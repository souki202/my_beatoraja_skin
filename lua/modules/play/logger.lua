require("modules.commons.define")
local playLog = require("modules.commons.playlog")
local commons = require("modules.play.commons")
local scores = require("modules.play.score")
local life = require("modules.play.life")
local main_state = require("main_state")

local logger = {
    didSave = false,
    functions = {}
}

local LOGGER = {

}

local EXSCORE_RATE = {
    SAMPLES = {
        NOTES = 50,
        MICRO_SEC = 1000000 * 10,
    }
}

logger.functions.load = function ()
    -- ログ出力しないなら終了
    if not isOutputLog() then
        return {
            customTimers = {
                {
                    id = CUSTOM_TIMERS.LOGGER, timer = function () -- ログ取得
                        scores.update()
                        return 1
                    end
                }
            }
        }
    end
    EXSCORE_RATE.SAMPLES.NOTES = getScoreRateSampleNotes()
    EXSCORE_RATE.SAMPLES.MICRO_SEC = getScoreRateSampleMicroSec()
    myPrint("レートのサンプルノーツ数: " .. EXSCORE_RATE.SAMPLES.NOTES)
    myPrint("レートのサンプル時間: " .. EXSCORE_RATE.SAMPLES.MICRO_SEC)
    -- local totalSec = (main_state.number(163) * 60 + main_state.number(164))
    local totalSec = (main_state.number(1163) * 60 + main_state.number(1164))
    playLog.setSongLength(totalSec)

    -- TODO: refactor

    local getNumber = main_state.number -- 先に持っておく
    local getFloatNumber = main_state.float_number -- 先に持っておく
    local getLastTime = playLog.getLastTimeData
    local playTimerTime = -1

    local rateRange = {
        sumExScores = {you = 0, best = 0, target = 0}, notes = 0, microSec = 0, startIdx = 1, endIdx = 1,
    }
    local rateSampleNotes = EXSCORE_RATE.SAMPLES.NOTES
    local rateSampleMs = EXSCORE_RATE.SAMPLES.MICRO_SEC
    local rangeExScores = rateRange.sumExScores
    local totalNotes = main_state.number(74)
    local didAddData = false

    return {
        customTimers = {
            {
                id = CUSTOM_TIMERS.LOGGER, timer = function () -- ログ取得
                    if playTimerTime < 0 then
                        playTimerTime = main_state.timer(41)
                    end
                    if playTimerTime >= 0 and main_state.timer(3) <= 0 then
                        -- 現在の時刻を取得
                        local t = getElapsedTime() - playTimerTime
                        local data = {time = t}
                        local lastData = getLastTime()
                        local numOfProcessedExistNotes = 0
                        playLog.addGrooveGaugeData(life.getCustomGauges(), t)
                        -- 判定数全部取る
                        do
                            local sumJudges = 0
                            local wasBreakCombo = false
                            local addCombo = 0
                            local early = {0, 0, 0, 0, 0, 0}
                            local late = {0, 0, 0, 0, 0, 0}
                            do
                                -- 判定数の処理
                                local idx = 0
                                for i = 1, 6 do
                                    idx = 408 + i * 2
                                    if i == 6 then idx = idx + 1 end
                                    local e = getNumber(idx)
                                    local l = getNumber(idx + 1)
                                    early[i] = e
                                    late[i] = l
                                    local de = e - lastData.judges.early[i]
                                    local dl = l - lastData.judges.late[i]
                                    sumJudges = sumJudges + e + l
                                    if i == 5 then -- prを処理した時点でノーツの処理数を入れる
                                        numOfProcessedExistNotes = sumJudges
                                    end
                                    if i <= 3 then
                                        addCombo = addCombo + de + dl
                                    elseif i == 4 or i == 5 then
                                        -- bdかprが0以上ならコンボが切れたと処理
                                        -- 最下ノーツ判定ができないので実際の値とズレる可能性あり
                                        if de + dl > 0 then
                                            wasBreakCombo = true
                                        end
                                    end
                                end
                                -- 合計判定数に変化がなければ他の値も変化がないので終了
                                if lastData.judges.sumJudges == sumJudges then
                                    didAddData = false
                                    return
                                end
                            end

                            -- データ記録
                            data.judges = {
                                sumJudges = sumJudges,
                                early = early,
                                late = late,
                            }
                            data.notes = numOfProcessedExistNotes
                            if wasBreakCombo then
                                -- コンボ切れたら0から開始し直す
                                data.combo = addCombo
                            else
                                -- コンボ加算
                                data.combo = lastData.combo + addCombo
                            end
                        end
                        do
                            local processedNotes = data.notes
                            if processedNotes == 0 then processedNotes = 1 end
                            local progress = processedNotes / totalNotes
                            -- exscoreの処理
                            data.exscore = {
                                you = main_state.exscore(),
                            }
                            data.exscore.best = math.floor(data.notes * getFloatNumber(112) / progress * 2 + 0.5)
                            data.exscore.target = math.floor(data.notes * getFloatNumber(115) / progress * 2 + 0.5)
                        end
                        didAddData = true
                        playLog.addData(data)
                        scores.update()
                    end
                    return 1
                end
            },
            {
                id = CUSTOM_TIMERS.LOGGER_SAVE, timer = function () -- save
                    if (main_state.timer(2) >= 0 or main_state.timer(3) >= 0) and logger.didSave == false then
                        logger.didSave = true -- いちいち関数呼ぶのはオーバーヘッドがでかいのでこっちでも管理
                        pcall(playLog.saveLog)
                    end
                    return 1
                end
            },
            {
                id = CUSTOM_TIMERS.LOGGER_UPDATE, timer = function ()
                    if didAddData == false then return end
                    -- ターゲットスコアをscores側で更新したものに修正する
                    local data = playLog.getLastTimeData()
                    local lastData = playLog.twoBeforeData()
                    data.exscore.target = scores.getTargetScore()
                    -- exscore rateの処理
                    -- 前回からのノーツ数と時間経過を取得
                    local rangeExScore = {}
                    -- 今回の分を追加
                    rateRange.notes = rateRange.notes + data.notes - lastData.notes
                    rateRange.microSec = rateRange.microSec + data.time - lastData.time
                    rateRange.endIdx = playLog.getNumOfData() + 1
                    rangeExScores.you = rangeExScores.you + data.exscore.you - lastData.exscore.you
                    rangeExScores.best = rangeExScores.best + data.exscore.best - lastData.exscore.best
                    rangeExScores.target = rangeExScores.target + data.exscore.target - lastData.exscore.target

                    -- 閾値内に収まるように範囲を狭める
                    -- 尺取法 範囲は[rateRange.startIdx, rateRange.endIdx]
                    -- どれだけ多くても通常100ループには収まる
                    while (rateRange.notes > rateSampleNotes or rateRange.microSec > rateSampleMs) and rateRange.startIdx < rateRange.endIdx do
                        -- 1つ狭める
                        local leftData = playLog.getDataByIdx(rateRange.startIdx - 1)
                        local leftEx = leftData.exscore
                        local leftData2 = playLog.getDataByIdx(rateRange.startIdx - 2)
                        local leftEx2 = leftData2.exscore
                        rateRange.notes = rateRange.notes - (leftData.notes - leftData2.notes)
                        rateRange.microSec = rateRange.microSec - (leftData.time - leftData2.time)
                        rangeExScores.you = rangeExScores.you - (leftEx.you - leftEx2.you)
                        rangeExScores.best = rangeExScores.best - (leftEx.best - leftEx2.best)
                        rangeExScores.target = rangeExScores.target - (leftEx.target - leftEx2.target)
                        rateRange.startIdx = rateRange.startIdx + 1
                    end

                    rangeExScore.theoretical = rateRange.notes * 2
                    local theoretical = rangeExScore.theoretical
                    if theoretical > 0 then
                        rangeExScore.you = rangeExScores.you / theoretical
                        rangeExScore.best = rangeExScores.best / theoretical
                        rangeExScore.target = rangeExScores.target / theoretical
                    else
                        rangeExScore.you = 0
                        rangeExScore.best = 0
                        rangeExScore.target = 0
                    end
                    -- myPrint(rangeExScore.you, rangeExScore.best, rangeExScore.target)
                    data.rangeExScore = rangeExScore
                end
            }
        }
    }
end

return logger.functions