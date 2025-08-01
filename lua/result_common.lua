require("modules.commons.easing")
require("modules.commons.numbers")
require("modules.commons.my_window")
require("modules.result.commons")
local main_state = require("main_state")
local background = require("modules.result.background")
local resultObtained = require("modules.result.result_obtained")
local graphs = require("modules.result.graphs")
local ir = require("modules.result.ir")
local fade = require("modules.result.fade")
local userInfo = require("modules.result.user_info")

local INPUT_WAIT = 500 -- シーン開始から入力受付までの時間
local TEXTURE_SIZE = 2048

local STAGE_FILE = {
    X = 79,
    Y = 834,
    W = 256,
    H = 192,
}

local DEVIDING_LINE_BASE = {
    OFFSET_Y = -6,
    H = 2,
}

local TITLE_BAR = {
    WND = {
        X = 375,
        Y = 834,
        W = 1186,
        H = 94,
    },
    TITLE = {
        FONT_SIZE = 36,
        W = 1150,
        Y = 43,
    },

    ARTIST = {
        FONT_SIZE = 24,
        W = 482,
        X = 55, -- 左端
        Y = 7,
    },

    DEVIDING_LINE = {
        W = 1148,
        H = 2,
        X = 19,
        Y = 39,
    }
}

local DIR_BAR = {
    WND = {
        X = RIGHT_X,
        Y = 46,
        W = WND_WIDTH,
        H = 48,
    },
    TEXT = {
        X = 18,
        Y = 9,
        SIZE = 24,
        W = WND_WIDTH - 18*2
    },
}

-- 灰色背景の項目
local GRAY_ITEM = {
    W = 120,
    H = 20,
}

local DIFFICULTY_INFO = {
    WND = {
        X = 1591,
        Y = 834,
        W = 265,
        H = 94,
    },
    DIFFICULTY = {
        X = 25,
        Y = 44,
        NUM_OFFSET_X = 217, -- relative_xからの右端の距離
        NUM_OFFSET_Y = 1,
        DIGIT = 2,
    },
    TOTAL_NOTES = {
        X = 25,
        Y = 14,
        NUM_OFFSET_X = 217, -- relative_xからの右端の距離
        NUM_OFFSET_Y = 1,
        DIGIT = 5,
    },
    FLAGS = {
        PREFIX = {"undefined", "beginner", "normal", "hyper", "another", "insane"},
        X = -16,
        Y = 80,
        W = 196,
        H = 28,
    }
}

local SCORE = {
    WND = {
        X = LEFT_X,
        Y = 654,
        W = 650,
        H = 160,
    },
    SCORE_NUM_OFFSET_X = 347,
    RELATIVE_X = 26,
    NUM_OFFSET_X = 347,

    EXSCORE = {
        TEXT_W = 221,
        TEXT_H = 31,
        RELATIVE_Y = 111,

        NUM_W = 22,
        NUM_H = 30,
        DIGIT = 5,

        -- 相対座標
        P = {
            INT_X = 395,
            DECIMAL_X = 34, -- DOTからの差分 後でTEXTからの座標に再計算
            DOT_X = 1, -- INTからの差分 後でTEXTからの座標に再計算
            SYMBOL_X = 1, -- DECIMALからの差分 後でTEXTからの座標に再計算
        },
    },

    HISCORE = {
        RELATIVE_Y = 64,
        NUM_W = 20,
        NUM_H = 26,
        DIGIT = 5,
        DIFF = {
            X = 435
        }
    },

    TARGET = {
        RELATIVE_Y = 17,
        NUM_W = 20,
        NUM_H = 26,
        DIGIT = 5,
        DIFF = {
            X = 435
        }
    },

    DEVIDING_LINE = {
        W = 460,
        X = 18,
    }
}
SCORE.EXSCORE.P.DOT_X = SCORE.EXSCORE.P.INT_X + SCORE.EXSCORE.P.DOT_X
SCORE.EXSCORE.P.DECIMAL_X = SCORE.EXSCORE.P.DOT_X + SCORE.EXSCORE.P.DECIMAL_X
SCORE.EXSCORE.P.SYMBOL_X = SCORE.EXSCORE.P.DECIMAL_X + SCORE.EXSCORE.P.SYMBOL_X

local COMBO = {
    WND = {
        X = LEFT_X,
        Y = 474,
        W = 650,
        H = 160,
    },
    TEXT = {
        X = 26,
        Y = 114,
        INTERVAL_Y = -47,
    },

    DIGIT = 4,
    OLD_NUM = {
        X = 322, -- textからの相対座標
    },
    NOW_NUM = {
        X = 493,
    },
    DIFF_NUM = {
        X = 582,
    },
    ARROW_X = 359,
    DEVIDING_LINE = {
        W = 612,
        X = 18,
    },
    PREFIX = {"missCount", "combo", "comboBreak"}
}

local JUDGE = {
    WND = {
        X = LEFT_X,
        Y = 116,
        W = 650,
        H = 336,
    },

    DEVIDING_LINE = {
        X = 18,
        W = 612,
    },

    TEXT = {
        X = 32,
        Y = 266,
        W = 221,
        H = 31,
        INTERVAL_Y = -49,
    },

    EL_TEXT = {
        EX = 437,
        LX = 503,
        Y = 304,
        W = 55,
        H = 18,
    },

    NUM = {
        DIGIT = 4, -- コースリザルト時は5桁
        EL_DIGIT = 4,
        X = 340,
        EARLY_X = 458,
        LATE_X = 520,
    },
    SLASH = {
        X = 458,
        W = 7,
        H = 18,
    },

    PREFIX = {"perfect", "great", "good", "bad", "poor", "epoor"},
}

local LAMP = {
    WND = {
        X = 734,
        Y = 654,
        W = 290,
        H = 70,
    },
    TEXT = {
        X = 112,
        Y = 42,
        W = 67,
        H = 22,
    },
    OLD = {
        X = 26,
        Y = 11,
        W = 76,
        H = 18,
    },
    NOW = {
        X = 165,
        Y = 11,
        W = 111,
        H = 24,
    },

    ARROW = {
        X = 120,
        Y = 9,
    },
}

local TIMING = {
    WND = {
        X = 734,
        Y = 382,
        W = 290,
        H = 70,
    },

    TEXT_X = 25,
    STD_Y = 40,
    AVG_Y = 10,

    NUM = {
        X = 208,
        Y = 1,
        DIGIT = 3,
    },
    DOT_X = 1, -- NUMからの差分 後でTEXTからの座標に再計算
    NUM_AFTER_DOT = {
        X = 32, -- DOTからの差分 後でTEXTからの座標に再計算
        DIGIT = 2,
    },
}
TIMING.DOT_X = TIMING.NUM.X + TIMING.DOT_X
TIMING.NUM_AFTER_DOT.X = TIMING.DOT_X + TIMING.NUM_AFTER_DOT.X

local OPTIONS = {
    IMG = {
        X = 1201,
        Y = 516,
        W = 152,
        H = 22,
        -- OPS= {126, 127, 128, 129, 130, 131, 1128, 1129, 1130, 1131},
    }
}

local LARGE_LAMP = {
    SIZE = 71,
    PREFIX = {"failed", "aeasy", "laeasy", "easy", "normal", "hard", "exhard", "fullcombo", "perfect", "perfect"},
    LEN = {9, 17, 19, 11, 12, 12, 15, 12, 10, 10}, -- 空白込み
    POS = { -- 文字の左端部分の座標間隔と, 画像側の文字左端と文字領域左端の差 座標間隔の1文字目だけ絶対座標
        INIT_Y = 533,
        FAILED_START_DY = 200,
        AT_TOP_Y = 950,
        PERFECT = {759, 48, 45, 49, 42, 46, 49, 42, 27, 27},
        PERFECT_D = {10, 12, 10, 12, 12, 12, 12, 23, 23, 23},
        FULLCOMBO = {685, 45, 51, 42, 43, 47, 53, 62, 51, 53, 27, 27},
        FULLCOMBO_D = {11, 10, 16, 16, 12, 9, 3, 11, 9, 22, 22, 22},
        EXHARD = {652, 39, 50, 27, 48, 52, 49, 0, 70, 45, 42, 38, 53, 50, 26},
        EXHARD_D = {12, 8, 23, 8, 10, 12, 11, 0, 13, 17, 12, 9, 10, 23, 23},
        HARD = {710, 48, 52, 49, 0, 70, 45, 42, 38, 53, 50, 26},
        HARD_D = {11, 10, 10, 10, 0, 12, 16, 12, 9, 10, 23, 23},
        NORMAL = {708, 64, 49, 47, 26, 0, 64, 45, 42, 38, 53, 50},
        NORMAL_D = {4, 10, 11, 23, 11, 0, 12, 16, 12, 9, 10, 23},
        EASY = {735, 38, 50, 50, 0, 57, 45, 42, 38, 53, 50},
        EASY_D = {12, 8, 11, 17, 0, 12, 16, 12, 9, 10, 23},
        LAEASY = {581, 42, 20, 51, 44, 47, 22, 51, 0, 57, 38, 50, 50, 0, 57, 45, 42, 38, 53},
        LAEASY_D = {16, 23, 8, 10, 10, 23, 10, 14, 0, 12, 8, 11, 17, 0, 12, 16, 12, 9, 10},
        AEASY = {609, 51, 44, 47, 22, 51, 0, 57, 38, 50, 50, 0, 57, 45, 42, 38, 53},
        AEASY_D = {8, 10, 10, 23, 10, 14, 0, 12, 8, 11, 17, 0, 12, 16, 12, 9, 10},
        FAILED = {800, 36, 52, 24, 41, 44, 52, 23, 23},
        FAILED_D = {12, 8, 23, 16, 12, 10, 27, 27, 27},
    },
    ANIMATION = {
        START_TIME = 0,
        POP_DURATION = 250,
        END_POP = 500,
        TO_TOP_TIME = 800,
        AT_TOP_TIME = 1300,
        END_TIME = 1700,
        FAILED_DROP_ORDER = {},

        START_BRIGHT_ROOP = 4000,
        BRIGHT_ROOP_INTERVAL = 3000,

        INIT_SIZE_MUL = 5,
        INIT_DX_MUL = 3,

        TO_TOP_DIV = 20, -- 何msごとにするか AT_TOP_TIME - TO_TOP_TIMEを割り切れる値にする
        ROOP_BRIGHT_DIV = 20,
        BRIGHT_INTERVAL = 2, -- これ*TO_TOP_DIV が各文字の光る間隔
        BRIGHT_DURATION = 5, -- これ*TO_TOP_DIV が各文字の光だしから完全に光るまでの時間と,完全に光ってから消える時間
        MAX_BRIGHT = 255, -- 最大に輝いているときのアルファ
        ROOP_BRIGHT = 128, -- ループ時に輝いているときのアルファ
        WHITE_BG_ALPHA = 178,
    },
}

