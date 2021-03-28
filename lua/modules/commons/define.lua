-- Copyright 2019-2020 tori-blog.net.
-- This file is part of SocialSkin.

-- SocialSkin is free program: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- SocialSkin is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with SocialSkin.  If not, see <http://www.gnu.org/licenses/>.

local main_state = require("main_state")
require("modules.commons.userdata")
require("modules.commons.numbers")
require("modules.commons.timer")

DEBUG = true

function table.in_key(tbl, key)
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

function table.sum(tbl)
    local sum = 0
    for i = 1, #tbl do
        sum = sum + tbl[i]
    end
    return sum
end

function table.merge(tbl, overrideTbl)
    if type(overrideTbl) == "table" then
        for k, v in pairs(overrideTbl) do
            -- 要素がないかテーブルでなければ全部上書き
            if type(tbl[k]) ~= "table" then
                tbl[k] = overrideTbl[k]
            else
                -- 直下の項目がテーブルでなければ更新
                if type(overrideTbl[k]) ~= "table" then
                    tbl[k] = overrideTbl[k]
                else
                    -- テーブルが見つかれば
                    table.merge(tbl[k], overrideTbl[k])
                end
            end
        end
    end
end

function string.split(str, ts)
    -- 引数がないときは空tableを返す
    if ts == nil then return {} end
    local t = {};
    local i = 1
    for s in string.gmatch(str, "([^"..ts.."]+)") do
      t[i] = s
      i = i + 1
    end
    return t
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

function split(str, delim)
    -- 引数がないときは分割しない
    if delim == nil then return {str} end

    local t = {}
    local i = 1
    for s in string.gmatch(str, "([^"..delim.."]+)") do
      t[i] = s
      i = i + 1
    end

    return t
end

function isNumber(str)
    if type(str) == "string" then
        for i = 1, string.len(str) do
            local b = str:byte(i)
            if not(48 <= b and b <= 57) then
                return false
            end
        end
        return true
    elseif type(str) == "number" then
        return true
    end

    return false
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

function gaussian(x, a, avg, v)
    return a * math.exp(-((x - avg) ^ 2) / (2 * v ^ 2))
end

SKIN_INFO = {
    SELECT_VRESION = "3.01",
    RESULT_VERSION = "3.01",
    DECIDE_VERSION = "1.10",
    PLAY_VERSION = "2.01",
    RESULT2_VERSION = "1.20",
}

BASE_WIDTH = 1920
BASE_HEIGHT = 1080
WIDTH = 1920
HEIGHT = 1080

MIN_VALUE = -2147483648

PARTS_TEXTURE_SIZE = 2048

NORMAL_TEXT_SIZE = 32
LARGE_TITLE_TEXT_SIZE = NORMAL_TEXT_SIZE * 2
NORMAL_DESCENDER_LINE = 3 -- フォントサイズ64

PLAY_LOG_PATH = ""

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
    PLAY_LOG_PATH = skin_config.get_path("../userdata/playlog.log")
    print("使用ファイルパス: " .. userData.filePath)
    -- 読み込み
    pcall(userData.load)

    createRankAndStaminaTable()

    skin.customTimers = {
        {id = 10000, timer = "updateTime"},
        {id = 10001, timer = "updateDrawNumbers"},
    }
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