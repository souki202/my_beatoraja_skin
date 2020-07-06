local commons = require("modules.select.commons")

local playButtons = {
    functions = {}
}

local DECIDE = {
    W = 354,
    H = 78
}

local AUTO = {
    W = 110,
    H = 62
}

local REPLAY = {
    SIZE = 62,
    TEXT = {
        W = 17,
        H = 22,
    }
}

playButtons.functions.load = function()
    return {
        image = {
            -- プレイ
            {id = "playButton", src = 0, x = 773, y = commons.PARTS_OFFSET + 377, w = DECIDE.W, h = DECIDE.H},
            {id = "playButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 15}, -- ボタン起動用ダミー
            -- auto
            {id = "autoButton", src = 0, x = 773, y = commons.PARTS_OFFSET + 377 + DECIDE.H, w = AUTO.W, h = AUTO.H},
            {id = "autoButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 16}, -- ボタン起動用ダミー
            -- replay
            {id = "replayButtonBg", src = 0, x = 773 + AUTO.W, y = commons.PARTS_OFFSET + 377 + DECIDE.H, w = REPLAY.SIZE, h = REPLAY.SIZE},
            {id = "replay1Text", src = 0, x = 773 + AUTO.W + REPLAY.SIZE + REPLAY.TEXT.W*0, y = commons.PARTS_OFFSET + 377 + DECIDE.H, w = REPLAY.TEXT.W, h = REPLAY.TEXT.H},
            {id = "replay2Text", src = 0, x = 773 + AUTO.W + REPLAY.SIZE + REPLAY.TEXT.W*1, y = commons.PARTS_OFFSET + 377 + DECIDE.H, w = REPLAY.TEXT.W, h = REPLAY.TEXT.H},
            {id = "replay3Text", src = 0, x = 773 + AUTO.W + REPLAY.SIZE + REPLAY.TEXT.W*2, y = commons.PARTS_OFFSET + 377 + DECIDE.H, w = REPLAY.TEXT.W, h = REPLAY.TEXT.H},
            {id = "replay4Text", src = 0, x = 773 + AUTO.W + REPLAY.SIZE + REPLAY.TEXT.W*3, y = commons.PARTS_OFFSET + 377 + DECIDE.H, w = REPLAY.TEXT.W, h = REPLAY.TEXT.H},
            {id = "replay1ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 19}, -- ボタン起動用ダミー
            {id = "replay2ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 316}, -- ボタン起動用ダミー
            {id = "replay3ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 317}, -- ボタン起動用ダミー
            {id = "replay4ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 318}, -- ボタン起動用ダミー
        }
    }
end

playButtons.functions.dst = function ()
    local skin = {destination = {
        -- プレイボタン
        {
            id = "playButton", op = {-1}, dst = {
                {x = 780, y = 571, w = DECIDE.W, h = DECIDE.H}
            }
        },
        { -- ボタン起動用にサイズを調整したやつ
            id = "playButtonDummy", op = {-1}, dst = {
                {x = 786, y = 577, w = DECIDE.W - 12, h = DECIDE.H - 12}
            }
        },
        -- AUTO
        {
            id = "autoButton", op = {-1}, dst = {
                {x = 780, y = 513, w = AUTO.W, h = AUTO.H}
            }
        },
        {
            id = "autoButtonDummy", op = {-1}, dst = {
                {x = 786, y = 519, w = AUTO.W - 12, h = AUTO.H - 12}
            }
        },
    }}

    -- リプレイボタン
    local replayOps = {197, 1197, 1200, 1203}
    for i = 1, 4 do
        local buttonX = 892 + 60 * (i - 1)
        table.insert(skin.destination, { -- リプレイあり
            id = "replayButtonBg", op = {replayOps[i]}, dst = {
                {x = buttonX, y = 513, w = REPLAY.SIZE, h = REPLAY.SIZE}
            }
        })
        table.insert(skin.destination, { -- リプレイ無し
            id = "replayButtonBg", op = {replayOps[i] - 1}, dst = {
                {x = buttonX, y = 513, w = REPLAY.SIZE, h = REPLAY.SIZE, a = 128}
            }
        })
        table.insert(skin.destination, { -- 右下の1,2,3,4の数字
            id = "replay" .. i .. "Text", op = {replayOps[i]}, dst = {
                {x = buttonX + 34, y = 513 + 2, w = REPLAY.TEXT.W, h = REPLAY.TEXT.H}
            }
        })
        table.insert(skin.destination, { -- 起動用ボタン
            id = "replay" .. i .. "ButtonDummy", op = {replayOps[i]}, dst = {
                {x = buttonX + 6, y = 513 + 6, w = REPLAY.SIZE - 12, h = REPLAY.SIZE - 12}
            }
        })
    end
    return skin
end

return playButtons.functions