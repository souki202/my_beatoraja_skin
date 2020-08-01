TEXTURE_SIZE = 2048
LEFT_X = 64
RIGHT_X = 1206
WND_WIDTH = 650

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