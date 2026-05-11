require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")
local musicDetail = require("modules.commons.music_detail")

local detail = {
    functions = {}
}

local DETAIL = {
    AREA = {
        X = function () return is1P() and lanes.getAreaX() + lanes.getAreaW() + 23 or 21 end,
        Y = function () return 16 end,
        W = 1373,
        H = 328
    },
    TEXT = {
        FONT = {
            LARGE = 30,
            NORMAL = 24,
        },
        VALUE = {
            X1 = function (self) return self.AREA.X() + 447 end,
            X2 = function (self) return self.AREA.X() + 903 end,
            X_TIME = function (self) return self.AREA.X() + 1280 end,
            Y_TIME = function (self) return self.AREA.Y() + 13 end,
            Y = function (self, i) return self.AREA.Y() + 170 - self.TEXT.VALUE.INTERVAL_Y * (i - 1) end,
            Y_TITLE = function (self) return self.AREA.Y() + 242 end,
            INTERVAL_Y = 72,
            W_TITLE = 880,
            W_ITEM = 412,
        },
    },
    GRAPH = {
        X = function (self) return self.AREA.X() + 903 end,
        Y = function (self) return self.AREA.Y() + 52 end,
        W = 440,
        H = 82,
    },
    STAGEFILE = {
        IMAGE = {
            X = function (self) return self.AREA.X() + 18 end,
            Y = function (self) return self.AREA.Y() + 18 end,
            W = 388,
            H = 291,
        },
    }
}

detail.functions.load = function ()
    if not getIsDrawMusicDetail() then
        return {}
    end
    if getIsUseMusicDatabase() then
        musicDetail.loadPlay()
        musicDetail.fetchMusicDetailOnPlay()
    end
    local p = "musicDetail"
    local skin = {
        image = {
            {id = p .. "Frame", src = 101, x = 0, y = 0, w = -1, h = -1},
            {id = p .. "NoImage", src = 100, x = 0, y = 0, w = -1, h = -1},
        },
        text = {
            {id = p .. "Title", font = 0, size = DETAIL.TEXT.FONT.LARGE, ref = 12, overflow = 1},
            {id = p .. "Artist", font = 0, size = DETAIL.TEXT.FONT.NORMAL, ref = 14, overflow = 1},
            {id = p .. "SubArtist", font = 0, size = DETAIL.TEXT.FONT.NORMAL, ref = 15, overflow = 1},
            {id = p .. "Genre", font = 0, size = DETAIL.TEXT.FONT.NORMAL, ref = 13, overflow = 1},
            {
                id = p .. "Event", font = 0, size = DETAIL.TEXT.FONT.NORMAL, overflow = 1,
                value = function ()
                    return musicDetail.getEventData().name
                end
            },
            {id = p .. "Time", font = 0, size = DETAIL.TEXT.FONT.NORMAL, constantText = string.format("%02d", main_state.number(1163))  .. ":" .. string.format("%02d", main_state.number(1164))}
        },
        value = {
        },
        judgegraph = {
            {id = p .. "NotesGraph", noGap = 1, orderReverse = 0, type = 0, backTexOff = 1},
            {id = p .. "JudgesGraph", noGap = 1, orderReverse = 1, type = 1, backTexOff = 1},
            {id = p .. "ElGraph", noGap = 1, orderReverse = 1, type = 2, backTexOff = 1},
        },
        timingdistributiongraph = {
            {id = p .. "TimingGraph", graphColor = "88FF88FF", PRColor = "00000000", BDColor = "88000088", GDColor = "88880088", GRColor = "00880088", PGColor = "00008888", devColor = "ffffff44", averageColor = "ffffff44"},
        },
        bpmgraph = {
            {id = p .. "BpmGraph"}
        },
    }
    return skin
end

