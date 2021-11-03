require("modules.commons.define")
local numberWithDepth = require("modules.result3.number_with_depth")
local main_state = require("main_state")

local DETAIL = {
    LAMP = {
        FROM = {
            X = 310,
            Y = 275,
            W = 109,
            H = 59,
        },
        TO = {
            X = 37,
            Y = 155,
            W = 233,
            H = 120,
        },
        ARROW = {
            X = 279,
            Y = 267,
            W = 21,
            H = 13,
        },
    },
    LN = {
        X = 182,
        Y = 120,
        W = 66,
        H = 100,
    },
    KEYS = {
        KEYS = {"7", "5", "14", "10", "9", "24", "48"},
        OP = {160, 161, 162, 163, 164, 1160, 1161},
        X = 262,
        Y = 163,
        W = 83,
        H = 103,
    },
    RANDOM = {
        X = 38,
        Y = 41,
        W = 127,
        H = 140,
    },
    NOTES = {
        X = 419,
        Y = 280,
        W = 12,
        H = 20,
        DX = {13, 25, 38, 49},
        DY = {6, 12, 18, 24},
        LABEL = {
            X = 358,
            Y = 252,
            W = 22,
            H = 20,
        },
    },
    DIFFICULTY = {
        X = 457,
        Y = 276,
        W = 11,
        H = 19,
        DX = {11},
        DY = {6},
        LABEL = {
            X = 358,
            Y = 223,
            W = 89,
            H = 59,
        },
    },
}

local detail = {
    functions = {},

    notesValue = numberWithDepth.create(
        86, -- src id
        DETAIL.NOTES.W, DETAIL.NOTES.H,
        11, 5, 106, -- divx, maxdigit, ref
        DETAIL.NOTES.DX, DETAIL.NOTES.DY,
        0, false -- align isfillzero
    ),
    difficultyValue = numberWithDepth.create(
        87, -- src id
        DETAIL.DIFFICULTY.W, DETAIL.DIFFICULTY.H,
        11, 2, 96, -- divx, maxdigit, ref
        DETAIL.DIFFICULTY.DX, DETAIL.DIFFICULTY.DY,
        0, false -- align isfillzero
    ),
}

detail.functions.load = function ()
    local skin = {
        image = {
            -- ランプ
            {id = "lampLabel", src = 11, x = 0, y = 0, w = -1, h = -1, divy = 11, len = 11, ref = 370},
            {id = "oldLampLabel", src = 10, x = 0, y = 0, w = -1, h = -1, divy = 11, len = 11, ref = 370},
            {id = "lampChangeArrow", src = 3, x = 59, y = 0, w = DETAIL.LAMP.ARROW.W, h = DETAIL.LAMP.ARROW.H},

            -- 設定
            {id = "lnModeLabel", src = 12, x = 0, y = 0, w = -1, h = -1, divy = 3, len = 3, ref = 308},
            {id = "randomModeLabel", src = 14, x = 0, y = 0, w = -1, h = -1, divy = 10, len = 10, ref = 42},

            {id = "notesLabel", src = 15, x = 0, y = 0, w = -1, h = -1},
            {id = "difficultyLabel", src = 16, x = 0, y = 0, w = -1, h = -1},
        }
    }
    local imgs = skin.image
    -- keys
    do
        for i = 1, #DETAIL.KEYS.KEYS do
            if main_state.option(DETAIL.KEYS.OP[i]) then
                imgs[#imgs+1] = {id = "keysLabel", src = 13, x = 0, y = DETAIL.KEYS.H * (i - 1), w = -1, h = DETAIL.KEYS.H}
            end
        end
    end
    mergeSkin(skin, detail.notesValue.load())
    mergeSkin(skin, detail.difficultyValue.load())

    return skin
end

detail.functions.dst = function ()
    local skin = {
        destination = {
            {
                id = "oldLampLabel", dst = {
                    {x = DETAIL.LAMP.FROM.X, y = DETAIL.LAMP.FROM.Y, w = DETAIL.LAMP.FROM.W, h = DETAIL.LAMP.FROM.H}
                }
            },
            {
                id = "lampLabel", dst = {
                    {x = DETAIL.LAMP.TO.X, y = DETAIL.LAMP.TO.Y, w = DETAIL.LAMP.TO.W, h = DETAIL.LAMP.TO.H}
                }
            },
            {
                id = "lampChangeArrow", dst = {
                    {x = DETAIL.LAMP.ARROW.X, y = DETAIL.LAMP.ARROW.Y, w = DETAIL.LAMP.ARROW.W, h = DETAIL.LAMP.ARROW.H}
                }
            },
            {
                id = "keysLabel", dst = {
                    {x = DETAIL.KEYS.X, y = DETAIL.KEYS.Y, w = DETAIL.KEYS.W, h = DETAIL.KEYS.H}
                }
            },
            {
                id = "randomModeLabel", dst = {
                    {x = DETAIL.RANDOM.X, y = DETAIL.RANDOM.Y, w = DETAIL.RANDOM.W, h = DETAIL.RANDOM.H}
                }
            },
            {
                id = "lnModeLabel", dst = {
                    {x = DETAIL.LN.X, y = DETAIL.LN.Y, w = DETAIL.LN.W, h = DETAIL.LN.H}
                }
            },
            {
                id = "notesLabel", dst = {
                    {x = DETAIL.NOTES.LABEL.X, y = DETAIL.NOTES.LABEL.Y, w = DETAIL.NOTES.LABEL.W, h = DETAIL.NOTES.LABEL.H}
                }
            },
            {
                id = "difficultyLabel", dst = {
                    {x = DETAIL.DIFFICULTY.LABEL.X, y = DETAIL.DIFFICULTY.LABEL.Y, w = DETAIL.DIFFICULTY.LABEL.W, h = DETAIL.DIFFICULTY.LABEL.H}
                }
            }
        }
    }

    mergeSkin(skin, detail.notesValue.dst(DETAIL.NOTES.X, DETAIL.NOTES.Y))
    mergeSkin(skin, detail.difficultyValue.dst(DETAIL.DIFFICULTY.X, DETAIL.DIFFICULTY.Y))

    return skin
end

return detail.functions
