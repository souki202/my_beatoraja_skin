local lanes = require("modules.play.lanes")

local auto = {
    functions = {}
}

local AUTO = {
    TEXT = {
        X = function () return lanes.getAreaX() + lanes.getAreaW() / 2 end,
        Y = function () return lanes.getAreaY() -36 end,
        SIZE = 24,
        APPEAR_TIME = 500,
        ALPHA = 128,
    },
}

auto.functions.load = function ()
    return {
        text = {
            {id = "autoplayMessage", font = 0, size = AUTO.TEXT.SIZE, align = 1, constantText = "AUTOPLAY"},
            {id = "replayMessage", font = 0, size = AUTO.TEXT.SIZE, align = 1, constantText = "REPLAY"},
        }
    }
end

auto.functions.dst = function ()
    return {
        destination = {
            {id = "autoplayMessage", op = {33}, timer = 41, loop = AUTO.TEXT.APPEAR_TIME, dst = {
                {time = 0, x = AUTO.TEXT.X(), y = AUTO.TEXT.Y(), w = 999, h = AUTO.TEXT.SIZE, a = 0},
                {time = AUTO.TEXT.APPEAR_TIME, a = AUTO.TEXT.ALPHA}
            }},
            {id = "replayMessage", op = {84}, timer = 41, loop = AUTO.TEXT.APPEAR_TIME, dst = {
                {time = 0, x = AUTO.TEXT.X(), y = AUTO.TEXT.Y(), w = 999, h = AUTO.TEXT.SIZE, a = 0},
                {time = AUTO.TEXT.APPEAR_TIME, a = AUTO.TEXT.ALPHA}
            }},
        }
    }
end

return auto.functions