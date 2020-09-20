require("modules.result.commons")
require("modules.result2.commons")
local main_state = require("main_state")
local largeLamp = require("modules.result2.large_lamp")

local rank = {
    functions = {}
}


local RANK = {
    LIST = {"Aaa", "Aa", "A", "B", "C", "D", "E", "F", "F"},

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
        W = 512, -- placeholder
        H = 256,
        DIV_Y = 128,
        PER_H = function (self) return self.TEXT.H / self.TEXT.DIV_Y end,
    },
    ANIMATION = {
        TEXT_APPEAR_START = largeLamp.getAnimationEndTime(),
        TEXT_PARTS_APPEAR_TIME = largeLamp.getAnimationEndTime() + 100,
        TEXT_ANIM_END_TIME = largeLamp.getAnimationEndTime() + 800,
    }
}

rank.functions.getRankIdx = function ()
    local m = main_state.number(74) * 2
    if m == 0 then return 0 end
    local s = main_state.number(71)
    local p = s / m
    local numOfRank = 27
    local rankDetailedIdx = {0}
    for i = 1, numOfRank do
        rankDetailedIdx[i + 1] = p >= 1.0 * i / numOfRank
    end

    myPrint("TN: " .. (m / 2), "score: " .. s, "rate: " .. p)

    local values = {0, 6, 9, 12, 15, 18, 21, 24, 28}
    for i = 1, #values do
        if rankDetailedIdx[values[i] + 1] and (i > 27 and true or (not rankDetailedIdx[values[i + 1] + 1])) then
            myPrint("ランク: " .. (values[i] / numOfRank) .. " 以上 " .. (values[i + 1] / numOfRank) .. " 以下", (#values - i))
            if i == #values then return 1 end
            return #values - i
        end
    end
end

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
    local imgs = skin.image

    -- ランクの文字読み込み
    -- for i = 1, #RANK.LIST do
    do
        local i = rank.functions.getRankIdx()
        -- 大量にimgに突っ込むわけには行かないので, 今回のランクの分だけ読む
        myPrint("rank読み込み: " .. RANK.LIST[i], i)
        -- if main_state.option(300 + (i - 1)) then
            local perH = RANK.TEXT.PER_H(RANK)
            for j = 1, RANK.TEXT.DIV_Y do
                local y = RANK.TEXT.H * i + perH * (j - 1)
                imgs[#imgs+1] = {
                    id = "rankTextPart" .. j, src = 8, x = 0, y = y, w = RANK.TEXT.W, h = perH
                }
                imgs[#imgs+1] = {
                    id = "rankTextBrightPart" .. j, src = 8, x = RANK.TEXT.W, y = y, w = RANK.TEXT.W, h = perH
                }
            end
        -- end
    end
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
        }
    }
    local dst = skin.destination

    -- 文字の出力
    do
        local dt = (RANK.ANIMATION.TEXT_ANIM_END_TIME - RANK.ANIMATION.TEXT_PARTS_APPEAR_TIME) / RANK.TEXT.DIV_Y
        local perH = RANK.TEXT.PER_H(RANK)
        local eachTextAnimTime = RANK.ANIMATION.TEXT_PARTS_APPEAR_TIME - RANK.ANIMATION.TEXT_APPEAR_START
        for i = 1, RANK.TEXT.DIV_Y do
            local imgIdx = RANK.TEXT.DIV_Y - (i - 1)
            dst[#dst+1] = {
                id = "rankTextPart" .. imgIdx, loop = dt * (i - 1) + RANK.ANIMATION.TEXT_APPEAR_START + eachTextAnimTime, dst = {
                    {time = 0, x = RANK.TEXT.X(RANK), y = RANK.TEXT.Y(RANK) + perH * (i - 1), w = RANK.TEXT.W, h = perH, a = 0, acc = 1},
                    {time = dt * (i - 1) + RANK.ANIMATION.TEXT_APPEAR_START + eachTextAnimTime / 2},
                    {time = dt * (i - 1) + RANK.ANIMATION.TEXT_APPEAR_START + eachTextAnimTime, a = 255}
                }
            }
        end
        -- 光る方を上に
        for i = 1, RANK.TEXT.DIV_Y do
            local imgIdx = RANK.TEXT.DIV_Y - (i - 1)
            dst[#dst+1] = {
                id = "rankTextBrightPart" .. imgIdx, loop = -1, dst = {
                    {time = 0, x = RANK.TEXT.X(RANK), y = RANK.TEXT.Y(RANK) + perH * (i - 1), w = RANK.TEXT.W, h = perH, a = 0, acc = 1},
                    {time = dt * (i - 1) + RANK.ANIMATION.TEXT_APPEAR_START},
                    {time = dt * (i - 1) + RANK.ANIMATION.TEXT_APPEAR_START + eachTextAnimTime / 2, a = 255},
                    {time = dt * (i - 1) + RANK.ANIMATION.TEXT_APPEAR_START + eachTextAnimTime, a = 0}
                }
            }
        end
    end

    -- フレームの出力
    mergeSkin(skin, {
        destination = {
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
    })

    return skin
end

return rank.functions