require("modules.result.commons")
require("modules.result2.commons")
local main_state = require("main_state")
local judges = require("modules.result2.judges")

local scoreDetail = {
    functions = {}
}

local DETAIL = {
    AREA = {
        X = 0,
        Y = 0,
        W = 960,
        H = HEIGHT,
        DIMMER_ALPHA = 90,
    },

    LABEL = {
        W = 120,
        H = 32,
        RATE = {
            Y = 1027,
        },
        JUDGE = {
            Y = 988
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
        H = 36
    },
    EXSCORE = {
        W = 256,
        H = 44,
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

    TIMING = {
        LABEL = {
            W = 162,
            H = 32,
        }
    },
    GRAY_30NUM = {
        W = 24,
        H = 31,
        SPACE = -9,
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
        }
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
    }
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


scoreDetail.functions.load = function ()
    local totalNotes = main_state.number(74)
    local theoretical = totalNotes * 2
    -- 判定文字は読み込み済み
    -- 各判定合計数字も読み込み済み

    local skin = {
        image = {
            {id = "detailBokehBg", src = getBokehBgSrc(), x = 0, y = HEIGHT - DETAIL.AREA.Y - DETAIL.AREA.H, w = DETAIL.AREA.W, h = DETAIL.AREA.H},
            {id = "gray30Dot", src = 15, x = 288, y = 235, w = DETAIL.GRAY_30NUM.DOT.W, h = DETAIL.GRAY_30NUM.DOT.H},
            {id = "gray30Percent", src = 15, x = 336, y = 216, w = DETAIL.GRAY_30NUM.PERCENT.W, h = DETAIL.GRAY_30NUM.PERCENT.H},
            -- ヘッダ読み込み 数が少ないので普通に.
            {id = "totalNotesDetailHeader" , src = 14, x = 0, y = DETAIL.HEADER.H * 0, w = DETAIL.HEADER.W, h = DETAIL.HEADER.H},
            {id = "maxComboDetailHeader"   , src = 14, x = 0, y = DETAIL.HEADER.H * 1, w = DETAIL.HEADER.W, h = DETAIL.HEADER.H},
            {id = "missCountDetailHeader"  , src = 14, x = 0, y = DETAIL.HEADER.H * 2, w = DETAIL.HEADER.W, h = DETAIL.HEADER.H},
            {id = "targetScoreDetailHeader", src = 14, x = 0, y = DETAIL.HEADER.H * 3, w = DETAIL.HEADER.W, h = DETAIL.HEADER.H},
            {id = "exScoreDetailHeader"    , src = 14, x = 0, y = DETAIL.HEADER.H * 4, w = DETAIL.EXSCORE.W, h = DETAIL.EXSCORE.H},
        },
        value = {}
    }
    local imgs = skin.image
    local vals = skin.value

    -- ラベル群の読み込み
    do
        local prefix = {"early", "late", "rate", "score", "num", "best", "diff", "rate"}
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
    vals[#vals+1] = {id = "comboDiffDetailValue", src = 15, x = 0, y = 72, w = DETAIL.GRAY_36NUM.W * 12, h = DETAIL.GRAY_36NUM.H * 2, divx = 12, divy = 2, digit = 5, ref = 175}
    -- bp
    vals[#vals+1] = scoreDetail.functions.loadGray48Number("comboDetailValue", 5, 0, 76, nil)
    vals[#vals+1] = scoreDetail.functions.loadGray36Number("comboOldDetailValue", 5, 0, 176, nil)
    vals[#vals+1] = {id = "comboDiffDetailValue", src = 15, x = 0, y = 144, w = DETAIL.GRAY_36NUM.W * 12, h = DETAIL.GRAY_36NUM.H * 2, divx = 12, divy = 2, digit = 5, ref = 176}
    -- EXSCORE
    vals[#vals+1] = {id = "exScoreDetailValue", src = 17, x = 0, y = 0, w = judges.getLargeNumSize().W * 10, h = judges.getLargeNumSize().H, divx = 10, digit = 5, space = judges.getLargeNumSize().SPACE, ref = 71}
    vals[#vals+1] = scoreDetail.functions.loadGray48Number("bestScoreDetailValue", 5, 0, 170, nil)
    vals[#vals+1] = scoreDetail.functions.loadGray30Number("exScoreRateDetailValue", 5, 0, 0, 102, nil)
    vals[#vals+1] = scoreDetail.functions.loadGray30Number("exScoreRateAfterDotDetailValue", 5, 0, 1, 103, nil)

    -- ベストスコア
    vals[#vals+1] = {id = "bestDiffDetailValue", src = 15, x = 0, y = 72, w = DETAIL.GRAY_36NUM.W * 12, h = DETAIL.GRAY_36NUM.H * 2, divx = 12, divy = 2, digit = 5, ref = 172}
    -- ターゲットスコア
    vals[#vals+1] = scoreDetail.functions.loadGray48Number("targetScoreDetailValue", 5, 0, 151, nil)
    vals[#vals+1] = {id = "targetDiffDetailValue", src = 15, x = 0, y = 72, w = DETAIL.GRAY_36NUM.W * 12, h = DETAIL.GRAY_36NUM.H * 2, divx = 12, divy = 2, digit = 5, ref = 153}
    vals[#vals+1] = scoreDetail.functions.loadGray30Number("targetScoreRateDetailValue", 5, 0, 0, 122, nil)
    vals[#vals+1] = scoreDetail.functions.loadGray30Number("targetScoreRateAfterDotDetailValue", 5, 1, 0, 123, nil)

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
                id = "black", dst = {
                    {x = DETAIL.AREA.X, y = DETAIL.AREA.Y, w = DETAIL.AREA.W, h = DETAIL.AREA.H, a = DETAIL.AREA.DIMMER_ALPHA}
                }
            },
            -- 上部のラベルから
            {
                id = "rateDetailLabel", dst = {
                    {x = DETAIL.COL.X(DETAIL, 3.5), y = DETAIL.LABEL.RATE.Y, w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
                }
            },
            {
                id = "earlyDetailLabel", dst = {
                    {x = DETAIL.COL.X(DETAIL, 1), y = DETAIL.LABEL.JUDGE.Y, w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
                }
            },
            {
                id = "lateDetailLabel", dst = {
                    {x = DETAIL.COL.X(DETAIL, 2), y = DETAIL.LABEL.JUDGE.Y, w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
                }
            },
            {
                id = "numDetailLabel", dst = {
                    {x = DETAIL.COL.X(DETAIL, 3), y = DETAIL.LABEL.JUDGE.Y, w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
                }
            },
            {
                id = "scoreDetailLabel", dst = {
                    {x = DETAIL.COL.X(DETAIL, 4), y = DETAIL.LABEL.JUDGE.Y, w = DETAIL.LABEL.W, h = DETAIL.LABEL.H}
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

    -- 全てにアニメーション用のタイマとxを設定
    for i, v in ipairs(skin.destination) do
        
    end
    return skin
end

return scoreDetail.functions