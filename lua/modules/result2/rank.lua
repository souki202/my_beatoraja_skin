require("modules.result.commons")
require("modules.result2.commons")

local rank = {
    functions = {}
}

local RANK = {
    AREA = {
        X = 224,
        Y = 72,
        W = 512,
        H = 256,
    },
    BG = {
        ALPHA = 90,
    },
    TEXT = {
        X = function (self) return self.AREA.X + (self.AREA.W - self.TEXT.W) / 2 end,
        Y = function (self) return self.AREA.Y + (self.AREA.H - self.TEXT.H) / 2 end,
        W = 300, -- placeholder
        H = 200,
    }
}

rank.functions.load = function ()
    RANK.BG.ALPHA = getRankFrameBgAlpha()

    local skin = {
        image = {
            {id = "rankFrameEdge", src = 5, x = 0, y = 0, w = -1, h = -1},
            {id = "rankFrameDecoration", src = 6, x = 0, y = 0, w = -1, h = -1},
            {id = "rankFrameBg", src = 7, x = 0, y = 0, w = -1, h = -1},
            {id = "bokehBgRankFrameArea", src = getBokehBgSrc(), x = RANK.AREA.X, y = HEIGHT - RANK.AREA.Y - RANK.AREA.H, w = RANK.AREA.W, h = RANK.AREA.H}
        },
    }
    -- ランクの文字読み込み

    return skin
end

rank.functions.dst = function ()
    local skin = {
        destination = {
            {
                id = "bokehBgRankFrameArea", dst = {
                    {x = RANK.AREA.X, y = RANK.AREA.Y, w = RANK.AREA.W, h = RANK.AREA.H}
                }
            },
            {
                id = "rankFrameBg", dst = {
                    {x = RANK.AREA.X, y = RANK.AREA.Y, w = RANK.AREA.W, h = RANK.AREA.H, a = RANK.BG.ALPHA}
                }
            },
            {
                id = "rankFrameDecoration", dst = {
                    {x = RANK.AREA.X, y = RANK.AREA.Y, w = RANK.AREA.W, h = RANK.AREA.H}
                }
            },
            {
                id = "rankFrameEdge", dst = {
                    {x = RANK.AREA.X, y = RANK.AREA.Y, w = RANK.AREA.W, h = RANK.AREA.H}
                }
            }
        }
    }

    -- 文字の出力

    return skin
end

return rank.functions