detail.functions.dst = function ()
    if not getIsDrawMusicDetail() then
        return {}
    end
    local p = "musicDetail"
    local graphId = "blank"
    do
        local t = getMusicDetailNotesGraph()
        if t == 1 then
            graphId = p .. "NotesGraph"
        elseif t == 2 then
            graphId = p .. "JudgesGraph"
        elseif t == 3 then
            graphId = p .. "ElGraph"
        elseif t == 4 then
            graphId = p .. "TimingGraph"
        end
    end

    local skin = {
        destination = {
            {
                id = p .. "Frame", dst = {
                    {x = DETAIL.AREA.X(), y = DETAIL.AREA.Y(), w = DETAIL.AREA.W, h = DETAIL.AREA.H},
                },
            },
            -- 楽曲詳細
            {
                id = p .. "Title", filter = 1, dst = {
                    {x = DETAIL.TEXT.VALUE.X1(DETAIL), y = DETAIL.TEXT.VALUE.Y_TITLE(DETAIL), w = DETAIL.TEXT.VALUE.W_TITLE, h = DETAIL.TEXT.FONT.LARGE}
                }
            },
            {
                id = p .. "Artist", filter = 1, dst = {
                    {x = DETAIL.TEXT.VALUE.X1(DETAIL), y = DETAIL.TEXT.VALUE.Y(DETAIL, 1), w = DETAIL.TEXT.VALUE.W_ITEM, h = DETAIL.TEXT.FONT.NORMAL}
                }
            },
            {
                id = p .. "SubArtist", filter = 1, dst = {
                    {x = DETAIL.TEXT.VALUE.X1(DETAIL), y = DETAIL.TEXT.VALUE.Y(DETAIL, 2), w = DETAIL.TEXT.VALUE.W_ITEM, h = DETAIL.TEXT.FONT.NORMAL}
                }
            },
            {
                id = p .. "Genre", filter = 1, dst = {
                    {x = DETAIL.TEXT.VALUE.X1(DETAIL), y = DETAIL.TEXT.VALUE.Y(DETAIL, 3), w = DETAIL.TEXT.VALUE.W_ITEM, h = DETAIL.TEXT.FONT.NORMAL}
                }
            },
            {
                id = p .. "Event", filter = 1, dst = {
                    {x = DETAIL.TEXT.VALUE.X2(DETAIL), y = DETAIL.TEXT.VALUE.Y(DETAIL, 1), w = DETAIL.TEXT.VALUE.W_ITEM, h = DETAIL.TEXT.FONT.NORMAL}
                }
            },
            {
                id = p .. "Time", dst = {
                    {x = DETAIL.TEXT.VALUE.X_TIME(DETAIL), y = DETAIL.TEXT.VALUE.Y_TIME(DETAIL), w = DETAIL.TEXT.VALUE.W_ITEM, h = DETAIL.TEXT.FONT.NORMAL}
                }
            },
            {
                id = graphId, dst = {
                    {x = DETAIL.GRAPH.X(DETAIL), y = DETAIL.GRAPH.Y(DETAIL), w = DETAIL.GRAPH.W, h = DETAIL.GRAPH.H}
                }
            },
            {
                id = p .. "BpmGraph", dst = {
                    {x = DETAIL.GRAPH.X(DETAIL), y = DETAIL.GRAPH.Y(DETAIL), w = DETAIL.GRAPH.W, h = DETAIL.GRAPH.H}
                }
            },

            -- ステージファイル
            -- no stagefile
            {
                id = p .. "NoImage", op = {190}, filter = 1, stretch = 1, offset = 42, dst = {
                    {x = DETAIL.STAGEFILE.IMAGE.X(DETAIL), y = DETAIL.STAGEFILE.IMAGE.Y(DETAIL), w = DETAIL.STAGEFILE.IMAGE.W, h = DETAIL.STAGEFILE.IMAGE.H}
                }
            },
            -- ステージファイル
            {
                id = -100, filter = 1, stretch = 1, offset = 42, dst = {
                    {x = DETAIL.STAGEFILE.IMAGE.X(DETAIL), y = DETAIL.STAGEFILE.IMAGE.Y(DETAIL), w = DETAIL.STAGEFILE.IMAGE.W, h = DETAIL.STAGEFILE.IMAGE.H}
                }
            },
        }
    }
    return skin
end

return detail.functions