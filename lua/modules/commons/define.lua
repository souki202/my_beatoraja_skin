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

function table.shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

function table.sum (tbl)
    local sum = 0
    for i = 1, #tbl do
        sum = sum + tbl[i]
    end
    return sum
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

--[[
    hsvをrgbに変換する
    @param  int h Hue 0 <= h <= 360
    @param  float s Saturation 0 <= s <= 1
    @param  float v Value 0 <= v <= 1
]]
function hsvToRgb(h, s, v)
    h = h % 360
    local c = v * s * 1.0
    local hp = h / 60.0
    local x = c * (1 - math.abs(hp % 2 - 1))

    local r, g, b
    if 0 <= hp and hp < 1 then
        r, g, b = c, x, 0
    elseif 1 <= hp and hp < 2 then
        r, g, b = x, c, 0
    elseif 2 <= hp and hp < 3 then
        r, g, b = 0, c, x
    elseif 3 <= hp and hp < 4 then
        r, g, b = 0, x, c
    elseif 4 <= hp and hp < 5 then
        r, g, b = x, 0, c
    elseif 5 <= hp and hp < 6 then
        r, g, b = c, 0, x
    end

    local m = v - c
    r, g, b = r + m, g + m, b + m
    r = math.floor(r * 255)
    g = math.floor(g * 255)
    b = math.floor(b * 255)
    return r, g, b
end

SKIN_INFO = {
    SELECT_VRESION = "2.25",
    RESULT_VERSION = "2.10",
    DECIDE_VERSION = "1.01",
    PLAY_VERSION = "0.91",
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
    if tbl == nil then
        return defaultValue
    end
    for k, v in pairs(tbl) do
        if key == k then
            return v
        end
    end
    return defaultValue
end

-- 0でdefaultを適用するようにしてoffsetを取得
function getOffsetValueWithDefault(name, defaultValue)
    local v = getTableValue(skin_config.offset, name, defaultValue)
    for key, value in pairs(defaultValue) do
        if not table.in_key(v, key) or v[key] == 0 then
            v[key] = value
        end
    end
    return v
end