require("modules.commons.define")
require("modules.result.commons")
local main_state = require("main_state")

local NOTESGRAPH = {
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

--[[
    グルーヴゲージ下の各種グラフの種類を取得

    @param  int pos 上から何番目か 1,2,3は下部分の枠目, 4はグルーヴゲージ部分
    @return int 1:ノーツ数分布, 2:判定分布, 3:EARLY/LATE分布(棒グラフ), 4:タイミング可視化グラフ, 5:無し
]]
NOTESGRAPH.functions.getGraphType = function (pos)
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

NOTESGRAPH.functions.getGrooveNotesGraphTransparency = function ()
	return 255 - getOffsetValueWithDefault("グルーヴゲージ部分のノーツグラフの透明度 (255で透明)", {a = 0}).a
end

NOTESGRAPH.functions.change2p = function ()
    GRAPH.WND_GAUGE.X = LEFT_X
    GRAPH.WND_JUDGE.X = LEFT_X
end

NOTESGRAPH.functions.load = function ()
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
        },
        imageset = {},
        value = {
             -- groove gaugeの値
            {id = "grooveGaugeValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = 185, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 3, ref = 107, align = 0},
            {id = "grooveGaugeValueAfterDot", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = 185, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 1, ref = 407, align = 0, padding = 1},
        },
        gaugegraph = {
            {id = "grooveGaugeGraphBg", assistClearBGColor = "440044cc", assistAndEasyFailBGColor = "004444cc", grooveFailBGColor = "004400cc", grooveClearAndHardBGColor = "440000cc", exHardBGColor = "444400cc", hazardBGColor = "444444cc"},
            {id = "grooveGaugeGraphFront", assistClearBGColor = "00000000", assistAndEasyFailBGColor = "00000000", grooveFailBGColor = "00000000", grooveClearAndHardBGColor = "00000000", exHardBGColor = "00000000", hazardBGColor = "00000000", borderColor = "440000cc"}
        },
        judgegraph = {
            {id = "notesGraph", noGap = 1, orderReverse = 0, type = 0, backTexOff = 1},
            {id = "judgesGraph", noGap = 1, orderReverse = 1, type = 1, backTexOff = 1},
            {id = "elGraph", noGap = 1, orderReverse = 1, type = 2, backTexOff = 1},
        },
        timingdistributiongraph = {
            {id = "timingGraph", graphColor = "88FF88FF"},
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

NOTESGRAPH.functions.dstGrooveGaugeArea = function ()
    local skin = {destination = {}}
    -- groove gauge出力
    local grooveX = GRAPH.GAUGE.X(GRAPH)
    local grooveY = GRAPH.GAUGE.Y(GRAPH)
    table.insert(skin.destination, {
        id = "grooveGaugeGraphBg", dst = {
            {x = grooveX, y = grooveY, w = GRAPH.GAUGE.W, h = GRAPH.GAUGE.H}
        }
    })

    -- グラフ本体
    local type = NOTESGRAPH.functions.getGraphType(4)
    if 0 < type and type < 5 then
        local prefix = GRAPH.PREFIX[type]
        local p = getGrooveNotesGraphSizePercentage()
        table.insert(skin.destination, {
            id = prefix .. "Graph", blend = type == 4 and 2 or 1, dst = {
                {x = grooveX, y = grooveY, w = GRAPH.JUDGE_GRAPH.W, h = GRAPH.GAUGE.H * p, a = NOTESGRAPH.functions.getGrooveNotesGraphTransparency()}
            }
        })
    end

    table.insert(skin.destination, {
        id = "grooveGaugeGraphFront", dst = {
            {x = grooveX, y = grooveY, w = GRAPH.GAUGE.W, h = GRAPH.GAUGE.H}
        }
    })

    do
        -- GROOVE GAUGEラベルの出力
        local labelY = getDrawLabelAtTop() and GRAPH.GROOVE_TEXT.TOP_Y(GRAPH) or GRAPH.GROOVE_TEXT.BOTTOM_Y(GRAPH)
        if isDrawGrooveGaugeLabel() then
            table.insert(skin.destination, {
                id = "grooveGaugeText", dst = {
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
    dstNumberRightJustify(skin, "grooveGaugeValue", grooveX + GRAPH.GROOVE_NUM.X, grooveY + GRAPH.GROOVE_NUM.Y, NUM_24PX.W, NUM_24PX.H, 3)
    table.insert(skin.destination, {
        id = "dotFor24PxWhite", dst = {
            {x = grooveX + GRAPH.GROOVE_NUM.DOT, y = grooveY + GRAPH.GROOVE_NUM.Y, w = NUM_24PX.DOT_SIZE, h = NUM_24PX.DOT_SIZE}
        }
    })
    dstNumberRightJustify(skin, "grooveGaugeValueAfterDot", grooveX + GRAPH.GROOVE_NUM.AF_X, grooveY + GRAPH.GROOVE_NUM.Y, NUM_24PX.W, NUM_24PX.H, 1)
    table.insert(skin.destination, {
        id = "percentageFor24PxWhite", dst = {
            {x = grooveX + GRAPH.GROOVE_NUM.SYMBOL_X, y = grooveY + GRAPH.GROOVE_NUM.Y, w = NUM_24PX.PERCENT.W, h = NUM_24PX.PERCENT.H}
        }
    })
    table.insert(skin.destination, {
        id = "grooveGaugeFrame", dst = {
            {
                x = GRAPH.WND_GAUGE.X - GRAPH.WND_GAUGE.SHADOW, y = GRAPH.WND_GAUGE.Y - GRAPH.WND_GAUGE.SHADOW,
                w = GRAPH.WND_GAUGE.W + GRAPH.WND_GAUGE.SHADOW * 2, h = GRAPH.WND_GAUGE.H + GRAPH.WND_GAUGE.SHADOW * 2
            }
        }
    })
    return skin
end

NOTESGRAPH.functions.dstJudgeGaugeArea = function ()
    local skin = {destination = {}}
    -- グラフ出力
    for i = 1, 3 do
        local type = NOTESGRAPH.functions.getGraphType(i)
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

NOTESGRAPH.functions.dst= function ()
    local skin = {destination = {}}
    mergeSkin(skin, NOTESGRAPH.functions.dstGrooveGaugeArea())
    mergeSkin(skin, NOTESGRAPH.functions.dstJudgeGaugeArea())
    return skin
end

return NOTESGRAPH.functions