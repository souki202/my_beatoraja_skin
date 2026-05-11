require("modules.commons.define")
require("modules.commons.my_window")
require("modules.commons.numbers")
require("modules.commons.position")
local commons = require("modules.select.commons")

local musicInfo = {
    functions = {}
}

local LEVEL_NAME_TABLE = {"Beginner", "Normal", "Hyper", "Another", "Insane"}

-- スコア詳細
local SCORE_INFO = {
    TEXT_W = 168,
    TEXT_H = 22,
    DIGIT = 8,
}

-- exscoreと楽曲難易度周り
local EXSCORE_AREA = {
    WND = {
        X = 72,
        Y = 298
    },
    NUMBER_W = 22,
    NUMBER_H = 30,
    TEXT_X = 315,
    NUMBER_X = 582,
    Y = 385,
    NEXT_Y = 348,

    RANKING_NUMBER_W = commons.NUM_28PX.W,
    RANKING_NUMBER_H = commons.NUM_28PX.H,
    IR = {
        Y = 311,
        W = 26,
        H = 22,
        NUM = {
            W = 11,
            H = 15,
        }
    },
    RATE = {
        X = function (self) return self.WND.X + 242 end,
        Y = function (self) return self.WND.Y + 50 end,
        NUM = {
            X = function (self) return self.RATE.X(self) + 165 end,
            X_DOT = function (self) return self.RATE.NUM.X(self) + 47 end,
            X_AF_DOT = function (self) return self.RATE.NUM.X_DOT(self) + 7 end,
            X_PERCENT = function (self) return self.RATE.NUM.X_AF_DOT(self) + 30 end,
            Y_SYMBOL = function (self) return self.RATE.Y(self) - 6 end,
        },
        NUM_SYMBOL_SIZE = 24,
    },
}

local RIVAL = {
    NAME_X   = 315,
    PLAYER_Y = 385,
    RIVAL_Y  = 343,

    FONT_SIZE = 24,
    MAX_W = 178,
}

local SCORE_RANK = {
    SRC_X = 1653,
    W = 133,
    H = 59,
    X = 625,
    Y = 364,
}

-- 左下のレベルが並んでいる部分
-- local LARGE_LEVEL = {
--     NUMBER_H = 40,
--     NUMBER_W = 30,
--     X = 140,
--     Y = 305,
--     INTERVAL = 136,
--     DOT_SIZE = 12,

--     ICON_W = 105,
--     SRC_X = 1128,
--     NONACTIVE_ICON_H = 82,
--     ACTIVE_ICON_H = 75,
--     ACTIVE_TEXT_H = 31,
--     ICON_X = 102,
--     ICON_Y = 348,
-- }

local DENSITY_INFO = {
    SRC_X = 1788,
    SRC_Y = 242,
    BASE_Y = 385,

    TEXT_W = 108,
    TEXT_H = 31,

    NUMBER_X = 243,
    NUMBER_Y = 305,
    NUMBER_W = 15,
    NUMBER_H = 21,

    ICON_W = 106,
    ICON_H = 30,
    ICON_X = 83,
    ICON_Y = 346,

    DOT_SIZE = 7,

    DIFFICULTY_ICON_X = 83,
    DIFFICULTY_ICON_Y = 348 - 2; -- ICON_Y - 2
    DIFFICULTY_NUMBER_X = 125,

    START_Y = 394,
    INTERVAL_Y = 38,
}

