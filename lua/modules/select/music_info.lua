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
    TEXT_X = 802,
    NUMBER_X = 1070,
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
        X = function (self) return self.WND.X + 730 end,
        Y = function (self) return self.WND.Y + 50 end,
        NUM = {
            X = function (self) return self.RATE.X(self) + 165 end,
            X_DOT = function (self) return self.RATE.NUM.X(self) + 47 end,
            X_AF_DOT = function (self) return self.RATE.NUM.X_DOT(self) + 4 end,
            X_PERCENT = function (self) return self.RATE.NUM.X_AF_DOT(self) + 32 end,
            Y_SYMBOL = function (self) return self.RATE.Y(self) - 6 end,
        },
        NUM_SYMBOL_SIZE = 24,
    },
}

local RIVAL = {
    NAME_X   = 802,
    PLAYER_Y = 385,
    RIVAL_Y  = 343,

    FONT_SIZE = 24,
    MAX_W = 178,
}

local SCORE_RANK = {
    SRC_X = 1653,
    W = 133,
    H = 59,
    X = 895,
    Y = 430,
}

-- 左下のレベルが並んでいる部分
local LARGE_LEVEL = {
    NUMBER_H = 40,
    NUMBER_W = 30,
    X = 140,
    Y = 305,
    INTERVAL = 136,
    DOT_SIZE = 12,

    ICON_W = 105,
    SRC_X = 1128,
    NONACTIVE_ICON_H = 82,
    ACTIVE_ICON_H = 75,
    ACTIVE_TEXT_H = 31,
    ICON_X = 102,
    ICON_Y = 348,
}

local DENSITY_INFO = {
    TEXT_W = 108,
    TEXT_H = 31,

    NUMBER_Y = 305,

    ICON_W = 105,
    ICON_H = 75,
    ICON_Y = 346,

    DOT_SIZE = 7,

    DIFFICULTY_ICON_X = 102,
    DIFFICULTY_TEXT_X = 100,
    DIFFICULTY_ICON_Y = 348 - 2; -- ICON_Y - 2
    DIFFICULTY_NUMBER_X = 125,

    START_X = 316,
    INTERVAL_X = 168,

    AFTER_DOT = {
        W = 16,
        H = 21,
    }
}

