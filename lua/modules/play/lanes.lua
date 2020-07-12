require("modules.commons.define")
local commons = require("modules.play.commons")

local notes = {
    functions = {}
}

local NOTES = {
    X = {},
    W = {52, 42, 52, 42, 52, 42, 52},
    SCRATCH_W = 92,
    SPACE = 1,
}

local LANES = {
    AREA = {
        W = 432,
        H = 723,
        X = nil,
        X_1 = function (self) return 75 end,
        X_2 = function (self) return WIDTH - self.AREA.W - self.AREA.X_1() end,
        Y = 357,
    },
    EDGE = {
        W = 18,
        H = HEIGHT,
    },
    SEPARATOR = {
        W = 1,
        A = 92,
    },
    JUDGE_LINE = {
        H = 4,
    }
}

local SYMBOL = {
    WHITE = 52,
    BLUE = 42,
    TURNTABLE = 91,
}

local function getDifficultyColor()
	local dif = getDifficultyValueForColor()
	local colors = {{255, 255, 255}, {137, 204, 137}, {137, 204, 204}, {204, 164, 108}, {204, 104, 104}, {204, 102, 153}}
	return colors[dif][1], colors[dif][2], colors[dif][3]
end

local function getJudgeLineColor()
	local dif = getDifficultyValueForColor()
	local colors = {{128, 128, 128}, {0, 255, 0}, {0, 128, 255}, {255, 128, 0}, {255, 0, 0}, {255, 0, 128}}
	return colors[dif][1], colors[dif][2], colors[dif][3]
end

local function isLeftScratch()
    local b = true
    if isMirrorTable() then
        b = not b
    end
    if not is1P() then
        b = not b
    end
    return b
end

notes.functions.getAreaX = function ()
    if is1P() then
        return LANES.AREA.X_1(LANES)
    else
        return LANES.AREA.X_2(LANES)
    end
end

notes.functions.getAreaY = function ()
    return LANES.AREA.Y
end

notes.functions.getInnerAreaY = function ()
    return LANES.AREA.Y + LANES.JUDGE_LINE.H
end

notes.functions.getOurterAreaY = function ()
    return LANES.AREA.Y - 2
end

notes.functions.getAreaW = function ()
    return LANES.AREA.W
end

notes.functions.getLaneX = function (key)
    if #NOTES.X < key then return 0 end
    return NOTES.X[key]
end

notes.functions.getLaneW = function (key)
    if key == commons.keys + 1 then return NOTES.SCRATCH_W end
    if #NOTES.W < key          then return 0 end
    return NOTES.W[key]
end

