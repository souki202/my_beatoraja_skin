require("modules.commons.define")
local commons = require("modules.select.commons")
local main_state = require("main_state")

local IR = {
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

    X = 701,
    Y = 229,
    INTERVAL_X = 198,
    INTERVAL_Y = 25,

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

local ir = {
    functions = {}
}

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
        value = {
        },
    }

    -- IR部分の文字の画像読み込み
    local irTexts = {
        "Max", "Perfect", "Fullcombo", "Exhard", "Hard", "Clear", "Easy", "Lassist", "Aassist", "Failed", "Player", "NumOfFullcombo", "NumOfClear"
    }
    for i, t in ipairs(irTexts) do
        table.insert(skin.image, {
            id = "ir" .. t .. "Text", src = 0, x = 1603, y = commons.PARTS_OFFSET + 531 + IR.TEXT.H * (i - 1), w = IR.TEXT.W, h = IR.TEXT.H
        })
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
        table.insert(skin.value, {
            id = "ir" .. type .. "Number", src = 0, x = commons.NUM_28PX.SRC_X, y = commons.PARTS_OFFSET + 89, w = IR.NUM.W * 10, h = IR.NUM.H, divx = 10, divy = 1, digit = IR.DIGIT, ref = refs[1]
        })
        if refs[2] ~= 0 then
            table.insert(skin.value, {
                id = "ir" .. type .. "Percentage", src = 0, x = commons.NUM_28PX.SRC_X + commons.NUM_28PX.W, y = commons.PARTS_OFFSET + 68, w = IR.P_NUM.W * 10, h = IR.P_NUM.H, divx = 10, divy = 1, digit = 3, ref = refs[2]
            })
            table.insert(skin.value, {
                id = "ir" .. type .. "PercentageAfterDot", src = 0, x = commons.NUM_28PX.SRC_X + commons.NUM_28PX.W, y = commons.PARTS_OFFSET + 68, w = IR.P_NUM.W * 10, h = IR.P_NUM.H, divx = 10, divy = 1, digit = 1, ref = refs[3], padding = 1
            })
        end
    end
    return skin
end

ir.functions.dst = function ()
    local skin = {destination = {}}
    -- IR
    local irTextOrder = {
        {"Max", "Perfect", "Fullcombo", "Exhard", "Hard", "Clear", "Easy",},
        {"Player", "NumOfFullcombo", "NumOfClear", "", "Lassist", "Aassist", "Failed"}
    }
    for i, _ in ipairs(irTextOrder) do
        for j, type in ipairs(irTextOrder[i]) do
            if irTextOrder[i][j] ~= "" then
                local baseX = IR.X + IR.INTERVAL_X * (i - 1)
                local baseY = IR.Y - IR.INTERVAL_Y * (j - 1)
                -- 画像
                table.insert(skin.destination, {
                    id = "ir" .. type .. "Text", dst = {
                        {x = baseX, y = baseY, w = IR.TEXT.W, h = IR.TEXT.H}
                    }
                })
                -- 数値
                table.insert(skin.destination, {
                    id = "ir" .. type .. "Number", dst = {
                        {x = baseX + 146 - IR.NUM.W * IR.DIGIT, y = baseY + 1, w = IR.NUM.W, h = IR.NUM.H}
                    }
                })
                -- player以外はパーセンテージも
                if irTextOrder[i][j] ~= "Player" then
                    table.insert(skin.destination, {
                        id = "ir" .. type .. "Percentage", dst = {
                            {x = baseX + 168 - IR.P_NUM.W * 3, y = baseY + 1, w = IR.P_NUM.W, h = IR.P_NUM.H}
                        }
                    })
                    table.insert(skin.destination, {
                        id = "irDot", op = {-606}, dst = {
                            {x = baseX + 168, y = baseY + 1, w = IR.P_NUM.W, h = IR.P_NUM.H}
                        }
                    })
                    table.insert(skin.destination, {
                        id = "ir" .. type .. "PercentageAfterDot", dst = {
                            {x = baseX + 178 - IR.P_NUM.W * 1, y = baseY + 1, w = IR.P_NUM.W, h = IR.P_NUM.H}
                        }
                    })
                    table.insert(skin.destination, {
                        id = "irPercent", op = {-606}, dst = {
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

return ir.functions