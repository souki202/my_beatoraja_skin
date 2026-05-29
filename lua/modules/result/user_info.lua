require("modules.commons.define")
require("modules.result.commons")
local main_state = require("main_state")

local userInfo = {
    functions = {}
}

local CLIENT_VERSION_REF = 1010

local USER_INFO = {
    SIZE = 16,
    WND = {
        X = RIGHT_X,
        Y = -16,
        W = WND_WIDTH,
        H = 44,
    },
    PLAYER = {
        X = function (self) return self.WND.X + 18 end,
        Y = function (self) return self.WND.Y + 20 end,
        W = 200,
    },
    CLIENT = {
        X = function (self) return self.WND.X + 325 end,
        Y = function (self) return self.WND.Y + 20 end,
        W = 250,
    },
    DATE = {
        X = function (self) return self.WND.X + self.WND.W - 18 end,
        Y = function (self) return self.WND.Y + 20 end,
        W = 160,
    },
}

userInfo.functions.change2p = function ()
    USER_INFO.WND.X = LEFT_X
end

local function getClientName()
    local version = main_state.text(CLIENT_VERSION_REF) or ""
    local lowerVersion = string.lower(version)

    if string.find(lowerVersion, "endless%s*dream") then
        return "LR2oraja ~Endless Dream~"
    elseif string.find(lowerVersion, "lr2oraja") then
        return "LR2oraja"
    elseif string.find(lowerVersion, "beatoraja") then
        return "beatoraja"
    elseif version ~= "" then
        return version
    end

    return "Unknown"
end

userInfo.functions.load = function ()
    local getNum = main_state.number
    local playerLabel = "Player: " .. main_state.text(2)
    local clientLabel = getClientName()
    local dateLabel = ""
    if isViewResultDate() then
        if isViewDateOnly() then
            dateLabel = string.format("%04d", getNum(21)) .. "-" .. string.format("%02d", getNum(22)) .. "-" .. string.format("%02d", getNum(23))
        elseif isViewDateAndTime() then
            dateLabel = string.format("%04d", getNum(21)) .. "-" .. string.format("%02d", getNum(22)) .. "-" .. string.format("%02d", getNum(23)) .. " " .. string.format("%02d", getNum(24)) .. ":" .. string.format("%02d", getNum(25)) .. ":" .. string.format("%02d", getNum(26))
        end
    end

    return {
        text = {
            {id = "playerName", font = 0, size = USER_INFO.SIZE * 2, constantText = playerLabel},
            {id = "clientName", font = 0, size = USER_INFO.SIZE * 2, align = 1, constantText = clientLabel},
            {id = "resultDate", font = 0, size = USER_INFO.SIZE * 2, align = 2, constantText = dateLabel}
        }
    }
end

userInfo.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    destinationStaticBaseWindowResult(skin, USER_INFO.WND.X, USER_INFO.WND.Y, USER_INFO.WND.W, USER_INFO.WND.H)
    dst[#dst+1] = {
        id = "playerName", filter = 1, dst = {
            {x = USER_INFO.PLAYER.X(USER_INFO), y = USER_INFO.PLAYER.Y(USER_INFO), w = USER_INFO.PLAYER.W, h = USER_INFO.SIZE, r = 0, g = 0, b = 0}
        }
    }
    dst[#dst+1] = {
        id = "resultDate", filter = 1, dst = {
            {x = USER_INFO.DATE.X(USER_INFO), y = USER_INFO.DATE.Y(USER_INFO), w = USER_INFO.DATE.W, h = USER_INFO.SIZE, r = 0, g = 0, b = 0}
        }
    }
    dst[#dst+1] = {
        id = "clientName", filter = 1, dst = {
            {x = USER_INFO.CLIENT.X(USER_INFO), y = USER_INFO.CLIENT.Y(USER_INFO), w = USER_INFO.CLIENT.W, h = USER_INFO.SIZE, r = 0, g = 0, b = 0}
        }
    }
    return skin
end


return userInfo.functions
