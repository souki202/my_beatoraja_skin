local commons = require("modules.select.commons")
local OPENING_ANIM_TIME = 1500 -- シーン開始時のアニメーション時間
local OPENING_ANIM_TIME_OFFSET = 00 -- アニメーション開始時刻のずれ

local FOV = 90
local METEOR_INFO = {
    BACKGROUND_COLOR = {r = 0, g = 0, b = 0},
    DEFAULT_QUANTITY = 6,
    QUANTITY = 6,
    INTERVAL_Y = 300,
    WIDTH = 192,
    ANGLE = -20,
    RADIAN = math.rad(-20),
    SATURATION = 0.13,
    BRIGHTNESS = 1.0,
    HEIGHT = BASE_WIDTH / math.cos(math.atan2(BASE_HEIGHT, BASE_WIDTH)),
    ROTATION_VALUE = 1800,
    BODY_SIZE = 384,
    STARDUST_QUANTITY = 60,
    STARDUST_SIZE_MAX = 64,
    STARDUST_SIZE_MIN = 28,
    STARDUST_ROTATION = 480,
    STARDUST_ANIM_TIME = 1500,
    STARDUST_DIRECTION_VARIATION = 40,
    STARDUST_MOVE_LENGTH = 4000,
    METEOR_BODY_SATURATION = 0.4,
    METEOR_BODY_BRIGHTNESS = 1.0
}

METEOR_INFO.WIDTH     = METEOR_INFO.DEFAULT_QUANTITY / METEOR_INFO.QUANTITY * METEOR_INFO.WIDTH
METEOR_INFO.BODY_SIZE = METEOR_INFO.DEFAULT_QUANTITY / METEOR_INFO.QUANTITY * METEOR_INFO.BODY_SIZE

local REVERSE_ANIM_INFO = {
    TIME_OFFSET = 0, -- アニメーションを途中から開始する
    STARTING_X = 0, -- 伝播の起点
    STARTING_Y = 560,
    DIRECTION = 1, -- ひっくり返る向き 0:縦 1:横
    IS_REVERSE = 0, -- ひっくり返る向きを逆にするかどうか
    DIV_X = 16,
    DIV_Y = 16,
    PROPAGATION_TIME = 40, -- 0.01sで進むピクセル数
    REVERSE_TIME = 300, -- ひっくり返るのにかかる時間
    VARIATION_TIME = 150, -- ms
    TIME_INVERSE_RESOLUTION = 125, -- 時間の分解能 低い程分解能が高い
    IMAGE_INVERSE_RESOLUTION = 8, -- タイルの分解能 低いほど分解能が高い
    TIME_RATE_UP_TO_TRANSPARENCY = 90, -- タイルが透明になるまでの時間の%
    COLOR = {r = 0, g = 0, b = 0}
}

local opening = {
    functions = {}
}

local function calcComplementValueByTime(startValue, endValue, nowTime, overallTime)
    return startValue + (endValue - startValue) * nowTime / overallTime
end

local function hsvToRgb(h, s, v)
    h = h % 360
    local c = v * s * 1.0
    local hp = h / 60.0
    local x = c * (1 - math.abs(hp % 2 - 1))

    local r, g, b
    if 0 <= hp and hp < 1 then
        r, g, b = c, x, 0
    elseif 1 <= hp and hp < 2 then
        r, g, b = x, c, 0
    elseif 2 <= hp and hp < 3 then
        r, g, b = 0, c, x
    elseif 3 <= hp and hp < 4 then
        r, g, b = 0, x, c
    elseif 4 <= hp and hp < 5 then
        r, g, b = x, 0, c
    elseif 5 <= hp and hp < 6 then
        r, g, b = c, 0, x
    end

    local m = v - c
    r, g, b = r + m, g + m, b + m
    r = math.floor(r * 255)
    g = math.floor(g * 255)
    b = math.floor(b * 255)
    return r, g, b
end

local function calcOpeningAnimationStartPosition(initX, initY, toX, toY, timeOffset)
    local x = initX + (toX - initX) * (1.0 * timeOffset / OPENING_ANIM_TIME)
    local y = initY + (toY - initY) * (1.0 * timeOffset / OPENING_ANIM_TIME)
    return x, y
end

