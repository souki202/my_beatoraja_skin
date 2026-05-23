require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")
require("modules.commons.numbers")

local hispeed = {
    functions = {}
}

local HISPEED = {
    OPERATION = {
        AREA = {
            X = nil, -- プレイサイドに適したものを入れる
            X_1 = function () return 0 end,
            X_2 = function () return WIDTH - lanes.getSideSpace() end,
            Y = function () return 355 end,
            H = 76,
            W = function () return lanes.getSideSpace() - 2 end,
        },
        LABEL = {
            X = function (self) return self.OPERATION.AREA.X() + (self.OPERATION.AREA.W() - self.OPERATION.LABEL.W) / 2 end,
            Y = function (self) return self.OPERATION.AREA.Y() + 54 end,
            W = 65,
            H = 18,
        },
        LR2HS = {
            X = function (self) return self.OPERATION.AREA.X() + self.OPERATION.AREA.W() / 2 - NUMBERS_24PX.W * self.NUM.DIGIT / 2 end,
            Y = function (self) return self.OPERATION.AREA.Y() + 32 end,
        },
        LARGE_GREEN = {
            X = function (self) return self.OPERATION.AREA.X() + self.OPERATION.AREA.W() / 2  - (self.NUM.W - 1) * self.NUM.DIGIT / 2 end,
            Y = function (self) return self.OPERATION.AREA.Y() + 4 end,
        },
    },
    IDS = {
        TYPE = {"main", "min", "max"},
        COLOR = {"Blue", "Green"},
        COVER = {"On", "Off"},
        SUFFIX = "Value",
    },
    NUM = {
        COVER = {
            X_W = function (self) return lanes.getAreaX() + lanes.getAreaW() * 1 / 4 - self.NUM.W * self.NUM.DIGIT / 2 end,
            X_B = function (self) return lanes.getAreaX() + lanes.getAreaW() * 2 / 4 - self.NUM.W * self.NUM.DIGIT / 2 end,
            X_G = function (self) return lanes.getAreaX() + lanes.getAreaW() * 3 / 4 - self.NUM.W * self.NUM.DIGIT / 2 end,
            X_B_SMALL = function (self) return lanes.getAreaX() + lanes.getAreaW() * 2 / 4 - self.NUM.COVER.SMALL.W * self.NUM.COVER.SMALL.DIGIT / 2 end,
            X_G_SMALL = function (self) return lanes.getAreaX() + lanes.getAreaW() * 3 / 4 - self.NUM.COVER.SMALL.W * self.NUM.COVER.SMALL.DIGIT / 2 end,
            LANE = {
                Y = function () return HEIGHT + 10 end,
            },
            LIFT = {
                Y = function () return lanes.getAreaNormalY() - 32 end
            },
            NO_LIFT = {
                Y = function () return lanes.getAreaNormalY() + 70 end
            },
            SMALL = {
                DIGIT = 4,
                W = 10,
                H = 12,
                GAP = 2,
                RANGE_GAP = 3,
            },
            W = 17,
            H = 22,
        },
        HS = {
            DOT_X = function (self) return self.OPERATION.AREA.X() + 27 end,
            X = function (self) return self.NUM.HS.DOT_X(self) - self.NUM.W * self.NUM.HS.DIGIT + 2 end,
            AF_X = function (self) return self.NUM.HS.DOT_X(self) + 5 end,
            Y = function (self) return self.OPERATION.AREA.Y() + 32 end,
            DIGIT = 1,
            AF_DIGIT = 2,
        },
        DIGIT = 4,
        W = 17,
        H = 22,
    },
    HYPHEN = {
        W = 6,
        H = 12,
    }
}

