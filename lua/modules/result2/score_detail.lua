require("modules.result.commons")
require("modules.result2.commons")
require("modules.commons.deepcopy")
local main_state = require("main_state")
local timer_util = require("timer_util")
local judges = require("modules.result2.judges")

local scoreDetail = {
    isOpened = false,
    timeForAnimation = 99999999,
    functions = {}
}

local DETAIL = {
    AREA = {
        X = 0,
        Y = 0,
        W = 960,
        SHADOW_W = 1005,
        H = HEIGHT,
        DIMMER_ALPHA = 90,
    },

    LABEL = {
        W = 120,
        H = 32,
        RATE = {
            Y = function (self) return self.AREA.Y + 1020 end,
        },
        JUDGE = {
            Y = function (self) return self.AREA.Y + 988 end,
        },
        BEST = {
            Y = function (self) return self.AREA.Y + 534 - 6 end,
        }
    },
    JUDGES = {
        INTERVALS_Y = {70, 60, 55, 55, 55},
        Y = function (self, idx)
            local s = 0
            for i = 1, idx-1 do s = s + self.JUDGES.INTERVALS_Y[i] end
            return self.AREA.Y + 923 - 6 - s
        end,
        LABEL = {
            W = 176,
            H = 45
        }
    },
    HEADER = {
        X = function (self) return self.AREA.X + 38 end,
        W = 256,
        H = 36,
    },
    EXSCORE = {
        Y = function (self) return self.AREA.Y + 346 end,
        W = 256,
        H = 44,
    },
    TN = {
        Y = function (self) return self.AREA.Y + 565 end,
    },
    COMBO = {
        Y = function (self) return self.AREA.Y + 481 end,
    },
    BP = {
        Y = function (self) return self.AREA.Y + 426 end,
    },
    TARGET = {
        Y = function (self) return self.AREA.Y + 291 end,
    },
    TIMING = {
        LABEL = {
            X = function (self) return self.AREA.X + 727 end,
            Y = function (self) return self.AREA.Y + 229 end,
            W = 162,
            H = 32,
        },
        VAL = {
            X_LABEL = function (self) return self.TIMING.LABEL.X(self) - 29 end,
            X_NUM = function (self) return self.TIMING.LABEL.X(self) + 150 end,
            Y1 = function (self) return self.TIMING.LABEL.Y(self) - 40 end,
            Y2 = function (self) return self.TIMING.VAL.Y1(self) - 40 end,
        }
    },

    COL = {
        X = function (self, idx) return self.AREA.X + 462 + self.COL.W * (idx - 1) end,
        -- 5桁前提
        NUM36_X = function (self, idx) return self.COL.X(self, idx + 1) - 15 - 5 * (self.GRAY_36NUM.W + self.GRAY_36NUM.SPACE) end,
        NUM48_X = function (self, idx) return self.COL.X(self, idx + 1) - 15 - 5 * (self.GRAY_48NUM.W + self.GRAY_48NUM.SPACE) end,
        NUM36_JUDGE_X = function (self, idx) return self.COL.X(self, idx + 1) - 15 - 5 * (judges.getVerySmallNumSize().W + judges.getVerySmallNumSize().SPACE) end,
        NUM48_JUDGE_X = function (self, idx) return self.COL.X(self, idx + 1) - 15 - 5 * (judges.getSmallNumSize().W + judges.getSmallNumSize().SPACE) end,

        RATE_X = function (self, idx) return self.COL.X(self, idx + 1) - 12 end,
        W = 120,
    },
    MAIN_NUM = {
        X = function (self) return self.AREA.X + 428 end,
        -- 5桁前提
        X_72PX = function (self) return self.MAIN_NUM.X(self) - 5 * (judges.getLargeNumSize().W + judges.getLargeNumSize().SPACE) + 5 end,
        X_JUDGE48PX = function (self) return self.MAIN_NUM.X(self) - 5 * (judges.getSmallNumSize().W + judges.getSmallNumSize().SPACE) + 5 end,
        X_GRAY48PX = function (self) return self.MAIN_NUM.X(self) - 5 * (self.GRAY_48NUM.W + self.GRAY_48NUM.SPACE) + 5 end,
    },
    GRAY_30NUM = {
        W = 24,
        H = 31,
        SPACE = -8,
        DOT = {
            W = 12,
            H = 12,
            SPACE = 0,
            AREA_W = 2,
        },
        PERCENT = {
            W = 29,
            H = 31,
            SPACE = -1,
            AREA_W = 19,
        },
        EMPTY = {
            W = 0,
            H = 0,
            SPACE = 0,
            AREA_W = 0,
        },
    },
    GRAY_36NUM = {
        W = 26,
        H = 36,
        SPACE = -7,
        DOT = {
            W = 13,
            H = 14,
            SPACE = 0,
            AREA_W = 3,
        },
        PERCENT = {
            W = 33,
            H = 36,
            SPACE = -1,
            AREA_W = 24,
        }
    },
    GRAY_48NUM = {
        W = 32,
        H = 45,
        SPACE = -5
    },
    GRAPH = {
        PREFIX = {"notes", "judges", "el", "timing", "blank"},
        DIMMER_ALPHA = 90,
        X = function (self) return self.AREA.X + 43 end,
        Y = function (self, idx) 
            if idx == 1 then return self.AREA.Y + 154
            else return self.AREA.Y + 22
            end
        end,
        W = 630,
        H = 102,
        DETAIL = {
            X = function (self) return self.GRAPH.X(self) + self.GRAPH.W - 7 - self.GRAPH.DETAIL.W end,
            Y = function (self, idx) return self.GRAPH.Y(self, idx) + self.GRAPH.H - 7 - self.GRAPH.DETAIL.H end,
            W = 174,
            H = 12,
        },
        LABEL = {
            X = function (self) return self.GRAPH.X(self) + 1 end,
            Y = function (self, idx) return self.GRAPH.Y(self, idx) + self.GRAPH.H - 1 - self.GRAPH.LABEL.H end,
            W = 128,
            H = 29,
        }
    },
    ANIMATION = {
        MOVE_TIME = 200,
        CLOSE_TIME = 1000,
    },
}

