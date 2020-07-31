local commons = require("modules.select.commons")
local main_state = require("main_state")

local densityGraph = {
    functions = {}
}

local GRAPH = {
    WND = {
        OLD = {
            X = 1126, -- 影含まない
            Y = 72,
            W = 638, -- 影含む
            H = 178,
            SHADOW = 7,
        },
        NEW = {
            X = 1126, -- 影含まない
            Y = 47,
            W = 638, -- 影含む
            H = 203,
            SHADOW = 7,
        },
    },
    STAMINA = {
        LABEL = {
            X = 237, -- WNDからの差分
            Y = 5,
            W = 120,
            H = 20,
        },
        NUM = {
            X = 182, -- STAMINAからの差分
            Y = 1,
            W = 14,
            H = 18,
        },
    },
    TOTAL = {
        LABEL = {
            X = 27, -- WNDからの差分
            Y = 5,
            W = 120,
            H = 20,
        },
        NUM = {
            X = 182, -- STAMINAからの差分
            Y = 1,
            W = 14,
            H = 18,
        },
    },
}

-- 密度グラフ
local NOTES_ICON_SIZE = 42

densityGraph.functions.load = function ()
    return {
        image = {
            -- 密度グラフ用
            {id = "notesGraphFrame", src = 0, x = 965, y = commons.PARTS_OFFSET + 593, w = 638, h = 178},
            {id = "notesGraphFrame2", src = 8, x = 0, y = 0, w = GRAPH.WND.NEW.W, h = GRAPH.WND.NEW.H},
            {id = "numOfNormalNotesIcon" , src = 0, x = 945 + NOTES_ICON_SIZE*0, y = commons.PARTS_OFFSET + 477, w = NOTES_ICON_SIZE, h = NOTES_ICON_SIZE},
            {id = "numOfScratchNotesIcon", src = 0, x = 945 + NOTES_ICON_SIZE*1, y = commons.PARTS_OFFSET + 477, w = NOTES_ICON_SIZE, h = NOTES_ICON_SIZE},
            {id = "numOfLnNotesIcon"     , src = 0, x = 945 + NOTES_ICON_SIZE*2, y = commons.PARTS_OFFSET + 477, w = NOTES_ICON_SIZE, h = NOTES_ICON_SIZE},
            {id = "numOfBssNotesIcon"    , src = 0, x = 945 + NOTES_ICON_SIZE*3, y = commons.PARTS_OFFSET + 477, w = NOTES_ICON_SIZE, h = NOTES_ICON_SIZE},
            {id = "useStaminaTextImg", src = 0, x = 1298, y = commons.PARTS_OFFSET + 471, w = GRAPH.STAMINA.LABEL.W, h = GRAPH.STAMINA.LABEL.H},
            {id = "totalValueTextImg", src = 0, x = 1298, y = commons.PARTS_OFFSET + 471 + GRAPH.STAMINA.LABEL.H, w = GRAPH.TOTAL.LABEL.W, h = GRAPH.TOTAL.LABEL.H},
        },
        value = {
            -- ノーツ数
            {id = "numOfNormalNotes" , src = 0, x = commons.NUM_28PX.SRC_X, y = commons.PARTS_OFFSET + commons.NUM_28PX.H, w = commons.NUM_32PX.W * 10, h = commons.NUM_32PX.H, divx = 10, digit = 4, ref = 350, align = 0},
            {id = "numOfScratchNotes", src = 0, x = commons.NUM_28PX.SRC_X, y = commons.PARTS_OFFSET + commons.NUM_28PX.H, w = commons.NUM_32PX.W * 10, h = commons.NUM_32PX.H, divx = 10, digit = 4, ref = 352, align = 0},
            {id = "numOfLnNotes"     , src = 0, x = commons.NUM_28PX.SRC_X, y = commons.PARTS_OFFSET + commons.NUM_28PX.H, w = commons.NUM_32PX.W * 10, h = commons.NUM_32PX.H, divx = 10, digit = 4, ref = 351, align = 0},
            {id = "numOfBssNotes"    , src = 0, x = commons.NUM_28PX.SRC_X, y = commons.PARTS_OFFSET + commons.NUM_28PX.H, w = commons.NUM_32PX.W * 10, h = commons.NUM_32PX.H, divx = 10, digit = 4, ref = 353, align = 0},
            {
                id = "useStaminaValue", src = 0, x = commons.NUM_24PX.SRC_X, y = commons.NUM_24PX.SRC_Y, w = commons.NUM_24PX.W * 10, h = commons.NUM_24PX.H, divx = 10, align = 0, digit = 2,
                value = function()
                    local tn = main_state.number(74)
                    if tn > 0 then
                        return userData.calcUseStamina(tn)
                    end
                end
            },
            {id = "totalValue", src = 0, x = commons.NUM_24PX.SRC_X, y = commons.NUM_24PX.SRC_Y, w = commons.NUM_24PX.W * 10, h = commons.NUM_24PX.H, divx = 10, align = 0, digit = 4, ref = 368},
        }
    }
