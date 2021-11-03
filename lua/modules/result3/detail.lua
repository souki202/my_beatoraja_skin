require("modules.commons.define")
local numberWithDepth = require("modules.result3.number_with_depth")
local main_state = require("main_state")

local DETAIL = {
    SCORE = {
        FRAME = {
            X = 0,
            Y = 318,
            W = 162,
            H = 641,
        },
        EXSCORE = {
            X = 45,
            Y = 872,
            W = 40,
            H = 39,
            PERCENT = {
                INTEGER = {
                    X = 245,
                    Y = 873,
                    W = 19,
                    H = 21,
                },
                DOT = {
                    X = 300,
                    Y = 871,
                    W = 4,
                    H = 5,
                },
                AFTER_DOT = {
                    X = 306,
                    Y = 872,
                    W = 18,
                    H = 20,
                },
                PERCENT = {
                    X = 344,
                    Y = 871,
                    W = 14,
                    H = 22,
                }
            },
        },
        BEST = {
            X = 127,
            Y = 826,
            W = 28,
            H = 28,
            DIFF = {
                X = 267,
                Y = 830,
                W = 17,
                H = 18,
            },
        },
        TARGET = {
            X = 127,
            Y = 778,
            W = 28,
            H = 30,
            DIFF = {
                X = 267,
                Y = 787,
                W = 17,
                H = 18,
            }
        }
    },
    JUDGES = {
        FRAME = {
            X = 0,
            Y = 439,
            W = 183,
            H = 280,
        },
        GRAPH = {
            W = 388,
            H = 100,
            SEPARATORS = {0, 50, 95, 139, 180, 219, 257, 293, 326, 359, 388}, -- 10%ごとの幅
            PF = {
                X = 31,
                Y = 677
            },
            GR = {
                X = 31,
                Y = 677 - 49,
            },
            GD = {
                X = 31,
                Y = 677 - 49 * 2
            },
            BD = {
                X = 31,
                Y = 677 - 49 * 3
            },
            PR = {
                X = 31,
                Y = 677 - 49 * 4
            },
            MS = {
                X = 31,
                Y = 677 - 49 * 5
            },
        },
        PF = {
            X = 192,
            Y = 700,
            W = 23,
            H = 27,
            F = {
                X = 324,
                Y = 714,
                W = 11,
                H = 14,
            },
            S = {
                X = 376,
                Y = 719,
                W = 11,
                H = 14,
            },
            SLUSH = {
                X = 370,
                Y = 719,
                W = 6,
                H = 15,
            },
        },
        GR = {
            X = 192,
            Y = 655,
            W = 24,
            H = 28,
            F = {
                X = 324,
                Y = 673,
                W = 11,
                H = 15,
                DX = {12, 24, 35},
                DY = {1, 3, 4},
            },
            S = {
                X = 376,
                Y = 680,
                W = 11,
                H = 15,
                DX = {11, 22, 33},
                DY = {1, 2, 4},
            },
            SLUSH = {
                X = 370,
                Y = 680,
                W = 6,
                H = 15,
            },
        },
        GD = {
            X = 192,
            Y = 611,
            W = 24,
            H = 28,
            F = {
                X = 324,
                Y = 633,
                W = 11,
                H = 16,
                DX = {12, 24, 35},
                DY = {1, 3, 5},
            },
            S = {
                X = 376,
                Y = 642,
                W = 11,
                H = 15,
                DX = {11, 22, 33},
                DY = {1, 3, 5},
            },
            SLUSH = {
                X = 370,
                Y = 640,
                W = 6,
                H = 15,
            },
        },
        BD = {
            X = 192,
            Y = 567,
            W = 24,
            H = 29,
            F = {
                X = 324,
                Y = 592,
                W = 11,
                H = 15,
                DX = {12, 24, 35},
                DY = {2, 4, 7},
            },
            S = {
                X = 376,
                Y = 603,
                W = 11,
                H = 15,
                DX = {11, 22, 33},
                DY = {2, 4, 6},
            },
            SLUSH = {
                X = 370,
                Y = 601,
                W = 6,
                H = 15,
            },
        },
        PR = {
            X = 192,
            Y = 522,
            W = 24,
            H = 29,
            F = {
                X = 324,
                Y = 552,
                W = 11,
                H = 16,
                DX = {12, 24, 35},
                DY = {2, 5, 7},
            },
            S = {
                X = 376,
                Y = 564,
                W = 11,
                H = 15,
                DX = {11, 22, 33},
                DY = {2, 5, 7},
            },
            SLUSH = {
                X = 370,
                Y = 562,
                W = 6,
                H = 15,
            },
        },
        MS = {
            X = 192,
            Y = 478,
            W = 24,
            H = 29,
            F = {
                X = 324,
                Y = 511,
                W = 11,
                H = 16,
                DX = {12, 24, 35},
                DY = {2, 5, 8},
            },
            S = {
                X = 376,
                Y = 525,
                W = 11,
                H = 15,
                DX = {11, 22, 33},
                DY = {3, 5, 8},
            },
            SLUSH = {
                X = 370,
                Y = 523,
                W = 6,
                H = 15,
            },
        },
    },
    COMBO = {
        X = 191,
        Y = 409,
        W = 24,
        H = 31,
        DX = {26, 50, 73, 96},
        DY = {7, 13, 19, 26},
        DIFF = {
            X = 321,
            Y = 446,
            W = 16,
            H = 22,
            DX = {17, 33, 49, 65},
            DY = {5, 9, 13, 18},
        },
    },
    BP = {
        X = 191,
        Y = 370,
        W = 24,
        H = 31,
        DX = {26, 50, 73, 96},
        DY = {8, 15, 22, 28},
        DIFF = {
            X = 321,
            Y = 411,
            W = 16,
            H = 21,
            DX = {17, 33, 49, 65},
            DY = {5, 10, 15, 20},
        },
    }
}

