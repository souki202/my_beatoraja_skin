require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")
require("modules.commons.position")

local finish = {
    functions = {}
}

local FINISH = {
    END = {
        X = function () return lanes.getAreaX() end,
        Y = function () return lanes.getAreaY() end,
        W = function () return lanes.getAreaW() end,
        H = 2000,
        TIME = 1000,
    },
    FC = {
        CIRCLE = {
            SIZE = 602,
            MAX_SIZE = 1600,
        },
        TEXT = {
            FIRST_X = function () return lanes.getAreaX() end,
            DX = {33, 35, 45, 35, 32, 40, 48, 52, 38}, -- 文字の座標差分 左端
            OFFSET_X = {7, 3, 7, 8, 3, 1, 0, 5, 1}, -- 文字毎のずれ
            Y = function () return lanes.getAreaY() + 328 end,
            W = 44,
            H = 49,
            INIT_Z = -100,
            POP_Z = -300,
            POP_TIME = 150,
            END_TIME = 300,
            DELTA_TIME = 50,
            TO_CENTER = 696,
        },
        FIRE = {
            SIZE = 70,
            MOVE_LEN_X_MUL = 2, -- 要は楕円に散らばる
            MOVE_LEN_Y_MUL = 1,
            MOVE_LEN = 150,
            MOVE_LEN_VAR = 100,
            SIZE_VAR = 30,
            ROTATE = 720,
            ROTATE_VAR = 160,
            ANGLE_VAR = 10,
            N = 7,
            ANIMATION_TIME = 500, -- テキストのアニメーション終了から
            DEL_START_TIME = 1000,
            DEL_TIME = 1500,
        },
        RAINBOW = {
            DEL_START_TIME = 300,
            DEL_TIME = 700,
            DELTA_TIME = 30,
            SATURATION = 0.5,
            BRIGHTNESS = 1,
        },
        PARTICLE = {
            N = 32,
            ALPHA_VAR = 192,
            ANIM_TIME = 1500,
            SIZE = 14,
            SIZE_VAR = 8,
        }
    },
    FAILED = {
        TEXT = {
            FIRST_X = function () return lanes.getAreaX() end,
            DX = {114, 30, 44, 20, 35, 36},
            OFFSET_X = {7, 1, 16, 9, 7, 4},
            Y = function () return lanes.getAreaY() + 328 end,
            DELTA_TIME = 50,
            DROP_TIME = 300,
            TUMBLE_START_TIME = 700,
            TUMBLE_TIME = 900,
            TUMBLE_ANGLE = -30,
            W = 44,
            H = 49,
        },
        DIMMER = {
            ALPHA = 196,
            TIME = 300,
        },
    }
}

local FOV = 90

finish.functions.load = function ()
    local skin = {
        image = {
            {id = "finishGrow", src = 0, x = PARTS_TEXTURE_SIZE - 1, y = PARTS_TEXTURE_SIZE - 255, w = 1, h = 255},
            {id = "fcShine", src = 19, x = 0, y = 0, w = -1, h = -1},
            {id = "fcFire1", src = 20, x = 0, y = 0, w = FINISH.FC.FIRE.SIZE, h = FINISH.FC.FIRE.SIZE},
            {id = "fcFire2", src = 20, x = FINISH.FC.FIRE.SIZE*1, y = 0, w = FINISH.FC.FIRE.SIZE, h = FINISH.FC.FIRE.SIZE},
            {id = "fcFire3", src = 20, x = FINISH.FC.FIRE.SIZE*2, y = 0, w = FINISH.FC.FIRE.SIZE, h = FINISH.FC.FIRE.SIZE},
            {id = "fcParticle", src = 21, x = 0, y = 0, w = -1, h = -1}
        }
    }
    local imgs = skin.image

    -- failed文字読み込み
    for i = 1, #FINISH.FAILED.TEXT.DX do
        imgs[#imgs+1] = {
            id = "failedText" .. i, src = 0, x = 705 + FINISH.FAILED.TEXT.W * (i - 1), y = 49, w = FINISH.FAILED.TEXT.W, h = FINISH.FAILED.TEXT.H
        }
    end

    -- フルコン文字読み込み
    for i = 1, #FINISH.FC.TEXT.DX do
        imgs[#imgs+1] = {
            id = "fcText" .. i, src = 0, x = 705 + FINISH.FC.TEXT.W * (i - 1), y = 0, w = FINISH.FC.TEXT.W, h = FINISH.FC.TEXT.H
        }
    end

    return skin
end