end

densityGraph.functions.dst = function ()
    local skin = {destination = {
        -- 密度グラフ共通部分
        {
            id = "black", op = {910}, dst = {
                {x = 1138, y = 124, w = 600, h = 100, a = 192}
            }
        },
        {
            id = "notesGraph2", op = {2, 910}, dst = {
                {x = 1138, y = 124, w = 600, h = 100}
            }
        },
        {
            id = "bpmGraph", op = {2, 910}, dst = {
                {x = 1138, y = 124, w = 600, h = 100}
            }
        },
        {
            id = "notesGraphFrame2", op = {910}, dst = {
                {x = GRAPH.WND.NEW.X - GRAPH.WND.OLD.SHADOW, y = GRAPH.WND.NEW.Y - GRAPH.WND.OLD.SHADOW, w = GRAPH.WND.NEW.W, h = GRAPH.WND.NEW.H}
            }
        },
    }}
    -- 密度グラフ
    if getTableValue(skin_config.option, "密度グラフ表示", 910) == 910 then
        local noteTypes = {"Normal", "Scratch", "Ln", "Bss"}
        for i = 1, 4 do
            table.insert(skin.destination, {
                id = "numOf" .. noteTypes[i] .. "NotesIcon", op = {910}, dst = {
                    {x = 1152 + 150 * (i - 1), y = 77, w = NOTES_ICON_SIZE, h = NOTES_ICON_SIZE}
                }
            })
            table.insert(skin.destination, {
                id = "numOf" .. noteTypes[i] .. "Notes", op = {910}, dst = {
                    {x = 1152 + 58 + 150 * (i - 1), y = 77 + 10, w = commons.NUM_32PX.W, h = commons.NUM_32PX.H}
                }
            })
        end

        -- total値
        do
            local totalX = GRAPH.WND.NEW.X + GRAPH.TOTAL.LABEL.X
            local totalY = GRAPH.WND.NEW.Y + GRAPH.TOTAL.LABEL.Y
            -- ラベル
            table.insert(skin.destination, {
                id = "totalValueTextImg", op = {910}, dst = {
                    {x = totalX, y = totalY, w = GRAPH.TOTAL.LABEL.W, h = GRAPH.TOTAL.LABEL.H}
                }
            })
            -- 数値
            table.insert(skin.destination, {
                id = "totalValue", op = {910}, dst = {
                    {
                        x = totalX + GRAPH.TOTAL.NUM.X - commons.NUM_24PX.W * 4,
                        y = totalY + GRAPH.TOTAL.NUM.Y,
                        w = commons.NUM_24PX.W, h = commons.NUM_24PX.H
                    }
                }
            })

        end
        -- 消費スタミナ
        if getTableValue(skin_config.option, "上部プレイヤー情報仕様", 950) == 950 then
            local staminaX = GRAPH.WND.NEW.X + GRAPH.STAMINA.LABEL.X
            local staminaY = GRAPH.WND.NEW.Y + GRAPH.STAMINA.LABEL.Y
            -- ラベル
            table.insert(skin.destination, {
                id = "useStaminaTextImg", op = {910}, dst = {
                    {x = staminaX, y = staminaY, w = GRAPH.STAMINA.LABEL.W, h = GRAPH.STAMINA.LABEL.H}
                }
            })
            -- スタミナ出力
            table.insert(skin.destination, {
                id = "useStaminaValue", op = {910}, dst = {
                    {
                        x = staminaX + GRAPH.STAMINA.NUM.X - commons.NUM_24PX.W * 2,
                        y = staminaY + GRAPH.STAMINA.NUM.Y,
                        w = commons.NUM_24PX.W, h = commons.NUM_24PX.H
                    }
                }
            })
        end
    end
    return skin
end

return densityGraph.functions