local MUSIC_INFO = {

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

    -- 難易度リストのアイコンの読み込み
    for i = 1, #LEVEL_NAME_TABLE do
        local d = LEVEL_NAME_TABLE[i]
        -- 非アクティブな難易度のアイコン
        imgs[#imgs+1] = {
            id = "nonActive" .. d .. "Icon" , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W * (i - 1), y = commons.PARTS_OFFSET, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.NONACTIVE_ICON_H
        }
        -- アクティブな難易度のアイコン周り
        imgs[#imgs+1] = {
            id = "active" .. d .. "Icon", src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W * (i - 1), y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H
        }
        imgs[#imgs+1] = {
            id = "active" .. d .. "Text", src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W * (i - 1), y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_TEXT_H
        }
        imgs[#imgs+1] = {
            id = "active" .. d .. "Note", src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W * (i - 1), y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_TEXT_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H
        }
        -- 難易度表記
        vals[#vals+1] = {
            id = "largeLevel" .. d  , src = 0, x = 771, y = commons.PARTS_OFFSET + 147 + LARGE_LEVEL.NUMBER_H * (i - 1), w = LARGE_LEVEL.NUMBER_W*10, h = LARGE_LEVEL.NUMBER_H, divx = 10, digit = 2, ref = 45 + (i - 1), align = 2
        }
    end

    local densities = {"Average", "End", "Peak"}
    for i = 1, #densities do
        local d = densities[i]
        imgs[#imgs+1] = {
            id = "density" .. d .. "Icon", src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W * i, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H
        }
        imgs[#imgs+1] = {
            id = "density" .. d .. "Note"   , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W * i, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_TEXT_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H
        }
        imgs[#imgs+1] = {
            id = "density" .. d .. "Text" , src = 0, x = 1788, y = commons.PARTS_OFFSET + DENSITY_INFO.TEXT_H * (i + 4), w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H
        }
        imgs[#imgs+1] = {
            id = "density" .. d .. "Dot", src = 0, x = 931, y = commons.PARTS_OFFSET + 35 + DENSITY_INFO.AFTER_DOT.H * i, w = DENSITY_INFO.DOT_SIZE, h = DENSITY_INFO.DOT_SIZE
        }
        if i == 3 then
            vals[#vals+1] = {
                id = "density" .. d .. "Number", src = 0, x = 771, y = commons.PARTS_OFFSET + 147 + LARGE_LEVEL.NUMBER_H * i, w = LARGE_LEVEL.NUMBER_W * 10, h = LARGE_LEVEL.NUMBER_H, divx = 10, digit = 2, ref = 364 - 2 * (i - 1), align = 2
            }
        else
            vals[#vals+1] = {
                id = "density" .. d .. "Number", src = 0, x = 771, y = commons.PARTS_OFFSET + 147 + LARGE_LEVEL.NUMBER_H * i, w = LARGE_LEVEL.NUMBER_W * 10, h = LARGE_LEVEL.NUMBER_H, divx = 10, digit = 2, ref = 364 - 2 * (i - 1), align = 0
            }
        end
        vals[#vals+1] = {
            id = "density" .. d .. "AfterDot"  , src = 0, x = 771, y = commons.PARTS_OFFSET + DENSITY_INFO.AFTER_DOT.H * (i + 1), w = DENSITY_INFO.AFTER_DOT.W * 10, h = DENSITY_INFO.AFTER_DOT.H, divx = 10, digit = 2, ref = 365 - 2 * (i - 1), align = 1, padding = 1
        }
    end
    -- density部分のdifficultyの読み込み
    for i = 1, #LEVEL_NAME_TABLE do
        local d = LEVEL_NAME_TABLE[i]
        imgs[#imgs+1] = {
            id = "densityDifficulty" .. d .. "Text", src = 0, x = 1788, y = commons.PARTS_OFFSET + DENSITY_INFO.TEXT_H * (i - 1), w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H
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

    -- レベルアイコン周り
    if getTableValue(skin_config.option, "曲情報表示形式", 935) == 935 then
        -- 難易度表示
        for i = 1, 5 do
            -- レベル表記
            dst[#dst+1] = {
                id = "largeLevel" .. LEVEL_NAME_TABLE[i], op = {150 + i}, dst = {
                    {x = LARGE_LEVEL.X + LARGE_LEVEL.INTERVAL * (i - 1) - 15, y = LARGE_LEVEL.Y, w = 30, h = 40}
                }
            }

            -- 非アクティブ時のレベルアイコン
            dst[#dst+1] = {
                id = "nonActive" .. LEVEL_NAME_TABLE[i] .. "Icon", op = {-150 - i}, dst = {
                    {x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y - (LARGE_LEVEL.NONACTIVE_ICON_H - LARGE_LEVEL.ACTIVE_ICON_H), w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.NONACTIVE_ICON_H}
                }
            }

            -- アクティブ時のレベルアイコン(背景)
            dst[#dst+1] = {
                id = "active" .. LEVEL_NAME_TABLE[i] .. "Icon", op = {150 + i}, dst = {
                    {x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y - 2, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H}
                }
            }

            -- アクティブ時のレベルアイコンのノート
            dst[#dst+1] = {
                id = "active" .. LEVEL_NAME_TABLE[i] .. "Note", op = {150 + i}, loop = 0, timer = 11, filter = 1, dst = {
                    {time = 0, angle = 0, acc = 2, a = 255, x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y - 5, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
                    {time = 500, angle = -10, acc = 2, a = 255, x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y + 10, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
                    {time = 501, angle = -10, acc = 2, a = 0},
                    {time = 1000, angle = 0, acc = 2, a = 0},
                }
            }
            dst[#dst+1] = {
                id = "active" .. LEVEL_NAME_TABLE[i] .. "Note", op = {150 + i}, loop = 0, timer = 11, filter = 1, dst = {
                    {time = 0, angle = 0, acc = 1, a = 0},
                    {time = 500, angle = -10, acc = 1, a = 0},
                    {time = 501, angle = -10, acc = 1, a = 255, x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y + 10, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
                    {time = 1000, angle = 0, acc = 1, a = 255, x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y - 5, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
                }
            }

            -- アクティブ時のレベルアイコンのテキスト
            dst[#dst+1] =  {
                id = "active" .. LEVEL_NAME_TABLE[i] .. "Text", op = {150 + i}, dst = {
                    {x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y + 1, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_TEXT_H}
                }
            }
        end
    elseif getTableValue(skin_config.option, "曲情報表示形式", 935) == 936 then
        -- 密度表示
        -- 難易度部分
        for i = 1, 5 do
            -- レベルアイコン(背景)
            dst[#dst+1] = {
                id = "active" .. LEVEL_NAME_TABLE[i] .. "Icon", op = {150 + i}, dst = {
                    {x = DENSITY_INFO.DIFFICULTY_ICON_X, y = DENSITY_INFO.ICON_Y, w = DENSITY_INFO.ICON_W, h = DENSITY_INFO.ICON_H}
                }
            }
            -- レベルアイコンのノート
            dst[#dst+1] = {
                id = "active" .. LEVEL_NAME_TABLE[i] .. "Note", op = {150 + i}, dst = {
                    {x = DENSITY_INFO.DIFFICULTY_ICON_X, y = DENSITY_INFO.ICON_Y, w = DENSITY_INFO.ICON_W, h = DENSITY_INFO.ICON_H},
                }
            }
            -- 文字
            dst[#dst+1] = {
                id = "densityDifficulty" .. LEVEL_NAME_TABLE[i] .. "Text", op = {150 + i}, dst = {
                    {x = DENSITY_INFO.DIFFICULTY_TEXT_X - 2, y = DENSITY_INFO.ICON_Y - 1, w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H}
                }
            }
            -- レベル表記
            dst[#dst+1] = {
                id = "largeLevel" .. LEVEL_NAME_TABLE[i], op = {150 + i}, dst = {
                    {x = DENSITY_INFO.DIFFICULTY_NUMBER_X, y = DENSITY_INFO.NUMBER_Y, w = LARGE_LEVEL.NUMBER_W, h = LARGE_LEVEL.NUMBER_H}
                }
            }
        end

        -- 密度部分
        local startX = DENSITY_INFO.START_X
        local types = {"Average", "End", "Peak"}

        for i = 1, 3 do
            -- アイコン部分
            dst[#dst+1] = {
                id = "density" ..  types[i] .. "Icon", op = {2}, dst = {
                    {x = startX + DENSITY_INFO.INTERVAL_X * (i - 1), y = DENSITY_INFO.ICON_Y, w = DENSITY_INFO.ICON_W, h = DENSITY_INFO.ICON_H}
                }
            }
            dst[#dst+1] = {
                id = "density" ..  types[i] .. "Note", op = {2}, dst = {
                    {x = startX + DENSITY_INFO.INTERVAL_X * (i - 1), y = DENSITY_INFO.ICON_Y + 4, w = DENSITY_INFO.ICON_W, h = DENSITY_INFO.ICON_H}
                }
            }
            dst[#dst+1] = {
                id = "density" ..  types[i] .. "Text", op = {2}, dst = {
                    {x = startX + DENSITY_INFO.INTERVAL_X * (i - 1) - 2, y = DENSITY_INFO.ICON_Y - 1, w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H}
                }
            }

            -- super magic number
            local offset = 63
            if getTableValue(skin_config.option, "密度の標準桁数", 938) == 938 then
                offset = 47
            end
            if types[i] == "Peak" then
                offset = 83
            end

            -- 整数部分
            dst[#dst+1] = {
                id = "density" ..  types[i] .. "Number", op = {2}, dst = {
                    {x = startX + DENSITY_INFO.INTERVAL_X * (i - 1) + offset - LARGE_LEVEL.NUMBER_W*2, y = DENSITY_INFO.NUMBER_Y, w = LARGE_LEVEL.NUMBER_W, h = LARGE_LEVEL.NUMBER_H}
                }
            }
            -- peakは小数点以下が現在は表示できないので出さない
            if types[i] ~= "Peak" then
                -- dot
                dst[#dst+1] = {
                    id = "density" ..  types[i] .. "Dot", op = {2}, dst = {
                        {x = startX + DENSITY_INFO.INTERVAL_X * (i - 1) + offset, y = DENSITY_INFO.NUMBER_Y, w = DENSITY_INFO.DOT_SIZE, h = DENSITY_INFO.DOT_SIZE}
                    }
                }
                -- 小数点以下
                dst[#dst+1] = {
                    id = "density" ..  types[i] .. "AfterDot", op = {2}, dst = {
                        {x = startX + DENSITY_INFO.INTERVAL_X * (i - 1) + offset + 8, y = DENSITY_INFO.NUMBER_Y, w = DENSITY_INFO.AFTER_DOT.W, h = DENSITY_INFO.AFTER_DOT.H}
                    }
                }
            end
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
                {x = EXSCORE_AREA.RATE.X(EXSCORE_AREA), y = EXSCORE_AREA.RATE.Y(EXSCORE_AREA), w = SCORE_INFO.TEXT_W, h = SCORE_INFO.TEXT_H}
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