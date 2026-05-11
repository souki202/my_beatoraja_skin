require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local bomb = {
    functions = {}
}

local BOMB = {
    ANIM1 = {
        W = 300,
        H = 300,
        DIV_X = 1,
        DIV_Y = 1,
        TIME = 300,
        LN_TIME = 300,
        OFFSET_X = 0,
        OFFSET_Y = 0,
        IMG_H = 0,
        IS_SPECIAL_LN = false,
    },
    ANIM2 = {
        W = 300,
        H = 300,
        DIV_X = 1,
        DIV_Y = 1,
        TIME = 300,
        LN_TIME = 300,
        OFFSET_X = 0,
        OFFSET_Y = 0,
        IMG_H = 0,
        IS_SPECIAL_LN = false,
    },
    SOCIAL_SKIN_PRESET = {
        W = 250,
        H = 250,
        DIV_X = 30,
        DIV_Y = 1,
        TIME = 500,
        LN_TIME = 1000,
        OFFSET_X = 0,
        OFFSET_Y = 0,
        IMG_H = 1200,
        IS_SPECIAL_LN = true,
    },
    OADX_PRESET = {
        W = 384,
        H = 384,
        DIV_X = 16,
        DIV_Y = 1,
        TIME = 350,
        LN_TIME = 350,
        OFFSET_X = 25,
        OFFSET_Y = -30,
        IMG_H = 768,
        IS_SPECIAL_LN = true,
    },
    PRESETS = {
        NONE = 1,
        SOCIAL_SKIN = 2,
        OADX03 = 3,
    },
}

bomb.functions.load = function ()
    -- 大きさを初期化
    local m = 0
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
    m = getOffsetValueWithDefault("ボムのanimation1の描画座標差分", {x = 0, y = 0})
    BOMB.ANIM1.OFFSET_X = m.x
    BOMB.ANIM1.OFFSET_Y = m.y
    m = getOffsetValueWithDefault("ボムのanimation2の描画座標差分", {x = 0, y = 0})
    BOMB.ANIM2.OFFSET_X = m.x
    BOMB.ANIM2.OFFSET_Y = m.y
    m = getOffsetValueWithDefault("ボムのanimation1の描画時間(単位100ms 既定値3)", {x = 3})
    BOMB.ANIM1.TIME = m.x * 100
    m = getOffsetValueWithDefault("ボムのanimation2の描画時間(単位100ms 既定値3)", {x = 3})
    BOMB.ANIM2.TIME = m.x * 100

    -- プリセット適用
    if getBombAnimation1Preset() == BOMB.PRESETS.SOCIAL_SKIN then
        BOMB.ANIM1 = BOMB.SOCIAL_SKIN_PRESET
    elseif getBombAnimation1Preset() == BOMB.PRESETS.OADX03 then
        BOMB.ANIM1 = BOMB.OADX_PRESET
    end
    if getBombAnimation2Preset() == BOMB.PRESETS.SOCIAL_SKIN then
        BOMB.ANIM2 = BOMB.SOCIAL_SKIN_PRESET
    elseif getBombAnimation2Preset() == BOMB.PRESETS.OADX03 then
        BOMB.ANIM2 = BOMB.OADX_PRESET
    end

    local skin = {
        image = {}
    }

    -- アニメーション
    local imgs = skin.image
    local bombTimer = {51, 52, 53, 54, 55, 56, 57, 50}
    local lnBombTimer = {71, 72, 73, 74, 75, 76, 77, 70}
    for i = 1, #bombTimer do
        for j = 1, 2, 1 do -- ANIM1と2
            local anim = BOMB["ANIM" .. j]
            local src = j == 1 and 13 or 16

            if anim.IS_SPECIAL_LN then
                local h = anim.IMG_H / 4 * 1
                -- 非LN
                imgs[#imgs+1] = {
                    id = "bombAnimation" .. j .. bombTimer[i], src = src, x = 0, y = 0, w = -1, h = h, divx = anim.DIV_X, divy = anim.DIV_Y, cycle = anim.TIME, timer = bombTimer[i]
                }
                -- LN
                if lnBombTimer[i] % 2 == 1 then
                    -- 白鍵
                    imgs[#imgs+1] = {
                        id = "bombAnimation" .. j .. lnBombTimer[i], src = src, x = 0, y = h * 1, w = -1, h = h, divx = anim.DIV_X, divy = anim.DIV_Y, cycle = anim.LN_TIME, timer = lnBombTimer[i]
                    }
                elseif lnBombTimer[i] % 2 == 0 and lnBombTimer[i] ~= 70 then
                    -- 青鍵
                    imgs[#imgs+1] = {
                        id = "bombAnimation" .. j .. lnBombTimer[i], src = src, x = 0, y = h * 2, w = -1, h = h, divx = anim.DIV_X, divy = anim.DIV_Y, cycle = anim.LN_TIME, timer = lnBombTimer[i]
                    }
                else
                    -- 皿
                    imgs[#imgs+1] = {
                        id = "bombAnimation" .. j .. lnBombTimer[i], src = src, x = 0, y = h * 3, w = -1, h = h, divx = anim.DIV_X, divy = anim.DIV_Y, cycle = anim.LN_TIME, timer = lnBombTimer[i]
                    }
                end
            else
                -- 通常
                imgs[#imgs+1] = {
                    id = "bombAnimation" .. j .. bombTimer[i], src = src, x = 0, y = 0, w = -1, h = -1, divx = anim.DIV_X, divy = anim.DIV_Y, cycle = anim.TIME, timer = bombTimer[i]
                }
                imgs[#imgs+1] = {
                    id = "bombAnimation" .. j .. lnBombTimer[i], src = src, x = 0, y = 0, w = -1, h = -1, divx = anim.DIV_X, divy = anim.DIV_Y, cycle = anim.LN_TIME, timer = lnBombTimer[i]
                }
            end
        end
    end


    return skin
