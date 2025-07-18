require("modules.commons.define")
local commons = require("modules.play.commons")
local main_state = require("main_state")

local notes = {
    functions = {}
}

local rhythm = {
    elapsedTimerTime = 0,
}

local NOTES = {
    X = {},
    W = {52, 42, 52, 42, 52, 42, 52},
    DX = {46, 26, 21},
    DY = 12,
    SIZES = {
        W = {184, 104, 84},
        X = {184, 368, 472},
        NOTE = 24,
        MINE = 24,
        H = 48,
        LN_START_H = 38,
    },

    SCRATCH_W = 92,
    SPACE = 1,
}

local LANES = {
    AREA = {
        W = 432,
        H = 723,
        X = nil,
        X_1 = function (self) return self.AREA.SPACE end,
        X_2 = function (self) return WIDTH - self.AREA.W - self.AREA.SPACE end,
        Y = 357,
        EXTEND_Y = 357 - 84,
        EXTEND_H = 723 + 84,
        SPACE = 75,
    },
    SIDE = {
        W = 18,
        H = HEIGHT,
    },
    SEPARATOR = {
        W = 1,
        A = 92,
    },
    JUDGE_LINE = {
        W = 436,
        H = 64,
        X = function (self) return self.AREA.X(self) - 2 end,
        Y = function (self) return self.AREA.Y - 32 end,
    },
    -- レーンサイドの画像判定. 手前のidxから優先して判定
    STATES = {
        FUNCS = {
            function () return main_state.judge(2) + main_state.judge(3) + main_state.judge(4) == 0 end,
            function () return main_state.judge(2) > 0 and main_state.judge(3) + main_state.judge(4) == 0 end,
            function () return main_state.gauge() > 0 and main_state.gauge_type() >= 3 end,
            function () return main_state.option(1240) and main_state.gauge_type() < 3 end,
            function () return true end,
        },
        ENUM = {
            NO_GOOD = 1,
            NO_MISS = 2,
            SURVIVAL = 3,
            CLEAR = 4,
            FAIL = 5,
        },
        SUFFIX = {"NoGood", "NoMiss", "Survival", "Clear", "Fail"}
    },
    ANIMATION = {
        SIDE_MOVE = 8000,
    }
}

local lanes = {
    nowGaugeState = LANES.STATES.ENUM.NO_GOOD,
}

-- local SYMBOL = {
--     WHITE = 52,
--     BLUE = 42,
--     TURNTABLE = 91,
-- }

local function getJudgeLineColor()
	local dif = getDifficultyValueForColor()
	local colors = {{255, 255, 255}, {137, 204, 137}, {137, 204, 204}, {204, 164, 108}, {204, 104, 104}, {204, 102, 153}}
	return colors[dif][1], colors[dif][2], colors[dif][3]
end

local function getLaneSideColor()
	local dif = getDifficultyValueForColor()
	local colors = {{255, 255, 255}, {137, 204, 137}, {137, 204, 204}, {204, 164, 108}, {204, 104, 104}, {204, 102, 153}}
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

notes.functions.getAreaNormalY = function ()
    return LANES.AREA.Y
end

notes.functions.getAreaY = function ()
    return isVerticalGrooveGauge() and LANES.AREA.EXTEND_Y or LANES.AREA.Y
end

notes.functions.getInnerAreaY = function ()
    return notes.functions.getAreaY()
end

notes.functions.getOurterAreaY = function ()
    return notes.functions.getAreaY() - 2
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

notes.functions.getLaneCenterX = function (key)
    local x = notes.functions.getLaneX(key)
    local w = notes.functions.getLaneW(key)
    return x + w / 2
end

notes.functions.getLaneNormalHeight = function ()
    return LANES.AREA.H
end

notes.functions.getLaneHeight = function ()
    return isVerticalGrooveGauge() and LANES.AREA.EXTEND_H or LANES.AREA.H
end

notes.functions.getSideSpace = function ()
    return LANES.AREA.SPACE
