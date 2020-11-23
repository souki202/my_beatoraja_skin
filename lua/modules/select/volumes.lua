require("modules.commons.my_window")
require("modules.commons.numbers")

local commons = require("modules.select.commons")
local main_state = require("main_state")
require("modules.commons.my_window")

local VOLUMES = {
    WND = {
        W = 1600,
        H = 900
    },
    CLOSE_BUTTON = {
        X = 728,
        Y = 12,
    },

    ITEM = {
        Y = function (idx) return SIMPLE_WND_AREA.Y + 766 - (idx - 1) * 64 end,
        VOLUME_ICON = {
            W = 52,
            H = 36,
            X_MIN = function () return SIMPLE_WND_AREA.X + 223 end,
            X_MAX = function () return SIMPLE_WND_AREA.X + 1334 end,
        },
        SLIDER = {
            X = function () return SIMPLE_WND_AREA.X + 293 end,
            W = 1024,
            BG_NONACTIVE = {
                H = 8,
                EDGE_W = 8,
                BODY_W = 1024 - 8 * 2,
            },
            BG_ACTIVE = {
                H = 18,
                EDGE_W = 8,
                BODY = 1024 - 8,
            },
            HANDLE = {
                W = 38,
                H = 62,
                -- RANGE = 1024,
            },
        },
    },


    ID_PREFIX = "volumes",
}

local volumes = {
    isOpen = false,
    isClosing = false,
    isClosed = true,
    closeTime = 0,
    openTime = 0,

    functions = {}
}

function openVolumes()
    if isRightClicking() then
        switchMenu()
        return
    end
    volumes.isOpen = true
    volumes.isClosing = false
    volumes.isClosed = false
    volumes.openTime = main_state.time()
    main_state.set_timer(volumes.functions.getWindowTimerId(), main_state.time())
end

function closeVolumes()
    volumes.isClosing = true
    volumes.isClosed = false
    volumes.isOpen = false
    volumes.closeTime = volumes.ANIMATION_TIME * 1000
end

function closeVolumesRightClickEvent()
    if isRightClicking() == true then
        closeVolumes()
    end
end

function volumesTimer()
    if volumes.isOpen then
        return volumes.openTime
    elseif volumes.isClosed then
        return main_state.timer_off_value
    elseif volumes.isClosing then
        volumes.closeTime = volumes.closeTime - getDeltaTime()
        if volumes.closeTime <= 0 then
            volumes.closeTime = 0
            volumes.isOpen = false
            volumes.isClosed = true
            volumes.isClosing = false
        end
        return getElapsedTime() - volumes.closeTime
    end

    return main_state.timer_off_value
end

volumes.functions.load = function()
    local iconW = VOLUMES.ITEM.SLIDER.VOLUME_ICON.W
    local iconH = VOLUMES.ITEM.SLIDER.VOLUME_ICON.H

    local skin = {
        customEvents = {
            {id = 1020, action = "openVolumes()"},
            {id = 1021, action = "closeVolumes()"},
            {id = 1022, action = "closeVolumesRightClickEvent()"},
        },
        image = {
            {id = "blackVolumesClose", src = 999, x = 1, y = 0, w = 1, h = 1, act = 1021},
            {id = "whiteVolumesBg", src = 999, x = 2, y = 0, w = 1, h = 1, act = 1022},

            -- 音量アイコン
            {id = "volumeMinIcon", src = 2, x = 1704        , y = TEXTURE_SIZE - iconH, w = iconW, h = iconH},
            {id = "volumeMaxIcon", src = 2, x = 1704 + iconW, y = TEXTURE_SIZE - iconH, w = iconW, h = iconH},

            -- スライダーの端の部分とnonactiveの本体
            {id = "volumeActiveEdge", src = 2, x = 1687, y = 2022, w = VOLUMES.ITEM.SLIDER.BG_ACTIVE.EDGE_W, h = VOLUMES.ITEM.SLIDER.BG_ACTIVE.H},
            {id = "volumeNonActiveEdge", src = 2, x = 1687, y = 2040, w = VOLUMES.ITEM.SLIDER.BG_NONACTIVE.EDGE_W, h = VOLUMES.ITEM.SLIDER.BG_NONACTIVE.H},
            {id = "volumeNonActiveBody", src = 2, x = 1687 + VOLUMES.ITEM.SLIDER.BG_NONACTIVE.EDGE_W, y = 2040, w = 1, h = VOLUMES.ITEM.SLIDER.BG_NONACTIVE.H},

        },
        text = {
            {id = "volumesHeader", font = 0, size = HEADER.TEXT.FONT_SIZE, align = 0, constantText = "音量設定"},
            -- 各設定名
            {id = "masterHeaderText", font = 0, size = SUB_HEADER.FONT_SIZE, align = 1, constantText = "MASTER"},
            {id = "keyHeaderText", font = 0, size = SUB_HEADER.FONT_SIZE, align = 1, constantText = "KEY"},
            {id = "bgmHeaderText", font = 0, size = SUB_HEADER.FONT_SIZE, align = 1, constantText = "BGM"},
        },
        graph = {},
    }

    -- 閉じるボタン
    loadCloseButtonSelect(skin, "volumesCloseButton", 1021)

    local texts = skin.text
    local imgs = skin.image
    local graphs = skin.graph

    -- 各音量の読み込み等
    -- スライダーはdstで
    for i = 1, 3 do
        -- 音量ゲージのアクティブ部分
        graphs[#graphs+1] = {
            id = "volumeActiveBody", src = 2, 
        }
    end

    return skin
end

volumes.functions.dst = function ()
    local skin = {
        destination = {},
        slider = {
            {id = "musicSelectSlider", src = 0, x = 1541, y = commons.PARTS_OFFSET + 263, w = MUSIC_SLIDER_BUTTON_W, h = MUSIC_SLIDER_BUTTON_H, type = 1, range = 1024, angle = 1},
        }
    }

    return skin
end

return volumes.functions
