local BASE_POS = {
    X = 1514,
    X_WITH_SHADOW = 1519,
    Y = 262,
    Y_WITH_SHADOW = 267,
}

local IR = {
    FRAME = {
        X = BASE_POS.X_WITH_SHADOW,
        Y = BASE_POS.Y_WITH_SHADOW,
    },
    OLD = {
        X = BASE_POS.X + 128,
        Y = BASE_POS.Y + 557,
        W = 19,
        H = 15,
    },
    NEW = {
        X = BASE_POS.X + 265,
        Y = BASE_POS.Y + 557,
        W = 25,
        H = 21,
    },
    NUM = {
        X = BASE_POS.X + 340,
        Y = BASE_POS.Y + 557,
        W = 19,
        H = 15,
    },
}

local ir = {
    functions = {}
}

ir.functions.load = function ()
    local skin = {
        image = {
            {id = "irFrame", src = 4, x = 0, y = 0, w = -1, h = -1},
        },
        value = {
            {id = "oldRankValue", src = 27, x = 0, y = 0, w = IR.OLD.W * 10, h = IR.OLD.H, divx = 10, digit = 4, space = 0, ref = 182},
            {id = "nowRankValue", src = 27, x = 0, y = 0, w = IR.NEW.W * 10, h = IR.NEW.H, divx = 10, digit = 4, space = 0, ref = 179},
            {id = "numOfPlayersValue", src = 27, x = 0, y = IR.NUM.H, w = IR.NUM.W * 10, h = IR.NUM.H, divx = 10, digit = 4, space = 0, ref = 180},
        },
        text = {},
        imageset = {},

    }
end
