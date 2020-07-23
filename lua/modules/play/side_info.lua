require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local info = {
    functions = {}
}

local INFO = {
    LABEL = {
        X = function (self) return self.AREA.COMMON.X() + (self.AREA.COMMON.W() - self.LABEL.W) / 2 end,
        BPM_Y = function (areaY) return areaY + 42 end,
        OTHER_Y = function (areaY) return areaY + 28 end,
        W = 65,
        H = 18,
    },
    NUM = {
        DIGIT = 5,
        CENTER_X = function (self) return self.AREA.COMMON.X() + self.AREA.COMMON.W() / 2 - NUMBERS_18PX.W * self.NUM.DIGIT / 2 end,
        Y = function (areaY) return areaY + 8 end, -- BPM以外
        BPM = {
            MIN_X = function (self) return self.AREA.COMMON.X() + 32 - NUMBERS_14PX.W * self.NUM.DIGIT end,
            TILDA_X = function (self) return self.AREA.COMMON.X() + 32 end,
            MAX_X = function (self) return self.AREA.COMMON.X() + 41 end,
            NOW_Y = function (areaY) return areaY + 22 end,
            VAR_Y = function (areaY) return areaY + 5 end,
        },
        TIME = {
            DIGIT = 2,
            M_X = function (self) return self.AREA.COMMON.X() + 34 - NUMBERS_18PX.W * self.NUM.TIME.DIGIT end,
            COLON_X = function (self) return self.AREA.COMMON.X() + 35 end,
            S_X = function (self) return self.AREA.COMMON.X() + 39 end,
        }
    },
    AREA = {
        COMMON = {
            X = nil,
            X_1 = function () return 0 end,
            X_2 = function () return WIDTH - lanes.getSideSpace() end,
            W = function () return lanes.getSideSpace() - 2 end,
            H = 50,
        },
        BPM = {
            H = 64,
            Y = 191,
        },
        TN = {
            Y = 137
        },
        COMBO = {
            Y = 83,
        },
        TIME = {
            Y = 29,
        }
    }
}

local LN = {
    X = nil,
    X_1 = function () return 0 end,
    X_2 = function () return WIDTH - lanes.getSideSpace() end,
    Y = function () return 0 end,
    W = function () return lanes.getSideSpace() - 2 end,
    H = 25,
}

info.functions.load = function ()
    INFO.AREA.COMMON.X = is1P() and INFO.AREA.COMMON.X_1 or INFO.AREA.COMMON.X_2
    LN.X = is1P() and LN.X_1 or LN.X_2

    return {
        image = {
            {id = "bpmLabel"   , src = 0, x = 52, y = 90 + INFO.LABEL.H*0, w = INFO.LABEL.W, h = INFO.LABEL.H},
            {id = "tnLabel"    , src = 0, x = 52, y = 90 + INFO.LABEL.H*1, w = INFO.LABEL.W, h = INFO.LABEL.H},
            {id = "comboLabel" , src = 0, x = 52, y = 90 + INFO.LABEL.H*2, w = INFO.LABEL.W, h = INFO.LABEL.H},
            {id = "timeLabel"  , src = 0, x = 52, y = 90 + INFO.LABEL.H*3, w = INFO.LABEL.W, h = INFO.LABEL.H},
            {id = "tilda14px", src = 0, x = 1931, y = 94, w = NUMBERS_14PX.W, h = NUMBERS_14PX.H},
            {id = "lnMode", src = 0, x = 509, y = 0, w = LN.W(), h = LN.H * 3, divy = 3, len = 3, ref = 308},
            {id = "lnModeGrow", src = 0, x = 509 + LN.W(), y = 0, w = LN.W(), h = LN.H * 3, divy = 3, len = 3, ref = 308},
        },
        value = {
            {id = "bpmNow", src = 0, x = NUMBERS_18PX.SRC_X, y = NUMBERS_18PX.SRC_Y, w = NUMBERS_18PX.W*10, h = NUMBERS_18PX.H, divx = 10, digit = INFO.NUM.DIGIT, align = 2, ref = 160},
            {id = "bpmMin", src = 0, x = NUMBERS_14PX.SRC_X, y = NUMBERS_14PX.SRC_Y, w = NUMBERS_14PX.W*10, h = NUMBERS_14PX.H, divx = 10, digit = INFO.NUM.DIGIT, align = 0, ref = 91},
            {id = "bpmMax", src = 0, x = NUMBERS_14PX.SRC_X, y = NUMBERS_14PX.SRC_Y, w = NUMBERS_14PX.W*10, h = NUMBERS_14PX.H, divx = 10, digit = INFO.NUM.DIGIT, align = 1, ref = 90},
            {id = "tnValue", src = 0, x = NUMBERS_18PX.SRC_X, y = NUMBERS_18PX.SRC_Y, w = NUMBERS_18PX.W*10, h = NUMBERS_18PX.H, divx = 10, digit = INFO.NUM.DIGIT, align = 2, ref = 74},
            {id = "maxComboValue", src = 0, x = NUMBERS_18PX.SRC_X, y = NUMBERS_18PX.SRC_Y, w = NUMBERS_18PX.W*10, h = NUMBERS_18PX.H, divx = 10, digit = INFO.NUM.DIGIT, align = 2, ref = 105},
            {id = "minuteValue", src = 0, x = NUMBERS_18PX.SRC_X, y = NUMBERS_18PX.SRC_Y, w = NUMBERS_18PX.W*10, h = NUMBERS_18PX.H, divx = 10, digit = INFO.NUM.TIME.DIGIT, align = 0, ref = 163, zeropadding = 1, padding = 1},
            {id = "secondValue", src = 0, x = NUMBERS_18PX.SRC_X, y = NUMBERS_18PX.SRC_Y, w = NUMBERS_18PX.W*10, h = NUMBERS_18PX.H, divx = 10, digit = INFO.NUM.TIME.DIGIT, align = 1, ref = 164, zeropadding = 1, padding = 1},
        },
        text = {
            {id = "colon18px", font = 0, size = 18, constantText = ":"}
        }
    }
