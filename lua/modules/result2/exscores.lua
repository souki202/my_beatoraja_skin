local main_state = require("main_state")

local exscores = {
    functions = {}
}

local EXSCORES = {
    IDS = {"Exscore", "Combo", "IrPlayer"},
    AREA = {
        X = function (self, idx) return 992 + self.AREA.INTERVAL_X * (idx - 1) end,
        Y = function (self, idx) return 358 + self.AREA.INTERVAL_Y * (idx - 1) end,
        W = 1024,
        H = 128,
        INTERVAL_X = 64,
        INTERVAL_Y = -116,
    },
    LABEL = {
        X = function (self, idx) return self.AREA.X(self, idx) end,
        Y = function (self, idx) return self.AREA.Y(self, idx) end,
        W = 512,
        H = 128,
    },
    EX_NUM = {
        X = function (self, idx) return self.AREA.X(self, idx) + 666 - (self.EX_NUM.W + self.EX_NUM.SPACE) * 5 end,
        Y = function (self, idx) return self.AREA.Y(self, idx) + 10 end,
        W = 72,
        H = 103,
        SPACE = -7,
    },
    OTHER_NUM = {
        X = function (self, idx) return self.AREA.X(self, idx) + 666 - (self.OTHER_NUM.W + self.OTHER_NUM.SPACE) * 5 end,
        Y = function (self, idx) return self.AREA.Y(self, idx) + 10 end,
        W = 46,
        H = 63,
        SPACE = -7,

        IR = {
            SLUSH = {
                X = function (self, idx) return self.OTHER_NUM.X(self, idx) - 35 end,
                Y = function (self, idx) return self.OTHER_NUM.Y(self, idx) end,
            },
            RANK = {
                X = function (self, idx) return self.OTHER_NUM.IR.SLUSH.X(self, idx) - (self.OTHER_NUM.W + self.OTHER_NUM.SPACE) * 5 + 2 end,
                Y = function (self, idx) return self.OTHER_NUM.IR.SLUSH.Y(self, idx) end,
            }
        }
    },
    IR = {
        LOADING = {
            X = function (self, idx) return self.OTHER_NUM.X(self, idx) + (self.OTHER_NUM.W + self.OTHER_NUM.SPACE) * 5 + 15 end,
            Y = function (self, idx) return self.OTHER_NUM.IR.SLUSH.Y(self, idx) + 6 end,
            W = 50,
            H = 50,
            MIN_A = 64,
            DIV_X = 12,
            ANIM = {
                TIME = 500,
                DURATION = 100,
            }
        }
    },
}

exscores.functions.load = function ()
    local skin = {
        image = {},
        value = {},
    }
    local imgs = skin.image
    local vals = skin.value

    local refs = {71, 75, 180}
    for i = 1, #EXSCORES.IDS do
        -- 項目の背景
        imgs[#imgs+1] = {
            id = "largeValue" .. EXSCORES.IDS[i] .. "Bg", src = 160 + 3 * (i - 1), x = 0, y = 0, w = -1, h = -1
        }
        imgs[#imgs+1] = {
            id = "largeValue" .. EXSCORES.IDS[i] .. "Label", src = 161 + 3 * (i - 1), x = 0, y = 0, w = -1, h = -1
        }

        -- 数値読み込み
        do
            local size = EXSCORES.OTHER_NUM
            if i == 1 then
                size = EXSCORES.EX_NUM
            end
            vals[#vals+1] = {
                id = "largeValue" .. EXSCORES.IDS[i] .. "Value", src = 162 + 3 * (i - 1), x = 0, y = 0, w = size.W * 10, h = size.H, divx = 10, digit = 5, space = size.SPACE, ref = refs[i]
            }
            -- irは順位も読み込む
            if i == #EXSCORES.IDS then
                vals[#vals+1] = {
                    id = "largeValue" .. EXSCORES.IDS[i] .. "RankValue", src = 162 + 3 * (i - 1), x = 0, y = 0, w = size.W * 10, h = size.H, divx = 10, digit = 5, space = size.SPACE, ref = 179
                }
            end
        end
    end

    -- IRのプレイヤーと順位区切り用スラッシュ
    imgs[#imgs+1] = {
        id = "largeValueIrSlash", src = 168, x = 598, y = 0, w = EXSCORES.OTHER_NUM.W, h = EXSCORES.OTHER_NUM.H
    }

    -- IR接続中アイコン
    for i = 1, EXSCORES.IR.LOADING.DIV_X, 1 do
        imgs[#imgs+1] = {
            id = "irLoadingIcon" .. i, src = 169, x = EXSCORES.IR.LOADING.W * (i - 1), y = 0, w = EXSCORES.IR.LOADING.W, h = EXSCORES.IR.LOADING.H
        }
    end

    return skin
