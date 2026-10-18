local main_state = require("main_state")
local commons = require("modules.play.commons")
local image = require("modules.commons.image")
local playlog = require("modules.commons.playlog")
local customGroove = require("modules.commons.custom_groove")

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

local function getColorIndex(img, color)
    local a = color[4] or 1
    if a <= 1 then a = a * 255 end
    return img:getColorIndex(
        math.floor(clamp(color[1], 0, 255) + 0.5),
        math.floor(clamp(color[2], 0, 255) + 0.5),
        math.floor(clamp(color[3], 0, 255) + 0.5),
        math.floor(clamp(a, 0, 255) + 0.5)
    )
end

local function setPixel(img, x, y, colorIndex)
    img:setPixel(math.floor(x + 0.5), math.floor(y + 0.5), colorIndex)
end

local function drawPoint(img, x, y, colorIndex)
    local startY = -math.floor(LIFE_IMAGE.LINE_HEIGHT / 2)
    for dy = 0, LIFE_IMAGE.LINE_HEIGHT - 1 do
        setPixel(img, x, y + startY + dy, colorIndex)
    end
end

local function drawLine(img, x1, y1, x2, y2, colorIndex)
    local dx = x2 - x1
    local dy = y2 - y1
    local steps = math.ceil(math.max(math.abs(dx), math.abs(dy)))
    if steps <= 0 then
        drawPoint(img, x1, y1, colorIndex)
        return
    end

    for step = 0, steps do
        local p = step / steps
        drawPoint(img, x1 + dx * p, y1 + dy * p, colorIndex)
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

    -- 0.8.9以降はスレッドが使えないため同期で画像出力 (数百ms程度かかる)
    local id = customGroove.nextImageId()
    if life.functions._output(id) then
        -- idを出力
        customGroove.writeImageId(id)
    end
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
            local colorIndex = getColorIndex(life.image, LIFE_IMAGE.COLORS[i])
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
                    drawLine(life.image, prevX, prevY, x, y, colorIndex)
                else
                    drawPoint(life.image, x, y, colorIndex)
                end
                prevX = x
                prevY = y
            end
        end

        if not life.image:outputImage(skin_config.get_path(customGroove.getImagePath(id))) then
            error("画像の書き込みに失敗しました")
        end
        print("カスタムゲージの出力が完了しました")
    end)
    if not status then
        print("カスタムゲージの出力に失敗しました")
        print(r)
    end
    return status
end

return life.functions
