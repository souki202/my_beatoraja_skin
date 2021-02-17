require("modules.commons.define")
require("modules.result.commons")
require("modules.commons.input")
local main_state = require("main_state")
local ranking = require("modules.result.ranking")
local scoreGraph = require("modules.result.score_graph")


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
        W = 210,
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
        X = function (self) return WIDTH - self.TAB.W end,
        START_Y = function (self) return self.WND_GAUGE.Y + self.WND_GAUGE.H - self.TAB.H - 1 end,
        Y = function (self, idx) return self.TAB.START_Y(self) - self.TAB.INTERVAL_Y * (idx - 1) end,
        INTERVAL_Y = 64,
        W = 58,
        H = 74,
        TYPES = {
            GROOVE = 1,
            CUSTOM_GROOVE = 2,
            SCORE = 3,
            RANKING = 4,
            LAMPS = 5,
        },
        BUTTON = {
            X = function (self) return self.TAB.X(self) + 18 end,
            Y = function (self, idx) return self.TAB.Y(self, idx) + 17 end,
            W = 40,
            H = 40,
        },
        PREFIX = {"grooveGauge", "customGrooveGauge", "scoreGauge", "ranking", "lampsGraph"}
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

notesGraph.functions.change2p = function ()
    GRAPH.WND_GAUGE.X = LEFT_X
    GRAPH.WND_JUDGE.X = LEFT_X
    scoreGraph.change2p()
    ranking.change2p()
end

notesGraph.functions.switchTab = function (tabIdx)
    myPrint("タブクリック: " .. tabIdx)
    notesGraph.activeTabIdx = tabIdx
end

notesGraph.functions.dstScoreGraph = function ()
    notesGraph.didLoadPlayData = true
    return scoreGraph.dst(GRAPH.GAUGE.X(GRAPH), GRAPH.GAUGE.Y(GRAPH), GRAPH.GAUGE.H)
end

