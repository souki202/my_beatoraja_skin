require("modules.commons.define")
local commons = require("modules.select.commons")
local main_state = require("main_state")

local IR = {
    WND = {
        X = 688,
        Y = 68,
        W = 437, -- 影込み
        H = 247, -- 影込み
        SHADOW = 15,
    },
    TEXT = {
        W = 99,
        H = 18,
    },
    NUM = {
        W = 11,
        H = 15,
    },
    P_NUM = {
        W = 7,
        H = 9,
    },
    PERCENT_W = 9,
    PERCENT_H = 9,
    DIGIT = 5,
    INTERVAL_X = 198,
    INTERVAL_Y = 25,

    STATISTICS = {
        START_X = 701,
        START_Y = 229,
    },
    LOADING = {
        FRAME_W = 249,
        FRAME_H = 62,
        FRAME_X = 681,
        FRAME_Y = 3,
        WAVE_LEVEL = 5,
        WAVE_W = 4,
        WAVE_H = 25,
        WAVE_TIME_INTERVAL = 500, -- ms
        WAITING_TEXT_W = 138,
        WAITING_TEXT_H = 21,
        LOADING_TEXT_W = 181,
        LOADING_TEXT_H = 21,
    },
}

local RANKING = {
    NUM = {
        W = 15,
        H = 19,
    },
    LINE = {
        START_Y = function (idx) return IR.WND.Y + 159 - 24.5 * (idx - 1) end,

        RANK = {
            X = function () return IR.WND.X + 13 end,
            Y = function (self, idx) return self.LINE.START_Y(idx) end,
        },
        NAME = {
            X = function () return IR.WND.X + 36 end,
            Y = function (self, idx) return self.LINE.START_Y(idx) - 2 end,
            W = 135,
            SIZE = 20,
        },
        LAMP = {
            X = function () return IR.WND.X + 180 end,
            Y = function (self, idx) return self.LINE.START_Y(idx) - 1 end,
            W = IR.TEXT.W,
            H = IR.TEXT.H,
        },
        SCORE = {
            X = function () return IR.WND.X + 284 end,
            Y = function (self, idx) return self.LINE.START_Y(idx) end,
        },
        PERCENTAGE = {
            X = function () return IR.WND.X + 394 end,
            Y = function (self, idx) return self.LINE.START_Y(idx) - 3 end,
            SIZE = 13,
            W = 100,
        },
    },
    NUM_OF_VIEW = 7,
}

local TABS = {
    TEXT_LIST = {"ランキング", "IR統計"},
    ID_LIST = {
        RANKING = 1,
        STATISTICS = 2,
    },
    TAB_AREA = {
        W = 172,
        H = 43,
        SHADOW = 22,

        START_X = function () return IR.WND.X + 28 end,
        Y = function () return IR.WND.Y + 189 end,
        INTERVAL_X = 179,
    },
    TEXT_SIZE = 20,
}

local ir = {
    activeTab = TABS.ID_LIST.STATISTICS,
    functions = {}
}

ir.functions.changeTab = function (tabIdx)
    ir.activeTab = tabIdx
end

ir.functions.isActiveTab = function (tabIdx)
    return ir.activeTab == tabIdx
end

ir.functions.isShowStatistics = function ()
    return ir.activeTab == TABS.ID_LIST.STATISTICS
end

ir.functions.isShowRanking = function ()
    return ir.activeTab == TABS.ID_LIST.RANKING
end

