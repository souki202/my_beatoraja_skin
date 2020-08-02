require("modules.commons.define")
local playLog = require("modules.commons.playlog")
local commons = require("modules.play.commons")
local main_state = require("main_state")

local logger = {
    didSave = false,
    functions = {}
}

local LOGGER = {

}

logger.functions.load = function ()
    return {
        customTimers = {
            {
                id = 12000, timer = function () -- ログ取得
                    local t = main_state.timer(41)
                    if t >= 0 then
                        -- 現在の時刻を取得
                        local data = {time = getElapsedTime() - t}
                        local lastData = playLog.getLastTimeData()

                        -- 判定数全部取る
                        do
                            local sumJudges = 0
                            local numOfProcessedExistNotes = 0
                            local wasBreakCombo = false
                            local addCombo = 0
                            local early = {0, 0, 0, 0, 0, 0}
                            local late = {0, 0, 0, 0, 0, 0}
                            -- 判定数の処理
                            for i = 1, 6 do
                                local idx = 408 + i * 2
                                if i == 6 then idx = idx + 1 end
                                local e = main_state.number(idx)
                                local l = main_state.number(idx + 1)
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
                                    if e + l > 0 then
                                        wasBreakCombo = true
                                    end
                                end
                            end
                            -- 合計判定数に変化がなければ他の値も変化がないので終了
                            if lastData.judges.sumJudges == sumJudges then
                                return
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
                            -- exscoreの処理
                            data.exscore = {
                                you = main_state.number(101),
                                best = main_state.number(150),
                                target = main_state.number(121),
                            }
                        end
                        playLog.addData(data)
                    end
                    return 1
                end
            },
            {
                id = 12001, timer = function () -- save
                    if (main_state.timer(2) >= 0 or main_state.timer(3) >= 0) and logger.didSave == false then
                        logger.didSave = true -- いちいち関数呼ぶのはオーバーヘッドがでかいのでこっちでも管理
                        pcall(playLog.saveLog)
                    end
                    return 1
                end
            }
        }
    }
end

return logger.functions