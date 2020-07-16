require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local visualizer = {
    lvals = {},
    rvals = {},
    ldensities = {},
    rdensities = {},
    judges = {},
    lastUpdateJudgeSec = 0,
    barIdxOffset = 0,
    nextUpdateTime = 0,

    v2 = {
        vals = {},
        subBaseVals = {}, -- グラフを縮めていくときに基準とする値
        laseScore = 0, -- goodでも波を起こすため
        lastExScore = 0,
    },

    functions = {},
}

local VISUALIZER = {
    UPDATE_INTERVAL = 6000, -- ns
    MOVE_TIME = 800,
    BASE_DENSITY = 1,
    DENSITY_DIV_TIME = 500,
    ERROR_TIME_RAMGE = 60, -- 左右に+-

    AREA = {
        FULL_X = function () return is1P() and lanes.getAreaX() + lanes.getAreaW() + 2 or 0 end,
        X = function () return is1P() and lanes.getAreaX() + lanes.getAreaW() + 67 or 67 end,
        Y = function () return 0 end,
        W = function () return 1280 end,
        FULL_W = function () return 1411 end,
        LEFT_START_X = function (self) return self.BAR.CX(self) - self.BAR.LIGHT end,
        RIGHT_START_X = function (self) return self.BAR.CX(self) - self.BAR.W + self.BAR.LIGHT end,
        REFLEC_H = 130,
    },
    BAR = {
        INTERVAL = 0, -- 計算で初期化
        W = 32,
        MAX_H = 150,
        CX = function (self) return self.AREA.X() + self.AREA.W() / 2 end,
        Y = function (self) return self.AREA.Y() + 130 end,
        N = 150,
        LIGHT = 12,
        DRAW_W = 32,
        BASE_DIV = 16,
        DIVS = {1, 2, 4, 8, 16, 32, 64},
        DIV_IDX = 5,
        SATURATION = 0.5,
        BRIGHTNESS = 1,
        ALPHA = 255,
    },
    BACK_BAR = {
        W = 32,
        H = 89,
        MAX_H = 75,
        SATURATION = 0.5,
        BRIGHTNESS = 1,
        ALPHA = 255,
    },
    REFLEC = {
        SIZE = 211,
        DRAW_SIZE = 422,
        MAX_ALPHA = 96,
        MIN_ALPHA = 16,
        INTERVAL_BAR = 4,
        NUM_Y = 4,
        NUM_X = 1, -- 計算する
        INTERVAL_Z = -60,
    },
    V2 = {
        WAVE_RANGE = 100, -- px +-WAVE_RANGEが反応できる
        NUM_OF_PROTRUSION = 3,
        CREATE_PROTRUSION_RANGE = 400, -- px
        SUB_PER_SEC = 1, -- 1秒間に小さくなる量
    },
    MASK1 = {
        X = function (self) return self.AREA.FULL_X() end,
        Y = function (self) return self.BAR.Y(self) end,
        W = function (self) return self.AREA.FULL_W() end,
        H = function (self) return lanes.getAreaY() - self.BAR.Y(self) end,
    },
    MASK2 = {
        X = function (self) return is1P() and 0 or lanes.getAreaX() end,
        Y = function (self) return 0 end,
        W = function (self) return lanes.getSideSpace() + 4 + lanes.getAreaW() end,
        H = function (self) return lanes.getAreaY() end,
    }
}

local VISUALIZER2 = {
    TO_ZERO_TIME = 500,
}

local function yToTime(y)
    return y * 1000000
end

local function reflecAlphaPercentageToTime(p)
    return p * 100000000
end

-- 高速化のため外出し
local judgeNum = nil -- あとでmain_state.numberを入れる
local pg = 0
local egr = 0
local lgr = 0
local egd = 0
local lgd = 0

local getSec = function ()
    return math.floor(getElapsedTime() / 1000000)
end

local getTimeForDensity = function ()
    return math.floor(getElapsedTime() / 1000 / VISUALIZER.DENSITY_DIV_TIME)
end

local getElapsedTimeForDensity = function ()
    return (getElapsedTime() - getTimeForDensity() * 1000 * VISUALIZER.DENSITY_DIV_TIME)
