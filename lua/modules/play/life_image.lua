local main_state = require("main_state")
local uuid = require("modules.commons.uuid")
local commons = require("modules.play.commons")
local image = require("modules.commons.image")
local playlog = require("modules.commons.playlog")
local luajava = require("luajava")
local Color = luajava.bindClass("java.awt.Color")
local RenderingHints = luajava.bindClass("java.awt.RenderingHints")

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
        local g = life.image.img:getGraphics()
        -- アンチエイリアス有効化
        g:setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
        -- 描画するグラフの太さを設定
        local stroke = luajava.newInstance("java.awt.BasicStroke", LIFE_IMAGE.LINE_HEIGHT)
        -- そのままだと上下端で線が細くなるので領域を調整
        local bottom = LIFE_IMAGE.HEIGHT - math.ceil(LIFE_IMAGE.LINE_HEIGHT / 2)
        local top = math.floor(LIFE_IMAGE.LINE_HEIGHT / 2)
        local range = LIFE_IMAGE.HEIGHT - LIFE_IMAGE.LINE_HEIGHT

        -- 描画していく
        local data = playlog.getGrooveGaugeData()
        local num_of_data = #data
        local isCompleted = playlog.getLastTimeData().notes == main_state.number(74) -- 全ノーツを判定したかどうか
        print("num of notes: " .. playlog.getLastTimeData().notes)
        print("total notes: " .. main_state.number(74))
        g:setStroke(stroke)
        -- ゲージの種類ごとにPolyLineを引く (aeasy ~ exhardまで)
        for i = 1, 5 do
            local x = {}
            local y = {}
            g:setColor(luajava.newInstance("java.awt.Color", LIFE_IMAGE.COLORS[i][1] / 255, LIFE_IMAGE.COLORS[i][2] / 255, LIFE_IMAGE.COLORS[i][3] / 255, LIFE_IMAGE.COLORS[i][4]))
            for j = 1, playlog.numOfOutputLogs() do
                local v = 0
                if num_of_data < j then -- 描画しようとしている場所のdataがないとき
                    v = isCompleted and data[num_of_data][i] or 0
                else -- あるとき
                    v = data[j][i]
                end
                x[j] = j - 1
                y[j] = top + range * (100 - v) / 100
            end
            g:drawPolyline(x, y, #x)
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