require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local fadeout = {
    functions = {}
}

local FADEOUT = {
    TIME = 500,
}

fadeout.functions.load = function ()
    return {}
end

fadeout.functions.dst = function ()
    return {
        destination = {
            {id = "black", timer = 2, loop = FADEOUT.TIME, dst = {
                {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 0},
                {time = FADEOUT.TIME, a = 255}
            }}
        }
    }
end

fadeout.functions.getFadeoutTime = function ()
    return FADEOUT.TIME
end

return fadeout.functions