local function drawStardust(meteorStartX, meteorToX, meteorStartY, meteorToY, quantity, skin)
    for j = 1, quantity do
        -- その時刻での星の座標を取得
        local parentTime = (OPENING_ANIM_TIME - OPENING_ANIM_TIME_OFFSET) * j / 60
        local baseX = calcComplementValueByTime(meteorStartX, meteorToX, parentTime, OPENING_ANIM_TIME - OPENING_ANIM_TIME_OFFSET)
        local baseY = calcComplementValueByTime(meteorStartY, meteorToY, parentTime, OPENING_ANIM_TIME - OPENING_ANIM_TIME_OFFSET)
        -- 星が外すぎるなら星屑を出さない
        if -BASE_WIDTH * 0.5 <= baseX and baseX <= BASE_WIDTH * 1.5 and -BASE_HEIGHT * 0.5 <= baseY and baseY <= BASE_HEIGHT * 1.5 then
            local size = math.random(METEOR_INFO.STARDUST_SIZE_MIN, METEOR_INFO.STARDUST_SIZE_MAX)
            local moveLength = METEOR_INFO.STARDUST_MOVE_LENGTH
            -- 適当に後方にぶちまける
            local direction = METEOR_INFO.ANGLE - 180
            local deltaDirection = math.random(0, METEOR_INFO.STARDUST_DIRECTION_VARIATION) - METEOR_INFO.STARDUST_DIRECTION_VARIATION / 2
            direction = math.rad(direction + deltaDirection)
            local toX = baseX + moveLength * -math.sin(direction)
            local toY = baseY + moveLength * math.cos(direction)

            local meteorInitAngle = math.random(0, 359)

            table.insert(skin.destination, {
                id = "meteorBody", loop = -1, dst = {
                    {time = 0, x = baseX, y = baseY, w = size, h = size, angle = 0, a = 0},
                    {time = commons.INPUT_WAIT + parentTime - 1, angle = meteorInitAngle, a = 0},
                    {time = commons.INPUT_WAIT + parentTime, angle = meteorInitAngle, a = 255},
                    {time = commons.INPUT_WAIT + parentTime + METEOR_INFO.STARDUST_ANIM_TIME, x = toX, y = toY, angle = METEOR_INFO.STARDUST_ROTATION + meteorInitAngle}
                }
            })
            table.insert(skin.destination, {
                id = "meteorLight", loop = -1, dst = {
                    {time = 0, x = baseX, y = baseY, w = size, h = size, angle = 0, a = 0},
                    {time = commons.INPUT_WAIT + parentTime - 1, angle = meteorInitAngle, a = 0},
                    {time = commons.INPUT_WAIT + parentTime, angle = meteorInitAngle, a = 255},
                    {time = commons.INPUT_WAIT + parentTime + METEOR_INFO.STARDUST_ANIM_TIME, x = toX, y = toY, angle = METEOR_INFO.STARDUST_ROTATION + meteorInitAngle}
                }
            })
        end
    end
end

