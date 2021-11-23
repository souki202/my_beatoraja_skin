require("modules.commons.http")
local main_state = require("main_state")

local estimate = {
    table = {},
    functions = {}
}

-- キャッシュファイル読み込みエラー対策でpcallできるようにする
local function cacheRequire()
    estimate.table = require("cache.estimates")
end

local ESTIMATE = {
    GET_WAIT_TIME = 1000,
    CACHE_PATH = "cache/estimates.lua",
    VAR_NAME = "estimates",
}

--[[
    難易度推定一覧を取得する. 通常, 起動時に1回だけ実行する
]]
estimate.functions.updateEstimates = function()
    local success, _ = pcall(function() updateEstimateLua(ESTIMATE.CACHE_PATH) end)
    if not success then
        print("難易度推定テーブルの更新に失敗しました")
    end
end

estimate.functions.loadCache = function()
    -- estimate読み込み
    pcall(cacheRequire)
end

--[[
    楽曲の難易度推定を取得
    @param {string} title 楽曲名
    @param {string} difficulty 難易度. "st0", "sl11"など, 難易度表記と数値のセットの文字列
    @return {{
        easy: float | "\"-"\",
        normal: float | "\"-"\",
        hard: float | "\"-"\",
        exhard: "\"-"\",
        fc: float | "\"-"\",
    } | nil} テーブルにあれば難易度ごとの推定値が, なければnil
]]
estimate.functions.getEstimateData = function(title, difficulty, _retry)
    if not next(estimate.table) then return nil end
    local d = estimate.table[title .. " " .. difficulty]
    -- 表記ゆれでのスペース有無差
    if not d and not _retry then
        local pos = math.max(string.rfind_start(title, "[") or 0, string.rfind_start(title, "(") or 0, string.rfind_start(title, "【") or 0, string.rfind_start(title, "-") or 0)
        if pos < 2 then
            return nil
        end
        -- スペースを付与
        if string.at(title, pos - 1) ~= " " then
            return estimate.functions.getEstimateData(string.sub(title, 0, pos - 1) .. " " .. string.sub(title, pos), difficulty, true)
        end
        -- スペースを削除
        if pos > 2 and string.at(title, pos - 1) == " " then
            return estimate.functions.getEstimateData(string.sub(title, 0, pos - 2) .. string.sub(title, pos), difficulty, true)
        else
            return nil
        end
    end
    return estimate.table[title .. " " .. difficulty]
end

return estimate.functions
