require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local info = {
    functions = {}
}

local INFO = {
    LABEL = {
        W = 65,
        H = 18,
    },
    NUM = {
        DIGIT = 5,
    },
    AREA = {
        COMMON = {
            X_1 = function () return 0 end,
            X_2 = function () return WIDTH - lanes.getSideSpace() end,
            W = function () return lanes.getSideSpace() end,
        },
        BPM = {
            H = 64,
        }
    }
}

info.functions.load = function ()
    return {
        image = {
            {id = "bpmLabel"   , src = 0, x = 52, y = 90 + INFO.LABEL.H*0, w = INFO.LABEL.W, h = INFO.LABEL.H},
            {id = "tnLabel"    , src = 0, x = 52, y = 90 + INFO.LABEL.H*1, w = INFO.LABEL.W, h = INFO.LABEL.H},
            {id = "comboLabel" , src = 0, x = 52, y = 90 + INFO.LABEL.H*2, w = INFO.LABEL.W, h = INFO.LABEL.H},
            {id = "timeLabel"  , src = 0, x = 52, y = 90 + INFO.LABEL.H*3, w = INFO.LABEL.W, h = INFO.LABEL.H},
        },
        value = {
            {id = "bpmNow", src = 0, x = NUMBERS_18PX.SRC_X, y = NUMBERS_18PX.SRC_Y, w = NUMBERS_18PX.W*10, h = NUMBERS_18PX.H, divx = 10, dgit = INFO.NUM.DIGIT, align = 2, ref = 160},
            {id = "bpmMin", src = 0, x = NUMBERS_14PX.SRC_X, y = NUMBERS_14PX.SRC_Y, w = NUMBERS_14PX.W*10, h = NUMBERS_14PX.H, divx = 10, dgit = INFO.NUM.DIGIT, align = 2, ref = 91},
            {id = "bpmMin", src = 0, x = NUMBERS_14PX.SRC_X, y = NUMBERS_14PX.SRC_Y, w = NUMBERS_14PX.W*10, h = NUMBERS_14PX.H, divx = 10, dgit = INFO.NUM.DIGIT, align = 2, ref = 90},
            {id = "tnValue", src = 0, x = NUMBERS_18PX.SRC_X, y = NUMBERS_18PX.SRC_Y, w = NUMBERS_18PX.W*10, h = NUMBERS_18PX.H, divx = 10, dgit = INFO.NUM.DIGIT, align = 2, ref = 74},
            {id = "maxComboValue", src = 0, x = NUMBERS_18PX.SRC_X, y = NUMBERS_18PX.SRC_Y, w = NUMBERS_18PX.W*10, h = NUMBERS_18PX.H, divx = 10, dgit = INFO.NUM.DIGIT, align = 2, ref = 105},
            {id = "minuteValue", src = 0, x = NUMBERS_18PX.SRC_X, y = NUMBERS_18PX.SRC_Y, w = NUMBERS_18PX.W*10, h = NUMBERS_18PX.H, divx = 10, dgit = INFO.NUM.DIGIT, align = 2, ref = 163},
            {id = "secondValue", src = 0, x = NUMBERS_18PX.SRC_X, y = NUMBERS_18PX.SRC_Y, w = NUMBERS_18PX.W*10, h = NUMBERS_18PX.H, divx = 10, dgit = INFO.NUM.DIGIT, align = 2, ref = 164},
        },
        text = {
            {id = "colon18px", font = 0, size = 18, constantText = ":"}
        }
    }
end

info.functions.dst = function ()
    
end

return info.functions