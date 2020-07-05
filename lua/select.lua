-- Copyright 2019-2020 tori-blog.net.
-- This file is part of SocialSkin.

-- SocialSkin is free program: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- SocialSkin is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with SocialSkin.  If not, see <http://www.gnu.org/licenses/>.

require("modules.commons.define")
require("modules.commons.http")
require("modules.commons.my_window")
require("modules.commons.numbers")
require("position")
local commons = require("modules.select.commons")
local help = require("modules.select.help")
local statistics = require("modules.select.statistics")
local opening = require("modules.select.opening")
local user = require("modules.select.user")

local main_state = require("main_state")

local existNewVersion = false

local PARTS_TEXTURE_SIZE = 2048

local ARTIST_FONT_SIZE = 24
local SUBARTIST_FONT_SIZE = 18

local BAR_FONT_SIZE = 32
local LAMP_HEIGHT = 28
local MUSIC_BAR_IMG_HEIGHT = 78
local MUSIC_BAR_IMG_WIDTH = 607

local NORMAL_NUMBER_SRC_X = 946
local NORMAL_NUMBER_SRC_Y = commons.PARTS_OFFSET
local NORMAL_NUMBER_W = 15
local NORMAL_NUMBER_H = 21
local STATUS_NUMBER_W = 18
local STATUS_NUMBER_H = 23

-- 決定ボタン周り
local DECIDE_BUTTON_W = 354
local DECIDE_BUTTON_H = 78
local AUTO_BUTTON_W = 110
local AUTO_BUTTON_H = 62
local REPLAY_BUTTON_SIZE = 62
local REPLAY_TEXT_W = 17
local REPLAY_TEXT_H = 22

-- コース表示
local COURSE = {
    BG_W = 772,
    LABEL_W = 192,
    LABEL_H = 64,
    INTERVAL_Y = 64 + 16,
    SONGNAME_W = 538,
    BASE_Y = 832,

    OPTION = {
        BASE_X = 65,
        BASE_Y = 434,

        BG_W = 694 + 14,
        BG_H = 64 + 14,
        BG_EDGE_W = 17,
        SETTING_START_X = 87,
        HEADER_OFFSET_Y = 47,
        VALUE_OFFSET_Y = 18,
        HEADER_W = 120,
        HEADER_H = 20,
        INTERVAL_X = 136,
        VALUE_W = 120,
        VALUE_H = 18,
    },
}

-- stage fileまわり
local STAGE_FILE = {
    X = 105,
    Y = 464,
    W = 640,
    H = 480,
    FRAME_OFFSET = 31,

    SHADOW = {
        X = -12,
        Y = -12,
        A = 102,
    },
}

-- 上部のLNモードとkeysのボタンサイズ
local UPPER_OPTION_W = 270
local UPPER_OPTION_H = 56


-- Music bar
local MUSIC_BAR = {
    DIFFICULTY_NUMBER_W = 16,
    DIFFICULTY_NUMBER_H = 21,

    TROPHY_W = 56,
    TROPHY_H = 56,
}

-- スクロールバー
local MUSIC_SLIDER_H = 768
local MUSIC_SLIDER_BUTTON_W = 22
local MUSIC_SLIDER_BUTTON_H = 48


local LEVEL_NAME_TABLE = {"Beginner", "Normal", "Hyper", "Another", "Insane"}
local JUDGE_NAME_TABLE = {"Perfect", "Great", "Good", "Bad", "Poor"}
local LAMP_NAMES = {"Max", "Perfect", "Fc", "Exhard", "Hard", "Normal", "Easy", "Lassist", "Assist", "Failed", "Noplay"}

-- スコア詳細
local SCORE_INFO = {
    TEXT_SRC_X = 1127,
    TEXT_SRC_Y = commons.PARTS_OFFSET + 263,
    TEXT_W = 168,
    TEXT_H = 22,
    TEXT_BASE_X = 95,
    TEXT_BASE_Y = 225,
    NUMBER_OFFSET_X = 273,
    NUMBER_BASE_Y = 225,
    INTERVAL_X = 292,
    INTERVAL_Y = 29,
    DIGIT = 8,
}

local JUDGE_DIFFICULTY = {
    W = 136,
    H = 22,
}

-- exscoreと楽曲難易度周り
local EXSCORE_AREA = {
    NUMBER_W = 22,
    NUMBER_H = 30,
    TEXT_X = 802,
    NUMBER_X = 1070,
    Y = 385,
    NEXT_Y = 348,

    RANKING_NUMBER_W = NORMAL_NUMBER_W,
    RANKING_NUMBER_H = NORMAL_NUMBER_H,
    IR_Y = 311,
    IR_W = 26,
    IR_H = 22,
}

local RIVAL = {
    NAME_X   = 802,
    PLAYER_Y = 385,
    RIVAL_Y  = 343,

    FONT_SIZE = 24,
    MAX_W = 178,
}

local SCORE_RANK = {
    SRC_X = 1653,
    W = 133,
    H = 59,
    X = 895,
    Y = 430,
}
local SONG_LIST = {
    LABEL = {
        X = 70,
        Y = 11,
        W = 50,
        H = 22,
    },
}

-- 左下のレベルが並んでいる部分
local LARGE_LEVEL = {
    NUMBER_H = 40,
    NUMBER_W = 30,
    X = 140,
    Y = 305,
    INTERVAL = 136,
    DOT_SIZE = 12,

    ICON_W = 105,
    SRC_X = 1128,
    NONACTIVE_ICON_H = 82,
    ACTIVE_ICON_H = 75,
    ACTIVE_TEXT_H = 31,
    ICON_X = 102,
    ICON_Y = 348,
}

local DENSITY_INFO = {
    TEXT_W = 108,
    TEXT_H = 31,

    NUMBER_Y = 305,

    ICON_W = 105,
    ICON_H = 75,
    ICON_Y = 346,

    DOT_SIZE = 7,

    DIFFICULTY_ICON_X = 102,
    DIFFICULTY_TEXT_X = 100,
    DIFFICULTY_ICON_Y = 348 - 2; -- ICON_Y - 2
    DIFFICULTY_NUMBER_X = 125,

    START_X = 316,
    INTERVAL_X = 168,
}

-- IR
local IR = {
    TEXT_W = 99,
    TEXT_H = 18,
    NUMBER_NUM_W = 11,
    NUMBER_NUM_H = 15,
    NUMBER_PERCENT_W = 7,
    NUMBER_PERCENT_H = 9,
    PERCENT_W = 9,
    PERCENT_H = 9,
    DIGIT = 5,

    X = 701,
    Y = 229,
    INTERVAL_X = 198,
    INTERVAL_Y = 25,

    LOADING = {
        FRAME_W = 249,
        FRAME_H = 62,
        FRAME_X = 681,
        FRAME_Y = 3,
        WAVE_LEVEL = 5,
        WAVE_W = 4,
        WAVE_H = 25,
        WAVE_TIME_INTERVAL = 500, -- ms
        WAITING_TEXT_W = 138,
        WAITING_TEXT_H = 21,
        LOADING_TEXT_W = 181,
        LOADING_TEXT_H = 21,
    },
}

-- 密度グラフ
local NOTES_ICON_SIZE = 42

-- オプションウィンドウ
local OPTION_INFO = {
    HEADER_H = 42,
    HEADER_TEXT_W = 269,
    WND_EDGE_SIZE = 32,
    WND_W = 1600,
    WND_H = 900,
    ACTIVE_FRAME_W = 360,
    ACTIVE_FRAME_H = 40,
    ITEM_W = 360,
    ITEM_H = 44,
    BUTTON_W = 130,
    BUTTON_H = 52,
    NUMBER_BUTTON_SIZE = 56,
    SWITCH_BUTTON_W = 302,
    SWITCH_BUTTON_H = 56,
    HEADER2_EDGE_BG_W = 16,
    HEADER2_EDGE_BG_H = 42,
    HEADER2_TEXT_SRC_X = 1709,
    HEADER2_TEXT_W = 300,
    HEADER2_TEXT_H = 42,
    BG_H = 44*5,
    NUMBER_BG_W = 240,
    NUMBER_BG_H = 46,
    NUMBER_W = 16,
    NUMBER_H = 22,
    WND_OFFSET_X = (WIDTH - 1600) / 2,
    WND_OFFSET_Y = (HEIGHT - 900) / 2,
    ANIMATION_TIME = 150,
}

local SELECT_OPTION = {
    BUTTON = {
        X = 720,
        UPPER_Y = 1022,
    },
    KEYS = {
        X = 6, -- buttonからの差分
    },
    SORT = {
        X = 6
    },
    LN = {
        X = 135
    },
}

local GRAPH = {
    WND = {
        OLD = {
            X = 1126, -- 影含まない
            Y = 72,
            W = 638, -- 影含む
            H = 178,
            SHADOW = 7,
        },
        NEW = {
            X = 1126, -- 影含まない
            Y = 47,
            W = 638, -- 影含む
            H = 203,
            SHADOW = 7,
        },
    },
    STAMINA = {
        LABEL = {
            X = 27, -- WNDからの差分
            Y = 5,
            W = 120,
            H = 20,
        },
        NUM = {
            X = 167, -- STAMINAからの差分
            Y = 1,
            W = 14,
            H = 18,
        },
    },
}

local ATTENSION_SIZE = 62

local NEW_VERSION_MSG = {
    WND = {
        START_X = WIDTH + 14,
        X = 1516,
        Y = 1012,
        W = 396,
        H = 60,
    },

    ICON = {
        X = 5,
        Y = -1,
    },

    TEXT = {
        X = 74,
        Y = 14,
    }
}

local SMALL_KEY_W = 20
local SMALL_KEY_H = 24
local HELP_WND_W = 672
local HELP_WND_H = 474
local HELP_ICON_SIZE = 56
local HELP_TEXT_H = 368
local HELP_TEXT1_W = 380
local HELP_TEXT2_W = 530

local FAVORITE = {
    W = 27,
    H = 26,
}

local header = {
    type = 5,
    name = "Social Skin" .. (DEBUG and " dev" or ""),
    w = WIDTH,
    h = HEIGHT,
    fadeout = 500,
    scene = 3000,
    input = commons.INPUT_WAIT,
    -- 使用済みリスト 910 915 920 925 930 935 940 945 950 955
    property = {
        {
            name = "背景形式", item = {{name = "画像(png)", op = 915}, {name = "動画(mp4)", op = 916}}, def = "画像(png)"
        },
        {
            name = "密度グラフ表示", item = {{name = "ON", op = 910}, {name = "OFF", op = 911}}, def = "ON"
        },
        {
            name = "フォルダのランプグラフ", item = {{name = "ON", op = 925}, {name = "OFF", op = 926}}, def = "ON"
        },
        {
            name = "フォルダのランプグラフの色", item = {{name = "デフォルト", op = 927}, {name = "独自仕様", op = 928}}, def = "独自仕様"
        },
        {
            name = "ステージファイル枠の種類", item = {{name = "枠", op = 945}, {name = "影1(ボケ)", op = 946}, {name = "影2", op = 947}, {name = "無し", op = 949}}, def = "影2"
        },
        {
            name = "バナー表示", item = {{name = "ON", op = 955}, {name = "OFF", op = 956}}, def = "ON"
        },
        {
            name = "曲情報表示形式", item = {{name = "難易度リスト", op = 935}, {name = "密度", op = 936}}, def = "密度"
        },
        {
            name = "密度の標準桁数", item = {{name = "1桁", op = 938}, {name = "2桁", op = 939}}, def = "1桁"
        },
        {
            name = "オプションのスコア目標表示", item = {{name = "非表示", op = 940}, {name = "表示", op = 941}}, def = "非表示"
        },
        {
            name = "開幕アニメーション種類", item = {{name = "無し", op = 930}, {name = "流星", op = 931}, {name = "タイル", op = 932}}, def = "無し"
        },
        {
            name = "上部プレイヤー情報仕様", item = {{name = "リザルト連携版", op = 950}, {name = "旧仕様(プレイ時間とプレイ回数等)", op = 951}}, def = "リザルト連携版"
        },
        {
            name = "新バージョン確認", item = {{name = "する", op = 998}, {name = "しない", op = 999}, def = "する"},
        },
        {
            name = "タイルアニメーション設定------------------------", item = {{name = "-"}}
        },
        {
            name = "タイルの回転方向", item = {{name = "縦", op = 920}, {name = "縦(反転)", op = 921}, {name = "横", op = 922}, {name = "横(反転)", op = "縦"}}
        },
    },
    filepath = {
        {name = "背景選択-----------------------------------------", path="../dummy/*"},
        {name = "背景(png)", path = "../select/background/*.png", def = "default"},
        {name = "背景(mp4)", path = "../select/background/*.mp4"},
        {name = "他画像-----------------------------------------", path="../dummy/*"},
        {name = "NoImage画像", path = "../select/noimage/*.png", def = "default"},

    },
    offset = {
        {name = "影2の座標と濃さ差分", x = 0, y = 0, a = 0, id = 40},
        {name = "全体設定(0で既定値)------------------------------", x = 0},
        {name = "FOV (既定値90 -1で平行投影 0<x<180 or x=-1)", x = 0},
        {name = "流星群(0で既定値)--------------------------------", x = 0},
        {name = "流星アニメーション時間(ms 既定値1500 0<x)", x = 0},
        {name = "流星アニメーション開始時間オフセット(ms 既定値0 0<=x<流星アニメーション時間)", x = 0},
        {name = "本数(既定値6 0<x)", x = 0},
        {name = "各流星のズレ(既定値300)", x = 0},
        {name = "角度(既定値-20)", a = 0},
        {name = "虹の彩度(既定値13 0<=x<=100)", x = 0},
        {name = "虹の明度(既定値100 0<=x<=100)", x = 0},
        {name = "星の大きさ(% 既定値100)", x = 0},
        {name = "星の回転量(既定値1800)", a = 0},
        {name = "星屑の量(既定値60)", x = 0},
        {name = "星屑の最大の大きさ(既定値64)", x = 0},
        {name = "星屑の最小の大きさ(既定値28)", x = 0},
        {name = "星屑の回転量(既定値480)", a = 0},
        {name = "星屑のアニメーション時間(既定値1500)", x = 0},
        {name = "星屑の角度のばらつき(既定値40)", a = 0},
        {name = "星屑の移動量(既定値4000)", x = 0},
        {name = "星屑の彩度(既定値40 0<=x<=100)", x = 0},
        {name = "星屑の明度(既定値100 0<=x<=100)", x = 0},
        {name = "背景色(既定値0 0<=r,g,b<=255 仕様の都合でrgbはそれぞれxywに割り当て)", x = 0, y = 0, w = 0},
        {name = "タイル(0で既定値)------------------------------", x = 0},
        {name = "タイルアニメーション開始時間オフセット(ms 既定値0 0<=x<500)", x = 0},
        {name = "伝播の起点座標(既定値0,0 画面左下原点)", x = 0, y = 0},
        {name = "画面分割数(既定値16,16 x,y>0)", x = 0, y = 0},
        {name = "伝播速度(10ms毎のpx数 既定値40 x>0)", x = 0},
        {name = "タイルの回転時間(既定値300 x>0)", x = 0},
        {name = "各タイルの回転開始時間のばらつき(既定値150 x>0)", x = 0},
        {name = "タイル回転の分割時間(このms毎に分割 規定値125 x>0)", x = 0},
        {name = "タイルの分割数(このpx毎に分割 既定値8 x>0)", x = 0},
        {name = "タイルが透明になるまでの時間の割合(既定値90 0<=x<=100)", x = 0},
        {name = "タイルの色(既定値0 0<=r,g,b<=255 rgbはそれぞれxywに割り当て)", x = 0, y = 0, w = 0},
    }
}

local function isViewFolderLampGraph()
    return getTableValue(skin_config.option, "フォルダのランプグラフ", 925) == 925
end

local function isDefaultLampGraphColor()
    return getTableValue(skin_config.option, "フォルダのランプグラフの色", 927) == 927
end

local function isCheckNewVersion()
    return getTableValue(skin_config.option, "新バージョン確認", 998) == 998 and userData.nextVersionCheckDate <= os.time()
end

local function isShowBanner()
    return getTableValue(skin_config.option, "バナー表示", 955) == 955
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local function insertOptionAnimationTable(skin, id, op, x, y, width, height, angle, r, g, b)
    if r == nil then
        r = 255
    end
    if g == nil then
        g = 255
    end
    if b == nil then
        b = 255
    end

    -- 消えるとき 上の出現中が消えると同時に表示され, 消失までアニメーション
    table.insert(skin.destination, {
        id = id, op = {-op}, timer = op + 10, loop = OPTION_INFO.ANIMATION_TIME,
        dst = {
            {time = 0, x = x, y = y, w = width, h = height, angle = angle, r = r, g = g, b = b},
            {time = OPTION_INFO.ANIMATION_TIME - 1, x = BASE_WIDTH / 2, y = BASE_HEIGHT / 2, w = 0, h = 0, a = 255},
            {time = OPTION_INFO.ANIMATION_TIME}
        }
    })
    -- 出現時
    table.insert(skin.destination, {
        id = id, op = {op}, timer = op, loop = OPTION_INFO.ANIMATION_TIME,
        dst = {
            {time = 0, x = BASE_WIDTH / 2, y = BASE_HEIGHT / 2, w = 0, h = 0, angle = angle, r = r, g = g, b = b},
            {time = OPTION_INFO.ANIMATION_TIME - 1, x = x, y = y, w = width, h = height},
            {time = OPTION_INFO.ANIMATION_TIME, x = 0, y = 0, w = 0, h = 0},
        }
    })
    -- 出現中
    table.insert(skin.destination, {
        id = id, op = {op}, timer = op, loop = OPTION_INFO.ANIMATION_TIME,
        dst = {
            {time = 0, x = x, y = y, w = width, h = height, angle = angle, a = 0, r = r, g = g, b = b},
            {time = OPTION_INFO.ANIMATION_TIME - 1, a = 0},
            {time = OPTION_INFO.ANIMATION_TIME, a = 255},
        }
    })
end

