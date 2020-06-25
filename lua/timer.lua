local main_state = require("main_state")

local elapsedTime = 0
local lastTime = 0
local deltaTime = -1
local frame = 0

function updateTime()
    elapsedTime = main_state.time()
    deltaTime = elapsedTime - lastTime
    lastTime = lastTime + deltaTime
    frame = frame + 1
end

function getDeltaTime()
    return deltaTime
end

function getElapsedTime()
    return elapsedTime
end

function getFrame()
    return frame
end

function myPrint(...)
    if DEBUG then
        print(...)
    end
end