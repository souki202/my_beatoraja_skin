require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")

local keyBeam = {
    functions = {}
}

local KEY_BEAM = {
    HEIGHTS = {0, 160, 350, 564, 720},
    BACK_H = {80, 60},
    ANIMATION_TIMES = {0, 50, 100, 200, 350},
    ALPHA = 192, -- 後で初期化
}

-- 皿もこれ
local function getWhiteBeamColor()
	local dif = getDifficultyValueForColor()
	local colors = {{183, 183, 183}, {151, 190, 151}, {151, 190, 190}, {218, 180, 151}, {255, 192, 192}, {255, 81, 200}}
	return colors[dif][1], colors[dif][2], colors[dif][3]
end

local function getBlueBeamColor()
	local dif = getDifficultyValueForColor()
	local colors = {{128, 128, 128}, {64, 255, 66}, {66, 66, 255}, {255, 128, 64}, {255, 128, 128}, {204, 102, 153}}
	return colors[dif][1], colors[dif][2], colors[dif][3]
end

keyBeam.functions.load = function ()
    KEY_BEAM.ALPHA = 255 - getKeyBeamTransparency()
    print("toumeido: " .. KEY_BEAM.ALPHA)
    return {
        image = {
            {id = "keyBeam", src = 0, x = 18, y = 30, w = 1, h = 80}
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
    local timer = {101, 102, 103, 104, 105, 106, 107, 100}
    for i = 1, commons.keys+1 do
        local r, g, b = wr, wg, wb
        local h2 = h
        local bh = KEY_BEAM.BACK_H[1]
        local by = lanes.getOurterAreaY()
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
                    if isDrwaBackKeyBeam() then
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
                    if isDrwaBackKeyBeam() then
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
                    if isDrwaBackKeyBeam() then
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
                    if isDrwaBackKeyBeam() then
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
                    if isDrwaBackKeyBeam() then
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
                    if isDrwaBackKeyBeam() then
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
                    if isDrwaBackKeyBeam() then
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
                    if isDrwaBackKeyBeam() then
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