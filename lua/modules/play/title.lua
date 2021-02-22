require("modules.commons.define")
local main_state = require("main_state")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")

local title = {
    functions = {}
}

local TITLE = {
    WND = {
        X = 0,
        Y = 231,
        W = 1411,
        H = 134,
    },
    TEXT = {
        X = function (self) return self.WND.X + self.WND.W / 2 end,
        Y = function (self) return self.WND.Y + 65 end,
        W = 800,
        SIZE = 34,
    },
    ANIMATION = {
        EACH_VIEW_TIME = 3000,
        FADE_TIME = 300,
    }
}

title.functions.load = function ()
    if is1P() then
        TITLE.WND.X = lanes.getAreaX() + lanes.getAreaW() + 2
    end
    if isBgaOnLeft() or isFullScreenBga() then
        TITLE.WND.Y = -10
    end

    local artistText = main_state.text(14)
    if main_state.text(15) ~= "" then
        artistText = artistText .. "/" .. main_state.text(15)
    end
    return {
        image = {
            {id = "titleFrame", src = 70, x = 0, y = 0, w = -1, h = -1}
        },
        text = {
            {id = "titleText", font = 0, size = TITLE.TEXT.SIZE, ref = 12, align = 1, overflow = 1},
            {id = "artistText", font = 0, size = TITLE.TEXT.SIZE, constantText = artistText, align = 1, overflow = 1},
            {id = "genreText", font = 0, size = TITLE.TEXT.SIZE, ref = 13, align = 1, overflow = 1},
            {id = "folderText", font = 0, size = TITLE.TEXT.SIZE, ref = 1003, align = 1, overflow = 1},
        },
    }
end

title.functions.dst = function ()
    -- 詳細表示時はコレを表示しない
    if getIsDrawMusicDetail() then
        return {}
    end
    local skin = {
        destination = {
            {
                id = "titleFrame", dst = {
                    {x = TITLE.WND.X, y = TITLE.WND.Y, w = TITLE.WND.W, h = TITLE.WND.H}
                }
            },
        }
    }
    local dst = skin.destination
    local ids = {"title", "artist", "genre", "folder"}
    do
        local f = TITLE.ANIMATION.FADE_TIME
        local v = TITLE.ANIMATION.EACH_VIEW_TIME
        local eachTotalTime = (v + f * 2)
        local totalTime = eachTotalTime * #ids + 1
        for i = 1, #ids do
            local s = eachTotalTime * (i - 1) + 1
            dst[#dst+1] = {
                id = ids[i] .. "Text", filter = 1, dst = {
                    {time = 0, x = TITLE.TEXT.X(TITLE), y = TITLE.TEXT.Y(TITLE), w = TITLE.TEXT.W, h = TITLE.TEXT.SIZE, a = 0},
                    {time = s, a = 0},
                    {time = s + f, a = 255},
                    {time = s + v + f},
                    {time = s + v + f * 2, a = 0},
                    {time = totalTime, a = 0},
                }
            }
        end
    end
    return skin
end

return title.functions