notes.functions.load = function ()
    local keyBeam = require("modules.play.key_beam")
    local laneX = notes.functions.getAreaX()

    -- offsetで初期化
    local h = getTableValue(skin_config.offset, "判定線の高さ(既定値 4px)", {h = 0}).h
    if h ~= 0 then LANES.JUDGE_LINE.H = h end

    local skin = {
        image = {
            {id = "note-b", src = 1, x = 127, y = 5, w = 21, h = 12},
            {id = "note-w", src = 1, x = 99, y = 5, w = 27, h = 12},
            {id = "note-s", src = 1, x = 50, y = 5, w = 46, h = 12},

            {id = "lns-b", src = 1, x = 127, y = 57, w = 21, h = 13},
            {id = "lns-w", src = 1, x = 99, y = 57, w = 27, h = 13},
            {id = "lns-s", src = 1, x = 50, y = 57, w = 46, h = 12},

            {id = "lne-b", src = 1, x = 127, y = 43, w = 21, h = 13},
            {id = "lne-w", src = 1, x = 99, y = 43, w = 27, h = 13},
            {id = "lne-s", src = 1, x = 50, y = 43, w = 46, h = 12},

            {id = "lnb-b", src = 1, x = 127, y = 80, w = 21, h = 1},
            {id = "lnb-w", src = 1, x = 99, y = 80, w = 27, h = 1},
            {id = "lnb-s", src = 1, x = 50, y = 80, w = 46, h = 1},

            {id = "lna-b", src = 1, x = 127, y = 76, w = 21, h = 1},
            {id = "lna-w", src = 1, x = 99, y = 76, w = 27, h = 1},
            {id = "lna-s", src = 1, x = 50, y = 76, w = 46, h = 1},

            {id = "hcns-b", src = 1, x = 127, y = 108, w = 21, h = 13},
            {id = "hcns-w", src = 1, x = 99, y = 108, w = 27, h = 13},
            {id = "hcns-s", src = 1, x = 50, y = 108, w = 46, h = 12},

            {id = "hcne-b", src = 1, x = 127, y = 94, w = 21, h = 13},
            {id = "hcne-w", src = 1, x = 99, y = 94, w = 27, h = 13},
            {id = "hcne-s", src = 1, x = 50, y = 94, w = 46, h = 12},

            {id = "hcnb-b", src = 1, x = 127, y = 131, w = 21, h = 1},
            {id = "hcnb-w", src = 1, x = 99, y = 131, w = 27, h = 1},
            {id = "hcnb-s", src = 1, x = 50, y = 131, w = 46, h = 1},

            {id = "hcna-b", src = 1, x = 127, y = 127, w = 21, h = 1},
            {id = "hcna-w", src = 1, x = 99, y = 127, w = 27, h = 1},
            {id = "hcna-s", src = 1, x = 50, y = 127, w = 46, h = 1},

            {id = "hcnd-b", src = 1, x = 127, y = 128, w = 21, h = 1},
            {id = "hcnd-w", src = 1, x = 99, y = 128, w = 27, h = 1},
            {id = "hcnd-s", src = 1, x = 50, y = 128, w = 46, h = 1},

            {id = "hcnr-b", src = 1, x = 127, y = 129, w = 21, h = 1},
            {id = "hcnr-w", src = 1, x = 99, y = 129, w = 27, h = 1},
            {id = "hcnr-s", src = 1, x = 50, y = 129, w = 46, h = 1},

            {id = "mine-b", src = 1, x = 127, y = 23, w = 21, h = 8},
            {id = "mine-w", src = 1, x = 99, y = 23, w = 27, h = 8},
            {id = "mine-s", src = 1, x = 50, y = 23, w = 46, h = 8},

            {id = "laneEdge", src = 0, x = 0, y = 30, w = LANES.EDGE.W, h = LANES.EDGE.H},

            -- シンボル
            {id = "whiteSymbol", src = 2, x = 0, y = 0, w = -1, h = -1},
            {id = "blueSymbol", src = 3, x = 0, y = 0, w = -1, h = -1},
            {id = "turntableSymbol", src = 4, x = 0, y = 0, w = -1, h = -1},
        },
        note = {
            id = "notes",
            note = {"note-w","note-b","note-w","note-b","note-w","note-b","note-w","note-s"},
            lnend = {"lne-w","lne-b","lne-w","lne-b","lne-w","lne-b","lne-w","lne-s"},
            lnstart = {"lns-w","lns-b","lns-w","lns-b","lns-w","lns-b","lns-w","lns-s"},
            lnbody = {"lnb-w","lnb-b","lnb-w","lnb-b","lnb-w","lnb-b","lnb-w","lnb-s"},
            lnactive = {"lna-w","lna-b","lna-w","lna-b","lna-w","lna-b","lna-w","lna-s"},
            hcnend = {"hcne-w","hcne-b","hcne-w","hcne-b","hcne-w","hcne-b","hcne-w","hcne-s"},
            hcnstart = {"hcns-w","hcns-b","hcns-w","hcns-b","hcns-w","hcns-b","hcns-w","hcns-s"},
            hcnbody = {"hcnb-w","hcnb-b","hcnb-w","hcnb-b","hcnb-w","hcnb-b","hcnb-w","hcnb-s"},
            hcnactive = {"hcna-w","hcna-b","hcna-w","hcna-b","hcna-w","hcna-b","hcna-w","hcna-s"},
            hcndamage = {"hcnd-w","hcnd-b","hcnd-w","hcnd-b","hcnd-w","hcnd-b","hcnd-w","hcnd-s"},
            hcnreactive = {"hcnr-w","hcnr-b","hcnr-w","hcnr-b","hcnr-w","hcnr-b","hcnr-w","hcnr-s"},
            mine = {"mine-w","mine-b","mine-w","mine-b","mine-w","mine-b","mine-w","mine-s"},
            hidden = {},
            processed = {},
            dst = {},
            -- 小節線配置 offset3指定でliftの値を考慮した座標になる
			group = {
				{id = "white", offset = 3, dst = {
					{x = laneX, y = LANES.AREA.Y, w = LANES.AREA.W, h = 3, r = 128, g = 128, b = 128}
				}}
			},
			time = {
				{id = "white", offset = 3, dst = {
					{x = laneX, y = LANES.AREA.Y, w = LANES.AREA.W, h = 3, r = 64, g = 192, b = 192}
				}}
			},
			bpm = {
				{id = "white", offset = 3, dst = {
					{x = laneX, y = LANES.AREA.Y, w = LANES.AREA.W, h = 6, r = 0, g = 192, b = 0}
				}}
			},
			stop = {
				{id = "white", offset = 3, dst = {
					{x = laneX, y = LANES.AREA.Y, w = LANES.AREA.W, h = 6, r = 192, g = 192, b = 0}
				}}
			}
        }
    }

    -- noteのxを埋める 1234567s または 12345s
    do
        local offsetX = isLeftScratch() and NOTES.SCRATCH_W + NOTES.SPACE or 0
        for i = 1, commons.keys do
            table.insert(NOTES.X, notes.functions.getAreaX() + offsetX)
            offsetX = offsetX + NOTES.W[i] + NOTES.SPACE
        end

        -- 皿
        local sx = laneX
        if not isLeftScratch() then
            sx = laneX + offsetX
        end
        table.insert(NOTES.X, sx)
    end

    -- noteのdstを作成
    do
        local notesDst = {}
        for i = 1, commons.keys do
            notesDst[#notesDst+1] = {
                x = NOTES.X[i], y = LANES.AREA.Y, w = NOTES.W[i], h = LANES.AREA.H
            }
        end

        -- 皿
        notesDst[#notesDst+1] = {
            x = NOTES.X[commons.keys+1], y = LANES.AREA.Y, w = NOTES.SCRATCH_W, h = LANES.AREA.H
        }

        -- 出力
        skin.note.dst = notesDst
    end

    mergeSkin(skin, keyBeam.load())

    return skin
