require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local scoreGraph = {
    functions = {}
}

local SCORE = {
    AREA = {
        X = function() return lanes.getAreaX() end,
        Y = function() return 99-7 end,
        W = 432,
        H = 98,
    },
    NUM = {
        X = function (self) return self.AREA.X() + 370 - self.NUM.W * self.NUM.DIGIT end,
        Y = function (self) return self.AREA.Y() + 64 end,
        W = 14,
        H = 18,
        DIGIT = 5,
    },
    P_NUM = {
        X = function (self) return self.AREA.X() + 395 - self.P_NUM.W * self.P_NUM.DIGIT end,
        Y = function (self) return self.AREA.Y() + 64 end,
        DOT_X = function (self) return self.P_NUM.X(self) + self.P_NUM.W * self.P_NUM.DIGIT + 1 end,
        A_X = function (self) return self.P_NUM.DOT_X(self) + 18 - self.P_NUM.W * self.P_NUM.A_DIGIT end,
        P_X = function (self) return self.P_NUM.A_X(self) + self.P_NUM.W * self.P_NUM.A_DIGIT + 1 end,
        W = NUMBERS_14PX.W,
        H = NUMBERS_14PX.H,
        P_W = 13,
        P_H = 11,
        DIGIT = 3,
        A_DIGIT = 2,
    },
    GRAPH = {
        ID_PREFIX = "scoreGraph",
        X = function (self) return self.AREA.X() + 2 end,
        Y = function (self) return self.AREA.Y() + 39 end,
        INTERVAL_Y = 15,
        H = 14,
        W = 428,
        COLORS = {{0, 128, 255}, {0, 192, 64}, {192, 0, 0}}
    },
    TEXT = {
        X = function (self) return self.AREA.X() + 4 end,
        Y = function (self) return self.AREA.Y() + 58 end,
        W = 89,
        H = 18,
    },

    DIFF = {
        X = function (self) return self.AREA.X() + 427 - self.DIFF.DIGIT * self.DIFF.W end,
        BEST_Y = function (self) return self.AREA.Y() + 25 end,
        TARGET_Y = function (self) return self.AREA.Y() + 10 end,
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
        H = 44
    }
}

scoreGraph.functions.load = function ()
    return {
        image = {
            {id = "scoreFrame", src = 0, x = 0, y = PARTS_TEXTURE_SIZE - SCORE.AREA.H, w = SCORE.AREA.W, h = SCORE.AREA.H},
            {id = "scoreGraphGlass", src = 0, x = 458, y = PARTS_TEXTURE_SIZE - SCORE.GRAPH.H, w = 1, h = SCORE.GRAPH.H},
            {id = "graphRankA", src = 0, x = 0, y = 0, w = SCORE.RANK_TEXT.W, h = SCORE.RANK_TEXT.H},
            {id = "graphRankAa", src = 0, x = 0, y = SCORE.RANK_TEXT.H, w = SCORE.RANK_TEXT.W, h = SCORE.RANK_TEXT.H},
            {id = "graphRankAaa", src = 0, x = 0, y = SCORE.RANK_TEXT.H * 2, w = SCORE.RANK_TEXT.W, h = SCORE.RANK_TEXT.H},
            {id = "exscoreText", src = 0, x = 124, y = 0, w = SCORE.TEXT.W, h = SCORE.TEXT.H},
            {id = "scorePercentageDot", src = 0, x = 2032, y = 94, w = NUMBERS_14PX.W, h = NUMBERS_14PX.H},
            {id = "scorePercent", src = 0, x = 1939, y = 94, w = SCORE.P_NUM.P_W, h = SCORE.P_NUM.P_H},
        },
        graph = {
            {id = SCORE.GRAPH.ID_PREFIX .. "Now", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, type = 110},
            {id = SCORE.GRAPH.ID_PREFIX .. "Best", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, type = 112},
            {id = SCORE.GRAPH.ID_PREFIX .. "Target", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, type = 114},
        },
        value = {
            {id = "scoreValue", src = 0, x = 1880, y = 76, w = SCORE.NUM.W * 10, h = SCORE.NUM.H, divx = 10, digit = SCORE.NUM.DIGIT, ref = 101},
            {id = "scorePercentage", src = 0, x = NUMBERS_14PX.SRC_X, y = NUMBERS_14PX.SRC_Y, w = NUMBERS_14PX.W * 10, h = NUMBERS_14PX.H, divx = 10, digit = SCORE.P_NUM.DIGIT, ref = 102},
            {id = "scorePercentageAfterDot", src = 0, x = NUMBERS_14PX.SRC_X, y = NUMBERS_14PX.SRC_Y, w = NUMBERS_14PX.W * 10, h = NUMBERS_14PX.H, divx = 10, digit = SCORE.P_NUM.A_DIGIT, ref = 103, padding = 1},

            {id = "scoreDiffMyBest", src = 0, x = 1940, y = 0, w = SCORE.DIFF.W * 12, h = SCORE.DIFF.H * 2, divx = 12, divy = 2, digit = SCORE.DIFF.DIGIT, ref = 152, padding = 0, space = -1},
            {id = "scoreDiffTarget", src = 0, x = 1940, y = 0, w = SCORE.DIFF.W * 12, h = SCORE.DIFF.H * 2, divx = 12, divy = 2, digit = SCORE.DIFF.DIGIT, ref = 153, padding = 0, space = -1},
        }
    }
