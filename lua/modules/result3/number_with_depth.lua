require("modules.commons.my_print")
require("modules.result3.commons")
local main_state = require("main_state")

local NUM_TYPES = {
    NUMBER = 1,
    FILL_ZERO = 2,
    WITH_SIGN = 3,
    FILL_ZERO_WITH_SIGN = 4,
}

local ALIGN = {
    LEFT = 1,
    RIGHT = 0,
    CENTER = 2,
}

local IMG_IDX = {
    -- 1 ~ 10は数値. idx=1は数字の0, idx=10は数字の9
    FILL_ZERO = 11,
    SIGN = 12,
}

local VAL_ARY_IDX = {
    -- 0 ~ 9は数値
    FILL_ZERO = 11,
    SIGN_PLUS = 12,
    SIGN_MINUS = 13,
    NONE = 14,
}

local MINUS_SUFFIX = "_m"

local MIN_VALUE = -2147483648

-- 整数の桁数を計算 (符号は含まない)
local function getDigit(val)
    if val == 0 then -- log(0, 10) == -inf のため分離
        return 1
    end
    local d = 0
    while val >= 1 do
        val = val / 10
        d = d + 1
    end
    return d
end

-- 下からtarget桁目の数値を取得する
local function getNumOfSpecificDigit(val, target)
    val = math.abs(val)
    return math.floor((val % (10 ^ target)) / (10 ^ (target - 1)))
end

local function getIsFillZero(numType)
    return numType == NUM_TYPES.FILL_ZERO or numType == NUM_TYPES.FILL_ZERO_WITH_SIGN
end

local function getIsWithSign(numType)
    return numType == NUM_TYPES.WITH_SIGN or numType == NUM_TYPES.FILL_ZERO_WITH_SIGN
end

local timerIdx = CUSTOM_TIMERS_RESULT3.EXSCORE_GETNUM_TIMER_START

