require("modules.commons.define")
require("modules.result.commons")
local main_state = require("main_state")
local playLog = require("modules.commons.playlog")

local scoreGraph = {
    functions = {}
}

local GRAPH = {
    PREFIX = {"notes", "judges", "el", "timing"},
    GAUGE = {
        W = WND_WIDTH - 20,
    },
    JUDGE_GRAPH = {
        W = WND_WIDTH - 20,
    },
}


local SCORE_GRAPH = {
    RES = {1, 2, 3, 5, 6},
    RES_IDX = 1,
    LINE = {
        MIN_H = 1,
        EXSCORE = {
            COLOR = {
                you = {128, 217, 255},
                best = {64, 255, 64},
                target = {255, 0, 0},
            }
        }
    },
    BG = {
        ALPHA = 128,
        COLORS = { -- rgb
            {128, 105, 52}, -- aaa
            {98, 128, 128}, -- aa
            {128, 52, 102}, -- a
            {98, 128, 98}, -- b
            {128, 54, 78}, -- c
            {0, 0, 0}, -- d
            {0, 0, 0}, -- e
            {0, 0, 0}, -- f
            {0, 0, 0}, -- f_2
        }
    },

    CANT_USE_MSG = {
        SIZE = 24,
        X = function (x) return x + 24 end,
        Y = function (y) return y + 290 end,
        W = 587,
    },

    SMOOTH = {
        SMA_N = 7,
        EMA_P = 0.4,
        SMMA_N = 7,
        LWMA_N = 7,
    },

    EXSCORE_KEYS = {"best", "target", "you"},

    SUB = function (lhs, rhs)
        return {you = lhs.you - rhs.you, best = lhs.best - rhs.best, target = lhs.target - rhs.target}
    end,
    ADD = function (lhs, rhs)
        return {you = lhs.you + rhs.you, best = lhs.best + rhs.best, target = lhs.target + rhs.target}
    end,
    DIV = function (lhs, scalar)
        return {you = lhs.you / scalar, best = lhs.best / scalar, target = lhs.target / scalar}
    end,
    MUL = function(lhs, scalar)
        return {you = lhs.you * scalar, best = lhs.best * scalar, target = lhs.target * scalar}
    end,
    COPY = function (val)
        return {you = val.you, best = val.best, target = val.target}
    end
}

local exScores = { -- レートも今はこれを使う
    {
        you = 0,
        best = 0,
        target = 0,
    }
}

scoreGraph.functions.change2p = function ()
    GRAPH.WND_GAUGE.X = LEFT_X
end

scoreGraph.functions.getScoreGraphType = function ()
    return getTableValue(skin_config.option, "スコアグラフ(プレイスキン併用時のみ)", 966) - 965 + 1
end

--[[
    スコアグラフの移動平均タイプを取得
    @return int 1:無し 2:MA 3:EMA 4:SMMA 4:LWMA
]]
scoreGraph.functions.getSmoothType = function ()
    return getTableValue(skin_config.option, "スコアグラフ平滑化", 970) - 970 + 1
end

scoreGraph.functions.load = function ()
    SCORE_GRAPH.LINE.MIN_H = getOffsetValueWithDefault("スコアグラフの1マスの高さ (既定値2)", {h = 2}).h
    SCORE_GRAPH.RES_IDX = getOffsetValueWithDefault("スコアグラフの細かさ (既定値2 1~5 小さいほど細かい)", {w = 2}).w
    SCORE_GRAPH.RES_IDX = math.max(1, math.min(SCORE_GRAPH.RES_IDX, 5))
    -- 平滑化期間設定を取る
    local numOfBar = GRAPH.GAUGE.W / SCORE_GRAPH.RES[SCORE_GRAPH.RES_IDX]
    SCORE_GRAPH.SMOOTH.SMA_N = math.max(1, math.min(getOffsetValueWithDefault("単純移動平均の期間 (既定値7)", {x = 7}).x, numOfBar - 1))
    SCORE_GRAPH.SMOOTH.EMA_P = math.max(1, math.min(getOffsetValueWithDefault("指数移動平均の最新データの重視率 (既定値40 0<x<100)", {x = 40}).x, 99)) / 100
    SCORE_GRAPH.SMOOTH.SMMA_N = math.max(1, math.min(getOffsetValueWithDefault("平滑移動平均 (既定値7)", {x = 7}).x, numOfBar - 1))
    SCORE_GRAPH.SMOOTH.LWMA_N = math.max(1, math.min(getOffsetValueWithDefault("線形加重移動平均 (既定値7)", {x = 7}).x, numOfBar - 1))
    return {
        text = {
            {id = "noScoreGraphMsg", font = 0, size = 24, constantText = "スコアグラフは, プレイスキン併用かつプレイスキンで\nログ出力時のみ利用可能です.\nまた, コースリザルトでは表示することができません."}
        },
    }
