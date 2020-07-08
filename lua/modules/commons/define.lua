local main_state = require("main_state")
require("modules.commons.userdata")
require("modules.commons.numbers")
require("modules.commons.timer")

DEBUG = true

function table.in_key (tbl, key)
    for k, v in pairs (tbl) do
        if k==key then return true end
    end
    return false
end

function table.add_all_dict(tbl, dict)
    if dict then
        for k, v in pairs(dict) do
            tbl[k] = v
        end
    end
end

function table.add_all(tbl, ary)
    if ary then
        for _, v in ipairs(ary) do
            table.insert(tbl, v)
        end
    end
end

function table.has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function mergeSkin(skin, addSkin)
    if addSkin then
        for k, v in pairs(addSkin) do -- image, text, value 等がkey
            if type(v) == nil then
                skin[k] = v
            else
                if skin[k] == nil then
                    skin[k] = {}
                end
                for _, v2 in ipairs(v) do -- 普通のdstやimage等への挿入はここ
                    table.insert(skin[k], v2)
                end
                for k2, v2 in pairs(v) do -- songlistやnotes等, 中身が辞書ならここ
                    if not (type(k2) == "number" and k2 % 1 == 0) then
                        skin[k][k2] = v2
                    end
                end
            end
        end
    end
end

SKIN_INFO = {
    SELECT_VRESION = "2.25",
    RESULT_VERSION = "2.05",
    DECIDE_VERSION = "1.01",
    PLAY_VERSION = "0.00",
}

BASE_WIDTH = 1920
BASE_HEIGHT = 1080
WIDTH = 1920
HEIGHT = 1080

PARTS_TEXTURE_SIZE = 2048

NORMAL_TEXT_SIZE = 32
LARGE_TITLE_TEXT_SIZE = NORMAL_TEXT_SIZE * 2
NORMAL_DESCENDER_LINE = 3 -- フォントサイズ64

function globalInitialize(skin)
    -- skinの要素をとりあえず空で入れておく. エラー防止
    skin.image = {}
    skin.imageset = {}
    skin.font = {}
    skin.text = {}
    skin.value = {}
    skin.songlist = {}
    skin.destination = {}
    skin.customTimers = {}
    skin.customEvents = {}

    math.randomseed(os.time())

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