local RANKS = {
    X = SCORE.WND.X + 491,
    Y = 704,
    W = 150,
    H = 63,
    PREFIX = {"max", "aaa", "aa", "a", "b", "c", "d", "e", "f", "f"}, -- 最後のはスコア0

    ANIMATION = {
        START_TIME = LARGE_LAMP.ANIMATION.END_TIME + 300,
        GET_IN_TIME = 500, -- start timeからの差分
        SHINE_TIME = 585,
        DEL_SHINE_TIME = 700,
        RIPPLE_TIME = 750, -- 終了時刻
        BRIGHT_TIME = 1000,
        BRIGHT_TIME2 = 1125,
        DEL_CIRCLE_TIME = 800,
        DEL_CIRCLE_TIME2 = 1000,
        END_TIME = 1300,

        START_MUL = 6,
        RIPPLE_MUL = 1.33,
        DEL_SHINE_MUL = 0.9,
        CIRCLE_MUL = 2,
        CIRCLE_MUL2 = 2.1,

        BRIGHT_DURATION = 80,
    },

    SHINE = {
        X = 0, Y = 0, -- あとで計算
        W = 1024,
        H = 1024,
    }
}
RANKS.SHINE.X = RANKS.X + RANKS.W / 2 - RANKS.SHINE.W / 2
RANKS.SHINE.Y = RANKS.Y + RANKS.H / 2 - RANKS.SHINE.H / 2

local NEW_RECORD = {
    W = 183,
    H = 35,

    SCORE = {
        X = SCORE.WND.X + 310,
        Y = 796,
        OP = 330,
    },

    ANIMATION = {
        START_TIME = RANKS.ANIMATION.START_TIME + RANKS.ANIMATION.END_TIME + 300,
        POP_TOP_TIME = 150, -- start timeからの差分
        POP_BOTTOM_TIME = 500,
        END_TIME = 1000,
        SHINE_DURATION = 150,
        DUST_DURATION = 300, -- pop timeからの差分
        DUST_DEL = 500, -- pop timeからの差分

        BRIGHT_INTERVAL = 2500,
        BRIGHT_DURATION = 300,

        POP_Y = 10,
        POP_TOP_MUL = 1,
        SHINE_MUL = 0.5,
    },

    DUST = {
        SIZE = 39,
        N = 50,
        X_MUL = 2.5,
        DST_MIN_SIZE = 7,
        DST_MAX_SIZE = 15,
    }
}

local isCourseResult = false
local function setIsCourseResult(b)
    isCourseResult = b
end

local function setProperties(skin)
    table.insert(skin.property, {
        name = "各種グラフ グルーヴゲージ部分", item = {{name = "ノーツ数分布", op = 945}, {name = "判定分布", op = 946}, {name = "EARLY/LATE分布(棒グラフ)", op = 947}, {name = "無し", op = 949}}, def = "無し"
    })

    if isCourseResult then
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

function makeHeader()
    local header = {
        type = 7,
        name = "Social Skin" .. (DEBUG and " dev result" or ""),
        w = WIDTH,
        h = HEIGHT,
        fadeout = fade.getFadeOutTime(),
        scene = 3600000,
        input = INPUT_WAIT,
        -- 990まで使用
        property = {
            {
                name = "背景の分類", item = {{name = "クリアかどうか", op = 910}, {name = "ランク毎", op = 911}, {name = "クリアランプ毎", op = 912}}, def = "クリアかどうか"
            },
            {
                name = "レイアウト", item = {{name = "1", op = 915}, {name = "2", op = 916}}, def = "2"
            },
            {
                name = "スコア位置", item = {{name = "左", op = 920}, {name = "右", op = 921}}, def = "左"
            },
            {
                name = "スコアグラフ(プレイスキン併用時のみ)", item = {{name = "累積スコア", op = 965}, {name = "一定区間のレート", op = 966}}, def = "一定区間のレート"
            },
            {
                name = "スコアグラフ平滑化", item = {{name = "無し", op = 970}, {name = "単純移動平均(SMA)", op = 971}, {name = "指数移動平均(EMA)", op = 972}, {name = "平滑移動平均(SMMA)", op = 973}, {name = "線形加重移動平均(LWMA)", op = 974}}, def = "無し"
            },
            {
                name = "経験値等画面遷移", item = {{name = "右キー", op = 925}, {name = "左キー", op = 926}, {name = "決定ボタン(一定時間表示)", op = 927}, {name = "無し", op = 928}}, def = "右キー"
            },
            {
                name = "グルーヴゲージ部分のラベル位置", item = {{name = "下", op = 955}, {name = "上", op = 956}}, def = 955,
            },
            {
                name = "グルーヴゲージ部分のラベル表示", item = {{name = "ON", op = 950}, {name = "OFF", op = 951}}, def = "ON"
            },
            {
                name = "譜面オプションの表示", item = {{name = "ON", op = 960}, {name = "OFF", op = 961}}, def = "ON"
            },
            {
                name = "ランキングの自分の名前表記", item = {{name = "プレイヤー名", op = 975}, {name = "YOU", op = 976}}, def = "プレイヤー名"
            },
            {
                name = "ランキングの情報量", item = {{name = "多い", op = 980}, {name = "少ない", op = 981}}, def = "多い"
            },
            {
                name = "日時表示", item = {{name = "無し", op = 985}, {name = "日付のみ", op = 986}, {name = "日付+日時", op = 987}}, def = "日付+日時"
            },
            {
                name = "カスタムゲージの結果出力", item = {{name = "ON", op = 990}, {name = "OFF", op = 991}}, def = "OFF"
            },
        },
        filepath = {
            {name = "NoImage画像(png)", path = "../result/noimage/*.png", def = "default"},
            {name = "背景選択-----------------------------------------", path="../dummy/*"},
            {name = "CLEAR背景", path = "../result/background/isclear/clear/*", def = "flower-back0955"},
            {name = "FAILED背景", path = "../result/background/isclear/failed/*", def = "flower-back0589f"},
            {name = "背景選択2-----------------------------------------", path="../dummy/*"},
            {name = "AAA背景", path = "../result/background/ranks/aaa/*", def = "default"},
            {name = "AA背景" , path = "../result/background/ranks/aa/*", def = "default"},
            {name = "A背景"  , path = "../result/background/ranks/a/*", def = "default"},
            {name = "B背景"  , path = "../result/background/ranks/b/*", def = "default"},
            {name = "C背景"  , path = "../result/background/ranks/c/*", def = "default"},
            {name = "D背景"  , path = "../result/background/ranks/d/*", def = "default"},
            {name = "E背景"  , path = "../result/background/ranks/e/*", def = "default"},
            {name = "F背景"  , path = "../result/background/ranks/f/*", def = "default"},
            {name = "背景選択3-----------------------------------------", path="../dummy/*"},
            {name = "FAILED(ランプ毎)背景", path = "../result/background/lamps/failed/*", def = "default"},
            {name = "ASSIST EASY背景"    , path = "../result/background/lamps/aeasy/*", def = "default"},
            {name = "LASSIST EASY背景"   , path = "../result/background/lamps/laeasy/*", def = "default"},
            {name = "EASY背景"           , path = "../result/background/lamps/easy/*", def = "default"},
            {name = "NORMAL背景"         , path = "../result/background/lamps/normal/*", def = "default"},
            {name = "HARD背景"           , path = "../result/background/lamps/hard/*", def = "default"},
            {name = "EXHARD背景"         , path = "../result/background/lamps/exhard/*", def = "default"},
            {name = "FULLCOMBO背景"      , path = "../result/background/lamps/fullcombo/*", def = "default"},
            {name = "PERFECT背景"        , path = "../result/background/lamps/perfect/*", def = "default"},
        },
        offset = {
            {name = "経験値等画面表示秒数 (決定キーの場合, 最小1秒)", x = 0},
            {name = "グルーヴゲージ部分のノーツグラフの透明度 (255で透明)", a = 0},
            {name = "グルーヴゲージ部分のノーツグラフの高さ (既定値30 単位%)", h = 0},
            {name = "スコアグラフの1マスの高さ (既定値2)", h = 0},
            {name = "スコアグラフの細かさ (既定値2 1~5 小さいほど細かい)", w = 0},
            {name = "平滑化周り--------------------------", x = 0},
            {name = "単純移動平均の期間 (既定値7)", x = 0},
            {name = "指数移動平均の最新データの重視率 (既定値40 0<x<100)", x = 0},
            {name = "平滑移動平均 (既定値7)", x = 0},
            {name = "線形加重移動平均 (既定値7)", x = 0},
        },
    }
    setProperties(header)
    return header
end