scoreDetail.functions.loadGray30Number = function (id, digit, align, padding, ref, value)
    local param = DETAIL.GRAY_30NUM
    return {id = id, src = 15, x = 0, y = 216, w = param.W * 10, h = param.H, divx = 10, align = align, digit = digit, space = param.SPACE, padding = padding, ref = ref, value = value}
end

scoreDetail.functions.loadGray36Number = function (id, digit, align, ref, value)
    local param = DETAIL.GRAY_36NUM
    return {id = id, src = 15, x = 0, y = 0, w = param.W * 10, h = param.H, divx = 10, align = align, digit = digit, space = param.SPACE, ref = ref, value = value}
end

scoreDetail.functions.loadGray48Number = function (id, digit, align, ref, value)
    local param = DETAIL.GRAY_48NUM
    return {id = id, src = 16, x = 0, y = 0, w = param.W * 10, h = param.H, divx = 10, align = align, digit = digit, space = param.SPACE, ref = ref, value = value}
end

--[[
    @param {string} id 整数部分はこのID, 小数部分はid.."AfterDot", ドットはid.."Dot", %はid.."Percent"
    @param {int} afterDotDigit 小数部分の桁数
    @param {float} rate パーセンテージ
    @return {array} skin mergeSkinする
]]
scoreDetail.functions.loadDiffRate30Number = function (id, afterDotDigit, rate)
    local skin = {image = {}, value = {}}
    local vals = skin.value
    local imgs = skin.image
    local rateAf = math.floor(math.abs(rate) * 100) % 100
    vals[#vals+1] = {id = id, src = 15, x = 0, y = 247, w = DETAIL.GRAY_30NUM.W * 12, h = DETAIL.GRAY_30NUM.H * 2, divx = 12, divy = 2, digit = 3, space = DETAIL.GRAY_30NUM.SPACE, value = function () return rate end}
    if rate >= 0 then
        vals[#vals+1] = {id = id .. "AfterDot", src = 15, x = 0, y = 247, w = DETAIL.GRAY_30NUM.W * 10, h = DETAIL.GRAY_30NUM.H, divx = 10, padding = 1, digit = afterDotDigit, space = DETAIL.GRAY_30NUM.SPACE, value = function () return rateAf end}
        imgs[#imgs+1] = {id = id .. "Dot", src = 15, x = 288, y = 266, w = DETAIL.GRAY_30NUM.DOT.W, h = DETAIL.GRAY_30NUM.DOT.H}
        imgs[#imgs+1] = {id = id .. "Percent", src = 15, x = 336, y = 247, w = DETAIL.GRAY_30NUM.PERCENT.W, h = DETAIL.GRAY_30NUM.PERCENT.H}
    else
        vals[#vals+1] = {id = id .. "AfterDot", src = 15, x = 0, y = 278, w = DETAIL.GRAY_30NUM.W * 10, h = DETAIL.GRAY_30NUM.H, divx = 10, padding = 1, digit = afterDotDigit, space = DETAIL.GRAY_30NUM.SPACE, value = function () return rateAf end}
        imgs[#imgs+1] = {id = id .. "Dot", src = 15, x = 288, y = 297, w = DETAIL.GRAY_30NUM.DOT.W, h = DETAIL.GRAY_30NUM.DOT.H}
        imgs[#imgs+1] = {id = id .. "Percent", src = 15, x = 336, y = 278, w = DETAIL.GRAY_30NUM.PERCENT.W, h = DETAIL.GRAY_30NUM.PERCENT.H}
    end
    return skin
end

scoreDetail.functions.switchOpenStateTimer = function ()
    if isPressedLeft() then
        scoreDetail.functions.switchOpenState()
    end
    return 1
end

scoreDetail.functions.switchOpenState = function ()
    scoreDetail.isOpened = not scoreDetail.isOpened
    myPrint("詳細画面切り替え: " .. (scoreDetail.isOpened and "opened" or "closed"))
    if scoreDetail.isOpened then
        scoreDetail.timeForAnimation = main_state.time()
    else
        scoreDetail.timeForAnimation = main_state.time() - DETAIL.ANIMATION.CLOSE_TIME * 1000
    end
end

scoreDetail.functions.isOpenedWindow = function ()
    return scoreDetail.isOpened
end

-- 閉じるアニメーションのためにこれ
scoreDetail.functions.windowAnimationTimer = function ()
    if scoreDetail.isOpened then
        local t = main_state.time()
        local moveTime = DETAIL.ANIMATION.MOVE_TIME
        if t - scoreDetail.timeForAnimation > moveTime * 1000 then
            scoreDetail.timeForAnimation = t - moveTime * 1000
        end
        return scoreDetail.timeForAnimation
    else
        return scoreDetail.timeForAnimation
    end
end

scoreDetail.functions.load = function ()
    local totalNotes = main_state.number(74)
    local theoretical = totalNotes * 2
    -- 判定文字は読み込み済み
    -- 各判定合計数字も読み込み済み

    local skin = {
        image = {
            {id = "detailBokehBg", src = getBokehBgSrc(), x = 0, y = HEIGHT - DETAIL.AREA.Y - DETAIL.AREA.H, w = DETAIL.AREA.W, h = DETAIL.AREA.H},
            {id = "detailWindowShadow", src = 18, x = 0, y = 0, w = -1, h = -1},
            {id = "gray30Dot", src = 15, x = 288, y = 235, w = DETAIL.GRAY_30NUM.DOT.W, h = DETAIL.GRAY_30NUM.DOT.H},
            {id = "gray30Percent", src = 15, x = 336, y = 216, w = DETAIL.GRAY_30NUM.PERCENT.W, h = DETAIL.GRAY_30NUM.PERCENT.H},
            -- ヘッダ読み込み 数が少ないので普通に.
            {id = "totalNotesDetailHeader" , src = 14, x = 0, y = DETAIL.HEADER.H * 0, w = DETAIL.HEADER.W, h = DETAIL.HEADER.H},
            {id = "comboDetailHeader"   , src = 14, x = 0, y = DETAIL.HEADER.H * 1, w = DETAIL.HEADER.W, h = DETAIL.HEADER.H},
            {id = "bpDetailHeader"  , src = 14, x = 0, y = DETAIL.HEADER.H * 2, w = DETAIL.HEADER.W, h = DETAIL.HEADER.H},
            {id = "targetScoreDetailHeader", src = 14, x = 0, y = DETAIL.HEADER.H * 3, w = DETAIL.HEADER.W, h = DETAIL.HEADER.H},
            {id = "exScoreDetailHeader"    , src = 14, x = 0, y = DETAIL.HEADER.H * 4, w = DETAIL.EXSCORE.W, h = DETAIL.EXSCORE.H},
            {id = "switchDetailWindowButton", src = 999, x = 0, y = 0, w = 1, h = 1, act = scoreDetail.functions.switchOpenState},
        },
        value = {},
        customTimers = {
            {id = CUSTOM_TIMERS_RESULT2.SWITCH_DETAIL, timer = scoreDetail.functions.switchOpenStateTimer},
            {id = CUSTOM_TIMERS_RESULT2.DETAIL_WND_TIMER, timer = scoreDetail.functions.windowAnimationTimer}
        }
    }
    local imgs = skin.image
    local vals = skin.value

    -- ラベル群の読み込み
    do
        local prefix = {"early", "late", "rate", "score", "num", "best", "diff", "avg", "std"}
        for i, v in ipairs(prefix) do
            imgs[#imgs+1] = {
                id = v .. "DetailLabel", src = 13, x = 0, y = DETAIL.LABEL.H * (i - 1), w = DETAIL.LABEL.W, h = DETAIL.LABEL.H
            }
        end
        -- timing shiftだけサイズが違うので別個
        imgs[#imgs+1] = {
            id = "timingShiftDetailLabel", src = 13, x = DETAIL.LABEL.W, y = 0, w = DETAIL.TIMING.LABEL.W, h = DETAIL.TIMING.LABEL.H
        }
    end

    -- 判定の数値の読み込み
    do
        local prefix = {"perfect", "great", "good", "bad", "poor", "epoor"}
        for i, v in ipairs(prefix) do
            imgs[#imgs+1] = {
                id = v .. "DetailLabel", src = 170 + (i - 1), x = 0, y = 0, w = -1, h = -1
            }

            local numParams = judges.getLargeNumSize()
            local numParamsSmall = judges.getSmallNumSize()
            if i >= 3 then
                numParams = judges.getSmallNumSize()
                numParamsSmall = judges.getVerySmallNumSize()
            end

            local ref = 110 + (i - 1)
            local elRef = 410 + 2 * (i - 1)
            if v == "epoor" then
                ref = 420
                elRef = 421
            end

            -- 合計数
            vals[#vals+1] = {
                id = v .. "DetailNum", src = 180 + (i - 1), x = 0, y = 0, w = numParams.W * 10, h = numParams.H, divx = 10, digit = 5, space = numParams.SPACE, ref = ref
            }
            -- early late
            vals[#vals+1] = {
                id = v .. "EarlyDetailNum", src = 180 + (i - 1), x = 0, y = 63, w = numParamsSmall.W * 10, h = numParamsSmall.H, divx = 10, digit = 5, space = numParamsSmall.SPACE, ref = elRef
            }
            vals[#vals+1] = {
                id = v .. "LateDetailNum", src = 180 + (i - 1), x = 0, y = 63, w = numParamsSmall.W * 10, h = numParamsSmall.H, divx = 10, digit = 5, space = numParamsSmall.SPACE, ref = elRef + 1
            }
            -- rate num
            do
                local rate = main_state.number(ref) / totalNotes * 100
                local rateAf = math.floor(rate * 100) % 100
                vals[#vals+1] = scoreDetail.functions.loadGray30Number(v .. "NumRateValue", 3, 0, 0, nil, function () return rate end)
                vals[#vals+1] = scoreDetail.functions.loadGray30Number(v .. "NumRateValueAfterDot", 2, 0, 1, nil, function () return rateAf end)
            end
            -- rate score good以下は0%なので計算出力はしない
            if i <= 2 then
                local rate = main_state.number(ref) / theoretical * 100
                if i == 1 then rate = main_state.number(ref) * 2 / theoretical * 100 end
                local rateAf = math.floor(rate * 100) % 100
                vals[#vals+1] = scoreDetail.functions.loadGray30Number(v .. "ScoreRateValue", 3, 0, 0, nil, function () return rate end)
                vals[#vals+1] = scoreDetail.functions.loadGray30Number(v .. "ScoreRateValueAfterDot", 2, 0, 1, nil, function () return rateAf end)
            end
        end
    end
    -- tn
    vals[#vals+1] = scoreDetail.functions.loadGray48Number("totalNotesDetailValue", 5, 0, 74, nil)
    -- combo
    vals[#vals+1] = scoreDetail.functions.loadGray48Number("comboDetailValue", 5, 0, 75, nil)
    vals[#vals+1] = scoreDetail.functions.loadGray36Number("comboOldDetailValue", 5, 0, 173, nil)
    vals[#vals+1] = {id = "comboDiffDetailValue", src = 15, x = 0, y = 72, w = DETAIL.GRAY_36NUM.W * 12, h = DETAIL.GRAY_36NUM.H * 2, divx = 12, divy = 2, digit = 5, space = DETAIL.GRAY_36NUM.SPACE, ref = 175}
    do
        local rate = main_state.number(75) / totalNotes * 100
        local rateAf = math.floor(rate * 100) % 100
        vals[#vals+1] = scoreDetail.functions.loadGray30Number("comboRateDetailValue", 3, 0, 0, nil, function () return rate end)
        vals[#vals+1] = scoreDetail.functions.loadGray30Number("comboRateDetailValueAfterDot", 2, 0, 1, nil, function () return rateAf end)
    end

    -- bp
    vals[#vals+1] = scoreDetail.functions.loadGray48Number("bpDetailValue", 5, 0, 76, nil)
    vals[#vals+1] = scoreDetail.functions.loadGray36Number("bpOldDetailValue", 5, 0, 176, nil)
    vals[#vals+1] = {id = "bpDiffDetailValue", src = 15, x = 0, y = 144, w = DETAIL.GRAY_36NUM.W * 12, h = DETAIL.GRAY_36NUM.H * 2, divx = 12, divy = 2, digit = 5, space = DETAIL.GRAY_36NUM.SPACE, ref = 176}
    do
        local rate = main_state.number(76) / totalNotes * 100
        local rateAf = math.floor(rate * 100) % 100
        vals[#vals+1] = scoreDetail.functions.loadGray30Number("bpRateDetailValue", 3, 0, 0, nil, function () return rate end)
        vals[#vals+1] = scoreDetail.functions.loadGray30Number("bpRateDetailValueAfterDot", 2, 0, 1, nil, function () return rateAf end)
    end

    -- EXSCORE
    vals[#vals+1] = {id = "exScoreDetailValue", src = 17, x = 0, y = 0, w = judges.getLargeNumSize().W * 10, h = judges.getLargeNumSize().H, divx = 10, digit = 5, space = judges.getLargeNumSize().SPACE, ref = 71}
    vals[#vals+1] = scoreDetail.functions.loadGray48Number("bestScoreDetailValue", 5, 0, 170, nil)
    vals[#vals+1] = scoreDetail.functions.loadGray30Number("exScoreRateDetailValue", 3, 0, 0, 102, nil)
    vals[#vals+1] = scoreDetail.functions.loadGray30Number("exScoreRateAfterDotDetailValue", 2, 0, 1, 103, nil)

    -- ベストスコア
    vals[#vals+1] = {id = "bestDiffDetailValue", src = 15, x = 0, y = 72, w = DETAIL.GRAY_36NUM.W * 12, h = DETAIL.GRAY_36NUM.H * 2, divx = 12, divy = 2, digit = 5, space = DETAIL.GRAY_36NUM.SPACE, ref = 172}
    -- ベストスコアとのレート差計算
    do
        local rate = (main_state.rate() - main_state.rate_best()) * 100
        mergeSkin(skin, scoreDetail.functions.loadDiffRate30Number("scoreRateBestDiffDetailValue", 2, rate))
    end
    -- ターゲットスコア
    vals[#vals+1] = scoreDetail.functions.loadGray48Number("targetScoreDetailValue", 5, 0, 151, nil)
    vals[#vals+1] = {id = "targetDiffDetailValue", src = 15, x = 0, y = 72, w = DETAIL.GRAY_36NUM.W * 12, h = DETAIL.GRAY_36NUM.H * 2, divx = 12, divy = 2, digit = 5, space = DETAIL.GRAY_36NUM.SPACE, ref = 153}
    vals[#vals+1] = scoreDetail.functions.loadGray30Number("targetScoreRateDetailValue", 3, 0, 0, 122, nil)
    vals[#vals+1] = scoreDetail.functions.loadGray30Number("targetScoreRateAfterDotDetailValue", 2, 1, 0, 123, nil)
    -- ターゲットスコアとのレート差計算
    do
        local rate = (main_state.rate() - main_state.rate_rival()) * 100
        mergeSkin(skin, scoreDetail.functions.loadDiffRate30Number("scoreRateTargetDiffDetailValue", 2, rate))
    end
    -- タイミング
    vals[#vals+1] = scoreDetail.functions.loadGray30Number("timingAvgDetailValue", 3, 0, 0, 374, nil)
    vals[#vals+1] = scoreDetail.functions.loadGray30Number("timingAvgDetailValueAfterDot", 2, 0, 1, 375, nil)
    vals[#vals+1] = scoreDetail.functions.loadGray30Number("timingStdDetailValue", 3, 0, 0, 376, nil)
    vals[#vals+1] = scoreDetail.functions.loadGray30Number("timingStdDetailValueAfterDot", 2, 0, 1, 377, nil)

    return skin
end

scoreDetail.functions.dst = function ()
    local skin = {
        destination = {
            {
                id = "detailBokehBg", dst = {
                    {x = DETAIL.AREA.X, y = DETAIL.AREA.Y, w = DETAIL.AREA.W, h = DETAIL.AREA.H}
                }
            },
            {
                id = "detailWindowShadow", dst = {
                    {x = DETAIL.AREA.X, y = DETAIL.AREA.Y, w = DETAIL.AREA.SHADOW_W, h = DETAIL.AREA.H}
                }
            },
            {
                id = "black", dst = {
                    {x = DETAIL.AREA.X, y = DETAIL.AREA.Y, w = DETAIL.AREA.W, h = DETAIL.AREA.H, a = DETAIL.AREA.DIMMER_ALPHA}
                }
            },
            -- 上部のラベルから
            {
                id = "rateDetailLabel", dst = {
                    {x = DETAIL.COL.X(DETAIL, 3.5), y = DETAIL.LABEL.RATE.Y(DETAIL), w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
                }
            },
            {
                id = "earlyDetailLabel", dst = {
                    {x = DETAIL.COL.X(DETAIL, 1), y = DETAIL.LABEL.JUDGE.Y(DETAIL), w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
                }
            },
            {
                id = "lateDetailLabel", dst = {
                    {x = DETAIL.COL.X(DETAIL, 2), y = DETAIL.LABEL.JUDGE.Y(DETAIL), w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
                }
            },
            {
                id = "numDetailLabel", dst = {
                    {x = DETAIL.COL.X(DETAIL, 3), y = DETAIL.LABEL.JUDGE.Y(DETAIL), w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
                }
            },
            {
                id = "scoreDetailLabel", dst = {
                    {x = DETAIL.COL.X(DETAIL, 4), y = DETAIL.LABEL.JUDGE.Y(DETAIL), w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
                }
            },
        }
    }
    local dst = skin.destination
    local num30 = DETAIL.GRAY_30NUM

    do
        -- 判定を並べる
        local prefix = {"perfect", "great", "good", "bad", "poor", "epoor"}
        local label = DETAIL.JUDGES.LABEL
        for i, v in ipairs(prefix) do
            local numParams = judges.getLargeNumSize()
            local numParamsSmall = judges.getSmallNumSize()
            if i >= 3 then
                numParams = judges.getSmallNumSize()
                numParamsSmall = judges.getVerySmallNumSize()
            end
            -- ラベルの出力
            dst[#dst+1] = {
                id = v .. "DetailLabel", dst = {
                    {x = DETAIL.HEADER.X(DETAIL), y = DETAIL.JUDGES.Y(DETAIL, i), w = label.W, h = label.H}
                }
            }
            -- 値の出力
            do
                local x = DETAIL.MAIN_NUM.X_72PX(DETAIL)
                if i > 2 then x = DETAIL.MAIN_NUM.X_JUDGE48PX(DETAIL) end
                dst[#dst+1] = {
                    id = v .. "DetailNum", dst = {
                        {x = x, y = DETAIL.JUDGES.Y(DETAIL, i), w = numParams.W, h = numParams.H}
                    }
                }
            end

            -- early late
            do
                local x = DETAIL.COL.NUM48_JUDGE_X(DETAIL, 1)
                if i > 2 then x = DETAIL.COL.NUM36_JUDGE_X(DETAIL, 1) end
                local x2 = DETAIL.COL.NUM48_JUDGE_X(DETAIL, 2)
                if i > 2 then x2 = DETAIL.COL.NUM36_JUDGE_X(DETAIL, 2) end
                dst[#dst+1] = {
                    id = v .. "EarlyDetailNum", dst = {
                        {x = x, y = DETAIL.JUDGES.Y(DETAIL, i), w = numParamsSmall.W, h = numParamsSmall.H}
                    }
                }
                dst[#dst+1] = {
                    id = v .. "LateDetailNum", dst = {
                        {x = x2, y = DETAIL.JUDGES.Y(DETAIL, i), w = numParamsSmall.W, h = numParamsSmall.H}
                    }
                }
            end

            -- 個数レート
            mergeSkin(skin, dstPercentage(v .. "NumRateValue", "gray30Dot", v .. "NumRateValueAfterDot", "gray30Percent", 2, DETAIL.COL.RATE_X(DETAIL, 3), DETAIL.JUDGES.Y(DETAIL, i), num30.W, num30.H, num30.SPACE, num30.DOT, num30.PERCENT))
            -- スコアレート
            if i <= 2 then
                mergeSkin(skin, dstPercentage(v .. "ScoreRateValue", "gray30Dot", v .. "ScoreRateValueAfterDot", "gray30Percent", 2, DETAIL.COL.RATE_X(DETAIL, 4), DETAIL.JUDGES.Y(DETAIL, i), num30.W, num30.H, num30.SPACE, num30.DOT, num30.PERCENT))
            end
        end
    end

    -- total notes
    dst[#dst+1] = {
        id = "totalNotesDetailHeader", dst = {
            {x = DETAIL.HEADER.X(DETAIL), y = DETAIL.TN.Y(DETAIL), w = DETAIL.HEADER.W, h = DETAIL.HEADER.H}
        }
    }
    dst[#dst+1] = {
        id = "totalNotesDetailValue", dst = {
            {x = DETAIL.MAIN_NUM.X_GRAY48PX(DETAIL), y = DETAIL.TN.Y(DETAIL), w = DETAIL.GRAY_48NUM.W, h = DETAIL.GRAY_48NUM.H}
        }
    }
    -- best diff rate
    dst[#dst+1] = {
        id = "bestDetailLabel", dst = {
            {x = DETAIL.COL.X(DETAIL, 1), y = DETAIL.LABEL.BEST.Y(DETAIL), w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
        }
    }
    dst[#dst+1] = {
        id = "diffDetailLabel", dst = {
            {x = DETAIL.COL.X(DETAIL, 2), y = DETAIL.LABEL.BEST.Y(DETAIL), w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
        }
    }
    dst[#dst+1] = {
        id = "rateDetailLabel", dst = {
            {x = DETAIL.COL.X(DETAIL, 3), y = DETAIL.LABEL.BEST.Y(DETAIL), w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
        }
    }

    -- max combo
    dst[#dst+1] = {
        id = "comboDetailHeader", dst = {
            {x = DETAIL.HEADER.X(DETAIL), y = DETAIL.COMBO.Y(DETAIL), w = DETAIL.HEADER.W, h = DETAIL.HEADER.H}
        }
    }
    dst[#dst+1] = {
        id = "comboDetailValue", dst = {
            {x = DETAIL.MAIN_NUM.X_GRAY48PX(DETAIL), y = DETAIL.COMBO.Y(DETAIL), w = DETAIL.GRAY_48NUM.W, h = DETAIL.GRAY_48NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "comboOldDetailValue", dst = {
            {x = DETAIL.COL.NUM36_X(DETAIL, 1), y = DETAIL.COMBO.Y(DETAIL), w = DETAIL.GRAY_36NUM.W, h = DETAIL.GRAY_36NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "comboDiffDetailValue", dst = {
            {x = DETAIL.COL.NUM36_X(DETAIL, 2), y = DETAIL.COMBO.Y(DETAIL), w = DETAIL.GRAY_36NUM.W, h = DETAIL.GRAY_36NUM.H}
        }
    }
    mergeSkin(skin, dstPercentage("comboRateDetailValue", "gray30Dot", "comboRateDetailValueAfterDot", "gray30Percent", 2, DETAIL.COL.RATE_X(DETAIL, 3), DETAIL.COMBO.Y(DETAIL), num30.W, num30.H, num30.SPACE, num30.DOT, num30.PERCENT))

    -- bp
    dst[#dst+1] = {
        id = "bpDetailHeader", dst = {
            {x = DETAIL.HEADER.X(DETAIL), y = DETAIL.BP.Y(DETAIL), w = DETAIL.HEADER.W, h = DETAIL.HEADER.H}
        }
    }
    dst[#dst+1] = {
        id = "bpDetailValue", dst = {
            {x = DETAIL.MAIN_NUM.X_GRAY48PX(DETAIL), y = DETAIL.BP.Y(DETAIL), w = DETAIL.GRAY_48NUM.W, h = DETAIL.GRAY_48NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "bpOldDetailValue", dst = {
            {x = DETAIL.COL.NUM36_X(DETAIL, 1), y = DETAIL.BP.Y(DETAIL), w = DETAIL.GRAY_36NUM.W, h = DETAIL.GRAY_36NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "bpDiffDetailValue", dst = {
            {x = DETAIL.COL.NUM36_X(DETAIL, 2), y = DETAIL.BP.Y(DETAIL), w = DETAIL.GRAY_36NUM.W, h = DETAIL.GRAY_36NUM.H}
        }
    }
    mergeSkin(skin, dstPercentage("bpRateDetailValue", "gray30Dot", "bpRateDetailValueAfterDot", "gray30Percent", 2, DETAIL.COL.RATE_X(DETAIL, 3), DETAIL.BP.Y(DETAIL), num30.W, num30.H, num30.SPACE, num30.DOT, num30.PERCENT))

    -- exscore
    dst[#dst+1] = {
        id = "exScoreDetailHeader", dst = {
            {x = DETAIL.HEADER.X(DETAIL), y = DETAIL.EXSCORE.Y(DETAIL), w = DETAIL.EXSCORE.W, h = DETAIL.EXSCORE.H}
        }
    }
    dst[#dst+1] = {
        id = "exScoreDetailValue", dst = {
            {x = DETAIL.MAIN_NUM.X_72PX(DETAIL), y = DETAIL.EXSCORE.Y(DETAIL), w = judges.getLargeNumSize().W, h = judges.getLargeNumSize().H}
        }
    }
    dst[#dst+1] = {
        id = "bestScoreDetailValue", dst = {
            {x = DETAIL.COL.NUM48_X(DETAIL, 1), y = DETAIL.EXSCORE.Y(DETAIL), w = DETAIL.GRAY_48NUM.W, h = DETAIL.GRAY_48NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "bestDiffDetailValue", dst = {
            {x = DETAIL.COL.NUM36_X(DETAIL, 2), y = DETAIL.EXSCORE.Y(DETAIL), w = DETAIL.GRAY_36NUM.W, h = DETAIL.GRAY_36NUM.H}
        }
    }
    -- 対bestとのdiff
    mergeSkin(skin, dstPercentage("exScoreRateDetailValue", "gray30Dot", "exScoreRateAfterDotDetailValue", "gray30Percent", 2, DETAIL.COL.RATE_X(DETAIL, 3), DETAIL.EXSCORE.Y(DETAIL), num30.W, num30.H, num30.SPACE, num30.DOT, num30.PERCENT))
    -- 対bestとのrateのdiff
    mergeSkin(skin, dstPercentage("scoreRateBestDiffDetailValue", "scoreRateBestDiffDetailValueDot", "scoreRateBestDiffDetailValueAfterDot", "scoreRateBestDiffDetailValuePercent", 2, DETAIL.COL.RATE_X(DETAIL, 4), DETAIL.EXSCORE.Y(DETAIL), num30.W, num30.H, num30.SPACE, num30.DOT, num30.PERCENT))

    -- target score
    dst[#dst+1] = {
        id = "targetScoreDetailHeader", dst = {
            {x = DETAIL.HEADER.X(DETAIL), y = DETAIL.TARGET.Y(DETAIL), w = DETAIL.HEADER.W, h = DETAIL.HEADER.H}
        }
    }
    -- メイン数字はなし
    -- dst[#dst+1] = {
    --     id = "targetScoreDetailValue", dst = {
    --         {x = DETAIL.MAIN_NUM.X_GRAY48PX(DETAIL), y = DETAIL.BP.Y(DETAIL), w = DETAIL.GRAY_48NUM.W, h = DETAIL.GRAY_48NUM.H}
    --     }
    -- }
    dst[#dst+1] = {
        id = "targetScoreDetailValue", dst = {
            {x = DETAIL.COL.NUM48_X(DETAIL, 1), y = DETAIL.TARGET.Y(DETAIL), w = DETAIL.GRAY_48NUM.W, h = DETAIL.GRAY_48NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "targetDiffDetailValue", dst = {
            {x = DETAIL.COL.NUM36_X(DETAIL, 2), y = DETAIL.TARGET.Y(DETAIL), w = DETAIL.GRAY_36NUM.W, h = DETAIL.GRAY_36NUM.H}
        }
    }
    -- 対targetとのdiff
    mergeSkin(skin, dstPercentage("targetScoreRateDetailValue", "gray30Dot", "targetScoreRateAfterDotDetailValue", "gray30Percent", 2, DETAIL.COL.RATE_X(DETAIL, 3), DETAIL.TARGET.Y(DETAIL), num30.W, num30.H, num30.SPACE, num30.DOT, num30.PERCENT))
    -- 対targetとのrateのdiff
    mergeSkin(skin, dstPercentage("scoreRateTargetDiffDetailValue", "scoreRateTargetDiffDetailValueDot", "scoreRateTargetDiffDetailValueAfterDot", "scoreRateTargetDiffDetailValuePercent", 2, DETAIL.COL.RATE_X(DETAIL, 4), DETAIL.TARGET.Y(DETAIL), num30.W, num30.H, num30.SPACE, num30.DOT, num30.PERCENT))

    -- 判定グラフ等描画
    -- グラフ本体やラベルはgroove.luaで読み込み済み
    mergeSkin(skin, {
        destination = {
            { -- 判定グラフbg
                id = "black", dst = {
                    {x = DETAIL.GRAPH.X(DETAIL), y = DETAIL.GRAPH.Y(DETAIL, 1), w = DETAIL.GRAPH.W, h = DETAIL.GRAPH.H, a = DETAIL.GRAPH.DIMMER_ALPHA}
                }
            },
            { -- 判定ゲージ本体
                id = DETAIL.GRAPH.PREFIX[getGaugeTypeAtDetailWindow1()] .. "Graph", dst = {
                    {x = DETAIL.GRAPH.X(DETAIL), y = DETAIL.GRAPH.Y(DETAIL, 1), w = DETAIL.GRAPH.W, h = DETAIL.GRAPH.H}
                }
            },
            { -- 色の説明部分
                id = DETAIL.GRAPH.PREFIX[getGaugeTypeAtDetailWindow1()] .. "Detail", dst = {
                    {x = DETAIL.GRAPH.DETAIL.X(DETAIL), y = DETAIL.GRAPH.DETAIL.Y(DETAIL, 1), w = DETAIL.GRAPH.DETAIL.W, h = DETAIL.GRAPH.DETAIL.H}
                }
            },
            { -- 色の説明部分
                id = DETAIL.GRAPH.PREFIX[getGaugeTypeAtDetailWindow1()] .. "Label", dst = {
                    {x = DETAIL.GRAPH.LABEL.X(DETAIL), y = DETAIL.GRAPH.LABEL.Y(DETAIL, 1), w = DETAIL.GRAPH.LABEL.W, h = DETAIL.GRAPH.LABEL.H}
                }
            },
            { -- 判定グラフshadow
                id = "judgeGaugeShadow", dst = {
                    {x = DETAIL.GRAPH.X(DETAIL), y = DETAIL.GRAPH.Y(DETAIL, 1), w = DETAIL.GRAPH.W, h = DETAIL.GRAPH.H, a = DETAIL.GRAPH.DIMMER_ALPHA}
                }
            },
            -- 2個目
            { -- 判定グラフbg
                id = "black", dst = {
                    {x = DETAIL.GRAPH.X(DETAIL), y = DETAIL.GRAPH.Y(DETAIL, 2), w = DETAIL.GRAPH.W, h = DETAIL.GRAPH.H, a = DETAIL.GRAPH.DIMMER_ALPHA}
                }
            },
            { -- 判定ゲージ本体
                id = DETAIL.GRAPH.PREFIX[getGaugeTypeAtDetailWindow2()] .. "Graph", dst = {
                    {x = DETAIL.GRAPH.X(DETAIL), y = DETAIL.GRAPH.Y(DETAIL, 2), w = DETAIL.GRAPH.W, h = DETAIL.GRAPH.H}
                }
            },
            { -- 色の説明部分
                id = DETAIL.GRAPH.PREFIX[getGaugeTypeAtDetailWindow2()] .. "Detail", dst = {
                    {x = DETAIL.GRAPH.DETAIL.X(DETAIL), y = DETAIL.GRAPH.DETAIL.Y(DETAIL, 2), w = DETAIL.GRAPH.DETAIL.W, h = DETAIL.GRAPH.DETAIL.H}
                }
            },
            { -- 色の説明部分
                id = DETAIL.GRAPH.PREFIX[getGaugeTypeAtDetailWindow2()] .. "Label", dst = {
                    {x = DETAIL.GRAPH.LABEL.X(DETAIL), y = DETAIL.GRAPH.LABEL.Y(DETAIL, 2), w = DETAIL.GRAPH.LABEL.W, h = DETAIL.GRAPH.LABEL.H}
                }
            },
            { -- 判定グラフshadow
                id = "judgeGaugeShadow", dst = {
                    {x = DETAIL.GRAPH.X(DETAIL), y = DETAIL.GRAPH.Y(DETAIL, 2), w = DETAIL.GRAPH.W, h = DETAIL.GRAPH.H, a = DETAIL.GRAPH.DIMMER_ALPHA}
                }
            },
        }
    })

    -- タイミング
    dst[#dst+1] = {
        id = "timingShiftDetailLabel", dst = {
            {x = DETAIL.TIMING.LABEL.X(DETAIL), y = DETAIL.TIMING.LABEL.Y(DETAIL), w = DETAIL.TIMING.LABEL.W, h = DETAIL.TIMING.LABEL.H}
        }
    }
    dst[#dst+1] = {
        id = "avgDetailLabel", dst = {
            {x = DETAIL.TIMING.VAL.X_LABEL(DETAIL), y = DETAIL.TIMING.VAL.Y1(DETAIL), w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
        }
    }
    mergeSkin(skin, dstPercentage("timingAvgDetailValue", "gray30Dot", "timingAvgDetailValueAfterDot", "gray30Percent", 2, DETAIL.TIMING.VAL.X_NUM(DETAIL), DETAIL.TIMING.VAL.Y1(DETAIL), num30.W, num30.H, num30.SPACE, num30.DOT, num30.EMPTY))
    dst[#dst+1] = {
        id = "stdDetailLabel", dst = {
            {x = DETAIL.TIMING.VAL.X_LABEL(DETAIL), y = DETAIL.TIMING.VAL.Y2(DETAIL), w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
        }
    }
    mergeSkin(skin, dstPercentage("timingStdDetailValue", "gray30Dot", "timingStdDetailValueAfterDot", "gray30Percent", 2, DETAIL.TIMING.VAL.X_NUM(DETAIL), DETAIL.TIMING.VAL.Y2(DETAIL), num30.W, num30.H, num30.SPACE, num30.DOT, num30.EMPTY))

    -- 全てにアニメーション用のタイマとxを設定
    do
        local moveTime = DETAIL.ANIMATION.MOVE_TIME
        local moveW = DETAIL.AREA.SHADOW_W
        for i = 1, #dst do
            local d = dst[i]
            local toX = d.dst[1].x
            local fromX = toX - moveW
            d.timer = CUSTOM_TIMERS_RESULT2.DETAIL_WND_TIMER
            d.loop = -1
            d.dst[1].time = 0
            d.dst[1].x = fromX
            d.dst[1].acc = 2
            d.dst[2] = {time = moveTime, x = toX}
            d.dst[3] = {time = DETAIL.ANIMATION.CLOSE_TIME, x = toX}
            d.dst[4] = {time = DETAIL.ANIMATION.CLOSE_TIME + moveTime, x = fromX}
            if d.id == "detailBokehBg" then
                d.dst[1].a = 0
                d.dst[2].a = 255
            end
        end
    end
    -- マウスdeスイッチ用の出力
    dst[#dst+1] = {
        id = "switchDetailWindowButton", dst = {
            {x = DETAIL.AREA.X, y = DETAIL.AREA.Y, w = DETAIL.AREA.W, h = DETAIL.AREA.H}
        }
    }
    return skin
end

return scoreDetail.functions