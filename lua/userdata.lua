local main_state = require("main_state")

userData = {
    name = "",
    escapedName = "",
    wasLoaded = false,
    filePath = "",
    backupPath = "",
    version = 0,

    rank = {
        maxRank = 999,
        rank = 1,
        exp = 0, -- math.pow(EXSCORE * math.min(1, END_DENSITY), 3 / 4.0)
        tbl = {},
        calcNext = nil, -- function
    },

    stamina = {
        nextHealEpochSecond = 0,
        healInterval = 240, -- 秒
        now = 10,
        tbl = {},
    },

    tokens = {
        coin = 0,
        dia = 0,
    },

    isSuccessedInitial = true,
    nextVersionCheckDate = 0
}

function createRankAndStaminaTable()
    local sum = 0
    local sumStamina = 9

    local f1 = function(i) return 20 + (i - 1) * 60 end
    local f2 = function(i) return f1(10) + (i - 10) * 250 end
    local f3 = function(i) return f2(100) + (i - 100) * 350 end
    local f4 = function(i) return f3(300) + (i - 300) * 400 end
    local f5 = function(i) return 250000 end

    for i = 1, userData.rank.maxRank do
        local next = 0
        if i <= 10 then
            next = f1(i)
            sumStamina = sumStamina + 1
        elseif i <= 100 then
            next = f2(i)
            sumStamina = sumStamina + 0.6
        elseif i <= 300 then
            next = f3(i)
            sumStamina = sumStamina + 0.3
        elseif i < 500 then
            next = f4(i)
        else
            next = f5(i)
        end

        -- ランクごとの累計経験値テーブルに入れる
        sum = sum + next
        table.insert(userData.rank.tbl, sum)
        table.insert(userData.stamina.tbl, math.floor(sumStamina))
    end
end

-- ユーザデータIO周り
userData.initData = function()
    local f = io.open(userData.filePath, "w")
    if f == nil then
        print("ユーザデータの新規作成に失敗しました: " .. userData.filePath)
        userData.isSuccessedInitial = false
        return
    end
    print("Social Skin ユーザ作成")

    userData.writeUserData(f)
    f:close()
end

userData.load = function()
    -- 初期値入れておく
    userData.tokens.coin = main_state.number(33)
    userData.tokens.dia = main_state.number(30)
    myPrint("コイン: " .. userData.tokens.coin, "ダイヤ: " .. userData.tokens.dia)

    local f = io.open(userData.filePath, "r")

    -- ファイルがなければ新規作成
    if f == nil then
        userData.initData()
        f = io.open(userData.filePath, "r")
    end

    if userData.isSuccessedInitial == false or f == nil then
        print("ユーザデータの読み込みに失敗しました: " .. userData.filePath)
        return
    end

    -- ファイルから読み込む
    local cnt = 0
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
        elseif cnt == 5 then
            userData.nextVersionCheckDate = tonumber(line)
        elseif cnt == 6 then
            userData.tokens.coin = tonumber(line)
        elseif cnt == 7 then
            userData.tokens.dia = tonumber(line)
        end
        cnt = cnt + 1
    end

    print("SocialSkin統計情報読み込み完了")
    print("ランク: " .. userData.rank.rank)
    print("累積経験値: " .. userData.rank.exp)
    print("スタミナ回復時刻: ")
    print("スタミナ: " .. userData.stamina.now)
    userData.wasLoaded = true
end


userData.writeUserData = function(fileHandle)
    if fileHandle == nil then
        print("ファイルオープンに失敗しました: " .. "userData.writeUserData", userData.filePath)
        return
    end
    -- version
    fileHandle:write(1 .. "\n")
    -- rank
    fileHandle:write(userData.rank.rank .. "\n")
    -- exp
    fileHandle:write(userData.rank.exp .. "\n")
    -- next heal stamina epoch second
    fileHandle:write(string.format("%10d", userData.stamina.nextHealEpochSecond) .. "\n")
    -- now stamina
    fileHandle:write(userData.stamina.now .. "\n")
    -- バージョン確認日
    fileHandle:write(string.format("%10d", userData.nextVersionCheckDate) .. "\n")
    -- コイン
    fileHandle:write(string.format("%11d", userData.tokens.coin) .. "\n")
    -- ダイヤ
    fileHandle:write(userData.tokens.dia .. "\n")

end

userData.save = function()
    if userData.wasLoaded == false then
        return
    end

    local f = io.open(userData.filePath, "w")
    userData.writeUserData(f)
    f:close()
    f = io.open(userData.backupPath, "w")
    userData.writeUserData(f)
    f:close()

    print("統計情報保存処理終了")
end

userData.rank.getSumExp = function(rank)
    if rank <= 0 then
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
        userData.stamina.now = math.min(userData.stamina.now + healValue, userData.stamina.tbl[userData.rank.rank])
        myPrint("次の回復: " .. userData.getNextHealStaminaDateString())
        pcall(userData.save)
    end
end

userData.updateNextVersionCheckDate = function()
    -- 1週間後
    userData.nextVersionCheckDate = os.time() + 60*60*24*7
    userData.save()
end