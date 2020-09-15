require("modules.result.commons")
local main_state = require("main_state")

local background = {
    functions = {}
}

local BACKGROUND = {
    ID = "background",
}

background.functions.load = function ()
    print("bgsrc: " .. getBgSrc())
    return {
        image = {
            {id = BACKGROUND.ID, src = getBgSrc(), x = 0, y = 0, w = -1, h = -1},
        }
    }
end

background.functions.dst = function ()
    return {
        destination = {
            {
                id = BACKGROUND.ID, dst = {
                    {x = 0, y = 0, w = WIDTH, h = HEIGHT}
                }
            },
        }
    }
end

return background.functions