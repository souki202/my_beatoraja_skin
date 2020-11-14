require("modules.commons.my_window")
require("modules.commons.numbers")

local commons = require("modules.select.commons")
local main_state = require("main_state")

local volumes = {
    WND = {
        W = 1600,
        H = 900
    },
    CLOSE_BUTTON = {
        X = 728,
        Y = 12,
    },

    ID_PREFIX = "volumes",

    isOpen = false,
    isClosing = false,
    isClosed = true,
    closeTime = 0,
    openTime = 0,
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

volumes.functions.load = function(skin)
    table.insert(skin.customEvents, {id = 1010, action = "openVolumes()"})
    table.insert(skin.customEvents, {id = 1011, action = "closeVolumes()"})
    table.insert(skin.customEvents, {id = 1012, action = "closeVolumesRightClickEvent()"})

    -- 背景は閉じるボタン
    table.insert(skin.image, {
        id = "blackVolumesClose", src = 999, x = 1, y = 0, w = 1, h = 1, act = 1011
    })

    -- 閉じるボタン
    loadCloseButtonSelect(skin, "volumesCloseButton", 1011)

    table.insert(skin.image, {
        id = "whiteVolumesBg", src = 999, x = 2, y = 0, w = 1, h = 1, act = 1012
    })

end