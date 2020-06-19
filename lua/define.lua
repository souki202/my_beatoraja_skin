
local main_state = require("main_state")

function table.in_key (tbl, key)
    for k, v in pairs (tbl) do
        if k==key then return true end
    end
    return false
end

DEBUG = true

BASE_WIDTH = 1920
BASE_HEIGHT = 1080
WIDTH = 1920
HEIGHT = 1080

NORMAL_TEXT_SIZE = 32
LARGE_TITLE_TEXT_SIZE = NORMAL_TEXT_SIZE * 2
NORMAL_DESCENDER_LINE = 3 -- フォントサイズ64

local isInputStarted = false
local elapsedTime = 0
local lastTime = 0
local deltaTime = -1

function updateTime()
    deltaTime = main_state.time() - lastTime
    lastTime = lastTime + deltaTime
    elapsedTime = elapsedTime + deltaTime
    -- updateDrawNumbers()
end

function getDeltaTime()
    return deltaTime
end

function getElapsedTime()
    return elapsedTime
end

userData = {
    wasLoaded = false,
    filePath = "",
    version = 0,

    rank = {
        maxRank = 999,
        rank = 0,
        exp = 0, -- math.pow(EXSCORE * math.min(1, END_DENSITY), 3 / 4.0)
        tbl = {},
        calcNext = nil, -- function
    },

    stamina = {
        nextHealEpochSecond = 0,
        healInterval = 240, -- 秒
        now = 0,
        tbl = {},
    },
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
    TIMER_START = 15000,

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

function myPrint(...)
    if DEBUG then
        print(...)
    end
end

function createRankAndStaminaTable()
    local sum = 0

    local f1 = function(i) return 20 + (i - 1) * 60 end
    local f2 = function(i) return f1(10) + (i - 10) * 250 end
    local f3 = function(i) return f2(100) + (i - 100) * 150 end
    local f4 = function(i) return f3(300) + (i - 300) * 50 end
    local f5 = function(i) return 70000 end

    for i = 1, userData.rank.maxRank do
        local next = 0
        if i <= 10 then
            next = f1(i)
        elseif i <= 100 then
            next = f2(i)
        elseif i <= 300 then
            next = f3(i)
        elseif i <= 500 then
            next = f4(i)
        else
            next = f5(i)
        end

        -- ランクごとの累計経験値テーブルに入れる
        sum = sum + next
        table.insert(userData.rank.tbl, sum)
        table.insert(userData.stamina.tbl, math.floor(10 + i / 5))
    end
end

function globalInitialize(skin)
    myPrint("プレイヤー名: " .. main_state.text(2))
    userData.filePath = skin_config.get_path("../userdata/data") .. "_" .. main_state.text(2)
    userData.load()
    createRankAndStaminaTable()

    skin.customTimers = {
        {id = 10000, timer = "updateTime"},
        {id = 10001, timer = "updateDrawNumbers"},
    }
end

function getTableValue(tbl, key, defaultValue)
    for k, v in pairs(tbl) do
        if key == k then
            return v
        end
    end
    return defaultValue
end

userData.initData = function()
    local f = io.open(userData.filePath, "w")
    print("Social Skin ユーザ作成")

    -- version
    f:write("1\n")
    -- rank
    f:write("1\n")
    -- total exp
    f:write("0\n")
    -- next heal stamina epoch second
    f:write(string.format("%12d", os.time()) .. "\n")
    -- now stamina
    f:write("10\n")

    f:close()
end

userData.load = function()
    local f = io.open(userData.filePath, "r")
    local cnt = 0

    -- ファイルがなければ新規作成
    if f == nil then
        userData.initData()
        f = io.open(userData.filePath, "r")
    end

    -- ファイルから読み込む
    for line in f:lines() do
        if cnt == 0 then
            userData.version = tonumber(line)
        elseif cnt == 1 then
            userData.rank.rank = tonumber(line)
        elseif cnt == 2 then
            userData.rank.exp = tonumber(line)
        elseif cnt == 3 then
            userData.stamina.nextHealEpochSecond = tonumber(line)
        elseif cnt == 4 then
            userData.stamina.now = tonumber(line)
        end
        cnt = cnt + 1
    end

    print("SocialSkinユーザ情報読み込み完了")
    print("ランク: " .. userData.rank.rank)
    print("累積経験値: " .. userData.rank.exp)
    print("スタミナ回復時刻: ")
    print("スタミナ: " .. userData.stamina.now)
    userData.wasLoaded = true
end

userData.save = function()
    if userData.wasLoaded == false then
        return
    end

    local f = io.open(userData.filePath, "w")

    -- version
    f:write(1 .. "\n")
    -- rank
    f:write(userData.rank.rank .. "\n")
    -- exp
    f:write(userData.rank.exp .. "\n")
    -- next heal stamina epoch second
    f:write(userData.stamina.nextHealEpochSecond .. "\n")
    -- now stamina
    f:write(userData.stamina.now .. "\n")

    f:close()

    print("ユーザ情報保存完了")
end

userData.rank.getSumExp = function(rank)
    if rank == 0 then
        return 0
    end

    -- 最大ランクは最大値
    if userData.rank.maxRank <= rank then
        return userData.rank.tbl[userData.rank.maxRank]
    end
    return userData.rank.tbl[rank]
end

userData.rank.calcNext = function(rank, exp)
    -- 最大ランクはnext無し
    if userData.rank.maxRank <= rank then
        return nil
    end

    return userData.rank.tbl[rank] - exp
end

-- 経験値を加算し, ランクをそれにあわせる
-- 後でuserData.save()を忘れずに
-- @param  int exp 獲得経験値
userData.addExp = function(exp)
    if exp < 0 then return end

    userData.rank.exp = userData.rank.exp + exp
    for i = 1, userData.rank.maxRank do
        if userData.rank.tbl[i] > userData.rank.exp then
            print("経験値追加 rank:" .. i .. " exp: " .. userData.rank.exp)
            userData.rank.rank = i
            return
        elseif i >= userData.rank.rank then -- ランクアップしたらスタミナ回復
            userData.stamina.now = userData.stamina.now + userData.stamina.tbl[i]
        end
    end
end

userData.calcUseStamina = function(totalNotes)
    return math.ceil(math.pow(totalNotes, 0.5) / 5)
end

userData.getNextHealStaminaDateString = function()
    return os.date("%Y-%m-%d %H:%M:%S", userData.stamina.nextHealEpochSecond)
end

userData.getIsMaxStamina = function()
    return userData.stamina.now >= userData.stamina.tbl[userData.rank.rank]
end

userData.getIsUsableStamina = function(useValue)
    return userData.stamina.now >= useValue
end

userData.useStamina = function(useValue)
    if userData.getIsUsableStamina(useValue) == false then
        print("スタミナが不足しています 現在値: " .. userData.stamina.now .. " 消費量: " .. useValue)
    end
    myPrint("スタミナ減少量: " .. useValue)
    userData.stamina.now = userData.stamina.now - useValue
    myPrint("スタミナ量更新: " .. userData.stamina.now)
end

-- スタミナ回復までの残り時間を取得する
-- @return int, int 分と秒
userData.getNextHealStaminaRemainTime = function()
    -- 回復できなければ終了
    if userData.getIsMaxStamina() then return 0, 0 end

    local t = os.time()
    -- 何故か浮動小数点になる
    local remain = math.floor(userData.stamina.nextHealEpochSecond - t)
    -- 回復しているはず
    if remain < 0 then return 0, 0 end
    return math.floor(remain / 60), remain % 60
end

userData.updateRemainingStamina = function()
    local t = os.time()
    -- スタミナ最大なら回復しない
    if userData.getIsMaxStamina() then
        userData.stamina.nextHealEpochSecond = t + userData.stamina.healInterval
        return
    end

    local excess = t - userData.stamina.nextHealEpochSecond
    if excess > 0 then
        myPrint("スタミナ回復")
        local healValue = math.ceil(excess / userData.stamina.healInterval)
        myPrint("スタミナ回復: " .. healValue)
        userData.stamina.nextHealEpochSecond = userData.stamina.nextHealEpochSecond + healValue * userData.stamina.healInterval
        myPrint("あまり")
        userData.stamina.now = math.min(userData.stamina.now + healValue, userData.stamina.tbl[userData.rank.rank])
        myPrint("次の回復: " .. userData.getNextHealStaminaDateString())
        userData.save()
    end
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
    myPrint((suffix and "符号あり" or "符号なし"))
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

local function preDrawNumbersCommon(idPrefix, dstId, align, drawBackZero, startTimerId)
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
    local startTimerId = getNextNumberTimerId()

    preDrawNumbersCommon(idPrefix, dstId, align, drawBackZero, startTimerId)

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
function preDrawStaticNumbers(skin, idPrefix, dstId, align, drawBackZero, baseDst, drawValue, op, timer, loop)
    local timerId = getNextNumberTimerId()

    preDrawNumbersCommon(idPrefix, dstId, align, drawBackZero, timerId)

    myNumber.isStatic[dstId] = true
    myNumber.values[dstId] = createSuffixIndexArray(drawValue, align, myNumber.drawBackZero[dstId], myNumber.drawSign[dstId])

    if timer ~= -1 then
        timerId = timer
    end

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
                main_state.set_timer(timer, elapsedTime)
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
                    main_state.set_timer(startTimer + (i - 1), elapsedTime - suffixIndex * 1000000 - 5000)
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

    if DEBUG then
        local s = myNumber.values[dstId][1]
        for i = 2, myNumber.MAX_DIGIT do
            s = s .. "," .. myNumber.values[dstId][i]
        end
        -- myPrint("描画配列: " .. s)
    end
end

-- 指定したdstIdの表示非表示を切り替える. timerを指定した静的な値は変更できない
function switchVisibleNumber(dstId, isVisible)
    if myNumber.isVisible[dstId] == isVisible then return end

    myNumber.isVisible[dstId] = isVisible
    myPrint("Visible変更 dstId: " .. dstId .. " 変更後状態: " .. (isVisible and "表示" or "非表示"))
    if isVisible == false then
        local startTimer = myNumber.timerIds[dstId]
        for i = 1, myNumber.MAX_DIGIT do
            main_state.set_timer(startTimer + (i - 1), main_state.timer_off_value)
        end
    end
end