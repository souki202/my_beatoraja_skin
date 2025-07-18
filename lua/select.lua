require("modules.commons.define")
require("modules.commons.http")
require("modules.commons.my_window")
require("modules.commons.numbers")
require("modules.commons.position")
local commons = require("modules.select.commons")
local background = require("modules.select.background")
local help = require("modules.select.help")
local statistics = require("modules.select.statistics")
local volumes = require("modules.select.volumes")
local opening = require("modules.select.opening")
local user = require("modules.select.user")
local stagefile = require("modules.select.stagefile")
local course = require("modules.select.course")
local upperOption = require("modules.select.upper_option")
local playButtons = require("modules.select.play_buttons")
local songlist = require("modules.select.songlist")
local densityGraph = require("modules.select.density_graph")
local searchBox = require("modules.select.search_box")
local menu = require("modules.select.menu")
local clock = require("modules.select.clock")
local ir = require("modules.select.ir")
local musicInfo = require("modules.select.music_info")
local musicDetail = require("modules.commons.music_detail")

local difficultyEstimates = require("modules.commons.difficulty_estimates")

local main_state = require("main_state")

local existNewVersion = false

local PARTS_TEXTURE_SIZE = 2048

-- スクロールバー
local MUSIC_SLIDER_H = 768
local MUSIC_SLIDER_BUTTON_W = 22
local MUSIC_SLIDER_BUTTON_H = 48

local JUDGE_NAME_TABLE = {"Perfect", "Great", "Good", "Bad", "Poor"}

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
    TEXT_H = 24,
    TEXT_SMALL_H = 20,
    BUTTON_W = 130,
    BUTTON_H = 52,
    NUMBER_BUTTON_SIZE = 56,
    SWITCH_BUTTON_W = 302,
    SWITCH_BUTTON_H = 56,
    HEADER2_EDGE_BG_W = 16,
    HEADER2_EDGE_BG_H = 42,
    HEADER2_TEXT_SRC_X = 3827,
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