musicInfo.functions.load = function ()
    local skin = {
        image = {
            -- IR用文字画像
            {id = "irRankingText", src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + 22 * 4, w = EXSCORE_AREA.IR.W, h = EXSCORE_AREA.IR.H},
            -- ランキング用スラッシュ(同じ)
            {id = "slashForRanking", src = 0, x = commons.NUM_28PX.SRC_X + commons.NUM_28PX.W * 11, y = commons.NUM_28PX.SRC_Y, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H},
            -- EXSCOREの文字画像はselect.lua側で 各種ステータス用数値(パーツ共通) 部分
            -- SCORE RATE
            {id = "scoreRateText", src = 0, x = 1298, y = commons.PARTS_OFFSET + 511, w = SCORE_INFO.TEXT_W, h = SCORE_INFO.TEXT_H},
        },
        value = {
            -- exscore用
            {id = "richExScore",  src = 0, x = 771, y = commons.PARTS_OFFSET + 347, w = EXSCORE_AREA.NUMBER_W * 10, h = EXSCORE_AREA.NUMBER_H, divx = 10, digit = 5, ref = 71, align = 0},
            {id = "rivalExScore", src = 0, x = 771, y = commons.PARTS_OFFSET + 347, w = EXSCORE_AREA.NUMBER_W * 10, h = EXSCORE_AREA.NUMBER_H, divx = 10, digit = 5, ref = 271, align = 0},
            -- IR(EXSCORE周辺の表示)
            {id = "irRanking"         , src = 0, x = commons.NUM_28PX.SRC_X, y = commons.NUM_28PX.SRC_Y, w = commons.NUM_28PX.W*10, h = commons.NUM_28PX.H, divx = 10, digit = 5, ref = 179, align = 0},
            {id = "irPlayerForRanking", src = 0, x = commons.NUM_28PX.SRC_X, y = commons.PARTS_OFFSET + 89, w = EXSCORE_AREA.IR.NUM.W * 10, h = EXSCORE_AREA.IR.NUM.H, divx = 10, digit = 5, ref = 200, align = 0},
            -- score rate
            {id = "scoreRateValue", src = 0, x = commons.NUM_28PX.SRC_X, y = commons.NUM_28PX.SRC_Y, w = commons.NUM_28PX.W*10, h = commons.NUM_28PX.H, divx = 10, digit = 3, ref = 102, align = 0},
            {id = "scoreRateAfterDot", src = 0, x = commons.NUM_28PX.SRC_X, y = commons.NUM_28PX.SRC_Y, w = commons.NUM_28PX.W*10, h = commons.NUM_28PX.H, divx = 10, digit = 2, ref = 103, align = 0, padding = 1},
        },
        text = {
            {id = "playerName", font = 0, size = RIVAL.FONT_SIZE, align = 0, ref = 2, overflow = 1},
            {id = "rivalName" , font = 0, size = RIVAL.FONT_SIZE, align = 0, ref = 1, overflow = 1},
            {id = "24dot", font = 0, size = EXSCORE_AREA.RATE.NUM_SYMBOL_SIZE, constantText = "."},
            {id = "24percent", font = 0, size = EXSCORE_AREA.RATE.NUM_SYMBOL_SIZE, constantText = "%"},
        }
    }
    local imgs = skin.image
    local vals = skin.value

    local densities = {"Average", "End", "Peak"}
    imgs[#imgs+1] = {
        id = "densityDot", src = 0, x = 946 + 150, y = commons.PARTS_OFFSET, w = DENSITY_INFO.NUMBER_W, h = DENSITY_INFO.NUMBER_H
    }
    for i = 1, #densities do
        local d = densities[i]
        imgs[#imgs+1] = {
            id = "density" .. d .. "Icon", src = 0, x = DENSITY_INFO.SRC_X, y = commons.PARTS_OFFSET + DENSITY_INFO.SRC_Y + DENSITY_INFO.ICON_H * (i - 1), w = DENSITY_INFO.ICON_W, h = DENSITY_INFO.ICON_H
        }
        if i == 3 then
            vals[#vals+1] = {
                id = "density" .. d .. "Number", src = 0, x = 946, y = commons.PARTS_OFFSET, w = DENSITY_INFO.NUMBER_W * 10, h = DENSITY_INFO.NUMBER_H, divx = 10, digit = 2, ref = 364 - 2 * (i - 1), align = 2
            }
        else
            vals[#vals+1] = {
                id = "density" .. d .. "Number", src = 0, x = 946, y = commons.PARTS_OFFSET, w = DENSITY_INFO.NUMBER_W * 10, h = DENSITY_INFO.NUMBER_H, divx = 10, digit = 2, ref = 364 - 2 * (i - 1), align = 0
            }
        end
        vals[#vals+1] = {
            id = "density" .. d .. "AfterDot"  , src = 0, x = 946, y = commons.PARTS_OFFSET, w = DENSITY_INFO.NUMBER_W * 10, h = DENSITY_INFO.NUMBER_H, divx = 10, digit = 2, ref = 365 - 2 * (i - 1), align = 1, padding = 1
        }
    end

    -- ランク
    -- local ranks = {"Max", "Aaa", "Aa", "a", "b", "c", "d", "e", "f"}
    local ranks = {"Aaa", "Aa", "A", "B", "C", "D", "E", "F"}
    for i, rank in ipairs(ranks) do
        imgs[#imgs+1] = {
            id = "rank" .. rank, src = 0,
            x = SCORE_RANK.SRC_X, y = commons.PARTS_OFFSET + SCORE_RANK.H * i,
            w = SCORE_RANK.W, h = SCORE_RANK.H
        }
    end
    return skin