local function loadOptionImgs(skin, optionTexts, optionIdPrefix, ref, x, y)
    local optionActiveTextSuffix = optionIdPrefix .. "OptionImgActive"
    local optionNonactiveTextSuffix = optionIdPrefix .. "OptionImgNonactive"
    local activeImages = {}
    local nonactiveImages = {}
    local viewRange = 5

    for i, val in ipairs(optionTexts) do
        table.insert(skin.image, {
            id = val .. optionActiveTextSuffix, src = 2, x = x + OPTION_INFO.ITEM_W, y = y + OPTION_INFO.ITEM_H * (i + 1),
            w = OPTION_INFO.ITEM_W, h = OPTION_INFO.ITEM_H
        })
        table.insert(skin.image, {
            id = val .. optionNonactiveTextSuffix, src = 2, x = x, y = y + OPTION_INFO.ITEM_H * (i + 1 - (viewRange - 1) / 2),
            w = OPTION_INFO.ITEM_W, h = OPTION_INFO.ITEM_H * viewRange
        })
        if ref == 77 then -- pacemakerだけ逆順
            table.insert(activeImages, 1, val .. optionActiveTextSuffix)
            table.insert(nonactiveImages, 1, val .. optionNonactiveTextSuffix)
        else
            table.insert(activeImages, val .. optionActiveTextSuffix)
            table.insert(nonactiveImages, val .. optionNonactiveTextSuffix)
        end
    end

    table.insert(skin.imageset, {
        id = optionIdPrefix .. "Active", ref = ref, images = activeImages
    })
    table.insert(skin.imageset, {
        id = optionIdPrefix .. "Nonactive", ref = ref, images = nonactiveImages
    })
end

local function destinationOptionHeader2(skin, baseX, baseY, width, titleTextId, activeKeys, op)
    local keyOffset = 16

    -- 各オプションヘッダBG出力
    insertOptionAnimationTable(skin, SUB_HEADER.EDGE.LEFT_ID, op, baseX, baseY, SUB_HEADER.EDGE.W, SUB_HEADER.EDGE.H, 0)
    insertOptionAnimationTable(skin, SUB_HEADER.EDGE.RIGHT_ID, op, baseX + width - SUB_HEADER.EDGE.W, baseY, SUB_HEADER.EDGE.W, SUB_HEADER.EDGE.H, 0)
    insertOptionAnimationTable(skin, "gray2", op, baseX + SUB_HEADER.EDGE.W, baseY, width - SUB_HEADER.EDGE.W * 2, SUB_HEADER.EDGE.H, 0)

    -- オプションヘッダテキスト出力
    insertOptionAnimationTable(skin, titleTextId, op, baseX + 20, baseY, OPTION_INFO.HEADER2_TEXT_W, OPTION_INFO.HEADER2_TEXT_H, 0)

    -- オプションの使用キー出力
    for i = 1, 7 do
        if not has_value(activeKeys, i) then
            local y = baseY + 3
            if i % 2 == 0 then -- 上のキーは座標足す
                y = y + SMALL_KEY_H - 6 * 2
            end
            insertOptionAnimationTable(skin, "optionSmallKeyNonActive", op, baseX + width - keyOffset - (8 - i) * (SMALL_KEY_W - 12) + 6 - 20, y, SMALL_KEY_W, SMALL_KEY_H, 0)
        end
    end
    for i = 1, 7 do
        if has_value(activeKeys, i) then
            local y = baseY + 3
            if i % 2 == 0 then -- 上のキーは座標足す
                y = y + SMALL_KEY_H - 6 * 2
            end
            insertOptionAnimationTable(skin, "optionSmallKeyActive", op, baseX + width - keyOffset - (8 - i) * (SMALL_KEY_W - 12) + 6 - 20, y, SMALL_KEY_W, SMALL_KEY_H, 0)
        end
    end
end

--- baseX: 右端X, baseY: 下へボタンの最下部(影含む), activeKeys: オプション変更に使用するキー(配列)
local function destinationPlayOption(skin, baseX, baseY, titleTextId, optionIdPrefix, isLarge, activeKeys, op)
    local width = 640
    local headerOffset = 346
    if isLarge == false then
        width = 480
    end
    local optionBoxOffsetX = (width - OPTION_INFO.ITEM_W) / 2
    local optionButtonOffsetX = (width - OPTION_INFO.BUTTON_W) / 2
    local optionItemOffsetY = 57
    local viewRange = 5

    -- ヘッダ出力
    destinationOptionHeader2(skin, baseX, baseY + headerOffset, width, titleTextId, activeKeys, op)

    -- オプション一覧背景
    insertOptionAnimationTable(skin, "optionSelectBg", op, baseX + optionBoxOffsetX, baseY + optionItemOffsetY, OPTION_INFO.ITEM_W, OPTION_INFO.BG_H, 0)

    -- オプション出力
    insertOptionAnimationTable(skin, optionIdPrefix .. "Nonactive", op, baseX + optionBoxOffsetX, baseY + optionItemOffsetY                             , OPTION_INFO.ITEM_W        , OPTION_INFO.ITEM_H * viewRange, 0)
    insertOptionAnimationTable(skin, "activeOptionFrame"          , op, baseX + optionBoxOffsetX, baseY + optionItemOffsetY + OPTION_INFO.ITEM_H * 2 + 2, OPTION_INFO.ACTIVE_FRAME_W, OPTION_INFO.ACTIVE_FRAME_H, 0)
    insertOptionAnimationTable(skin, optionIdPrefix .. "Active"   , op, baseX + optionBoxOffsetX, baseY + optionItemOffsetY + OPTION_INFO.ITEM_H * 2    , OPTION_INFO.ITEM_W        , OPTION_INFO.ITEM_H, 0)


    -- ボタン出力
    insertOptionAnimationTable(skin, optionIdPrefix .. "UpButton", op, baseX + optionButtonOffsetX, baseY + 282, OPTION_INFO.BUTTON_W, OPTION_INFO.BUTTON_H, 0)
    -- 下
    insertOptionAnimationTable(skin, optionIdPrefix .. "DownButton", op, baseX + optionButtonOffsetX, baseY, OPTION_INFO.BUTTON_W, OPTION_INFO.BUTTON_H, 0)
end

local function destinationNumberOption(skin, baseX, baseY, titleTextId, optionIdPrefix, isLarge, activeKeys, op)
    local width = 640
    local height = 113
    local digit = 4
    if isLarge == false then
        width = 480
    end
    local optionBoxOffsetX = (width - OPTION_INFO.NUMBER_BG_W) / 2
    local optionButtonOffsetX = (width - OPTION_INFO.BUTTON_W) / 2
    local optionOffsetY = 5

    -- ヘッダ出力
    destinationOptionHeader2(skin, baseX, baseY + height - HEADER.MARKER.H, width, titleTextId, activeKeys, op)

    -- オプション背景
    insertOptionAnimationTable(skin, "optionNumberBg", op, baseX + optionBoxOffsetX, baseY + optionOffsetY, OPTION_INFO.NUMBER_BG_W, OPTION_INFO.NUMBER_BG_H, 0)

    -- 数値出力
    insertOptionAnimationTable(skin, optionIdPrefix, op,
        baseX + width / 2 - OPTION_INFO.NUMBER_W * (digit - 0.5) - 4,
        baseY + optionOffsetY + 12,
        OPTION_INFO.NUMBER_W, OPTION_INFO.NUMBER_H, 0)

    -- ms出力
    insertOptionAnimationTable(skin, "millisecondTextImg", op,
        baseX + width / 2 + 6,
        baseY + optionOffsetY + 12,
        39, OPTION_INFO.NUMBER_H, 0)

    -- ボタン出力
    -- beatorajaの現バージョンは未実装
    insertOptionAnimationTable(skin, optionIdPrefix .. "DownButton", op,
        baseX + width / 2 - 186,
        baseY,
        OPTION_INFO.NUMBER_BUTTON_SIZE, OPTION_INFO.NUMBER_BUTTON_SIZE, 0)

    insertOptionAnimationTable(skin, optionIdPrefix .. "UpButton", op,
        baseX + width / 2 + 186 - OPTION_INFO.NUMBER_BUTTON_SIZE,
        baseY,
        OPTION_INFO.NUMBER_BUTTON_SIZE, OPTION_INFO.NUMBER_BUTTON_SIZE, 0)

end

--- appearTime >= fadeTime
local function destinationSmallKeysInHelp(skin, baseX, baseY, activeKeys, appearTime, viewTime, fadeTime, loopTime)
    -- 小さいキー
    for i = 1, 7 do
        if not has_value(activeKeys, i) then
            local y = baseY - 6
            if i % 2 == 0 then -- 上のキーは座標足す
                y = y + SMALL_KEY_H - 6 * 2
            end
            table.insert(skin.destination, {
                id = "optionSmallKeyNonActive", op = {23}, timer = 23, dst = {
                    {time = 0, a = 0},
                    {time = appearTime - fadeTime, a = 0, x = baseX + (i - 1) * (SMALL_KEY_W - 12) - 6, y = y, w = SMALL_KEY_W, h = SMALL_KEY_H},
                    {time = appearTime, a = 255, x = baseX + (i - 1) * (SMALL_KEY_W - 12) - 6, y = y, w = SMALL_KEY_W, h = SMALL_KEY_H},
                    {time = appearTime + viewTime, a = 255},
                    {time = appearTime + viewTime + fadeTime, a = 0},
                    {time = loopTime, a = 0},
                }
            })
        end
    end
    for i = 1, 7 do
        if has_value(activeKeys, i) then
            local y = baseY - 6
            if i % 2 == 0 then -- 上のキーは座標足す
                y = y + SMALL_KEY_H - 6 * 2
            end
            table.insert(skin.destination, {
                id = "optionSmallKeyActive", op = {23}, timer = 23, dst = {
                    {time = 0, a = 0},
                    {time = appearTime - fadeTime, a = 0, x = baseX + (i - 1) * (SMALL_KEY_W - 12) - 6, y = y, w = SMALL_KEY_W, h = SMALL_KEY_H},
                    {time = appearTime, a = 255, x = baseX + (i - 1) * (SMALL_KEY_W - 12) - 6, y = y, w = SMALL_KEY_W, h = SMALL_KEY_H},
                    {time = appearTime + viewTime, a = 255},
                    {time = appearTime + viewTime + fadeTime, a = 0},
                    {time = loopTime, a = 0},
                }
            })
        end
    end
end

