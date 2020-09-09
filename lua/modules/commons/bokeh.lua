require("modules.commons.define")

local BOKEH = {
    QUALITY1 = 25, -- %
    QUALITY_SKIP = 1,
    ALPHA_TIMER_MUL = 1000000,
}

local bokeh = {
    functions = {}
}

bokeh.functions.createBokehDst = function (id, bokehLen, x, y, w, h)
    return bokeh.functions.createBokehDstDetail(id, bokehLen, x, y, w, h, 255, 255, 255, 255, nil, nil)
end

bokeh.functions.createBokehDstWithCondition = function (id, bokehLen, x, y, w, h, op, draw)
    return bokeh.functions.createBokehDstDetail(id, bokehLen, x, y, w, h, 255, 255, 255, 255, op, draw)
end

bokeh.functions.createBokehDstDetail = function (id, bokehLen, x, y, w, h, r, g, b, a, op, draw)
    local dst = {}
    local quality = BOKEH.QUALITY1 / 100
    local rand = math.random
    local mul = BOKEH.ALPHA_TIMER_MUL

    -- まず中央に1枚
    dst[#dst+1] = {
        id = id, op = op, draw = draw, dst = {
            {x = x, y = y, w = w, h = h, r = r, g = g, b = b, a = a},
        }
    }

    for len = 1, bokehLen, BOKEH.QUALITY_SKIP do
        local n = math.floor(2 * len * math.pi)
        local radianOffset = math.random(0, 359) / 180 * math.pi
        -- local maxAlpha = 255 * r / bokehLen
        local totalAlpha = (a / 255) * gaussian(len, 1, 0, bokehLen / 2)
        -- local a = math.min(maxAlpha, maxAlpha / n / quality) / math.sqrt(math.max(1, bokehLen / BOKEH.QUALITY_SKIP))
        local a2 = 255 * math.min(totalAlpha, totalAlpha / n / quality)
        local idxes = {}
        for i = 1, n do
            idxes[i] = i
        end
        table.shuffle(idxes)
        for i = 1, n do
            local idx = idxes[i]
            -- ディザ
            if rand() < quality then
                local radian = (idx / n) * 2 * math.pi + radianOffset
                local x2 = x + len * math.cos(radian)
                local y2 = y + len * math.sin(radian)
                dst[#dst+1] = {
                    id = id, op = op, draw = draw, dst = {
                        {x = x2, y = y2, w = w, h = h, r = r, g = g, b = b, a = a2},
                    }
                }
            end
        end
    end
    myPrint("ボケでのdst数: " .. #dst)
    return {destination = dst}
end

return bokeh.functions