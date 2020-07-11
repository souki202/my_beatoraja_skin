require("modules.commons.define")
local lanes = require("modules.play.lanes")

local header = {
    type = 0,
    name = "Social Skin" .. (DEBUG and " play dev" or ""),
    w = WIDTH,
    h = HEIGHT,
    playstart = 1000,
    scene = 36000000,
    input = 500,
    close = 1500,
    fadeout = 1000,

    property = { -- 使用済み 970まで
        {
            name = "プレイ位置", item = {{name = "1P", op = 900}, {name = "2P", op = 901}, {name = "center", op = 902}}, def = "1P"
        },
        {
            name = "ターンテーブル位置", item = {{name = "通常", op = 950}, {name = "反転", op = 951}}, def = "通常"
        },
        {
            name = "コンボ位置", item = {{name = "判定横", op = 970}, {name = "判定下", op = 971}, {name = "レーン右上(1P), 左上(2P)", op = 973}}, def = "判定横"
        },
        {
            name = "EARLY, LATE表示", item = {{name = "OFF", op = 905}, {name = "EARLY/LATE", op = 906}, {name = "+-ms", op = 907}}, def = "EARLY/LATE"
        },
        {
            name = "レーン色分け", item = {{name = "ON", op = 910}, {name = "OFF", op = 911}}, def = "ON"
        },
        {
            name = "レーン区切り線", item = {{name = "ON", op = 915}, {name = "OFF", op = 916}}, def = "ON"
        },
        {
            name = "判定ライン", item = {{name = "ON", op = 920}, {name = "OFF", op = 921}}, def = "ON"
        },
        {
            name = "レーンのシンボル", item = {{name = "ON", op = 965}, {name = "OFF", op = 966}}, def = "ON"
        },
        {
            name = "キーフラッシュ長さ", item = {{name = "短め", op = 925}, {name = "普通", op = 926}, {name = "長め", op = 927}}, def = "普通"
        },
        {
            name = "キーフラッシュ表示時間", item = {{name = "短め", op = 930}, {name = "普通", op = 931}, {name = "長め", op = 932}}, def = "普通"
        },
        {
            name = "後方キーフラッシュ", item = {{name = "ON", op = 935}, {name = "OFF", op = 936}}, def = "ON"
        },
        {
            name = "BGA枠", item = {{name = "16:9", op = 940}, {name = "横の領域全体", op = 941}, {name = "画面全体", op = 942}}, def = "横の領域全体"
        },
        {
            name = "黒帯部分のBGA表示", item = {{name = "ON", op = 945}, {name = "OFF", op = 946}}, def = "ON"
        },
        { -- 961まで使用
            name = "難易度毎の色変化", item = {{name = "あり", op = 955}, {name = "灰固定", op = 956}, {name = "緑固定", op = 957}, {name = "青固定", op = 958}, {name = "橙固定", op = 959}, {name = "赤固定", op = 960}, {name = "紫固定", op = 961}}, def = "あり"
        },
    },
    filepath = {
        {name = "ノーツ画像", path = "../play/parts/notes/*.png", def = "default"},
        {name = "レーンのシンボル(白鍵)", path = "../play/parts/lanesymbols/white/*.png", def = "dia"},
        {name = "レーンのシンボル(青鍵)", path = "../play/parts/lanesymbols/blue/*.png", def = "square"},
        {name = "レーンのシンボル(ターンテーブル)", path = "../play/parts/lanesymbols/turntable/*.png", def = "circle"},
        {name = "判定画像", path = "../play/parts/judges/*.png", def = "default"},
        {name = "コンボ画像", path = "../play/parts/combo/*.png", def = "default"},
    },
    offset = {
        {name = "各種オフセット(0で既定値)---------", x = 0},
        {name = "判定線の高さ(既定値 4px)", h = 0}
    }
}

local function main()
    local skin = {}
	-- ヘッダ情報をスキン本体にコピー
	for k, v in pairs(header) do
		skin[k] = v
    end

    globalInitialize(skin)

    skin.source = {
        {id = 0, path = "../play/parts/parts.png"},
        {id = 1, path = "../play/parts/notes/*.png"},
        {id = 2, path = "../play/parts/lanesymbols/white/*.png"},
        {id = 3, path = "../play/parts/lanesymbols/blue/*.png"},
        {id = 4, path = "../play/parts/lanesymbols/turntable/*.png"},
        {id = 5, path = "../play/parts/judges/*.png"},
        {id = 6, path = "../play/parts/combo/*.png"},
        {id = 999, path = "../commON/colors/colors.png"}
    }

    skin.image = {
        {id = "blank", src = 999, x = 0, y = 0, w = 1, h = 1},
        {id = "black", src = 999, x = 1, y = 0, w = 1, h = 1},
        {id = "white", src = 999, x = 2, y = 0, w = 1, h = 1},
    }

    -- 数字を作成するのは面倒なので, 一部は文字化して対処


    skin.font = {
		{id = 0, path = "../commON/fONts/SourceHanSans-Regular.otf"},
    }
    

    -- 各種読み込み
    mergeSkin(skin, lanes.load())

    skin.destination = {}

    -- 各種出力
    mergeSkin(skin, lanes.dst())
    return skin
end

return {
    header = header,
    main = main
}