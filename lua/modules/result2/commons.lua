local main_state = require("main_state")
require("modules.result.commons")

CUSTOM_TIMERS = {
    SWITCH_STAGEFILE_TAB = 10100,
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

function dstPercentage(valId, dotId, afterDotId, percentId, afterDotDigit, x, y, numW, numH, numSpace, dotW, dotH, dotAreaW, dotSpace, percentW, percentH, percentAreaW, percentSpace)
    local percentX = x - percentAreaW - (percentW - percentAreaW) / 2
    local afterDotX = percentX - percentSpace - afterDotDigit * (numW + numSpace)
    local dotX = afterDotId - dotAreaW - (dotW - dotAreaW) / 2
    local valX = dotX - dotSpace - 3 * (numW + numSpace)
    return {
        destination = {
            {
                id = percentId, dst = {
                    {x = x, y = y, w = percentW, h = percentH}
                }
            },
            {
                id = afterDotId, dst = {
                    {x = afterDotX, y = y, w = numW, h = numH}
                }
            },
            {
                id = dotId, dst = {
                    {x = dotX, y = y, w = dotW, h = dotH}
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
    return (getTableValue(skin_config.option, "ステージファイル部分の判定グラフ", 951) % 5) + 1
end