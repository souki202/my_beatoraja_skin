require("modules.commons.define")
local main_state = require("main_state")
local playCommons = require("modules.play.commons")
local songInfo = require("modules.commons.songinfo")
local lanes = require("modules.play.lanes")
local judges = require("modules.play.judges")
local life = require("modules.play.life")
local scoreGraph = require("modules.play.score_graph")
local bga = require("modules.play.bga")
local progress = require("modules.play.progress_bar")
local judgeDetail = require("modules.play.judge_detail")
local hispeed = require("modules.play.hispeed")
local sideInfo = require("modules.play.side_info")
local grow = require("modules.play.grow")
local bomb = require("modules.play.bomb")
local loading = require("modules.play.loading")
local finish = require("modules.play.finish")
local fade = require("modules.play.fade")
local visualizer = require("modules.play.visualizer")
local autoplay = require("modules.play.autoplay")
local logger = require("modules.play.logger")

local header = {
    type = 0,
    name = "Social Skin" .. (DEBUG and " play dev" or ""),
    w = WIDTH,
    h = HEIGHT,
    loadend = 2500,
    playstart = playCommons.startTime,
    scene = 36000000,
    input = 500,
    close = 2000,
    fadeout = fade.getFadeoutTime(),

    property = { -- 使用済み 10105まで
        {
            name = "orajaの起動時のスキンタブから変更推奨", item = {{name = "-", op = 19999}}
        },
        {
            name = "----------------------------------", item = {{name = "-", op = 19999}}
        },
        {
            name = "プレイ位置", item = {{name = "1P", op = 900}, {name = "2P", op = 901}}, def = "1P"
        },
        {
            name = "ターンテーブル位置", item = {{name = "通常", op = 950}, {name = "反転", op = 951}}, def = "通常"
        },
        {
            name = "汎用BGA形式", item = {{name = "png", op = 10025}, {name = "mp4", op = 10026}}, def = "mp4"
        },
        {
            name = "コンボ位置", item = {{name = "判定横", op = 970}, {name = "判定下", op = 971}, {name = "レーン右上(1P), 左上(2P)", op = 973}}, def = "判定下"
        },
        {
            name = "判定画像分類", item = {{name = "通常", op = 10090}, {name = "EARLY/LATE分割", op = 10091}}, def = "通常"
        },
        {
            name = "EARLY, LATE表示", item = {{name = "OFF", op = 905}, {name = "EARLY/LATE", op = 906}, {name = "+-ms", op = 907}, {name = "+-ms(PG時非表示)", op = 908}}, def = "EARLY/LATE"
        },
        {
            name = "低速時のEARLY, LATE位置変更基準", item = {{name = "OFF", op = 10075}, {name = "4/5", op = 10076}, {name = "3/4", op = 10077}, {name = "2/3", op = 10078}, {name = "1/2", op = 10079}}, def = "3/4"
        },
        {
            name = "BPM変化の判定基準", item = {{name = "開始時BPM", op = 10080}, {name = "MAIN BPM", op = 10081}}, def = "MAIN BPM"
        },
        {
            name = "スコア差表示", item = {{name = "無し", op = 990}, {name = "目標スコア", op = 991}, {name = "自己ベスト", op = 992}}, def = "目標スコア"
        },
        {
            name = "スコア差表示位置", item = {{name = "レーン横", op = 995}, {name = "判定上", op = 996}}, def = "レーン横"
        },
        {
            name = "ノートの画像", item = {{name = "通常形式", op = 10030}, {name = "独自形式", op = 10031}}, def = "通常形式"
        },
        {
            name = "BGA枠", item = {{name = "横上部", op = 940}, {name = "横全体", op = 941}, {name = "画面全体", op = 942}}, def = "横上部"
        },
        {
            name = "黒帯部分のBGA表示", item = {{name = "ON", op = 945}, {name = "OFF", op = 946}}, def = "ON"
        },
        {
            name = "黒帯部分のBGA表示のぼかし", item = {{name = "ON", op = 10105}, {name = "OFF", op = 10106}}, def = "OFF"
        },
        {
            name = "サイド部分のグラフ", item = {{name = "無し", op = 10000}, {name = "判定分布", op = 10001}, {name = "EARLY, LATE分布", op = 10002}}, def = "判定分布"
        },
        { -- 961まで使用
            name = "難易度毎の色変化", item = {{name = "あり", op = 955}, {name = "灰固定", op = 956}, {name = "緑固定", op = 957}, {name = "青固定", op = 958}, {name = "橙固定", op = 959}, {name = "赤固定", op = 960}, {name = "紫固定", op = 961}}, def = "あり"
        },
        {
            name = "リザルト用ログ出力", item = {{name = "ON", op = 10085}, {name = "OFF", op = 10086}}, def = "ON"
        },
        {
            name = "グルーヴゲージ-----------------------", item = {{name = "-", op = 19999}}
        },
        {
            name = "グルーヴゲージ隠し", item = {{name = "ON", op = 10095}, {name = "OFF", op = 10096}}, def = "OFF"
        },
        {
            name = "グルーヴゲージの通知エフェクトの基準", item = {{name = "5%毎", op = 10065}, {name = "10%毎", op = 10066}, {name = "20%毎", op = 10067}, {name = "30%毎", op = 10068}, {name = "無し", op = 10069}}, def = "10%毎"
        },
        {
            name = "グルーヴゲージ位置", item = {{name = "レーン下", op = 10100}, {name = "レーン左右", op = 10101}}, def = "レーン下"
        },
        {
            name = "ゲージ100%時のキラキラ", item = {{name = "ON", op = 10070}, {name = "OFF", op = 10071}}, def = "ON"
        },
        {
            name = "レーン------------------------------", item = {{name = "-", op = 19999}}
        },
        {
            name = "レーン色分け", item = {{name = "ON", op = 910}, {name = "OFF", op = 911}}, def = "ON"
        },
        {
            name = "レーン区切り線", item = {{name = "ON", op = 915}, {name = "OFF", op = 916}}, def = "ON"
        },
        {
            name = "レーンのシンボル", item = {{name = "ON", op = 965}, {name = "OFF", op = 966}}, def = "ON"
        },
        {
            name = "判定ライン", item = {{name = "ON", op = 920}, {name = "OFF", op = 921}}, def = "ON"
        },
        {
            name = "キービーム--------------------------", item = {{name = "-", op = 19999}}
        },
        {
            name = "キービーム長さ", item = {{name = "無し", op = 925}, {name = "とても短め", op = 926}, {name = "短め", op = 927}, {name = "普通", op = 928}, {name = "長め", op = 929}}, def = "普通"
        },
        {
            name = "キービーム出現時間", item = {{name = "即", op = 930}, {name = "とても短め", op = 931}, {name = "短め", op = 932}, {name = "普通", op = 933}, {name = "長め", op = 934}}, def = "即"
        },
        {
            name = "キービーム消失時間", item = {{name = "即", op = 985}, {name = "とても短め", op = 986}, {name = "短め", op = 987}, {name = "普通", op = 988}, {name = "長め", op = 989}}, def = "短め"
        },
        {
            name = "キービーム出現アニメーション", item = {{name = "通常", op = 975}, {name = "端から", op = 976}, {name = "中央から", op = 977}}, def = "通常"
        },
        {
            name = "キービーム消失アニメーション", item = {{name = "通常", op = 980}, {name = "端から", op = 981}, {name = "中央から", op = 982}}, def = "端から"
        },
        {
            name = "後方キービーム", item = {{name = "ON", op = 935}, {name = "OFF", op = 936}}, def = "ON"
        },
        {
            name = "ボム------------------------------", item = {{name = "-", op = 19999}}
        },
        {
            name = "ボムのパーティクル", item = {{name = "ON", op = 10005}, {name = "OFF", op = 10006}}, def = "ON"
        },
        {
            name = "ボムのparticle1のアニメーション", item = {{name = "フロー", op = 10010}, {name = "拡散", op = 10011}, {name = "静止", op = 10012}}, def = "フロー"
        },
        {
            name = "ボムのparticle2のアニメーション", item = {{name = "フロー", op = 10015}, {name = "拡散", op = 10016}, {name = "静止", op = 10017}}, def = "フロー"
        },
        {
            name = "ボムのanimation1と2の黒背景透過", item = {{name = "ON", op = 10020}, {name = "OFF", op = 10021}}, def = "ON"
        },
        {
            name = "ビジュアライザー-------------------", item = {{name = "-", op = 19999}}
        },
        {
            name = "ビジュアライザー1", item = {{name = "ON", op = 10055}, {name = "OFF", op = 10056}}, def = "OFF"
        },
        {
            name = "ビジュアライザー1の棒線タイプ", item = {{name = "太い", op = 10035}, {name = "細い", op = 10036}}, def = "細い"
        },
        {
            name = "ビジュアライザー1の棒線の多さ", item = {{name = "1(Very Low)", op = 10040}, {name = "2(Low)", op = 10041}, {name = "3", op = 10042}, {name = "4", op = 10043}, {name = "5(High)", op = 10044}, {name = "6(Very High)", op = 10045}, {name = "7(Ultra)", op = 10046}}, def = "3"
        },
        {
            name = "ビジュアライザー1の山の出現位置", item = {{name = "ボム基準", op = 10050}, {name = "判定基準", op = 10051}}, def = "ボム基準"
        },
        {
            name = "ビジュアライザー1の奥側の反射", item = {{name = "ON", op = 10060}, {name = "OFF", op = 10061}}, def = "ON"
        },
    },
    filepath = {
        {name = "各種画像--------------", path = "../dummy/*"},
        {name = "背景画像", path = "../play/parts/background/*.png", def = "default"},
        {name = "汎用画像(png)", path = "../play/parts/versatilitybga/*.png", def = "default"},
        {name = "汎用画像(mp4)", path = "../play/parts/versatilitybga/*.mp4", def = "default"},
        {name = "黒帯部分BGAのマスク", path = "../play/parts/bgamask/*.png", def = "default"},
        {name = "ノート画像(通常形式)", path = "../play/parts/notes/normal/*.png", def = "default"},
        {name = "ノート画像(独自形式)", path = "../play/parts/notes/original/*.png", def = "default"},
        {name = "レーンのシンボル(白鍵)", path = "../play/parts/lanesymbols/white/*.png", def = "dia"},
        {name = "レーンのシンボル(青鍵)", path = "../play/parts/lanesymbols/blue/*.png", def = "dia"},
        {name = "レーンのシンボル(ターンテーブル)", path = "../play/parts/lanesymbols/turntable/*.png", def = "circle"},
        {name = "レーンカバー", path = "../play/parts/lanecover/*.png", def = "default"},
        {name = "リフトカバー", path = "../play/parts/liftcover/*.png", def = "default"},
        {name = "判定画像", path = "../play/parts/judges/*.png", def = "default"},
        {name = "判定画像(EARLY)", path = "../play/parts/judges/early/*.png", def = "text"},
        {name = "判定画像(LATE)", path = "../play/parts/judges/late/*.png", def = "text"},
        {name = "コンボ画像", path = "../play/parts/combo/*.png", def = "default"},
        {name = "グルーヴゲージのインディケーター", path = "../play/parts/indicators/*.png", def = "default"},
        {name = "ボム関連画像---------", path = "../dummy/*"},
        {name = "wave1", path = "../play/parts/bombs/wave1/*.png", def = "default"},
        {name = "particle1", path = "../play/parts/bombs/particle1/*.png", def = "default"},
        {name = "animation1", path = "../play/parts/bombs/animation1/*.png", def = "blank"},
        {name = "wave2", path = "../play/parts/bombs/wave2/*.png", def = "blank"},
        {name = "particle2", path = "../play/parts/bombs/particle2/*.png", def = "blank"},
        {name = "animation2", path = "../play/parts/bombs/animation2/*.png", def = "blank"},
    },
    offset = {
        {name = "各種オフセット(0で既定値)---------", x = 0},
        {name = "判定線の高さ(既定値 4px)", h = 0},
        {name = "レーンの黒背景(255で透明)", a = 0},
        {name = "グルーブゲージの通知エフェクトの大きさ差分(%)", y = 0},
        {name = "ゲージ100%時のキラキラの数(既定値20)", x = 0},

        {name = "スコアログ周り------------------", x = 0},
        {name = "スコアレートのサンプルノーツ数(既定値50)", x = 0},
        {name = "スコアレートのサンプル取得の最大時間(単位秒 既定値10)", x = 0},

        {name = "キービーム関連------------------------", x = 0},
        {name = "キービームの透明度(既定値64 255で透明)", a = 0},
        {name = "白鍵キービームの明るさ(単位% 既定値100)", x = 0},
        {name = "白鍵キービームの彩度(単位% 既定値30)", x = 0},
        {name = "青鍵キービームの明るさ(単位% 既定値100)", x = 0},
        {name = "青鍵キービームの彩度(単位% 既定値60)", x = 0},

        {name = "ボム関連------------------------", x = 0},
        {name = "100%の描画縦横はwave 500px, anim 300px, particle 16px", x = 0},
        {name = "倍率差分は, -100で0%相当, 100で200%相当", x = 0},

        {name = "ボムのwave1の大きさ倍率(単位%)", w = 0, h = 0},
        {name = "ボムのwave1の描画時間(単位100ms 既定値3)", x = 0},
        {name = "ボムのwave2の大きさ倍率(単位%)", w = 0, h = 0},
        {name = "ボムのwave2の描画時間(単位100ms 既定値3)", x = 0},

        {name = "ボムのparticle1の大きさ倍率(単位%)", w = 0, h = 0},
        {name = "ボムのparticle1の描画数(既定値7)", x = 0},
        {name = "ボムのparticle1の描画時間(単位100ms 既定値3)", x = 0},
        {name = "ボムのparticle1のフローの高さ倍率差分(単位%)", h = 0},
        {name = "ボムのparticle1の拡散の広さ倍率差分(単位%)", w = 0, h = 0},
        {name = "ボムのparticle1の出現範囲倍率差分(単位%)", w = 0, h = 0},

        {name = "ボムのparticle2の大きさ倍率(単位%)", w = 0, h = 0},
        {name = "ボムのparticle2の描画数(既定値7)", x = 0},
        {name = "ボムのparticle2の描画時間(単位100ms 既定値3)", x = 0},
        {name = "ボムのparticle2のフローの高さ倍率差分(単位%)", h = 0},
        {name = "ボムのparticle2の拡散の広さ倍率差分(単位%)", w = 0, h = 0},
        {name = "ボムのparticle2の出現範囲倍率差分(単位%)", w = 0, h = 0},

        {name = "ボムのanimation1の大きさ倍率(単位%)", w = 0, h = 0},
        {name = "ボムのanimation1の画像分割数", x = 0, y = 0},
        {name = "ボムのanimation1の描画時間(単位100ms 既定値3)", x = 0},
        {name = "ボムのanimation1の描画座標差分", id = 40, x = 0, y = 0},

        {name = "ボムのanimation2の大きさ倍率(単位%)", w = 0, h = 0},
        {name = "ボムのanimation2の画像分割数", x = 0, y = 0},
        {name = "ボムのanimation2の描画時間(単位100ms 既定値3)", x = 0},
        {name = "ボムのanimation2の描画座標差分", id = 41, x = 0, y = 0},

        {name = "ビジュアライザー関連---------", x = 0},
        {name = "ビジュアライザー1のバーの透明度(既定値64 255で透明)", a = 0},
        {name = "ビジュアライザー1の反射の透明度(既定値196 255で透明)", a = 0},
    }
}