local GREEN = {
    AREA = {
        X = nil, -- プレイサイドに適したものを入れる
        X_1 = function () return 0 end,
        X_2 = function () return WIDTH - lanes.getSideSpace() end,
        Y = function () return 324 end,
        H = 27,
        W = function () return lanes.getSideSpace() end,
    },
    NUM = {
        X = {
            function (self) return self.AREA.X() + self.AREA.W() / 2  - (self.NUM.W - 1) * self.NUM.DIGIT / 2 end,
            function (self) return self.AREA.X() + 19  - (self.NUM.W - 1) * self.NUM.DIGIT / 2 end,
            function (self) return self.AREA.X() + 54  - (self.NUM.W - 1) * self.NUM.DIGIT / 2 end,
        },
        Y = {
            function (self) return self.AREA.Y() + 14 end,
            function (self) return self.AREA.Y() + 1 end,
            function (self) return self.AREA.Y() + 1 end,
        },
        DIGIT = 4,
        W = 10,
        H = 12,

        SMALL = {
            W = 10,
            H = 12,
        },
    }
}

local BLUE = {
    AREA = {
        X = nil, -- プレイサイドに適したものを入れる
        X_1 = function () return 0 end,
        X_2 = function () return WIDTH - lanes.getSideSpace() end,
        Y = function () return 293 end,
        H = 27,
        W = function () return lanes.getSideSpace() end,
    },
    NUM = {
        X = {
            function (self) return self.AREA.X() + self.AREA.W() / 2  - (self.NUM.W - 1) * self.NUM.DIGIT / 2 end,
            function (self) return self.AREA.X() + 19  - (self.NUM.W - 1) * self.NUM.DIGIT / 2 end,
            function (self) return self.AREA.X() + 54  - (self.NUM.W - 1) * self.NUM.DIGIT / 2 end,
        },
        Y = {
            function (self) return self.AREA.Y() + 14 end,
            function (self) return self.AREA.Y() + 1 end,
            function (self) return self.AREA.Y() + 1 end,
        },
        DIGIT = 4,
        W = 10,
        H = 12,
    },

    SMALL = {
        W = 10,
        H = 12,
    },
}

