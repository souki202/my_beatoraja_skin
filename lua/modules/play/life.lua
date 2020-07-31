require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")
local timer_util = require("timer_util")
require("modules.commons.numbers")

local life = {
    functions = {},
    gaugeType = 0,
    value = 0,
}

local LIFE = {
    AREA = {
        X = function() return lanes.getAreaX() end,
        Y = function() return 191-7 end,
        W = 432,
        H = 98,
    },
    INDICATOR = {
        X = function (self) return self.AREA.X() + 310 end,
        Y = function (self) return self.AREA.Y() + 60 end,
        W = 26,
        H = 25,
        WAVE_TIME = 500,
        WAVE_LOOP = 1000,
        WAVE_MUL = 2,
    },
    NUM = {
        X = function (self) return self.AREA.X() + 383 - self.NUM.W * self.NUM.DIGIT end,
        Y = function (self) return self.AREA.Y() + 64 end,
        DOT_X = function (self) return self.NUM.X(self) + self.NUM.W * self.NUM.DIGIT + 1 end,
        AFTER_DOT_X = function (self) return self.NUM.DOT_X(self) + 18 - self.NUM.W end,
        P_X = function (self) return self.NUM.AFTER_DOT_X(self) + self.NUM.W + 1 end,
        W = NUMBERS_24PX.W,
        H = NUMBERS_24PX.H,
        P_W = 21,
        P_H = 18,
        DIGIT = 3,
    },
    TYPES = {"Aeasy", "Easy", "Normal", "Hard", "Exhard", "Hazard", "Class", "ExClass", "ExhardClass"},
    TEXT = {
        ID_PREFIX = "grooveTypeText",
        X = function (self) return self.AREA.X() + 4 end,
        Y = function (self) return self.AREA.Y() + 58 end,
        W = 147,
        H = 18,
    },
    GAUGE = {
        ID_PREFIX = "grooveGauge",
        X = function (self) return self.AREA.X() + 2 end,
        Y = function (self) return self.AREA.Y() + 9 end,
        W = 428,
        H = 44,
        COLORS = {
            {{251, 137, 255}, {247, 33, 255}},
            {{64, 200, 64}, {255, 69, 3}},
            {{64, 255, 255}, {255, 69, 3}},
            {{255, 0, 0}, {255, 0, 0}},
            {{255, 150, 0}, {255, 150, 0}},
            {{200, 200, 200}, {200, 200, 200}},
            {{247, 33, 255}, {247, 33, 255}},
            {{255, 0, 0}, {255, 0, 0}},
            {{255, 150, 0}, {255, 150, 0}},
        },
        BG_COLORS = {
            {{46, 16, 46}, {77, 32, 61}},
            {{16, 46, 16}, {50, 7, 0}},
            {{16, 46, 46}, {50, 7, 0}},
            {{46, 16, 0}, {46, 16, 0}},
            {{58, 58, 0}, {58, 58, 1}},
            {{64, 64, 64}, {64, 64, 64}},
            {{77, 21, 0}, {77, 21, 0}},
            {{46, 16, 0}, {46, 16, 0}},
            {{58, 58, 0}, {58, 58, 0}},
        },
        COLOR_BORDERS = {
            60, 80, 80, 30, 30, 30, 30, 30, 30,
        },
        INDICATOR_BORDERS = {
            {20, 60}, {20, 80}, {20, 80}, {10, 30}, {30, 50}, {10, 30}, {10, 30}, {10, 30}, {10, 30}
        },
        WARN = {
            SHADOW = 12,
            H = 68,
            LOOP_TIME = 1000,
        },
        LIGHT = {
            SIZE = 24,
            MAX_H = 768,
            CY = function (self) return self.GAUGE.Y(self) + self.GAUGE.H / 2 end,
            THRESHOLD_INTERVALS = {5, 10, 20, 30, 9999},
            THRESHOLD_INTERVAL = 5,
            ANIM_TIME = 500,
        },
    },
    PARTICLE = {
        LEFT_X = function (self) return self.GAUGE.X(self) - 24 end,
        RIGHT_X = function (self) return self.GAUGE.X(self) + self.GAUGE.W + 24 end,
        TOP_Y = function (self) return self.GAUGE.Y(self) + self.GAUGE.H + 24 end,
        BOTTOM_Y = function (self) return self.GAUGE.Y(self) - 24 end,
        SIZE = 16,
        LOOP_TIME = 1000,
        ALPHA = 255,
        ALPHA_VAR = 128,
    },
}

