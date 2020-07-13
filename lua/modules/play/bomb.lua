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
        TIME = 300,
    },
    WAVE2 = {
        W = 500,
        H = 500,
        TIME = 300,
    },
    P1 = {
        W = 16,
        H = 16,
        N = 7,
        TIME = 300,
        TYPE = 0,
    },
    P2 = {
        W = 16,
        H = 16,
        N = 7,
        TIME = 300,
        TYPE = 0,
    },
    ANIM1 = {
        W = 300,
        H = 300,
        DIV_X = 1,
        DIV_Y = 1,
        TIME = 300,
    },
    ANIM2 = {
        W = 300,
        H = 300,
        DIV_X = 1,
        DIV_Y = 1,
        TIME = 300,
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
    m = getOffsetValueWithDefault("ボムのparticle1の描画数(既定値7)", {x = 7})
    BOMB.P1.N = m.x
    m = getOffsetValueWithDefault("ボムのparticle2の描画数(既定値7)", {x = 7})
    BOMB.P2.N = m.x
    m = getOffsetValueWithDefault("ボムのwave1の描画時間(単位100ms 既定値3)", {x = 3})
    BOMB.WAVE1.TIME = m.x * 100
    m = getOffsetValueWithDefault("ボムのwave2の描画時間(単位100ms 既定値3)", {x = 3})
    BOMB.WAVE2.TIME = m.x * 100
    m = getOffsetValueWithDefault("ボムのparticle1の描画時間(単位100ms 既定値3)", {x = 3})
    BOMB.P1.TIME = m.x * 100
    m = getOffsetValueWithDefault("ボムのparticle2の描画時間(単位100ms 既定値3)", {x = 3})
    BOMB.P2.TIME = m.x * 100
    m = getOffsetValueWithDefault("ボムのanimation1の描画時間(単位100ms 既定値3)", {x = 3})
    BOMB.ANIM1.TIME = m.x * 100
    m = getOffsetValueWithDefault("ボムのanimation2の描画時間(単位100ms 既定値3)", {x = 3})
    BOMB.ANIM2.TIME = m.x * 100

    BOMB.P1.TYPE = getParticle1AnimationType()
    BOMB.P2.TYPE = getParticle2AnimationType()

    local skin = {
        image = {
            {id = "bombWave1", src = 11, x = 0, y = 0, w = -1, h = -1},
            {id = "bombWave2", src = 14, x = 0, y = 0, w = -1, h = -1},
            {id = "bombParticle1", src = 12, x = 0, y = 0, w = -1, h = -1},
            {id = "bombParticle2", src = 15, x = 0, y = 0, w = -1, h = -1},
        }
    }

    -- アニメーション
    local imgs = skin.image
    local bombTimer = {51, 52, 53, 54, 55, 56, 57, 50}
    local lnBombTimer = {71, 72, 73, 74, 75, 76, 77, 70}
    for i = 1, #bombTimer do
        imgs[#imgs+1] = {
            id = "bombAnimation1" .. bombTimer[i], src = 13, x = 0, y = 0, w = -1, h = -1, divx = BOMB.ANIM1.DIV_X, divy = BOMB.ANIM1.DIV_Y, cycle = BOMB.ANIM1.TIME, timer = bombTimer[i]
        }
        imgs[#imgs+1] = {
            id = "bombAnimation1" .. lnBombTimer[i], src = 13, x = 0, y = 0, w = -1, h = -1, divx = BOMB.ANIM1.DIV_X, divy = BOMB.ANIM1.DIV_Y, cycle = BOMB.ANIM1.TIME * 2 / 3, timer = lnBombTimer[i]
        }
        imgs[#imgs+1] = {
            id = "bombAnimation2" .. bombTimer[i], src = 16, x = 0, y = 0, w = -1, h = -1, divx = BOMB.ANIM2.DIV_X, divy = BOMB.ANIM2.DIV_Y, cycle = BOMB.ANIM2.TIME, timer = bombTimer[i]
        }
        imgs[#imgs+1] = {
            id = "bombAnimation2" .. lnBombTimer[i], src = 16, x = 0, y = 0, w = -1, h = -1, divx = BOMB.ANIM2.DIV_X, divy = BOMB.ANIM2.DIV_Y, cycle = BOMB.ANIM2.TIME * 2 / 3, timer = lnBombTimer[i]
        }
    end


    return skin
end

--[[
    @param  array skin
    @param  int   number particle1かparticle2か
    @param  int   cx 対象レーンの中心座標
    @param  int   y  対象レーンのボム描画の中心y
    @param  int   timer
]]
bomb.functions.addParticle = function (skin, number, cx, y, timer, isLn)
    if isDrawBombParticle() then return end
    local dst = skin.destination
    local particle = number == 1 and BOMB.P1 or BOMB.P2
    local loop = isLn and 0 or -1
    cx = cx - particle.W / 2
    y = y - particle.H / 2
    for j = 1, BOMB.P1.N do
        if particle.TYPE == 0 then
            local sx = cx + math.random(-30, 30)
            local sy = y + math.random(-10, 10)
            local vy = math.random(-10, 100)
            local t = particle.TIME + math.random(-50, 50)
            -- flow
            dst[#dst+1] = {
                id = "bombParticle" .. number, offset = 3, timer = timer, loop = loop, dst = {
                    {time = 0, x = sx, y = sy, w = particle.W, h = particle.H, a = 255, acc = 2},
                    {time = t, y = sy + vy, a = 0}
                }
            }
        elseif particle.TYPE == 1 then
            -- 拡散
            local r = math.random(0, 360) / 180 * math.pi
            local v = math.random(10, 100)
            local t = particle.TIME + math.random(-50, 50)
            local tx, ty = cx + math.cos(r) * v, y + math.sin(r) * v
            dst[#dst+1] = {
                id = "bombParticle" .. number, offset = 3, timer = timer, loop = loop, dst = {
                    {time = 0, x = cx, y = y, w = particle.W, h = particle.H, a = 255, acc = 2},
                    {time = t, x = tx, y = ty, a = 0}
                }
            }
        elseif particle.TYPE == 2 then
            -- static
            local sx = cx + math.random(-30, 30)
            local sy = y + math.random(-30, 30)
            local t = particle.TIME + math.random(-50, 50)
            dst[#dst+1] = {
                id = "bombParticle" .. number, offset = 3, timer = timer, loop = loop, dst = {
                    {time = 0, x = sx, y = sy, w = particle.W, h = particle.H, a = 255, acc = 2},
                    {time = t, a = 0}
                }
            }
        end
    end
end

bomb.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    local animBlend = isTransparentBombAnimationBlackBg() and 2 or 1
    -- timer並べる
    local timer = {}
    local lnTimer = {}
    for i = 1, commons.keys+1 do
        local t, t2 = 50 + i, 70 + i
        if i == commons.keys + 1 then
            t = 50
            t2 = 70
        end
        timer[#timer+1] = t
        lnTimer[#lnTimer+1] = t2
    end

    for i = 1, commons.keys+1 do
        local cx = lanes.getLaneCenterX(i)
        local y = lanes.getAreaY()
        -- WAVE1
        dst[#dst+1] = {
            id = "bombWave1", offset = 3, timer = timer[i], loop = -1, dst = {
                {time = 0, x = cx, y = y, w = 0, h = 0, a = 255, acc = 2},
                {time = BOMB.WAVE1.TIME, x = cx - BOMB.WAVE1.W / 2, y = y - BOMB.WAVE1.H / 2, w = BOMB.WAVE1.W, h = BOMB.WAVE1.H, a = 0}
            }
        }
        dst[#dst+1] = {
            id = "bombWave1", offset = 3, timer = lnTimer[i], dst = {
                {time = 0, x = cx, y = y, w = 0, h = 0, a = 255, acc = 2},
                {time = BOMB.WAVE1.TIME * 2 / 3, x = cx - BOMB.WAVE1.W / 2, y = y - BOMB.WAVE1.H / 2, w = BOMB.WAVE1.W, h = BOMB.WAVE1.H, a = 0}
            }
        }

        -- particle
        bomb.functions.addParticle(skin, 1, cx, y, timer[i])
        bomb.functions.addParticle(skin, 1, cx, y, lnTimer[i], true)
        -- bomb
        dst[#dst+1] = {
            id = "bombAnimation1" .. timer[i], offsets = {3, 40}, timer = timer[i], loop = -1, blend = animBlend, dst = {
                {time = 0, x = cx - BOMB.ANIM1.W / 2, y = y - BOMB.ANIM1.H / 2, w = BOMB.ANIM1.W, h = BOMB.ANIM1.H},
                {time = BOMB.ANIM1.TIME - 1}
            }
        }
        -- bomb
        dst[#dst+1] = {
            id = "bombAnimation1" .. lnTimer[i], offsets = {3, 40}, timer = lnTimer[i], blend = animBlend, dst = {
                {time = 0, x = cx - BOMB.ANIM1.W / 2, y = y - BOMB.ANIM1.H / 2, w = BOMB.ANIM1.W, h = BOMB.ANIM1.H},
                {time = BOMB.ANIM1.TIME * 2 / 3- 1}
            }
        }

        -- WAVE2
        dst[#dst+1] = {
            id = "bombWave2", offset = 3, timer = timer[i], loop = -1, dst = {
                {time = 0, x = cx, y = y, w = 0, h = 0, a = 255, acc = 2},
                {time = BOMB.WAVE2.TIME, x = cx - BOMB.WAVE2.W / 2, y = y - BOMB.WAVE2.H / 2, w = BOMB.WAVE2.W, h = BOMB.WAVE2.H, a = 0}
            }
        }
        dst[#dst+1] = {
            id = "bombWave2", offset = 3, timer = lnTimer[i], dst = {
                {time = 0, x = cx, y = y, w = 0, h = 0, a = 255, acc = 2},
                {time = BOMB.WAVE2.TIME * 2 / 3, x = cx - BOMB.WAVE2.W / 2, y = y - BOMB.WAVE2.H / 2, w = BOMB.WAVE2.W, h = BOMB.WAVE2.H, a = 0}
            }
        }
        -- particle2
        bomb.functions.addParticle(skin, 2, cx, y, timer[i])
        bomb.functions.addParticle(skin, 2, cx, y, lnTimer[i], true)
        -- bomb
        dst[#dst+1] = {
            id = "bombAnimation2" .. timer[i], offsets = {3, 41}, timer = timer[i], loop = -1, blend = animBlend, dst = {
                {time = 0, x = cx - BOMB.ANIM2.W / 2, y = y - BOMB.ANIM2.H / 2, w = BOMB.ANIM2.W, h = BOMB.ANIM2.H},
                {time = BOMB.ANIM2.TIME - 1}
            }
        }
        dst[#dst+1] = {
            id = "bombAnimation2" .. lnTimer[i], offsets = {3, 41}, timer = lnTimer[i], blend = animBlend, dst = {
                {time = 0, x = cx - BOMB.ANIM2.W / 2, y = y - BOMB.ANIM2.H / 2, w = BOMB.ANIM2.W, h = BOMB.ANIM2.H},
                {time = BOMB.ANIM2.TIME * 2 / 3 - 1}
            }
        }
    end

    return skin
end

return bomb.functions