ir.functions.load = function ()
    local skin = {
        image = {
            -- IR用ドットと%
            {id = "irDot", src = 0, x = commons.NUM_28PX.SRC_X + IR.P_NUM.W * 10 + 15, y = commons.PARTS_OFFSET + 68, w = IR.P_NUM.W, h = IR.P_NUM.H},
            {id = "irPercent", src = 0, x = commons.NUM_28PX.SRC_X + IR.P_NUM.W * 11 + 15, y = commons.PARTS_OFFSET + 68, w = IR.PERCENT_W, h = IR.PERCENT_H},
            -- IR loading
            {id = "irLoadingFrame"   , src = 0, x = 965, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.FRAME_W, h = IR.LOADING.FRAME_H},
            {id = "irLoadingWave1"   , src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*0, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.WAVE_W, h = IR.LOADING.WAVE_H},
            {id = "irLoadingWave2"   , src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*1, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.WAVE_W, h = IR.LOADING.WAVE_H},
            {id = "irLoadingWave3"   , src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*2, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.WAVE_W, h = IR.LOADING.WAVE_H},
            {id = "irLoadingWave4"   , src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*3, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.WAVE_W, h = IR.LOADING.WAVE_H},
            {id = "irLoadingWave5"   , src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*4, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.WAVE_W, h = IR.LOADING.WAVE_H},
            {id = "irLoadingWaitText", src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*5, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.WAITING_TEXT_W, h = IR.LOADING.WAITING_TEXT_H},
            {id = "irLoadingLoadText", src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*5, y = commons.PARTS_OFFSET + 771 + IR.LOADING.WAITING_TEXT_H, w = IR.LOADING.LOADING_TEXT_W, h = IR.LOADING.LOADING_TEXT_H},
        },
        imageset = {},
        value = {
        },
        text = {},
    }

    local imgs = skin.image
    local vals = skin.value
    local texts = skin.text
    local imgsets = skin.imageset
    local getNum = main_state.number

    -- IR部分の文字の画像読み込み
    local irTexts = {
        "Max", "Perfect", "Fullcombo", "Exhard", "Hard", "Clear", "Easy", "Lassist", "Aassist", "Failed", "NoPlay", "Player", "NumOfFullcombo", "NumOfClear"
    }
    for i, t in ipairs(irTexts) do
        imgs[#imgs+1] = {
            id = "ir" .. t .. "Text", src = 0, x = 1603, y = commons.PARTS_OFFSET + 513 + IR.TEXT.H * (i - 1), w = IR.TEXT.W, h = IR.TEXT.H
        }
    end

    -- IR irTextsに対応する値を入れていく
    -- {人数, percentage, afterdot} で, irTextsに対応するrefsを入れる
    local irNumbers = {
        -- MAXから
        {224, 225, 240}, {222, 223, 239}, {218, 219, 238}, {208, 209, 233}, {216, 217, 237}, {214, 215, 236},
        -- ここからEASY
        {212, 213, 235}, {206, 207, 232}, {204, 205, 231}, {210, 211, 234},
        -- ここからplayer
        {200, 0, 0}, {228, 229, 242}, {226, 227, 241}
    }
    for i, refs in ipairs(irNumbers) do
        local type = irTexts[i]
        vals[#vals+1] = {
            id = "ir" .. type .. "Number", src = 0, x = commons.NUM_28PX.SRC_X, y = commons.PARTS_OFFSET + 89, w = IR.NUM.W * 10, h = IR.NUM.H, divx = 10, divy = 1, digit = IR.DIGIT, ref = refs[1]
        }
        if refs[2] ~= 0 then
            vals[#vals+1] = {
                id = "ir" .. type .. "Percentage", src = 0, x = commons.NUM_28PX.SRC_X + commons.NUM_28PX.W, y = commons.PARTS_OFFSET + 68, w = IR.P_NUM.W * 10, h = IR.P_NUM.H, divx = 10, divy = 1, digit = 3, ref = refs[2]
            }
            vals[#vals+1] = {
                id = "ir" .. type .. "PercentageAfterDot", src = 0, x = commons.NUM_28PX.SRC_X + commons.NUM_28PX.W, y = commons.PARTS_OFFSET + 68, w = IR.P_NUM.W * 10, h = IR.P_NUM.H, divx = 10, divy = 1, digit = 1, ref = refs[3], padding = 1
            }
        end
    end

    -- ranking
    -- ランプ表示用imageset
    do
        local lamps = {}
        local maxScoreCache = 0
        for i = 1, 11 do
            lamps[i] = "ir" .. irTexts[i] .. "Text"
        end
        for i = 1, RANKING.NUM_OF_VIEW do
            vals[#vals+1] = {
                id = "ranking" .. i .. "Number", src = 12, x = 0, y = 494, w = RANKING.NUM.W * 10, h = RANKING.NUM.H, divx = 10, digit = 1, value = function () return i end
            }
            texts[#texts+1] = {
                id = "ranking" .. i .. "Name", font = 0, size = RANKING.LINE.NAME.SIZE, ref = 120 + (i - 1), overflow = 1,
            }
            imgsets[#imgsets+1] = {
                id = "ranking" .. i .. "Lamp",
                value = function () return 10 - getNum(390 + (i - 1)) end,
                images = lamps
            }
            vals[#vals+1] = {
                id = "ranking" .. i .. "Exscore",
                src = 12, x = 0, y = 513, w = commons.NUM_20PX.W * 10, h = commons.NUM_20PX.H, divx = 10, digit = 5, ref = 380 + (i - 1), align = 0
            }
            do
                local valueFunc = nil
                -- string.formatは重いので文字連結で
                if i == 1 then
                    valueFunc = function ()
                        maxScoreCache = getNum(74) * 2
                        local s = getNum(380 + (i - 1))
                        if s > 0 then
                            local p = 100 * getNum(380 + (i - 1)) / maxScoreCache
                            return math.floor(p) .. "." .. math.floor((p * 10) % 10) .. "%"
                        end
                        return ""
                    end
                else
                    valueFunc = function ()
                        local s = getNum(380 + (i - 1))
                        if s > 0 then
                            local p = 100 * getNum(380 + (i - 1)) / maxScoreCache
                            return math.floor(p) .. "." .. math.floor((p * 10) % 10) .. "%"
                        end
                        return ""
                    end
                end
                texts[#texts+1] = {
                    id = "ranking" .. i .. "Percentage",
                    font = 0, size = RANKING.LINE.PERCENTAGE.SIZE * 2, value = valueFunc, align = 2,
                }
            end
        end
    end

    -- タブ全般
    imgs[#imgs+1] = {
        id = "nonActiveTab", src = 12, x = 437, y = 0, w = TABS.TAB_AREA.W, h = TABS.TAB_AREA.H
    }
    for i = 1, #TABS.TEXT_LIST do
        -- ウィンドウ全体
        imgs[#imgs+1] = {
            id = "tab" .. i .. "Frame", src = 12, x = 0, y = IR.WND.H * (i - 1), w = IR.WND.W, h = IR.WND.H
        }
        -- text
        texts[#texts+1] = {
            id = "tab" .. i .. "Label", font = 0, align = 1, size = TABS.TEXT_SIZE, constantText = TABS.TEXT_LIST[i]
        }
        -- タブ切り替え用の透明オブジェクト
        imgs[#imgs+1] = {
            id = "tab" .. i .. "Button", src = 999, x = 0, y = 0, w = 1, h = 1,
            act = function () ir.functions.changeTab(i) end
        }
    end
    return skin