opening.functions.init = function()
    -- 全体設定
    local v = getTableValue(skin_config.offset, "FOV (既定値90 -1で平行投影 0<x<180 or x=-1)", {x = FOV})
    if v.x ~= 0 then FOV = v.x end

    -- ここから流星設定
    v = getTableValue(skin_config.offset, "流星アニメーション時間(ms 既定値1500 0<x)", {x = OPENING_ANIM_TIME})
    if v.x ~= 0 then OPENING_ANIM_TIME = v.x end

    v = getTableValue(skin_config.offset, "流星アニメーション開始時間オフセット(ms 既定値0 0<=x<流星アニメーション時間)", {x = OPENING_ANIM_TIME_OFFSET})
    if v.x ~= 0 then  OPENING_ANIM_TIME_OFFSET = v.x end

    v = getTableValue(skin_config.offset, "本数(既定値6 0<x)", {x = METEOR_INFO.QUANTITY})
    if v.x ~= 0 then METEOR_INFO.QUANTITY = v.x end
    METEOR_INFO.WIDTH = METEOR_INFO.DEFAULT_QUANTITY / (METEOR_INFO.QUANTITY - 0.5) * METEOR_INFO.WIDTH

    v = getTableValue(skin_config.offset, "各流星のズレ(既定値300)", {x = METEOR_INFO.INTERVAL_Y})
    if v.x ~= 0 then METEOR_INFO.INTERVAL_Y = v.x end

    v = getTableValue(skin_config.offset, "角度(既定値-20)", {a = METEOR_INFO.ANGLE})
    if v.a ~= 0 then METEOR_INFO.ANGLE = v.a end
    METEOR_INFO.RADIAN = math.rad(METEOR_INFO.ANGLE)

    v = getTableValue(skin_config.offset, "虹の彩度(既定値13 0<=x<=100)", {x = METEOR_INFO.SATURATION})
    if v.x ~= 0 then METEOR_INFO.SATURATION = v.x / 100.0 end

    v = getTableValue(skin_config.offset, "虹の明度(既定値100 0<=x<=100)", {x = METEOR_INFO.BRIGHTNESS})
    if v.x ~= 0 then METEOR_INFO.BRIGHTNESS = v.x / 100.0 end

    v = getTableValue(skin_config.offset, "星の大きさ(% 既定値100)", {x = 0})
    if v.x ~= 0 then
        METEOR_INFO.BODY_SIZE = METEOR_INFO.BODY_SIZE * v.x / 100.0
    end
    METEOR_INFO.BODY_SIZE = METEOR_INFO.DEFAULT_QUANTITY / METEOR_INFO.QUANTITY * METEOR_INFO.BODY_SIZE

    v = getTableValue(skin_config.offset, "星の回転量(既定値1800)", {a = METEOR_INFO.ROTATION_VALUE})
    if v.a ~= 0 then METEOR_INFO.ROTATION_VALUE = v.a end

    -- ここから星屑
    v = getTableValue(skin_config.offset, "星屑の量(既定値60)", {x = METEOR_INFO.STARDUST_QUANTITY})
    if v.x ~= 0 then METEOR_INFO.STARDUST_QUANTITY = v.x end

    v = getTableValue(skin_config.offset, "星屑の最大の大きさ(既定値64)", {x = METEOR_INFO.STARDUST_SIZE_MAX})
    if v.x ~= 0 then METEOR_INFO.STARDUST_SIZE_MAX = v.x end

    v = getTableValue(skin_config.offset, "星屑の最小の大きさ(既定値28)", {x = METEOR_INFO.STARDUST_SIZE_MIN})
    if v.x ~= 0 then METEOR_INFO.STARDUST_SIZE_MIN = v.x end

    v = getTableValue(skin_config.offset, "星屑の回転量(既定値480)", {a = METEOR_INFO.STARDUST_ROTATION})
    if v.a ~= 0 then METEOR_INFO.STARDUST_ROTATION = v.a end

    v = getTableValue(skin_config.offset, "星屑のアニメーション時間(既定値1500)", {x = METEOR_INFO.STARDUST_ANIM_TIME})
    if v.x ~= 0 then METEOR_INFO.STARDUST_ANIM_TIME = v.x end

    v = getTableValue(skin_config.offset, "星屑の角度のばらつき(既定値40)", {a = METEOR_INFO.STARDUST_DIRECTION_VARIATION})
    if v.a ~= 0 then METEOR_INFO.STARDUST_DIRECTION_VARIATION = v.a end

    v = getTableValue(skin_config.offset, "星屑の移動量(既定値4000)", {x = METEOR_INFO.STARDUST_MOVE_LENGTH})
    if v.x ~= 0 then METEOR_INFO.STARDUST_MOVE_LENGTH = v.x end

    v = getTableValue(skin_config.offset, "星屑の彩度(既定値40 0<=x<=100)", {x = METEOR_INFO.METEOR_BODY_SATURATION})
    if v.x ~= 0 then METEOR_INFO.METEOR_BODY_SATURATION = v.x / 100.0 end

    v = getTableValue(skin_config.offset, "星屑の明度(既定値100 0<=x<=100)", {x = METEOR_INFO.METEOR_BODY_BRIGHTNESS})
    if v.x ~= 0 then METEOR_INFO.METEOR_BODY_BRIGHTNESS = v.x / 100.0 end

    v = getTableValue(skin_config.offset, "背景色(既定値0 0<=r,g,b<=255 仕様の都合でrgbはそれぞれxywに割り当て)", {x = 0, y = 0, w = 0})
    if v.x ~= 0 then METEOR_INFO.BACKGROUND_COLOR.r = v.x end
    if v.y ~= 0 then METEOR_INFO.BACKGROUND_COLOR.g = v.y end
    if v.w ~= 0 then METEOR_INFO.BACKGROUND_COLOR.b = v.w end

    -- タイル設定
    local c = getTableValue(skin_config.option, "タイルの回転方向", 920)
    if c == 920 then REVERSE_ANIM_INFO.DIRECTION, REVERSE_ANIM_INFO.IS_REVERSE = 0, 0
    elseif c == 921 then REVERSE_ANIM_INFO.DIRECTION, REVERSE_ANIM_INFO.IS_REVERSE = 0, 1
    elseif c == 922 then REVERSE_ANIM_INFO.DIRECTION, REVERSE_ANIM_INFO.IS_REVERSE = 1, 0
    else REVERSE_ANIM_INFO.DIRECTION, REVERSE_ANIM_INFO.IS_REVERSE = 1, 1
    end

    v = getTableValue(skin_config.offset, "タイルアニメーション開始時間オフセット(ms 既定値0 0<=x<500)", {x = REVERSE_ANIM_INFO.TIME_OFFSET})
    if v.x ~= 0 then REVERSE_ANIM_INFO.TIME_OFFSET = v.x end

    v = getTableValue(skin_config.offset, "伝播の起点座標(既定値0,0 画面左下原点)", {x = REVERSE_ANIM_INFO.STARTING_X, y = REVERSE_ANIM_INFO.STARTING_Y})
    if v.x ~= 0 then REVERSE_ANIM_INFO.STARTING_X = v.x end
    if v.y ~= 0 then REVERSE_ANIM_INFO.STARTING_Y = v.y end

    v = getTableValue(skin_config.offset, "画面分割数(既定値16,16 x,y>0)", {x = REVERSE_ANIM_INFO.DIV_X, y = REVERSE_ANIM_INFO.DIV_Y})
    if v.x ~= 0 then REVERSE_ANIM_INFO.DIV_X = v.x end
    if v.y ~= 0 then REVERSE_ANIM_INFO.DIV_Y = v.y end

    v = getTableValue(skin_config.offset, "伝播速度(10ms毎のpx数 既定値40 x>0)", {x = REVERSE_ANIM_INFO.PROPAGATION_TIME})
    if v.x ~= 0 then REVERSE_ANIM_INFO.PROPAGATION_TIME = v.x end

    v = getTableValue(skin_config.offset, "タイルの回転時間(既定値300 x>0)", {x = REVERSE_ANIM_INFO.REVERSE_TIME})
    if v.x ~= 0 then REVERSE_ANIM_INFO.REVERSE_TIME = v.x end

    v = getTableValue(skin_config.offset, "各タイルの回転開始時間のばらつき(既定値150 x>0)", {x = REVERSE_ANIM_INFO.VARIATION_TIME})
    if v.x ~= 0 then REVERSE_ANIM_INFO.VARIATION_TIME = v.x end

    v = getTableValue(skin_config.offset, "タイル回転の分割時間(このms毎に分割 規定値125 x>0)", {x = REVERSE_ANIM_INFO.TIME_INVERSE_RESOLUTION})
    if v.x ~= 0 then REVERSE_ANIM_INFO.TIME_INVERSE_RESOLUTION = v.x end

    v = getTableValue(skin_config.offset, "タイルの分割数(このpx毎に分割 既定値8 x>0)", {x = REVERSE_ANIM_INFO.IMAGE_INVERSE_RESOLUTION})
    if v.x ~= 0 then REVERSE_ANIM_INFO.IMAGE_INVERSE_RESOLUTION = v.x end

    v = getTableValue(skin_config.offset, "タイルが透明になるまでの時間の割合(既定値90 0<=x<=100)", {x = REVERSE_ANIM_INFO.TIME_RATE_UP_TO_TRANSPARENCY})
    if v.x ~= 0 then REVERSE_ANIM_INFO.TIME_RATE_UP_TO_TRANSPARENCY = v.x end

    v = getTableValue(skin_config.offset, "タイルの色(既定値0 0<=r,g,b<=255 rgbはそれぞれxywに割り当て)", {x = 0, y = 0, w = 0})
    if v.x ~= 0 then REVERSE_ANIM_INFO.COLOR.r = v.x end
    if v.y ~= 0 then REVERSE_ANIM_INFO.COLOR.g = v.y end
    if v.w ~= 0 then REVERSE_ANIM_INFO.COLOR.b = v.w end
