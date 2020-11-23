require("modules.commons.my_window")
require("modules.commons.numbers")
require("modules.commons.input")

local commons = require("modules.select.commons")
local main_state = require("main_state")

local TEXTURE_SIZE = 2048

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
        Y = function (idx) return SIMPLE_WND_AREA.Y + 766 - (idx - 1) * 106 end,
        HEADER = {
            X = function () return SIMPLE_WND_AREA.X + 32 end,
            W = 128,
        },
        VOLUME_ICON = {
            W = 52,
            H = 36,
            X_MIN = function () return SIMPLE_WND_AREA.X + 223 end,
            X_MAX = function () return SIMPLE_WND_AREA.X + 1334 end,
            Y = function (self, idx) return self.ITEM.Y(idx) + 3 end,
        },
        VALUE = {
            BG = {
                X = function () return SIMPLE_WND_AREA.X + 1440 end,
                Y = function (self, idx) return self.ITEM.Y(idx) - 6 end,
                W = 128,
                H = 46,
            },
            NUM = {
                X = function (self) return self.ITEM.VALUE.BG.X() + 40 end,
                Y = function (self, idx) return self.ITEM.VALUE.BG.Y(self, idx) + 12 end,
                W = 16,
                H = 22,
            }
        },
        SLIDER = {
            X = function () return SIMPLE_WND_AREA.X + 293 end,
            W = 1024,
            BG_NONACTIVE = {
                Y = function (self, idx) return self.ITEM.Y(idx) + 17 end,
                H = 8,
                EDGE_W = 8,
                BODY_W = 1024 - 8 * 2,
            },
            BG_ACTIVE = {
                Y = function (self, idx) return self.ITEM.Y(idx) + 12 end,
                H = 18,
                EDGE_W = 8,
                BODY_W = 1024 - 8,
            },
            HANDLE = {
                Y = function (self, idx) return self.ITEM.Y(idx) - 9 end,
                W = 38,
                H = 62,
                -- RANGE = 1024,
            },
        },
    },
    ANIMATION_TIME = 150,

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

volumes.functions.getWindowTimerId = function() return 10600 end

