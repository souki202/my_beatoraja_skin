local main_state = require("main_state")
local commons = require("modules.select.commons")

local songlist = {
    functions = {}
}

local SONG_LIST = {
    BAR = {
        N = 17,
        W = 607,
        H = 78,

        PREV_CENTER_X = 1197 - 11.2 * 1.75,
        PREV_CENTER_Y = 571 - 80 * 1.75,
        CENTER_X = 1197,
        CENTER_Y = 571,
        NEXT_CENTER_X = 1197 + 11.2,
        NEXT_CENTER_Y = 571 + 80,

        CENTER_IDX = 8,

        INTERVAL_Y = 80,
        INTERVAL_X = 80 * 0.14,
        FONT_SIZE = 32,
        ANIM_INTERVAL = 20,

        DIFFICULTY = {
            X = 18,
            Y = 12,
            W = 16,
            H = 21,
        },
        TROPHY = {
            W = 56,
            H = 56,
        },
        TEXT = {
            X = 570,
            Y = 21,
            W = 397,
        },
        GRAPH = {
            X = 170,
            Y = 9,
            W = 397,
            H = 8,
        },
        LABEL = {
            X = 70,
            Y = 11,
            W = 50,
            H = 22,
        },
        LAMP = {
            W = 110,
            H = 28,
            X = 17,
            Y = 41,
        },
    },
    ACTIVE_FRAME = {
        -- アクティブなバーの部分のフレーム座標
        FRAME = {
            X = 1143,
            Y = 503,
            W = 714,
            H = 130,
        },
        -- アクティブなバーの箇所のアーティスト名とサブアーティスト名のサイズ
        TEXT = {
            ARTIST_SIZE = 24,
            SUBARTIST_SIZE = 18,
        },
        -- アーティスト表記の描画最大幅と絶対座標 xは右端
        ARTIST = {
            X = function (self) return self.ACTIVE_FRAME.FRAME.X + 657 end,
            Y = function (self) return self.ACTIVE_FRAME.FRAME.Y + 40 end,
            W = 370,
        },
        -- サブアーティスト表記の描画最大幅と絶対座標 xは右端
        SUBARTIST = {
            X = function (self) return self.ACTIVE_FRAME.FRAME.X + 657 end,
            Y = function (self) return self.ACTIVE_FRAME.FRAME.Y + 13 end,
            W = 310,
        },
        ITEM_TEXT = {
            W = 168,
            H = 22,
        },
        FAVORITE = {
            X = function (self) return self.ACTIVE_FRAME.FRAME.X + 669 end,
            Y = function (self) return self.ACTIVE_FRAME.FRAME.Y + 86 end,
            W = 26,
            H = 25,
        },
    }
}

local SONG_LIST_THIN = {
    BAR = {
        N = 25,
        W = 607,
        H = 50,

        PREV_CENTER_X = 1196 - 11.2 * 1.75 + 4,
        PREV_CENTER_Y = 573 - 50 * 1.75 - 30,
        CENTER_X = 1196,
        CENTER_Y = 573,
        NEXT_CENTER_X = 1196 + 7.7,
        NEXT_CENTER_Y = 573 + 57,

        CENTER_IDX = 12,

        INTERVAL_Y = 50,
        INTERVAL_X = 50 * 0.14,
        FONT_SIZE = 24,
        ANIM_INTERVAL = 15,

        DIFFICULTY = {
            X = 143,
            Y = 14,
            W = 16,
            H = 21,
        },
        TROPHY = {
            W = 56,
            H = 56,
        },
        TITLE = {
            X = 570,
            Y = 11,
            W = 380,
        },
        GRAPH = {
            X = 179,
            Y = 8,
            W = 403,
            H = 4,
        },
        LABEL = {
            X = 580,
            Y = 0,
            W = 20,
            H = 50,
        },
        LAMP = {
            W = 110,
            H = 28,
            X = 17,
            Y = 11,
        },
    },
    ACTIVE_FRAME = {
        -- アクティブなバーの部分のフレーム座標
        FRAME = {
            X = 1143,
            Y = 503,
            W = 714,
            H = 130,
        },
        -- アクティブなバーの箇所のアーティスト名とサブアーティスト名のサイズ
        TEXT = {
            ARTIST_SIZE = 24,
            SUBARTIST_SIZE = 18,
        },
        -- アーティスト表記の描画最大幅と絶対座標 xは右端
        ARTIST = {
            X = function (self) return self.ACTIVE_FRAME.FRAME.X + 657 end,
            Y = function (self) return self.ACTIVE_FRAME.FRAME.Y + 40 end,
            W = 370,
        },
        -- サブアーティスト表記の描画最大幅と絶対座標 xは右端
        SUBARTIST = {
            X = function (self) return self.ACTIVE_FRAME.FRAME.X + 657 end,
            Y = function (self) return self.ACTIVE_FRAME.FRAME.Y + 13 end,
            W = 310,
        },
        ITEM_TEXT = {
            W = 168,
            H = 22,
        },
        FAVORITE = {
            X = function (self) return self.ACTIVE_FRAME.FRAME.X + 669 end,
            Y = function (self) return self.ACTIVE_FRAME.FRAME.Y + 86 end,
            W = 26,
            H = 25,
        },
    }
}

