local luajava = require("luajava")
local File = luajava.bindClass("java.io.File")

local commons = require("modules.select.commons")
local background = {
    numOfFiles = 0,
    filelist = {},
    imageIdList = {},
    createId = function(srcId)
        return "background" .. srcId
    end,

    functions = {}
}

local BACKGROUND = {
    SRC_START_ID = 200,
    INTERVAL = 15000,
    FADE_TIME = 500,
}

background.functions.isEnableSlideshow = function ()
    return getTableValue(skin_config.option, "スライドショー", 960) ~= 960
end

background.functions.isRandom = function ()
    return getTableValue(skin_config.option, "スライドショー", 960) == 962
end

background.functions.isMovie = function ()
    return getTableValue(skin_config.option, "背景形式", 915) == 916
end

background.functions.load = function ()
    local skin = {
        source = {},
        image = {}
    }

    if background.functions.isEnableSlideshow() then
        local dir = luajava.new(File, skin_config.get_path("../select/background/slideshow/"))
        local filelists = dir:listFiles()
        local allowExtList = {"png", "jpg", "gif", "cim", "tga", "bmp", "mp4", "mov"}

        for i = 1, #filelists do
            -- 対象ファイル一覧を取得してsrcに入れる
            if filelists[i]:isFile() then
                local filename = filelists[i]:getName()
                -- 末尾3文字を拡張子とする
                local ext = string.sub(filename, string.len(filename) - 2)

                -- 対応拡張子ならスライドショーに登録
                if table.has_value(allowExtList, ext) then
                    local path = "../select/background/slideshow/" .. filename
                    local srcId = BACKGROUND.SRC_START_ID + background.numOfFiles
                    local imageId = background.createId(srcId)
                    myPrint(imageId, srcId, path)
                    table.insert(background.filelist, path)
                    table.insert(background.imageIdList, imageId)
                    table.insert(skin.source, {
                        id = srcId,
                        path = path
                    })
                    table.insert(skin.image, {
                        id = imageId, src = srcId, x = 0, y = 0, w = -1, h = -1
                    })

                    background.numOfFiles = background.numOfFiles + 1
                    myPrint("add slide: " .. path)
                end
            end
        end

        -- ここで順番をバラバラにする
        local list = background.imageIdList
        if background.functions.isRandom() then
            for i = #list, 2, -1 do
                local j = math.random(i)
                list[i], list[j] = list[j], list[i]
            end
        end
    else
        if not background.functions.isMovie() then
            myPrint("load png")
            table.insert(skin.image, {id = "background", src = 1, x = 0, y = 0, w = -1, h = -1})
        else
            myPrint("load mp4")
            table.insert(skin.image, {id = "background", src = 101, x = 0, y = 0, w = -1, h = -1})
        end
    end
    return skin
end

background.functions.dst = function ()
    return background.functions.dstWithAlpha(255)
end

background.functions.dstWithAlpha = function (alpha)
    alpha = math.max(0, math.min(alpha, 255))
    local skin = {destination = {}}

    if background.functions.isEnableSlideshow() then
        -- offsetで初期化
        local interval = getTableValue(skin_config.offset, "表示時間 (単位 秒 既定値15)", {x = 15}).x
        local fadetime = getTableValue(skin_config.offset, "フェード時間 (単位 100ms 既定値5)", {x = 5}).x
        if interval ~= 0 then BACKGROUND.INTERVAL = interval * 1000 end
        if fadetime ~= 0 then BACKGROUND.FADE_TIME = fadetime * 100 end
        myPrint("show time: " .. BACKGROUND.INTERVAL, "fade time: " .. BACKGROUND.FADE_TIME)
        -- スライドショーの設定
        local endTime = BACKGROUND.INTERVAL * #background.imageIdList

        local list = background.imageIdList
        for i = 1, #list do
            local appear = (i - 1) * BACKGROUND.INTERVAL - BACKGROUND.FADE_TIME
            local fadein = appear + BACKGROUND.FADE_TIME
            local fadeout = appear + BACKGROUND.INTERVAL
            local del = fadeout + BACKGROUND.FADE_TIME
            myPrint(list[i], appear, fadein, fadeout, del, endTime)
            if i ~= 1 then
                table.insert(skin.destination, {
                    id = list[i], filter = 1, dst = {
                        {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 0},
                        {time = appear, a = 0},
                        {time = fadein, a = alpha},
                        {time = fadeout},
                        {time = del, a = 0},
                        {time = endTime},
                    }
                })
            else -- 1枚目だけ, 最後の画像のfadeoutから出現開始している必要がある
                table.insert(skin.destination, {
                    id = list[i], filter = 1, dst = {
                        {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = alpha},
                        {time = fadein, a = alpha},
                        {time = fadeout},
                        {time = del, a = 0},
                        {time = endTime - BACKGROUND.FADE_TIME},
                        {time = endTime, a = alpha},
                    }
                })
            end
        end
    else
        table.insert(skin.destination, {
            id = "background", filter = 1,
            dst = {
                {x = 0, y = 0, w = WIDTH, h = HEIGHT, a = alpha}
            }
        })
    end

    return skin
end

return background.functions