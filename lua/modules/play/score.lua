require("modules.commons.define")
local main_state = require("main_state")
local playLog = require("modules.commons.playlog")
local playCommons = require("modules.play.commons")

local score = {
    isInited = false,
    now = {
        theoretical = 0,
        you = 0,
        ttarget = 0, -- 自己ベ連動用
        target = 0,
        best = 0,
        notes = 0,
        -- top10 = {}, -- あとで
    },

    -- 今まで押した部分だけでののスコアレート
    nowRate = {
        target = 0,
    },

    -- 現時点でのスコアでの, 全体に対するスコアレート
    nowOverallRate = {
        target = 0,
    },

    whole = {
        theoretical = 2,
        target = 0,
        best = 0,
        -- top10 = {},
    },

    -- 終了時点でのスコアでのレート
    wholeRates = {
        theoretical = 1,
        target = 0,
        best = 0,
        targetDiffByBest = 0,
    },

    functions = {}
}

local SCORE = {
    TOTAL_NOTES = 0,
    SCORE_GRAPH_RATE_TYPE = 0,
}

--[[
    引数に入れたターゲットスコアの情報から, 自己べに連動させたときのスコアの情報を計算して取得する

    @return float, float, float 計算後のターゲットスコア, 計算後のスコアレート, 計算後の譜面全体でのスコアレート, レート100%無視時のスコア
]]
score.functions.calcTargetScoreByBestScore = function (latestData, twoBeforeData, wholeTargetScore, nowTargetScore, targetScoreRateDiff, nowTTargetScore, diffNotes, remaindNotes)
    local resultTargetScore, resultTargetScoreRate, resultTargetOverallRate = 0, 0, 0
    local minTargetScoreDiff = wholeTargetScore - remaindNotes * 2 - nowTargetScore -- これ以降レート100%なら目標スコアに届く
    local maxTargetScoreDiff = wholeTargetScore - nowTargetScore -- これ以降0%なら目標スコアに届く

    local best = latestData.exscore.best
    local bestDiff = best - twoBeforeData.exscore.best

    -- 100%を超えて計算したときのtarget
    nowTTargetScore = best + score.now.theoretical * targetScoreRateDiff
    local baseAddScore = bestDiff + diffNotes * 2 * targetScoreRateDiff
    local adjustedAddScore = baseAddScore + (nowTTargetScore - (nowTargetScore + baseAddScore)) / math.min(2, math.max(1, (remaindNotes / 2)))

    -- 最終的にtargetスコアにたどり着ける範囲に収めて更新
    adjustedAddScore = math.max(0, math.min(diffNotes * 2, adjustedAddScore)) -- 100%を超えないよう調整
    adjustedAddScore = math.max(minTargetScoreDiff, math.min(adjustedAddScore, maxTargetScoreDiff)) -- 目標スコアに届くように調整
    resultTargetScore = nowTargetScore + adjustedAddScore
    -- スコアレート更新
    resultTargetScoreRate = resultTargetScore / score.now.theoretical
    resultTargetOverallRate = resultTargetScore / score.whole.theoretical
    return resultTargetScore, resultTargetScoreRate, resultTargetOverallRate, nowTTargetScore
end

score.functions.updateScoreByBestScore = function ()
    local latestData = playLog.getLastTimeData()
    local twoBeforeData = playLog.twoBeforeData()
    local remaindNotes = SCORE.TOTAL_NOTES - latestData.notes
    local processedNotes = latestData.notes
    local processedDiffNotes = latestData.notes - twoBeforeData.notes

    -- 処理ノートがなければ終わり
    if score.now.notes == processedNotes then return end
    -- 処理したノーツ数更新
    score.now.notes = processedNotes

    -- 自己ベ等は前のログから取ってくる
    score.now.you = latestData.exscore.you
    score.now.best = latestData.exscore.best
    score.now.theoretical = processedNotes * 2
    local resultTargetScore, resultTargetScoreRate, resultTargetOverallRate, resultTTarget
        = score.functions.calcTargetScoreByBestScore(latestData, twoBeforeData, score.whole.target, score.now.target, score.wholeRates.targetDiffByBest, score.now.ttarget, processedDiffNotes, remaindNotes)
    score.now.target = resultTargetScore
    score.nowRate.target = resultTargetScoreRate
    score.nowOverallRate.target = resultTargetOverallRate
    score.now.ttarget = resultTTarget
    -- myPrint("diff ttarget: " .. (score.now.ttarget - score.now.target))
    -- myPrint("diff best: " .. (score.now.target - score.now.best))
    -- myPrint("rate: ", "best: " .. (score.now.best / score.now.theoretical), "target: " .. resultTargetScoreRate)
end

score.functions.getNowBestScore = function ()
    return score.now.best
end

score.functions.getTargetScore = function ()
    return math.floor(score.now.target + 0.5)
end

score.functions.getDiffTargetScoreAndNowScore = function ()
    return score.now.you - score.functions.getTargetScore()
end

score.functions.getTargetWholeScoreRate = function ()
    return score.wholeRates.target
end

score.functions.getTargetScoreRate = function ()
    return score.nowOverallRate.target
end

score.functions.update = function ()
    local getNum = main_state.number
    if not isOutputLog() or SCORE.SCORE_GRAPH_RATE_TYPE == 0 then
        -- 普通の一直線スコア
        -- 自己べ更新
        score.now.you = main_state.exscore()
        score.now.best = score.now.you - getNum(152)
        -- ターゲット更新
        score.now.target = score.now.you - getNum(153)
        score.nowRate.target = main_state.float_number(114)
        score.nowOverallRate.target = main_state.float_number(114)
        score.wholeRates.target = main_state.float_number(115)
    elseif SCORE.SCORE_GRAPH_RATE_TYPE == 1 then
        -- 自己べ等はlogから取ってくる (つまり前のフレームのデータ)
        score.functions.updateScoreByBestScore()
    end
    return 1
end

score.functions.load = function ()
    -- ログ出力必須のため, しないなら終了
    if not isOutputLog() then
        return {}
    end
    local getNum = main_state.number
    SCORE.TOTAL_NOTES = getNum(74)
    SCORE.SCORE_GRAPH_RATE_TYPE = getTargetRateType()
    return {
        customTimers = {
            -- 今はlogger側からupdateを呼んでいる
            -- {
            --     id = CUSTOM_TIMERS.SCORE_VALUE, timer = function ()
            --         score.functions.update()
            --     end
            -- },
            {
                id = CUSTOM_TIMERS.SCORE_VALUE_INITIAL, timer = function ()
                    if score.isInited ~= true and getFrame() > 100 then
                        score.whole.theoretical = SCORE.TOTAL_NOTES * 2
                        score.whole.best = main_state.exscore_best()
                        score.wholeRates.best = score.whole.best / score.whole.theoretical -- best_rate()では取れないらしい
                        
                        myPrint("スコア周りデバッグ出力----------------------")
                        myPrint("スコア理論値: " .. score.whole.theoretical)
                        myPrint("目標スコア: " .. score.whole.target, main_state.float_number(115))
                        myPrint("自己べと目標スコアのレート差: " .. score.wholeRates.targetDiffByBest)
                        score.isInited = true
                    end
                    score.whole.target = main_state.exscore_rival()
                    score.wholeRates.target = main_state.rate_rival()
                    score.whole.targetDiffByBest = score.whole.target - score.whole.best
                    score.wholeRates.targetDiffByBest = score.whole.targetDiffByBest / score.whole.theoretical
                    return 0
                end
            }
        }
    }
end

return score.functions