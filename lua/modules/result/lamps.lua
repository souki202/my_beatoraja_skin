require("modules.commons.define")
require("modules.result.commons")
local luajava = require("luajava")
local Color = luajava.bindClass("java.awt.Color")
local RenderingHints = luajava.bindClass("java.awt.RenderingHints")
local image = require("modules.commons.image")
local main_state = require("main_state")
local utils = require("modules.commons.utility")

local lamps = {
    isLoaded = false,
    image = nil,
    barValues = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    rates = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    rateAfterDots = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    num = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    functions = {},
}

local LAMPS = {
    WND = {
        X = RIGHT_X,
        Y = 116,
        W = 650,
        H = 698,
        SHADOW = 15,
    },
    HEADER = {
        X = function (self) return self.WND.X + 173 end,
        Y = function (self) return self.WND.Y + 653 end,
        W = 304,
        H = 27,
    },
    GRAPH = {
        BAR = {
            X = function (self) return self.WND.X + 518 end,
            Y = function (self) return self.WND.Y + 27 end,
            W = 80,
            H = 600,
            COLORS = { -- maxから noplayは無し
                {0, 255, 126},
                {0, 255, 255},
                {252, 181, 202},
                {247, 148, 49},
                {247, 99, 198},
                {0, 99, 198},
                {0, 148, 49},
                {148, 0, 99},
                {0, 0, 247},
                {148, 0, 0},
            }
        },
        LABEL = {
            X = function (self) return self.WND.X + 48 end,
            Y = function (self) return self.WND.Y + 585 end,
            INTERVAL_Y = 62,
            TEXT = {
                X = function (self) return self.GRAPH.LABEL.X(self) end,
                Y = function (self, i) return self.GRAPH.LABEL.BG.Y(self, i) + 9 end,
                W = 110,
                H = 24,
            },
            BG = {
                X = function (self) return self.GRAPH.LABEL.X(self) end,
                Y = function (self, i) return self.GRAPH.LABEL.Y(self) - self.GRAPH.LABEL.INTERVAL_Y * (i - 1) end,
                W = 256,
                H = 42,
            },
            VAL = {
                X = function (self) return self.GRAPH.LABEL.X(self) + 135 end,
                X_DOT = function (self) return self.GRAPH.LABEL.VAL.X(self) + 42 end,
                X_AFTER_DOT = function (self) return self.GRAPH.LABEL.VAL.X_DOT(self) + 5 end,
                X_PERCENT = function (self) return self.GRAPH.LABEL.VAL.X_AFTER_DOT(self) + 16 end,
                Y = function (self, i) return self.GRAPH.LABEL.BG.Y(self, i) + 11 end,
            },
            AMOUNT = {
                X = function (self) return self.GRAPH.LABEL.BG.X(self) + self.GRAPH.LABEL.BG.W + 5 end,
                X_UNIT = function (self) return self.GRAPH.LABEL.BG.X(self) + self.GRAPH.LABEL.BG.W + 5 + 62 end,
                Y = function (self, i) return self.GRAPH.LABEL.BG.Y(self, i) + 11 end,
                Y_UNIT = function (self, i) return self.GRAPH.LABEL.BG.Y(self, i) + 5 end,
                UNIT_FONT_SIZE = 24,
            },
        },
        BEAM = {
            X = function (self) return self.WND.X + 304 end,
            X2 = function (self) return self.GRAPH.BEAM.X(self) + 107 end,
            Y = function (self, i) return self.GRAPH.LABEL.BG.Y(self, i) end,
            W = 214,
            W2 = 107,
            MAX_H = 600,
        }
    },
    ID_PREFIX = {"max", "perfect", "fullcombo", "exhard", "hard", "clear", "easy", "laeasy", "aeasy", "failed"},
}

lamps.functions.change2p = function ()
    LAMPS.WND.X = LEFT_X
end