function openVolumes()
    myPrint("Volumeウィンドウ open")
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
    myPrint("Volumeウィンドウ close")
    volumes.isClosing = true
    volumes.isClosed = false
    volumes.isOpen = false
    volumes.closeTime = VOLUMES.ANIMATION_TIME * 1000
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
    local iconW = VOLUMES.ITEM.VOLUME_ICON.W
    local iconH = VOLUMES.ITEM.VOLUME_ICON.H

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

            -- スライダーの端の部分とnonactiveの本体 active本体はbargraphの方に
            {id = "volumeActiveEdge", src = 2, x = 1687, y = 2022, w = VOLUMES.ITEM.SLIDER.BG_ACTIVE.EDGE_W, h = VOLUMES.ITEM.SLIDER.BG_ACTIVE.H},
            {id = "volumeNonActiveEdge", src = 2, x = 1687, y = 2040, w = VOLUMES.ITEM.SLIDER.BG_NONACTIVE.EDGE_W, h = VOLUMES.ITEM.SLIDER.BG_NONACTIVE.H},
            {id = "volumeNonActiveBody", src = 2, x = 1687 + VOLUMES.ITEM.SLIDER.BG_NONACTIVE.EDGE_W, y = 2040, w = 1, h = VOLUMES.ITEM.SLIDER.BG_NONACTIVE.H},

            {id = "volumeValueBg", src = 2, x = 1808, y = TEXTURE_SIZE - VOLUMES.ITEM.VALUE.BG.H, w = VOLUMES.ITEM.VALUE.BG.W, h = VOLUMES.ITEM.VALUE.BG.H}
        },
        text = {
            {id = "volumesHeader", font = 0, size = HEADER.TEXT.FONT_SIZE, align = 0, constantText = "音量設定"},
            -- 各設定名
            {id = "masterHeaderText", font = 0, size = SUB_HEADER.FONT_SIZE, align = 1, constantText = "MASTER"},
            {id = "keyHeaderText", font = 0, size = SUB_HEADER.FONT_SIZE, align = 1, constantText = "KEY"},
            {id = "bgmHeaderText", font = 0, size = SUB_HEADER.FONT_SIZE, align = 1, constantText = "BGM"},
        },
        graph = {},
        slider = {},
        value = {},
    }

    -- 閉じるボタン
    loadCloseButtonSelect(skin, "volumesCloseButton", 1021)

    local texts = skin.text
    local imgs = skin.image
    local graphs = skin.graph
    local slider = skin.slider
    local vals = skin.value

    -- 各音量の読み込み等
    -- スライダーはdstで
    do
        local ids = {"master", "key", "bgm"}
        local volFuncs = {main_state.volume_sys, main_state.volume_key, main_state.volume_bg}
        local setVolFuncs = {main_state.set_volume_sys, main_state.set_volume_key, main_state.set_volume_bg}
        for i = 1, 3 do
            -- 音量ゲージのアクティブ部分
            graphs[#graphs+1] = {
                id = ids[i] .. "VolumeActiveBody", src = 2, x = 1687 + VOLUMES.ITEM.SLIDER.BG_ACTIVE.EDGE_W, y = 2022, w = 1, h = VOLUMES.ITEM.SLIDER.BG_ACTIVE.H, angle = 0,
                value = function () return volFuncs[i]() end,
            }
            -- スライダー
            slider[#slider+1] = {
                id = ids[i] .. "VolumeSlider", src = 2, x = 1649, y = TEXTURE_SIZE - VOLUMES.ITEM.SLIDER.HANDLE.H, w = VOLUMES.ITEM.SLIDER.HANDLE.W, h = VOLUMES.ITEM.SLIDER.HANDLE.H, type = 17 + (i - 1), range = VOLUMES.ITEM.SLIDER.W, angle = 1
            }
            vals[#vals+1] = {
                id = ids[i] .. "Value", src = 2, x = 1111, y = PARTS_TEXTURE_SIZE - VOLUMES.ITEM.VALUE.NUM.H, w = VOLUMES.ITEM.VALUE.NUM.W * 10, h = VOLUMES.ITEM.VALUE.NUM.H, divx = 10, digit = 3, align = 2, value = function () return math.floor(volFuncs[i]() * 100) end,
            }
            -- 音量100と0ボタン
            imgs[#imgs+1] = {id = ids[i] .. "VolumeMinIcon", src = 2, x = 1704        , y = TEXTURE_SIZE - iconH, w = iconW, h = iconH, act = function () setVolFuncs[i](0) end}
            imgs[#imgs+1] = {id = ids[i] .. "VolumeMaxIcon", src = 2, x = 1704 + iconW, y = TEXTURE_SIZE - iconH, w = iconW, h = iconH, act = function () setVolFuncs[i](1) end}

        end
    end

    return skin
end

volumes.functions.dst = function ()
    local timer = volumes.functions.getWindowTimerId()
    local atime = VOLUMES.ANIMATION_TIME

    local skin = {
        destination = {},
    }

    -- アニメーションの機構が無いものは取り敢えずこっちにいれてから, すべての要素にtimerとアニメーションをつける
    local itemSkin = {
        destination = {},
    }

    dstSimplePopUpWindowSelect(skin, "blackVolumesClose", timer, atime)
    dstCloseButton(skin, "volumesCloseButton", timer, atime)
    dstHeaderSelect(skin, {}, timer, atime, "volumesHeader")
    dstCloseArea(skin, "whiteVolumesBg", nil, timer, atime)

    local init = {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0}

    local ids = {"master", "key", "bgm"}
    local dst = itemSkin.destination
    local item = VOLUMES.ITEM
    for i = 1, 3 do
        dstSubHeaderSelect(skin, item.HEADER.X(), item.Y(i), item.HEADER.W, {}, volumes.functions.getWindowTimerId(), atime, ids[i] .. "HeaderText", true)
        -- 音量アイコン
        dst[#dst+1] = {
            id = ids[i] .. "VolumeMinIcon", dst = {
                {x = item.VOLUME_ICON.X_MIN(), y = item.VOLUME_ICON.Y(VOLUMES, i), w = item.VOLUME_ICON.W, h = item.VOLUME_ICON.H}
            }
        }
        dst[#dst+1] = {
            id = ids[i] .. "VolumeMaxIcon", dst = {
                {x = item.VOLUME_ICON.X_MAX(), y = item.VOLUME_ICON.Y(VOLUMES, i), w = item.VOLUME_ICON.W, h = item.VOLUME_ICON.H}
            }
        }
        -- スライダーのnonactive背景
        dst[#dst+1] = {
            id = "volumeNonActiveEdge", dst = {
                {x = item.SLIDER.X(), y = item.SLIDER.BG_NONACTIVE.Y(VOLUMES, i), w = item.SLIDER.BG_NONACTIVE.EDGE_W, h = item.SLIDER.BG_NONACTIVE.H}
            }
        }
        dst[#dst+1] = {
            id = "volumeNonActiveEdge", dst = {
                {x = item.SLIDER.X() + item.SLIDER.W, y = item.SLIDER.BG_NONACTIVE.Y(VOLUMES, i), w = -item.SLIDER.BG_NONACTIVE.EDGE_W, h = item.SLIDER.BG_NONACTIVE.H}
            }
        }
        dst[#dst+1] = {
            id = "volumeNonActiveBody", dst = {
                {x = item.SLIDER.X() + item.SLIDER.BG_NONACTIVE.EDGE_W, y = item.SLIDER.BG_NONACTIVE.Y(VOLUMES, i), w = item.SLIDER.BG_NONACTIVE.BODY_W, h = item.SLIDER.BG_NONACTIVE.H}
            }
        }
        -- スライダーのアクティブ
        dst[#dst+1] = {
            id = "volumeActiveEdge", dst = {
                {x = item.SLIDER.X(), y = item.SLIDER.BG_ACTIVE.Y(VOLUMES, i), w = item.SLIDER.BG_ACTIVE.EDGE_W, h = item.SLIDER.BG_ACTIVE.H}
            }
        }
        dst[#dst+1] = {
            id = ids[i] .. "VolumeActiveBody", dst = {
                {x = item.SLIDER.X() + item.SLIDER.BG_ACTIVE.EDGE_W, y = item.SLIDER.BG_ACTIVE.Y(VOLUMES, i), w = item.SLIDER.BG_ACTIVE.BODY_W, h = item.SLIDER.BG_ACTIVE.H}
            }
        }
        -- ハンドル
        dst[#dst+1] = {
            id = ids[i] .. "VolumeSlider", dst = {
                {x = item.SLIDER.X() - item.SLIDER.HANDLE.W / 2, y = item.SLIDER.HANDLE.Y(VOLUMES, i), w = item.SLIDER.HANDLE.W, h = item.SLIDER.HANDLE.H}
            }
        }

        -- volumeの値
        dst[#dst+1] =  {
            id = "volumeValueBg", dst = {
                {x = item.VALUE.BG.X(), y = item.VALUE.BG.Y(VOLUMES, i), w = item.VALUE.BG.W, h = item.VALUE.BG.H}
            }
        }
        dst[#dst+1] = {
            id = ids[i] .. "Value", dst = {
                {x = item.VALUE.NUM.X(VOLUMES), y = item.VALUE.NUM.Y(VOLUMES, i), w = item.VALUE.NUM.W, h = item.VALUE.NUM.H}
            }
        }
    end

    for key, value in pairs(itemSkin.destination) do
        value.timer = timer
        value.loop = atime
        value.dst[1].time = atime
        table.insert(value.dst, 1, init)
        table.insert(value.dst, 2, {time = 1, a = 255})
    end

    mergeSkin(skin, itemSkin)
    return skin
end

return volumes.functions
