require("modules.commons.define")
require("modules.result.commons")
local main_state = require("main_state")

local userInfo = {
    functions = {}
}

local USER_INFO = {
    SIZE = 16,
    WND = {
        X = RIGHT_X,
        Y = -16,
        W = WND_WIDTH,
        H = 44,
    },
    DATE = {
        X = function (self) return self.WND.X + 18 end,
        Y = function (self) return self.WND.Y + 20 end,
        W = 160,
    },
    NAME = {
        X = function (self) return self.WND.X + self.WND.W - 18 end,
        Y = function (self) return self.WND.Y + 20 end,
        W = 460,
    }
}

userInfo.functions.change2p = function ()
    USER_INFO.WND.X = LEFT_X
end

userInfo.functions.load = function ()
    local getNum = main_state.number
    local playerLabel = "Player: " .. main_state.text(2)
    local dateLabel = string.format("%04d", getNum(21)) .. "-" .. string.format("%02d", getNum(22)) .. "-" .. string.format("%02d", getNum(23)) .. " " .. string.format("%02d", getNum(24)) .. ":" .. string.format("%02d", getNum(25)) .. ":" .. string.format("%02d", getNum(26))

    return {
        text = {
            {id = "resultDate", font = 0, size = USER_INFO.SIZE * 2, constantText = playerLabel},
            {id = "playerName", font = 0, size = USER_INFO.SIZE * 2, align = 2, constantText = dateLabel}
        }
    }
end

userInfo.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    destinationStaticBaseWindowResult(skin, USER_INFO.WND.X, USER_INFO.WND.Y, USER_INFO.WND.W, USER_INFO.WND.H)
    dst[#dst+1] = {
        id = "resultDate", filter = 1, dst = {
            {x = USER_INFO.DATE.X(USER_INFO), y = USER_INFO.DATE.Y(USER_INFO), w = USER_INFO.DATE.W, h = USER_INFO.SIZE, r = 0, g = 0, b = 0}
        }
    }
    dst[#dst+1] = {
        id = "playerName", filter = 1, dst = {
            {x = USER_INFO.NAME.X(USER_INFO), y = USER_INFO.NAME.Y(USER_INFO), w = USER_INFO.NAME.W, h = USER_INFO.SIZE, r = 0, g = 0, b = 0}
        }
    }
    return skin
end


return userInfo.functions