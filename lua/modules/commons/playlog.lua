require("modules.commons.define")
require("modules.commons.deepcopy")
local commons = require("modules.play.commons")
local main_state = require("main_state")

local logger = {
    didSave = false,
    data = { -- 必ず最初はすべて0のデータが入る
        {
            time = 0, -- micro sec
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
            rangeExScore = {
                theoretical = 0,
                you = 0,
                best = 0,
                target = 0,
            },
        }
    },
    outputData = {},
    songLengthSec = 1,
    songLengthMicroSec = 1,
    microSecPerIdx = 1,
    functions = {}
}

local LOGGER = {
    NUM_OF_SAVE_LOGS = 631,
}

--[[
    プレイログを保存
]]
logger.functions.saveLog = function ()
    if logger.didSave then return 0 end

    logger.didSave = true
    myPrint("プレイログ保存開始: " .. PLAY_LOG_PATH)
    local data = logger.outputData
    local fp = io.open(PLAY_LOG_PATH, "w")
    -- local str = "time, epg, lpg, egr, lgr, egd, lgd, ebd, lbd, epr, lpr, ems, lms, sumJudges, combo, notes, exscore, best, target, rangeTheoretical, rangeYou, rangeBest, rangeTarget\n"
    local str = "time, sumJudges, combo, notes, exscore, best, target, rangeTheoretical, rangeYou, rangeBest, rangeTarget\n"
    str = str .. logger.songLengthSec

    for i = 1, LOGGER.NUM_OF_SAVE_LOGS do
        local nowData = data[i]
        if nowData ~= nil then
            local line = nowData.time .. " "
            -- -- 判定出力
            -- for j = 1, 6 do
            --     line = line .. nowData.judges.early[j] .. " " .. nowData.judges.late[j] .. " "
            -- end
            line = line .. nowData.judges.sumJudges .. " "
            -- combo
            line = line .. nowData.combo .. " "
            -- notes
            line = line .. nowData.notes .. " "
            -- score
            local exScore = nowData.exscore
            line = line .. exScore.you .. " " .. exScore.best .. " " .. exScore.target .. " "
            local range = nowData.rangeExScore
            line = line .. range.theoretical .. " " .. range.you .. " " .. range.best .. " " .. range.target
            str = str .. "\n" .. line
        end
    end
    fp:write(str)
    -- print(str)
    fp:close()
    myPrint("プレイログ保存完了")
    return 0
end

logger.functions.loadLog = function ()
    local fp = io.open(PLAY_LOG_PATH, "r")
    myPrint("プレイデータ読み込み開始: " .. PLAY_LOG_PATH)
    if not fp then
        print("プレイデータの読み込みに失敗しました. " .. PLAY_LOG_PATH)
        return {}
    end
    local dataArray = {}
    local cnt = 0

    for line in fp:lines() do
        -- 1行目は人が見てわかるようにするためのラベル
        if cnt > 1 then
            local data = table.deepcopy(logger.data[1])
            local splited = split(line, " ")
            if #splited >= 11 then
                data.time = splited[1]
                -- for i = 1, 6 do
                --     data.judges.early[i] = splited[2 + (i - 1) * 2]
                --     data.judges.late[i] = splited[3 + (i - 1) * 2]
                -- end
                data.judges.sumJudges = splited[2]
                data.combo = splited[3]
                data.notes = splited[4]
                data.exscore.you = splited[5]
                data.exscore.best = splited[6]
                data.exscore.target = splited[7]
                data.rangeExScore.theoretical = splited[8]
                data.rangeExScore.you = splited[9]
                data.rangeExScore.best = splited[10]
                data.rangeExScore.target = splited[11]
                dataArray[cnt - 1] = data
            end
        elseif cnt == 1 then
            logger.songLengthSec = tonumber(line)
        end
        cnt = cnt + 1
    end
    fp:close()

    myPrint("プレイデータ読み込み完了")

    -- プレイスキンを変更したあとにグラフが出続けるのを防止
    local fp2 = io.open(PLAY_LOG_PATH, "w")
    fp2:write("")
    fp2:close()
    return dataArray
end

--[[
    特定時点のプレイログを配列に追加
    @param dict data logger.data参照
]]
logger.functions.addData = function (data)
    local d = logger.data
    d[#d+1] = data
    logger.outputData[math.floor(data.time / logger.microSecPerIdx) + 1] = data
end

--[[
    曲の長さをセットする
    @param  int len 秒
]]
logger.functions.setSongLength = function (sec)
    logger.songLengthSec = sec
    logger.songLengthMicroSec = sec * 1000000
    logger.microSecPerIdx = logger.songLengthMicroSec / 630
end

logger.functions.getSongLength = function ()
    return logger.songLengthSec
end

--[[
    logger.dataのログの最後尾を取得する
    @return dict logger.dataの最後尾の値
]]
logger.functions.getLastTimeData = function ()
    local d = logger.data
    return d[#d]
end

logger.functions.twoBeforeData = function ()
    local d = logger.data
    if #d >= 2 then
        return d[#d - 1]
    else
        return d[#d]
    end
end

logger.functions.getNumOfData = function ()
    return #logger.data
end

logger.functions.getDataByIdx = function (i)
    local data = logger.data
    if i < 1 then return data[1] end
    return (i > #data or i == 0) and data[1] or data[i]
end

return logger.functions