end

scoreGraph.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    -- ゲージ出力
    do
        local IDS = {"Now", "Best", "Target"}
        for i = 1, 3 do
            local color = SCORE.GRAPH.COLORS[i]
            -- 背景
            dst[#dst+1] = {
                id = "white", dst = {
                    {
                        x = SCORE.GRAPH.X(SCORE),
                        y = SCORE.GRAPH.Y(SCORE) - SCORE.GRAPH.INTERVAL_Y * (i - 1),
                        w = SCORE.GRAPH.W, h = SCORE.GRAPH.H,
                        a = 96, r = 0, g = 0, b = 0
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
            -- ガラス
            dst[#dst+1] = {
                id = "scoreGraphGlass", dst = {
                    {
                        x = SCORE.GRAPH.X(SCORE),
                        y = SCORE.GRAPH.Y(SCORE) - SCORE.GRAPH.INTERVAL_Y * (i - 1),
                        w = SCORE.GRAPH.W, h = SCORE.GRAPH.H, a = 196
                    }
                }
            }
            -- 区切り線
            dst[#dst+1] = {
                id = "white", dst = {
                    {
                        x = SCORE.GRAPH.X(SCORE),
                        y = SCORE.GRAPH.Y(SCORE) - SCORE.GRAPH.INTERVAL_Y * (i - 1) - 1,
                        w = SCORE.GRAPH.W, h = 1
                    }
                }
            }
        end
    end
    -- フレーム
    dst[#dst+1] = {
        id = "scoreFrame", dst = {
            {x = SCORE.AREA.X(), y = SCORE.AREA.Y(), w = SCORE.AREA.W, h = SCORE.AREA.H}
        }
    }
    -- 文字EXSCORE
    dst[#dst+1] = {
        id = "exscoreText", dst = {
            {x = SCORE.TEXT.X(SCORE), y = SCORE.TEXT.Y(SCORE), w = SCORE.TEXT.W, h = SCORE.TEXT.H}
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
            {x = SCORE.P_NUM.X(SCORE), y = SCORE.P_NUM.Y(SCORE), w = NUMBERS_14PX.W, h = NUMBERS_14PX.H}
        }
    }
    dst[#dst+1] = {
        id = "scorePercentageDot", dst = {
            {x = SCORE.P_NUM.DOT_X(SCORE), y = SCORE.P_NUM.Y(SCORE), w = NUMBERS_14PX.W, h = NUMBERS_14PX.H}
        }
    }
    dst[#dst+1] = {
        id = "scorePercentageAfterDot", dst = {
            {x = SCORE.P_NUM.A_X(SCORE), y = SCORE.P_NUM.Y(SCORE), w = NUMBERS_14PX.W, h = NUMBERS_14PX.H}
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

    -- a, aa, aaa
    do
        local ids = {"graphRankA", "graphRankAa", "graphRankAaa"}
        for i = 1, 3 do
            local lineX = SCORE.GRAPH.X(SCORE) + SCORE.GRAPH.W * (0.6666 + (0.1111 * (i - 1)))
            -- 線
            dst[#dst+1] = {
                id = "white", dst = {
                    {x = lineX, y = SCORE.SEPARATOR.Y(SCORE), w = 1, h = SCORE.SEPARATOR.H}
                }
            }
            -- マーク
            dst[#dst+1] = {
                id = ids[i], dst = {
                    {x = lineX - SCORE.RANK_TEXT.W, y = SCORE.SEPARATOR.Y(SCORE), w = SCORE.RANK_TEXT.W, h = SCORE.RANK_TEXT.H}
                }
            }
        end
    end
    return skin
end

return scoreGraph.functions