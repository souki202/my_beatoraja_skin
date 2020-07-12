local bga = {
    functions = {}
}

local BGA = {}

local _BGA = {
    LEFT_UPPER = {
        X_1 = 509,
        X_2 = 0,
        Y = 357,
        W = 1411,
        H = 723,
        BACK = {
            W = 1411,
            H = 1411,
            X_1 = 509,
            X_2 = 0,
            Y = 357 - (1411 - 723) / 2
        },
    },
    LEFT = {
        X_1 = 509,
        X_2 = 0,
        Y = 0,
        W = 1411,
        H = 1080,
        BACK = {
            W = 1920,
            H = 1920,
            X_1 = 509 - (1920 - 1411) / 2,
            X_2 = 0 - (1920 - 1411) / 2,
            Y = (1080 - 1920) / 2
        }
    },
    FULL = {
        X_1 = 0,
        X_2 = 0,
        Y = 0,
        W = 1920,
        H = 1080,
        BACK = {
            W = 1920,
            H = 1920,
            X_1 = 0,
            X_2 = 0,
            Y = 0 - (1920 - 1080) / 2
        }
    }
}

bga.functions.load = function ()
    return {
        image = {
            {id = "bgaMask", src = 8, x = 0, y = 0, w = -1, h = -1}
        },
        bga = {id = "bga"}
    }
end

bga.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    if isFullScreenBga() then
        BGA = _BGA.FULL
    elseif isBgaOnLeftUpper() then
        BGA = _BGA.LEFT_UPPER
    elseif isBgaOnLeft() then
        BGA = _BGA.LEFT
    end

    local bgaX = is1P() and BGA.X_1 or BGA.X_2

    if isDrawLargeBga() then
        local backBgaX = is1P() and BGA.BACK.X_1 or BGA.BACK.X_2
        local w = BGA.BACK.W
        local maskBga = backBgaX
        local maskW = w
        if isBgaOnLeft() then
            maskW = BGA.W
            maskBga = bgaX
        end

        dst[#dst+1] = {
            id = "bga", op = {171}, dst = {
                {x = backBgaX, y = BGA.BACK.Y, w = w, h = BGA.BACK.H}
            }
        }

        dst[#dst+1] = {
            id = "bgaMask", op = {171}, dst = {
                {x = maskBga, y = BGA.BACK.Y, w = maskW, h = BGA.BACK.H}
            }
        }
    end
    dst[#dst+1] = {
        id = "bga", op = {171}, dst = {
            {x = bgaX, y = BGA.Y, w = BGA.W, h = BGA.H}
        }
    }

    if isBgaOnLeftUpper() then
        dst[#dst+1] = {
            id = "black", dst = {
                {x = bgaX, y = BGA.Y, h = -1920, w = 1920}
            }
        }
    elseif isBgaOnLeft() then
        local x = 0
        if not is1P() then
            x = BGA.W
        end
        dst[#dst+1] = {
            id = "black", dst = {
                {x = x, y = 0, h = 1080, w = BGA.X_1}
            }
        }
    end

    return skin
end

return bga.functions