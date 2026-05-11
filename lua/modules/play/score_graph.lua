require("modules.commons.define")
local commons = require("modules.play.commons")
local scores = require("modules.play.score")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local scoreGraph = {
    functions = {}
}

local SCORE = {
    -- LIFEと合わせる
    AREA = {
        X = function() return lanes.getAreaX() end,
        Y = function() return 118 end,
        W = 437,
        H = 239,
    },
    NUM = {
        X = function (self) return self.AREA.X() + 344 - self.NUM.W * self.NUM.DIGIT end,
        Y = function (self) return self.AREA.Y() + 108 end,
        W = 18,
        H = 23,
        DIGIT = 5,
    },
    P_NUM = {
        X = function (self) return self.AREA.X() + 381 - self.P_NUM.W * self.P_NUM.DIGIT end,
        Y = function (self) return self.AREA.Y() + 108 end,
        DOT_X = function (self) return self.AREA.X() + 382 end,
        A_X = function (self) return self.AREA.X() + 410 - self.P_NUM.W * self.P_NUM.A_DIGIT end,
        P_X = function (self) return self.AREA.X() + 410 end,
        W = 10,
        H = 17,
        P_W = 10,
        P_H = 17,
        DIGIT = 3,
        A_DIGIT = 2,
    },
    GRAPH = {
        ID_PREFIX = "scoreGraph",
        X = function (self) return self.AREA.X() + 10 end,
        Y = function (self) return self.AREA.Y() + 75 end,
        INTERVAL_Y = 27,
        H = 27,
        W = 415,
        COLORS = {{0, 128, 255}, {0, 192, 64}, {255, 64, 64}},
        TOTAL_COLORS = {{0, 43, 85}, {0, 64, 21}, {85, 21, 21}},
    },
    TEXT = {
        X = function (self) return self.AREA.X() + 4 end,
        Y = function (self) return self.AREA.Y() + 73 end,
        W = 256,
        H = 18,
    },

    DIFF = {
        X = function (self) return self.AREA.X() + 420 - self.DIFF.DIGIT * self.DIFF.W end,
        BEST_Y = function (self) return self.AREA.Y() + 56 end,
        TARGET_Y = function (self) return self.AREA.Y() + 30 end,
        W = 9,
        H = 11,
        DIGIT = 5,
    },
    RANK_TEXT = {
        W = 22,
        H = 10,
    },
    SEPARATOR = {
        Y = function (self) return self.AREA.Y() + 9 end,
    }
}

scoreGraph.functions.load = function ()
    return {
        image = {
            {id = "scoreBg", src = 0, x = 0, y = 1476, w = 417, h = 83},
            {id = "scoreFrame", src = 0, x = 0, y = 1390, w = 419, h = 85},
            {id = "scoreOverlay", src = 0, x = 0, y = 1308, w = 415, h = 81},
            {id = "scorePercentageDot", src = 0, x = 2039, y = 295, w = SCORE.P_NUM.W, h = SCORE.P_NUM.H},
            {id = "scorePercent", src = 0, x = 1928, y = 295, w = SCORE.P_NUM.P_W, h = SCORE.P_NUM.P_H},
        },
        graph = {
            {id = SCORE.GRAPH.ID_PREFIX .. "Now", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, type = 110},
            {id = SCORE.GRAPH.ID_PREFIX .. "Best", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, type = 112},
            -- {id = SCORE.GRAPH.ID_PREFIX .. "Target", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, type = 114},
            {id = SCORE.GRAPH.ID_PREFIX .. "Target", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, value = scores.getTargetScoreRate},
            {id = SCORE.GRAPH.ID_PREFIX .. "NowTotal", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, type = 111},
            {id = SCORE.GRAPH.ID_PREFIX .. "BestTotal", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, type = 113},
            -- {id = SCORE.GRAPH.ID_PREFIX .. "TargetTotal", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, type = 115},
            {id = SCORE.GRAPH.ID_PREFIX .. "TargetTotal", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, value = scores.getTargetWholeScoreRate},
        },
        value = {
            {id = "scoreValue", src = 0, x = 1868, y = 271, w = SCORE.NUM.W * 10, h = SCORE.NUM.H, divx = 10, digit = SCORE.NUM.DIGIT, ref = 101},
            {id = "scorePercentage", src = 0, x = 1938, y = 295, w = SCORE.P_NUM.W * 10, h = SCORE.P_NUM.H, divx = 10, digit = SCORE.P_NUM.DIGIT, ref = 102},
            {id = "scorePercentageAfterDot", src = 0, x = 1938, y = 295, w = SCORE.P_NUM.W * 10, h = SCORE.P_NUM.H, divx = 10, digit = SCORE.P_NUM.A_DIGIT, ref = 103, padding = 1},

            {id = "scoreDiffMyBest", src = 0, x = 1940, y = 0, w = SCORE.DIFF.W * 12, h = SCORE.DIFF.H * 2, divx = 12, divy = 2, digit = SCORE.DIFF.DIGIT, ref = 152, padding = 0, space = -1},
            -- {id = "scoreDiffTarget", src = 0, x = 1940, y = 0, w = SCORE.DIFF.W * 12, h = SCORE.DIFF.H * 2, divx = 12, divy = 2, digit = SCORE.DIFF.DIGIT, ref = 153, padding = 0, space = -1},
            {id = "scoreDiffTarget", src = 0, x = 1940, y = 0, w = SCORE.DIFF.W * 12, h = SCORE.DIFF.H * 2, divx = 12, divy = 2, digit = SCORE.DIFF.DIGIT, value = scores.getDiffTargetScoreAndNowScore, padding = 0, space = -1},
        }
    }
