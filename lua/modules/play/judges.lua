require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local judges = {
    functions = {}
}

local JUDGES = {
    APPEAR_TIME = 75,
    DRAW_TIME = 1000,
    X = function() return lanes.getAreaX() + 136 end, -- 後で初期化
    Y = function() return lanes.getAreaY() + 132 end,
    W = 160,
    INIT_MUL_SIZE = 0.75,
    H = 31,

    IDS = {"Perfect", "Great", "Good", "Bad", "Poor", "Miss"},
    ID_PREFIX = "judge",

    TIMING = {
        TEXT = {
            X = function(self) return self.X() + self.W / 2 - self.TIMING.TEXT.W / 2 end,
            Y = function(self) return self.Y() + 35 end,
            W = 56,
            H = 16,
        },
        NUM = {
            X = function(self) return self.X() + self.W / 2 - self.TIMING.NUM.W * self.TIMING.NUM.DIGIT / 2 end,
            Y = function(self) return self.Y() + 35 end,
            W = 12,
            H = 15,
            DIGIT = 3,
        }
    },
}

local COMBO = {
    LEFT = {
        X = function(self) return JUDGES.W * 1.25 + JUDGES.W * JUDGES.INIT_MUL_SIZE / 2 end,
        Y = -19 + JUDGES.H * JUDGES.INIT_MUL_SIZE / 2,
    },
    BOTTOM = {
        X = function(self) return self.W * self.DIGIT / 2 + JUDGES.W * JUDGES.INIT_MUL_SIZE / 2 end,
        Y = -60 + JUDGES.H * JUDGES.INIT_MUL_SIZE / 2,
    },
    OUTER = {
        X_1 = function(self) return 376 + self.W / 4 + JUDGES.W * JUDGES.INIT_MUL_SIZE / 2 end,
        X_2 = function(self) return -138 - 78 + self.W / 4 + JUDGES.W * JUDGES.INIT_MUL_SIZE / 2 end,
        Y = 350 + JUDGES.H * JUDGES.INIT_MUL_SIZE / 2,
    },
    TEXT = {
        X_1 = 542,
        X_2 = WIDTH - 542 - 92,
        Y = 900,
        W = 92,
        H = 23,
    },
    W = 29,
    H = 38,
    DIGIT = 6,
    DRAW_TIME = 1000,
}

