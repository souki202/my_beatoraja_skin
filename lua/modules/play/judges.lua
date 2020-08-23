require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local judges = {
    baseBpm = 0,
    slowBorderBpm = 0,

    functions = {}
}

local inited = false

local JUDGES = {
    APPEAR_TIME = 75,
    DRAW_TIME = 1000,
    X = function() return lanes.getAreaX() + 136 end, -- 後で初期化
    Y = function() return lanes.getAreaNormalY() + 260 end,
    W = 160,
    INIT_MUL_SIZE = 0.75,
    H = 31,

    IDS = {"Perfect", "Great", "Good", "Bad", "Poor", "Miss"},
    ID_PREFIX = "judge",

    TIMING = {
        TEXT = {
            X_1 = function (self) return self.X() + self.W / 2 - self.TIMING.TEXT.W / 2 end,
            X_2 = function (self) return self.X() + self.W / 4 - self.TIMING.TEXT.W / 2 end,
            TOP_Y = function (self) return self.Y() + 35 end,
            BOTTOM_Y1 = function (self) return self.Y() - 24 end,
            BOTTOM_Y2 = function (self) return self.Y() - 70 end,
            W = 56,
            H = 16,
        },
        NUM = {
            X_1 = function (self) return self.X() + self.W / 2 - self.TIMING.NUM.W * self.TIMING.NUM.DIGIT / 2 end,
            X_2 = function (self) return self.X() + self.W / 4 - self.TIMING.NUM.W * self.TIMING.NUM.DIGIT / 2 end,
            Y = function (self) return self.Y() + 35 end,
            W = 15,
            H = 20,
            DIGIT = 3,
        }
    },
    SCORE = {
        DIFF = {
            X_1 = function (self) return self.X() + self.W / 2 - self.SCORE.DIFF.W * self.SCORE.DIFF.DIGIT / 2 end,
            X_2 = function (self) return self.X() + self.W / 4 * 3 - self.SCORE.DIFF.W * self.SCORE.DIFF.DIGIT / 2 end,
            SIDE_X_1 = function (self) return lanes.getAreaX() + lanes.getAreaW() + 8 end,
            SIDE_X_2 = function (self) return lanes.getAreaX() - 8 - self.SCORE.DIFF.W * self.SCORE.DIFF.DIGIT end,
            Y = function (self) return self.Y() + 35 end,
            W = 15,
            H = 20,
            DIGIT = 5,
        }
    }
}

