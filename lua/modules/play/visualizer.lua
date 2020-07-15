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
        laseScore = 0,
    },

    functions = {},
}

local VISUALIZER = {
    UPDATE_INTERVAL = 6000, -- ns
    MOVE_TIME = 800,
    BASE_DENSITY = 1,
    DENSITY_DIV_TIME = 500,
    ERROR_TIME_RAMGE = 200, -- 左右に+-

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
        LIGHT = 12
    },
    BACK_BAR = {
        W = 27,
        H = 89,
    },
    V2 = {
        WAVE_RANGE = 300, -- px +-WAVE_RANGEが反応できる
        NUM_OF_PROTRUSION = 3,
        PROTRUSION_RANGE = 150, -- px
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
    return math.ceil(x / VISUALIZER.BAR.N)
end

function updateVisualizer2()
    local pt = main_state.judge(100)

    -- スコアが増えていたら波を起こす
    if pt ~= visualizer.v2.laseScore then
        pt = visualizer.v2.laseScore

        local hw = VISUALIZER.AREA.W() / 2
        local x = main_state.number(525) * hw / VISUALIZER.ERROR_TIME_RAMGE
    end

    return 0
end

visualizer.functions.load = function ()
    local skin = {
        image = {
            {id = "frontBar", src = 25, x = 0, y = 12, w = -1, h = 1},
            {id = "backBar", src = 26, x = 0, y = 12, w = -1, h = 1},
        },
        graph = {},
        customTimers = {
            -- {timer = function () pcall(updateVisualizer()) return 0 end},
            {timer = function () pcall(updateVisualizer2()) return 0 end},
        },
    }

    judgeNum = main_state.number
    VISUALIZER.BAR.N = numOfVisualizerBar()
    VISUALIZER.BAR.INTERVAL = VISUALIZER.AREA.W() / VISUALIZER.BAR.N
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
    for i = 1, VISUALIZER.BAR.N do
        v2vals[i] = 0
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
        for i = 1, VISUALIZER.BAR.N do
            g[#g+1] = {
                id = "visualizerFrontBarL" .. i, src = 25, x = 0, y = 12, w = -1, h = 1,
                value = function ()
                    if vals[i] == nil then return 0 end
                    return vals[i]
                end
            }
            g[#g+1] = {
                id = "visualizerFrontBarR" .. i, src = 25, x = 0, y = 12, w = -1, h = 1,
                value = function ()
                    if vals[i] == nil then return 0 end
                    return vals[i]
                end
            }
        end
    end
    return skin
end

visualizer.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    for i = 1, VISUALIZER.BAR.N / 2 do
        -- 本数次第で隙間ができるので幅を1足す
        -- 左
        dst[#dst+1] = {
            id = "visualizerFrontBarL" .. i, dst = {
                {
                    x = math.ceil(VISUALIZER.AREA.LEFT_START_X(VISUALIZER) + VISUALIZER.BAR.INTERVAL * (i - 1)),
                    y = VISUALIZER.BAR.Y(VISUALIZER), w = VISUALIZER.BAR.W + 1, h = VISUALIZER.BAR.MAX_H
                }
            }
        }
        -- 右
        dst[#dst+1] = {
            id = "visualizerFrontBarR" .. i, dst = {
                {
                    x = math.floor(VISUALIZER.AREA.RIGHT_START_X(VISUALIZER) - VISUALIZER.BAR.INTERVAL * (i - 1)),
                    y = VISUALIZER.BAR.Y(VISUALIZER), w = VISUALIZER.BAR.W + 1, h = VISUALIZER.BAR.MAX_H
                }
            }
        }
    end
    return skin
end

return visualizer.functions