life.functions.load = function ()
    LIFE.GAUGE.LIGHT.THRESHOLD_INTERVAL = LIFE.GAUGE.LIGHT.THRESHOLD_INTERVALS[math.max(1, math.min(getLifeGaugeEffectThresholdIdx(), 5))]
    LIFE.GAUGE.LIGHT.MAX_H = LIFE.GAUGE.LIGHT.MAX_H * (100 + getLifeGaugeEffectSizeYOffset()) / 100
    local skin = {
        image = {
            {id = "grooveFrame", src = 0, x = 0, y = PARTS_TEXTURE_SIZE - LIFE.AREA.H, w = LIFE.AREA.W, h = LIFE.AREA.H},
            {id = "gaugeGlass", src = 0, x = 432, y = PARTS_TEXTURE_SIZE - LIFE.GAUGE.H, w = 1, h = LIFE.GAUGE.H},
            -- インディケーター
            {id = "grooveIndicatorSafe", src = 7, x = 0, y = 0, w = LIFE.INDICATOR.W, h = LIFE.INDICATOR.H},
            {id = "grooveIndicatorWarn", src = 7, x = LIFE.INDICATOR.W, y = 0, w = LIFE.INDICATOR.W, h = LIFE.INDICATOR.H},
            {id = "grooveIndicatorDanger", src = 7, x = LIFE.INDICATOR.W*2, y = 0, w = LIFE.INDICATOR.W, h = LIFE.INDICATOR.H},

            {id = "grooveValueDot", src = 0, x = PARTS_TEXTURE_SIZE - LIFE.NUM.W, y = 76, w = LIFE.NUM.W, h = LIFE.NUM.H},
            {id = "percent24px", src = 0, x = 1851, y = 76, w = LIFE.NUM.P_W, h = LIFE.NUM.P_H},

            -- 警告エフェクト
            {id = "warnLeft", src = 0, x = 433, y = PARTS_TEXTURE_SIZE - LIFE.GAUGE.WARN.H, w = LIFE.GAUGE.WARN.SHADOW, h = LIFE.GAUGE.WARN.H},
            -- {id = "warnRight", src = 0, x = 433 + 1 + LIFE.GAUGE.WARN.SHADOW, y = PARTS_TEXTURE_SIZE - LIFE.GAUGE.WARN.H, w = LIFE.GAUGE.WARN.SHADOW, h = LIFE.GAUGE.WARN.H},
            -- {id = "warnCenter", src = 0, x = 433 + LIFE.GAUGE.WARN.SHADOW, y = PARTS_TEXTURE_SIZE - LIFE.GAUGE.WARN.H, w = 1, h = LIFE.GAUGE.WARN.H},

            -- 10%ごとのエフェクト
            {id = "lightIndicator", src = 0, x = 22, y = 0, w = LIFE.GAUGE.LIGHT.SIZE, h = LIFE.GAUGE.LIGHT.SIZE},

            -- 100%時のキラ
            {id = "gauge100Particle", src = 27, x = 0, y = 0, w = -1, h = -1},
        },
        value = {
            {id = "grooveValue", src = 0, x = 1880, y = 76, w = NUMBERS_24PX.W * 10, h = NUMBERS_24PX.H, divx = 10, digit = LIFE.NUM.DIGIT, ref = 107},
            {id = "grooveValueAfterDot", src = 0, x = 1880, y = 76, w = NUMBERS_24PX.W * 10, h = NUMBERS_24PX.H, divx = 10, digit = 1, ref = 407},
        },
        graph = {},
        customTimers = {
            {
                id = 10010, timer = function()
                    life.gaugeType = main_state.gauge_type()
                    life.value = main_state.gauge()
                    return 0
                end
            },
            -- {id = 10011, timer = function() print(life.gaugeType, life.value) return 0 end}, -- ジャギるので無し
        }
    }

    local imgs = skin.image

    -- ゲージ種類文字読み込み
    for i = 1, #LIFE.TYPES do
        imgs[#imgs+1] = {
            id = LIFE.TEXT.ID_PREFIX .. LIFE.TYPES[i], src = 0,
            x = 213, y = LIFE.TEXT.H * (i - 1), w = LIFE.TEXT.W, h = LIFE.TEXT.H
        }
    end

    -- graph読み込み
    local g = skin.graph
    for i = 1, #LIFE.TYPES do
        local border = LIFE.GAUGE.COLOR_BORDERS[i]
        -- 少ない部分
        g[#g+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "Low", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0,
            value = function ()
                return math.min(life.value, border) / border
            end,
        }
        -- WARN
        g[#g+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "warn", src = 0, x = 433 + LIFE.GAUGE.WARN.SHADOW, y = PARTS_TEXTURE_SIZE - LIFE.GAUGE.WARN.H, w = 1, h = LIFE.GAUGE.WARN.H, angle = 0,
            value = function ()
                return math.min(life.value, border) / border
            end,
        }

        -- 多い部分
        g[#g+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "High", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0,
            value = function ()
                return life.value / 100
            end,
        }
    end
    return skin
