local main_state = require("main_state")

-- beatoraja 0.8.9以降はluajava(Gdx.input)が使えないため, main_state.key_pressedで代替する
-- マウスの状態はLuaから取得できなくなったため, クリック判定はイベントの引数(左:1, 右:-1)を使うこと

-- com.badlogic.gdx.Input.Keys のキーコード
KEY_CODE = {
    UP = 19,
    DOWN = 20,
    LEFT = 21,
    RIGHT = 22,
    ENTER = 66,
}

-- クリックイベントの引数 (SkinObject.mousePressed参照)
CLICK_ARG = {
    LEFT = 1,
    RIGHT = -1,
}

-- 押した瞬間の判定用. 同一フレームで何度呼ばれても同じ結果を返すようにフレーム時刻でキャッシュする
local keyStates = {}

local function isKeyJustPressed(keyCode)
    local now = main_state.time()
    local state = keyStates[keyCode]
    if state == nil then
        state = {time = nil, now = false, prev = false}
        keyStates[keyCode] = state
    end
    if state.time ~= now then
        state.time = now
        state.prev = state.now
        state.now = main_state.key_pressed(keyCode)
    end
    return state.now and not state.prev
end

function isKeyPressed(keyCode)
    return main_state.key_pressed(keyCode)
end

function isPressedEnter()
    return main_state.key_pressed(KEY_CODE.ENTER)
end

-- @param arg クリックイベントの引数
function isRightClickArg(arg)
    return arg ~= nil and tonumber(arg) == CLICK_ARG.RIGHT
end

function isPressedUp()
    return isKeyJustPressed(KEY_CODE.UP)
end

function isPressedDown()
    return isKeyJustPressed(KEY_CODE.DOWN)
end

function isPressedLeft()
    return isKeyJustPressed(KEY_CODE.LEFT)
end

function isPressedRight()
    return isKeyJustPressed(KEY_CODE.RIGHT)
end
