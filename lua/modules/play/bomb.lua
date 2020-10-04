require("modules.commons.define")
require("modules.commons.easing")
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
        FLOW_H = 100,
        SPREAD_X = 100,
        SPREAD_Y = 100,
        APPEAR_RANGE_X = 30,
        APPEAR_RANGE_Y = 30,
        TIMER_DIV = 50,
    },
    P2 = {
        W = 16,
        H = 16,
        N = 7,
        TIME = 300,
        TYPE = 0,
        FLOW_H = 100,
        SPREAD_X = 100,
        SPREAD_Y = 100,
        APPEAR_RANGE_X = 30,
        APPEAR_RANGE_Y = 30,
        TIMER_DIV = 5,
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
    m = getOffsetValueWithDefault("ボムのwave1の大きさ倍率(単位%)", {w = 0, h = 0})
    BOMB.WAVE1.W = BOMB.WAVE1.W * (100 + m.w) / 100
    BOMB.WAVE1.H = BOMB.WAVE1.H * (100 + m.h) / 100
    m = getOffsetValueWithDefault("ボムのwave2の大きさ倍率(単位%)", {w = 0, h = 0})
    BOMB.WAVE2.W = BOMB.WAVE2.W * (100 + m.w) / 100
    BOMB.WAVE2.H = BOMB.WAVE2.H * (100 + m.h) / 100
    m = getOffsetValueWithDefault("ボムのparticle1の大きさ倍率(単位%)", {w = 0, h = 0})
    BOMB.P1.W = BOMB.P1.W * (100 + m.w) / 100
    BOMB.P1.H = BOMB.P1.H * (100 + m.h) / 100
    m = getOffsetValueWithDefault("ボムのparticle2の大きさ倍率(単位%)", {w = 0, h = 0})
    BOMB.P2.W = BOMB.P2.W * (100 + m.w) / 100
    BOMB.P2.H = BOMB.P2.H * (100 + m.h) / 100
    m = getOffsetValueWithDefault("ボムのanimation1の大きさ倍率(単位%)", {w = 0, h = 0})
    BOMB.ANIM1.W = BOMB.ANIM1.W * (100 + m.w) / 100
    BOMB.ANIM1.H = BOMB.ANIM1.H * (100 + m.h) / 100
    m = getOffsetValueWithDefault("ボムのanimation2の大きさ倍率(単位%)", {w = 0, h = 0})
    BOMB.ANIM2.W = BOMB.ANIM2.W * (100 + m.w) / 100
    BOMB.ANIM2.H = BOMB.ANIM2.H * (100 + m.h) / 100
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
    m = getOffsetValueWithDefault("ボムのparticle1のフローの高さ倍率差分(単位%)", {h = 0})
    BOMB.P1.FLOW_H = math.floor(BOMB.P1.FLOW_H * (100 + m.h) / 100)
    m = getOffsetValueWithDefault("ボムのparticle2のフローの高さ倍率差分(単位%)", {h = 0})
    BOMB.P2.FLOW_H = math.floor(BOMB.P2.FLOW_H * (100 + m.h) / 100)
    m = getOffsetValueWithDefault("ボムのparticle1の拡散の広さ倍率差分(単位%)", {w = 0, h = 0})
    BOMB.P1.SPREAD_X = math.floor(BOMB.P1.SPREAD_X * (100 + m.w) / 100)
    BOMB.P1.SPREAD_Y = math.floor(BOMB.P1.SPREAD_Y * (100 + m.h) / 100)
    m = getOffsetValueWithDefault("ボムのparticle2の拡散の広さ倍率差分(単位%)", {w = 0, h = 0})
    BOMB.P2.SPREAD_X = math.floor(BOMB.P2.SPREAD_X * (100 + m.w) / 100)
    BOMB.P2.SPREAD_Y = math.floor(BOMB.P2.SPREAD_Y * (100 + m.h) / 100)
    m = getOffsetValueWithDefault("ボムのparticle1の出現範囲倍率差分(単位%)", {w = 0, h = 0})
    BOMB.P1.APPEAR_RANGE_X = math.floor(BOMB.P1.APPEAR_RANGE_X * (100 + m.w) / 100)
    BOMB.P1.APPEAR_RANGE_Y = math.floor(BOMB.P1.APPEAR_RANGE_Y * (100 + m.h) / 100)
    m = getOffsetValueWithDefault("ボムのparticle2の出現範囲倍率差分(単位%)", {w = 0, h = 0})
    BOMB.P2.APPEAR_RANGE_X = math.floor(BOMB.P2.APPEAR_RANGE_X * (100 + m.w) / 100)
    BOMB.P2.APPEAR_RANGE_Y = math.floor(BOMB.P2.APPEAR_RANGE_Y * (100 + m.h) / 100)

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
    @param  array particle BOMB.P1 or BOMB.P2
    @param  int   alphaEaseType アルファ変化のイージング種類 1:ease in 2:linear 3:ease out
    @param  int   moveEaseType  アルファ変化のイージング種類 1:ease in 2:linear 3:ease out
    @param  int   sx xの開始座標
    @param  int   sy yの開始座標
    @param  int   tx xの終了座標
    @param  int   ty yの終了座標
    @return array mergeSkinする
]]
bomb.functions.createParticleTimers = function (particle, n, alphaEaseType, moveEaseType, timer, loop, endTime, sx, sy, tx, ty)
    local skin = {destination = {}}
    local dst = skin.destination
    local timerDiv = particle.TIMER_DIV

    local alphaEaseFunc = nil
    if alphaEaseType == 1 then
        alphaEaseFunc = easing.easeIn
    elseif alphaEaseType == 2 then
        alphaEaseFunc = easing.linear
    elseif alphaEaseType == 3 then
        alphaEaseFunc = easing.easeOut
    end
    local moveEaseFunc = nil
    if moveEaseType == 1 then
        moveEaseFunc = easing.easeIn
    elseif moveEaseType == 2 then
        moveEaseFunc = easing.linear
    elseif moveEaseType == 3 then
        moveEaseFunc = easing.easeOut
    end

    local dt = endTime / timerDiv
    local dstTime = {
        {time = 0, x = sx, y = sy, w = particle.W, h = particle.H, a = 255},
    }

    for i = 1, timerDiv do
        local nowTime = i * dt
        local nowAlpha = alphaEaseFunc(nowTime, 255, 0, endTime)
        local nowX = moveEaseFunc(nowTime, sx, tx, endTime)
        local nowY = moveEaseFunc(nowTime, sy, ty, endTime)
        dstTime[#dstTime+1] = {
            time = nowTime, x = nowX, y = nowY, a = nowAlpha
        }
    end
    dst[#dst+1] = {
        id = "bombParticle" .. n, offset = 3, timer = timer, loop = loop, dst = dstTime
    }
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
    if not isDrawBombParticle() then return end
    local dst = skin.destination
    local particle = number == 1 and BOMB.P1 or BOMB.P2
    local alphaEaseType = number == 1 and getBombParticle1AlphaEasingType() or getBombParticle2AlphaEasingType()
    local moveEaseType = number == 1 and getBombParticle1MoveEasingType() or getBombParticle2MoveEasingType()
    local flowH = particle.FLOW_H
    local spreadX, spreadY = particle.SPREAD_X, particle.SPREAD_Y
    local appearRangeX, appearRangeY = particle.APPEAR_RANGE_X, particle.APPEAR_RANGE_Y
    local loop = isLn and 0 or -1
    cx = cx - particle.W / 2
    y = y - particle.H / 2
    for j = 1, BOMB.P1.N do
        if particle.TYPE == 0 then
            local sx = cx + math.random(-appearRangeX, appearRangeX)
            local sy = y + math.random(-appearRangeY, appearRangeY)
            local vy = math.random(math.floor(flowH / (-10)), flowH)
            local t = particle.TIME + math.random(-50, 50)
            mergeSkin(skin, bomb.functions.createParticleTimers(particle, number, alphaEaseType, moveEaseType, timer, loop, t, sx, sy, sx, sy + vy))
            -- flow
            -- dst[#dst+1] = {
            --     id = "bombParticle" .. number, offset = 3, timer = timer, loop = loop, dst = {
            --         {time = 0, x = sx, y = sy, w = particle.W, h = particle.H, a = 255, acc = 2},
            --         {time = t, y = sy + vy, a = 0}
            --     }
            -- }
        elseif particle.TYPE == 1 then
            -- 拡散
            local r = math.random(0, 360) / 180 * math.pi
            local vx = math.random(spreadX / 10, spreadX)
            local vy = math.random(spreadY / 10, spreadY)
            local t = particle.TIME + math.random(-50, 50)
            local tx, ty = cx + math.cos(r) * vx, y + math.sin(r) * vy
            mergeSkin(skin, bomb.functions.createParticleTimers(particle, number, alphaEaseType, moveEaseType, timer, loop, t, cx, y, tx, ty))
            -- dst[#dst+1] = {
            --     id = "bombParticle" .. number, offset = 3, timer = timer, loop = loop, dst = {
            --         {time = 0, x = cx, y = y, w = particle.W, h = particle.H, a = 255, acc = 2},
            --         {time = t, x = tx, y = ty, a = 0}
            --     }
            -- }
        elseif particle.TYPE == 2 then
            -- static
            local sx = cx + math.random(-appearRangeX, appearRangeX)
            local sy = y + math.random(-appearRangeY, appearRangeY)
            local t = particle.TIME + math.random(-50, 50)
            mergeSkin(skin, bomb.functions.createParticleTimers(particle, number, alphaEaseType, moveEaseType, timer, loop, t, sx, sy, sx, sy))
            -- dst[#dst+1] = {
            --     id = "bombParticle" .. number, offset = 3, timer = timer, loop = loop, dst = {
            --         {time = 0, x = sx, y = sy, w = particle.W, h = particle.H, a = 255, acc = 2},
            --         {time = t, a = 0}
            --     }
            -- }
        end
    end
end

bomb.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    -- ピクッとするとので先に出力
    do
        local ids = {"Wave", "Particle", "Animation1", "Animation2"}
        local ids2 = {"", "", "51", "51"}
        for key, value in pairs(ids) do
            for i = 1, 2 do
                dst[#dst+1] = {
                    id = "bomb" .. value .. ids2[key], dst = {
                        {x = 0, y = 0, w = 1, h = 1, a = 1}
                    }
                }
            end
        end
    end

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