local function initialize(skin)
    if isOldLayout() == false then
        LAMP.WND.X = LEFT_X + 360
        LAMP.WND.Y = 564
        COMBO.WND.Y = 384
        JUDGE.WND.Y = 26
        TIMING.WND.Y = 26
    end
    if is2P() then
        SCORE.WND.X = RIGHT_X
        COMBO.WND.X = RIGHT_X
        JUDGE.WND.X = RIGHT_X
        graphs.change2p()
        userInfo.change2p()
        DIR_BAR.WND.X = LEFT_X
        RANKS.X = SCORE.WND.X + 491
        NEW_RECORD.SCORE.X = SCORE.WND.X + 310
        -- ranking, lampは左右反転
        LAMP.WND.X = WIDTH - LAMP.WND.X - LAMP.WND.W
        TIMING.WND.X = WIDTH - TIMING.WND.X - TIMING.WND.W
    end

    -- failed向け
    do
        local order = LARGE_LAMP.ANIMATION.FAILED_DROP_ORDER
        for i = 1, LARGE_LAMP.LEN[LAMPS.FAILED] do
            order[#order+1] = i - 1
        end
        table.shuffle(order)
    end

    if isCourseResult then
        JUDGE.NUM.DIGIT = 5
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
        {id = 0, path = "../result/parts/parts.png"},
        {id = 1, path = "../result/parts/shine.png"},
        {id = 2, path = "../result/parts/shine_circle.png"},
        {id = 3, path = "../result/parts/largelamp/" .. LARGE_LAMP.PREFIX[CLEAR_TYPE] .. ".png"},
        {id = 4, path = "../result/parts/ranking/ranks.png"},
        {id = 5, path = "../result/parts/ranking/active.png"},
        {id = 6, path = "../result/parts/icons.png"},
        {id = 7, path = "../result/parts/groove/custom_gauge_bg.png"},
        -- {id = 8, path = "../generated/custom_groove/groove_xxx.png"},
        {id = 9, path = "../result/parts/graph_labels.png"},
        {id = 10, path = "../result/parts/lamps/lamp_bg.png"},
        {id = 11, path = "../result/parts/lamps/header.png"},
        {id = 12, path = "../result/parts/lamps/decoration.png"},
        {id = 20, path = "../result/noimage/*.png"},
        {id = 100, path = "../result/background/isclear/clear/*"},
        {id = 101, path = "../result/background/isclear/failed/*"},
        -- AAAからランク毎
        {id = 110, path = "../result/background/ranks/aaa/*"},
        {id = 111, path = "../result/background/ranks/aa/*"},
        {id = 112, path = "../result/background/ranks/a/*"},
        {id = 113, path = "../result/background/ranks/b/*"},
        {id = 114, path = "../result/background/ranks/c/*"},
        {id = 115, path = "../result/background/ranks/d/*"},
        {id = 116, path = "../result/background/ranks/e/*"},
        {id = 117, path = "../result/background/ranks/f/*"},
        -- {id = 118, path = "../result/background/ranks/f/*.png"},
        -- FAILEDからランプ毎
        {id = 120, path = "../result/background/lamps/failed/*"},
        {id = 121, path = "../result/background/lamps/aeasy/*"},
        {id = 122, path = "../result/background/lamps/laeasy/*"},
        {id = 123, path = "../result/background/lamps/easy/*"},
        {id = 124, path = "../result/background/lamps/normal/*"},
        {id = 125, path = "../result/background/lamps/hard/*"},
        {id = 126, path = "../result/background/lamps/exhard/*"},
        {id = 127, path = "../result/background/lamps/fullcombo/*"},
        {id = 128, path = "../result/background/lamps/perfect/*"},
        {id = 999, path = "../common/colors/colors.png"}
    }

    skin.image = {
        {id = "noImage", src = 20, x = 0, y = 0, w = -1, h = -1},

        {id = "grayItemBg", src = 0, x = 529, y = 0, w = GRAY_ITEM.W, h = GRAY_ITEM.H},
        {id = "percentageFor24Px", src = 0, x = 1848, y = 40, w = NUM_24PX.PERCENT.W, h = NUM_24PX.PERCENT.H},
        {id = "percentageFor24PxWhite", src = 0, x = 1848, y = 189, w = NUM_24PX.PERCENT.W, h = NUM_24PX.PERCENT.H},
        {id = "dotFor24Px", src = 0, x = 2034, y = 50, w = NUM_24PX.DOT_SIZE, h = NUM_24PX.DOT_SIZE},
        {id = "dotFor24PxWhite", src = 0, x = 2034, y = 199, w = NUM_24PX.DOT_SIZE, h = NUM_24PX.DOT_SIZE},
        {id = "changeArrow", src = 0, x = 0, y = 49, w = CHANGE_ARROW.W, h = CHANGE_ARROW.H},
        {id = "titleDevidingLine", src = 0, x = 0, y = TEXTURE_SIZE - 1, w = TITLE_BAR.DEVIDING_LINE.W, h = 1},
        {id = "scoreDevidingLine", src = 0, x = 0, y = TEXTURE_SIZE - 1, w = SCORE.DEVIDING_LINE.W, h = 1},
        {id = "comboDevidingLine", src = 0, x = 0, y = TEXTURE_SIZE - 1, w = SCORE.DEVIDING_LINE.W, h = 1},

        -- 難易度部分
        {id = "difficultyText", src = 0, x = 529, y = GRAY_ITEM.H*1, w = GRAY_ITEM.W, h = GRAY_ITEM.H},
        {id = "totalNotesText", src = 0, x = 529, y = GRAY_ITEM.H*2, w = GRAY_ITEM.W, h = GRAY_ITEM.H},
        {id = "standardText"  , src = 0, x = 529, y = GRAY_ITEM.H*3, w = GRAY_ITEM.W, h = GRAY_ITEM.H},
        {id = "averageText"   , src = 0, x = 529, y = GRAY_ITEM.H*4, w = GRAY_ITEM.W, h = GRAY_ITEM.H},

        -- スコア部分
        {id = "exScoreText"    , src = 0, x = 199, y = 0, w = SCORE.EXSCORE.TEXT_W, h = SCORE.EXSCORE.TEXT_H},
        {id = "hiScoreText"    , src = 0, x = VALUE_ITEM_TEXT.SRC_X, y = VALUE_ITEM_TEXT.SRC_Y + VALUE_ITEM_TEXT.H*0, w = VALUE_ITEM_TEXT.W, h = VALUE_ITEM_TEXT.H},
        {id = "targetScoreText", src = 0, x = VALUE_ITEM_TEXT.SRC_X, y = VALUE_ITEM_TEXT.SRC_Y + VALUE_ITEM_TEXT.H*1, w = VALUE_ITEM_TEXT.W, h = VALUE_ITEM_TEXT.H},
        {id = "missCountText"  , src = 0, x = VALUE_ITEM_TEXT.SRC_X, y = VALUE_ITEM_TEXT.SRC_Y + VALUE_ITEM_TEXT.H*2, w = VALUE_ITEM_TEXT.W, h = VALUE_ITEM_TEXT.H},
        {id = "comboText"      , src = 0, x = VALUE_ITEM_TEXT.SRC_X, y = VALUE_ITEM_TEXT.SRC_Y + VALUE_ITEM_TEXT.H*3, w = VALUE_ITEM_TEXT.W, h = VALUE_ITEM_TEXT.H},
        {id = "comboBreakText" , src = 0, x = VALUE_ITEM_TEXT.SRC_X, y = VALUE_ITEM_TEXT.SRC_Y + VALUE_ITEM_TEXT.H*4, w = VALUE_ITEM_TEXT.W, h = VALUE_ITEM_TEXT.H},

        -- 判定部分
        {id = "judgeSlash", src = 0, x = 1872, y = 36, w = JUDGE.SLASH.W, h = JUDGE.SLASH.H},
        {id = "earlyText", src = 0, x = VALUE_ITEM_TEXT.SRC_X, y = 396, w = JUDGE.EL_TEXT.W, h = JUDGE.EL_TEXT.H},
        {id = "lateText", src = 0, x = VALUE_ITEM_TEXT.SRC_X, y = 396 + JUDGE.EL_TEXT.H, w = JUDGE.EL_TEXT.W, h = JUDGE.EL_TEXT.H},

        -- ランプ
        {id = "lampText", src = 0, x = VALUE_ITEM_TEXT.SRC_X, y = 374, w = LAMP.TEXT.W, h = LAMP.TEXT.H},
        {id = "lampOld", src = 0, x = 845, y = 0, w = LAMP.OLD.W, h = LAMP.OLD.H * 11, len = 11, divy = 11, ref = 371},
        {id = "lampNow", src = 0, x = 845 + LAMP.OLD.W, y = 0, w = LAMP.NOW.W, h = LAMP.NOW.H * 11, len = 11, divy = 11, ref = 370},

        -- ランク
        {id = "rankShine", src = 1, x = 0, y = 0, w = RANKS.SHINE.W, h = RANKS.SHINE.H},
        {id = "rankShineCircle", src = 2, x = 0, y = 0, w = RANKS.SHINE.W, h = RANKS.SHINE.H},

        -- new record
        {id = "newRecordText", src = 0, x = 1032, y = 0, w = NEW_RECORD.W, h = NEW_RECORD.H},
        {id = "newRecordBrightText", src = 0, x = 1032, y = 0, w = NEW_RECORD.W, h = NEW_RECORD.H},
        {id = "newRecordDust", src = 0, x = 1215, y = 0, w = NEW_RECORD.DUST.SIZE, h = NEW_RECORD.DUST.SIZE},

        -- その他色
        {id = "blank", src = 999, x = 0, y = 0, w = 1, h = 1},
        {id = "black", src = 999, x = 1, y = 0, w = 1, h = 1},
        {id = "white", src = 999, x = 2, y = 0, w = 1, h = 1},
    }

    -- ウィンドウ読み込み
    loadBaseWindowResult(skin)

    -- 大クリアランプ読み込み
    for i = 1, LARGE_LAMP.LEN[CLEAR_TYPE] do
        table.insert(skin.image,
            {
                id = "largeLampText" .. i, src = 3,
                x = LARGE_LAMP.SIZE * (i - 1), y = LARGE_LAMP.SIZE * 1,
                w = LARGE_LAMP.SIZE, h = LARGE_LAMP.SIZE
            }
        )
        table.insert(skin.image,
            {
                id = "largeLampBrightText" .. i, src = 3,
                x = LARGE_LAMP.SIZE * (i - 1), y = LARGE_LAMP.SIZE * 0,
                w = LARGE_LAMP.SIZE, h = LARGE_LAMP.SIZE
            }
        )
        table.insert(skin.image, 
            {
                id = "largeLampShadowText" .. i, src = 3,
                x = LARGE_LAMP.SIZE * (i - 1), y = LARGE_LAMP.SIZE * 2,
                w = LARGE_LAMP.SIZE, h = LARGE_LAMP.SIZE
            }
        )
    end

    -- 難易度種別読み込み
    for i, text in ipairs(DIFFICULTY_INFO.FLAGS.PREFIX) do
        table.insert(skin.image, {
            id = text .. "Flag", src = 0, x = 649, y = DIFFICULTY_INFO.FLAGS.H * (i - 1), w = DIFFICULTY_INFO.FLAGS.W, h = DIFFICULTY_INFO.FLAGS.H
        })
    end

    -- 判定文字読み込み
    for i, text in ipairs(JUDGE.PREFIX) do
        table.insert(skin.image, {
            id = text .. "Text", src = 0, x = VALUE_ITEM_TEXT.SRC_X, y = 166 + JUDGE.TEXT.H * (i - 1), w = JUDGE.TEXT.W, h = JUDGE.TEXT.H
        })
    end

    -- rank読み込み
    for i, rank in ipairs(RANKS.PREFIX) do
        table.insert(skin.image, {
            id = rank .. "Text", src = 0, x = 49, y = RANKS.H * (i - 1), w = RANKS.W, h = RANKS.H
        })
        table.insert(skin.image, {
            id = rank .. "BrightText", src = 0, x = 49, y = RANKS.H * (i - 1 + 9), w = RANKS.W, h = RANKS.H
        })
    end

    skin.value = {
        {id = "difficultyValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 2, ref = 96, align = 0},
        {id = "totalNotesValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = DIFFICULTY_INFO.TOTAL_NOTES.DIGIT, ref = 106, align = 0},
        -- スコア部分
        {id = "exScoreValue"    , src = 0, x = 1784, y = 106, w = SCORE.EXSCORE.NUM_W*11, h = SCORE.EXSCORE.NUM_H, divx = 11, digit = SCORE.EXSCORE.DIGIT, ref = 71},
        {id = "hiScoreValue"    , src = 0, x = 1808, y = 80, w = SCORE.HISCORE.NUM_W*11, h = SCORE.HISCORE.NUM_H, divx = 11, digit = SCORE.HISCORE.DIGIT, ref = 170},
        {id = "targetScoreValue", src = 0, x = 1808, y = 80, w = SCORE.TARGET.NUM_W*11, h = SCORE.TARGET.NUM_H, divx = 11, digit = SCORE.TARGET.DIGIT, ref = 151},
        {id = "exScorePercentageValue"        , src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 3, ref = 102, align = 0},
        {id = "exScorePercentageValueAfterDot", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 2, ref = 103, align = 0, padding = 1},
        {id = "hiScoreDiffValue"    , src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = 0, w = NUM_24PX.W * 12, h = NUM_24PX.H*2, divx = 12, divy = 2, digit = SCORE.HISCORE.DIGIT, ref = 172, align = 1, zeropadding = 0},
        {id = "targetScoreDiffValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = 0, w = NUM_24PX.W * 12, h = NUM_24PX.H*2, divx = 12, divy = 2, digit = SCORE.TARGET.DIGIT, ref = 153, align = 1, zeropadding = 0},
        -- BP部分
        {id = "missCountValue"    , src = NUM_36PX.SRC, x = NUM_36PX.SRC_X, y = NUM_36PX.SRC_Y, w = NUM_36PX.W * 11, h = NUM_36PX.H, divx = 11, digit = COMBO.DIGIT, ref = 76, align = 0},
        {id = "missCountOldValue" , src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 11, h = NUM_24PX.H, divx = 11, digit = COMBO.DIGIT, ref = 176, align = 0},
        {id = "missCountDiffValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = 136           , w = NUM_24PX.W * 12, h = NUM_24PX.H*2, divx = 12, divy = 2, digit = COMBO.DIGIT+1, ref = 178, align = 1, zeropadding = 0},
        {id = "comboValue"        , src = NUM_36PX.SRC, x = NUM_36PX.SRC_X, y = NUM_36PX.SRC_Y, w = NUM_36PX.W * 11, h = NUM_36PX.H, divx = 11, digit = COMBO.DIGIT, ref = 75, align = 0},
        {id = "comboOldValue"     , src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 11, h = NUM_24PX.H, divx = 11, digit = COMBO.DIGIT, ref = 173, align = 0},
        {id = "comboDiffValue"    , src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = 0             , w = NUM_24PX.W * 12, h = NUM_24PX.H*2, divx = 12, divy = 2, digit = COMBO.DIGIT+1, ref = 175, align = 1, zeropadding = 0},
        {id = "comboBreakValue"   , src = NUM_36PX.SRC, x = NUM_36PX.SRC_X, y = NUM_36PX.SRC_Y, w = NUM_36PX.W * 11, h = NUM_36PX.H, divx = 11, digit = COMBO.DIGIT, ref = 425, align = 0},
        -- タイミング周り
        {id = "standardValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = TIMING.NUM.DIGIT, ref = 376, align = 0},
        {id = "standardValueAfterDot", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = TIMING.NUM_AFTER_DOT.DIGIT, ref = 377, align = 0, padding = 1},
        {id = "averageValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = TIMING.NUM.DIGIT, ref = 374, align = 0},
        {id = "averageValueAfterDot", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = TIMING.NUM_AFTER_DOT.DIGIT, ref = 375, align = 0, padding = 1},
    }

    -- 判定読み込み
    for i, text in ipairs(JUDGE.PREFIX) do
        local sumRef = 110 + (i - 1)
        local divRef = 410 + (i - 1) * 2
        if text == "epoor" then
            sumRef = 420
            divRef = 421
        end
        -- 合計
        table.insert(skin.value, {
            id = text .. "Value", src = NUM_36PX.SRC, x = NUM_36PX.SRC_X, y = NUM_36PX.SRC_Y, w = NUM_36PX.W * 11, h = NUM_36PX.H, divx = 11, digit = JUDGE.NUM.DIGIT,
            ref = sumRef, align = 0
        })
        -- early
        table.insert(skin.value, {
            id = text .. "EarlyValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 11, h = NUM_24PX.H, divx = 11, digit = JUDGE.NUM.EL_DIGIT, ref = divRef, align = 0
        })
        -- late
        table.insert(skin.value, {
            id = text .. "LateValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 11, h = NUM_24PX.H, divx = 11, digit = JUDGE.NUM.EL_DIGIT, ref = divRef + 1, align = 0
        })
    end

    skin.font = {
		{id = 0, path = "../common/fonts/SourceHanSans-Regular.otf"},
		-- {id = 0, path = "../common/fonts/mplus-2p-regular.ttf"},
	}

    skin.text = {
        {id = "title", font = 0, size = TITLE_BAR.TITLE.FONT_SIZE, ref = 12, align = 1, overflow = 1},
		{id = "artist", font = 0, size = TITLE_BAR.ARTIST.FONT_SIZE, ref = 14, align = 1, overflow = 1},
        {id = "subArtist", font = 0, size = TITLE_BAR.ARTIST.FONT_SIZE, ref = 15, align = 1, overflow = 1},
        {id = "tableName", font = 0, size = DIR_BAR.TEXT.SIZE, ref = 1003, align = 0, overflow = 1},
    }

    resultObtained.load(skin)
    mergeSkin(skin, background.load())
    mergeSkin(skin, graphs.load())
    mergeSkin(skin, ir.load())
    mergeSkin(skin, userInfo.load())

    skin.destination = {}

    mergeSkin(skin, background.dst())
    mergeSkin(skin, graphs.dst())
    mergeSkin(skin, ir.dst())
    mergeSkin(skin, userInfo.dst())

    -- noimage
    table.insert(skin.destination, {
        id = "noImage", op = {190}, stretch = 1, dst = {
            {x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H}
        }
    })
    -- stagefile
    table.insert(skin.destination, {
        id = -100, op = {191}, filter = 1, stretch = 1, dst = {
            {x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H}
        }
    })

    -- タイトル部分
    destinationStaticBaseWindowResult(skin, TITLE_BAR.WND.X, TITLE_BAR.WND.Y, TITLE_BAR.WND.W, TITLE_BAR.WND.H)
    table.insert(skin.destination, {
        id = "title", filter = 1, dst = {
            {x = TITLE_BAR.WND.X + TITLE_BAR.WND.W / 2, y = TITLE_BAR.WND.Y + TITLE_BAR.TITLE.Y, w = TITLE_BAR.TITLE.W, h = TITLE_BAR.TITLE.FONT_SIZE, r = 0, g = 0, b = 0}
        }
    })
    table.insert(skin.destination, {
        id = "artist", filter = 1, dst = {
            {x = TITLE_BAR.WND.X + TITLE_BAR.ARTIST.X + TITLE_BAR.ARTIST.W / 2, y = TITLE_BAR.WND.Y + TITLE_BAR.ARTIST.Y, w = TITLE_BAR.ARTIST.W, h = TITLE_BAR.ARTIST.FONT_SIZE, r = 0, g = 0, b = 0}
        }
    })
    table.insert(skin.destination, {
        id = "subArtist", filter = 1, dst = {
            {x = TITLE_BAR.WND.X + TITLE_BAR.ARTIST.X + TITLE_BAR.ARTIST.W / 2 + TITLE_BAR.WND.W / 2, y = TITLE_BAR.WND.Y + TITLE_BAR.ARTIST.Y, w = TITLE_BAR.ARTIST.W, h = TITLE_BAR.ARTIST.FONT_SIZE, r = 0, g = 0, b = 0}
        }
    })
    table.insert(skin.destination, {
        id = "titleDevidingLine", dst = {
            {
                x = TITLE_BAR.WND.X + TITLE_BAR.DEVIDING_LINE.X,
                y = TITLE_BAR.WND.Y + TITLE_BAR.DEVIDING_LINE.Y,
                w = TITLE_BAR.DEVIDING_LINE.W, h = DEVIDING_LINE_BASE.H,
            }
        }
    })
    -- フォルダ名
    destinationStaticBaseWindowResult(skin, DIR_BAR.WND.X, DIR_BAR.WND.Y, DIR_BAR.WND.W, DIR_BAR.WND.H)
    table.insert(skin.destination, {
        id = "tableName", dst = {
            {
                x = DIR_BAR.WND.X + DIR_BAR.TEXT.X, y = DIR_BAR.WND.Y + DIR_BAR.TEXT.Y,
                w = DIR_BAR.TEXT.W, h = DIR_BAR.TEXT.SIZE,
                r = 0, g = 0, b = 0
            }
        }
    })


    -- 難易度, ノーツ数部分
    destinationStaticBaseWindowResult(skin, DIFFICULTY_INFO.WND.X, DIFFICULTY_INFO.WND.Y, DIFFICULTY_INFO.WND.W, DIFFICULTY_INFO.WND.H)
    -- 難易度
    local difficultyTextX = DIFFICULTY_INFO.WND.X + DIFFICULTY_INFO.DIFFICULTY.X
    local difficultyTextY = DIFFICULTY_INFO.WND.Y + DIFFICULTY_INFO.DIFFICULTY.Y
    table.insert(skin.destination, {
        id = "grayItemBg", dst = {
            {
                x = difficultyTextX, y = difficultyTextY,
                w = GRAY_ITEM.W, h = GRAY_ITEM.H
            }
        }
    })
    table.insert(skin.destination, {
        id = "difficultyText", dst = {
            {
                x = difficultyTextX, y = difficultyTextY,
                w = GRAY_ITEM.W, h = GRAY_ITEM.H
            }
        }
    })
    table.insert(skin.destination, {
        id = "difficultyValue", dst = {
            {
                x = difficultyTextX + DIFFICULTY_INFO.DIFFICULTY.NUM_OFFSET_X - NUM_24PX.W * DIFFICULTY_INFO.DIFFICULTY.DIGIT,
                y = difficultyTextY + DIFFICULTY_INFO.DIFFICULTY.NUM_OFFSET_Y,
                w = NUM_24PX.W, h = NUM_24PX.H
            }
        }
    })
    -- ノーツ数
    local notesTextX = DIFFICULTY_INFO.WND.X + DIFFICULTY_INFO.TOTAL_NOTES.X
    local notesTextY = DIFFICULTY_INFO.WND.Y + DIFFICULTY_INFO.TOTAL_NOTES.Y
    table.insert(skin.destination, {
        id = "grayItemBg", dst = {
            {x = notesTextX, y = notesTextY, w = GRAY_ITEM.W, h = GRAY_ITEM.H}
        }
    })
    table.insert(skin.destination, {
        id = "totalNotesText", dst = {
            {x = notesTextX, y = notesTextY, w = GRAY_ITEM.W, h = GRAY_ITEM.H}
        }
    })
    table.insert(skin.destination, {
        id = "totalNotesValue", dst = {
            {
                x = notesTextX + DIFFICULTY_INFO.TOTAL_NOTES.NUM_OFFSET_X - NUM_24PX.W * DIFFICULTY_INFO.TOTAL_NOTES.DIGIT,
                y = notesTextY + DIFFICULTY_INFO.TOTAL_NOTES.NUM_OFFSET_Y,
                w = NUM_24PX.W, h = NUM_24PX.H
            }
        }
    })
    -- 難易度の旗
    local flagX = DIFFICULTY_INFO.WND.X + DIFFICULTY_INFO.FLAGS.X
    local flagY = DIFFICULTY_INFO.WND.Y + DIFFICULTY_INFO.FLAGS.Y
    local prefix = {"undefined", "beginner", "normal", "hyper", "another", "insane"}
    for i, text in ipairs(prefix) do
        table.insert(skin.destination, {
            id = text .. "Flag", op = {150 + (i - 1)}, dst = {
                {
                    x = flagX, y = flagY,
                    w = DIFFICULTY_INFO.FLAGS.W, h = DIFFICULTY_INFO.FLAGS.H
                }
            }
        })
    end

    -- スコア部分
    destinationStaticBaseWindowResult(skin, SCORE.WND.X, SCORE.WND.Y, SCORE.WND.W, SCORE.WND.H)
    local scoreTextX = SCORE.WND.X + SCORE.RELATIVE_X
    local scoreTextY = SCORE.WND.Y + SCORE.EXSCORE.RELATIVE_Y
    -- EXSCORE
    table.insert(skin.destination, {
        id = "exScoreText", dst = {
            {
                x = scoreTextX, y = scoreTextY,
                w = SCORE.EXSCORE.TEXT_W, h = SCORE.EXSCORE.TEXT_H
            }
        }
    })
    dstNumberRightJustify(skin, "exScoreValue", scoreTextX + SCORE.NUM_OFFSET_X, scoreTextY, SCORE.EXSCORE.NUM_W, SCORE.EXSCORE.NUM_H, SCORE.EXSCORE.DIGIT)
    dstNumberRightJustify(skin, "exScorePercentageValue",
        scoreTextX + SCORE.EXSCORE.P.INT_X,
        scoreTextY, NUM_24PX.W, NUM_24PX.H, 3
    )
    table.insert(skin.destination, {
        id = "dotFor24Px", dst = {
            {x = scoreTextX + SCORE.EXSCORE.P.DOT_X, y = scoreTextY, w = NUM_24PX.DOT_SIZE, h = NUM_24PX.DOT_SIZE}
        }
    })
    dstNumberRightJustify(skin, "exScorePercentageValueAfterDot",
        scoreTextX + SCORE.EXSCORE.P.DECIMAL_X,
        scoreTextY, NUM_24PX.W, NUM_24PX.H, 2
    )
    table.insert(skin.destination, {
        id = "percentageFor24Px", dst = {
            {x = scoreTextX + SCORE.EXSCORE.P.SYMBOL_X, y = scoreTextY, w = NUM_24PX.PERCENT.W, h = NUM_24PX.PERCENT.H}
        }
    })
    table.insert(skin.destination, {
        id = "scoreDevidingLine", dst = {
            {
                x = SCORE.WND.X + SCORE.DEVIDING_LINE.X, y = scoreTextY + DEVIDING_LINE_BASE.OFFSET_Y,
                w = SCORE.DEVIDING_LINE.W, h = DEVIDING_LINE_BASE.H
            }
        }
    })

    -- HISCORE
    local hiScoreY = SCORE.WND.Y + SCORE.HISCORE.RELATIVE_Y
    table.insert(skin.destination, {
        id = "hiScoreText", dst = {
            {
                x = scoreTextX, y = hiScoreY,
                w = VALUE_ITEM_TEXT.W, h = VALUE_ITEM_TEXT.H
            }
        }
    })
    dstNumberRightJustify(skin, "hiScoreValue", scoreTextX + SCORE.NUM_OFFSET_X, hiScoreY, SCORE.HISCORE.NUM_W, SCORE.HISCORE.NUM_H, SCORE.HISCORE.DIGIT)
    dstNumberRightJustify(skin, "hiScoreDiffValue", scoreTextX + SCORE.HISCORE.DIFF.X, hiScoreY, NUM_24PX.W, NUM_24PX.H, SCORE.HISCORE.DIGIT)
    table.insert(skin.destination, {
        id = "scoreDevidingLine", dst = {
            {
                x = SCORE.WND.X + SCORE.DEVIDING_LINE.X, y = hiScoreY + DEVIDING_LINE_BASE.OFFSET_Y,
                w = SCORE.DEVIDING_LINE.W, h = DEVIDING_LINE_BASE.H
            }
        }
    })
    -- target
    local targetTextY = SCORE.WND.Y + SCORE.TARGET.RELATIVE_Y
    table.insert(skin.destination, {
        id = "targetScoreText", dst = {
            {
                x = scoreTextX, y = targetTextY,
                w = VALUE_ITEM_TEXT.W, h = VALUE_ITEM_TEXT.H
            }
        }
    })
    dstNumberRightJustify(skin, "targetScoreValue"    , scoreTextX + SCORE.NUM_OFFSET_X, targetTextY, SCORE.TARGET.NUM_W, SCORE.TARGET.NUM_H, SCORE.TARGET.DIGIT)
    dstNumberRightJustify(skin, "targetScoreDiffValue", scoreTextX + SCORE.TARGET.DIFF.X, targetTextY, NUM_24PX.W, NUM_24PX.H, SCORE.TARGET.DIGIT)

    table.insert(skin.destination, {
        id = "scoreDevidingLine", dst = {
            {
                x = SCORE.WND.X + SCORE.DEVIDING_LINE.X, y = targetTextY + DEVIDING_LINE_BASE.OFFSET_Y,
                w = SCORE.DEVIDING_LINE.W, h = DEVIDING_LINE_BASE.H
            }
        }
    })

    -- BP等
    destinationStaticBaseWindowResult(skin, COMBO.WND.X, COMBO.WND.Y, COMBO.WND.W, COMBO.WND.H)
    for i, text in ipairs(COMBO.PREFIX) do
        local x = COMBO.WND.X + COMBO.TEXT.X
        local y = COMBO.WND.Y + COMBO.TEXT.Y + COMBO.TEXT.INTERVAL_Y * (i - 1)
        -- 文字部分
        table.insert(skin.destination, {
            id = text .. "Text", dst = {
                {
                    x = x, y = y, w = VALUE_ITEM_TEXT.W, h = VALUE_ITEM_TEXT.H
                }
            }
        })
        -- 今回の値
        dstNumberRightJustifyWithColor(skin, text .. "Value", x + COMBO.NOW_NUM.X, y, NUM_36PX.W, NUM_36PX.H, COMBO.DIGIT, 0, 0, 0)

        -- 古い数値と差分
        if text ~= "comboBreak" then
            -- 古い値
            dstNumberRightJustifyWithColor(skin, text .. "OldValue", x + COMBO.OLD_NUM.X, y, NUM_24PX.W, NUM_24PX.H, COMBO.DIGIT, 0, 0, 0)
            -- 矢印
            table.insert(skin.destination, {
                id = "changeArrow", dst = {
                    {
                        x = x + COMBO.ARROW_X, y = y, w = CHANGE_ARROW.W, h = CHANGE_ARROW.H
                    }
                }
            })
            -- 差分
            dstNumberRightJustify(skin, text .. "DiffValue", x + COMBO.DIFF_NUM.X, y, NUM_24PX.W, NUM_24PX.H, COMBO.DIGIT)
        end

        -- 区切り線
        table.insert(skin.destination, {
            id = "comboDevidingLine", dst = {
                {
                    x = COMBO.WND.X + COMBO.DEVIDING_LINE.X, y = y + DEVIDING_LINE_BASE.OFFSET_Y,
                    w = COMBO.DEVIDING_LINE.W, h = DEVIDING_LINE_BASE.H
                }
            }
        })
    end

    -- 各種判定
    destinationStaticBaseWindowResult(skin, JUDGE.WND.X, JUDGE.WND.Y, JUDGE.WND.W, JUDGE.WND.H)
    -- early lateの文字
    table.insert(skin.destination, {
        id = "earlyText", dst = {
            {x = JUDGE.WND.X + JUDGE.EL_TEXT.EX, y = JUDGE.WND.Y + JUDGE.EL_TEXT.Y, w = JUDGE.EL_TEXT.W, h = JUDGE.EL_TEXT.H}
        }
    })
    table.insert(skin.destination, {
        id = "lateText", dst = {
            {x = JUDGE.WND.X + JUDGE.EL_TEXT.LX, y = JUDGE.WND.Y + JUDGE.EL_TEXT.Y, w = JUDGE.EL_TEXT.W, h = JUDGE.EL_TEXT.H}
        }
    })
    for i, text in ipairs(JUDGE.PREFIX) do
        local x = JUDGE.WND.X + JUDGE.TEXT.X
        local y = JUDGE.WND.Y + JUDGE.TEXT.Y + JUDGE.TEXT.INTERVAL_Y * (i - 1)
        -- 文字部分
        table.insert(skin.destination, {
            id = text .. "Text", dst = {
                {x = x, y = y, w = JUDGE.TEXT.W, h = JUDGE.TEXT.H}
            }
        })
        -- 判定合計値
        dstNumberRightJustifyWithColor(skin, text .. "Value", x + JUDGE.NUM.X, y, NUM_36PX.W, NUM_36PX.H, JUDGE.NUM.DIGIT, 0, 0, 0)
        -- early late
        dstNumberRightJustify(skin, text .. "EarlyValue", x + JUDGE.NUM.EARLY_X, y, NUM_24PX.W, NUM_24PX.H, JUDGE.NUM.EL_DIGIT)
        dstNumberRightJustify(skin, text .. "LateValue" , x + JUDGE.NUM.LATE_X , y, NUM_24PX.W, NUM_24PX.H, JUDGE.NUM.EL_DIGIT)

        -- slash
        table.insert(skin.destination, {
            id = "judgeSlash", dst = {
                {
                    x = x + JUDGE.SLASH.X, y = y,
                    w = JUDGE.SLASH.W, h = JUDGE.SLASH.H
                }
            }
        })

        -- 区切り線
        table.insert(skin.destination, {
            id = "comboDevidingLine", dst = {
                {
                    x = JUDGE.WND.X + JUDGE.DEVIDING_LINE.X, y = y + DEVIDING_LINE_BASE.OFFSET_Y,
                    w = JUDGE.DEVIDING_LINE.W, h = DEVIDING_LINE_BASE.H
                }
            }
        })
    end

    -- lamp
    destinationStaticBaseWindowResult(skin, LAMP.WND.X, LAMP.WND.Y, LAMP.WND.W, LAMP.WND.H)
    table.insert(skin.destination, {
        id = "lampText", dst = {
            {x = LAMP.WND.X + LAMP.TEXT.X, y = LAMP.WND.Y + LAMP.TEXT.Y, w = LAMP.TEXT.W, h = LAMP.TEXT.H}
        }
    })
    table.insert(skin.destination, {
        id = "lampOld", dst = {
            {x = LAMP.WND.X + LAMP.OLD.X, y = LAMP.WND.Y + LAMP.OLD.Y, w = LAMP.OLD.W, h = LAMP.OLD.H}
        }
    })
    table.insert(skin.destination, {
        id = "changeArrow", dst = {
            {x = LAMP.WND.X + LAMP.ARROW.X, y = LAMP.WND.Y + LAMP.ARROW.Y, w = CHANGE_ARROW.W, h = CHANGE_ARROW.H}
        }
    })
    table.insert(skin.destination, {
        id = "lampNow", dst = {
            {x = LAMP.WND.X + LAMP.NOW.X, y = LAMP.WND.Y + LAMP.NOW.Y, w = LAMP.NOW.W, h = LAMP.NOW.H}
        }
    })

    -- タイミング部分
    destinationStaticBaseWindowResult(skin, TIMING.WND.X, TIMING.WND.Y, TIMING.WND.W, TIMING.WND.H)
    local stdX = TIMING.WND.X + TIMING.TEXT_X
    local stdY = TIMING.WND.Y + TIMING.STD_Y
    -- 標準偏差
    table.insert(skin.destination, {
        id = "grayItemBg", dst = {
            {x = stdX, y = stdY, w = GRAY_ITEM.W, h = GRAY_ITEM.H}
        }
    })
    table.insert(skin.destination, {
        id = "standardText", dst = {
            {x = stdX, y = stdY, w = GRAY_ITEM.W, h = GRAY_ITEM.H}
        }
    })
    dstNumberRightJustify(skin, "standardValue", stdX + TIMING.NUM.X, stdY + TIMING.NUM.Y, NUM_24PX.W, NUM_24PX.H, TIMING.NUM.DIGIT)
    table.insert(skin.destination, {
        id = "dotFor24Px", dst = {
            {x = stdX + TIMING.NUM.X, y = stdY, w = NUM_24PX.DOT_SIZE, h = NUM_24PX.DOT_SIZE}
        }
    })
    dstNumberRightJustify(skin, "standardValueAfterDot", stdX + TIMING.NUM_AFTER_DOT.X, stdY + TIMING.NUM.Y, NUM_24PX.W, NUM_24PX.H, TIMING.NUM_AFTER_DOT.DIGIT)
    -- 平均
    local avgX = TIMING.WND.X + TIMING.TEXT_X
    local avgY = TIMING.WND.Y + TIMING.AVG_Y
    table.insert(skin.destination, {
        id = "grayItemBg", dst = {
            {x = avgX, y = avgY, w = GRAY_ITEM.W, h = GRAY_ITEM.H}
        }
    })
    table.insert(skin.destination, {
        id = "averageText", dst = {
            {x = avgX, y = avgY, w = GRAY_ITEM.W, h = GRAY_ITEM.H}
        }
    })
    dstNumberRightJustify(skin, "averageValue", avgX + TIMING.NUM.X, avgY + TIMING.NUM.Y, NUM_24PX.W, NUM_24PX.H, TIMING.NUM.DIGIT)
    table.insert(skin.destination, {
        id = "dotFor24Px", dst = {
            {x = avgX + TIMING.NUM.X, y = avgY, w = NUM_24PX.DOT_SIZE, h = NUM_24PX.DOT_SIZE}
        }
    })
    dstNumberRightJustify(skin, "averageValueAfterDot", avgX + TIMING.NUM_AFTER_DOT.X, avgY + TIMING.NUM.Y, NUM_24PX.W, NUM_24PX.H, TIMING.NUM_AFTER_DOT.DIGIT)

    -- ランク出力
    for i, rank in ipairs(RANKS.PREFIX) do
        if i ~= 1 then
            local st = RANKS.ANIMATION.START_TIME
            local op = 300 + (i - 2)
            local cx = RANKS.X + RANKS.W / 2
            local cy = RANKS.Y + RANKS.H / 2
            -- 一旦暗くする
            table.insert(skin.destination, {
                id = "black", loop = st + RANKS.ANIMATION.END_TIME, op = {op}, dst = {
                    {time = 0, a = 0, acc = 1},
                    {time = st - 1, a = 0},
                    {time = st, a = 128, x = 0, y = 0, w = WIDTH, h = HEIGHT},
                    {time = st + RANKS.ANIMATION.GET_IN_TIME, a = 0},
                    {time = st + RANKS.ANIMATION.END_TIME},
                }
            })
            -- A以上のみ輝かせる
            if i <= 4 then
                -- 輝き
                table.insert(skin.destination, {
                    id = "rankShine", loop = st + RANKS.ANIMATION.END_TIME, op = {op, 90}, blend = 2, dst = {
                        {time = 0, a = 0},
                        {time = st + RANKS.ANIMATION.GET_IN_TIME - 1},
                        {
                            time = st + RANKS.ANIMATION.GET_IN_TIME,
                            x = cx, y = cy, w = 0, h = 0, a = 0,
                            acc = 2
                        },
                        {
                            time = st + RANKS.ANIMATION.SHINE_TIME,
                            x = cx - RANKS.SHINE.W / 2, y = cy - RANKS.SHINE.H / 2,
                            w = RANKS.SHINE.W, h = RANKS.SHINE.H,
                            a = 255, acc = 1,
                        },
                        {
                            time = st + RANKS.ANIMATION.DEL_SHINE_TIME,
                            x = cx - RANKS.SHINE.W * RANKS.ANIMATION.DEL_SHINE_MUL / 2, y = cy - RANKS.SHINE.H * RANKS.ANIMATION.DEL_SHINE_MUL / 2,
                            w = RANKS.SHINE.W * RANKS.ANIMATION.DEL_SHINE_MUL, h = RANKS.SHINE.H * RANKS.ANIMATION.DEL_SHINE_MUL,
                            a = 0
                        },
                        {time = st + RANKS.ANIMATION.END_TIME},
                    },
                })

                -- 輝きcircle
                table.insert(skin.destination, {
                    id = "rankShineCircle", loop = st + RANKS.ANIMATION.END_TIME, op = {op, 90}, blend = 2, dst = {
                        {time = 0, a = 0},
                        {time = st + RANKS.ANIMATION.GET_IN_TIME - 1},
                        {
                            time = st + RANKS.ANIMATION.GET_IN_TIME,
                            x = cx, y = cy, w = 0, h = 0, a = 0,
                            acc = 0
                        },
                        {
                            time = st + RANKS.ANIMATION.SHINE_TIME,
                            x = cx - RANKS.SHINE.W / 2, y = cy - RANKS.SHINE.H / 2,
                            w = RANKS.SHINE.W, h = RANKS.SHINE.H,
                            a = 255
                        },
                        {
                            time = st + RANKS.ANIMATION.DEL_CIRCLE_TIME,
                            x = cx - RANKS.SHINE.W * RANKS.ANIMATION.CIRCLE_MUL / 2, y = cy - RANKS.SHINE.H * RANKS.ANIMATION.CIRCLE_MUL / 2,
                            w = RANKS.SHINE.W * RANKS.ANIMATION.CIRCLE_MUL, h = RANKS.SHINE.H * RANKS.ANIMATION.CIRCLE_MUL,
                            a = 255
                        },
                        {
                            time = st + RANKS.ANIMATION.DEL_CIRCLE_TIME2,
                            x = cx - RANKS.SHINE.W * RANKS.ANIMATION.CIRCLE_MUL2 / 2, y = cy - RANKS.SHINE.H * RANKS.ANIMATION.CIRCLE_MUL2 / 2,
                            w = RANKS.SHINE.W * RANKS.ANIMATION.CIRCLE_MUL2, h = RANKS.SHINE.H * RANKS.ANIMATION.CIRCLE_MUL2,
                            a = 0
                        },
                        {
                            time = st + RANKS.ANIMATION.END_TIME
                        },
                    }
                })
            end

            -- 波紋
            table.insert(skin.destination, {
                id = rank .. "Text", loop = st + RANKS.ANIMATION.END_TIME, op = {op}, dst = {
                    {time = 0, a = 0},
                    {time = st + RANKS.ANIMATION.GET_IN_TIME - 1},
                    {time = st + RANKS.ANIMATION.GET_IN_TIME, x = RANKS.X, y = RANKS.Y, w = RANKS.W, h = RANKS.H, a = 255},
                    {
                        time = st + RANKS.ANIMATION.RIPPLE_TIME,
                        x = cx - RANKS.W * RANKS.ANIMATION.RIPPLE_MUL / 2,
                        y = cy - RANKS.H * RANKS.ANIMATION.RIPPLE_MUL / 2,
                        w = RANKS.W * RANKS.ANIMATION.RIPPLE_MUL,
                        h = RANKS.H * RANKS.ANIMATION.RIPPLE_MUL,
                        a = 0
                    },
                    {
                        time = st + RANKS.ANIMATION.END_TIME
                    },
                }
            })

            -- 本体
            table.insert(skin.destination, {
                id = rank .. "Text", loop = st + RANKS.ANIMATION.END_TIME, op = {op}, dst = {
                    {time = 0, a = 0},
                    {time = st - 1, a = 0},
                    {
                        time = st,
                        x = cx - RANKS.W * RANKS.ANIMATION.START_MUL / 2,
                        y = cy - RANKS.H * RANKS.ANIMATION.START_MUL / 2,
                        w = RANKS.W * RANKS.ANIMATION.START_MUL,
                        h = RANKS.H * RANKS.ANIMATION.START_MUL,
                        a = 255, r = 64, g = 64, b = 64, acc = 1,
                    },
                    {
                        time = st + RANKS.ANIMATION.GET_IN_TIME,
                        x = RANKS.X, y = RANKS.Y, w = RANKS.W, h = RANKS.H,
                        a = 255, r = 255, g = 255, b = 255, acc = 0,
                    },
                    {
                        time = st + RANKS.ANIMATION.RIPPLE_TIME,
                    },
                    {
                        time = st + RANKS.ANIMATION.END_TIME
                    },
                }
            })

            -- 光る文字
            table.insert(skin.destination, {
                id = rank .. "BrightText", loop = st + RANKS.ANIMATION.END_TIME, op = {op}, dst = {
                    {
                        time = 0,
                        x = RANKS.X, y = RANKS.Y, w = RANKS.W, h = RANKS.H,
                        a = 0, acc = 3,
                    },
                    {time = st + RANKS.ANIMATION.BRIGHT_TIME, a = 255},
                    {time = st + RANKS.ANIMATION.BRIGHT_TIME + RANKS.ANIMATION.BRIGHT_DURATION, a = 0},
                    {time = st + RANKS.ANIMATION.BRIGHT_TIME2, a = 255},
                    {time = st + RANKS.ANIMATION.BRIGHT_TIME2 + RANKS.ANIMATION.BRIGHT_DURATION, a = 0},
                    {time = st + RANKS.ANIMATION.END_TIME},
                }
            })
        end
    end

    -- new record
    for i = 1, 1 do
        local x = 0
        local y = 0
        local cx = 0
        local cy = 0
        local op = 0
        if i == 1 then
            x = NEW_RECORD.SCORE.X
            y = NEW_RECORD.SCORE.Y
            op = NEW_RECORD.SCORE.OP
        end

        cx = x + NEW_RECORD.W / 2
        cy = y + NEW_RECORD.H / 2

        local st = NEW_RECORD.ANIMATION.START_TIME
        -- 輝き
        table.insert(skin.destination, {
            id = "rankShine", loop = st + RANKS.ANIMATION.END_TIME, blend = 2, op = {op}, dst = {
                {time = 0, a = 0},
                {
                    time = st,
                    x = cx, y = cy, w = 0, h = 0, a = 0,
                    acc = 2
                },
                {
                    time = st + NEW_RECORD.ANIMATION.POP_TOP_TIME,
                    x = cx - RANKS.SHINE.W / 2 * NEW_RECORD.ANIMATION.SHINE_MUL, y = cy - RANKS.SHINE.H / 2 * NEW_RECORD.ANIMATION.SHINE_MUL,
                    w = RANKS.SHINE.W * NEW_RECORD.ANIMATION.SHINE_MUL, h = RANKS.SHINE.H * NEW_RECORD.ANIMATION.SHINE_MUL,
                    a = 255, acc = 1,
                },
                {
                    time = st + NEW_RECORD.ANIMATION.POP_TOP_TIME + NEW_RECORD.ANIMATION.SHINE_DURATION,
                    x = cx - RANKS.SHINE.W * RANKS.ANIMATION.DEL_SHINE_MUL / 2 * NEW_RECORD.ANIMATION.SHINE_MUL,
                    y = cy - RANKS.SHINE.H * RANKS.ANIMATION.DEL_SHINE_MUL / 2 * NEW_RECORD.ANIMATION.SHINE_MUL,
                    w = RANKS.SHINE.W * RANKS.ANIMATION.DEL_SHINE_MUL * NEW_RECORD.ANIMATION.SHINE_MUL, h = RANKS.SHINE.H * RANKS.ANIMATION.DEL_SHINE_MUL * NEW_RECORD.ANIMATION.SHINE_MUL,
                    a = 0
                },
                {time = st + NEW_RECORD.ANIMATION.END_TIME},
            },
        })
        table.insert(skin.destination, {
            id = "newRecordText", loop = st + NEW_RECORD.ANIMATION.END_TIME, op = {op}, dst = {
                {time = 0, x = cx, y = cy, w = 0, h = 0},
                {time = st, acc = 2},
                {
                    time = st + NEW_RECORD.ANIMATION.POP_TOP_TIME,
                    x = cx - NEW_RECORD.W * NEW_RECORD.ANIMATION.POP_TOP_MUL / 2,
                    y = cy + NEW_RECORD.ANIMATION.POP_Y - NEW_RECORD.H * NEW_RECORD.ANIMATION.POP_TOP_MUL / 2,
                    w = NEW_RECORD.W * NEW_RECORD.ANIMATION.POP_TOP_MUL, h = NEW_RECORD.H * NEW_RECORD.ANIMATION.POP_TOP_MUL
                },
                {time = st + NEW_RECORD.ANIMATION.POP_TOP_TIME + 1, a = 0},
                {time = st + NEW_RECORD.ANIMATION.END_TIME},
            }
        })
        table.insert(skin.destination, {
            id = "newRecordText", loop = st + NEW_RECORD.ANIMATION.END_TIME, op = {op}, dst = {
                {time = 0, x = cx, y = cy, w = 0, h = 0, a = 0},
                {time = st, acc = 1},
                {
                    time = st + NEW_RECORD.ANIMATION.POP_TOP_TIME,
                    x = cx - NEW_RECORD.W * NEW_RECORD.ANIMATION.POP_TOP_MUL / 2,
                    y = cy + NEW_RECORD.ANIMATION.POP_Y - NEW_RECORD.H * NEW_RECORD.ANIMATION.POP_TOP_MUL / 2,
                    w = NEW_RECORD.W * NEW_RECORD.ANIMATION.POP_TOP_MUL, h = NEW_RECORD.H * NEW_RECORD.ANIMATION.POP_TOP_MUL
                },
                {time = st + NEW_RECORD.ANIMATION.POP_TOP_TIME + 1, a = 255},
                {time = st + NEW_RECORD.ANIMATION.POP_BOTTOM_TIME, x = x, y = y, w = NEW_RECORD.W, h = NEW_RECORD.H},
                {time = st + NEW_RECORD.ANIMATION.END_TIME},
            }
        })

        -- 文字光らせる
        table.insert(skin.destination, {
            id = "newRecordBrightText", loop = st, blend = 2, op = {op}, dst = {
                {time = 0, x = x, y = y, w = NEW_RECORD.W, h = NEW_RECORD.H, a = 0},
                {time = st + NEW_RECORD.ANIMATION.POP_TOP_TIME - 1, a = 0},
                {time = st + NEW_RECORD.ANIMATION.POP_TOP_TIME, a = 128},
                {time = st + NEW_RECORD.ANIMATION.POP_TOP_TIME + NEW_RECORD.ANIMATION.BRIGHT_DURATION, a = 0},
                {time = st + NEW_RECORD.ANIMATION.BRIGHT_INTERVAL},
            }
        })

        -- dustばらまき
        for j = 1, NEW_RECORD.DUST.N do
            local dirction = math.random(0, 2 * math.pi * 314) / 314.0
            local size = math.random(NEW_RECORD.DUST.DST_MIN_SIZE, NEW_RECORD.DUST.DST_MAX_SIZE)
            local len = math.random(30, 60)
            local dx = len * math.cos(dirction)
            local dy = len * math.sin(dirction)
            table.insert(skin.destination, {
                id = "newRecordDust", loop = st, op = {op}, dst = {
                    {time = 0, a = 0},
                    {
                        time = st,
                        x = cx, y = cy, w = 0, h = 0, a = 0,
                        acc = 2
                    },
                    {
                        time = st + NEW_RECORD.ANIMATION.POP_TOP_TIME,
                        a = 255,
                    },
                    {
                        time = st + NEW_RECORD.ANIMATION.POP_TOP_TIME + NEW_RECORD.ANIMATION.DUST_DURATION,
                        x = cx + dx * NEW_RECORD.DUST.X_MUL * 0.8 - size / 2,
                        y = cy + dy * 0.8 - size / 2,
                        w = size, h = size,
                    },
                    {
                        time = st + NEW_RECORD.ANIMATION.POP_TOP_TIME + NEW_RECORD.ANIMATION.DUST_DEL,
                        x = cx + dx * NEW_RECORD.DUST.X_MUL - size / 2,
                        y = cy + dy - size / 2,
                        w = size, h = size,
                        a = 0
                    },
                    {time = st + NEW_RECORD.ANIMATION.BRIGHT_INTERVAL},
                }
            })
        end
    end

    resultObtained.dst(skin)

    -- 大きいクリアランプ
    local nowLLTextX = 0
    local lampUpperText = string.upper(LARGE_LAMP.PREFIX[CLEAR_TYPE])
    local popInterval = LARGE_LAMP.ANIMATION.END_POP / LARGE_LAMP.LEN[CLEAR_TYPE]
    local bgId = "white"
    if CLEAR_TYPE == LAMPS.FAILED then bgId = "black" end
    -- まず背景
    table.insert(skin.destination, {
        id = bgId, loop = -1, dst = {
            {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = LARGE_LAMP.ANIMATION.WHITE_BG_ALPHA},
            {time = INPUT_WAIT + LARGE_LAMP.ANIMATION.TO_TOP_TIME},
            {time = INPUT_WAIT + LARGE_LAMP.ANIMATION.AT_TOP_TIME, a = 0},
        }
    })
    -- また超カオス
    for i = 1, LARGE_LAMP.LEN[CLEAR_TYPE] do
        local dt = popInterval * (i - 1)
        local st = LARGE_LAMP.ANIMATION.START_TIME
        nowLLTextX = nowLLTextX + LARGE_LAMP.POS[lampUpperText][i]
        local dstBodyX = nowLLTextX - LARGE_LAMP.POS[lampUpperText .. "_D"][i]
        local cx = dstBodyX + LARGE_LAMP.SIZE / 2
        local initCy = LARGE_LAMP.POS.INIT_Y + LARGE_LAMP.SIZE / 2
        local initSize = LARGE_LAMP.SIZE * LARGE_LAMP.ANIMATION.INIT_SIZE_MUL
        local dx = cx - WIDTH / 2
        local dstArrayFirstHalf = {}
        local dstArrayLatterHalf = {}
        -- shadowと本体は同時に動かす, brightは別働隊
        if CLEAR_TYPE == LAMPS.FAILED then
            local dropDt = popInterval * LARGE_LAMP.ANIMATION.FAILED_DROP_ORDER[i]
            local fromY = LARGE_LAMP.POS.INIT_Y + LARGE_LAMP.POS.FAILED_START_DY
            dstArrayFirstHalf = {
                {time = 0, x = dstBodyX, y = fromY, w = LARGE_LAMP.SIZE, h = LARGE_LAMP.SIZE, a = 0, acc = 2},
                {time = st + dropDt},
                {time = st + dropDt + LARGE_LAMP.ANIMATION.POP_DURATION, y = LARGE_LAMP.POS.INIT_Y, a = 255},
                {time = st + dropDt + LARGE_LAMP.ANIMATION.POP_DURATION + 1, a = 0},
                {time = st + LARGE_LAMP.ANIMATION.END_TIME},
            }
            dstArrayLatterHalf = {
                {time = 0, x = dstBodyX, y = LARGE_LAMP.POS.INIT_Y, w = LARGE_LAMP.SIZE, h = LARGE_LAMP.SIZE, a = 0, acc = 0},
                {time = st + dropDt + LARGE_LAMP.ANIMATION.POP_DURATION, a = 0},
                {time = st + dropDt + LARGE_LAMP.ANIMATION.POP_DURATION + 1, a = 255},
                {time = st + LARGE_LAMP.ANIMATION.TO_TOP_TIME},
            }
        else
            dstArrayFirstHalf = {
                {time = 0, x = (cx - initSize / 2) + dx, y = initCy - initSize / 2, w = initSize, h = initSize, a = 0, acc = 2},
                {time = st + dt - 1, a = 0},
                {time = st + dt, a = 255},
                {
                    time = st + dt + LARGE_LAMP.ANIMATION.POP_DURATION,
                    x = dstBodyX, y = LARGE_LAMP.POS.INIT_Y, w = LARGE_LAMP.SIZE, h = LARGE_LAMP.SIZE,
                },
                {time = st + dt + LARGE_LAMP.ANIMATION.POP_DURATION + 1, a = 0},
                {time = st + LARGE_LAMP.ANIMATION.END_TIME},
            }
            dstArrayLatterHalf = {
                {time = 0, x = dstBodyX, y = LARGE_LAMP.POS.INIT_Y, w = LARGE_LAMP.SIZE, h = LARGE_LAMP.SIZE, a = 0, acc = 0},
                {time = st + dt + LARGE_LAMP.ANIMATION.POP_DURATION, a = 0},
                {time = st + dt + LARGE_LAMP.ANIMATION.POP_DURATION + 1, a = 255},
                {time = st + LARGE_LAMP.ANIMATION.TO_TOP_TIME},
            }
        end
        local dstArrayBright = {
            {time = 0, w = LARGE_LAMP.SIZE, h = LARGE_LAMP.SIZE, a = 0, acc = 0},
            {time = st + LARGE_LAMP.ANIMATION.TO_TOP_TIME},
        }

        -- 後半は光らせる関係で一定時間ごとに分割していく
        local brightStartTime = LARGE_LAMP.ANIMATION.TO_TOP_TIME + LARGE_LAMP.ANIMATION.TO_TOP_DIV * (i - 1) * LARGE_LAMP.ANIMATION.BRIGHT_INTERVAL
        local brightTime = LARGE_LAMP.ANIMATION.TO_TOP_TIME + LARGE_LAMP.ANIMATION.TO_TOP_DIV * (i - 1 + LARGE_LAMP.ANIMATION.BRIGHT_INTERVAL) * LARGE_LAMP.ANIMATION.BRIGHT_INTERVAL
        local brightEndTime = LARGE_LAMP.ANIMATION.TO_TOP_TIME + LARGE_LAMP.ANIMATION.TO_TOP_DIV * (i - 1 + LARGE_LAMP.ANIMATION.BRIGHT_INTERVAL * 2) * LARGE_LAMP.ANIMATION.BRIGHT_INTERVAL
        local maxTime = math.max(LARGE_LAMP.ANIMATION.AT_TOP_TIME, brightEndTime)
        for t = LARGE_LAMP.ANIMATION.TO_TOP_TIME, maxTime, LARGE_LAMP.ANIMATION.TO_TOP_DIV do
            local y = easing.easeOut(
                math.min(t - LARGE_LAMP.ANIMATION.TO_TOP_TIME, LARGE_LAMP.ANIMATION.AT_TOP_TIME - LARGE_LAMP.ANIMATION.TO_TOP_TIME),
                LARGE_LAMP.POS.INIT_Y,
                LARGE_LAMP.POS.AT_TOP_Y,
                LARGE_LAMP.ANIMATION.AT_TOP_TIME - LARGE_LAMP.ANIMATION.TO_TOP_TIME
            )
            local a = 0 -- brightのアルファ
            if t >= brightStartTime and t <= brightTime then
                a = LARGE_LAMP.ANIMATION.MAX_BRIGHT * (t - brightStartTime) / (brightTime - brightStartTime)
            elseif t > brightTime and t <= brightEndTime then
                a = LARGE_LAMP.ANIMATION.MAX_BRIGHT * (brightEndTime - t) / (brightEndTime - brightTime)
            end
            table.insert(dstArrayLatterHalf, {
                time = st + t, x = dstBodyX, y = y
            })
            table.insert(dstArrayBright, {
                time = st + t, x = dstBodyX, y = y, a = a
            })
        end

        table.insert(dstArrayLatterHalf, {
            time = st + LARGE_LAMP.ANIMATION.END_TIME
        })

        table.insert(dstArrayBright, {
            time = st + LARGE_LAMP.ANIMATION.END_TIME
        })

        table.insert(skin.destination, {
            id = "largeLampShadowText" .. i, timer = 1, loop = st + LARGE_LAMP.ANIMATION.END_TIME, dst = dstArrayFirstHalf
        })
        table.insert(skin.destination, {
            id = "largeLampText" .. i, timer = 1, loop = st + LARGE_LAMP.ANIMATION.END_TIME, dst = dstArrayFirstHalf
        })
        table.insert(skin.destination, {
            id = "largeLampShadowText" .. i, timer = 1, loop = st + LARGE_LAMP.ANIMATION.END_TIME, dst = dstArrayLatterHalf
        })
        table.insert(skin.destination, {
            id = "largeLampText" .. i, timer = 1, loop = st + LARGE_LAMP.ANIMATION.END_TIME, dst = dstArrayLatterHalf
        })
        table.insert(skin.destination, {
            id = "largeLampBrightText" .. i, timer = 1, loop = st + LARGE_LAMP.ANIMATION.END_TIME, dst = dstArrayBright
        })

        -- brightのループ
        local brightDt = LARGE_LAMP.ANIMATION.BRIGHT_INTERVAL * (i - 1) * LARGE_LAMP.ANIMATION.ROOP_BRIGHT_DIV
        table.insert(skin.destination, {
            id = "largeLampBrightText" .. i, timer = 1, loop = st + LARGE_LAMP.ANIMATION.START_BRIGHT_ROOP, dst = {
                {time = 0, x = dstBodyX, y = LARGE_LAMP.POS.AT_TOP_Y, w = LARGE_LAMP.SIZE, h = LARGE_LAMP.SIZE, a = 0},
                {time = st + LARGE_LAMP.ANIMATION.START_BRIGHT_ROOP},
                {time = st + LARGE_LAMP.ANIMATION.START_BRIGHT_ROOP + brightDt, a = 0},
                {time = st + LARGE_LAMP.ANIMATION.START_BRIGHT_ROOP + brightDt + LARGE_LAMP.ANIMATION.BRIGHT_DURATION * LARGE_LAMP.ANIMATION.ROOP_BRIGHT_DIV, a = 255},
                {time = st + LARGE_LAMP.ANIMATION.START_BRIGHT_ROOP + brightDt + LARGE_LAMP.ANIMATION.BRIGHT_DURATION*2 * LARGE_LAMP.ANIMATION.ROOP_BRIGHT_DIV, a = 0},
                {time = st + LARGE_LAMP.ANIMATION.START_BRIGHT_ROOP + LARGE_LAMP.ANIMATION.BRIGHT_ROOP_INTERVAL}
            }
        })
    end

    mergeSkin(skin, fade.dst())

    return skin
end


return {
    header = makeHeader,
    main = main,

    setIsCourseResult = setIsCourseResult,
}