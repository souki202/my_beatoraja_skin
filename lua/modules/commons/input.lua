local luajava = require("luajava")

local Gdx = luajava.bindClass("com.badlogic.gdx.Gdx")
local Input = luajava.bindClass("com.badlogic.gdx.Input")

function isKeyPressed(keyCode)
    return Gdx.input:isKeyPressed(keyCode)
end

function isPressedEnter()
    return Gdx.input:isKeyPressed(Input.Keys.Enter)
end

function getInput()
    return Input
end

function isLeftClicking()
    return Gdx.input:isButtonPressed(Input.Buttons.LEFT)
end

function isRightClicking()
    return Gdx.input:isButtonPressed(Input.Buttons.RIGHT)
end

function isPressedUp()
    return Gdx.input:isKeyJustPressed(Input.Keys.UP)
end

function isPressedDown()
    return Gdx.input:isKeyJustPressed(Input.Keys.DOWN)
end

function getDeltaY()
    return Gdx.input:getDeltaY()
end

function getDeltaX()
    return Gdx.input:getDeltaX()
end

function getMousePos()
    return Gdx.input:getX(), Gdx.input:getY()
end