lamps.functions.load = function (isDrawFunction)
    lamps.functions.isDraw = isDrawFunction

    local rateIds  = utils.getIrPlayerLampRateIds()
    local afId     = utils.getIrPlayerLampRateAfterDotIds()
    local valueIds = utils.getIrPlayerLampAmountIds()
    local skin = {
        image = {
            {id = "graphWhite", src = 999, x = 2, y = 0, w = 1, h = 1},
            -- ヘッダー
            {id = "lampDistributionHeader", src = 11, x = 0, y = 0, w = LAMPS.HEADER.W, h = LAMPS.HEADER.H},
        },
        graph = {},
        value = {},
        text = {
            {id = "numOfPeopleUnit", font = 0, size = LAMPS.GRAPH.LABEL.AMOUNT.UNIT_FONT_SIZE, constantText = "人"}
        },
        customTimers = {
            {
                id = 10104,
                timer = function ()
                    -- if not lamps.isLoaded and not main_state.option(606) and not main_state.option(608) then
                    -- IR読み込み完了がないのでとりあえず常時更新する
                    if 1 then
                        lamps.isLoaded = true

                        -- ランプの下から計算
                        local sum = 0
                        for i = #LAMPS.ID_PREFIX, 1, -1 do
                            local r, a = main_state.number(rateIds[i]), main_state.number(afId[i])
                            -- 読み込まれていないなら終了
                            if r < 0 or a < 0 then return end

                            sum = sum + r + a / 10
                            lamps.rates[i] = r
                            lamps.rateAfterDots[i] = a
                            lamps.barValues[i] = sum / 100
                            lamps.num[i] = main_state.number(valueIds[i])
                        end
                    end
                end
            }
        }
    }

    local g = skin.graph
    local imgs = skin.image
    local vals = skin.value
    local beam = LAMPS.GRAPH.BEAM
    for i, color in ipairs(LAMPS.GRAPH.BAR.COLORS) do
        local id = LAMPS.ID_PREFIX[i]
        -- 棒グラフ用のgraph読み込み
        g[#g+1] = {
            id = id .. "RateBarGraph", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 1,
            value = function ()
                return lamps.barValues[i]
            end
        }
        -- 棒グラフに向かう斜め線の定義
        g[#g+1] = {
            id = id .. "RateBarSeparator", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0,
            value = function ()
                if i == #LAMPS.ID_PREFIX then return beam.W2 / 1000 end
                return math.sqrt((beam.W2) ^ 2 + (LAMPS.GRAPH.BAR.H * lamps.barValues[i + 1] - (LAMPS.GRAPH.LABEL.BG.Y(LAMPS, i) - LAMPS.GRAPH.BAR.Y(LAMPS))) ^ 2) / 1000
            end
        }
        -- ラベル文字読み込み
        imgs[#imgs+1] = {
            id = id .. "RateLabel", src = 0, x = 921, y = 504 - (i - 1) * LAMPS.GRAPH.LABEL.TEXT.H,
            w = LAMPS.GRAPH.LABEL.TEXT.W, h = LAMPS.GRAPH.LABEL.TEXT.H
        }
        imgs[#imgs+1] = {
            id = id .. "RateLabelBg", src = 10, x = 0, y = LAMPS.GRAPH.LABEL.BG.H * (i - 1), w = LAMPS.GRAPH.LABEL.BG.W, h = LAMPS.GRAPH.LABEL.BG.H
        }
        -- 値読み込み
        vals[#vals+1] = {
            id = id .. "RateValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 3, ref = rateIds[i], align = 0
        }
        vals[#vals+1] = {
            id = id .. "RateAfterDotValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 1, ref = afId[i], align = 0
        }
        vals[#vals+1] = {
            id = id .. "AmountValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 4, ref = valueIds[i], align = 0
        }
    end
    return skin
end

lamps.functions.dstMaskBg = function ()
    return {
        destination = {
            {
                id = "graphMaskBg", draw = lamps.functions.isDraw, dst = {
                    {x = LAMPS.WND.X - LAMPS.WND.SHADOW, y = LAMPS.WND.Y - LAMPS.WND.SHADOW, w = LAMPS.WND.W + LAMPS.WND.SHADOW*2, h = LAMPS.WND.H + LAMPS.WND.SHADOW*2}
                }
            }
        }
    }
end