local FAVORITE = {
    W = 27,
    H = 26,
}

local JUDGE_DIFFICULTY = {
    W = 136,
    H = 22,
}

local LAMP_NAMES = {"Max", "Perfect", "Fc", "Exhard", "Hard", "Normal", "Easy", "Lassist", "Assist", "Failed", "Noplay"}

local function isViewFolderLampGraph()
    return getTableValue(skin_config.option, "フォルダのランプグラフ", 925) == 925
end

local function isDefaultLampGraphColor()
    return getTableValue(skin_config.option, "フォルダのランプグラフの色", 927) == 927
end

songlist.functions.load = function ()
    -- 設定を上書き
    do
        -- 太い
        local thickPath = skin_config.get_path("../select/parts/songlist/thick/*.png")
        local luaPath = string.sub(thickPath, 1, string.len(thickPath) - 3) .. "lua"
        local fp = io.open(luaPath, "r")
        if fp ~= nil then
            table.merge(SONG_LIST, dofile(luaPath))
        end

        local thinPath = skin_config.get_path("../select/parts/songlist/thin/*.png")
        luaPath = string.sub(thinPath, 1, string.len(thinPath) - 3) .. "lua"
        fp = io.open(luaPath, "r")
        if fp ~= nil then
            table.merge(SONG_LIST_THIN, dofile(luaPath))
        end
    end

    local params = SONG_LIST
    if not isThickSongList() then
        params = SONG_LIST_THIN
    end

    local skin = {
        image = {
            {id = "songlistBg", src = 13, x = 0, y = 0, w = -1, h = -1},
            -- 判定難易度
            {id = "judgeEasy"    , src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + JUDGE_DIFFICULTY.H * 0, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H},
            {id = "judgeNormal"  , src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + JUDGE_DIFFICULTY.H * 1, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H},
            {id = "judgeHard"    , src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + JUDGE_DIFFICULTY.H * 2, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H},
            {id = "judgeVeryhard", src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + JUDGE_DIFFICULTY.H * 3, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H},
            -- トロフィー
            {id ="goldTrophy"  , src = 0, x = 1896, y = commons.PARTS_OFFSET + SONG_LIST.BAR.TROPHY.H*0, w = SONG_LIST.BAR.TROPHY.W, h = SONG_LIST.BAR.TROPHY.H},
            {id ="silverTrophy", src = 0, x = 1896, y = commons.PARTS_OFFSET + SONG_LIST.BAR.TROPHY.H*1, w = SONG_LIST.BAR.TROPHY.W, h = SONG_LIST.BAR.TROPHY.H},
            {id ="bronzeTrophy", src = 0, x = 1896, y = commons.PARTS_OFFSET + SONG_LIST.BAR.TROPHY.H*2, w = SONG_LIST.BAR.TROPHY.W, h = SONG_LIST.BAR.TROPHY.H},

            -- ふぁぼ
            -- {id = "favoriteButton", src = 0, x = 1563, y = commons.PARTS_OFFSET + 263, w = FAVORITE.W*2, h = FAVORITE.H, divx = 2, act = 89},
            -- {id = "favoriteButton", src = 0, x = 1563, y = commons.PARTS_OFFSET + 263, w = FAVORITE.W, h = FAVORITE.H, act = 89},
        },
        text = {
            {id = "artist", font = 0, size = params.ACTIVE_FRAME.TEXT.ARTIST_SIZE, ref = 14, align = 2, overflow = 1},
            {id = "subArtist", font = 0, size = params.ACTIVE_FRAME.TEXT.SUBARTIST_SIZE, ref = 15, align = 2, overflow = 1},
        },
        value = {
            -- 選曲バー難易度数値
            {id = "barPlayLevelUnknown",  src = 0, x = 771, y = commons.PARTS_OFFSET,                                w = SONG_LIST.BAR.DIFFICULTY.W*10, h = SONG_LIST.BAR.DIFFICULTY.H, divx = 10, digit = 2, align = 2},
            {id = "barPlayLevelBeginner", src = 0, x = 771, y = commons.PARTS_OFFSET + SONG_LIST.BAR.DIFFICULTY.H*1, w = SONG_LIST.BAR.DIFFICULTY.W*10, h = SONG_LIST.BAR.DIFFICULTY.H, divx = 10, digit = 2, align = 2},
            {id = "barPlayLevelNormal",   src = 0, x = 771, y = commons.PARTS_OFFSET + SONG_LIST.BAR.DIFFICULTY.H*2, w = SONG_LIST.BAR.DIFFICULTY.W*10, h = SONG_LIST.BAR.DIFFICULTY.H, divx = 10, digit = 2, align = 2},
            {id = "barPlayLevelHyper",    src = 0, x = 771, y = commons.PARTS_OFFSET + SONG_LIST.BAR.DIFFICULTY.H*3, w = SONG_LIST.BAR.DIFFICULTY.W*10, h = SONG_LIST.BAR.DIFFICULTY.H, divx = 10, digit = 2, align = 2},
            {id = "barPlayLevelAnother",  src = 0, x = 771, y = commons.PARTS_OFFSET + SONG_LIST.BAR.DIFFICULTY.H*4, w = SONG_LIST.BAR.DIFFICULTY.W*10, h = SONG_LIST.BAR.DIFFICULTY.H, divx = 10, digit = 2, align = 2},
            {id = "barPlayLevelInsane",   src = 0, x = 771, y = commons.PARTS_OFFSET + SONG_LIST.BAR.DIFFICULTY.H*5, w = SONG_LIST.BAR.DIFFICULTY.W*10, h = SONG_LIST.BAR.DIFFICULTY.H, divx = 10, digit = 2, align = 2},
            {id = "barPlayLevelUnknown2", src = 0, x = 771, y = commons.PARTS_OFFSET + SONG_LIST.BAR.DIFFICULTY.H*6, w = SONG_LIST.BAR.DIFFICULTY.W*10, h = SONG_LIST.BAR.DIFFICULTY.H, divx = 10, digit = 2, align = 2},
        },
        -- songlist = {
        --     id = "songlist",
        --     center = 8,
        --     clickable = {8},
        --     listoff = {},
        --     liston = {},
        -- }
    }

    if isThickSongList() then
        mergeSkin(skin, {image = {
            {id = "barSong"   , src = 10, x = 0, y = 0, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barNosong" , src = 10, x = 0, y = SONG_LIST.BAR.H*1, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barGrade"  , src = 10, x = 0, y = SONG_LIST.BAR.H*2, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barNograde", src = 10, x = 0, y = SONG_LIST.BAR.H*2, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barFolder" , src = 10, x = 0, y = SONG_LIST.BAR.H*3, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barTable"  , src = 10, x = 0, y = SONG_LIST.BAR.H*4, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barCommand", src = 10, x = 0, y = SONG_LIST.BAR.H*5, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barSearch" , src = 10, x = 0, y = 0, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barFolderWithLamp" , src = 10, x = 0, y = SONG_LIST.BAR.H*6, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barTableWithLamp"  , src = 10, x = 0, y = SONG_LIST.BAR.H*7, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barCommandWithLamp", src = 10, x = 0, y = SONG_LIST.BAR.H*8, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            -- 選曲バーLN表示
            {id = "barLn"    , src = 10, x = 974, y = SONG_LIST.BAR.LABEL.H*0, w = SONG_LIST.BAR.LABEL.W, h = SONG_LIST.BAR.LABEL.H},
            {id = "barRandom", src = 10, x = 974, y = SONG_LIST.BAR.LABEL.H*1, w = SONG_LIST.BAR.LABEL.W, h = SONG_LIST.BAR.LABEL.H},
            {id = "barBomb"  , src = 10, x = 974, y = SONG_LIST.BAR.LABEL.H*2, w = SONG_LIST.BAR.LABEL.W, h = SONG_LIST.BAR.LABEL.H},
            {id = "barCn"    , src = 10, x = 974, y = SONG_LIST.BAR.LABEL.H*3, w = SONG_LIST.BAR.LABEL.W, h = SONG_LIST.BAR.LABEL.H},
            {id = "barHcn"   , src = 10, x = 974, y = SONG_LIST.BAR.LABEL.H*4, w = SONG_LIST.BAR.LABEL.W, h = SONG_LIST.BAR.LABEL.H},
            -- favorite
            {id = "favoriteButton", src = 10, x = 1024 - SONG_LIST.ACTIVE_FRAME.FAVORITE.W * 3, y = 273, w = SONG_LIST.ACTIVE_FRAME.FAVORITE.W * 3, h = SONG_LIST.ACTIVE_FRAME.FAVORITE.W, divx = 3, len = 3, ref = 90, act = 90},
        }})

        table.insert(skin.image,
            {id = "barCenterFrame", src = 10, x = 0, y = 1024 - SONG_LIST.ACTIVE_FRAME.FRAME.H, w = SONG_LIST.ACTIVE_FRAME.FRAME.W, h = SONG_LIST.ACTIVE_FRAME.FRAME.H}
        )
        table.insert(skin.text,
            {id = "bartext", font = 0, size = SONG_LIST.BAR.FONT_SIZE, align = 2, overflow = 1}
        )
    else
        mergeSkin(skin, {image = {
            {id = "barSong"   , src = 11, x = 0, y = 0, w = SONG_LIST_THIN.BAR.W, h = SONG_LIST_THIN.BAR.H},
            {id = "barNosong" , src = 11, x = 0, y = SONG_LIST_THIN.BAR.H*1, w = SONG_LIST_THIN.BAR.W, h = SONG_LIST_THIN.BAR.H},
            {id = "barGrade"  , src = 11, x = 0, y = SONG_LIST_THIN.BAR.H*2, w = SONG_LIST_THIN.BAR.W, h = SONG_LIST_THIN.BAR.H},
            {id = "barNograde", src = 11, x = 0, y = SONG_LIST_THIN.BAR.H*2, w = SONG_LIST_THIN.BAR.W, h = SONG_LIST_THIN.BAR.H},
            {id = "barFolder" , src = 11, x = 0, y = SONG_LIST_THIN.BAR.H*3, w = SONG_LIST_THIN.BAR.W, h = SONG_LIST_THIN.BAR.H},
            {id = "barTable"  , src = 11, x = 0, y = SONG_LIST_THIN.BAR.H*4, w = SONG_LIST_THIN.BAR.W, h = SONG_LIST_THIN.BAR.H},
            {id = "barCommand", src = 11, x = 0, y = SONG_LIST_THIN.BAR.H*5, w = SONG_LIST_THIN.BAR.W, h = SONG_LIST_THIN.BAR.H},
            {id = "barSearch" , src = 11, x = 0, y = 0, w = SONG_LIST_THIN.BAR.W, h = SONG_LIST_THIN.BAR.H},
            {id = "barFolderWithLamp" , src = 11, x = 0, y = SONG_LIST_THIN.BAR.H*6, w = SONG_LIST_THIN.BAR.W, h = SONG_LIST_THIN.BAR.H},
            {id = "barTableWithLamp"  , src = 11, x = 0, y = SONG_LIST_THIN.BAR.H*7, w = SONG_LIST_THIN.BAR.W, h = SONG_LIST_THIN.BAR.H},
            {id = "barCommandWithLamp", src = 11, x = 0, y = SONG_LIST_THIN.BAR.H*8, w = SONG_LIST_THIN.BAR.W, h = SONG_LIST_THIN.BAR.H},
            -- 選曲バーLN表示
            {id = "barLn"    , src = 11, x = 1024 - SONG_LIST_THIN.BAR.LABEL.W, y = SONG_LIST_THIN.BAR.LABEL.H*0, w = SONG_LIST_THIN.BAR.LABEL.W, h = SONG_LIST_THIN.BAR.LABEL.H},
            {id = "barRandom", src = 11, x = 1024 - SONG_LIST_THIN.BAR.LABEL.W, y = SONG_LIST_THIN.BAR.LABEL.H*1, w = SONG_LIST_THIN.BAR.LABEL.W, h = SONG_LIST_THIN.BAR.LABEL.H},
            {id = "barBomb"  , src = 11, x = 1024 - SONG_LIST_THIN.BAR.LABEL.W, y = SONG_LIST_THIN.BAR.LABEL.H*2, w = SONG_LIST_THIN.BAR.LABEL.W, h = SONG_LIST_THIN.BAR.LABEL.H},
            {id = "barCn"    , src = 11, x = 1024 - SONG_LIST_THIN.BAR.LABEL.W, y = SONG_LIST_THIN.BAR.LABEL.H*3, w = SONG_LIST_THIN.BAR.LABEL.W, h = SONG_LIST_THIN.BAR.LABEL.H},
            {id = "barHcn"   , src = 11, x = 1024 - SONG_LIST_THIN.BAR.LABEL.W, y = SONG_LIST_THIN.BAR.LABEL.H*4, w = SONG_LIST_THIN.BAR.LABEL.W, h = SONG_LIST_THIN.BAR.LABEL.H},
            -- favorite
            {id = "favoriteButton", src = 10, x = 1024 - SONG_LIST_THIN.ACTIVE_FRAME.FAVORITE.W * 3, y = 273, w = SONG_LIST_THIN.ACTIVE_FRAME.FAVORITE.W * 3, h = SONG_LIST_THIN.ACTIVE_FRAME.FAVORITE.W, divx = 3, len = 3, ref = 90, act = 90},
        }})
        table.insert(skin.image,
            {id = "barCenterFrame", src = 11, x = 0, y = 1024 - SONG_LIST_THIN.ACTIVE_FRAME.FRAME.H, w = SONG_LIST_THIN.ACTIVE_FRAME.FRAME.W, h = SONG_LIST_THIN.ACTIVE_FRAME.FRAME.H}
        )
        table.insert(skin.text, 
            {id = "bartext", font = 0, size = SONG_LIST_THIN.BAR.FONT_SIZE, align = 2, overflow = 1}
        )
    end

    -- 選曲バーのクリアランプ
    for i, lamp in ipairs(LAMP_NAMES) do
        table.insert(skin.image, {
            id = "barLamp" .. lamp, src = 0,
            x = 657, y = commons.PARTS_OFFSET + SONG_LIST.BAR.LAMP.H * (i - 1),
            w = SONG_LIST.BAR.LAMP.W, h = SONG_LIST.BAR.LAMP.H
        })
        table.insert(skin.image, {
            id = "barLampRivalPlayer" .. lamp, src = 0,
            x = 657, y = commons.PARTS_OFFSET + SONG_LIST.BAR.LAMP.H * (i - 1),
            w = SONG_LIST.BAR.LAMP.W, h = SONG_LIST.BAR.LAMP.H / 2
        })
        table.insert(skin.image, {
            id = "barLampRivalTarget" .. lamp, src = 0,
            x = 657, y = commons.PARTS_OFFSET + SONG_LIST.BAR.LAMP.H * (i - 1) + SONG_LIST.BAR.LAMP.H / 2,
            w = SONG_LIST.BAR.LAMP.W, h = SONG_LIST.BAR.LAMP.H / 2
        })
    end

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

    mergeSkin(skin, songlist.functions.loadSongListBar())

    return skin
end

songlist.functions.loadSongListBar = function ()
    local params = SONG_LIST
    if not isThickSongList() then
        params = SONG_LIST_THIN
    end

    local skin = {
        songlist = {
            id = "songlist",
            center = params.BAR.CENTER_IDX,
            clickable = {params.BAR.CENTER_IDX},
            listoff = {},
            liston = {},
        }
    }

    do
        local timeInterval = params.BAR.ANIM_INTERVAL
        local centerIdx = skin.songlist.center
        local intervalY = params.BAR.INTERVAL_Y
        local intervalX = params.BAR.INTERVAL_X
        local alpha = getSongListAlpha()
        for i = 1, params.BAR.N do
            local idx = params.BAR.N - i
            local posX = 0
            local posY = 0
            if idx < centerIdx then
                posX = math.floor(params.BAR.PREV_CENTER_X + (idx - centerIdx + 1) * intervalX)
                posY = math.floor(params.BAR.PREV_CENTER_Y + (idx - centerIdx + 1) * intervalY)
            elseif idx > centerIdx then
                posX = math.floor(params.BAR.NEXT_CENTER_X + (idx - centerIdx - 1) * intervalX)
                posY = math.floor(params.BAR.NEXT_CENTER_Y + (idx - centerIdx - 1) * intervalY)
            elseif idx == centerIdx then
                posX = math.floor(params.BAR.CENTER_X)
                posY = math.floor(params.BAR.CENTER_Y)
            end
            -- ぽわんと1回跳ねる感じ
            table.insert(skin.songlist.listoff, {
                id = "bar", loop = 250 + i * timeInterval,
                dst = {
                    {time = 0                 , x = posX + 800, y = posY, w = params.BAR.W, h = params.BAR.H, a = alpha, acc = 2},
                    {time = i * timeInterval      , x = posX + 800, acc = 2},
                    {time = 200 + i * timeInterval, x = posX -  50, acc = 1},
                    {time = 225 + i * timeInterval, x = posX -  25, acc = 2},
                    {time = 250 + i * timeInterval, x = posX      , acc = 2}
                }
            })
            table.insert(skin.songlist.liston, {
                id = "bar", loop = 250 + i * timeInterval,
                dst = {
                    {time = 0                 , x = posX + 800, y = posY, w = params.BAR.W, h = params.BAR.H, a = alpha, acc = 2},
                    {time = i * timeInterval      , x = posX + 800, acc = 2},
                    {time = 200 + i * timeInterval, x = posX -  50, acc = 1},
                    {time = 225 + i * timeInterval, x = posX -  25, acc = 2},
                    {time = 250 + i * timeInterval, x = posX      , acc = 2}
                }
            })
        end
    end

    skin.songlist.label = {
        {
            id = "barLn", dst = {
                {x = params.BAR.LABEL.X, y = params.BAR.LABEL.Y, w = params.BAR.LABEL.W, h = params.BAR.LABEL.H, a = getSongListAlpha()}
            }
        },
        {
            id = "barRandom", dst = {
                {x = params.BAR.LABEL.X, y = params.BAR.LABEL.Y, w = params.BAR.LABEL.W, h = params.BAR.LABEL.H, a = getSongListAlpha()}
            }
        },
        {
            id = "barBomb", dst = {
                {x = params.BAR.LABEL.X, y = params.BAR.LABEL.Y, w = params.BAR.LABEL.W, h = params.BAR.LABEL.H, a = getSongListAlpha()}
            }
        },
        {
            id = "barCn", dst = {
                {x = params.BAR.LABEL.X, y = params.BAR.LABEL.Y, w = params.BAR.LABEL.W, h = params.BAR.LABEL.H, a = getSongListAlpha()}
            }
        },
        {
            id = "barHcn", dst = {
                {x = params.BAR.LABEL.X, y = params.BAR.LABEL.Y, w = params.BAR.LABEL.W, h = params.BAR.LABEL.H, a = getSongListAlpha()}
            }
        },
    }

    if isDefaultLampGraphColor() then
        skin.graph = {
            {id = "lampGraph", src = 0, x = 607, y = commons.PARTS_OFFSET, w = 11, h = 16, divx = 11, divy = 2, cycle = 16.6*4, type = -1, a = getSongListAlpha()}
        }
    else
        skin.graph = {
            {id = "lampGraph", src = 6, x = 0, y = 0, w = 1408, h = 256, divx = 11, divy = 256, cycle = 2000, type = -1, a = getSongListAlpha()},
        }
    end

    -- skin.songlist.trophy = {
    --     {
    --         id = "bronzeTrophy", dst = {
    --             {x = 146, y = 11, w = params.BAR.TROPHY.W, h = params.BAR.TROPHY.H}
    --         }
    --     },
    --     {
    --         id = "silverTrophy", dst = {
    --             {x = 146, y = 11, w = params.BAR.TROPHY.W, h = params.BAR.TROPHY.H}
    --         }
    --     },
    --     {
    --         id = "goldTrophy", dst = {
    --             {x = 146, y = 11, w = params.BAR.TROPHY.W, h = params.BAR.TROPHY.H}
    --         }
    --     },
    -- }

    -- 曲名等
    do
        local text = params.BAR.TITLE
        skin.songlist.text = {
            {
                id = "bartext", filter = 1,
                dst = {
                    {x = text.X, y = text.Y, w = text.W, h = params.BAR.FONT_SIZE, r = 0, g = 0, b = 0, filter = 1, a = getCommonSongListAlpha()}
                }
            },
            {
                id = "bartext", filter = 1,
                dst = {
                    {x = text.X, y = text.Y, w = text.W, h = params.BAR.FONT_SIZE, r = 200, g = 0, b = 0, filter = 1, a = getCommonSongListAlpha()}
                }
            },
        }
    end

    if isViewFolderLampGraph() then
        skin.songlist.graph = {
            id = "lampGraph", dst = {
                {x = params.BAR.GRAPH.X, y = params.BAR.GRAPH.Y, w = params.BAR.GRAPH.W, h = params.BAR.GRAPH.H, a = getSongListAlpha()}
            }
        }
    end

    -- 難易度表記
    do
        local list = {
            "barPlayLevelUnknown",
            "barPlayLevelBeginner",
            "barPlayLevelNormal",
            "barPlayLevelHyper",
            "barPlayLevelAnother",
            "barPlayLevelInsane",
            "barPlayLevelUnknown2",
        }
        skin.songlist.level = {}
        for i = 1, #list do
            table.insert(skin.songlist.level, {
                id = list[i],
                dst = {
                    {x = params.BAR.DIFFICULTY.X, y = params.BAR.DIFFICULTY.Y, w = params.BAR.DIFFICULTY.W, h = params.BAR.DIFFICULTY.H, a = getSongListAlpha()}
                }
            })
        end
    end

    do
        local x = params.BAR.LAMP.X
        local y = params.BAR.LAMP.Y
        local w = params.BAR.LAMP.W
        local h = params.BAR.LAMP.H

        skin.songlist.lamp = {}
        skin.songlist.playerlamp = {}
        skin.songlist.rivallamp = {}

        for i, lamp in ipairs(LAMP_NAMES) do
            table.insert(skin.songlist.lamp, 1, {
                id = "barLamp" .. lamp, dst = {
                    {x = x, y = y, w = w, h = h, a = getSongListAlpha()}
                }
            })
            table.insert(skin.songlist.playerlamp, 1, {
                id = "barLampRivalPlayer" .. lamp, dst = {
                    {x = x, y = y + h / 2, w = w, h = h / 2, a = getSongListAlpha()}
                }
            })
            table.insert(skin.songlist.rivallamp, 1, {
                id = "barLampRivalTarget" .. lamp, dst = {
                    {x = x, y = y, w = w, h = h / 2, a = getSongListAlpha()}
                }
            })
        end
    end
    return skin
end

songlist.functions.dst = function ()
    local params = SONG_LIST
    if not isThickSongList() then
        params = SONG_LIST_THIN
    end

    return {
        destination = {
            {
                id = "songlistBg", dst = {
                    {x = 0, y = 0, w = WIDTH, h = HEIGHT, a = getSongListBgAlpha()}
                }
            },
            {id = "songlist"},
            -- 選曲バー中央
            {
                id = "barCenterFrame", dst = {
                    {x = params.ACTIVE_FRAME.FRAME.X, y = params.ACTIVE_FRAME.FRAME.Y, w = params.ACTIVE_FRAME.FRAME.W, h = params.ACTIVE_FRAME.FRAME.H, a = getCenterSongFrameAlpha()}
                }
            },
            -- アーティスト
            {
                id = "artist", filter = 1, dst = {
                    {x = params.ACTIVE_FRAME.ARTIST.X(params), y = params.ACTIVE_FRAME.ARTIST.Y(params), w = params.ACTIVE_FRAME.ARTIST.W, h = params.ACTIVE_FRAME.TEXT.ARTIST_SIZE, r = 0, g = 0, b = 0, a = getCommonSongListAlpha()}
                }
            },
            {
                id = "subArtist", filter = 1, dst = {
                    {x = params.ACTIVE_FRAME.SUBARTIST.X(params), y = params.ACTIVE_FRAME.SUBARTIST.Y(params), w = params.ACTIVE_FRAME.SUBARTIST.W, h = params.ACTIVE_FRAME.TEXT.SUBARTIST_SIZE, r = 0, g = 0, b = 0, a = getCommonSongListAlpha()}
                }
            },
            -- BPM
            {
                id = "bpmTextImg", op = {2}, dst = {
                    {x = 1207, y = 547, w = params.ACTIVE_FRAME.ITEM_TEXT.W, h = params.ACTIVE_FRAME.ITEM_TEXT.H, a = getCommonSongListAlpha()}
                }
            },
            -- BPM変化なし
            {
                id = "bpm", op = {176}, dst = {
                    {x = 1380 - commons.NUM_28PX.W * 7, y = 547, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H, a = getCommonSongListAlpha()}
                }
            },
            -- BPM変化あり
            {
                id = "bpmMax", op = {177}, dst = {
                    {x = 1380 - commons.NUM_28PX.W * 3, y = 547, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H, a = getCommonSongListAlpha()}
                }
            },
            {
                id = "bpmTilda", op = {177}, dst = {
                    {x = 1380 - commons.NUM_28PX.W * 4, y = 547, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H, a = getCommonSongListAlpha()}
                }
            },
            {
                id = "bpmMin", op = {177}, dst = {
                    {x = 1380 - commons.NUM_28PX.W * 7, y = 547, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H, a = getCommonSongListAlpha()}
                }
            },
            -- keys
            {
                id = "keysTextImg", op = {2}, dst = {
                    {x = 1207, y = 517, w = SONG_LIST.ACTIVE_FRAME.ITEM_TEXT.W, h = SONG_LIST.ACTIVE_FRAME.ITEM_TEXT.H, a = getCommonSongListAlpha()}
                }
            },
            -- 楽曲keys ゴリ押し
            {
                id = "music7keys", op = {160}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H, a = getCommonSongListAlpha()}
                }
            },
            {
                id = "music5keys", op = {161}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H, a = getCommonSongListAlpha()}
                }
            },
            {
                id = "music14keys", op = {162}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H, a = getCommonSongListAlpha()}
                }
            },
            {
                id = "music10keys", op = {163}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H, a = getCommonSongListAlpha()}
                }
            },
            {
                id = "music9keys", op = {164}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H, a = getCommonSongListAlpha()}
                }
            },
            {
                id = "music24keys", op = {1160}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H, a = getCommonSongListAlpha()}
                }
            },
            {
                id = "music48keys", op = {1161}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H, a = getCommonSongListAlpha()}
                }
            },

            -- 判定難易度
            {
                id = "judgeEasy", op = {183}, dst = {
                    {x = 1335, y = 517, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H, a = getCommonSongListAlpha()}
                }
            },
            {
                id = "judgeNormal", op = {182}, dst = {
                    {x = 1335, y = 517, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H, a = getCommonSongListAlpha()}
                }
            },
            {
                id = "judgeHard", op = {181}, dst = {
                    {x = 1335, y = 517, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H, a = getCommonSongListAlpha()}
                }
            },
            {
                id = "judgeVeryhard", op = {180}, dst = {
                    {x = 1335, y = 517, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H, a = getCommonSongListAlpha()}
                }
            },

            -- favorite
            {
                id = "favoriteButton", dst = {
                    {x = params.ACTIVE_FRAME.FAVORITE.X(params), y = params.ACTIVE_FRAME.FAVORITE.Y(params), w = params.ACTIVE_FRAME.FAVORITE.W, h = params.ACTIVE_FRAME.FAVORITE.H}
                }
            },
        }
    }
end

return songlist.functions