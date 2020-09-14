require("modules.result.commons")
require("modules.result2.commons")
local main_state = require("main_state")
local stagefile = require("modules.result2.stagefile")
local scoreGraph = require("modules.result.score_graph")

local groove = {
    didLoadPlayData = false,
    functions = {}
}

local GROOVE = {
    AREA = stagefile.getStageFileArea(),
    DIMMER_ALPHA = 90,
    PLAYER = {
        X = function (self) return self.AREA.X + 7 end,
        Y = function (self) return self.AREA.Y + 4 end,
        W = 400,
        SIZE = 24,
    },
    DATE = {
        X = function (self) return self.AREA.X + self.AREA.W - 7 end,
        Y = function (self) return self.AREA.Y + 4 end,
        W = 220,
        SIZE = 24,
    },
    GAUGE = {
        JUDGE_IDS = {"notes", "judges", "el", "timing", "blank"},
        GROOVE = {
            X = function (self) return self.AREA.X + 5 end,
            Y = function (self) return self.AREA.Y + 155 end,
            W = 630,
            H = 320,
            JUDGE = {
                H = 160,
                ALPHA = 192,
            },
            LABEL = {
                X = function (self) return self.GAUGE.GROOVE.X(self) + 1 end,
                Y = function (self) return self.GAUGE.GROOVE.Y(self) + 1 end,
                W = 128,
                H = 29,
            },
            VALUE = {
                X = function (self) return self.GAUGE.GROOVE.X(self) + 536 end,
                X_DOT = function (self) return self.GAUGE.GROOVE.VALUE.X(self) + 47 end,
                X_AF_DOT = function (self) return self.GAUGE.GROOVE.VALUE.X_DOT(self) + 4 end,
                X_PERCENT = function (self) return self.GAUGE.GROOVE.VALUE.X_AF_DOT(self) + 17 end,
                Y = function (self) return self.GAUGE.GROOVE.Y(self) + 292 end,
                -- w, hはRESULT2NUMから
            }
        },
        JUDGE = {
            X = function (self) return self.AREA.X + 5 end,
            Y = function (self) return self.AREA.Y + 48 end,
            W = 630,
            H = 102,
            DETAIL = {
                X = function (self) return self.GAUGE.JUDGE.X(self) + self.GAUGE.JUDGE.W - 7 - self.GAUGE.JUDGE.DETAIL.W end,
                Y = function (self) return self.GAUGE.JUDGE.Y(self) + self.GAUGE.JUDGE.H - 7 - self.GAUGE.JUDGE.DETAIL.H end,
                W = 174,
                H = 12,
            },
            LABEL = {
                X = function (self) return self.GAUGE.JUDGE.X(self) + 1 end,
                Y = function (self) return self.GAUGE.JUDGE.Y(self) + self.GAUGE.JUDGE.H - 1 - self.GAUGE.JUDGE.LABEL.H end,
                W = 128,
                H = 29,
            }
        }
    }
}

groove.functions.getIsDrawGroove = function ()
    return stagefile.getNowTab() == stagefile.getTabList().GROOVE
end

groove.functions.getIsDrawGraph = function ()
    return stagefile.getNowTab() == stagefile.getTabList().GROOVE or stagefile.getNowTab() == stagefile.getTabList().SCORE
end

