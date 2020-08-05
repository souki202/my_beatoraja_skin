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