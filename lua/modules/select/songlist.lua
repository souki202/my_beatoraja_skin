local commons = require("modules.select.commons")

local songlist = {
    functions = {}
}

local SONG_LIST = {
    LABEL = {
        X = 70,
        Y = 11,
        W = 50,
        H = 22,
    },
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
    },
    LAMP = {
        W = 110,
        H = 28,
        X = 17,
        Y = 41,
    },
    TEXT = {
        ARTIST_SIZE = 24,
        SUBARTIST_SIZE = 18,
    },
    ITEM_TEXT = {
        W = 168,
        H = 22,
    },
    CENTER_FRAME = {
        X = 1143,
        Y = 503,
        W = 714,
        H = 154,
    },
}

local SONG_LIST_THIN = {
    LABEL = {
        X = 580,
        Y = 7,
        W = 20,
        H = 36,
    },
    BAR = {
        N = 25,
        W = 607,
        H = 50,

        PREV_CENTER_X = 1196 - 11.2 * 1.75 + 4,
        PREV_CENTER_Y = 573 - 80 + 1.75 - 34,
        CENTER_X = 1196,
        CENTER_Y = 573,
        NEXT_CENTER_X = 1196 + 7.7,
        NEXT_CENTER_Y = 573 + 57,

        CENTER_IDX = 12,

        INTERVAL_Y = 50,
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
        TEXT = {
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
    },
    LAMP = {
        W = 110,
        H = 28,
        X = 17,
        Y = 11,
    },
    TEXT = {
        ARTIST_SIZE = 24,
        SUBARTIST_SIZE = 18,
    },
    ITEM_TEXT = {
        W = 168,
        H = 22,
    },
    CENTER_FRAME = {
        X = 1143,
        Y = 503,
        W = 714,
        H = 130,
    },
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
    local skin = {
        image = {
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
            {id = "artist", font = 0, size = SONG_LIST.TEXT.ARTIST_SIZE, ref = 14, align = 2, overflow = 1},
            {id = "subArtist", font = 0, size = SONG_LIST.TEXT.SUBARTIST_SIZE, ref = 15, align = 2, overflow = 1},
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
            {id = "barLn"    , src = 10, x = 974, y = SONG_LIST.LABEL.H*0, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
            {id = "barRandom", src = 10, x = 974, y = SONG_LIST.LABEL.H*1, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
            {id = "barBomb"  , src = 10, x = 974, y = SONG_LIST.LABEL.H*2, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
            {id = "barCn"    , src = 10, x = 974, y = SONG_LIST.LABEL.H*3, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
            {id = "barHcn"   , src = 10, x = 974, y = SONG_LIST.LABEL.H*4, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
        }})

        table.insert(skin.image,
            {id = "barCenterFrame", src = 10, x = 0, y = 1024 - SONG_LIST.CENTER_FRAME.H, w = SONG_LIST.CENTER_FRAME.W, h = SONG_LIST.CENTER_FRAME.H}
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
            {id = "barLn"    , src = 11, x = 1024 - SONG_LIST_THIN.LABEL.W, y = SONG_LIST_THIN.LABEL.H*0, w = SONG_LIST_THIN.LABEL.W, h = SONG_LIST_THIN.LABEL.H},
            {id = "barRandom", src = 11, x = 1024 - SONG_LIST_THIN.LABEL.W, y = SONG_LIST_THIN.LABEL.H*1, w = SONG_LIST_THIN.LABEL.W, h = SONG_LIST_THIN.LABEL.H},
            {id = "barBomb"  , src = 11, x = 1024 - SONG_LIST_THIN.LABEL.W, y = SONG_LIST_THIN.LABEL.H*2, w = SONG_LIST_THIN.LABEL.W, h = SONG_LIST_THIN.LABEL.H},
            {id = "barCn"    , src = 11, x = 1024 - SONG_LIST_THIN.LABEL.W, y = SONG_LIST_THIN.LABEL.H*3, w = SONG_LIST_THIN.LABEL.W, h = SONG_LIST_THIN.LABEL.H},
            {id = "barHcn"   , src = 11, x = 1024 - SONG_LIST_THIN.LABEL.W, y = SONG_LIST_THIN.LABEL.H*4, w = SONG_LIST_THIN.LABEL.W, h = SONG_LIST_THIN.LABEL.H},
        }})
        table.insert(skin.image,
            {id = "barCenterFrame", src = 11, x = 0, y = 1024 - SONG_LIST_THIN.CENTER_FRAME.H, w = SONG_LIST_THIN.CENTER_FRAME.W, h = SONG_LIST_THIN.CENTER_FRAME.H}
        )
        table.insert(skin.text, 
            {id = "bartext", font = 0, size = SONG_LIST_THIN.BAR.FONT_SIZE, align = 2, overflow = 1}
        )
    end

    -- 選曲バーのクリアランプ
    for i, lamp in ipairs(LAMP_NAMES) do
        table.insert(skin.image, {
            id = "barLamp" .. lamp, src = 0,
            x = 657, y = commons.PARTS_OFFSET + SONG_LIST.LAMP.H * (i - 1),
            w = SONG_LIST.LAMP.W, h = SONG_LIST.LAMP.H
        })
        table.insert(skin.image, {
            id = "barLampRivalPlayer" .. lamp, src = 0,
            x = 657, y = commons.PARTS_OFFSET + SONG_LIST.LAMP.H * (i - 1),
            w = SONG_LIST.LAMP.W, h = SONG_LIST.LAMP.H / 2
        })
        table.insert(skin.image, {
            id = "barLampRivalTarget" .. lamp, src = 0,
            x = 657, y = commons.PARTS_OFFSET + SONG_LIST.LAMP.H * (i - 1) + SONG_LIST.LAMP.H / 2,
            w = SONG_LIST.LAMP.W, h = SONG_LIST.LAMP.H / 2
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
        for i = 1, params.BAR.N do
            local idx = params.BAR.N - i
            local posX = 0
            local posY = 0
            if idx < centerIdx then
                posX = math.floor(params.BAR.PREV_CENTER_X + (idx - centerIdx + 1) * intervalY * 0.14)
                posY = math.floor(params.BAR.PREV_CENTER_Y + (idx - centerIdx + 1) * intervalY)
            elseif idx > centerIdx then
                posX = math.floor(params.BAR.NEXT_CENTER_X + (idx - centerIdx - 1) * intervalY * 0.14)
                posY = math.floor(params.BAR.NEXT_CENTER_Y + (idx - centerIdx - 1) * intervalY)
            elseif idx == centerIdx then
                posX = math.floor(params.BAR.CENTER_X)
                posY = math.floor(params.BAR.CENTER_Y)
            end
            -- ぽわんと1回跳ねる感じ
            table.insert(skin.songlist.listoff, {
                id = "bar", loop = 250 + i * timeInterval,
                dst = {
                    {time = 0                 , x = posX + 800, y = posY, w = params.BAR.W, h = params.BAR.H, acc = 2},
                    {time = i * timeInterval      , x = posX + 800, y = posY, w = params.BAR.W, h = params.BAR.H, acc = 2},
                    {time = 200 + i * timeInterval, x = posX -  50, y = posY, w = params.BAR.W, h = params.BAR.H, acc = 1},
                    {time = 225 + i * timeInterval, x = posX -  25, y = posY, w = params.BAR.W, h = params.BAR.H, acc = 2},
                    {time = 250 + i * timeInterval, x = posX      , y = posY, w = params.BAR.W, h = params.BAR.H, acc = 2}
                }
            })
            table.insert(skin.songlist.liston, {
                id = "bar", loop = 250 + i * timeInterval,
                dst = {
                    {time = 0                 , x = posX + 800, y = posY, w = params.BAR.W, h = params.BAR.H, acc = 2},
                    {time = i * timeInterval      , x = posX + 800, y = posY, w = params.BAR.W, h = params.BAR.H, acc = 2},
                    {time = 200 + i * timeInterval, x = posX -  50, y = posY, w = params.BAR.W, h = params.BAR.H, acc = 1},
                    {time = 225 + i * timeInterval, x = posX -  25, y = posY, w = params.BAR.W, h = params.BAR.H, acc = 2},
                    {time = 250 + i * timeInterval, x = posX      , y = posY, w = params.BAR.W, h = params.BAR.H, acc = 2}
                }
            })
        end
    end

    skin.songlist.label = {
        {
            id = "barLn", dst = {
                {x = params.LABEL.X, y = params.LABEL.Y, w = params.LABEL.W, h = params.LABEL.H}
            }
        },
        {
            id = "barRandom", dst = {
                {x = params.LABEL.X, y = params.LABEL.Y, w = params.LABEL.W, h = params.LABEL.H}
            }
        },
        {
            id = "barBomb", dst = {
                {x = params.LABEL.X, y = params.LABEL.Y, w = params.LABEL.W, h = params.LABEL.H}
            }
        },
        {
            id = "barCn", dst = {
                {x = params.LABEL.X, y = params.LABEL.Y, w = params.LABEL.W, h = params.LABEL.H}
            }
        },
        {
            id = "barHcn", dst = {
                {x = params.LABEL.X, y = params.LABEL.Y, w = params.LABEL.W, h = params.LABEL.H}
            }
        },
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
        local text = params.BAR.TEXT
        skin.songlist.text = {
            {
                id = "bartext", filter = 1,
                dst = {
                    {x = text.X, y = text.Y, w = text.W, h = params.BAR.FONT_SIZE, r = 0, g = 0, b = 0, filter = 1}
                }
            },
            {
                id = "bartext", filter = 1,
                dst = {
                    {x = text.X, y = text.Y, w = text.W, h = params.BAR.FONT_SIZE, r = 200, g = 0, b = 0, filter = 1}
                }
            },
        }
    end

    if isViewFolderLampGraph() then
        skin.songlist.graph = {
            id = "lampGraph", dst = {
                {x = params.BAR.GRAPH.X, y = params.BAR.GRAPH.Y, w = params.BAR.GRAPH.W, h = params.BAR.GRAPH.H}
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
                    {x = params.BAR.DIFFICULTY.X, y = params.BAR.DIFFICULTY.Y, w = params.BAR.DIFFICULTY.W, h = params.BAR.DIFFICULTY.H}
                }
            })
        end
    end

    do
        local x = params.LAMP.X
        local y = params.LAMP.Y
        local w = params.LAMP.W
        local h = params.LAMP.H

        skin.songlist.lamp = {}
        skin.songlist.playerlamp = {}
        skin.songlist.rivallamp = {}

        for i, lamp in ipairs(LAMP_NAMES) do
            table.insert(skin.songlist.lamp, 1, {
                id = "barLamp" .. lamp, dst = {
                    {x = x, y = y, w = w, h = h}
                }
            })
            table.insert(skin.songlist.playerlamp, 1, {
                id = "barLampRivalPlayer" .. lamp, dst = {
                    {x = x, y = y + h / 2, w = w, h = h / 2}
                }
            })
            table.insert(skin.songlist.rivallamp, 1, {
                id = "barLampRivalTarget" .. lamp, dst = {
                    {x = x, y = y, w = w, h = h / 2}
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
            {id = "songlist"},
            -- 選曲バー中央
            {
                id = "barCenterFrame", dst = {
                    {x = 1143, y = 503, w = params.CENTER_FRAME.W, h = params.CENTER_FRAME.H}
                }
            },
            -- アーティスト
            {
                id = "artist", filter = 1, dst = {
                    {x = 1800, y = 543, w = 370, h = SONG_LIST.TEXT.ARTIST_SIZE, r = 0, g = 0, b = 0}
                }
            },
            {
                id = "subArtist", filter = 1, dst = {
                    {x = 1800, y = 516, w = 310, h = SONG_LIST.TEXT.SUBARTIST_SIZE, r = 0, g = 0, b = 0}
                }
            },
            -- BPM
            {
                id = "bpmTextImg", op = {2}, dst = {
                    {x = 1207, y = 547, w = SONG_LIST.ITEM_TEXT.W, h = SONG_LIST.ITEM_TEXT.H}
                }
            },
            -- BPM変化なし
            {
                id = "bpm", op = {176}, dst = {
                    {x = 1380 - commons.NUM_28PX.W * 7, y = 547, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H}
                }
            },
            -- BPM変化あり
            {
                id = "bpmMax", op = {177}, dst = {
                    {x = 1380 - commons.NUM_28PX.W * 3, y = 547, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H}
                }
            },
            {
                id = "bpmTilda", op = {177}, dst = {
                    {x = 1380 - commons.NUM_28PX.W * 4, y = 547, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H}
                }
            },
            {
                id = "bpmMin", op = {177}, dst = {
                    {x = 1380 - commons.NUM_28PX.W * 7, y = 547, w = commons.NUM_28PX.W, h = commons.NUM_28PX.H}
                }
            },
            -- keys
            {
                id = "keysTextImg", op = {2}, dst = {
                    {x = 1207, y = 517, w = SONG_LIST.ITEM_TEXT.W, h = SONG_LIST.ITEM_TEXT.H}
                }
            },
            -- 楽曲keys ゴリ押し
            {
                id = "music7keys", op = {160}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H}
                }
            },
            {
                id = "music5keys", op = {161}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H}
                }
            },
            {
                id = "music14keys", op = {162}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H}
                }
            },
            {
                id = "music10keys", op = {163}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H}
                }
            },
            {
                id = "music9keys", op = {164}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H}
                }
            },
            {
                id = "music24keys", op = {1160}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H}
                }
            },
            {
                id = "music48keys", op = {1161}, dst = {
                    {x = 1207 + 70, y = 517, w = commons.NUM_28PX.W * 2, h = commons.NUM_28PX.H}
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
        }
    }
end

return songlist.functions