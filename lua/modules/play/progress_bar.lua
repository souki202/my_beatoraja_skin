require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local progress = {
    functions = {}
}

local PROGRESS = {
    X_1 = function () return 0 end,
    X_2 = function () return lanes.getAreaX() + lanes.getAreaNormalY() + 2 end,
    W_1 = function () return lanes.getSideSpace() - 2 end,
    W_2 = function () return lanes.getSideSpace() - 2 end,
    Y = function () return lanes.getAreaNormalY() end,
    H = function () return HEIGHT - lanes.getAreaNormalY() end,
    BAR_H = 2
}

progress.functions.load = function ()
    return {
        judgegraph = {
            {id = "notesGraph", noGap = 1, orderReverse = 0, type = 0, backTexOff = 1},
            {id = "judgesGraph", noGap = 1, orderReverse = 1, type = 1, backTexOff = 1},
            {id = "elGraph", noGap = 1, orderReverse = 1, type = 2, backTexOff = 1},
        },
        bpmgraph = {
            {id = "bpmgraph"}
        },
    }
end

progress.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    if not(drawSideEarlyLateGraph() or drawSideJudgeGraph()) then
        return skin
    end

    local x = is1P() and PROGRESS.X_1() or PROGRESS.X_2() + PROGRESS.W_2()
    local w = is1P() and PROGRESS.W_1() or PROGRESS.W_2()

    local id = "judgesGraph"
    if drawSideEarlyLateGraph() then
        id = "elGraph"
    end
    dst[#dst+1] = {
        id = id, center = 7, dst = {
            {x = x, y = HEIGHT, w = PROGRESS.H(), h = w, angle = -90}
        }
    }
    dst[#dst+1] = {
        id = "bpmgraph", center = 7, dst = {
            {x = x, y = HEIGHT, w = PROGRESS.H(), h = w, angle = -90}
        }
    }
    -- プログレスバー用横線 ズレるので今は表示しない
    -- local musicTime = main_state.number(1163) * 60 + main_state.number(1164)
    -- dst[#dst+1] = {
    --     id = "white", timer = 41, dst = {
    --         {time = 0, x = x, y = HEIGHT - PROGRESS.BAR_H / 2, w = w, h = PROGRESS.BAR_H},
    --         {time = musicTime * 1000, y = HEIGHT - PROGRESS.H() - PROGRESS.BAR_H / 2}
    --     }
    -- }
    do
        local r, g, b = getSimpleLineColor()
        dst[#dst+1] = {
            id = "white", dst = {
                {x = x, y = lanes.getAreaNormalY() - 2, w = w, h = 2, r = r, g = g, b = b}
            }
        }
    end
    return skin
end

return progress.functions