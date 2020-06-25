require("my_window")
local main_state = require("main_state")

local TEXTURE_SIZE = 2048
local PARTS_OFFSET = HEIGHT + 32

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

    PLAYTIME = {
        IDS = {"totalPlayHour", "totalPlayMinute", "totalPlaySecond", "totalOperateHour", "totalOperateMinute", "totalOperateSecond"},
        REFS = {17, 18, 19, 27, 28, 29},
    },

    functions = {}
}

function openStatistics()
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
        id = "whiteDetailBg", src = 999, x = 2, y = 0, w = 1, h = 1, act = 1003
    })

    -- 統計ボタン
    table.insert(skin.image, {
        id = "statisticsOpenButton", src = 0, x = 1761, y = PARTS_OFFSET + 771, w = CLOSE_BUTTON.W, h = CLOSE_BUTTON.H, act = 1010
    })

    -- 各種数値
    -- 数値の画像自体は読み込み済み, ランク, ダイヤ, コインは略
    local numSrcX = 1434
    local numSrcY = PARTS_OFFSET + 421
    for i = 1, #statistics.PLAYTIME.IDS do
        table.insert(skin.value, {
            id = statistics.PLAYTIME.IDS[i], src = 0, x = numSrcX, y = numSrcY, w = NUMBERS_24PX.W * 10, h = NUMBERS_24PX.H
        })
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
    dstSimplePopUpWindowSelect(skin, "blackStatisticsClose", timer, statistics.ANIMATION_TIME)
    dstCloseButton(skin, "statisticCloseButton", timer, statistics.ANIMATION_TIME)

    local init = {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1}
    table.insert(skin.destination, {
        id = "whiteDetailBg", timer = timer, loop = statistics.ANIMATION_TIME, dst = {
            init,
            {time = statistics.ANIMATION_TIME, x = SIMPLE_WND_AREA.X + statistics.ITEM.AREA.X, y = SIMPLE_WND_AREA.Y + statistics.ITEM.AREA.Y, w = statistics.ITEM.AREA.W, h = statistics.ITEM.AREA.H, a = 255}
        }
    })

end

statistics.functions.getWindowTimerId = function() return 10500 end

return statistics.functions