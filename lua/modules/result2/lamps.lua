require("modules.result.commons")
local main_state = require("main_state")

local lamps = {
    functions = {}
}

local LAMPS = {
    PREFIX = {"failed", "aeasy", "laeasy", "easy", "normal", "hard", "exhard", "fullcombo", "perfect", "perfect"},
    AREA = {
        X = function (self) return 1462 - self.AREA.W / 2 end,
        Y = function (self) return 987 end,
        W = 528,
        H = 55,
    }
}

lamps.functions.load = function ()
    return {
        image = {
            {id = "lampText", src = 12, x = 0, y = 0, w = -1, h = -1, divy = 11, len = 11, ref = 370},
        }
    }
end

lamps.functions.dst = function ()
    return {
        destination = {
            {
                id = "lampText", dst = {
                    {x = LAMPS.AREA.X(LAMPS), y = LAMPS.AREA.Y(LAMPS), w = LAMPS.AREA.W, h = LAMPS.AREA.H}
                }
            }
        }
    }
end

return lamps.functions