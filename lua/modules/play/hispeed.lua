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
            W = function () return lanes.getSideSpace() end,
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
            LANE = {
                Y = function () return HEIGHT + 10 end,
            },
            LIFT = {
                Y = function () return lanes.getAreaY() - 32 end
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
    }
}

hispeed.functions.load = function ()
    local skin = {
        image = {
            {id = "hispeedLabel", src = 0, x = 52, y = 162, w = HISPEED.OPERATION.LABEL.W, h = HISPEED.OPERATION.LABEL.H},
            {id = "hispeedDot", src = 0, x = 2034, y = 76, w = NUMBERS_24PX.W, h = NUMBERS_24PX.H}
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
                vals[#vals+1] = {
                    id = HISPEED.IDS.TYPE[i] .. HISPEED.IDS.COLOR[j] .. HISPEED.IDS.COVER[k],
                    src = 0, x = 1928, y = srcY, w = GREEN.NUM.W * 10, h = GREEN.NUM.H, divx = 10, digit = GREEN.NUM.DIGIT, align = 2, space = -2,
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
    print(HISPEED.NUM.HS.AF_X(HISPEED), HISPEED.NUM.HS.Y(HISPEED))
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

    -- 小さい緑数字
    dst[#dst+1] = {
        id = "white", dst = {
            {x = GREEN.AREA.X(), y = GREEN.AREA.Y(), w = GREEN.AREA.W(), h = GREEN.AREA.H, a = 192}
        }
    }
    for i = 1, 3 do
        dst[#dst+1] = {
            id = HISPEED.IDS.TYPE[i] .. HISPEED.IDS.COLOR[2] .. HISPEED.IDS.COVER[1], op = {271},
            dst = {
                {x = GREEN.NUM.X[i](GREEN), y = GREEN.NUM.Y[i](GREEN), w = GREEN.NUM.W, h = GREEN.NUM.H}
            }
        }
        dst[#dst+1] = {
            id = HISPEED.IDS.TYPE[i] .. HISPEED.IDS.COLOR[2] .. HISPEED.IDS.COVER[2], op = {-271},
            dst = {
                {x = GREEN.NUM.X[i](GREEN), y = GREEN.NUM.Y[i](GREEN), w = GREEN.NUM.W, h = GREEN.NUM.H}
            }
        }
    end
    -- 小さい青数字
    dst[#dst+1] = {
        id = "white", dst = {
            {x = BLUE.AREA.X(), y = BLUE.AREA.Y(), w = BLUE.AREA.W(), h = BLUE.AREA.H, a = 192}
        }
    }
    for i = 1, 3 do
        dst[#dst+1] = {
            id = HISPEED.IDS.TYPE[i] .. HISPEED.IDS.COLOR[1] .. HISPEED.IDS.COVER[1], op = {271},
            dst = {
                {x = BLUE.NUM.X[i](BLUE), y = BLUE.NUM.Y[i](BLUE), w = BLUE.NUM.W, h = BLUE.NUM.H}
            }
        }
        dst[#dst+1] = {
            id = HISPEED.IDS.TYPE[i] .. HISPEED.IDS.COLOR[1] .. HISPEED.IDS.COVER[2], op = {-271},
            dst = {
                {x = BLUE.NUM.X[i](BLUE), y = BLUE.NUM.Y[i](BLUE), w = BLUE.NUM.W, h = BLUE.NUM.H}
            }
        }
    end

    do
        -- レーンカバー部分
        local nw = HISPEED.NUM.W
        local nh = HISPEED.NUM.H
        dst[#dst+1] = {
            id = "laneCoverValue", op = {270, 271}, offset = 4, dst = {
                {x = HISPEED.NUM.COVER.X_W(HISPEED), y = HISPEED.NUM.COVER.LANE.Y(), w = nw, h = nh}
            }
        }
        dst[#dst+1] = {
            id = "largeGreenValueCoverOn", op = {270, 271}, offset = 4, dst = {
                {x = HISPEED.NUM.COVER.X_G(HISPEED), y = HISPEED.NUM.COVER.LANE.Y(), w = nw, h = nh}
            }
        }
        dst[#dst+1] = {
            id = "largeBlueValueCoverOn", op = {270, 271}, offset = 4, dst = {
                {x = HISPEED.NUM.COVER.X_B(HISPEED), y = HISPEED.NUM.COVER.LANE.Y(), w = nw, h = nh}
            }
        }
        -- リフト部分
        dst[#dst+1] = {
            id = "liftValue", op = {270, 272}, offset = 3, dst = {
                {x = HISPEED.NUM.COVER.X_W(HISPEED), y = HISPEED.NUM.COVER.LIFT.Y(), w = nw, h = nh}
            }
        }
        dst[#dst+1] = {
            id = "largeGreenValueCoverOn", op = {270, 272, 271}, offset = 3, dst = {
                {x = HISPEED.NUM.COVER.X_G(HISPEED), y = HISPEED.NUM.COVER.LIFT.Y(), w = nw, h = nh}
            }
        }
        dst[#dst+1] = {
            id = "largeGreenValueCoverOff", op = {270, 272, -271}, offset = 3, dst = {
                {x = HISPEED.NUM.COVER.X_G(HISPEED), y = HISPEED.NUM.COVER.LIFT.Y(), w = nw, h = nh}
            }
        }
        dst[#dst+1] = {
            id = "largeBlueValueCoverOn", op = {270, 272, 271}, offset = 3, dst = {
                {x = HISPEED.NUM.COVER.X_B(HISPEED), y = HISPEED.NUM.COVER.LIFT.Y(), w = nw, h = nh}
            }
        }
        dst[#dst+1] = {
            id = "largeBlueValueCoverOff", op = {270, 272, -271}, offset = 3, dst = {
                {x = HISPEED.NUM.COVER.X_B(HISPEED), y = HISPEED.NUM.COVER.LIFT.Y(), w = nw, h = nh}
            }
        }
    end

    return skin
end

return hispeed.functions