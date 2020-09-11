require("modules.result.commons")
local main_state = require("main_state")

local stagefile = {
    functions = {}
}

local STAGEFILE = {
    X = 1085,
    Y = 492,
    W = 640,
    H = 480,
    BG_ALPHA = 128,
}

stagefile.functions.load = function ()
    return {
        image = {
            {id = "noImage", src = 20, x = 0, y = 0, w = -1, h = -1},
        }
    }
end

stagefile.functions.dst = function ()
    return {
        destination = {
            {
                id = "noImage", op = {190}, stretch = 1, filter = 1, dst = {
                    {x = STAGEFILE.X, y = STAGEFILE.Y, w = STAGEFILE.W, h = STAGEFILE.H}
                }
            },
            {
                id = "black", op = {191}, dst = {
                    {x = STAGEFILE.X, y = STAGEFILE.Y, w = STAGEFILE.W, h = STAGEFILE.H, a = STAGEFILE.BG_ALPHA}
                }
            },
            {
                id = -100, op = {191}, stretch = 1, filter = 1, dst = {
                    {x = STAGEFILE.X, y = STAGEFILE.Y, w = STAGEFILE.W, h = STAGEFILE.H}
                }
            }
        }
    }
end

return stagefile.functions