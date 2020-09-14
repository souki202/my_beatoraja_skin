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
            X = function (self) return 258 - 74 end,
            Y = function (self) return 702 - 76 end,
        },
        GR = {
            X = function (self) return self.AREA.PF.X(self) + 90.5 * 2 end,
            Y = function (self) return self.AREA.PF.Y(self) - 90.5 * 2 end,
        },
        GD = {
            -- 61はサイズ差
            X = function (self) return self.AREA.GR.X(self) - 242 - 61 end,
            Y = function (self) return self.AREA.GR.Y(self) - 60 + 61 end,
        },
        BD = {
            X = function (self) return self.AREA.GD.X(self) + 120 end,
            Y = function (self) return self.AREA.GD.Y(self) - 120 end,
        },
        PR = {
            X = function (self) return self.AREA.BD.X(self) + 120 end,
            Y = function (self) return self.AREA.BD.Y(self) - 120 end,
        },
    },
    LABEL = {
        X = function (self, arrayLabel) return self.AREA[arrayLabel].X(self) + (self.AREA.W - self.LABEL.W) / 2 end,
        -- +48は文字画像の余白
        Y = function (self, arrayLabel, isSmall)
            local cy = self.AREA[arrayLabel].Y(self) + self.AREA.H / 2
            if isSmall then
                return cy + 22 - self.LABEL.SMALL_SPACE
            else
                return cy + 24 - self.LABEL.LARGE_SPACE
            end
        end,
        LARGE_SPACE = 48,
        SMALL_SPACE = 52,
        W = 256,
        H = 128,
    },
    NUM = {
        X = function (self, arrayLabel, isSmall)
            local cx = self.AREA[arrayLabel].X(self) + self.AREA.W / 2
            if isSmall then
                return cx - self.NUM.DIGIT * (self.NUM.SMALL.W + self.NUM.SMALL.SPACE) / 2 - 4
            else
                return cx - self.NUM.DIGIT * (self.NUM.LARGE.W + self.NUM.LARGE.SPACE) / 2 - 7
            end
        end,
        Y = function (self, arrayLabel, isSmall)
            local cy = self.AREA[arrayLabel].Y(self) + self.AREA.H / 2
            if isSmall then
                return cy - 55
            else
                return cy - 81
            end
        end,
        MISS = {
            X = function (self, arrayLabel, isSmall)
                local cx = self.AREA[arrayLabel].X(self) + self.AREA.W / 2
                if isSmall then
                    return cx - self.NUM.DIGIT * (self.NUM.SMALL.W + self.NUM.SMALL.SPACE) / 2 / 2 + 2
                else
                    return cx - self.NUM.DIGIT * (self.NUM.LARGE.W + self.NUM.LARGE.SPACE) / 2 / 2 + 2
                end
            end,
            Y = function (self, arrayLabel, isSmall)
                local cy = self.AREA[arrayLabel].Y(self) + self.AREA.H / 2
                if isSmall then
                    return cy - 85
                else
                    return cy - 118
                end
            end,
        },
        DIGIT = 5,
        LARGE = {
            W = 46,
            H = 63,
            SPACE = -5
        },
        SMALL = {
            W = 34,
            H = 46,
            SPACE = -4
        },
        VERY_SMALL = {
            W = 26,
            H = 36,
            SPACE = -3
        },
    },
}

judges.functions.getLargeNumSize = function ()
    return JUDGES.NUM.LARGE
end

judges.functions.getSmallNumSize = function ()
    return JUDGES.NUM.SMALL
end

judges.functions.getVerySmallNumSize = function ()
    return JUDGES.NUM.VERY_SMALL
end

judges.functions.getLabelSize = function ()
    return {W = JUDGES.LABEL.W, H = JUDGES.LABEL.H}
end

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
        do
            local size = JUDGES.NUM.LARGE
            if i >= 3 then -- GOOD以降は小さいもの
                size = JUDGES.NUM.SMALL
            end
            vals[#vals+1] = {
                id = "judge" .. JUDGES.IDS[i] .. "Num", src = 150 + (i - 1), x = 0, y = 0, w = size.W * 10, h = size.H, divx = 10, align = 2, digit = 5, space = size.SPACE, ref = 110 + (i - 1)
            }
            -- missの分の画像
            if i == #JUDGES.IDS then
                vals[#vals+1] = {
                    id = "judge" .. JUDGES.IDS[i] .. "Num", src = 150 + (i - 1), x = 0, y = 0, w = size.W * 10, h = size.H, divx = 10, align = 2, digit = 5, space = size.SPACE, ref = 420
                }
            end
        end
    end
    return skin
end

judges.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    for i = 1, #JUDGES.IDS do
        local aryLabel = JUDGES.ARRAY_LABELS[i]
        local isSmall = i >= 3
        -- 背景
        dst[#dst+1] = {
            id = "judge" .. JUDGES.IDS[i] .. "Bg", dst = {
                {x = JUDGES.AREA[aryLabel].X(JUDGES), y = JUDGES.AREA[aryLabel].Y(JUDGES), w = JUDGES.AREA.W, h = JUDGES.AREA.H}
            },
        }
        -- ラベル
        dst[#dst+1] = {
            id = "judge" .. JUDGES.IDS[i] .. "Label", dst = {
                {x = JUDGES.LABEL.X(JUDGES, aryLabel), y = JUDGES.LABEL.Y(JUDGES, aryLabel, isSmall), w = JUDGES.LABEL.W, h = JUDGES.LABEL.H}
            },
        }
        do
            local size = JUDGES.NUM.LARGE
            if i >= 3 then -- GOOD以降は小さいもの
                size = JUDGES.NUM.SMALL
            end
            -- 値
            dst[#dst+1] = {
                id = "judge" .. JUDGES.IDS[i] .. "Num", dst = {
                    {x = JUDGES.NUM.X(JUDGES, aryLabel, isSmall), y = JUDGES.NUM.Y(JUDGES, aryLabel, isSmall), w = size.W, h = size.H}
                }
            }
            -- poorのときだけmissの分を描画
            if i == #JUDGES.IDS then
                dst[#dst+1] = {
                    id = "judge" .. JUDGES.IDS[i] .. "Num", filter = 1, dst = {
                        {x = JUDGES.NUM.MISS.X(JUDGES, aryLabel, isSmall), y = JUDGES.NUM.MISS.Y(JUDGES, aryLabel, isSmall), w = size.W / 2, h = size.H / 2}
                    }
                }
            end
        end
    end
    return skin
end

return judges.functions