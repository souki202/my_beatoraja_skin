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
            H = 40,
            PERCENT = {
                INTEGER = {
                    X = 245,
                    Y = 871,
                    W = 21,
                    H = 22,
                },
                DOT = {
                    X = 300,
                    Y = 872,
                    W = 4,
                    H = 5,
                },
                AFTER_DOT = {
                    X = 306,
                    Y = 870,
                    W = 21,
                    H = 22,
                },
                PERCENT = {
                    X = 344,
                    Y = 871,
                    W = 14,
                    H = 22,
                }
            },
        },
    },
    JUDGES = {
        FRAME = {
            X = 0,
            Y = 439,
            W = 183,
            H = 280,
        },
    },
}

local detail = {
    functions = {},

    exscoreValue = numberWithDepth.create(
        "exscoreValue",
        51,
        DETAIL.SCORE.EXSCORE.W, DETAIL.SCORE.EXSCORE.H,
        11, 5,
        71,
        {43, 84, 124, 162}, {-1, -2, -3, -4},
        0, false
    ),
    exscorePercentIntegerValue = numberWithDepth.create(
        "exscorePercentIntegerValue",
        52,
        DETAIL.SCORE.EXSCORE.PERCENT.INTEGER.W, DETAIL.SCORE.EXSCORE.PERCENT.INTEGER.H,
        11, 3, 102,
        {15, 35}, {-1, -1},
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
}

detail.functions.load = function ()
    local skin = {
        image = {
            {id = "scoreFrame", src = 1, x = 0, y = 0, w = -1, h = -1},
            {id = "judgesFrame", src = 2, x = 0, y = 0, w = -1, h = -1},
            {id = "exscorePercentDot", src = 52, x = 0, y = 105, w = DETAIL.SCORE.EXSCORE.PERCENT.DOT.W, h = DETAIL.SCORE.EXSCORE.PERCENT.DOT.H},
            {id = "exscorePercentPercent", src = 52, x = 4, y = 88, w = DETAIL.SCORE.EXSCORE.PERCENT.PERCENT.W, h = DETAIL.SCORE.EXSCORE.PERCENT.PERCENT.H},
        }
    }

    mergeSkin(skin, detail.exscoreValue.load())
    mergeSkin(skin, detail.exscorePercentIntegerValue.load())
    mergeSkin(skin, detail.exscorePercentAfterDotValue.load())
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

    return skin
end

return detail.functions