end

musicInfo.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    local ranks = {"Aaa", "Aa", "A", "B", "C", "D", "E", "F"}

    -- 密度部分
    local types = {"Average", "End", "Peak"}

    for i = 1, 3 do
        local baseY = DENSITY_INFO.BASE_Y - DENSITY_INFO.INTERVAL_Y * (i - 1)
        -- アイコン部分
        dst[#dst+1] = {
            id = "density" ..  types[i] .. "Icon", op = {2}, dst = {
                {x = DENSITY_INFO.ICON_X, y = baseY, w = DENSITY_INFO.ICON_W, h = DENSITY_INFO.ICON_H}
            }
        }

        local offsetX = 30
        if types[i] == "Peak" then
            -- offsetX = 83
        end

        -- 整数部分
        dst[#dst+1] = {
            id = "density" ..  types[i] .. "Number", op = {2}, dst = {
                {x = DENSITY_INFO.NUMBER_X - offsetX, y = baseY + 5, w = DENSITY_INFO.NUMBER_W, h = DENSITY_INFO.NUMBER_H}
            }
        }
        -- peakは小数点以下が現在は表示できないので出さない
        if types[i] ~= "Peak" then
            -- dot
            dst[#dst+1] = {
                id = "densityDot", op = {2}, dst = {
                    {x = DENSITY_INFO.NUMBER_X, y = baseY + 5, w = DENSITY_INFO.NUMBER_W, h = DENSITY_INFO.NUMBER_H}
                }
            }
            -- 小数点以下
            dst[#dst+1] = {
                id = "density" ..  types[i] .. "AfterDot", op = {2}, dst = {
                    {x = DENSITY_INFO.NUMBER_X + DENSITY_INFO.DOT_SIZE, y = baseY + 5, w = DENSITY_INFO.NUMBER_W, h = DENSITY_INFO.NUMBER_H}
                }
            }
        end
    end

    -- ランク出力
    for i, rank in ipairs(ranks) do
        dst[#dst+1] = {
            id = "rank" .. rank, op = {{2, 3}, 200 + (i - 1)}, dst = {
                {x = SCORE_RANK.X, y = SCORE_RANK.Y, w = SCORE_RANK.W, h = SCORE_RANK.H}
            }
        }
    end

    -- exscoreとnext
    dst[#dst+1] = {
        id = "exScoreTextImg", op = {624}, dst = {
            {x = EXSCORE_AREA.TEXT_X, y = EXSCORE_AREA.Y, w = SCORE_INFO.TEXT_W, h = SCORE_INFO.TEXT_H}
        }
    }
    dst[#dst+1] = {
        id = "richExScore", op = {624}, dst = {
            {x = EXSCORE_AREA.NUMBER_X - EXSCORE_AREA.NUMBER_W * 5, y = EXSCORE_AREA.Y, w = EXSCORE_AREA.NUMBER_W, h = EXSCORE_AREA.NUMBER_H}
        }
    }
    if isShowScoreRate() then
        dst[#dst+1] = {
            id = "scoreRateText", op = {624}, dst = {
                {x = EXSCORE_AREA.RATE.X(EXSCORE_AREA), y = EXSCORE_AREA.RATE.Y(EXSCORE_AREA) - 2, w = SCORE_INFO.TEXT_W, h = SCORE_INFO.TEXT_H}
            }
        }
        dst[#dst+1] = {
            id = "scoreRateValue", op = {624}, dst = {
                {x = EXSCORE_AREA.RATE.NUM.X(EXSCORE_AREA), y = EXSCORE_AREA.RATE.Y(EXSCORE_AREA), w = commons.NUM_28PX.W, h = commons.NUM_28PX.H}
            }
        }
        dst[#dst+1] = {
            id = "24dot", op = {624, -100, -1, -1030}, dst = {
                {x = EXSCORE_AREA.RATE.NUM.X_DOT(EXSCORE_AREA), y = EXSCORE_AREA.RATE.NUM.Y_SYMBOL(EXSCORE_AREA), w = 24, h = EXSCORE_AREA.RATE.NUM_SYMBOL_SIZE, r = 0, g = 0, b = 0}
            }
        }
        dst[#dst+1] = {
            id = "scoreRateAfterDot", op = {624}, dst = {
                {x = EXSCORE_AREA.RATE.NUM.X_AF_DOT(EXSCORE_AREA), y = EXSCORE_AREA.RATE.Y(EXSCORE_AREA), w = commons.NUM_28PX.W, h = commons.NUM_28PX.H}
            }
        }
        dst[#dst+1] = {
            id = "24percent", op = {624, -100, -1, -1030}, dst = {
                {x = EXSCORE_AREA.RATE.NUM.X_PERCENT(EXSCORE_AREA), y = EXSCORE_AREA.RATE.NUM.Y_SYMBOL(EXSCORE_AREA), w = 32, h = EXSCORE_AREA.RATE.NUM_SYMBOL_SIZE, r = 0, g = 0, b = 0}
            }
        }
    else
        dst[#dst+1] = {
            id = "nextRankTextImg", op = {624}, dst = {
                {x = EXSCORE_AREA.TEXT_X, y = EXSCORE_AREA.NEXT_Y, w = SCORE_INFO.TEXT_W, h = SCORE_INFO.TEXT_H}
            }
        }
        dst[#dst+1] = {
            id = "nextRank", op = {624}, dst = {
                {x = EXSCORE_AREA.NUMBER_X - commons.NUM_28PX.W * SCORE_INFO.DIGIT, y = EXSCORE_AREA.NEXT_Y, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H}
            }
        }
    end
    dst[#dst+1] = {
        id = "irRankingText", dst = {
            {x = EXSCORE_AREA.TEXT_X, y = EXSCORE_AREA.IR.Y, w = EXSCORE_AREA.IR.W, h = EXSCORE_AREA.IR.H}
        }
    }
    dst[#dst+1] = {
        id = "irRanking", dst = {
            {x = EXSCORE_AREA.NUMBER_X - EXSCORE_AREA.IR.NUM.W * 5 - commons.NUM_28PX.W * 6, y = EXSCORE_AREA.IR.Y, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H}
        }
    }
    dst[#dst+1] = {
        id = "slashForRanking", op = {-606}, dst = {
            {x = EXSCORE_AREA.NUMBER_X - EXSCORE_AREA.IR.NUM.W * 5 - commons.NUM_28PX.W * 1, y = EXSCORE_AREA.IR.Y, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H}
        }
    }
    dst[#dst+1] = {
        id = "irPlayerForRanking", dst = {
            {x = EXSCORE_AREA.NUMBER_X - EXSCORE_AREA.IR.NUM.W * 5, y = EXSCORE_AREA.IR.Y, w = EXSCORE_AREA.IR.NUM.W, h = EXSCORE_AREA.IR.NUM.H}
        }
    }
    -- ライバル名とexScore
    dst[#dst+1] = {
        id = "playerName", op = {625}, dst = {
            {x = RIVAL.NAME_X, y = RIVAL.PLAYER_Y - 4, w = RIVAL.MAX_W, h = RIVAL.FONT_SIZE, r = 0, g = 0, b = 0}
        }
    }
    dst[#dst+1] = {
        id = "richExScore", op = {625}, dst = {
            {x = EXSCORE_AREA.NUMBER_X - EXSCORE_AREA.NUMBER_W * 5, y = RIVAL.PLAYER_Y, w = EXSCORE_AREA.NUMBER_W, h = EXSCORE_AREA.NUMBER_H}
        }
    }
    dst[#dst+1] = {
        id = "rivalName", op = {625}, dst = {
            {x = RIVAL.NAME_X, y = RIVAL.RIVAL_Y - 4, w = RIVAL.MAX_W, h = RIVAL.FONT_SIZE, r = 0, g = 0, b = 0}
        }
    }
    dst[#dst+1] = {
        id = "rivalExScore", op = {625}, dst = {
            {x = EXSCORE_AREA.NUMBER_X - EXSCORE_AREA.NUMBER_W * 5, y = RIVAL.RIVAL_Y, w = EXSCORE_AREA.NUMBER_W, h = EXSCORE_AREA.NUMBER_H}
        }
    }

    return skin
end

return musicInfo.functions