end

bomb.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    -- ピクッとするので先に出力
    do
        local ids = {"Animation1", "Animation2"}
        local ids2 = {"51", "51"}
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
        -- bomb
        dst[#dst+1] = {
            id = "bombAnimation1" .. timer[i], offsets = {3}, timer = timer[i], loop = -1, blend = animBlend, filter = 1, dst = {
                {time = 0, x = cx - BOMB.ANIM1.W / 2 + BOMB.ANIM1.OFFSET_X, y = y - BOMB.ANIM1.H / 2 + BOMB.ANIM1.OFFSET_Y, w = BOMB.ANIM1.W, h = BOMB.ANIM1.H},
                {time = BOMB.ANIM1.TIME - 1}
            }
        }
        -- bomb
        dst[#dst+1] = {
            id = "bombAnimation1" .. lnTimer[i], offsets = {3}, timer = lnTimer[i], blend = animBlend, filter = 1, dst = {
                {time = 0, x = cx - BOMB.ANIM1.W / 2 + BOMB.ANIM1.OFFSET_X, y = y - BOMB.ANIM1.H / 2 + BOMB.ANIM1.OFFSET_Y, w = BOMB.ANIM1.W, h = BOMB.ANIM1.H},
                {time = BOMB.ANIM1.TIME * 2 / 3- 1}
            }
        }

        -- bomb
        dst[#dst+1] = {
            id = "bombAnimation2" .. timer[i], offsets = {3}, timer = timer[i], loop = -1, blend = animBlend, filter = 1, dst = {
                {time = 0, x = cx - BOMB.ANIM2.W / 2 + BOMB.ANIM2.OFFSET_X, y = y - BOMB.ANIM2.H / 2 + BOMB.ANIM2.OFFSET_Y, w = BOMB.ANIM2.W, h = BOMB.ANIM2.H},
                {time = BOMB.ANIM2.TIME - 1}
            }
        }
        dst[#dst+1] = {
            id = "bombAnimation2" .. lnTimer[i], offsets = {3}, timer = lnTimer[i], blend = animBlend, filter = 1, dst = {
                {time = 0, x = cx - BOMB.ANIM2.W / 2 + BOMB.ANIM2.OFFSET_X, y = y - BOMB.ANIM2.H / 2 + BOMB.ANIM2.OFFSET_Y, w = BOMB.ANIM2.W, h = BOMB.ANIM2.H},
                {time = BOMB.ANIM2.TIME * 2 / 3 - 1}
            }
        }
    end

    return skin
end

return bomb.functions
