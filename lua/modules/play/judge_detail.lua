require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local detail = {
    functions = {}
}

local DETAIL = {
    AREA = {
        X = function () return lanes.getAreaX() end,
        Y = 0,
        H = 53,
        W = 432,
    },
    IDS = {"perfect", "great", "good", "bad", "poor", "epoor"},
    TEXT = {
        X = function (self, idx) return self.AREA.X() + self.TEXT.W * (idx - 1) end,
        Y = function (self) return self.AREA.Y + 36 end,
        W = 72,
        H = 15,
    },
    NUM = {
        X = function (self, idx) return self.AREA.X() - self.NUM.W * self.NUM.DIGIT / 2 + self.TEXT.W * (idx - 0.5) end,
        Y = function (self) return self.AREA.Y + 19 end,
        W = 9,
        H = 12,
        DIGIT = 5,

        EL = {
            X_1 = function (self, idx) return self.AREA.X() + 19 - (self.NUM.EL.W - 2) * self.NUM.EL.DIGIT / 2 + self.TEXT.W * (idx - 1) end,
            X_2 = function (self, idx) return self.AREA.X() + 53 - (self.NUM.EL.W - 2) * self.NUM.EL.DIGIT / 2 + self.TEXT.W * (idx - 1) end,
            Y = function (self) return self.AREA.Y + 2 end,
            W = 9,
            H = 11,
            DIGIT = 5,
        }
    },
}

detail.functions.load = function ()
    local skin = {image = {}, value = {}}
    local imgs = skin.image
    local vals = skin.value
    local ids = DETAIL.IDS

    for i = 1, #ids do
        imgs[#imgs+1] = {
            id = ids[i] .. "DetailText", src = 0, x = 52, y = DETAIL.TEXT.H * (i - 1), w = DETAIL.TEXT.W, h = DETAIL.TEXT.H
        }
    end

    -- 数値
    for i = 1, #ids do
        local sumRef = 110 + (i - 1)
        local eRef = 410 + (i - 1) * 2
        local lRef = eRef + 1
        if i == #ids then sumRef = 420 end -- missだけ値が違う
        vals[#vals+1] = {
            id = ids[i] .. "DetailValue", src = 0, x = 1940, y = 105, w = DETAIL.NUM.W * 10, h = DETAIL.NUM.H, divx = 10, digit = DETAIL.NUM.DIGIT, ref = sumRef, align = 2
        }
        vals[#vals+1] = {
            id = ids[i] .. "DetailEarlyValue", src = 0, x = 1940, y = 0, w = DETAIL.NUM.EL.W * 10, h = DETAIL.NUM.EL.H, divx = 10, digit = DETAIL.NUM.EL.DIGIT, ref = eRef, space = -2, align = 2
        }
        vals[#vals+1] = {
            id = ids[i] .. "DetailLateValue", src = 0, x = 1940, y = 11, w = DETAIL.NUM.EL.W * 10, h = DETAIL.NUM.EL.H, divx = 10, digit = DETAIL.NUM.EL.DIGIT, ref = lRef, space = -2, align = 2
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
        id = "white", dst = {
            {x = DETAIL.AREA.X(), y = DETAIL.AREA.Y, w = DETAIL.AREA.W, h = DETAIL.AREA.H, a = 192}
        }
    }

    for i = 1, #ids do
        dst[#dst+1] = {
            id = ids[i] .. "DetailText", dst = {
                {x = DETAIL.TEXT.X(DETAIL, i), y = DETAIL.TEXT.Y(DETAIL), w = DETAIL.TEXT.W, h = DETAIL.TEXT.H}
            }
        }
        dst[#dst+1] = {
            id = ids[i] .. "DetailValue", dst = {
                {x = DETAIL.NUM.X(DETAIL, i), y = DETAIL.NUM.Y(DETAIL), w = DETAIL.NUM.W, h = DETAIL.NUM.H}
            }
        }
        dst[#dst+1] = {
            id = ids[i] .. "DetailEarlyValue", dst = {
                {x = DETAIL.NUM.EL.X_1(DETAIL, i), y = DETAIL.NUM.EL.Y(DETAIL), w = DETAIL.NUM.EL.W, h = DETAIL.NUM.EL.H}
            }
        }
        dst[#dst+1] = {
            id = ids[i] .. "DetailLateValue", dst = {
                {x = DETAIL.NUM.EL.X_2(DETAIL, i), y = DETAIL.NUM.EL.Y(DETAIL), w = DETAIL.NUM.EL.W, h = DETAIL.NUM.EL.H}
            }
        }

        -- 区切り線
        dst[#dst+1] = {
            id = "white", dst = {
                {x = DETAIL.TEXT.X(DETAIL, i), y = DETAIL.AREA.Y, w = 1, h = DETAIL.AREA.H}
            }
        }
    end
    -- 区切り線
    dst[#dst+1] = {
        id = "white", dst = {
            {x = DETAIL.AREA.X(), y = DETAIL.TEXT.Y(DETAIL) - 3, w = DETAIL.AREA.W, h = 1}
        }
    }
    dst[#dst+1] = {
        id = "white", dst = {
            {x = DETAIL.AREA.X(), y = DETAIL.NUM.Y(DETAIL) - 3, w = DETAIL.AREA.W, h = 1}
        }
    }
    return skin
end

return detail.functions