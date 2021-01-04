require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")
local timer_util = require("timer_util")
local playLog = require("modules.commons.playlog")
require("modules.commons.numbers")

local life = {
    functions = {},
    gaugeType = 0,
    value = 0,
    lr2Gauge = {
        gasType = 1,
        gaugeType = 1,
        initGaugeType = 1,
        values = {20, 20, 20, 100, 100, 100, 100, 100, 100}, -- LIFE.TYPESと同じ順
        processedJudges = 0,
        total = 100,
        notes = 1000,
        a = 1, -- 1ノーツあたりのNORMALゲージでの増加量
    }
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
    TYPE_IDX = {AEASY = 1, EAST = 2, NORMAL = 3, HARD = 4, EXHARD = 5, HAZARD = 6, CLASS = 7, EXCLASS = 8, EXHARD_CLASS = 9},
    TYPES = {"Aeasy", "Easy", "Normal", "Hard", "Exhard", "Hazard", "Class", "ExClass", "ExhardClass"},
    TEXT = {
        ID_PREFIX = "grooveTypeText",
        X = function (self) return self.AREA.X() + 4 end,
        Y = function (self) return self.AREA.Y() + 58 end,
        W = 256,
        H = 18,
    },
    HIDDEN = {
        FONT_SIZE = 18,
        X = function (self) return self.GAUGE.X(self) + 4 end,
        Y = function (self) return self.GAUGE.Y(self) end,
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
    LR2GAUGE = {
        B = function () -- ノーツ数での差もあるらしいけど係数は未検証なので無し
            if life.lr2Gauge.total >= 240 then return 1
            elseif life.lr2Gauge.total >= 230 then return 1.11
            elseif life.lr2Gauge.total >= 210 then return 1.25
            elseif life.lr2Gauge.total >= 200 then return 1.5
            elseif life.lr2Gauge.total >= 180 then return 1.666
            elseif life.lr2Gauge.total >= 160 then return 2.0
            elseif life.lr2Gauge.total >= 150 then return 2.5
            elseif life.lr2Gauge.total >= 130 then return 3.333
            elseif life.lr2Gauge.total >= 120 then return 5
            else return 10
            end
        end,
        ACQUISTITIONS = { -- 左から PG GR GD BD PR MS
            {
                function () return life.lr2Gauge.a * 1.3 end,
                function () return life.lr2Gauge.a * 1.3 end,
                function () return life.lr2Gauge.a * 1.3 / 2 end,
                function () return -2.8 end,
                function () return -4.8 end,
                function () return -1.6 end
            }, -- AEASY (想定)
            {
                function () return life.lr2Gauge.a * 1.2 end,
                function () return life.lr2Gauge.a * 1.2 end,
                function () return life.lr2Gauge.a * 1.2 / 2 end,
                function () return -3.2 end,
                function () return -4.8 end,
                function () return -1.6 end
            }, -- EASY
            {
                function () return life.lr2Gauge.a end,
                function () return life.lr2Gauge.a end,
                function () return life.lr2Gauge.a / 2 end,
                function () return -4 end,
                function () return -6 end,
                function () return -2 end
            }, -- NORAML
            {
                function () return 0.1 end,
                function () return 0.1 end,
                function () return 0.1 / 2 end,
                function (self)
                    local a = -6
                    if life.lr2Gauge.values[4] <= 30 then
                        a = a * 0.6
                    end
                    return a + self.LR2GAUGE.B()
                end,
                function (self)
                    local a = -10
                    if life.lr2Gauge.values[4] <= 30 then
                        a = a * 0.6
                    end
                    return a + self.LR2GAUGE.B()
                end,
                function (self)
                    local a = -2
                    if life.lr2Gauge.values[4] <= 30 then
                        a = a * 0.6
                    end
                    return a + self.LR2GAUGE.B()
                end,
            }, -- HARD
            {
                function () return 0.1 end,
                function () return 0.1 end,
                function () return 0.1 / 2 end,
                function (self)
                    local a = -12
                    if life.lr2Gauge.values[5] <= 30 then
                        a = a * 0.6
                    end
                    return a + self.LR2GAUGE.B()
                end,
                function (self)
                    local a = -20
                    if life.lr2Gauge.values[5] <= 30 then
                        a = a * 0.6
                    end
                    return a + self.LR2GAUGE.B()
                end,
                function (self)
                    local a = -12
                    if life.lr2Gauge.values[5] <= 30 then
                        a = a * 0.6
                    end
                    return a + self.LR2GAUGE.B()
                end,
            }, -- EXHARD
            {
                function () return 0.1 end,
                function () return 0.1 end,
                function () return 0.1 / 2 end,
                function () return -100 end,
                function () return -100 end,
                function () return -20 end,
            }, -- HAZARD
            {
                function () return 0.1 end,
                function () return 0.1 end,
                function () return 0.1 / 2 end,
                function ()
                    if life.lr2Gauge.values[7] > 30 then
                        return -2
                    else return -1.2
                    end
                end,
                function ()
                    if life.lr2Gauge.values[7] > 30 then
                        return -3
                    else return -1.8
                    end
                end,
                function ()
                    if life.lr2Gauge.values[7] > 30 then
                        return -2
                    else return -1.2
                    end
                end,
            }, -- 段位
            {
                function () return 0.1 end,
                function () return 0.1 end,
                function () return 0.1 / 2 end,
                function ()
                    if life.lr2Gauge.values[8] > 30 then
                        return -6
                    else return -3.6
                    end
                end,
                function ()
                    if life.lr2Gauge.values[8] > 30 then
                        return -10
                    else return -6
                    end
                end,
                function ()
                    if life.lr2Gauge.values[8] > 30 then
                        return -2
                    else return -1.2
                    end
                end,
            }, -- 段位HARD
            {
                function () return 0.1 end,
                function () return 0.1 end,
                function () return 0.1 / 2 end,
                function ()
                    if life.lr2Gauge.values[9] > 30 then
                        return -12
                    else return -7.2
                    end
                end,
                function ()
                    if life.lr2Gauge.values[9] > 30 then
                        return -20
                    else return -12
                    end
                end,
                function ()
                    if life.lr2Gauge.values[9] > 30 then
                        return -12
                    else return -6
                    end
                end,
            }, -- 段位EXHARD
        }
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

life.functions.lr2GaugeUpdate = function ()
    -- 判定数の差分を取得
    local lastData = playLog.getLastTimeData()
    if lastData == nil then
        return
    end
    -- 処理ノーツ数に差がなければ終わり
    if lastData.judges.sumJudges <= life.lr2Gauge.processedJudges then
        return
    end
    life.lr2Gauge.processedJudges = lastData.judges.sumJudges

    local twoBeforeData = playLog.twoBeforeData()
    local deltaJudges = {0, 0, 0, 0, 0, 0}
    -- 各判定の前回との差分を取得する
    do
        local d1 = lastData.judges
        local d2 = twoBeforeData.judges
        for i = 1, 6 do
            deltaJudges[i] = (d1.early[i] + d1.late[i]) - (d2.early[i] + d2.late[i])
        end
    end

    for gaugeType = 1, #LIFE.TYPES do
        for judgeType = 1, 6 do
            local a = LIFE.LR2GAUGE.ACQUISTITIONS[gaugeType][judgeType](LIFE) * deltaJudges[judgeType]
            -- ゲージ減少時か, 0%より高いとき
            if a < 0 or (a > 0 and life.lr2Gauge.values[gaugeType] > 0) then
                life.lr2Gauge.values[gaugeType] = life.lr2Gauge.values[gaugeType] + a
            end
            -- 通常ゲージは2%で止まる
            local minValue = 0
            if gaugeType <= 3 then
                minValue = 2
            end
            life.lr2Gauge.values[gaugeType] = math.max(life.lr2Gauge.values[gaugeType], minValue)
            life.lr2Gauge.values[gaugeType] = math.min(life.lr2Gauge.values[gaugeType], 100)
        end
    end
    life.functions.updateNowLR2GaugeType()
end

life.functions.updateNowLR2GaugeType = function ()
    local t = life.lr2Gauge.gasType
    if life.lr2Gauge.initGaugeType >= LIFE.TYPE_IDX.CLASS then
        if t == 1 then
            return
        elseif t == 3 then -- best clear
            -- 各ゲージでクリアしているか見る
            for i = LIFE.TYPE_IDX.CLASS, LIFE.TYPE_IDX.EXHARD_CLASS do
                local val = life.lr2Gauge.values[i]
                if i <= LIFE.TYPE_IDX.NORMAL then
                    -- ノーマル以下は一定以上
                    if val >= LIFE.GAUGE.COLOR_BORDERS[i] then
                        life.lr2Gauge.gaugeType = i
                    end
                else -- ハード以上は0%より多ければ
                    if val > 0 then
                        life.lr2Gauge.gaugeType = i
                    end
                end
            end
        elseif t == 4 or t == 2 then -- select to under
            life.lr2Gauge.gaugeType = LIFE.TYPE_IDX.CLASS
            for i = LIFE.TYPE_IDX.CLASS, life.lr2Gauge.initGaugeType do
                local val = life.lr2Gauge.values[i]
                if val > 0 then
                    life.lr2Gauge.gaugeType = i
                end
            end
        end
    else
        if t == 1 then
            return
        elseif t == 2 then -- hard to groove
            if life.lr2Gauge.values[LIFE.TYPE_IDX.HARD] <= 0 or life.lr2Gauge.values[LIFE.TYPE_IDX.EXCLASS] <= 0 then
                life.lr2Gauge.gaugeType = 3
            end
        elseif t == 3 then -- best clear
            -- 各ゲージでクリアしているか見る
            for i = 1, LIFE.TYPE_IDX.HAZARD do
                local val = life.lr2Gauge.values[i]
                if i <= LIFE.TYPE_IDX.NORMAL then
                    -- ノーマル以下は一定以上
                    if val >= LIFE.GAUGE.COLOR_BORDERS[i] then
                        life.lr2Gauge.gaugeType = i
                    end
                else -- ハード以上は0%より多ければ
                    if val > 0 then
                        life.lr2Gauge.gaugeType = i
                    end
                end
            end
        elseif t == 4 then -- select to under
            for i = 1, life.lr2Gauge.initGaugeType do
                local val = life.lr2Gauge.values[i]
                if i <= LIFE.TYPE_IDX.NORMAL then
                    -- ノーマル以下は一定以上
                    if val >= LIFE.GAUGE.COLOR_BORDERS[i] then
                        life.lr2Gauge.gaugeType = i
                    end
                else -- ハード以上は0%より多ければ
                    if val > 0 then
                        life.lr2Gauge.gaugeType = i
                    end
                end
            end
        end
    end
end

life.functions.load = function ()
    LIFE.GAUGE.LIGHT.THRESHOLD_INTERVAL = LIFE.GAUGE.LIGHT.THRESHOLD_INTERVALS[math.max(1, math.min(getLifeGaugeEffectThresholdIdx(), 5))]
    LIFE.GAUGE.LIGHT.MAX_H = LIFE.GAUGE.LIGHT.MAX_H * (100 + getLifeGaugeEffectSizeYOffset()) / 100
    local skin = {
        image = {
            {id = "grooveFrame", src = 43, x = 0, y = 0, w = LIFE.AREA.W, h = LIFE.AREA.H},
            {id = "gaugeGlass", src = 0, x = 432, y = PARTS_TEXTURE_SIZE - LIFE.GAUGE.H, w = 1, h = LIFE.GAUGE.H},
            -- インディケーター
            {id = "grooveIndicatorSafe", src = 40, x = 0, y = 0, w = LIFE.INDICATOR.W, h = LIFE.INDICATOR.H},
            {id = "grooveIndicatorWarn", src = 40, x = LIFE.INDICATOR.W, y = 0, w = LIFE.INDICATOR.W, h = LIFE.INDICATOR.H},
            {id = "grooveIndicatorDanger", src = 40, x = LIFE.INDICATOR.W*2, y = 0, w = LIFE.INDICATOR.W, h = LIFE.INDICATOR.H},

            {id = "grooveValueDot", src = 0, x = PARTS_TEXTURE_SIZE - LIFE.NUM.W, y = 76, w = LIFE.NUM.W, h = LIFE.NUM.H},
            {id = "percent24px", src = 0, x = 1851, y = 76, w = LIFE.NUM.P_W, h = LIFE.NUM.P_H},

            -- 警告エフェクト
            {id = "warnLeft", src = 0, x = 433, y = PARTS_TEXTURE_SIZE - LIFE.GAUGE.WARN.H, w = LIFE.GAUGE.WARN.SHADOW, h = LIFE.GAUGE.WARN.H},
            -- {id = "warnRight", src = 0, x = 433 + 1 + LIFE.GAUGE.WARN.SHADOW, y = PARTS_TEXTURE_SIZE - LIFE.GAUGE.WARN.H, w = LIFE.GAUGE.WARN.SHADOW, h = LIFE.GAUGE.WARN.H},
            -- {id = "warnCenter", src = 0, x = 433 + LIFE.GAUGE.WARN.SHADOW, y = PARTS_TEXTURE_SIZE - LIFE.GAUGE.WARN.H, w = 1, h = LIFE.GAUGE.WARN.H},

            -- 10%ごとのエフェクト
            {id = "lightIndicator", src = 0, x = 22, y = 0, w = LIFE.GAUGE.LIGHT.SIZE, h = LIFE.GAUGE.LIGHT.SIZE},

            -- 100%時のキラ
            {id = "gauge100Particle", src = 41, x = 0, y = 0, w = -1, h = -1},
        },
        value = {
            {id = "grooveValue", src = 0, x = 1880, y = 76, w = NUMBERS_24PX.W * 10, h = NUMBERS_24PX.H, divx = 10, digit = LIFE.NUM.DIGIT, ref = 107},
            {id = "grooveValueAfterDot", src = 0, x = 1880, y = 76, w = NUMBERS_24PX.W * 10, h = NUMBERS_24PX.H, divx = 10, digit = 1, ref = 407},
        },
        graph = {},
        text = {
            {id = "hiddenText", font = 0, size = LIFE.HIDDEN.FONT_SIZE, constantText = "HIDDEN"},
        },
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
            id = LIFE.TEXT.ID_PREFIX .. LIFE.TYPES[i], src = 42,
            x = 0, y = LIFE.TEXT.H * (i - 1), w = LIFE.TEXT.W, h = LIFE.TEXT.H
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

    -- LR2ゲージ読み込み
    for i = 1, #LIFE.TYPES do
        local border = LIFE.GAUGE.COLOR_BORDERS[i]
        -- 少ない部分
        g[#g+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "LR2Low", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0,
            value = function ()
                return math.min(life.lr2Gauge.values[i], border) / border
            end,
        }
        -- WARN
        g[#g+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "LR2warn", src = 0, x = 433 + LIFE.GAUGE.WARN.SHADOW, y = PARTS_TEXTURE_SIZE - LIFE.GAUGE.WARN.H, w = 1, h = LIFE.GAUGE.WARN.H, angle = 0,
            value = function ()
                return math.min(life.lr2Gauge.values[i], border) / border
            end,
        }

        -- 多い部分
        g[#g+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "LR2High", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0,
            value = function ()
                return life.lr2Gauge.values[i] / 100
            end,
        }
    end
    if getIsEnableLR2Gauge() then
        table.insert(skin.customTimers, {
            id = CUSTOM_TIMERS.LIFE_LR2,
            timer = function ()
                life.functions.lr2GaugeUpdate()
                return 1
            end
        })
        life.lr2Gauge.total = main_state.number(368)
        life.lr2Gauge.notes = main_state.number(74)
        print("total: " .. life.lr2Gauge.total)
        print("notes: " .. life.lr2Gauge.notes)
        life.lr2Gauge.a = life.lr2Gauge.total / life.lr2Gauge.notes
        life.lr2Gauge.gasType = getLR2GaugeAutoShiftType()
    end
    life.lr2Gauge.initGaugeType = main_state.gauge_type() + 1
    life.lr2Gauge.gaugeType = life.lr2Gauge.initGaugeType
    print("初期ゲージタイプ: " .. life.lr2Gauge.initGaugeType)
    return skin
end

life.functions.dstNormal = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    local isHiddenSetting = isHiddenGrooveGauge()
    local getTimer = main_state.timer -- cache
    local getIsShowNow = function () return not isHiddenSetting or (isHiddenSetting and getTimer(143) > 0) end

    -- ゲージ背景の黒
    dst[#dst+1] = {
        id = "black", dst = {
            {x = LIFE.GAUGE.X(LIFE), y = LIFE.GAUGE.Y(LIFE), w = LIFE.GAUGE.W, h = LIFE.GAUGE.H, a = 192}
        }
    }

    -- hidden文字
    dst[#dst+1] = {
        id = "hiddenText", draw = function () return not getIsShowNow() end, dst = {
            {x = LIFE.HIDDEN.X(LIFE), y = LIFE.HIDDEN.Y(LIFE), w = 128, h = LIFE.HIDDEN.FONT_SIZE, a = 228}
        }
    }

    -- ゲージ
    local h = LIFE.GAUGE.H
    local y = LIFE.GAUGE.Y(LIFE)
    local bodyH = h
    if getIsEnableLR2Gauge() then
        bodyH = h / 2
    end
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
            draw = function () return getIsShowNow() and life.gaugeType+1 == i end,
            dst = {
                {x = LIFE.GAUGE.X(LIFE), y = y + bodyH, w = LIFE.GAUGE.W, h = bodyH, r = bgHighColor[1], g = bgHighColor[2], b = bgHighColor[3]}
            }
        }
        -- 少ない部分
        dst[#dst+1] = {
            id = "white",
            draw = function () return getIsShowNow() and life.gaugeType+1 == i end,
            dst = {
                {x = LIFE.GAUGE.X(LIFE), y = y + bodyH, w = LIFE.GAUGE.W * border / 100, h = bodyH, r = bgLowColor[1], g = bgLowColor[2], b = bgLowColor[3]}
            }
        }

        -- orajaゲージ実体
        -- 多い時
        dst[#dst+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "High",
            draw = function () return getIsShowNow() and life.value > border and life.gaugeType+1 == i end,
            dst = {
                {x = LIFE.GAUGE.X(LIFE), y = y + bodyH, w = LIFE.GAUGE.W, h = bodyH, r = highColor[1], g = highColor[2], b = highColor[3]}
            }
        }
        -- 少ない部分の色
        dst[#dst+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "Low",
            draw = function () return getIsShowNow() and life.gaugeType+1 == i end,
            dst = {
                {x = LIFE.GAUGE.X(LIFE), y = y + bodyH, w = LIFE.GAUGE.W * border / 100, h = bodyH, r = lowColor[1], g = lowColor[2], b = lowColor[3]}
            }
        }

        -- lr2ゲージ実体
        if getIsEnableLR2Gauge() then
            -- 背景
            -- 多い部分
            dst[#dst+1] = {
                id = "white",
                draw = function () return getIsShowNow() and life.lr2Gauge.gaugeType == i end,
                dst = {
                    {x = LIFE.GAUGE.X(LIFE), y = y, w = LIFE.GAUGE.W, h = bodyH, r = bgHighColor[1], g = bgHighColor[2], b = bgHighColor[3]}
                }
            }
            -- 少ない部分
            dst[#dst+1] = {
                id = "white",
                draw = function () return getIsShowNow() and life.lr2Gauge.gaugeType == i end,
                dst = {
                    {x = LIFE.GAUGE.X(LIFE), y = y, w = LIFE.GAUGE.W * border / 100, h = bodyH, r = bgLowColor[1], g = bgLowColor[2], b = bgLowColor[3]}
                }
            }
            -- ゲージ本体
            -- 多い時
            dst[#dst+1] = {
                id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "LR2High",
                draw = function () return getIsShowNow() and life.lr2Gauge.values[i] > border and life.lr2Gauge.gaugeType == i end,
                dst = {
                    {x = LIFE.GAUGE.X(LIFE), y = y, w = LIFE.GAUGE.W, h = bodyH, r = highColor[1], g = highColor[2], b = highColor[3]}
                }
            }
            -- 少ない部分の色
            dst[#dst+1] = {
                id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "LR2Low",
                draw = function () return getIsShowNow() and life.lr2Gauge.gaugeType == i end,
                dst = {
                    {x = LIFE.GAUGE.X(LIFE), y = y, w = LIFE.GAUGE.W * border / 100, h = bodyH, r = lowColor[1], g = lowColor[2], b = lowColor[3]}
                }
            }
        end
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
            id = LIFE.TEXT.ID_PREFIX .. LIFE.TYPES[i], draw = function () return getIsShowNow() and life.gaugeType+1 == i end, dst = {
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
                return getIsShowNow() and life.gaugeType+1 == i
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
                return getIsShowNow() and life.value >= borderSafe
            end,
            dst = {
                {x = LIFE.INDICATOR.X(LIFE), y = LIFE.INDICATOR.Y(LIFE), w = LIFE.INDICATOR.W, h = LIFE.INDICATOR.H}
            }
        }
        dst[#dst+1] = {
            id = "grooveIndicatorWarn",
            draw = function ()
                if life.gaugeType+1 ~= i then return false end
                return getIsShowNow() and borderDanger <= life.value and life.value < borderSafe
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
                return getIsShowNow() and life.value < borderDanger
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
                return getIsShowNow() and life.value < borderDanger
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
                return getIsShowNow() and life.value < borderDanger
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
                return getIsShowNow() and life.value < borderDanger
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
                return getIsShowNow() and life.value < borderDanger
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
                return getIsShowNow() and life.value < borderDanger
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
        id = "grooveValue", draw = function () return getIsShowNow() end, dst = {
            {x = LIFE.NUM.X(LIFE), y = LIFE.NUM.Y(LIFE), w = LIFE.NUM.W, h = LIFE.NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "grooveValueDot", draw = function () return getIsShowNow() end, dst = {
            {x = LIFE.NUM.DOT_X(LIFE), y = LIFE.NUM.Y(LIFE), w = LIFE.NUM.W, h = LIFE.NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "grooveValueAfterDot", draw = function () return getIsShowNow() end, dst = {
            {x = LIFE.NUM.AFTER_DOT_X(LIFE), y = LIFE.NUM.Y(LIFE), w = LIFE.NUM.W, h = LIFE.NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "percent24px", draw = function () return getIsShowNow() end, dst = {
            {x = LIFE.NUM.P_X(LIFE), y = LIFE.NUM.Y(LIFE), w = LIFE.NUM.P_W, h = LIFE.NUM.P_H}
        }
    }

    -- 100%時のキラキラ
    if isDrawGauge100Particle() then
        local getOp = main_state.option -- cache
        local size = LIFE.PARTICLE.SIZE
        local loopTime = LIFE.PARTICLE.LOOP_TIME
        local n = getNumOfGauge100Particles()
        for i = 1, n do
            local x = math.random(LIFE.PARTICLE.LEFT_X(LIFE), LIFE.PARTICLE.RIGHT_X(LIFE)) - size / 2
            local y = math.random(LIFE.PARTICLE.BOTTOM_Y(LIFE), LIFE.PARTICLE.TOP_Y(LIFE)) - size / 2
            local a = LIFE.PARTICLE.ALPHA - math.random(0, LIFE.PARTICLE.ALPHA_VAR)
            local dt = math.random(0, loopTime)
            dst[#dst+1] = {
                id = "gauge100Particle", loop = dt, draw = function () return getIsShowNow() and getOp(240) end, dst = {
                    {time = 0, x = x, y = y, w = size, h = size, a = 0},
                    {time = dt},
                    {time = dt + loopTime / 2, a = 255},
                    {time = dt + loopTime, a = 0}
                }
            }
        end
    end

    -- n%ごとの通知読み込み
    if not isHiddenSetting then
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

life.functions.dstVertical = function ()
    
end

life.functions.dst = function ()
    if isVerticalGrooveGauge() then
        return life.functions.dstVertical()
    else
        return life.functions.dstNormal()
    end
end

return life.functions