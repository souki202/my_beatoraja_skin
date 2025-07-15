local luajava = require("luajava")
require("modules.commons.url_encoder")

local function httpConnection(url)
    local lines = {}
    local url2 = luajava.newInstance("java.net.URL", url);
    local urlConn = url2:openConnection()
    urlConn:setRequestMethod("GET")
    urlConn:setConnectTimeout(200) -- バージョンチェックは失敗しても良いので, タイムアウトが早くても問題ない
    if pcall(function() urlConn:connect() end) then
        local status = urlConn:getResponseCode()
        if status == 200 then
            local reader = luajava.newInstance("java.io.BufferedReader", luajava.newInstance("java.io.InputStreamReader", urlConn:getInputStream(), "utf8"))
            -- 1行ごとに配列へ
            local hasLine = true
            while hasLine do
                local line = reader:readLine()
                if line then
                    table.insert(lines, line)
                else
                    hasLine = false
                end
            end
        else
            print("HTTPステータスが正常ではありません: " .. status)
        end
    else
        print("connectに失敗しました")
        return
    end
    return lines
end

-- 各スキンのバージョンを確認する
-- @param  {array} versions 現在のバージョンの文字列の配列 手前から, セレクト, リザルト, decide, プレイ, リザルト2
-- @return {boolean} 新しいバージョンがあるかの配列. それぞれのindexは上に対応しているか, nil 取得に失敗すれば空の配列
function skinVersionCheck(nowVersions)
    local err, v = pcall(httpConnection, "https://media.tori-blog.net/uploads/skin/version")
    local isNews = {}
    if v and #v > 0 then
        local n = math.min(#v, #nowVersions)
        for i = 1, n do
            -- nilの場合は新しいバージョンが無いとする
            if v[i] == nil then
                isNews[i] = false
                break
            else
                isNews[i] = tonumber(nowVersions[i]) < tonumber(v[i])
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
    @param {function(bool, array)} callback 取得完了時のcallback関数 成功時は第一引数にtrueが入る. 第二引数は取得したデータ
]]
function getMusicDataAsync(title)
    local url = "https://bmsapi.tori-blog.net/?title=" .. URLEncoder.encode(title) .. "&format=lua&v=2"
    return {
        isConnecting = false,
        wasSuccess = false,
        data = {},

        runHttpRequest = function (self, callback)
            -- 前回の接続が終わっていなければ終了
            if self.isConnecting == true then
                return
            end
            self.isConnecting = true
            local runnable = {
                run = function ()
                    print("楽曲情報取得開始: " .. title)
                    print("url: " .. url)
                    self.wasSuccess = false
                    local url2 = luajava.newInstance("java.net.URL", url);
                    local urlConn = url2:openConnection()
                    urlConn:setRequestMethod("GET")
                    urlConn:setConnectTimeout(1000)
                    if pcall(function() urlConn:connect() end) then
                        local status = urlConn:getResponseCode()
                        if status == 200 then
                            print("楽曲情報接続完了: " .. title)
                            local reader = luajava.newInstance("java.io.BufferedReader", luajava.newInstance("java.io.InputStreamReader", urlConn:getInputStream(), "utf8"))
                            local lines = {}
                            -- 1行ごとに配列へ
                            local hasLine = true
                            while hasLine do
                                local line = reader:readLine()
                                if line then
                                    lines[#lines+1] = line
                                else
                                    hasLine = false
                                end
                            end
                            -- parseする
                            self.wasSuccess, self.data = pcall(parseMusicData, lines)
                            print("楽曲情報取得完了")
                        else
                            print("HTTPステータスが正常ではありません: " .. status)
                        end
                    else
                        print("connectに失敗しました")
                    end
                    self.isConnecting = false
                    callback(self.wasSuccess, self.data)
                end
            }
            local runnableProxy = luajava.createProxy("java.lang.Runnable", runnable)
            local t = luajava.newInstance("java.lang.Thread", runnableProxy)
            t:start()
        end,
    }
end

--[[
    難易度推定表luaファイルを取得して配置する (同期実行)
    必ずpcallに囲んで呼ぶこと
]]
function updateEstimateLua(savePath)
    local url = "https://difficulty-estimates.s3.ap-northeast-1.amazonaws.com/estimates.lua"

    print("難易度推定取得開始")
    print("url: " .. url)
    local url2 = luajava.newInstance("java.net.URL", url);
    local urlConn = url2:openConnection()
    urlConn:setRequestMethod("GET")
    urlConn:setConnectTimeout(1000)
    if pcall(function() urlConn:connect() end) then
        local status = urlConn:getResponseCode()
        if status == 200 then
            print("難易度推定取得完了")
            -- 全部読み込む
            local reader = luajava.newInstance("java.io.BufferedReader", luajava.newInstance("java.io.InputStreamReader", urlConn:getInputStream(), "utf8"))
            local str = ""
            -- 1行ごとに配列へ
            local hasLine = true
            while hasLine do
                local line = reader:readLine()
                if line then
                    str = str .. line
                else
                    hasLine = false
                end
            end
            -- luaファイルに出力
            local f = io.open(skin_config.get_path(savePath), "w")
            f:write(str)
            f:close()
        end
    end

end
