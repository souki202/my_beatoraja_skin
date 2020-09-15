local main_state = require("main_state")
require("modules.result.commons")

CUSTOM_TIMERS_RESULT2 = {
    SWITCH_STAGEFILE_TAB = 10100,
    SWITCH_DETAIL = 10101,
    DETAIL_WND_TIMER = 10102,
}

RESULT2NUM = {
    SIZE30 = {
        W = 15,
        H = 21,
        DOT_SIZE = 2,
        SLUSH = {
            W = 11,
            H = 21,
        },
        PERCENT = {
            W = 19,
            H = 21,
        },
    }
}

function loadNumberSymbols()
    return {
        image = {
            {id = "30pxDot", src = 330, x = 180, y = 19, w = RESULT2NUM.SIZE30.DOT_SIZE, h = RESULT2NUM.SIZE30.DOT_SIZE},
            {id = "30pxSlush", src = 330, x = 195, y = 0, w = RESULT2NUM.SIZE30.SLUSH.W, h = RESULT2NUM.SIZE30.SLUSH.H},
            {id = "30pxPercent", src = 330, x = 210, y = 0, w = RESULT2NUM.SIZE30.PERCENT.W, h = RESULT2NUM.SIZE30.PERCENT.H},
        }
    }
end

function loadNumber(id, size, digit, align, ref, value)
    local param = RESULT2NUM["SIZE" .. size]
    return {id = id, src = 300 + size, x = 0, y = 0, w = param.W * 10, h = param.H, divx = 10, align = align, digit = digit, ref = ref, value = value}
end

--[[
    パーセンテージ全体を出力する

    @param dotInfo {W, H, AREA_W, SPACE}を持つ配列
    @param percentInfo {W, H, AREA_W, SPACE}を持つ配列
    @return スキンの配列 mergeSkinしてください
]]
function dstPercentage(valId, dotId, afterDotId, percentId, afterDotDigit, x, y, numW, numH, numSpace, dotInfo, percentInfo)
    local percentX = x - percentInfo.W + (percentInfo.W - percentInfo.AREA_W) / 2
    local afterDotX = percentX - percentInfo.SPACE - afterDotDigit * (numW + numSpace)
    local dotX = afterDotX - numSpace / 2 - dotInfo.W + (dotInfo.W - dotInfo.AREA_W) / 2
    local valX = dotX - dotInfo.SPACE - 3 * (numW + numSpace)
    return {
        destination = {
            {
                id = percentId, dst = {
                    {x = percentX, y = y, w = percentInfo.W, h = percentInfo.H}
                }
            },
            {
                id = afterDotId, dst = {
                    {x = afterDotX, y = y, w = numW, h = numH}
                }
            },
            {
                id = dotId, dst = {
                    {x = dotX, y = y, w = dotInfo.W, h = dotInfo.H}
                }
            },
            {
                id = valId, dst = {
                    {x = valX, y = y, w = numW, h = numH}
                }
            }
        }
    }
end

function getRankFrameBgAlpha()
	return 255 - getOffsetValueWithDefault("ランクの額縁の背景の透明度(既定値165 255で透明)", {a = 165}).a
end

function getBokehBgSrc()
    return getBgSrc() + 100
end

function getGrooveGaugeAreaGraph()
    return (getTableValue(skin_config.option, "各種グラフ グルーヴゲージ部分", 945) % 5) + 1
end

function getGaugeTypeAtStageFileArea()
    return (getTableValue(skin_config.option, "各種グラフ ステージファイル部分", 930) % 5) + 1
end

function getGaugeTypeAtDetailWindow1()
    return (getTableValue(skin_config.option, "各種グラフ 詳細画面1個目", 936) % 5) + 1
end

function getGaugeTypeAtDetailWindow2()
    return (getTableValue(skin_config.option, "各種グラフ 詳細画面2個目", 942) % 5) + 1
end