local detail = {
    functions = {},

    exscoreValue = numberWithDepth.create(
        51, -- src id
        DETAIL.SCORE.EXSCORE.W, DETAIL.SCORE.EXSCORE.H,
        11, 5, 71, -- divx, maxdigit, ref
        {43, 85, 125, 162}, {-1, -2, -3, -4},
        0, false -- align isfillzero
    ),
    exscorePercentIntegerValue = numberWithDepth.create(
        52,
        DETAIL.SCORE.EXSCORE.PERCENT.INTEGER.W, DETAIL.SCORE.EXSCORE.PERCENT.INTEGER.H,
        11, 3, 102,
        {15, 35}, {-1, -2},
        0, false
    ),
    exscorePercentAfterDotValue = numberWithDepth.create(
        53,
        DETAIL.SCORE.EXSCORE.PERCENT.AFTER_DOT.W, DETAIL.SCORE.EXSCORE.PERCENT.AFTER_DOT.H,
        11, 2, 103,
        {19}, {0},
        0, true
    ),
    bestScoreValue = numberWithDepth.create(
        54,
        DETAIL.SCORE.BEST.W, DETAIL.SCORE.BEST.H,
        11, 5, 150,
        {30, 60, 88, 115}, {1, 1, 1, 2},
        0, false
    ),
    bestScoreDiffValue = numberWithDepth.create(
        55,
        DETAIL.SCORE.BEST.DIFF.W, DETAIL.SCORE.BEST.DIFF.H,
        12, 6, 152,
        {18, 35, 52, 69, 85}, {0, 1, 1, 1, 2},
        0, false
    ),
    targetScoreValue = numberWithDepth.create(
        56,
        DETAIL.SCORE.TARGET.W, DETAIL.SCORE.TARGET.H,
        11, 5, 151,
        {30, 60, 88, 115}, {1, 2, 3, 4},
        0, false
    ),
    targetScoreDiffValue = numberWithDepth.create(
        57,
        DETAIL.SCORE.TARGET.DIFF.W, DETAIL.SCORE.TARGET.DIFF.H,
        12, 6, 153,
        {18, 35, 52, 69, 85}, {1, 2, 3, 3, 4},
        0, false
    ),
    judgePfValue = numberWithDepth.create(
        58,
        DETAIL.JUDGES.PF.W, DETAIL.JUDGES.PF.H,
        11, 5, 110,
        {26, 50, 75, 98}, {2, 4, 6, 8},
        0, false
    ),
    judgeGrValue = numberWithDepth.create(
        59,
        DETAIL.JUDGES.GR.W, DETAIL.JUDGES.GR.H,
        11, 5, 111,
        {26, 50, 75, 97}, {3, 6, 9, 12},
        0, false
    ),
    judgeGdValue = numberWithDepth.create(
        60,
        DETAIL.JUDGES.GD.W, DETAIL.JUDGES.GD.H,
        11, 5, 112,
        {26, 50, 75, 97}, {3, 7, 11, 14},
        0, false
    ),
    judgeBdValue = numberWithDepth.create(
        61,
        DETAIL.JUDGES.BD.W, DETAIL.JUDGES.BD.H,
        11, 5, 113,
        {26, 50, 75, 97}, {4, 8, 13, 17},
        0, false
    ),
    judgePrValue = numberWithDepth.create(
        62,
        DETAIL.JUDGES.PR.W, DETAIL.JUDGES.PR.H,
        11, 5, 114,
        {26, 50, 75, 97}, {5, 10, 15, 19},
        0, false
    ),
    judgeMsValue = numberWithDepth.create(
        63,
        DETAIL.JUDGES.MS.W, DETAIL.JUDGES.MS.H,
        11, 5, 420,
        {26, 50, 75, 97}, {6, 12, 18, 23},
        0, false
    ),
    judgePfFastValue = numberWithDepth.create(
        70,
        DETAIL.JUDGES.PF.F.W, DETAIL.JUDGES.PF.F.H,
        11, 4, 410,
        {12, 23, 35}, {1, 2, 3},
        0, false
    ),
    judgePfSlowValue = numberWithDepth.create(
        71,
        DETAIL.JUDGES.PF.S.W, DETAIL.JUDGES.PF.S.H,
        11, 4, 411,
        {11, 22, 32}, {1, 2, 3},
        0, false
    ),
    judgeGrFastValue = numberWithDepth.create(
        72,
        DETAIL.JUDGES.GR.F.W, DETAIL.JUDGES.GR.F.H,
        11, 4, 412,
        DETAIL.JUDGES.GR.F.DX, DETAIL.JUDGES.GR.F.DY,
        0, false
    ),
    judgeGrSlowValue = numberWithDepth.create(
        73,
        DETAIL.JUDGES.GR.S.W, DETAIL.JUDGES.GR.S.H,
        11, 4, 413,
        DETAIL.JUDGES.GR.S.DX, DETAIL.JUDGES.GR.S.DY,
        0, false
    ),
    judgeGdFastValue = numberWithDepth.create(
        74,
        DETAIL.JUDGES.GD.F.W, DETAIL.JUDGES.GD.F.H,
        11, 4, 414,
        DETAIL.JUDGES.GD.F.DX, DETAIL.JUDGES.GD.F.DY,
        0, false
    ),
    judgeGdSlowValue = numberWithDepth.create(
        75,
        DETAIL.JUDGES.GD.S.W, DETAIL.JUDGES.GD.S.H,
        11, 4, 415,
        DETAIL.JUDGES.GD.S.DX, DETAIL.JUDGES.GD.S.DY,
        0, false
    ),
    judgeBdFastValue = numberWithDepth.create(
        76,
        DETAIL.JUDGES.BD.F.W, DETAIL.JUDGES.BD.F.H,
        11, 4, 416,
        DETAIL.JUDGES.BD.F.DX, DETAIL.JUDGES.BD.F.DY,
        0, false
    ),
    judgeBdSlowValue = numberWithDepth.create(
        77,
        DETAIL.JUDGES.BD.S.W, DETAIL.JUDGES.BD.S.H,
        11, 4, 417,
        DETAIL.JUDGES.BD.S.DX, DETAIL.JUDGES.BD.S.DY,
        0, false
    ),
    judgePrFastValue = numberWithDepth.create(
        78,
        DETAIL.JUDGES.PR.F.W, DETAIL.JUDGES.PR.F.H,
        11, 4, 418,
        DETAIL.JUDGES.PR.F.DX, DETAIL.JUDGES.PR.F.DY,
        0, false
    ),
    judgePrSlowValue = numberWithDepth.create(
        79,
        DETAIL.JUDGES.PR.S.W, DETAIL.JUDGES.PR.S.H,
        11, 4, 419,
        DETAIL.JUDGES.PR.S.DX, DETAIL.JUDGES.PR.S.DY,
        0, false
    ),
    judgeMsFastValue = numberWithDepth.create(
        80,
        DETAIL.JUDGES.MS.F.W, DETAIL.JUDGES.MS.F.H,
        11, 4, 421,
        DETAIL.JUDGES.MS.F.DX, DETAIL.JUDGES.MS.F.DY,
        0, false
    ),
    judgeMsSlowValue = numberWithDepth.create(
        81,
        DETAIL.JUDGES.MS.S.W, DETAIL.JUDGES.MS.S.H,
        11, 4, 422,
        DETAIL.JUDGES.MS.S.DX, DETAIL.JUDGES.MS.S.DY,
        0, false
    ),
    comboValue = numberWithDepth.create(
        82,
        DETAIL.COMBO.W, DETAIL.COMBO.H,
        11, 5, 75,
        DETAIL.COMBO.DX, DETAIL.COMBO.DY,
        0, false
    ),
    comboDiffValue = numberWithDepth.create(
        83,
        DETAIL.COMBO.DIFF.W, DETAIL.COMBO.DIFF.H,
        12, 5, 175,
        DETAIL.COMBO.DIFF.DX, DETAIL.COMBO.DIFF.DY,
        0, false
    ),
    bpValue = numberWithDepth.create(
        84,
        DETAIL.BP.W, DETAIL.BP.H,
        11, 5, 76,
        DETAIL.BP.DX, DETAIL.BP.DY,
        0, false
    ),
    bpDiffValue = numberWithDepth.create(
        85,
        DETAIL.BP.DIFF.W, DETAIL.BP.DIFF.H,
        12, 5, 178,
        DETAIL.BP.DIFF.DX, DETAIL.BP.DIFF.DY,
        0, false
    ),
    fsGraph = {
        pf = {fastW = 0},
        gr = {fastW = 0},
        gd = {fastW = 0},
        bd = {fastW = 0},
        pr = {fastW = 0},
        ms = {fastW = 0},
    }
}

