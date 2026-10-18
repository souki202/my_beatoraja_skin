local main_state = require("main_state")
require("modules.commons.url_encoder")

-- beatoraja 0.8.9以降はluajavaが使えないため, main_state.http_get_linesを使用する
-- 制約: GETのみ, タイムアウト最大5000ms, 最大1024行・65536文字, 同期実行(スレッド不可)
local function httpGetLines(url, timeout)
    local ok, lines, err = pcall(main_state.http_get_lines, url, timeout)
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
    return {
        isConnecting = false,
        wasSuccess = false,
        data = {},

        -- 0.8.9以降はスレッドを作れないため同期実行となる (タイムアウトまで描画が止まる)
        runHttpRequest = function (self, callback)
            -- 前回の接続が終わっていなければ終了
            if self.isConnecting == true then
                return
            end
            self.isConnecting = true
            print("楽曲情報取得開始: " .. title)
            print("url: " .. url)
            self.wasSuccess = false
            local lines = httpGetLines(url, 1000)
            if lines then
                print("楽曲情報接続完了: " .. title)
                -- parseする
                self.wasSuccess, self.data = pcall(parseMusicData, lines)
                print("楽曲情報取得完了")
            end
            self.isConnecting = false
            callback(self.wasSuccess, self.data)
        end,
    }
end

--[[
    難易度推定表luaファイルを取得して配置する (同期実行)
    必ずpcallに囲んで呼ぶこと
]]
function updateEstimateLua(savePath)
    -- beatoraja 0.8.9のHTTP API(main_state.http_get_lines)は最大1024行・65536文字までしか取得できず,
    -- 推定表(約500KB)は取得できないため自動更新は行わない.
    -- 手動で https://difficulty-estimates.s3.ap-northeast-1.amazonaws.com/estimates.lua を
    -- lua/cache/estimates.lua に配置すれば利用できる
    error("難易度推定表の自動更新はbeatoraja 0.8.9以降では利用できません: " .. tostring(savePath))
end
