require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local loading = {
    functions = {}
}

local LOADING = {
    AREA = {
        X = function () return lanes.getAreaX() end,
        Y = function () return lanes.getAreaY() end,
        W = function () return lanes.getAreaW() end,
        H = function () return lanes.getLaneHeight() end,
    },
    CIRCLE = {
        X = function (self) return self.AREA.X() + 39 end,
        Y = function (self) return self.AREA.Y() + 352 end,
        SIZE = 50,
        ANIM_TIME = 1000,
    },
    TEXT = {
        X = function (self) return self.AREA.X() + 251 end,
        Y = function (self) return self.AREA.Y() + 352 end,
        SIZE = 24,
    },
    READY = {
        X = function (self) return self.AREA.X() + (self.AREA.W() - self.READY.W) / 2 end,
        START_X = function (self) return self.AREA.X() + (self.AREA.W() - self.READY.W * self.READY.INIT_MUL) / 2 end,
        Y = function (self) return self.AREA.Y() + 365 - self.READY.H / 2 end,
        START_Y = function (self) return self.AREA.Y() + 306 - self.READY.H * self.READY.INIT_MUL / 2 end,
        W = 301,
        H = 115,
        APPEAR_TIME = 350,
        DEL_START_TIME = 800,
        DEL_TIME = 1100,
        INIT_MUL = 3,
    },
    GAUGE = {
        X = function (self) return self.AREA.X() + 16 end,
        Y = function (self) return self.AREA.Y() + 337 end,
        W = 400,
        H = 8,
    },
    FADEOUT = 500,
}

function isLoaded()
    return main_state.number(165) >= 100
end

local function getDifficultyColor()
	local dif = getDifficultyValueForColor()
	local colors = {{255, 255, 255}, {137, 204, 137}, {137, 204, 204}, {204, 164, 108}, {204, 104, 104}, {204, 102, 153}}
	return colors[dif][1], colors[dif][2], colors[dif][3]
end

loading.functions.load = function ()
    return {
        image = {
            {id = "loadingCircle", src = 0, x = 655, y = 0, w = LOADING.CIRCLE.SIZE, h = LOADING.CIRCLE.SIZE},
            {id = "readyText", src = 17, x = 0, y = 0, w = -1, h = -1},
        },
        text = {
            {id = "loadingText", font = 0, size = LOADING.TEXT.SIZE, constantText = "楽曲データ読込中", align = 1},
            {id = "loadCompleteText", font = 0, size = LOADING.TEXT.SIZE, constantText = "プレイ開始待機中", align = 1},
        },
        graph = {
            {id = "loadingGauge", src = 999, x = 2, y = 0, w = 1, h = 1, angle = 2, type = 102},
        }
    }
end

loading.functions.dst = function ()
    -- BACKBMPはbga.luaの方で
    return {
        destination = {
            {id = "black", op = {80}, dst = {
                {x = LOADING.AREA.X(), y = LOADING.AREA.Y(), w = LOADING.AREA.W(), h = LOADING.AREA.H(), a = 128}
            }},
            {id = "black", op = {81}, timer = 40, loop = -1, dst = {
                {time = 0, x = LOADING.AREA.X(), y = LOADING.AREA.Y(), w = LOADING.AREA.W(), h = LOADING.AREA.H(), a = 128},
                {time = LOADING.FADEOUT, a = 0}
            }},
            {id = "loadingCircle", op = {80}, loop = 0, dst = {
                {time = 0, x = LOADING.CIRCLE.X(LOADING), y = LOADING.CIRCLE.Y(LOADING), w = LOADING.CIRCLE.SIZE, h = LOADING.CIRCLE.SIZE, angle = 0},
                {time = LOADING.CIRCLE.ANIM_TIME, angle = -360},
            }},
            {id = "loadingText", draw = function() return not isLoaded() and main_state.option(80) end, dst = {
                {x = LOADING.TEXT.X(LOADING), y = LOADING.TEXT.Y(LOADING), w = 999, h = LOADING.TEXT.SIZE}
            }},
            {id = "loadCompleteText", draw = function() return isLoaded() and main_state.option(80) end, dst = {
                {x = LOADING.TEXT.X(LOADING), y = LOADING.TEXT.Y(LOADING), w = 999, h = LOADING.TEXT.SIZE}
            }},
            {id = "loadingGauge", op = {80}, dst = {
                {x = LOADING.GAUGE.X(LOADING), y = LOADING.GAUGE.Y(LOADING), w = LOADING.GAUGE.W, h = LOADING.GAUGE.H, a = 192}
            }},
            {id = "readyText", op = {81}, timer = 40, loop = -1, dst = {
                {time = 0, x = LOADING.READY.START_X(LOADING), y = LOADING.READY.START_Y(LOADING), w = LOADING.READY.W * LOADING.READY.INIT_MUL, h = LOADING.READY.H * LOADING.READY.INIT_MUL},
                {time = LOADING.READY.APPEAR_TIME, x = LOADING.READY.X(LOADING), y = LOADING.READY.Y(LOADING), w = LOADING.READY.W, h = LOADING.READY.H},
                {time = LOADING.READY.DEL_START_TIME, a = 255},
                {time = LOADING.READY.DEL_TIME, a = 0},
            }},
            -- 描画が引っかかるので先に読んでおく
            {id = "readyText", loop = -1, dst = {
                {time = 0, x = 0, y = 0, w = 1, h = 1, a = 1},
                {time = 1, a = 0},
            }},
        }
    }
end

return loading.functions