detail.functions.load = function ()
    local skin = {
        image = {
            {id = "scoreFrame", src = 1, x = 0, y = 0, w = -1, h = -1},
            {id = "judgesFrame", src = 2, x = 0, y = 0, w = -1, h = -1},
            {id = "exscorePercentDot", src = 3, x = 0, y = 0, w = DETAIL.SCORE.EXSCORE.PERCENT.DOT.W, h = DETAIL.SCORE.EXSCORE.PERCENT.DOT.H},
            {id = "exscorePercentPercent", src = 3, x = 4, y = 0, w = DETAIL.SCORE.EXSCORE.PERCENT.PERCENT.W, h = DETAIL.SCORE.EXSCORE.PERCENT.PERCENT.H},

            {id = "pfFsSlush", src = 3, x = 21, y = 0, w = DETAIL.JUDGES.PF.SLUSH.W, h = DETAIL.JUDGES.PF.SLUSH.H},
            {id = "grFsSlush", src = 3, x = 21 + DETAIL.JUDGES.PF.SLUSH.W, y = 0, w = DETAIL.JUDGES.GR.SLUSH.W, h = DETAIL.JUDGES.GR.SLUSH.H},
            {id = "gdFsSlush", src = 3, x = 21 + DETAIL.JUDGES.GR.SLUSH.W, y = 0, w = DETAIL.JUDGES.GD.SLUSH.W, h = DETAIL.JUDGES.GD.SLUSH.H},
            {id = "bdFsSlush", src = 3, x = 21 + DETAIL.JUDGES.GD.SLUSH.W, y = 0, w = DETAIL.JUDGES.BD.SLUSH.W, h = DETAIL.JUDGES.BD.SLUSH.H},
            {id = "prFsSlush", src = 3, x = 21 + DETAIL.JUDGES.BD.SLUSH.W, y = 0, w = DETAIL.JUDGES.PR.SLUSH.W, h = DETAIL.JUDGES.PR.SLUSH.H},
            {id = "msFsSlush", src = 3, x = 21 + DETAIL.JUDGES.PR.SLUSH.W, y = 0, w = DETAIL.JUDGES.MS.SLUSH.W, h = DETAIL.JUDGES.MS.SLUSH.H},
        }
    }

    mergeSkin(skin, detail.exscoreValue.load())
    mergeSkin(skin, detail.exscorePercentIntegerValue.load())
    mergeSkin(skin, detail.exscorePercentAfterDotValue.load())
    mergeSkin(skin, detail.bestScoreValue.load())
    mergeSkin(skin, detail.bestScoreDiffValue.load())
    mergeSkin(skin, detail.targetScoreValue.load())
    mergeSkin(skin, detail.targetScoreDiffValue.load())

    mergeSkin(skin, detail.judgePfValue.load())
    mergeSkin(skin, detail.judgeGrValue.load())
    mergeSkin(skin, detail.judgeGdValue.load())
    mergeSkin(skin, detail.judgeBdValue.load())
    mergeSkin(skin, detail.judgePrValue.load())
    mergeSkin(skin, detail.judgeMsValue.load())

    mergeSkin(skin, detail.judgePfFastValue.load())
    mergeSkin(skin, detail.judgePfSlowValue.load())
    mergeSkin(skin, detail.judgeGrFastValue.load())
    mergeSkin(skin, detail.judgeGrSlowValue.load())
    mergeSkin(skin, detail.judgeGdFastValue.load())
    mergeSkin(skin, detail.judgeGdSlowValue.load())
    mergeSkin(skin, detail.judgeBdFastValue.load())
    mergeSkin(skin, detail.judgeBdSlowValue.load())
    mergeSkin(skin, detail.judgePrFastValue.load())
    mergeSkin(skin, detail.judgePrSlowValue.load())
    mergeSkin(skin, detail.judgeMsFastValue.load())
    mergeSkin(skin, detail.judgeMsSlowValue.load())

    mergeSkin(skin, detail.comboValue.load())
    mergeSkin(skin, detail.comboDiffValue.load())
    mergeSkin(skin, detail.bpValue.load())
    mergeSkin(skin, detail.bpDiffValue.load())

    -- judgeのfsの棒の大きさ計算. 3次元から遠近法で計算するのはややこしいっぽいので10%ごとに線形で近似する
    -- slowは無条件で幅100で良いので, fastだけ計算
    local prefix = {"PF", "GR", "GD", "BD", "PR", "MS"}
    local lowerIdPrefix = {"pf", "gr", "gd", "bd", "pr", "ms"}
    local tref = {110, 111, 112, 113, 114, 420}
    local fref = {410, 412, 414, 416, 418, 421}
    -- local sref = {411, 413, 415, 417, 419, 422}
    local imgs = skin.image
    for i = 1, #prefix do
        local fast = main_state.number(fref[i])
        local total = main_state.number(tref[i])
        local w = 0

        -- fastの幅の計算
        if (fast == total) then
            w = DETAIL.JUDGES.GRAPH.W
        else
            local p = (100 * fast / total)
            local separatorIdx = math.floor(p / 10) + 1
            local remainder = p % 10
            local l = DETAIL.JUDGES.GRAPH.SEPARATORS[separatorIdx]
            local r = DETAIL.JUDGES.GRAPH.SEPARATORS[separatorIdx + 1]
            w = l + (r - l) * remainder / 10
        end

        detail.fsGraph[lowerIdPrefix[i]].fastW = w

        local y = DETAIL.JUDGES.GRAPH.H * (i - 1)
        imgs[#imgs+1] = {
            id = lowerIdPrefix[i] .. "FsGraphFast", src = 90, x = 0, y = y,
            w = w, h = DETAIL.JUDGES.GRAPH.H
        }
        imgs[#imgs+1] = {
            id = lowerIdPrefix[i] .. "FsGraphSlow", src = 90, x = DETAIL.JUDGES.GRAPH.W, y = y,
            w = DETAIL.JUDGES.GRAPH.W, h = DETAIL.JUDGES.GRAPH.H
        }
    end

    return skin
