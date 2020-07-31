require("modules.commons.define")
local commons = require("modules.play.commons")
local main_state = require("main_state")

local logger = {
    isSaved = false,
    data = {
        {
            time = 0, -- ms
            judges = {
                sumJudges = 0,
                early = {0, 0, 0, 0, 0, 0}, -- pg, gr, gd, bd, pr, ms
                late  = {0, 0, 0, 0, 0, 0}
            },
            combo = 0,
            notes = 0,
            exscore = {
                you = 0,
                best = 0,
                target = 0,
            },
        }
    },
    functions = {}
}

local LOGGER = {

}

logger.functions.saveLog = function ()
    logger.isSaved = true
    myPrint("プレイログ保存開始")
    local fp = fopen
    return 0
end

logger.functions.load = function ()
    local dataArray = logger.data
    return {
        customTimers = {
            {
                id = 11332, timer = function () -- ログ取得
                    local t = main_state.timer(41)
                    if t >= 0 then
                        -- 現在の時刻を取得
                        local data = {time = getElapsedTime() - t}
                        local lastData = dataArray[#dataArray]

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
                                sumJudges = e + l
                                if i == 5 then -- prを処理した時点でノーツの処理数を入れる
                                    numOfProcessedExistNotes = sumJudges
                                end
                                if i <= 3 then
                                    addCombo = addCombo + e + l
                                elseif i == 4 or i == 5 then
                                    -- bdかprが0以上ならコンボが切れたと処理
                                    -- 最下ノーツ判定ができないので実際の値とズレる可能性あり
                                    if e + l > 0 then
                                        wasBreakCombo = true
                                    end
                                end
                            end
                            -- 合計判定数に変化がなければ他の値も変化がないので終了
                            if lastData.sumJudges == sumJudges then
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

                        dataArray[#dataArray+1] = data
                    end
                end
            },
            {
                id = 10120, timer = function () -- save
                    if main_state.timer(2) >= 0 and logger.isSaved == false then
                        pcall(logger.functions.saveLog)
                    end
                    return 1
                end
            }
        }
    }
end

return logger.functions