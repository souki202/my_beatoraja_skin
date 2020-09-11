require("modules.result.commons")
local main_state = require("main_state")

local judges = {
    functions = {}
}

local JUDGES = {
    IDS = {"Perfect", "Great", "Good", "Bad", "Poor"},
    ARRAY_LABELS = {"PF", "GR", "GD", "BD", "PR"},

    AREA = {
        W = 512,
        H = 512,
        PF = {
            X = function (self) return 281 - 74 end,
            Y = function (self) return 645 - 76 end,
        },
        GR = {
            X = function (self) return self.AREA.PF.X(self) + 90.5 * 2 end,
            Y = function (self) return self.AREA.PF.Y(self) - 90.5 * 2 end,
        },
        GD = {
            X = function (self) return self.AREA.GR.X(self) - 90.5 * 3 end,
            Y = function (self) return self.AREA.GR.Y(self) - 90.5 end,
        },
        BD = {
            X = function (self) return self.AREA.GD.X(self) + 90.5 * 2 end,
            Y = function (self) return self.AREA.GD.Y(self) - 90.5 * 2 end,
        },
        PR = {
            X = function (self) return self.AREA.BD.X(self) - 90.5 * 3 end,
            Y = function (self) return self.AREA.BD.Y(self) - 90.5 end,
        },
    },
    LABEL = {
        X = function (self, arrayLabel) return self.AREA[arrayLabel].X(self) + (self.AREA.W - self.LABEL.W) / 2 end,
        -- +48は文字画像の余白
        Y = function (self, arrayLabel) return self.AREA[arrayLabel].Y(self) + self.AREA.H / 2 + 24 - 48 end,
        W = 256,
        H = 128,
    },
    NUM = {
        X = function (self, arrayLabel) return self.AREA[arrayLabel].X(self) + self.AREA.W / 2 - self.NUM.DIGIT * self.NUM.INTERVAL / 2 - 7 end,
        Y = function (self, arrayLabel) return self.AREA[arrayLabel].Y(self) + self.AREA.H / 2 - 81 end,
        MISS = {
            X = function (self, arrayLabel) return self.AREA[arrayLabel].X(self) + self.AREA.W / 2 - self.NUM.DIGIT * self.NUM.INTERVAL / 2 / 2 + 6 end,
            Y = function (self, arrayLabel) return self.AREA[arrayLabel].Y(self) + self.AREA.H / 2 - 118 end,
        },
        DIGIT = 5,
        W = 46,
        H = 63,
        INTERVAL = 36,
    },
}

judges.functions.load = function ()
    local skin = {image = {}, value = {}}
    local imgs = skin.image
    local vals = skin.value

    for i = 1, #JUDGES.IDS do
        imgs[#imgs+1] = {
            id = "judge" .. JUDGES.IDS[i] .. "Bg", src = 130 + (i - 1), x = 0, y = 0, w = -1, h = -1
        }
        imgs[#imgs+1] = {
            id = "judge" .. JUDGES.IDS[i] .. "Label", src = 140 + (i - 1), x = 0, y = 0, w = -1, h = -1
        }
        vals[#vals+1] = {
            id = "judge" .. JUDGES.IDS[i] .. "Num", src = 150 + (i - 1), x = 0, y = 0, w = JUDGES.NUM.W * 10, h = JUDGES.NUM.H, divx = 10, align = 2, digit = 5, space = JUDGES.NUM.INTERVAL - JUDGES.NUM.W, ref = 110 + (i - 1)
        }
        -- missの分の画像
        if i == #JUDGES.IDS then
            vals[#vals+1] = {
                id = "judge" .. JUDGES.IDS[i] .. "Num", src = 150 + (i - 1), x = 0, y = 0, w = JUDGES.NUM.W * 10, h = JUDGES.NUM.H, divx = 10, align = 2, digit = 5, space = JUDGES.NUM.INTERVAL - JUDGES.NUM.W, ref = 420
            }
        end
    end
    return skin
end

judges.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    for i = 1, #JUDGES.IDS do
        local aryLabel = JUDGES.ARRAY_LABELS[i]
        -- 背景
        dst[#dst+1] = {
            id = "judge" .. JUDGES.IDS[i] .. "Bg", dst = {
                {x = JUDGES.AREA[aryLabel].X(JUDGES), y = JUDGES.AREA[aryLabel].Y(JUDGES), w = JUDGES.AREA.W, h = JUDGES.AREA.H}
            },
        }
        -- ラベル
        dst[#dst+1] = {
            id = "judge" .. JUDGES.IDS[i] .. "Label", dst = {
                {x = JUDGES.LABEL.X(JUDGES, aryLabel), y = JUDGES.LABEL.Y(JUDGES, aryLabel), w = JUDGES.LABEL.W, h = JUDGES.LABEL.H}
            },
        }
        -- 値
        dst[#dst+1] = {
            id = "judge" .. JUDGES.IDS[i] .. "Num", dst = {
                {x = JUDGES.NUM.X(JUDGES, aryLabel), y = JUDGES.NUM.Y(JUDGES, aryLabel), w = JUDGES.NUM.W, h = JUDGES.NUM.H}
            }
        }
        -- poorのときだけmissの分を描画
        if i == #JUDGES.IDS then
            dst[#dst+1] = {
                id = "judge" .. JUDGES.IDS[i] .. "Num", filter = 1, dst = {
                    {x = JUDGES.NUM.MISS.X(JUDGES, aryLabel), y = JUDGES.NUM.MISS.Y(JUDGES, aryLabel), w = JUDGES.NUM.W / 2, h = JUDGES.NUM.H / 2}
                }
            }
        end
    end
    return skin
end

return judges.functions