hispeed.functions.load = function ()
    local skin = {
        image = {
            {id = "hispeedLabel", src = 0, x = 52, y = 162, w = HISPEED.OPERATION.LABEL.W, h = HISPEED.OPERATION.LABEL.H},
            {id = "hispeedDot", src = 0, x = 2034, y = 76, w = NUMBERS_24PX.W, h = NUMBERS_24PX.H},
            {id = "greenHyphen", src = 0, x = 2042, y = 34, w = HISPEED.HYPHEN.W, h = HISPEED.HYPHEN.H},
            {id = "blueHyphen", src = 0, x = 2042, y = 22, w = HISPEED.HYPHEN.W, h = HISPEED.HYPHEN.H},
        },
        value = {
            {id = "lr2Hispeed", src = 0, x = 1880, y = 76, w = NUMBERS_24PX.W * 10, h = NUMBERS_24PX.H, divx = 10, digit = HISPEED.NUM.DIGIT, ref = 10, align = 2},
            {id = "hispeedValue", src = 0, x = 1880, y = 76, w = NUMBERS_24PX.W * 10, h = NUMBERS_24PX.H, divx = 10, digit = HISPEED.NUM.HS.DIGIT, ref = 310, align = 0},
            {id = "hispeedAfterDot", src = 0, x = 1880, y = 76, w = NUMBERS_24PX.W * 10, h = NUMBERS_24PX.H, divx = 10, digit = HISPEED.NUM.HS.AF_DIGIT, ref = 311, align = 1, padding = 1},
            {id = "largeGreenValueCoverOn", src = 0, x = 1845, y = 117, w = HISPEED.NUM.W * 10, h = HISPEED.NUM.H, divx = 10, digit = HISPEED.NUM.DIGIT, ref = 1312, align = 2, space = -2},
            {id = "largeGreenValueCoverOff", src = 0, x = 1845, y = 117, w = HISPEED.NUM.W * 10, h = HISPEED.NUM.H, divx = 10, digit = HISPEED.NUM.DIGIT, ref = 313, align = 2, space = -2},
            {id = "largeBlueValueCoverOn", src = 0, x = 1845, y = 139, w = HISPEED.NUM.W * 10, h = HISPEED.NUM.H, divx = 10, digit = HISPEED.NUM.DIGIT, ref = 1313, align = 2, space = -2},
            {id = "largeBlueValueCoverOff", src = 0, x = 1845, y = 139, w = HISPEED.NUM.W * 10, h = HISPEED.NUM.H, divx = 10, digit = HISPEED.NUM.DIGIT, ref = 312, align = 2, space = -2},
            {id = "laneCoverValue", src = 0, x = 1845, y = 161, w = HISPEED.NUM.W * 10, h = HISPEED.NUM.H, divx = 10, digit = HISPEED.NUM.DIGIT, ref = 14, align = 2, space = -2},
            {id = "liftValue", src = 0, x = 1845, y = 161, w = HISPEED.NUM.W * 10, h = HISPEED.NUM.H, divx = 10, digit = HISPEED.NUM.DIGIT, ref = 314, align = 2, space = -2},
        }
    }
    local vals = skin.value

    HISPEED.OPERATION.AREA.X = is1P() and HISPEED.OPERATION.AREA.X_1 or HISPEED.OPERATION.AREA.X_2
    GREEN.AREA.X = is1P() and GREEN.AREA.X_1 or GREEN.AREA.X_2
    BLUE.AREA.X = is1P() and BLUE.AREA.X_1 or BLUE.AREA.X_2

    -- {id = "mainGreenValueCoverOn", src = 0, x = 1928, y = 34, w = HISPEED.NUM.GREEN.W * 10, h = HISPEED.NUM.GREEN.H, divx = 10, digit = HISPEED.NUM.DIGIT, ref = 1312, align = 1},
    -- {id = "mainBlueValueCoverOn", src = 0, x = 1928, y = 22, w = HISPEED.NUM.BLUE.W * 10, h = HISPEED.NUM.BLUE.H, divx = 10, digit = HISPEED.NUM.DIGIT, ref = 1313, align = 1},

    -- すべての数字の組み合わせを読み込む
    for i = 1, #HISPEED.IDS.TYPE do
        for j = 1, #HISPEED.IDS.COLOR do
            local srcY = 34
            if HISPEED.IDS.COLOR[j] == "Blue" then
                srcY = 22
            end
            for k = 1, #HISPEED.IDS.COVER do
                -- グリーンがブルーでブルーがグリーンなのに注意
                local ref = 1316 + (i - 1) * 4 + (2 - j) + (k - 1) * 2
                if ref == 1317 then ref = 1313 end
                if ref == 1319 then ref = 312 end
                if ref == 1316 then ref = 1312 end
                if ref == 1318 then ref = 1314 end
                local align = 2
                if HISPEED.IDS.TYPE[i] == "max" then
                    align = 0
                end
                vals[#vals+1] = {
                    id = HISPEED.IDS.TYPE[i] .. HISPEED.IDS.COLOR[j] .. HISPEED.IDS.COVER[k],
                    src = 0, x = 1928, y = srcY, w = GREEN.NUM.W * 10, h = GREEN.NUM.H, divx = 10, digit = GREEN.NUM.DIGIT, align = align, space = -2,
                    ref = ref
                }
            end
        end
    end
    return skin
end

