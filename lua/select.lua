require("define")

local PARTS_TEXTURE_SIZE = 2048

local PARTS_OFFSET = HEIGHT + 32

local ARTIST_FONT_SIZE = 24
local SUBARTIST_FONT_SIZE = 18

local BAR_FONT_SIZE = 32
local LAMP_HEIGHT = 28
local MUSIC_BAR_IMG_HEIGHT = 78
local MUSIC_BAR_IMG_WIDTH = 607
local STAGEFILE_BG_WIDTH = 640
local STAGEFILE_BG_HEIGHT = 480

local NORMAL_NUMBER_SRC_X = 946
local NORMAL_NUMBER_SRC_Y = PARTS_OFFSET
local NORMAL_NUMBER_W = 15
local NORMAL_NUMBER_H = 21
local STATUS_NUMBER_W = 18
local STATUS_NUMBER_H = 23
local RANK_NUMBER_W = 18
local RANK_NUMBER_H = 24

-- 決定ボタン周り
local DECIDE_BUTTON_W = 354
local DECIDE_BUTTON_H = 78
local AUTO_BUTTON_W = 110
local AUTO_BUTTON_H = 62
local REPLAY_BUTTON_SIZE = 62
local REPLAY_TEXT_W = 17
local REPLAY_TEXT_H = 22

-- 上部のLNモードとkeysのボタンサイズ
local UPPER_OPTION_W = 270
local UPPER_OPTION_H = 56

-- 上部のユーザ情報的な部分の各種
local RANK_IMG_W = 106
local RANK_IMG_H = 46
local EXP_GAUGE_FRAME_W = 222
local EXP_GAUGE_FRAME_H = 48
local EXP_GAUGE_W = 196
local EXP_GAUGE_H = 24
local COIN_W = 46
local COIN_H = 46
local DIA_W = 54
local DIA_H = 47

-- スクロールバー
local MUSIC_SLIDER_H = 768
local MUSIC_SLIDER_BUTTON_W = 22
local MUSIC_SLIDER_BUTTON_H = 48

-- 左下のレベルが並んでいる部分
local LARGE_LEVEL_HEIGHT = 40
local LARGE_LEVEL_X = 140
local LARGE_LEVEL_Y = 275
local LARGE_LEVEL_INTERVAL = 136
local LEVEL_ICON_WIDTH = 105
local LEVEL_ICON_INTERVAL = LARGE_LEVEL_INTERVAL
local LEVEL_ICON_SRC_X = 1128
local NONACTIVE_LEVEL_ICON_H = 82
local ACTIVE_LEVEL_ICON_H = 75
local ACTIVE_LEVEL_TEXT_H = 31
local LEVEL_ICON_Y = 318

local LEVEL_NAME_TABLE = {"Beginner", "Normal", "Hyper", "Another", "Insane"}
local JUDGE_NAME_TABLE = {"Perfect", "Great", "Good", "Bad", "Poor"}

-- スコア詳細
local PLAY_STATUS_TEXT_SRC_X = 1127
local PLAY_STATUS_TEXT_SRC_Y = PARTS_OFFSET + 263
local PLAY_STATUS_TEXT_W = 168
local PLAY_STATUS_TEXT_H = 22
local PLAY_STATUS_TEXT_BASE_X = 95
local PLAY_STATUS_TEXT_BASE_Y = 200
local PLAY_STATUS_INTERVAL_X = 347
local PLAY_STATUS_INTERVAL_Y = 29
local PLAY_STATUS_NUMBER_BASE_X = PLAY_STATUS_TEXT_BASE_X + 290
local PLAY_STATUS_NUMBER_BASE_Y = PLAY_STATUS_TEXT_BASE_Y
local PLAY_STATUS_DIGIT = 8

local RANK_SRC_X = 1653
local RANK_W = 133
local RANK_H = 59
local RANK_X = 895
local RANK_Y = 400

local EXSCORE_NUMBER_W = 22
local EXSCORE_NUMBER_H = 30

local OPTION_HEADER_H = 42
local OPTION_HEADER_TEXT_W = 269
local OPTION_WND_EDGE_SIZE = 32
local OPTION_WND_W = 1600
local OPTION_WND_H = 900
local ACTIVE_OPTION_FRAME_W = 360
local ACTIVE_OPTION_FRAME_H = 40
local OPTION_ITEM_W = ACTIVE_OPTION_FRAME_W
local OPTION_ITEM_H = 44
local OPTION_BUTTON_W = 130
local OPTION_BUTTON_H = 52
local OPTION_NUMBER_BUTTON_SIZE = 56
local OPTION_SWITCH_BUTTON_W = 302
local OPTION_SWITCH_BUTTON_H = 56
local OPTION_HEADER2_EDGE_BG_W = 16
local OPTION_HEADER2_EDGE_BG_H = 42
local OPTION_HEADER2_TEXT_SRC_X = 1709
local OPTION_HEADER2_TEXT_W = 300
local OPTION_HEADER2_TEXT_H = 42
local OPTION_BG_H = 132
local OPTION_NUMBER_BG_W = 240
local OPTION_NUMBER_BG_H = 46
local OPTION_NUMBER_W = 16
local OPTION_NUMBER_H = 22
local SMALL_KEY_W = 20
local SMALL_KEY_H = 24
local HELP_WND_W = 672
local HELP_WND_H = 474
local HELP_ICON_SIZE = 56
local HELP_TEXT_H = 368
local HELP_TEXT1_W = 380
local HELP_TEXT2_W = 530
local OPTION_WND_OFFSET_X = (WIDTH - OPTION_WND_W) / 2
local OPTION_WND_OFFSET_Y = (HEIGHT - OPTION_WND_H) / 2

local header = {
    type = 5,
    name = "Flat skin",
    w = WIDTH,
    h = HEIGHT,
    fadeout = 500,
    scene = 3000,
    input = 500,
    filepath = {
        {name = "Background", path = "../select/background/*.png"}
    },
}

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local function loadOptionImgs(skin, optionTexts, optionIdPrefix, ref, x, y)
    local optionActiveTextSuffix = optionIdPrefix .. "OptionImgActive"
    local optionNonactiveTextSuffix = optionIdPrefix .. "OptionImgNonactive"
    local activeImages = {}
    local nonactiveImages = {}
    for i, val in ipairs(optionTexts) do
        table.insert(skin.image, {
            id = val .. optionActiveTextSuffix, src = 2, x = x + OPTION_ITEM_W, y = y + OPTION_ITEM_H * i,
            w = OPTION_ITEM_W, h = OPTION_ITEM_H
        })
        table.insert(skin.image, {
            id = val .. optionNonactiveTextSuffix, src = 2, x = x, y = y + OPTION_ITEM_H * (i - 1),
            w = OPTION_ITEM_W, h = OPTION_ITEM_H * 3
        })
        table.insert(activeImages, val .. optionActiveTextSuffix)
        table.insert(nonactiveImages, val .. optionNonactiveTextSuffix)
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
    table.insert(skin.destination, {
        id = "optionHeader2LeftBg", op = {op}, dst = {
            {x = baseX, y = baseY, w = OPTION_HEADER2_EDGE_BG_W, h = OPTION_HEADER2_EDGE_BG_H}
        }
    })
    table.insert(skin.destination, {
        id = "optionHeader2RightBg", op = {op}, dst = {
            {x = baseX + width - OPTION_HEADER2_EDGE_BG_W, y = baseY, w = OPTION_HEADER2_EDGE_BG_W, h = OPTION_HEADER2_EDGE_BG_H}
        }
    })
    table.insert(skin.destination, {
        id = "gray", op = {op}, dst = {
            {x = baseX + OPTION_HEADER2_EDGE_BG_W, y = baseY, w = width - OPTION_HEADER2_EDGE_BG_W * 2, h = OPTION_HEADER2_EDGE_BG_H}
        }
    })

    -- オプションヘッダテキスト出力
    table.insert(skin.destination, {
        id = titleTextId, op = {op}, dst = {
            {x = baseX + 20, y = baseY, w = OPTION_HEADER2_TEXT_W, h = OPTION_HEADER2_TEXT_H}
        }
    })

    -- オプションの使用キー出力
    for i = 1, 7 do
        if not has_value(activeKeys, i) then
            local y = baseY + 3
            if i % 2 == 0 then -- 上のキーは座標足す
                y = y + SMALL_KEY_H - 6 * 2
            end
            table.insert(skin.destination, {
                id = "optionSmallKeyNonActive", op = {op}, dst = {
                    {x = baseX + width - keyOffset - (8 - i) * (SMALL_KEY_W - 12) + 6 - 20, y = y, w = SMALL_KEY_W, h = SMALL_KEY_H}
                }
            })
        end
    end
    for i = 1, 7 do
        if has_value(activeKeys, i) then
            local y = baseY + 3
            if i % 2 == 0 then -- 上のキーは座標足す
                y = y + SMALL_KEY_H - 6 * 2
            end
            table.insert(skin.destination, {
                id = "optionSmallKeyActive", op = {op}, dst = {
                    {x = baseX + width - keyOffset - (8 - i) * (SMALL_KEY_W - 12) + 6 - 20, y = y, w = SMALL_KEY_W, h = SMALL_KEY_H}
                }
            })
        end
    end
end

