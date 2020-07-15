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

    ltarget = 0,
    rtarget = 0,

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
    ERROR_TIME_RAMGE = 100, -- 左右に+-

    AREA = {
        X = function () return is1P() and lanes.getAreaX() + lanes.getAreaW() + 67 or 67 end,
        Y = function () return 0 end,
        W = function () return 1280 end,
        LEFT_START_X = function (self) return self.BAR.CX(self) - self.BAR.LIGHT end,
        RIGHT_START_X = function (self) return self.BAR.CX(self) - self.BAR.W + self.BAR.LIGHT end,
    },
    BAR = {
        INTERVAL = 0, -- 計算で初期化
        W = 32,
        MAX_H = 200,
        CX = function (self) return self.AREA.X() + self.AREA.W() / 2 end,
        Y = function (self) return self.AREA.Y() + 130 end,
        N = 150,
        LIGHT = 12,
        DRAW_W = 32,
        DIVS = {1, 2, 4, 8, 16, 32, 64, 128, 160, 256},

        SATURATION = 1,
        BRIGHTNESS = 0.8,
        ALPHA = 96
    },
    BACK_BAR = {
        W = 27,
        H = 89,
    },
    V2 = {
        WAVE_RANGE = 100, -- px +-WAVE_RANGEが反応できる
        NUM_OF_PROTRUSION = 3,
        CREATE_PROTRUSION_RANGE = 400, -- px
        SUB_PER_SEC = 1, -- 1秒間に小さくなる量
    }
}

local VISUALIZER2 = {
    TO_ZERO_TIME = 500,
}

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

    for i = lbar, rbar do
        local dx = math.abs(barCenterX(i) - x)
        local scale = pow * math.cos((dx / range) * math.pi / 2) / div * 2 / scaleSup
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
        image = {
            {id = "frontBar", src = 25, x = 0, y = 12, w = -1, h = 1},
            {id = "frontBarFull", src = 25, x = 12, y = 12, w = 12, h = 1},
            {id = "backBar", src = 26, x = 0, y = 12, w = -1, h = 1},
        },
        graph = {},
        customTimers = {
            -- {timer = function () pcall(updateVisualizer()) return 0 end},
            {timer = function () pcall(updateVisualizer2()) return 0 end},
        },
    }

    judgeNum = main_state.number
    VISUALIZER.BAR.N = VISUALIZER.AREA.W() / VISUALIZER.BAR.DIVS[4]
    VISUALIZER.BAR.INTERVAL = VISUALIZER.AREA.W() / VISUALIZER.BAR.N
    VISUALIZER.BAR.DRAW_W = VISUALIZER.BAR.DRAW_W * VISUALIZER.BAR.DIVS[4] / VISUALIZER.BAR.DRAW_W * 32 / 8
    VISUALIZER.UPDATE_INTERVAL = VISUALIZER.MOVE_TIME / (VISUALIZER.AREA.W() / VISUALIZER.BAR.INTERVAL) * 1000 * getVisualizerPropagationSpeed()
    VISUALIZER.BASE_DENSITY = math.max(1, math.ceil(main_state.number(360)))
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
    -- for i = 1, VISUALIZER.BAR.N / 2 do
    --     g[#g+1] = {
    --         id = "visualizerFrontBarL" .. i, src = 25, x = 0, y = 12, w = -1, h = 1,
    --         value = function ()
    --             local idx = visualizer.barIdxOffset - (i + 1)
    --             if idx <= 0 or idx > #lvals then return 0 end
    --             return lvals[idx]
    --         end
    --     }
    --     g[#g+1] = {
    --         id = "visualizerFrontBarR" .. i, src = 25, x = 0, y = 12, w = -1, h = 1,
    --         value = function ()
    --             local idx = visualizer.barIdxOffset - (i + 1)
    --             if idx <= 0 or idx > #rvals then return 0 end
    --             return rvals[idx]
    --         end
    --     }
    -- end
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
        else
            for i = 1, VISUALIZER.BAR.N do
                g[#g+1] = {
                    id = "visualizerFrontBar" .. i, src = 25, x = 12, y = 12, w = 12, h = 1,
                    value = function ()
                        if vals[i] == nil then return 0 end
                        return vals[i]
                    end
                }
            end
        end
    end
    return skin
end

visualizer.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    local hue = 0
    local addHuePerBar = 360 / VISUALIZER.BAR.N
    local a = VISUALIZER.BAR.ALPHA
    for i = 1, VISUALIZER.BAR.N do
        -- 本数次第で隙間ができるので幅を1足す
        -- 左
        local r, g, b = hsvToRgb(hue, VISUALIZER.BAR.SATURATION, VISUALIZER.BAR.BRIGHTNESS)

        dst[#dst+1] = {
            id = "visualizerFrontBar" .. i, dst = {
                {
                    x = VISUALIZER.AREA.X() + VISUALIZER.BAR.INTERVAL * (i - 1),
                    y = VISUALIZER.BAR.Y(VISUALIZER), w = VISUALIZER.BAR.DRAW_W, h = VISUALIZER.BAR.MAX_H,
                    r = r, g = g, b = b, a = a
                }
            }
        }
        hue = hue + addHuePerBar
    end
    return skin
end

return visualizer.functions