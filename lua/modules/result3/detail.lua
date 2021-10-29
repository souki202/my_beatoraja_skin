require("modules.commons.define")
local numberWithDepth = require("modules.result3.number_with_depth")


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
                    Y = 873,
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
                Y = 720,
                W = 11,
                H = 14,
            }
        },
        GR = {
            X = 192,
            Y = 655,
            W = 24,
            H = 28,
        },
        GD = {
            X = 192,
            Y = 611,
            W = 24,
            H = 28,
        },
        BD = {
            X = 192,
            Y = 567,
            W = 24,
            H = 29,
        },
        PR = {
            X = 192,
            Y = 522,
            W = 24,
            H = 29,
        },
        MS = {
            X = 192,
            Y = 478,
            W = 24,
            H = 29,
        },
    },
}

local detail = {
    functions = {},

    exscoreValue = numberWithDepth.create(
        "exscoreValue",
        51, -- src id
        DETAIL.SCORE.EXSCORE.W, DETAIL.SCORE.EXSCORE.H,
        11, 5, 71, -- divx, maxdigit, ref
        {43, 85, 125, 162}, {-1, -2, -3, -4},
        0, false -- align isfillzero
    ),
    exscorePercentIntegerValue = numberWithDepth.create(
        "exscorePercentIntegerValue",
        52,
        DETAIL.SCORE.EXSCORE.PERCENT.INTEGER.W, DETAIL.SCORE.EXSCORE.PERCENT.INTEGER.H,
        11, 3, 102,
        {15, 35}, {-1, -2},
        0, false
    ),
    exscorePercentAfterDotValue = numberWithDepth.create(
        "exscorePercentAfterDotValue",
        53,
        DETAIL.SCORE.EXSCORE.PERCENT.AFTER_DOT.W, DETAIL.SCORE.EXSCORE.PERCENT.AFTER_DOT.H,
        11, 2, 103,
        {19}, {0},
        0, true
    ),
    bestScoreValue = numberWithDepth.create(
        "bestScoreValue",
        54,
        DETAIL.SCORE.BEST.W, DETAIL.SCORE.BEST.H,
        11, 5, 150,
        {30, 60, 88, 115}, {1, 1, 1, 2},
        0, false
    ),
    bestScoreDiffValue = numberWithDepth.create(
        "bestScoreDiffValue",
        55,
        DETAIL.SCORE.BEST.DIFF.W, DETAIL.SCORE.BEST.DIFF.H,
        12, 6, 152,
        {18, 35, 52, 69, 85}, {0, 1, 1, 1, 2},
        0, false
    ),
    targetScoreValue = numberWithDepth.create(
        "targetScoreValue",
        56,
        DETAIL.SCORE.TARGET.W, DETAIL.SCORE.TARGET.H,
        11, 5, 151,
        {30, 60, 88, 115}, {1, 2, 3, 4},
        0, false
    ),
    targetScoreDiffValue = numberWithDepth.create(
        "targetScoreDiffValue",
        57,
        DETAIL.SCORE.TARGET.DIFF.W, DETAIL.SCORE.TARGET.DIFF.H,
        12, 6, 153,
        {18, 35, 52, 69, 85}, {1, 2, 3, 3, 4},
        0, false
    ),
    judgePfValue = numberWithDepth.create(
        "judgePfValue",
        58,
        DETAIL.JUDGES.PF.W, DETAIL.JUDGES.PF.H,
        11, 5, 110,
        {26, 50, 75, 97}, {2, 4, 6, 8},
        0, false
    ),
    judgeGrValue = numberWithDepth.create(
        "judgeGrValue",
        59,
        DETAIL.JUDGES.GR.W, DETAIL.JUDGES.GR.H,
        11, 5, 111,
        {26, 50, 75, 97}, {3, 6, 9, 12},
        0, false
    ),
    judgeGdValue = numberWithDepth.create(
        "judgeGdValue",
        60,
        DETAIL.JUDGES.GD.W, DETAIL.JUDGES.GD.H,
        11, 5, 112,
        {26, 50, 75, 97}, {4, 8, 12, 15},
        0, false
    ),
    judgeBdValue = numberWithDepth.create(
        "judgeBdValue",
        61,
        DETAIL.JUDGES.BD.W, DETAIL.JUDGES.BD.H,
        11, 5, 113,
        {26, 50, 75, 97}, {4, 8, 13, 17},
        0, false
    ),
    judgePrValue = numberWithDepth.create(
        "judgePrValue",
        62,
        DETAIL.JUDGES.PR.W, DETAIL.JUDGES.PR.H,
        11, 5, 114,
        {26, 50, 75, 97}, {5, 10, 15, 19},
        0, false
    ),
    judgeMsValue = numberWithDepth.create(
        "judgeMsValue",
        63,
        DETAIL.JUDGES.MS.W, DETAIL.JUDGES.MS.H,
        11, 5, 420,
        {26, 50, 75, 97}, {6, 12, 18, 23},
        0, false
    ),
    judgePfFastValue = numberWithDepth.create(
        "judgePfFastValue",
        70,
        DETAIL.JUDGES.PF.F.W, DETAIL.JUDGES.PF.F.H,
        11, 4, 410,
        {12, 23, 35}, {1, 2, 3},
        0, false
    ),
    judgePfSlowValue = numberWithDepth.create(
        "judgePfSlowValue",
        71,
        DETAIL.JUDGES.PF.S.W, DETAIL.JUDGES.PF.S.H,
        11, 4, 411,
        {11, 22, 32}, {1, 2, 3},
        0, false
    ),
}

detail.functions.load = function ()
    local skin = {
        image = {
            {id = "scoreFrame", src = 1, x = 0, y = 0, w = -1, h = -1},
            {id = "judgesFrame", src = 2, x = 0, y = 0, w = -1, h = -1},
            {id = "exscorePercentDot", src = 3, x = 0, y = 0, w = DETAIL.SCORE.EXSCORE.PERCENT.DOT.W, h = DETAIL.SCORE.EXSCORE.PERCENT.DOT.H},
            {id = "exscorePercentPercent", src = 3, x = 4, y = 0, w = DETAIL.SCORE.EXSCORE.PERCENT.PERCENT.W, h = DETAIL.SCORE.EXSCORE.PERCENT.PERCENT.H},
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
        }
    }

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

    return skin
end

return detail.functions