end

ir.functions.dstWindow = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    local isActiveTab = ir.functions.isActiveTab

    -- 非アクティブタブをまず描画
    for i = 1, #TABS.TEXT_LIST do
        local x = TABS.TAB_AREA.START_X() + TABS.TAB_AREA.INTERVAL_X * (i - 1)
        local isDraw = function () return not isActiveTab(i) end
        dst[#dst+1] = {
            id = "nonActiveTab", draw = isDraw, dst = {
                {
                    x = x, y = TABS.TAB_AREA.Y(),
                    w = TABS.TAB_AREA.W, h = TABS.TAB_AREA.H
                }
            }
        }
        dst[#dst+1] = {
            id = "tab" .. i .. "Button", draw = isDraw, dst = {
                {
                    x = x + TABS.TAB_AREA.SHADOW, y = TABS.TAB_AREA.Y(),
                    w = TABS.TAB_AREA.W - TABS.TAB_AREA.SHADOW * 2, h = TABS.TAB_AREA.H - IR.WND.SHADOW
                }
            }
        }
        dst[#dst+1] = {
            id = "tab" .. i .. "Label", draw = isDraw, dst = {
                {
                    x = x + TABS.TAB_AREA.W / 2, y = TABS.TAB_AREA.Y() + 2,
                    w = TABS.TAB_AREA.W - TABS.TAB_AREA.SHADOW * 2, h = TABS.TEXT_SIZE,
                    r = 0, g = 0, b = 0,
                }
            }
        }
    end
    -- アクティブタブを描画
    for i = 1, #TABS.TEXT_LIST do
        local x = TABS.TAB_AREA.START_X() + TABS.TAB_AREA.INTERVAL_X * (i - 1)
        local isDraw = function () return isActiveTab(i) end
        dst[#dst+1] = {
            id = "tab" .. i .. "Frame", draw = isDraw, dst = {
                {
                    x = IR.WND.X - IR.WND.SHADOW, y = IR.WND.Y - IR.WND.SHADOW,
                    w = IR.WND.W, h = IR.WND.H
                }
            }
        }
        dst[#dst+1] = {
            id = "tab" .. i .. "Label", draw = isDraw, dst = {
                {
                    x = x + TABS.TAB_AREA.W / 2, y = TABS.TAB_AREA.Y() + 2,
                    w = TABS.TAB_AREA.W - TABS.TAB_AREA.SHADOW * 2, h = TABS.TEXT_SIZE,
                    r = 0, g = 0, b = 0,
                }
            }
        }
    end
    return skin
