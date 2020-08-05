require("modules.commons.define")
require("modules.result.commons")
require("modules.commons.input")
local main_state = require("main_state")
local playLog = require("modules.commons.playlog")


local notesGraph = {
    didLoadPlayData = false,
    activeTabIdx = 1,
    functions = {}
}

local GRAPH = {
    WND_GAUGE = {
        X = RIGHT_X,
        Y = 474,
        W = WND_WIDTH,
        H = 340,
        EDGE = 10,
        SHADOW = 15,
    },
    WND_JUDGE = {
        X = RIGHT_X,
        Y = 116,
        W = WND_WIDTH,
        H = 336,
        EDGE = 10,
        SHADOW = 15,
    },

    GAUGE = {
        X = function (self) return self.WND_GAUGE.X + 10 end,
        Y = function (self) return self.WND_GAUGE.Y + 10 end,
        W = WND_WIDTH - 20, -- 20はEDGE * 2
        H = 320,
        EDGE = 25,
    },

    JUDGE_TEXT = {
        X = 7,
        Y = 75,
        W = 189,
        H = 22,
    },

    GROOVE_TEXT = {
        X = function (self) return self.GAUGE.X(self) + 7 end,
        TOP_Y = function (self) return self.GAUGE.Y(self) + self.GAUGE.H - 5 - self.GROOVE_TEXT.H end,
        BOTTOM_Y = function (self) return self.GAUGE.Y(self) + 5 end,
        Y = 5,
        W = 189,
        H = 22,
    },

    GROOVE_NUM = {
        X = 586, -- グラフエリアからの値
        Y = 295,
        DOT = 1, -- x からの差分 あとでグラフからの差分に再計算
        AF_X = 20, -- x からの差分 あとでグラフからの差分に再計算
        SYMBOL_X = 20, -- x からの差分 あとでグラフからの差分に再計算
    },

    JUDGE_GRAPH = {
        X = 10,
        Y = 224,
        INTERVAL_Y = -107,
        W = WND_WIDTH - 20,
        H = 102,
    },

    DESCRIPTION = {
        X = 404, -- 各グラフからの差分
        Y = 83, -- 各グラフからの差分
        W = 219,
        H = 12,
    },

    TAB = {
        X = function (self) return self.WND_GAUGE.X + self.WND_GAUGE.W end,
        START_Y = function (self) return self.WND_GAUGE.Y + self.WND_GAUGE.H - self.TAB.H - 14 end,
        INTERVAL_Y = 154,
        W = 45,
        H = 158,
        TYPES = {
            GROOVE = 1,
            SCORE = 2,
        },
        PREFIX = {"grooveGauge", "scoreGauge"}
    },

    PREFIX = {"notes", "judges", "el", "timing"}
}

GRAPH.GROOVE_NUM.DOT = GRAPH.GROOVE_NUM.X + GRAPH.GROOVE_NUM.DOT
GRAPH.GROOVE_NUM.AF_X = GRAPH.GROOVE_NUM.X + GRAPH.GROOVE_NUM.AF_X
GRAPH.GROOVE_NUM.SYMBOL_X = GRAPH.GROOVE_NUM.X + GRAPH.GROOVE_NUM.SYMBOL_X

local OPTIONS = {
    IMG = {
        X = function () return GRAPH.GAUGE.X(GRAPH) + 7 end,
        DY_WHEN_DRAW_LABEL = 27,
        W = 147,
        H = 22,
    }
}

local SCORE_GRAPH = {
    RES = {1, 2, 3, 5, 6},
    RES_IDX = 1,
    LINE = {
        MIN_H = 1,
        EXSCORE = {
            COLOR = {
                you = {128, 217, 255},
                best = {64, 255, 64},
                target = {255, 0, 0},
            }
        }
    },
    BG = {
        ALPHA = 128,
        COLORS = { -- rgb
            {128, 105, 52}, -- aaa
            {98, 128, 128}, -- aa
            {128, 52, 102}, -- a
            {98, 128, 98}, -- b
            {128, 54, 78}, -- c
            {0, 0, 0}, -- d
            {0, 0, 0}, -- e
            {0, 0, 0}, -- f
            {0, 0, 0}, -- f_2
        }
    },

    EXSCORE_KEYS = {"best", "target", "you"},
}

