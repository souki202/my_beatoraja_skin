require("modules.commons.my_window")
require("modules.commons.numbers")

local commons = require("modules.select.commons")
local main_state = require("main_state")

local statistics = {
    WND = {
        W = 1600,
        H = 900
    },
    OPEN_BUTTON = {

    },
    CLOSE_BUTTON = {
        X = 728,
        Y = 12,
    },
    ITEM = {
        AREA = {
            X = 49,
            W = 1502,
            Y = 86,
            START_Y = 760, -- WNDからの相対
            H = 724,
        },

        INTERVAL_Y = 42,
        TEXT = {
            X = 72,
        },
        NUM = {
            X = 464
        },
        NEXT_HEADER_Y = 18,
    },

    HEADER = {
        W = 738,
        H = 42,
        X1 = 52, -- yはとりあえず1個1個手打ちになる
    },
    ANIMATION_TIME = 150,
    FONT_SIZE = 24,

    isOpen = false,
    isClosing = false,
    isClosed = true,
    closeTime = 0,
    openTime = 0,

    ID_PREFIX = "statistics",

    USER = {
        VALUES = {0, 0, 0},
        TEXTS = {"ランク", "所持コイン", "所持ダイヤ"},
    },

    PLAYTIME = {
        IDS = {"TotalPlayHour", "TotalPlayMinute", "TotalPlaySecond", "TotalOperateHour", "TotalOperateMinute", "TotalOperateSecond"},
        REFS = {17, 18, 19, 27, 28, 29},
        TEXTS = {"累計プレイ時間", "今回の起動時間"},
    },

    PLAY = {
        IDS = {"PlayCount", "ClearCount", "Perfect", "Great", "Good", "Bad", "Poor", "TotalNotes"},
        REFS = {30, 31, 33, 34, 35, 36, 37, 333},
        TEXTS = {"プレイ回数", "クリア回数", "PERFECT", "GREAT", "GOOD", "BAD", "POOR", "TOTAL NOTES"},
    },

    functions = {}
}

function openStatistics()
    if isRightClicking() then
        switchMenu()
        return
    end
    statistics.isOpen = true
    statistics.isClosing = false
    statistics.isClosed = false
    statistics.openTime = main_state.time()
    main_state.set_timer(statistics.functions.getWindowTimerId(), main_state.time())
end

function closeStatistics()
    statistics.isClosing = true
    statistics.isClosed = false
    statistics.isOpen = false
    statistics.closeTime = statistics.ANIMATION_TIME * 1000
end

function closeStatisticsRightClickEvent()
    if isRightClicking() == true then
        closeStatistics()
    end
end

function statisticsTimer()
    if statistics.isOpen then
        return statistics.openTime
    elseif statistics.isClosed then
        return main_state.timer_off_value
    elseif statistics.isClosing then
        statistics.closeTime = statistics.closeTime - getDeltaTime()
        if statistics.closeTime <= 0 then
            statistics.closeTime = 0
            statistics.isOpen = false
            statistics.isClosed = true
            statistics.isClosing = false
        end
        return getElapsedTime() - statistics.closeTime
    end

    return main_state.timer_off_value
end

