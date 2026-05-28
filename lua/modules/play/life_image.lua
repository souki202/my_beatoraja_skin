local main_state = require("main_state")
local uuid = require("modules.commons.uuid")
local commons = require("modules.play.commons")
local image = require("modules.commons.image")
local playlog = require("modules.commons.playlog")
local luajava = require("luajava")

local LIFE_IMAGE = {
    WIDTH = 630,
    HEIGHT = 320,
    LINE_HEIGHT = 2,
    COLORS = {
        {251, 137, 255, 1}, -- aeasy
        {64, 255, 255, 1}, -- easy
        {64, 200, 64, 1}, -- normal
        {255, 0, 0, 1}, -- hard
        {255, 150, 0, 1}, -- exhard
    }
}

local life = {
    image = nil,
    wasPrepare = false,
    wasOutput = false,
    functions = {}
}

life.functions.load = function ()
    life.image = image:newInstance()
    life.image:createBufferedImage(LIFE_IMAGE.WIDTH, LIFE_IMAGE.HEIGHT)
end

local function clamp(v, minValue, maxValue)
    return math.max(minValue, math.min(maxValue, v))
end

local function createArgb(color)
    local a = color[4] or 1
    if a <= 1 then a = a * 255 end

    local argb =
        math.floor(clamp(a, 0, 255) + 0.5) * 16777216 +
        math.floor(clamp(color[1], 0, 255) + 0.5) * 65536 +
        math.floor(clamp(color[2], 0, 255) + 0.5) * 256 +
        math.floor(clamp(color[3], 0, 255) + 0.5)

    if argb >= 2147483648 then
        argb = argb - 4294967296
    end
    return argb
end

local function setPixel(img, x, y, argb)
    x = math.floor(x + 0.5)
    y = math.floor(y + 0.5)
    if x < 0 or x >= LIFE_IMAGE.WIDTH or y < 0 or y >= LIFE_IMAGE.HEIGHT then
        return
    end
    img:setRGB(x, y, argb)
end

local function drawPoint(img, x, y, argb)
    local startY = -math.floor(LIFE_IMAGE.LINE_HEIGHT / 2)
    for dy = 0, LIFE_IMAGE.LINE_HEIGHT - 1 do
        setPixel(img, x, y + startY + dy, argb)
    end
end

local function drawLine(img, x1, y1, x2, y2, argb)
    local dx = x2 - x1
    local dy = y2 - y1
    local steps = math.ceil(math.max(math.abs(dx), math.abs(dy)))
    if steps <= 0 then
        drawPoint(img, x1, y1, argb)
        return
    end

    for step = 0, steps do
        local p = step / steps
        drawPoint(img, x1 + dx * p, y1 + dy * p, argb)
    end
end

life.functions.output = function ()
    if not life.wasPrepare then
        life.wasPrepare = true
        return
    end
    if life.wasOutput then
        return
    end
    print("画像出力開始")
    life.wasOutput = true
    if not life.image or not life.image.img or not isOutputLog() or not getIsEnableLR2Gauge() then
        return
    end

    -- 非同期で画像出力
    local id = uuid()
    local runnable = {
        run = function ()
            life.functions._output(id)
        end
    }
    local runnableProxy = luajava.createProxy("java.lang.Runnable", runnable)
    local t = luajava.newInstance("java.lang.Thread", runnableProxy)
    t:start()

    -- idを出力
    local f = io.open(skin_config.get_path("../generated/custom_groove/id.txt"), "w")
    if not f then
        print("カスタムゲージの画像IDの出力に失敗しました")
        return
    end
    f:write(id)
    f:close()
end

life.functions._output = function (id)
    print("カスタムゲージの出力開始")
    local status, r = pcall(function ()
        -- そのままだと上下端で線が細くなるので領域を調整
        local top = math.floor(LIFE_IMAGE.LINE_HEIGHT / 2)
        local range = LIFE_IMAGE.HEIGHT - LIFE_IMAGE.LINE_HEIGHT

        -- 描画していく
        local data = playlog.getGrooveGaugeData()
        local num_of_data = #data
        local isCompleted = playlog.getLastTimeData().notes == main_state.number(74) -- 全ノーツを判定したかどうか
        print("num of notes: " .. playlog.getLastTimeData().notes)
        print("total notes: " .. main_state.number(74))
        -- ゲージの種類ごとにPolyLineを引く (aeasy ~ exhardまで)
        for i = 1, 5 do
            local argb = createArgb(LIFE_IMAGE.COLORS[i])
            local prevX = nil
            local prevY = nil
            for j = 1, playlog.numOfOutputLogs() do
                local v = 0
                if num_of_data < j then -- 描画しようとしている場所のdataがないとき
                    v = isCompleted and data[num_of_data][i] or 0
                else -- あるとき
                    v = data[j][i]
                end
                local x = j - 1
                local y = top + range * (100 - v) / 100
                if prevX then
                    drawLine(life.image.img, prevX, prevY, x, y, argb)
                else
                    drawPoint(life.image.img, x, y, argb)
                end
                prevX = x
                prevY = y
            end
        end

        life.image:outputImage(skin_config.get_path("../generated/custom_groove/groove_" .. id .. ".png"))
        print("カスタムゲージの出力が完了しました")
    end)
    if not status then
        print("カスタムゲージの出力に失敗しました")
        print(r)
    end
end

return life.functions