local exScores = { -- レートも今はこれを使う
    {
        you = 0,
        best = 0,
        target = 0,
    }
}

--[[
    グルーヴゲージ下の各種グラフの種類を取得

    @param  int pos 上から何番目か 1,2,3は下部分の枠目, 4はグルーヴゲージ部分
    @return int 1:ノーツ数分布, 2:判定分布, 3:EARLY/LATE分布(棒グラフ), 4:タイミング可視化グラフ, 5:無し
]]
notesGraph.functions.getGraphType = function (pos)
    if pos == 4 then
        return (getTableValue(skin_config.option, "各種グラフ グルーヴゲージ部分", 949) % 5) + 1
    end

    if pos < 1 or 3 < pos then return 5 end
    local def = 930
    if pos == 2 then def = 936
    elseif pos == 3 then def = 942
    end
    return (getTableValue(skin_config.option, "各種グラフ" .. pos .. "個目", def) % 5) + 1
end

notesGraph.functions.getGrooveNotesGraphTransparency = function ()
	return 255 - getOffsetValueWithDefault("グルーヴゲージ部分のノーツグラフの透明度 (255で透明)", {a = 0}).a
end

notesGraph.functions.getScoreGraphType = function ()
    return getTableValue(skin_config.option, "スコアグラフ(プレイスキン併用時のみ)", 966) - 965 + 1
end

notesGraph.functions.change2p = function ()
    GRAPH.WND_GAUGE.X = LEFT_X
    GRAPH.WND_JUDGE.X = LEFT_X
end

