require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")
local playLog = require("modules.commons.playlog")
local life_image = require("modules.play.life_image")
require("modules.commons.numbers")

local life = {
    functions = {},
    gaugeType = 0,
    value = 0,
    lr2Gauge = {
        gasType = 1,
        minGaugeType = 1,
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
        X = function() return lanes.getAreaX() - (is1P() and 0 or 5) end,
        Y = function() return 118 end,
        W = 437,
        H = 239,
    },
    NUM = {
        X = function (self) return self.AREA.X() + 357 end,
        Y = function (self) return self.AREA.Y() + 198 end,
        DOT_X = function (self) return self.AREA.X() + 389 end,
        AFTER_DOT_X = function (self) return self.AREA.X() + 398 end,
        P_X = function (self) return self.AREA.X() + 409 end,
        W = 10,
        H = 18,
        P_W = 10,
        P_H = 18,
        DIGIT = 3,
    },
    TYPE_IDX = {AEASY = 1, EAST = 2, NORMAL = 3, HARD = 4, EXHARD = 5, HAZARD = 6, CLASS = 7, EXCLASS = 8, EXHARD_CLASS = 9},
    TYPES = {"Aeasy", "Easy", "Normal", "Hard", "Exhard", "Hazard", "Class", "ExClass", "ExhardClass"},
    TEXT = {
        ID_PREFIX = "grooveTypeText",
        X = function (self) return self.AREA.X() + 11 end,
        Y = function (self) return self.AREA.Y() + 197 end,
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
        X = function (self) return self.AREA.X() + 10 end,
        Y = function (self) return self.AREA.Y() + 161 end,
        W = 416,
        H = 31,
        COLORS = {
            {
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
            {
                {{251, 137, 255}, {247, 33, 255}},
                {{64, 200, 64}, {255, 69, 3}},
                {{64, 255, 255}, {255, 69, 3}},
                {{255, 0, 0}, {255, 0, 0}},
                {{255, 150, 0}, {255, 150, 0}},
                {{200, 200, 200}, {200, 200, 200}},
                {{255, 0, 0}, {255, 0, 0}},
                {{255, 150, 0}, {255, 150, 0}},
                {{200, 200, 200}, {200, 200, 200}},
            },
        },
        BG_COLORS = {
            {
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
            {
                {{46, 16, 46}, {77, 32, 61}},
                {{16, 46, 16}, {50, 7, 0}},
                {{16, 46, 46}, {50, 7, 0}},
                {{46, 16, 0}, {46, 16, 0}},
                {{58, 58, 0}, {58, 58, 1}},
                {{64, 64, 64}, {64, 64, 64}},
                {{46, 16, 0}, {46, 16, 0}},
                {{58, 58, 0}, {58, 58, 1}},
                {{64, 64, 64}, {64, 64, 64}},
            },
        },
        COLOR_BORDERS = {
            60, 80, 80, 30, 30, 30, 30, 30, 30,
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
        VALS = {
            {140, 140, 70, -28, -40, -12}, -- AEASY
            {120, 120, 60, -32, -48, -16}, -- EASY
            {100, 100, 50, -40, -60, -20}, -- NORMAL
            {10, 10, 5, -60, -100, -20}, -- HARD
            {10, 10, 5, -120, -200, -120}, -- EXHARD
            {10, 10, 5, -1000, -1000, -200}, -- HAZARD
            {10, 10, 5, -20, -30, -20}, -- CLASS
            {10, 10, 5, -60, -100, -20}, -- CLASS HARD
            {10, 10, 5, -120, -200, -120}, -- CLASS HARD
        },
        CORRECTIONS = {
            HARD = 0.6,
            EXHARD = 0.6,
        },
        ACQUISTITIONS = function (self, gaugeType, judge)
            local v = 0
            if gaugeType <= self.TYPE_IDX.NORMAL and judge <= 3 then -- 通常ゲージの増加 (totalでの増加量に対する百分率)
                v = life.lr2Gauge.a * self.LR2GAUGE.VALS[gaugeType][judge] / 100
            elseif gaugeType >= self.TYPE_IDX.HARD and judge <= 3 then -- ハードゲージの増加 (0.01倍)
                v = self.LR2GAUGE.VALS[gaugeType][judge] / 100
            else -- 減少 (0.1倍)
                v = self.LR2GAUGE.VALS[gaugeType][judge] / 10
            end
            if v < 0 then -- 減少時かつHARD, EXHARD時は30%以下のときに補正をかける
                if gaugeType == self.TYPE_IDX.HARD and life.lr2Gauge.values[self.TYPE_IDX.HARD] <= 30 then
                    return v * self.LR2GAUGE.CORRECTIONS.HARD
                elseif gaugeType == self.TYPE_IDX.EXHARD and life.lr2Gauge.values[self.TYPE_IDX.EXHARD] <= 30 then
                    return v * self.LR2GAUGE.CORRECTIONS.EXHARD
                end
            end
            return v
        end,
    },
}

life.functions.initCustomGauge = function ()
    local labels = {"AEASY", "EASY", "NORMAL", "HARD", "EXHARD"}
    local judges = {"PG", "GR", "GD", "BD", "PR", "MS"}
    -- 値をとってきて入れる
    for i, value in ipairs(LIFE.LR2GAUGE.VALS) do
        if i < 6 then -- hazardは無視
            local namePrefix = "カスタムゲージ" .. labels[i] .. " "
            for j = 1, 6, 1 do
                local name = namePrefix .. judges[j]
                if i <= 3 and j <= 3 then -- normalまでかつPG, GR, GDはtotalでの増加量に対する倍率
                    name = name .. "増加率 (%"
                elseif i > 3 and j <= 3 then -- hardとexhardの増加量は0.01
                    name = name .. "増加量 (0.01%"
                else
                    name = name .. "増加量 (0.1%"
                end
                name = name .. " 既定値" .. value[j] .. ")"
                local v = getOffsetValueWithDefault(name, {x = value[j]}).x
                if v == 9999 or v == -9999 then
                    value[j] = 0
                else
                    value[j] = v
                end
            end
        end
    end

    -- 30%補正
    LIFE.LR2GAUGE.CORRECTIONS.HARD = getOffsetValueWithDefault("カスタムゲージHARD 30%補正時の減少量倍率 (% 既定値60)", {x = 60}).x / 100
    LIFE.LR2GAUGE.CORRECTIONS.EXHARD = getOffsetValueWithDefault("カスタムゲージEXHARD 30%補正時の減少量倍率 (% 既定値60)", {x = 60}).x / 100
    print("30%補正 hard: " .. (LIFE.LR2GAUGE.CORRECTIONS.HARD * 100) .. "%")
    print("30%補正 exhard: " .. (LIFE.LR2GAUGE.CORRECTIONS.EXHARD * 100) .. "%")
    life.lr2Gauge.total = main_state.number(368)
    life.lr2Gauge.notes = main_state.number(74)
    life.lr2Gauge.a = life.lr2Gauge.total / life.lr2Gauge.notes
    print("1ノーツあたりの増加量: " .. life.lr2Gauge.a)
    life.lr2Gauge.gasType = getLR2GaugeAutoShiftType()
    life.lr2Gauge.minGaugeType = getLR2GaugeAutoShiftMinType()

    life_image.load()
end

life.functions.customGaugeUpdate = function ()
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
            local a = LIFE.LR2GAUGE.ACQUISTITIONS(LIFE, gaugeType, judgeType) * deltaJudges[judgeType]
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
    local minGaugeType = math.min(life.lr2Gauge.minGaugeType or LIFE.TYPE_IDX.AEASY, LIFE.TYPE_IDX.EXHARD)
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
        if t == 1 then -- GAS無し
            return
        elseif t == 2 then -- hard to groove
            -- 段位ゲージ時はGASは無し
            if life.lr2Gauge.gaugeType >= LIFE.TYPE_IDX.CLASS then
                return
            end
            if life.lr2Gauge.values[LIFE.TYPE_IDX.HARD] <= 0 then
                life.lr2Gauge.gaugeType = math.max(LIFE.TYPE_IDX.NORMAL, minGaugeType)
            end
        elseif t == 3 then -- best clear
            -- 各ゲージでクリアしているか見る
            if life.lr2Gauge.gaugeType < LIFE.TYPE_IDX.CLASS then
                life.lr2Gauge.gaugeType = minGaugeType
                for i = minGaugeType, LIFE.TYPE_IDX.HAZARD do
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
            else
                -- 段位ゲージ 未実装
            end
        elseif t == 4 then -- select to under
            if life.lr2Gauge.gaugeType < LIFE.TYPE_IDX.CLASS then
                life.lr2Gauge.gaugeType = minGaugeType
                for i = minGaugeType, life.lr2Gauge.initGaugeType do
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
            else
                -- 段位ゲージ 未実装
            end
        end
        if life.lr2Gauge.gaugeType < minGaugeType then
            life.lr2Gauge.gaugeType = minGaugeType
        end
    end
end

life.functions.getIsEnableLR2Gauge = function ()
    return isOutputLog() and getIsEnableLR2Gauge() and main_state.gauge_type() + 1 < LIFE.TYPE_IDX.CLASS
end

life.functions.load = function ()
    local skin = {
        image = {
            {id = "grooveAndScoreFrame", src = 43, x = 0, y = 0, w = -1, h = -1},
            {id = "gaugeGlass", src = 0, x = 0, y = 1560, w = LIFE.GAUGE.W, h = LIFE.GAUGE.H},
            {id = "grooveGaugeBg", src = 0, x = 0, y = 1593, w = LIFE.GAUGE.W, h = LIFE.GAUGE.H},
            {id = "grooveGaugeFrame", src = 0, x = 0, y = 1627, w = 419, h = 35},
            {id = "grooveValueDot", src = 0, x = 2038, y = 252, w = LIFE.NUM.W, h = LIFE.NUM.H},
            {id = "percent24px", src = 0, x = 1928, y = 252, w = LIFE.NUM.P_W, h = LIFE.NUM.P_H},
        },
        value = {
            {id = "grooveValue", src = 0, x = 1938, y = 252, w = LIFE.NUM.W * 10, h = LIFE.NUM.H, divx = 10, digit = LIFE.NUM.DIGIT, ref = 107},
            {id = "grooveValueAfterDot", src = 0, x = 1938, y = 252, w = LIFE.NUM.W * 10, h = LIFE.NUM.H, divx = 10, digit = 1, ref = 407},
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
        -- 多い部分
        g[#g+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "LR2High", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0,
            value = function ()
                return life.lr2Gauge.values[i] / 100
            end,
        }
    end

    -- カスタムゲージ. 段位ゲージ時は使用しない
    if life.functions.getIsEnableLR2Gauge() then
        life.functions.initCustomGauge()

        table.insert(skin.customTimers, {
            id = CUSTOM_TIMERS.LIFE_LR2,
            timer = function ()
                life.functions.customGaugeUpdate()
                return 1
            end
        })
        local tn = main_state.number(74)
        table.insert(skin.customTimers, {
            id = CUSTOM_TIMERS.LIFE_OUTPUT,
            timer = function ()
                if main_state.timer(48) > 0 or main_state.timer(3) > 0 or playLog.getLastTimeData().notes == tn then
                    life_image.output()
                end
            end
        })
    end
    life.lr2Gauge.initGaugeType = main_state.gauge_type() + 1
    life.lr2Gauge.gaugeType = life.lr2Gauge.initGaugeType
    print("初期ゲージタイプ: " .. life.lr2Gauge.initGaugeType)
    return skin
end

life.functions.getCustomGauges = function ()
    return life.lr2Gauge.values
end

life.functions.dstNormal = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    local isHiddenSetting = isHiddenGrooveGauge()
    local getTimer = main_state.timer -- cache
    local getIsShowGrooveGauge = function () return not isHiddenSetting or (isHiddenSetting and getTimer(143) > 0) end

    -- 全体フレーム
    dst[#dst+1] = {
        id = "grooveAndScoreFrame", dst = {
            {x = LIFE.AREA.X(), y = LIFE.AREA.Y(), w = LIFE.AREA.W, h = LIFE.AREA.H}
        }
    }

    -- ゲージ背景
    dst[#dst+1] = {
        id = "grooveGaugeBg", dst = {
            {x = LIFE.GAUGE.X(LIFE), y = LIFE.GAUGE.Y(LIFE), w = LIFE.GAUGE.W, h = LIFE.GAUGE.H}
        }
    }

    -- ゲージ
    local h = LIFE.GAUGE.H
    local y = LIFE.GAUGE.Y(LIFE)
    local bodyH = h
    local orajaGaugeY = y
    local customGaugeY = y
    if life.functions.getIsEnableLR2Gauge() then
        bodyH = h / 2
        if getLR2GaugePosition() == 1 then
            customGaugeY = y + bodyH -- カスタムが上
        else
            orajaGaugeY = y + bodyH -- orajaが上
        end
    end
    local colors = LIFE.GAUGE.COLORS[getGrooveGaugeColorType()]
    local bgColors = LIFE.GAUGE.BG_COLORS[getGrooveGaugeColorType()]
    for i = 1, #LIFE.TYPES do
        local border = LIFE.GAUGE.COLOR_BORDERS[i]
        local lowColor = colors[i][1]
        local highColor = colors[i][2]
        local bgLowColor = bgColors[i][1]
        local bgHighColor = bgColors[i][2]

        -- 背景
        -- 多い部分
        dst[#dst+1] = {
            id = "white",
            draw = function () return getIsShowGrooveGauge() and life.gaugeType+1 == i end,
            dst = {
                {x = LIFE.GAUGE.X(LIFE), y = orajaGaugeY, w = LIFE.GAUGE.W, h = bodyH, r = bgHighColor[1], g = bgHighColor[2], b = bgHighColor[3]}
            }
        }
        -- 少ない部分
        dst[#dst+1] = {
            id = "white",
            draw = function () return getIsShowGrooveGauge() and life.gaugeType+1 == i end,
            dst = {
                {x = LIFE.GAUGE.X(LIFE), y = orajaGaugeY, w = LIFE.GAUGE.W * border / 100, h = bodyH, r = bgLowColor[1], g = bgLowColor[2], b = bgLowColor[3]}
            }
        }

        -- orajaゲージ実体
        -- 多い時
        dst[#dst+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "High",
            draw = function () return getIsShowGrooveGauge() and life.value > border and life.gaugeType+1 == i end,
            dst = {
                {x = LIFE.GAUGE.X(LIFE), y = orajaGaugeY, w = LIFE.GAUGE.W, h = bodyH, r = highColor[1], g = highColor[2], b = highColor[3]}
            }
        }
        -- 少ない部分の色
        dst[#dst+1] = {
            id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "Low",
            draw = function () return getIsShowGrooveGauge() and life.gaugeType+1 == i end,
            dst = {
                {x = LIFE.GAUGE.X(LIFE), y = orajaGaugeY, w = LIFE.GAUGE.W * border / 100, h = bodyH, r = lowColor[1], g = lowColor[2], b = lowColor[3]}
            }
        }

        -- lr2ゲージ実体
        if life.functions.getIsEnableLR2Gauge() then
            -- 背景
            -- 多い部分
            dst[#dst+1] = {
                id = "white",
                draw = function () return getIsShowGrooveGauge() and life.lr2Gauge.gaugeType == i end,
                dst = {
                    {x = LIFE.GAUGE.X(LIFE), y = customGaugeY, w = LIFE.GAUGE.W, h = bodyH, r = bgHighColor[1], g = bgHighColor[2], b = bgHighColor[3]}
                }
            }
            -- 少ない部分
            dst[#dst+1] = {
                id = "white",
                draw = function () return getIsShowGrooveGauge() and life.lr2Gauge.gaugeType == i end,
                dst = {
                    {x = LIFE.GAUGE.X(LIFE), y = customGaugeY, w = LIFE.GAUGE.W * border / 100, h = bodyH, r = bgLowColor[1], g = bgLowColor[2], b = bgLowColor[3]}
                }
            }
            -- ゲージ本体
            -- 多い時
            dst[#dst+1] = {
                id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "LR2High",
                draw = function () return getIsShowGrooveGauge() and life.lr2Gauge.values[i] > border and life.lr2Gauge.gaugeType == i end,
                dst = {
                    {x = LIFE.GAUGE.X(LIFE), y = customGaugeY, w = LIFE.GAUGE.W, h = bodyH, r = highColor[1], g = highColor[2], b = highColor[3]}
                }
            }
            -- 少ない部分の色
            dst[#dst+1] = {
                id = LIFE.GAUGE.ID_PREFIX .. LIFE.TYPES[i] .. "LR2Low",
                draw = function () return getIsShowGrooveGauge() and life.lr2Gauge.gaugeType == i end,
                dst = {
                    {x = LIFE.GAUGE.X(LIFE), y = customGaugeY, w = LIFE.GAUGE.W * border / 100, h = bodyH, r = lowColor[1], g = lowColor[2], b = lowColor[3]}
                }
            }
        end
    end
    -- overlay
    dst[#dst+1] = {
        id = "gaugeGlass", blend = 4, dst = {
            {x = LIFE.GAUGE.X(LIFE), y = LIFE.GAUGE.Y(LIFE), w = LIFE.GAUGE.W, h = LIFE.GAUGE.H}
        }
    }

    -- グルーヴゲージ枠
    dst[#dst+1] = {
        id = "grooveGaugeFrame", dst = {
            {x = LIFE.GAUGE.X(LIFE) - 2, y = LIFE.GAUGE.Y(LIFE) - 2, w = 419, h = 35}
        }
    }

    -- ゲージ種類
    for i = 1, #LIFE.TYPES do
        dst[#dst+1] = {
            id = LIFE.TEXT.ID_PREFIX .. LIFE.TYPES[i], draw = function () return getIsShowGrooveGauge() and life.gaugeType+1 == i end, dst = {
                {x = LIFE.TEXT.X(LIFE), y = LIFE.TEXT.Y(LIFE), w = LIFE.TEXT.W, h = LIFE.TEXT.H}
            }
        }
    end

    -- 値
    dst[#dst+1] = {
        id = "grooveValue", draw = function () return getIsShowGrooveGauge() end, dst = {
            {x = LIFE.NUM.X(LIFE), y = LIFE.NUM.Y(LIFE), w = LIFE.NUM.W, h = LIFE.NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "grooveValueDot", draw = function () return getIsShowGrooveGauge() end, dst = {
            {x = LIFE.NUM.DOT_X(LIFE), y = LIFE.NUM.Y(LIFE), w = LIFE.NUM.W, h = LIFE.NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "grooveValueAfterDot", draw = function () return getIsShowGrooveGauge() end, dst = {
            {x = LIFE.NUM.AFTER_DOT_X(LIFE), y = LIFE.NUM.Y(LIFE), w = LIFE.NUM.W, h = LIFE.NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "percent24px", draw = function () return getIsShowGrooveGauge() end, dst = {
            {x = LIFE.NUM.P_X(LIFE), y = LIFE.NUM.Y(LIFE), w = LIFE.NUM.P_W, h = LIFE.NUM.P_H}
        }
    }

    return skin
end

life.functions.dst = function ()
    return life.functions.dstNormal()
end

return life.functions
