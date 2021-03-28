local categoryBase = require("modules.commons.category_base")

local options = categoryBase.createInstance()

options.property = { -- 使用済み 10225まで
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
        name = "汎用BGA形式", item = {{name = "png", op = 10025}, {name = "mp4", op = 10026}}, def = "mp4"
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
        name = "ターゲットスコアのレート変動(ログ出力有効時)", item = {{name = "一定", op = 10110}, {name = "自己べ連動", op = 10111}, {name = "CPU風", op = 10112}}, def = "一定"
    },
    {
        name = "サイド部分のグラフ", item = {{name = "無し", op = 10000}, {name = "判定分布", op = 10001}, {name = "EARLY, LATE分布", op = 10002}}, def = "判定分布"
    },
    { -- 961まで使用
        name = "難易度毎の色変化", item = {{name = "あり", op = 955}, {name = "灰固定", op = 956}, {name = "緑固定", op = 957}, {name = "青固定", op = 958}, {name = "橙固定", op = 959}, {name = "赤固定", op = 960}, {name = "紫固定", op = 961}}, def = "紫固定"
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
    -- {
    --     name = "グルーヴゲージ位置", item = {{name = "レーン下", op = 10100}, {name = "レーン左右", op = 10101}}, def = "レーン下"
    -- },
    {
        name = "ゲージ100%時のキラキラ", item = {{name = "ON", op = 10070}, {name = "OFF", op = 10071}}, def = "ON"
    },
    {
        name = "カスタムゲージの表示", item = {{name = "ON", op = 10170}, {name = "OFF", op = 10171}}, def = "OFF"
    },
    {
        name = "カスタムゲージの位置", item = {{name = "上", op = 10225}, {name = "下", op = 10226}}, def = "下"
    },
    {
        name = "カスタムゲージのゲージオートシフト", item = {{name = "無し", op = 10175}, {name = "SURVIVAL TO GROOVE", op = 10176}, {name = "BEST CLEAR", op = 10177}, {name = "SELECT TO UNDER", op = 10178}}, def = "無し"
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
    -- {
    --     name = "レーンのシンボル", item = {{name = "ON", op = 965}, {name = "OFF", op = 966}}, def = "ON"
    -- },
    {
        name = "グロー表示", item = {{name = "ON", op = 10135}, {name = "OFF", op = 10136}}, def = "ON"
    },
    {
        name = "判定ライン", item = {{name = "ON", op = 920}, {name = "OFF", op = 921}}, def = "ON"
    },
    {
        name = "レーンサイドの画像変化", item = {{name = "無し", op = 10115}, {name = "ゲージ状態毎", op = 10116}}, def = "ゲージ状態毎"
    },
    {
        name = "レーンサイドを難易度毎の色変化に合わせる", item = {{name = "ON", op = 10120}, {name = "OFF", op = 10121}}, def = "OFF"
    },
    {
        name = "判定ライン(Layer1)を難易度毎の色変化に合わせる", item = {{name = "ON", op = 10125}, {name = "OFF", op = 10126}}, def = "OFF"
    },
    {
        name = "判定ライン(Layer2)を難易度毎の色変化に合わせる", item = {{name = "ON", op = 10130}, {name = "OFF", op = 10131}}, def = "OFF"
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
        name = "ボムのanimation1のプリセット", item = {{name = "無し", op = 10160}, {name = "SocialSkinボム", op = 10161}, {name = "OADXボム", op = 10162}}, def = "SocialSkinボム"
    },
    {
        name = "ボムのanimation2のプリセット", item = {{name = "無し", op = 10165}, {name = "SocialSkinボム", op = 10166}, {name = "OADXボム", op = 10167}}, def = "SocialSkinボム"
    },
    {
        name = "ボムのparticle1のアニメーション", item = {{name = "フロー", op = 10010}, {name = "拡散", op = 10011}, {name = "静止", op = 10012}}, def = "フロー"
    },
    {
        name = "ボムのparticle2のアニメーション", item = {{name = "フロー", op = 10015}, {name = "拡散", op = 10016}, {name = "静止", op = 10017}}, def = "フロー"
    },
    {
        name = "ボムのparticle1のアルファ変化", item = {{name = "ease in", op = 10140}, {name = "linear", op = 10141}, {name = "ease out", op = 10142}}, def = "ease in"
    },
    {
        name = "ボムのparticle2のアルファ変化", item = {{name = "ease in", op = 10145}, {name = "linear", op = 10146}, {name = "ease out", op = 10147}}, def = "ease in"
    },
    {
        name = "ボムのparticle1の座標変化", item = {{name = "ease in", op = 10150}, {name = "linear", op = 10151}, {name = "ease out", op = 10152}}, def = "ease out"
    },
    {
        name = "ボムのparticle2の座標変化", item = {{name = "ease in", op = 10155}, {name = "linear", op = 10156}, {name = "ease out", op = 10157}}, def = "ease out"
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
    {
        name = "楽曲詳細表示---------------------", item = {{name = "-", op = 19999}}
    },
    {
        name = "楽曲詳細表示", item = {{name = "ON", op = 10205}, {name = "OFF", op = 10206}}, def = "ON"
    },
    {
        name = "楽曲詳細のステージファイル位置", item = {{name = "右", op = 10210}, {name = "左", op = 10211}}, def = "左"
    },
    {
        name = "楽曲詳細のノーツグラフ種類", item = {{name = "ノーツ数分布", op = 10220}, {name = "判定分布", op = 10221}, {name = "EARLY/LATE分布(棒グラフ)", op = 10222}, {name = "タイミング可視化グラフ", op = 10223}, {name = "無し", op = 10224}}, def = "ノーツ数分布"
    },
    {
        name = "楽曲データベースの使用", item = {{name = "ON", op = 10215}, {name = "OFF", op = 10216}}, def = "ON"
    },
}

options.filepath = {
    {name = "各種画像--------------", path = "../dummy/*"},
    {name = "背景画像", path = "../play/parts/background/*.png", def = "default"},
    {name = "汎用画像(png)", path = "../play/parts/versatilitybga/*.png", def = "default"},
    {name = "汎用画像(mp4)", path = "../play/parts/versatilitybga/*.mp4", def = "default"},
    {name = "BGAフレーム(横上部)", path = "../play/parts/bga/frame/normal/*.png", def = "default"},
    {name = "BGAフレーム(横全体)", path = "../play/parts/bga/frame/large/*.png", def = "blank"},
    {name = "BGAフレーム(全画面)", path = "../play/parts/bga/frame/full/*.png", def = "blank"},
    {name = "黒帯部分BGAのマスク", path = "../play/parts/bga/mask/*.png", def = "default"},
    {name = "タイトル部分フレーム", path = "../play/parts/title/frame/*.png", def = "simple"},
    {name = "楽曲詳細情報のステージファイルのnoimage画像", path = "../play/parts/detail/noimage/*.png", def = "default"},
    {name = "楽曲詳細情報フレーム", path = "../play/parts/detail/frame/*.png", def = "blank"},
    {name = "楽曲詳細情報ステージファイルフレーム", path = "../play/parts/detail/stagefileframe/*.png", def = "blank"},
    {name = "楽曲詳細情報背景", path = "../play/parts/detail/bg/*.png", def = "blank"},
    {name = "レーン部分全般--------------", path = "../dummy/*"},
    {name = "ノート画像(通常形式)", path = "../play/parts/lane/notes/normal/*.png", def = "default"},
    {name = "ノート画像(独自形式)", path = "../play/parts/lane/notes/original/*.png", def = "default"},
    {name = "レーンサイド", path = "../play/parts/lane/laneside/*.png", def = "default"},
    {name = "レーンサイド(ゲージ状態毎 nogood)"  , path = "../play/parts/lane/laneside/state/nogood/*.png", def = "default"},
    {name = "レーンサイド(ゲージ状態毎 nomiss)"  , path = "../play/parts/lane/laneside/state/nomiss/*.png", def = "default"},
    {name = "レーンサイド(ゲージ状態毎 survival)", path = "../play/parts/lane/laneside/state/survival/*.png", def = "default"},
    {name = "レーンサイド(ゲージ状態毎 clear)"   , path = "../play/parts/lane/laneside/state/clear/*.png", def = "default"},
    {name = "レーンサイド(ゲージ状態毎 fail)"    , path = "../play/parts/lane/laneside/state/fail/*.png", def = "default"},
    {name = "判定ライン(Layer1)", path = "../play/parts/lane/judgeline/layer1/*.png", def = "default"},
    {name = "判定ライン(Layer2)", path = "../play/parts/lane/judgeline/layer2/*.png", def = "default"},
    {name = "レーンカバー", path = "../play/parts/lane/lanecover/*.png", def = "default"},
    {name = "リフトカバー", path = "../play/parts/lane/liftcover/*.png", def = "default"},
    {name = "判定画像", path = "../play/parts/judges/*.png", def = "default"},
    {name = "判定画像(EARLY)", path = "../play/parts/judges/early/*.png", def = "text"},
    {name = "判定画像(LATE)", path = "../play/parts/judges/late/*.png", def = "text"},
    {name = "コンボ画像", path = "../play/parts/combo/*.png", def = "default"},
    {name = "グルーヴゲージのフレーム", path = "../play/parts/groove/frame/*.png", def = "default"},
    {name = "グルーヴゲージの種類の文字", path = "../play/parts/groove/types/*.png", def = "default"},
    {name = "グルーヴゲージのインディケーター", path = "../play/parts/groove/indicators/*.png", def = "default"},
    {name = "EXSCOREの文字", path = "../play/parts/exscore/label/*.png", def = "default"},
    {name = "ボム関連画像---------", path = "../dummy/*"},
    {name = "wave1", path = "../play/parts/bombs/wave1/*.png", def = "blank"},
    {name = "particle1", path = "../play/parts/bombs/particle1/*.png", def = "blank"},
    {name = "animation1", path = "../play/parts/bombs/animation1/*.png", def = "default"},
    {name = "wave2", path = "../play/parts/bombs/wave2/*.png", def = "blank"},
    {name = "particle2", path = "../play/parts/bombs/particle2/*.png", def = "blank"},
    {name = "animation2", path = "../play/parts/bombs/animation2/*.png", def = "blank"},
    {name = "animation1(placeholder)", path = "../dummy/*"},
}

options.offset = {
    {name = "各種オフセット(0で既定値)---------", x = 0},
    -- {name = "判定線の高さ(既定値 4px)", h = 0},
    {name = "レーンの黒背景(255で透明)", a = 0},
    {name = "グルーブゲージの通知エフェクトの大きさ差分(%)", y = 0},
    {name = "ゲージ100%時のキラキラの数(既定値20)", x = 0},
    {name = "レーンサイドの1ループのアニメーション時間(単位拍子 既定値8 -1でアニメーションなし)", x = 0},
    {name = "楽曲詳細情報のステージファイルオフセット", x = 0, y = 0, w = 0, h = 0, id = 42},

    {name = "スコアログ周り------------------", x = 0},
    {name = "スコアレートのサンプルノーツ数(既定値50)", x = 0},
    {name = "スコアレートのサンプル取得の最大時間(単位秒 既定値10)", x = 0},

    {name = "キービーム関連------------------------", x = 0},
    {name = "キービームの透明度(既定値64 255で透明)", a = 0},
    {name = "白鍵キービームの明るさ(単位% 既定値100)", x = 0},
    {name = "白鍵キービームの彩度(単位% 既定値30)", x = 0},
    {name = "青鍵キービームの明るさ(単位% 既定値100)", x = 0},
    {name = "青鍵キービームの彩度(単位% 既定値60)", x = 0},

    {name = "カスタムゲージ関連(9999か-9999で増減0)-----------", x = 0},
    {name = "AEASY-------------------------", x = 0},
    {name = "カスタムゲージAEASY PG増加率 (% 既定値140)", x = 0},
    {name = "カスタムゲージAEASY GR増加率 (% 既定値140)", x = 0},
    {name = "カスタムゲージAEASY GD増加率 (% 既定値70)", x = 0},
    {name = "カスタムゲージAEASY BD増加量 (0.1% 既定値-28)", x = 0},
    {name = "カスタムゲージAEASY PR増加量 (0.1% 既定値-40)", x = 0},
    {name = "カスタムゲージAEASY MS増加量 (0.1% 既定値-12)", x = 0},

    {name = "EASY-------------------------", x = 0},
    {name = "カスタムゲージEASY PG増加率 (% 既定値120)", x = 0},
    {name = "カスタムゲージEASY GR増加率 (% 既定値120)", x = 0},
    {name = "カスタムゲージEASY GD増加率 (% 既定値60)", x = 0},
    {name = "カスタムゲージEASY BD増加量 (0.1% 既定値-32)", x = 0},
    {name = "カスタムゲージEASY PR増加量 (0.1% 既定値-48)", x = 0},
    {name = "カスタムゲージEASY MS増加量 (0.1% 既定値-16)", x = 0},

    {name = "NORMAL-------------------------", x = 0},
    {name = "カスタムゲージNORMAL PG増加率 (% 既定値100)", x = 0},
    {name = "カスタムゲージNORMAL GR増加率 (% 既定値100)", x = 0},
    {name = "カスタムゲージNORMAL GD増加率 (% 既定値50)", x = 0},
    {name = "カスタムゲージNORMAL BD増加量 (0.1% 既定値-40)", x = 0},
    {name = "カスタムゲージNORMAL PR増加量 (0.1% 既定値-60)", x = 0},
    {name = "カスタムゲージNORMAL MS増加量 (0.1% 既定値-20)", x = 0},

    {name = "HARD-------------------------", x = 0},
    {name = "カスタムゲージHARD PG増加量 (0.01% 既定値10)", x = 0},
    {name = "カスタムゲージHARD GR増加量 (0.01% 既定値10)", x = 0},
    {name = "カスタムゲージHARD GD増加量 (0.01% 既定値5)", x = 0},
    {name = "カスタムゲージHARD BD増加量 (0.1% 既定値-60)", x = 0},
    {name = "カスタムゲージHARD PR増加量 (0.1% 既定値-100)", x = 0},
    {name = "カスタムゲージHARD MS増加量 (0.1% 既定値-20)", x = 0},
    {name = "カスタムゲージHARD 30%補正時の減少量倍率 (% 既定値60)", x = 0},

    {name = "EXHARD-------------------------", x = 0},
    {name = "カスタムゲージEXHARD PG増加量 (0.01% 既定値10)", x = 0},
    {name = "カスタムゲージEXHARD GR増加量 (0.01% 既定値10)", x = 0},
    {name = "カスタムゲージEXHARD GD増加量 (0.01% 既定値5)", x = 0},
    {name = "カスタムゲージEXHARD BD増加量 (0.1% 既定値-120)", x = 0},
    {name = "カスタムゲージEXHARD PR増加量 (0.1% 既定値-200)", x = 0},
    {name = "カスタムゲージEXHARD MS増加量 (0.1% 既定値-120)", x = 0},
    {name = "カスタムゲージEXHARD 30%補正時の減少量倍率 (% 既定値60)", x = 0},
    -- 段位ゲージは次の曲に継承する機能を用意していないので未実装

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

    {name = "ボムアニメーション関連(プリセット設定時は無視)-------------", x = 0},
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

    {name = "ボムのanimation1のプリセット(placeholder)", x = 0},
}

options.category = {
    {
        name = "プレイサイド",
        myItems = {"プレイ位置", "ターンテーブル位置"}
    },
    {
        name = "BGA",
        myItems = {"汎用BGA形式", "汎用画像(png)", "汎用画像(mp4)", "BGA枠", "BGAフレーム(横上部)", "BGAフレーム(横全体)", "BGAフレーム(全画面)", "黒帯部分のBGA表示", "黒帯部分BGAのマスク", "黒帯部分のBGA表示のぼかし"}
    },
    {
        name = "判定表示",
        myItems = {"判定画像分類", "EARLY, LATE表示", "判定画像", "判定画像(EARLY)", "判定画像(LATE)", "低速時のEARLY, LATE位置変更基準", "BPM変化の判定基準"}
    },
    {
        name = "コンボ",
        myItems = {"コンボ位置", "コンボ画像"},
    },
    {
        name = "スコア差表示",
        myItems = {"スコア差表示", "スコア差表示位置"},
    },
    {
        name = "スコア",
        myItems = {"EXSCOREの文字", "ターゲットスコアのレート変動(ログ出力有効時)", "スコアレートのサンプルノーツ数(既定値50)", "スコアレートのサンプル取得の最大時間(単位秒 既定値10)"}
    },
    {
        name = "プログレスバー",
        myItems = {"サイド部分のグラフ"}
    },
    {
        name = "ノート",
        myItems = {"ノート画像(通常形式)"}
    },
    {
        name = "グルーヴゲージ",
        myItems = {"グルーヴゲージのフレーム", "グルーヴゲージの種類の文字", "グルーヴゲージのインディケーター", "グルーヴゲージ隠し", "グルーヴゲージの通知エフェクトの基準", "グルーブゲージの通知エフェクトの大きさ差分(%)", "ゲージ100%時のキラキラ", "ゲージ100%時のキラキラの数(既定値20)"}
    },
    {
        name = "カスタムグルーヴゲージ",
        myItems = {"カスタムゲージの表示", "カスタムゲージの位置", "カスタムゲージのゲージオートシフト"}
    },
    {
        name = "カスタムグルーヴゲージ増減設定(9999か-9999で増減0)",
        myItems = {
            "AEASY-------------------------",
            "カスタムゲージAEASY PG増加率 (% 既定値140)",
            "カスタムゲージAEASY GR増加率 (% 既定値140)",
            "カスタムゲージAEASY GD増加率 (% 既定値70)",
            "カスタムゲージAEASY BD増加量 (0.1% 既定値-28)",
            "カスタムゲージAEASY PR増加量 (0.1% 既定値-40)",
            "カスタムゲージAEASY MS増加量 (0.1% 既定値-12)",
            "EASY-------------------------",
            "カスタムゲージEASY PG増加率 (% 既定値120)",
            "カスタムゲージEASY GR増加率 (% 既定値120)",
            "カスタムゲージEASY GD増加率 (% 既定値60)",
            "カスタムゲージEASY BD増加量 (0.1% 既定値-32)",
            "カスタムゲージEASY PR増加量 (0.1% 既定値-48)",
            "カスタムゲージEASY MS増加量 (0.1% 既定値-16)",
            "NORMAL-------------------------",
            "カスタムゲージNORMAL PG増加率 (% 既定値100)",
            "カスタムゲージNORMAL GR増加率 (% 既定値100)",
            "カスタムゲージNORMAL GD増加率 (% 既定値50)",
            "カスタムゲージNORMAL BD増加量 (0.1% 既定値-40)",
            "カスタムゲージNORMAL PR増加量 (0.1% 既定値-60)",
            "カスタムゲージNORMAL MS増加量 (0.1% 既定値-20)",
            "HARD-------------------------",
            "カスタムゲージHARD PG増加量 (0.01% 既定値10)",
            "カスタムゲージHARD GR増加量 (0.01% 既定値10)",
            "カスタムゲージHARD GD増加量 (0.01% 既定値5)",
            "カスタムゲージHARD BD増加量 (0.1% 既定値-60)",
            "カスタムゲージHARD PR増加量 (0.1% 既定値-100)",
            "カスタムゲージHARD MS増加量 (0.1% 既定値-20)",
            "カスタムゲージHARD 30%補正時の減少量倍率 (% 既定値60)",
            "EXHARD-------------------------",
            "カスタムゲージEXHARD PG増加量 (0.01% 既定値10)",
            "カスタムゲージEXHARD GR増加量 (0.01% 既定値10)",
            "カスタムゲージEXHARD GD増加量 (0.01% 既定値5)",
            "カスタムゲージEXHARD BD増加量 (0.1% 既定値-120)",
            "カスタムゲージEXHARD PR増加量 (0.1% 既定値-200)",
            "カスタムゲージEXHARD MS増加量 (0.1% 既定値-120)",
            "カスタムゲージEXHARD 30%補正時の減少量倍率 (% 既定値60)",
        }
    },
    {
        name = "レーン",
        myItems = {
            "レーン色分け", "レーン区切り線", "レーンの黒背景(255で透明)", "レーンサイドの画像変化", "レーンサイドを難易度毎の色変化に合わせる", "レーンサイド",
            "レーンサイド(ゲージ状態毎 nogood)",
            "レーンサイド(ゲージ状態毎 nomiss)",
            "レーンサイド(ゲージ状態毎 survival)",
            "レーンサイド(ゲージ状態毎 clear)",
            "レーンサイド(ゲージ状態毎 fail)",
            "レーンサイドの1ループのアニメーション時間(単位拍子 既定値8 -1でアニメーションなし)",
        }
    },
    {
        name = "レーン, リフトカバー",
        myItems = {"レーンカバー", "リフトカバー"}
    },
    {
        name = "判定ライン",
        myItems = {
            "グロー表示", "判定ライン", "判定ライン(Layer1)", "判定ライン(Layer2)",
            "判定ライン(Layer1)を難易度毎の色変化に合わせる", "判定ライン(Layer2)を難易度毎の色変化に合わせる"
        }
    },
    {
        name = "キービーム",
        myItems = {
            "キービーム長さ", "キービーム出現時間", "キービーム消失時間", "キービーム出現アニメーション", "キービーム消失アニメーション", "後方キービーム",
            "キービームの透明度(既定値64 255で透明)", "白鍵キービームの明るさ(単位% 既定値100)", "白鍵キービームの彩度(単位% 既定値30)", "青鍵キービームの明るさ(単位% 既定値100)", "青鍵キービームの彩度(単位% 既定値60)"
        }
    },
    {
        name = "ボム",
        myItems = {"ボムのanimation1のプリセット", "animation1"}
    },
    {
        name = "ボム(その他詳細設定 倍率は100%からの差分)",
        myItems = {
            "ボムのパーティクル",
            "ボムのanimation1と2の黒背景透過",
            "100%の描画縦横はwave 500px, anim 300px, particle 16px", "倍率差分は, -100で0%相当, 100で200%相当",
            "ボムのanimation1のプリセット(placeholder)", "animation1(placeholder)", "ボムのanimation1の大きさ倍率(単位%)", "ボムのanimation1の画像分割数", "ボムのanimation1の描画時間(単位100ms 既定値3)", "ボムのanimation1の描画座標差分",
            "ボムのanimation2のプリセット", "animation2", "ボムのanimation2の大きさ倍率(単位%)", "ボムのanimation2の画像分割数", "ボムのanimation2の描画時間(単位100ms 既定値3)", "ボムのanimation2の描画座標差分",
            "ボムのparticle1のアニメーション", "particle1", "ボムのparticle1のアルファ変化", "ボムのparticle1の座標変化", "ボムのparticle1の大きさ倍率(単位%)", "ボムのparticle1の描画数(既定値7)", "ボムのparticle1の描画時間(単位100ms 既定値3)", "ボムのparticle1のフローの高さ倍率差分(単位%)", "ボムのparticle1の拡散の広さ倍率差分(単位%)", "ボムのparticle1の出現範囲倍率差分(単位%)",
            "ボムのparticle2のアニメーション", "particle2", "ボムのparticle2のアルファ変化", "ボムのparticle2の座標変化", "ボムのparticle2の大きさ倍率(単位%)", "ボムのparticle2の描画数(既定値7)", "ボムのparticle2の描画時間(単位100ms 既定値3)", "ボムのparticle2のフローの高さ倍率差分(単位%)", "ボムのparticle2の拡散の広さ倍率差分(単位%)", "ボムのparticle2の出現範囲倍率差分(単位%)",
            "wave1", "ボムのwave1の大きさ倍率(単位%)", "ボムのwave1の描画時間(単位100ms 既定値3)",
            "wave2", "ボムのwave2の大きさ倍率(単位%)", "ボムのwave2の描画時間(単位100ms 既定値3)",
        }
    },
    {
        name = "楽曲詳細表示",
        myItems = {
            "楽曲詳細表示", "楽曲詳細のステージファイル位置", "楽曲詳細情報のステージファイルオフセット", "楽曲詳細のノーツグラフ種類",
            "楽曲詳細情報フレーム", "楽曲詳細情報のステージファイルのnoimage画像", "楽曲詳細情報ステージファイルフレーム", "楽曲詳細情報背景",
            "楽曲データベースの使用"
        }
    },
    {
        name = "簡易タイトル (詳細表示時は非表示)",
        myItems = {"タイトル部分フレーム"}
    },
    {
        name = "ビジュアライザー",
        myItems = {
            "ビジュアライザー1", "ビジュアライザー1の棒線タイプ", "ビジュアライザー1の棒線の多さ", "ビジュアライザー1の山の出現位置", "ビジュアライザー1の奥側の反射", "ビジュアライザー1のバーの透明度(既定値64 255で透明)", "ビジュアライザー1の反射の透明度(既定値196 255で透明)",
        }
    },
    {
        name = "ノート(非推奨)",
        myItems = {"ノートの画像", "ノート画像(独自形式)"}
    },
    {
        name = "その他全般",
        myItems = {"背景画像", "リザルト用ログ出力", "難易度毎の色変化"}
    },
}

return options.functions