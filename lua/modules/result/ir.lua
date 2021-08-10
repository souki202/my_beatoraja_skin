require("modules.commons.numbers")
require("modules.commons.my_window")
require("modules.result.commons")
local main_state = require("main_state")

local ir = {
    functions = {}
}

local IR = {
    WND = {
        X = 734,
        Y = 744,
        W = 290,
        H = 70,
    },

    SUFFIX_S_TEXT = {
        Y = function (self) return self.WND.Y + 10 end,
        W = 18,
        H = 17,
    },
    SUFFIX_L_TEXT = {
        Y = function (self) return self.WND.Y + 10 end,
        W = 23,
        H = 23,
    },
    SUFFIX_PLAYER_TEXT = {
        Y = function (self) return self.WND.Y + 10 end,
        W = 14,
        H = 13,
    },

    TEXT = {
        X = function (self) return self.WND.X + 90 end,
        Y = function (self) return self.WND.Y + 42 end,
        W = 110,
        H = 22
    },

    ARROW = {
        X = function (self) return self.WND.X + 100 end,
        Y = function (self) return self.WND.Y + 9 end,
    },

    BALL = {
        X = function (self) return self.WND.X + 210 end,
        Y = function (self) return self.WND.Y + 45 end,
        W = 16,
        H = 16,
        ANIM = {
            N = 5,
            MOVE_X = 50,
            TIME = 1500,
            STOP_TIME = 500,
            DURATION = 100,
        }
    },

    NUM = {
        DIGIT = 4,
        OLD = {
            X = function (self) return self.WND.X + 66 end,
            Y = function (self) return self.WND.Y + 12 end,
        },
        NOW = {
            X = function (self) return self.WND.X + 193 end,
            Y = function (self) return self.WND.Y + 12 end,
        },
        PLAYER = {
            X = function (self) return self.WND.X + 264 end,
            Y = function (self) return self.WND.Y + 12 end,
        },
    },
}