local header = {
    type = 5,
    name = "Social Skin" .. (DEBUG and " dev" or ""),
    w = WIDTH,
    h = HEIGHT,
    fadeout = 500,
    scene = 3000,
    input = commons.INPUT_WAIT,
    -- 使用済み 990まで
    property = {
        {
            name = "背景形式", item = {{name = "画像(png)", op = 915}, {name = "動画(mp4)", op = 916}}, def = "画像(png)"
        },
        {
            name = "スライドショー", item = {{name = "無効", op = 960}, {name = "ファイル名順", op = 961}, {name = "ランダム順", op = 962}}, def = "無効"
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
            name = "Favoriteボタンの種類", item = {{name = "Song", op = 990}, {name = "Chart", op = 991}}, def="Song",
        },
        {
            name = "ステージファイルの影", item = {{name = "ON", op = 945}, {name = "OFF", op = 946}}, def = "OFF"
        },
        {
            name = "選曲バー移動時のステージファイルの暗転", item = {{name = "ON", op = 975}, {name = "OFF", 976}}, def = "ON"
        },
        {
            name = "バナー表示", item = {{name = "ON", op = 955}, {name = "OFF", op = 956}}, def = "ON"
        },
        {
            name = "曲情報表示形式", item = {{name = "難易度リスト", op = 935}, {name = "密度", op = 936}}, def = "密度"
        },
        {
            name = "選曲バーの太さ", item = {{name = "太い", op = 965}, {name = "細い", op = 966}}, def = "細い"
        },
        {
            name = "EXSCORE下の表示種類", item = {{name = "次のランク", op = 980}, {name = "スコアレート", op = 981}}, def = "スコアレート"
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
            name = "IR部分のデフォルトのアクティブタブ", item = {{name = "IR統計", op = 970}, {name = "ランキング", op = 971}}, def = "IR統計"
        },
        {
            name = "新バージョン確認", item = {{name = "する", op = 998}, {name = "しない", op = 999}}, def = "する",
        },
        {
            name = "楽曲データベースの使用", item = {{name = "ON", op = 985}, {name = "OFF", op = 986}}, def = "ON"
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
        {name = "ステージファイルフレーム", path = "../select/parts/stagefileframe/*.png", def = "simple"},
        {name = "ステージファイルマスク", path = "../select/parts/stagefilemask/*.png", def = "default"},
        {name = "曲リストバーの画像(太い)", path = "../select/parts/songlist/thick/*.png", def = "default"},
        {name = "曲リストバーの画像(細い)", path = "../select/parts/songlist/thin/*.png", def = "default"},
        {name = "曲リストバーの背景", path = "../select/parts/songlist/bg/*.png", def = "default"},
    },
    offset = {
        {name = "各種数値設定項目群----------------", x = 0},
        {name = "全体の透明度(255で透明)", a = 0},
        {name = "バナー座標オフセット", x = 0, y = 0, id = 41},
        {name = "影2の座標と濃さ差分", x = 0, y = 0, a = 0, id = 40},
        {name = "ステージファイルの暗転の黒マスクの透明度(255で透明 既定値128)", a = 0},
        {name = "ステージファイルの暗転のフェードアウト開始までの時間(100ms 既定値2)", x = 0},
        {name = "ステージファイルの暗転のフェードアウト終了までの時間(100ms 既定値3)", x = 0},
        {name = "選曲バー-------------------------", x = 0},
        {name = "選曲バー全体の透明度(255で透明)", a = 0},
        {name = "選曲バーフレームの透明度(255で透明)", a = 0},
        {name = "選択中の曲のフレームの透明度(255で透明)", a = 0},
        {name = "選曲バー背景の透明度(255で透明)", a = 0},
        {name = "背景, スライドショー設定(0で既定値)---------------------", x = 0},
        {name = "表示時間 (単位 秒 既定値15)", x = 0},
        {name = "フェード時間 (単位 100ms 既定値5)", x = 0},
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
        {name = "FOV (既定値90 -1で平行投影 0<x<180 or x=-1)", x = 0},
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

local function insertOptionAnimationTextTable(skin, id, op, x, y, width, height, angle, r, g, b)
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
            {time = OPTION_INFO.ANIMATION_TIME - 1, x = BASE_WIDTH / 2, y = BASE_HEIGHT / 2, a = 0},
            {time = OPTION_INFO.ANIMATION_TIME}
        }
    })
    -- 出現時
    table.insert(skin.destination, {
        id = id, op = {op}, timer = op, loop = OPTION_INFO.ANIMATION_TIME,
        dst = {
            {time = 0, x = BASE_WIDTH / 2, y = BASE_HEIGHT / 2, w = width, h = height, angle = angle, r = r, g = g, b = b, a = 0},
            {time = OPTION_INFO.ANIMATION_TIME - 1, x = x, y = y, a = 255},
            {time = OPTION_INFO.ANIMATION_TIME, x = 0, y = 0, a = 0},
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
    if optionIdPrefix == "paceMaker" then
        local centerX = baseX + optionBoxOffsetX + OPTION_INFO.ITEM_W / 2;
        local textOffsetY = 7
        local intervalY = OPTION_INFO.TEXT_H + 5
        for i = 1, 3, 1 do
            insertOptionAnimationTextTable(skin, "forwardRival" .. i, op, centerX, baseY + optionItemOffsetY + textOffsetY + OPTION_INFO.ITEM_H * 2 + 6 + intervalY * (i), OPTION_INFO.ITEM_W, OPTION_INFO.TEXT_SMALL_H, 0, 0, 0, 0)
            insertOptionAnimationTextTable(skin, "backwardRival" .. i, op, centerX, baseY + optionItemOffsetY + textOffsetY + intervalY * (3 - i), OPTION_INFO.ITEM_W, OPTION_INFO.TEXT_SMALL_H, 0, 0, 0, 0)
        end
        insertOptionAnimationTable(skin, "activeOptionFrame", op, baseX + optionBoxOffsetX, baseY + optionItemOffsetY + OPTION_INFO.ITEM_H * 2 + 2, OPTION_INFO.ACTIVE_FRAME_W, OPTION_INFO.ACTIVE_FRAME_H, 0)
        insertOptionAnimationTextTable(skin, "activeRival", op, centerX, baseY + optionItemOffsetY + textOffsetY + OPTION_INFO.ITEM_H * 2, OPTION_INFO.ITEM_W, OPTION_INFO.TEXT_H, 0, 255, 255, 255)
    else
        insertOptionAnimationTable(skin, optionIdPrefix .. "Nonactive", op, baseX + optionBoxOffsetX, baseY + optionItemOffsetY                             , OPTION_INFO.ITEM_W        , OPTION_INFO.ITEM_H * viewRange, 0)
        insertOptionAnimationTable(skin, "activeOptionFrame"          , op, baseX + optionBoxOffsetX, baseY + optionItemOffsetY + OPTION_INFO.ITEM_H * 2 + 2, OPTION_INFO.ACTIVE_FRAME_W, OPTION_INFO.ACTIVE_FRAME_H, 0)
        insertOptionAnimationTable(skin, optionIdPrefix .. "Active"   , op, baseX + optionBoxOffsetX, baseY + optionItemOffsetY + OPTION_INFO.ITEM_H * 2    , OPTION_INFO.ITEM_W        , OPTION_INFO.ITEM_H, 0)
    end

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
        local isNews = skinVersionCheck({SKIN_INFO.SELECT_VRESION, SKIN_INFO.RESULT_VERSION, SKIN_INFO.DECIDE_VERSION, SKIN_INFO.PLAY_VERSION, SKIN_INFO.RESULT2_VERSION})
        existNewVersion = false
        for i = 1, #isNews do
            existNewVersion = existNewVersion or isNews[i]
        end
        userData.updateNextVersionCheckDate()
        -- 難易度推定更新
        difficultyEstimates.updateEstimates()
    end
    difficultyEstimates.loadCache()

    skin.source = {
        {id = 1, path = "../select/background/*.png"},
        {id = 101, path = "../select/background/*.mp4"},
        {id = 0, path = "../select/parts/parts.png"},
        {id = 8, path = "../select/parts/parts2.png"},
        {id = 2, path = "../select/parts/option.png"},
        {id = 3, path = "../select/parts/help.png"},
        {id = 4, path = "../select/parts/stagefileframe/*.png"},
        {id = 5, path = "../select/parts/meteor.png"},
        {id = 6, path = "../select/parts/lamp_gauge_rainbow.png"},
        {id = 7, path = "../select/noimage/*.png"},
        {id = 12, path = "../select/parts/ir/default.png"},
        {id = 10, path = "../select/parts/songlist/thick/*.png"},
        {id = 11, path = "../select/parts/songlist/thin/*.png"},
        {id = 13, path = "../select/parts/songlist/bg/*.png"},
        {id = 20, path = "../select/parts/stagefilemask/*.png"},
        {id = 999, path = "../common/colors/colors.png"}
    }

    -- 10000, 10001はタイマ周り
    table.insert(skin.customTimers, {id = 10003, timer = "updateStamina"})
    table.insert(skin.customTimers, {id = 10006, timer = "updateStaminaGauge"}) -- スタミナゲージ表示用タイマー
    table.insert(skin.customTimers, {id = 10008, timer = "newVersionAnimation"}) -- 新バージョンがある時の文字表示用
    table.insert(skin.customTimers, {id = 10009, timer = "helpTimer"}) -- ヘルプ画面全体のタイマー
    table.insert(skin.customTimers, {id = 12000, timer = "keyInput"})
    for i = 1, 490 do
        table.insert(skin.customTimers, {id = 10010 + (i - 1)}) -- 10010~10499までヘルプ用で予約 増えるかもしれないので500くらい余裕見ておく
    end
    table.insert(skin.customTimers, {id = statistics.getWindowTimerId(), timer = "statisticsTimer"}) -- 統計画面全体のタイマー
    table.insert(skin.customTimers, {id = volumes.getWindowTimerId(), timer = "volumesTimer"}) -- 音量設定画面全体のタイマー
    if isUseMusicDb() then
        table.insert(skin.customTimers, {id = musicDetail.getHttpTimer(), timer = function () musicDetail.fetchMusicDetail() end})
    end
    table.insert(skin.customTimers, {id = 13000, timer = "update"})
    -- 13100はmenu
    -- 13200はestimate

    skin.customEvents = {} -- 1000~未定はヘルプ

    skin.image = {
        {id = "baseFrame", src = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT},
        -- 楽曲のkeys
        {id = "music7keys" , src = 0, x = commons.NUM_28PX.SRC_X + commons.NUM_28PX.W*0, y = commons.PARTS_OFFSET + 105, w = commons.NUM_28PX.W*2, h = commons.NUM_28PX.H},
        {id = "music5keys" , src = 0, x = commons.NUM_28PX.SRC_X + commons.NUM_28PX.W*2, y = commons.PARTS_OFFSET + 105, w = commons.NUM_28PX.W*2, h = commons.NUM_28PX.H},
        {id = "music14keys", src = 0, x = commons.NUM_28PX.SRC_X + commons.NUM_28PX.W*4, y = commons.PARTS_OFFSET + 105, w = commons.NUM_28PX.W*2, h = commons.NUM_28PX.H},
        {id = "music10keys", src = 0, x = commons.NUM_28PX.SRC_X + commons.NUM_28PX.W*6, y = commons.PARTS_OFFSET + 105, w = commons.NUM_28PX.W*2, h = commons.NUM_28PX.H},
        {id = "music9keys" , src = 0, x = commons.NUM_28PX.SRC_X + commons.NUM_28PX.W*0, y = commons.PARTS_OFFSET + 105 + commons.NUM_28PX.H, w = commons.NUM_28PX.W*2, h = commons.NUM_28PX.H},
        {id = "music24keys", src = 0, x = commons.NUM_28PX.SRC_X + commons.NUM_28PX.W*2, y = commons.PARTS_OFFSET + 105 + commons.NUM_28PX.H, w = commons.NUM_28PX.W*2, h = commons.NUM_28PX.H},
        {id = "music48keys", src = 0, x = commons.NUM_28PX.SRC_X + commons.NUM_28PX.W*4, y = commons.PARTS_OFFSET + 105 + commons.NUM_28PX.H, w = commons.NUM_28PX.W*2, h = commons.NUM_28PX.H},

        -- 空プア表記用スラッシュ
        {id = "slashForEmptyPoor", src = 0, x = commons.NUM_28PX.SRC_X + commons.NUM_28PX.W * 11, y = commons.NUM_28PX.SRC_Y, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H},
        -- BPM用チルダ
        {id = "bpmTilda", src = 0, x = commons.NUM_28PX.SRC_X, y = commons.PARTS_OFFSET + 68, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H},
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

        -- 注目アイコン
        {id = "attensionIcon", src = 0, x = 1846, y = commons.PARTS_OFFSET + 874, w = ATTENSION_SIZE, h = ATTENSION_SIZE},

        -- ヘルプウィンドウ周り
        -- {id = "helpHeaderBgLeft", src = 0, x = 1591, y = },

        -- 汎用カラー
        {id = "blank", src = 999, x = 0, y = 0, w = 1, h = 1, act = 0},
        {id = "black", src = 999, x = 1, y = 0, w = 1, h = 1, act = 0},
        {id = "white", src = 999, x = 2, y = 0, w = 1, h = 1},
        {id = "purpleRed", src = 999, x = 3, y = 0, w = 1, h = 1},
        {id = "gray", src = 999, x = 4, y = 0, w = 1, h = 1},
        {id = "gray2", src = 999, x = 4, y = 1, w = 1, h = 1},
        {id = "pink", src = 999, x = 5, y = 0, w = 1, h = 1},
    }

    skin.font = {
		{id = 0, path = "../common/fonts/SourceHanSans-Regular.otf"},
		-- {id = 0, path = "../common/fonts/font_1_kokumr_1.00_rls.ttf"},
	}

    skin.text = {
        {id = "newVersion" , font = 0, size = 24, align = 0, overflow = 1, constantText = "スキンに更新があります"},
        {id = "helpText", font = 0, size = 30, align = 0, constantText = "ヘルプ    ※マウスで操作し, スクロールはドラッグで操作してください."},
        {id = "24:", font = 0, size = 24, align = 0, constantText = ":"},
        {id = "countText", font = 0, size = 24, align = 2, constantText = "回"},
    }

    -- オプション画面等のポップアップウィンドウ共通パーツ読み込み
    -- オプションはrefactorしたいけどtimerの都合上リファクタリングはしんどい
    loadBaseSelect(skin)

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

    -- 選曲スライダー
    skin.slider = {
        {id = "musicSelectSlider", src = 0, x = 1541, y = commons.PARTS_OFFSET + 263, w = MUSIC_SLIDER_BUTTON_W, h = MUSIC_SLIDER_BUTTON_H, type = 1, range = 768 - MUSIC_SLIDER_BUTTON_H / 2 - 3, angle = 2, align = 0},
    }

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
    -- PaceMaker 旧仕様
    optionTexts = {
        "next", "max", "aaa+", "aaa", "aaa-", "aa+", "aa", "aa-", "a+", "a", "a-"
    }
    loadOptionImgs(skin, optionTexts, "paceMaker", 77, 2048, 0)
    -- PaceMaker文字
    -- ライバル枠
    table.insert(skin.text, {id = "activeRival", font = 0, size = OPTION_INFO.TEXT_H, ref = 3, align = 1})
    for i = 1, 10, 1 do
        table.insert(skin.text, {id = "forwardRival" .. i, font = 0, size = OPTION_INFO.TEXT_SMALL_H, ref = 210 - i, align = 1})
        table.insert(skin.text, {id = "backwardRival" .. i, font = 0, size = OPTION_INFO.TEXT_SMALL_H, ref = 209 + i, align = 1})
    end

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
        -- オプション
        {id = "notesDisplayTime", src = 2, x = 1111, y = PARTS_TEXTURE_SIZE - OPTION_INFO.NUMBER_H, w = OPTION_INFO.NUMBER_W * 10, h = OPTION_INFO.NUMBER_H, divx = 10, digit = 4, ref = 312},
        {id = "judgeTiming", src = 2, x = 1111, y = PARTS_TEXTURE_SIZE - OPTION_INFO.NUMBER_H * 2, w = OPTION_INFO.NUMBER_W * 12, h = OPTION_INFO.NUMBER_H * 2, divx = 12, divy = 2, digit = 4, ref = 12},
    }

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
                x = commons.NUM_28PX.SRC_X, y = commons.NUM_28PX.SRC_Y,
                w = commons.NUM_28PX.W*10, h = commons.NUM_28PX.H,
                divx = 10, digit = digit, ref = useNormalNumberTexts[val], align = 0
        })
        if val == "numOfPoor" then
            table.insert(skin.value, {
                    id = "numOfEmptyPoor", src = 0,
                    x = commons.NUM_28PX.SRC_X, y = commons.NUM_28PX.SRC_Y,
                    w = commons.NUM_28PX.W*10, h = commons.NUM_28PX.H,
                    divx = 10, digit = digit, ref = useNormalNumberTexts["numOfEmptyPoor"], align = 0
            })
        end
    end

    -- オープニングの読み込み
    opening.load(skin)
    -- ユーザ情報出力周り
    user.load(skin)
    -- ヘルプの読み込み
    help.loadHelpItem(skin)
    -- 統計の読み込み
    statistics.load(skin)

    -- stagefile, コース
    mergeSkin(skin, background.load())
    mergeSkin(skin, stagefile.load())
    mergeSkin(skin, course.load())
    mergeSkin(skin, course.load())
    mergeSkin(skin, upperOption.load())
    mergeSkin(skin, playButtons.load())
    mergeSkin(skin, songlist.load())
    mergeSkin(skin, densityGraph.load())
    mergeSkin(skin, searchBox.load())
    mergeSkin(skin, menu.load())
    mergeSkin(skin, clock.load())
    mergeSkin(skin, ir.load())
    mergeSkin(skin, musicInfo.load())
    mergeSkin(skin, volumes.load())
    mergeSkin(skin, musicDetail.loadSelect())

    skin.destination = {}

    mergeSkin(skin, background.dst())

    table.insert(skin.destination, {
        id = "baseFrame",
        dst = {
            {x = 0, y = 0, w = WIDTH, h = HEIGHT}
        }
    })

    -- 各種出力
    mergeSkin(skin, clock.dst())
    mergeSkin(skin, stagefile.dst())
    mergeSkin(skin, course.dst())
    mergeSkin(skin, upperOption.dst())
    mergeSkin(skin, playButtons.dst())
    mergeSkin(skin, songlist.dst())
    mergeSkin(skin, densityGraph.dst())
    mergeSkin(skin, searchBox.dst())
    mergeSkin(skin, musicInfo.dst())
    mergeSkin(skin, musicDetail.dst())

    -- バナー表示
    if isShowBanner() then
        table.insert(skin.destination, {
            id = -102, offset = 41, dst = {
                {x = 807, y = 784, w = 300, h = 80, filter = 1}
            }
        })
    end

    -- ユーザ情報出力周り
    user.dst(skin)
    mergeSkin(skin, ir.dst())

    -- 選曲スライダー
    table.insert(skin.destination, {
        id = "musicSelectSlider", dst = {
            {x = 1892, y = 153 + 768 + 6 - MUSIC_SLIDER_BUTTON_H, w = MUSIC_SLIDER_BUTTON_W, h = MUSIC_SLIDER_BUTTON_H}
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
            local numberX = baseX + SCORE_INFO.NUMBER_OFFSET_X - commons.NUM_28PX.W * 8
            if val == "numOfPoor" then
                numberX = numberX - commons.NUM_28PX.W * 5
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
                        w = commons.NUM_28PX.W, h = commons.NUM_28PX.H
                    }
                }
            })
            table.insert(skin.destination, {
                id = val, op = {3}, dst = {
                    {
                        x = numberX,
                        y = baseY,
                        w = commons.NUM_28PX.W, h = commons.NUM_28PX.H
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
                            w = commons.NUM_28PX.W, h = commons.NUM_28PX.H
                        }
                    }
                })
            end
            -- 空プア
            if val == "numOfPoor" then
                table.insert(skin.destination, {
                    id = "slashForEmptyPoor", dst = {
                        {
                            x = numberX + commons.NUM_28PX.W*8,
                            y = baseY,
                            w = commons.NUM_28PX.W, h = commons.NUM_28PX.H
                        }
                    }
                })
                table.insert(skin.destination, {
                    id = "numOfEmptyPoor", dst = {
                        {
                            x = numberX + commons.NUM_28PX.W + commons.NUM_28PX.W*4,
                            y = baseY,
                            w = commons.NUM_28PX.W, h = commons.NUM_28PX.H
                        }
                    }
                })
            end
        end
    end

    -- ボタン
    -- help.destinationOpenButton(skin)
    -- statistics.destinationOpenButton(skin)
    mergeSkin(skin, menu.dst())
    -- ヘルプウィンドウ
    help.setWindowDestination(skin)
    help.setListDestination(skin)
    help.setWindowDestination2(skin)
    help.setDestinationDescription(skin)

    -- 統計ウィンドウ
    statistics.destinationWindow(skin)
    -- ボリューム
    mergeSkin(skin, volumes.dst())

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

    mergeSkin(skin, background.dstWithAlpha(getTableValue(skin_config.offset, "全体の透明度(255で透明)", {a = 0}).a))

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