local function main()
    local skin = {}
	-- ヘッダ情報をスキン本体にコピー
	for k, v in pairs(header) do
		skin[k] = v
    end

    globalInitialize(skin)
    songInfo.loadSongInfo(main_state.text(10))

    skin.source = {
        {id = 0, path = "../play/parts/parts.png"},
        {id = 1, path = "../play/parts/notes/normal/*.png"},
        {id = 24, path = "../play/parts/notes/original/*.png"},
        {id = 2, path = "../play/parts/lanesymbols/white/*.png"},
        {id = 3, path = "../play/parts/lanesymbols/blue/*.png"},
        {id = 4, path = "../play/parts/lanesymbols/turntable/*.png"},
        {id = 5, path = "../play/parts/judges/*.png"},
        {id = 28, path = "../play/parts/judges/early/*.png"},
        {id = 29, path = "../play/parts/judges/late/*.png"},
        {id = 6, path = "../play/parts/combo/*.png"},
        {id = 7, path = "../play/parts/indicators/*.png"},
        {id = 8, path = "../play/parts/bgamask/*.png"},
        {id = 9, path = "../play/parts/lanecover/default.png"},
        {id = 10, path = "../play/parts/liftcover/default.png"},
        {id = 11, path = "../play/parts/bombs/wave1/*.png"},
        {id = 12, path = "../play/parts/bombs/particle1/*.png"},
        {id = 13, path = "../play/parts/bombs/animation1/*.png"},
        {id = 14, path = "../play/parts/bombs/wave2/*.png"},
        {id = 15, path = "../play/parts/bombs/particle2/*.png"},
        {id = 16, path = "../play/parts/bombs/animation2/*.png"},
        {id = 17, path = "../play/parts/ready/*.png"},
        {id = 18, path = "../play/parts/background/*.png"},
        {id = 19, path = "../play/parts/fc/shine_circle.png"},
        {id = 20, path = "../play/parts/fc/fireworks/default.png"},
        {id = 21, path = "../play/parts/fc/particle/default.png"},
        {id = 22, path = "../play/parts/versatilitybga/*.png"},
        {id = 23, path = "../play/parts/versatilitybga/*.mp4"},
        {id = 25, path = "../play/parts/visualizer/bar.png"},
        {id = 26, path = "../play/parts/visualizer/reflection.png"},
        {id = 27, path = "../play/parts/gauge100/default.png"},
        {id = 999, path = "../commON/colors/colors.png"}
    }

    skin.image = {
        {id = "blank", src = 999, x = 0, y = 0, w = 1, h = 1},
        {id = "black", src = 999, x = 1, y = 0, w = 1, h = 1},
        {id = "white", src = 999, x = 2, y = 0, w = 1, h = 1},
    }

    skin.font = {
		{id = 0, path = "../common/fonts/SourceHanSans-Regular.otf"},
    }

    -- skin.customTimers = {
    --     {id = 10002, timer = function ()
    --         print(main_state.text(12))
    --         songInfo.loadSongInfo(main_state.text(10))
    --         return main_state.timer_off_value
    --     end}
    -- }


    -- 各種読み込み
    mergeSkin(skin, logger.load())
    mergeSkin(skin, bga.load())
    mergeSkin(skin, lanes.load())
    mergeSkin(skin, progress.load())
    mergeSkin(skin, sideInfo.load())
    mergeSkin(skin, grow.load())
    mergeSkin(skin, judges.load())
    mergeSkin(skin, life.load())
    mergeSkin(skin, scoreGraph.load())
    mergeSkin(skin, judgeDetail.load())
    mergeSkin(skin, hispeed.load())
    mergeSkin(skin, bomb.load())
    mergeSkin(skin, loading.load())
    mergeSkin(skin, finish.load())
    mergeSkin(skin, fade.load())
    mergeSkin(skin, autoplay.load())
    if isDrawVisualizer1() then
        mergeSkin(skin, visualizer.load())
    end

    skin.destination = {}

    -- 各種出力
    mergeSkin(skin, bga.dst())
    if isDrawVisualizer1() then
        mergeSkin(skin, visualizer.dst())
    end
    mergeSkin(skin, progress.dst())
    mergeSkin(skin, sideInfo.dst())
    mergeSkin(skin, hispeed.dst())
    mergeSkin(skin, lanes.dst()) -- キービームとリフト, レーンカバーはここの中でmergeSkin
    mergeSkin(skin, grow.dst())
    mergeSkin(skin, bomb.dst())
    mergeSkin(skin, judges.dst())
    mergeSkin(skin, life.dst())
    mergeSkin(skin, scoreGraph.dst())
    mergeSkin(skin, judgeDetail.dst())
    mergeSkin(skin, autoplay.dst())
    mergeSkin(skin, loading.dst())
    mergeSkin(skin, finish.dst())
    mergeSkin(skin, fade.dst())
    return skin
end

return {
    header = header,
    main = main
}