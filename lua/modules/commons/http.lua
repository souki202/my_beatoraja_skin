local http = require("modules.commons.http_request")
local compat = require("modules.commons.compat")
require("modules.commons.url_encoder")

-- バージョン確認も通常更新から完了を受け取る。
function skinVersionCheckAsync(nowVersions, callback)
    local request = http.get("https://tori-blog.net/skin/version", 1000, 64 * 1024)
    request:runHttpRequest(function (success, lines, err)
        local isNews = {}
        if success and #lines > 0 then
            for i = 1, math.min(#lines, #nowVersions) do
                local now, latest = tonumber(nowVersions[i]), tonumber(lines[i])
                if not now or not latest then success = false break end
                isNews[i] = now < latest
            end
        else
            success = false
        end
        if not success then print("スキンのバージョンチェックに失敗しました: " .. tostring(err)) end
        callback(success, isNews)
    end)
    return request
end

local function parseMusicData(musicDataLines)
    if DEBUG == true then
        for key, value in ipairs(musicDataLines) do
            print(value)
        end
    end
    local result = {}

    local getInsertTargetTable = function (keyArray)
        local nowDict = result
        for i, key in ipairs(keyArray) do
            if i >= #keyArray then
                return nowDict
            end
            if isNumber(key) then
                key = tonumber(key)
            end
            -- 該当のキーがなければ作る
            if not table.in_key(nowDict, key) then
                nowDict[key] = {}
            end
            nowDict = nowDict[key]
        end
        return nowDict
    end

    for _, line in ipairs(musicDataLines) do
        local separatePos = string.find(line, " ")
        local key = string.sub(line, 1, separatePos - 1)
        local value = string.sub(line, separatePos + 1)
        local keyArray = string.split(key, ".")
        local t = getInsertTargetTable(keyArray)

        local k = keyArray[#keyArray]
        if isNumber(k) then k = tonumber(k) end
        t[k] = string.gsub(value, "(\\n)", "\n")
    end

    -- デバッグ出力
    if DEBUG == true then
        print(result)
        for key, value in pairs(result) do
            print(key, value)
        end
        -- print ("難易度表数: " .. #result.tables)
    end
    return result
end


-- 楽曲の解析とcallbackはJavaワーカーではなく通常更新中に行う。
function getMusicDataAsync(title, md5)
    local url = "https://bmsapi.tori-blog.net/?title=" .. URLEncoder.encode(title) .. "&format=lua&v=2"
    if md5 ~= nil and md5 ~= "" then url = url .. "&md5=" .. URLEncoder.encode(md5) end
    local request = http.get(url, 1000, 4 * 1024 * 1024)
    local run = request.runHttpRequest
    function request:runHttpRequest(callback)
        run(self, function (success, lines, err)
            if success then
                local ok, data = pcall(parseMusicData, lines)
                self.wasSuccess = ok
                self.data = ok and data or {}
                if ok then self.error = nil else self.error = data end
            end
            if callback then callback(self.wasSuccess, self.data, self.error) end
        end)
    end
    return request
end

-- 分割ファイルは1件ずつ取得する。全て揃うまで既存キャッシュには触れない。
local ESTIMATE_BASE_URL = "https://difficulty-estimates.s3.ap-northeast-1.amazonaws.com/"
local ESTIMATE_MANIFEST_PATH = "estimates/manifest.txt"
local ESTIMATE_TIMEOUT = 3000

function updateEstimateLuaAsync(savePath, callback)
    local job = {isConnecting = true, wasSuccess = false}
    local parts, out, index = nil, {"local estimates = {}"}, 0
    local function finish(success, err)
        if not job.isConnecting then return end
        job.isConnecting = false
        job.wasSuccess = success
        job.error = err
        job.request = nil
        if not success then print("難易度推定テーブルの更新に失敗しました: " .. tostring(err)) end
        local onComplete = callback
        callback = nil
        if onComplete then onComplete(success, err) end
    end
    local function fetch(relativePath, maxBytes, consume)
        job.request = http.get(ESTIMATE_BASE_URL .. relativePath, ESTIMATE_TIMEOUT, maxBytes)
        job.request:runHttpRequest(function (success, lines, err)
            if not success then finish(false, err) return end
            local ok, message = pcall(consume, lines)
            if not ok then finish(false, message) end
        end)
    end
    local function nextPart()
        index = index + 1
        local part = parts[index]
        if not part then
            out[#out + 1] = "return estimates"
            local text = table.concat(out, "\n")
            -- 不正な応答は保存前に検出する（実行はしない）。
            local chunk, err = load(text, "@estimates", "t")
            if not chunk then error(err) end
            local file, openError = compat.openFile(skin_config.get_path(savePath), "w")
            if not file then error(openError) end
            local written, writeError = file:write(text)
            local closed, closeError = file:close()
            if not written or not closed then error(writeError or closeError) end
            finish(true)
            return
        end
        fetch(part.path, 64 * 1024, function (lines)
            if #lines ~= part.count then error("難易度推定の行数が一致しません: " .. part.path) end
            for _, line in ipairs(lines) do out[#out + 1] = line end
            nextPart()
        end)
    end
    fetch(ESTIMATE_MANIFEST_PATH, 64 * 1024, function (lines)
        parts = {}
        for _, line in ipairs(lines) do
            local partPath, count = string.match(line, "^([%w_%-%./]+)%s+(%d+)%s*$")
            count = tonumber(count)
            if not partPath or string.find(partPath, "..", 1, true) or string.sub(partPath, 1, 1) == "/" or not count or count < 1 then
                error("難易度推定のmanifestが不正です")
            end
            parts[#parts + 1] = {path = partPath, count = count}
        end
        if #parts == 0 then error("難易度推定のmanifestが空です") end
        nextPart()
    end)
    function job:update()
        if self.isConnecting and self.request then self.request:update() end
    end
    function job:cancel()
        if self.request then self.request:cancel() end
        self.request = nil
        self.isConnecting = false
        callback = nil
    end
    return job
end
