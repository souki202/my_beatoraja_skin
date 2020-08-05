local main_state = require("main_state")
require("modules.commons.timer")

NUMBERS_24PX = {
    W = 14,
    H = 18,
    ID = "24pxNumbers",
}

NUMBERS_18PX = {
    SRC_X = 1928,
    SRC_Y = 183,
    W = 10,
    H = 13,
}

NUMBERS_14PX = {
    W = 8,
    H = 10,
    SRC_X = 1952,
    SRC_Y = 94,
}

-- 自作の任意の数値を表示させるための色々
-- 力技なので重い上に複雑です
local myNumber = {
    SUFFIX = {
        "p0", "p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9", "pb0", "p",
        "m0", "m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "mb0", "m",
    },
    MAX_DIGIT = 10, -- 1つは符号なので数値は9桁
    INVALID_VALUE = 10000000000,
    -- TIMER_START = 11000, --14200はセーフ, 14300はクラッシュ
    TIMER_START = 19000,

    didInitStaticNumberTimer = false,

    -- idPrefix毎
    signData = {},
    hasBackZero = {},

    -- dstId毎 リファクタリングするかも
    values = {}, -- 各[dstId]について, suffixのindexがMAX_DIGIT個並ぶ
    timerIds = {},
    aligns = {},
    drawBackZero = {},
    drawSign = {},
    backZeroDigit = {},
    isVisible = {},
    isStatic = {},
}

-- xは右端の座標
function dstNumberRightJustify(skin, id, x, y, w, h, digit)
    table.insert(skin.destination, {
        id = id, dst = {
            {
                x = x - w * digit,
                y = y,
                w = w, h = h
            }
        }
    })
end

-- xは右端の座標
function dstNumberRightJustifyWithDrawFunc(skin, id, x, y, w, h, digit, draw)
    table.insert(skin.destination, {
        id = id, draw = draw, dst = {
            {
                x = x - w * digit,
                y = y,
                w = w, h = h
            }
        }
    })
end

function dstNumberRightJustifyWithColor(skin, id, x, y, w, h, digit, r, g, b)
    table.insert(skin.destination, {
        id = id, dst = {
            {
                x = x - w * digit,
                y = y,
                w = w, h = h,
                r = r, g = g, b = b,
            }
        }
    })
end

