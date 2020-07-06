local commons = require("modules.select.commons")

local upperOption = {
    functions = {}
}

local UPPER_OPTION = {
    TEXT_H = 44,
    TEXT = {
        W = 258,
        HALF_W = 129,
        H = 44,
    },
    BUTTON = {
        X = 720,
        UPPER_Y = 1022,
        W = 270,
        H = 56,
    },
    KEYS = {
        X = 6, -- buttonからの差分
    },
    SORT = {
        X = 6
    },
    LN = {
        X = 135
    },
}

upperOption.functions.load = function ()
    return {
        image = {
            -- オプションのkeys
            {id = "upperOptionButtonBg" , src = 2, x = 1321, y = PARTS_TEXTURE_SIZE - UPPER_OPTION.BUTTON.H, w = UPPER_OPTION.BUTTON.W, h = UPPER_OPTION.BUTTON.H},
            {id = "keysSet", src = 2, x = 1441, y = 836, w = UPPER_OPTION.TEXT.HALF_W, h = UPPER_OPTION.TEXT_H * 8, divy = 8, len = 8, ref = 11, act = 11},
            -- オプションのLNモード
            {id = "lnModeSet" , src = 2, x = 1570, y = 836, w = UPPER_OPTION.TEXT.HALF_W, h = UPPER_OPTION.TEXT_H * 3, divy = 3, len = 3, ref = 308, act = 308},
            -- ソート
            {id = "sortModeSet" , src = 2, x = 1699, y = 836, w = UPPER_OPTION.TEXT.W, h = UPPER_OPTION.TEXT_H * 8, divy = 8, len = 8, ref = 12, act = 12},
        }
    }
end

upperOption.functions.dst = function ()
    return {
        destination = {
            -- 上部オプション
            {
                id = "upperOptionButtonBg", dst = {
                    {x = UPPER_OPTION.BUTTON.X, y = UPPER_OPTION.BUTTON.UPPER_Y, w = UPPER_OPTION.BUTTON.W, h = UPPER_OPTION.BUTTON.H}
                }
            },
            -- 上部オプションの上のやつの区切り
            {
                id = "white", dst = {
                    {x = UPPER_OPTION.BUTTON.X + 135, y = UPPER_OPTION.BUTTON.UPPER_Y + 6, w = 1, h = UPPER_OPTION.TEXT_H, r = 102, g = 102, b = 102}
                }
            },
            {
                id = "upperOptionButtonBg", dst = {
                    {x = UPPER_OPTION.BUTTON.X, y = UPPER_OPTION.BUTTON.UPPER_Y - 53, w = UPPER_OPTION.BUTTON.W, h = UPPER_OPTION.BUTTON.H}
                }
            },
            -- keys
            {
                id = "keysSet", dst = {
                    {x = UPPER_OPTION.BUTTON.X + UPPER_OPTION.KEYS.X, y = UPPER_OPTION.BUTTON.UPPER_Y + 6, w = UPPER_OPTION.TEXT.HALF_W, h = UPPER_OPTION.TEXT_H}
                }
            },
            -- LN
            {
                id = "lnModeSet", dst = {
                    {x = UPPER_OPTION.BUTTON.X + UPPER_OPTION.LN.X, y = UPPER_OPTION.BUTTON.UPPER_Y + 6, w = UPPER_OPTION.TEXT.HALF_W, h = UPPER_OPTION.TEXT_H}
                }
            },
            -- ソート
            {
                id = "sortModeSet", dst = {
                    {x = UPPER_OPTION.BUTTON.X + UPPER_OPTION.SORT.X, y = UPPER_OPTION.BUTTON.UPPER_Y - 53 + 6, w = UPPER_OPTION.TEXT.W, h = UPPER_OPTION.TEXT_H}
                }
            },
        }
    }
end

return upperOption.functions