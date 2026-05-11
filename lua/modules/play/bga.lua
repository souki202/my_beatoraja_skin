require("modules.commons.define")
local songInfo = require("modules.commons.songinfo")
require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local bga = {
    functions = {}
}

local BOKEH = {
    R = 30,
    QUALITY1 = 15, -- %
    QUALITY_SKIP = 5,
}

local BGA = {
    X_1P = 531, -- 1PのBGAのX座標
    X_2P = 13, -- 2PのBGAのX座標
    Y = 370,
    W = 1371,
    H = 697,
    PLAY_AREA = {
        X = 2,
        Y = 372,
        W = 1367,
        H = 693,
    },
    BACK = {
        W = 1367,
        H = 1367,
        X_1P = 509,
        X_2P = 0,
        Y = 372 - (1367 - 693) / 2
    }
}

bga.functions.load = function ()
    -- アス比から, 幅を計算してその後高さを計算
    -- 動画のアス比が1:1であること前提
    do
        local data = songInfo.getSongInfo()
        local raito = data.aspectW / data.aspectH
        if raito > 1 then
            BGA.PLAY_AREA.W = math.min(BGA.W, BGA.H * raito)
            BGA.PLAY_AREA.H = BGA.PLAY_AREA.W
            local areaCy = BGA.Y + BGA.H / 2
            BGA.PLAY_AREA.X = (is1P() and BGA.X_1P or BGA.X_2P) + (BGA.W - BGA.PLAY_AREA.W) / 2
            BGA.PLAY_AREA.Y = areaCy  - BGA.PLAY_AREA.H / 2
        else
            BGA.PLAY_AREA.X = is1P() and BGA.X_1P or BGA.X_2P
            BGA.PLAY_AREA.Y = BGA.Y
            BGA.PLAY_AREA.W = BGA.W
            BGA.PLAY_AREA.H = BGA.H
        end
    end

    -- オフセット分だけ小さく+ずらす
    do
        local offset = math.min(getBgaWidthOffset(), 0);
        BGA.PLAY_AREA.X = BGA.PLAY_AREA.X - offset / 2;
        BGA.PLAY_AREA.W = BGA.PLAY_AREA.W + offset;
    end

    return {
        image = {
            {id = "bgaMask", src = 60, x = 0, y = 0, w = -1, h = -1},
            {id = "background", src = 18, x = 0, y = 0, w = WIDTH, h = HEIGHT},
            {id = "background2", src = 18, x = 0, y = HEIGHT - BGA.Y, w = WIDTH, h = BGA.Y},
            {id = "versatilityBgaPng", src = 22, x = 0, y = 0, w = -1, h = -1},
            {id = "versatilityBgaMp4", src = 23, x = 0, y = 0, w = -1, h = -1},
            {id = "bgaFrame", src = 61, x = 0, y = 0, w = -1, h = -1},
            {id = "bgaBg", src = 64, x = 0, y = 0, w = -1, h = -1},
            {id = "bgaBackFrame", src = 65, x = 0, y = 0, w = -1, h = -1},
        },
        bga = {id = "bga"}
    }
end

bga.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    local bgaX = is1P() and BGA.X_1P or BGA.X_2P
    local versatilityBgaId = isVersatilitybgaPng() and "versatilityBgaPng" or "versatilityBgaMp4"

    -- 背景
    dst[#dst+1] = {
        id = "background", dst = {
            {x = 0, y = 0, w = WIDTH, h = HEIGHT}
        }
    }

    dst[#dst+1] = {
        id = "bgaBg", op = {171}, dst = {
            {x = bgaX + BGA.PLAY_AREA.X, y = BGA.Y + BGA.PLAY_AREA.Y, w = BGA.PLAY_AREA.W, h = BGA.PLAY_AREA.H}
        }
    }

    -- CoverでメインのBGAの後ろに表示する大きいBGA
    if isDrawLargeBga() then
        local backBgaX = is1P() and BGA.BACK.X_1P or BGA.BACK.X_2P
        local backBgaY = BGA.BACK.Y
        local w = BGA.BACK.W
        local h = BGA.BACK.H
        dst[#dst+1] = {
            id = versatilityBgaId, op = {170}, timer = 41, stretch = 1, filter = 1, dst = {
                {x = backBgaX, y = backBgaY, w = w, h = h}
            }
        }

        dst[#dst+1] = {
            id = "bga", op = {171}, dst = {
                {x = backBgaX, y = backBgaY, w = w, h = h}
            }
        }

        if isEnableBackBgaBokeh() then
            local numOfBga = 0
            local hasBga = main_state.option(171)
            local quality = BOKEH.QUALITY1 / 100
            local rand = math.random
            local start = BOKEH.R / 2
            start = 1
            for r = start, BOKEH.R, BOKEH.QUALITY_SKIP do
                local n = math.floor(2 * r * math.pi)
                local radianOffset = math.random(0, 359) / 180 * math.pi
                -- local maxAlpha = 255 * r / BOKEH.R
                local maxAlpha = 255 * gaussian(r, 1, 0, BOKEH.R / 2)
                -- local a = math.min(maxAlpha, maxAlpha / n / quality) / math.sqrt(math.max(1, BOKEH.R / BOKEH.QUALITY_SKIP))
                local a = math.min(maxAlpha, maxAlpha / n / quality)
                myPrint("numOfBga: " .. n * quality)
                myPrint("maxAlpha: " .. maxAlpha, "alpha: " .. a)
                local idxes = {}
                for i = 1, n do
                    idxes[i] = i
                end
                table.shuffle(idxes)
                if a >= 1 then
                    for i = 1, n do
                        local idx = idxes[i]
                        -- ディザ
                        if rand() < quality then
                            local radian = (idx / n) * 2 * math.pi + radianOffset
                            local x = backBgaX + r * math.cos(radian)
                            local y = backBgaY + r * math.sin(radian)
                            if hasBga then
                                dst[#dst+1] = {
                                    id = "bga", dst = {
                                        {x = x, y = y, w = w, h = h, a = a}
                                    }
                                }
                            else
                                dst[#dst+1] = {
                                    id = versatilityBgaId, dst = {
                                        {x = x, y = y, w = w, h = h, a = a}
                                    }
                                }
                            end
                            numOfBga = numOfBga + 1
                        end
                    end
                end
            end
            myPrint("BGA描画枚数: " .. numOfBga)
        end

        dst[#dst+1] = {
            id = "bgaMask", dst = {
                {x = backBgaX, y = backBgaY, w = w, h = h}
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

    dst[#dst+1] = {
        id = "black", dst = {
            {x = BGA.PLAY_AREA.X, y = BGA.PLAY_AREA.Y, h = -1920, w = 1920}
        }
    }

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

    dst[#dst+1] = {
        id = "bgaBackFrame", dst = {
            {x = bgaX, y = 0, w = 1395, h = 1080}
        }
    }

    dst[#dst+1] = {
        id = "bgaFrame", dst = {
            {x = bgaX, y = BGA.Y, w = BGA.W, h = BGA.H}
        }
    }

    -- BGAの区切り線
    local r, g, b = getSimpleLineColor()
    dst[#dst+1] = {
        id = "white", dst = {
            {x = bgaX, y = BGA.Y - 2, w = BGA.W, h = 2, r = r, g = g, b = b}
        }
    }

    return skin
end

return bga.functions
