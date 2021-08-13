require("modules.commons.define")
require("modules.commons.sound")
local main_state = require("main_state")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")

local keyBeam = {
    functions = {},
    timerValue = {0, 0, 0, 0, 0, 0, 0},
    lastSeTimer = 0,
}

local KEY_BEAM = {
    HEIGHTS = {0, 160, 350, 564, 720},
    BACK_H = {80, 60},
    ANIMATION_TIMES = {0, 50, 100, 200, 350},
    ALPHA = 192, -- 後で初期化

    WHITE_SATURATION = 0.3,
    WHITE_BRIGHTNESS = 1,
    BLUE_SATURATION = 0.6,
    BLUE_BRIGHTNESS = 1,
    HUES = {0, 120, 240, 25, 0, 320},
    TIMER = {101, 102, 103, 104, 105, 106, 107, 100}
}

-- 皿もこれ
local function getWhiteBeamColor()
    local dif = getDifficultyValueForColor()
    if dif == 0 then return hsvToRgb(0, 0, KEY_BEAM.WHITE_BRIGHTNESS) end
	return hsvToRgb(KEY_BEAM.HUES[dif], KEY_BEAM.WHITE_SATURATION, KEY_BEAM.WHITE_BRIGHTNESS)
end

local function getBlueBeamColor()
    local dif = getDifficultyValueForColor()
    if dif == 0 then return hsvToRgb(0, 0, KEY_BEAM.BLUE_BRIGHTNESS) end
	return hsvToRgb(KEY_BEAM.HUES[dif], KEY_BEAM.BLUE_SATURATION, KEY_BEAM.BLUE_BRIGHTNESS)
end

keyBeam.functions.keyBeamStart = function()
    local timer = KEY_BEAM.TIMER

    for i = 1, commons.keys do
        local myTimer = timer[i]
        local value = main_state.timer(myTimer)
        if value > 0 and keyBeam.timerValue[i] < value then
            keyBeam.timerValue[i] = value
            local vol = KEY_BEAM.SE_VOLUME

            if keyBeam.lastSeTimer == value then
                vol = vol / 5
            elseif value - keyBeam.lastSeTimer < 1000 * 5 then -- ナノ秒
                vol = vol / 3
            end
            keyBeam.lastSeTimer = value
            
            Sound.play(KEY_BEAM.KEY_SE, vol, false)
        end
    end
end

keyBeam.functions.load = function ()
    Sound.init()
    KEY_BEAM.KEY_SE = skin_config.get_path("../sounds/key/*.wav")
    KEY_BEAM.SE_VOLUME = getKeySEVolume()
    myPrint(KEY_BEAM.KEY_SE);
    myPrint(KEY_BEAM.SE_VOLUME);
    Sound.play(KEY_BEAM.KEY_SE, 0, false)
    KEY_BEAM.ALPHA = 255 - getKeyBeamTransparency()
    KEY_BEAM.WHITE_BRIGHTNESS = math.max(0, math.min(getKeyBeamWhiteBrightness(), 100)) / 100
    KEY_BEAM.WHITE_SATURATION = math.max(0, math.min(getKeyBeamWhiteSaturation(), 100)) / 100
    KEY_BEAM.BLUE_BRIGHTNESS = math.max(0, math.min(getKeyBeamBlueBrightness(), 100)) / 100
    KEY_BEAM.BLUE_SATURATION = math.max(0,math.min( getKeyBeamBlueSaturation(), 100)) / 100

    return {
        image = {
            {id = "keyBeam", src = 0, x = 18, y = 30, w = 1, h = 80}
        },
        customTimers = {
            {id = CUSTOM_TIMERS.KEYBEAM_START, timer = keyBeam.functions.keyBeamStart},
        }
    }
end