end

opening.functions.load = function(skin)
    table.insert(skin.source, {id = 5, path = "../select/parts/meteor.png"})

    local imgs = skin.image
    imgs[#imgs+1] = {id = "forOpeningSquare", src = 1, x = PARTS_TEXTURE_SIZE - 3, y = PARTS_TEXTURE_SIZE - 3, w = 3, h = 3}
    imgs[#imgs+1] = {id = "meteorBody", src = 5, x = 0, y = 0, w = 256, h = 256}
    imgs[#imgs+1] = {id = "meteorLight", src = 5, x = 0, y = 256, w = 256, h = 256}
end

opening.functions.drawMeteor = function(skin)
    -- 背景
    local radius = BASE_WIDTH / math.cos(math.atan2(BASE_HEIGHT, BASE_WIDTH))
    local bgInitXLeft  = -BASE_WIDTH + METEOR_INFO.WIDTH / 2
    local bgInitXRight = BASE_WIDTH / 2 - METEOR_INFO.WIDTH / 2
    local tx, ty = rotationByCenter(bgInitXLeft, -BASE_HEIGHT, METEOR_INFO.RADIAN)
    local dstLeft = {
        {time = 0, x = tx, y = ty, w = BASE_WIDTH*1.5, h = BASE_HEIGHT*4, angle = METEOR_INFO.ANGLE, r = METEOR_INFO.BACKGROUND_COLOR.r, g = METEOR_INFO.BACKGROUND_COLOR.g, b = METEOR_INFO.BACKGROUND_COLOR.b}
    }
    tx, ty = rotationByCenter(bgInitXRight, -BASE_HEIGHT, METEOR_INFO.RADIAN)
    local dstRight = {
        {time = 0, x = tx, y = ty, w = BASE_WIDTH*1.5, h = BASE_HEIGHT*4, angle = METEOR_INFO.ANGLE, r = METEOR_INFO.BACKGROUND_COLOR.r, g = METEOR_INFO.BACKGROUND_COLOR.g, b = METEOR_INFO.BACKGROUND_COLOR.b}
    }
    local startAnimToXLeft = bgInitXLeft - METEOR_INFO.WIDTH * METEOR_INFO.QUANTITY
    local startAnimToXRight = bgInitXRight + METEOR_INFO.WIDTH * METEOR_INFO.QUANTITY
    local startAnimToY = -BASE_HEIGHT
    for i = 1, METEOR_INFO.QUANTITY do
        local initYForTimer = -radius - METEOR_INFO.HEIGHT - METEOR_INFO.INTERVAL_Y * (i - 1) -- これは一次変換しない
        local toYForTimer   = radius - (i - 1) * METEOR_INFO.INTERVAL_Y + METEOR_INFO.QUANTITY * METEOR_INFO.INTERVAL_Y
        _, initYForTimer = calcOpeningAnimationStartPosition(0, initYForTimer, 0, toYForTimer, OPENING_ANIM_TIME_OFFSET)
        local percentage    = ((BASE_HEIGHT - METEOR_INFO.HEIGHT) / 2 - initYForTimer) / (toYForTimer - initYForTimer)
        local targetTime    = (OPENING_ANIM_TIME - OPENING_ANIM_TIME_OFFSET) * percentage
        local x = bgInitXLeft + (startAnimToXLeft - bgInitXLeft) * i / METEOR_INFO.QUANTITY
        local y = -BASE_HEIGHT + (startAnimToY + BASE_HEIGHT / 2) * i / METEOR_INFO.QUANTITY

        tx, ty = rotationByCenter(x, y, METEOR_INFO.RADIAN)
        table.insert(dstLeft, {
            time = commons.INPUT_WAIT + targetTime, x = tx, y = ty, acc = 3
        })

        x = bgInitXRight + (startAnimToXRight - bgInitXRight) * i / METEOR_INFO.QUANTITY
        tx, ty = rotationByCenter(x, y, METEOR_INFO.RADIAN)
        table.insert(dstRight, {
            time = commons.INPUT_WAIT + targetTime, x = tx, y = ty, acc = 3
        })
    end
    table.insert(skin.destination, {
        id = "white", loop = -1, center = 1,  dst = dstLeft
    })
    table.insert(skin.destination, {
        id = "white", loop = -1, center = 1,  dst = dstRight
    })

    -- 流星
    -- ひたすら座標計算
    local hue = 0.0
    local deltaHue = 360.0 / METEOR_INFO.QUANTITY
    local startdustDst = {destination = {}}
    for i = 1, METEOR_INFO.QUANTITY do
        local ii = METEOR_INFO.QUANTITY - i
        -- 起点となる回転前の座標を計算
        local initXLeft  = BASE_WIDTH / 2 + (ii * METEOR_INFO.WIDTH) - METEOR_INFO.WIDTH / 2
        local initXRight = BASE_WIDTH / 2 - (ii * METEOR_INFO.WIDTH) - METEOR_INFO.WIDTH / 2
        local toXLeft    = initXLeft
        local toXRight   = initXRight
        local initYLeft  = -radius - ii * METEOR_INFO.INTERVAL_Y - METEOR_INFO.HEIGHT
        local initYRight = initYLeft
        local toYLeft    = radius - ii * METEOR_INFO.INTERVAL_Y + METEOR_INFO.QUANTITY * METEOR_INFO.INTERVAL_Y
        local toYRight   = toYLeft
        local startXLeft, startYLeft   = calcOpeningAnimationStartPosition(initXLeft, initYLeft, toXLeft, toYLeft, OPENING_ANIM_TIME_OFFSET)
        local startXRight, startYRight = calcOpeningAnimationStartPosition(initXRight, initYRight, toXRight, toYRight, OPENING_ANIM_TIME_OFFSET)
        startXLeft, startYLeft = rotationByCenter(startXLeft, startYLeft, METEOR_INFO.RADIAN)
        toXLeft, toYLeft = rotationByCenter(toXLeft, toYLeft, METEOR_INFO.RADIAN)

        local r, g, b = hsvToRgb(math.floor(hue), METEOR_INFO.SATURATION, METEOR_INFO.BRIGHTNESS)
        hue = hue + deltaHue
        local meteorInitXLeft  = BASE_WIDTH / 2 + (ii * METEOR_INFO.WIDTH) - METEOR_INFO.BODY_SIZE / 2
        local meteorInitXRight = BASE_WIDTH / 2 - (ii * METEOR_INFO.WIDTH) - METEOR_INFO.BODY_SIZE / 2
        local meteorToXLeft    = meteorInitXLeft
        local meteorToXRight   = meteorInitXRight
        local meteorInitYLeft  = -radius - ii * METEOR_INFO.INTERVAL_Y - METEOR_INFO.BODY_SIZE / 2
        local meteorInitYRight = meteorInitYLeft
        local meteorToYLeft    = radius - ii * METEOR_INFO.INTERVAL_Y + METEOR_INFO.QUANTITY * METEOR_INFO.INTERVAL_Y + METEOR_INFO.HEIGHT - METEOR_INFO.BODY_SIZE / 2
        local meteorToYRight   = meteorToYLeft
        local meteorStartXLeft, meteorStartYLeft   = calcOpeningAnimationStartPosition(meteorInitXLeft, meteorInitYLeft, meteorToXLeft, meteorToYLeft, OPENING_ANIM_TIME_OFFSET)
        local meteorStartXRight, meteorStartYRight = calcOpeningAnimationStartPosition(meteorInitXRight, meteorInitYRight, meteorToXRight, meteorToYRight, OPENING_ANIM_TIME_OFFSET)
        meteorStartXLeft, meteorStartYLeft = rotationByCenter(meteorStartXLeft, meteorStartYLeft, METEOR_INFO.RADIAN)
        meteorToXLeft, meteorToYLeft = rotationByCenter(meteorToXLeft, meteorToYLeft, METEOR_INFO.RADIAN)
        local meteorDx, meteorDy = linearRotation(METEOR_INFO.BODY_SIZE, METEOR_INFO.BODY_SIZE, METEOR_INFO.RADIAN)
        local meteorInitAngle = math.random(0, 359)
        meteorStartXLeft = meteorStartXLeft + (meteorDx - METEOR_INFO.BODY_SIZE) / 2
        meteorToXLeft    = meteorToXLeft    + (meteorDx - METEOR_INFO.BODY_SIZE) / 2
        meteorStartYLeft = meteorStartYLeft + (meteorDy - METEOR_INFO.BODY_SIZE) / 2
        meteorToYLeft    = meteorToYLeft    + (meteorDy - METEOR_INFO.BODY_SIZE) / 2

        -- 回転の都合で隙間ができるので, 描画幅を+1する
        table.insert(skin.destination, {
            id = "white", loop = -1, center = 1, dst = {
                {time = 0, x = startXLeft, y = startYLeft, w = METEOR_INFO.WIDTH+1, h = METEOR_INFO.HEIGHT, angle = METEOR_INFO.ANGLE, r = r, g = g, b = b},
                {time = commons.INPUT_WAIT},
                {time = commons.INPUT_WAIT + OPENING_ANIM_TIME - OPENING_ANIM_TIME_OFFSET, x = toXLeft, y = toYLeft}
            }
        })

        -- 星本体
        local sr, sg, sb = hsvToRgb(math.floor(hue), METEOR_INFO.METEOR_BODY_SATURATION, METEOR_INFO.METEOR_BODY_BRIGHTNESS)
        table.insert(skin.destination, {
            id = "meteorBody", loop = -1, dst = {
                {time = 0, x = meteorStartXLeft, y = meteorStartYLeft, w = METEOR_INFO.BODY_SIZE, h = METEOR_INFO.BODY_SIZE, angle = 0, r = sr, g = sg, b = sb},
                {time = commons.INPUT_WAIT, angle = meteorInitAngle},
                {time = commons.INPUT_WAIT + OPENING_ANIM_TIME - OPENING_ANIM_TIME_OFFSET, x = meteorToXLeft, y = meteorToYLeft, angle = METEOR_INFO.ROTATION_VALUE + meteorInitAngle}
            }
        })
        table.insert(skin.destination, {
            id = "meteorLight", loop = -1, dst = {
                {time = 0, x = meteorStartXLeft, y = meteorStartYLeft, w = METEOR_INFO.BODY_SIZE, h = METEOR_INFO.BODY_SIZE, angle = 0},
                {time = commons.INPUT_WAIT, angle = meteorInitAngle},
                {time = commons.INPUT_WAIT + OPENING_ANIM_TIME - OPENING_ANIM_TIME_OFFSET, x = meteorToXLeft, y = meteorToYLeft, angle = METEOR_INFO.ROTATION_VALUE + meteorInitAngle}
            }
        })

        if i ~= METEOR_INFO.QUANTITY then
            startXRight, startYRight = rotationByCenter(startXRight, startYRight, METEOR_INFO.RADIAN)
            toXRight, toYRight = rotationByCenter(toXRight, toYRight, METEOR_INFO.RADIAN)
            meteorStartXRight, meteorStartYRight = rotationByCenter(meteorStartXRight, meteorStartYRight, METEOR_INFO.RADIAN)
            meteorToXRight, meteorToYRight = rotationByCenter(meteorToXRight, meteorToYRight, METEOR_INFO.RADIAN)
            meteorStartXRight = meteorStartXRight + (meteorDx - METEOR_INFO.BODY_SIZE) / 2
            meteorToXRight    = meteorToXRight    + (meteorDx - METEOR_INFO.BODY_SIZE) / 2
            meteorStartYRight = meteorStartYRight + (meteorDy - METEOR_INFO.BODY_SIZE) / 2
            meteorToYRight    = meteorToYRight    + (meteorDy - METEOR_INFO.BODY_SIZE) / 2

            table.insert(skin.destination, {
                id = "white", loop = -1, center = 1, dst = {
                    {time = 0, x = startXRight, y = startYRight, w = METEOR_INFO.WIDTH+1, h = METEOR_INFO.HEIGHT, angle = METEOR_INFO.ANGLE, r = r, g = g, b = b},
                    {time = commons.INPUT_WAIT},
                    {time = commons.INPUT_WAIT + OPENING_ANIM_TIME - OPENING_ANIM_TIME_OFFSET, x = toXRight, y = toYRight}
                }
            })
            -- 星本体
            table.insert(skin.destination, {
                id = "meteorBody", loop = -1, dst = {
                    {time = 0, x = meteorStartXRight, y = meteorStartYRight, w = METEOR_INFO.BODY_SIZE, h = METEOR_INFO.BODY_SIZE, angle = 0, r = sr, g = sg, b = sb},
                    {time = commons.INPUT_WAIT, angle = meteorInitAngle},
                    {time = commons.INPUT_WAIT + OPENING_ANIM_TIME - OPENING_ANIM_TIME_OFFSET, x = meteorToXRight, y = meteorToYRight, angle = METEOR_INFO.ROTATION_VALUE + meteorInitAngle}
                }
            })
            table.insert(skin.destination, {
                id = "meteorLight", loop = -1, dst = {
                    {time = 0, x = meteorStartXRight, y = meteorStartYRight, w = METEOR_INFO.BODY_SIZE, h = METEOR_INFO.BODY_SIZE, angle = 0},
                    {time = commons.INPUT_WAIT, angle = meteorInitAngle},
                    {time = commons.INPUT_WAIT + OPENING_ANIM_TIME - OPENING_ANIM_TIME_OFFSET, x = meteorToXRight, y = meteorToYRight, angle = METEOR_INFO.ROTATION_VALUE + meteorInitAngle}
                }
            })
        end

        -- 星屑
        drawStardust(meteorStartXLeft, meteorToXLeft, meteorStartYLeft, meteorToYLeft, METEOR_INFO.STARDUST_QUANTITY, startdustDst)
        drawStardust(meteorStartXRight, meteorToXRight, meteorStartYRight, meteorToYRight, METEOR_INFO.STARDUST_QUANTITY, startdustDst)
    end

    for key, dst in ipairs(startdustDst.destination) do
        table.insert(skin.destination, dst)
    end
end

opening.functions.drawTile = function (skin)
    -- 各マスの情報を入れる
    local squareInfo = {} -- x, y, w, h, centerX, centerY, lengthが入る. x,yは左下
    local minLength = 999999
    for x = 1, REVERSE_ANIM_INFO.DIV_X do
        for y = 1, REVERSE_ANIM_INFO.DIV_Y do
            local posX = math.floor((x - 1) * (BASE_WIDTH / REVERSE_ANIM_INFO.DIV_X))
            local posY = math.floor((y - 1) * (BASE_HEIGHT / REVERSE_ANIM_INFO.DIV_Y))
            local nextPosX = math.floor(x * (BASE_WIDTH / REVERSE_ANIM_INFO.DIV_X))
            local nextPosY = math.floor(y * (BASE_HEIGHT / REVERSE_ANIM_INFO.DIV_Y))
            local w = nextPosX - posX
            local h = nextPosY - posY
            local centerX = math.floor((nextPosX + posX) / 2)
            local centerY = math.floor((nextPosY + posY) / 2)
            local length = (REVERSE_ANIM_INFO.STARTING_X - centerX) ^ 2 + (REVERSE_ANIM_INFO.STARTING_Y - centerY) ^ 2
            length = math.sqrt(length)
            squareInfo[#squareInfo+1] = {x = posX, y = posY, w = w, h = h, centerX = centerX, centerY = centerY, length = length, deltaTime = math.floor(math.random(0, REVERSE_ANIM_INFO.VARIATION_TIME) / 2)}
            minLength = math.min(minLength, length)
        end
    end
    -- 遠い方を下に描画するためにソート
    table.sort(squareInfo, function (a, b) return (a.length < b.length) end)

    -- print("num of squares: " .. #squareInfo)
    -- 描画+アニメーション
    for _, square in pairs(squareInfo) do
        -- print("now: " .. n)
        -- 各線について計算していく
        local startTime = commons.INPUT_WAIT + 1000 * square.length / (REVERSE_ANIM_INFO.PROPAGATION_TIME * 100) - REVERSE_ANIM_INFO.TIME_OFFSET
        startTime = math.max(0, startTime)

        -- 初期化
        local dst = {}
        local n = square.h
        if REVERSE_ANIM_INFO.DIRECTION == 1 then
            n = square.w
        end
        for line = 1, n do
            dst[line] = {id = "white", loop = -1, dst = {}}
            if REVERSE_ANIM_INFO.DIRECTION == 0 then -- 横軸に対してひっくり返る
                table.insert(dst[line].dst, {
                    time = 0, x = square.x, y = square.y + line - 1, w = square.w, h = 1, a = 255, r = REVERSE_ANIM_INFO.COLOR.r, g = REVERSE_ANIM_INFO.COLOR.g, b = REVERSE_ANIM_INFO.COLOR.b
                })
            else -- 縦軸方向に対して
                table.insert(dst[line].dst, {
                    time = 0, x = square.x + line - 1, y = square.y, w = 1, h = square.h, a = 255, r = REVERSE_ANIM_INFO.COLOR.r, g = REVERSE_ANIM_INFO.COLOR.g, b = REVERSE_ANIM_INFO.COLOR.b
                })
            end
            table.insert(dst[line].dst, {
                time = startTime + square.deltaTime
            })
        end

        -- それぞれの時間について
        local fixedTime = REVERSE_ANIM_INFO.REVERSE_TIME
        if REVERSE_ANIM_INFO.REVERSE_TIME % REVERSE_ANIM_INFO.TIME_INVERSE_RESOLUTION ~= 0 then
            fixedTime = REVERSE_ANIM_INFO.REVERSE_TIME + (REVERSE_ANIM_INFO.TIME_INVERSE_RESOLUTION - REVERSE_ANIM_INFO.REVERSE_TIME % REVERSE_ANIM_INFO.TIME_INVERSE_RESOLUTION)
        end
        for i = 1, fixedTime, REVERSE_ANIM_INFO.TIME_INVERSE_RESOLUTION do
            local rad = math.pi * i / REVERSE_ANIM_INFO.REVERSE_TIME
            local a   = 255 - 255 * i / REVERSE_ANIM_INFO.REVERSE_TIME / (REVERSE_ANIM_INFO.TIME_RATE_UP_TO_TRANSPARENCY / 100.0)
            if REVERSE_ANIM_INFO.IS_REVERSE == 1 then
                rad = -rad
            end
            a = math.max(0, a)
            --それぞれの線について
            local res = REVERSE_ANIM_INFO.IMAGE_INVERSE_RESOLUTION
            if REVERSE_ANIM_INFO.DIRECTION == 0 then -- 横軸に対してひっくり返る
                local nextX, nextY  = perspectiveProjection(square.x, square.centerY + (res - 1 - square.h / 2) * math.cos(rad), (square.h / 2 - res - 1) * math.sin(rad), FOV)
                for line = res, square.h, res do
                    local nextLine = math.min(line + res, square.h)
                    -- それぞれの時間での座標を計算
                    local x, y    = nextX, nextY
                    nextX, nextY  = perspectiveProjection(square.x, square.centerY + (nextLine - square.h / 2) * math.cos(rad), (square.h / 2 - nextLine) * math.sin(rad), FOV)
                    local x2, _ = perspectiveProjection(square.x + square.w, square.centerY + (line - 1 - square.h / 2) * math.cos(rad) + 1, (square.h / 2 - line - 1) * math.sin(rad), FOV)
                    x = math.floor(x + 0.5)
                    y = math.floor(y + 0.5)
                    local h = math.floor(nextY + 0.5) - y
                    table.insert(dst[line].dst, {
                        time = startTime + i + square.deltaTime, x = x, y = y, w = math.floor(x2 - x + 0.5), h = h, a = a
                    })
                end
            else
                local nextX, nextY  = perspectiveProjection(square.centerX + (res - 1 - square.w / 2) * math.cos(rad), square.y, (square.w / 2 - res - 1) * math.sin(rad), FOV)
                for line = res, square.w, res do
                    local nextLine = math.min(line + res, square.w)
                    -- それぞれの時間での座標を計算
                    local x, y    = nextX, nextY
                    nextX, nextY  = perspectiveProjection(square.centerX + (nextLine - square.w / 2) * math.cos(rad), square.y, (square.w / 2 - nextLine) * math.sin(rad), FOV)
                    local _, y2 = perspectiveProjection(square.centerX + (line - 1 - square.w / 2) * math.cos(rad), square.y + square.h, (square.w / 2 - line - 1) * math.sin(rad), FOV)
                    x = math.floor(x + 0.5)
                    y = math.floor(y + 0.5)
                    local w = math.floor(nextX + 0.5) - x
                    table.insert(dst[line].dst, {
                        time = startTime + i + square.deltaTime, x = x, y = y, w = w, h = math.floor(y2 - y + 0.5), a = a
                    })
                end
            end
        end

        for _, d in pairs(dst) do
            table.insert(skin.destination, d)
        end
    end
end

return opening.functions