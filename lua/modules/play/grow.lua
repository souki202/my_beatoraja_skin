require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local grow = {
    functions = {}
}

local GROW = {
    X = function () return lanes.getAreaX() end,
    Y = function () return lanes.getAreaY() end,
    W = function () return lanes.getAreaW() end,
    H = 45,
}

local function getGrowColor()
	local dif = getDifficultyValueForColor()
	local colors = {{128, 128, 128}, {0, 192, 128}, {0, 128, 255}, {192, 128, 64}, {192, 0, 0}, {192, 0, 92}}
	return colors[dif][1], colors[dif][2], colors[dif][3]
end

grow.functions.load = function ()
    return {
        image = {
            {id = "grow", src = 0, x = 459, y = PARTS_TEXTURE_SIZE - GROW.H, w = 1, h = GROW.H}
        }
    }
end

grow.functions.dst = function ()
    local r, g, b = getGrowColor()
    return {
        destination = {
            {id = "grow", offset = 3, timer = 140, dst = {
                {time = 0, x = GROW.X(), y = GROW.Y(), w = GROW.W(), h = GROW.H, r = r, g = g, b = b, a = 255},
                {time = 1000, a = 64}
            }}
        }
    }
end

return grow.functions