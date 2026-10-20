local main_state = require("main_state")
local compat = require("modules.commons.compat")
local http = {}

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


-- 0.8.9cは本体のワーカー、0.8.8はJavaワーカーを使用する。
-- 新APIの拒否を同期HTTPやJava経由で迂回しない。
function http.get(url, timeout, maxBytes)
    local request = {isConnecting = false, wasSuccess = false, data = {}, started = false}
    local function complete(self, lines, err)
        self.isConnecting = false
        self.requestId = nil
        self.thread = nil
        if self.cancelled then return end
        self.wasSuccess = type(lines) == "table"
        self.data = self.wasSuccess and lines or {}
        self.error = err
        local callback = self.callback
        self.callback = nil
        if callback then callback(self.wasSuccess, self.data, self.error) end
    end

    function request:runHttpRequest(callback)
        if self.started or self.cancelled then return end
        self.started = true
        self.isConnecting = true
        self.callback = callback
        if main_state.http_get_async then
            if not main_state.http_poll or not main_state.http_cancel then
                self.startError = "非同期HTTP APIが揃っていません"
                return
            end
            local ok, id, err = pcall(main_state.http_get_async, url, timeout, maxBytes)
            if ok and id then self.requestId = id
            else self.startError = tostring(ok and err or id) end
        elseif not main_state.http_get_lines and not main_state.file_mkdir and compat.javaClass("java.lang.Thread") then
            local ok, err = pcall(function ()
                local j = compat.getJava()
                local proxy = j.createProxy("java.lang.Runnable", {run = function ()
                    local success, lines = pcall(httpGetLinesByLuajava, url, timeout, maxBytes)
                    if not self.cancelled then self.legacyResult = {success = success, lines = lines} end
                end})
                self.thread = j.newInstance("java.lang.Thread", proxy)
                self.thread:start()
            end)
            if not ok then self.startError = tostring(err) end
        else
            self.startError = "HTTP非同期通信にはbeatoraja 0.8.9cまたは0.8.8が必要です"
        end
    end

    -- 完了、開始失敗ともcallbackは通常のスキン更新中に一度だけ実行する。
    function request:update()
        if not self.isConnecting or self.cancelled then return end
        if self.startError then
            complete(self, nil, self.startError)
        elseif self.requestId then
            local ok, result = pcall(main_state.http_poll, self.requestId)
            if ok and type(result) == "table" and result.status == "pending" then return end
            if ok and type(result) == "table" and result.status == "completed" and type(result.lines) == "table" then
                complete(self, result.lines)
            else
                pcall(main_state.http_cancel, self.requestId)
                complete(self, nil, type(result) == "table" and result.error or tostring(result))
            end
        elseif self.thread then
            local ok, alive = pcall(function () return self.thread:isAlive() end)
            if ok and alive then return end
            local result = self.legacyResult
            self.legacyResult = nil
            complete(self, result and result.success and result.lines or nil,
                result and not result.success and result.lines or (not ok and tostring(alive) or nil))
        end
    end

    function request:cancel()
        if self.cancelled then return end
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

return http