return {
    -- @param {10 | 11 | 12} divx 画像の横分割数 11は0埋め対応, 12は0埋め対応かつ符号付き
    -- @param {number[]} dxs 上位2桁目~maxDigit桁目までの, 1桁目に対するx座標のずれ
    -- @param {number[]} dys 上位2桁目~maxDigit桁目までの, 1桁目に対するy座標のずれ
    -- @param {number} isFillZero 0埋めするかどうか. divxが10の場合は必ずfalse扱い
    create = function (imgId, srcId, w, h, divx, maxDigit, ref, dxs, dys, align, isFillZero)
        local numType = NUM_TYPES.NUMBER
        local thisTimer = timerIdx
        local oldVal = 0
        local val = MIN_VALUE
        local valAry = {}

        timerIdx = timerIdx + 1

        if divx ~= 10 and divx ~= 11 and divx ~= 12 then
            myPrint("divxは10, 11, 24のいずれかです")
        end

        if align == ALIGN.CENTER then
            myPrint("align=centerは現在非対応です")
            align = ALIGN.RIGHT
        end

        -- 数値の描画種類を取得
        do
            if divx == 11 then
                numType = NUM_TYPES.FILL_ZERO
                if not isFillZero then
                    numType = NUM_TYPES.NUMBER
                end
            elseif divx == 12 then
                numType = NUM_TYPES.WITH_SIGN
                if isFillZero then
                    numType = NUM_TYPES.FILL_ZERO_WITH_SIGN
                end
            end
        end

        if #dxs > maxDigit - 1 then
            myPrint("x座標ずれの数と桁数が一致していません. digitZoom: " + #dxs + " maxDigit: " + maxDigit)
        end

        if #dys > maxDigit - 1 then
            myPrint("y座標ずれの数と桁数が一致していません. digitZoom: " + #dys + " maxDigit: " + maxDigit)
        end

        -- その数値に対応するimg idを取得
        -- @param {1 | -1} sign 正数なら1, 負数なら-1
        local function getId(value, digit, sign)
            local id = imgId .. "_" .. (value + 1) .. "_" .. digit
            if sign == -1 then
                id = id + MINUS_SUFFIX
            end
            return id
        end

        local function fillValueAry()
            -- 数値に差がなければ何もしない
            if val == oldVal then
                return
            end

            oldVal = val
            -- 初期化
            local actualDigit = getDigit(val)
            local emptyValue = getIsFillZero(numType) and VAL_ARY_IDX.FILL_ZERO or VAL_ARY_IDX.NONE

            for i = 1, maxDigit do
                valAry[i] = emptyValue
            end

            -- 無効な数値の場合はすべて空で終了
            if val == MIN_VALUE then
                return
            end

            -- 符号をつけるかどうか
            local isViewSign = false
            local sign = 0
            if actualDigit < maxDigit and getIsWithSign(numType) then
               isViewSign = true
               if val < 0 then
                    sign = VAL_ARY_IDX.SIGN_MINUS
                else
                    sign = VAL_ARY_IDX.SIGN_PLUS
                end
            end

            -- 符号を取得したので, 負数は正数に修正
            val = math.abs(val)

            -- 数値埋め
            -- 左詰め. 上の桁から入れていく
            if align == ALIGN.LEFT then
                if isViewSign then
                    valAry[1] = sign
                end
                for i = 1, actualDigit do
                    local n = getNumOfSpecificDigit(val, actualDigit - i + 1)
                    -- 数値を入れるインデックスは, 1桁目が符号ならずれる
                    local vi = isViewSign and i + 1 or i
                    valAry[vi] = n
                end
            elseif align == ALIGN.RIGHT then
                if isViewSign then
                    valAry[maxDigit - actualDigit - 1] = sign
                end
                for i = 1, actualDigit do
                    local n = getNumOfSpecificDigit(val, i)
                    -- 下の桁から埋める
                    local vi = maxDigit - i + 1
                    valAry[vi] = n
                end
            end
            print("val: " .. val .. " ref:" .. ref .. " actualDigit: " .. actualDigit)
            for i = 1, maxDigit, 1 do
                print(valAry[i] .. " ref:" .. ref)
            end
        end
        fillValueAry()

        return {
            load = function ()
                local skin = {
                    image = {}
                }
                local imgs = skin.image
                local y = 0
                for i = 1, maxDigit do
                    for j = 1, divx do
                        imgs[#imgs+1] = {
                            id = getId(j, i, 1), src = srcId,
                            x = (j - 1) * w, y = y, w = w, h = h
                        }
                        -- 符号付きの場合は, 正の値の次の行にある
                        if getIsWithSign(numType) then
                            y = y + h
                            imgs[#imgs+1] = {
                                id = getId(j, i, -1), src = srcId,
                                x = (j - 1) * w, y = y, w = w, h = h
                            }
                        end
                    end
                    -- 符号付きかどうかで移動量が変わるので, xと違ってここで加算する
                    y = y + h
                end

                return skin
            end,

            -- @param {number} x 最も左の描画座標
            -- @param {number} y 最上位の桁の描画座標
            dst = function (x, y)
                local skin = {
                    customTimers = {},
                    destination = {}
                }

                if type(ref) == "function" then
                    skin.customTimers = {
                        {id = thisTimer, timer = function ()
                            val = ref()
                            fillValueAry()
                        end}
                    }
                else
                    skin.customTimers = {
                        {id = thisTimer, timer = function ()
                            val = main_state.number(ref)
                            fillValueAry()
                        end}
                    }
                end

                local dst = skin.destination

                -- @param {IMG_IDX} idx
                -- @param {number} digit 表示しようとしている桁
                -- @param {1 | -1} sign 正数なら1, 負数なら-1
                local function getIsDraw(idx, digit, sign)
                    if val < 0 and sign == 1 then -- 表示しようとしている符号の数値と実際の符号があっていない場合
                        return false
                    elseif val >= 0 and sign == -1 then
                        return false
                    elseif sign == -1 and not getIsWithSign(numType) then
                        -- 負数非対応の場合に負数の画像を表示しようとしている場合
                        return false
                    end

                    local v = valAry[digit]

                    -- 数値の表示
                    if v <= 9 then
                        return v == idx - 1
                    end
                    -- ゼロ埋めの表示
                    if v == VAL_ARY_IDX.FILL_ZERO then
                        return v == idx
                    end
                    -- 符号の表示
                    if v == VAL_ARY_IDX.SIGN_PLUS then
                        return idx == IMG_IDX.SIGN and sign == 1
                    end
                    if v == VAL_ARY_IDX.SIGN_MINUS then
                        return idx == IMG_IDX.SIGN and sign == -1
                    end
                    return false
                end

                -- 各桁の描画(上から設定)
                local nowX = x
                local nowY = y
                for i = 1, maxDigit do
                    for j = 1, divx do
                        dst[#dst+1] = {
                            id = getId(j, i, 1), draw = function ()
                                return getIsDraw(j, i, 1)
                            end, dst = {
                                {x = nowX, y = nowY, w = w, h = h}
                            }
                        }
                        if getIsWithSign(numType) then
                            dst[#dst+1] = {
                                id = getId(j, i, -1), draw = function ()
                                    return getIsDraw(j, i, -1)
                                end, dst = {
                                    {x = nowX, y = nowY, w = w, h = h}
                                }
                            }
                        end
                    end
                    if i <= #dxs then
                        nowX = x + dxs[i]
                        nowY = y + dys[i]
                    end
                end

                return skin
            end
        }
    end
}