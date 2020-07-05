local luajava = require("luajava")

local gdx = luajava.bindClass("com.badlogic.gdx.Gdx")
local input = luajava.bindClass("com.badlogic.gdx.Input")

function isKeyPressed(keyCode)
    return gdx.input:isKeyPressed(keyCode)
end

function isPressedEnter()
    return gdx.input:isKeyPressed(input.Keys.Enter)
end

function getInput()
    return input
end

function isLeftClicking()
    return gdx.input:isButtonPressed(input.Buttons.LEFT)
end

function isRightClicking()
    return gdx.input:isButtonPressed(input.Buttons.RIGHT)
end

function getDeltaY()
    return gdx.input:getDeltaY()
end

function getDeltaX()
    return gdx.input:getDeltaX()
end

function getMousePos()
    return gdx.input:getX(), gdx.input:getY()
end