--- baseX: 右端X, baseY: 下へボタンの最下部(影含む), activeKeys: オプション変更に使用するキー(配列)
local function destinationPlayOption(skin, baseX, baseY, titleTextId, optionIdPrefix, isLarge, activeKeys, op)
    local width = 640
    local headerOffset = 258
    if isLarge == false then
        width = 480
    end
    local optionBoxOffsetX = (width - OPTION_ITEM_W) / 2
    local optionButtonOffsetX = (width - OPTION_BUTTON_W) / 2
    local optionItemOffsetY = 100

    -- ヘッダ出力
    destinationOptionHeader2(skin, baseX, baseY + headerOffset, width, titleTextId, activeKeys, op)

    -- オプション一覧背景
    table.insert(skin.destination, {
        id = "optionSelectBg", op = {op}, dst = {
            {x = baseX + optionBoxOffsetX, y = baseY + optionItemOffsetY - OPTION_ITEM_H, w = OPTION_ITEM_W, h = OPTION_BG_H}
        }
    })

    -- オプション出力
    table.insert(skin.destination, {
        id = optionIdPrefix .. "Nonactive", op = {op}, dst = {
            {x = baseX + optionBoxOffsetX, y = baseY + optionItemOffsetY - 2 - OPTION_ITEM_H, w = OPTION_ITEM_W, h = OPTION_ITEM_H * 3}
        }
    })
    table.insert(skin.destination, {
        id = "activeOptionFrame", op = {op}, dst = {
            {x = baseX + optionBoxOffsetX, y = baseY + optionItemOffsetY, w = ACTIVE_OPTION_FRAME_W, h = ACTIVE_OPTION_FRAME_H}
        }
    })
    table.insert(skin.destination, {
        id = optionIdPrefix .. "Active", op = {op}, dst = {
            {x = baseX + optionBoxOffsetX, y = baseY + optionItemOffsetY - 2, w = OPTION_ITEM_W, h = OPTION_ITEM_H}
        }
    })

    -- ボタン出力
    table.insert(skin.destination, {
        id = optionIdPrefix .. "UpButton", op = {op}, dst = {
            {x = baseX + optionButtonOffsetX, y = baseY + 192, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H}
        }
    })
    -- 下
    table.insert(skin.destination, {
        id = optionIdPrefix .. "DownButton", op = {op}, dst = {
            {x = baseX + optionButtonOffsetX, y = baseY, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H}
        }
    })
end