end

ir.functions.dstStatistics = function ()
    local skin = {destination = {}}
    local isDraw = ir.functions.isShowStatistics
    local isDrawValue = function ()
        return ir.functions.isShowStatistics() and not main_state.option(606)
    end
    -- IR
    local irTextOrder = {
        {"Max", "Perfect", "Fullcombo", "Exhard", "Hard", "Clear", "Easy",},
        {"Player", "NumOfFullcombo", "NumOfClear", "", "Lassist", "Aassist", "Failed"}
    }
    for i, _ in ipairs(irTextOrder) do
        for j, type in ipairs(irTextOrder[i]) do
            if irTextOrder[i][j] ~= "" then
                local baseX = IR.STATISTICS.START_X + IR.INTERVAL_X * (i - 1)
                local baseY = IR.STATISTICS.START_Y - IR.INTERVAL_Y * (j - 1)
                -- 画像
                table.insert(skin.destination, {
                    id = "ir" .. type .. "Text", draw = isDraw, dst = {
                        {x = baseX, y = baseY, w = IR.TEXT.W, h = IR.TEXT.H}
                    }
                })
                -- 数値
                table.insert(skin.destination, {
                    id = "ir" .. type .. "Number", draw = isDraw, dst = {
                        {x = baseX + 146 - IR.NUM.W * IR.DIGIT, y = baseY + 1, w = IR.NUM.W, h = IR.NUM.H}
                    }
                })
                -- player以外はパーセンテージも
                if irTextOrder[i][j] ~= "Player" then
                    table.insert(skin.destination, {
                        id = "ir" .. type .. "Percentage", draw = isDrawValue, dst = {
                            {x = baseX + 168 - IR.P_NUM.W * 3, y = baseY + 1, w = IR.P_NUM.W, h = IR.P_NUM.H}
                        }
                    })
                    table.insert(skin.destination, {
                        id = "irDot", draw = isDrawValue, dst = {
                            {x = baseX + 168, y = baseY + 1, w = IR.P_NUM.W, h = IR.P_NUM.H}
                        }
                    })
                    table.insert(skin.destination, {
                        id = "ir" .. type .. "PercentageAfterDot", draw = isDrawValue, dst = {
                            {x = baseX + 178 - IR.P_NUM.W * 1, y = baseY + 1, w = IR.P_NUM.W, h = IR.P_NUM.H}
                        }
                    })
                    table.insert(skin.destination, {
                        id = "irPercent", draw = isDrawValue, dst = {
                            {x = baseX + 179, y = baseY + 1, w = IR.PERCENT_W, h = IR.PERCENT_H}
                        }
                    })
                end
            end
        end
    end
    -- IRロード表示
    table.insert(skin.destination, {
        id = "irLoadingFrame", op = {606, -1, -1030}, dst = {
            {x = IR.LOADING.FRAME_X, y = IR.LOADING.FRAME_Y, w = IR.LOADING.FRAME_W, h = IR.LOADING.FRAME_H}
        }
    })
    table.insert(skin.destination, {
        id = "irLoadingLoadText", op = {606, -1, -1030}, dst = {
            {x = IR.LOADING.FRAME_X + 49, y = IR.LOADING.FRAME_Y + 20, w = IR.LOADING.LOADING_TEXT_W, h = IR.LOADING.LOADING_TEXT_H}
        }
    })
    for i = 1, IR.LOADING.WAVE_LEVEL do
        table.insert(skin.destination, {
            id = "irLoadingWave" .. i, op = {606, -1, -1030}, loop = 0, timer = 11, dst = {
                {time = 0, a = 0, acc = 3, x = IR.LOADING.FRAME_X + 19 + IR.LOADING.WAVE_W * (i - 1), y = IR.LOADING.FRAME_Y + 18, w = IR.LOADING.WAVE_W, h = IR.LOADING.WAVE_H},
                {time = IR.LOADING.WAVE_TIME_INTERVAL * i, a = 255},
                {time = IR.LOADING.WAVE_TIME_INTERVAL * (IR.LOADING.WAVE_LEVEL + 1)}
            }
        })
    end
    return skin
