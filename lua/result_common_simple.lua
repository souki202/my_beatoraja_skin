
require("modules.commons.numbers")
require("modules.commons.my_window")
local main_state = require("main_state")
local resultObtained = require("modules.result.result_obtained")

local INPUT_WAIT = 500 -- シーン開始から入力受付までの時間
local TEXTURE_SIZE = 2048
local BG_ID = "background"

local LEFT_X = 80
local RIGHT_X = 1190

local BASE_WINDOW = {
    SHADOW_LEN = 14,
    EDGE_SIZE = 10,
    ID = {
       UPPER_LEFT   = "baseWindowUpperLeft",
       UPPER_RIGHT  = "baseWindowUpperRight",
       BOTTOM_RIGHT = "baseWindowBottomRight",
       BOTTOM_LEFT  = "baseWindowBottomLeft",
       TOP    = "baseWindowTopEdge",
       LEFT   = "baseWindowLeftEdge",
       BOTTOM = "baseWindowBottomEdge",
       RIGHT  = "baseWindowRightEdge",
       BODY = "baseWindowBody",
    }
}

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

-- EXSCORE以外
local VALUE_ITEM_TEXT = {
    SRC_X = 199,
    SRC_Y = 31,
    W = 221,
    H = 27,
}

local CHANGE_ARROW = {
    W = 27,
    H = 21,
}

local TITLE_BAR = {
    WND = {
        X = 375,
        Y = 1030,
        W = 1186,
        H = 40,
    },
    TITLE = {
        FONT_SIZE = 24,
        X = 550,
        W = 868,
        Y = 8,
    },
    DIFFICULTY = {
        X = 1005,
        Y = 11,
        NUM_OFFSET_X = 166, -- xからの右端の距離
        NUM_OFFSET_Y = 1,
        DIGIT = 2,
    },
    FLAGS = {
        PREFIX = {"undefined", "beginner", "normal", "hyper", "another", "insane"},
        X = -98,
        Y = 6,
        W = 196,
        H = 28,
    }
}

