require("modules.commons.define")
local songInfo = require("modules.commons.songinfo")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

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
        PLAY_AREA = {
            X = 0,
            Y = 357,
            W = 1411,
            H = 723,
        },
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
        PLAY_AREA = {
            X = 0,
            Y = 0,
            W = 1411,
            H = 1080,
        },
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
        PLAY_AREA = {
            X = 0,
            Y = 0,
            W = 1920,
            H = 1080,
        },
        BACK = {
            W = 1920,
            H = 1920,
            X_1 = 0,
            X_2 = 0,
            Y = 0 - (1920 - 1080) / 2
        }
    }
}

local BG = {

}

bga.functions.load = function ()
    if isFullScreenBga() then
        BGA = _BGA.FULL
    elseif isBgaOnLeftUpper() then
        BGA = _BGA.LEFT_UPPER
        if isVerticalGrooveGauge() then
            BGA.Y = lanes.getAreaY()
            BGA.H = lanes.getLaneHeight()
        end
    elseif isBgaOnLeft() then
        BGA = _BGA.LEFT
    end

    -- アス比から, 幅を計算してその後高さを計算
    -- 動画のアス比が1:1であること前提
    do
        local data = songInfo.getSongInfo()
        local raito = data.aspectW / data.aspectH
        if raito > 1 then
            BGA.PLAY_AREA.W = math.min(BGA.W, BGA.H * raito)
            BGA.PLAY_AREA.H = BGA.PLAY_AREA.W
            local areaCy = BGA.Y + BGA.H / 2
            BGA.PLAY_AREA.X = (is1P() and BGA.X_1 or BGA.X_2) + (BGA.W - BGA.PLAY_AREA.W) / 2
            BGA.PLAY_AREA.Y = areaCy  - BGA.PLAY_AREA.H / 2
        else
            BGA.PLAY_AREA.X = is1P() and BGA.X_1 or BGA.X_2
            BGA.PLAY_AREA.Y = BGA.Y
            BGA.PLAY_AREA.W = BGA.W
            BGA.PLAY_AREA.H = BGA.H
        end
    end

    return {
        image = {
            {id = "bgaMask", src = 8, x = 0, y = 0, w = -1, h = -1},
            {id = "background", src = 18, x = 0, y = 0, w = WIDTH, h = HEIGHT},
            {id = "background2", src = 18, x = 0, y = HEIGHT - BGA.Y, w = WIDTH, h = BGA.Y},
            {id = "versatilityBgaPng", src = 22, x = 0, y = 0, w = -1, h = -1},
            {id = "versatilityBgaMp4", src = 23, x = 0, y = 0, w = -1, h = -1},
        },
        bga = {id = "bga"}
    }
end

bga.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    local bgaX = is1P() and BGA.X_1 or BGA.X_2
    local versatilityBgaId = isVersatilitybgaPng() and "versatilityBgaPng" or "versatilityBgaMp4"

    -- 背景
    dst[#dst+1] = {
        id = "background", dst = {
            {x = 0, y = 0, w = WIDTH, h = HEIGHT}
        }
    }

    if isDrawLargeBga() then
        local backBgaX = is1P() and BGA.BACK.X_1 or BGA.BACK.X_2
        local w = BGA.BACK.W
        local maskBgaX = backBgaX
        local maskW = w
        if isBgaOnLeft() then
            maskW = BGA.W
            maskBgaX = bgaX
        end

        dst[#dst+1] = {
            id = versatilityBgaId, op = {170}, timer = 41, stretch = 1, filter = 1, dst = {
                {x = backBgaX, y = BGA.BACK.Y, w = w, h = BGA.BACK.H}
            }
        }

        dst[#dst+1] = {
            id = "bga", op = {171}, dst = {
                {x = backBgaX, y = BGA.BACK.Y, w = w, h = BGA.BACK.H}
            }
        }

        dst[#dst+1] = {
            id = "bgaMask", dst = {
                {x = maskBgaX, y = BGA.BACK.Y, w = maskW, h = BGA.BACK.H}
            }
        }
    end

    dst[#dst+1] = {
        id = versatilityBgaId, op = {170}, timer = 41, stretch = 1, filter = 1, dst = {
            {x = bgaX, y = BGA.Y, w = BGA.W, h = BGA.H}
        }
    }

    dst[#dst+1] = {
        id = "bga", op = {171}, dst = {
            {x = BGA.PLAY_AREA.X, y = BGA.PLAY_AREA.Y, w = BGA.PLAY_AREA.W, h = BGA.PLAY_AREA.H}
        }
    }

    if isBgaOnLeftUpper() then
        dst[#dst+1] = {
            id = "black", dst = {
                {x = BGA.PLAY_AREA.X, y = BGA.PLAY_AREA.Y, h = -1920, w = 1920}
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

    -- 背景2
    dst[#dst+1] = {
        id = "background2", dst = {
            {x = 0, y = 0, w = WIDTH, h = BGA.Y}
        }
    }


    -- ロード中はステージファイルを出す
    dst[#dst+1] = {
        id = -101, op = {80, 195}, stretch = 1, filter = 1, dst = {
            {x = bgaX, y = BGA.Y, w = BGA.W, h = BGA.H}
        }
    }
    dst[#dst+1] = {
        id = -101, op = {81, 195}, stretch = 1, filter = 1, timer = 40, loop = -1, dst = {
            {time = 0, x = bgaX, y = BGA.Y, w = BGA.W, h = BGA.H, a = 255},
            {time = 500, a = 0}
        }
    }
    dst[#dst+1] = {
        id = -100, op = {80, 191, -195}, stretch = 1, filter = 1, dst = {
            {x = bgaX, y = BGA.Y, w = BGA.W, h = BGA.H}
        }
    }
    dst[#dst+1] = {
        id = -100, op = {81, 191, -195}, stretch = 1, filter = 1, timer = 40, loop = -1, dst = {
            {time = 0, x = bgaX, y = BGA.Y, w = BGA.W, h = BGA.H, a = 255},
            {time = 500, a = 0}
        }
    }

    -- BGAの区切り線
    if isBgaOnLeftUpper() then
        local r, g, b = getSimpleLineColor()
        dst[#dst+1] = {
            id = "white", dst = {
                {x = bgaX, y = BGA.Y - 2, w = BGA.W, h = 2, r = r, g = g, b = b}
            }
        }
    end

    return skin
end

return bga.functions