end

ir.functions.dstRanking = function ()
    local skin = {destination = {}}
    local dst = skin.destination
    local isDraw = ir.functions.isShowRanking

    for i = 1, RANKING.NUM_OF_VIEW do
        dst[#dst+1] = {
            id = "ranking" .. i .. "Number", draw = isDraw, dst = {
                {x = RANKING.LINE.RANK.X(), y = RANKING.LINE.RANK.Y(RANKING, i), w = RANKING.NUM.W, h = RANKING.NUM.H}
            }
        }
        dst[#dst+1] = {
            id = "ranking" .. i .. "Name", draw = isDraw, filter = 1, dst = {
                {x = RANKING.LINE.NAME.X(), y = RANKING.LINE.NAME.Y(RANKING, i), w = RANKING.LINE.NAME.W, h = RANKING.LINE.NAME.SIZE, r = 0, g = 0, b = 0}
            }
        }
        dst[#dst+1] = {
            id = "ranking" .. i .. "Lamp", draw = isDraw, dst = {
                {x = RANKING.LINE.LAMP.X(), y = RANKING.LINE.LAMP.Y(RANKING, i), w = RANKING.LINE.LAMP.W, h = RANKING.LINE.LAMP.H}
            }
        }
        dst[#dst+1] = {
            id = "ranking" .. i .. "Exscore", draw = isDraw, dst = {
                {x = RANKING.LINE.SCORE.X(), y = RANKING.LINE.SCORE.Y(RANKING, i), w = commons.NUM_20PX.W, h = commons.NUM_20PX.H}
            }
        }
        dst[#dst+1] = {
            id = "ranking" .. i .. "Percentage", draw = isDraw, filter = 1, dst = {
                {x = RANKING.LINE.PERCENTAGE.X(), y = RANKING.LINE.PERCENTAGE.Y(RANKING, i), w = RANKING.LINE.PERCENTAGE.W, h = RANKING.LINE.PERCENTAGE.SIZE, r = 0, g = 0, b = 0}
            }
        }
    end
    return skin
end

ir.functions.dst = function ()
    local skin = {destination = {}}
    mergeSkin(skin, ir.functions.dstWindow())
    mergeSkin(skin, ir.functions.dstStatistics())
    mergeSkin(skin, ir.functions.dstRanking())
    return skin
end

return ir.functions