end

local function updateDensity()
    local nowTime = getTimeForDensity()
    pg = main_state.judge(0)
    egr = judgeNum(412)
    lgr = judgeNum(413)
    egd = judgeNum(414)
    lgd = judgeNum(415)

    -- 現在の判定数を記録
    visualizer.judges[nowTime] = {
        pg = pg,
        egr = egr,
        lgr = lgr,
        egd = egd,
        lgd = lgd,
    }
    -- 前の秒の判定数を取得
    local last = {}
    if visualizer.judges[nowTime - 1] == nil then
        last = {
            pg = 0,
            egr = 0,
            lgr = 0,
            egd = 0,
            lgd = 0,
        }
        visualizer.judges[nowTime - 1] = last
        visualizer.ldensities[nowTime - 1] = 0
        visualizer.rdensities[nowTime - 1] = 0
    else
        last = visualizer.judges[nowTime - 1]
    end
    -- 現在の秒で発生した判定数を計算
    pg = pg - last.pg
    egr = egr - last.egr
    lgr = lgr - last.lgr
    egd = egd - last.egd
    lgd = lgd - last.lgd


    local left = pg + egr + lgr * 0.5 + egd * 0.5 -- early側
    local right = pg + egr * 0.5 + lgr + lgd * 0.5 -- late側
    visualizer.ldensities[nowTime] = left
    visualizer.rdensities[nowTime] = right
end

function updateVisualizer()
    if not main_state.option(81) then
        return 0
    end
    local nowSec = getTimeForDensity()
    local divt = VISUALIZER.DENSITY_DIV_TIME
    local lvals = visualizer.lvals
    local rvals = visualizer.rvals
    local ld = visualizer.ldensities
    local rd = visualizer.rdensities
    while visualizer.nextUpdateTime < getElapsedTime() do
        -- どれだけ判定が発生したか調べて更新
        updateDensity()

        local barIdx = visualizer.barIdxOffset + 1
        visualizer.barIdxOffset = barIdx

        -- 秒未満の密度用単位の値を取得
        local t = getElapsedTimeForDensity() / 1000
        -- 値をもとにビジュアライザーの最新の高さを計算
        local lh = (ld[nowSec] * (t / divt) + ld[nowSec - 1] * (divt - t) / divt) / (VISUALIZER.BASE_DENSITY * divt / 1000)
        local rh = (rd[nowSec] * (t / divt) + rd[nowSec - 1] * (divt - t) / divt) / (VISUALIZER.BASE_DENSITY * divt / 1000)
        lvals[barIdx] = math.min(1, lh)
        rvals[barIdx] = math.min(1, rh)
        -- print(lh)
        -- print(rh)
        visualizer.nextUpdateTime = visualizer.nextUpdateTime + VISUALIZER.UPDATE_INTERVAL
    end
    return 0
end

--[[
    @return int, int 0左1右, idx
]]
local function overallIndexToLeftRightIndex(idx)
    if idx > VISUALIZER.BAR.N / 2 then
        return 1, idx - VISUALIZER.BAR.N / 2
    else
        return 0, idx
    end
end

--[[
    v2用
    @param int x VISUALIZERに対する相対座標
    @return int 該当するバーのidx
]]
local function xToBarIdx(x)
    if x < 0 then return 0 end
    if x > VISUALIZER.AREA.W() then return 0 end
    return math.ceil(x / VISUALIZER.BAR.INTERVAL)
end

--[[
    v2用 指定したidxのバーの中心x座標を取得する
]]
local function barCenterX(idx)
    return VISUALIZER.BAR.INTERVAL * (idx - 0.5)
end

