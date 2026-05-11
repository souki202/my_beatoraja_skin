require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local detail = {
    functions = {}
}

local DETAIL = {
    AREA = {
        X = function () return is1P() and 2 or (WIDTH - 2 - 510) end,
        Y = 2,
        H = 115,
        W = 510,
    },
    IDS = {"perfect", "great", "good", "bad", "poor", "epoor"},
    NUM = {
        X = function (self, idx) return self.AREA.X() + (idx == 1 and 30 or 126 + 77.5 * (idx - 2)) end,
        Y = function (self) return self.AREA.Y + 57 end,
        W = 10,
        H = 13,
        DIGIT = 5,
    },
}

detail.functions.load = function ()
    local skin = {image = {}, value = {},
        timingvisualizer = {
            {id = "JudgeDetailTimingGraph", graphColor = "88FF88FF", PRColor = "00000000", BDColor = "88000088", GDColor = "88880088", GRColor = "00880088", PGColor = "00008888", devColor = "ffffff44", averageColor = "ffffff44"},
        }
    }
    local imgs = skin.image
    local vals = skin.value
    local ids = DETAIL.IDS

    imgs[#imgs+1] = {
        id = "JudgesDetailFrame", src = 0, x = 0, y = 1833, w = DETAIL.AREA.W, h = DETAIL.AREA.H
    }

    -- 数値
    for i = 1, #ids do
        local sumRef = 110 + (i - 1)
        local eRef = 410 + (i - 1) * 2
        local lRef = eRef + 1
        if i == #ids then -- missだけ値が違う
            sumRef = 420
            eRef = 421
            lRef = 422
        end
        vals[#vals+1] = {
            id = ids[i] .. "DetailValue", src = 0, x = 1948, y = 238, w = DETAIL.NUM.W * 10, h = DETAIL.NUM.H, divx = 10, digit = DETAIL.NUM.DIGIT, ref = sumRef, align = 2
        }
    end
    return skin
end

detail.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    local ids = DETAIL.IDS

    -- 背景
    dst[#dst+1] = {
        id = "JudgesDetailFrame", dst = {
            {x = DETAIL.AREA.X(), y = DETAIL.AREA.Y, w = DETAIL.AREA.W, h = DETAIL.AREA.H}
        }
    }

    for i = 1, #ids do
        dst[#dst+1] = {
            id = ids[i] .. "DetailValue", dst = {
                {x = DETAIL.NUM.X(DETAIL, i), y = DETAIL.NUM.Y(DETAIL), w = DETAIL.NUM.W, h = DETAIL.NUM.H}
            }
        }
    end

    dst[#dst+1] = {
        id = "JudgeDetailTimingGraph", dst = {
            {x = DETAIL.AREA.X() + 12, y = DETAIL.AREA.Y + 8, w = 485, h = 27}
        }
    }

    return skin
end

return detail.functions