finish.functions.dstRainbowLane = function (skin, lane)
    local dst = skin.destination
    local rainbow = FINISH.FC.RAINBOW
    local dHuePerLane = 360 / (commons.keys+1)
    local hue = dHuePerLane * (lane - 1)
    local x = lanes.getLaneX(lane)
    local w = lanes.getLaneW(lane)+1 -- 境界線を埋める
    local r, g, b = hsvToRgb(hue, rainbow.SATURATION, rainbow.BRIGHTNESS)
    local dt = rainbow.DELTA_TIME * (lane - 1)
    if lane > commons.keys / 2 then
        dt = rainbow.DELTA_TIME * (commons.keys - lane)
    end
    -- 皿は255かつ1番目に飛ばす
    if lane == commons.keys + 1 then
        r, g, b = 255, 255, 255
        dt = 0
    end
    dst[#dst+1] = {
        id = "white", timer = 48, loop = -1, filter = 1, dst = {
            {time = 0, x = x, y = lanes.getAreaY(), w = w, h = 0, r = r, g = g, b = b, acc = 2},
            {time = dt},
            {time = dt + rainbow.DEL_START_TIME, h = HEIGHT, r = 255, g = 255, b = 255},
            {time = dt + rainbow.DEL_TIME, a = 0},
        }
    }
end

