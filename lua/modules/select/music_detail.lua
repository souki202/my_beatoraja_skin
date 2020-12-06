require("modules.commons.http")
local timer_util = require("timer_util")
local main_state = require("main_state")

-- キャッシュファイル読み込みエラー対策でpcallできるようにする
local function cacheRequire()
    require("cache.music_data")
end
local wasSuccessLoadCache, _ = pcall(cacheRequire)

local MUSIC_DETAIL = {
    GET_WAIT_TIME = 1000,
    CACHE_PATH = "cache/music_data.lua",
    VAR_NAME = "MUSIC_DATA_CACHE",
}

local musicDetail = {
    getMusicDataObj = nil,
    musicData = nil,
    tablesString = "",
    wasDrawed = false,
    lastGetDataTitle = "",
    functions = {}
}

musicDetail.functions.getHttpTimer = function ()
    return 10700
end

musicDetail.functions.clearViewData = function ()
    musicDetail.musicData = nil
    musicDetail.getMusicDataObj = nil
    musicDetail.tablesString = ""
    musicDetail.wasDrawed = false
end

musicDetail.functions.getMusicDetail = function ()
    if MUSIC_DATA_CACHE == nil then
        return
    end

    if not main_state.option(2) then
        musicDetail.functions.clearViewData()
        return 0
    end

    -- cacheがヒットしたらそれをとって終了
    local title = main_state.text(10)
    if MUSIC_DATA_CACHE[title] ~= nil then
        if musicDetail.lastGetDataTitle ~= title then
            print("キャッシュがヒット: " .. title)
            musicDetail.musicData = MUSIC_DATA_CACHE[title]
            musicDetail.tablesString = ""
            for _, value in pairs(musicDetail.musicData.tables) do
                if musicDetail.tablesString == "" then
                    -- musicDetail.tablesString = value.detail.name
                    musicDetail.tablesString = value.comment
                else
                    -- musicDetail.tablesString = musicDetail.tablesString .. "\n" .. value.detail.name
                    musicDetail.tablesString = musicDetail.tablesString .. "\n" .. value.comment
                end
            end
            musicDetail.wasDrawed = true
            musicDetail.lastGetDataTitle = title
        end
        return
    end

    -- キャッシュがなければ通信して取得する
    local nowTime = (main_state.time() - main_state.timer(11)) / 1000

    -- 楽曲情報を表示開始までは消す
    if nowTime <= MUSIC_DETAIL.GET_WAIT_TIME then
        musicDetail.functions.clearViewData()
        return 0
    end

    if musicDetail.getMusicDataObj == nil and nowTime > MUSIC_DETAIL.GET_WAIT_TIME then
        -- 取得用オブジェクトが無ければ取得する
        musicDetail.getMusicDataObj = getMusicDataAsync(title)
        musicDetail.getMusicDataObj:runHttpRequest(function (isSuccess, data)
            if not isSuccess then
                return
            end

            myPrint("テーブル情報更新")
            musicDetail.musicData = data
            musicDetail.tablesString = ""
            for _, value in pairs(musicDetail.musicData.tables) do
                if musicDetail.tablesString == "" then
                    -- musicDetail.tablesString = value.detail.name
                    musicDetail.tablesString = value.comment
                else
                    -- musicDetail.tablesString = musicDetail.tablesString .. "\n" .. value.detail.name
                    musicDetail.tablesString = musicDetail.tablesString .. "\n" .. value.comment
                end
            end
            musicDetail.wasDrawed = true
            musicDetail.functions.addCache(data, title)
            musicDetail.lastGetDataTitle = title
        end)
    end
end

musicDetail.functions.clearCache = function ()
    print("キャッシュクリア実行")
    local f = io.open(skin_config.get_path(MUSIC_DETAIL.CACHE_PATH), "w")
    if f == nil then
        print("キャッシュファイルクリアでのファイルオープンに失敗しました")
    end
    f:write("MUSIC_DATA_CACHE = {}\n")
    f:close()
end

musicDetail.functions.createCacheString = function (data, parentKey)
    local str = ""
    if not data then
        return ""
    end
    if type(data) == "table" then
        str = "{"
        if parentKey == "level_order" or parentKey == "folder_order" or parentKey == "tables" then
            for key, value in ipairs(data) do
                str = str .. musicDetail.functions.createCacheString(value, key) .. ","
            end
        else
            for key, value in pairs(data) do
                str = str .. key .. "=" .. musicDetail.functions.createCacheString(value, key) .. ","
            end
        end
        str = str .. "}"
        return str
    else
        -- luaでエラーが出ないように, ダブルクオーテーションと改行はエスケープする
        return '"' .. musicDetail.functions.escapeForLuaValue(data) .. '"'
    end
end

musicDetail.functions.escapeForLuaValue = function (str)
    return string.gsub(tostring(str), '["\n]', function (c)
        if c == '"' then return '\\"'
        elseif c == "\n" then return "\\n"
        else return c
        end
    end)
end

musicDetail.functions.addCache = function (data, localTitle)
    print()
    local f = io.open(skin_config.get_path(MUSIC_DETAIL.CACHE_PATH), "a")
    if f == nil then
        print("キャッシュファイルのオープンに失敗しました")
    end
    io.output(f)
    local cache = musicDetail.functions.createCacheString(data, "")
    io.write(MUSIC_DETAIL.VAR_NAME .. '["' .. musicDetail.functions.escapeForLuaValue(data.title) .. '"]=' .. cache .. "\n")
    print("add cache: " .. cache)
    io.close(f)
    MUSIC_DATA_CACHE[localTitle] = data
end

musicDetail.functions.load = function ()
    if not wasSuccessLoadCache or MUSIC_DATA_CACHE == nil then
        print("キャッシュ読み込み失敗 キャッシュクリア実行")
        musicDetail.functions.clearCache()
        cacheRequire()
    end
    return {
        text = {
            {id = "tableString" , font = 0, size = 48, align = 0, overflow = 1, value = function () return musicDetail.tablesString end},
        }
    }
end

musicDetail.functions.dst = function ()
    return {
        destination = {
            {id = "white", dst = {
                {x = 0, y = 0, w = 800, h = 1400}
            }},
            {id = "tableString", dst = {
                {x = 100, y = 900, w = 1000, h = 48, r = 0, g = 0, b = 0}
            }}
        }
    }
end

return musicDetail.functions
