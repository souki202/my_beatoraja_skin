require("modules.commons.define")
require("modules.result.commons")
local main_state = require("main_state")

local musicInfo = {
    functions = {}
}

local MUSIC_INFO = {
    AREA = {
        X = 0,
        Y = 0,
        W = WIDTH,
        H = 128,
    },
    TITLE = {
        X = function (self) return self.AREA.X + self.AREA.W / 4 end,
        Y = function (self) return self.AREA.Y + 2 end,
        W = WIDTH / 2 - 48,
        SIZE = 36
    },
    ARTIST = {
        X = function (self) return self.AREA.X + self.AREA.W * 3 / 4 end,
        Y = function (self) return self.AREA.Y + 2 end,
        W = WIDTH / 2 - 48,
        SIZE = 36
    },
}

musicInfo.functions.load = function ()
    return {
        image = {
            {id = "musicInfoBg", src = 1, x = 0, y = 0, w = -1, h = -1}
        },
        text = {
            {id = "musicTitleAndFolder", font = 0, size = MUSIC_INFO.TITLE.SIZE, overflow = 1, align = 1, constantText = main_state.text(12) .. "/" .. main_state.text(1003)},
            {id = "musicArtist", font = 0, size = MUSIC_INFO.ARTIST.SIZE, overflow = 1, align = 1, constantText = main_state.text(14) .. "/" .. main_state.text(15)},
        }
    }
end

musicInfo.functions.dst = function ()
    return {
        destination = {
            {
                id = "musicInfoBg", dst = {
                    {x = MUSIC_INFO.AREA.X, y = MUSIC_INFO.AREA.Y, w = MUSIC_INFO.AREA.W, h = MUSIC_INFO.AREA.H}
                }
            },
            {
                id = "musicTitleAndFolder", filter = 1, dst = {
                    {x = MUSIC_INFO.TITLE.X(MUSIC_INFO), y = MUSIC_INFO.TITLE.Y(MUSIC_INFO), w = MUSIC_INFO.TITLE.W, h = MUSIC_INFO.TITLE.SIZE}
                }
            },
            {
                id = "musicArtist", filter = 1, dst = {
                    {x = MUSIC_INFO.ARTIST.X(MUSIC_INFO), y = MUSIC_INFO.ARTIST.Y(MUSIC_INFO), w = MUSIC_INFO.ARTIST.W, h = MUSIC_INFO.ARTIST.SIZE}
                }
            }
        }
    }
end

return musicInfo.functions