notesGraph.functions.dstScoreGraph = function ()
    local skin = {destination = {
        {id = "white", dst = {
            {x = GRAPH.GAUGE.X(GRAPH), y = GRAPH.GAUGE.Y(GRAPH), w = GRAPH.GAUGE.W, h = GRAPH.GAUGE.H, r = 0, g = 0, b = 0, a = 96}
        }}
    }}
    local dst = skin.destination
    local data = playLog.loadLog()
    if #data == 0 then return skin end

    local scoreGraphType = notesGraph.functions.getScoreGraphType()

    -- バー周りの情報
    local totalMicroSec = math.max(data[#data].time, math.max(1, playLog.getSongLength()) * 1000000)
    local barW = SCORE_GRAPH.RES[SCORE_GRAPH.RES_IDX]
    local barH = SCORE_GRAPH.LINE.MIN_H
    local timeLenParBar = totalMicroSec / GRAPH.GAUGE.W * barW
    local numOfBar = GRAPH.GAUGE.W / barW
    local maxBarIdx = 0
    local hasBestScore = main_state.number(150) > 0
    -- local maxRate, minRate = 0, 1

    myPrint("totalMicroSec: " .. totalMicroSec)
    myPrint("timeLenParBar: " .. timeLenParBar)
    -- スコア周りの情報集計
    do
        -- local lastBarIdx = 0
        for i = 1, #data do
            local now = data[i]
            local barIdx = math.floor(now.time / timeLenParBar) + 1 -- forの都合で1から開始するために1ずらす

            -- スコア周りのグラフ集計
            if scoreGraphType == 1 then
                exScores[barIdx] = now.exscore
                -- 前のbarを現在の場所の直前まで埋める
                -- if i > 1 then
                --     local last = data[i - 1]
                --     local fillBarIdx = math.floor(last.time / timeLenParBar) + 2
                --     while fillBarIdx < barIdx do
                --         exScores[fillBarIdx] = last.exscore
                --         fillBarIdx = fillBarIdx + 1
                --     end
                -- end
            elseif scoreGraphType == 2 then
                -- スコアレート周りのグラフ集計
                do
                    exScores[barIdx] = now.rangeExScore
                    -- if i > 1 then
                    --     local last = data[i - 1]
                    --     local fillBarIdx = math.floor(last.time / timeLenParBar) + 2
                    --     while fillBarIdx < barIdx do
                    --         exScores[fillBarIdx] = last.rangeExScore
                    --         fillBarIdx = fillBarIdx + 1
                    --     end
                    -- end
                end
            end

            maxBarIdx = barIdx
        end
    end

    -- 背景描画
    -- aaa ~ fまで
    for i = 1, 9 do
        local color = SCORE_GRAPH.BG.COLORS[i]
        local bottomY = GRAPH.GAUGE.Y(GRAPH)
        local graphH = GRAPH.GAUGE.H
        local y = bottomY + graphH - math.ceil(graphH * 0.111111 * (i - 1))
        local nextY = bottomY + graphH - math.ceil(graphH * 0.111111 * i)
        dst[#dst+1] = {
            id = "white", dst = {
                {x = GRAPH.GAUGE.X(GRAPH), y = nextY, w = GRAPH.GAUGE.W, h = y - nextY, r = color[1], g = color[2], b = color[3], a = SCORE_GRAPH.BG.ALPHA}
            }
        }
    end

    -- ノーツグラフ本体
    do
        local type = notesGraph.functions.getGraphType(4)
        if 0 < type and type < 5 then
            local prefix = GRAPH.PREFIX[type]
            local p = getGrooveNotesGraphSizePercentage()
            table.insert(skin.destination, {
                id = prefix .. "Graph", blend = type == 4 and 2 or 1, dst = {
                    {x = GRAPH.GAUGE.X(GRAPH), y = GRAPH.GAUGE.Y(GRAPH), w = GRAPH.JUDGE_GRAPH.W, h = GRAPH.GAUGE.H * p, a = notesGraph.functions.getGrooveNotesGraphTransparency()}
                }
            })
        end
    end

    -- スコア描画
    do
        local nowIdx = 0
        local lastExScore = exScores[1]
        local maxExScore = main_state.number(74) * 2
        local fitstX = GRAPH.GAUGE.X(GRAPH)
        local bottomY = GRAPH.GAUGE.Y(GRAPH)
        local areaH = GRAPH.GAUGE.H - barH -- 引かないとはみ出す
        local colors = SCORE_GRAPH.LINE.EXSCORE.COLOR
        local calcExScoreY = function (s) return bottomY + math.ceil(areaH * s / maxExScore) end
        local calcRateY    = function (s) return bottomY + math.ceil(areaH * s) end
        for i = 1, numOfBar do
            local exScore = exScores[i]
            local x = fitstX + (i - 1) * barW

            for j = 1, #SCORE_GRAPH.EXSCORE_KEYS do
                local key = SCORE_GRAPH.EXSCORE_KEYS[j]
                local color = colors[key]

                if exScore ~= nil then
                    local lastY, y = 0, 0
                    if scoreGraphType == 1 then
                        lastY = calcExScoreY(lastExScore[key])
                        y = calcExScoreY(exScore[key])
                    elseif scoreGraphType == 2 then
                        lastY = calcRateY(lastExScore[key])
                        y = calcRateY(exScore[key])
                    end
                    -- 今回のスコアを描画する
                    local h = y - lastY
                    if h >= 0 then h = h + 1
                    else
                        lastY = lastY + 1
                        h = h - 1
                    end
                    dst[#dst+1] = {
                        id = "white", dst = {
                            {x = x, y = lastY, w = barW, h = h, r = color[1], g = color[2], b = color[3]}
                        }
                    }
                elseif lastExScore ~= nil then
                    -- スコアがなければ, 最後に見たスコアを描画する
                    local lastY = 0

                    if scoreGraphType == 1 then
                        lastY = calcExScoreY(lastExScore[key])
                    elseif scoreGraphType == 2 then
                        lastY = calcRateY(lastExScore[key])
                    end
                    -- 最後の部分までのfill中
                    dst[#dst+1] = {
                        id = "white", dst = {
                            {x = x, y = lastY, w = barW, h = barH, r = color[1], g = color[2], b = color[3]}
                        }
                    }
                end
            end
            if exScore ~= nil then
                lastExScore = exScore
            end
        end
    end
    notesGraph.didLoadPlayData = true
    return skin
end

notesGraph.functions.load = function ()
    SCORE_GRAPH.LINE.MIN_H = getOffsetValueWithDefault("スコアグラフの1マスの高さ (既定値2)", {h = 2}).h
    SCORE_GRAPH.RES_IDX = getOffsetValueWithDefault("スコアグラフの細かさ (既定値2 1~5 小さいほど細かい)", {w = 2}).w
    SCORE_GRAPH.RES_IDX = math.max(1, math.min(SCORE_GRAPH.RES_IDX, 5))
    local skin = {
        image = {
            -- グラフ
            {id = "grooveGaugeFrame", src = 0, x = 0, y = TEXTURE_SIZE - 371, w = GRAPH.WND_GAUGE.W + GRAPH.WND_GAUGE.SHADOW*2, h = GRAPH.WND_GAUGE.H + GRAPH.WND_GAUGE.SHADOW*2},
            {id = "judgeFrame", src = 0, x = GRAPH.WND_GAUGE.W + GRAPH.WND_GAUGE.SHADOW*2, y = TEXTURE_SIZE - 367, w = GRAPH.WND_JUDGE.W + GRAPH.WND_JUDGE.SHADOW*2, h = GRAPH.WND_JUDGE.H + GRAPH.WND_JUDGE.SHADOW*2},
            {id = "notesDescription"  , src = 0, x = 626, y = 168 + GRAPH.DESCRIPTION.H*0, w = GRAPH.DESCRIPTION.W, h = GRAPH.DESCRIPTION.H},
            {id = "judgesDescription" , src = 0, x = 626, y = 168 + GRAPH.DESCRIPTION.H*1, w = GRAPH.DESCRIPTION.W, h = GRAPH.DESCRIPTION.H},
            {id = "elDescription"     , src = 0, x = 626, y = 168 + GRAPH.DESCRIPTION.H*2, w = GRAPH.DESCRIPTION.W, h = GRAPH.DESCRIPTION.H},
            {id = "timingDescription" , src = 999, x = 0, y = 0, w = 1, h = 1},
            {id = "notesGraphText"  , src = 0, x = 199, y = 432 + GRAPH.JUDGE_TEXT.H*0, w = GRAPH.JUDGE_TEXT.W, h = GRAPH.JUDGE_TEXT.H},
            {id = "judgesGraphText" , src = 0, x = 199, y = 432 + GRAPH.JUDGE_TEXT.H*1, w = GRAPH.JUDGE_TEXT.W, h = GRAPH.JUDGE_TEXT.H},
            {id = "elGraphText"     , src = 0, x = 199, y = 432 + GRAPH.JUDGE_TEXT.H*2, w = GRAPH.JUDGE_TEXT.W, h = GRAPH.JUDGE_TEXT.H},
            {id = "timingGraphText" , src = 0, x = 199, y = 432 + GRAPH.JUDGE_TEXT.H*3, w = GRAPH.JUDGE_TEXT.W, h = GRAPH.JUDGE_TEXT.H},
            {id = "grooveGaugeText", src = 0, x = 199, y = 432 + GRAPH.GROOVE_TEXT.H*4, w = GRAPH.GROOVE_TEXT.W, h = GRAPH.GROOVE_TEXT.H},
            -- ランダムオプションはグラフ上に表示
            {id = "randomOptionImgs", src = 0, x = 199, y = 566, w = OPTIONS.IMG.W, h = OPTIONS.IMG.H * 10, divy = 10, ref = 42},
            -- tab
            {id = "grooveGaugeTab", src = 0, x = 0, y = 93, w = GRAPH.TAB.W, h = GRAPH.TAB.H},
            {id = "scoreGaugeTab", src = 0, x = 0, y = 93 + GRAPH.TAB.H, w = GRAPH.TAB.W, h = GRAPH.TAB.H},
            -- スコアグラフを隠すための背景
            {id = "scoreGraphMaskBg", src = getBgSrc(), x = GRAPH.WND_GAUGE.X - GRAPH.WND_GAUGE.SHADOW, y = HEIGHT - GRAPH.WND_GAUGE.Y - GRAPH.WND_GAUGE.H - GRAPH.WND_GAUGE.SHADOW, w = GRAPH.WND_GAUGE.W + GRAPH.WND_GAUGE.SHADOW*2, h = GRAPH.WND_GAUGE.H + GRAPH.WND_GAUGE.SHADOW*2},
        },
        imageset = {},
        value = {
             -- groove gaugeの値
            {id = "grooveGaugeValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = 185, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 3, ref = 107, align = 0},
            {id = "grooveGaugeValueAfterDot", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = 185, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 1, ref = 407, align = 0, padding = 1},
        },
        gaugegraph = {
            {id = "grooveGaugeGraphBg", assistClearBGColor = "440044aa", assistAndEasyFailBGColor = "004444aa", grooveFailBGColor = "004400aa", grooveClearAndHardBGColor = "440000aa", exHardBGColor = "444400aa", hazardBGColor = "444444aa"},
            {id = "grooveGaugeGraphFront", assistClearBGColor = "00000000", assistAndEasyFailBGColor = "00000000", grooveFailBGColor = "00000000", grooveClearAndHardBGColor = "00000000", exHardBGColor = "00000000", hazardBGColor = "00000000", borderColor = "440000cc"}
        },
        judgegraph = {
            {id = "notesGraph", noGap = 1, orderReverse = 0, type = 0, backTexOff = 1},
            {id = "judgesGraph", noGap = 1, orderReverse = 1, type = 1, backTexOff = 1},
            {id = "elGraph", noGap = 1, orderReverse = 1, type = 2, backTexOff = 1},
        },
        timingdistributiongraph = {
            {id = "timingGraph", graphColor = "88FF88FF"},
        },
        customTimers = {
            {
                id = 10102, timer = function ()
                    -- タブ切り替え
                    if notesGraph.didLoadPlayData then
                        if isPressedUp() then
                            myPrint("move tab up")
                            notesGraph.activeTabIdx = notesGraph.activeTabIdx + 1
                            if notesGraph.activeTabIdx > #GRAPH.TAB.PREFIX then
                                notesGraph.activeTabIdx = 1
                            end
                        elseif isPressedDown() then
                            myPrint("move tab down")
                            notesGraph.activeTabIdx = notesGraph.activeTabIdx - 1
                            if notesGraph.activeTabIdx < 1 then
                                notesGraph.activeTabIdx = #GRAPH.TAB.PREFIX
                            end
                        end
                    end
                    return 1
                end
            },
        }
    }

    local imgs = skin.image

    -- オプション読み込み
    local opImgs = {}
    for i = 1, 10 do
        imgs[#imgs+1] = {id = "randomOptionImgs" .. i, src = 0, x = 199, y = 566 + OPTIONS.IMG.H * (i - 1), w = OPTIONS.IMG.W, h = OPTIONS.IMG.H}
        opImgs[#opImgs+1] = "randomOptionImgs" .. i
    end
    skin.imageset[#skin.imageset+1] = {id = "randomOptionImageSet", ref = 42, images = opImgs}
    return skin
end

notesGraph.functions.dstGrooveGaugeArea = function ()
    local skin = {destination = {}}
    -- groove gauge出力
    local grooveX = GRAPH.GAUGE.X(GRAPH)
    local grooveY = GRAPH.GAUGE.Y(GRAPH)
    local getIsDrawGrooveGauge = function () return notesGraph.activeTabIdx == GRAPH.TAB.TYPES.GROOVE end

    -- スコアグラフを描画
    do
        local e, s = pcall(notesGraph.functions.dstScoreGraph)
        if s then
            mergeSkin(skin, s)
        end
    end

    -- スコアグラフを隠すためのマスク
    table.insert(skin.destination, {
        id = "scoreGraphMaskBg", draw = getIsDrawGrooveGauge, dst = {
            {x = GRAPH.WND_GAUGE.X - GRAPH.WND_GAUGE.SHADOW, y = GRAPH.WND_GAUGE.Y - GRAPH.WND_GAUGE.SHADOW, w = GRAPH.WND_GAUGE.W + GRAPH.WND_GAUGE.SHADOW*2, h = GRAPH.WND_GAUGE.H + GRAPH.WND_GAUGE.SHADOW*2}
        }
    })

    table.insert(skin.destination, {
        id = "grooveGaugeGraphBg", draw = getIsDrawGrooveGauge, dst = {
            {x = grooveX, y = grooveY, w = GRAPH.GAUGE.W, h = GRAPH.GAUGE.H}
        }
    })

    -- ノーツグラフ本体
    local type = notesGraph.functions.getGraphType(4)
    if 0 < type and type < 5 then
        local prefix = GRAPH.PREFIX[type]
        local p = getGrooveNotesGraphSizePercentage()
        table.insert(skin.destination, {
            id = prefix .. "Graph", blend = type == 4 and 2 or 1, draw = getIsDrawGrooveGauge, dst = {
                {x = grooveX, y = grooveY, w = GRAPH.JUDGE_GRAPH.W, h = GRAPH.GAUGE.H * p, a = notesGraph.functions.getGrooveNotesGraphTransparency()}
            }
        })
    end

    table.insert(skin.destination, {
        id = "grooveGaugeGraphFront", draw = getIsDrawGrooveGauge, dst = {
            {x = grooveX, y = grooveY, w = GRAPH.GAUGE.W, h = GRAPH.GAUGE.H}
        }
    })

    do
        -- GROOVE GAUGEラベルの出力
        local labelY = getDrawLabelAtTop() and GRAPH.GROOVE_TEXT.TOP_Y(GRAPH) or GRAPH.GROOVE_TEXT.BOTTOM_Y(GRAPH)
        if isDrawGrooveGaugeLabel() then
            table.insert(skin.destination, {
                id = "grooveGaugeText", draw = getIsDrawGrooveGauge, dst = {
                    {x = GRAPH.GROOVE_TEXT.X(GRAPH), y = labelY, w = GRAPH.GROOVE_TEXT.W, h = GRAPH.GROOVE_TEXT.H}
                },
            })
        end
        -- ランダムオプションの出力
        if isDrawPlayOption() then
            local opY = labelY
            if isDrawGrooveGaugeLabel() then
                opY = labelY + OPTIONS.IMG.DY_WHEN_DRAW_LABEL * (getDrawLabelAtTop() and -1 or 1)
            end
            table.insert(skin.destination, {
                id = "randomOptionImageSet", dst = {
                    {x = OPTIONS.IMG.X(), y = opY, w = OPTIONS.IMG.W, h = OPTIONS.IMG.H}
                }
            })
        end
    end
    dstNumberRightJustifyWithDrawFunc(skin, "grooveGaugeValue", grooveX + GRAPH.GROOVE_NUM.X, grooveY + GRAPH.GROOVE_NUM.Y, NUM_24PX.W, NUM_24PX.H, 3, getIsDrawGrooveGauge)
    table.insert(skin.destination, {
        id = "dotFor24PxWhite", draw = getIsDrawGrooveGauge, dst = {
            {x = grooveX + GRAPH.GROOVE_NUM.DOT, y = grooveY + GRAPH.GROOVE_NUM.Y, w = NUM_24PX.DOT_SIZE, h = NUM_24PX.DOT_SIZE}
        }
    })
    dstNumberRightJustifyWithDrawFunc(skin, "grooveGaugeValueAfterDot", grooveX + GRAPH.GROOVE_NUM.AF_X, grooveY + GRAPH.GROOVE_NUM.Y, NUM_24PX.W, NUM_24PX.H, 1, getIsDrawGrooveGauge)
    table.insert(skin.destination, {
        id = "percentageFor24PxWhite", draw = getIsDrawGrooveGauge, dst = {
            {x = grooveX + GRAPH.GROOVE_NUM.SYMBOL_X, y = grooveY + GRAPH.GROOVE_NUM.Y, w = NUM_24PX.PERCENT.W, h = NUM_24PX.PERCENT.H}
        }
    })

    -- 非アクティブタブを下に
    for i = 1, #GRAPH.TAB.PREFIX do
        table.insert(skin.destination,{
            id = GRAPH.TAB.PREFIX[i] .. "Tab", draw = function () return notesGraph.activeTabIdx ~= i and notesGraph.didLoadPlayData end, dst = {
                {x = GRAPH.TAB.X(GRAPH), y = GRAPH.TAB.START_Y(GRAPH) - GRAPH.TAB.INTERVAL_Y * (i - 1), w = GRAPH.TAB.W, h = GRAPH.TAB.H}
            }
        })
    end
    table.insert(skin.destination, {
        id = "grooveGaugeFrame", dst = {
            {
                x = GRAPH.WND_GAUGE.X - GRAPH.WND_GAUGE.SHADOW, y = GRAPH.WND_GAUGE.Y - GRAPH.WND_GAUGE.SHADOW,
                w = GRAPH.WND_GAUGE.W + GRAPH.WND_GAUGE.SHADOW * 2, h = GRAPH.WND_GAUGE.H + GRAPH.WND_GAUGE.SHADOW * 2
            }
        }
    })
    -- アクティブタブを上に
    for i = 1, #GRAPH.TAB.PREFIX do
        table.insert(skin.destination,{
            id = GRAPH.TAB.PREFIX[i] .. "Tab", draw = function () return notesGraph.activeTabIdx == i and notesGraph.didLoadPlayData end, dst = {
                {x = GRAPH.TAB.X(GRAPH), y = GRAPH.TAB.START_Y(GRAPH) - GRAPH.TAB.INTERVAL_Y * (i - 1), w = GRAPH.TAB.W, h = GRAPH.TAB.H}
            }
        })
    end

    return skin
end

notesGraph.functions.dstJudgeGaugeArea = function ()
    local skin = {destination = {}}
    -- グラフ出力
    for i = 1, 3 do
        local type = notesGraph.functions.getGraphType(i)
        if 0 < type and type < 5 then
            local x = GRAPH.WND_JUDGE.X + GRAPH.JUDGE_GRAPH.X
            local y = GRAPH.WND_JUDGE.Y + GRAPH.JUDGE_GRAPH.Y + GRAPH.JUDGE_GRAPH.INTERVAL_Y * (i - 1)
            local prefix = GRAPH.PREFIX[type]
            -- 黒背景
            table.insert(skin.destination, {
                id = "black", dst = {
                    {x = x, y = y, w = GRAPH.JUDGE_GRAPH.W, h = GRAPH.JUDGE_GRAPH.H, a = 128}
                }
            })
            -- グラフ本体
            table.insert(skin.destination, {
                id = prefix .. "Graph", blend = type == 4 and 2 or 1, dst = {
                    {x = x, y = y, w = GRAPH.JUDGE_GRAPH.W, h = GRAPH.JUDGE_GRAPH.H}
                }
            })
            -- グラフ種別文字
            table.insert(skin.destination, {
                id = prefix .. "GraphText", dst = {
                    {x = x + GRAPH.JUDGE_TEXT.X, y = y + GRAPH.JUDGE_TEXT.Y, w = GRAPH.JUDGE_TEXT.W, h = GRAPH.JUDGE_TEXT.H}
                }
            })
            -- グラフ項目
            table.insert(skin.destination, {
                id = prefix .. "Description", dst = {
                    {x = x + GRAPH.DESCRIPTION.X, y = y + GRAPH.DESCRIPTION.Y, w = GRAPH.DESCRIPTION.W, h = GRAPH.DESCRIPTION.H}
                }
            })
        end
    end
    -- グラフフレーム
    table.insert(skin.destination, {
        id = "judgeFrame", dst = {
            {
                x = GRAPH.WND_JUDGE.X - GRAPH.WND_JUDGE.SHADOW, y = GRAPH.WND_JUDGE.Y - GRAPH.WND_JUDGE.SHADOW,
                w = GRAPH.WND_JUDGE.W + GRAPH.WND_JUDGE.SHADOW * 2, h = GRAPH.WND_JUDGE.H + GRAPH.WND_JUDGE.SHADOW * 2
            }
        }
    })
    return skin
end

notesGraph.functions.dst= function ()
    local skin = {destination = {}}
    mergeSkin(skin, notesGraph.functions.dstGrooveGaugeArea())
    mergeSkin(skin, notesGraph.functions.dstJudgeGaugeArea())
    return skin
end

return notesGraph.functions