lamps.functions.dst = function ()
    local isDraw = lamps.functions.isDraw
    local skin = {
        destination = {
            {   -- ranking側から流用
                id = "graphMaskBg", draw = isDraw, dst = {
                    {x = LAMPS.WND.X - LAMPS.WND.SHADOW, y = LAMPS.WND.Y - LAMPS.WND.SHADOW, w = LAMPS.WND.W + LAMPS.WND.SHADOW*2, h = LAMPS.WND.H + LAMPS.WND.SHADOW*2}
                }
            },
        }
    }
    destinationStaticWindowBg(skin, RESULT_BASE_WINDOW.ID, LAMPS.WND.X, LAMPS.WND.Y, LAMPS.WND.W, LAMPS.WND.H, RESULT_BASE_WINDOW.EDGE_SIZE, RESULT_BASE_WINDOW.SHADOW_LEN, {}, isDraw)
    local dst = skin.destination

    dst[#dst+1] = {
        id = "lampDistributionHeader", draw = isDraw, dst = {
            {x = LAMPS.HEADER.X(LAMPS), y = LAMPS.HEADER.Y(LAMPS), w = LAMPS.HEADER.W, h = LAMPS.HEADER.H}
        }
    }

    for i = 1, #LAMPS.ID_PREFIX do
        local id = LAMPS.ID_PREFIX[i]
        local color = LAMPS.GRAPH.BAR.COLORS[i]
        -- ラベルの描画
        dst[#dst+1] = {
            id = id .. "RateLabelBg", draw = isDraw, dst = {
                {x = LAMPS.GRAPH.LABEL.BG.X(LAMPS), y = LAMPS.GRAPH.LABEL.BG.Y(LAMPS, i), w = LAMPS.GRAPH.LABEL.BG.W, h = LAMPS.GRAPH.LABEL.BG.H}
            }
        }
        dst[#dst+1] = {
            id = id .. "RateLabel", draw = isDraw, dst = {
                {x = LAMPS.GRAPH.LABEL.TEXT.X(LAMPS), y = LAMPS.GRAPH.LABEL.TEXT.Y(LAMPS, i), w = LAMPS.GRAPH.LABEL.TEXT.W, h = LAMPS.GRAPH.LABEL.TEXT.H}
            }
        }

        -- 数値の描画
        -- 割合
        dst[#dst+1] = {
            id = id .. "RateValue", draw = isDraw, dst = {
                {x = LAMPS.GRAPH.LABEL.VAL.X(LAMPS), y = LAMPS.GRAPH.LABEL.VAL.Y(LAMPS, i), w = NUM_24PX.W, h = NUM_24PX.H}
            }
        }
        dst[#dst+1] = {
            id = "dotFor24Px", draw = isDraw, dst = {
                {x = LAMPS.GRAPH.LABEL.VAL.X_DOT(LAMPS), y = LAMPS.GRAPH.LABEL.VAL.Y(LAMPS, i), w = NUM_24PX.DOT_SIZE, h = NUM_24PX.DOT_SIZE}
            }
        }
        dst[#dst+1] = {
            id = id .. "RateAfterDotValue", draw = isDraw, dst = {
                {x = LAMPS.GRAPH.LABEL.VAL.X_AFTER_DOT(LAMPS), y = LAMPS.GRAPH.LABEL.VAL.Y(LAMPS, i), w = NUM_24PX.W, h = NUM_24PX.H}
            }
        }
        dst[#dst+1] = {
            id = "percentageFor24Px", draw = isDraw, dst = {
                {x = LAMPS.GRAPH.LABEL.VAL.X_PERCENT(LAMPS), y = LAMPS.GRAPH.LABEL.VAL.Y(LAMPS, i), w = NUM_24PX.PERCENT.W, h = NUM_24PX.PERCENT.H}
            }
        }
        -- 人数
        dst[#dst+1] = {
            id = id .. "AmountValue", draw = isDraw, dst = {
                {x = LAMPS.GRAPH.LABEL.AMOUNT.X(LAMPS), y = LAMPS.GRAPH.LABEL.AMOUNT.Y(LAMPS, i), w = NUM_24PX.W, h = NUM_24PX.H}
            }
        }
        dst[#dst+1] = {
            id = "numOfPeopleUnit", draw = isDraw, dst = {
                {x = LAMPS.GRAPH.LABEL.AMOUNT.X_UNIT(LAMPS), y = LAMPS.GRAPH.LABEL.AMOUNT.Y_UNIT(LAMPS, i), w = 30, h = LAMPS.GRAPH.LABEL.AMOUNT.UNIT_FONT_SIZE, r = 0, g = 0, b = 0}
            }
        }

        -- グラフまでの線を描画
        dst[#dst+1] = {
            id = "graphWhite", draw = isDraw, filter = 1, dst = {
                {
                    x = LAMPS.GRAPH.BEAM.X(LAMPS), y = LAMPS.GRAPH.BEAM.Y(LAMPS, i), w = LAMPS.GRAPH.BEAM.W2, h = 2,
                    r = color[1], g = color[2], b = color[3], a = 255
                }
            }
        }
        dst[#dst+1] = {
            id = id .. "RateBarSeparator", draw = function () return isDraw() and lamps.num[i] > 0 end, center = 4, dst = {
                {
                    time = 0,
                    x = LAMPS.GRAPH.BEAM.X2(LAMPS), y = LAMPS.GRAPH.BEAM.Y(LAMPS, i), w = 1000, h = 2,
                    r = color[1], g = color[2], b = color[3], a = 255, angle = 0,
                },
                {
                    time = 360 * 1000, angle = 360,
                },
            },
            timer = function ()
                local h = 0
                if i == #LAMPS.ID_PREFIX then h = 0
                else h = LAMPS.GRAPH.BAR.H * lamps.barValues[i + 1] end
                local r = math.atan2(h - (LAMPS.GRAPH.LABEL.BG.Y(LAMPS, i) - LAMPS.GRAPH.BAR.Y(LAMPS)), LAMPS.GRAPH.BEAM.W2)
                if r < 0 then r = 2 * math.pi + r end
                return getElapsedTime() - r * 180 / math.pi * 1000 * 1000
            end
        }

        -- グラフの描画
        dst[#dst+1] = {
            id = id .. "RateBarGraph", draw = isDraw, dst = {
                {
                    x = LAMPS.GRAPH.BAR.X(LAMPS), y = LAMPS.GRAPH.BAR.Y(LAMPS), w = LAMPS.GRAPH.BAR.W, h = LAMPS.GRAPH.BAR.H,
                    r = color[1], g = color[2], b = color[3], a = 255,
                }
            }
        }
    end
    return skin
end

return lamps.functions