end

detail.functions.dst = function ()
    local skin = {
        destination = {
            {
                id = "scoreFrame", dst = {
                    {x = DETAIL.SCORE.FRAME.X, y = DETAIL.SCORE.FRAME.Y, w = DETAIL.SCORE.FRAME.W, h = DETAIL.SCORE.FRAME.H}
                }
            },
            {
                id = "judgesFrame", dst = {
                    {x = DETAIL.JUDGES.FRAME.X, y = DETAIL.JUDGES.FRAME.Y, w = DETAIL.JUDGES.FRAME.W, h = DETAIL.JUDGES.FRAME.H}
                }
            },
            {
                id = "exscorePercentDot", dst = {
                    {x = DETAIL.SCORE.EXSCORE.PERCENT.DOT.X, y = DETAIL.SCORE.EXSCORE.PERCENT.DOT.Y, w = DETAIL.SCORE.EXSCORE.PERCENT.DOT.W, h = DETAIL.SCORE.EXSCORE.PERCENT.DOT.H}
                }
            },
            {
                id = "exscorePercentPercent", dst = {
                    {x = DETAIL.SCORE.EXSCORE.PERCENT.PERCENT.X, y = DETAIL.SCORE.EXSCORE.PERCENT.PERCENT.Y, w = DETAIL.SCORE.EXSCORE.PERCENT.PERCENT.W, h = DETAIL.SCORE.EXSCORE.PERCENT.PERCENT.H}
                }
            },
            {
                id = "pfFsSlush", dst = {
                    {x = DETAIL.JUDGES.PF.SLUSH.X, y = DETAIL.JUDGES.PF.SLUSH.Y, w = DETAIL.JUDGES.PF.SLUSH.W, h = DETAIL.JUDGES.PF.SLUSH.H}
                }
            },
            {
                id = "grFsSlush", dst = {
                    {x = DETAIL.JUDGES.GR.SLUSH.X, y = DETAIL.JUDGES.GR.SLUSH.Y, w = DETAIL.JUDGES.GR.SLUSH.W, h = DETAIL.JUDGES.GR.SLUSH.H}
                }
            },
            {
                id = "gdFsSlush", dst = {
                    {x = DETAIL.JUDGES.GD.SLUSH.X, y = DETAIL.JUDGES.GD.SLUSH.Y, w = DETAIL.JUDGES.GD.SLUSH.W, h = DETAIL.JUDGES.GD.SLUSH.H}
                }
            },
            {
                id = "bdFsSlush", dst = {
                    {x = DETAIL.JUDGES.BD.SLUSH.X, y = DETAIL.JUDGES.BD.SLUSH.Y, w = DETAIL.JUDGES.BD.SLUSH.W, h = DETAIL.JUDGES.BD.SLUSH.H}
                }
            },
            {
                id = "prFsSlush", dst = {
                    {x = DETAIL.JUDGES.PR.SLUSH.X, y = DETAIL.JUDGES.PR.SLUSH.Y, w = DETAIL.JUDGES.PR.SLUSH.W, h = DETAIL.JUDGES.PR.SLUSH.H}
                }
            },
            {
                id = "msFsSlush", dst = {
                    {x = DETAIL.JUDGES.MS.SLUSH.X, y = DETAIL.JUDGES.MS.SLUSH.Y, w = DETAIL.JUDGES.MS.SLUSH.W, h = DETAIL.JUDGES.MS.SLUSH.H}
                }
            }
        }
    }

    local dst = skin.destination

    -- exscoreとパーセンテージ
    mergeSkin(skin, detail.exscoreValue.dst(DETAIL.SCORE.EXSCORE.X, DETAIL.SCORE.EXSCORE.Y))
    mergeSkin(skin, detail.exscorePercentIntegerValue.dst(DETAIL.SCORE.EXSCORE.PERCENT.INTEGER.X, DETAIL.SCORE.EXSCORE.PERCENT.INTEGER.Y))
    mergeSkin(skin, detail.exscorePercentAfterDotValue.dst(DETAIL.SCORE.EXSCORE.PERCENT.AFTER_DOT.X, DETAIL.SCORE.EXSCORE.PERCENT.AFTER_DOT.Y))

    mergeSkin(skin, detail.bestScoreValue.dst(DETAIL.SCORE.BEST.X, DETAIL.SCORE.BEST.Y))
    mergeSkin(skin, detail.bestScoreDiffValue.dst(DETAIL.SCORE.BEST.DIFF.X, DETAIL.SCORE.BEST.DIFF.Y))
    mergeSkin(skin, detail.targetScoreValue.dst(DETAIL.SCORE.TARGET.X, DETAIL.SCORE.TARGET.Y))
    mergeSkin(skin, detail.targetScoreDiffValue.dst(DETAIL.SCORE.TARGET.DIFF.X, DETAIL.SCORE.TARGET.DIFF.Y))

    -- judges
    mergeSkin(skin, detail.judgePfValue.dst(DETAIL.JUDGES.PF.X, DETAIL.JUDGES.PF.Y))
    mergeSkin(skin, detail.judgeGrValue.dst(DETAIL.JUDGES.GR.X, DETAIL.JUDGES.GR.Y))
    mergeSkin(skin, detail.judgeGdValue.dst(DETAIL.JUDGES.GD.X, DETAIL.JUDGES.GD.Y))
    mergeSkin(skin, detail.judgeBdValue.dst(DETAIL.JUDGES.BD.X, DETAIL.JUDGES.BD.Y))
    mergeSkin(skin, detail.judgePrValue.dst(DETAIL.JUDGES.PR.X, DETAIL.JUDGES.PR.Y))
    mergeSkin(skin, detail.judgeMsValue.dst(DETAIL.JUDGES.MS.X, DETAIL.JUDGES.MS.Y))
    mergeSkin(skin, detail.judgePfFastValue.dst(DETAIL.JUDGES.PF.F.X, DETAIL.JUDGES.PF.F.Y))
    mergeSkin(skin, detail.judgePfSlowValue.dst(DETAIL.JUDGES.PF.S.X, DETAIL.JUDGES.PF.S.Y))
    mergeSkin(skin, detail.judgeGrFastValue.dst(DETAIL.JUDGES.GR.F.X, DETAIL.JUDGES.GR.F.Y))
    mergeSkin(skin, detail.judgeGrSlowValue.dst(DETAIL.JUDGES.GR.S.X, DETAIL.JUDGES.GR.S.Y))
    mergeSkin(skin, detail.judgeGdFastValue.dst(DETAIL.JUDGES.GD.F.X, DETAIL.JUDGES.GD.F.Y))
    mergeSkin(skin, detail.judgeGdSlowValue.dst(DETAIL.JUDGES.GD.S.X, DETAIL.JUDGES.GD.S.Y))
    mergeSkin(skin, detail.judgeBdFastValue.dst(DETAIL.JUDGES.BD.F.X, DETAIL.JUDGES.BD.F.Y))
    mergeSkin(skin, detail.judgeBdSlowValue.dst(DETAIL.JUDGES.BD.S.X, DETAIL.JUDGES.BD.S.Y))
    mergeSkin(skin, detail.judgePrFastValue.dst(DETAIL.JUDGES.PR.F.X, DETAIL.JUDGES.PR.F.Y))
    mergeSkin(skin, detail.judgePrSlowValue.dst(DETAIL.JUDGES.PR.S.X, DETAIL.JUDGES.PR.S.Y))
    mergeSkin(skin, detail.judgeMsFastValue.dst(DETAIL.JUDGES.MS.F.X, DETAIL.JUDGES.MS.F.Y))
    mergeSkin(skin, detail.judgeMsSlowValue.dst(DETAIL.JUDGES.MS.S.X, DETAIL.JUDGES.MS.S.Y))

    -- judgeのfsの棒
    local prefix = {"PF", "GR", "GD", "BD", "PR", "MS"}
    local lowerIdPrefix = {"pf", "gr", "gd", "bd", "pr", "ms"}
    for i = 1, #prefix do
        dst[#dst+1] = {
            id = lowerIdPrefix[i] .. "FsGraphSlow", dst = {
                {x = DETAIL.JUDGES.GRAPH[prefix[i]].X, y = DETAIL.JUDGES.GRAPH[prefix[i]].Y, w = DETAIL.JUDGES.GRAPH.W, h = DETAIL.JUDGES.GRAPH.H}
            }
        }
        dst[#dst+1] = {
            id = lowerIdPrefix[i] .. "FsGraphFast", dst = {
                {x = DETAIL.JUDGES.GRAPH[prefix[i]].X, y = DETAIL.JUDGES.GRAPH[prefix[i]].Y, w = detail.fsGraph[lowerIdPrefix[i]].fastW, h = DETAIL.JUDGES.GRAPH.H}
            }
        }
    end

    mergeSkin(skin, detail.comboValue.dst(DETAIL.COMBO.X, DETAIL.COMBO.Y))
    mergeSkin(skin, detail.comboDiffValue.dst(DETAIL.COMBO.DIFF.X, DETAIL.COMBO.DIFF.Y))
    mergeSkin(skin, detail.bpValue.dst(DETAIL.BP.X, DETAIL.BP.Y))
    mergeSkin(skin, detail.bpDiffValue.dst(DETAIL.BP.DIFF.X, DETAIL.BP.DIFF.Y))

    return skin
end

return detail.functions