ir.functions.load = function ()
    if isOldLayout() == false then
        IR.WND.X = LEFT_X
        IR.WND.Y = 564
    end
    if is2P() then
        IR.WND.X = WIDTH - IR.WND.X - IR.WND.W
    end

    return {
        image = {
            {id = "irSuffix18px", src = 0, x = 0, y = 70, w = IR.SUFFIX_S_TEXT.W, h = IR.SUFFIX_S_TEXT.H},
            {id = "irSuffix24px", src = 0, x = 18, y = 70, w = IR.SUFFIX_L_TEXT.W, h = IR.SUFFIX_L_TEXT.H},
            {id = "irSuffixNumOfPlayer", src = 0, x = 27, y = 49, w = IR.SUFFIX_PLAYER_TEXT.W, h = IR.SUFFIX_PLAYER_TEXT.H},
            {id = "irText", src = 0, x = VALUE_ITEM_TEXT.SRC_X, y = 352, w = IR.TEXT.W, h = IR.TEXT.H},
            {id = "irConnectingBall", src = 0, x = 779, y = 204, w = IR.BALL.W, h = IR.BALL.H},
        },
        value = {
            {id = "irOldValue", src = NUM_18PX.SRC, x = NUM_18PX.SRC_X, y = NUM_18PX.SRC_Y, w = NUM_18PX.W * 11, h = NUM_18PX.H, divx = 11, digit = IR.NUM.DIGIT, ref = 182, align = 0},
            {id = "irNowValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 11, h = NUM_24PX.H, divx = 11, digit = IR.NUM.DIGIT, ref = 179, align = 0},
            {id = "irNumOfPlayerValue", src = NUM_18PX.SRC, x = NUM_18PX.SRC_X, y = NUM_18PX.SRC_Y, w = NUM_18PX.W * 11, h = NUM_18PX.H, divx = 11, digit = IR.NUM.DIGIT, ref = 180, align = 0},
        }
    }
end

ir.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    destinationStaticBaseWindowResult(skin, IR.WND.X, IR.WND.Y, IR.WND.W, IR.WND.H)
    mergeSkin(skin, {
        destination = {
            {
                id = "irText", dst = {
                    {x = IR.TEXT.X(IR), y = IR.TEXT.Y(IR), w = IR.TEXT.W, h = IR.TEXT.H}
                }
            },
            {
                id = "irSuffix18px", dst = {
                    {x = IR.NUM.OLD.X(IR), y = IR.SUFFIX_S_TEXT.Y(IR), w = IR.SUFFIX_S_TEXT.W, h = IR.SUFFIX_S_TEXT.H}
                }
            },
            {
                id = "changeArrow", dst = {
                    {x = IR.ARROW.X(IR), y = IR.ARROW.Y(IR), w = CHANGE_ARROW.W, h = CHANGE_ARROW.H}
                }
            },
            {
                id = "irSuffix24px", dst = {
                    {x = IR.NUM.NOW.X(IR), y = IR.SUFFIX_L_TEXT.Y(IR), w = IR.SUFFIX_L_TEXT.W, h = IR.SUFFIX_L_TEXT.H}
                }
            },
            {
                id = "irSuffixNumOfPlayer", dst = {
                    {x = IR.NUM.PLAYER.X(IR), y = IR.SUFFIX_PLAYER_TEXT.Y(IR), w = IR.SUFFIX_PLAYER_TEXT.W, h = IR.SUFFIX_PLAYER_TEXT.H}
                }
            },
        }
    })

    -- 接続中はそれを示すオブジェクトを動かす
    local moveTime = IR.BALL.ANIM.TIME - IR.BALL.ANIM.STOP_TIME
    local stopTime = IR.BALL.ANIM.STOP_TIME
    local numBallTime = moveTime + stopTime + IR.BALL.ANIM.DURATION * (IR.BALL.ANIM.N - 1)
    local isConnecting = function ()
        return main_state.timer(173) <= 0 and main_state.timer(174) <= 0 
    end
    
    for i = 1, IR.BALL.ANIM.N, 1 do
        local d = IR.BALL.ANIM.DURATION * (i - 1)
        dst[#dst+1] = {
            id = "irConnectingBall", draw = isConnecting, loop = 0, dst = {
                {time = 0, x = IR.BALL.X(IR), y = IR.BALL.Y(IR), w = IR.BALL.W, h = IR.BALL.H, a = 255, acc = 1},
                {time = d},
                {time = d + moveTime / 4, x = IR.BALL.X(IR) + IR.BALL.ANIM.MOVE_X / 2},
                {time = d + moveTime / 4 + 1, a = 0},
                {time = numBallTime},
            }
        }
        dst[#dst+1] = {
            id = "irConnectingBall", draw = isConnecting, loop = 0, dst = {
                {time = 0, x = IR.BALL.X(IR) + IR.BALL.ANIM.MOVE_X / 2, y = IR.BALL.Y(IR), w = IR.BALL.W, h = IR.BALL.H, a = 0, acc = 2},
                {time = d + moveTime / 4},
                {time = d + moveTime / 4 + 1, a = 255},
                {time = d + moveTime / 2, x = IR.BALL.X(IR) + IR.BALL.ANIM.MOVE_X},
                {time = d + moveTime / 2 + 1 + stopTime, a = 0},
                {time = numBallTime},
            }
        }
        dst[#dst+1] = {
            id = "irConnectingBall", draw = isConnecting, loop = 0, dst = {
                {time = 0, x = IR.BALL.X(IR) + IR.BALL.ANIM.MOVE_X, y = IR.BALL.Y(IR), w = IR.BALL.W, h = IR.BALL.H, a = 0, acc = 1},
                {time = d + moveTime / 2},
                {time = d + moveTime / 2 + 1 + stopTime, a = 255},
                {time = d + moveTime * 3 / 4 + stopTime, x = IR.BALL.X(IR) + IR.BALL.ANIM.MOVE_X / 2},
                {time = d + moveTime * 3 / 4 + 1 + stopTime, a = 0},
                {time = numBallTime},
            }
        }
        dst[#dst+1] = {
            id = "irConnectingBall", draw = isConnecting, loop = 0, dst = {
                {time = 0, x = IR.BALL.X(IR) + IR.BALL.ANIM.MOVE_X / 2, y = IR.BALL.Y(IR), w = IR.BALL.W, h = IR.BALL.H, a = 0, acc = 2},
                {time = d + moveTime * 3 / 4 + stopTime},
                {time = d + moveTime * 3 / 4 + 1 + stopTime, a = 255},
                {time = d + moveTime + stopTime, x = IR.BALL.X(IR)},
                {time = numBallTime},
            }
        }
    end

    dstNumberRightJustify(skin, "irOldValue", IR.NUM.OLD.X(IR), IR.NUM.OLD.Y(IR), NUM_18PX.W, NUM_18PX.H, IR.NUM.DIGIT)
    dstNumberRightJustify(skin, "irNowValue", IR.NUM.NOW.X(IR), IR.NUM.NOW.Y(IR), NUM_24PX.W, NUM_24PX.H, IR.NUM.DIGIT)
    dstNumberRightJustify(skin, "irNumOfPlayerValue", IR.NUM.PLAYER.X(IR), IR.NUM.PLAYER.Y(IR), NUM_18PX.W, NUM_18PX.H, IR.NUM.DIGIT)
    return skin
end

return ir.functions