local COMBO = {
    LEFT = {
        X = function (self) return JUDGES.W * 1.25 + JUDGES.W * JUDGES.INIT_MUL_SIZE / 2 end,
        Y = -19 + JUDGES.H * JUDGES.INIT_MUL_SIZE / 2,
    },
    BOTTOM = {
        X = function (self) return self.W * self.DIGIT / 2 + JUDGES.W * JUDGES.INIT_MUL_SIZE / 2 end,
        Y = -60 + JUDGES.H * JUDGES.INIT_MUL_SIZE / 2,
    },
    OUTER = {
        X_1 = function (self) return 376 + self.W / 4 + JUDGES.W * JUDGES.INIT_MUL_SIZE / 2 end,
        X_2 = function (self) return -138 - 78 + self.W / 4 + JUDGES.W * JUDGES.INIT_MUL_SIZE / 2 end,
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
            {id = "earlyText", src = 0, x = 452, y = 0, w = JUDGES.TIMING.TEXT.W, h = JUDGES.TIMING.TEXT.H},
            {id = "lateText", src = 0, x = 452, y = JUDGES.TIMING.TEXT.H, w = JUDGES.TIMING.TEXT.W, h = JUDGES.TIMING.TEXT.H},
        },
        value = {
            {id = "nowCombo", src = 6, x = 0, y = 0, w = COMBO.W * 10, h = COMBO.H, divx = 10, digit = COMBO.DIGIT, ref = 75, align = (isDrawComboNextToTheJudge() and 0 or 2)},
            {id = "judgeTimeError", src = 0, x = 1868, y = 197, w = JUDGES.TIMING.NUM.W * 12, h = JUDGES.TIMING.NUM.H * 2, divx = 12, divy = 2, digit = JUDGES.TIMING.NUM.DIGIT, align = 2, ref = 525},
            {id = "bestDiffValue", src = 0, x = 1868, y = 197, w = JUDGES.TIMING.NUM.W * 12, h = JUDGES.TIMING.NUM.H * 2, divx = 12, divy = 2, digit = JUDGES.SCORE.DIFF.DIGIT, ref = 152, align = drawDiffUpperJudge() and 2 or 1},
            {id = "targetDiffValue", src = 0, x = 1868, y = 197, w = JUDGES.TIMING.NUM.W * 12, h = JUDGES.TIMING.NUM.H * 2, divx = 12, divy = 2, digit = JUDGES.SCORE.DIFF.DIGIT, ref = 153, align = drawDiffUpperJudge() and 2 or 1},
        },
        judge = {
            {
                id = "judges",
                index = 0,
                images = {},
                numbers = {},
                shift = isDrawComboNextToTheJudge()
            },
            {
                id = "judgesPerfect",
                index = 0,
                images = {},
                numbers = {},
                shift = isDrawComboNextToTheJudge()
            },
            {
                id = "judgesEarly",
                index = 0,
                images = {},
                numbers = {},
                shift = isDrawComboNextToTheJudge()
            },
            {
                id = "judgesLate",
                index = 0,
                images = {},
                numbers = {},
                shift = isDrawComboNextToTheJudge()
            },
        }
    }
    local imgs = skin.image

    -- 判定読み込み
    for i = 1, #JUDGES.IDS do
        imgs[#imgs+1] = {id = JUDGES.ID_PREFIX .. JUDGES.IDS[i], src = 5, x = 0, y = JUDGES.H * (i - 1), w = JUDGES.W, h = JUDGES.H}
        if isEarlyLateJudgeImage() then
            imgs[#imgs+1] = {id = JUDGES.ID_PREFIX .. JUDGES.IDS[i] .. "Early", src = 28, x = 0, y = JUDGES.H * (i - 1), w = JUDGES.W, h = JUDGES.H}
            imgs[#imgs+1] = {id = JUDGES.ID_PREFIX .. JUDGES.IDS[i] .. "Late", src = 29, x = 0, y = JUDGES.H * (i - 1), w = JUDGES.W, h = JUDGES.H}
        end
    end

    -- 判定出力を入れる
    do
        local judgeImgs = skin.judge[1].images
        local pfImgs = skin.judge[2].images
        local earlyImgs = skin.judge[3].images
        local lateImgs = skin.judge[4].images
        for i = 1, #JUDGES.IDS do
            judgeImgs[#judgeImgs+1] = {
                id = JUDGES.ID_PREFIX .. JUDGES.IDS[i], loop = -1, timer = 46, offsets = {3, 32}, dst = {
                    {time = 0, x = JUDGES.X() + JUDGES.W * (1 - JUDGES.INIT_MUL_SIZE) / 2, y = JUDGES.Y() + JUDGES.H * (1 - JUDGES.INIT_MUL_SIZE) / 2, w = JUDGES.W * JUDGES.INIT_MUL_SIZE, h = JUDGES.H * JUDGES.INIT_MUL_SIZE},
                    {time = JUDGES.APPEAR_TIME, x = JUDGES.X(), y = JUDGES.Y(), w = JUDGES.W, h = JUDGES.H},
                    {time = JUDGES.DRAW_TIME}
                }
            }
            if isEarlyLateJudgeImage() then
                pfImgs[#pfImgs+1] = {
                    id = JUDGES.ID_PREFIX .. JUDGES.IDS[i], loop = -1, timer = 46, offsets = {3, 32}, op = {241}, dst = {
                        {time = 0, x = JUDGES.X() + JUDGES.W * (1 - JUDGES.INIT_MUL_SIZE) / 2, y = JUDGES.Y() + JUDGES.H * (1 - JUDGES.INIT_MUL_SIZE) / 2, w = JUDGES.W * JUDGES.INIT_MUL_SIZE, h = JUDGES.H * JUDGES.INIT_MUL_SIZE},
                        {time = JUDGES.APPEAR_TIME, x = JUDGES.X(), y = JUDGES.Y(), w = JUDGES.W, h = JUDGES.H},
                        {time = JUDGES.DRAW_TIME}
                    }
                }
                earlyImgs[#earlyImgs+1] = {
                    id = JUDGES.ID_PREFIX .. JUDGES.IDS[i] .. "Early", loop = -1, timer = 46, offsets = {3, 32}, op = {1242}, dst = {
                        {time = 0, x = JUDGES.X() + JUDGES.W * (1 - JUDGES.INIT_MUL_SIZE) / 2, y = JUDGES.Y() + JUDGES.H * (1 - JUDGES.INIT_MUL_SIZE) / 2, w = JUDGES.W * JUDGES.INIT_MUL_SIZE, h = JUDGES.H * JUDGES.INIT_MUL_SIZE},
                        {time = JUDGES.APPEAR_TIME, x = JUDGES.X(), y = JUDGES.Y(), w = JUDGES.W, h = JUDGES.H},
                        {time = JUDGES.DRAW_TIME}
                    }
                }
                lateImgs[#lateImgs+1] = {
                    id = JUDGES.ID_PREFIX .. JUDGES.IDS[i] .. "Late", loop = -1, timer = 46, offsets = {3, 32}, op = {1243}, dst = {
                        {time = 0, x = JUDGES.X() + JUDGES.W * (1 - JUDGES.INIT_MUL_SIZE) / 2, y = JUDGES.Y() + JUDGES.H * (1 - JUDGES.INIT_MUL_SIZE) / 2, w = JUDGES.W * JUDGES.INIT_MUL_SIZE, h = JUDGES.H * JUDGES.INIT_MUL_SIZE},
                        {time = JUDGES.APPEAR_TIME, x = JUDGES.X(), y = JUDGES.Y(), w = JUDGES.W, h = JUDGES.H},
                        {time = JUDGES.DRAW_TIME}
                    }
                }
            end
        end
    end

    -- 判定数を入れる
    do
        local judgeNums = skin.judge[1].numbers
        local judgeNumsPf = skin.judge[2].numbers
        local judgeNumsEarly = skin.judge[3].numbers
        local judgeNumsLate = skin.judge[4].numbers
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
            if isEarlyLateJudgeImage() then
                judgeNumsPf[#judgeNumsPf+1] = {
                    id = "nowCombo", loop = -1, offsets = {3, 32}, timer = 46, op = {241}, dst = {
                        {time = 0, x = x - COMBO.W * 3, y = y + COMBO.H * (1 - JUDGES.INIT_MUL_SIZE) * 0.75, w = COMBO.W * JUDGES.INIT_MUL_SIZE, h = COMBO.H * JUDGES.INIT_MUL_SIZE},
                        {time = JUDGES.APPEAR_TIME, x = x2, y = y2, w = COMBO.W, h = COMBO.H},
                        {time = COMBO.DRAW_TIME}
                    }
                }
                judgeNumsEarly[#judgeNumsEarly+1] = {
                    id = "nowCombo", loop = -1, offsets = {3, 32}, timer = 46, op = {1242}, dst = {
                        {time = 0, x = x - COMBO.W * 3, y = y + COMBO.H * (1 - JUDGES.INIT_MUL_SIZE) * 0.75, w = COMBO.W * JUDGES.INIT_MUL_SIZE, h = COMBO.H * JUDGES.INIT_MUL_SIZE},
                        {time = JUDGES.APPEAR_TIME, x = x2, y = y2, w = COMBO.W, h = COMBO.H},
                        {time = COMBO.DRAW_TIME}
                    }
                }
                judgeNumsLate[#judgeNumsLate+1] = {
                    id = "nowCombo", loop = -1, offsets = {3, 32}, timer = 46, op = {1243}, dst = {
                        {time = 0, x = x - COMBO.W * 3, y = y + COMBO.H * (1 - JUDGES.INIT_MUL_SIZE) * 0.75, w = COMBO.W * JUDGES.INIT_MUL_SIZE, h = COMBO.H * JUDGES.INIT_MUL_SIZE},
                        {time = JUDGES.APPEAR_TIME, x = x2, y = y2, w = COMBO.W, h = COMBO.H},
                        {time = COMBO.DRAW_TIME}
                    }
                }
            end
        end
    end

    -- 低速等の判定基準用BPMを取得
    skin.customTimers = {
        {
            id = 10101, timer = function ()
                -- 2フレーム目以降でないとNOW_BPMを取得できない? 0フレーム目はヌルポ, 1フレーム目は0BPM, 2フレーム目で正常
                -- 念の為1秒待つ設定で
                if inited == false and getElapsedTime() / 1000 > 1000 then
                    if isBaseBpmTypeStartBpm() then
                        judges.baseBpm = main_state.number(160)
                    elseif isBaseBpmTypeMainBpm() then
                        judges.baseBpm = main_state.number(92)
                    end

                    myPrint("低速判定基準用BPM: " .. judges.baseBpm)

                    local calcType = slowBpmCalcType()
                    myPrint(calcType)
                    if calcType == 1 then
                        judges.slowBorderBpm = judges.baseBpm * 4 / 5
                    elseif calcType == 2 then
                        judges.slowBorderBpm = judges.baseBpm * 3 / 4
                    elseif calcType == 3 then
                        judges.slowBorderBpm = judges.baseBpm * 2 / 3
                    elseif calcType == 4 then
                        judges.slowBorderBpm = judges.baseBpm * 1 / 2
                    else
                        judges.slowBorderBpm = 0
                    end
                    myPrint("低速とするBPM: " .. judges.slowBorderBpm)
                    inited = true
                    return main_state.timer_off_value
                end
                return getElapsedTime()
            end
        }
    }
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
    if isEarlyLateJudgeImage() then
        dst[#dst+1] = {id = "judgesEarly"}
        dst[#dst+1] = {id = "judgesLate"}
        dst[#dst+1] = {id = "judgesPerfect"}
    else
        dst[#dst+1] = {id = "judges"}
    end

    do
        local elBottomY = JUDGES.TIMING.TEXT.BOTTOM_Y1(JUDGES)
        if isDrawComboBottom() then
            elBottomY = JUDGES.TIMING.TEXT.BOTTOM_Y2(JUDGES)
        end
        -- early late
        if isDrawEarlyLate() then
            local x = JUDGES.TIMING.TEXT.X_1(JUDGES)
            if drawDiffUpperJudge() then
                x = JUDGES.TIMING.TEXT.X_2(JUDGES)
            end
            -- 早いときのel
            dst[#dst+1] = {
                id = "earlyText", offsets = {3, 32}, timer = 46, loop = -1, draw = function ()
                    return main_state.option(1242) and main_state.number(160) > judges.slowBorderBpm
                end, dst = {
                    {time = 0, x = x, y = JUDGES.TIMING.TEXT.TOP_Y(JUDGES), w = JUDGES.TIMING.TEXT.W, h = JUDGES.TIMING.TEXT.H},
                    {time = JUDGES.DRAW_TIME}
                }
            }
            dst[#dst+1] = {
                id = "lateText", offsets = {3, 32}, timer = 46, loop = -1, draw = function ()
                    return main_state.option(1243) and main_state.number(160) > judges.slowBorderBpm
                end, dst = {
                    {time = 0, x = x, y = JUDGES.TIMING.TEXT.TOP_Y(JUDGES), w = JUDGES.TIMING.TEXT.W, h = JUDGES.TIMING.TEXT.H},
                    {time = JUDGES.DRAW_TIME}
                }
            }
            -- 遅いときのel
            dst[#dst+1] = {
                id = "earlyText", offsets = {3, 32}, timer = 46, loop = -1, draw = function ()
                    return main_state.option(1242) and main_state.number(160) <= judges.slowBorderBpm
                end, dst = {
                    {time = 0, x = x, y = elBottomY, w = JUDGES.TIMING.TEXT.W, h = JUDGES.TIMING.TEXT.H},
                    {time = JUDGES.DRAW_TIME}
                }
            }
            dst[#dst+1] = {
                id = "lateText", offsets = {3, 32}, timer = 46, loop = -1, draw = function ()
                    return main_state.option(1243) and main_state.number(160) <= judges.slowBorderBpm
                end, dst = {
                    {time = 0, x = x, y = elBottomY, w = JUDGES.TIMING.TEXT.W, h = JUDGES.TIMING.TEXT.H},
                    {time = JUDGES.DRAW_TIME}
                }
            }
        elseif isDrawErrorJudgeTimeExcludePg() then
            local x = JUDGES.TIMING.NUM.X_1(JUDGES)
            if drawDiffUpperJudge() then
                x = JUDGES.TIMING.NUM.X_2(JUDGES)
            end
            -- +-ms
            dst[#dst+1] = {
                id = "judgeTimeError", offsets = {3, 32}, timer = 46, loop = -1, draw = function ()
                    return main_state.option(241) == false and main_state.number(160) > judges.slowBorderBpm
                end, dst = {
                    {time = 0, x = x, y = JUDGES.TIMING.NUM.Y(JUDGES), w = JUDGES.TIMING.NUM.W, h = JUDGES.TIMING.NUM.H},
                    {time = JUDGES.DRAW_TIME}
                }
            }
            dst[#dst+1] = {
                id = "judgeTimeError", offsets = {3, 32}, timer = 46, loop = -1, draw = function ()
                    return main_state.option(241) == false and main_state.number(160) <= judges.slowBorderBpm
                end, dst = {
                    {time = 0, x = x, y = elBottomY, w = JUDGES.TIMING.NUM.W, h = JUDGES.TIMING.NUM.H},
                    {time = JUDGES.DRAW_TIME}
                }
            }
        elseif isDrawErrorJudgeTimeIncludetPg() then
            local x = JUDGES.TIMING.NUM.X_1(JUDGES)
            if drawDiffUpperJudge() then
                x = JUDGES.TIMING.NUM.X_2(JUDGES)
            end
            dst[#dst+1] = {
                id = "judgeTimeError", offsets = {3, 32}, timer = 46, loop = -1, draw = function ()
                    return main_state.number(160) > judges.slowBorderBpm
                end, dst = {
                    {time = 0, x = x, y = JUDGES.TIMING.NUM.Y(JUDGES), w = JUDGES.TIMING.NUM.W, h = JUDGES.TIMING.NUM.H},
                    {time = JUDGES.DRAW_TIME}
                }
            }
            dst[#dst+1] = {
                id = "judgeTimeError", offsets = {3, 32}, timer = 46, loop = -1, draw = function ()
                    return main_state.number(160) <= judges.slowBorderBpm
                end, dst = {
                    {time = 0, x = x, y = elBottomY, w = JUDGES.TIMING.NUM.W, h = JUDGES.TIMING.NUM.H},
                    {time = JUDGES.DRAW_TIME}
                }
            }
        end
    end

    -- スコア差表示
    if drawDiffUpperJudge() then
        local x = JUDGES.SCORE.DIFF.X_1(JUDGES)
        if isDrawEarlyLate() or isDrawErrorJudgeTimeExcludePg() or isDrawErrorJudgeTimeIncludetPg() then
            x = JUDGES.SCORE.DIFF.X_2(JUDGES)
        end
        local id = "bestDiffValue"
        if drawDiffTargetScore() then
            id = "targetDiffValue"
        end
        dst[#dst+1] = {
            id = id, timer = 46, loop = -1, dst = {
                {time = 0, x = x, y = JUDGES.SCORE.DIFF.Y(JUDGES), w = JUDGES.SCORE.DIFF.W, h = JUDGES.SCORE.DIFF.H},
                {time = JUDGES.DRAW_TIME}
            }
        }
    elseif drawDiffLaneSide() then
        local x = JUDGES.SCORE.DIFF.SIDE_X_1(JUDGES)
        if not is1P() then
            x =  JUDGES.SCORE.DIFF.SIDE_X_2(JUDGES)
        end
        local id = "bestDiffValue"
        if drawDiffTargetScore() then
            id = "targetDiffValue"
        end
        dst[#dst+1] = {
            id = id, timer = 46, loop = -1, dst = {
                {time = 0, x = x, y = JUDGES.SCORE.DIFF.Y(JUDGES), w = JUDGES.SCORE.DIFF.W, h = JUDGES.SCORE.DIFF.H},
                {time = JUDGES.DRAW_TIME}
            }
        }
    end
    return skin
end

return judges.functions