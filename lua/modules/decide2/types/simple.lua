local main_state = require("main_state")
local timeTableLoader = require("modules.decide2.time_table")

local DECIDE = {
    FRAME = {
        X = 0,
        Y = 0,
        W = 871,
        H = 180,
    },
    CIRCLE = {
        X = 59,
        Y = 51,
        W = 100,
        H = 100,
    },
    TEXT = {
        X = 195,
        Y = 60,
        W = 385,
        H = 39,
    },
    BAR = {
        X = 20,
        Y = 29,
        W = 600,
        H = 7,
    }
}

local decide = {
    sceneTime = 1,
    functions = {}
}

decide.functions.load = function(sceneTime)
    local skin = {
        source = {
            {id = 2, path="../decide2/parts/simple/frame.png"},
            {id = 3, path="../decide2/parts/simple/circle.png"},
            {id = 4, path="../decide2/parts/simple/text.png"},
        },
        image = {
            {id = "frame", src = 2, x = 0, y = 0, w = -1, h = -1},
            {id = "loadingCircle", src = 3, x = 0, y = 0, w = -1, h = -1},
            {id = "loadingText", src = 4, x = 0, y = 0, w = -1, h = -1},
        }
    }
    decide.sceneTime = sceneTime
    return skin
end

decide.functions.dst = function()
    local skin = {
        destination = {
            {id = "frame", dst = {
                {x = DECIDE.FRAME.X, y = DECIDE.FRAME.Y, w = DECIDE.FRAME.W, h = DECIDE.FRAME.H}
            }},
            {id = "loadingCircle", loop = 0, dst = {
                {time = 0, x = DECIDE.CIRCLE.X, y = DECIDE.CIRCLE.Y, w = DECIDE.CIRCLE.W, h = DECIDE.CIRCLE.H, angle = 0},
                {time = 750, angle = -360},
            }},
            {id = "loadingText", dst = {
                {x = DECIDE.TEXT.X, y = DECIDE.TEXT.Y, w = DECIDE.TEXT.W, h = DECIDE.TEXT.H}
            }},
            -- loadingグラフの背景
            {id = "white", dst = {
                {x = DECIDE.BAR.X, y = DECIDE.BAR.Y, w = DECIDE.BAR.W, h = DECIDE.BAR.H, a = 64},
            }}
        }
    }

    local dst = skin.destination
    do
        local timeTable = timeTableLoader.getLoadingTimeTable(decide.sceneTime)
        local dstTable = {
            {time = 0, x = DECIDE.BAR.X, y = DECIDE.BAR.Y, w = 0, h = DECIDE.BAR.H},
        }
        for i = 1, #timeTable do
            local time = timeTable[i].time
            local w = timeTable[i].val * DECIDE.BAR.W / 100
            print(time, w)
            dstTable[#dstTable+1] = {
                time = time, w = w
            }
        end
        dst[#dst+1] = {
            id = "white", loop = timeTable[#timeTable].time, dst = dstTable
        }
    end
    return skin
end

return decide.functions