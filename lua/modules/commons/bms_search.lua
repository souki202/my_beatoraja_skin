local http = require("modules.commons.http_request")
local compat = require("modules.commons.compat")
local json = require("modules.commons.json")
local search = {}
local BASE = "https://api.bmssearch.net/v1/"
local CACHE_DIR = "cache/bmssearch/"
local TTL = 7 * 24 * 60 * 60
local MAX_BYTES = 60 * 1024
local memory, failures = {}, {}

local function validId(id)
    return type(id) == "string" and #id > 0 and #id <= 128 and id:match("^[%w_-]+$") ~= nil
end
local function validate(data, kind)
    if type(data) ~= "table" then return nil end
    -- HTTP 200でもエラーオブジェクトや別形式はキャッシュしない。
    if kind == "patterns" then
        if type(data.file) ~= "table" or type(data.file.hashSha256) ~= "string" then return nil end
    elseif kind == "neighbors" then
        for index, neighbor in pairs(data) do
            if type(index) ~= "number" or index < 1 or index % 1 ~= 0
                or type(neighbor) ~= "table" or type(neighbor.pattern) ~= "table"
                or type(neighbor.confidence) ~= "number" then return nil end
        end
    elseif not validId(data.id) then return nil end
    return data
end
local function decode(body, kind)
    if kind == "neighbors" and not body:match("^%s*%[") then return nil end
    local ok, data = pcall(json.decode, body)
    if ok then return validate(data, kind) end
end
local function cachePath(key)
    return skin_config.get_path(CACHE_DIR .. key .. ".json")
end
local function readCache(key, kind)
    local now = os.time()
    local entry = memory[key]
    if entry and now >= entry.time and now - entry.time < TTL then return entry.data end
    memory[key] = nil
    local file = compat.openFile(cachePath(key), "r")
    if not file then return nil end
    local body = file:read(MAX_BYTES + 129)
    file:close()
    if not body or #body > MAX_BYTES + 128 then return nil end
    local ok, cached = pcall(json.decode, body)
    if not ok or type(cached) ~= "table" then return nil end
    local stamp = cached.cachedAt
    if type(stamp) ~= "number" or now < stamp or now - stamp >= TTL then return nil end
    local data = validate(cached.data, kind)
    if data then memory[key] = {time = stamp, data = data} end
    return data
end
local function saveCache(key, data, body)
    local now = math.floor(os.time())
    memory[key] = {time = now, data = data}
    local file = compat.openFile(cachePath(key), "w")
    if not file then return end -- 書き込み不可でも取得済み情報は表示する。
    -- LuaJのtostringは大きな数値を丸めるため、秒単位の整数を明示する。
    file:write('{"cachedAt":' .. string.format("%.0f", now) .. ',"data":' .. body .. "}")
    file:close()
end

-- 各段階の応答全体を個別保存。同じBMSの別譜面や同じイベントでも共有する。
function search.get(sha256)
    local job = {isConnecting = false, data = {name = "", url = ""}}
    local pending, callback
    local function finish(success, err)
        job.isConnecting = false
        job.wasSuccess = success
        job.error = err
        pending = nil
        local done = callback
        callback = nil
        if done then done(success, job.data, err) end
    end
    local function fetch(kind, id, consume)
        local key = kind .. "_" .. id
        local data = readCache(key, kind)
        if data then consume(data) return end
        if failures[key] and os.time() - failures[key] < 60 then finish(false, "BMS Search retry cooldown") return end
        local route
        if kind == "patterns" or kind == "neighbors" then
            route = "patterns/sha256/" .. id .. (kind == "neighbors" and "/neighbors" or "")
        else
            route = kind .. "/" .. id
        end
        pending = http.get(BASE .. route, 3000, MAX_BYTES)
        pending:runHttpRequest(function (success, lines, err)
            if job.cancelled then return end
            local body = success and table.concat(lines, "\n") or ""
            local result = success and #body <= MAX_BYTES and decode(body, kind) or nil
            if not result or (kind ~= "patterns" and kind ~= "neighbors" and result.id ~= id)
                or (kind == "patterns" and result.file.hashSha256:lower() ~= id) then
                failures[key] = os.time()
                finish(false, err or "Invalid BMS Search response")
                return
            end
            saveCache(key, result, body)
            pending = nil
            consume(result)
        end)
    end
    local function fetchBms(bmsId)
        fetch("bmses", bmsId, function (bms)
            local exhibition = bms.exhibition
            if type(exhibition) ~= "table" then finish(true) return end
            -- 公開仕様はobject。配列形式の応答にも対応する。
            exhibition = exhibition[1] or exhibition
            if type(exhibition) ~= "table" then finish(true) return end
            job.data.name = type(exhibition.name) == "string" and exhibition.name or ""
            if not validId(exhibition.id) then finish(true) return end
            fetch("exhibitions", exhibition.id, function (event)
                if type(event.name) == "string" then job.data.name = event.name end
                local profile = event.linkedProfile
                local websites = type(profile) == "table" and profile.websites
                local website = type(websites) == "table" and websites[1]
                local url = type(website) == "table" and website.url
                if type(url) == "string" and url:match("^https?://[^%s]+$") then
                    job.data.url = url
                end
                finish(true)
            end)
        end)
    end
    function job:runHttpRequest(onComplete)
        if self.started or self.cancelled then return end
        self.started = true
        self.isConnecting = true
        callback = onComplete
        if type(sha256) ~= "string" or #sha256 ~= 64 or not sha256:match("^%x+$") then finish(false, "Invalid SHA256") return end
        sha256 = sha256:lower()
        fetch("patterns", sha256, function (data)
            if type(data.bms) == "table" and validId(data.bms.id) then
                fetchBms(data.bms.id)
                return
            end
            fetch("neighbors", sha256, function (neighbors)
                -- 最大confidenceの候補内で、有効な親BMS紐づけを優先する。
                -- 同率かつ紐づけありの候補が複数ならAPI順の先頭を維持する。
                local highest, bmsId
                for _, neighbor in ipairs(neighbors) do
                    if highest == nil or neighbor.confidence > highest then
                        highest = neighbor.confidence
                        bmsId = nil
                    end
                    if neighbor.confidence == highest and not bmsId then
                        local bms = neighbor.pattern.bms
                        if type(bms) == "table" and validId(bms.id) then bmsId = bms.id end
                    end
                end
                if not bmsId then finish(true) return end
                fetchBms(bmsId)
            end)
        end)
    end
    function job:update()
        if self.isConnecting and pending then pending:update() end
    end
    function job:cancel()
        self.cancelled = true
        self.isConnecting = false
        if pending then pending:cancel() end
        pending, callback = nil, nil
    end
    return job
end

return search
