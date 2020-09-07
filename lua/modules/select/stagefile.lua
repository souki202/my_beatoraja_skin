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

    SHADOW = {
        X = function (self) return self.X - 12 end,
        Y = function (self) return self.Y - 12 end,
        W = 640,
        H = 480,
        A = 102,
    },
    FRAME = {
        X = function (self) return self.X + (self.W - self.FRAME.W) / 2 end,
        Y = function (self) return self.Y + (self.H - self.FRAME.H) / 2 end,
        W = 800,
        H = 600,
    },
    MASK = {
        FADEOUT_START = 200,
        FADEOUT_END = 300,
        ALPHA = 128,
    }
}

stagefile.functions.load = function ()
    STAGE_FILE.MASK.FADEOUT_START = getStageFileMaskFadeOutStartTime()
    STAGE_FILE.MASK.FADEOUT_END = math.max(STAGE_FILE.MASK.FADEOUT_START, getStageFileMaskFadeOutEndTime())
    STAGE_FILE.MASK.ALPHA = getStageFileMaskAlpha()

    local skin = {
        image = {
            {id = "noImage", src = 7, x = 0, y = 0, w = -1, h = -1}
        }
    }
    local imgs = skin.image
    for i = 1, 6 do
        imgs[#imgs+1] = {
            id = "stageFileFrame" .. i, src = 4, x = 0, y = STAGE_FILE.FRAME.H * (i - 1), w = STAGE_FILE.FRAME.W, h = STAGE_FILE.FRAME.H
        }
    end
    return skin
end

stagefile.functions.dst = function ()
    local skin = {
        destination = {
            { -- stage file影
                id = "black", op = {2, 945}, dst = {
                    {x = STAGE_FILE.SHADOW.X(STAGE_FILE), y = STAGE_FILE.SHADOW.Y(STAGE_FILE), w = STAGE_FILE.SHADOW.W, h = STAGE_FILE.SHADOW.H, a = STAGE_FILE.SHADOW.A}
                }
            },
            -- stagefile黒背景
            {
                id = "black", op = {191, 2}, dst = {
                    {x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H, a = 255}
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
                id = "black", op = {{190, 191}, 2, 975}, timer = 11, loop = STAGE_FILE.MASK.FADEOUT_END, dst = {
                    {time = 0, x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H, a =  STAGE_FILE.MASK.ALPHA},
                    {time = STAGE_FILE.MASK.FADEOUT_START, a = STAGE_FILE.MASK.ALPHA},
                    {time = STAGE_FILE.MASK.FADEOUT_END, a = 0}
                }
            },
        }
    }
    local dst = skin.destination
    for i = 1, 6 do
        dst[#dst+1] = {
            id = "stageFileFrame" .. i, op = {2, 150 + (i - 1)}, dst = {
                {x = STAGE_FILE.FRAME.X(STAGE_FILE), y = STAGE_FILE.FRAME.Y(STAGE_FILE), w = STAGE_FILE.FRAME.W, h = STAGE_FILE.FRAME.H}
            }
        }
    end
    return skin
end

return stagefile.functions