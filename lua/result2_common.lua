--[[
    一部のモジュールはSocialSkinのresultと共有
]]

require("modules.result.commons")
local main_state = require("main_state")
local background = require("modules.result.background")
local fade = require("modules.result.fade")
local stagefile = require("modules.result2.stagefile")
local judges = require("modules.result2.judges")
local exscores = require("modules.result2.exscores")
local musicInfo = require("modules.result2.music_info")
local largeLamp = require("modules.result2.large_lamp")
local lamp = require("modules.result2.lamps")
local rank = require("modules.result2.rank")
local groove = require("modules.result2.groove")
local scoreDetail = require("modules.result2.score_detail")
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
            name = "ステージファイル部分の判定グラフ", item = {{name = "ノーツ数分布", op = 950}, {name = "判定分布", op = 951}, {name = "EARLY/LATE分布(棒グラフ)", op = 952}}, def = "判定分布"
        })
        table.insert(skin.property, {
            name = "各種グラフ1個目", item = {{name = "ノーツ数分布", op = 930}, {name = "判定分布", op = 931}, {name = "EARLY/LATE分布(棒グラフ)", op = 932}}, def = "ノーツ数分布"
        })
        table.insert(skin.property, {
            name = "各種グラフ2個目", item = {{name = "ノーツ数分布", op = 935}, {name = "判定分布", op = 936}, {name = "EARLY/LATE分布(棒グラフ)", op = 937}}, def = "判定分布"
        })
        table.insert(skin.property, {
            name = "各種グラフ3個目", item = {{name = "ノーツ数分布", op = 940}, {name = "判定分布", op = 941}, {name = "EARLY/LATE分布(棒グラフ)", op = 942}}, def = "EARLY/LATE分布(棒グラフ)"
        })
    else
        table.insert(skin.property, {
            name = "ステージファイル部分の判定グラフ", item = {{name = "ノーツ数分布", op = 950}, {name = "判定分布", op = 951}, {name = "EARLY/LATE分布(棒グラフ)", op = 952}, {name = "タイミング可視化グラフ", op = 953}}, def = "判定分布"
        })
        table.insert(skin.property, {
            name = "各種グラフ1個目", item = {{name = "ノーツ数分布", op = 930}, {name = "判定分布", op = 931}, {name = "EARLY/LATE分布(棒グラフ)", op = 932}, {name = "タイミング可視化グラフ", op = 933}}, def = "ノーツ数分布"
        })
        table.insert(skin.property, {
            name = "各種グラフ2個目", item = {{name = "ノーツ数分布", op = 935}, {name = "判定分布", op = 936}, {name = "EARLY/LATE分布(棒グラフ)", op = 937}, {name = "タイミング可視化グラフ", op = 938}}, def = "判定分布"
        })
        table.insert(skin.property, {
            name = "各種グラフ3個目", item = {{name = "ノーツ数分布", op = 940}, {name = "判定分布", op = 941}, {name = "EARLY/LATE分布(棒グラフ)", op = 942}, {name = "タイミング可視化グラフ", op = 943}}, def = "EARLY/LATE分布(棒グラフ)"
        })
    end
end

