require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local scoreGraph = {
    functions = {}
}

local SCORE_GRAPH = {
    AREA = {
        X = function() return lanes.getAreaX() end,
        Y = function() return 99-7 end,
        W = 432,
        H = 98,
    },
    RANK_TEXT = {
        W = 22,
        H = 10,
    },
    GRAPH = {
        ID_PREFIX = "scoreGraph",
        X = function (self) return self.AREA.X() + 2 end,
        Y = function (self) return self.AREA.Y() + 39 end,
        INTERVAL_Y = 15,
        H = 14,
        W = 428,
        COLORS = {{0, 102, 204}, {0, 143, 34}, {153, 0, 0}}
    }
}

scoreGraph.functions.load = function ()
    return {
        image = {
            {id = "scoreFrame", src = 0, x = 0, y = PARTS_TEXTURE_SIZE - SCORE_GRAPH.AREA.H, w = SCORE_GRAPH.AREA.W, h = SCORE_GRAPH.AREA.H},
            {id = "scoreGraphGlass", src = 0, x = 458, y = PARTS_TEXTURE_SIZE - SCORE_GRAPH.GRAPH.H, w = 1, h = SCORE_GRAPH.GRAPH.H},
            {id = "graphRankA", src = 0, x = 0, y = 0, w = SCORE_GRAPH.RANK_TEXT.W, h = SCORE_GRAPH.RANK_TEXT.H},
            {id = "graphRankAa", src = 0, x = 0, y = SCORE_GRAPH.RANK_TEXT.H, w = SCORE_GRAPH.RANK_TEXT.W, h = SCORE_GRAPH.RANK_TEXT.H},
            {id = "graphRankAaa", src = 0, x = 0, y = SCORE_GRAPH.RANK_TEXT.H * 2, w = SCORE_GRAPH.RANK_TEXT.W, h = SCORE_GRAPH.RANK_TEXT.H},
        },
        graph = {
            {id = SCORE_GRAPH.GRAPH.ID_PREFIX .. "Now", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, type = 110},
            {id = SCORE_GRAPH.GRAPH.ID_PREFIX .. "Best", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, type = 112},
            {id = SCORE_GRAPH.GRAPH.ID_PREFIX .. "Target", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 0, type = 114},
        },
        value = {
            
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
            local color = SCORE_GRAPH.GRAPH.COLORS[i]
            -- 背景
            dst[#dst+1] = {
                id = "white", dst = {
                    {
                        x = SCORE_GRAPH.GRAPH.X(SCORE_GRAPH),
                        y = SCORE_GRAPH.GRAPH.Y(SCORE_GRAPH) - SCORE_GRAPH.GRAPH.INTERVAL_Y * (i - 1),
                        w = SCORE_GRAPH.GRAPH.W, h = SCORE_GRAPH.GRAPH.H,
                        a = 96
                    }
                }
            }
            -- 本体
            dst[#dst+1] = {
                id = SCORE_GRAPH.GRAPH.ID_PREFIX .. IDS[i], dst = {
                    {
                        x = SCORE_GRAPH.GRAPH.X(SCORE_GRAPH),
                        y = SCORE_GRAPH.GRAPH.Y(SCORE_GRAPH) - SCORE_GRAPH.GRAPH.INTERVAL_Y * (i - 1),
                        w = SCORE_GRAPH.GRAPH.W, h = SCORE_GRAPH.GRAPH.H,
                        r = color[1], g = color[2], b = color[3]
                    }
                }
            }
            -- ガラス
            dst[#dst+1] = {
                id = "scoreGraphGlass", dst = {
                    {
                        x = SCORE_GRAPH.GRAPH.X(SCORE_GRAPH),
                        y = SCORE_GRAPH.GRAPH.Y(SCORE_GRAPH) - SCORE_GRAPH.GRAPH.INTERVAL_Y * (i - 1),
                        w = SCORE_GRAPH.GRAPH.W, h = SCORE_GRAPH.GRAPH.H, a = 196
                    }
                }
            }
            -- 区切り線
            dst[#dst+1] = {
                id = "white", dst = {
                    {
                        x = SCORE_GRAPH.GRAPH.X(SCORE_GRAPH),
                        y = SCORE_GRAPH.GRAPH.Y(SCORE_GRAPH) - SCORE_GRAPH.GRAPH.INTERVAL_Y * (i - 1) - 1,
                        w = SCORE_GRAPH.GRAPH.W, h = 1
                    }
                }
            }
        end
    end
    -- フレーム
    dst[#dst+1] = {
        id = "scoreFrame", dst = {
            {x = SCORE_GRAPH.AREA.X(), y = SCORE_GRAPH.AREA.Y(), w = SCORE_GRAPH.AREA.W, h = SCORE_GRAPH.AREA.H}
        }
    }
    return skin
end

return scoreGraph.functions