end

exscores.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    local isConnecting = function ()
        return main_state.timer(173) <= 0 and main_state.timer(174) <= 0 
    end

    for i = 1, #EXSCORES.IDS do
        dst[#dst+1] = {
            id = "largeValue" .. EXSCORES.IDS[i] .. "Bg", dst = {
                {x = EXSCORES.AREA.X(EXSCORES, i), y = EXSCORES.AREA.Y(EXSCORES, i), w = EXSCORES.AREA.W, h = EXSCORES.AREA.H}
            }
        }
        dst[#dst+1] = {
            id = "largeValue" .. EXSCORES.IDS[i] .. "Label", dst = {
                {x = EXSCORES.LABEL.X(EXSCORES, i), y = EXSCORES.LABEL.Y(EXSCORES, i), w = EXSCORES.LABEL.W, h = EXSCORES.LABEL.H}
            }
        }
        do
            local numParam = EXSCORES.OTHER_NUM
            if i == 1 then
                numParam = EXSCORES.EX_NUM
            end
            dst[#dst+1] = {
                id = "largeValue" .. EXSCORES.IDS[i] .. "Value", dst = {
                    {x = numParam.X(EXSCORES, i), y = numParam.Y(EXSCORES, i), w = numParam.W, h = numParam.H}
                }
            }
            -- IR時はスラッシュと現在順位出力
            if i == #EXSCORES.IDS then
                dst[#dst+1] = {
                    id = "largeValueIrSlash", dst = {
                        {x = EXSCORES.OTHER_NUM.IR.SLUSH.X(EXSCORES, i), y = EXSCORES.OTHER_NUM.IR.SLUSH.Y(EXSCORES, i), w = numParam.W, h = numParam.H}
                    }
                }
                dst[#dst+1] = {
                    id = "largeValue" .. EXSCORES.IDS[i] .. "RankValue", dst = {
                        {x = EXSCORES.OTHER_NUM.IR.RANK.X(EXSCORES, i), y = EXSCORES.OTHER_NUM.IR.RANK.Y(EXSCORES, i), w = numParam.W, h = numParam.H}
                    }
                }

                -- 接続中表示
                local sumAnimTime = EXSCORES.IR.LOADING.ANIM.DURATION * EXSCORES.IR.LOADING.DIV_X
                for j = 1, EXSCORES.IR.LOADING.DIV_X, 1 do
                    local dt = EXSCORES.IR.LOADING.ANIM.DURATION * (j - 1)
                    dst[#dst+1] = {
                        id = "irLoadingIcon" .. j, draw = isConnecting, loop = dt, dst = {
                            {time = 0, x = EXSCORES.IR.LOADING.X(EXSCORES, i), y = EXSCORES.IR.LOADING.Y(EXSCORES, i), w = EXSCORES.IR.LOADING.W, h = EXSCORES.IR.LOADING.H, a = 255},
                            {time = dt},
                            {time = dt + EXSCORES.IR.LOADING.ANIM.TIME / 2, a = EXSCORES.IR.LOADING.MIN_A},
                            {time = dt + EXSCORES.IR.LOADING.ANIM.TIME, a = 255},
                            {time = dt + sumAnimTime},
                        }
                    }
                end
            end
        end
    end
    return skin
end

return exscores.functions