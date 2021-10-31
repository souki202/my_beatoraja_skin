--[[
    一部のモジュールはSocialSkinのresultと共有
]]

require("modules.result.commons")
local main_state = require("main_state")
local background = require("modules.result.background")
local fade = require("modules.result.fade")

local scoreDetail = require("modules.result3.detail")

local resultObtained = require("modules.result.result_obtained")

local INPUT_WAIT = 500 -- シーン開始から入力受付までの時間

local RANK_DIR_LIST = {"aaa", "aa", "a", "b", "c", "d", "e", "f"}
local LAMP_DIR_LIST = {"failed", "aeasy", "laeasy", "easy", "normal", "hard", "exhard", "fullcombo", "perfect"}
local LAMP_DIR_NAME_LIST = {"FAILED", "ASSIST EASY", "LASSIST EASY", "EASY", "NORMAL", "HARD", "EXHARD", "FULLCOMBO", "PERFECT"}

local isCourseResult = false
local function setIsCourseResult(b)
    isCourseResult = b
end

local function setProperties(skin)
    table.insert(skin.property, {
        name = "各種グラフ グルーヴゲージ部分", item = {{name = "ノーツ数分布", op = 945}, {name = "判定分布", op = 946}, {name = "EARLY/LATE分布(棒グラフ)", op = 947}, {name = "無し", op = 949}}, def = "ノーツ数分布"
    })

    if isCourseResult then
        table.insert(skin.property, {
            name = "各種グラフ ステージファイル部分", item = {{name = "ノーツ数分布", op = 930}, {name = "判定分布", op = 931}, {name = "EARLY/LATE分布(棒グラフ)", op = 932}}, def = "ノーツ数分布"
        })
        table.insert(skin.property, {
            name = "各種グラフ 詳細画面1個目", item = {{name = "ノーツ数分布", op = 935}, {name = "判定分布", op = 936}, {name = "EARLY/LATE分布(棒グラフ)", op = 937}}, def = "判定分布"
        })
        table.insert(skin.property, {
            name = "各種グラフ 詳細画面2個目", item = {{name = "ノーツ数分布", op = 940}, {name = "判定分布", op = 941}, {name = "EARLY/LATE分布(棒グラフ)", op = 942}}, def = "EARLY/LATE分布(棒グラフ)"
        })
    else
        table.insert(skin.property, {
            name = "各種グラフ ステージファイル部分", item = {{name = "ノーツ数分布", op = 930}, {name = "判定分布", op = 931}, {name = "EARLY/LATE分布(棒グラフ)", op = 932}, {name = "タイミング可視化グラフ", op = 933}}, def = "判定分布"
        })
        table.insert(skin.property, {
            name = "各種グラフ 詳細画面1個目", item = {{name = "ノーツ数分布", op = 935}, {name = "判定分布", op = 936}, {name = "EARLY/LATE分布(棒グラフ)", op = 937}, {name = "タイミング可視化グラフ", op = 938}}, def = "EARLY/LATE分布(棒グラフ)"
        })
        table.insert(skin.property, {
            name = "各種グラフ 詳細画面2個目", item = {{name = "ノーツ数分布", op = 940}, {name = "判定分布", op = 941}, {name = "EARLY/LATE分布(棒グラフ)", op = 942}, {name = "タイミング可視化グラフ", op = 943}}, def = "タイミング可視化グラフ"
        })
    end
end

