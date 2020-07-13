require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local cover = {
    functions = {}
}

local COVER = {
    X = function () return lanes.getAreaX() end,
    Y = function () return 0 end,
    W = function () return lanes.getAreaW() end,
    H = function () return lanes.getLaneHeight() end,
}

cover.functions.load = function ()
    return {
        hiddenCover = {
            {id = "hiddenCover", src = 999, x = 1, y = 0, w = 1, h = 1, disapearLine = lanes.getAreaY()}
        },
        slider = {
            {id = "laneCover", src = 9, x = 0, y = 0, w = COVER.W(), h = COVER.H(), angle = 2, range = lanes.getLaneHeight(), type = 4}
        },
        liftCover = {
            {id = "liftCover", src = 10, x = 0, y = 0, w = COVER.W(), h = COVER.H(), disapearLine = lanes.getAreaY()}
        }
    }
end

cover.functions.dst = function ()
    return {
        destination = {
            {id = "hiddenCover", dst = {{x = lanes.getAreaX(), y = lanes.getAreaY() - COVER.H(), w = COVER.W(), h = COVER.H()}}},
            {id = "liftCover", dst = {{x = lanes.getAreaX(), y = lanes.getAreaY() - COVER.H(), w = COVER.W(), h = COVER.H()}}},
            {id = "laneCover", dst = {{x = lanes.getAreaX(), y = HEIGHT, w = COVER.W(), h = COVER.H()}}},
        }
    }
end

return cover.functions