--[[
    v2用の山を作る
]]
local function makeProtrusion(x, pow)
    if x <= 0 then x = 1
    elseif x >= VISUALIZER.AREA.W() then x = VISUALIZER.AREA.W() - 1
    end
    local lbar = xToBarIdx(x - VISUALIZER.V2.WAVE_RANGE)
    local rbar = xToBarIdx(x + VISUALIZER.V2.WAVE_RANGE)
    if lbar == 0 then lbar = 1 end
    if rbar == 0 then rbar = VISUALIZER.BAR.N end

    local div = VISUALIZER.BASE_DENSITY / 2
    local range = VISUALIZER.V2.WAVE_RANGE
    local vals = visualizer.v2.vals
    -- 上限付近での張り付き防止
    local scaleSup = (vals[xToBarIdx(x)]) + pow / div * 2
    if scaleSup < 1 then scaleSup = 1 end
    scaleSup = div / scaleSup * 0.5
    for i = lbar, rbar do
        local dx = math.abs(barCenterX(i) - x)
        local scale = pow * math.cos((dx / range) * math.pi / 2) / scaleSup
        if scale < 0 then scale = 0
        elseif scale > 1 then scale = 1
        end
        -- どーん
        -- 1以上のときに1にする処理はあとでしている
        vals[i] = vals[i] + scale
        visualizer.v2.subBaseVals[i] = vals[i]
    end
end

function updateVisualizer2()
    local pt = main_state.number(100)

    -- スコアが増えていたら波を起こす
    if pt ~= visualizer.v2.laseScore then
        visualizer.v2.laseScore = pt
        local exScore = main_state.exscore()
        local pow = exScore - visualizer.v2.lastExScore
        visualizer.v2.lastExScore = exScore
        if pow == 0 then pow = 0.5 end

        local waveRange = VISUALIZER.V2.WAVE_RANGE

        local hw = VISUALIZER.AREA.W() / 2
        local x = main_state.number(525) * hw / VISUALIZER.ERROR_TIME_RAMGE + hw
        makeProtrusion(x + math.random(-waveRange, waveRange), pow)
        local randomRange = VISUALIZER.V2.CREATE_PROTRUSION_RANGE
        for i = 1, VISUALIZER.V2.NUM_OF_PROTRUSION-1 do
            local dx = math.random(-randomRange, randomRange)
            local randPow = math.random() * 0.75
            makeProtrusion(x + dx, randPow * pow)
        end
    end

    -- 波を減らす
    do
        local vals = visualizer.v2.vals
        local subBaseVals = visualizer.v2.subBaseVals
        local subPerSec = VISUALIZER.V2.SUB_PER_SEC
        local mul = getDeltaTime() / 1000000
        for i = 1, #vals do
            local v = vals[i]
            v = v - subBaseVals[i] / subPerSec * mul
            if v < 0 then v = 0
            elseif v > 1 then v = 1
            end
            vals[i] = v
        end
    end
    return 0
end

