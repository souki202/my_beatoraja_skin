local commons = require("modules.select.commons")

local playButtons = {
    functions = {}
}

local AUTO = {
    W = 110,
    H = 62,
    Y = 299,
}

local REPLAY = {
    SIZE = 62,
    Y = 299,
    TEXT = {
        W = 17,
        H = 22,
    }
}

playButtons.functions.load = function()
    return {
        image = {
            -- auto
            {id = "autoButton", src = 0, x = 773, y = commons.PARTS_OFFSET + 455, w = AUTO.W, h = AUTO.H},
            {id = "autoButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 16}, -- ボタン起動用ダミー
            -- replay
            {id = "replayButtonBg", src = 0, x = 773 + AUTO.W, y = commons.PARTS_OFFSET + 455, w = REPLAY.SIZE, h = REPLAY.SIZE},
            {id = "replay1Text", src = 0, x = 773 + AUTO.W + REPLAY.SIZE + REPLAY.TEXT.W*0, y = commons.PARTS_OFFSET + 455, w = REPLAY.TEXT.W, h = REPLAY.TEXT.H},
            {id = "replay2Text", src = 0, x = 773 + AUTO.W + REPLAY.SIZE + REPLAY.TEXT.W*1, y = commons.PARTS_OFFSET + 455, w = REPLAY.TEXT.W, h = REPLAY.TEXT.H},
            {id = "replay3Text", src = 0, x = 773 + AUTO.W + REPLAY.SIZE + REPLAY.TEXT.W*2, y = commons.PARTS_OFFSET + 455, w = REPLAY.TEXT.W, h = REPLAY.TEXT.H},
            {id = "replay4Text", src = 0, x = 773 + AUTO.W + REPLAY.SIZE + REPLAY.TEXT.W*3, y = commons.PARTS_OFFSET + 455, w = REPLAY.TEXT.W, h = REPLAY.TEXT.H},
            {id = "replay1ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 19}, -- ボタン起動用ダミー
            {id = "replay2ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 316}, -- ボタン起動用ダミー
            {id = "replay3ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 317}, -- ボタン起動用ダミー
            {id = "replay4ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 318}, -- ボタン起動用ダミー
        }
    }
end

playButtons.functions.dst = function ()
    local skin = {destination = {
        -- AUTO
        {
            id = "autoButton", op = {-1}, dst = {
                {x = 855, y = AUTO.Y, w = AUTO.W, h = AUTO.H}
            }
        },
        {
            id = "autoButtonDummy", op = {-1}, dst = {
                {x = 855, y = AUTO.Y, w = AUTO.W - 12, h = AUTO.H - 12}
            }
        },
    }}

    -- リプレイボタン
    local replayOps = {197, 1197, 1200, 1203}
    for i = 1, 4 do
        local buttonX = 614 + 60 * (i - 1)
        table.insert(skin.destination, { -- リプレイあり
            id = "replayButtonBg", op = {replayOps[i]}, dst = {
                {x = buttonX, y = REPLAY.Y, w = REPLAY.SIZE, h = REPLAY.SIZE}
            }
        })
        table.insert(skin.destination, { -- リプレイ無し
            id = "replayButtonBg", op = {replayOps[i] - 1}, dst = {
                {x = buttonX, y = REPLAY.Y, w = REPLAY.SIZE, h = REPLAY.SIZE, a = 128}
            }
        })
        table.insert(skin.destination, { -- 右下の1,2,3,4の数字
            id = "replay" .. i .. "Text", op = {replayOps[i]}, dst = {
                {x = buttonX + 34, y = REPLAY.Y + 2, w = REPLAY.TEXT.W, h = REPLAY.TEXT.H}
            }
        })
        table.insert(skin.destination, { -- 起動用ボタン
            id = "replay" .. i .. "ButtonDummy", op = {replayOps[i]}, dst = {
                {x = buttonX + 6, y = REPLAY.Y + 6, w = REPLAY.SIZE - 12, h = REPLAY.SIZE - 12}
            }
        })
    end
    return skin
end

return playButtons.functions