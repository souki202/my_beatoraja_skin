local main_state = require("main_state")
require("userdata")
require("numbers")
require("timer")

function table.in_key (tbl, key)
    for k, v in pairs (tbl) do
        if k==key then return true end
    end
    return false
end

DEBUG = true

SKIN_INFO = {
    SELECT_VRESION = "2.15",
    RESULT_VERSION = "1.25",
}

BASE_WIDTH = 1920
BASE_HEIGHT = 1080
WIDTH = 1920
HEIGHT = 1080

NORMAL_TEXT_SIZE = 32
LARGE_TITLE_TEXT_SIZE = NORMAL_TEXT_SIZE * 2
NORMAL_DESCENDER_LINE = 3 -- フォントサイズ64

function globalInitialize(skin)
    -- 統計情報周り
    userData.name = main_state.text(2)

    print("ユーザデータ読み込み")
    userData.escapedName = string.gsub(userData.name, "([\\/:*?\"<>|])", "_")
    myPrint("プレイヤー名: " .. userData.name)
    myPrint("使用不能文字置換後: " .. userData.escapedName)
    userData.filePath = skin_config.get_path("../userdata/data") .. "_" .. userData.escapedName
    userData.backupPath = skin_config.get_path("../userdata/backup/data") .. "_" .. userData.escapedName .. string.format("%10d", os.time())
    print("使用ファイルパス: " .. userData.filePath)
    -- 読み込み
    pcall(userData.load)

    createRankAndStaminaTable()

    skin.customTimers = {
        {id = 10000, timer = "updateTime"},
        {id = 10001, timer = "updateDrawNumbers"},
    }

    -- IntMapバグ回避のため. 本当に回避できているかは不明
    -- 先にTimerを連番で登録しておく
    for i = getTimerStart(), getTimerStart() + getMaxDigit() * 10 do
        table.insert(skin.customTimers, {id = i})
    end
end

function getTableValue(tbl, key, defaultValue)
    for k, v in pairs(tbl) do
        if key == k then
            return v
        end
    end
    return defaultValue
end
