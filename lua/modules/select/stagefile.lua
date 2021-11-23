local commons = require("modules.select.commons")
local main_state = require("main_state")
local desktop = require("modules.commons.desktop")
local musicDetail = require("modules.commons.music_detail")
local difficultyEstimates = require("modules.commons.difficulty_estimates")

local stagefile = {
    estimate = {
        isDraw = false,
        oldTitle = "", -- 値キャッシュ用
        difficulties = nil -- cache
    },
    functions = {}
}

-- stage fileまわり
local STAGE_FILE = {
    X = 105,
    Y = 464,
    W = 640,
    H = 480,

    SHADOW = {
        X = function (self) return self.X - 12 end,
        Y = function (self) return self.Y - 12 end,
        W = 640,
        H = 480,
        A = 102,
    },
    FRAME = {
        X = function (self) return self.X + (self.W - self.FRAME.W) / 2 end,
        Y = function (self) return self.Y + (self.H - self.FRAME.H) / 2 end,
        W = 800,
        H = 600,
    },
    MASK = {
        FADEOUT_START = 200,
        FADEOUT_END = 300,
        ALPHA = 128,
    },
    EVENT = {
        TEXT = {
            X = function (self) return self.X + (4 + 29 * 2 + 4) end,
            Y = function (self) return self.Y + 3 end,
            W = 510,
            SIZE = 18,
        },
        OPEN_ICON = {
            X = function (self) return self.X + 4 end,
            Y = function (self) return self.Y + 2 end,
            W = 25,
            H = 25,
        },
        LIST_ICON = {
            X = function (self) return self.X + (4 + 29) end,
            Y = function (self) return self.Y + 2 end,
            W = 25,
            H = 25,
        }
    },
    MUSIC_ICON = {
        X = function (self) return self.X + (self.W - 29) end,
        Y = function (self) return self.Y + 2 end,
        W = 25,
        H = 25,
    },
    README_ICON = {
        X = function (self) return self.X + (self.W - 29 * 2) end,
        Y = function (self) return self.Y + 2 end,
        W = 25,
        H = 25,
    },
    ESTIMATE = {
        ALLOW = {Satellite = true, Stella = true},
        LAMPS = {"easy", "normal", "hard", "fc"},
        FRAME = {
            X = function (self) return self.X + 1 end,
            Y = function (self) return self.Y + 46 end,
            W = 100,
            H = 128,
        },
        NUM = {
            X = function (self) return self.ESTIMATE.FRAME.X(self) + 32 end,
            X_DOT = function (self) return self.ESTIMATE.NUM.X(self) + 21 end,
            X_AFTER_DOT = function (self) return self.ESTIMATE.NUM.X_DOT(self) + 3 end,
            Y = function (self) return self.ESTIMATE.FRAME.Y(self) + 11 end,
            Y_INTERVAL = 23,
            W = 11,
            H = 14,
        }
    }
}