hispeed.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    -- 背景
    local opArea = HISPEED.OPERATION.AREA
    local operation = HISPEED.OPERATION
    dst[#dst+1] = {
        id = "white", op = {270}, dst = {
            {x = opArea.X(), y = opArea.Y(), w = opArea.W(), h = opArea.H}
        }
    }
    -- ラベル
    dst[#dst+1] = {
        id = "hispeedLabel", op = {270}, dst = {
            {x = operation.LABEL.X(HISPEED), y = operation.LABEL.Y(HISPEED), w = operation.LABEL.W, h = operation.LABEL.H}
        }
    }
    -- lr2ハイスピ
    -- dst[#dst+1] = {
    --     id = "lr2Hispeed", op = {270}, dst = {
    --         {x = operation.LR2HS.X(HISPEED), y = operation.LR2HS.Y(HISPEED), w = NUMBERS_24PX.W, h = NUMBERS_24PX.H}
    --     }
    -- }
    -- ハイスピ
    dst[#dst+1] = {
        id = "hispeedValue", op = {270}, dst = {
            {x = HISPEED.NUM.HS.X(HISPEED), y = HISPEED.NUM.HS.Y(HISPEED), w = NUMBERS_24PX.W, h = NUMBERS_24PX.H}
        }
    }
    dst[#dst+1] = {
        id = "hispeedDot", op = {270}, dst = {
            {x = HISPEED.NUM.HS.DOT_X(HISPEED), y = HISPEED.NUM.HS.Y(HISPEED), w = NUMBERS_24PX.W, h = NUMBERS_24PX.H}
        }
    }
    dst[#dst+1] = {
        id = "hispeedAfterDot", op = {270}, dst = {
            {x = HISPEED.NUM.HS.AF_X(HISPEED), y = HISPEED.NUM.HS.Y(HISPEED), w = NUMBERS_24PX.W, h = NUMBERS_24PX.H}
        }
    }

    -- 大きい緑数字
    dst[#dst+1] = {
        id = "largeGreenValueCoverOff", op = {270, -271}, dst = {
            {x = operation.LARGE_GREEN.X(HISPEED), y = operation.LARGE_GREEN.Y(HISPEED), w = HISPEED.NUM.W, h = HISPEED.NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "largeGreenValueCoverOn", op = {270, 271}, dst = {
            {x = operation.LARGE_GREEN.X(HISPEED), y = operation.LARGE_GREEN.Y(HISPEED), w = HISPEED.NUM.W, h = HISPEED.NUM.H}
        }
    }


    do
        -- レーンカバー部分
        local nw = HISPEED.NUM.W
        local nh = HISPEED.NUM.H
        local small = HISPEED.NUM.COVER.SMALL
        local function addCoverNumber(id, op, offset, x, y, w, h)
            local item = {
                id = id, op = op, dst = {
                    {x = x, y = y, w = w, h = h}
                }
            }
            if offset ~= nil then
                item.offset = offset
            end
            dst[#dst+1] = item
        end
        local function addSmallRange(color, cover, op, offset, x, mainY, position)
            local rangeY = mainY + nh + small.GAP
            if position == "below" then
                rangeY = mainY - small.H - small.GAP
            end
            local centerX = x + small.W * small.DIGIT / 2
            local hyphenX = centerX - HISPEED.HYPHEN.W / 2
            local minX = hyphenX - small.RANGE_GAP - small.W * small.DIGIT
            local maxX = hyphenX + HISPEED.HYPHEN.W + small.RANGE_GAP
            local hyphenId = color == "Green" and "greenHyphen" or "blueHyphen"
            addCoverNumber("min" .. color .. cover, op, offset, minX, rangeY, small.W, small.H)
            addCoverNumber(hyphenId, op, offset, hyphenX, rangeY, HISPEED.HYPHEN.W, HISPEED.HYPHEN.H)
            addCoverNumber("max" .. color .. cover, op, offset, maxX, rangeY, small.W, small.H)
        end
        local laneY = HISPEED.NUM.COVER.LANE.Y()
        local liftY = HISPEED.NUM.COVER.LIFT.Y()
        local noLiftY = HISPEED.NUM.COVER.NO_LIFT.Y()
        dst[#dst+1] = {
            id = "laneCoverValue", op = {80, {270}, {271}}, offset = 4, dst = {
                {x = HISPEED.NUM.COVER.X_W(HISPEED), y = laneY, w = nw, h = nh}
            }
        }
        dst[#dst+1] = {
            id = "largeGreenValueCoverOn", op = {80, {270}, {271}}, offset = 4, dst = {
                {x = HISPEED.NUM.COVER.X_G(HISPEED), y = laneY, w = nw, h = nh}
            }
        }
        dst[#dst+1] = {
            id = "largeBlueValueCoverOn", op = {80, {270}, {271}}, offset = 4, dst = {
                {x = HISPEED.NUM.COVER.X_B(HISPEED), y = laneY, w = nw, h = nh}
            }
        }
        addSmallRange("Green", "On", {80, {270}, {271}}, 4, HISPEED.NUM.COVER.X_G_SMALL(HISPEED), laneY, "above")
        addSmallRange("Blue", "On", {80, {270}, {271}}, 4, HISPEED.NUM.COVER.X_B_SMALL(HISPEED), laneY, "above")

        -- リフト部分
        dst[#dst+1] = {
            id = "liftValue", op = {80, {270}, {272}}, offset = 3, dst = {
                {x = HISPEED.NUM.COVER.X_W(HISPEED), y = liftY, w = nw, h = nh}
            }
        }
        dst[#dst+1] = {
            id = "largeGreenValueCoverOn", op = {80, 271, {270}, {272}}, offset = 3, dst = {
                {x = HISPEED.NUM.COVER.X_G(HISPEED), y = liftY, w = nw, h = nh}
            }
        }
        dst[#dst+1] = {
            id = "largeGreenValueCoverOff", op = {80, -271, {270}, {272}}, offset = 3, dst = {
                {x = HISPEED.NUM.COVER.X_G(HISPEED), y = liftY, w = nw, h = nh}
            }
        }
        dst[#dst+1] = {
            id = "largeBlueValueCoverOn", op = {80, 271, {270}, {272}}, offset = 3, dst = {
                {x = HISPEED.NUM.COVER.X_B(HISPEED), y = liftY, w = nw, h = nh}
            }
        }
        dst[#dst+1] = {
            id = "largeBlueValueCoverOff", op = {80, -271, {270}, {272}}, offset = 3, dst = {
                {x = HISPEED.NUM.COVER.X_B(HISPEED), y = liftY, w = nw, h = nh}
            }
        }
        addSmallRange("Green", "On", {80, 271, {270}, {272}}, 3, HISPEED.NUM.COVER.X_G_SMALL(HISPEED), liftY, "below")
        addSmallRange("Green", "Off", {80, -271, {270}, {272}}, 3, HISPEED.NUM.COVER.X_G_SMALL(HISPEED), liftY, "below")
        addSmallRange("Blue", "On", {80, 271, {270}, {272}}, 3, HISPEED.NUM.COVER.X_B_SMALL(HISPEED), liftY, "below")
        addSmallRange("Blue", "Off", {80, -271, {270}, {272}}, 3, HISPEED.NUM.COVER.X_B_SMALL(HISPEED), liftY, "below")

        -- リフトがないとき
        addCoverNumber("laneCoverValue", {80, {270}, -272}, nil, HISPEED.NUM.COVER.X_W(HISPEED), noLiftY, nw, nh)
        addCoverNumber("largeGreenValueCoverOn", {80, 271, {270}, -272}, nil, HISPEED.NUM.COVER.X_G(HISPEED), noLiftY, nw, nh)
        addCoverNumber("largeGreenValueCoverOff", {80, -271, {270}, -272}, nil, HISPEED.NUM.COVER.X_G(HISPEED), noLiftY, nw, nh)
        addCoverNumber("largeBlueValueCoverOn", {80, 271, {270}, -272}, nil, HISPEED.NUM.COVER.X_B(HISPEED), noLiftY, nw, nh)
        addCoverNumber("largeBlueValueCoverOff", {80, -271, {270}, -272}, nil, HISPEED.NUM.COVER.X_B(HISPEED), noLiftY, nw, nh)
        addSmallRange("Green", "On", {80, 271, {270}, -272}, nil, HISPEED.NUM.COVER.X_G_SMALL(HISPEED), noLiftY, "below")
        addSmallRange("Green", "Off", {80, -271, {270}, -272}, nil, HISPEED.NUM.COVER.X_G_SMALL(HISPEED), noLiftY, "below")
        addSmallRange("Blue", "On", {80, 271, {270}, -272}, nil, HISPEED.NUM.COVER.X_B_SMALL(HISPEED), noLiftY, "below")
        addSmallRange("Blue", "Off", {80, -271, {270}, -272}, nil, HISPEED.NUM.COVER.X_B_SMALL(HISPEED), noLiftY, "below")
    end

    return skin
end

return hispeed.functions
