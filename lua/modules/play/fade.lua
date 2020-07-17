require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local fade = {
    functions = {}
}

local FADE = {
    TIME = 500,
}

fade.functions.load = function ()
    return {}
end

fade.functions.dst = function ()
    return {
        destination = {
            {id = "black", loop = -1, dst = {
                {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 255},
                {time = FADE.TIME, a = 0}
            }},
            {id = "black", timer = 2, loop = FADE.TIME, dst = {
                {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 0},
                {time = FADE.TIME, a = 255}
            }}
        }
    }
end

fade.functions.getFadeoutTime = function ()
    return FADE.TIME
end

return fade.functions