local function main()
	local skin = {}
	-- ヘッダ情報をスキン本体にコピー
	for k, v in pairs(header) do
		skin[k] = v
    end

    globalInitialize(skin)
    opening.init()

    -- バージョンチェック
    if isCheckNewVersion() then
        local v1, v2, v3, v4 = skinVersionCheck(SKIN_INFO.SELECT_VRESION, SKIN_INFO.RESULT_VERSION, SKIN_INFO.DECIDE_VERSION, SKIN_INFO.PLAY_VERSION)
        existNewVersion = v1 or v2 or v3 or v4
        userData.updateNextVersionCheckDate()
    end

    skin.source = {
        {id = 0, path = "../select/parts/parts.png"},
        {id = 8, path = "../select/parts/parts2.png"},
        {id = 1, path = "../select/background/*.png"},
        {id = 101, path = "../select/background/*.mp4"},
        {id = 2, path = "../select/parts/option.png"},
        {id = 3, path = "../select/parts/help.png"},
        {id = 4, path = "../select/parts/stagefile_frame.png"},
        {id = 6, path = "../select/parts/lamp_gauge_rainbow.png"},
        {id = 7, path = "../select/noimage/*.png"},
        {id = 999, path = "../common/colors/colors.png"}
    }

    table.insert(skin.customTimers, {id = 10002, timer = "calcStamina"})
    table.insert(skin.customTimers, {id = 10003, timer = "updateStamina"})
    table.insert(skin.customTimers, {id = 10006, timer = "updateStaminaGauge"}) -- スタミナゲージ表示用タイマー
    table.insert(skin.customTimers, {id = 10007, timer = "updateUseStamina"}) -- スタミナ使用量更新用タイマー
    table.insert(skin.customTimers, {id = 10008, timer = "newVersionAnimation"}) -- 新バージョンがある時の文字表示用
    table.insert(skin.customTimers, {id = 10009, timer = "helpTimer"}) -- ヘルプ画面全体のタイマー
    table.insert(skin.customTimers, {id = 13009, timer = "keyInput"}) -- ヘルプ画面全体のタイマー
    for i = 1, 490 do
        table.insert(skin.customTimers, {id = 10010 + (i - 1)}) -- 10010~10499までヘルプ用で予約 増えるかもしれないので500くらい余裕見ておく
    end
    table.insert(skin.customTimers, {id = statistics.getWindowTimerId(), timer = "statisticsTimer"}) -- 統計画面全体のタイマー
    table.insert(skin.customTimers, {id = 13000, timer = "update"})

    skin.customEvents = {} -- 1000~未定はヘルプ

    skin.image = {
        {id = "baseFrame", src = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT},
        {id = "stagefileFrame", src = 4, x = 0, y = 0, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2},
        {id = "stagefileShadow", src = 4, x = 0, y = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2},
        {id = "noImage", src = 7, x = 0, y = 0, w = -1, h = -1},
        -- 選曲バー種類
        {id = "barSong"   , src = 0, x = 0, y = commons.PARTS_OFFSET, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barNosong" , src = 0, x = 0, y = commons.PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*1, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barGrade"  , src = 0, x = 0, y = commons.PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*2, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barNograde", src = 0, x = 0, y = commons.PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*2, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barFolder" , src = 0, x = 0, y = commons.PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*3, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barFolderWithLamp" , src = 0, x = 0, y = commons.PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*7, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barTable"  , src = 0, x = 0, y = commons.PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*4, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barTableWithLamp"  , src = 0, x = 0, y = commons.PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*8, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barCommand", src = 0, x = 0, y = commons.PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*5, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barCommandWithLamp", src = 0, x = 0, y = commons.PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*9, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barSearch" , src = 0, x = 0, y = commons.PARTS_OFFSET, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        -- 選曲バークリアランプはimagesの後
        -- 選曲バー中央
        {id = "barCenterFrame", src = 0, x = 0, y = commons.PARTS_OFFSET + 782, w = 714, h = 154},
        -- 選曲バーLN表示
        {id = "barLn"    , src = 0, x = 607, y = commons.PARTS_OFFSET + 16 + SONG_LIST.LABEL.H*0, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
        {id = "barRandom", src = 0, x = 607, y = commons.PARTS_OFFSET + 16 + SONG_LIST.LABEL.H*1, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
        {id = "barBomb"  , src = 0, x = 607, y = commons.PARTS_OFFSET + 16 + SONG_LIST.LABEL.H*2, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
        {id = "barCn"    , src = 0, x = 607, y = commons.PARTS_OFFSET + 16 + SONG_LIST.LABEL.H*3, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
        {id = "barHcn"   , src = 0, x = 607, y = commons.PARTS_OFFSET + 16 + SONG_LIST.LABEL.H*4, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
        -- Favorite
        -- {id = "favoriteButton", src = 0, x = 1563, y = 263, w = FAVORITE.W*2, h = FAVORITE.H, divx = 2, act = 9999},
        -- トロフィー
        {id ="goldTrophy"  , src = 0, x = 1896, y = commons.PARTS_OFFSET + MUSIC_BAR.TROPHY_H*0, w = MUSIC_BAR.TROPHY_W, h = MUSIC_BAR.TROPHY_H},
        {id ="silverTrophy", src = 0, x = 1896, y = commons.PARTS_OFFSET + MUSIC_BAR.TROPHY_H*1, w = MUSIC_BAR.TROPHY_W, h = MUSIC_BAR.TROPHY_H},
        {id ="bronzeTrophy", src = 0, x = 1896, y = commons.PARTS_OFFSET + MUSIC_BAR.TROPHY_H*2, w = MUSIC_BAR.TROPHY_W, h = MUSIC_BAR.TROPHY_H},
        -- プレイ
        {id = "playButton", src = 0, x = 773, y = commons.PARTS_OFFSET + 377, w = DECIDE_BUTTON_W, h = DECIDE_BUTTON_H},
        {id = "playButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 15}, -- ボタン起動用ダミー
        {id = "autoButton", src = 0, x = 773, y = commons.PARTS_OFFSET + 377 + DECIDE_BUTTON_H, w = AUTO_BUTTON_W, h = AUTO_BUTTON_H},
        {id = "autoButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 16}, -- ボタン起動用ダミー
        {id = "replayButtonBg", src = 0, x = 773 + AUTO_BUTTON_W, y = commons.PARTS_OFFSET + 377 + DECIDE_BUTTON_H, w = REPLAY_BUTTON_SIZE, h = REPLAY_BUTTON_SIZE},
        {id = "replay1Text", src = 0, x = 773 + AUTO_BUTTON_W + REPLAY_BUTTON_SIZE + REPLAY_TEXT_W*0, y = commons.PARTS_OFFSET + 377 + DECIDE_BUTTON_H, w = REPLAY_TEXT_W, h = REPLAY_TEXT_H},
        {id = "replay2Text", src = 0, x = 773 + AUTO_BUTTON_W + REPLAY_BUTTON_SIZE + REPLAY_TEXT_W*1, y = commons.PARTS_OFFSET + 377 + DECIDE_BUTTON_H, w = REPLAY_TEXT_W, h = REPLAY_TEXT_H},
        {id = "replay3Text", src = 0, x = 773 + AUTO_BUTTON_W + REPLAY_BUTTON_SIZE + REPLAY_TEXT_W*2, y = commons.PARTS_OFFSET + 377 + DECIDE_BUTTON_H, w = REPLAY_TEXT_W, h = REPLAY_TEXT_H},
        {id = "replay4Text", src = 0, x = 773 + AUTO_BUTTON_W + REPLAY_BUTTON_SIZE + REPLAY_TEXT_W*3, y = commons.PARTS_OFFSET + 377 + DECIDE_BUTTON_H, w = REPLAY_TEXT_W, h = REPLAY_TEXT_H},
        {id = "replay1ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 19}, -- ボタン起動用ダミー
        {id = "replay2ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 316}, -- ボタン起動用ダミー
        {id = "replay3ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 317}, -- ボタン起動用ダミー
        {id = "replay4ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 318}, -- ボタン起動用ダミー

        -- 段位, コースの曲一覧部分
        {id = "courseBarBg", src = 0, x = 0, y = commons.PARTS_OFFSET + 468, w = COURSE.BG_W, h = COURSE.LABEL_H + 14},
        {id = "courseMusic1Label", src = 0, x = 773, y = commons.PARTS_OFFSET + 519 + COURSE.LABEL_H*0, w = COURSE.LABEL_W, h = COURSE.LABEL_H},
        {id = "courseMusic2Label", src = 0, x = 773, y = commons.PARTS_OFFSET + 519 + COURSE.LABEL_H*1, w = COURSE.LABEL_W, h = COURSE.LABEL_H},
        {id = "courseMusic3Label", src = 0, x = 773, y = commons.PARTS_OFFSET + 519 + COURSE.LABEL_H*2, w = COURSE.LABEL_W, h = COURSE.LABEL_H},
        {id = "courseMusic4Label", src = 0, x = 773, y = commons.PARTS_OFFSET + 519 + COURSE.LABEL_H*3, w = COURSE.LABEL_W, h = COURSE.LABEL_H},
        {id = "courseMusic5Label", src = 0, x = 773, y = commons.PARTS_OFFSET + 519 + COURSE.LABEL_H*4, w = COURSE.LABEL_W, h = COURSE.LABEL_H},
        -- コースのオプション
        {id = "courseBgEdgeLeft"   , src = 0, x = 1811                              , y = PARTS_TEXTURE_SIZE - COURSE.OPTION.BG_H, w = COURSE.OPTION.BG_EDGE_W, h = COURSE.OPTION.BG_H},
        {id = "courseBgMiddle"     , src = 0, x = 1811 + COURSE.OPTION.BG_EDGE_W    , y = PARTS_TEXTURE_SIZE - COURSE.OPTION.BG_H, w = 1, h = COURSE.OPTION.BG_H},
        {id = "courseBgMiddleRight", src = 0, x = 1811 + COURSE.OPTION.BG_EDGE_W + 1, y = PARTS_TEXTURE_SIZE - COURSE.OPTION.BG_H, w = COURSE.OPTION.BG_EDGE_W, h = COURSE.OPTION.BG_H},
        {id = "courseHeaderBg"     , src = 0, x = 1898, y = commons.PARTS_OFFSET + 168 + COURSE.OPTION.HEADER_H*0, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H},
        {id = "courseHeaderOption" , src = 0, x = 1898, y = commons.PARTS_OFFSET + 168 + COURSE.OPTION.HEADER_H*1, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H},
        {id = "courseHeaderHiSpeed", src = 0, x = 1898, y = commons.PARTS_OFFSET + 168 + COURSE.OPTION.HEADER_H*2, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H},
        {id = "courseHeaderJudge"  , src = 0, x = 1898, y = commons.PARTS_OFFSET + 168 + COURSE.OPTION.HEADER_H*3, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H},
        {id = "courseHeaderGauge"  , src = 0, x = 1898, y = commons.PARTS_OFFSET + 168 + COURSE.OPTION.HEADER_H*4, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H},
        {id = "courseHeaderLnType" , src = 0, x = 1898, y = commons.PARTS_OFFSET + 168 + COURSE.OPTION.HEADER_H*5, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H},
        {id = "courseSettingClass"      , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*0, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingMirror"     , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*1, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingRandom"     , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*2, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingNoSpeed"    , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*3, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingNoGood"     , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*4, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingNoGreat"    , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*5, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingGaugeLR2"   , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*6, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingGauge5Keys" , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*7, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingGauge7Keys" , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*8, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingGauge9Keys" , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*9, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingGauge24Keys", src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*10, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingGaugeLn"    , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*11, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingGaugeCn"    , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*12, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingGaugeHcn"   , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*13, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        {id = "courseSettingNoSetting"  , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*14, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},

        -- レベルアイコン
        {id = "nonActiveBeginnerIcon", src = 0, x = LARGE_LEVEL.SRC_X, y = commons.PARTS_OFFSET, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.NONACTIVE_ICON_H},
        {id = "nonActiveNormalIcon"  , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*1, y = commons.PARTS_OFFSET, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.NONACTIVE_ICON_H},
        {id = "nonActiveHyperIcon"   , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*2, y = commons.PARTS_OFFSET, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.NONACTIVE_ICON_H},
        {id = "nonActiveAnotherIcon" , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*3, y = commons.PARTS_OFFSET, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.NONACTIVE_ICON_H},
        {id = "nonActiveInsaneIcon"  , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*4, y = commons.PARTS_OFFSET, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.NONACTIVE_ICON_H},
        {id = "activeBeginnerIcon"   , src = 0, x = LARGE_LEVEL.SRC_X, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "activeNormalIcon"     , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*1, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "activeHyperIcon"      , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*2, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "activeAnotherIcon"    , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*3, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "activeInsaneIcon"     , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*4, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "activeBeginnerText"   , src = 0, x = LARGE_LEVEL.SRC_X, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_TEXT_H},
        {id = "activeNormalText"     , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*1, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_TEXT_H},
        {id = "activeHyperText"      , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*2, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_TEXT_H},
        {id = "activeAnotherText"    , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*3, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_TEXT_H},
        {id = "activeInsaneText"     , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*4, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_TEXT_H},
        {id = "activeBeginnerNote"   , src = 0, x = LARGE_LEVEL.SRC_X, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_TEXT_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "activeNormalNote"     , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*1, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_TEXT_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "activeHyperNote"      , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*2, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_TEXT_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "activeAnotherNote"    , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*3, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_TEXT_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "activeInsaneNote"     , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*4, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_TEXT_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        -- 密度アイコン 難易度アイコン部分のアイコン表示は上ので読み込み済み
        -- 今のところのソースは, 平均はnormal, 終わり100notesはhyper, 最大値はanotherアイコン
        -- dstはdensity用の値 DENSITY_INFO参照
        {id = "densityAverageIcon"   , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*1, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "densityEndIcon"       , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*2, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "densityPeakIcon"      , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*3, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "densityAverageNote"   , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*1, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_TEXT_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "densityEndNote"       , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*2, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_TEXT_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "densityPeakNote"      , src = 0, x = LARGE_LEVEL.SRC_X + LARGE_LEVEL.ICON_W*3, y = commons.PARTS_OFFSET + LARGE_LEVEL.NONACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_ICON_H + LARGE_LEVEL.ACTIVE_TEXT_H, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
        {id = "densityDifficultyBeginnerText", src = 0, x = 1788, y = commons.PARTS_OFFSET + DENSITY_INFO.TEXT_H*0, w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H},
        {id = "densityDifficultyNormalText"  , src = 0, x = 1788, y = commons.PARTS_OFFSET + DENSITY_INFO.TEXT_H*1, w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H},
        {id = "densityDifficultyHyperText"   , src = 0, x = 1788, y = commons.PARTS_OFFSET + DENSITY_INFO.TEXT_H*2, w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H},
        {id = "densityDifficultyAnotherText" , src = 0, x = 1788, y = commons.PARTS_OFFSET + DENSITY_INFO.TEXT_H*3, w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H},
        {id = "densityDifficultyInsaneText"  , src = 0, x = 1788, y = commons.PARTS_OFFSET + DENSITY_INFO.TEXT_H*4, w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H},
        {id = "densityAverageText" , src = 0, x = 1788, y = commons.PARTS_OFFSET + DENSITY_INFO.TEXT_H*5, w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H},
        {id = "densityEndText"     , src = 0, x = 1788, y = commons.PARTS_OFFSET + DENSITY_INFO.TEXT_H*6, w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H},
        {id = "densityPeakText"    , src = 0, x = 1788, y = commons.PARTS_OFFSET + DENSITY_INFO.TEXT_H*7, w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H},
        -- 密度表示部分のdot
        {id = "densityAverageDot", src = 0, x = 931, y = commons.PARTS_OFFSET + 35 + MUSIC_BAR.DIFFICULTY_NUMBER_H*1, w = DENSITY_INFO.DOT_SIZE, h = DENSITY_INFO.DOT_SIZE},
        {id = "densityEndDot"    , src = 0, x = 931, y = commons.PARTS_OFFSET + 35 + MUSIC_BAR.DIFFICULTY_NUMBER_H*2, w = DENSITY_INFO.DOT_SIZE, h = DENSITY_INFO.DOT_SIZE},
        {id = "densityPeakDot"   , src = 0, x = 931, y = commons.PARTS_OFFSET + 35 + MUSIC_BAR.DIFFICULTY_NUMBER_H*3, w = DENSITY_INFO.DOT_SIZE, h = DENSITY_INFO.DOT_SIZE},

        -- 楽曲のkeys
        {id = "music7keys" , src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*0, y = commons.PARTS_OFFSET + 105, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        {id = "music5keys" , src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*2, y = commons.PARTS_OFFSET + 105, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        {id = "music14keys", src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*4, y = commons.PARTS_OFFSET + 105, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        {id = "music10keys", src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*6, y = commons.PARTS_OFFSET + 105, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        {id = "music9keys" , src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*0, y = commons.PARTS_OFFSET + 105 + NORMAL_NUMBER_H, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        {id = "music24keys", src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*2, y = commons.PARTS_OFFSET + 105 + NORMAL_NUMBER_H, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        {id = "music48keys", src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*4, y = commons.PARTS_OFFSET + 105 + NORMAL_NUMBER_H, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        -- オプションのkeys
        {id = "upperOptionButtonBg" , src = 2, x = 1321, y = PARTS_TEXTURE_SIZE - UPPER_OPTION_H, w = UPPER_OPTION_W, h = UPPER_OPTION_H},
        {id = "keysSet", src = 2, x = 1441, y = 836, w = 129, h = OPTION_INFO.ITEM_H * 8, divy = 8, len = 8, ref = 11, act = 11},
        -- オプションのLNモード
        {id = "lnModeSet" , src = 2, x = 1570, y = 836, w = 129, h = OPTION_INFO.ITEM_H * 3, divy = 3, len = 3, ref = 308, act = 308},
        -- ソート
        {id = "sortModeSet" , src = 2, x = 1699, y = 836, w = 258, h = OPTION_INFO.ITEM_H * 8, divy = 8, len = 8, ref = 12, act = 12},

        -- 空プア表記用スラッシュ
        {id = "slashForEmptyPoor", src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W * 11, y = NORMAL_NUMBER_SRC_Y, w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H},
        -- ランキング用スラッシュ(同じ)
        {id = "slashForRanking"  , src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W * 11, y = NORMAL_NUMBER_SRC_Y, w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H},
        -- BPM用チルダ
        {id = "bpmTilda", src = 0, x = NORMAL_NUMBER_SRC_X, y = commons.PARTS_OFFSET + 68, w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H},
        -- 判定難易度
        {id = "judgeEasy"    , src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + JUDGE_DIFFICULTY.H * 0, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H},
        {id = "judgeNormal"  , src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + JUDGE_DIFFICULTY.H * 1, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H},
        {id = "judgeHard"    , src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + JUDGE_DIFFICULTY.H * 2, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H},
        {id = "judgeVeryhard", src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + JUDGE_DIFFICULTY.H * 3, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H},
        -- アクティブなオブション用背景
        {id = "activeOptionFrame", src = 2, x = 0, y = PARTS_TEXTURE_SIZE - OPTION_INFO.ACTIVE_FRAME_H, w = OPTION_INFO.ACTIVE_FRAME_W, h = OPTION_INFO.ACTIVE_FRAME_H},
        -- オプション画面の端
        {id = "optionWndEdge", src = 2, x = 360, y = PARTS_TEXTURE_SIZE - OPTION_INFO.WND_EDGE_SIZE, w = OPTION_INFO.WND_EDGE_SIZE, h = OPTION_INFO.WND_EDGE_SIZE},
        -- オプションのヘッダテキスト
        {id = "optionHeaderPlayOption", src = 2, x = 1441, y = 0, w = OPTION_INFO.HEADER_TEXT_W, h = HEADER.MARKER.H},
        {id = "optionHeaderAssistOption", src = 2, x = 1441, y = HEADER.MARKER.H, w = OPTION_INFO.HEADER_TEXT_W, h = HEADER.MARKER.H},
        {id = "optionHeaderOtherOption", src = 2, x = 1441, y = HEADER.MARKER.H * 2, w = OPTION_INFO.HEADER_TEXT_W, h = HEADER.MARKER.H},
        -- オプション用キー
        {id = "optionSmallKeyActive", src = 2, x = 673, y = PARTS_TEXTURE_SIZE - SMALL_KEY_H * 2, w = SMALL_KEY_W, h = SMALL_KEY_H},
        {id = "optionSmallKeyNonActive", src = 2, x = 673, y = PARTS_TEXTURE_SIZE - SMALL_KEY_H, w = SMALL_KEY_W, h = SMALL_KEY_H},
        -- 各オプション選択部分背景
        {id = "optionSelectBg", src = 2, x = 0, y = 1568, w = OPTION_INFO.ITEM_W, h = OPTION_INFO.BG_H},
        {id = "optionNumberBg", src = 2, x = 0, y = 1788, w = OPTION_INFO.NUMBER_BG_W, h = OPTION_INFO.NUMBER_BG_H},
        -- 各オプションヘッダテキスト
        {id = "optionHeader2NotesOrder1"     , src = 2, x = OPTION_INFO.HEADER2_TEXT_SRC_X, y = 0, w = OPTION_INFO.HEADER2_TEXT_W, h = OPTION_INFO.HEADER2_TEXT_H},
        {id = "optionHeader2NotesOrder2"     , src = 2, x = OPTION_INFO.HEADER2_TEXT_SRC_X, y = OPTION_INFO.HEADER2_TEXT_H * 1, w = OPTION_INFO.HEADER2_TEXT_W, h = OPTION_INFO.HEADER2_TEXT_H},
        {id = "optionHeader2GaugeType"       , src = 2, x = OPTION_INFO.HEADER2_TEXT_SRC_X, y = OPTION_INFO.HEADER2_TEXT_H * 2, w = OPTION_INFO.HEADER2_TEXT_W, h = OPTION_INFO.HEADER2_TEXT_H},
        {id = "optionHeader2DpOption"        , src = 2, x = OPTION_INFO.HEADER2_TEXT_SRC_X, y = OPTION_INFO.HEADER2_TEXT_H * 3, w = OPTION_INFO.HEADER2_TEXT_W, h = OPTION_INFO.HEADER2_TEXT_H},
        {id = "optionHeader2FixedHiSpeed"    , src = 2, x = OPTION_INFO.HEADER2_TEXT_SRC_X, y = OPTION_INFO.HEADER2_TEXT_H * 4, w = OPTION_INFO.HEADER2_TEXT_W, h = OPTION_INFO.HEADER2_TEXT_H},
        {id = "optionHeader2GaugeAutoShift"  , src = 2, x = OPTION_INFO.HEADER2_TEXT_SRC_X, y = OPTION_INFO.HEADER2_TEXT_H * 5, w = OPTION_INFO.HEADER2_TEXT_W, h = OPTION_INFO.HEADER2_TEXT_H},
        {id = "optionHeader2BgaShow"         , src = 2, x = OPTION_INFO.HEADER2_TEXT_SRC_X, y = OPTION_INFO.HEADER2_TEXT_H * 6, w = OPTION_INFO.HEADER2_TEXT_W, h = OPTION_INFO.HEADER2_TEXT_H},
        {id = "optionHeader2NotesDisplayTime", src = 2, x = OPTION_INFO.HEADER2_TEXT_SRC_X, y = OPTION_INFO.HEADER2_TEXT_H * 7, w = OPTION_INFO.HEADER2_TEXT_W, h = OPTION_INFO.HEADER2_TEXT_H},
        {id = "optionHeader2JudgeTiming"     , src = 2, x = OPTION_INFO.HEADER2_TEXT_SRC_X, y = OPTION_INFO.HEADER2_TEXT_H * 8, w = OPTION_INFO.HEADER2_TEXT_W, h = OPTION_INFO.HEADER2_TEXT_H},
        {id = "optionHeader2PeaceMaker"      , src = 2, x = OPTION_INFO.HEADER2_TEXT_SRC_X, y = OPTION_INFO.HEADER2_TEXT_H * 9, w = OPTION_INFO.HEADER2_TEXT_W, h = OPTION_INFO.HEADER2_TEXT_H},
        -- オプション用ボタン
        {id = "notesOrder1UpButton"     , src = 2, x = 408                       , y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 42, click = 1},
        {id = "notesOrder1DownButton"   , src = 2, x = 408 + OPTION_INFO.BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 42},
        {id = "notesOrder2UpButton"     , src = 2, x = 408                       , y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 43, click = 1},
        {id = "notesOrder2DownButton"   , src = 2, x = 408 + OPTION_INFO.BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 43},
        {id = "gaugeTypeUpButton"       , src = 2, x = 408                       , y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 40, click = 1},
        {id = "gaugeTypeDownButton"     , src = 2, x = 408 + OPTION_INFO.BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 40},
        {id = "dpTypeUpButton"          , src = 2, x = 408                       , y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 54, click = 1},
        {id = "dpTypeDownButton"        , src = 2, x = 408 + OPTION_INFO.BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 54},
        {id = "hiSpeedTypeUpButton"     , src = 2, x = 408                       , y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 55, click = 1},
        {id = "hiSpeedTypeDownButton"   , src = 2, x = 408 + OPTION_INFO.BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 55},
        {id = "gaugeAutoShiftUpButton"  , src = 2, x = 408                       , y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 78, click = 1},
        {id = "gaugeAutoShiftDownButton", src = 2, x = 408 + OPTION_INFO.BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 78},
        {id = "bgaShowUpButton"         , src = 2, x = 408                       , y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 72, click = 1},
        {id = "bgaShowDownButton"       , src = 2, x = 408 + OPTION_INFO.BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 72},
        {id = "paceMakerUpButton"       , src = 2, x = 408                       , y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 77, click = 1},
        {id = "paceMakerDownButton"     , src = 2, x = 408 + OPTION_INFO.BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_INFO.BUTTON_H * 2, w = OPTION_INFO.BUTTON_W, h = OPTION_INFO.BUTTON_H * 2, divy = 2, act = 77},
        {
            id = "notesDisplayTimeUpButton", src = 2,
            x = 998 + OPTION_INFO.NUMBER_BUTTON_SIZE,
            y = PARTS_TEXTURE_SIZE - OPTION_INFO.NUMBER_BUTTON_SIZE * 2,
            w = OPTION_INFO.NUMBER_BUTTON_SIZE, h = OPTION_INFO.NUMBER_BUTTON_SIZE * 2,
            divy = 2, act = 0},
        {
            id = "notesDisplayTimeDownButton", src = 2,
            x = 998,
            y = PARTS_TEXTURE_SIZE - OPTION_INFO.NUMBER_BUTTON_SIZE * 2,
            w = OPTION_INFO.NUMBER_BUTTON_SIZE, h = OPTION_INFO.NUMBER_BUTTON_SIZE * 2,
            divy = 2, act = 0, click = 1},
        {
            id = "judgeTimingUpButton", src = 2,
            x = 998 + OPTION_INFO.NUMBER_BUTTON_SIZE,
            y = PARTS_TEXTURE_SIZE - OPTION_INFO.NUMBER_BUTTON_SIZE * 2,
            w = OPTION_INFO.NUMBER_BUTTON_SIZE, h = OPTION_INFO.NUMBER_BUTTON_SIZE * 2,
            divy = 2, act = 0
        },
        {
            id = "judgeTimingDownButton", src = 2,
            x = 998,
            y = PARTS_TEXTURE_SIZE - OPTION_INFO.NUMBER_BUTTON_SIZE * 2,
            w = OPTION_INFO.NUMBER_BUTTON_SIZE, h = OPTION_INFO.NUMBER_BUTTON_SIZE * 2,
            divy = 2, act = 0, click = 1
        },
        -- その他オプション用
        {id = "millisecondTextImg", src = 2, x = 1111, y = PARTS_TEXTURE_SIZE - OPTION_INFO.NUMBER_H * 3, w = 39, h = OPTION_INFO.NUMBER_H},
        -- ON/OFFオプション用ボタン(アシストは後のforで処理)

        -- ヘルプヘッダ
        {id = "helpIcon", src = 3, x = 0, y = PARTS_TEXTURE_SIZE / 2 - HELP_ICON_SIZE, w = HELP_ICON_SIZE, h = HELP_ICON_SIZE},
        {id = "helpHeaderText", src = 3, x = 0, y = 0, w = 122, h = 30},
        -- ヘルプ内容
        {id = "helpNumberKeys", src = 3, x = 0, y = 30, w = HELP_TEXT1_W, h = HELP_TEXT_H},
        {id = "helpFunctionKeys1", src = 3, x = 0, y = 398, w = HELP_TEXT1_W, h = 246}, -- F7まで
        {id = "helpFunctionKeys2", src = 3, x = 0, y = 398 + 246, w = 470, h = 163}, -- F8~F12
        {id = "helpPlayKey", src = 3, x = 397, y = 30, w = HELP_TEXT2_W, h = HELP_TEXT_H},
        {id = "helpDetailReplayKey", src = 3, x = 397, y = 398, w = HELP_TEXT2_W, h = 248},

        -- 密度グラフ用
        {id = "notesGraphFrame", src = 0, x = 965, y = commons.PARTS_OFFSET + 593, w = 638, h = 178},
        {id = "notesGraphFrame2", src = 8, x = 0, y = 0, w = GRAPH.WND.NEW.W, h = GRAPH.WND.NEW.H},
        {id = "numOfNormalNotesIcon" , src = 0, x = 945 + NOTES_ICON_SIZE*0, y = commons.PARTS_OFFSET + 477, w = NOTES_ICON_SIZE, h = NOTES_ICON_SIZE},
        {id = "numOfScratchNotesIcon", src = 0, x = 945 + NOTES_ICON_SIZE*1, y = commons.PARTS_OFFSET + 477, w = NOTES_ICON_SIZE, h = NOTES_ICON_SIZE},
        {id = "numOfLnNotesIcon"     , src = 0, x = 945 + NOTES_ICON_SIZE*2, y = commons.PARTS_OFFSET + 477, w = NOTES_ICON_SIZE, h = NOTES_ICON_SIZE},
        {id = "numOfBssNotesIcon"    , src = 0, x = 945 + NOTES_ICON_SIZE*3, y = commons.PARTS_OFFSET + 477, w = NOTES_ICON_SIZE, h = NOTES_ICON_SIZE},
        {id = "useStaminaTextImg", src = 0, x = 1298, y = commons.PARTS_OFFSET + 471, w = GRAPH.STAMINA.LABEL.W, h = GRAPH.STAMINA.LABEL.H},

        -- IR用ドットと%
        {id = "irDot", src = 0, x = NORMAL_NUMBER_SRC_X + IR.NUMBER_PERCENT_W * 10 + 15, y = commons.PARTS_OFFSET + 68, w = IR.NUMBER_PERCENT_W, h = IR.NUMBER_PERCENT_H},
        {id = "irPercent", src = 0, x = NORMAL_NUMBER_SRC_X + IR.NUMBER_PERCENT_W * 11 + 15, y = commons.PARTS_OFFSET + 68, w = IR.PERCENT_W, h = IR.PERCENT_H},
        -- IR用文字画像
        {id = "irRankingText", src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + JUDGE_DIFFICULTY.H * 4, w = EXSCORE_AREA.IR_W, h = EXSCORE_AREA.IR_H},
        -- IR loading
        {id = "irLoadingFrame"   , src = 0, x = 965, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.FRAME_W, h = IR.LOADING.FRAME_H},
        {id = "irLoadingWave1"   , src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*0, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.WAVE_W, h = IR.LOADING.WAVE_H},
        {id = "irLoadingWave2"   , src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*1, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.WAVE_W, h = IR.LOADING.WAVE_H},
        {id = "irLoadingWave3"   , src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*2, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.WAVE_W, h = IR.LOADING.WAVE_H},
        {id = "irLoadingWave4"   , src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*3, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.WAVE_W, h = IR.LOADING.WAVE_H},
        {id = "irLoadingWave5"   , src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*4, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.WAVE_W, h = IR.LOADING.WAVE_H},
        {id = "irLoadingWaitText", src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*5, y = commons.PARTS_OFFSET + 771, w = IR.LOADING.WAITING_TEXT_W, h = IR.LOADING.WAITING_TEXT_H},
        {id = "irLoadingLoadText", src = 0, x = 965 + IR.LOADING.FRAME_W + IR.LOADING.WAVE_W*5, y = commons.PARTS_OFFSET + 771 + IR.LOADING.WAITING_TEXT_H, w = IR.LOADING.LOADING_TEXT_W, h = IR.LOADING.LOADING_TEXT_H},

        -- 注目アイコン
        {id = "attensionIcon", src = 0, x = 1846, y = commons.PARTS_OFFSET + 874, w = ATTENSION_SIZE, h = ATTENSION_SIZE},

        -- ヘルプウィンドウ周り
        -- {id = "helpHeaderBgLeft", src = 0, x = 1591, y = },

        -- 検索ボックス
        {id = "searchBox", src = 0, x = 773, y = PARTS_TEXTURE_SIZE - 62, w = 1038, h = 62},

        -- 汎用カラー
        {id = "blank", src = 999, x = 0, y = 0, w = 1, h = 1, act = 0},
        {id = "black", src = 999, x = 1, y = 0, w = 1, h = 1, act = 0},
        {id = "white", src = 999, x = 2, y = 0, w = 1, h = 1},
        {id = "purpleRed", src = 999, x = 3, y = 0, w = 1, h = 1},
        {id = "gray", src = 999, x = 4, y = 0, w = 1, h = 1},
        {id = "gray2", src = 999, x = 4, y = 1, w = 1, h = 1},
        {id = "pink", src = 999, x = 5, y = 0, w = 1, h = 1},
    }

    -- オプション画面等のポップアップウィンドウ共通パーツ読み込み
    -- オプションはrefactorしたいけどtimerの都合上リファクタリングはしんどい
    loadBaseSelect(skin)

    local c = getTableValue(skin_config.option, "背景形式", 915)
    if c == 915 then
        table.insert(skin.image, {id = "background", src = 1, x = 0, y = 0, w = -1, h = -1})
    elseif c == 916 then
        table.insert(skin.image, {id = "background", src = 101, x = 0, y = 0, w = -1, h = -1})
    end

    -- 選曲バーのクリアランプ
    for i, lamp in ipairs(LAMP_NAMES) do
        table.insert(skin.image, {
            id = "barLamp" .. lamp, src = 0,
            x = 657, y = commons.PARTS_OFFSET + LAMP_HEIGHT * (i - 1),
            w = 110, h = LAMP_HEIGHT
        })
        table.insert(skin.image, {
            id = "barLampRivalPlayer" .. lamp, src = 0,
            x = 657, y = commons.PARTS_OFFSET + LAMP_HEIGHT * (i - 1),
            w = 110, h = LAMP_HEIGHT / 2
        })
        table.insert(skin.image, {
            id = "barLampRivalTarget" .. lamp, src = 0,
            x = 657, y = commons.PARTS_OFFSET + LAMP_HEIGHT * (i - 1) + LAMP_HEIGHT / 2,
            w = 110, h = LAMP_HEIGHT / 2
        })
    end

    -- IR部分の文字の画像読み込み
    local irTexts = {
        "Max", "Perfect", "Fullcombo", "Exhard", "Hard", "Clear", "Easy", "Lassist", "Aassist", "Failed", "Player", "NumOfFullcombo", "NumOfClear"
    }
    for i, t in ipairs(irTexts) do
        table.insert(skin.image, {
            id = "ir" .. t .. "Text", src = 0, x = 1603, y = commons.PARTS_OFFSET + 531 + IR.TEXT_H * (i - 1), w = IR.TEXT_W, h = IR.TEXT_H
        })
    end

    -- 汎用的な24px数値
    loadNumbers(skin, NUMBERS_24PX.ID, 0, 1434, commons.PARTS_OFFSET + 421, NUMBERS_24PX.W * 10, NUMBERS_24PX.H, 10, 1)


    -- 密度グラフ
    skin.judgegraph = {
		{id = "notesGraph", type = 0, noGap = 1, delay = 0},
		{id = "notesGraph2", type = 0, noGap = 1, backTexOff = 1, delay = 0},
		{id = "bpmGraph2", type = 0, noGap = 1, backTexOff = 1, delay = 0}
    }

    skin.bpmgraph = {
        {id = "bpmGraph", delay = 0},
    }

    if isDefaultLampGraphColor() then
        skin.graph = {
            {id = "lampGraph", src = 0, x = 607, y = commons.PARTS_OFFSET, w = 11, h = 16, divx = 11, divy = 2, cycle = 16.6*4, type = -1}
        }
    else
        skin.graph = {
            {id = "lampGraph", src = 6, x = 0, y = 0, w = 1408, h = 256, divx = 11, divy = 256, cycle = 2000, type = -1},
        }
    end

    -- 選曲スライダー
    skin.slider = {
        {id = "musicSelectSlider", src = 0, x = 1541, y = commons.PARTS_OFFSET + 263, w = MUSIC_SLIDER_BUTTON_W, h = MUSIC_SLIDER_BUTTON_H, type = 1, range = 768 - MUSIC_SLIDER_BUTTON_H / 2 - 3, angle = 2, align = 0},
    }

    if isViewFolderLampGraph() then
        skin.imageset = {
            {
                id = "bar", images = {
                    "barSong",
                    "barFolderWithLamp",
                    "barTableWithLamp",
                    "barGrade",
                    -- "barGrade",
                    "barNosong",
                    "barCommandWithLamp",
                    "barNosong",
                    "barSearch",
                }
            },
        }
    else
        skin.imageset = {
            {
                id = "bar", images = {
                    "barSong",
                    "barFolder",
                    "barTable",
                    "barGrade",
                    -- "barGrade",
                    "barNosong",
                    "barCommand",
                    "barNosong",
                    "barSearch",
                }
            },
        }
    end

    -- ランク
    -- local ranks = {"Max", "Aaa", "Aa", "a", "b", "c", "d", "e", "f"}
    local ranks = {"Aaa", "Aa", "A", "B", "C", "D", "E", "F"}
    for i, rank in ipairs(ranks) do
        table.insert(skin.image, {
            id = "rank" .. rank, src = 0,
            x = SCORE_RANK.SRC_X, y = commons.PARTS_OFFSET + SCORE_RANK.H * i,
            w = SCORE_RANK.W, h = SCORE_RANK.H
        })
    end

    -- プレイオプション 譜面配置
    local optionTexts = {
        "normal", "mirror", "random", "r-random", "s-random", "spiral", "h-random", "all-scr", "random+", "s-ran+"
    }
    loadOptionImgs(skin, optionTexts, "notesOrder1", 42, 0, 0)
    loadOptionImgs(skin, optionTexts, "notesOrder2", 43, 0, 0)
    -- ゲージ
    optionTexts = {
        "assistedEasy", "easy", "normal", "hard", "exHard", "hazard",
    }
    loadOptionImgs(skin, optionTexts, "gaugeType", 40, OPTION_INFO.ITEM_W * 2, 0)
    -- DPオプション
    optionTexts = {
        "off", "flip", "battle", "battleAs"
    }
    loadOptionImgs(skin, optionTexts, "dpType", 54, OPTION_INFO.ITEM_W * 2, OPTION_INFO.ITEM_H * 14)
    -- ハイスピード固定
    optionTexts = {
        "off", "startBpm", "maxBpm", "mainBpm", "minBpm"
    }
    loadOptionImgs(skin, optionTexts, "hiSpeedType", 55, 0, OPTION_INFO.ITEM_H * 14)
    -- PeaceMaker
    optionTexts = {
        "next", "max", "aaa+", "aaa", "aaa-", "aa+", "aa", "aa-", "a+", "a", "a-"
    }
    loadOptionImgs(skin, optionTexts, "paceMaker", 77, 2048, 0)

    -- GAS
    optionTexts = {
        "none", "continue", "hardToGroove", "bestClear", "selectToUnder"
    }
    loadOptionImgs(skin, optionTexts, "gaugeAutoShift", 78, 0, OPTION_INFO.ITEM_H * 23)
    -- BGA
    optionTexts = {
        "on", "auto", "off"
    }
    loadOptionImgs(skin, optionTexts, "bgaShow", 72, OPTION_INFO.ITEM_W * 2, OPTION_INFO.ITEM_H * 23)

    -- アシストオプション
    local assistTexts = {
        "expandJudge", "constant", "judgeArea", "legacyNote", "markNote", "bpmGuide", "noMine"
    }
    for i, assistText in ipairs(assistTexts) do
        -- assist名
        table.insert(skin.image, {
            id = assistText .. "TextImg", src = 2,
            x = OPTION_INFO.ITEM_W * 4, y = HEADER.MARKER.H * (3 + i),
            w = OPTION_INFO.HEADER_TEXT_W, h = HEADER.MARKER.H
        })
        -- 説明
        table.insert(skin.image, {
            id = assistText .. "DescriptionTextImg", src = 2,
            x = OPTION_INFO.ITEM_W * 4, y = HEADER.MARKER.H * (3 + 7 + i),
            w = OPTION_INFO.HEADER_TEXT_W * 2, h = HEADER.MARKER.H
        })
        -- ON/OFF
        table.insert(skin.image, {
            id = assistText .. "ButtonOff", src = 2,
            x = 696, y = PARTS_TEXTURE_SIZE - OPTION_INFO.SWITCH_BUTTON_H * 2,
            w = OPTION_INFO.SWITCH_BUTTON_W, h = OPTION_INFO.SWITCH_BUTTON_H,
        })
        table.insert(skin.image, {
            id = assistText .. "ButtonOn", src = 2,
            x = 696, y = PARTS_TEXTURE_SIZE - OPTION_INFO.SWITCH_BUTTON_H,
            w = OPTION_INFO.SWITCH_BUTTON_W, h = OPTION_INFO.SWITCH_BUTTON_H,
        })
        table.insert(skin.imageset, {
            id = assistText .. "ButtonImgset", ref = 300 + i, act = 300 + i,
            images = {assistText .. "ButtonOff", assistText .. "ButtonOn"}
        })
    end

    skin.value = {
        -- 選曲バー難易度数値
        {id = "barPlayLevelUnknown",  src = 0, x = 771, y = commons.PARTS_OFFSET,                                   w = MUSIC_BAR.DIFFICULTY_NUMBER_W*10, h = MUSIC_BAR.DIFFICULTY_NUMBER_H, divx = 10, digit = 2, align = 2},
        {id = "barPlayLevelBeginner", src = 0, x = 771, y = commons.PARTS_OFFSET + MUSIC_BAR.DIFFICULTY_NUMBER_H*1, w = MUSIC_BAR.DIFFICULTY_NUMBER_W*10, h = MUSIC_BAR.DIFFICULTY_NUMBER_H, divx = 10, digit = 2, align = 2},
        {id = "barPlayLevelNormal",   src = 0, x = 771, y = commons.PARTS_OFFSET + MUSIC_BAR.DIFFICULTY_NUMBER_H*2, w = MUSIC_BAR.DIFFICULTY_NUMBER_W*10, h = MUSIC_BAR.DIFFICULTY_NUMBER_H, divx = 10, digit = 2, align = 2},
        {id = "barPlayLevelHyper",    src = 0, x = 771, y = commons.PARTS_OFFSET + MUSIC_BAR.DIFFICULTY_NUMBER_H*3, w = MUSIC_BAR.DIFFICULTY_NUMBER_W*10, h = MUSIC_BAR.DIFFICULTY_NUMBER_H, divx = 10, digit = 2, align = 2},
        {id = "barPlayLevelAnother",  src = 0, x = 771, y = commons.PARTS_OFFSET + MUSIC_BAR.DIFFICULTY_NUMBER_H*4, w = MUSIC_BAR.DIFFICULTY_NUMBER_W*10, h = MUSIC_BAR.DIFFICULTY_NUMBER_H, divx = 10, digit = 2, align = 2},
        {id = "barPlayLevelInsane",   src = 0, x = 771, y = commons.PARTS_OFFSET + MUSIC_BAR.DIFFICULTY_NUMBER_H*5, w = MUSIC_BAR.DIFFICULTY_NUMBER_W*10, h = MUSIC_BAR.DIFFICULTY_NUMBER_H, divx = 10, digit = 2, align = 2},
        {id = "barPlayLevelUnknown2", src = 0, x = 771, y = commons.PARTS_OFFSET + MUSIC_BAR.DIFFICULTY_NUMBER_H*6, w = MUSIC_BAR.DIFFICULTY_NUMBER_W*10, h = MUSIC_BAR.DIFFICULTY_NUMBER_H, divx = 10, digit = 2, align = 2},
        -- 左側の難易度表記数字
        {id = "largeLevelBeginner", src = 0, x = 771, y = commons.PARTS_OFFSET + 147                         , w = LARGE_LEVEL.NUMBER_W*10, h = LARGE_LEVEL.NUMBER_H, divx = 10, digit = 2, ref = 45, align = 2},
        {id = "largeLevelNormal"  , src = 0, x = 771, y = commons.PARTS_OFFSET + 147 + LARGE_LEVEL.NUMBER_H * 1, w = LARGE_LEVEL.NUMBER_W*10, h = LARGE_LEVEL.NUMBER_H, divx = 10, digit = 2, ref = 46, align = 2},
        {id = "largeLevelHyper"   , src = 0, x = 771, y = commons.PARTS_OFFSET + 147 + LARGE_LEVEL.NUMBER_H * 2, w = LARGE_LEVEL.NUMBER_W*10, h = LARGE_LEVEL.NUMBER_H, divx = 10, digit = 2, ref = 47, align = 2},
        {id = "largeLevelAnother" , src = 0, x = 771, y = commons.PARTS_OFFSET + 147 + LARGE_LEVEL.NUMBER_H * 3, w = LARGE_LEVEL.NUMBER_W*10, h = LARGE_LEVEL.NUMBER_H, divx = 10, digit = 2, ref = 48, align = 2},
        {id = "largeLevelInsane"  , src = 0, x = 771, y = commons.PARTS_OFFSET + 147 + LARGE_LEVEL.NUMBER_H * 4, w = LARGE_LEVEL.NUMBER_W*10, h = LARGE_LEVEL.NUMBER_H, divx = 10, digit = 2, ref = 49, align = 2},
        -- 密度
        {id = "densityAverageNumber"    , src = 0, x = 771, y = commons.PARTS_OFFSET + 147 + LARGE_LEVEL.NUMBER_H * 1, w = LARGE_LEVEL.NUMBER_W*10, h = LARGE_LEVEL.NUMBER_H, divx = 10, digit = 2, ref = 364, align = 0},
        {id = "densityAverageAfterDot"  , src = 0, x = 771, y = commons.PARTS_OFFSET + MUSIC_BAR.DIFFICULTY_NUMBER_H*2, w = MUSIC_BAR.DIFFICULTY_NUMBER_W*10, h = MUSIC_BAR.DIFFICULTY_NUMBER_H, divx = 10, digit = 2, ref = 365, align = 1, padding = 1},
        {id = "densityEndNumber"        , src = 0, x = 771, y = commons.PARTS_OFFSET + 147 + LARGE_LEVEL.NUMBER_H * 2, w = LARGE_LEVEL.NUMBER_W*10, h = LARGE_LEVEL.NUMBER_H, divx = 10, digit = 2, ref = 362, align = 0},
        {id = "densityEndAfterDot"      , src = 0, x = 771, y = commons.PARTS_OFFSET + MUSIC_BAR.DIFFICULTY_NUMBER_H*3, w = MUSIC_BAR.DIFFICULTY_NUMBER_W*10, h = MUSIC_BAR.DIFFICULTY_NUMBER_H, divx = 10, digit = 2, ref = 363, align = 1, padding = 1},
        {id = "densityPeakNumber"       , src = 0, x = 771, y = commons.PARTS_OFFSET + 147 + LARGE_LEVEL.NUMBER_H * 3, w = LARGE_LEVEL.NUMBER_W*10, h = LARGE_LEVEL.NUMBER_H, divx = 10, digit = 2, ref = 360, align = 2},
        -- {id = "densityPeakAfterDot"     , src = 0, x = 771, y = commons.PARTS_OFFSET + MUSIC_BAR.DIFFICULTY_NUMBER_H*4, w = MUSIC_BAR.DIFFICULTY_NUMBER_W*10, h = MUSIC_BAR.DIFFICULTY_NUMBER_H, divx = 10, digit = 2, ref = 361, align = 1},
        -- exscore用
        {id = "richExScore",  src = 0, x = 771, y = commons.PARTS_OFFSET + 347, w = EXSCORE_AREA.NUMBER_W * 10, h = EXSCORE_AREA.NUMBER_H, divx = 10, digit = 5, ref = 71, align = 0},
        {id = "rivalExScore", src = 0, x = 771, y = commons.PARTS_OFFSET + 347, w = EXSCORE_AREA.NUMBER_W * 10, h = EXSCORE_AREA.NUMBER_H, divx = 10, digit = 5, ref = 271, align = 0},
        -- IR
        {id = "irRanking"         , src = 0, x = NORMAL_NUMBER_SRC_X, y = NORMAL_NUMBER_SRC_Y, w = NORMAL_NUMBER_W*10, h = NORMAL_NUMBER_H, divx = 10, digit = 5, ref = 179, align = 0},
        {id = "irPlayerForRanking", src = 0, x = NORMAL_NUMBER_SRC_X, y = commons.PARTS_OFFSET + 89, w = IR.NUMBER_NUM_W * 10, h = IR.NUMBER_NUM_H, divx = 10, digit = 5, ref = 200, align = 0},
        -- ノーツ数
        {id = "numOfNormalNotes" , src = 0, x = NORMAL_NUMBER_SRC_X, y = commons.PARTS_OFFSET + NORMAL_NUMBER_H, w = STATUS_NUMBER_W * 10, h = STATUS_NUMBER_H, divx = 10, digit = 4, ref = 350, align = 0},
        {id = "numOfScratchNotes", src = 0, x = NORMAL_NUMBER_SRC_X, y = commons.PARTS_OFFSET + NORMAL_NUMBER_H, w = STATUS_NUMBER_W * 10, h = STATUS_NUMBER_H, divx = 10, digit = 4, ref = 352, align = 0},
        {id = "numOfLnNotes"     , src = 0, x = NORMAL_NUMBER_SRC_X, y = commons.PARTS_OFFSET + NORMAL_NUMBER_H, w = STATUS_NUMBER_W * 10, h = STATUS_NUMBER_H, divx = 10, digit = 4, ref = 351, align = 0},
        {id = "numOfBssNotes"    , src = 0, x = NORMAL_NUMBER_SRC_X, y = commons.PARTS_OFFSET + NORMAL_NUMBER_H, w = STATUS_NUMBER_W * 10, h = STATUS_NUMBER_H, divx = 10, digit = 4, ref = 353, align = 0},
        -- オプション
        {id = "notesDisplayTime", src = 2, x = 1111, y = PARTS_TEXTURE_SIZE - OPTION_INFO.NUMBER_H, w = OPTION_INFO.NUMBER_W * 10, h = OPTION_INFO.NUMBER_H, divx = 10, digit = 4, ref = 312},
        {id = "judgeTiming", src = 2, x = 1111, y = PARTS_TEXTURE_SIZE - OPTION_INFO.NUMBER_H * 2, w = OPTION_INFO.NUMBER_W * 12, h = OPTION_INFO.NUMBER_H * 2, divx = 12, divy = 2, digit = 4, ref = 12},

    }
    -- IR irTextsに対応する値を入れていく
    -- {人数, percentage, afterdot} で, irTextsに対応するrefsを入れる
    local irNumbers = {
        -- MAXから
        {224, 225, 240}, {222, 223, 239}, {218, 219, 238}, {208, 209, 233}, {216, 217, 237}, {214, 215, 236},
        -- ここからEASY
        {212, 213, 235}, {206, 207, 232}, {204, 205, 231}, {210, 211, 234},
        -- ここからplayer
        {200, 0, 0}, {228, 229, 242}, {226, 227, 241}
    }
    for i, refs in ipairs(irNumbers) do
        local type = irTexts[i]
        table.insert(skin.value, {
            id = "ir" .. type .. "Number", src = 0, x = NORMAL_NUMBER_SRC_X, y = commons.PARTS_OFFSET + 89, w = IR.NUMBER_NUM_W * 10, h = IR.NUMBER_NUM_H, divx = 10, divy = 1, digit = IR.DIGIT, ref = refs[1]
        })
        if refs[2] ~= 0 then
            table.insert(skin.value, {
                id = "ir" .. type .. "Percentage", src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W, y = commons.PARTS_OFFSET + 68, w = IR.NUMBER_PERCENT_W * 10, h = IR.NUMBER_PERCENT_H, divx = 10, divy = 1, digit = 3, ref = refs[2]
            })
            table.insert(skin.value, {
                id = "ir" .. type .. "PercentageAfterDot", src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W, y = commons.PARTS_OFFSET + 68, w = IR.NUMBER_PERCENT_W * 10, h = IR.NUMBER_PERCENT_H, divx = 10, divy = 1, digit = 1, ref = refs[3], padding = 1
            })
        end
    end

    -- 各種ステータス用数値(パーツ共通)
    local commonStatusTexts = {
        "exScore", "hiScore", "nextRank",
        "numOfPerfect", "numOfGreat", "numOfGood", "numOfBad", "numOfPoor",
        "maxCombo", "totalNotes", "missCount", "playCount", "clearCount",
        "bpm", "keys",
        -- ここから画像無し
        "bpmMax", "bpmMin",
        "numOfPerfectFolder", "numOfGreatFolder", "numOfGoodFolder", "numOfBadFolder", "numOfPoorFolder",
        "playCountFolder", "clearCountFolder",
    }
    local useNormalNumberTexts = {
        exScore = 71, hiScore = 100, nextRank = 154,
        numOfPerfect = 110, numOfGreat = 111, numOfGood = 112, numOfBad = 113, numOfPoor = 114, numOfEmptyPoor = 420,
        maxCombo = 105, totalNotes = 106, missCount = 427, playCount = 77, clearCount = 78,
        bpm = 90, bpmMax = 90, bpmMin = 91,
        numOfPerfectFolder = 33, numOfGreatFolder = 34, numOfGoodFolder = 35, numOfBadFolder = 36, numOfPoorFolder = 37,
        playCountFolder = 30, clearCountFolder = 31
    }

    for i, val in ipairs(commonStatusTexts) do
        local digit = SCORE_INFO.DIGIT
        if val == "bpm" or val == "bpmMax" or val == "bpmMin" then
            digit = 3
        end
        table.insert(skin.image, {
                id = val .. "TextImg", src = 0,
                x = SCORE_INFO.TEXT_SRC_X, y = SCORE_INFO.TEXT_SRC_Y + SCORE_INFO.TEXT_H * (i - 1),
                w = SCORE_INFO.TEXT_W, h = SCORE_INFO.TEXT_H
        })
        table.insert(skin.value, {
                id = val, src = 0,
                x = NORMAL_NUMBER_SRC_X, y = NORMAL_NUMBER_SRC_Y,
                w = NORMAL_NUMBER_W*10, h = NORMAL_NUMBER_H,
                divx = 10, digit = digit, ref = useNormalNumberTexts[val], align = 0
        })
        if val == "numOfPoor" then
            table.insert(skin.value, {
                    id = "numOfEmptyPoor", src = 0,
                    x = NORMAL_NUMBER_SRC_X, y = NORMAL_NUMBER_SRC_Y,
                    w = NORMAL_NUMBER_W*10, h = NORMAL_NUMBER_H,
                    divx = 10, digit = digit, ref = useNormalNumberTexts["numOfEmptyPoor"], align = 0
            })
        end
    end

    skin.font = {
		{id = 0, path = "../common/fonts/SourceHanSans-Regular.otf"},
		-- {id = 0, path = "../common/fonts/font_1_kokumr_1.00_rls.ttf"},
	}

    skin.text = {
        {id = "dir", font = 0, size = 24, ref = 1000},
		{id = "genre", font = 0, size = 24, ref = 13},
        {id = "title", font = 0, size = 24, ref = 12},
		{id = "artist", font = 0, size = ARTIST_FONT_SIZE, ref = 14, align = 2, overflow = 1},
        {id = "subArtist", font = 0, size = SUBARTIST_FONT_SIZE, ref = 15, align = 2, overflow = 1},
		{id = "course1Text", font = 0, size = BAR_FONT_SIZE, ref = 150, align = 2, overflow = 1},
		{id = "course2Text", font = 0, size = BAR_FONT_SIZE, ref = 151, align = 2, overflow = 1},
		{id = "course3Text", font = 0, size = BAR_FONT_SIZE, ref = 152, align = 2, overflow = 1},
		{id = "course4Text", font = 0, size = BAR_FONT_SIZE, ref = 153, align = 2, overflow = 1},
		{id = "course5Text", font = 0, size = BAR_FONT_SIZE, ref = 154, align = 2, overflow = 1},

		{id = "bartext", font = 0, size = BAR_FONT_SIZE, align = 2, overflow = 1},
        {id = "searchText", font = 0, size = 24, ref = 30},

        {id = "playerName", font = 0, size = RIVAL.FONT_SIZE, align = 0, ref = 2, overflow = 1},
        {id = "rivalName" , font = 0, size = RIVAL.FONT_SIZE, align = 0, ref = 1, overflow = 1},
        {id = "newVersion" , font = 0, size = 24, align = 0, overflow = 1, constantText = "スキンに更新があります"},
        {id = "helpText", font = 0, size = 30, align = 0, constantText = "ヘルプ    ※マウスで操作し, スクロールはドラッグで操作してください."},
        {id = "24:", font = 0, size = 24, align = 0, constantText = ":"},
        {id = "countText", font = 0, size = 24, align = 2, constantText = "回"},
    }

    -- オープニングの読み込み
    opening.load(skin)
    -- ユーザ情報出力周り
    user.load(skin)
    -- ヘルプの読み込み
    help.loadHelpItem(skin)
    -- 統計の読み込み
    statistics.load(skin)

    -- 選曲バー設定
    skin.songlist = {
        id = "songlist",
        center = 8,
        clickable = {8},
        listoff = {},
        liston = {},
    }

    for i = 1, 17 do
        local idx = i
        if i > skin.songlist.center + 1 then
            idx = idx + 0.75 -- BPM等を入れる部分の高さだけ下にずらす
        end
        local posX = math.floor(1184 + (skin.songlist.center - idx + 2) * 12)
        local posY = math.floor(491 + (skin.songlist.center - idx + 2) * 80)
        local INTERVAL = 20
        -- ぽわんと1回跳ねる感じ
        table.insert(skin.songlist.listoff, {
            id = "bar", loop = 250 + i * INTERVAL,
            dst = {
                {time = 0                 , x = posX + 800, y = posY, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT, acc = 2},
                {time = i * INTERVAL      , x = posX + 800, y = posY, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT, acc = 2},
                {time = 200 + i * INTERVAL, x = posX -  50, y = posY, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT, acc = 1},
                {time = 225 + i * INTERVAL, x = posX -  25, y = posY, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT, acc = 2},
                {time = 250 + i * INTERVAL, x = posX      , y = posY, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT, acc = 2}
            }
        })
        table.insert(skin.songlist.liston, {
            id = "bar", loop = 250 + i * INTERVAL,
            dst = {
                {time = 0                 , x = posX + 800, y = posY, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT, acc = 2},
                {time = i * INTERVAL      , x = posX + 800, y = posY, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT, acc = 2},
                {time = 200 + i * INTERVAL, x = posX -  50, y = posY, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT, acc = 1},
                {time = 225 + i * INTERVAL, x = posX -  25, y = posY, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT, acc = 2},
                {time = 250 + i * INTERVAL, x = posX      , y = posY, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT, acc = 2}
            }
        })
    end

    skin.songlist.label = {
        {
            id = "barLn", dst = {
                {x = SONG_LIST.LABEL.X, y = SONG_LIST.LABEL.Y, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H}
            }
        },
        {
            id = "barRandom", dst = {
                {x = SONG_LIST.LABEL.X, y = SONG_LIST.LABEL.Y, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H}
            }
        },
        {
            id = "barBomb", dst = {
                {x = SONG_LIST.LABEL.X, y = SONG_LIST.LABEL.Y, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H}
            }
        },
        {
            id = "barCn", dst = {
                {x = SONG_LIST.LABEL.X, y = SONG_LIST.LABEL.Y, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H}
            }
        },
        {
            id = "barHcn", dst = {
                {x = SONG_LIST.LABEL.X, y = SONG_LIST.LABEL.Y, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H}
            }
        },
    }

    -- skin.songlist.trophy = {
    --     {
    --         id = "bronzeTrophy", dst = {
    --             {x = 146, y = 11, w = MUSIC_BAR.TROPHY_W, h = MUSIC_BAR.TROPHY_H}
    --         }
    --     },
    --     {
    --         id = "silverTrophy", dst = {
    --             {x = 146, y = 11, w = MUSIC_BAR.TROPHY_W, h = MUSIC_BAR.TROPHY_H}
    --         }
    --     },
    --     {
    --         id = "goldTrophy", dst = {
    --             {x = 146, y = 11, w = MUSIC_BAR.TROPHY_W, h = MUSIC_BAR.TROPHY_H}
    --         }
    --     },
    -- }

    -- 曲名等
    skin.songlist.text = {
        {
            id = "bartext", filter = 1,
            dst = {
                {x = 570, y = 21, w = 397, h = BAR_FONT_SIZE, r = 0, g = 0, b = 0, filter = 1}
            }
        },
        {
            id = "bartext", filter = 1,
            dst = {
                {x = 570, y = 21, w = 397, h = BAR_FONT_SIZE, r = 200, g = 0, b = 0, filter = 1}
            }
        },
    }

    if isViewFolderLampGraph() then
        skin.songlist.graph = {
            id = "lampGraph", dst = {
                {x = 170, y = 9, w = 397, h = 8}
            }
        }
    end

    local levelPosX = 19
    local levelPosY = 12
    skin.songlist.level = {
        {
            id = "barPlayLevelUnknown",
            dst = {
                {x = levelPosX, y = levelPosY, w = 16, h = 21}
            }
        },
        {
            id = "barPlayLevelBeginner",
            dst = {
                {x = levelPosX, y = levelPosY, w = 16, h = 21}
            }
        },
        {
            id = "barPlayLevelNormal",
            dst = {
                {x = levelPosX, y = levelPosY, w = 16, h = 21}
            }
        },
        {
            id = "barPlayLevelHyper",
            dst = {
                {x = levelPosX, y = levelPosY, w = 16, h = 21}
            }
        },
        {
            id = "barPlayLevelAnother",
            dst = {
                {x = levelPosX, y = levelPosY, w = 16, h = 21}
            }
        },
        {
            id = "barPlayLevelInsane",
            dst = {
                {x = levelPosX, y = levelPosY, w = 16, h = 21}
            }
        },
        {
            id = "barPlayLevelUnknown2",
            dst = {
                {x = levelPosX, y = levelPosY, w = 16, h = 21}
            }
        },
    }
    local lampPosX = 17
    local lampPosY = 41;

    skin.songlist.lamp = {}
    skin.songlist.playerlamp = {}
    skin.songlist.rivallamp = {}

    for i, lamp in ipairs(LAMP_NAMES) do
        table.insert(skin.songlist.lamp, 1, {
            id = "barLamp" .. lamp, dst = {
                {x = lampPosX, y = lampPosY, w = 110, h = LAMP_HEIGHT}
            }
        })
        table.insert(skin.songlist.playerlamp, 1, {
            id = "barLampRivalPlayer" .. lamp, dst = {
                {x = lampPosX, y = lampPosY + LAMP_HEIGHT / 2, w = 110, h = LAMP_HEIGHT / 2}
            }
        })
        table.insert(skin.songlist.rivallamp, 1, {
            id = "barLampRivalTarget" .. lamp, dst = {
                {x = lampPosX, y = lampPosY, w = 110, h = LAMP_HEIGHT / 2}
            }
        })
    end

    skin.destination = {
        -- 背景
        {
            id = "background",
            dst = {
                {x = 0, y = 0, w = WIDTH, h = HEIGHT}
            }
        },
        -- フレーム
        {
            id = "baseFrame",
            dst = {
                {x = 0, y = 0, w = WIDTH, h = HEIGHT}
            }
        },
        -- ステージファイル背景
        {
            id = "black", op = {191, 2}, dst = {
                {x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H, a = 255}
            }
        },
        -- stage file影1
        {
            id = "black", op = {2, 947}, offset = 40, dst = {
                {x = STAGE_FILE.X + STAGE_FILE.SHADOW.X, y = STAGE_FILE.Y + STAGE_FILE.SHADOW.Y, w = STAGE_FILE.W, h = STAGE_FILE.H, a = STAGE_FILE.SHADOW.A}
            }
        },
        -- stage file影2(デフォルト)
        {
            id = "stagefileShadow", op = {2, 946}, dst = {
                {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y = STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2}
            }
        },
        -- noステージファイル背景
        {
            id = "noImage", op = {190, 2}, stretch = 1, dst = {
                {x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H}
            }
        },
        -- ステージファイル
        {
            id = -100, op = {2}, filter = 1, stretch = 1, dst = {
                {x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H}
            }
        },
        -- ステージファイルマスク
        {
            id = "black", op = {{190, 191}, 2}, timer = 11, loop = 300, dst = {
                {time = 0  , a = 128, x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H},
                {time = 200, a = 128},
                {time = 300, a = 0}
            }
        },
        -- Stage fileフレーム
        { -- 設定無し
            id = "stagefileFrame", op = {2, 150, 945}, dst = {
                {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y = STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2}
            }
        },
        { -- beginner
            id = "stagefileFrame", op = {2, 151, 945}, dst = {
                {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y =  STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2, r = 153, g = 255, b = 153}
            }
        },
        { -- normal
            id = "stagefileFrame", op = {2, 152, 945}, dst = {
                {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y =  STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2, r = 153, g = 255, b = 255}
            }
        },
        { -- hyper
            id = "stagefileFrame", op = {2, 153, 945}, dst = {
                {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y =  STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2, r = 255, g = 204, b = 102}
            }
        },
        { -- another
            id = "stagefileFrame", op = {2, 154, 945}, dst = {
                {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y =  STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2, r = 255, g = 102, b = 102}
            }
        },
        { -- insane
            id = "stagefileFrame", op = {2, 155, 945}, dst = {
                {x = STAGE_FILE.X - STAGE_FILE.FRAME_OFFSET, y =  STAGE_FILE.Y - STAGE_FILE.FRAME_OFFSET, w = STAGE_FILE.W + STAGE_FILE.FRAME_OFFSET * 2, h = STAGE_FILE.H + STAGE_FILE.FRAME_OFFSET * 2, r = 204, g = 0, b = 102}
            }
        },

        -- コース曲一覧表示は下のforで
        -- コースオプション
        -- BG
        {
            id = "courseBgEdgeLeft", op = {3}, dst = {
                {x = COURSE.OPTION.BASE_X, y = COURSE.OPTION.BASE_Y, w = COURSE.OPTION.BG_EDGE_W, h = COURSE.OPTION.BG_H}
            }
        },
        {
            id = "courseBgMiddle", op = {3}, dst = {
                {x = COURSE.OPTION.BASE_X + COURSE.OPTION.BG_EDGE_W, y = COURSE.OPTION.BASE_Y, w = COURSE.OPTION.BG_W - COURSE.OPTION.BG_EDGE_W * 2, h = COURSE.OPTION.BG_H}
            }
        },
        {
            id = "courseBgMiddleRight", op = {3}, dst = {
                {x = COURSE.OPTION.BASE_X + COURSE.OPTION.BG_W - COURSE.OPTION.BG_EDGE_W, y = COURSE.OPTION.BASE_Y, w = COURSE.OPTION.BG_EDGE_W, h = COURSE.OPTION.BG_H}
            }
        },
        -- 値
        -- 譜面オプション
        {
            id = "courseHeaderBg", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseHeaderOption", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseSettingClass", op = {3, 1002}, dst = {
                {x = COURSE.OPTION.SETTING_START_X, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingMirror", op = {3, 1003}, dst = {
                {x = COURSE.OPTION.SETTING_START_X, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingRandom", op = {3, 1004}, dst = {
                {x = COURSE.OPTION.SETTING_START_X, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingNoSetting", op = {3, -1002, -1003, -1004}, dst = {
                {x = COURSE.OPTION.SETTING_START_X, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        -- ハイスピ
        {
            id = "courseHeaderBg", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*1, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseHeaderHiSpeed", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*1, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseSettingNoSpeed", op = {3, 1005}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*1, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingNoSetting", op = {3, -1005}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*1, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        -- 判定
        {
            id = "courseHeaderBg", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*2, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseHeaderJudge", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*2, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseSettingNoGood", op = {3, 1006}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*2, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingNoGreat", op = {3, 1007}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*2, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingNoSetting", op = {3, -1006, -1007}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*2, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        -- ゲージ
        {
            id = "courseHeaderBg", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseHeaderGauge", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseSettingGaugeLR2", op = {3, 1010}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingGauge5Keys", op = {3, 1011}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingGauge7Keys", op = {3, 1012}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingGauge9Keys", op = {3, 1013}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingGauge24Keys", op = {3, 1014}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingNoSetting", op = {3, -1010, -1011, -1012, -1013, -1014}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        -- LN
        {
            id = "courseHeaderBg", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*4, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseHeaderLnType", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*4, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseSettingGaugeLn", op = {3, 1015}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*4, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingGaugeCn", op = {3, 1016}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*4, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingGaugeHcn", op = {3, 1017}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*4, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingNoSetting", op = {3, -1015, -1016, -1017}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*4, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },

        -- 上部オプション
        {
            id = "upperOptionButtonBg", dst = {
                {x = SELECT_OPTION.BUTTON.X, y = SELECT_OPTION.BUTTON.UPPER_Y, w = 270, h = OPTION_INFO.SWITCH_BUTTON_H}
            }
        },
        -- 上部オプションの上のやつの区切り
        {
            id = "white", dst = {
                {x = SELECT_OPTION.BUTTON.X + 135, y = SELECT_OPTION.BUTTON.UPPER_Y + 6, w = 1, h = OPTION_INFO.ITEM_H, r = 102, g = 102, b = 102}
            }
        },
        {
            id = "upperOptionButtonBg", dst = {
                {x = SELECT_OPTION.BUTTON.X, y = SELECT_OPTION.BUTTON.UPPER_Y - 53, w = 270, h = OPTION_INFO.SWITCH_BUTTON_H}
            }
        },
        -- keys
        {
            id = "keysSet", dst = {
                {x = SELECT_OPTION.BUTTON.X + SELECT_OPTION.KEYS.X, y = SELECT_OPTION.BUTTON.UPPER_Y + 6, w = 129, h = OPTION_INFO.ITEM_H}
            }
        },
        -- LN
        {
            id = "lnModeSet", dst = {
                {x = SELECT_OPTION.BUTTON.X + SELECT_OPTION.LN.X, y = SELECT_OPTION.BUTTON.UPPER_Y + 6, w = 129, h = OPTION_INFO.ITEM_H}
            }
        },
        -- ソート
        {
            id = "sortModeSet", dst = {
                {x = SELECT_OPTION.BUTTON.X + SELECT_OPTION.SORT.X, y = SELECT_OPTION.BUTTON.UPPER_Y - 53 + 6, w = 258, h = OPTION_INFO.ITEM_H}
            }
        },

        -- プレイボタン
        {
            id = "playButton", op = {-1}, dst = {
                {x = 780, y = 571, w = DECIDE_BUTTON_W, h = DECIDE_BUTTON_H}
            }
        },
        { -- ボタン起動用にサイズを調整したやつ
            id = "playButtonDummy", op = {-1}, dst = {
                {x = 786, y = 577, w = DECIDE_BUTTON_W - 12, h = DECIDE_BUTTON_H - 12}
            }
        },
        -- AUTO
        {
            id = "autoButton", op = {-1}, dst = {
                {x = 780, y = 513, w = AUTO_BUTTON_W, h = AUTO_BUTTON_H}
            }
        },
        {
            id = "autoButtonDummy", op = {-1}, dst = {
                {x = 786, y = 519, w = AUTO_BUTTON_W - 12, h = AUTO_BUTTON_H - 12}
            }
        },
        -- replayは下のリプレイボタンfor文で挿入

        -- 選曲バー
        {id = "songlist"},
        -- 選曲バー中央
        {
            id = "barCenterFrame", dst = {
                {x = 1143, y = 503, w = 714, h = 154, filter = 1}
            }
        },
        -- アーティスト
        {
            id = "artist", filter = 1, dst = {
                {x = 1800, y = 543, w = 370, h = ARTIST_FONT_SIZE, r = 0, g = 0, b = 0, filter = 1}
            }
        },
        {
            id = "subArtist", filter = 1, dst = {
                {x = 1800, y = 516, w = 310, h = SUBARTIST_FONT_SIZE, r = 0, g = 0, b = 0, filter = 1}
            }
        },

        -- BPM
        {
            id = "bpmTextImg", op = {2}, dst = {
                {x = 1207, y = 547, w = SCORE_INFO.TEXT_W, h = SCORE_INFO.TEXT_H}
            }
        },
        -- BPM変化なし
        {
            id = "bpm", op = {176}, dst = {
                {x = 1380 - NORMAL_NUMBER_W * 7, y = 547, w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H}
            }
        },
        -- BPM変化あり
        {
            id = "bpmMax", op = {177}, dst = {
                {x = 1380 - NORMAL_NUMBER_W * 3, y = 547, w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H}
            }
        },
        {
            id = "bpmTilda", op = {177}, dst = {
                {x = 1380 - NORMAL_NUMBER_W * 4, y = 547, w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H}
            }
        },
        {
            id = "bpmMin", op = {177}, dst = {
                {x = 1380 - NORMAL_NUMBER_W * 7, y = 547, w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H}
            }
        },
        -- keys
        {
            id = "keysTextImg", op = {2}, dst = {
                {x = 1207, y = 517, w = SCORE_INFO.TEXT_W, h = SCORE_INFO.TEXT_H}
            }
        },
        -- 楽曲keys ゴリ押し
        {
            id = "music7keys", op = {160}, dst = {
                {x = 1207 + 70, y = 517, w = NORMAL_NUMBER_W * 2, h = NORMAL_NUMBER_H}
            }
        },
        {
            id = "music5keys", op = {161}, dst = {
                {x = 1207 + 70, y = 517, w = NORMAL_NUMBER_W * 2, h = NORMAL_NUMBER_H}
            }
        },
        {
            id = "music14keys", op = {162}, dst = {
                {x = 1207 + 70, y = 517, w = NORMAL_NUMBER_W * 2, h = NORMAL_NUMBER_H}
            }
        },
        {
            id = "music10keys", op = {163}, dst = {
                {x = 1207 + 70, y = 517, w = NORMAL_NUMBER_W * 2, h = NORMAL_NUMBER_H}
            }
        },
        {
            id = "music9keys", op = {164}, dst = {
                {x = 1207 + 70, y = 517, w = NORMAL_NUMBER_W * 2, h = NORMAL_NUMBER_H}
            }
        },
        {
            id = "music24keys", op = {1160}, dst = {
                {x = 1207 + 70, y = 517, w = NORMAL_NUMBER_W * 2, h = NORMAL_NUMBER_H}
            }
        },
        {
            id = "music48keys", op = {1161}, dst = {
                {x = 1207 + 70, y = 517, w = NORMAL_NUMBER_W * 2, h = NORMAL_NUMBER_H}
            }
        },

        -- 判定難易度
        {
            id = "judgeEasy", op = {183}, dst = {
                {x = 1335, y = 517, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H}
            }
        },
        {
            id = "judgeNormal", op = {182}, dst = {
                {x = 1335, y = 517, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H}
            }
        },
        {
            id = "judgeHard", op = {181}, dst = {
                {x = 1335, y = 517, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H}
            }
        },
        {
            id = "judgeVeryhard", op = {180}, dst = {
                {x = 1335, y = 517, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H}
            }
        },

        -- 検索ボックス
        {
            id = "searchBox", dst = {
                {x = -7, y = -7, w = 1038, h = 62}
            }
        },
        -- テキスト入力欄
        {
            id = "searchText", filter = 1, dst = {
                {x = 48, y = 12, w = 970, h = 24}
            }
        },
        -- 密度グラフ共通部分
        {
            id = "black", op = {910}, dst = {
                {x = 1138, y = 124, w = 600, h = 100, a = 192}
            }
        },
        {
            id = "notesGraph2", op = {2, 910}, dst = {
                {x = 1138, y = 124, w = 600, h = 100}
            }
        },
        {
            id = "bpmGraph", op = {2, 910}, dst = {
                {x = 1138, y = 124, w = 600, h = 100}
            }
        },
        -- 各ノーツ数は下のfor
    }

    -- バナー表示
    if isShowBanner() then
        table.insert(skin.destination, {
            id = -102, dst = {
                {x = 800, y = 784, w = 300, h = 80, filter = 1}
            }
        })
    end

    -- ユーザ情報出力周り
    user.dst(skin)

    -- コースの曲一覧
    for i = 1, 5 do
        local y = COURSE.BASE_Y - COURSE.INTERVAL_Y * (i - 1) -- 14は上下の影
        -- 背景
        table.insert(skin.destination, {
            id = "courseBarBg", op = {3}, dst = {
                {x = 0, y = y, w = COURSE.BG_W, h = COURSE.LABEL_H + 14}
            }
        })
        -- 1st等のラベル
        table.insert(skin.destination, {
            id = "courseMusic" .. i .. "Label", op = {3}, dst = {
                {x = -2, y = y + 7, w = COURSE.LABEL_W, h = COURSE.LABEL_H}
            }
        })
        -- 曲名
        table.insert(skin.destination, {
            id = "course" .. i .. "Text", op = {3}, filter = 1, dst = {
                {x = 750, y = y + 20, w = COURSE.SONGNAME_W, h = BAR_FONT_SIZE, r = 0, g = 0, b = 0}
            }
        })
    end

    -- リプレイボタン
    local replayOps = {197, 1197, 1200, 1203}
    for i = 1, 4 do
        local buttonX = 892 + 60 * (i - 1)
        table.insert(skin.destination, { -- リプレイあり
            id = "replayButtonBg", op = {replayOps[i]}, dst = {
                {x = buttonX, y = 513, w = REPLAY_BUTTON_SIZE, h = REPLAY_BUTTON_SIZE}
            }
        })
        table.insert(skin.destination, { -- リプレイ無し
            id = "replayButtonBg", op = {replayOps[i] - 1}, dst = {
                {x = buttonX, y = 513, w = REPLAY_BUTTON_SIZE, h = REPLAY_BUTTON_SIZE, a = 128}
            }
        })
        table.insert(skin.destination, { -- 右下の1,2,3,4の数字
            id = "replay" .. i .. "Text", op = {replayOps[i]}, dst = {
                {x = buttonX + 34, y = 513 + 2, w = REPLAY_TEXT_W, h = REPLAY_TEXT_H}
            }
        })
        table.insert(skin.destination, { -- 起動用ボタン
            id = "replay" .. i .. "ButtonDummy", op = {replayOps[i]}, dst = {
                {x = buttonX + 6, y = 513 + 6, w = REPLAY_BUTTON_SIZE - 12, h = REPLAY_BUTTON_SIZE - 12}
            }
        })
    end

    -- 密度グラフ
    if getTableValue(skin_config.option, "密度グラフ表示", 910) == 910 then
        -- フレーム表示
        if getTableValue(skin_config.option, "上部プレイヤー情報仕様", 950) == 951 then
            table.insert(skin.destination, {
                id = "notesGraphFrame", op = {910}, dst = {
                    {x = GRAPH.WND.OLD.X - GRAPH.WND.OLD.SHADOW, y = GRAPH.WND.OLD.Y - GRAPH.WND.OLD.SHADOW, w = GRAPH.WND.OLD.W, h = GRAPH.WND.OLD.H}
                }
            })
        elseif getTableValue(skin_config.option, "上部プレイヤー情報仕様", 950) == 950 then
            table.insert(skin.destination, {
                id = "notesGraphFrame2", op = {910}, dst = {
                    {x = GRAPH.WND.NEW.X - GRAPH.WND.OLD.SHADOW, y = GRAPH.WND.NEW.Y - GRAPH.WND.OLD.SHADOW, w = GRAPH.WND.NEW.W, h = GRAPH.WND.NEW.H}
                }
            })
        end
        local noteTypes = {"Normal", "Scratch", "Ln", "Bss"}
        for i = 1, 4 do
            table.insert(skin.destination, {
                id = "numOf" .. noteTypes[i] .. "NotesIcon", op = {910}, dst = {
                    {x = 1152 + 150 * (i - 1), y = 77, w = NOTES_ICON_SIZE, h = NOTES_ICON_SIZE}
                }
            })
            table.insert(skin.destination, {
                id = "numOf" .. noteTypes[i] .. "Notes", op = {910}, dst = {
                    {x = 1152 + 58 + 150 * (i - 1), y = 77 + 10, w = STATUS_NUMBER_W, h = STATUS_NUMBER_H}
                }
            })
        end

        -- 消費スタミナ
        if getTableValue(skin_config.option, "上部プレイヤー情報仕様", 950) == 950 then
            local staminaX = GRAPH.WND.NEW.X + GRAPH.STAMINA.LABEL.X
            local staminaY = GRAPH.WND.NEW.Y + GRAPH.STAMINA.LABEL.Y
            -- ラベル
            table.insert(skin.destination, {
                id = "useStaminaTextImg", op = {910}, dst = {
                    {x = staminaX, y = staminaY, w = GRAPH.STAMINA.LABEL.W, h = GRAPH.STAMINA.LABEL.H}
                }
            })
            -- スタミナ出力
            -- 現在値
            preDrawDynamicNumbers(
                skin, "24pxNumbers", "useStaminaValue",
                staminaX + GRAPH.STAMINA.NUM.X, staminaY + GRAPH.STAMINA.NUM.Y,
                NUMBERS_24PX.W, NUMBERS_24PX.H, 0, false, {})

            setValue("useStaminaValue", 0)
        end
    end


    -- 選曲スライダー
    table.insert(skin.destination, {
        id = "musicSelectSlider", dst = {
            {x = 1892, y = 153 + 768 + 6 - MUSIC_SLIDER_BUTTON_H, w = MUSIC_SLIDER_BUTTON_W, h = MUSIC_SLIDER_BUTTON_H}
        }
    })

    -- レベルアイコン周り
    if getTableValue(skin_config.option, "曲情報表示形式", 935) == 935 then
        -- 難易度表示
        for i = 1, 5 do
            -- レベル表記
            table.insert(skin.destination, {
                id = "largeLevel" .. LEVEL_NAME_TABLE[i], op = {150 + i}, dst = {
                    {x = LARGE_LEVEL.X + LARGE_LEVEL.INTERVAL * (i - 1) - 15, y = LARGE_LEVEL.Y, w = 30, h = 40}
                }
            })

            -- 非アクティブ時のレベルアイコン
            table.insert(skin.destination, {
                id = "nonActive" .. LEVEL_NAME_TABLE[i] .. "Icon", op = {-150 - i}, dst = {
                    {x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y - (LARGE_LEVEL.NONACTIVE_ICON_H - LARGE_LEVEL.ACTIVE_ICON_H), w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.NONACTIVE_ICON_H}
                }
            })

            -- アクティブ時のレベルアイコン(背景)
            table.insert(skin.destination, {
                id = "active" .. LEVEL_NAME_TABLE[i] .. "Icon", op = {150 + i}, dst = {
                    {x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y - 2, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H}
                }
            })

            -- アクティブ時のレベルアイコンのノート
            table.insert(skin.destination, {
                id = "active" .. LEVEL_NAME_TABLE[i] .. "Note", op = {150 + i}, loop = 0, timer = 11, filter = 1, dst = {
                    {time = 0, angle = 0, acc = 2, a = 255, x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y - 5, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
                    {time = 500, angle = -10, acc = 2, a = 255, x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y + 10, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
                    {time = 501, angle = -10, acc = 2, a = 0},
                    {time = 1000, angle = 0, acc = 2, a = 0},
                }
            })
            table.insert(skin.destination, {
                id = "active" .. LEVEL_NAME_TABLE[i] .. "Note", op = {150 + i}, loop = 0, timer = 11, filter = 1, dst = {
                    {time = 0, angle = 0, acc = 1, a = 0},
                    {time = 500, angle = -10, acc = 1, a = 0},
                    {time = 501, angle = -10, acc = 1, a = 255, x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y + 10, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
                    {time = 1000, angle = 0, acc = 1, a = 255, x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y - 5, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_ICON_H},
                }
            })

            -- アクティブ時のレベルアイコンのテキスト
            table.insert(skin.destination,  {
                id = "active" .. LEVEL_NAME_TABLE[i] .. "Text", op = {150 + i}, dst = {
                    {x = LARGE_LEVEL.ICON_X + LARGE_LEVEL.INTERVAL * (i - 1), y = LARGE_LEVEL.ICON_Y + 1, w = LARGE_LEVEL.ICON_W, h = LARGE_LEVEL.ACTIVE_TEXT_H}
                }
            })
        end
    elseif getTableValue(skin_config.option, "曲情報表示形式", 935) == 936 then
        -- 密度表示

        -- 難易度部分
        for i = 1, 5 do
            -- レベルアイコン(背景)
            table.insert(skin.destination, {
                id = "active" .. LEVEL_NAME_TABLE[i] .. "Icon", op = {150 + i}, dst = {
                    {x = DENSITY_INFO.DIFFICULTY_ICON_X, y = DENSITY_INFO.ICON_Y, w = DENSITY_INFO.ICON_W, h = DENSITY_INFO.ICON_H}
                }
            })
            -- レベルアイコンのノート
            table.insert(skin.destination, {
                id = "active" .. LEVEL_NAME_TABLE[i] .. "Note", op = {150 + i}, dst = {
                    {x = DENSITY_INFO.DIFFICULTY_ICON_X, y = DENSITY_INFO.ICON_Y, w = DENSITY_INFO.ICON_W, h = DENSITY_INFO.ICON_H},
                }
            })
            -- 文字
            table.insert(skin.destination, {
                id = "densityDifficulty" .. LEVEL_NAME_TABLE[i] .. "Text", op = {150 + i}, dst = {
                    {x = DENSITY_INFO.DIFFICULTY_TEXT_X - 2, y = DENSITY_INFO.ICON_Y - 1, w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H}
                }
            })

            -- レベル表記
            table.insert(skin.destination, {
                id = "largeLevel" .. LEVEL_NAME_TABLE[i], op = {150 + i}, dst = {
                    {x = DENSITY_INFO.DIFFICULTY_NUMBER_X, y = DENSITY_INFO.NUMBER_Y, w = LARGE_LEVEL.NUMBER_W, h = LARGE_LEVEL.NUMBER_H}
                }
            })
        end

        -- 密度部分
        local startX = DENSITY_INFO.START_X
        local types = {"Average", "End", "Peak"}

        for i = 1, 3 do
            -- アイコン部分
            table.insert(skin.destination, {
                id = "density" ..  types[i] .. "Icon", op = {2}, dst = {
                    {x = startX + DENSITY_INFO.INTERVAL_X * (i - 1), y = DENSITY_INFO.ICON_Y, w = DENSITY_INFO.ICON_W, h = DENSITY_INFO.ICON_H}
                }
            })
            table.insert(skin.destination, {
                id = "density" ..  types[i] .. "Note", op = {2}, dst = {
                    {x = startX + DENSITY_INFO.INTERVAL_X * (i - 1), y = DENSITY_INFO.ICON_Y + 4, w = DENSITY_INFO.ICON_W, h = DENSITY_INFO.ICON_H}
                }
            })
            table.insert(skin.destination, {
                id = "density" ..  types[i] .. "Text", op = {2}, dst = {
                    {x = startX + DENSITY_INFO.INTERVAL_X * (i - 1) - 2, y = DENSITY_INFO.ICON_Y - 1, w = DENSITY_INFO.TEXT_W, h = DENSITY_INFO.TEXT_H}
                }
            })

            -- super magic number
            local offset = 63
            if getTableValue(skin_config.option, "密度の標準桁数", 938) == 938 then
                offset = 47
            end
            if types[i] == "Peak" then
                offset = 83
            end

            -- 整数部分
            table.insert(skin.destination, {
                id = "density" ..  types[i] .. "Number", op = {2}, dst = {
                    {x = startX + DENSITY_INFO.INTERVAL_X * (i - 1) + offset - LARGE_LEVEL.NUMBER_W*2, y = DENSITY_INFO.NUMBER_Y, w = LARGE_LEVEL.NUMBER_W, h = LARGE_LEVEL.NUMBER_H}
                }
            })
            -- peakは小数点以下が現在は表示できないので出さない
            if types[i] ~= "Peak" then
                -- dot
                table.insert(skin.destination, {
                    id = "density" ..  types[i] .. "Dot", op = {2}, dst = {
                        {x = startX + DENSITY_INFO.INTERVAL_X * (i - 1) + offset, y = DENSITY_INFO.NUMBER_Y, w = DENSITY_INFO.DOT_SIZE, h = DENSITY_INFO.DOT_SIZE}
                    }
                })
                -- 小数点以下
                table.insert(skin.destination, {
                    id = "density" ..  types[i] .. "AfterDot", op = {2}, dst = {
                        {x = startX + DENSITY_INFO.INTERVAL_X * (i - 1) + offset + 8, y = DENSITY_INFO.NUMBER_Y, w = MUSIC_BAR.DIFFICULTY_NUMBER_W, h = MUSIC_BAR.DIFFICULTY_NUMBER_H}
                    }
                })
            end
        end
    end

    -- ランク出力
    for i, rank in ipairs(ranks) do
        table.insert(skin.destination, {
            id = "rank" .. rank, op = {{2, 3}, 200 + (i - 1)}, dst = {
                {x = SCORE_RANK.X, y = SCORE_RANK.Y, w = SCORE_RANK.W, h = SCORE_RANK.H}
            }
        })
    end

    -- exscoreとnext
    table.insert(skin.destination, {
        id = "exScoreTextImg", op = {624}, dst = {
            {x = EXSCORE_AREA.TEXT_X, y = EXSCORE_AREA.Y, w = SCORE_INFO.TEXT_W, h = SCORE_INFO.TEXT_H}
        }
    })
    table.insert(skin.destination, {
        id = "richExScore", op = {624}, dst = {
            {x = EXSCORE_AREA.NUMBER_X - EXSCORE_AREA.NUMBER_W * 5, y = EXSCORE_AREA.Y, w = EXSCORE_AREA.NUMBER_W, h = EXSCORE_AREA.NUMBER_H}
        }
    })
    table.insert(skin.destination, {
        id = "nextRankTextImg", op = {624}, dst = {
            {x = EXSCORE_AREA.TEXT_X, y = EXSCORE_AREA.NEXT_Y, w = SCORE_INFO.TEXT_W, h = SCORE_INFO.TEXT_H}
        }
    })
    table.insert(skin.destination, {
        id = "nextRank", op = {624}, dst = {
            {x = EXSCORE_AREA.NUMBER_X - NORMAL_NUMBER_W * SCORE_INFO.DIGIT, y = EXSCORE_AREA.NEXT_Y, w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H}
        }
    })
    table.insert(skin.destination, {
        id = "irRankingText", dst = {
            {x = EXSCORE_AREA.TEXT_X, y = EXSCORE_AREA.IR_Y, w = EXSCORE_AREA.IR_W, h = EXSCORE_AREA.IR_H}
        }
    })
    table.insert(skin.destination, {
        id = "irRanking", dst = {
            {x = EXSCORE_AREA.NUMBER_X - IR.NUMBER_NUM_W * 5 - NORMAL_NUMBER_W * 6, y = EXSCORE_AREA.IR_Y, w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H}
        }
    })
    table.insert(skin.destination, {
        id = "slashForRanking", op = {-606}, dst = {
            {x = EXSCORE_AREA.NUMBER_X - IR.NUMBER_NUM_W * 5 - NORMAL_NUMBER_W * 1, y = EXSCORE_AREA.IR_Y, w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H}
        }
    })
    table.insert(skin.destination, {
        id = "irPlayerNumber", dst = {
            {x = EXSCORE_AREA.NUMBER_X - IR.NUMBER_NUM_W * 5, y = EXSCORE_AREA.IR_Y, w = IR.NUMBER_NUM_W, h = IR.NUMBER_NUM_H}
        }
    })
    -- ライバル名とexScore
    table.insert(skin.destination, {
        id = "playerName", op = {625}, dst = {
            {x = RIVAL.NAME_X, y = RIVAL.PLAYER_Y - 4, w = RIVAL.MAX_W, h = RIVAL.FONT_SIZE, r = 0, g = 0, b = 0}
        }
    })
    table.insert(skin.destination, {
        id = "richExScore", op = {625}, dst = {
            {x = EXSCORE_AREA.NUMBER_X - EXSCORE_AREA.NUMBER_W * 5, y = RIVAL.PLAYER_Y, w = EXSCORE_AREA.NUMBER_W, h = EXSCORE_AREA.NUMBER_H}
        }
    })
    table.insert(skin.destination, {
        id = "rivalName", op = {625}, dst = {
            {x = RIVAL.NAME_X, y = RIVAL.RIVAL_Y - 4, w = RIVAL.MAX_W, h = RIVAL.FONT_SIZE, r = 0, g = 0, b = 0}
        }
    })
    table.insert(skin.destination, {
        id = "rivalExScore", op = {625}, dst = {
            {x = EXSCORE_AREA.NUMBER_X - EXSCORE_AREA.NUMBER_W * 5, y = RIVAL.RIVAL_Y, w = EXSCORE_AREA.NUMBER_W, h = EXSCORE_AREA.NUMBER_H}
        }
    })

    -- 各種ステータス
    local statusLine = {
        {"numOfPerfect", "numOfGreat", "numOfGood", "numOfBad", "numOfPoor"},
        {"hiScore", "maxCombo", "totalNotes", "missCount", "playCount", "clearCount"},
    }
    for i, arr in ipairs(statusLine) do
        for j, val in ipairs(arr) do
            local baseX = SCORE_INFO.TEXT_BASE_X + SCORE_INFO.INTERVAL_X * (i - 1)
            local baseY = SCORE_INFO.TEXT_BASE_Y - SCORE_INFO.INTERVAL_Y * (j - 1)
            local numberX = baseX + SCORE_INFO.NUMBER_OFFSET_X - NORMAL_NUMBER_W * 8
            if val == "numOfPoor" then
                numberX = numberX - NORMAL_NUMBER_W * 5
            end

            -- テキスト画像
            table.insert(skin.destination, {
                id = val .. "TextImg", dst = {
                    {
                        x = baseX,
                        y = baseY,
                        w = SCORE_INFO.TEXT_W, h = SCORE_INFO.TEXT_H
                    }
                }
            })
            -- 数値
            -- 曲
            table.insert(skin.destination, {
                id = val, op = {2}, dst = {
                    {
                        x = numberX,
                        y = baseY,
                        w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H
                    }
                }
            })
            table.insert(skin.destination, {
                id = val, op = {3}, dst = {
                    {
                        x = numberX,
                        y = baseY,
                        w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H
                    }
                }
            })
            -- フォルダ
            if has_value(commonStatusTexts, val .. "Folder") then
                table.insert(skin.destination, {
                    id = val .. "Folder", op = {1}, dst = {
                        {
                            x = numberX,
                            y = baseY,
                            w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H
                        }
                    }
                })
            end
            -- 空プア
            if val == "numOfPoor" then
                table.insert(skin.destination, {
                    id = "slashForEmptyPoor", dst = {
                        {
                            x = numberX + NORMAL_NUMBER_W*8,
                            y = baseY,
                            w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H
                        }
                    }
                })
                table.insert(skin.destination, {
                    id = "numOfEmptyPoor", dst = {
                        {
                            x = numberX + NORMAL_NUMBER_W + NORMAL_NUMBER_W*4,
                            y = baseY,
                            w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H
                        }
                    }
                })
            end
        end
    end

    -- IR
    local irTextOrder = {
        {"Max", "Perfect", "Fullcombo", "Exhard", "Hard", "Clear", "Easy",},
        {"Player", "NumOfFullcombo", "NumOfClear", "", "Lassist", "Aassist", "Failed"}
    }
    for i, _ in ipairs(irTextOrder) do
        for j, type in ipairs(irTextOrder[i]) do
            if irTextOrder[i][j] ~= "" then
                local baseX = IR.X + IR.INTERVAL_X * (i - 1)
                local baseY = IR.Y - IR.INTERVAL_Y * (j - 1)
                -- 画像
                table.insert(skin.destination, {
                    id = "ir" .. type .. "Text", dst = {
                        {x = baseX, y = baseY, w = IR.TEXT_W, h = IR.TEXT_H}
                    }
                })
                -- 数値
                table.insert(skin.destination, {
                    id = "ir" .. type .. "Number", dst = {
                        {x = baseX + 146 - IR.NUMBER_NUM_W * IR.DIGIT, y = baseY + 1, w = IR.NUMBER_NUM_W, h = IR.NUMBER_NUM_H}
                    }
                })
                -- player以外はパーセンテージも
                if irTextOrder[i][j] ~= "Player" then
                    table.insert(skin.destination, {
                        id = "ir" .. type .. "Percentage", dst = {
                            {x = baseX + 168 - IR.NUMBER_PERCENT_W * 3, y = baseY + 1, w = IR.NUMBER_PERCENT_W, h = IR.NUMBER_PERCENT_H}
                        }
                    })
                    table.insert(skin.destination, {
                        id = "irDot", op = {-606}, dst = {
                            {x = baseX + 168, y = baseY + 1, w = IR.NUMBER_PERCENT_W, h = IR.NUMBER_PERCENT_H}
                        }
                    })
                    table.insert(skin.destination, {
                        id = "ir" .. type .. "PercentageAfterDot", dst = {
                            {x = baseX + 178 - IR.NUMBER_PERCENT_W * 1, y = baseY + 1, w = IR.NUMBER_PERCENT_W, h = IR.NUMBER_PERCENT_H}
                        }
                    })
                    table.insert(skin.destination, {
                        id = "irPercent", op = {-606}, dst = {
                            {x = baseX + 179, y = baseY + 1, w = IR.PERCENT_W, h = IR.PERCENT_H}
                        }
                    })
                end
            end
        end
    end
    -- IRロード表示
    table.insert(skin.destination, {
        id = "irLoadingFrame", op = {606, -1, -1030}, dst = {
            {x = IR.LOADING.FRAME_X, y = IR.LOADING.FRAME_Y, w = IR.LOADING.FRAME_W, h = IR.LOADING.FRAME_H}
        }
    })
    table.insert(skin.destination, {
        id = "irLoadingLoadText", op = {606, -1, -1030}, dst = {
            {x = IR.LOADING.FRAME_X + 49, y = IR.LOADING.FRAME_Y + 20, w = IR.LOADING.LOADING_TEXT_W, h = IR.LOADING.LOADING_TEXT_H}
        }
    })
    for i = 1, IR.LOADING.WAVE_LEVEL do
        table.insert(skin.destination, {
            id = "irLoadingWave" .. i, op = {606, -1, -1030}, loop = 0, timer = 11, dst = {
                {time = 0, a = 0, acc = 3, x = IR.LOADING.FRAME_X + 19 + IR.LOADING.WAVE_W * (i - 1), y = IR.LOADING.FRAME_Y + 18, w = IR.LOADING.WAVE_W, h = IR.LOADING.WAVE_H},
                {time = IR.LOADING.WAVE_TIME_INTERVAL * i, a = 255},
                {time = IR.LOADING.WAVE_TIME_INTERVAL * (IR.LOADING.WAVE_LEVEL + 1)}
            }
        })
    end

    -- ボタン
    help.destinationOpenButton(skin)
    statistics.destinationOpenButton(skin)
    -- ヘルプウィンドウ
    help.setWindowDestination(skin)
    help.setListDestination(skin)
    help.setWindowDestination2(skin)
    help.setDestinationDescription(skin)

    -- 統計ウィンドウ
    statistics.destinationWindow(skin)

    -- プレイオプション
    -- 背景部分
    for i = 1, 3 do
        local op = 21 + (i - 1)
        -- 背景
        table.insert(skin.destination, {
            id = "black", op = {op}, dst = {
                {x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 64},
            }
        })
        -- 横長
        insertOptionAnimationTable(skin, "white", op, OPTION_INFO.WND_OFFSET_X, OPTION_INFO.WND_OFFSET_Y + OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_W, OPTION_INFO.WND_H - OPTION_INFO.WND_EDGE_SIZE * 2, 0)
        -- 縦長
        insertOptionAnimationTable(skin, "white", op, OPTION_INFO.WND_OFFSET_X + OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_OFFSET_Y, OPTION_INFO.WND_W - OPTION_INFO.WND_EDGE_SIZE * 2, OPTION_INFO.WND_H, 0)
        -- 四隅
        insertOptionAnimationTable(skin, "optionWndEdge", op, OPTION_INFO.WND_OFFSET_X, OPTION_INFO.WND_OFFSET_Y, OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_EDGE_SIZE, 90)
        insertOptionAnimationTable(skin, "optionWndEdge", op, OPTION_INFO.WND_OFFSET_X + OPTION_INFO.WND_W - OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_OFFSET_Y, OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_EDGE_SIZE, 180)
        insertOptionAnimationTable(skin, "optionWndEdge", op, OPTION_INFO.WND_OFFSET_X + OPTION_INFO.WND_W - OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_OFFSET_Y + OPTION_INFO.WND_H - OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_EDGE_SIZE, 270)
        insertOptionAnimationTable(skin, "optionWndEdge", op, OPTION_INFO.WND_OFFSET_X, OPTION_INFO.WND_OFFSET_Y + OPTION_INFO.WND_H - OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_EDGE_SIZE, 0)

        -- オプションのヘッダ部分
        insertOptionAnimationTable(skin, "popUpWindowHeaderLeft", op, SIMPLE_WND_AREA.X + HEADER.MARKER.X, SIMPLE_WND_AREA.Y + HEADER.MARKER.Y, HEADER.MARKER.W, HEADER.MARKER.H, 0)
        insertOptionAnimationTable(skin, "purpleRed", op, SIMPLE_WND_AREA.X + HEADER.UNDERBAR.X, SIMPLE_WND_AREA.Y + HEADER.UNDERBAR.Y, HEADER.UNDERBAR.W, HEADER.UNDERBAR.H, 0)
    end
    -- オプションのヘッダテキスト
    local optionTypes = {"optionHeaderPlayOption", "optionHeaderAssistOption", "optionHeaderOtherOption"}
    for i, v in ipairs(optionTypes) do
        insertOptionAnimationTable(skin, v, 21 + (i - 1), 220, 932, OPTION_INFO.HEADER_TEXT_W, HEADER.MARKER.H, 0)
    end

    -- プレイプション
    if getTableValue(skin_config.option, "オプションのスコア目標表示", 940) == 940 then
        destinationPlayOption(skin, 192, 517, "optionHeader2NotesOrder1", "notesOrder1", true, {1, 2}, 21)
        destinationPlayOption(skin, 1088, 517, "optionHeader2NotesOrder2", "notesOrder2", true, {6, 7}, 21)
        destinationPlayOption(skin, 192, 115, "optionHeader2GaugeType", "gaugeType", false, {3}, 21)
        destinationPlayOption(skin, 720, 115, "optionHeader2DpOption", "dpType", false, {4}, 21)
        destinationPlayOption(skin, 1248, 115, "optionHeader2FixedHiSpeed", "hiSpeedType", false, {5}, 21)
    else
        destinationPlayOption(skin, 192, 517, "optionHeader2NotesOrder1", "notesOrder1", false, {1, 2}, 21)
        destinationPlayOption(skin, 720, 517, "optionHeader2DpOption", "dpType", false, {4}, 21)
        destinationPlayOption(skin, 1248, 517, "optionHeader2NotesOrder2", "notesOrder2", false, {6, 7}, 21)
        destinationPlayOption(skin, 192, 115, "optionHeader2PeaceMaker", "paceMaker", false, {}, 21)
        destinationPlayOption(skin, 720, 115, "optionHeader2GaugeType", "gaugeType", false, {3}, 21)
        destinationPlayOption(skin, 1248, 115, "optionHeader2FixedHiSpeed", "hiSpeedType", false, {5}, 21)
    end
    -- アシスト
    for i, assistText in ipairs(assistTexts) do
        local baseY = 865 - 109 * (i - 1)
        -- 小さいキーの背景
        insertOptionAnimationTable(skin, SUB_HEADER.EDGE.LEFT_ID, 22, 192, baseY, SUB_HEADER.EDGE.W, SUB_HEADER.EDGE.H, 0)
        insertOptionAnimationTable(skin, SUB_HEADER.EDGE.RIGHT_ID, 22, 192 + 96 - SUB_HEADER.EDGE.W, baseY, SUB_HEADER.EDGE.W, SUB_HEADER.EDGE.H, 0)
        insertOptionAnimationTable(skin, "gray2", 22, 192 + SUB_HEADER.EDGE.W, baseY, 96 - SUB_HEADER.EDGE.W * 2, SUB_HEADER.EDGE.H, 0)

        -- 小さいキー
        for j = 1, 7 do
            if i ~= j then
                local y = baseY + 3
                if j % 2 == 0 then -- 上のキーは座標足す
                    y = y + SMALL_KEY_H - 6 * 2
                end
                insertOptionAnimationTable(skin, "optionSmallKeyNonActive", 22, 
                    192 + 20 + (j - 1) * (SMALL_KEY_W - 12) - 6, y,
                    SMALL_KEY_W, SMALL_KEY_H, 0)
            end
        end
        for j = 1, 7 do
            if i == j then
                local y = baseY + 3
                if j % 2 == 0 then -- 上のキーは座標足す
                    y = y + SMALL_KEY_H - 6 * 2
                end
                insertOptionAnimationTable(skin, "optionSmallKeyActive", 22, 
                    192 + 20 + (j - 1) * (SMALL_KEY_W - 12) - 6, y,
                    SMALL_KEY_W, SMALL_KEY_H, 0)
            end
        end

        -- 文字
        insertOptionAnimationTable(skin, assistText .. "TextImg", 22, 314, baseY, OPTION_INFO.HEADER_TEXT_W, HEADER.MARKER.H, 0)
        insertOptionAnimationTable(skin, assistText .. "DescriptionTextImg", 22, 672, baseY, OPTION_INFO.HEADER_TEXT_W * 2, HEADER.MARKER.H, 0)

        -- ボタン
        insertOptionAnimationTable(skin, assistText .. "ButtonImgset", 22, 1426, baseY - (OPTION_INFO.SWITCH_BUTTON_H - HEADER.MARKER.H) / 2, OPTION_INFO.SWITCH_BUTTON_W, OPTION_INFO.SWITCH_BUTTON_H, 0)
    end

    -- その他オプション
    -- ヘルプ背景
    insertOptionAnimationTable(skin, "gray2", 23, OPTION_INFO.WND_OFFSET_X + OPTION_INFO.WND_W - HELP_WND_W, OPTION_INFO.WND_OFFSET_Y, HELP_WND_W - OPTION_INFO.WND_EDGE_SIZE, HELP_WND_H - OPTION_INFO.WND_EDGE_SIZE, 0)
    insertOptionAnimationTable(skin, "gray2", 23, OPTION_INFO.WND_OFFSET_X + OPTION_INFO.WND_W - HELP_WND_W + OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_OFFSET_Y + OPTION_INFO.WND_EDGE_SIZE, HELP_WND_W - OPTION_INFO.WND_EDGE_SIZE, HELP_WND_H - OPTION_INFO.WND_EDGE_SIZE, 0)

    -- 隅
    insertOptionAnimationTable(skin, "optionWndEdge", 23, OPTION_INFO.WND_OFFSET_X + OPTION_INFO.WND_W - OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_OFFSET_Y, OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_EDGE_SIZE, 180, 64, 64, 64)
    insertOptionAnimationTable(skin, "optionWndEdge", 23,
        OPTION_INFO.WND_OFFSET_X + OPTION_INFO.WND_W - HELP_WND_W,
        OPTION_INFO.WND_OFFSET_Y + HELP_WND_H - OPTION_INFO.WND_EDGE_SIZE,
        OPTION_INFO.WND_EDGE_SIZE, OPTION_INFO.WND_EDGE_SIZE, 0, 64, 64, 64)


    destinationPlayOption(skin, 192, 115, "optionHeader2GaugeAutoShift", "gaugeAutoShift", true, {2}, 23)
    destinationPlayOption(skin, 192, 517, "optionHeader2BgaShow", "bgaShow", true, {1}, 23)
    destinationNumberOption(skin, 1088, 794, "optionHeader2NotesDisplayTime", "notesDisplayTime", true, {4, 6}, 23)
    destinationNumberOption(skin, 1088, 614, "optionHeader2JudgeTiming", "judgeTiming", true, {5, 7}, 23)

    -- ヘルプヘッダ
    local helpHeaderOffsetX = OPTION_INFO.WND_OFFSET_X + OPTION_INFO.WND_W - HELP_WND_W + 3
    local helpHeaderOffsetY = OPTION_INFO.WND_OFFSET_Y + HELP_WND_H - HELP_ICON_SIZE - 3
    insertOptionAnimationTable(skin, "helpIcon", 23, helpHeaderOffsetX, helpHeaderOffsetY, HELP_ICON_SIZE, HELP_ICON_SIZE, 0)
    insertOptionAnimationTable(skin, "helpHeaderText", 23, helpHeaderOffsetX + HELP_ICON_SIZE + 1, helpHeaderOffsetY + 13, 122, 30, 0)
    insertOptionAnimationTable(skin, "white", 23, helpHeaderOffsetX + 6, helpHeaderOffsetY, 652, 2, 0)

    -- ヘルプ内容
    table.insert(skin.destination, {
        id = "helpNumberKeys", op = {23}, loop = OPTION_INFO.ANIMATION_TIME, timer = 23, dst = {
            {time = 0, x = BASE_WIDTH / 2, y = BASE_HEIGHT / 2, w = 0, h = 0},
            {time = OPTION_INFO.ANIMATION_TIME, a = 255, x = helpHeaderOffsetX + 9, y = helpHeaderOffsetY - HELP_TEXT_H, w = HELP_TEXT1_W, h = HELP_TEXT_H},
            {time = 3500 + OPTION_INFO.ANIMATION_TIME, a = 255},
            {time = 4000 + OPTION_INFO.ANIMATION_TIME, a = 0},
            {time = 15500 + OPTION_INFO.ANIMATION_TIME, a = 0},
            {time = 16000 + OPTION_INFO.ANIMATION_TIME, a = 255, x = helpHeaderOffsetX + 9, y = helpHeaderOffsetY - HELP_TEXT_H, w = HELP_TEXT1_W, h = HELP_TEXT_H},
        }
    })
    table.insert(skin.destination, {
        id = "helpFunctionKeys1", op = {23}, loop = OPTION_INFO.ANIMATION_TIME, timer = 23, dst = {
            {time = 0, a = 0},
            {time = 3500 + OPTION_INFO.ANIMATION_TIME, a = 0, x = helpHeaderOffsetX + 9, y = helpHeaderOffsetY - 246, w = HELP_TEXT1_W, h = 246},
            {time = 4000 + OPTION_INFO.ANIMATION_TIME, a = 255, x = helpHeaderOffsetX + 9, y = helpHeaderOffsetY - 246, w = HELP_TEXT1_W, h = 246},
            {time = 7500 + OPTION_INFO.ANIMATION_TIME, a = 255},
            {time = 8000 + OPTION_INFO.ANIMATION_TIME, a = 0},
            {time = 16000 + OPTION_INFO.ANIMATION_TIME, a = 0},
        }
    })
    table.insert(skin.destination, {
        id = "helpFunctionKeys2", op = {23}, loop = OPTION_INFO.ANIMATION_TIME, timer = 23, dst = {
            {time = 0, a = 0},
            {time = 3500 + OPTION_INFO.ANIMATION_TIME, a = 0, x = helpHeaderOffsetX + 9, y = helpHeaderOffsetY - 246 - 163, w = 470, h = 163},
            {time = 4000 + OPTION_INFO.ANIMATION_TIME, a = 255, x = helpHeaderOffsetX + 9, y = helpHeaderOffsetY - 246 - 163, w = 470, h = 163},
            {time = 7500 + OPTION_INFO.ANIMATION_TIME, a = 255},
            {time = 8000 + OPTION_INFO.ANIMATION_TIME, a = 0},
            {time = 16000 + OPTION_INFO.ANIMATION_TIME, a = 0},
        }
    })
    table.insert(skin.destination, {
        id = "helpPlayKey", op = {23}, loop = OPTION_INFO.ANIMATION_TIME, timer = 23, dst = {
            {time = 0, a = 0},
            {time = 7500, a = 0, x = helpHeaderOffsetX + 9 + 64, y = helpHeaderOffsetY - HELP_TEXT_H, w = HELP_TEXT2_W, h = HELP_TEXT_H},
            {time = 8000, a = 255, x = helpHeaderOffsetX + 9 + 64, y = helpHeaderOffsetY - HELP_TEXT_H, w = HELP_TEXT2_W, h = HELP_TEXT_H},
            {time = 11500, a = 255},
            {time = 12000, a = 0},
            {time = 16000, a = 0},
        }
    })
    destinationSmallKeysInHelp(skin, 1100, 469, {1}, 8000, 3500, 500, 16000);
    destinationSmallKeysInHelp(skin, 1100, 428, {2}, 8000, 3500, 500, 16000);
    destinationSmallKeysInHelp(skin, 1100, 399, {4}, 8000, 3500, 500, 16000);
    destinationSmallKeysInHelp(skin, 1100, 358, {3}, 8000, 3500, 500, 16000);
    destinationSmallKeysInHelp(skin, 1100, 318, {5}, 8000, 3500, 500, 16000);
    destinationSmallKeysInHelp(skin, 1100, 277, {7}, 8000, 3500, 500, 16000);
    destinationSmallKeysInHelp(skin, 1100, 236, {7}, 8000, 3500, 500, 16000);
    table.insert(skin.destination, {
        id = "helpDetailReplayKey", op = {23}, loop = 0, timer = 23, dst = {
            {time = 0, a = 0},
            {time = 11500, a = 0, x = helpHeaderOffsetX + 9 + 64, y = helpHeaderOffsetY - 248, w = HELP_TEXT2_W, h = 248},
            {time = 12000, a = 255, x = helpHeaderOffsetX + 9 + 64, y = helpHeaderOffsetY - 248, w = HELP_TEXT2_W, h = 248},
            {time = 15500, a = 255},
            {time = 16000, a = 0},
        }
    })
    local replayActiveKeys = {{6}, {4}, {4, 6}, {2}, {3}, {5}}
    for i = 1, 6 do
        destinationSmallKeysInHelp(skin, 1100, 469 - (i - 1) * 41, {7}, 12000, 3500, 500, 16000);
        destinationSmallKeysInHelp(skin, 1100 + 95, 469 - (i - 1) * 41, replayActiveKeys[i], 12000, 3500, 500, 16000);
    end

    -- 新バージョン通知
    if existNewVersion then
    -- if true then
        local dst = {
            {time = 0, x = NEW_VERSION_MSG.WND.START_X, y = NEW_VERSION_MSG.WND.Y, w = NEW_VERSION_MSG.WND.W, h = NEW_VERSION_MSG.WND.H, acc = 2},
            {time = 2000},
            {time = 2300, x = NEW_VERSION_MSG.WND.X},
            {time = 6300},
            {time = 6600, x = NEW_VERSION_MSG.WND.START_X},
        }
        destinationWindowWithTimer(skin, BASE_WINDOW.ID, BASE_WINDOW.EDGE_SIZE, BASE_WINDOW.SHADOW_LEN, {}, 10008, -1, dst)

        -- attensionアイコン
        table.insert(skin.destination, {
            id = "attensionIcon", timer = 10008, loop = -1, dst = {
                {time = 0, x = NEW_VERSION_MSG.WND.START_X + NEW_VERSION_MSG.ICON.X, y = NEW_VERSION_MSG.WND.Y + NEW_VERSION_MSG.ICON.Y, w = ATTENSION_SIZE, h = ATTENSION_SIZE, acc = 2},
                {time = 2000},
                {time = 2300, x = NEW_VERSION_MSG.WND.X + NEW_VERSION_MSG.ICON.X},
                {time = 6300},
                {time = 6600, x = NEW_VERSION_MSG.WND.START_X + NEW_VERSION_MSG.ICON.X},
            }
        })

        -- 文字
        table.insert(skin.destination, {
            id = "newVersion", timer = 10008, loop = -1, dst = {
                {time = 0, x = NEW_VERSION_MSG.WND.START_X + NEW_VERSION_MSG.TEXT.X, y = NEW_VERSION_MSG.WND.Y + NEW_VERSION_MSG.TEXT.Y, w = 310, h = 24, r = 0, g = 0, b = 0, acc = 2},
                {time = 2000},
                {time = 2300, x = NEW_VERSION_MSG.WND.X + NEW_VERSION_MSG.TEXT.X},
                {time = 6300},
                {time = 6600, x = NEW_VERSION_MSG.WND.START_X + NEW_VERSION_MSG.TEXT.X},
            }
        })

    end

    -- 選曲画面突入時アニメーション
    if getTableValue(skin_config.option, "開幕アニメーション種類", 930) == 931 then
        opening.drawMeteor(skin)
    end
    if getTableValue(skin_config.option, "開幕アニメーション種類", 930) == 932 then
        opening.drawTile(skin)
    end

    return skin
end

return {
    header = header,
    main = main
}