local function destinationNumberOption(skin, baseX, baseY, titleTextId, optionIdPrefix, isLarge, activeKeys, op)
    local width = 640
    local height = 113
    local digit = 4
    if isLarge == false then
        width = 480
    end
    local optionBoxOffsetX = (width - OPTION_NUMBER_BG_W) / 2
    local optionButtonOffsetX = (width - OPTION_BUTTON_W) / 2
    local optionOffsetY = 5

    -- ヘッダ出力
    destinationOptionHeader2(skin, baseX, baseY + height - OPTION_HEADER_H, width, titleTextId, activeKeys, op)

    -- オプション背景
    table.insert(skin.destination, {
        id = "optionNumberBg", op = {op}, dst = {
            {x = baseX + optionBoxOffsetX, y = baseY + optionOffsetY, w = OPTION_NUMBER_BG_W, h = OPTION_NUMBER_BG_H}
        }
    })

    -- 数値出力
    table.insert(skin.destination, {
        id = optionIdPrefix, op = {op}, dst = {
            {
                x = baseX + width / 2 - OPTION_NUMBER_W * (digit - 0.5) - 4,
                y = baseY + optionOffsetY + 12,
                w = OPTION_NUMBER_W, h = OPTION_NUMBER_H
            }
        }
    })

    -- ms出力
    table.insert(skin.destination, {
        id = "millisecondTextImg", op = {op}, dst = {
            {
                x = baseX + width / 2 + 6,
                y = baseY + optionOffsetY + 12,
                w = 39, h = OPTION_NUMBER_H
            }
        }
    })

    -- ボタン出力
    -- beatorajaの現バージョンは未実装
    table.insert(skin.destination, {
        id = optionIdPrefix .. "DownButton", op = {op}, dst = {
            {
                x = baseX + width / 2 - 186,
                y = baseY,
                w = OPTION_NUMBER_BUTTON_SIZE, h = OPTION_NUMBER_BUTTON_SIZE
            }
        }
    })
    table.insert(skin.destination, {
        id = optionIdPrefix .. "UpButton", op = {op}, dst = {
            {
                x = baseX + width / 2 + 186 - OPTION_NUMBER_BUTTON_SIZE,
                y = baseY,
                w = OPTION_NUMBER_BUTTON_SIZE, h = OPTION_NUMBER_BUTTON_SIZE
            }
        }
    })
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

    skin.source = {
        {id = 0, path = "../select/parts/parts.png"},
        {id = 1, path = "../select/background/*.png"},
        {id = 2, path = "../select/parts/option.png"},
        {id = 3, path = "../select/parts/help.png"},
        {id = 4, path = "../select/parts/stagefile_frame.png"},
        {id = 999, path = "../common/colors/colors.png"}
    }

    skin.image = {
        {id = "background", src = 1, x = 0, y = 0, w = WIDTH, h = HEIGHT},
        {id = "baseFrame", src = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT},
        {id = "stagefileFrame", src = 4, x = 0, y = 0, w = 702, h = 542},
        -- 選曲バー種類
        {id = "barSong"   , src = 0, x = 0, y = PARTS_OFFSET, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barNosong" , src = 0, x = 0, y = PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*1, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barGrade"  , src = 0, x = 0, y = PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*2, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barNograde", src = 0, x = 0, y = PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*2, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barFolder" , src = 0, x = 0, y = PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*3, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barTable"  , src = 0, x = 0, y = PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*4, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barCommand", src = 0, x = 0, y = PARTS_OFFSET + MUSIC_BAR_IMG_HEIGHT*5, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        {id = "barSearch" , src = 0, x = 0, y = PARTS_OFFSET, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT},
        -- 選曲バークリアランプ
        {id = "barLampMax", src = 0, x = 656, y = PARTS_OFFSET + LAMP_HEIGHT*0, w = 110, h = LAMP_HEIGHT},
        {id = "barLampPerfect", src = 0, x = 656, y = PARTS_OFFSET + LAMP_HEIGHT*1, w = 110, h = LAMP_HEIGHT},
        {id = "barLampFc", src = 0, x = 656, y = PARTS_OFFSET + LAMP_HEIGHT*2, w = 110, h = LAMP_HEIGHT},
        {id = "barLampExhard", src = 0, x = 656, y = PARTS_OFFSET + LAMP_HEIGHT*3, w = 110, h = LAMP_HEIGHT},
        {id = "barLampHard", src = 0, x = 656, y = PARTS_OFFSET + LAMP_HEIGHT*4, w = 110, h = LAMP_HEIGHT},
        {id = "barLampNormal", src = 0, x = 656, y = PARTS_OFFSET + LAMP_HEIGHT*5, w = 110, h = LAMP_HEIGHT},
        {id = "barLampEasy", src = 0, x = 656, y = PARTS_OFFSET + LAMP_HEIGHT*6, w = 110, h = LAMP_HEIGHT},
        {id = "barLampLassist", src = 0, x = 656, y = PARTS_OFFSET + LAMP_HEIGHT*7, w = 110, h = LAMP_HEIGHT},
        {id = "barLampAssist", src = 0, x = 656, y = PARTS_OFFSET + LAMP_HEIGHT*8, w = 110, h = LAMP_HEIGHT},
        {id = "barLampFailed", src = 0, x = 656, y = PARTS_OFFSET + LAMP_HEIGHT*9, w = 110, h = LAMP_HEIGHT},
        {id = "barLampNoplay", src = 0, x = 656, y = PARTS_OFFSET + LAMP_HEIGHT*10, w = 110, h = LAMP_HEIGHT},
        -- 選曲バー中央
        {id = "barCenterFrame", src = 0, x = 0, y = PARTS_OFFSET + 782, w = 714, h = 154},
        -- 選曲バーLN表示
        {id = "barLn", src = 0, x = 607, y = PARTS_OFFSET, w = 30, h = 22},
        -- プレイ
        {id = "playButton", src = 0, x = 773, y = PARTS_OFFSET + 377, w = DECIDE_BUTTON_W, h = DECIDE_BUTTON_H},
        {id = "playButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 15}, -- ボタン起動用ダミー
        {id = "autoButton", src = 0, x = 773, y = PARTS_OFFSET + 377 + DECIDE_BUTTON_H, w = AUTO_BUTTON_W, h = AUTO_BUTTON_H},
        {id = "autoButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 16}, -- ボタン起動用ダミー
        {id = "replayButtonBg", src = 0, x = 773 + AUTO_BUTTON_W, y = PARTS_OFFSET + 377 + DECIDE_BUTTON_H, w = REPLAY_BUTTON_SIZE, h = REPLAY_BUTTON_SIZE},
        {id = "replay1Text", src = 0, x = 773 + AUTO_BUTTON_W + REPLAY_BUTTON_SIZE + REPLAY_TEXT_W*0, y = PARTS_OFFSET + 377 + DECIDE_BUTTON_H, w = REPLAY_TEXT_W, h = REPLAY_TEXT_H},
        {id = "replay2Text", src = 0, x = 773 + AUTO_BUTTON_W + REPLAY_BUTTON_SIZE + REPLAY_TEXT_W*1, y = PARTS_OFFSET + 377 + DECIDE_BUTTON_H, w = REPLAY_TEXT_W, h = REPLAY_TEXT_H},
        {id = "replay3Text", src = 0, x = 773 + AUTO_BUTTON_W + REPLAY_BUTTON_SIZE + REPLAY_TEXT_W*2, y = PARTS_OFFSET + 377 + DECIDE_BUTTON_H, w = REPLAY_TEXT_W, h = REPLAY_TEXT_H},
        {id = "replay4Text", src = 0, x = 773 + AUTO_BUTTON_W + REPLAY_BUTTON_SIZE + REPLAY_TEXT_W*3, y = PARTS_OFFSET + 377 + DECIDE_BUTTON_H, w = REPLAY_TEXT_W, h = REPLAY_TEXT_H},
        {id = "replay1ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 19}, -- ボタン起動用ダミー
        {id = "replay2ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 316}, -- ボタン起動用ダミー
        {id = "replay3ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 317}, -- ボタン起動用ダミー
        {id = "replay4ButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = 318}, -- ボタン起動用ダミー

        -- レベルアイコン
        {id = "nonActiveBeginnerIcon", src = 0, x = LEVEL_ICON_SRC_X, y = PARTS_OFFSET, w = LEVEL_ICON_WIDTH, h = NONACTIVE_LEVEL_ICON_H},
        {id = "nonActiveNormalIcon"  , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*1, y = PARTS_OFFSET, w = LEVEL_ICON_WIDTH, h = NONACTIVE_LEVEL_ICON_H},
        {id = "nonActiveHyperIcon"   , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*2, y = PARTS_OFFSET, w = LEVEL_ICON_WIDTH, h = NONACTIVE_LEVEL_ICON_H},
        {id = "nonActiveAnotherIcon" , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*3, y = PARTS_OFFSET, w = LEVEL_ICON_WIDTH, h = NONACTIVE_LEVEL_ICON_H},
        {id = "nonActiveInsaneIcon"  , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*4, y = PARTS_OFFSET, w = LEVEL_ICON_WIDTH, h = NONACTIVE_LEVEL_ICON_H},
        {id = "activeBeginnerIcon"   , src = 0, x = LEVEL_ICON_SRC_X, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
        {id = "activeNormalIcon"     , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*1, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
        {id = "activeHyperIcon"      , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*2, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
        {id = "activeAnotherIcon"    , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*3, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
        {id = "activeInsaneIcon"     , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*4, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
        {id = "activeBeginnerText"   , src = 0, x = LEVEL_ICON_SRC_X, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_ICON_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_TEXT_H},
        {id = "activeNormalText"     , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*1, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_ICON_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_TEXT_H},
        {id = "activeHyperText"      , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*2, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_ICON_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_TEXT_H},
        {id = "activeAnotherText"    , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*3, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_ICON_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_TEXT_H},
        {id = "activeInsaneText"     , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*4, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_ICON_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_TEXT_H},
        {id = "activeBeginnerNote"   , src = 0, x = LEVEL_ICON_SRC_X, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_TEXT_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
        {id = "activeNormalNote"     , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*1, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_TEXT_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
        {id = "activeHyperNote"      , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*2, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_TEXT_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
        {id = "activeAnotherNote"    , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*3, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_TEXT_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
        {id = "activeInsaneNote"     , src = 0, x = LEVEL_ICON_SRC_X + LEVEL_ICON_WIDTH*4, y = PARTS_OFFSET + NONACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_ICON_H + ACTIVE_LEVEL_TEXT_H, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
        -- 楽曲のkeys
        {id = "music7keys" , src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*0, y = PARTS_OFFSET + 105, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        {id = "music5keys" , src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*2, y = PARTS_OFFSET + 105, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        {id = "music14keys", src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*4, y = PARTS_OFFSET + 105, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        {id = "music10keys", src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*6, y = PARTS_OFFSET + 105, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        {id = "music9keys" , src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*0, y = PARTS_OFFSET + 105 + NORMAL_NUMBER_H, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        {id = "music24keys", src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*2, y = PARTS_OFFSET + 105 + NORMAL_NUMBER_H, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        {id = "music48keys", src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W*4, y = PARTS_OFFSET + 105 + NORMAL_NUMBER_H, w = NORMAL_NUMBER_W*2, h = NORMAL_NUMBER_H},
        -- オプションのkeys
        {id = "upperOptionButtonBg" , src = 2, x = 1321, y = PARTS_TEXTURE_SIZE - UPPER_OPTION_H, w = UPPER_OPTION_W, h = UPPER_OPTION_H},
        {id = "keysSet", src = 2, x = 1441, y = 836, w = 129, h = OPTION_ITEM_H * 8, divy = 8, len = 8, ref = 11, act = 11},
        -- オプションのLNモード
        {id = "lnModeSet" , src = 2, x = 1570, y = 836, w = 129, h = OPTION_ITEM_H * 3, divy = 3, len = 3, ref = 308, act = 308},
        -- ソート
        {id = "sortModeSet" , src = 2, x = 1699, y = 836, w = 258, h = OPTION_ITEM_H * 8, divy = 8, len = 8, ref = 12, act = 12},

        -- 空プア表記用スラッシュ
        {id = "slashForEmptyPoor", src = 0, x = NORMAL_NUMBER_SRC_X + NORMAL_NUMBER_W * 11, y = NORMAL_NUMBER_SRC_Y, w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H},
        -- 上部プレイヤー情報 expゲージの背景とゲージ本体は汎用カラー
        {id = "rankTextImg", src = 0, x = 1298, y = PARTS_OFFSET + 267, w = RANK_IMG_W, h = RANK_IMG_H},
        {id = "coin", src = 0, x = 1298 + 108, y = PARTS_OFFSET + 266, w = COIN_W, h = COIN_H},
        {id = "dia", src = 0, x = 1298 + 108 + 47, y = PARTS_OFFSET + 264, w = DIA_W, h = DIA_H},
        {id = "expGaugeFrame", src = 0, x = 1298, y = PARTS_OFFSET + 313, w = EXP_GAUGE_FRAME_W, h = EXP_GAUGE_FRAME_H},
        -- BPM用チルダ
        {id = "bpmTilda", src = 0, x = NORMAL_NUMBER_SRC_X, y = PARTS_OFFSET + 68, w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H},
        -- 判定難易度
        {id = "judgeEasy", src = 0, x = 1298, y = PARTS_OFFSET + 361, w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H},
        {id = "judgeNormal", src = 0, x = 1298, y = PARTS_OFFSET + 361 + PLAY_STATUS_TEXT_H * 1, w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H},
        {id = "judgeHard", src = 0, x = 1298, y = PARTS_OFFSET + 361 + PLAY_STATUS_TEXT_H * 2, w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H},
        {id = "judgeVeryhard", src = 0, x = 1298, y = PARTS_OFFSET + 361 + PLAY_STATUS_TEXT_H * 3, w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H},
        -- アクティブなオブション用背景
        {id = "activeOptionFrame", src = 2, x = 0, y = PARTS_TEXTURE_SIZE - ACTIVE_OPTION_FRAME_H, w = ACTIVE_OPTION_FRAME_W, h = ACTIVE_OPTION_FRAME_H},
        -- オプション画面の端
        {id = "optionWndEdge", src = 2, x = 360, y = PARTS_TEXTURE_SIZE - OPTION_WND_EDGE_SIZE, w = OPTION_WND_EDGE_SIZE, h = OPTION_WND_EDGE_SIZE},
        -- オプションのヘッダ
        {id = "optionHeaderLeft", src = 2, x = 392, y = PARTS_TEXTURE_SIZE - OPTION_HEADER_H, w = 16, h = OPTION_HEADER_H},
        -- オプションのヘッダテキスト
        {id = "optionHeaderPlayOption", src = 2, x = 1441, y = 0, w = OPTION_HEADER_TEXT_W, h = OPTION_HEADER_H},
        {id = "optionHeaderAssistOption", src = 2, x = 1441, y = OPTION_HEADER_H, w = OPTION_HEADER_TEXT_W, h = OPTION_HEADER_H},
        {id = "optionHeaderOtherOption", src = 2, x = 1441, y = OPTION_HEADER_H * 2, w = OPTION_HEADER_TEXT_W, h = OPTION_HEADER_H},
        -- オプション用キー
        {id = "optionSmallKeyActive", src = 2, x = 673, y = PARTS_TEXTURE_SIZE - SMALL_KEY_H * 2, w = SMALL_KEY_W, h = SMALL_KEY_H},
        {id = "optionSmallKeyNonActive", src = 2, x = 673, y = PARTS_TEXTURE_SIZE - SMALL_KEY_H, w = SMALL_KEY_W, h = SMALL_KEY_H},
        -- 各オプション選択部分背景
        {id = "optionSelectBg", src = 2, x = 0, y = 1834, w = OPTION_ITEM_W, h = OPTION_BG_H},
        {id = "optionNumberBg", src = 2, x = 0, y = 1788, w = OPTION_NUMBER_BG_W, h = OPTION_NUMBER_BG_H},
        -- 各オプションヘッダBG
        {id = "optionHeader2LeftBg", src = 2, x = 0, y = 1966, w = OPTION_HEADER2_EDGE_BG_W, h = OPTION_HEADER2_EDGE_BG_H},
        {id = "optionHeader2RightBg", src = 2, x = OPTION_HEADER2_EDGE_BG_W, y = 1966, w = OPTION_HEADER2_EDGE_BG_W, h = OPTION_HEADER2_EDGE_BG_H},
        -- 各オプションヘッダテキスト
        {id = "optionHeader2NotesOrder1", src = 2, x = OPTION_HEADER2_TEXT_SRC_X, y = 0, w = OPTION_HEADER2_TEXT_W, h = OPTION_HEADER2_TEXT_H},
        {id = "optionHeader2NotesOrder2", src = 2, x = OPTION_HEADER2_TEXT_SRC_X, y = OPTION_HEADER2_TEXT_H * 1, w = OPTION_HEADER2_TEXT_W, h = OPTION_HEADER2_TEXT_H},
        {id = "optionHeader2GaugeType", src = 2, x = OPTION_HEADER2_TEXT_SRC_X, y = OPTION_HEADER2_TEXT_H * 2, w = OPTION_HEADER2_TEXT_W, h = OPTION_HEADER2_TEXT_H},
        {id = "optionHeader2DpOption", src = 2, x = OPTION_HEADER2_TEXT_SRC_X, y = OPTION_HEADER2_TEXT_H * 3, w = OPTION_HEADER2_TEXT_W, h = OPTION_HEADER2_TEXT_H},
        {id = "optionHeader2FixedHiSpeed", src = 2, x = OPTION_HEADER2_TEXT_SRC_X, y = OPTION_HEADER2_TEXT_H * 4, w = OPTION_HEADER2_TEXT_W, h = OPTION_HEADER2_TEXT_H},
        {id = "optionHeader2GaugeAutoShift", src = 2, x = OPTION_HEADER2_TEXT_SRC_X, y = OPTION_HEADER2_TEXT_H * 5, w = OPTION_HEADER2_TEXT_W, h = OPTION_HEADER2_TEXT_H},
        {id = "optionHeader2BgaShow", src = 2, x = OPTION_HEADER2_TEXT_SRC_X, y = OPTION_HEADER2_TEXT_H * 6, w = OPTION_HEADER2_TEXT_W, h = OPTION_HEADER2_TEXT_H},
        {id = "optionHeader2NotesDisplayTime", src = 2, x = OPTION_HEADER2_TEXT_SRC_X, y = OPTION_HEADER2_TEXT_H * 7, w = OPTION_HEADER2_TEXT_W, h = OPTION_HEADER2_TEXT_H},
        {id = "optionHeader2JudgeTiming", src = 2, x = OPTION_HEADER2_TEXT_SRC_X, y = OPTION_HEADER2_TEXT_H * 8, w = OPTION_HEADER2_TEXT_W, h = OPTION_HEADER2_TEXT_H},
        -- オプション用ボタン
        {id = "notesOrder1UpButton", src = 2, x = 408, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 42, click = 1},
        {id = "notesOrder1DownButton", src = 2, x = 408 + OPTION_BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 42},
        {id = "notesOrder2UpButton", src = 2, x = 408, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 43, click = 1},
        {id = "notesOrder2DownButton", src = 2, x = 408 + OPTION_BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 43},
        {id = "gaugeTypeUpButton", src = 2, x = 408, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 40, click = 1},
        {id = "gaugeTypeDownButton", src = 2, x = 408 + OPTION_BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 40},
        {id = "dpTypeUpButton", src = 2, x = 408, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 54, click = 1},
        {id = "dpTypeDownButton", src = 2, x = 408 + OPTION_BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 54},
        {id = "hiSpeedTypeUpButton", src = 2, x = 408, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 55, click = 1},
        {id = "hiSpeedTypeDownButton", src = 2, x = 408 + OPTION_BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 55},
        {id = "gaugeAutoShiftUpButton", src = 2, x = 408, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 78, click = 1},
        {id = "gaugeAutoShiftDownButton", src = 2, x = 408 + OPTION_BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 78},
        {id = "bgaShowUpButton", src = 2, x = 408, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 72, click = 1},
        {id = "bgaShowDownButton", src = 2, x = 408 + OPTION_BUTTON_W, y = PARTS_TEXTURE_SIZE - OPTION_BUTTON_H * 2, w = OPTION_BUTTON_W, h = OPTION_BUTTON_H * 2, divy = 2, act = 72},
        {
            id = "notesDisplayTimeUpButton", src = 2,
            x = 998 + OPTION_NUMBER_BUTTON_SIZE,
            y = PARTS_TEXTURE_SIZE - OPTION_NUMBER_BUTTON_SIZE * 2,
            w = OPTION_NUMBER_BUTTON_SIZE, h = OPTION_NUMBER_BUTTON_SIZE * 2,
            divy = 2, act = 0},
        {
            id = "notesDisplayTimeDownButton", src = 2,
            x = 998,
            y = PARTS_TEXTURE_SIZE - OPTION_NUMBER_BUTTON_SIZE * 2,
            w = OPTION_NUMBER_BUTTON_SIZE, h = OPTION_NUMBER_BUTTON_SIZE * 2,
            divy = 2, act = 0, click = 1},
        {
            id = "judgeTimingUpButton", src = 2,
            x = 998 + OPTION_NUMBER_BUTTON_SIZE,
            y = PARTS_TEXTURE_SIZE - OPTION_NUMBER_BUTTON_SIZE * 2,
            w = OPTION_NUMBER_BUTTON_SIZE, h = OPTION_NUMBER_BUTTON_SIZE * 2,
            divy = 2, act = 0
        },
        {
            id = "judgeTimingDownButton", src = 2,
            x = 998,
            y = PARTS_TEXTURE_SIZE - OPTION_NUMBER_BUTTON_SIZE * 2,
            w = OPTION_NUMBER_BUTTON_SIZE, h = OPTION_NUMBER_BUTTON_SIZE * 2,
            divy = 2, act = 0, click = 1
        },
        -- その他オプション用
        {id = "millisecondTextImg", src = 2, x = 1111, y = PARTS_TEXTURE_SIZE - OPTION_NUMBER_H * 3, w = 39, h = OPTION_NUMBER_H},
        -- ON/OFFオプション用ボタン(アシストは後のforで処理)

        -- ヘルプヘッダ
        {id = "helpIcon", src = 3, x = 0, y = PARTS_TEXTURE_SIZE / 2 - HELP_ICON_SIZE, w = HELP_ICON_SIZE, h = HELP_ICON_SIZE},
        {id = "helpHeaderText", src = 3, x = 0, y = 0, w = 122, h = 30},
        -- ヘルプ内容
        {id = "helpNumberKeys", src = 3, x = 0, y = 30, w = HELP_TEXT1_W, h = HELP_TEXT_H},
        {id = "helpFunctionKeys", src = 3, x = 0, y = 398, w = HELP_TEXT1_W, h = HELP_TEXT_H},
        {id = "helpPlayKey", src = 3, x = 397, y = 30, w = HELP_TEXT2_W, h = HELP_TEXT_H},
        {id = "helpDetailReplayKey", src = 3, x = 397, y = 398, w = HELP_TEXT2_W, h = 248},

        -- 汎用カラー
        {id = "blank", src = 999, x = 0, y = 0, w = 1, h = 1, act = 0},
        {id = "black", src = 999, x = 1, y = 0, w = 1, h = 1, act = 0},
        {id = "white", src = 999, x = 2, y = 0, w = 1, h = 1},
        {id = "purpleRed", src = 999, x = 3, y = 0, w = 1, h = 1},
        {id = "gray", src = 999, x = 4, y = 0, w = 1, h = 1},
    }

    skin.slider = {
        -- 選曲スライダー
        {id = "musicSelectSlider", src = 0, x = 1541, y = PARTS_OFFSET + 263, w = MUSIC_SLIDER_BUTTON_W, h = MUSIC_SLIDER_BUTTON_H, type = 1, range = 768 - MUSIC_SLIDER_BUTTON_H / 2 - 3, angle = 2, align = 0},
    }

    skin.imageset = {
        {
            id = "bar", images = {
                "barSong",
                "barFolder",
                "barTable",
                "barGrade",
                "barNosong",
                "barNograde",
                "barCommand",
                "barSearch",
            }
        },
    }

    -- ランク
    -- local ranks = {"Max", "Aaa", "Aa", "a", "b", "c", "d", "e", "f"}
    local ranks = {"Aaa", "Aa", "A", "B", "C", "D", "E", "F"}
    for i, rank in ipairs(ranks) do
        table.insert(skin.image, {
            id = "rank" .. rank, src = 0,
            x = RANK_SRC_X, y = PARTS_OFFSET + RANK_H * i,
            w = RANK_W, h = RANK_H
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
    loadOptionImgs(skin, optionTexts, "gaugeType", 40, OPTION_ITEM_W * 2, 0)
    -- DPオプション
    optionTexts = {
        "off", "flip", "battle", "battleAs"
    }
    loadOptionImgs(skin, optionTexts, "dpType", 54, OPTION_ITEM_W * 2, OPTION_ITEM_H * 12)
    -- ハイスピード固定
    optionTexts = {
        "off", "startBpm", "maxBpm", "mainBpm", "minBpm"
    }
    loadOptionImgs(skin, optionTexts, "hiSpeedType", 55, 0, OPTION_ITEM_H * 12)

    -- GAS
    optionTexts = {
        "none", "continue", "hardToGroove", "bestClear", "selectToUnder"
    }
    loadOptionImgs(skin, optionTexts, "gaugeAutoShift", 78, 0, OPTION_ITEM_H * 12 * 2)
    -- BGA
    optionTexts = {
        "on", "auto", "off"
    }
    loadOptionImgs(skin, optionTexts, "bgaShow", 72, OPTION_ITEM_W * 2, OPTION_ITEM_H * 12 * 2)

    -- アシストオプション
    local assistTexts = {
        "expandJudge", "constant", "judgeArea", "legacyNote", "markNote", "bpmGuide", "noMine"
    }
    for i, assistText in ipairs(assistTexts) do
        -- assist名
        table.insert(skin.image, {
            id = assistText .. "TextImg", src = 2,
            x = OPTION_ITEM_W * 4, y = OPTION_HEADER_H * (3 + i),
            w = OPTION_HEADER_TEXT_W, h = OPTION_HEADER_H
        })
        -- 説明
        table.insert(skin.image, {
            id = assistText .. "DescriptionTextImg", src = 2,
            x = OPTION_ITEM_W * 4, y = OPTION_HEADER_H * (3 + 7 + i),
            w = OPTION_HEADER_TEXT_W * 2, h = OPTION_HEADER_H
        })
        -- ON/OFF
        table.insert(skin.image, {
            id = assistText .. "ButtonOff", src = 2,
            x = 696, y = PARTS_TEXTURE_SIZE - OPTION_SWITCH_BUTTON_H * 2,
            w = OPTION_SWITCH_BUTTON_W, h = OPTION_SWITCH_BUTTON_H,
        })
        table.insert(skin.image, {
            id = assistText .. "ButtonOn", src = 2,
            x = 696, y = PARTS_TEXTURE_SIZE - OPTION_SWITCH_BUTTON_H,
            w = OPTION_SWITCH_BUTTON_W, h = OPTION_SWITCH_BUTTON_H,
        })
        table.insert(skin.imageset, {
            id = assistText .. "ButtonImgset", ref = 300 + i, act = 300 + i,
            images = {assistText .. "ButtonOff", assistText .. "ButtonOn"}
        })
    end

    skin.value = {
        -- 選曲バー難易度数値
        {id = "barPlayLevelUnknown", src = 0, x = 771, y = PARTS_OFFSET, w = 16*10, h = 32, divx = 10, digit = 2, align = 2},
        {id = "barPlayLevelBeginner", src = 0, x = 771, y = PARTS_OFFSET + 21*1, w = 16*10, h = 21, divx = 10, digit = 2, align = 2},
        {id = "barPlayLevelNormal", src = 0, x = 771, y = PARTS_OFFSET + 21*2, w = 16*10, h = 21, divx = 10, digit = 2, align = 2},
        {id = "barPlayLevelHyper", src = 0, x = 771, y = PARTS_OFFSET + 21*3, w = 16*10, h = 21, divx = 10, digit = 2, align = 2},
        {id = "barPlayLevelAnother", src = 0, x = 771, y = PARTS_OFFSET + 21*4, w = 16*10, h = 21, divx = 10, digit = 2, align = 2},
        {id = "barPlayLevelInsane", src = 0, x = 771, y = PARTS_OFFSET + 21*5, w = 16*10, h = 21, divx = 10, digit = 2, align = 2},
        {id = "barPlayLevelUnknown2", src = 0, x = 771, y = PARTS_OFFSET + 21*6, w = 16*10, h = 21, divx = 10, digit = 2, align = 2},
        -- 左側の難易度表記数字
        {id = "largeLevelBeginner", src = 0, x = 771, y = PARTS_OFFSET + 147, w = 30*10, h = LARGE_LEVEL_HEIGHT, divx = 10, digit = 2, ref = 45, align = 2},
        {id = "largeLevelNormal", src = 0, x = 771, y = PARTS_OFFSET + 147 + LARGE_LEVEL_HEIGHT * 1, w = 30*10, h = LARGE_LEVEL_HEIGHT, divx = 10, digit = 2, ref = 46, align = 2},
        {id = "largeLevelHyper", src = 0, x = 771, y = PARTS_OFFSET + 147 + LARGE_LEVEL_HEIGHT * 2, w = 30*10, h = LARGE_LEVEL_HEIGHT, divx = 10, digit = 2, ref = 47, align = 2},
        {id = "largeLevelAnother", src = 0, x = 771, y = PARTS_OFFSET + 147 + LARGE_LEVEL_HEIGHT * 3, w = 30*10, h = LARGE_LEVEL_HEIGHT, divx = 10, digit = 2, ref = 48, align = 2},
        {id = "largeLevelInsane", src = 0, x = 771, y = PARTS_OFFSET + 147 + LARGE_LEVEL_HEIGHT * 4, w = 30*10, h = LARGE_LEVEL_HEIGHT, divx = 10, digit = 2, ref = 49, align = 2},
        -- exscore用
        {id = "richExScore", src = 0, x = 771, y = PARTS_OFFSET + 347, w = EXSCORE_NUMBER_W * 10, h = EXSCORE_NUMBER_H, divx = 10, digit = 4, ref = 71, align = 0},
        -- 上部プレイヤー情報
        {id = "numOfCoin", src = 0, x = NORMAL_NUMBER_SRC_X, y = PARTS_OFFSET + NORMAL_NUMBER_H, w = STATUS_NUMBER_W * 10, h = STATUS_NUMBER_H, divx = 10, digit = 8, ref = 33, align = 0},
        {id = "numOfDia", src = 0, x = NORMAL_NUMBER_SRC_X, y = PARTS_OFFSET + NORMAL_NUMBER_H, w = STATUS_NUMBER_W * 10, h = STATUS_NUMBER_H, divx = 10, digit = 8, ref = 30, align = 0},
        {id = "rankValue", src = 0, x = NORMAL_NUMBER_SRC_X, y = PARTS_OFFSET + NORMAL_NUMBER_H + STATUS_NUMBER_H, w = RANK_NUMBER_W * 10, h = RANK_NUMBER_H, divx = 10, digit = 4, ref = 17, align = 0},
        {id = "expGauge", src = 0, x = PARTS_TEXTURE_SIZE - 10, y = PARTS_OFFSET, w = 10, h = 10, divy = 10, digit = 1,  ref = 31, align = 1},
        -- オプション
        {id = "notesDisplayTime", src = 2, x = 1111, y = PARTS_TEXTURE_SIZE - OPTION_NUMBER_H, w = OPTION_NUMBER_W * 10, h = OPTION_NUMBER_H, divx = 10, digit = 4, ref = 312},
        {id = "judgeTiming", src = 2, x = 1111, y = PARTS_TEXTURE_SIZE - OPTION_NUMBER_H * 2, w = OPTION_NUMBER_W * 12, h = OPTION_NUMBER_H * 2, divx = 12, divy = 2, digit = 4, ref = 12},
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
        maxCombo = 75, totalNotes = 74, missCount = 427, playCount = 77, clearCount = 78,
        bpm = 90, bpmMax = 90, bpmMin = 91,
        numOfPerfectFolder = 33, numOfGreatFolder = 34, numOfGoodFolder = 35, numOfBadFolder = 36, numOfPoorFolder = 37,
        playCountFolder = 30, clearCountFolder = 31
    }

    for i, val in ipairs(commonStatusTexts) do
        local digit = PLAY_STATUS_DIGIT
        if val == "bpm" or val == "bpmMax" or val == "bpmMin" then
            digit = 3
        end
        table.insert(skin.image, {
                id = val .. "TextImg", src = 0,
                x = PLAY_STATUS_TEXT_SRC_X, y = PLAY_STATUS_TEXT_SRC_Y + PLAY_STATUS_TEXT_H * (i - 1),
                w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H
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
		{id = 0, path = "../common/fonts/SourceHanSans.fnt"},
	}

    skin.text = {
        {id = "dir", font = 0, size = 24, ref = 1000},
		{id = "genre", font = 0, size = 24, ref = 13},
        {id = "title", font = 0, size = 24, ref = 12},
		{id = "artist", font = 0, size = ARTIST_FONT_SIZE, ref = 14, align = 2, overflow = 1},
        {id = "subArtist", font = 0, size = SUBARTIST_FONT_SIZE, ref = 15, align = 2, overflow = 1},
		{id = "course1", font = 0, size = 24, ref = 150},
		{id = "course2", font = 0, size = 24, ref = 151},
		{id = "course3", font = 0, size = 24, ref = 152},
		{id = "course4", font = 0, size = 24, ref = 153},

		{id = "bartext", font = 0, size = BAR_FONT_SIZE, align = 2, overflow = 1},
        {id = "search", font = 0, size = 24, ref = 30},
    }

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
            idx = idx + 0.77 -- BPM等を入れる部分の高さだけ下にずらす
        end
        local posX = math.floor(1184 + (skin.songlist.center - idx + 2) * 12)
        local posY = math.floor(492 + (skin.songlist.center - idx + 2) * 80)
        table.insert(skin.songlist.listoff, {
            id = "bar",
            dst = {
                {x = posX, y = posY, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT}
            }
        })
        table.insert(skin.songlist.liston, {
            id = "bar",
            dst = {
                {x = posX, y = posY, w = MUSIC_BAR_IMG_WIDTH, h = MUSIC_BAR_IMG_HEIGHT}
            }
        })
    end

    skin.songlist.label = {
        {
            id = "barLn", dst = {
                {x = 78, y = 11, w = 30, h = 22}
            }
        }
    }

    -- 曲名等
    skin.songlist.text = {
        {
            id = "bartext", filter = 1,
            dst = {
                {x = 570, y = 30 - 9, w = 397, h = BAR_FONT_SIZE, r = 0, g = 0, b = 0, filter = 1}
            }
        },
        {
            id = "bartext", filter = 1,
            dst = {
                {x = 570, y = 30 - 9, w = 397, h = BAR_FONT_SIZE, r = 200, g = 0, b = 0, filter = 1}
            }
        },
    }
    
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
    local lampPosY = 40;
    skin.songlist.lamp = {
        {
            id = "barLampNoplay", dst = {
                {x = lampPosX, y = lampPosY, w = 110, h = LAMP_HEIGHT}
            }
        },
        {
            id = "barLampFailed", dst = {
                {x = lampPosX, y = lampPosY, w = 110, h = LAMP_HEIGHT}
            }
        },
        {
            id = "barLampAssist", dst = {
                {x = lampPosX, y = lampPosY, w = 110, h = LAMP_HEIGHT}
            }
        },
        {
            id = "barLampLassist", dst = {
                {x = lampPosX, y = lampPosY, w = 110, h = LAMP_HEIGHT}
            }
        },
        {
            id = "barLampEasy", dst = {
                {x = lampPosX, y = lampPosY, w = 110, h = LAMP_HEIGHT}
            }
        },
        {
            id = "barLampNormal", dst = {
                {x = lampPosX, y = lampPosY, w = 110, h = LAMP_HEIGHT}
            }
        },
        {
            id = "barLampHard", dst = {
                {x = lampPosX, y = lampPosY, w = 110, h = LAMP_HEIGHT}
            }
        },
        {
            id = "barLampExhard", dst = {
                {x = lampPosX, y = lampPosY, w = 110, h = LAMP_HEIGHT}
            }
        },
        {
            id = "barLampFc", dst = {
                {x = lampPosX, y = lampPosY, w = 110, h = LAMP_HEIGHT}
            }
        },
        {
            id = "barLampPerfect", dst = {
                {x = lampPosX, y = lampPosY, w = 110, h = LAMP_HEIGHT}
            }
        },
        {
            id = "barLampMax", dst = {
                {x = lampPosX, y = lampPosY, w = 110, h = LAMP_HEIGHT}
            }
        },
    }

    skin.destination = {
        -- 背景
        {
            id = "background",
            dst = {
                {x = 0, y = 0, w = WIDTH, h = HEIGHT}
            }
        },
        -- ステージファイル背景
        {
            id = "black", op = {191}, dst = {
                {x = 105, y = 446, w = STAGEFILE_BG_WIDTH, h = STAGEFILE_BG_HEIGHT, a = 255}
            }
        },
        -- noステージファイル背景
        {
            id = "black", op = {190}, dst = {
                {x = 105, y = 446, w = STAGEFILE_BG_WIDTH, h = STAGEFILE_BG_HEIGHT, a = 64}
            }
        },
        -- ステージファイル
        {
            id = -100, dst = {
                {x = 105, y = 446, w = STAGEFILE_BG_WIDTH, h = STAGEFILE_BG_HEIGHT}
            }
        },
        -- バナー
        {
            id = -102, dst = {
                {x = 800, y = 784, w = 300, h = 80, filter = 1}
            }
        },
        -- フレーム
        {
            id = "baseFrame",
            dst = {
                {x = 0, y = 0, w = WIDTH, h = HEIGHT}
            }
        },
        -- Stage fileフレーム
        {
            id = "stagefileFrame", dst = {
                {x = 74, y = 415, w = 702, h = 542}
            }
        },

        -- 上部プレイヤー情報
        -- RANK
        {
            id = "rankTextImg", dst = {
                {x = 150, y = 1024, w = RANK_IMG_W, h = RANK_IMG_H}
            }
        },
        {
            id = "black", dst = {
                {x = 163, y = 990, w = EXP_GAUGE_W, h = EXP_GAUGE_H, a = 64}
            }
        },
        -- 経験値ゲージ
        {
            id = "expGauge", dst = {
                {x = 163, y = 990, w = EXP_GAUGE_W, h = EXP_GAUGE_H}
            }
        },
        -- 経験値フレーム
        {
            id = "expGaugeFrame", dst = {
                {x = 150, y = 978, w = EXP_GAUGE_FRAME_W, h = EXP_GAUGE_FRAME_H}
            }
        },
        -- コイン
        {
            id = "coin", dst = {
                {x = 410, y = 1024, w = COIN_W, h = COIN_H}
            }
        },
        -- ダイヤ
        {
            id = "dia", dst = {
                {x = 405, y = 980, w = DIA_W, h = DIA_H}
            }
        },
        -- RANK値
        {
            id = "rankValue", dst = {
                {x = 359 - RANK_NUMBER_W * 4, y = 1035, w = RANK_NUMBER_W, h = RANK_NUMBER_H}
            }
        },
        -- コイン数
        {
            id = "numOfCoin", dst = {
                {x = 608 - STATUS_NUMBER_W * 8, y = 1035, w = STATUS_NUMBER_W, h = STATUS_NUMBER_H}
            }
        },
        -- ダイヤ数
        {
            id = "numOfDia", dst = {
                {x = 608 - STATUS_NUMBER_W * 8, y = 994, w = STATUS_NUMBER_W, h = STATUS_NUMBER_H}
            }
        },
        
        -- 上部オプション
        {
            id = "upperOptionButtonBg", dst = {
                {x = 674, y = BASE_HEIGHT - OPTION_SWITCH_BUTTON_H - 1, w = 270, h = OPTION_SWITCH_BUTTON_H}
            }
        },
        -- 上部オプションの上のやつの区切り
        {
            id = "white", dst = {
                {x = 680 + 129, y = BASE_HEIGHT - OPTION_SWITCH_BUTTON_H + 6 - 1, w = 1, h = OPTION_ITEM_H, r = 102, g = 102, b = 102}
            }
        },
        {
            id = "upperOptionButtonBg", dst = {
                {x = 674, y = BASE_HEIGHT - OPTION_SWITCH_BUTTON_H - 54, w = 270, h = OPTION_SWITCH_BUTTON_H}
            }
        },
        -- keys
        {
            id = "keysSet", dst = {
                {x = 680, y = BASE_HEIGHT - OPTION_SWITCH_BUTTON_H + 6 - 1, w = 129, h = OPTION_ITEM_H}
            }
        },
        -- LN
        {
            id = "lnModeSet", dst = {
                {x = 809, y = BASE_HEIGHT - OPTION_SWITCH_BUTTON_H + 6 - 1, w = 129, h = OPTION_ITEM_H}
            }
        },
        -- ソート
        {
            id = "sortModeSet", dst = {
                {x = 680, y = BASE_HEIGHT - OPTION_SWITCH_BUTTON_H - 54 + 6, w = 258, h = OPTION_ITEM_H}
            }
        },

        -- プレイボタン
        {
            id = "playButton", dst = {
                {x = 780, y = 571, w = DECIDE_BUTTON_W, h = DECIDE_BUTTON_H}
            }
        },
        { -- ボタン起動用にサイズを調整したやつ
            id = "playButtonDummy", dst = {
                {x = 786, y = 577, w = DECIDE_BUTTON_W - 12, h = DECIDE_BUTTON_H - 12}
            }
        },
        -- AUTO
        {
            id = "autoButton", dst = {
                {x = 780, y = 513, w = AUTO_BUTTON_W, h = AUTO_BUTTON_H}
            }
        },
        {
            id = "autoButtonDummy", dst = {
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
            id = "artist", dst = {
                {x = 1800, y = 543, w = 370, h = ARTIST_FONT_SIZE, r = 0, g = 0, b = 0, filter = 1}
            }
        },
        {
            id = "subArtist", dst = {
                {x = 1800, y = 516, w = 310, h = SUBARTIST_FONT_SIZE, r = 0, g = 0, b = 0, filter = 1}
            }
        },

        -- BPM
        {
            id = "bpmTextImg", op = {2}, dst = {
                {x = 1207, y = 547, w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H}
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
                {x = 1207, y = 517, w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H}
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
                {x = 1335, y = 517, w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H}
            }
        },
        {
            id = "judgeNormal", op = {182}, dst = {
                {x = 1335, y = 517, w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H}
            }
        },
        {
            id = "judgeHard", op = {181}, dst = {
                {x = 1335, y = 517, w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H}
            }
        },
        {
            id = "judgeVeryhard", op = {180}, dst = {
                {x = 1335, y = 517, w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H}
            }
        },
    }

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


    -- 選曲スライダー
    table.insert(skin.destination, {
        id = "musicSelectSlider", dst = {
            {x = 1892, y = 153 + 768 + 6 - MUSIC_SLIDER_BUTTON_H, w = MUSIC_SLIDER_BUTTON_W, h = MUSIC_SLIDER_BUTTON_H}
        }
    })

    -- レベルアイコン周り
    for i = 1, 5 do
        -- レベル表記
        table.insert(skin.destination, {
            id = "largeLevel" .. LEVEL_NAME_TABLE[i], op = {150 + i}, dst = {
                {x = LARGE_LEVEL_X + LARGE_LEVEL_INTERVAL * (i - 1) - 15, y = LARGE_LEVEL_Y, w = 30, h = 40}
            }
        })

        -- 非アクティブ時のレベルアイコン
        table.insert(skin.destination, {
            id = "nonActive" .. LEVEL_NAME_TABLE[i] .. "Icon", op = {-150 - i}, dst = {
                {x = 102 + LARGE_LEVEL_INTERVAL * (i - 1), y = LEVEL_ICON_Y - (NONACTIVE_LEVEL_ICON_H - ACTIVE_LEVEL_ICON_H), w = LEVEL_ICON_WIDTH, h = NONACTIVE_LEVEL_ICON_H}
            }
        })

        -- アクティブ時のレベルアイコン(背景)
        table.insert(skin.destination, {
            id = "active" .. LEVEL_NAME_TABLE[i] .. "Icon", op = {150 + i}, dst = {
                {x = 102 + LARGE_LEVEL_INTERVAL * (i - 1), y = LEVEL_ICON_Y - 2, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H}
            }
        })

        -- アクティブ時のレベルアイコンのノート
        table.insert(skin.destination, {
            id = "active" .. LEVEL_NAME_TABLE[i] .. "Note", op = {150 + i}, loop = 0, timer = 11, filter = 1, dst = {
                {time = 0, angle = 0, acc = 2, a = 255, x = 102 + LARGE_LEVEL_INTERVAL * (i - 1), y = LEVEL_ICON_Y - 5, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
                {time = 500, angle = -10, acc = 2, a = 255, x = 102 + LARGE_LEVEL_INTERVAL * (i - 1), y = LEVEL_ICON_Y + 10, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
                {time = 501, angle = -10, acc = 2, a = 0},
                {time = 1000, angle = 0, acc = 2, a = 0},
            }
        })
        table.insert(skin.destination, {
            id = "active" .. LEVEL_NAME_TABLE[i] .. "Note", op = {150 + i}, loop = 0, timer = 11, filter = 1, dst = {
                {time = 0, angle = 0, acc = 1, a = 0},
                {time = 500, angle = -10, acc = 1, a = 0},
                {time = 501, angle = -10, acc = 1, a = 255, x = 102 + LARGE_LEVEL_INTERVAL * (i - 1), y = LEVEL_ICON_Y + 10, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
                {time = 1000, angle = 0, acc = 1, a = 255, x = 102 + LARGE_LEVEL_INTERVAL * (i - 1), y = LEVEL_ICON_Y - 5, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_ICON_H},
            }
        })

        -- アクティブ時のレベルアイコンのテキスト
        table.insert(skin.destination,  {
            id = "active" .. LEVEL_NAME_TABLE[i] .. "Text", op = {150 + i}, dst = {
                {x = 102 + LARGE_LEVEL_INTERVAL * (i - 1), y = LEVEL_ICON_Y + 1, w = LEVEL_ICON_WIDTH, h = ACTIVE_LEVEL_TEXT_H}
            }
        })
    end

    -- ランク出力
    for i, rank in ipairs(ranks) do
        table.insert(skin.destination, {
            id = "rank" .. rank, op = {2, 200 + (i - 1)}, dst = {
                {x = RANK_X, y = RANK_Y, w = RANK_W, h = RANK_H}
            }
        })
    end
    -- exscoreとnext
    table.insert(skin.destination, {
        id = "exScoreTextImg", dst = {
            {x = 822, y = 338, w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H}
        }
    })
    table.insert(skin.destination, {
        id = "nextRankTextImg", dst = {
            {x = 822, y = 301, w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H}
        }
    })
    table.insert(skin.destination, {
        id = "richExScore", dst = {
            {x = 1070 - EXSCORE_NUMBER_W * 4, y = 337, w = EXSCORE_NUMBER_W, h = EXSCORE_NUMBER_H}
        }
    })
    table.insert(skin.destination, {
        id = "nextRank", dst = {
            {x = 1070 - NORMAL_NUMBER_W * PLAY_STATUS_DIGIT, y = 301, w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H}
        }
    })

    -- 各種ステータス
    local statusLine = {
        {"numOfPerfect", "numOfGreat", "numOfGood", "numOfBad", "numOfPoor"},
        {"exScore", "hiScore", "maxCombo", "totalNotes", "missCount"},
        {"playCount", "clearCount"}
    }
    for i, arr in ipairs(statusLine) do
        for j, val in ipairs(arr) do
            local numberX = PLAY_STATUS_NUMBER_BASE_X + (i - 1) * PLAY_STATUS_INTERVAL_X - NORMAL_NUMBER_W * 8
            if val == "numOfPoor" then
                numberX = numberX - NORMAL_NUMBER_W * 5
            end

            -- テキスト画像
            table.insert(skin.destination, {
                id = val .. "TextImg", dst = {
                    {
                        x = PLAY_STATUS_TEXT_BASE_X + (i - 1) * PLAY_STATUS_INTERVAL_X,
                        y = PLAY_STATUS_TEXT_BASE_Y - (j - 1) * PLAY_STATUS_INTERVAL_Y,
                        w = PLAY_STATUS_TEXT_W, h = PLAY_STATUS_TEXT_H
                    }
                }
            })
            -- 数値
            -- 曲
            table.insert(skin.destination, {
                id = val, op = {2}, dst = {
                    {
                        x = numberX,
                        y = PLAY_STATUS_NUMBER_BASE_Y - (j - 1) * PLAY_STATUS_INTERVAL_Y,
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
                            y = PLAY_STATUS_NUMBER_BASE_Y - (j - 1) * PLAY_STATUS_INTERVAL_Y,
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
                            x = numberX + 64 + NORMAL_NUMBER_W * 4,
                            y = PLAY_STATUS_NUMBER_BASE_Y - (j - 1) * PLAY_STATUS_INTERVAL_Y,
                            w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H
                        }
                    }
                })
                table.insert(skin.destination, {
                    id = "numOfEmptyPoor", dst = {
                        {
                            x = numberX + NORMAL_NUMBER_W + NORMAL_NUMBER_W*4,
                            y = PLAY_STATUS_NUMBER_BASE_Y - (j - 1) * PLAY_STATUS_INTERVAL_Y,
                            w = NORMAL_NUMBER_W, h = NORMAL_NUMBER_H
                        }
                    }
                })
            end
        end
    end

    -- プレイオプション
    -- 背景部分
    for i = 1, 3 do
        local op = 21 + (i - 1)
        -- 背景
        table.insert(skin.destination, {
            id = "black", op = {op}, dst = {
                {x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 64}
            }
        })
        -- 横長
        table.insert(skin.destination, {
            id = "white", op = {op}, dst = {
                {x = OPTION_WND_OFFSET_X, y = OPTION_WND_OFFSET_Y + OPTION_WND_EDGE_SIZE, w = OPTION_WND_W, h = OPTION_WND_H - OPTION_WND_EDGE_SIZE * 2}
            }
        })
        -- 縦長
        table.insert(skin.destination, {
            id = "white", op = {op}, dst = {
                {x = OPTION_WND_OFFSET_X + OPTION_WND_EDGE_SIZE, y = OPTION_WND_OFFSET_Y, w = OPTION_WND_W - OPTION_WND_EDGE_SIZE * 2, h = OPTION_WND_H}
            }
        })
        -- 四隅
        table.insert(skin.destination, {
            id = "optionWndEdge", op = {op}, dst = {
                {x = OPTION_WND_OFFSET_X, y = OPTION_WND_OFFSET_Y, w = OPTION_WND_EDGE_SIZE, h = OPTION_WND_EDGE_SIZE, angle = 90},
            }
        })
        table.insert(skin.destination, {
            id = "optionWndEdge", op = {op}, dst = {
                {x = OPTION_WND_OFFSET_X + OPTION_WND_W - OPTION_WND_EDGE_SIZE, y = OPTION_WND_OFFSET_Y, w = OPTION_WND_EDGE_SIZE, h = OPTION_WND_EDGE_SIZE, angle = 180},
            }
        })
        table.insert(skin.destination, {
            id = "optionWndEdge", op = {op}, dst = {
                {x = OPTION_WND_OFFSET_X + OPTION_WND_W - OPTION_WND_EDGE_SIZE, y = OPTION_WND_OFFSET_Y + OPTION_WND_H - OPTION_WND_EDGE_SIZE, w = OPTION_WND_EDGE_SIZE, h = OPTION_WND_EDGE_SIZE, angle = 270},
            }
        })
        table.insert(skin.destination, {
            id = "optionWndEdge", op = {op}, dst = {
                {x = OPTION_WND_OFFSET_X, y = OPTION_WND_OFFSET_Y + OPTION_WND_H - OPTION_WND_EDGE_SIZE, w = OPTION_WND_EDGE_SIZE, h = OPTION_WND_EDGE_SIZE, angle = 0}
            }
        })
        -- オプションのヘッダ部分
        table.insert(skin.destination, {
            id = "optionHeaderLeft", op = {op}, dst = {
                {x = 192, y = 932, w = 16, h = OPTION_HEADER_H}
            }
        })
        table.insert(skin.destination, {
            id = "purpleRed", op = {op}, dst = {
                {x = 212, y = 932, w = 1516, h = 2}
            }
        })
    end
    -- オプションのヘッダテキスト
    local optionTypes = {"optionHeaderPlayOption", "optionHeaderAssistOption", "optionHeaderOtherOption"}
    for i, v in ipairs(optionTypes) do
        table.insert(skin.destination, {
            id = v, op = {21 + (i - 1)}, dst = {
                {x = 220, y = 932, w = OPTION_HEADER_TEXT_W, h = OPTION_HEADER_H}
            }
        })
    end

    -- プレイプション
    destinationPlayOption(skin, 192, 607, "optionHeader2NotesOrder1", "notesOrder1", true, {1, 2}, 21)
    destinationPlayOption(skin, 1088, 607, "optionHeader2NotesOrder2", "notesOrder2", true, {6, 7}, 21)
    destinationPlayOption(skin, 192, 205, "optionHeader2GaugeType", "gaugeType", false, {3}, 21)
    destinationPlayOption(skin, 720, 205, "optionHeader2DpOption", "dpType", false, {4}, 21)
    destinationPlayOption(skin, 1248, 205, "optionHeader2FixedHiSpeed", "hiSpeedType", false, {5}, 21)

    -- アシスト
    for i, assistText in ipairs(assistTexts) do
        local baseY = 865 - 109 * (i - 1)
        -- 小さいキーの背景
        table.insert(skin.destination, {
            id = "optionHeader2LeftBg", op = {22}, dst = {
                {x = 192, y = baseY, w = OPTION_HEADER2_EDGE_BG_W, h = OPTION_HEADER2_EDGE_BG_H}
            }
        })
        table.insert(skin.destination, {
            id = "optionHeader2RightBg", op = {22}, dst = {
                {x = 192 + 96 - OPTION_HEADER2_EDGE_BG_W, y = baseY, w = OPTION_HEADER2_EDGE_BG_W, h = OPTION_HEADER2_EDGE_BG_H}
            }
        })
        table.insert(skin.destination, {
            id = "gray", op = {22}, dst = {
                {x = 192 + OPTION_HEADER2_EDGE_BG_W, y = baseY, w = 96 - OPTION_HEADER2_EDGE_BG_W * 2, h = OPTION_HEADER2_EDGE_BG_H}
            }
        })

        -- 小さいキー
        for j = 1, 7 do
            if i ~= j then
                local y = baseY + 3
                if j % 2 == 0 then -- 上のキーは座標足す
                    y = y + SMALL_KEY_H - 6 * 2
                end
                table.insert(skin.destination, {
                    id = "optionSmallKeyNonActive", op = {22}, dst = {
                        {x = 192 + 20 + (j - 1) * (SMALL_KEY_W - 12) - 6, y = y, w = SMALL_KEY_W, h = SMALL_KEY_H}
                    }
                })
            end
        end
        for j = 1, 7 do
            if i == j then
                local y = baseY + 3
                if j % 2 == 0 then -- 上のキーは座標足す
                    y = y + SMALL_KEY_H - 6 * 2
                end
                table.insert(skin.destination, {
                    id = "optionSmallKeyActive", op = {22}, dst = {
                        {x = 192 + 20 + (j - 1) * (SMALL_KEY_W - 12) - 6, y = y, w = SMALL_KEY_W, h = SMALL_KEY_H}
                    }
                })
            end
        end

        -- 文字
        table.insert(skin.destination, {
            id = assistText .. "TextImg", op = {22}, dst = {
                {x = 314, y = baseY, w = OPTION_HEADER_TEXT_W, h = OPTION_HEADER_H}
            }
        })
        table.insert(skin.destination, {
            id = assistText .. "DescriptionTextImg", op = {22}, dst = {
                {x = 672, y = baseY, w = OPTION_HEADER_TEXT_W * 2, h = OPTION_HEADER_H}
            }
        })

        -- ボタン
        table.insert(skin.destination, {
            id = assistText .. "ButtonImgset", op = {22}, dst = {
                {x = 1426, y = baseY - (OPTION_SWITCH_BUTTON_H - OPTION_HEADER_H) / 2, w = OPTION_SWITCH_BUTTON_W, h = OPTION_SWITCH_BUTTON_H},
            }
        })
    end

    -- その他オプション
    -- ヘルプ背景
    table.insert(skin.destination, {
        id = "gray", op = {23}, dst = {
            {x = OPTION_WND_OFFSET_X + OPTION_WND_W - HELP_WND_W, y = OPTION_WND_OFFSET_Y, w = HELP_WND_W - OPTION_WND_EDGE_SIZE, h = HELP_WND_H - OPTION_WND_EDGE_SIZE}
        }
    })
    table.insert(skin.destination, {
        id = "gray", op = {23}, dst = {
            {x = OPTION_WND_OFFSET_X + OPTION_WND_W - HELP_WND_W + OPTION_WND_EDGE_SIZE, y = OPTION_WND_OFFSET_Y + OPTION_WND_EDGE_SIZE, w = HELP_WND_W - OPTION_WND_EDGE_SIZE, h = HELP_WND_H - OPTION_WND_EDGE_SIZE}
        }
    })
    -- 隅
    table.insert(skin.destination, {
        id = "optionWndEdge", op = {23}, dst = {
            {x = OPTION_WND_OFFSET_X + OPTION_WND_W - OPTION_WND_EDGE_SIZE, y = OPTION_WND_OFFSET_Y, w = OPTION_WND_EDGE_SIZE, h = OPTION_WND_EDGE_SIZE, angle = 180, r = 64, g = 64, b = 64},
        }
    })
    table.insert(skin.destination, {
        id = "optionWndEdge", op = {23}, dst = {
            {
                x = OPTION_WND_OFFSET_X + OPTION_WND_W - HELP_WND_W,
                y = OPTION_WND_OFFSET_Y + HELP_WND_H - OPTION_WND_EDGE_SIZE,
                w = OPTION_WND_EDGE_SIZE, h = OPTION_WND_EDGE_SIZE,
                angle = 0, r = 64, g = 64, b = 64
            }
        }
    })
    destinationPlayOption(skin, 192, 205, "optionHeader2GaugeAutoShift", "gaugeAutoShift", true, {2}, 23)
    destinationPlayOption(skin, 192, 607, "optionHeader2BgaShow", "bgaShow", true, {1}, 23)
    destinationNumberOption(skin, 1088, 799, "optionHeader2NotesDisplayTime", "notesDisplayTime", true, {4, 6}, 23)
    destinationNumberOption(skin, 1088, 614, "optionHeader2JudgeTiming", "judgeTiming", true, {5, 7}, 23)

    -- ヘルプヘッダ
    local helpHeaderOffsetX = OPTION_WND_OFFSET_X + OPTION_WND_W - HELP_WND_W + 3
    local helpHeaderOffsetY = OPTION_WND_OFFSET_Y + HELP_WND_H - HELP_ICON_SIZE - 3
    table.insert(skin.destination, {
        id = "helpIcon", op = {23}, dst = {
            {
                x = helpHeaderOffsetX, y = helpHeaderOffsetY,
                w = HELP_ICON_SIZE, h = HELP_ICON_SIZE
            }
        }
    })
    table.insert(skin.destination, {
        id = "helpHeaderText", op = {23}, dst = {
            {
                x = helpHeaderOffsetX + HELP_ICON_SIZE + 1, y = helpHeaderOffsetY + 13,
                w = 122, h = 30
            }
        }
    })
    table.insert(skin.destination, {
        id = "white", op = {23}, dst = {
            {
                x = helpHeaderOffsetX + 6, y = helpHeaderOffsetY,
                w = 652, h = 2
            }
        }
    })
    -- ヘルプ内容
    table.insert(skin.destination, {
        id = "helpNumberKeys", op = {23}, loop = 0, timer = 23, dst = {
            {time = 0, a = 255, x = helpHeaderOffsetX + 9, y = helpHeaderOffsetY - HELP_TEXT_H, w = HELP_TEXT1_W, h = HELP_TEXT_H},
            {time = 3500, a = 255},
            {time = 4000, a = 0},
            {time = 15500, a = 0},
            {time = 16000, a = 255, x = helpHeaderOffsetX + 9, y = helpHeaderOffsetY - HELP_TEXT_H, w = HELP_TEXT1_W, h = HELP_TEXT_H},
        }
    })
    table.insert(skin.destination, {
        id = "helpFunctionKeys", op = {23}, loop = 0, timer = 23, dst = {
            {time = 0, a = 0},
            {time = 3500, a = 0, x = helpHeaderOffsetX + 9, y = helpHeaderOffsetY - HELP_TEXT_H, w = HELP_TEXT1_W, h = HELP_TEXT_H},
            {time = 4000, a = 255, x = helpHeaderOffsetX + 9, y = helpHeaderOffsetY - HELP_TEXT_H, w = HELP_TEXT1_W, h = HELP_TEXT_H},
            {time = 7500, a = 255},
            {time = 8000, a = 0},
            {time = 16000, a = 0},
        }
    })
    table.insert(skin.destination, {
        id = "helpPlayKey", op = {23}, loop = 0, timer = 23, dst = {
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

    return skin
end

return {
    header = header,
    main = main
}