finish.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    -- 一瞬読み込みで止まる対策
    for i = 1, #FINISH.FC.TEXT.DX do
        dst[#dst+1] = {
            id = "fcText" .. i, timer = 1, loop = -1, dst = {
                {time = 0, x = 0, y = 0, w = 1, h = 1, a = 1},
                {time = 1},
            }
        }
    end

    -- フィニッシュエフェクト
    dst[#dst+1] = {
        id = "finishGrow", timer = 143, offset = 3, loop = -1, dst = {
            {time = 0, x = FINISH.END.X(), y = FINISH.END.Y(), w = FINISH.END.W(), h = 0, a = 255},
            {time = FINISH.END.TIME - 300, h = FINISH.END.H - 600},
            {time = FINISH.END.TIME, h = FINISH.END.H, a = 0}
        }
    }

    -- failedエフェクト
    do
        -- でぃまー
        -- dst[#dst+1] = {
        --     id = "black", timer = 3, loop = FINISH.FAILED.DIMMER.TIME, dst = {
        --         {time = 0, x = lanes.getAreaX(), y = lanes.getAreaY(), w = lanes.getAreaW(), h = lanes.getLaneHeight(), a = 0},
        --         {time = FINISH.FAILED.DIMMER.TIME, a = FINISH.FAILED.DIMMER.ALPHA}
        --     }
        -- }
        dst[#dst+1] = {
            id = "black", timer = 3, loop = FINISH.FAILED.DIMMER.TIME, dst = {
                {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 0},
                {time = FINISH.FAILED.DIMMER.TIME, a = FINISH.FAILED.DIMMER.ALPHA}
            }
        }

        local text = FINISH.FAILED.TEXT
        local lastX = text.FIRST_X()
        for i = 1, #text.DX do
            -- 中央移動
            local x = lastX + text.DX[i] - text.OFFSET_X[i]
            lastX = x + text.OFFSET_X[i]
            local dt = text.DELTA_TIME * (i - 1)
            if i ~= #text.DX then
                dst[#dst+1] = {
                    id = "failedText" .. i, timer = 3, loop = text.DROP_TIME + dt, dst = {
                        {time = 0, x = x, y = HEIGHT, w = text.W, h = text.H},
                        {time = dt},
                        {time = dt + text.DROP_TIME, y = text.Y()},
                    }
                }
            else -- 最後の文字だけこかす
                dst[#dst+1] = {
                    id = "failedText" .. i, timer = 3, loop = text.TUMBLE_TIME + dt, center = 1, dst = {
                        {time = 0, x = x, y = HEIGHT, w = text.W, h = text.H},
                        {time = dt},
                        {time = dt + text.DROP_TIME, y = text.Y()},
                        {time = dt + text.TUMBLE_START_TIME},
                        {time = dt + text.TUMBLE_TIME, angle = text.TUMBLE_ANGLE},
                    }
                }
            end
        end
    end

    -- フルコンエフェクト
    do
        -- 虹
        do
            for i = 1, math.ceil(commons.keys / 2) do
                finish.functions.dstRainbowLane(skin, i)

                if i ~= math.ceil(commons.keys / 2) then
                    finish.functions.dstRainbowLane(skin, commons.keys - i + 1)
                end
            end
            -- 皿
            finish.functions.dstRainbowLane(skin, commons.keys + 1)
        end
        local text = FINISH.FC.TEXT
        local fire = FINISH.FC.FIRE
        local textY = text.Y()
        local cx = (FINISH.FC.TEXT.FIRST_X() * 2 + table.sum(text.DX)) / 2
        local cy = textY + text.H / 2
        local textAnimEnd = text.END_TIME + text.DELTA_TIME * (#text.DX - 1)
        do
            local dAnglePerFire = 360 / fire.N
            local nowAngle = 0
            -- ★を散らせる
            for i = 1, FINISH.FC.FIRE.N do
                nowAngle = nowAngle + dAnglePerFire + fire.ANGLE_VAR
                local v = fire.MOVE_LEN + math.random(0, fire.MOVE_LEN_VAR)
                local tx = cx + v * math.cos(nowAngle) * fire.MOVE_LEN_X_MUL
                local ty = cy + v * math.sin(nowAngle) * fire.MOVE_LEN_Y_MUL
                local size = fire.SIZE + math.random(-fire.SIZE_VAR, fire.SIZE_VAR) / 2
                local rotate = (fire.ROTATE + math.random(-fire.ROTATE_VAR, fire.ROTATE_VAR) / 2) * (math.random(0, 1) - 0.5) * 2
                local fireColor = math.random(1, 3)
                dst[#dst+1] = {
                    id = "fcFire" .. fireColor, timer = 48, loop = -1, dst = {
                        {time = 0, x = cx, y = cy, w = 0, h = 0, filter = 1, angle = 0, acc = 2},
                        {time = textAnimEnd},
                        {time = textAnimEnd + fire.ANIMATION_TIME, x = tx - size / 2, y = ty - size / 2, w = size, h = size, angle = rotate},
                        {time = textAnimEnd + fire.DEL_START_TIME, a = 255},
                        {time = textAnimEnd + fire.DEL_TIME, a = 0},
                    }
                }
            end
        end
        -- 中央移動->perspective projection->レーンに移動
        local ty = text.Y() + text.H
        local toCenter = text.TO_CENTER * (is1P() and 1 or -1)
        local lastX = text.FIRST_X() + toCenter
        for i = 1, #text.DX do
            -- 中央移動
            local lx = lastX + text.DX[i] - text.OFFSET_X[i]
            local rx = lx + text.W
            lastX = lx + text.OFFSET_X[i]
            -- perspective projection
            -- 最初の座標
            -- 左下
            local ilx, iy = perspectiveProjection(lx, textY, text.INIT_Z, FOV)
            -- 右上
            local irx, ity = perspectiveProjection(rx, ty, text.INIT_Z, FOV)
            -- ポップ時点での座標
            local plx, py = perspectiveProjection(lx, textY, text.POP_Z, FOV)
            local prx, pty = perspectiveProjection(rx, ty, text.POP_Z, FOV)

            local popTime = text.POP_TIME + text.DELTA_TIME * (i - 1)
            local endTime = text.END_TIME + text.DELTA_TIME * (i - 1)
            -- 終了時点の座標は最初の設定した値
            dst[#dst+1] = {
                id = "fcText" .. i, timer = 48, loop = -1, dst = {
                    {time = 0, x = ilx - toCenter, y = iy, w = irx - ilx, h = ity - iy, acc = 2},
                    {time = popTime, x = plx - toCenter, y = py, w = prx - plx, h = pty - py},
                }
            }
            -- ポップから並ぶまで
            dst[#dst+1] = {
                id = "fcText" .. i, timer = 48, loop = endTime, dst = {
                    {time = 0, x = plx - toCenter, y = py, w = prx - plx, h = pty - py, a = 0, acc = 1},
                    {time = popTime, a = 0},
                    {time = popTime + 1, a = 255},
                    {time = endTime, x = lx - toCenter, y = textY, w = text.W, h = text.H}
                }
            }
        end
        -- パーティクル
        do
            local p = FINISH.FC.PARTICLE
            for i = 1, p.N do
                local size = p.SIZE + math.random(-p.SIZE_VAR, p.SIZE_VAR) / 2
                local x = lanes.getAreaX() + math.random(0, lanes.getAreaW()) - size / 2
                local y = lanes.getAreaY() + math.random(0, lanes.getLaneHeight()) - size / 2
                local st = math.random(0, p.ANIM_TIME)
                local alpha = 255 - math.random(0, p.ALPHA_VAR)
                dst[#dst+1] = {
                    id = "fcParticle", timer = 48, loop = st, dst = {
                        {time = 0, x = x, y = y, w = size, h = size, a = 0},
                        {time = st},
                        {time = st + p.ANIM_TIME / 2, a = alpha},
                        {time = st + p.ANIM_TIME, a = 0},
                    }
                }
            end
        end
    end

    return skin
end

return finish.functions