local fade = {
    functions = {}
}

local FADE = {
    IN_TIME = 150,
    OUT_TIME = 500,
    OUT_ANIM_TIME = 300,
}

fade.functions.load = function ()
    return {}
end

fade.functions.dst = function ()
    return {
        destination = {
            {
                id = "black", loop = -1, dst = {
                    {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 255},
                    {time = FADE.IN_TIME, a = 0}
                }
            },
            {
                id = "black", timer = 2, loop = FADE.OUT_TIME, dst = {
                    {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 0},
                    {time = FADE.OUT_TIME - FADE.OUT_ANIM_TIME},
                    {time = FADE.OUT_TIME, a = 255}
                }
            }
        }
    }
end

fade.functions.getFadeOutTime = function ()
    return FADE.OUT_TIME
end

return fade.functions