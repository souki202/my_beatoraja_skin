require("modules.commons.define")
local PARTS_OFFSET = HEIGHT + 32
local SELECT = {
    INPUT_WAIT = 500,
    PARTS_OFFSET = PARTS_OFFSET,
    NUM_28PX = {
        SRC_X = 946,
        SRC_Y = PARTS_OFFSET,
        W = 15,
        H = 21,
    },
    NUM_32PX = {
        W = 18,
        H = 23,
    },
    NUM_20PX = {
        SRC_X = 946,
        SRC_Y = PARTS_OFFSET + 89,
        W = 11,
        H = 15,
    },
    NUM_24PX = {
        SRC_X = 1434,
        SRC_Y = PARTS_OFFSET + 421,
        W = 13,
        H = 18,
    }
}

function isThickSongList()
    return getTableValue(skin_config.option, "選曲バーの太さ", 965) == 965
end

function isDefaultIrStatistics()
    return getTableValue(skin_config.option, "IR部分のデフォルトのアクティブタブ", 970) == 970
end

function getOverallSongListAlphaRaito()
    return (255 - getOffsetValueWithDefault("選曲バー全体の透明度(255で透明)", {a = 0}).a) / 255.0
end

function getCommonSongListAlpha()
    return 255 * getOverallSongListAlphaRaito()
end

function getSongListAlpha()
    return getOverallSongListAlphaRaito() * (255 - getOffsetValueWithDefault("選曲バーフレームの透明度(255で透明)", {a = 0}).a)
end

function getCenterSongFrameAlpha()
    return getOverallSongListAlphaRaito() * (255 - getOffsetValueWithDefault("選択中の曲のフレームの透明度(255で透明)", {a = 0}).a)
end

function getSongListBgAlpha()
    return getOverallSongListAlphaRaito() * (255 - getOffsetValueWithDefault("選曲バー背景の透明度(255で透明)", {a = 0}).a)
end

function getStageFileMaskFadeOutStartTime()
    return getOffsetValueWithDefault("ステージファイルの暗転のフェードアウト開始までの時間(100ms 既定値2)", {x = 2}).x * 100
end

function getStageFileMaskFadeOutEndTime()
    return getOffsetValueWithDefault("ステージファイルの暗転のフェードアウト終了までの時間(100ms 既定値3)", {x = 3}).x * 100
end

function getStageFileMaskAlpha()
    return 255 - getOffsetValueWithDefault("ステージファイルの暗転の黒マスクの透明度(255で透明 既定値128)", {a = 128}).a
end

return SELECT