end

info.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    -- BPM
    local bpmY = INFO.AREA.BPM.Y
    -- 背景
    dst[#dst+1] = {
        id = "white", dst = {
            {x = INFO.AREA.COMMON.X(), y = bpmY, w = INFO.AREA.COMMON.W(), h = INFO.AREA.BPM.H}
        }
    }
    -- ラベル
    dst[#dst+1] = {
        id = "bpmLabel", dst = {
            {x = INFO.LABEL.X(INFO), y = INFO.LABEL.BPM_Y(bpmY), w = INFO.LABEL.W, h = INFO.LABEL.H}
        }
    }
    -- 数値
    dst[#dst+1] = {
        id = "bpmNow", dst = {
            {x = INFO.NUM.CENTER_X(INFO), y = INFO.NUM.BPM.NOW_Y(bpmY), w = NUMBERS_18PX.W, h = NUMBERS_18PX.H}
        }
    }
    dst[#dst+1] = {
        id = "bpmMin", dst = {
            {x = INFO.NUM.BPM.MIN_X(INFO), y = INFO.NUM.BPM.VAR_Y(bpmY), w = NUMBERS_14PX.W, h = NUMBERS_14PX.H}
        }
    }
    dst[#dst+1] = {
        id = "tilda14px", dst = {
            {x = INFO.NUM.BPM.TILDA_X(INFO), y = INFO.NUM.BPM.VAR_Y(bpmY), w = NUMBERS_14PX.W, h = NUMBERS_14PX.H}
        }
    }
    dst[#dst+1] = {
        id = "bpmMax", dst = {
            {x = INFO.NUM.BPM.MAX_X(INFO), y = INFO.NUM.BPM.VAR_Y(bpmY), w = NUMBERS_14PX.W, h = NUMBERS_14PX.H}
        }
    }

    -- TN
    -- 背景
    local tnY = INFO.AREA.TN.Y
    dst[#dst+1] = {
        id = "white", dst = {
            {x = INFO.AREA.COMMON.X(), y = tnY, w = INFO.AREA.COMMON.W(), h = INFO.AREA.COMMON.H}
        }
    }
    -- ラベル
    dst[#dst+1] = {
        id = "tnLabel", dst = {
            {x = INFO.LABEL.X(INFO), y = INFO.LABEL.OTHER_Y(tnY), w = INFO.LABEL.W, h = INFO.LABEL.H}
        }
    }
    dst[#dst+1] = {
        id = "tnValue", dst = {
            {x = INFO.NUM.CENTER_X(INFO), y = INFO.NUM.Y(tnY), w = NUMBERS_18PX.W, h = NUMBERS_18PX.H}
        }
    }

    -- COMBO
    -- 背景
    local comboY = INFO.AREA.COMBO.Y
    dst[#dst+1] = {
        id = "white", dst = {
            {x = INFO.AREA.COMMON.X(), y = comboY, w = INFO.AREA.COMMON.W(), h = INFO.AREA.COMMON.H}
        }
    }
    -- ラベル
    dst[#dst+1] = {
        id = "comboLabel", dst = {
            {x = INFO.LABEL.X(INFO), y = INFO.LABEL.OTHER_Y(comboY), w = INFO.LABEL.W, h = INFO.LABEL.H}
        }
    }
    dst[#dst+1] = {
        id = "maxComboValue", dst = {
            {x = INFO.NUM.CENTER_X(INFO), y = INFO.NUM.Y(comboY), w = NUMBERS_18PX.W, h = NUMBERS_18PX.H}
        }
    }

    -- COMBO
    -- 背景
    local timeY = INFO.AREA.TIME.Y
    dst[#dst+1] = {
        id = "white", dst = {
            {x = INFO.AREA.COMMON.X(), y = timeY, w = INFO.AREA.COMMON.W(), h = INFO.AREA.COMMON.H}
        }
    }
    -- ラベル
    dst[#dst+1] = {
        id = "timeLabel", dst = {
            {x = INFO.LABEL.X(INFO), y = INFO.LABEL.OTHER_Y(timeY), w = INFO.LABEL.W, h = INFO.LABEL.H}
        }
    }
    -- 分
    dst[#dst+1] = {
        id = "minuteValue", dst = {
            {x = INFO.NUM.TIME.M_X(INFO), y = INFO.NUM.Y(timeY), w = NUMBERS_18PX.W, h = NUMBERS_18PX.H}
        }
    }
    dst[#dst+1] = {
        id = "colon18px", dst = {
            {x = INFO.NUM.TIME.COLON_X(INFO), y = INFO.NUM.Y(timeY) - 4, w = 20, h = 18, r = 0, g = 0, b = 0}
        }
    }
    dst[#dst+1] = {
        id = "secondValue", dst = {
            {x = INFO.NUM.TIME.S_X(INFO), y = INFO.NUM.Y(timeY), w = NUMBERS_18PX.W, h = NUMBERS_18PX.H}
        }
    }

    
	-- LNモード
	dst[#dst+1] = {
        id = "lnMode", dst = {
            {x = LN.X(), y = LN.Y(), w = LN.W(), h = LN.H}
        }
    }
	dst[#dst+1] = {
        id = "lnModeGrow", timer = 140, dst = {
            {time = 0, x = LN.X(), y = LN.Y(), w = LN.W(), h = LN.H, a = 255},
            {time = 1000, a = 0}
        }
    }
    return skin
end

return info.functions