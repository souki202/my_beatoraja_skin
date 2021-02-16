local main_state = require("main_state")
TEXTURE_SIZE = 2048
LEFT_X = 64
RIGHT_X = 1206
WND_WIDTH = 650
CLEAR_TYPE = 0

LAMPS = {
    NO_PLAY = 0,
    FAILED = 1,
    A_EASY = 2,
    LA_EASY = 3,
    EASY = 4,
    NORMAL = 5,
    HARD = 6,
    EX_HARD = 7,
    FULLCOMBO = 8,
    PERFECT = 9,
    MAX = 10,
}

NUM_24PX = {
    SRC = 0,
    SRC_X = 1880,
    SRC_Y = 36,
    W = 14,
    H = 18,

    PERCENT = {
        W = 17,
        H = 14,
    },
    DOT_SIZE = 4,
}

NUM_30PX = {
    SRC = 0,
    SRC_X = 1856,
    SRC_Y = 203,
    W = 16,
    H = 22,
}

SLASH_30PX = {
    SRC = 0,
    SRC_X = 1799,
    SRC_Y = 56,
    W = 9,
    H = 24,
}

NUM_36PX = {
    SRC = 0,
    SRC_X = 1808,
    SRC_Y = 54,
    W = 20,
    H = 26,

    DOT_SIZE = 5,
}

NUM_18PX = {
    SRC = 0,
    SRC_X = 1928,
    SRC_Y = 172,
    W = 10,
    H = 13,

    DOT_SIZE = 3,
}

-- EXSCORE以外
VALUE_ITEM_TEXT = {
    SRC_X = 199,
    SRC_Y = 31,
    W = 221,
    H = 27,
}

CHANGE_ARROW = {
    W = 27,
    H = 21,
}

function isOldLayout()
    return getTableValue(skin_config.option, "レイアウト", 915) == 915
end

function is2P()
    return getTableValue(skin_config.option, "スコア位置", 920) == 921
end

function isDrawGrooveGaugeLabel()
	return getTableValue(skin_config.option, "グルーヴゲージ部分のラベル表示", 950) == 950
end

function isDrawPlayOption()
	return getTableValue(skin_config.option, "譜面オプションの表示", 960) == 960
end

function getDrawLabelAtTop()
	return getTableValue(skin_config.option, "グルーヴゲージ部分のラベル位置", 955) == 956
end

function getGrooveNotesGraphSizePercentage()
	return getOffsetValueWithDefault("グルーヴゲージ部分のノーツグラフの高さ (既定値30 単位%)", {h = 30}).h / 100
end

function isShowOwnPlayerNameInRanking()
	return getTableValue(skin_config.option, "ランキングの自分の名前表記", 975) == 975
end

function isSimpleRankingInformation()
	return getTableValue(skin_config.option, "ランキングの情報量", 980) == 981
end

function getGrooveNotesGraphTransparency()
	return 255 - getOffsetValueWithDefault("グルーヴゲージ部分のノーツグラフの透明度 (255で透明)", {a = 0}).a
end
--[[
    グルーヴゲージ下の各種グラフの種類を取得

    @param  int pos 上から何番目か 1,2,3は下部分の枠目, 4はグルーヴゲージ部分
    @return int 1:ノーツ数分布, 2:判定分布, 3:EARLY/LATE分布(棒グラフ), 4:タイミング可視化グラフ, 5:無し
]]
function getGraphType(pos)
    if pos == 4 then
        return (getTableValue(skin_config.option, "各種グラフ グルーヴゲージ部分", 949) % 5) + 1
    end

    if pos < 1 or 3 < pos then return 5 end
    local def = 930
    if pos == 2 then def = 936
    elseif pos == 3 then def = 942
    end
    return (getTableValue(skin_config.option, "各種グラフ" .. pos .. "個目", def) % 5) + 1
end

function getBgSrc()
    if getTableValue(skin_config.option, "背景の分類", 910) == 910 then
        -- クリアかどうかの背景時
        if CLEAR_TYPE ~= LAMPS.FAILED then
            return 100
        else
            return 101
        end
    elseif getTableValue(skin_config.option, "背景の分類", 910) == 911 then
        -- スコア0のOPTION_RESULT_0_1Pはヌルポなので見ない
        for i = 1, 8 do
            if main_state.option(300 + (i - 1)) then
                return 110 + (i - 1)
            end
        end
    elseif getTableValue(skin_config.option, "背景の分類", 910) == 912 then
        return 120 + CLEAR_TYPE - 1
    end
end

function isViewResultDate()
	return getTableValue(skin_config.option, "日時表示", 987) ~= 985
end

function isViewDateOnly()
	return getTableValue(skin_config.option, "日時表示", 987) == 986
end

function isViewDateAndTime()
	return getTableValue(skin_config.option, "日時表示", 987) == 987
end

function getIsViewCostomGrooveGauge()
    return getTableValue(skin_config.option, "カスタムゲージの結果出力", 991) == 990 and not getIsCourse()
end

function getIsCourse()
	return main_state.text(150) ~= ""
end