visualizer.functions.load = function ()
    local skin = {
        image = {},
        graph = {},
        customTimers = {
            -- {timer = function () pcall(updateVisualizer()) return 0 end},
            {timer = function () pcall(updateVisualizer2()) return 0 end},
        },
    }
    local imgs = skin.image

    judgeNum = main_state.number
    VISUALIZER.BAR.DIV_IDX = getVisualizerBarQuantityLevel()
    local divIdx = VISUALIZER.BAR.DIV_IDX
    -- 各種パラメータ計算
    VISUALIZER.BAR.N = VISUALIZER.AREA.W() / VISUALIZER.BAR.DIVS[divIdx]
    VISUALIZER.BAR.INTERVAL = VISUALIZER.AREA.W() / VISUALIZER.BAR.N
    VISUALIZER.BAR.DRAW_W = VISUALIZER.BAR.DRAW_W * VISUALIZER.BAR.DIVS[divIdx] / VISUALIZER.BAR.DRAW_W
    VISUALIZER.UPDATE_INTERVAL = VISUALIZER.MOVE_TIME / (VISUALIZER.AREA.W() / VISUALIZER.BAR.INTERVAL) * 1000 * getVisualizerPropagationSpeed()
    VISUALIZER.BASE_DENSITY = math.max(1, math.ceil(main_state.number(360)))

    -- 下側の反射の数とサイズ計算
    do
        local mul = VISUALIZER.BAR.BASE_DIV / VISUALIZER.BAR.DIVS[divIdx]
        print(mul)
        VISUALIZER.REFLEC.NUM_X = VISUALIZER.BAR.N / 4
        VISUALIZER.REFLEC.DRAW_SIZE = VISUALIZER.REFLEC.DRAW_SIZE * VISUALIZER.BAR.DRAW_W / VISUALIZER.BAR.W
        VISUALIZER.REFLEC.NUM_Y = VISUALIZER.REFLEC.NUM_Y * mul
        VISUALIZER.REFLEC.INTERVAL_Z = VISUALIZER.REFLEC.INTERVAL_Z / mul
    end
    -- 先に配列を確保
    local lvals = visualizer.lvals
    local rvals = visualizer.rvals
    do
        local playtime = main_state.number(163) * 60 * main_state.number(165)
        local addSec = math.ceil(VISUALIZER.BAR.N * VISUALIZER.UPDATE_INTERVAL) -- *2は余裕をもたせているだけ
        local n = (playtime + addSec) * 1000 / VISUALIZER.UPDATE_INTERVAL
        for i = 1, n do
            lvals[i] = 0
            rvals[i] = 0
        end
    end
    local v2vals = visualizer.v2.vals
    local v2SubBaseVals = visualizer.v2.subBaseVals
    for i = 1, VISUALIZER.BAR.N do
        v2vals[i] = 0
        v2SubBaseVals[i] = 0
    end

    -- 描画部分のグラフを作成
    local g = skin.graph
    myPrint("ビジュアライザー本数: " .. VISUALIZER.BAR.N)
    -- v2
    do
        local vals = visualizer.v2.vals
        if isThinVisualizerBarType() then
            for i = 1, VISUALIZER.BAR.N do
                g[#g+1] = {
                    id = "visualizerFrontBar" .. i, src = 25, x = 0, y = 12, w = -1, h = 1,
                    value = function ()
                        if vals[i] == nil then return 0 end
                        return vals[i]
                    end
                }
            end
            imgs[#imgs+1] = {
                id = "visualizerBackBar", src = 26, x = 0, y = 0, w = -1, h = -1,
            }
        else
            for i = 1, VISUALIZER.BAR.N do
                g[#g+1] = {
                    id = "visualizerFrontBar" .. i, src = 25, x = 12, y = 12, w = 8, h = 1,
                    value = function ()
                        if vals[i] == nil then return 0 end
                        return vals[i]
                    end
                }
            end
            imgs[#imgs+1] = {
                id = "visualizerBackBar", src = 26, x = 12, y = 0, w = 8, h = -1,
            }
        end
    end
    imgs[#imgs+1] = {
        id = "visualizerReflection", src = 27, x = 0, y = 0, w = -1, h = -1
    }
    -- 反射のマスク用
    imgs[#imgs+1] = {
        id = "barReflectionMask", src = 18, x = VISUALIZER.MASK1.X(VISUALIZER), y = HEIGHT - lanes.getAreaY(),
        w = VISUALIZER.MASK1.W(VISUALIZER), h = VISUALIZER.MASK1.H(VISUALIZER)
    }
    imgs[#imgs+1] = {
        id = "barReflectionMask2", src = 18, x = VISUALIZER.MASK2.X(VISUALIZER), y = HEIGHT - VISUALIZER.MASK2.H(VISUALIZER),
        w = VISUALIZER.MASK2.W(VISUALIZER), h = VISUALIZER.MASK2.H(VISUALIZER)
    }
    return skin
end

