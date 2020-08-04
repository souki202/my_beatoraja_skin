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
    songLengthSec = 1,
    functions = {}
}

--[[
    プレイログを保存
]]
logger.functions.saveLog = function ()
    if logger.didSave then return 0 end

    logger.didSave = true
    myPrint("プレイログ保存開始: " .. PLAY_LOG_PATH)
    local data = logger.data
    local fp = io.open(PLAY_LOG_PATH, "w")
    local str = "time, epg, lpg, egr, lgr, egd, lgd, ebd, lbd, epr, lpr, ems, lms, sumJudges, combo, notes, exscore, best, target\n"
    str = str .. logger.songLengthSec

    for i = 1, #data do
        local nowData = data[i]
        local line = nowData.time .. " "
        -- 判定出力
        for j = 1, 6 do
            line = line .. nowData.judges.early[j] .. " " .. nowData.judges.late[j] .. " "
        end
        line = line .. nowData.judges.sumJudges .. " "
        -- combo
        line = line .. nowData.combo .. " "
        -- notes
        line = line .. nowData.notes .. " "
        -- score
        line = line .. nowData.exscore.you .. " " .. nowData.exscore.best .. " " .. nowData.exscore.target
        str = str .. "\n" .. line
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
            if #splited >= 19 then
                data.time = splited[1]
                for i = 1, 6 do
                    data.judges.early[i] = splited[2 + (i - 1) * 2]
                    data.judges.late[i] = splited[3 + (i - 1) * 2]
                end
                data.judges.sumJudges = splited[14]
                data.combo = splited[15]
                data.notes = splited[16]
                data.exscore.you = splited[17]
                data.exscore.best = splited[18]
                data.exscore.target = splited[19]

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
end

--[[
    曲の長さをセットする
    @param  int len 秒
]]
logger.functions.setSongLength = function (sec)
    logger.songLengthSec = sec
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

logger.functions.getNumOfData = function ()
    return #logger.data
end

logger.functions.getDataByIdx = function (i)
    local data = logger.data
    return (i > #data or i == 0) and data[1] or data[i]
end

return logger.functions