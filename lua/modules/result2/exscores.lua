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
        Y = function (self, idx) return self.AREA.Y(self, idx) + 16 end,
        W = 61,
        H = 92,
        SPACE = 3,
    },
    OTHER_NUM = {
        X = function (self, idx) return self.AREA.X(self, idx) + 666 - (self.OTHER_NUM.W + self.OTHER_NUM.SPACE) * 5 end,
        Y = function (self, idx) return self.AREA.Y(self, idx) + 16 end,
        W = 35,
        H = 50,
        SPACE = 2,

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
}

exscores.functions.load = function ()
    local skin = {image = {}, value = {}}
    local imgs = skin.image
    local vals = skin.value

    local refs = {71, 75, 180}
    for i = 1, #EXSCORES.IDS do
        imgs[#imgs+1] = {
            id = "largeValue" .. EXSCORES.IDS[i] .. "Bg", src = 160 + 3 * (i - 1), x = 0, y = 0, w = -1, h = -1
        }
        imgs[#imgs+1] = {
            id = "largeValue" .. EXSCORES.IDS[i] .. "Label", src = 161 + 3 * (i - 1), x = 0, y = 0, w = -1, h = -1
        }

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
        id = "largeValueIrSlash", src = 168, x = EXSCORES.OTHER_NUM.W * 11, y = 0, w = EXSCORES.OTHER_NUM.W, h = EXSCORES.OTHER_NUM.H
    }

    return skin
end

exscores.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

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
            end
        end
    end
    return skin
end

return exscores.functions