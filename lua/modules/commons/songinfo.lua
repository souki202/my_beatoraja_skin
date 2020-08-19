require("modules.commons.define")
local main_state = require("main_state")
local commons = require("modules.play.commons")

local songInfo = {
    functions = {},
    data = {
        aspectW = 1,
        aspectH = 1,
    }
}

local SONG_INFO = {
    DIR_PATH = "../userdata/song/"
}

songInfo.functions.loadChartInfo = function (fullTitle, totalNotes)
    local fp = io.open(skin_config.get_path(SONG_INFO.DIR_PATH) .. fullTitle .. totalNotes, "r")
    if fp == nil then
        return 1
    end
end

songInfo.functions.getSongFilePath = function (title)
    return skin_config.get_path(SONG_INFO.DIR_PATH) .. title
end

songInfo.functions.loadSongInfo = function (title)
    local fp = io.open(songInfo.functions.getSongFilePath(title), "r")
    if fp == nil then
        return 1
    end

    local cnt = 0
    local data = songInfo.data
    for line in fp:lines() do
        if cnt == 0 then
            local splited = split(line, " ")
            if #splited >= 2 then
                data.aspectW = math.max(1, tonumber(splited[1]))
                data.aspectH = math.max(1, tonumber(splited[2]))
                myPrint("aspect raito: " .. data.aspectW .. ":" .. data.aspectH)
            end
        end

        cnt = cnt + 1
    end
    fp.close()
    return 0
end

songInfo.functions.saveSongInfo = function (title)
    local fp = io.open(songInfo.functions.getSongFilePath(title), "w")
    if fp == nil then
        print("SocialSkin: 曲の設定情報の保存に失敗しました.")
        return 1
    end

    local data = songInfo.data
    local str = ""
    str = str .. data.aspectW .. " " .. data.aspectH .. "\n"
    fp.write(str)
    fp.close()

    return 0
end

songInfo.functions.getSongInfo = function ()
    return songInfo.data
end

return songInfo.functions