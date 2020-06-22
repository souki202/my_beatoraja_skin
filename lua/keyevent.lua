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

function hogehoge()
    print(luajava.bindClass("java.sql.Connection"))
end