end

notes.functions.load = function ()
    local keyBeam = require("modules.play.key_beam")
    local cover = require("modules.play.cover")
    local laneX = notes.functions.getAreaX()
    if is1P() then
        LANES.AREA.X = LANES.AREA.X_1
    else
        LANES.AREA.X = LANES.AREA.X_2
    end

    LANES.ANIMATION.SIDE_MOVE = 1000 * getLaneSideAnimationTime()

    local nx = NOTES.SIZES.X
    local skin = {
        image = {
            -- シンボル
            {id = "judgeLineLayer1", src = 83, x = 0, y = 0, w = -1, h = -1},
            {id = "judgeLineLayer2", src = 84, x = 0, y = 0, w = -1, h = -1},
        },
        customTimers = {
            {
                -- 付属のtimerは小節ごとにリセットされるので, 足し続けるタイマーを作成
                id = CUSTOM_TIMERS.MY_BPM_TIMER, timer = function ()
                    if main_state.timer(140) > 0 then
                        -- ソフラン時に多少の誤差がでるが許容する
                        -- 時間のたつ速さ倍率
                        local timeMul = main_state.number(160) / 60
                        rhythm.elapsedTimerTime = rhythm.elapsedTimerTime + getDeltaTime() * timeMul
                        return main_state.time() - rhythm.elapsedTimerTime
                    end
                    return main_state.time()
                end
            },
            {
                id = CUSTOM_TIMERS.UPDATE_GAUGE_STATE, timer = function ()
                    for i, f in ipairs(LANES.STATES.FUNCS) do
                        if f() then
                            -- ゲージの状態を満たしていたら書き込んで終わり
                            lanes.nowGaugeState = i
                            return 1
                        end
                    end
                    return 1
                end
            }
        },
    }

    local imgs = skin.image

    -- レーンのサイドの画像読み込み
    do
        for i, suffix in ipairs(LANES.STATES.SUFFIX) do
            if getIsChangeLaneSideByGaugeState() then
                imgs[#imgs+1] = {
                    id = "laneSide" .. suffix, src = 88 + (i - 1), x = 0, y = 0, w = -1, h = -1
                }
            else
                imgs[#imgs+1] = {
                    id = "laneSide" .. suffix, src = 80, x = 0, y = 0, w = -1, h = -1
                }
            end
        end
    end

    if getNoteType() == 1 then
        -- 独自形式
        local skin2 = {
            image = {
                {id = "note-b", src = 81, x = nx[3], y = 0, w = NOTES.SIZES.W[3], h = NOTES.SIZES.H},
                {id = "note-w", src = 81, x = nx[2], y = 0, w = NOTES.SIZES.W[2], h = NOTES.SIZES.H},
                {id = "note-s", src = 81, x = nx[1], y = 0, w = NOTES.SIZES.W[1], h = NOTES.SIZES.H},

                {id = "lns-b", src = 81, x = nx[3], y = 144, w = NOTES.SIZES.W[3], h = NOTES.SIZES.LN_START_H},
                {id = "lns-w", src = 81, x = nx[2], y = 144, w = NOTES.SIZES.W[2], h = NOTES.SIZES.LN_START_H},
                {id = "lns-s", src = 81, x = nx[1], y = 144, w = NOTES.SIZES.W[1], h = NOTES.SIZES.LN_START_H},

                {id = "lne-b", src = 81, x = nx[3], y = 96, w = NOTES.SIZES.W[3], h = NOTES.SIZES.H},
                {id = "lne-w", src = 81, x = nx[2], y = 96, w = NOTES.SIZES.W[2], h = NOTES.SIZES.H},
                {id = "lne-s", src = 81, x = nx[1], y = 96, w = NOTES.SIZES.W[1], h = NOTES.SIZES.H},

                {id = "lnb-b", src = 81, x = nx[3], y = 260, w = NOTES.SIZES.W[3], h = 1},
                {id = "lnb-w", src = 81, x = nx[2], y = 260, w = NOTES.SIZES.W[2], h = 1},
                {id = "lnb-s", src = 81, x = nx[1], y = 260, w = NOTES.SIZES.W[1], h = 1},

                {id = "lna-b", src = 81, x = nx[3], y = 192, w = NOTES.SIZES.W[3], h = 1},
                {id = "lna-w", src = 81, x = nx[2], y = 192, w = NOTES.SIZES.W[2], h = 1},
                {id = "lna-s", src = 81, x = nx[1], y = 192, w = NOTES.SIZES.W[1], h = 1},

                {id = "hcns-b", src = 81, x = nx[3], y = 336, w = NOTES.SIZES.W[3], h = NOTES.SIZES.LN_START_H},
                {id = "hcns-w", src = 81, x = nx[2], y = 336, w = NOTES.SIZES.W[2], h = NOTES.SIZES.LN_START_H},
                {id = "hcns-s", src = 81, x = nx[1], y = 336, w = NOTES.SIZES.W[1], h = NOTES.SIZES.LN_START_H},

                {id = "hcne-b", src = 81, x = nx[3], y = 288, w = NOTES.SIZES.W[3], h = NOTES.SIZES.H},
                {id = "hcne-w", src = 81, x = nx[2], y = 288, w = NOTES.SIZES.W[2], h = NOTES.SIZES.H},
                {id = "hcne-s", src = 81, x = nx[1], y = 288, w = NOTES.SIZES.W[1], h = NOTES.SIZES.H},

                {id = "hcnb-b", src = 81, x = nx[3], y = 528, w = NOTES.SIZES.W[3], h = 1},
                {id = "hcnb-w", src = 81, x = nx[2], y = 528, w = NOTES.SIZES.W[2], h = 1},
                {id = "hcnb-s", src = 81, x = nx[1], y = 528, w = NOTES.SIZES.W[1], h = 1},

                {id = "hcna-b", src = 81, x = nx[3], y = 384, w = NOTES.SIZES.W[3], h = 1},
                {id = "hcna-w", src = 81, x = nx[2], y = 384, w = NOTES.SIZES.W[2], h = 1},
                {id = "hcna-s", src = 81, x = nx[1], y = 384, w = NOTES.SIZES.W[1], h = 1},

                {id = "hcnd-b", src = 81, x = nx[3], y = 480, w = NOTES.SIZES.W[3], h = 1},
                {id = "hcnd-w", src = 81, x = nx[2], y = 480, w = NOTES.SIZES.W[2], h = 1},
                {id = "hcnd-s", src = 81, x = nx[1], y = 480, w = NOTES.SIZES.W[1], h = 1},

                {id = "hcnr-b", src = 81, x = nx[3], y = 432, w = NOTES.SIZES.W[3], h = 1},
                {id = "hcnr-w", src = 81, x = nx[2], y = 432, w = NOTES.SIZES.W[2], h = 1},
                {id = "hcnr-s", src = 81, x = nx[1], y = 432, w = NOTES.SIZES.W[1], h = 1},

                {id = "mine-b", src = 81, x = nx[3], y = 48, w = NOTES.SIZES.W[3], h = NOTES.SIZES.H},
                {id = "mine-w", src = 81, x = nx[2], y = 48, w = NOTES.SIZES.W[2], h = NOTES.SIZES.H},
                {id = "mine-s", src = 81, x = nx[1], y = 48, w = NOTES.SIZES.W[1], h = NOTES.SIZES.H},    
            }
        }
        mergeSkin(skin, skin2)
    elseif getNoteType() == 0 then
        local skin2 = {
            image = {
                {id = "note-b", src = 82, x = 127, y = 5, w = 21, h = 12},
                {id = "note-w", src = 82, x = 99, y = 5, w = 27, h = 12},
                {id = "note-s", src = 82, x = 50, y = 5, w = 46, h = 12},

                {id = "lns-b", src = 82, x = 127, y = 57, w = 21, h = 13},
                {id = "lns-w", src = 82, x = 99, y = 57, w = 27, h = 13},
                {id = "lns-s", src = 82, x = 50, y = 57, w = 46, h = 12},

                {id = "lne-b", src = 82, x = 127, y = 43, w = 21, h = 13},
                {id = "lne-w", src = 82, x = 99, y = 43, w = 27, h = 13},
                {id = "lne-s", src = 82, x = 50, y = 43, w = 46, h = 12},

                {id = "lnb-b", src = 82, x = 127, y = 80, w = 21, h = 1},
                {id = "lnb-w", src = 82, x = 99, y = 80, w = 27, h = 1},
                {id = "lnb-s", src = 82, x = 50, y = 80, w = 46, h = 1},

                {id = "lna-b", src = 82, x = 127, y = 76, w = 21, h = 1},
                {id = "lna-w", src = 82, x = 99, y = 76, w = 27, h = 1},
                {id = "lna-s", src = 82, x = 50, y = 76, w = 46, h = 1},

                {id = "hcns-b", src = 82, x = 127, y = 108, w = 21, h = 13},
                {id = "hcns-w", src = 82, x = 99, y = 108, w = 27, h = 13},
                {id = "hcns-s", src = 82, x = 50, y = 108, w = 46, h = 12},

                {id = "hcne-b", src = 82, x = 127, y = 94, w = 21, h = 13},
                {id = "hcne-w", src = 82, x = 99, y = 94, w = 27, h = 13},
                {id = "hcne-s", src = 82, x = 50, y = 94, w = 46, h = 12},

                {id = "hcnb-b", src = 82, x = 127, y = 131, w = 21, h = 1},
                {id = "hcnb-w", src = 82, x = 99, y = 131, w = 27, h = 1},
                {id = "hcnb-s", src = 82, x = 50, y = 131, w = 46, h = 1},

                {id = "hcna-b", src = 82, x = 127, y = 127, w = 21, h = 1},
                {id = "hcna-w", src = 82, x = 99, y = 127, w = 27, h = 1},
                {id = "hcna-s", src = 82, x = 50, y = 127, w = 46, h = 1},

                {id = "hcnd-b", src = 82, x = 127, y = 128, w = 21, h = 1},
                {id = "hcnd-w", src = 82, x = 99, y = 128, w = 27, h = 1},
                {id = "hcnd-s", src = 82, x = 50, y = 128, w = 46, h = 1},

                {id = "hcnr-b", src = 82, x = 127, y = 129, w = 21, h = 1},
                {id = "hcnr-w", src = 82, x = 99, y = 129, w = 27, h = 1},
                {id = "hcnr-s", src = 82, x = 50, y = 129, w = 46, h = 1},

                {id = "mine-b", src = 82, x = 127, y = 23, w = 21, h = 8},
                {id = "mine-w", src = 82, x = 99, y = 23, w = 27, h = 8},
                {id = "mine-s", src = 82, x = 50, y = 23, w = 46, h = 8},
            }
        }
        mergeSkin(skin, skin2)
    end
    if commons.keys == 7 then
        skin.note = {
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
    elseif commons.keys == 5 then
        skin.note = {
            id = "notes",
            note = {"note-w","note-b","note-w","note-b","note-w","note-s"},
            lnend = {"lne-w","lne-b","lne-w","lne-b","lne-w","lne-s"},
            lnstart = {"lns-w","lns-b","lns-w","lns-b","lns-w","lns-s"},
            lnbody = {"lnb-w","lnb-b","lnb-w","lnb-b","lnb-w","lnb-s"},
            lnactive = {"lna-w","lna-b","lna-w","lna-b","lna-w","lna-s"},
            hcnend = {"hcne-w","hcne-b","hcne-w","hcne-b","hcne-w","hcne-s"},
            hcnstart = {"hcns-w","hcns-b","hcns-w","hcns-b","hcns-w","hcns-s"},
            hcnbody = {"hcnb-w","hcnb-b","hcnb-w","hcnb-b","hcnb-w","hcnb-s"},
            hcnactive = {"hcna-w","hcna-b","hcna-w","hcna-b","hcna-w","hcna-s"},
            hcndamage = {"hcnd-w","hcnd-b","hcnd-w","hcnd-b","hcnd-w","hcnd-s"},
            hcnreactive = {"hcnr-w","hcnr-b","hcnr-w","hcnr-b","hcnr-w","hcnr-s"},
            mine = {"mine-w","mine-b","mine-w","mine-b","mine-w","mine-s"},
            hidden = {},
            processed = {},
            dst = {},
            -- 小節線配置 offset3指定でliftの値を考慮した座標になる
            group = {
                {id = "white", offset = 3, dst = {
                    {x = laneX, y = notes.functions.getAreaY(), w = LANES.AREA.W, h = 3, r = 128, g = 128, b = 128}
                }}
            },
            time = {
                {id = "white", offset = 3, dst = {
                    {x = laneX, y = notes.functions.getAreaY(), w = LANES.AREA.W, h = 3, r = 64, g = 192, b = 192}
                }}
            },
            bpm = {
                {id = "white", offset = 3, dst = {
                    {x = laneX, y = notes.functions.getAreaY(), w = LANES.AREA.W, h = 6, r = 0, g = 192, b = 0}
                }}
            },
            stop = {
                {id = "white", offset = 3, dst = {
                    {x = laneX, y = notes.functions.getAreaY(), w = LANES.AREA.W, h = 6, r = 192, g = 192, b = 0}
                }}
            }
        }
    end


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
        if getNoteType() == 1 then
            for i = 1, commons.keys do
                local dx = (i % 2 == 1) and NOTES.DX[2] or NOTES.DX[3]
                local size = (i % 2 == 1) and NOTES.SIZES.W[2] or NOTES.SIZES.W[3]
                notesDst[#notesDst+1] = {
                    x = NOTES.X[i] - dx, y = notes.functions.getAreaY() - NOTES.DY, w = size, h = notes.functions.getLaneHeight() + NOTES.DY
                }
            end
            -- 皿
            notesDst[#notesDst+1] = {
                x = NOTES.X[commons.keys+1] - NOTES.DX[1], y = notes.functions.getAreaY() - NOTES.DY, w = NOTES.SIZES.W[1], h = notes.functions.getLaneHeight() + NOTES.DY
            }
        else
            for i = 1, commons.keys do
                notesDst[#notesDst+1] = {
                    x = NOTES.X[i], y = notes.functions.getAreaY(), w = NOTES.W[i], h = notes.functions.getLaneHeight()
                }
            end
            -- 皿
            notesDst[#notesDst+1] = {
                x = NOTES.X[commons.keys+1], y = notes.functions.getAreaY(), w = NOTES.SCRATCH_W, h = notes.functions.getLaneHeight()
            }
        end
        -- 出力
        skin.note.dst = notesDst
    end

    mergeSkin(skin, keyBeam.load())
    mergeSkin(skin, cover.load())

    return skin
end

notes.functions.dst = function ()
    local keyBeam = require("modules.play.key_beam")
    local cover = require("modules.play.cover")
    local grow = require("modules.play.grow")
    local laneX = notes.functions.getAreaX()
    local skin = {destination = {}}
    local dst = skin.destination

    --レーン全体の背景
    dst[#dst+1] = {
        id = "black", dst = {
            {x = laneX, y = notes.functions.getAreaY(), w = LANES.AREA.W, h = notes.functions.getLaneHeight(), a = 255 - getLaneAlpha()}
        }
    }

    -- レーンの左右
    do
        local r, g, b = getLaneSideColor()
        if not getIsLaneSideColorToMatchDifficulyColor() then
            r, g, b = 255, 255, 255
        end
        for i, suffix in ipairs(LANES.STATES.SUFFIX) do
            local d = function () return i == lanes.nowGaugeState end

            if LANES.ANIMATION.SIDE_MOVE <= 0 then
                -- アニメーションなし時
                dst[#dst+1] = {
                    id = "laneSide" .. suffix, draw = d, timer = CUSTOM_TIMERS.MY_BPM_TIMER, dst = {
                        {x = laneX, y = 0, w = -LANES.SIDE.W, h = LANES.SIDE.H, r = r, g = g, b = b},
                    }
                }
                dst[#dst+1] = {
                    id = "laneSide" .. suffix, draw = d, timer = CUSTOM_TIMERS.MY_BPM_TIMER, dst = {
                        {x = laneX + LANES.AREA.W, y = 0, w = LANES.SIDE.W, h = LANES.SIDE.H, r = r, g = g, b = b},
                    }
                }
            else
                if false then
                    -- 通常時
                    -- 上
                    dst[#dst+1] = {
                        id = "laneSide" .. suffix, draw = d, timer = CUSTOM_TIMERS.MY_BPM_TIMER, dst = {
                            {time = 0, x = laneX, y = 0, w = -LANES.SIDE.W, h = LANES.SIDE.H, r = r, g = g, b = b},
                            {time = LANES.ANIMATION.SIDE_MOVE, y = LANES.SIDE.H},
                        }
                    }
                    dst[#dst+1] = {
                        id = "laneSide" .. suffix, draw = d, timer = CUSTOM_TIMERS.MY_BPM_TIMER, dst = {
                            {time = 0, x = laneX + LANES.AREA.W, y = 0, w = LANES.SIDE.W, h = LANES.SIDE.H, r = r, g = g, b = b},
                            {time = LANES.ANIMATION.SIDE_MOVE, y = LANES.SIDE.H},
                        }
                    }
                    -- 下
                    dst[#dst+1] = {
                        id = "laneSide" .. suffix, draw = d, timer = CUSTOM_TIMERS.MY_BPM_TIMER, dst = {
                            {time = 0, x = laneX, y = -LANES.SIDE.H, w = -LANES.SIDE.W, h = LANES.SIDE.H, r = r, g = g, b = b},
                            {time = LANES.ANIMATION.SIDE_MOVE, y = 0},
                        }
                    }
                    dst[#dst+1] = {
                        id = "laneSide" .. suffix, draw = d, timer = CUSTOM_TIMERS.MY_BPM_TIMER, dst = {
                            {time = 0, x = laneX + LANES.AREA.W, y = -LANES.SIDE.H, w = LANES.SIDE.W, h = LANES.SIDE.H, r = r, g = g, b = b},
                            {time = LANES.ANIMATION.SIDE_MOVE, y = 0},
                        }
                    }
                else
                    -- 反転時
                    -- 上
                    dst[#dst+1] = {
                        id = "laneSide" .. suffix, draw = d, timer = CUSTOM_TIMERS.MY_BPM_TIMER, dst = {
                            {time = 0, x = laneX, y = 0, w = -LANES.SIDE.W, h = LANES.SIDE.H, r = r, g = g, b = b},
                            {time = LANES.ANIMATION.SIDE_MOVE * 2, y = LANES.SIDE.H * 2},
                        }
                    }
                    dst[#dst+1] = {
                        id = "laneSide" .. suffix, draw = d, timer = CUSTOM_TIMERS.MY_BPM_TIMER, dst = {
                            {time = 0, x = laneX + LANES.AREA.W, y = 0, w = LANES.SIDE.W, h = LANES.SIDE.H, r = r, g = g, b = b},
                            {time = LANES.ANIMATION.SIDE_MOVE * 2, y = LANES.SIDE.H * 2},
                        }
                    }
                    dst[#dst+1] = {
                        id = "laneSide" .. suffix, draw = d, timer = CUSTOM_TIMERS.MY_BPM_TIMER, dst = {
                            {time = 0, x = laneX, y = -9999, w = -LANES.SIDE.W, h = LANES.SIDE.H, r = r, g = g, b = b},
                            {time = LANES.ANIMATION.SIDE_MOVE, y = -LANES.SIDE.H},
                            {time = LANES.ANIMATION.SIDE_MOVE * 2, y = 0},
                        }
                    }
                    dst[#dst+1] = {
                        id = "laneSide" .. suffix, draw = d, timer = CUSTOM_TIMERS.MY_BPM_TIMER, dst = {
                            {time = 0, x = laneX + LANES.AREA.W, y = -9999, w = LANES.SIDE.W, h = LANES.SIDE.H, r = r, g = g, b = b},
                            {time = LANES.ANIMATION.SIDE_MOVE, y = -LANES.SIDE.H},
                            {time = LANES.ANIMATION.SIDE_MOVE * 2, y = 0},
                        }
                    }
                    -- 下
                    dst[#dst+1] = {
                        id = "laneSide" .. suffix, draw = d, timer = CUSTOM_TIMERS.MY_BPM_TIMER, dst = {
                            {time = 0, x = laneX, y = 0, w = -LANES.SIDE.W, h = -LANES.SIDE.H, r = r, g = g, b = b},
                            {time = LANES.ANIMATION.SIDE_MOVE * 2, y = LANES.SIDE.H * 2},
                        }
                    }
                    dst[#dst+1] = {
                        id = "laneSide" .. suffix, draw = d, timer = CUSTOM_TIMERS.MY_BPM_TIMER, dst = {
                            {time = 0, x = laneX + LANES.AREA.W, y = 0, w = LANES.SIDE.W, h = -LANES.SIDE.H, r = r, g = g, b = b},
                            {time = LANES.ANIMATION.SIDE_MOVE * 2, y = LANES.SIDE.H * 2},
                        }
                    }
                end
            end
        end
    end

    -- 青レーンの背景
    if isDrawBlueLaneBg() then
        for i = 2, commons.keys, 2 do
            dst[#dst+1] = {
                id = "white", dst = {
                    {x = NOTES.X[i], y = notes.functions.getAreaY(), w = NOTES.W[i], h = notes.functions.getLaneHeight(), a = 24}
                }
            }
        end
    end

    -- レーンの区切り線
    if isDrawSeparator() then
        for i = 1, commons.keys+1 do
            if (isLeftScratch() and i ~= commons.keys+1) or (not isLeftScratch() and i ~= 1) then
                dst[#dst+1] = {
                    id = "white", dst = {
                        {x = NOTES.X[i] - 1, y = notes.functions.getAreaY(), w = 1, h = notes.functions.getLaneHeight(), a = 96}
                    }
                }
            end
        end
    end

    mergeSkin(skin, cover.dstOtherCover())
    mergeSkin(skin, keyBeam.dst())
    dst[#dst+1] = {id = "notes"}
    mergeSkin(skin, cover.dstLaneCover())
    mergeSkin(skin, grow.dst())

    -- 判定線
    if isDrawJudgeLine() then
        local r, g, b = getJudgeLineColor()
        if not getIsJudgeLineLayer1ColorToMatchDifficulyColor() then
            r, g, b = 255, 255, 255
        end
        local r2, g2, b2 = getJudgeLineColor()
        if not getIsJudgeLineLayer2ColorToMatchDifficulyColor() then
            r2, g2, b2 = 255, 255, 255
        end
        local x = LANES.JUDGE_LINE.X(LANES)
        local y = LANES.JUDGE_LINE.Y(LANES)
        local w = LANES.JUDGE_LINE.W
        local h = LANES.JUDGE_LINE.H
        if not isLeftScratch() then
            x = x + w
            w = -w
        end
        dst[#dst+1] = {
            id = "judgeLineLayer1", offsets = {3}, dst = {
                {x = x, y = y, w = w, h = h, r = r, g = g, b = b}
            }
        }
        dst[#dst+1] = {
            id = "judgeLineLayer2", offsets = {3}, dst = {
                {x = x, y = y, w = w, h = h, r = r2, g = g2, b = b2}
            }
        }
    end

    return skin
end

return notes.functions