local function makeHeader()
    local header = {
        type = 7,
        name = "Glass style" .. (DEBUG and " dev result" or ""),
        w = WIDTH,
        h = HEIGHT,
        fadeout = fade.getFadeOutTime(),
        scene = 3600000,
        input = INPUT_WAIT,
        -- 910, 920, 930, 935, 940, 945, 950, 965, 975
        property = {
            {
                name = "背景の分類", item = {{name = "クリアかどうか", op = 910}, {name = "ランク毎", op = 911}, {name = "クリアランプ毎", op = 912}}, def = "クリアかどうか"
            },
            -- {
            --     name = "スコア位置", item = {{name = "左", op = 920}, {name = "右", op = 921}}, def = "左"
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
        },
        filepath = {
            {name = "NoImage画像(png)", path = "../result2/noimage/*.png", def = "default"},
            {name = "判定---------------------------------------------", path="../dummy/*"},
            {name = "PERFECT背景", path = "../result2/parts/judge/background/perfect/*.png", def = "light blue purple"},
            {name = "GREAT背景"  , path = "../result2/parts/judge/background/great/*.png", def = "purple orange"},
            {name = "GOOD背景"   , path = "../result2/parts/judge/background/good/*.png", def = "orange"},
            {name = "BAD背景"    , path = "../result2/parts/judge/background/bad/*.png", def = "purple"},
            {name = "POOR背景"   , path = "../result2/parts/judge/background/poor/*.png", def = "red purple"},
            {name = "PERFECT文字", path = "../result2/parts/judge/text/perfect/*.png", def = "light purple"},
            {name = "GREAT文字"  , path = "../result2/parts/judge/text/great/*.png", def = "orange"},
            {name = "GOOD文字"   , path = "../result2/parts/judge/text/good/*.png", def = "orange"},
            {name = "BAD文字"    , path = "../result2/parts/judge/text/bad/*.png", def = "light red"},
            {name = "POOR文字"   , path = "../result2/parts/judge/text/poor/*.png", def = "purple"},
            {name = "PERFECT数字", path = "../result2/parts/judge/num/perfect/*.png", def = "light purple"},
            {name = "GREAT数字"  , path = "../result2/parts/judge/num/great/*.png", def = "orange"},
            {name = "GOOD数字"   , path = "../result2/parts/judge/num/good/*.png", def = "orange"},
            {name = "BAD数字"    , path = "../result2/parts/judge/num/bad/*.png", def = "dark red"},
            {name = "POOR数字"   , path = "../result2/parts/judge/num/poor/*.png", def = "dark purple"},
            {name = "詳細画面判定--------------------------------------", path="../dummy/*"},
            {name = "PERFECT文字", path = "../result2/parts/detail/judge/text/perfect/*.png", def = "light purple"},
            {name = "GREAT文字"  , path = "../result2/parts/detail/judge/text/great/*.png", def = "orange"},
            {name = "GOOD文字"   , path = "../result2/parts/detail/judge/text/good/*.png", def = "orange"},
            {name = "BAD文字"    , path = "../result2/parts/detail/judge/text/bad/*.png", def = "light red"},
            {name = "POOR文字"   , path = "../result2/parts/detail/judge/text/poor/*.png", def = "purple"},
            {name = "E.POOR文字" , path = "../result2/parts/detail/judge/text/epoor/*.png", def = "purple"},
            {name = "PERFECT数字", path = "../result2/parts/detail/judge/num/perfect/*.png", def = "light purple"},
            {name = "GREAT数字"  , path = "../result2/parts/detail/judge/num/great/*.png", def = "orange"},
            {name = "GOOD数字"   , path = "../result2/parts/detail/judge/num/good/*.png", def = "orange"},
            {name = "BAD数字"    , path = "../result2/parts/detail/judge/num/bad/*.png", def = "dark red"},
            {name = "POOR数字"   , path = "../result2/parts/detail/judge/num/poor/*.png", def = "dark purple"},
            {name = "E.POOR数字" , path = "../result2/parts/detail/judge/num/epoor/*.png", def = "dark purple"},
            {name = "ランク-------------------------------------------", path="../dummy/*"},
            {name = "ランクの額縁の縁"  , path = "../result2/parts/rank/frame/edge/*.png", def = "luxury"},
            {name = "ランクの額縁の装飾", path = "../result2/parts/rank/frame/decoration/*.png", def = "ivy"},
            {name = "ランクの額縁の背景", path = "../result2/parts/rank/frame/background/*.png", def = "oldpaper"},
            {name = "背景選択-----------------------------------------", path="../dummy/*"},
            {name = "CLEAR背景(png)", path = "../result2/background/isclear/clear/*.png", def = "bg"},
            {name = "FAILED背景(png)", path = "../result2/background/isclear/failed/*.png", def = "bg"},
        },
        offset = {
            {name = "経験値等画面表示秒数 (決定キーの場合, 最小1秒)", x = 0},
            {name = "スコアグラフの1マスの高さ (既定値2)", h = 0},
            {name = "スコアグラフの細かさ (既定値2 1~5 小さいほど細かい)", w = 0},
            {name = "ランクの額縁の背景の透明度(既定値165 255で透明)", a = 0},
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
        filepathes[#filepathes+1] = {name = "背景選択2-----------------------------------------", path="../dummy/*"}
        for i, rankDir in ipairs(RANK_DIR_LIST) do
            filepathes[#filepathes+1] = {
                name = string.upper(rankDir) .. "背景(png)", path = "../result2/background/ranks/" .. rankDir .. "/*.png"
            }
        end
        filepathes[#filepathes+1] = {name = "背景選択3-----------------------------------------", path="../dummy/*"}
        for i, lampDir in ipairs(LAMP_DIR_LIST) do
            filepathes[#filepathes+1] = {
                name = LAMP_DIR_NAME_LIST[i] .. "背景(png)", path = "../result2/background/lamps/" .. lampDir .. "/*.png"
            }
        end
        -- ボケている方
        filepathes[#filepathes+1] = {name = "背景選択(ぼかし)----------------------------------", path="../dummy/*"}
        filepathes[#filepathes+1] = {name = "CLEARぼかし背景(png)", path = "../result2/backgroundbokeh/isclear/clear/*.png", def = "bg"}
        filepathes[#filepathes+1] = {name = "FAILEDぼかし背景(png)", path = "../result2/backgroundbokeh/isclear/failed/*.png", def = "bg"}

        filepathes[#filepathes+1] = {name = "背景選択2(ぼかし)---------------------------------", path="../dummy/*"}
        for i, rankDir in ipairs(RANK_DIR_LIST) do
            filepathes[#filepathes+1] = {
                name = string.upper(rankDir) .. "ぼかし背景(png)", path = "../result2/backgroundbokeh/ranks/" .. rankDir .. "/*.png"
            }
        end
        filepathes[#filepathes+1] = {name = "背景選択3(ぼかし)---------------------------------", path="../dummy/*"}
        for i, lampDir in ipairs(LAMP_DIR_LIST) do
            filepathes[#filepathes+1] = {
                name = LAMP_DIR_NAME_LIST[i] .. "ぼかし背景(png)", path = "../result2/backgroundbokeh/lamps/" .. lampDir .. "/*.png"
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
                print("FULLCOMBOのため, 経験値1.5倍")
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
        {id = 0, path = "../result2/parts/parts.png"},
        {id = 1, path = "../result2/parts/musicinfo/default.png"},
        {id = 3, path = "../result2/parts/largelamp/" .. largeLamp.getLampId(CLEAR_TYPE) .. ".png"},
        {id = 4, path = "../result2/parts/largelamp/lines.png"},
        -- ランク背景
        {id = 5, path = "../result2/parts/rank/frame/edge/*.png"},
        {id = 6, path = "../result2/parts/rank/frame/decoration/*.png"},
        {id = 7, path = "../result2/parts/rank/frame/background/*.png"},
        {id = 8, path = "../result2/parts/rank/text/default.png"},

        {id = 9, path = "../result2/parts/gauge/shadow.png"},
        {id = 10, path = "../result2/parts/gauge/details.png"},
        {id = 11, path = "../result2/parts/gauge/labels.png"},
        {id = 12, path = "../result2/parts/lamps/normal.png"},
        {id = 13, path = "../result2/parts/detail/labels.png"},
        {id = 14, path = "../result2/parts/detail/headers.png"},
        {id = 15, path = "../result2/parts/detail/num36.png"},
        {id = 16, path = "../result2/parts/detail/gray_num48.png"},
        {id = 17, path = "../result2/parts/detail/exscore_num.png"},

        {id = 20, path = "../result2/noimage/*.png"},
        {id = 100, path = "../result2/background/isclear/clear/*.png"},
        {id = 101, path = "../result2/background/isclear/failed/*.png"},
        -- 110~120は下のfor
        -- 判定の背景
        {id = 130, path = "../result2/parts/judge/background/perfect/*.png"},
        {id = 131, path = "../result2/parts/judge/background/great/*.png"},
        {id = 132, path = "../result2/parts/judge/background/good/*.png"},
        {id = 133, path = "../result2/parts/judge/background/bad/*.png"},
        {id = 134, path = "../result2/parts/judge/background/poor/*.png"},
        {id = 140, path = "../result2/parts/judge/text/perfect/*.png"},
        {id = 141, path = "../result2/parts/judge/text/great/*.png"},
        {id = 142, path = "../result2/parts/judge/text/good/*.png"},
        {id = 143, path = "../result2/parts/judge/text/bad/*.png"},
        {id = 144, path = "../result2/parts/judge/text/poor/*.png"},
        {id = 150, path = "../result2/parts/judge/num/perfect/*.png"},
        {id = 151, path = "../result2/parts/judge/num/great/*.png"},
        {id = 152, path = "../result2/parts/judge/num/good/*.png"},
        {id = 153, path = "../result2/parts/judge/num/bad/*.png"},
        {id = 154, path = "../result2/parts/judge/num/poor/*.png"},
        -- 大きいEXSCORE等
        {id = 160, path = "../result2/parts/exscore/background/default.png"},
        {id = 161, path = "../result2/parts/exscore/text/default.png"},
        {id = 162, path = "../result2/parts/exscore/num/default.png"},
        {id = 163, path = "../result2/parts/combo/background/default.png"},
        {id = 164, path = "../result2/parts/combo/text/default.png"},
        {id = 165, path = "../result2/parts/combo/num/default.png"},
        {id = 166, path = "../result2/parts/ir/background/default.png"},
        {id = 167, path = "../result2/parts/ir/text/default.png"},
        {id = 168, path = "../result2/parts/ir/num/default.png"},
        -- 詳細画面用
        {id = 170, path = "../result2/parts/detail/judge/text/perfect/*.png"},
        {id = 171, path = "../result2/parts/detail/judge/text/great/*.png"},
        {id = 172, path = "../result2/parts/detail/judge/text/good/*.png"},
        {id = 173, path = "../result2/parts/detail/judge/text/bad/*.png"},
        {id = 174, path = "../result2/parts/detail/judge/text/poor/*.png"},
        {id = 175, path = "../result2/parts/detail/judge/text/epoor/*.png"},
        {id = 180, path = "../result2/parts/detail/judge/num/perfect/*.png"},
        {id = 181, path = "../result2/parts/detail/judge/num/great/*.png"},
        {id = 182, path = "../result2/parts/detail/judge/num/good/*.png"},
        {id = 183, path = "../result2/parts/detail/judge/num/bad/*.png"},
        {id = 184, path = "../result2/parts/detail/judge/num/poor/*.png"},
        {id = 185, path = "../result2/parts/detail/judge/num/epoor/*.png"},

        -- ぼかし背景は210~220
        {id = 200, path = "../result2/backgroundbokeh/isclear/clear/*.png"},
        {id = 201, path = "../result2/backgroundbokeh/isclear/failed/*.png"},

        -- シンプル数字は300番台
        {id = 330, path = "../result2/parts/simplenumbers/30px.png"},
        {id = 999, path = "../common/colors/colors.png"},
    }
    do
        local sources = skin.source
        for i, rankDir in ipairs(RANK_DIR_LIST) do
            sources[#sources+1] = {
                id = 110 + (i - 1), path = "../result2/background/ranks/" .. rankDir .. "/*.png"
            }
        end
        for i, lampDir in ipairs(LAMP_DIR_LIST) do
            sources[#sources+1] = {
                id = 120 + (i - 1), path = "../result2/background/lamps/" .. lampDir .. "/*.png"
            }
        end
        for i, rankDir in ipairs(RANK_DIR_LIST) do
            sources[#sources+1] = {
                id = 210 + (i - 1), path = "../result2/backgroundbokeh/ranks/" .. rankDir .. "/*.png"
            }
        end
        for i, lampDir in ipairs(LAMP_DIR_LIST) do
            sources[#sources+1] = {
                id = 220 + (i - 1), path = "../result2/backgroundbokeh/lamps/" .. lampDir .. "/*.png"
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


    mergeSkin(skin, loadNumberSymbols())
    mergeSkin(skin, background.load())
    mergeSkin(skin, groove.load())
    mergeSkin(skin, lamp.load())
    mergeSkin(skin, stagefile.load())
    mergeSkin(skin, rank.load())
    mergeSkin(skin, judges.load())
    mergeSkin(skin, exscores.load())
    mergeSkin(skin, musicInfo.load())
    mergeSkin(skin, scoreDetail.load())
    mergeSkin(skin, largeLamp.load())
    mergeSkin(skin, fade.load())

    skin.destination = {}

    mergeSkin(skin, background.dst())
    mergeSkin(skin, groove.dst())
    mergeSkin(skin, lamp.dst())
    mergeSkin(skin, stagefile.dst())
    mergeSkin(skin, rank.dst())
    mergeSkin(skin, judges.dst())
    mergeSkin(skin, exscores.dst())
    mergeSkin(skin, scoreDetail.dst())

    mergeSkin(skin, musicInfo.dst())
    mergeSkin(skin, largeLamp.dst())
    mergeSkin(skin, fade.dst())

    return skin
end


return {
    header = makeHeader,
    main = main,

    setIsCourseResult = setIsCourseResult,
}