function dstNumberRightJustifyByDst(skin, id, op, timer, loop, baseSst, digit)
    local dst = {}
    local function copyDst(t)
        local t2 = {}
        for k,v in pairs(t) do
          t2[k] = v
        end
        return t2
    end

    local lastW = 0
    for i, value in pairs(baseSst) do
        local newDst = copyDst(value)
        if table.in_key(newDst, "w") then
            lastW = newDst["w"]
        end
        if table.in_key(newDst, "x") then
            newDst["x"] = newDst["x"] - lastW * digit
        end
        dst[#dst + 1] = newDst
    end
    table.insert(skin.destination, {
        id = id, op = op, timer = timer, loop = loop, dst = dst
    })
end

-- 数字の画像を読み込む
-- @param  skin
-- @param  idPrefix 描画用数字フォントのidPrefix
-- @param  srcNumber skin.imageのsrc
-- @param  srcX
-- @param  srcY
-- @param  w 数字全体の幅
-- @param  h 数字全体の高さ
-- @param  divX wの分割数
-- @param  divY hの分割数
function loadNumbers(skin, idPrefix, srcNumber, srcX, srcY, w, h, divX, divY)
    local d = divX * divY
    local signed = d == 24
    local suffix = myNumber.SUFFIX

    myPrint("数字読み込み開始 " .. idPrefix)
    myPrint((signed and "符号あり" or "符号なし"))
    myPrint((d ~= 10 and "裏0あり" or "裏0なし"))

    if w % divX ~= 0 or h % divY ~= 0 then
        print("幅と高さは, 各分割数で割り切れる値にしてください.")
        return
    end

    myNumber.signData[idPrefix] = signed
    myNumber.hasBackZero[idPrefix] = d ~= 10

    for i = 1, d do
        table.insert(skin.image, {
            id = idPrefix .. suffix[i], src = srcNumber,
            x = srcX + ((i - 1) % divX) * w / divX, y = srcY - math.floor((i - 1) / divX) * h / divY,
            w = w / divX, h = h / divY
        })
    end
    for i = d + 1, 24 do -- ID無しでバグらないようにとりあえず入れておく
        table.insert(skin.image, {
            id = idPrefix .. suffix[i], src = srcNumber,
            x = 0, y = 0, w = 1, h = 1
        })
    end
end

local function preDrawNumbersCommon(skin, idPrefix, dstId, align, drawBackZero, startTimerId)
    -- とりあえず突っ込んでおく
    myNumber.values[dstId] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    myNumber.aligns[dstId] = align
    myNumber.drawSign[dstId] = myNumber.signData[idPrefix]

    if myNumber.hasBackZero[idPrefix] == false and drawBackZero == true then
        myPrint("srcに裏0が定義されていないため, 裏0描画設定は強制的にfalseになります.")
        drawBackZero = false
    end

    myNumber.drawBackZero[dstId] = drawBackZero
    myNumber.timerIds[dstId] = startTimerId
end

local function getNextNumberTimerId()
    local startTimerId = myNumber.TIMER_START
        for _, value in pairs(myNumber.timerIds) do
            startTimerId = math.max(startTimerId, value + myNumber.MAX_DIGIT)
        end
    return startTimerId
end

-- 各桁のmyNumber.SUFFIXに対応するインデックスリストを作成する
-- @return array インデックスのリスト
local function createSuffixIndexArray(value, align, drawBackZero, drawSign)
    local numbers = {}
    local wasSetSign = false
    -- 各桁の値を下から取得していく
    for i = 1, myNumber.MAX_DIGIT do
        local v = math.floor((value % math.pow(10, i)) / math.pow(10, i - 1))
        if value >= math.pow(10, i - 1) or (value == 0 and i == 1) then
            local suffixIndex = v + 1
            if drawSign and value < 0 then
                suffixIndex = v + 12
            end
            table.insert(numbers, 1, suffixIndex)
        else
            -- 桁が入っている数値を超えた場合
            if (drawBackZero == false or drawBackZero and i ~= myNumber.MAX_DIGIT) and wasSetSign == false and drawSign then
                -- 符号描画
                if value < 0 then
                    table.insert(numbers, 1, 24)
                else
                    table.insert(numbers, 1, 12)
                end
                wasSetSign = true
            else
                if align == 0 then
                    table.insert(numbers, 1, 0)
                elseif align == 1 then
                    table.insert(numbers, 0)
                end
            end
        end
    end
    return numbers
end



-- 各出力について, 出力の準備を行う
-- 値更新の都合でstaticよりはるかに重いのでできるだけ使わないように
-- @param  skin
-- @param  idPrefix 読み込み時に指定した描画用数字フォントのidPrefix
-- @param  dstId 出力用の識別文字 何でも良い
-- @param  x align 0の場合描画の右端, 1の場合左端
-- @param  y
-- @param  w 数字1つの幅
-- @param  h 数字1つの高さ
-- @param  align 0右寄せ 1左寄せ
-- @param  drawBackZero 裏0を表示するかどうか
-- @param  op
function preDrawDynamicNumbers(skin, idPrefix, dstId, x, y, w, h, align, drawBackZero, op)
    myPrint("数字出力準備: ", idPrefix, dstId, x, y, w, h, align, drawBackZero)

    local startTimerId = getNextNumberTimerId()
    myPrint("タイマー開始値: " .. startTimerId)

    preDrawNumbersCommon(skin, idPrefix, dstId, align, drawBackZero, startTimerId)

    local offsetX = align == 0 and -w or 0
    myNumber.isStatic[dstId] = false

    -- 描画用数値を定義する 上の桁から
    for i = 1, myNumber.MAX_DIGIT do
        local m = 10
        local timer = startTimerId + (i - 1)
        if myNumber.hasBackZero[idPrefix] then
            m = 11
        end
        if myNumber.signData[idPrefix] then
            m = 24
        end
        table.insert(skin.customTimers, {
            id = timer
        })
        for v = 1, m do
            local x2 = x - (myNumber.MAX_DIGIT - i) * w + offsetX
            if align == 1 then -- 左揃えの場合
                x2 = x + (i - 1) * w + offsetX
            end
            table.insert(skin.destination, {
                id = idPrefix .. myNumber.SUFFIX[v], timer = timer, op = op, loop = -1, dst = {
                    {time = 0, x = x2, y = y, w = w, h = h, a = 0, acc = 3},
                    {time = v * 1000, a = 255}, -- 1ms単位だとたまにちらつくので10倍 5fpsでも2500fpsでも正常に動いたので多分大丈夫
                    {time = (v + 1) * 1000, a = 0}, -- 内部処理が遅すぎると怪しいかも
                }
            })
        end
    end
end

-- 各出力について, 出力の準備を行う
-- @param  skin
-- @param  idPrefix 読み込み時に指定した描画用数字フォントのidPrefix
-- @param  dstId 出力用の識別文字 何でも良い
-- @param  align 0右寄せ 1左寄せ
-- @param  drawBackZero 裏0を表示するかどうか
-- @param  baseDst 数値描画の基準座標におけるdstの中身. それぞれで, xが定義されていれば各桁に適した座標に修正する. 他はそのまま
-- @param  drawValue 表示する値
-- @param  op
-- @param  timer 使用するタイマー -1場合は独自の表示の切り替えができるタイマー
-- @param  loop
-- @param  complession 何px幅を詰めるか
function preDrawStaticNumbers(skin, idPrefix, dstId, align, drawBackZero, baseDst, drawValue, op, timer, loop, complession)
    myPrint("数字出力準備: ", idPrefix, dstId, align, drawBackZero, baseDst, drawValue)
    local timerId = getNextNumberTimerId()

    preDrawNumbersCommon(skin, idPrefix, dstId, align, drawBackZero, timerId)

    myNumber.isStatic[dstId] = true
    myNumber.values[dstId] = createSuffixIndexArray(drawValue, align, myNumber.drawBackZero[dstId], myNumber.drawSign[dstId])

    if timer ~= -1 then
        timerId = timer
    end
    myPrint("タイマー値: " .. timerId)

    local function copyDst(t)
        local t2 = {}
        for k,v in pairs(t) do
          t2[k] = v
        end
        return t2
    end

    local function offsetX(w)
        return align == 0 and -w or 0
    end

    -- 上の桁からdst定義
    local newestW = 0
    for i = 1, myNumber.MAX_DIGIT do
        local dst = {}
        for _, value in pairs(baseDst) do
            -- 元の入ってきたものを破壊しないように複製
            local newDst = copyDst(value)

            if table.in_key(newDst, "w") then
                newestW = newDst["w"]
            end

            if table.in_key(newDst, "x") then
                local newX = newDst["x"] - (myNumber.MAX_DIGIT - i) * newestW + offsetX(newestW)
                if align == 1 then -- 左揃えの場合
                    newX = newDst["x"] + (i - 1) * newestW + offsetX(newestW)
                end
                newDst["x"] = newX
            end
            table.insert(dst, newDst)
        end
        if myNumber.values[dstId][i] > 0 then
            table.insert(skin.destination, {
                id = idPrefix .. myNumber.SUFFIX[myNumber.values[dstId][i]],
                op = op, timer = timerId, loop = loop, dst = dst
            })
        end
    end
end

function updateDrawNumbers()
    if myNumber.didInitStaticNumberTimer == false then
        for dstId, timer in pairs(myNumber.timerIds) do
            if myNumber.isStatic[dstId] == true then
                main_state.set_timer(timer, getElapsedTime())
            end
        end
    end

    for dstId, startTimer in pairs(myNumber.timerIds) do
        -- 描画する数値の変更のため, hidden状態と静的な値は更新しない
        if myNumber.isVisible[dstId] == true and myNumber.isStatic[dstId] == false then
            -- 各桁について
            for i = 1, myNumber.MAX_DIGIT do
                local suffixIndex = myNumber.values[dstId][i]
                if suffixIndex > 0 then
                    main_state.set_timer(startTimer + (i - 1), getElapsedTime() - suffixIndex * 1000000 - 5000)
                else
                    -- index 0は描画無し
                    main_state.set_timer(startTimer + (i - 1), main_state.timer_off_value)
                end
            end
        end
    end
end

function calcValueDigit(value, withSign)
    local v = math.abs(value)
    for i = 1, myNumber.MAX_DIGIT do
        if value < math.pow(10, i) then
            return withSign and i + 1 or i
        end
    end
end

function setValue(dstId, value)
    local align = myNumber.aligns[dstId]

    -- myPrint("値セット: " .. dstId .. " " .. value)

    myNumber.values[dstId] = createSuffixIndexArray(value, align, myNumber.drawBackZero[dstId], myNumber.drawSign[dstId])
    myNumber.isVisible[dstId] = true

    -- if DEBUG then
    --     local s = myNumber.values[dstId][1]
    --     for i = 2, myNumber.MAX_DIGIT do
    --         s = s .. "," .. myNumber.values[dstId][i]
    --     end
    --     myPrint("描画配列: " .. s)
    -- end
end

-- 指定したdstIdの表示非表示を切り替える. timerを指定した静的な値は変更できない
function switchVisibleNumber(dstId, isVisible)
    if myNumber.isVisible[dstId] == isVisible then return end

    myNumber.isVisible[dstId] = isVisible
    myPrint("Visible変更 dstId: " .. dstId .. " 変更後状態: " .. (isVisible and "表示" or "非表示"))
    if isVisible == false then
        local startTimer = myNumber.timerIds[dstId]
        if startTimer ~= nil then
            for i = 1, myNumber.MAX_DIGIT do
                main_state.set_timer(startTimer + (i - 1), main_state.timer_off_value)
            end
        else
            print("startTimerがありません 未登録のdstIdの可能性があります: " .. dstId)
        end
    end
end

function getTimerStart()
    return myNumber.TIMER_START
end

function getMaxDigit()
    return myNumber.MAX_DIGIT
end