end

--[[
    スコアグラフを描画 widthのみ630で固定
]]
scoreGraph.functions.dst = function (areaX, areaY, areaH)
    local areaW = GRAPH.GAUGE.W
    local data = playLog.loadLog()
    local skin = {destination = {
        {id = "white", dst = {
            {x = areaX, y = areaY, w = areaW, h = areaH, r = 0, g = 0, b = 0, a = 96}
        }},
        {id = "noScoreGraphMsg", draw = function () return #data == 0 end, dst = {
            {x = SCORE_GRAPH.CANT_USE_MSG.X(areaX), y = SCORE_GRAPH.CANT_USE_MSG.Y(areaY), w = SCORE_GRAPH.CANT_USE_MSG.W, h = SCORE_GRAPH.CANT_USE_MSG.SIZE}
        }},
    }}
    local dst = skin.destination
    if #data == 0 then return skin end

    local scoreGraphType = scoreGraph.functions.getScoreGraphType()

    -- バー周りの情報
    local totalMicroSec = math.max(data[#data].time, math.max(1, playLog.getSongLength()) * 1000000)
    local barW = SCORE_GRAPH.RES[SCORE_GRAPH.RES_IDX]
    local barH = SCORE_GRAPH.LINE.MIN_H
    local timeLenParBar = totalMicroSec / areaW * barW
    local numOfBar = areaW / barW
    local maxBarIdx = 0
    local hasBestScore = main_state.number(150) > 0
    -- local maxRate, minRate = 0, 1

    myPrint("totalMicroSec: " .. totalMicroSec)
    myPrint("timeLenParBar: " .. timeLenParBar)
    -- スコア周りの情報集計
    do
        -- local lastBarIdx = 0
        for i = 1, #data do
            local now = data[i]
            local barIdx = math.floor(now.time / timeLenParBar) + 1 -- forの都合で1から開始するために1ずらす

            -- スコア周りのグラフ集計
            if scoreGraphType == 1 then
                exScores[barIdx] = now.exscore
            elseif scoreGraphType == 2 then
                -- スコアレート周りのグラフ集計
                do
                    exScores[barIdx] = now.rangeExScore
                end
            end

            maxBarIdx = barIdx
        end

        -- 隙間埋め
        do
            local lastExScore = exScores[1]
            for i = 1, numOfBar do
                local exScore = exScores[i]
                if exScore ~= nil then
                    lastExScore = exScore
                else
                    exScores[i] = lastExScore
                end
            end
        end
    end

    -- 移動平均出す
    do
        local smoothed = {}
        local type = scoreGraph.functions.getSmoothType()
        local scoreAdd = SCORE_GRAPH.ADD
        local scoreSub = SCORE_GRAPH.SUB
        local scoreMul = SCORE_GRAPH.MUL
        local scoreDiv = SCORE_GRAPH.DIV
        local scoreCopy = SCORE_GRAPH.COPY
        if type == 2 then
            -- SMA
            local range = SCORE_GRAPH.SMOOTH.SMA_N
            local rangeSum = {exScores = {you = 0, best = 0, target = 0}, n = 0}
            for i = 1, numOfBar do
                rangeSum.exScores = scoreAdd(rangeSum.exScores, exScores[i])
                rangeSum.n = rangeSum.n + 1
                if rangeSum.n > range then
                    rangeSum.exScores = scoreSub(rangeSum.exScores, exScores[i - range])
                    rangeSum.n = range
                end
                smoothed[i] = scoreDiv(rangeSum.exScores, rangeSum.n)
            end
            exScores = smoothed
        elseif type == 3 then
            -- EMA
            local p = SCORE_GRAPH.SMOOTH.EMA_P
            smoothed[0] = exScores[1]
            for i = 1, numOfBar do
                smoothed[i] =
                    scoreAdd(
                        scoreMul(exScores[i], p), scoreMul(smoothed[i - 1], (1 - p))
                    )
            end
            exScores = smoothed
        elseif type == 4 then
            -- SMMA
            local n = SCORE_GRAPH.SMOOTH.SMMA_N
            smoothed[0] = exScores[1]
            for i = 1, numOfBar do
                smoothed[i] =
                    scoreDiv(
                        scoreAdd(
                            scoreMul(
                                smoothed[i - 1], (n - 1)
                            ), exScores[i]
                        ), n)
            end
            exScores = smoothed
        elseif type == 5 then
            -- LWMA
            local range = SCORE_GRAPH.SMOOTH.LWMA_N
            -- 平均を出すため, マイナス方面に少し追加する
            for i = 1, range do
                exScores[-i + 1] = exScores[1]
            end
            local numN = ((range + 1) * range / 2)
            for i = 1, numOfBar do
                local sum = {you = 0, best = 0, target = 0}
                for j = 1, range do
                    sum = scoreAdd(sum, scoreMul(exScores[i - j + 1], range - j + 1))
                end
                smoothed[i] = scoreDiv(sum, numN)
            end
            exScores = smoothed
        end
    end


    -- 背景描画
    -- aaa ~ fまで
    for i = 1, 9 do
        local color = SCORE_GRAPH.BG.COLORS[i]
        local bottomY = areaY
        local graphH = areaH
        local y = bottomY + graphH - math.ceil(graphH * 0.111111 * (i - 1))
        local nextY = bottomY + graphH - math.ceil(graphH * 0.111111 * i)
        dst[#dst+1] = {
            id = "white", dst = {
                {x = areaX, y = nextY, w = areaW, h = y - nextY, r = color[1], g = color[2], b = color[3], a = SCORE_GRAPH.BG.ALPHA}
            }
        }
    end

    -- 判定グラフ出力
    do
        local type = getGraphType(4)
        if 0 < type and type < 5 then
            local prefix = GRAPH.PREFIX[type]
            local p = getGrooveNotesGraphSizePercentage()
            dst[#dst+1] = {
                id = prefix .. "Graph", blend = type == 4 and 2 or 1, dst = {
                    {x = areaX, y = areaY, w = GRAPH.JUDGE_GRAPH.W, h = areaH * p, a = getGrooveNotesGraphTransparency()}
                }
            }
        end
    end

    -- スコア描画
    do
        local colors = SCORE_GRAPH.LINE.EXSCORE.COLOR
        local bottomY = areaY
        local areaH = areaH - barH -- 引かないとはみ出す
        local fitstX = areaX
        local maxExScore = main_state.number(74) * 2
        local calcExScoreY = function (s) return bottomY + math.ceil(areaH * s / maxExScore) end
        local calcRateY    = function (s) return bottomY + math.ceil(areaH * s) end

        -- まず最後のスコアで薄く線をかく
        do
            local rates = {main_state.float_number(113), main_state.float_number(115), main_state.float_number(111)}
            for j = 1, #SCORE_GRAPH.EXSCORE_KEYS do
                local key = SCORE_GRAPH.EXSCORE_KEYS[j]
                local color = colors[key]
                local y = calcRateY(rates[j])
                dst[#dst+1] = {
                    id = "white", dst = {
                        {x = areaX, y = y, w = areaW, h = barH, r = color[1], g = color[2], b = color[3], a = 96}
                    }
                }
            end
        end

        local lastExScore = exScores[1]
        for i = 1, numOfBar do
            local exScore = exScores[i]
            local x = fitstX + (i - 1) * barW

            for j = 1, #SCORE_GRAPH.EXSCORE_KEYS do
                local key = SCORE_GRAPH.EXSCORE_KEYS[j]
                local color = colors[key]

                if exScore ~= nil then
                    local lastY, y = 0, 0
                    if scoreGraphType == 1 then
                        lastY = calcExScoreY(lastExScore[key])
                        y = calcExScoreY(exScore[key])
                    elseif scoreGraphType == 2 then
                        lastY = calcRateY(lastExScore[key])
                        y = calcRateY(exScore[key])
                    end
                    -- 今回のスコアを描画する
                    local h = y - lastY
                    if h >= 0 then h = h + 1
                    else
                        lastY = lastY + 1
                        h = h - 1
                    end

                    if h < 0 then h = math.min(-barH, h)
                    elseif h >= 0 then h = math.max(barH, h)
                    end

                    dst[#dst+1] = {
                        id = "white", dst = {
                            {x = x, y = lastY, w = barW, h = h, r = color[1], g = color[2], b = color[3]}
                        }
                    }
                elseif lastExScore ~= nil then
                    -- スコアがなければ, 最後に見たスコアを描画する
                    local lastY = 0

                    if scoreGraphType == 1 then
                        lastY = calcExScoreY(lastExScore[key])
                    elseif scoreGraphType == 2 then
                        lastY = calcRateY(lastExScore[key])
                    end
                    -- 最後の部分までのfill中
                    dst[#dst+1] = {
                        id = "white", dst = {
                            {x = x, y = lastY, w = barW, h = barH, r = color[1], g = color[2], b = color[3]}
                        }
                    }
                end
            end
            if exScore ~= nil then
                lastExScore = exScore
            end
        end
    end
    return skin
end

return scoreGraph.functions