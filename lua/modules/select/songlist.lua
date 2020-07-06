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
        W = 607,
        H = 78,
        FONT_SIZE = 32,

        DIFFICULTY = {
            W = 16,
            H = 21,
        },
        TROPHY = {
            W = 56,
            H = 56,
        }
    },
    LAMP = {
        W = 110,
        H = 28
    },
    TEXT = {
        ARTIST_SIZE = 24,
        SUBARTIST_SIZE = 18,
    },
    ITEM_TEXT = {
        W = 168,
        H = 22,
    }
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
        source = {
            {id = 6, path = "../select/parts/lamp_gauge_rainbow.png"},
        },
        image = {
            -- 選曲バー種類
            {id = "barSong"   , src = 0, x = 0, y = commons.PARTS_OFFSET, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barNosong" , src = 0, x = 0, y = commons.PARTS_OFFSET + SONG_LIST.BAR.H*1, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barGrade"  , src = 0, x = 0, y = commons.PARTS_OFFSET + SONG_LIST.BAR.H*2, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barNograde", src = 0, x = 0, y = commons.PARTS_OFFSET + SONG_LIST.BAR.H*2, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barFolder" , src = 0, x = 0, y = commons.PARTS_OFFSET + SONG_LIST.BAR.H*3, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barFolderWithLamp" , src = 0, x = 0, y = commons.PARTS_OFFSET + SONG_LIST.BAR.H*7, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barTable"  , src = 0, x = 0, y = commons.PARTS_OFFSET + SONG_LIST.BAR.H*4, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barTableWithLamp"  , src = 0, x = 0, y = commons.PARTS_OFFSET + SONG_LIST.BAR.H*8, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barCommand", src = 0, x = 0, y = commons.PARTS_OFFSET + SONG_LIST.BAR.H*5, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barCommandWithLamp", src = 0, x = 0, y = commons.PARTS_OFFSET + SONG_LIST.BAR.H*9, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            {id = "barSearch" , src = 0, x = 0, y = commons.PARTS_OFFSET, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H},
            -- 選曲バークリアランプはimagesの後
            -- 選曲バー中央
            {id = "barCenterFrame", src = 0, x = 0, y = commons.PARTS_OFFSET + 782, w = 714, h = 154},
            -- 判定難易度
            {id = "judgeEasy"    , src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + JUDGE_DIFFICULTY.H * 0, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H},
            {id = "judgeNormal"  , src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + JUDGE_DIFFICULTY.H * 1, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H},
            {id = "judgeHard"    , src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + JUDGE_DIFFICULTY.H * 2, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H},
            {id = "judgeVeryhard", src = 0, x = 1298, y = commons.PARTS_OFFSET + 361 + JUDGE_DIFFICULTY.H * 3, w = JUDGE_DIFFICULTY.W, h = JUDGE_DIFFICULTY.H},
            -- 選曲バーLN表示
            {id = "barLn"    , src = 0, x = 607, y = commons.PARTS_OFFSET + 16 + SONG_LIST.LABEL.H*0, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
            {id = "barRandom", src = 0, x = 607, y = commons.PARTS_OFFSET + 16 + SONG_LIST.LABEL.H*1, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
            {id = "barBomb"  , src = 0, x = 607, y = commons.PARTS_OFFSET + 16 + SONG_LIST.LABEL.H*2, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
            {id = "barCn"    , src = 0, x = 607, y = commons.PARTS_OFFSET + 16 + SONG_LIST.LABEL.H*3, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
            {id = "barHcn"   , src = 0, x = 607, y = commons.PARTS_OFFSET + 16 + SONG_LIST.LABEL.H*4, w = SONG_LIST.LABEL.W, h = SONG_LIST.LABEL.H},
            -- トロフィー
            {id ="goldTrophy"  , src = 0, x = 1896, y = commons.PARTS_OFFSET + SONG_LIST.BAR.TROPHY.H*0, w = SONG_LIST.BAR.TROPHY.W, h = SONG_LIST.BAR.TROPHY.H},
            {id ="silverTrophy", src = 0, x = 1896, y = commons.PARTS_OFFSET + SONG_LIST.BAR.TROPHY.H*1, w = SONG_LIST.BAR.TROPHY.W, h = SONG_LIST.BAR.TROPHY.H},
            {id ="bronzeTrophy", src = 0, x = 1896, y = commons.PARTS_OFFSET + SONG_LIST.BAR.TROPHY.H*2, w = SONG_LIST.BAR.TROPHY.W, h = SONG_LIST.BAR.TROPHY.H},
        },
        text = {
            {id = "artist", font = 0, size = SONG_LIST.TEXT.ARTIST_SIZE, ref = 14, align = 2, overflow = 1},
            {id = "subArtist", font = 0, size = SONG_LIST.TEXT.SUBARTIST_SIZE, ref = 15, align = 2, overflow = 1},
            {id = "bartext", font = 0, size = SONG_LIST.BAR.FONT_SIZE, align = 2, overflow = 1},
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
        songlist = {
            id = "songlist",
            center = 8,
            clickable = {8},
            listoff = {},
            liston = {},
        }
    }

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
                {time = 0                 , x = posX + 800, y = posY, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H, acc = 2},
                {time = i * INTERVAL      , x = posX + 800, y = posY, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H, acc = 2},
                {time = 200 + i * INTERVAL, x = posX -  50, y = posY, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H, acc = 1},
                {time = 225 + i * INTERVAL, x = posX -  25, y = posY, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H, acc = 2},
                {time = 250 + i * INTERVAL, x = posX      , y = posY, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H, acc = 2}
            }
        })
        table.insert(skin.songlist.liston, {
            id = "bar", loop = 250 + i * INTERVAL,
            dst = {
                {time = 0                 , x = posX + 800, y = posY, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H, acc = 2},
                {time = i * INTERVAL      , x = posX + 800, y = posY, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H, acc = 2},
                {time = 200 + i * INTERVAL, x = posX -  50, y = posY, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H, acc = 1},
                {time = 225 + i * INTERVAL, x = posX -  25, y = posY, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H, acc = 2},
                {time = 250 + i * INTERVAL, x = posX      , y = posY, w = SONG_LIST.BAR.W, h = SONG_LIST.BAR.H, acc = 2}
            }
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
    --             {x = 146, y = 11, w = SONG_LIST.BAR.TROPHY.W, h = SONG_LIST.BAR.TROPHY.H}
    --         }
    --     },
    --     {
    --         id = "silverTrophy", dst = {
    --             {x = 146, y = 11, w = SONG_LIST.BAR.TROPHY.W, h = SONG_LIST.BAR.TROPHY.H}
    --         }
    --     },
    --     {
    --         id = "goldTrophy", dst = {
    --             {x = 146, y = 11, w = SONG_LIST.BAR.TROPHY.W, h = SONG_LIST.BAR.TROPHY.H}
    --         }
    --     },
    -- }

    -- 曲名等
    skin.songlist.text = {
        {
            id = "bartext", filter = 1,
            dst = {
                {x = 570, y = 21, w = 397, h = SONG_LIST.BAR.FONT_SIZE, r = 0, g = 0, b = 0, filter = 1}
            }
        },
        {
            id = "bartext", filter = 1,
            dst = {
                {x = 570, y = 21, w = 397, h = SONG_LIST.BAR.FONT_SIZE, r = 200, g = 0, b = 0, filter = 1}
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
                {x = lampPosX, y = lampPosY, w = SONG_LIST.LAMP.W, h = SONG_LIST.LAMP.H}
            }
        })
        table.insert(skin.songlist.playerlamp, 1, {
            id = "barLampRivalPlayer" .. lamp, dst = {
                {x = lampPosX, y = lampPosY + SONG_LIST.LAMP.H / 2, w = SONG_LIST.LAMP.W, h = SONG_LIST.LAMP.H / 2}
            }
        })
        table.insert(skin.songlist.rivallamp, 1, {
            id = "barLampRivalTarget" .. lamp, dst = {
                {x = lampPosX, y = lampPosY, w = SONG_LIST.LAMP.W, h = SONG_LIST.LAMP.H / 2}
            }
        })
    end

    return skin
end

songlist.functions.dst = function ()
    return {
        destination = {
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
                    {x = 1800, y = 543, w = 370, h = SONG_LIST.TEXT.ARTIST_SIZE, r = 0, g = 0, b = 0, filter = 1}
                }
            },
            {
                id = "subArtist", filter = 1, dst = {
                    {x = 1800, y = 516, w = 310, h = SONG_LIST.TEXT.SUBARTIST_SIZE, r = 0, g = 0, b = 0, filter = 1}
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