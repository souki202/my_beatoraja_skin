require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local info = {
    functions = {}
}

local REF = {
    HISPEED = 310,
    HISPEED_AFTERDOT = 311,
    GREEN_NUMBER = 313,
    BLUE_NUMBER = 312,
    GREEN_NUMBER_LANECOVER_ON = 1312,
    BLUE_NUMBER_LANECOVER_ON = 1313,
    BPM_NOW = 160,
    BPM_MIN = 91,
    BPM_MAX = 90,
    TOTAL_NOTES = 74,
    MAX_COMBO = 105,
}

local OPTION_LANECOVER1_ON = 271

local function numberValue(ref)
    return main_state.number(ref) or 0
end

local function numberText(ref)
    return tostring(numberValue(ref))
end

local function coverNumberText(coverOnRef, coverOffRef)
    return numberText(main_state.option(OPTION_LANECOVER1_ON) and coverOnRef or coverOffRef)
end

local function hiSpeedText()
    return string.format("%d.%02d", numberValue(REF.HISPEED), numberValue(REF.HISPEED_AFTERDOT))
end

local function bpmRangeText()
    return numberText(REF.BPM_MIN) .. "~" .. numberText(REF.BPM_MAX)
end

local INFO = {
    TEXT = {
        X = function (self) return self.AREA.X() + 10 end,
        W = 54,
        SIZE = 18,
        SMALL_SIZE = 14,
    },
    AREA = {
        X = function () return is1P() and 2 or WIDTH - 73 end,
        Y = 118,
        W = 71,
        H = 239,
    }
}

info.functions.load = function ()
    return {
        image = {
            {id = "infoBg", src = 0, x = 422, y = 1593, w = INFO.AREA.W, h = INFO.AREA.H},
        },
        value = {
        },
        text = {
            {id = "hiSpeedValue", font = 1, size = INFO.TEXT.SIZE, overflow = 1, value = hiSpeedText},
            {id = "greenNumberValue", font = 1, size = INFO.TEXT.SMALL_SIZE, overflow = 1, value = function () return coverNumberText(REF.GREEN_NUMBER_LANECOVER_ON, REF.GREEN_NUMBER) end},
            {id = "blueNumberValue", font = 1, size = INFO.TEXT.SMALL_SIZE, overflow = 1, value = function () return coverNumberText(REF.BLUE_NUMBER_LANECOVER_ON, REF.BLUE_NUMBER) end},
            {id = "bpmNow", font = 1, size = INFO.TEXT.SIZE, overflow = 1, value = function () return numberText(REF.BPM_NOW) end},
            {id = "bpmRange", font = 1, size = INFO.TEXT.SMALL_SIZE, overflow = 1, value = bpmRangeText},
            {id = "maxComboValue", font = 1, size = INFO.TEXT.SIZE, overflow = 1, value = function () return numberText(REF.MAX_COMBO) end},
            {id = "colon18px", font = 0, size = 18, constantText = ":"}
        }
    }
end

info.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    local y = INFO.AREA.Y

    -- 背景
    dst[#dst+1] = {
        id = "infoBg", dst = {
            {x = INFO.AREA.X(), y = y, w = INFO.AREA.W, h = INFO.AREA.H}
        }
    }

    dst[#dst+1] = {
        id = "bpmNow", dst = {
            {x = INFO.TEXT.X(INFO), y = y + 117, w = INFO.TEXT.W, h = INFO.TEXT.SIZE, r = 250, g = 249, b = 250}
        }
    }
    dst[#dst+1] = {
        id = "bpmRange", dst = {
            {x = INFO.TEXT.X(INFO), y = y + 99, w = INFO.TEXT.W, h = INFO.TEXT.SMALL_SIZE, r = 250, g = 249, b = 250}
        }
    }

    -- HiSpeed / green number / blue number
    dst[#dst+1] = {
        id = "hiSpeedValue", dst = {
            {x = INFO.TEXT.X(INFO), y = y + 196, w = INFO.TEXT.W, h = INFO.TEXT.SIZE, r = 250, g = 249, b = 250}
        }
    }
    dst[#dst+1] = {
        id = "greenNumberValue", dst = {
            {x = INFO.TEXT.X(INFO), y = y + 179, w = INFO.TEXT.W, h = INFO.TEXT.SMALL_SIZE, r = 109, g = 244, b = 105}
        }
    }
    dst[#dst+1] = {
        id = "blueNumberValue", dst = {
            {x = INFO.TEXT.X(INFO), y = y + 162, w = INFO.TEXT.W, h = INFO.TEXT.SMALL_SIZE, r = 105, g = 151, b = 244}
        }
    }

    -- max combo
    dst[#dst+1] = {
        id = "maxComboValue", dst = {
            {x = INFO.TEXT.X(INFO), y = y + 50, w = INFO.TEXT.W, h = INFO.TEXT.SIZE, r = 250, g = 249, b = 250}
        }
    }

    return skin
end

return info.functions
