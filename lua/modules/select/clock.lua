require("modules.commons.my_window")
local commons = require("modules.select.commons")
local main_state = require("main_state")

local clock = {
    functions = {}
}

local CLOCK = {
    WND = {
        X = 1792,
        Y = -20,
        W = 186,
        H = 52,
    },

    -- 必ず2桁固定0fillするのですべて左揃え
    NUM = {
        Y = 7,
        COLON_Y = 3,
        COLON_SIZE = 24,

        HOUR = {
            X = function (self) return self.WND.X + 18 end,
            COLON_X = function (self) return self.WND.X + 45 end,
        },
        MINUTE = {
            X = function (self) return self.WND.X + 50 end,
            COLON_X = function (self) return self.WND.X + 78 end,
        },
        SEC = {
            X = function (self) return self.WND.X + 84 end,
        },
    }
}

clock.functions.load = function ()
    return {
        value = {
            {id = "clockHour", src = 0, x = commons.NUM_24PX.SRC_X, y = commons.NUM_24PX.SRC_Y, w = commons.NUM_24PX.W * 10, h = commons.NUM_24PX.H, divx = 10, ref = 24, digit = 2, zeropadding = 1, padding = 1, align = 1},
            {id = "clockMinute", src = 0, x = commons.NUM_24PX.SRC_X, y = commons.NUM_24PX.SRC_Y, w = commons.NUM_24PX.W * 10, h = commons.NUM_24PX.H, divx = 10, ref = 25, digit = 2, zeropadding = 1, padding = 1, align = 1},
            {id = "clockSec", src = 0, x = commons.NUM_24PX.SRC_X, y = commons.NUM_24PX.SRC_Y, w = commons.NUM_24PX.W * 10, h = commons.NUM_24PX.H, divx = 10, ref = 26, digit = 2, zeropadding = 1, padding = 1, align = 1},
        },
        text = {
            {id = "colonForClock", font = 0, size = CLOCK.NUM.COLON_SIZE, constantText = ":"}
        }
    }
end

clock.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    destinationStaticBaseWindowSelect(skin, CLOCK.WND.X, CLOCK.WND.Y, CLOCK.WND.W, CLOCK.WND.H)

    dst[#dst+1] = {
        id = "clockHour", dst = {
            {x = CLOCK.NUM.HOUR.X(CLOCK), y = CLOCK.NUM.Y, w = commons.NUM_24PX.W, h = commons.NUM_24PX.H, a = 192}
        },
    }
    dst[#dst+1] = {
        id = "colonForClock", dst = {
            {x = CLOCK.NUM.HOUR.COLON_X(CLOCK), y = CLOCK.NUM.COLON_Y, w = 12, h = CLOCK.NUM.COLON_SIZE, r = 0, g = 0, b = 0, a = 192}
        }
    }
    dst[#dst+1] = {
        id = "clockMinute", dst = {
            {x = CLOCK.NUM.MINUTE.X(CLOCK), y = CLOCK.NUM.Y, w = commons.NUM_24PX.W, h = commons.NUM_24PX.H, a = 192}
        },
    }
    dst[#dst+1] = {
        id = "colonForClock", dst = {
            {x = CLOCK.NUM.MINUTE.COLON_X(CLOCK), y = CLOCK.NUM.COLON_Y, w = 12, h = CLOCK.NUM.COLON_SIZE, r = 0, g = 0, b = 0, a = 192}
        }
    }
    dst[#dst+1] = {
        id = "clockSec", dst = {
            {x = CLOCK.NUM.SEC.X(CLOCK), y = CLOCK.NUM.Y, w = commons.NUM_24PX.W, h = commons.NUM_24PX.H, a = 192}
        },
    }

    return skin
end

return clock.functions