local function makeHeader()
    local header = {
        type = 7,
        name = "Space Ship" .. (DEBUG and " dev result" or ""),
        w = WIDTH,
        h = HEIGHT,
        fadeout = fade.getFadeOutTime(),
        scene = 3600000,
        input = INPUT_WAIT,
        -- 910, 920, 930, 935, 940, 945, 965, 975, 980, 985, 990
        property = {
            {
                name = "背景の分類", item = {{name = "クリアかどうか", op = 910}, {name = "ランク毎", op = 911}, {name = "クリアランプ毎", op = 912}}, def = "クリアかどうか"
            },
            -- {
            --     name = "スコア位置", item = {{name = "左", op = 920}, {name = "右", op = 921}}, def = "左"
            -- },
            -- {
            --     name = "ステージファイル部分の初期表示", item = {{name = "ステージファイル", op = 915}, {name = "グルーブゲージ", op = 916}, {name = "スコアグラフ", op = 917}}, def = "ステージファイル"
            -- },
            {
                name = "スコアグラフ(プレイスキン併用時のみ)", item = {{name = "累積スコア", op = 965}, {name = "一定区間のレート", op = 966}}, def = "一定区間のレート"
            },
            {
                name = "スコアグラフ平滑化", item = {{name = "無し", op = 970}, {name = "単純移動平均(SMA)", op = 971}, {name = "指数移動平均(EMA)", op = 972}, {name = "平滑移動平均(SMMA)", op = 973}, {name = "線形加重移動平均(LWMA)", op = 974}}, def = "無し"
            },
            {
                name = "ランキングの自分の名前表記", item = {{name = "プレイヤー名", op = 975}, {name = "YOU", op = 976}}, def = "プレイヤー名"
            },
            {
                name = "日時表示", item = {{name = "無し", op = 985}, {name = "日付のみ", op = 986}, {name = "日付+日時", op = 987}}, def = "日付+日時"
            },
            {
                name = "カスタムゲージの結果出力", item = {{name = "ON", op = 990}, {name = "OFF", op = 991}}, def = "OFF"
            },
        },
        filepath = {
            {name = "NoImage画像", path = "../result2/noimage/*.png", def = "default"},
            {name = "ランキングのヘッダー", path = "../result2/parts/ranking/header/*.png", def = "ranking"},
            {name = "IR接続中のアイコン", path = "../result2/parts/ir/loading/*.png", def = "default"},
            {name = "背景選択-----------------------------------------", path="../dummy/*"},
            {name = "CLEAR背景", path = "../result2/background/isclear/clear/*", def = "bg"},
            {name = "FAILED背景", path = "../result2/background/isclear/failed/*", def = "bg"},
        },
        offset = {
            {name = "経験値等画面表示秒数 (決定キーの場合, 最小1秒)", x = 0},
            {name = "スコアグラフの1マスの高さ (既定値2)", h = 0},
            {name = "スコアグラフの細かさ (既定値2 1~5 小さいほど細かい)", w = 0},
            {name = "ランクの額縁の背景の透明度(既定値165 255で透明)", a = 0},
            {name = "ランキングのゲージの透明度(既定値75 255で透明)", a = 0},
            {name = "グルーヴゲージ部分のノーツグラフの透明度 (255で透明)", a = 0},
            {name = "平滑化周り--------------------------", x = 0},
            {name = "単純移動平均の期間 (既定値7)", x = 0},
            {name = "指数移動平均の最新データの重視率 (既定値40 0<x<100)", x = 0},
            {name = "平滑移動平均 (既定値7)", x = 0},
            {name = "線形加重移動平均 (既定値7)", x = 0},
        },
    }

    do
        local filepathes = header.filepath
        -- ボケていない方
        filepathes[#filepathes+1] = {name = "背景選択2(クリアランク毎)-------------------------", path="../dummy/*"}
        for i, rankDir in ipairs(RANK_DIR_LIST) do
            filepathes[#filepathes+1] = {
                name = string.upper(rankDir) .. "背景(ランク毎)", path = "../result2/background/ranks/" .. rankDir .. "/*", def = "default",
            }
        end
        filepathes[#filepathes+1] = {name = "背景選択3(クリアランプ毎)-------------------------", path="../dummy/*"}
        for i, lampDir in ipairs(LAMP_DIR_LIST) do
            filepathes[#filepathes+1] = {
                name = LAMP_DIR_NAME_LIST[i] .. "背景(ランプ毎)", path = "../result2/background/lamps/" .. lampDir .. "/*", def = "default",
            }
        end
    end

    setProperties(header)
    return header
end

local function initialize(skin)
    if is2P() then

    end
end


local function main()
    local skin = {}
	-- ヘッダ情報をスキン本体にコピー
    for k, v in pairs(makeHeader()) do
        skin[k] = v
    end

    globalInitialize(skin)
    initialize(skin)
    resultObtained.init()

    CLEAR_TYPE = main_state.number(370)
    local requireStamina = userData.calcUseStamina(main_state.number(106))
    resultObtained.setRampAndUpdateFadeTime(skin, CLEAR_TYPE, not userData.getIsUsableStamina(requireStamina))

    if CLEAR_TYPE == LAMPS.NO_PLAY then
        -- コース途中のリザルトならクリアかfailedしか無い
        if main_state.option(90) then
            CLEAR_TYPE = LAMPS.NORMAL
        else
            CLEAR_TYPE = LAMPS.FAILED
        end
    elseif CLEAR_TYPE > LAMPS.NO_PLAY then
        myPrint("スタミナ要求量: " .. requireStamina)
        -- リザでリプレイかどうかは検出できない
        if userData.getIsUsableStamina(requireStamina) then
            -- ランプがあって(単体, コースリザルト, フルコン以上)クリアなら経験値を更新
            local exp = math.ceil(math.pow(main_state.number(362) * main_state.number(71), 0.75))
            print("獲得経験値: ceil((" .. main_state.number(71) .. " * " .. main_state.number(362) .. ") ^ 0.75) = " .. exp)

            if CLEAR_TYPE == LAMPS.FAILED then
                print("FAILEDのため, 経験値0倍")
                exp = 0
            elseif CLEAR_TYPE <= LAMPS.LA_EASY then
                print("LIGHT ASSIST EASY以下のため, 経験値0.25倍")
                exp = exp * 0.25
            elseif CLEAR_TYPE == LAMPS.EASY then
                print("EASYのため, 経験値0.8倍")
                exp = exp * 0.8
            elseif CLEAR_TYPE <= LAMPS.HARD then
                print("NORMAL, HARDのため, 経験値変化なし")
            elseif CLEAR_TYPE == LAMPS.EX_HARD then
                print("EX-HARDのため, 経験値1.2倍")
                exp = exp * 1.2
            elseif CLEAR_TYPE == LAMPS.FULLCOMBO then
                print("FULLCOMBOのため, 経験値1.4倍")
                exp = exp * 1.4
            elseif CLEAR_TYPE == LAMPS.PERFECT then
                print("PERFECTのため, 経験値1.5倍")
                exp = exp * 1.5
            elseif CLEAR_TYPE == LAMPS.MAX then
                print("MAXのため, 経験値5倍")
                exp = exp * 5
            end
            exp = math.floor(exp)
            userData.updateRemainingStamina()
            userData.useStamina(requireStamina)
            userData.addExp(exp)
            userData.updateTokens()
            pcall(userData.save)
        end
    end

    skin.customEvents = {} -- カスタムタイマはglobalInitializeで初期化済み

    skin.source = {
        -- score frame
        {id = 1, path = "../result3/parts/score_text.png"},
        {id = 2, path = "../result3/parts/judges_text.png"},
        {id = 3, path = "../result3/parts/others.png"},

        -- exscore value
        {id = 51, path = "../result3/parts/nums/exscore.png"},
        {id = 52, path = "../result3/parts/nums/exscore_p.png"},
        {id = 53, path = "../result3/parts/nums/exscore_p_a.png"},
        {id = 54, path = "../result3/parts/nums/best.png"},
        {id = 55, path = "../result3/parts/nums/best_diff.png"},
        {id = 56, path = "../result3/parts/nums/tgt.png"},
        {id = 57, path = "../result3/parts/nums/tgt_diff.png"},

        -- judges
        {id = 58, path = "../result3/parts/nums/pf.png"},
        {id = 59, path = "../result3/parts/nums/gr.png"},
        {id = 60, path = "../result3/parts/nums/gd.png"},
        {id = 61, path = "../result3/parts/nums/bd.png"},
        {id = 62, path = "../result3/parts/nums/pr.png"},
        {id = 63, path = "../result3/parts/nums/ms.png"},

        {id = 70, path = "../result3/parts/nums/pf_f.png"},
        {id = 71, path = "../result3/parts/nums/pf_s.png"},
        {id = 72, path = "../result3/parts/nums/gr_f.png"},
        {id = 73, path = "../result3/parts/nums/gr_s.png"},
        {id = 74, path = "../result3/parts/nums/gd_f.png"},
        {id = 75, path = "../result3/parts/nums/gd_s.png"},
        {id = 76, path = "../result3/parts/nums/bd_f.png"},
        {id = 77, path = "../result3/parts/nums/bd_s.png"},
        {id = 78, path = "../result3/parts/nums/pr_f.png"},
        {id = 79, path = "../result3/parts/nums/pr_s.png"},
        {id = 80, path = "../result3/parts/nums/ms_f.png"},
        {id = 81, path = "../result3/parts/nums/ms_s.png"},

        -- bp, combo
        {id = 82, path = "../result3/parts/nums/combo.png"},
        {id = 83, path = "../result3/parts/nums/combo_diff.png"},
        {id = 84, path = "../result3/parts/nums/bp.png"},
        {id = 85, path = "../result3/parts/nums/bp_diff.png"},


        -- 背景群
        {id = 100, path = "../result2/background/isclear/clear/*.png"},
        {id = 101, path = "../result2/background/isclear/failed/*.png"},

        -- 背景
        {id = 200, path = "../result2/backgroundbokeh/isclear/clear/*"},
        {id = 201, path = "../result2/backgroundbokeh/isclear/failed/*"},

        {id = 999, path = "../common/colors/colors.png"},
    }

    -- ランプ毎などの背景
    do
        local sources = skin.source
        for i, rankDir in ipairs(RANK_DIR_LIST) do
            sources[#sources+1] = {
                id = 110 + (i - 1), path = "../result3/background/ranks/" .. rankDir .. "/*", def = "default",
            }
        end
        for i, lampDir in ipairs(LAMP_DIR_LIST) do
            sources[#sources+1] = {
                id = 120 + (i - 1), path = "../result3/background/lamps/" .. lampDir .. "/*", def = "default",
            }
        end
    end

    skin.image = {
        -- その他色
        {id = "blank", src = 999, x = 0, y = 0, w = 1, h = 1},
        {id = "black", src = 999, x = 1, y = 0, w = 1, h = 1},
        {id = "white", src = 999, x = 2, y = 0, w = 1, h = 1},
    }

    skin.font = {
        {id = 0, path = "../common/fonts/SourceHanSans-Light.otf"},
    }


    mergeSkin(skin, background.load())
    mergeSkin(skin, fade.load())
    mergeSkin(skin, scoreDetail.load())

    skin.destination = {}

    mergeSkin(skin, background.dst())
    mergeSkin(skin, scoreDetail.dst())
    mergeSkin(skin, fade.dst())
    return skin
end


return {
    header = makeHeader,
    main = main,

    setIsCourseResult = setIsCourseResult,
}