visualizer.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    local hue = 0
    local addHuePerBar = 360 / VISUALIZER.BAR.N
    local a = VISUALIZER.BAR.ALPHA
    local y = VISUALIZER.BAR.Y(VISUALIZER)
    local vals = visualizer.v2.vals
    local backMaxH = VISUALIZER.BAR.MAX_H
    local calcX = function (i) return VISUALIZER.AREA.X() + VISUALIZER.BAR.INTERVAL * (i - 1) end

    do
        local addHuePerReflec = 360 / VISUALIZER.REFLEC.NUM_X
        local barPerReflec = VISUALIZER.BAR.N / VISUALIZER.REFLEC.NUM_X
        local intervalZ = VISUALIZER.REFLEC.INTERVAL_Z
        local size = VISUALIZER.REFLEC.DRAW_SIZE
        local maxAlpha, minAlpha = VISUALIZER.REFLEC.MAX_ALPHA, VISUALIZER.REFLEC.MIN_ALPHA
        for i = 0, VISUALIZER.REFLEC.NUM_X do
            local r, g, b = hsvToRgb(hue, VISUALIZER.BAR.SATURATION, VISUALIZER.BAR.BRIGHTNESS)
            for j = 1, VISUALIZER.REFLEC.NUM_Y do
                local correspondBar = math.ceil((i - 1) * barPerReflec + 0.5)
                if correspondBar < 1 then correspondBar = 1
                elseif correspondBar > VISUALIZER.BAR.N then correspondBar = VISUALIZER.BAR.N
                end

                local thisMaxAlpha = minAlpha + (maxAlpha - minAlpha) * (VISUALIZER.REFLEC.NUM_Y - j + 1) / VISUALIZER.REFLEC.NUM_Y
                local topY = y + size / 2
                local bottomY = y - size / 2
                local rx = calcX(correspondBar) - size / 2
                local lx = calcX(correspondBar) + size / 2
                local z = intervalZ * (j - 1)
                local tlx, tly = perspectiveProjection(rx, topY, z, 90)
                local trx, bry = perspectiveProjection(lx, bottomY, z, 90)
                dst[#dst+1] = {
                    id = "visualizerReflection",
                    timer = function ()
                        return getElapsedTime() - reflecAlphaPercentageToTime(vals[correspondBar]) * 1000
                    end,
                    dst = {
                        {time = 0, x = tlx, y = bry, w = trx - tlx, h = tly - bry, r = r, g = g, b = b, a = 0},
                        {time = reflecAlphaPercentageToTime(1), a = thisMaxAlpha}
                    }
                }
            end

            hue = hue + addHuePerReflec
        end
    end
    -- バーより奥に反射が出ないようにマスク
    -- dst[#dst+1] = {
    --     id = "barReflectionMask", dst = {
    --         {x = VISUALIZER.MASK1.X(VISUALIZER), y = VISUALIZER.MASK1.Y(VISUALIZER),
    --         w = VISUALIZER.MASK1.W(VISUALIZER), h = VISUALIZER.MASK1.H(VISUALIZER)}
    --     }
    -- }
    -- ゲージ等の部分にかぶらないようにマスク
    dst[#dst+1] = {
        id = "barReflectionMask2", dst = {
            {x = VISUALIZER.MASK2.X(VISUALIZER), y = VISUALIZER.MASK2.Y(VISUALIZER),
            w = VISUALIZER.MASK2.W(VISUALIZER), h = VISUALIZER.MASK2.H(VISUALIZER)}
        }
    }

    hue = 0
    for i = 1, VISUALIZER.BAR.N do
        local br, bg, bb = hsvToRgb(hue, VISUALIZER.BACK_BAR.SATURATION, VISUALIZER.BACK_BAR.BRIGHTNESS)

        dst[#dst+1] = {
            id = "visualizerBackBar", timer = function ()
                if vals[i] == nil then return getElapsedTime() end
                return getElapsedTime() - yToTime(backMaxH * vals[i]) * 1000
            end,
            dst = {
                {time = 0, x = calcX(i), y = y, w = VISUALIZER.BAR.DRAW_W, h = 16, r = br, g = bg, b = bb, a = VISUALIZER.BACK_BAR.ALPHA},
                {time = yToTime(backMaxH), y = y + VISUALIZER.BAR.MAX_H, h = VISUALIZER.BACK_BAR.MAX_H}
            }
        }
        hue = hue + addHuePerBar
    end
    hue = 0
    for i = 1, VISUALIZER.BAR.N do
        local r, g, b = hsvToRgb(hue, VISUALIZER.BAR.SATURATION, VISUALIZER.BAR.BRIGHTNESS)
        dst[#dst+1] = {
            id = "visualizerFrontBar" .. i, dst = {
                {
                    x = calcX(i), y = y, w = VISUALIZER.BAR.DRAW_W, h = VISUALIZER.BAR.MAX_H,
                    r = r, g = g, b = b, a = a
                }
            }
        }
        hue = hue + addHuePerBar
    end
    return skin
end

return visualizer.functions