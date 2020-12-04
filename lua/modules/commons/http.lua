local luajava = require("luajava")
local json = require("modules.commons.json")
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
    local err, v = pcall(httpConnection, "https://tori-blog.net/wp-content/uploads/skin/version")
    local isNews = {}
    if v then
        local n = math.min(#v, #nowVersions)
        for i = 1, n do
            isNews[i] = tonumber(nowVersions[i]) < tonumber(v[i])
        end
    else
        print("スキンのバージョンチェックに失敗しました")
    end

    return isNews
end

local function parseMusicData(musicDataLines)
    local result = {}

    local getInsertTargetTable = function (keyArray)
        local nowDict = result
        for i, key in ipairs(keyArray) do
            if i >= #keyArray then
                return nowDict
            end
            -- 該当のキーがなければ作る
            if not table.in_key(nowDict, key) then
                nowDict[key] = {}
            end
            nowDict = nowDict[key]
        end
    end

    for _, line in ipairs(musicDataLines) do
        local separatePos = string.find(line, " ")
        local key = string.sub(line, 1, separatePos - 1)
        local value = string.sub(line, separatePos + 1)
        local keyArray = string.split(key, ".")
        local t = getInsertTargetTable(keyArray)
        t[keyArray[#keyArray]] = value
    end

    -- デバッグ出力
    if DEBUG == true then
        print(result)
        for key, value in pairs(result) do
            print(key, value)
        end
    end
    return result
end

function getMusicDataAsync(title)
    local url = "https://bmsapi.tori-blog.net/?title=" .. URLEncoder.encode(title) .. "&format=lua"
    return {
        isConnecting = false,
        data = {},

        runHttpRequest = function (self)
            -- 前回の接続が終わっていなければ終了
            if self.isConnecting == true then
                return
            end
            self.isConnecting = true
            local runnable = {
                run = function ()
                    print("楽曲情報取得開始: " .. title)
                    print("url: " .. url)
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
                            self.data = parseMusicData(lines)

                            -- parseする

                            print("楽曲情報取得完了: ")
                        else
                            print("HTTPステータスが正常ではありません: " .. status)
                        end
                    else
                        print("connectに失敗しました")
                    end
                    self.isConnecting = false
                end
            }
            local runnableProxy = luajava.createProxy("java.lang.Runnable", runnable)
            local t = luajava.newInstance("java.lang.Thread", runnableProxy)
            t:start()
        end,
    }
end