groove.functions.load = function ()
    local getNum = main_state.number
    local playerLabel = "Player: " .. main_state.text(2)
    local dateLabel = string.format("%04d", getNum(21)) .. "-" .. string.format("%02d", getNum(22)) .. "-" .. string.format("%02d", getNum(23)) .. " " .. string.format("%02d", getNum(24)) .. ":" .. string.format("%02d", getNum(25)) .. ":" .. string.format("%02d", getNum(26))
    local skin = {
        image = {
            {id = "grooveBokehBg", src = getBokehBgSrc(), x = GROOVE.AREA.X, y = GROOVE.AREA.Y - GROOVE.AREA.H, w = GROOVE.AREA.W, h = GROOVE.AREA.H},
            {id = "grooveShadow", src = 9, x = 0, y = 0, w = -1, h = GROOVE.GAUGE.GROOVE.H},
            {id = "judgeGaugeShadow", src = 9, x = 0, y = GROOVE.GAUGE.GROOVE.H, w = -1, h = GROOVE.GAUGE.JUDGE.H},
            {id = GROOVE.GAUGE.JUDGE_IDS[1] .. "Detail", src = 10, x = 0, y = GROOVE.GAUGE.JUDGE.DETAIL.H * 0, w = -1, h = GROOVE.GAUGE.JUDGE.DETAIL.H},
            {id = GROOVE.GAUGE.JUDGE_IDS[2] .. "Detail", src = 10, x = 0, y = GROOVE.GAUGE.JUDGE.DETAIL.H * 1, w = -1, h = GROOVE.GAUGE.JUDGE.DETAIL.H},
            {id = GROOVE.GAUGE.JUDGE_IDS[3] .. "Detail", src = 10, x = 0, y = GROOVE.GAUGE.JUDGE.DETAIL.H * 2, w = -1, h = GROOVE.GAUGE.JUDGE.DETAIL.H},
            {id = GROOVE.GAUGE.JUDGE_IDS[4] .. "Detail", src = 10, x = 0, y = GROOVE.GAUGE.JUDGE.DETAIL.H * 3, w = -1, h = GROOVE.GAUGE.JUDGE.DETAIL.H},
            {id = GROOVE.GAUGE.JUDGE_IDS[1] .. "Label", src = 11, x = 0, y = GROOVE.GAUGE.JUDGE.LABEL.H * 0, w = -1, h = GROOVE.GAUGE.JUDGE.LABEL.H},
            {id = GROOVE.GAUGE.JUDGE_IDS[2] .. "Label", src = 11, x = 0, y = GROOVE.GAUGE.JUDGE.LABEL.H * 1, w = -1, h = GROOVE.GAUGE.JUDGE.LABEL.H},
            {id = GROOVE.GAUGE.JUDGE_IDS[3] .. "Label", src = 11, x = 0, y = GROOVE.GAUGE.JUDGE.LABEL.H * 2, w = -1, h = GROOVE.GAUGE.JUDGE.LABEL.H},
            {id = GROOVE.GAUGE.JUDGE_IDS[4] .. "Label", src = 11, x = 0, y = GROOVE.GAUGE.JUDGE.LABEL.H * 3, w = -1, h = GROOVE.GAUGE.JUDGE.LABEL.H},
            {id = "GrooveLabel", src = 11, x = 0, y = GROOVE.GAUGE.JUDGE.LABEL.H * 5, w = -1, h = GROOVE.GAUGE.JUDGE.LABEL.H},
            {id = "ScoreGraphLabel", src = 11, x = 0, y = GROOVE.GAUGE.JUDGE.LABEL.H * 6, w = -1, h = GROOVE.GAUGE.JUDGE.LABEL.H},
        },
        value = {
            loadNumber("grooveValue", 30, 3, 0, 107, nil),
            loadNumber("grooveValueAfterDot", 30, 1, 0, 407, nil)
        },
        text = {
            {id = "playerLabel", font = 0, size = 24, constantText = playerLabel},
            {id = "dateLabel", font = 0, size = 24, align = 2, constantText = dateLabel},
        },
        gaugegraph = {
            {id = "grooveGaugeGraphBg", assistClearBGColor = "44004488", assistAndEasyFailBGColor = "00444488", grooveFailBGColor = "00440088", grooveClearAndHardBGColor = "44000088", exHardBGColor = "44440088", hazardBGColor = "44444488"},
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
    }
    mergeSkin(skin, scoreGraph.load())
    return skin
end

groove.functions.dst = function ()
    local isDrawGroove = groove.functions.getIsDrawGroove
    local isDrawGraph = groove.functions.getIsDrawGraph
    local skin = {
        destination = {
            -- スコアグラフの背景をここで
            { -- ぼかし背景
                id = "grooveBokehBg", dst = {
                    {x = GROOVE.AREA.X, y = GROOVE.AREA.Y, w = GROOVE.AREA.W, h = GROOVE.AREA.H}
                }
            },
            { -- dimmer
                id = "black", dst = {
                    {x = GROOVE.AREA.X, y = GROOVE.AREA.Y, w = GROOVE.AREA.W, h = GROOVE.AREA.H, a = GROOVE.DIMMER_ALPHA}
                }
            },
        }
    }
    mergeSkin(skin, scoreGraph.dst(GROOVE.GAUGE.GROOVE.X(GROOVE), GROOVE.GAUGE.GROOVE.Y(GROOVE), GROOVE.GAUGE.GROOVE.H))
    mergeSkin(skin, {
        destination = {
            { -- スコアグラフ用のshadow
                id = "grooveShadow", dst = {
                    {x = GROOVE.GAUGE.GROOVE.X(GROOVE), y = GROOVE.GAUGE.GROOVE.Y(GROOVE), w = GROOVE.GAUGE.GROOVE.W, h = GROOVE.GAUGE.GROOVE.H}
                }
            },
            {
                id = "ScoreGraphLabel", dst = {
                    {x = GROOVE.GAUGE.GROOVE.LABEL.X(GROOVE), y = GROOVE.GAUGE.GROOVE.LABEL.Y(GROOVE), w = GROOVE.GAUGE.GROOVE.LABEL.W, h = GROOVE.GAUGE.GROOVE.LABEL.H}
                }
            },
            { -- ぼかし背景
                id = "grooveBokehBg", draw = isDrawGroove, dst = {
                    {x = GROOVE.AREA.X, y = GROOVE.AREA.Y, w = GROOVE.AREA.W, h = GROOVE.AREA.H}
                }
            },
            { -- dimmer
                id = "black", draw = isDrawGroove, dst = {
                    {x = GROOVE.AREA.X, y = GROOVE.AREA.Y, w = GROOVE.AREA.W, h = GROOVE.AREA.H, a = GROOVE.DIMMER_ALPHA}
                }
            },
            { -- プレイヤー名
                id = "playerLabel", draw = isDrawGraph, dst = {
                    {x = GROOVE.PLAYER.X(GROOVE), y = GROOVE.PLAYER.Y(GROOVE), w = GROOVE.PLAYER.W, h = GROOVE.PLAYER.SIZE}
                }
            },
            { -- プレイ日時
                id = "dateLabel", draw = isDrawGraph, dst = {
                    {x = GROOVE.DATE.X(GROOVE), y = GROOVE.DATE.Y(GROOVE), w = GROOVE.DATE.W, h = GROOVE.DATE.SIZE}
                }
            },
            { -- groovegauge bg
                id = "grooveGaugeGraphBg", draw = isDrawGroove, dst = {
                    {x = GROOVE.GAUGE.GROOVE.X(GROOVE), y = GROOVE.GAUGE.GROOVE.Y(GROOVE), w = GROOVE.GAUGE.GROOVE.W, h = GROOVE.GAUGE.GROOVE.H}
                }
            },
            { -- groovegauge部分の判定グラフ
                id = GROOVE.GAUGE.JUDGE_IDS[getGrooveGaugeAreaGraph()], draw = isDrawGroove, dst = {
                    {x = GROOVE.GAUGE.GROOVE.X(GROOVE), y = GROOVE.GAUGE.GROOVE.Y(GROOVE), w = GROOVE.GAUGE.GROOVE.W, h = GROOVE.GAUGE.GROOVE.JUDGE.H, a = GROOVE.GAUGE.GROOVE.JUDGE.ALPHA}
                }
            },
            { -- groovegauge border
                id = "grooveGaugeGraphFront", draw = isDrawGroove, dst = {
                    {x = GROOVE.GAUGE.GROOVE.X(GROOVE), y = GROOVE.GAUGE.GROOVE.Y(GROOVE), w = GROOVE.GAUGE.GROOVE.W, h = GROOVE.GAUGE.GROOVE.H}
                }
            },
            {
                id = "GrooveLabel", draw = isDrawGroove, dst = {
                    {x = GROOVE.GAUGE.GROOVE.LABEL.X(GROOVE), y = GROOVE.GAUGE.GROOVE.LABEL.Y(GROOVE), w = GROOVE.GAUGE.GROOVE.LABEL.W, h = GROOVE.GAUGE.GROOVE.LABEL.H}
                }
            },
            { -- groove gaugeの値
                id = "grooveValue", draw = isDrawGroove, dst = {
                    {x = GROOVE.GAUGE.GROOVE.VALUE.X(GROOVE), y = GROOVE.GAUGE.GROOVE.VALUE.Y(GROOVE), w = RESULT2NUM.SIZE30.W, h = RESULT2NUM.SIZE30.H}
                }
            },
            {
                id = "30pxDot", draw = isDrawGroove, dst = {
                    {x = GROOVE.GAUGE.GROOVE.VALUE.X_DOT(GROOVE), y = GROOVE.GAUGE.GROOVE.VALUE.Y(GROOVE), w = RESULT2NUM.SIZE30.DOT_SIZE, h = RESULT2NUM.SIZE30.DOT_SIZE}
                }
            },
            { -- groove gaugeの値 小数
                id = "grooveValueAfterDot", draw = isDrawGroove, dst = {
                    {x = GROOVE.GAUGE.GROOVE.VALUE.X_AF_DOT(GROOVE), y = GROOVE.GAUGE.GROOVE.VALUE.Y(GROOVE), w = RESULT2NUM.SIZE30.W, h = RESULT2NUM.SIZE30.H}
                }
            },
            {
                id = "30pxPercent", draw = isDrawGroove, dst = {
                    {x = GROOVE.GAUGE.GROOVE.VALUE.X_PERCENT(GROOVE), y = GROOVE.GAUGE.GROOVE.VALUE.Y(GROOVE), w = RESULT2NUM.SIZE30.PERCENT.W, h = RESULT2NUM.SIZE30.PERCENT.H}
                }
            },
            { -- groovegauge shadow
                id = "grooveShadow", draw = isDrawGroove, dst = {
                    {x = GROOVE.GAUGE.GROOVE.X(GROOVE), y = GROOVE.GAUGE.GROOVE.Y(GROOVE), w = GROOVE.GAUGE.GROOVE.W, h = GROOVE.GAUGE.GROOVE.H}
                }
            },
            { -- 判定グラフbg
                id = "black", draw = isDrawGraph, dst = {
                    {x = GROOVE.GAUGE.JUDGE.X(GROOVE), y = GROOVE.GAUGE.JUDGE.Y(GROOVE), w = GROOVE.GAUGE.JUDGE.W, h = GROOVE.GAUGE.JUDGE.H, a = GROOVE.DIMMER_ALPHA}
                }
            },
            { -- 判定ゲージ本体
                id = GROOVE.GAUGE.JUDGE_IDS[getGaugeTypeAtStageFileArea()] .. "Graph", draw = isDrawGraph, dst = {
                    {x = GROOVE.GAUGE.JUDGE.X(GROOVE), y = GROOVE.GAUGE.JUDGE.Y(GROOVE), w = GROOVE.GAUGE.JUDGE.W, h = GROOVE.GAUGE.JUDGE.H}
                }
            },
            { -- 色の説明部分
                id = GROOVE.GAUGE.JUDGE_IDS[getGaugeTypeAtStageFileArea()] .. "Detail", draw = isDrawGraph, dst = {
                    {x = GROOVE.GAUGE.JUDGE.DETAIL.X(GROOVE), y = GROOVE.GAUGE.JUDGE.DETAIL.Y(GROOVE), w = GROOVE.GAUGE.JUDGE.DETAIL.W, h = GROOVE.GAUGE.JUDGE.DETAIL.H}
                }
            },
            { -- 色の説明部分
                id = GROOVE.GAUGE.JUDGE_IDS[getGaugeTypeAtStageFileArea()] .. "Label", draw = isDrawGraph, dst = {
                    {x = GROOVE.GAUGE.JUDGE.LABEL.X(GROOVE), y = GROOVE.GAUGE.JUDGE.LABEL.Y(GROOVE), w = GROOVE.GAUGE.JUDGE.LABEL.W, h = GROOVE.GAUGE.JUDGE.LABEL.H}
                }
            },
            { -- 判定グラフshadow
                id = "judgeGaugeShadow", draw = isDrawGraph, dst = {
                    {x = GROOVE.GAUGE.JUDGE.X(GROOVE), y = GROOVE.GAUGE.JUDGE.Y(GROOVE), w = GROOVE.GAUGE.JUDGE.W, h = GROOVE.GAUGE.JUDGE.H, a = GROOVE.DIMMER_ALPHA}
                }
            },
        }
    })
    return skin
end

return groove.functions