notesGraph.functions.load = function ()
    local skin = {
        image = {
            -- グラフ
            {id = "grooveGaugeFrame", src = 0, x = 0, y = TEXTURE_SIZE - 371, w = GRAPH.WND_GAUGE.W + GRAPH.WND_GAUGE.SHADOW*2, h = GRAPH.WND_GAUGE.H + GRAPH.WND_GAUGE.SHADOW*2},
            {id = "judgeFrame", src = 0, x = GRAPH.WND_GAUGE.W + GRAPH.WND_GAUGE.SHADOW*2, y = TEXTURE_SIZE - 367, w = GRAPH.WND_JUDGE.W + GRAPH.WND_JUDGE.SHADOW*2, h = GRAPH.WND_JUDGE.H + GRAPH.WND_JUDGE.SHADOW*2},
            {id = "notesDescription"  , src = 0, x = 626, y = 168 + GRAPH.DESCRIPTION.H*0, w = GRAPH.DESCRIPTION.W, h = GRAPH.DESCRIPTION.H},
            {id = "judgesDescription" , src = 0, x = 626, y = 168 + GRAPH.DESCRIPTION.H*1, w = GRAPH.DESCRIPTION.W, h = GRAPH.DESCRIPTION.H},
            {id = "elDescription"     , src = 0, x = 626, y = 168 + GRAPH.DESCRIPTION.H*2, w = GRAPH.DESCRIPTION.W, h = GRAPH.DESCRIPTION.H},
            {id = "timingDescription" , src = 999, x = 0, y = 0, w = 1, h = 1},
            {id = "notesGraphText"       , src = 9, x = 0, y = GRAPH.JUDGE_TEXT.H*0, w = GRAPH.JUDGE_TEXT.W, h = GRAPH.JUDGE_TEXT.H},
            {id = "judgesGraphText"      , src = 9, x = 0, y = GRAPH.JUDGE_TEXT.H*1, w = GRAPH.JUDGE_TEXT.W, h = GRAPH.JUDGE_TEXT.H},
            {id = "elGraphText"          , src = 9, x = 0, y = GRAPH.JUDGE_TEXT.H*2, w = GRAPH.JUDGE_TEXT.W, h = GRAPH.JUDGE_TEXT.H},
            {id = "timingGraphText"      , src = 9, x = 0, y = GRAPH.JUDGE_TEXT.H*3, w = GRAPH.JUDGE_TEXT.W, h = GRAPH.JUDGE_TEXT.H},
            {id = "grooveGaugeText"      , src = 9, x = 0, y = GRAPH.GROOVE_TEXT.H*4, w = GRAPH.GROOVE_TEXT.W, h = GRAPH.GROOVE_TEXT.H},
            {id = "customGrooveGaugeText", src = 9, x = 0, y = GRAPH.GROOVE_TEXT.H*5, w = GRAPH.GROOVE_TEXT.W, h = GRAPH.GROOVE_TEXT.H},
            -- ランダムオプションはグラフ上に表示
            {id = "randomOptionImgs", src = 0, x = 199, y = 566, w = OPTIONS.IMG.W, h = OPTIONS.IMG.H * 10, divy = 10, ref = 42},
            -- スコアグラフを隠すための背景
            {id = "scoreGraphMaskBg", src = getBgSrc(), x = GRAPH.WND_GAUGE.X - GRAPH.WND_GAUGE.SHADOW, y = HEIGHT - GRAPH.WND_GAUGE.Y - GRAPH.WND_GAUGE.H - GRAPH.WND_GAUGE.SHADOW, w = GRAPH.WND_GAUGE.W + GRAPH.WND_GAUGE.SHADOW*2, h = GRAPH.WND_GAUGE.H + GRAPH.WND_GAUGE.SHADOW},
            {id = "customGrooveBg", src = 7, x = 0, y = 0, w = GRAPH.GAUGE.W, h = GRAPH.GAUGE.H},
            {id = "customGrooveGraph", src = 8, x = 0, y = 0, w = GRAPH.GAUGE.W, h = GRAPH.GAUGE.H},
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
                    if isPressedUp() then
                        myPrint("move tab up")
                        notesGraph.activeTabIdx = notesGraph.activeTabIdx - 1
                        if notesGraph.activeTabIdx < 1 then
                            notesGraph.activeTabIdx = #GRAPH.TAB.PREFIX
                        end
                        if not getIsViewCostomGrooveGauge() and notesGraph.activeTabIdx == GRAPH.TAB.TYPES.CUSTOM_GROOVE then
                            notesGraph.activeTabIdx = GRAPH.TAB.TYPES.GROOVE
                        end
                        myPrint("nowTab: " .. notesGraph.activeTabIdx)
                    elseif isPressedDown() then
                        myPrint("move tab down")
                        notesGraph.activeTabIdx = notesGraph.activeTabIdx + 1
                        if notesGraph.activeTabIdx > #GRAPH.TAB.PREFIX then
                            notesGraph.activeTabIdx = 1
                        end
                        if not getIsViewCostomGrooveGauge() and notesGraph.activeTabIdx == GRAPH.TAB.TYPES.CUSTOM_GROOVE then
                            notesGraph.activeTabIdx = GRAPH.TAB.TYPES.SCORE
                        end
                        myPrint("nowTab: " .. notesGraph.activeTabIdx)
                    end
                    return 1
                end
            },
        },
    }

    local imgs = skin.image

    -- オプション読み込み
    local opImgs = {}
    for i = 1, 10 do
        imgs[#imgs+1] = {id = "randomOptionImgs" .. i, src = 0, x = 199, y = 566 + OPTIONS.IMG.H * (i - 1), w = OPTIONS.IMG.W, h = OPTIONS.IMG.H}
        opImgs[#opImgs+1] = "randomOptionImgs" .. i
    end
    skin.imageset[#skin.imageset+1] = {id = "randomOptionImageSet", ref = 42, images = opImgs}

    -- タブ読み込み
    for i, v in ipairs(GRAPH.TAB.PREFIX) do
        imgs[#imgs+1] = {id = v .. "TabIcon", src = 6, x = 0, y = GRAPH.TAB.H * (i - 1), w = GRAPH.TAB.W, h = GRAPH.TAB.H}
        imgs[#imgs+1] = {id = v .. "TabButton", src = 999, x = 0, y = 0, w = 1, h = 1, act = function () notesGraph.functions.switchTab(i) end}
    end

    -- カスタムグルーヴゲージ読み込み+画像削除
    if getIsViewCostomGrooveGauge() then
        local f = io.open(skin_config.get_path("../generated/custom_groove/id.txt"), "r")
        local id = ""
        if f then
            for line in f:lines() do
                id = line
            end
            print("カスタムグルーヴゲージ 画像ID: " .. id)
            skin.source = {
                {id = 8, path = "../generated/custom_groove/groove_" .. id .. ".png"}
            }

            -- そのままだと画像が増殖していくのでカスタムグルーヴゲージの結果を削除
            local isDeleted = false
            table.insert(skin.customTimers, {
                id = 10103,
                timer = function ()
                    if main_state.timer(2) > 0 and not isDeleted then
                        isDeleted = true
                        os.remove(skin_config.get_path("../generated/custom_groove/groove_" .. id .. ".png"))
                    end
                end
            })
        end
    end

    mergeSkin(skin, ranking.load(function () return notesGraph.activeTabIdx == GRAPH.TAB.TYPES.RANKING end))
    mergeSkin(skin, scoreGraph.load())
    return skin
end

notesGraph.functions.dstGrooveGaugeArea = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    -- groove gauge出力
    local grooveX = GRAPH.GAUGE.X(GRAPH)
    local grooveY = GRAPH.GAUGE.Y(GRAPH)
    local getIsDrawGrooveGauge = function () return notesGraph.activeTabIdx == GRAPH.TAB.TYPES.GROOVE end
    local getIsDrawCustomGrooveGauge = function () return notesGraph.activeTabIdx == GRAPH.TAB.TYPES.CUSTOM_GROOVE end
    local getIsDrawAnyGrooveGauge = function () return getIsDrawGrooveGauge() or getIsDrawCustomGrooveGauge() end
    local getIsDrawAnyGraph = function () return getIsDrawAnyGrooveGauge() or notesGraph.activeTabIdx == GRAPH.TAB.TYPES.SCORE end

    -- スコアグラフを描画
    do
        local e, s = pcall(notesGraph.functions.dstScoreGraph)
        if e and s then
            mergeSkin(skin, s)
        else
            print(s)
        end
    end

    -- スコアグラフを隠すためのマスク
    dst[#dst+1] = {
        id = "scoreGraphMaskBg", draw = getIsDrawAnyGrooveGauge, dst = {
            {x = GRAPH.WND_GAUGE.X - GRAPH.WND_GAUGE.SHADOW, y = GRAPH.WND_GAUGE.Y, w = GRAPH.WND_GAUGE.W + GRAPH.WND_GAUGE.SHADOW*2, h = GRAPH.WND_GAUGE.H + GRAPH.WND_GAUGE.SHADOW}
        }
    }

    -- 通常グルーヴゲージの背景
    dst[#dst+1] = {
        id = "grooveGaugeGraphBg", draw = getIsDrawGrooveGauge, dst = {
            {x = grooveX, y = grooveY, w = GRAPH.GAUGE.W, h = GRAPH.GAUGE.H}
        }
    }
    -- カスタムグルーヴゲージの背景
    dst[#dst+1] = {
        id = "customGrooveBg", draw = getIsDrawCustomGrooveGauge, dst = {
            {x = grooveX, y = grooveY, w = GRAPH.GAUGE.W, h = GRAPH.GAUGE.H}
        }
    }

    -- ノーツグラフ本体
    local type = getGraphType(4)
    if 0 < type and type < 5 then
        local prefix = GRAPH.PREFIX[type]
        local p = getGrooveNotesGraphSizePercentage()
        dst[#dst+1] = {
            id = prefix .. "Graph", blend = type == 4 and 2 or 1, draw = getIsDrawGrooveGauge, dst = {
                {x = grooveX, y = grooveY, w = GRAPH.JUDGE_GRAPH.W, h = GRAPH.GAUGE.H * p, a = getGrooveNotesGraphTransparency()}
            }
        }
    end

    -- グルーヴゲージ本体
    dst[#dst+1] = {
        id = "grooveGaugeGraphFront", draw = getIsDrawGrooveGauge, dst = {
            {x = grooveX, y = grooveY, w = GRAPH.GAUGE.W, h = GRAPH.GAUGE.H}
        }
    }
    dst[#dst+1] = {
        id = "customGrooveGraph", draw = getIsDrawCustomGrooveGauge, dst = {
            {x = grooveX, y = grooveY, w = GRAPH.GAUGE.W, h = GRAPH.GAUGE.H}
        }
    }

    do
        -- GROOVE GAUGEラベルの出力
        local labelY = getDrawLabelAtTop() and GRAPH.GROOVE_TEXT.TOP_Y(GRAPH) or GRAPH.GROOVE_TEXT.BOTTOM_Y(GRAPH)
        if isDrawGrooveGaugeLabel() then
            dst[#dst+1] = {
                id = "grooveGaugeText", draw = getIsDrawGrooveGauge, dst = {
                    {x = GRAPH.GROOVE_TEXT.X(GRAPH), y = labelY, w = GRAPH.GROOVE_TEXT.W, h = GRAPH.GROOVE_TEXT.H}
                },
            }dst[#dst+1] = {
                id = "customGrooveGaugeText", draw = getIsDrawCustomGrooveGauge, dst = {
                    {x = GRAPH.GROOVE_TEXT.X(GRAPH), y = labelY, w = GRAPH.GROOVE_TEXT.W, h = GRAPH.GROOVE_TEXT.H}
                },
            }
        end
        -- ランダムオプションの出力
        if isDrawPlayOption() then
            local opY = labelY
            if isDrawGrooveGaugeLabel() then
                opY = labelY + OPTIONS.IMG.DY_WHEN_DRAW_LABEL * (getDrawLabelAtTop() and -1 or 1)
            end
            dst[#dst+1] = {
                id = "randomOptionImageSet", dst = {
                    {x = OPTIONS.IMG.X(), y = opY, w = OPTIONS.IMG.W, h = OPTIONS.IMG.H}
                }
            }
        end
    end
    dstNumberRightJustifyWithDrawFunc(skin, "grooveGaugeValue", grooveX + GRAPH.GROOVE_NUM.X, grooveY + GRAPH.GROOVE_NUM.Y, NUM_24PX.W, NUM_24PX.H, 3, getIsDrawGrooveGauge)
    dst[#dst+1] = {
        id = "dotFor24PxWhite", draw = getIsDrawGrooveGauge, dst = {
            {x = grooveX + GRAPH.GROOVE_NUM.DOT, y = grooveY + GRAPH.GROOVE_NUM.Y, w = NUM_24PX.DOT_SIZE, h = NUM_24PX.DOT_SIZE}
        }
    }
    dstNumberRightJustifyWithDrawFunc(skin, "grooveGaugeValueAfterDot", grooveX + GRAPH.GROOVE_NUM.AF_X, grooveY + GRAPH.GROOVE_NUM.Y, NUM_24PX.W, NUM_24PX.H, 1, getIsDrawGrooveGauge)
    dst[#dst+1] = {
        id = "percentageFor24PxWhite", draw = getIsDrawGrooveGauge, dst = {
            {x = grooveX + GRAPH.GROOVE_NUM.SYMBOL_X, y = grooveY + GRAPH.GROOVE_NUM.Y, w = NUM_24PX.PERCENT.W, h = NUM_24PX.PERCENT.H}
        }
    }

    mergeSkin(skin, ranking.dstMaskBg())

    -- タブの描画
    for i, v in ipairs(GRAPH.TAB.PREFIX) do
        local usable = true
        if i == GRAPH.TAB.TYPES.SCORE and not notesGraph.didLoadPlayData then
            usable = false
        elseif i == GRAPH.TAB.TYPES.CUSTOM_GROOVE and not getIsViewCostomGrooveGauge() then
            usable = false
        end

        dst[#dst+1] = {
            id = v .. "TabIcon", dst = {
                {
                    x = GRAPH.TAB.X(GRAPH), y = GRAPH.TAB.Y(GRAPH, i), w = GRAPH.TAB.W, h = GRAPH.TAB.H,
                    a = usable and 255 or 128
                }
            }
        }
        if usable then
            dst[#dst+1] = {
                id = v .. "TabButton", dst = {
                    {x = GRAPH.TAB.BUTTON.X(GRAPH), y = GRAPH.TAB.BUTTON.Y(GRAPH, i), w = GRAPH.TAB.BUTTON.W, h = GRAPH.TAB.BUTTON.H,}
                }
            }
        end
    end

    dst[#dst+1] = {
        id = "grooveGaugeFrame", draw = getIsDrawAnyGraph, dst = {
            {
                x = GRAPH.WND_GAUGE.X - GRAPH.WND_GAUGE.SHADOW, y = GRAPH.WND_GAUGE.Y - GRAPH.WND_GAUGE.SHADOW,
                w = GRAPH.WND_GAUGE.W + GRAPH.WND_GAUGE.SHADOW * 2, h = GRAPH.WND_GAUGE.H + GRAPH.WND_GAUGE.SHADOW * 2
            }
        }
    }
    return skin
end

notesGraph.functions.dstJudgeGaugeArea = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    -- グラフ出力
    for i = 1, 3 do
        local type = getGraphType(i)
        if 0 < type and type < 5 then
            local x = GRAPH.WND_JUDGE.X + GRAPH.JUDGE_GRAPH.X
            local y = GRAPH.WND_JUDGE.Y + GRAPH.JUDGE_GRAPH.Y + GRAPH.JUDGE_GRAPH.INTERVAL_Y * (i - 1)
            local prefix = GRAPH.PREFIX[type]
            -- 黒背景
            dst[#dst+1] = {
                id = "black", dst = {
                    {x = x, y = y, w = GRAPH.JUDGE_GRAPH.W, h = GRAPH.JUDGE_GRAPH.H, a = 128}
                }
            }
            -- グラフ本体
            dst[#dst+1] = {
                id = prefix .. "Graph", blend = type == 4 and 2 or 1, dst = {
                    {x = x, y = y, w = GRAPH.JUDGE_GRAPH.W, h = GRAPH.JUDGE_GRAPH.H}
                }
            }
            -- グラフ種別文字
            dst[#dst+1] = {
                id = prefix .. "GraphText", dst = {
                    {x = x + GRAPH.JUDGE_TEXT.X, y = y + GRAPH.JUDGE_TEXT.Y, w = GRAPH.JUDGE_TEXT.W, h = GRAPH.JUDGE_TEXT.H}
                }
            }
            -- グラフ項目
            dst[#dst+1] = {
                id = prefix .. "Description", dst = {
                    {x = x + GRAPH.DESCRIPTION.X, y = y + GRAPH.DESCRIPTION.Y, w = GRAPH.DESCRIPTION.W, h = GRAPH.DESCRIPTION.H}
                }
            }
        end
    end
    -- グラフフレーム
    dst[#dst+1] = {
        id = "judgeFrame", dst = {
            {
                x = GRAPH.WND_JUDGE.X - GRAPH.WND_JUDGE.SHADOW, y = GRAPH.WND_JUDGE.Y - GRAPH.WND_JUDGE.SHADOW,
                w = GRAPH.WND_JUDGE.W + GRAPH.WND_JUDGE.SHADOW * 2, h = GRAPH.WND_JUDGE.H + GRAPH.WND_JUDGE.SHADOW * 2
            }
        }
    }
    return skin
end

notesGraph.functions.dst= function ()
    local skin = {destination = {}}
    mergeSkin(skin, notesGraph.functions.dstJudgeGaugeArea())
    mergeSkin(skin, notesGraph.functions.dstGrooveGaugeArea())
    mergeSkin(skin, ranking.dst())
    return skin
end

return notesGraph.functions