stagefile.functions.load = function ()
    STAGE_FILE.MASK.FADEOUT_START = getStageFileMaskFadeOutStartTime()
    STAGE_FILE.MASK.FADEOUT_END = math.max(STAGE_FILE.MASK.FADEOUT_START, getStageFileMaskFadeOutEndTime())
    STAGE_FILE.MASK.ALPHA = getStageFileMaskAlpha()

    local skin = {
        image = {
            {id = "noImage", src = 7, x = 0, y = 0, w = -1, h = -1},
            {id = "stageFileMask", src = 20, x = 0, y = 0, w = -1, h = -1},
            {
                id = "openEventIcon", src = 0, x = 1408, y = PARTS_TEXTURE_SIZE - STAGE_FILE.EVENT.OPEN_ICON.H, w = STAGE_FILE.EVENT.OPEN_ICON.W, h = STAGE_FILE.EVENT.OPEN_ICON.H,
                act = function () desktop.openUrlByBrowser(musicDetail.getEventData().musicList) end
            },
            {
                id = "openMusicLinkIcon", src = 0, x = 1433, y = PARTS_TEXTURE_SIZE - STAGE_FILE.MUSIC_ICON.H, w = STAGE_FILE.MUSIC_ICON.W, h = STAGE_FILE.MUSIC_ICON.H,
                act = function () desktop.openUrlByBrowser(musicDetail.getMusicLink()) end
            },
            {
                id = "openEventSpecialPageIcon", src = 0, x = 1483, y = PARTS_TEXTURE_SIZE - STAGE_FILE.EVENT.LIST_ICON.H, w = STAGE_FILE.EVENT.LIST_ICON.W, h = STAGE_FILE.EVENT.LIST_ICON.H,
                act = function () desktop.openUrlByBrowser(musicDetail.getEventData().url) end
            },
            {id = "openReadmeIcon", src = 0, x = 1458, y = PARTS_TEXTURE_SIZE - STAGE_FILE.README_ICON.H, w = STAGE_FILE.README_ICON.W, h = STAGE_FILE.README_ICON.H, act = 17},
            -- estimate
            {id = "estimateFrame", src = 8, x = 792, y = 0, w = STAGE_FILE.ESTIMATE.FRAME.W, h = STAGE_FILE.ESTIMATE.FRAME.H},
            {id = "estimateDot", src = 8, x = 1013, y = 28, w = STAGE_FILE.ESTIMATE.NUM.W, h = STAGE_FILE.ESTIMATE.NUM.H},
            -- -0.xxのときにマイナスが出てこないので, それの描画用
            {id = "estimateMinus", src = 8, x = 1013, y = 14, w = STAGE_FILE.ESTIMATE.NUM.W, h = STAGE_FILE.ESTIMATE.NUM.H},
        },
        text = {
            {id = "eventName", font = 0, size = STAGE_FILE.EVENT.TEXT.SIZE*1.5, align = 0, overflow = 1, value = function () return musicDetail.getEventData().name end}
        },
        value = {},
        customTimers = {
            {id = 13200, timer = function()
                -- ソングバーでなければ終了
                if main_state.option(2) == false then
                    stagefile.estimate.isDraw = false
                    stagefile.estimate.difficulties = nil
                    return
                end

                -- 現在のフォルダ取得
                local path = main_state.text(1000)
                if path == "" then return end

                -- 階層取得
                local dirs = string.split(path, ">")
                if #dirs < 3 then return end -- ディレクトリ階層が浅い
                local tableName = string.trim(dirs[#dirs - 2])
                local tableLevel = string.trim(dirs[#dirs - 1])
                if not STAGE_FILE.ESTIMATE.ALLOW[tableName] then return end

                -- フルタイトル取得
                local title = main_state.text(12)
                -- cache済みは終了
                if title == stagefile.estimate.title then
                    return
                end
                stagefile.estimate.title = title

                -- estimate取得
                stagefile.estimate.difficulties = difficultyEstimates.getEstimateData(title, tableLevel)
                print("title:" .. title)
                if stagefile.estimate.difficulties then
                    print("easy " .. stagefile.estimate.difficulties.easy)
                    print("normal " .. stagefile.estimate.difficulties.normal)
                    print("hard " .. stagefile.estimate.difficulties.hard)
                    print("fc " .. stagefile.estimate.difficulties.fc)
                end
            end}
        }
    }
    local imgs = skin.image
    local vals = skin.value
    for i = 1, 6 do
        imgs[#imgs+1] = {
            id = "stageFileFrame" .. i, src = 4, x = 0, y = STAGE_FILE.FRAME.H * (i - 1), w = STAGE_FILE.FRAME.W, h = STAGE_FILE.FRAME.H
        }
    end
    -- 難易度推定
    for i, lamp in ipairs(STAGE_FILE.ESTIMATE.LAMPS) do
        vals[#vals+1] = {
            id = lamp .. "EstimateValue", src = 8, x = 892, y = 0, w = STAGE_FILE.ESTIMATE.NUM.W * 12, h = STAGE_FILE.ESTIMATE.NUM.H * 2, divx = 12, divy = 2, digit = 3, zeropadding = 0,
            value = function ()
                if not stagefile.estimate.difficulties then
                    return MIN_VALUE
                end
                local v = stagefile.estimate.difficulties[lamp]
                if v == "-" then
                    return MIN_VALUE
                end
                return v
            end
        }
        vals[#vals+1] = {
            id = lamp .. "EstimateValueAfterDot", src = 8, x = 892, y = 0, w = STAGE_FILE.ESTIMATE.NUM.W * 11, h = STAGE_FILE.ESTIMATE.NUM.H, divx = 11, divy = 1, digit = 2, zeropadding = 2,
            value = function ()
                if not stagefile.estimate.difficulties then
                    return MIN_VALUE
                end
                local v = stagefile.estimate.difficulties[lamp]
                if v == "-" then
                    return MIN_VALUE
                end
                v = math.abs(v)
                return math.floor(v * 100) - (math.floor(v) * 100)
            end
        }
    end
    return skin
end

stagefile.functions.dst = function ()
    local skin = {
        destination = {
            { -- stage file影
                id = "black", op = {2, 945}, dst = {
                    {x = STAGE_FILE.SHADOW.X(STAGE_FILE), y = STAGE_FILE.SHADOW.Y(STAGE_FILE), w = STAGE_FILE.SHADOW.W, h = STAGE_FILE.SHADOW.H, a = STAGE_FILE.SHADOW.A}
                }
            },
            -- stagefile黒背景
            {
                id = "black", op = {191, 2}, dst = {
                    {x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H, a = 255}
                }
            },
            -- no stagefile
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
                id = "stageFileMask", op = {2}, filter = 1, stretch = 1, dst = {
                    {x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H}
                }
            },
            -- イベントブラウザで開くアイコン
            {
                id = "openEventIcon", draw = function () return musicDetail.getEventData().musicList ~= "" and main_state.option(2) end, dst = {
                    {x = STAGE_FILE.EVENT.OPEN_ICON.X(STAGE_FILE), y = STAGE_FILE.EVENT.OPEN_ICON.Y(STAGE_FILE), w = STAGE_FILE.EVENT.OPEN_ICON.W, h = STAGE_FILE.EVENT.OPEN_ICON.H}
                }
            },
            {
                id = "openEventIcon", draw = function () return musicDetail.getEventData().musicList == "" and main_state.option(2) end, dst = {
                    {x = STAGE_FILE.EVENT.OPEN_ICON.X(STAGE_FILE), y = STAGE_FILE.EVENT.OPEN_ICON.Y(STAGE_FILE), w = STAGE_FILE.EVENT.OPEN_ICON.W, h = STAGE_FILE.EVENT.OPEN_ICON.H, a = 96}
                }
            },
            {
                id = "openEventSpecialPageIcon", draw = function () return musicDetail.getEventData().url ~= "" and main_state.option(2) end, dst = {
                    {x = STAGE_FILE.EVENT.LIST_ICON.X(STAGE_FILE), y = STAGE_FILE.EVENT.LIST_ICON.Y(STAGE_FILE), w = STAGE_FILE.EVENT.LIST_ICON.W, h = STAGE_FILE.EVENT.LIST_ICON.H}
                }
            },
            {
                id = "openEventSpecialPageIcon", draw = function () return musicDetail.getEventData().url == "" and main_state.option(2) end, dst = {
                    {x = STAGE_FILE.EVENT.LIST_ICON.X(STAGE_FILE), y = STAGE_FILE.EVENT.LIST_ICON.Y(STAGE_FILE), w = STAGE_FILE.EVENT.LIST_ICON.W, h = STAGE_FILE.EVENT.LIST_ICON.H, a = 96}
                }
            },
            -- 楽曲ブラウザで開くアイコン
            {
                id = "openMusicLinkIcon", draw = function () return musicDetail.getMusicLink() ~= "" and main_state.option(2) end, dst = {
                    {x = STAGE_FILE.MUSIC_ICON.X(STAGE_FILE), y = STAGE_FILE.MUSIC_ICON.Y(STAGE_FILE), w = STAGE_FILE.MUSIC_ICON.W, h = STAGE_FILE.MUSIC_ICON.H}
                }
            },
            {
                id = "openMusicLinkIcon", draw = function () return musicDetail.getMusicLink() == "" and main_state.option(2) end, dst = {
                    {x = STAGE_FILE.MUSIC_ICON.X(STAGE_FILE), y = STAGE_FILE.MUSIC_ICON.Y(STAGE_FILE), w = STAGE_FILE.MUSIC_ICON.W, h = STAGE_FILE.MUSIC_ICON.H, a = 96}
                }
            },
            -- readtext
            {
                id = "openReadmeIcon", op = {175, 2}, dst = {
                    {x = STAGE_FILE.README_ICON.X(STAGE_FILE), y = STAGE_FILE.README_ICON.Y(STAGE_FILE), w = STAGE_FILE.README_ICON.W, h = STAGE_FILE.README_ICON.H}
                }
            },
            {
                id = "openReadmeIcon", op = {176, 2}, dst = {
                    {x = STAGE_FILE.README_ICON.X(STAGE_FILE), y = STAGE_FILE.README_ICON.Y(STAGE_FILE), w = STAGE_FILE.README_ICON.W, h = STAGE_FILE.README_ICON.H, a = 96}
                }
            },
            -- イベント名
            {
                id = "eventName", op = {2}, filter = 1, dst = {
                    {x = STAGE_FILE.EVENT.TEXT.X(STAGE_FILE), y = STAGE_FILE.EVENT.TEXT.Y(STAGE_FILE), w = STAGE_FILE.EVENT.TEXT.W, h = STAGE_FILE.EVENT.TEXT.SIZE, r = 0, g = 0, b = 0}
                }
            },
            -- ステージファイルマスク(暗転)
            {
                id = "black", op = {{190, 191}, 2, 975}, timer = 11, loop = -1, dst = {
                    {time = 0, x = STAGE_FILE.X, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H, a =  STAGE_FILE.MASK.ALPHA},
                    {time = STAGE_FILE.MASK.FADEOUT_START, a = STAGE_FILE.MASK.ALPHA},
                    {time = STAGE_FILE.MASK.FADEOUT_END, a = 0}
                }
            },
        }
    }
    local dst = skin.destination
    for i = 1, 6 do
        dst[#dst+1] = {
            id = "stageFileFrame" .. i, op = {2, 150 + (i - 1)}, dst = {
                {x = STAGE_FILE.FRAME.X(STAGE_FILE), y = STAGE_FILE.FRAME.Y(STAGE_FILE), w = STAGE_FILE.FRAME.W, h = STAGE_FILE.FRAME.H}
            }
        }
    end

    -- 難易度推定
    do
        local isDrawEstimate = function() return stagefile.estimate.difficulties ~= nil end
        dst[#dst+1] = {
            id = "estimateFrame", draw = isDrawEstimate, dst = {
                {x = STAGE_FILE.ESTIMATE.FRAME.X(STAGE_FILE), y = STAGE_FILE.ESTIMATE.FRAME.Y(STAGE_FILE), w = STAGE_FILE.ESTIMATE.FRAME.W, h = STAGE_FILE.ESTIMATE.FRAME.H}
            }
        }
        for i, lamp in ipairs(STAGE_FILE.ESTIMATE.LAMPS) do
            local y = STAGE_FILE.ESTIMATE.NUM.Y(STAGE_FILE) + STAGE_FILE.ESTIMATE.NUM.Y_INTERVAL * (i - 1)
            dst[#dst+1] = {
                id = lamp .. "EstimateValue", draw = isDrawEstimate, dst = {
                    {x = STAGE_FILE.ESTIMATE.NUM.X(STAGE_FILE) - STAGE_FILE.ESTIMATE.NUM.W, y = y, w = STAGE_FILE.ESTIMATE.NUM.W, h = STAGE_FILE.ESTIMATE.NUM.H}
                }
            }
            dst[#dst+1] = {
                id = "estimateDot", draw = function() 
                    if not isDrawEstimate() then return false end
                    local lv = stagefile.estimate.difficulties[lamp]
                    if lv == "-" then return false end
                    return true
                end, dst = {
                    {x = STAGE_FILE.ESTIMATE.NUM.X_DOT(STAGE_FILE), y = y, w = STAGE_FILE.ESTIMATE.NUM.W, h = STAGE_FILE.ESTIMATE.NUM.H}
                }
            }
            dst[#dst+1] = {
                id = lamp .. "EstimateValueAfterDot", draw = isDrawEstimate, dst = {
                    {x = STAGE_FILE.ESTIMATE.NUM.X_AFTER_DOT(STAGE_FILE), y = y, w = STAGE_FILE.ESTIMATE.NUM.W, h = STAGE_FILE.ESTIMATE.NUM.H}
                }
            }
            -- -0.xxの場合にマイナスが出てこないので手動で
            dst[#dst+1] = {
                id = "estimateMinus", draw = function()
                    if not isDrawEstimate() then return false end
                    local lv = stagefile.estimate.difficulties[lamp]
                    if lv == "-" then return false end
                    return -1 < lv and lv < 0
                end,
                dst = {
                    {x = STAGE_FILE.ESTIMATE.NUM.X(STAGE_FILE), y = y, w = STAGE_FILE.ESTIMATE.NUM.W, h = STAGE_FILE.ESTIMATE.NUM.H}
                }
            }
        end
    end
    return skin
end

return stagefile.functions