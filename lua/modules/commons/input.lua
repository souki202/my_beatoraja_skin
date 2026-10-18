local main_state = require("main_state")
local compat = require("modules.commons.compat")
local Gdx = compat.javaClass("com.badlogic.gdx.Gdx")

KEY_CODE = {UP = 19, DOWN = 20, LEFT = 21, RIGHT = 22, ENTER = 66}
CLICK_ARG = {LEFT = 1, RIGHT = -1}
local keyStates = {}

local function inputObject()
    local ok, input = pcall(function () return Gdx.input end)
    return ok and input or nil
end

local function callInput(method, arg)
    local input = inputObject()
    if not compat.hasMethod(input, method) then return nil end
    local ok, value = pcall(function ()
        if arg == nil then return input[method](input) end
        return input[method](input, arg)
    end)
    if ok then return value end
end

function getInput()
    return compat.javaClass("com.badlogic.gdx.Input") or {Keys = KEY_CODE, Buttons = {LEFT = 0, RIGHT = 1}}
end

function isKeyPressed(keyCode)
    if main_state.key_pressed then
        return main_state.key_pressed(keyCode) == true
    end
    return callInput("isKeyPressed", keyCode) == true
end

local function isKeyJustPressed(keyCode)
    local pressed = callInput("isKeyJustPressed", keyCode)
    if pressed ~= nil then return pressed == true end
    local now = main_state.time()
    local state = keyStates[keyCode]
    if state == nil then
        state = {time = nil, now = false, prev = false}
        keyStates[keyCode] = state
    end
    if state.time ~= now then
        state.time = now
        state.prev = state.now
        state.now = isKeyPressed(keyCode)
    end
    return state.now and not state.prev
end

function isPressedEnter() return isKeyPressed(KEY_CODE.ENTER) end
function isPressedUp() return isKeyJustPressed(KEY_CODE.UP) end
function isPressedDown() return isKeyJustPressed(KEY_CODE.DOWN) end
function isPressedLeft() return isKeyJustPressed(KEY_CODE.LEFT) end
function isPressedRight() return isKeyJustPressed(KEY_CODE.RIGHT) end
function isLeftClicking() return callInput("isButtonPressed", 0) == true end
function isRightClicking() return callInput("isButtonPressed", 1) == true end
function isRightClickArg(arg) return arg ~= nil and tonumber(arg) == CLICK_ARG.RIGHT end

function hasMouseInput()
    local input = inputObject()
    return compat.hasMethod(input, "isButtonPressed") and
        compat.hasMethod(input, "getX") and compat.hasMethod(input, "getY")
end

local function mouseScale()
    local ok, w, h = pcall(function () return Gdx.graphics:getWidth(), Gdx.graphics:getHeight() end)
    if ok and w > 0 and h > 0 then
        return (WIDTH or 1920) / w, (HEIGHT or 1080) / h
    end
    return 1, 1
end

function getMousePos()
    local sx, sy = mouseScale()
    return (callInput("getX") or 0) * sx, (callInput("getY") or 0) * sy
end

function getDeltaX()
    local sx = mouseScale()
    return (callInput("getDeltaX") or 0) * sx
end

function getDeltaY()
    local _, sy = mouseScale()
    return (callInput("getDeltaY") or 0) * sy
end
