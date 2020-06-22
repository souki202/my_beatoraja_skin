local luajava = require("luajava")

local gdx = luajava.bindClass("com.badlogic.gdx.Gdx")
local input = luajava.bindClass("com.badlogic.gdx.Input")

function keyInput()
    -- print(gdx.input:getX())
end

function isKeyPressed(keyCode)
    return gdx.input:isKeyPressed(keyCode)
end

function isPressedEnter(keyCode)
    return gdx.input:isKeyPressed(input.Keys.Enter)
end

function getInput()
    return input
end

function isLeftClicking()
    return gdx.input:isButtonPressed(input.Buttons.LEFT)
end

function getDeltaY()
    return gdx.input:getDeltaY()
end

function getMousePos()
    return gdx.input:getX(), gdx.input:getY()
end