end

scoreGraph.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    -- 背景
    dst[#dst+1] = {
        id = "scoreBg", dst = {
            {x = SCORE.AREA.X() + 9, y = SCORE.AREA.Y() + 20, w = 417, h = 83}
        }
    }

    -- ゲージ出力
    do
        local IDS = {"Now", "Best", "Target"}
        for i = 1, 3 do
            local color = SCORE.GRAPH.COLORS[i]
            -- 終了時点での値
            local colorBg = SCORE.GRAPH.TOTAL_COLORS[i]

            dst[#dst+1] = {
                id = SCORE.GRAPH.ID_PREFIX .. IDS[i] .. "Total", dst = {
                    {
                        x = SCORE.GRAPH.X(SCORE),
                        y = SCORE.GRAPH.Y(SCORE) - SCORE.GRAPH.INTERVAL_Y * (i - 1),
                        w = SCORE.GRAPH.W, h = SCORE.GRAPH.H,
                        r = colorBg[1], g = colorBg[2], b = colorBg[3]
                    }
                }
            }
            -- 本体
            dst[#dst+1] = {
                id = SCORE.GRAPH.ID_PREFIX .. IDS[i], dst = {
                    {
                        x = SCORE.GRAPH.X(SCORE),
                        y = SCORE.GRAPH.Y(SCORE) - SCORE.GRAPH.INTERVAL_Y * (i - 1),
                        w = SCORE.GRAPH.W, h = SCORE.GRAPH.H,
                        r = color[1], g = color[2], b = color[3]
                    }
                }
            }
        end
    end

    -- ガラス
    dst[#dst+1] = {
        id = "scoreOverlay", blend = 4, dst = {
            {x = SCORE.AREA.X() + 9, y = SCORE.AREA.Y() + 21, w = 415, h = 81}
        }
    }

    -- ゲージのフレーム
    dst[#dst+1] = {
        id = "scoreFrame", dst = {
            {x = SCORE.AREA.X() + 8, y = SCORE.AREA.Y() + 19, w = 419, h = 85}
        }
    }

    -- スコア値
    dst[#dst+1] = {
        id = "scoreValue", dst = {
            {x = SCORE.NUM.X(SCORE), y = SCORE.NUM.Y(SCORE), w = SCORE.NUM.W, h = SCORE.NUM.H}
        }
    }
    -- パーセンテージ
    dst[#dst+1] = {
        id = "scorePercentage", dst = {
            {x = SCORE.P_NUM.X(SCORE), y = SCORE.P_NUM.Y(SCORE), w = SCORE.P_NUM.W, h = SCORE.P_NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "scorePercentageDot", dst = {
            {x = SCORE.P_NUM.DOT_X(SCORE), y = SCORE.P_NUM.Y(SCORE), w = SCORE.P_NUM.W, h = SCORE.P_NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "scorePercentageAfterDot", dst = {
            {x = SCORE.P_NUM.A_X(SCORE), y = SCORE.P_NUM.Y(SCORE), w = SCORE.P_NUM.W, h = SCORE.P_NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "scorePercent", dst = {
            {x = SCORE.P_NUM.P_X(SCORE), y = SCORE.P_NUM.Y(SCORE), w = SCORE.P_NUM.P_W, h = SCORE.P_NUM.P_H}
        }
    }

    -- スコア差分
    dst[#dst+1] = {
        id = "scoreDiffMyBest", dst = {
            {x = SCORE.DIFF.X(SCORE), y = SCORE.DIFF.BEST_Y(SCORE), w = SCORE.DIFF.W, h = SCORE.DIFF.H}
        }
    }
    dst[#dst+1] = {
        id = "scoreDiffTarget", dst = {
            {x = SCORE.DIFF.X(SCORE), y = SCORE.DIFF.TARGET_Y(SCORE), w = SCORE.DIFF.W, h = SCORE.DIFF.H}
        }
    }
    return skin
end

return scoreGraph.functions