-- カスタムタイマ, カスタムアクション, textの後に配置すること
statistics.functions.load = function(skin)
    table.insert(skin.customEvents, {id = 1010, action = "openStatistics()"})
    table.insert(skin.customEvents, {id = 1011, action = "closeStatistics()"})
    table.insert(skin.customEvents, {id = 1012, action = "closeStatisticsRightClickEvent()"})

    -- 背景は閉じるボタン
    table.insert(skin.image, {
        id = "blackStatisticsClose", src = 999, x = 1, y = 0, w = 1, h = 1, act = 1011
    })

    -- 閉じるボタン
    loadCloseButtonSelect(skin, "statisticCloseButton", 1011)

    table.insert(skin.image, {
        id = "whiteStatisticBg", src = 999, x = 2, y = 0, w = 1, h = 1, act = 1012
    })

    -- 各種数値
    -- 数値の画像自体は読み込み済み
    local numSrcX = 1434
    local numSrcY = commons.PARTS_OFFSET + 421

    local values = skin.value
    local texts = skin.text

    -- タイトルヘッダー
    texts[#texts + 1] = {id = "統計情報", font = 0, size = HEADER.TEXT.FONT_SIZE, align = 0, constantText = "統計情報"}

    -- 時間周り
    for i = 1, #statistics.PLAYTIME.IDS do
        local digit = 2
        local padding = 1
        if i % 3 == 1 then
            digit = 5
            padding = 0
        end
        values[#values + 1] = {id = statistics.ID_PREFIX .. statistics.PLAYTIME.IDS[i], src = 0, x = numSrcX, y = numSrcY, w = NUMBERS_24PX.W * 10, h = NUMBERS_24PX.H, divx = 10, digit = digit, align = 0, ref = statistics.PLAYTIME.REFS[i], padding = padding}
        if i <= 2 then
            texts[#texts + 1] = {id = statistics.PLAYTIME.TEXTS[i], font = 0, size = statistics.FONT_SIZE, align = 0, constantText = statistics.PLAYTIME.TEXTS[i]}
        end
    end

    -- プレイ周り
    for i = 1, #statistics.PLAY.IDS do
        values[#values + 1] = {id = statistics.ID_PREFIX .. statistics.PLAY.IDS[i], src = 0, x = numSrcX, y = numSrcY, w = NUMBERS_24PX.W * 10, h = NUMBERS_24PX.H, divx = 10, digit = 9, align = 0, ref = statistics.PLAY.REFS[i]}
        texts[#texts + 1] = {id = statistics.PLAY.TEXTS[i], font = 0, size = statistics.FONT_SIZE, align = 0, constantText = statistics.PLAY.TEXTS[i]}
    end

    texts[#texts + 1] = {id = "ユーザ", font = 0, size = statistics.FONT_SIZE, align = 0, constantText = "ユーザ"}
    texts[#texts + 1] = {id = "時間", font = 0, size = statistics.FONT_SIZE, align = 0, constantText = "時間"}
    texts[#texts + 1] = {id = "プレイ情報", font = 0, size = statistics.FONT_SIZE, align = 0, constantText = "プレイ情報"}

    -- 統計情報数値はdstで
    statistics.USER.VALUES = {userData.rank.rank, userData.tokens.coin, userData.tokens.dia}
    for i = 1, #statistics.USER.VALUES do
        texts[#texts + 1] = {id = statistics.USER.TEXTS[i], font = 0, size = statistics.FONT_SIZE, align = 0, constantText = statistics.USER.TEXTS[i]}
        values[#values + 1] = {
            id = statistics.ID_PREFIX .. statistics.USER.TEXTS[i], src = 0, x = numSrcX, y = numSrcY, w = NUMBERS_24PX.W * 10, h = NUMBERS_24PX.H, divx = 10, digit = 9, align = 0,
            value = function() return statistics.USER.VALUES[i] end
        }
    end


    
end

statistics.functions.destinationOpenButton = function(skin)
    table.insert(skin.destination, {
        id = "statisticsOpenButton", dst = {
            {x = 1768, y = 56, w = CLOSE_BUTTON.W, h = CLOSE_BUTTON.H}
        }
    })
end

statistics.functions.destinationWindow = function(skin)
    local timer = statistics.functions.getWindowTimerId()
    local atime = statistics.ANIMATION_TIME
    dstSimplePopUpWindowSelect(skin, "blackStatisticsClose", timer, atime)
    dstCloseButton(skin, "statisticCloseButton", timer, atime)

    local init = {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 0, h = 0}
    local initText = {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, r = 0, g = 0, b = 0}
    table.insert(skin.destination, {
        id = "whiteStatisticBg", timer = timer, loop = atime, dst = {
            init,
            {time = atime, x = SIMPLE_WND_AREA.X + statistics.ITEM.AREA.X, y = SIMPLE_WND_AREA.Y + statistics.ITEM.AREA.Y, w = statistics.ITEM.AREA.W, h = statistics.ITEM.AREA.H, a = 255}
        }
    })
    dstHeaderSelect(skin, {}, timer, atime, "統計情報")

    -- データ列挙
    local interval = statistics.ITEM.INTERVAL_Y
    local textX1 = SIMPLE_WND_AREA.X + statistics.ITEM.TEXT.X
    local numX1 = SIMPLE_WND_AREA.X + statistics.ITEM.NUM.X
    local nowY = SIMPLE_WND_AREA.Y + 788
    local numOffsetY = 5
    local next = statistics.ITEM.NEXT_HEADER_Y

    -- プレイヤーデータ
    dstSubHeaderSelect(skin, SIMPLE_WND_AREA.X + statistics.HEADER.X1, nowY, statistics.HEADER.W, {}, statistics.functions.getWindowTimerId(), atime, "ユーザ")
    nowY = nowY - interval
    for i = 1, #statistics.USER.VALUES do
        -- 文字
        table.insert(skin.destination, {
            id = statistics.USER.TEXTS[i], timer = timer, loop = atime, dst = {
                initText,
                {time = atime, x = textX1, y = nowY, w = 999, h = statistics.FONT_SIZE}
            }
        })

        -- 数値
        table.insert(skin.destination, {
            id = statistics.ID_PREFIX .. statistics.USER.TEXTS[i], timer = timer, loop = atime, dst = {
                {time = atime, x = numX1 - NUMBERS_24PX.W * 9, y = nowY + numOffsetY, w = NUMBERS_24PX.W, h = NUMBERS_24PX.H}
            }
        })
        nowY = nowY - interval
    end
    nowY = nowY - next

    -- 時間
    dstSubHeaderSelect(skin, SIMPLE_WND_AREA.X + statistics.HEADER.X1, nowY, statistics.HEADER.W, {}, statistics.functions.getWindowTimerId(), atime, "時間")
    nowY = nowY - interval
    for i = 1, #statistics.PLAYTIME.TEXTS do
        local ni = i == 1 and 1 or 4
        -- 文字
        table.insert(skin.destination, {
            id = statistics.PLAYTIME.TEXTS[i], timer = timer, loop = atime, dst = {
                initText,
                {time = atime, x = textX1, y = nowY, w = 999, h = statistics.FONT_SIZE}
            }
        })

        -- 秒
        local dst = {
            init,
            {time = atime, x = numX1, y = nowY + numOffsetY, w = NUMBERS_24PX.W, h = NUMBERS_24PX.H}
        }
        dstNumberRightJustifyByDst(skin, statistics.ID_PREFIX .. statistics.PLAYTIME.IDS[ni+2], {}, timer, atime, dst, 2)
        -- コロン
        table.insert(skin.destination, {
            id = "24:", timer = timer, loop = atime, dst = {
                initText,
                {time = atime, x = numX1 - 32, y = nowY, w = 999, h = statistics.FONT_SIZE}
            }
        })
        -- 分
        dst = {
            init,
            {time = atime, x = numX1 - 35, y = nowY + numOffsetY, w = NUMBERS_24PX.W, h = NUMBERS_24PX.H}
        }
        dstNumberRightJustifyByDst(skin, statistics.ID_PREFIX .. statistics.PLAYTIME.IDS[ni+1], {}, timer, atime, dst, 2)
        -- コロン
        table.insert(skin.destination, {
            id = "24:", timer = timer, loop = atime, dst = {
                initText,
                {time = atime, x = numX1 - 67, y = nowY, w = 999, h = statistics.FONT_SIZE}
            }
        })
        -- 時
        dst = {
            init,
            {time = atime, x = numX1 - 69, y = nowY + numOffsetY, w = NUMBERS_24PX.W, h = NUMBERS_24PX.H}
        }
        dstNumberRightJustifyByDst(skin, statistics.ID_PREFIX .. statistics.PLAYTIME.IDS[ni], {}, timer, atime, dst, 5)
        nowY = nowY - interval
    end
    nowY = nowY - next

    -- 判定等
    dstSubHeaderSelect(skin, SIMPLE_WND_AREA.X + statistics.HEADER.X1, nowY, statistics.HEADER.W, {}, statistics.functions.getWindowTimerId(), atime, "プレイ情報")
    nowY = nowY - interval
    for i = 1, #statistics.PLAY.IDS do
        -- 文字
        table.insert(skin.destination, {
            id = statistics.PLAY.TEXTS[i], timer = timer, loop = atime, dst = {
                initText,
                {time = atime, x = textX1, y = nowY, w = 999, h = statistics.FONT_SIZE}
            }
        })

        -- 数値
        local numOffsetX = 0
        if i == 1 or i == 2 then
            -- 回 を出力
            table.insert(skin.destination, {
                id = "countText", timer = timer, loop = atime, dst = {
                    initText,
                    {time = atime, x = numX1, y = nowY, w = 99, h = statistics.FONT_SIZE}
                }
            })
            numOffsetX = 24
        end
        local dst = {
            init,
            {time = atime, x = numX1 - numOffsetX, y = nowY + numOffsetY, w = NUMBERS_24PX.W, h = NUMBERS_24PX.H}
        }
        dstNumberRightJustifyByDst(skin, statistics.ID_PREFIX .. statistics.PLAY.IDS[i], {}, timer, atime, dst, 9)

        nowY = nowY - interval
    end

end

statistics.functions.getWindowTimerId = function() return 10500 end

return statistics.functions