end

notes.functions.dst = function ()
    local keyBeam = require("modules.play.key_beam")
    local laneX = notes.functions.getAreaX()
    local skin = {destination = {}}
    local dst = skin.destination

    --レーン全体の背景
    dst[#dst+1] = {
        id = "black", dst = {
            {x = laneX, y = LANES.AREA.Y, w = LANES.AREA.W, h = LANES.AREA.H, a = getLaneAlpha()}
        }
    }

    -- レーンの左右
    do
        local r, g, b = getDifficultyColor()
        dst[#dst+1] = {
            id = "laneEdge", dst = {
                {x = laneX - LANES.EDGE.W, y = 0, w = LANES.EDGE.W, h = LANES.EDGE.H, r = r, g = g, b = b}
            }
        }
        dst[#dst+1] = {
            id = "laneEdge", dst = {
                {x = laneX + LANES.AREA.W + LANES.EDGE.W, y = 0, w = -LANES.EDGE.W, h = LANES.EDGE.H, r = r, g = g, b = b}
            }
        }
    end

    -- 青レーンの背景
    if isDrawBlueLaneBg() then
        for i = 2, commons.keys, 2 do
            dst[#dst+1] = {
                id = "white", dst = {
                    {x = NOTES.X[i], y = LANES.AREA.Y, w = NOTES.W[i], h = LANES.AREA.H, a = 24}
                }
            }
        end
    end

    mergeSkin(skin, keyBeam.dst())


    -- レーンの区切り線
    for i = 1, commons.keys+1 do
        if (isLeftScratch() and i ~= commons.keys+1) or (not isLeftScratch() and i ~= 1) then
            dst[#dst+1] = {
                id = "white", dst = {
                    {x = NOTES.X[i] - 1, y = LANES.AREA.Y, w = 1, h = LANES.AREA.H}
                }
            }
        end
    end

    -- 判定線
    if isDrawJudgeLine() then
        local r, g, b = getJudgeLineColor()
        dst[#dst+1] = {
            id = "white", dst = {
                {x = laneX, y = LANES.AREA.Y, w = LANES.AREA.W, h = LANES.JUDGE_LINE.H, r = r, g = g, b = b}
            }
        }
    end

    -- アンダーライン
    do
        local r, g, b = getDifficultyColor()
        if isFullScreenBga() or isBgaOnLeft() then
            local x = 0
            if not is1P() then
                x = laneX
            end
            dst[#dst+1] = {
                id = "white", dst = {
                    {x = x, y = LANES.AREA.Y - 2, w = LANES.AREA.W + 75, h = 2, r = r, g = g, b = b}
                }
            }
        else
            dst[#dst+1] = {
                id = "white", dst = {
                    {x = 0, y = LANES.AREA.Y - 2, w = WIDTH, h = 2, r = r, g = g, b = b}
                }
            }
        end
    end
    -- レーンのシンボル
    if isDrawLaneSymbol() then
        local r, g, b = getDifficultyColor()
        for i = 1, commons.keys+1 do
            local id = "turntable"
            local s = SYMBOL.TURNTABLE
            if i ~= commons.keys + 1 and i % 2 == 0 then
                id = "blue"
                s = SYMBOL.BLUE
            end
            if i ~= commons.keys + 1 and i % 2 == 1 then
                id = "white"
                s = SYMBOL.WHITE
            end
            dst[#dst+1] = {
                id = id .. "Symbol", dst = {
                    {x = NOTES.X[i], y = LANES.AREA.Y - s / 2, w = s, h = s, r = r, g = g, b = b}
                }
            }
        end
    end

    dst[#dst+1] = {id = "notes"}

    return skin
end

return notes.functions