end

life.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    -- ゲージ背景の白
    dst[#dst+1] = {
        id = "white", dst = {
            {x = LIFE.GAUGE.X(LIFE), y = LIFE.GAUGE.Y(LIFE), w = LIFE.GAUGE.W, h = LIFE.GAUGE.H, a = 96}
        }
    }
    -- ゲージ
    for i = 1, #LIFE.TYPES do
        local border = LIFE.GAUGE.COLOR_BORDERS[i]
        local lowColor = LIFE.GAUGE.COLORS[i][1]
        local highColor = LIFE.GAUGE.COLORS[i][2]
        local bgLowColor = LIFE.GAUGE.BG_COLORS[i][1]
        local bgHighColor = LIFE.GAUGE.BG_COLORS[i][2]

        -- 背景
        -- 多い部分
        dst[#dst+1] = {
            id = "white",
            draw = function () return life.gaugeType+1 == i end,
            dst = {
                {x = LIFE.GAUGE.X(LIFE), y = LIFE.GAUGE.Y(LIFE), w = LIFE.GAUGE.W, h = LIFE.GAUGE.H, r = bgHighColor[1], g = bgHighColor[2], b = bgHighColor[3]}
            }
        }
        -- 少ない部分
        dst[#dst+1] = {
            id = "white",
            draw = function () return life.gaugeType+1 == i end,
            dst = {
                {x = LIFE.GAUGE.X(LIFE), y = LIFE.GAUGE.Y(LIFE), w = LIFE.GAUGE.W * border / 100, h = LIFE.GAUGE.H, r = bgLowColor[1], g = bgLowColor[2], b = bgLowColor[3]}
            }
        }

        -- 実体
        -- 多い時
        dst[#dst+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "High",
            draw = function () return life.value > border and life.gaugeType+1 == i end,
            dst = {
                {x = LIFE.GAUGE.X(LIFE), y = LIFE.GAUGE.Y(LIFE), w = LIFE.GAUGE.W, h = LIFE.GAUGE.H, r = highColor[1], g = highColor[2], b = highColor[3]}
            }
        }
        -- 少ない部分の色
        dst[#dst+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "Low",
            draw = function () return life.gaugeType+1 == i end,
            dst = {
                {x = LIFE.GAUGE.X(LIFE), y = LIFE.GAUGE.Y(LIFE), w = LIFE.GAUGE.W * border / 100, h = LIFE.GAUGE.H, r = lowColor[1], g = lowColor[2], b = lowColor[3]}
            }
        }
    end
    -- ゲージカバー
    dst[#dst+1] = {
        id = "gaugeGlass", dst = {
            {x = LIFE.GAUGE.X(LIFE), y = LIFE.GAUGE.Y(LIFE), w = LIFE.GAUGE.W, h = LIFE.GAUGE.H, a = 192}
        }
    }
    -- フレーム
    dst[#dst+1] = {
        id = "grooveFrame", dst = {
            {x = LIFE.AREA.X(), y = LIFE.AREA.Y(), w = LIFE.AREA.W, h = LIFE.AREA.H}
        }
    }
    -- ゲージ種類
    for i = 1, #LIFE.TYPES do
        dst[#dst+1] = {
            id = LIFE.TEXT.ID_PREFIX .. LIFE.TYPES[i], draw = function () return life.gaugeType+1 == i end, dst = {
                {x = LIFE.TEXT.X(LIFE), y = LIFE.TEXT.Y(LIFE), w = LIFE.TEXT.W, h = LIFE.TEXT.H}
            }
        }
    end

    -- インディケーター
    for i = 1, #LIFE.TYPES do
        local borderDanger = LIFE.GAUGE.INDICATOR_BORDERS[i][1]
        local borderSafe = LIFE.GAUGE.INDICATOR_BORDERS[i][2]

        -- 100% safeの波紋
        local maxW = LIFE.INDICATOR.W * LIFE.INDICATOR.WAVE_MUL
        local maxH = LIFE.INDICATOR.H * LIFE.INDICATOR.WAVE_MUL
        local cx = LIFE.INDICATOR.X(LIFE) + LIFE.INDICATOR.W / 2
        local cy = LIFE.INDICATOR.Y(LIFE) + LIFE.INDICATOR.H / 2
        dst[#dst+1] = {
            id = "grooveIndicatorSafe", timer = 44, loop = 0,
            draw = function ()
                return life.gaugeType+1 == i
            end,
            dst = {
                {time = 0, x = LIFE.INDICATOR.X(LIFE), y = LIFE.INDICATOR.Y(LIFE), w = LIFE.INDICATOR.W, h = LIFE.INDICATOR.H, a = 255, acc = 2},
                {time = LIFE.INDICATOR.WAVE_TIME, x = cx - maxW / 2, y = cy - maxH / 2, w = maxW, h = maxH, a = 0},
                {time = LIFE.INDICATOR.WAVE_LOOP}
            }
        }

        dst[#dst+1] = {
            id = "grooveIndicatorSafe",
            draw = function ()
                if life.gaugeType+1 ~= i then return false end
                return life.value >= borderSafe
            end,
            dst = {
                {x = LIFE.INDICATOR.X(LIFE), y = LIFE.INDICATOR.Y(LIFE), w = LIFE.INDICATOR.W, h = LIFE.INDICATOR.H}
            }
        }
        dst[#dst+1] = {
            id = "grooveIndicatorWarn",
            draw = function ()
                if life.gaugeType+1 ~= i then return false end
                return borderDanger <= life.value and life.value < borderSafe
            end,
            dst = {
                {x = LIFE.INDICATOR.X(LIFE), y = LIFE.INDICATOR.Y(LIFE), w = LIFE.INDICATOR.W, h = LIFE.INDICATOR.H}
            }
        }

        -- 波紋
        dst[#dst+1] = {
            id = "grooveIndicatorDanger", loop = 0,
            draw = function ()
                if life.gaugeType+1 ~= i then return false end
                return life.value < borderDanger
            end,
            dst = {
                {time = 0, x = LIFE.INDICATOR.X(LIFE), y = LIFE.INDICATOR.Y(LIFE), w = LIFE.INDICATOR.W, h = LIFE.INDICATOR.H, a = 255, acc = 2},
                {time = LIFE.INDICATOR.WAVE_TIME, x = cx - maxW / 2, y = cy - maxH / 2, w = maxW, h = maxH, a = 0},
                {time = LIFE.INDICATOR.WAVE_LOOP}
            }
        }
        dst[#dst+1] = {
            id = "grooveIndicatorDanger",
            draw = function ()
                if life.gaugeType+1 ~= i then return false end
                return life.value < borderDanger
            end,
            dst = {
                {x = LIFE.INDICATOR.X(LIFE), y = LIFE.INDICATOR.Y(LIFE), w = LIFE.INDICATOR.W, h = LIFE.INDICATOR.H}
            }
        }

        -- low danger未満で警告エフェクト
        -- 左側は, 紛らわしいのと可変のため厳しいので出さない
        local lowColor = LIFE.GAUGE.COLORS[i][1]
        local border = LIFE.GAUGE.COLOR_BORDERS[i]
        dst[#dst+1] = {
            id = "warnLeft", loop = 0,
            draw = function ()
                if life.gaugeType+1 ~= i then return false end
                return life.value < borderDanger
            end,
            dst = {
                {time = 0, x = LIFE.GAUGE.X(LIFE) - LIFE.GAUGE.WARN.SHADOW, y = LIFE.GAUGE.Y(LIFE) - LIFE.GAUGE.WARN.SHADOW, w = LIFE.GAUGE.WARN.SHADOW, h = LIFE.GAUGE.WARN.H, a = 0, acc = 2, r = lowColor[1], g = lowColor[2], b = lowColor[3]},
                {time = LIFE.GAUGE.WARN.LOOP_TIME / 2, a = 255},
                {time = LIFE.GAUGE.WARN.LOOP_TIME / 2 + 1, a = 0},
                {time = LIFE.GAUGE.WARN.LOOP_TIME},
            }
        }
        dst[#dst+1] = {
            id = "warnLeft", loop = 0,
            draw = function ()
                if life.gaugeType+1 ~= i then return false end
                return life.value < borderDanger
            end,
            dst = {
                {time = 0, x = LIFE.GAUGE.X(LIFE) - LIFE.GAUGE.WARN.SHADOW, y = LIFE.GAUGE.Y(LIFE) - LIFE.GAUGE.WARN.SHADOW, w = LIFE.GAUGE.WARN.SHADOW, h = LIFE.GAUGE.WARN.H, a = 0, acc = 1, r = lowColor[1], g = lowColor[2], b = lowColor[3]},
                {time = LIFE.GAUGE.WARN.LOOP_TIME / 2, a = 0},
                {time = LIFE.GAUGE.WARN.LOOP_TIME / 2 + 1, a = 255},
                {time = LIFE.GAUGE.WARN.LOOP_TIME, a = 0},
            }
        }
        dst[#dst+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "warn", loop = 0,
            draw = function ()
                if life.gaugeType+1 ~= i then return false end
                return life.value < borderDanger
            end,
            dst = {
                {
                    time = 0,
                    x = LIFE.GAUGE.X(LIFE),
                    y = LIFE.GAUGE.Y(LIFE) - LIFE.GAUGE.WARN.SHADOW,
                    w = LIFE.GAUGE.W * border / 100,
                    h = LIFE.GAUGE.WARN.H,
                    a = 0, r = lowColor[1], g = lowColor[2], b = lowColor[3],
                    acc = 2
                },
                {time = LIFE.GAUGE.WARN.LOOP_TIME / 2, a = 255},
                {time = LIFE.GAUGE.WARN.LOOP_TIME / 2 + 1, a = 0},
                {time = LIFE.GAUGE.WARN.LOOP_TIME},
            }
        }
        dst[#dst+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "warn", loop = 0,
            draw = function ()
                if life.gaugeType+1 ~= i then return false end
                return life.value < borderDanger
            end,
            dst = {
                {
                    time = 0,
                    x = LIFE.GAUGE.X(LIFE),
                    y = LIFE.GAUGE.Y(LIFE) - LIFE.GAUGE.WARN.SHADOW,
                    w = LIFE.GAUGE.W * border / 100,
                    h = LIFE.GAUGE.WARN.H,
                    a = 0, r = lowColor[1], g = lowColor[2], b = lowColor[3],
                    acc = 1
                },
                {time = LIFE.GAUGE.WARN.LOOP_TIME / 2, a = 0},
                {time = LIFE.GAUGE.WARN.LOOP_TIME / 2 + 1, a = 255},
                {time = LIFE.GAUGE.WARN.LOOP_TIME, a = 0},
            }
        }
    end

    -- 値
    dst[#dst+1] = {
        id = "grooveValue", dst = {
            {x = LIFE.NUM.X(LIFE), y = LIFE.NUM.Y(LIFE), w = LIFE.NUM.W, h = LIFE.NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "grooveValueDot", dst = {
            {x = LIFE.NUM.DOT_X(LIFE), y = LIFE.NUM.Y(LIFE), w = LIFE.NUM.W, h = LIFE.NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "grooveValueAfterDot", dst = {
            {x = LIFE.NUM.AFTER_DOT_X(LIFE), y = LIFE.NUM.Y(LIFE), w = LIFE.NUM.W, h = LIFE.NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "percent24px", dst = {
            {x = LIFE.NUM.P_X(LIFE), y = LIFE.NUM.Y(LIFE), w = LIFE.NUM.P_W, h = LIFE.NUM.P_H}
        }
    }

    -- 100%時のキラキラ
    if isDrawGauge100Particle() then
        local size = LIFE.PARTICLE.SIZE
        local loopTime = LIFE.PARTICLE.LOOP_TIME
        local n = getNumOfGauge100Particles()
        for i = 1, n do
            local x = math.random(LIFE.PARTICLE.LEFT_X(LIFE), LIFE.PARTICLE.RIGHT_X(LIFE)) - size / 2
            local y = math.random(LIFE.PARTICLE.BOTTOM_Y(LIFE), LIFE.PARTICLE.TOP_Y(LIFE)) - size / 2
            local a = LIFE.PARTICLE.ALPHA - math.random(0, LIFE.PARTICLE.ALPHA_VAR)
            local dt = math.random(0, loopTime)
            dst[#dst+1] = {
                id = "gauge100Particle", loop = dt, op = {240}, dst = {
                    {time = 0, x = x, y = y, w = size, h = size, a = 0},
                    {time = dt},
                    {time = dt + loopTime / 2, a = 255},
                    {time = dt + loopTime, a = 0}
                }
            }
        end
    end

    -- n%ごとの通知読み込み
    do
        local size = LIFE.GAUGE.LIGHT.SIZE
        local cy = LIFE.GAUGE.LIGHT.CY(LIFE)
        local maxH = LIFE.GAUGE.LIGHT.MAX_H
        local animTime = LIFE.GAUGE.LIGHT.ANIM_TIME
        for i = 0, 100, LIFE.GAUGE.LIGHT.THRESHOLD_INTERVAL do
            local x = LIFE.GAUGE.X(LIFE) - size / 2 + LIFE.GAUGE.W * i / 100
            -- 超えた時
            dst[#dst+1] = {
                id = "lightIndicator", loop = -1, timer = timer_util.timer_observe_boolean(function () return life.value >= i end), dst = {
                    {time = 0, x = x, y = cy, w = size, h = 0, acc = 2},
                    {time = animTime, y = cy - maxH / 2, h = maxH, a = 0},
                }
            }
            -- 下回った時
            dst[#dst+1] = {
                id = "lightIndicator", loop = -1, timer = timer_util.timer_observe_boolean(function () return life.value < i end), dst = {
                    {time = 0, x = x, y = cy, w = size, h = 0, r = 255, g = 128, b = 128, acc = 2},
                    {time = animTime, y = cy - maxH / 2, h = maxH, a = 0},
                }
            }
        end
    end
    return skin
end

return life.functions