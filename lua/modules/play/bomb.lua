require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local bomb = {
    functions = {}
}

local BOMB = {
    WAVE1 = {
        W = 500,
        H = 500,
    },
    WAVE2 = {
        W = 500,
        H = 500,
    },
    P1 = {
        W = 16,
        H = 16,
        N = 15,
    },
    P2 = {
        W = 16,
        H = 16,
        N = 15,
    },
    ANIM1 = {
        W = 300,
        H = 300,
        DIV_X = 1,
        DIV_Y = 1,
    },
    ANIM2 = {
        W = 300,
        H = 300,
        DIV_X = 1,
        DIV_Y = 1,
    },
}

bomb.functions.load = function ()
    -- 大きさを初期化
    local m = 0
    m = getOffsetValueWithDefault("ボムのwave1の大きさ(単位10% 既定値10)", {w = 10, h = 10})
    BOMB.WAVE1.W = BOMB.WAVE1.W * m.w / 10
    BOMB.WAVE1.H = BOMB.WAVE1.H * m.h / 10
    m = getOffsetValueWithDefault("ボムのwave2の大きさ(単位10% 既定値10)", {w = 10, h = 10})
    BOMB.WAVE2.W = BOMB.WAVE2.W * m.w / 10
    BOMB.WAVE2.H = BOMB.WAVE2.H * m.h / 10
    m = getOffsetValueWithDefault("ボムのparticle1の大きさ(単位10% 既定値10)", {w = 10, h = 10})
    BOMB.P1.W = BOMB.P1.W * m.w / 10
    BOMB.P1.H = BOMB.P1.H * m.h / 10
    m = getOffsetValueWithDefault("ボムのparticle2の大きさ(単位10% 既定値10)", {w = 10, h = 10})
    BOMB.P2.W = BOMB.P2.W * m.w / 10
    BOMB.P2.H = BOMB.P2.H * m.h / 10
    m = getOffsetValueWithDefault("ボムのanimation1の大きさ(単位10% 既定値10)", {w = 10, h = 10})
    BOMB.ANIM1.W = BOMB.ANIM1.W * m.w / 10
    BOMB.ANIM1.H = BOMB.ANIM1.H * m.h / 10
    m = getOffsetValueWithDefault("ボムのanimation2の大きさ(単位10% 既定値10)", {w = 10, h = 10})
    BOMB.ANIM2.W = BOMB.ANIM2.W * m.w / 10
    BOMB.ANIM2.H = BOMB.ANIM2.H * m.h / 10
    m = getOffsetValueWithDefault("ボムのanimation1の画像分割数", {x = 1, y = 1})
    BOMB.ANIM1.DIV_X = m.x
    BOMB.ANIM1.DIV_Y = m.y
    m = getOffsetValueWithDefault("ボムのanimation2の画像分割数", {x = 1, y = 1})
    BOMB.ANIM2.DIV_X = m.x
    BOMB.ANIM2.DIV_Y = m.y
    m = getOffsetValueWithDefault("ボムのparticle1の描画数(既定値15)", {x = 15})
    BOMB.P1.N = m.x
    m = getOffsetValueWithDefault("ボムのparticle2の描画数(既定値15)", {x = 15})
    BOMB.P2.N = m.x

    print(BOMB.P1.W)

    return {
        image = {
            {id = "bombWave1", src = 11, x = 0, y = 0, w = -1, h = -1},
            {id = "bombWave2", src = 14, x = 0, y = 0, w = -1, h = -1},
            {id = "bombParticle1", src = 12, x = 0, y = 0, w = -1, h = -1},
            {id = "bombParticle2", src = 15, x = 0, y = 0, w = -1, h = -1},
        }
    }
end

bomb.functions.dst = function ()
    return {}
end

return bomb.functions