keyBeam.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    local h = KEY_BEAM.HEIGHTS[getKeyFlashHeightIndex()]
    local atime = KEY_BEAM.ANIMATION_TIMES[getKeyFlashAppearAnimationTimeIndex()]
    local dtime = KEY_BEAM.ANIMATION_TIMES[getKeyFlashDelAnimationTimeIndex()] / 2
    local wr, wg, wb = getWhiteBeamColor()
    local br, bg, bb = getBlueBeamColor()
    local timer = KEY_BEAM.TIMER
    for i = 1, commons.keys+1 do
        local r, g, b = wr, wg, wb
        local h2 = h
        local bh = KEY_BEAM.BACK_H[1]
        local by = lanes.getInnerAreaY()
        local myTimer = timer[i]

        if h ~= 0 then -- キービームがあるときだけセット
            if i ~= commons.keys and i % 2 == 0 then
                r, g, b = br, bg, bb
                h2 = h2 * 0.9
                bh = KEY_BEAM.BACK_H[2]
            elseif i == commons.keys then
                h2 = h2 * 1.1
            end

            -- 出現
            local w = lanes.getLaneW(i)
            local y = lanes.getInnerAreaY()
            local x = lanes.getLaneX(i)
            if atime == 0 then
                dst[#dst+1] = {
                    id = "keyBeam", offst = 3, timer = myTimer,
                    dst = {{x = x, y = y, w = w, h = h, r = r, g = g, b = b, a = KEY_BEAM.ALPHA}}
                }
                dst[#dst+1] = {
                    id = "keyBeam", offset = 3, timer = myTimer,
                    dst = {
                        {time = 0, x = x, y = by, w = w, h = -bh, r = r, g = g, b = b, a = KEY_BEAM.ALPHA},
                    }
                }
            else
                if iskeyFlashAppearNormalAnimation() then
                    dst[#dst+1] = {
                        id = "keyBeam", offset = 3, timer = myTimer, loop = atime,
                        dst = {
                            {time = 0, x = x, y = y, w = w, h = 0, r = r, g = g, b = b, a = KEY_BEAM.ALPHA, acc = 2},
                            {time = atime, h = h2}
                        }
                    }
                    if isDrawBackKeyBeam() then
                        dst[#dst+1] = {
                            id = "keyBeam", offset = 3, timer = myTimer, loop = atime,
                            dst = {
                                {time = 0, x = x, y = by, w = w, h = 0, r = r, g = g, b = b, a = KEY_BEAM.ALPHA, acc = 2},
                                {time = atime, h = -bh}
                            }
                        }
                    end
                elseif iskeyFlashAppearFromCenterAnimation() then
                    dst[#dst+1] = {
                        id = "keyBeam", offset = 3, timer = myTimer, loop = atime,
                        dst = {
                            {time = 0, x = x + w / 2, y = y, w = 0, h = h2, r = r, g = g, b = b, a = KEY_BEAM.ALPHA, acc = 2},
                            {time = atime, x = x, w = w}
                        }
                    }
                    if isDrawBackKeyBeam() then
                        dst[#dst+1] = {
                            id = "keyBeam", offset = 3, timer = myTimer, loop = atime,
                            dst = {
                                {time = 0, x = x + w / 2, y = by, w = 0, h = -bh, r = r, g = g, b = b, a = KEY_BEAM.ALPHA, acc = 2},
                                {time = atime, x = x, w = w}
                            }
                        }
                    end
                elseif iskeyFlashAppearFromEdgeAnimation() then
                    -- 左
                    dst[#dst+1] = {
                        id = "keyBeam", offset = 3, timer = myTimer, loop = atime,
                        dst = {
                            {time = 0, x = x, y = y, w = 0, h = h2, r = r, g = g, b = b, a = KEY_BEAM.ALPHA},
                            {time = atime, w = math.ceil(w / 2)},
                        }
                    }
                    if isDrawBackKeyBeam() then
                        dst[#dst+1] = {
                            id = "keyBeam", offset = 3, timer = myTimer, loop = atime,
                            dst = {
                                {time = 0, x = x, y = by, w = 0, h = -bh, r = r, g = g, b = b, a = KEY_BEAM.ALPHA},
                                {time = atime, w = math.ceil(w / 2)},
                            }
                        }
                    end
                    -- 右
                    dst[#dst+1] = {
                        id = "keyBeam", offset = 3, timer = myTimer, loop = atime,
                        dst = {
                            {time = 0, x = x + w, y = y, w = 0, h = h2, r = r, g = g, b = b, a = KEY_BEAM.ALPHA},
                            {time = atime, w = -math.floor(w / 2)},
                        }
                    }
                    if isDrawBackKeyBeam() then
                        dst[#dst+1] = {
                            id = "keyBeam", offset = 3, timer = myTimer, loop = atime,
                            dst = {
                                {time = 0, x = x + w, y = by, w = 0, h = -bh, r = r, g = g, b = b, a = KEY_BEAM.ALPHA},
                                {time = atime, w = -math.floor(w / 2)},
                            }
                        }
                    end
                end
            end

            -- 消失
            myTimer = myTimer + 20
            if dtime ~= 0 then
                if iskeyFlashDelNormalAnimation() then
                    dst[#dst+1] = {
                        id = "keyBeam", offset = 3, timer = myTimer, loop = -1,
                        dst = {
                            {time = 0, x = x, y = y, w = w, h = h2, r = r, g = g, b = b, a = KEY_BEAM.ALPHA},
                            {time = dtime, h = 0}
                        }
                    }
                    if isDrawBackKeyBeam() then
                        dst[#dst+1] = {
                            id = "keyBeam", offset = 3, timer = myTimer, loop = -1,
                            dst = {
                                {time = 0, x = x, y = by, w = w, h = -bh, r = r, g = g, b = b, a = KEY_BEAM.ALPHA},
                                {time = dtime, h = 0}
                            }
                        }
                    end
                elseif iskeyFlashDelFromEdgeAnimation() then
                    dst[#dst+1] = {
                        id = "keyBeam", offset = 3, timer = myTimer, loop = -1,
                        dst = {
                            {time = 0, x = x, y = y, w = w, h = h2, r = r, g = g, b = b, a = KEY_BEAM.ALPHA},
                            {time = dtime, x = x + w / 2, w = 0}
                        }
                    }
                    if isDrawBackKeyBeam() then
                        dst[#dst+1] = {
                            id = "keyBeam", offset = 3, timer = myTimer, loop = -1,
                            dst = {
                                {time = 0, x = x, y = by, w = w, h = -bh, r = r, g = g, b = b, a = KEY_BEAM.ALPHA},
                                {time = dtime, x = x + w / 2, w = 0}
                            }
                        }
                    end
                elseif iskeyFlashDelFromCenterAnimation() then
                    -- 左
                    dst[#dst+1] = {
                        id = "keyBeam", offset = 3, timer = myTimer, loop = -1,
                        dst = {
                            {time = 0, x = x, y = y, w = math.ceil(w / 2), h = h2, r = r, g = g, b = b, a = KEY_BEAM.ALPHA},
                            {time = dtime, w = 0},
                        }
                    }
                    if isDrawBackKeyBeam() then
                        dst[#dst+1] = {
                            id = "keyBeam", offset = 3, timer = myTimer, loop = -1,
                            dst = {
                                {time = 0, x = x, y = by, w = math.ceil(w / 2), h = -bh, r = r, g = g, b = b, a = KEY_BEAM.ALPHA},
                                {time = dtime, w = 0},
                            }
                        }
                    end
                    -- 右
                    dst[#dst+1] = {
                        id = "keyBeam", offset = 3, timer = myTimer, loop = -1,
                        dst = {
                            {time = 0, x = x + w, y = y, w = -math.floor(w / 2), h = h2, r = r, g = g, b = b, a = KEY_BEAM.ALPHA},
                            {time = dtime, w = 0},
                        }
                    }
                    if isDrawBackKeyBeam() then
                        dst[#dst+1] = {
                            id = "keyBeam", offset = 3, timer = myTimer, loop = -1,
                            dst = {
                                {time = 0, x = x + w, y = by, w = -math.floor(w / 2), h = -bh, r = r, g = g, b = b, a = KEY_BEAM.ALPHA},
                                {time = dtime, w = 0},
                            }
                        }
                    end
                end
            end
        end
    end
    return skin
end

return keyBeam.functions