-- 灰色背景の項目
local GRAY_ITEM = {
    W = 120,
    H = 20,
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


local JUDGE = {
    WND = {
        X = LEFT_X,
        Y = 322,
        W = 650,
        H = 312,
    },

    DEVIDING_LINE = {
        X = 18,
        W = 364,
    },

    TEXT = {
        X = 32,
        Y = 263,
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
        DIGIT = 4, -- コース時は5桁
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

    COMBO = {
        WND = {
            X = 405,
            Y = 170,
            W = 220,
            H = 115,
        },
        TEXT = {
            X = 55,
            Y = 78,
            W = 109,
            H = 23,
        },

        DIGIT = 5,
        NOW_NUM = {
            X = 110,
            Y = 20,
        },
        SLASH = {
            X = 111,
            Y = 20,
        },
        TN_NUM = {
            X = 189,
            Y = 20,
        },
        PREFIX = {"missCount", "combo", "comboBreak"}
    },
    IR = {
        WND = {
            X = 405,
            Y = 27,
            W = 220,
            H = 115,
        },

        TEXT = {
            X = 44,
            Y = 78,
            W = 132,
            H = 23,
        },
        DIGIT = 5,
        NOW_NUM = {
            X = 110,
            Y = 20,
        },
        SLASH = {
            X = 111,
            Y = 20,
        },
        P_NUM = {
            X = 187,
            Y = 20,
        },
    },
}

local TIMING = {
    WND = {
        X = 750,
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

local GRAPH = {
    WND_GAUGE = {
        X = LEFT_X,
        Y = 20,
        W = 650,
        H = 282,
        EDGE = 10,
        SHADOW = 15,
    },

    GAUGE = {
        X = 10,
        Y = 10,
        W = 630,
        H = 262,
        EDGE = 25,
    },

    GROOVE_TEXT = {
        X = 7,
        Y = 5,
        W = 189,
        H = 22,
    },

    GROOVE_NUM = {
        X = 584, -- グラフエリアからの値
        Y = 237,
        DOT = 1, -- x からの差分 あとでグラフからの差分に再計算
        AF_X = 20, -- x からの差分 あとでグラフからの差分に再計算
        SYMBOL_X = 20, -- x からの差分 あとでグラフからの差分に再計算
    },

    PREFIX = {"notes", "judges", "el"}
}

GRAPH.GROOVE_NUM.DOT = GRAPH.GROOVE_NUM.X + GRAPH.GROOVE_NUM.DOT
GRAPH.GROOVE_NUM.AF_X = GRAPH.GROOVE_NUM.X + GRAPH.GROOVE_NUM.AF_X
GRAPH.GROOVE_NUM.SYMBOL_X = GRAPH.GROOVE_NUM.X + GRAPH.GROOVE_NUM.SYMBOL_X

local LARGE_LAMP = {
    SIZE = 71,
    PREFIX = {"failed", "aeasy", "laeasy", "easy", "normal", "hard", "exhard", "fullcombo", "perfect", "perfect"},
    LEN = {9, 17, 19, 11, 12, 12, 15, 12, 10, 10}, -- 空白込み
    POS = { -- 文字の左端部分の座標間隔と, 画像側の文字左端と文字領域左端の差 座標間隔の1文字目だけ絶対座標
        INIT_Y = 533,
        FAILED_START_DY = 200,
        AT_TOP_Y = 894,
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
    X = 571,
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
        X = 390,
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

local FADEOUT_ANIM_TIME = 300
local FADEIN_ANIM_TIME = 150

local isCourseResult = false
local function setIsCourseResult(b)
    isCourseResult = b
end

local header = {
    type = 7,
    name = "Social Skin Simple" .. (DEBUG and " dev result" or ""),
    w = WIDTH,
    h = HEIGHT,
    fadeout = 500,
    scene = 3600000,
    input = INPUT_WAIT,
    property = {
        {
            name = "背景の分類", item = {{name = "クリアかどうか", op = 910}, {name = "ランク毎", op = 911}, {name = "クリアランプ毎", op = 912}}
        },
        {
            name = "スコア位置", item = {{name = "左", op = 920}, {name = "右", op = 921}}, def = "左"
        },
        {
            name = "経験値等画面遷移", item = {{name = "右キー", op = 925}, {name = "左キー", op = 926}, {name = "決定ボタン(一定時間表示)", op = 927}, {name = "無し", op = 928}}, def = "右キー"
        },
    },
    filepath = {
        {name = "NoImage画像(png)", path = "../result/noimage/*.png", def = "default"},
        {name = "背景選択-----------------------------------------", path="../dummy/*"},
        {name = "CLEAR背景(png)", path = "../result/background/isclear/clear/*.png"},
        {name = "FAILED背景(png)", path = "../result/background/isclear/failed/*.png"},
        {name = "背景選択2-----------------------------------------", path="../dummy/*"},
        {name = "AAA背景(png)", path = "../result/background/ranks/aaa/*.png"},
        {name = "AA背景(png)" , path = "../result/background/ranks/aa/*.png"},
        {name = "A背景(png)"  , path = "../result/background/ranks/a/*.png"},
        {name = "B背景(png)"  , path = "../result/background/ranks/b/*.png"},
        {name = "C背景(png)"  , path = "../result/background/ranks/c/*.png"},
        {name = "D背景(png)"  , path = "../result/background/ranks/d/*.png"},
        {name = "E背景(png)"  , path = "../result/background/ranks/e/*.png"},
        {name = "F背景(png)"  , path = "../result/background/ranks/f/*.png"},
        {name = "背景選択3-----------------------------------------", path="../dummy/*"},
        {name = "FAILED(ランプ毎)背景(png)", path = "../result/background/lamps/failed/*.png"},
        {name = "ASSIST EASY背景(png)"    , path = "../result/background/lamps/aeasy/*.png"},
        {name = "LASSIST EASY背景(png)"   , path = "../result/background/lamps/laeasy/*.png"},
        {name = "EASY背景(png)"           , path = "../result/background/lamps/easy/*.png"},
        {name = "NORMAL背景(png)"         , path = "../result/background/lamps/normal/*.png"},
        {name = "HARD背景(png)"           , path = "../result/background/lamps/hard/*.png"},
        {name = "EXHARD背景(png)"         , path = "../result/background/lamps/exhard/*.png"},
        {name = "FULLCOMBO背景(png)"      , path = "../result/background/lamps/fullcombo/*.png"},
        {name = "PERFECT背景(png)"        , path = "../result/background/lamps/perfect/*.png"},
    },
}

local function is2P()
    return getTableValue(skin_config.option, "スコア位置", 920) == 921
end

local function easeOut(t, s, e, d)
    local c = e - s
    local t2 = t / d
    t2 = t2 - 1
    return c * (t2 * t2 * t2 + 1) + s
end

-- ランプやクリアかどうかに応じて適切な背景を1枚だけ読み込む
local function loadBackground(skin)
    table.insert(skin.image, {
        id = BG_ID, src = getBgSrc(), x = 0, y = 0, w = -1, h = -1
    })
end

local function initialize(skin)
    if is2P() then
        STAGE_FILE.X = 1584
        SCORE.WND.X = RIGHT_X
        JUDGE.WND.X = RIGHT_X
        GRAPH.WND_GAUGE.X = RIGHT_X
        RANKS.X = SCORE.WND.X + 491
        NEW_RECORD.SCORE.X = SCORE.WND.X + 310
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
    for k, v in pairs(header) do
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
            pcall(userData.save)
        else
            print("スタミナ不足のため, 経験値なし")
        end
    end

    skin.customEvents = {}

    skin.source = {
        {id = 0, path = "../result/parts/parts.png"},
        {id = 1, path = "../result/parts/shine.png"},
        {id = 2, path = "../result/parts/shine_circle.png"},
        {id = 20, path = "../result/noimage/*.png"},
        {id = 100, path = "../result/background/isclear/clear/*.png"},
        {id = 101, path = "../result/background/isclear/failed/*.png"},
        -- AAAからランク毎
        {id = 110, path = "../result/background/ranks/aaa/*.png"},
        {id = 111, path = "../result/background/ranks/aa/*.png"},
        {id = 112, path = "../result/background/ranks/a/*.png"},
        {id = 113, path = "../result/background/ranks/b/*.png"},
        {id = 114, path = "../result/background/ranks/c/*.png"},
        {id = 115, path = "../result/background/ranks/d/*.png"},
        {id = 116, path = "../result/background/ranks/e/*.png"},
        {id = 117, path = "../result/background/ranks/f/*.png"},
        -- {id = 118, path = "../result/background/ranks/f/*.png"},
        -- FAILEDからランプ毎
        {id = 120, path = "../result/background/lamps/failed/*.png"},
        {id = 121, path = "../result/background/lamps/aeasy/*.png"},
        {id = 122, path = "../result/background/lamps/laeasy/*.png"},
        {id = 123, path = "../result/background/lamps/easy/*.png"},
        {id = 124, path = "../result/background/lamps/normal/*.png"},
        {id = 125, path = "../result/background/lamps/hard/*.png"},
        {id = 126, path = "../result/background/lamps/exhard/*.png"},
        {id = 127, path = "../result/background/lamps/fullcombo/*.png"},
        {id = 128, path = "../result/background/lamps/perfect/*.png"},
        {id = 999, path = "../common/colors/colors.png"}
    }
    table.insert(skin.source, {
        id = 3, path = "../result/parts/largelamp/" .. LARGE_LAMP.PREFIX[CLEAR_TYPE] .. ".png"
    })

    skin.image = {
        {id = "noImage", src = 20, x = 0, y = 0, w = -1, h = -1},

        {id = "grayItemBg", src = 0, x = 529, y = 0, w = GRAY_ITEM.W, h = GRAY_ITEM.H},
        {id = "percentageFor24Px", src = 0, x = 1848, y = 40, w = NUM_24PX.PERCENT.W, h = NUM_24PX.PERCENT.H},
        {id = "percentageFor24PxWhite", src = 0, x = 1848, y = 189, w = NUM_24PX.PERCENT.W, h = NUM_24PX.PERCENT.H},
        {id = "dotFor24Px", src = 0, x = 2034, y = 50, w = NUM_24PX.DOT_SIZE, h = NUM_24PX.DOT_SIZE},
        {id = "dotFor24PxWhite", src = 0, x = 2034, y = 199, w = NUM_24PX.DOT_SIZE, h = NUM_24PX.DOT_SIZE},
        {id = "slashFor30Px", src = SLASH_30PX.SRC, x = SLASH_30PX.SRC_X, y = SLASH_30PX.SRC_Y, w = SLASH_30PX.W, h = SLASH_30PX.H},
        {id = "changeArrow", src = 0, x = 0, y = 49, w = CHANGE_ARROW.W, h = CHANGE_ARROW.H},
        {id = "scoreDevidingLine", src = 0, x = 0, y = TEXTURE_SIZE - 1, w = SCORE.DEVIDING_LINE.W, h = 1},
        {id = "judgeDevidingLine", src = 0, x = 0, y = TEXTURE_SIZE - 1, w = JUDGE.DEVIDING_LINE.W, h = 1},

        -- 難易度部分
        {id = "difficultyText", src = 0, x = 529, y = GRAY_ITEM.H*1, w = GRAY_ITEM.W, h = GRAY_ITEM.H},

        -- スコア部分
        {id = "exScoreText"    , src = 0, x = 199, y = 0, w = SCORE.EXSCORE.TEXT_W, h = SCORE.EXSCORE.TEXT_H},
        {id = "hiScoreText"    , src = 0, x = VALUE_ITEM_TEXT.SRC_X, y = VALUE_ITEM_TEXT.SRC_Y + VALUE_ITEM_TEXT.H*0, w = VALUE_ITEM_TEXT.W, h = VALUE_ITEM_TEXT.H},
        {id = "targetScoreText", src = 0, x = VALUE_ITEM_TEXT.SRC_X, y = VALUE_ITEM_TEXT.SRC_Y + VALUE_ITEM_TEXT.H*1, w = VALUE_ITEM_TEXT.W, h = VALUE_ITEM_TEXT.H},

        -- combo ir
        {id = "comboText" , src = 0, x = 1032, y = 70, w = JUDGE.COMBO.TEXT.W, h = JUDGE.COMBO.TEXT.H},
        {id = "irText"    , src = 0, x = 1032, y = 70 + JUDGE.COMBO.TEXT.H, w = JUDGE.IR.TEXT.W, h = JUDGE.IR.TEXT.H},
        {id = "comboFrame", src = 0, x = 1404, y = TEXTURE_SIZE - 1 - JUDGE.COMBO.WND.H, w = JUDGE.COMBO.WND.W, h = JUDGE.COMBO.WND.H},
        {id = "irFrame"   , src = 0, x = 1404, y = TEXTURE_SIZE - 1 - JUDGE.IR.WND.H, w = JUDGE.IR.WND.W, h = JUDGE.IR.WND.H},

        -- 判定部分
        {id = "judgeSlash", src = 0, x = 1872, y = 36, w = JUDGE.SLASH.W, h = JUDGE.SLASH.H},

        -- グラフ
        {id = "grooveGaugeFrame", src = 0, x = 0, y = TEXTURE_SIZE - 371 - GRAPH.WND_GAUGE.H - GRAPH.WND_GAUGE.SHADOW*2, w = GRAPH.WND_GAUGE.W + GRAPH.WND_GAUGE.SHADOW*2, h = GRAPH.WND_GAUGE.H + GRAPH.WND_GAUGE.SHADOW*2},
        {id = "grooveGaugeText", src = 0, x = VALUE_ITEM_TEXT.SRC_X, y = 432 + GRAPH.GROOVE_TEXT.H*4, w = GRAPH.GROOVE_TEXT.W ,h = GRAPH.GROOVE_TEXT.H},

        -- ランク
        {id = "rankShine", src = 1, x = 0, y = 0, w = RANKS.SHINE.W, h = RANKS.SHINE.H},
        {id = "rankShineCircle", src = 2, x = 0, y = 0, w = RANKS.SHINE.W, h = RANKS.SHINE.H},

        -- new record
        {id = "newRecordText", src = 0, x = 1032, y = 0, w = NEW_RECORD.W, h = NEW_RECORD.H},
        {id = "newRecordBrightText", src = 0, x = 1032, y = 0, w = NEW_RECORD.W, h = NEW_RECORD.H},
        {id = "newRecordDust", src = 0, x = 1215, y = 0, w = NEW_RECORD.DUST.SIZE, h = NEW_RECORD.DUST.SIZE},

        -- その他色
        {id = "black", src = 999, x = 1, y = 0, w = 1, h = 1},
        {id = "white", src = 999, x = 2, y = 0, w = 1, h = 1},
    }

    -- 背景読み込み
    loadBackground(skin)
    -- ウィンドウ読み込み
    loadBaseWindowResult(skin, 0, 0)

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
    for i, text in ipairs(TITLE_BAR.FLAGS.PREFIX) do
        table.insert(skin.image, {
            id = text .. "Flag", src = 0, x = 649, y = TITLE_BAR.FLAGS.H * (i - 1), w = TITLE_BAR.FLAGS.W, h = TITLE_BAR.FLAGS.H
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

    -- 各種グラフ
    skin.gaugegraph = {
		{id = "grooveGaugeGraph", assistClearBGColor = "440044cc", assistAndEasyFailBGColor = "004444cc", grooveFailBGColor = "004400cc", grooveClearAndHardBGColor = "440000cc", exHardBGColor = "444400cc", hazardBGColor = "444444cc", borderColor = "440000cc"}
    }

    skin.judgegraph = {
        {id = "notesGraph", noGap = 1, orderReverse = 0, type = 0, backTexOff = 1},
    }

    skin.value = {
        {id = "difficultyValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 2, ref = 96, align = 0},
        -- スコア部分
        {id = "exScoreValue"    , src = 0, x = 1784, y = 106, w = SCORE.EXSCORE.NUM_W*11, h = SCORE.EXSCORE.NUM_H, divx = 11, digit = SCORE.EXSCORE.DIGIT, ref = 71},
        {id = "hiScoreValue"    , src = 0, x = 1808, y = 80, w = SCORE.HISCORE.NUM_W*11, h = SCORE.HISCORE.NUM_H, divx = 11, digit = SCORE.HISCORE.DIGIT, ref = 170},
        {id = "targetScoreValue", src = 0, x = 1808, y = 80, w = SCORE.TARGET.NUM_W*11, h = SCORE.TARGET.NUM_H, divx = 11, digit = SCORE.TARGET.DIGIT, ref = 151},
        {id = "exScorePercentageValue"        , src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 3, ref = 102, align = 0},
        {id = "exScorePercentageValueAfterDot", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 2, ref = 103, align = 0, padding = 1},
        {id = "hiScoreDiffValue"    , src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = 0, w = NUM_24PX.W * 12, h = NUM_24PX.H*2, divx = 12, divy = 2, digit = SCORE.HISCORE.DIGIT, ref = 172, align = 1, zeropadding = 0},
        {id = "targetScoreDiffValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = 0, w = NUM_24PX.W * 12, h = NUM_24PX.H*2, divx = 12, divy = 2, digit = SCORE.TARGET.DIGIT, ref = 153, align = 1, zeropadding = 0},
        -- COMBO部分
        {id = "comboValue", src = NUM_30PX.SRC, x = NUM_30PX.SRC_X, y = NUM_30PX.SRC_Y, w = NUM_30PX.W * 11, h = NUM_30PX.H, divx = 11, digit = JUDGE.COMBO.DIGIT, ref = 75, align = 0},
        {id = "totalNotesValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 11, h = NUM_24PX.H, divx = 11, digit = JUDGE.COMBO.DIGIT, ref = 106, align = 0},
        -- IR
        {id = "irNowValue", src = NUM_30PX.SRC, x = NUM_30PX.SRC_X, y = NUM_30PX.SRC_Y, w = NUM_30PX.W * 11, h = NUM_30PX.H, divx = 11, digit = JUDGE.IR.DIGIT, ref = 179, align = 0},
        {id = "irNumOfPlayersValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 11, h = NUM_24PX.H, divx = 11, digit = JUDGE.IR.DIGIT, ref = 180, align = 0},
        -- groove gaugeの値
        {id = "grooveGaugeValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = 185, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 3, ref = 107, align = 0},
        {id = "grooveGaugeValueAfterDot", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = 185, w = NUM_24PX.W * 10, h = NUM_24PX.H, divx = 10, digit = 1, ref = 407, align = 0, padding = 1},
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
            id = text .. "EarlyValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 11, h = NUM_24PX.H, divx = 11, digit = JUDGE.NUM.DIGIT, ref = divRef, align = 0
        })
        -- late
        table.insert(skin.value, {
            id = text .. "LateValue", src = NUM_24PX.SRC, x = NUM_24PX.SRC_X, y = NUM_24PX.SRC_Y, w = NUM_24PX.W * 11, h = NUM_24PX.H, divx = 11, digit = JUDGE.NUM.DIGIT, ref = divRef + 1, align = 0
        })
    end

    skin.font = {
		{id = 0, path = "../common/fonts/SourceHanSans-Regular.otf"},
		-- {id = 0, path = "../common/fonts/mplus-2p-regular.ttf"},
	}

    skin.text = {
        {id = "title", font = 0, size = TITLE_BAR.TITLE.FONT_SIZE, ref = 12, align = 1},
    }

    resultObtained.load(skin)

    skin.destination = {
        -- 背景
        {
            id = BG_ID, dst = {
                {x = 0, y = 0, w = WIDTH, h = HEIGHT}
            }
        },
        -- noimage
        {
            id = "noImage", op = {190}, stretch = 1, dst = {
                {x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H}
            }
        },
        -- ジャケット画像
        {
            id = -100, op = {191}, filter = 1, stretch = 1, dst = {
                {x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H}
            }
        },
    }

    -- groove gauge出力
    local grooveX = GRAPH.WND_GAUGE.X + GRAPH.GAUGE.X
    local grooveY = GRAPH.WND_GAUGE.Y + GRAPH.GAUGE.Y
    table.insert(skin.destination, {
        id = "grooveGaugeGraph", dst = {
            {x = grooveX, y = grooveY, w = GRAPH.GAUGE.W, h = GRAPH.GAUGE.H}
        }
    })
    table.insert(skin.destination, {
        id = "grooveGaugeText", dst = {
            {x = grooveX + GRAPH.GROOVE_TEXT.X, y = grooveY + GRAPH.GROOVE_TEXT.Y, w = GRAPH.GROOVE_TEXT.W, h = GRAPH.GROOVE_TEXT.H}
        },
    })
    dstNumberRightJustify(skin, "grooveGaugeValue", grooveX + GRAPH.GROOVE_NUM.X, grooveY + GRAPH.GROOVE_NUM.Y, NUM_24PX.W, NUM_24PX.H, 3)
    table.insert(skin.destination, {
        id = "dotFor24PxWhite", dst = {
            {x = grooveX + GRAPH.GROOVE_NUM.DOT, y = grooveY + GRAPH.GROOVE_NUM.Y, w = NUM_24PX.DOT_SIZE, h = NUM_24PX.DOT_SIZE}
        }
    })
    dstNumberRightJustify(skin, "grooveGaugeValueAfterDot", grooveX + GRAPH.GROOVE_NUM.AF_X, grooveY + GRAPH.GROOVE_NUM.Y, NUM_24PX.W, NUM_24PX.H, 1)
    table.insert(skin.destination, {
        id = "percentageFor24PxWhite", dst = {
            {x = grooveX + GRAPH.GROOVE_NUM.SYMBOL_X, y = grooveY + GRAPH.GROOVE_NUM.Y, w = NUM_24PX.PERCENT.W, h = NUM_24PX.PERCENT.H}
        }
    })
    table.insert(skin.destination, {
        id = "grooveGaugeFrame", dst = {
            {
                x = GRAPH.WND_GAUGE.X - GRAPH.WND_GAUGE.SHADOW, y = GRAPH.WND_GAUGE.Y - GRAPH.WND_GAUGE.SHADOW,
                w = GRAPH.WND_GAUGE.W + GRAPH.WND_GAUGE.SHADOW * 2, h = GRAPH.WND_GAUGE.H + GRAPH.WND_GAUGE.SHADOW * 2
            }
        }
    })

    -- タイトル部分
    destinationStaticBaseWindow(skin, TITLE_BAR.WND.X, TITLE_BAR.WND.Y, TITLE_BAR.WND.W, TITLE_BAR.WND.H)
    table.insert(skin.destination, {
        id = "title", filter = 1, dst = {
            {x = TITLE_BAR.WND.X + TITLE_BAR.TITLE.X, y = TITLE_BAR.WND.Y + TITLE_BAR.TITLE.Y, w = TITLE_BAR.TITLE.W, h = TITLE_BAR.TITLE.FONT_SIZE, r = 0, g = 0, b = 0}
        }
    })

    -- 難易度
    local difficultyTextX = TITLE_BAR.WND.X + TITLE_BAR.DIFFICULTY.X
    local difficultyTextY = TITLE_BAR.WND.Y + TITLE_BAR.DIFFICULTY.Y
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
                x = difficultyTextX + TITLE_BAR.DIFFICULTY.NUM_OFFSET_X - NUM_24PX.W * TITLE_BAR.DIFFICULTY.DIGIT,
                y = difficultyTextY + TITLE_BAR.DIFFICULTY.NUM_OFFSET_Y,
                w = NUM_24PX.W, h = NUM_24PX.H
            }
        }
    })
    -- 難易度の旗
    local flagX = TITLE_BAR.WND.X + TITLE_BAR.FLAGS.X
    local flagY = TITLE_BAR.WND.Y + TITLE_BAR.FLAGS.Y
    local prefix = {"undefined", "beginner", "normal", "hyper", "another", "insane"}
    for i, text in ipairs(prefix) do
        table.insert(skin.destination, {
            id = text .. "Flag", op = {150 + (i - 1)}, dst = {
                {
                    x = flagX, y = flagY,
                    w = TITLE_BAR.FLAGS.W, h = TITLE_BAR.FLAGS.H
                }
            }
        })
    end

    -- スコア部分
    destinationStaticBaseWindow(skin, SCORE.WND.X, SCORE.WND.Y, SCORE.WND.W, SCORE.WND.H)
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

    -- 各種判定
    destinationStaticBaseWindow(skin, JUDGE.WND.X, JUDGE.WND.Y, JUDGE.WND.W, JUDGE.WND.H)
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

        -- 区切り線
        table.insert(skin.destination, {
            id = "judgeDevidingLine", dst = {
                {
                    x = JUDGE.WND.X + JUDGE.DEVIDING_LINE.X, y = y + DEVIDING_LINE_BASE.OFFSET_Y,
                    w = JUDGE.DEVIDING_LINE.W, h = DEVIDING_LINE_BASE.H
                }
            }
        })
    end

    -- コンボ
    local comboX = JUDGE.WND.X + JUDGE.COMBO.WND.X
    local comboY = JUDGE.WND.Y + JUDGE.COMBO.WND.Y
    table.insert(skin.destination, {
        id = "comboFrame", dst = {
            {x = comboX, y = comboY, w = JUDGE.COMBO.WND.W, h = JUDGE.COMBO.WND.H}
        }
    })
    table.insert(skin.destination, {
        id = "comboText", dst = {
            {x = comboX + JUDGE.COMBO.TEXT.X, y = comboY + JUDGE.COMBO.TEXT.Y, w = JUDGE.COMBO.TEXT.W, h = JUDGE.COMBO.TEXT.H}
        }
    })
    dstNumberRightJustify(skin, "comboValue", comboX + JUDGE.COMBO.NOW_NUM.X, comboY + JUDGE.COMBO.NOW_NUM.Y, NUM_30PX.W, NUM_30PX.H, JUDGE.COMBO.DIGIT)
    table.insert(skin.destination, {
        id = "slashFor30Px", dst = {
            {x = comboX + JUDGE.COMBO.SLASH.X, y = comboY + JUDGE.COMBO.SLASH.Y, w = SLASH_30PX.W, h = SLASH_30PX.H}
        },
    })
    dstNumberRightJustify(skin, "totalNotesValue", comboX + JUDGE.COMBO.TN_NUM.X, comboY + JUDGE.COMBO.TN_NUM.Y, NUM_24PX.W, NUM_24PX.H, JUDGE.COMBO.DIGIT)
    -- IR
    local irX = JUDGE.WND.X + JUDGE.IR.WND.X
    local irY = JUDGE.WND.Y + JUDGE.IR.WND.Y
    table.insert(skin.destination, {
        id = "irFrame", dst = {
            {x = irX, y = irY, w = JUDGE.IR.WND.W, h = JUDGE.IR.WND.H}
        }
    })
    table.insert(skin.destination, {
        id = "irText", dst = {
            {x = irX + JUDGE.IR.TEXT.X, y = irY + JUDGE.IR.TEXT.Y, w = JUDGE.IR.TEXT.W, h = JUDGE.IR.TEXT.H}
        }
    })
    dstNumberRightJustify(skin, "irNowValue", irX + JUDGE.IR.NOW_NUM.X, irY + JUDGE.IR.NOW_NUM.Y, NUM_30PX.W, NUM_30PX.H, JUDGE.IR.DIGIT)
    table.insert(skin.destination, {
        id = "slashFor30Px", dst = {
            {x = irX + JUDGE.IR.SLASH.X, y = irY + JUDGE.IR.SLASH.Y, w = SLASH_30PX.W, h = SLASH_30PX.H}
        },
    })
    dstNumberRightJustify(skin, "irNumOfPlayersValue", irX + JUDGE.IR.P_NUM.X, irY + JUDGE.IR.P_NUM.Y, NUM_24PX.W, NUM_24PX.H, JUDGE.IR.DIGIT)


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
            local y = easeOut(
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
    -- フェードイン
    table.insert(skin.destination, {
        id = "black", loop = -1, dst = {
            {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 255},
            {time = FADEIN_ANIM_TIME, a = 0}
        }
    })

    -- フェードアウト
    table.insert(skin.destination, {
        id = "black", timer = 2, loop = skin.fadeout, dst = {
            {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 0},
            {time = skin.fadeout - FADEOUT_ANIM_TIME},
            {time = skin.fadeout, a = 255}
        }
    })

    return skin
end


return {
    header = header,
    main = main,

    setIsCourseResult = setIsCourseResult,
}