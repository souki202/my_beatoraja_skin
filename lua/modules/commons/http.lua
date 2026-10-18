local main_state = require("main_state")
local compat = require("modules.commons.compat")
require("modules.commons.url_encoder")

-- beatoraja 0.8.8以前(およびluajavaが使える派生)向け: luajavaでHTTP GETする
local function httpGetLinesByLuajava(url, timeout, maxBytes)
    local luajava = require("luajava")
    local urlConn = luajava.newInstance("java.net.URL", url):openConnection()
    urlConn:setRequestMethod("GET")
    urlConn:setConnectTimeout(timeout)
    urlConn:setReadTimeout(timeout)
    if maxBytes and compat.hasMethod(urlConn, "setResponseLimitBytes") then
        urlConn:setResponseLimitBytes(maxBytes)
    end
    local reader
    local ok, result = pcall(function ()
        urlConn:connect()
        local status = urlConn:getResponseCode()
        if status < 200 or status >= 300 then error("HTTPステータスが正常ではありません: " .. status) end
        reader = luajava.newInstance("java.io.BufferedReader", luajava.newInstance("java.io.InputStreamReader", urlConn:getInputStream(), "utf8"))
        local lines, bytes = {}, 0
        while true do
            local line = reader:readLine()
            if not line then break end
            bytes = bytes + #line + 1
            if maxBytes and bytes > maxBytes then error("HTTP応答の容量上限を超えました") end
            lines[#lines + 1] = line
        end
        return lines
    end)
    if reader then pcall(function () reader:close() end) end
    pcall(function () urlConn:disconnect() end)
    if not ok then error(result) end
    return result
end

-- 初期0.8.9は1024行/65536文字、拡張版はバイト容量指定。第3引数は初期版では無視される。
-- 0.8.8以前はJavaの同期GETを使用する。
local function httpGetLines(url, timeout, maxBytes)
    local ok, lines, err
    if main_state.http_get_lines then
        ok, lines, err = pcall(main_state.http_get_lines, url, timeout, maxBytes)
    else
        ok, lines = pcall(httpGetLinesByLuajava, url, timeout, maxBytes)
    end
    if not ok then
        print("HTTP通信に失敗しました: " .. tostring(lines))
        return nil
    end
    if lines == nil then
        print("HTTP通信に失敗しました: " .. tostring(err))
        return nil
    end
    return lines
end

local function httpConnection(url)
    -- バージョンチェックは失敗しても良いので, タイムアウトが早くても問題ない
    return httpGetLines(url, 200)
end

-- 各スキンのバージョンを確認する
-- @param  {array} versions 現在のバージョンの文字列の配列 手前から, セレクト, リザルト, decide, プレイ, リザルト2
-- @return {boolean} 新しいバージョンがあるかの配列. それぞれのindexは上に対応しているか, nil 取得に失敗すれば空の配列
function skinVersionCheck(nowVersions)
    local err, v = pcall(httpConnection, "https://tori-blog.net/skin/version")
    local isNews = {}
    if v and #v > 0 then
        local n = math.min(#v, #nowVersions)
        for i = 1, n do
            -- nilの場合は新しいバージョンが無いとする
            if v[i] == nil then
                isNews[i] = false
                break
            else
                local now, latest = tonumber(nowVersions[i]), tonumber(v[i])
                isNews[i] = now ~= nil and latest ~= nil and now < latest
            end
        end
    else
        print("スキンのバージョンチェックに失敗しました")
    end

    return isNews
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

--[[
    楽曲情報をHTTPで取得する

    @param {string} title 楽曲名
    @param {string} md5 譜面のMD5
    @param {function(bool, array)} callback 取得完了時のcallback関数 成功時は第一引数にtrueが入る. 第二引数は取得したデータ
]]
function getMusicDataAsync(title, md5)
    local url = "https://bmsapi.tori-blog.net/?title=" .. URLEncoder.encode(title) .. "&format=lua&v=2"
    if md5 ~= nil and md5 ~= "" then
        url = url .. "&md5=" .. URLEncoder.encode(md5)
    end
    local request = {
        isConnecting = false,
        wasSuccess = false,
        data = {},
        started = false,
    }
    local maxBytes = 4 * 1024 * 1024
    local function complete(self, lines, err)
        self.isConnecting = false
        self.requestId = nil
        self.thread = nil
        if self.cancelled then return end
        self.error = err
        if lines then
            local ok, data = pcall(parseMusicData, lines)
            self.wasSuccess = ok
            if ok then self.data = data else self.error = data end
        end
        local callback = self.callback
        self.callback = nil
        if callback then callback(self.wasSuccess, self.data) end
    end

    function request:runHttpRequest(callback)
        if self.started then return end
        self.started = true
        self.isConnecting = true
        self.callback = callback
        print("楽曲情報取得開始: " .. title)
        if main_state.http_get_async and main_state.http_poll and main_state.http_cancel then
            local ok, id, err = pcall(main_state.http_get_async, url, 1000, maxBytes)
            if ok and id then self.requestId = id
            else complete(self, nil, ok and err or id) end
        elseif not main_state.http_get_lines and compat.javaClass("java.lang.Thread") then
            -- 旧版だけでJavaワーカーを使う。解析・callbackはupdate()側で実行する。
            local ok, err = pcall(function ()
                local j = compat.getJava()
                local proxy = j.createProxy("java.lang.Runnable", {run = function ()
                    local success, lines = pcall(httpGetLinesByLuajava, url, 1000, maxBytes)
                    self.legacyResult = {success = success, lines = lines}
                end})
                self.thread = j.newInstance("java.lang.Thread", proxy)
                self.thread:start()
            end)
            if not ok then complete(self, nil, err) end
        else
            -- 非同期APIを持たない初期0.8.9向け。
            complete(self, httpGetLines(url, 1000, maxBytes))
        end
    end

    function request:update()
        if not self.isConnecting or self.cancelled then return end
        if self.requestId then
            local ok, result = pcall(main_state.http_poll, self.requestId)
            if ok and result and result.status == "pending" then return end
            if ok and result and result.status == "completed" and type(result.lines) == "table" then
                complete(self, result.lines)
            else
                pcall(main_state.http_cancel, self.requestId)
                complete(self, nil, ok and result and result.error or result)
            end
        elseif self.thread then
            local ok, alive = pcall(function () return self.thread:isAlive() end)
            if ok and alive then return end
            local result = self.legacyResult
            self.legacyResult = nil
            complete(self, result and result.success and result.lines or nil,
                result and not result.success and result.lines or nil)
        end
    end

    function request:cancel()
        self.cancelled = true
        if self.requestId then pcall(main_state.http_cancel, self.requestId) end
        if self.thread then pcall(function () self.thread:interrupt() end) end
        self.requestId = nil
        self.thread = nil
        self.callback = nil
        self.isConnecting = false
        self.wasSuccess = false
        self.legacyResult = nil
        self.data = {}
    end
    return request
end

--[[
    難易度推定表luaファイルを取得して配置する (同期実行)
    必ずpcallに囲んで呼ぶこと

    初期0.8.9の容量制限にも対応するため、全バージョンで小さい分割ファイルを取得する。
    manifestに従って順に取得し, 1つのluaファイルに結合して保存する
    manifestの各行は "<ファイルパス> <行数>" の形式
]]
local ESTIMATE_BASE_URL = "https://difficulty-estimates.s3.ap-northeast-1.amazonaws.com/"
local ESTIMATE_MANIFEST_PATH = "estimates/manifest.txt"
local ESTIMATE_TIMEOUT = 3000

function updateEstimateLua(savePath)
    print("難易度推定取得開始")
    local manifest = httpGetLines(ESTIMATE_BASE_URL .. ESTIMATE_MANIFEST_PATH, ESTIMATE_TIMEOUT)
    if not manifest then
        error("難易度推定のmanifestの取得に失敗しました")
    end

    local parts = {}
    for _, line in ipairs(manifest) do
        local path, count = string.match(line, "^([%w_%-%./]+)%s+(%d+)%s*$")
        if not path or string.find(path, "..", 1, true) or string.sub(path, 1, 1) == "/" or tonumber(count) < 1 then
            error("難易度推定のmanifestが不正です")
        end
        parts[#parts + 1] = {path = path, count = tonumber(count)}
    end
    if #parts == 0 then
        error("難易度推定のmanifestが不正です")
    end

    -- 全て取得できた場合のみ保存する
    local out = {"local estimates = {}"}
    for i, part in ipairs(parts) do
        local lines = httpGetLines(ESTIMATE_BASE_URL .. part.path, ESTIMATE_TIMEOUT)
        if not lines then
            error("難易度推定の取得に失敗しました: " .. part.path)
        end
        -- 上限超過で行が切り捨てられた場合などを検出する
        if #lines ~= part.count then
            error("難易度推定の行数が一致しません: " .. part.path .. " " .. #lines .. "/" .. part.count)
        end
        for _, l in ipairs(lines) do
            out[#out + 1] = l
        end
    end
    out[#out + 1] = "return estimates"

    local f, err = compat.openFile(skin_config.get_path(savePath), "w")
    if not f then error("難易度推定を保存できません: " .. tostring(err)) end
    f:write(table.concat(out, "\n"))
    f:close()
    print("難易度推定取得完了: " .. (#out - 2) .. "件")
end
