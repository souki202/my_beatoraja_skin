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
    H = function () return lanes.getLaneNormalHeight() end,
}

cover.functions.load = function ()
    return {
        hiddenCover = {
            {id = "hiddenCover", src = 999, x = 1, y = 0, w = 1, h = 1, disapearLine = lanes.getAreaNormalY()}
        },
        slider = {
            {id = "laneCover", src = 86, x = 0, y = 0, w = COVER.W(), h = COVER.H(), angle = 2, range = lanes.getLaneNormalHeight(), type = 4}
        },
        liftCover = {
            {id = "liftCover", src = 87, x = 0, y = 0, w = COVER.W(), h = COVER.H(), disapearLine = lanes.getAreaNormalY()}
        }
    }
end

cover.functions.dstOtherCover = function ()
    return {
        destination = {
            {id = "hiddenCover", dst = {{x = lanes.getAreaX(), y = lanes.getAreaNormalY() - COVER.H(), w = COVER.W(), h = COVER.H()}}},
            {id = "liftCover", dst = {{x = lanes.getAreaX(), y = lanes.getAreaNormalY() - COVER.H(), w = COVER.W(), h = COVER.H()}}},
        }
    }
end

cover.functions.dstLaneCover = function ()
    return {
        destination = {
            {id = "laneCover", dst = {{x = lanes.getAreaX(), y = HEIGHT, w = COVER.W(), h = COVER.H()}}},
        }
    }
end

return cover.functions