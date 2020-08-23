local commons = require("modules.select.commons")

local stagefile = {
    functions = {}
}

-- stage fileまわり
local STAGE_FILE = {
    X = 105,
    Y = 464,
    W = 640,
    H = 480,
    FRAME_OFFSET = 31,

    SHADOW = {
        X = -12,
        Y = -12,
        A = 102,
    },
}

stagefile.functions.load = function ()
    return {
        image = {
            {id = "stagefileFrame", src = 4, x = 0, y = 0, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2},
            {id = "stagefileShadow", src = 4, x = 0, y = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2},
            {id = "noImage", src = 7, x = 0, y = 0, w = -1, h = -1}
        }
    }
end

stagefile.functions.dst = function ()
    return {
        destination = {
            -- stagefile背景
            {
                id = "black", op = {191, 2}, dst = {
                    {x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H, a = 255}
                }
            },
            -- stage file影1
            {
                id = "black", op = {2, 947}, offset = 40, dst = {
                    {x = STAGE_FILE.X + STAGE_FILE.SHADOW.X, y = STAGE_FILE.Y + STAGE_FILE.SHADOW.Y, w = STAGE_FILE.W, h = STAGE_FILE.H, a = STAGE_FILE.SHADOW.A}
                }
            },
            { -- stage file影2(デフォルト)
                id = "stagefileShadow", op = {2, 946}, dst = {
                    {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y = STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2}
                }
            },
            -- no stagefile
            {
                id = "noImage", op = {190, 2}, stretch = 1, dst = {
                    {x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H}
                }
            },
            -- ステージファイル
            {
                id = -100, op = {2}, filter = 1, stretch = 1, dst = {
                    {x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H}
                }
            },
            -- ステージファイルマスク
            {
                id = "black", op = {{190, 191}, 2}, timer = 11, loop = 300, dst = {
                    {time = 0  , a = 128, x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H},
                    {time = 200, a = 128},
                    {time = 300, a = 0}
                }
            },
            -- Stage fileフレーム
            { -- 設定無し
                id = "stagefileFrame", op = {2, 150, 945}, dst = {
                    {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y = STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2}
                }
            },
            { -- beginner
                id = "stagefileFrame", op = {2, 151, 945}, dst = {
                    {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y =  STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2, r = 153, g = 255, b = 153}
                }
            },
            { -- normal
                id = "stagefileFrame", op = {2, 152, 945}, dst = {
                    {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y =  STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2, r = 153, g = 255, b = 255}
                }
            },
            { -- hyper
                id = "stagefileFrame", op = {2, 153, 945}, dst = {
                    {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y =  STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2, r = 255, g = 204, b = 102}
                }
            },
            { -- another
                id = "stagefileFrame", op = {2, 154, 945}, dst = {
                    {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y =  STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2, r = 255, g = 102, b = 102}
                }
            },
            { -- insane
                id = "stagefileFrame", op = {2, 155, 945}, dst = {
                    {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y =  STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2, r = 204, g = 0, b = 102}
                }
            },
        }
    }
end

return stagefile.functions