judges.functions.load = function ()
    local skin = {
        image = {
            {id = "comboText", src = 0, x = 360, y = 0, w = COMBO.TEXT.W, h = COMBO.TEXT.H},
            {id = "earlyText", src = 0, x = 453, y = 0, w = JUDGES.TIMING.TEXT.W, h = JUDGES.TIMING.TEXT.H},
            {id = "lateText", src = 0, x = 453, y = JUDGES.TIMING.TEXT.H, w = JUDGES.TIMING.TEXT.W, h = JUDGES.TIMING.TEXT.H},
        },
        value = {
            {id = "nowCombo", src = 6, x = 0, y = 0, w = COMBO.W * 10, h = COMBO.H, divx = 10, digit = COMBO.DIGIT, ref = 75, align = (isDrawComboNextToTheJudge() and 0 or 2)},
            {id = "judgeTimeError", src = 0, x = 1904, y = 46, w = JUDGES.TIMING.NUM.W * 12, h = JUDGES.TIMING.NUM.H * 2, divx = 12, divy = 2, digit = JUDGES.TIMING.NUM.DIGIT, align = 2, ref = 525},
        },
        judge = {
            {
                id = "judges",
                index = 0,
                images = {},
                numbers = {},
                shift = isDrawComboNextToTheJudge()
            }
        }
    }
    local imgs = skin.image

    -- 判定読み込み
    for i = 1, #JUDGES.IDS do
        imgs[#imgs+1] = {id = JUDGES.ID_PREFIX .. JUDGES.IDS[i], src = 5, x = 0, y = JUDGES.H * (i - 1), w = JUDGES.W, h = JUDGES.H}
    end

    -- 判定出力を入れる
    do
        local judgeImgs = skin.judge[1].images
        for i = 1, #JUDGES.IDS do
            judgeImgs[#judgeImgs+1] = {
                id = JUDGES.ID_PREFIX .. JUDGES.IDS[i], loop = -1, timer = 46, offsets = {3, 32}, dst = {
                    {time = 0, x = JUDGES.X() + JUDGES.W * (1 - JUDGES.INIT_MUL_SIZE) / 2, y = JUDGES.Y() + JUDGES.H * (1 - JUDGES.INIT_MUL_SIZE) / 2, w = JUDGES.W * JUDGES.INIT_MUL_SIZE, h = JUDGES.H * JUDGES.INIT_MUL_SIZE},
                    {time = JUDGES.APPEAR_TIME, x = JUDGES.X(), y = JUDGES.Y(), w = JUDGES.W, h = JUDGES.H},
                    {time = JUDGES.DRAW_TIME}
                }
            }
        end
    end

    -- 判定数を入れる
    do
        local judgeNums = skin.judge[1].numbers
        local x = 0
        local y = 0
        local x2 = 0
        local y2 = 0
        -- このよくわからない調整はbeatorajaのシステム側都合でせざるを得なかった
        -- 調整しても桁によってブレるので, 意図的にアニメーションさせてごまかし
        if isDrawComboNextToTheJudge() then
            x = COMBO.LEFT.X(COMBO)
            y = COMBO.LEFT.Y
            x2 = x - COMBO.W / 4 - JUDGES.W * JUDGES.INIT_MUL_SIZE / 2
            y2 = y + COMBO.H / 3 + 2 - JUDGES.H * JUDGES.INIT_MUL_SIZE / 2
        elseif isDrawComboBottom() then
            x = COMBO.BOTTOM.X(COMBO)
            y = COMBO.BOTTOM.Y
            x2 = x - COMBO.W / 4 - JUDGES.W * JUDGES.INIT_MUL_SIZE / 2
            y2 = y + COMBO.H / 3 + 2 - JUDGES.H * JUDGES.INIT_MUL_SIZE / 2
        elseif isDrawComboOuterLane() then
            x = is1P() and COMBO.OUTER.X_1(COMBO) or COMBO.OUTER.X_2(COMBO)
            y = COMBO.OUTER.Y
            x2 = x - COMBO.W / 4 - JUDGES.W * JUDGES.INIT_MUL_SIZE / 2
            y2 = y + COMBO.H / 3 + 3 - JUDGES.H * JUDGES.INIT_MUL_SIZE / 2
        end
        for i = 1, #JUDGES.IDS do
            judgeNums[#judgeNums+1] = {
                id = "nowCombo", loop = -1, offsets = {3, 32}, timer = 46, dst = {
                    {time = 0, x = x - COMBO.W * 3, y = y + COMBO.H * (1 - JUDGES.INIT_MUL_SIZE) * 0.75, w = COMBO.W * JUDGES.INIT_MUL_SIZE, h = COMBO.H * JUDGES.INIT_MUL_SIZE},
                    {time = JUDGES.APPEAR_TIME, x = x2, y = y2, w = COMBO.W, h = COMBO.H},
                    {time = COMBO.DRAW_TIME}
                }
            }
        end
    end
    return skin
end

judges.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    -- レーンの外に出すものは, comboの文字も出す
    if isDrawComboOuterLane() then
        if isDrawComboOuterLane() then
            dst[#dst+1] = {
                id = "comboText", loop = -1, timer = 46, dst = {
                    {time = 0, x = is1P() and COMBO.TEXT.X_1 or COMBO.TEXT.X_2, y = COMBO.TEXT.Y, w = COMBO.TEXT.W, h = COMBO.TEXT.H},
                    {time = COMBO.DRAW_TIME}
                }
            }
        end
    end
    dst[#dst+1] = {id = "judges"}

    -- early late
    if isDrawEarlyLate() then
        dst[#dst+1] = {
            id = "earlyText", offsets = {3, 32}, timer = 46, loop = -1, op = {1242}, dst = {
                {time = 0, x = JUDGES.TIMING.TEXT.X(JUDGES), y = JUDGES.TIMING.TEXT.Y(JUDGES), w = JUDGES.TIMING.TEXT.W, h = JUDGES.TIMING.TEXT.H},
                {time = JUDGES.DRAW_TIME}
            }
        }
        dst[#dst+1] = {
            id = "lateText", offsets = {3, 32}, timer = 46, loop = -1, op = {1243}, dst = {
                {time = 0, x = JUDGES.TIMING.TEXT.X(JUDGES), y = JUDGES.TIMING.TEXT.Y(JUDGES), w = JUDGES.TIMING.TEXT.W, h = JUDGES.TIMING.TEXT.H},
                {time = JUDGES.DRAW_TIME}
            }
        }
    elseif isDrawErrorJudgeTimeExcludePg() then
        -- +-ms
        dst[#dst+1] = {
            id = "judgeTimeError", offsets = {3, 32}, timer = 46, loop = -1, op = {-241}, dst = {
                {time = 0, x = JUDGES.TIMING.NUM.X(JUDGES), y = JUDGES.TIMING.NUM.Y(JUDGES), w = JUDGES.TIMING.NUM.W, h = JUDGES.TIMING.NUM.H},
                {time = JUDGES.DRAW_TIME}
            }
        }
    elseif isDrawErrorJudgeTimeIncludetPg() then
        dst[#dst+1] = {
            id = "judgeTimeError", offsets = {3, 32}, timer = 46, loop = -1, dst = {
                {time = 0, x = JUDGES.TIMING.NUM.X(JUDGES), y = JUDGES.TIMING.NUM.Y(JUDGES), w = JUDGES.TIMING.NUM.W, h = JUDGES.TIMING.NUM.H},
                {time = JUDGES.DRAW_TIME}
            }
        }
    end
    return skin
end

return judges.functions