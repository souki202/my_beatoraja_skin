require("modules.commons.define")
require("modules.result.commons")
local main_state = require("main_state")

local ranking = {
    numOfPlayer = 0,
    isHideName = false,
    maxScoreCache = 0,
    myScoreCache = 0,
    irFixedDisplayLimit = 3,
    isScrolled = false,

    irScoreCache = {},
    functions = {}
}

local RANKING = {
    WND = {
        X = RIGHT_X,
        Y = 116,
        W = 650,
        H = 698,
        SHADOW = 15,
    },
    ID_PREFIX = "ranking",
    IS_SHOW_PLAYER_NAME = true,
    TOP3 = {
        AREA = {
            X = function (self) return self.WND.X end,
            Y = function (self, idx) return self.WND.Y + 610 - 88 * (idx - 1) end,
        },
        SYMBOL = {
            W = 124,
            H = 78,
            X = function (self) return self.TOP3.AREA.X(self) + 7 end,
            Y = function (self, idx) return self.TOP3.AREA.Y(self, idx) + 5 end,
        },
        LAMP = {
            X = function (self) return self.TOP3.AREA.X(self) + 155 end,
            Y = function (self, idx) return self.TOP3.AREA.Y(self, idx) + 14 end,
            W = 111,
            H = 24,
        },
        NUM = {
            X = function (self) return self.TOP3.AREA.X(self) + 470 end,
            Y = function (self, idx) return self.TOP3.AREA.Y(self, idx) + 26 end,
            W = 28,
            H = 37,
        },
        DIFF = {
            X = function (self) return self.TOP3.AREA.X(self) + 585 end,
            Y = function (self, idx) return self.TOP3.AREA.Y(self, idx) + 27 end,
            -- w, hはNUMBERS_18PX
        },
        NAME = {
            X = function (self) return self.TOP3.AREA.X(self) + 157 end,
            Y = function (self, idx) return self.TOP3.AREA.Y(self, idx) + 42 end,
            W = 290,
            SIZE = 30,
        },
        OWN_BG = {
            X = function (self) return self.TOP3.AREA.X(self) end,
            Y = function (self, idx) return self.TOP3.AREA.Y(self, idx) end,
            W = 650,
            H = 88
        },
        RATE = {
            SIZE = 24,
            X = function (self) return self.TOP3.AREA.X(self) + 277 end,
            X_DOT = function (self) return self.TOP3.RATE.X(self) + 42 end,
            X_AF_DOT = function (self) return self.TOP3.RATE.X_DOT(self) + 5 end,
            X_PERCENT = function (self) return self.TOP3.RATE.X_AF_DOT(self) + 29 end,
            Y = function (self, idx) return self.TOP3.AREA.Y(self, idx) + 17 end,
            Y_SYMBOL = function (self, idx) return self.TOP3.RATE.Y(self, idx) - 6 end,
            -- w, hはNUMBERS_xxpx
        },
    },
    TOP10 = {
        AREA = {
            X = function (self) return self.WND.X end,
            Y = function (self, idx) return self.WND.Y + 372 - 62 * (idx - 4) end, -- idxはランクの値
        },
        SYMBOL = {
           W = 73,
           H = 33,
           X = function (self) return self.TOP10.AREA.X(self) + 31 end,
           Y = function (self, idx) return self.TOP10.AREA.Y(self, idx) + 16 end,
        },
        NUM = {
            X = function (self) return self.TOP10.AREA.X(self) + 508 end,
            Y = function (self, idx) return self.TOP10.AREA.Y(self, idx) + 18 end,
            W = 20,
            H = 26,
        },
        DIFF = {
            X = function (self) return self.TOP10.AREA.X(self) + 585 end,
            Y = function (self, idx) return self.TOP10.AREA.Y(self, idx) + 18 end,
            -- w, hはNUMBERS_18PX
        },
        LAMP = {
            X = function (self) return self.TOP10.AREA.X(self) + 155 end,
            Y = function (self, idx) return self.TOP10.AREA.Y(self, idx) + 8 end,
            W = 76,
            H = 18,
        },
        NAME = {
            X = function (self) return self.TOP10.AREA.X(self) + 157 end,
            Y = function (self, idx) return self.TOP10.AREA.Y(self, idx) + 27 end,
            W = 290,
            SIZE = 24,
        },
        OWN_BG = {
            X = function (self) return self.TOP10.AREA.X(self) end,
            Y = function (self, idx) return self.TOP10.AREA.Y(self, idx) end,
            W = 650,
            H = 62
        },
        RATE = {
            SIZE = 18,
            X = function (self) return self.TOP10.AREA.X(self) + 240 end,
            X_DOT = function (self) return self.TOP10.RATE.X(self) + 30 end,
            X_AF_DOT = function (self) return self.TOP10.RATE.X_DOT(self) + 5 end,
            X_PERCENT = function (self) return self.TOP10.RATE.X_AF_DOT(self) + 21 end,
            Y = function (self, idx) return self.TOP10.AREA.Y(self, idx) + 11 end,
            Y_SYMBOL = function (self, idx) return self.TOP10.RATE.Y(self, idx) - 5 end,
            -- w, hはNUMBERS_xxpx
        },
    },
    TOP3BG = {
        X = function (self) return self.TOP3.AREA.X(self) end,
        Y = function (self) return self.WND.Y + 434 end,
        W = 650,
        H = 264,
    },
    SCROLLED = {
        AREA = {
            X = function (self) return self.WND.X end,
            Y = function (self, idx) return self.WND.Y + 630 - 68.2 * (idx - 1) end, -- idxはランクの値
        },
        INDEX = {
            W = 21,
            H = 26,
            X = function (self) return self.SCROLLED.AREA.X(self) + 32 end,
            Y = function (self, idx) return self.SCROLLED.AREA.Y(self, idx) + 16 end,
         },
        NUM = {
            X = function (self) return self.SCROLLED.AREA.X(self) + 508 end,
            Y = function (self, idx) return self.SCROLLED.AREA.Y(self, idx) + 18 end,
            W = 20,
            H = 26,
        },
        DIFF = {
            X = function (self) return self.SCROLLED.AREA.X(self) + 585 end,
            Y = function (self, idx) return self.SCROLLED.AREA.Y(self, idx) + 18 end,
            -- w, hはNUMBERS_18PX
        },
        LAMP = {
            X = function (self) return self.SCROLLED.AREA.X(self) + 155 end,
            Y = function (self, idx) return self.SCROLLED.AREA.Y(self, idx) + 8 end,
            W = 76,
            H = 18,
        },
        NAME = {
            X = function (self) return self.SCROLLED.AREA.X(self) + 157 end,
            Y = function (self, idx) return self.SCROLLED.AREA.Y(self, idx) + 27 end,
            W = 290,
            SIZE = 24,
        },
        OWN_BG = {
            X = function (self) return self.SCROLLED.AREA.X(self) end,
            Y = function (self, idx) return self.SCROLLED.AREA.Y(self, idx) end,
            W = 650,
            H = 62
        },
        RATE = {
            SIZE = 18,
            X = function (self) return self.SCROLLED.AREA.X(self) + 240 end,
            X_DOT = function (self) return self.SCROLLED.RATE.X(self) + 30 end,
            X_AF_DOT = function (self) return self.SCROLLED.RATE.X_DOT(self) + 5 end,
            X_PERCENT = function (self) return self.SCROLLED.RATE.X_AF_DOT(self) + 21 end,
            Y = function (self, idx) return self.SCROLLED.AREA.Y(self, idx) + 11 end,
            Y_SYMBOL = function (self, idx) return self.SCROLLED.RATE.Y(self, idx) - 5 end,
            -- w, hはNUMBERS_xxpx
        },

    },
    PRIVACY = {
        X = function (self) return self.WND.X + self.WND.W + 7 end, -- 2pで関数上書き
        Y = function (self) return self.WND.Y end,
        W = 36,
        H = 36,
    },
}

ranking.functions.change2p = function ()
    RANKING.WND.X = LEFT_X
    RANKING.PRIVACY.X = function (self) return self.WND.X - 7 - self.PRIVACY.W end
end

ranking.functions.load = function (isShowRankingFunc)
    ranking.functions.isShowRanking = isShowRankingFunc
    RANKING.IS_SHOW_PLAYER_NAME = isShowOwnPlayerNameInRanking()
    if not isSimpleRankingInformation() then
        RANKING.TOP3.NUM.X = function (self) return self.TOP3.AREA.X(self) + 440 end
        RANKING.TOP10.NUM.X = function (self) return self.TOP10.AREA.X(self) + 480 end
        RANKING.SCROLLED.NUM.X = function (self) return self.TOP10.AREA.X(self) + 480 end
    end
    local getNum = main_state.number
    ranking.maxScoreCache = getNum(74) * 2
    ranking.myScoreCache = math.max(getNum(150), getNum(71))

    local skin = {
        image = {
            -- スコアグラフを隠すための背景
            {id = "graphMaskBg", src = getBgSrc(), x = RANKING.WND.X - RANKING.WND.SHADOW, y = HEIGHT - RANKING.WND.Y - RANKING.WND.H - RANKING.WND.SHADOW, w = RANKING.WND.W + RANKING.WND.SHADOW*2, h = RANKING.WND.H + RANKING.WND.SHADOW*2},
            {id = "rankInTop3Bg", src = 5, x = 0, y = 0, w = RANKING.TOP3.OWN_BG.W, h = RANKING.TOP3.OWN_BG.H},
            {id = "rankInBg", src = 5, x = 0, y = RANKING.TOP3.OWN_BG.H, w = RANKING.TOP10.OWN_BG.W, h = RANKING.TOP10.OWN_BG.H},
            {id = "rankTop3Bg", src = 5, x = 0, y = RANKING.TOP3.OWN_BG.H + RANKING.TOP10.OWN_BG.H, w = RANKING.TOP3BG.W, h = RANKING.TOP3BG.H},
            {id = "privacyButton", src = 4, x = 0, y = 297, w = RANKING.PRIVACY.W, h = RANKING.PRIVACY.H, act = function () ranking.isHideName = not ranking.isHideName end},
        },
        imageset = {},
        value = {},
        text = {
            {id = "24pxPercent", font = 0, size = RANKING.TOP3.RATE.SIZE * 2, constantText = "%"},
            {id = "18pxPercent", font = 0, size = RANKING.TOP10.RATE.SIZE * 2, constantText = "%"},
            {id = "24pxDot", font = 0, size = RANKING.TOP3.RATE.SIZE * 2, constantText = "."},
            {id = "18pxDot", font = 0, size = RANKING.TOP10.RATE.SIZE * 2, constantText = "."},
        },
        customTimers = {
            {
                id = 10200, timer = function ()
                    -- 複数回更新されたりするので常時取得に一旦変更
                    ranking.numOfPlayer = getNum(180)
                    -- if ranking.numOfPlayer == nil or ranking.numOfPlayer == 0 then
                    --     ranking.numOfPlayer = main_state.number(180)
                    -- end

                    -- スコアレートは複数回使うので計算してキャッシュ
                    for i = 1, 10 do
                        ranking.irScoreCache[i] = getNum(380 + (i - 1))
                    end

                    -- スクロールしているか調べる
                    ranking.isScrolled = false
                    for i = 1, 10 do
                        ranking.isScrolled = ranking.isScrolled or (main_state.number(389 + i) > i)
                    end
                    return 1
                end
            },
        }
    }
    local imgs = skin.image
    local imagesets = skin.imageset
    local largeLamps = {}
    local smallLamps = {}
    local vals = skin.value
    local texts = skin.text
    -- 各ランクのランプ用imagesetを作成
    for i = 1, 11 do
        local lid = RANKING.ID_PREFIX .. "LampLargeType" .. i
        local sid = RANKING.ID_PREFIX .. "LampSmallType" .. i
        imgs[#imgs+1] = {id = lid, src = 0, x = 845 + RANKING.TOP10.LAMP.W, y = 264 + RANKING.TOP3.LAMP.H * (i - 1), w = RANKING.TOP3.LAMP.W, h = RANKING.TOP3.LAMP.H}
        imgs[#imgs+1] = {id = sid, src = 0, x = 845, y = 198 + RANKING.TOP10.LAMP.H * (i - 1), w = RANKING.TOP10.LAMP.W, h = RANKING.TOP10.LAMP.H}
        largeLamps[i] = lid
        smallLamps[i] = sid
    end

    -- ランキングのスコアやスコアレートなど TOP3
    for i = 1, 3 do
        imgs[#imgs+1] = {id = RANKING.ID_PREFIX .. i .. "Symbol", src = 4, x = 0, y = RANKING.TOP3.SYMBOL.H * (i - 1), w = RANKING.TOP3.SYMBOL.W, h = RANKING.TOP3.SYMBOL.H}
        imagesets[#imagesets+1] = {id = RANKING.ID_PREFIX .. i .. "Lamp", ref = 390 + (i - 1), images = largeLamps}
        vals[#vals+1] = {id = RANKING.ID_PREFIX .. i .. "ExScore", src = 4, x = 0, y = 234, w = RANKING.TOP3.NUM.W * 10, h = RANKING.TOP3.NUM.H, divx = 10, ref = 380 + (i - 1), digit = 5}
        vals[#vals+1] = {
            id = RANKING.ID_PREFIX .. i .. "Diff", src = 4, x = 0, y = 333, w = NUMBERS_18PX.W * 12, h = NUMBERS_18PX.H * 2, divx = 12, divy = 2, digit = 5,
            value = function ()
                local s = ranking.irScoreCache[i]
                if s > 0 then
                    return ranking.myScoreCache - s
                end
                return 0x80000000
            end
        }
        vals[#vals+1] = {
            id = RANKING.ID_PREFIX .. i .. "Percentage", src = 0, x = 1880, y = 185, w = NUMBERS_24PX.W * 10, h = NUMBERS_24PX.H, divx = 10, digit = 3, value = function ()
                local s = ranking.irScoreCache[i]
                if s > 0 and ranking.maxScoreCache > 0 then
                    return math.floor(100 * s / ranking.maxScoreCache)
                end
            end
        }
        vals[#vals+1] = {
            id = RANKING.ID_PREFIX ..i .. "PercentageAfterDot", src = 0, x = 1880, y = 185, w = NUMBERS_24PX.W * 10, h = NUMBERS_24PX.H, divx = 10, digit = 2, padding = 1, value = function ()
                local s = ranking.irScoreCache[i]
                if s > 0 and ranking.maxScoreCache > 0 then
                    return math.floor(100 * s / ranking.maxScoreCache * 100) % 100
                end
            end
        }
        texts[#texts+1] = {id = RANKING.ID_PREFIX .. i .. "Name", font = 0, size = RANKING.TOP3.NAME.SIZE, ref = 120 + (i - 1), overflow = 1}
        texts[#texts+1] = {id = RANKING.ID_PREFIX .. i .. "PlayerName", font = 0, size = RANKING.TOP3.NAME.SIZE, ref = 2, overflow = 1}
        texts[#texts+1] = {id = RANKING.ID_PREFIX .. i .. "AnonymousName", font = 0, size = RANKING.TOP3.NAME.SIZE, constantText = "Anonymous", overflow = 1}
    end
    -- ランキングのスコアやスコアレートなど TOP4~10
    for i = 1, 10 do
        if i > 3 then
            imgs[#imgs+1] = {id = RANKING.ID_PREFIX .. i .. "Symbol", src = 4, x = 124, y = RANKING.TOP10.SYMBOL.H * (i - 4), w = RANKING.TOP10.SYMBOL.W, h = RANKING.TOP10.SYMBOL.H}
        end
        imagesets[#imagesets+1] = {id = RANKING.ID_PREFIX .. i .. "SmallLamp", ref = 390 + i - 1, images = smallLamps}
        vals[#vals+1] = {id = RANKING.ID_PREFIX .. i .. "SmallExScore", src = 4, x = 0, y = 271, w = RANKING.TOP10.NUM.W * 10, h = RANKING.TOP10.NUM.H, divx = 10, ref = 380 + i - 1, digit = 5}
        vals[#vals+1] = {
            id = RANKING.ID_PREFIX .. i .. "SmallDiff", src = 4, x = 0, y = 333 + 26, w = NUMBERS_18PX.W * 12, h = NUMBERS_18PX.H * 2, divx = 12, divy = 2, digit = 5,
            value = function ()
                local s = ranking.irScoreCache[i]
                if s > 0 then
                    return ranking.myScoreCache - s
                end
                return 0x80000000
            end
        }
        vals[#vals+1] = {
            id = RANKING.ID_PREFIX .. i .. "SmallPercentage", src = 0, x = 1928, y = 392, w = NUMBERS_18PX.W * 10, h = NUMBERS_18PX.H, divx = 10, digit = 3, value = function ()
                local s = ranking.irScoreCache[i]
                if s > 0 and ranking.maxScoreCache > 0 then
                    return math.floor(100 * s / ranking.maxScoreCache)
                end
                return 0x80000000
            end
        }
        vals[#vals+1] = {
            id = RANKING.ID_PREFIX .. i .. "SmallPercentageAfterDot", src = 0, x = 1928, y = 392, w = NUMBERS_18PX.W * 10, h = NUMBERS_18PX.H, divx = 10, digit = 2, padding = 1, value = function ()
                local s = ranking.irScoreCache[i]
                if s > 0 and ranking.maxScoreCache > 0 then
                    return math.floor(100 * s / ranking.maxScoreCache * 100) % 100
                end
            end
        }
        texts[#texts+1] = {id = RANKING.ID_PREFIX .. i .. "SmallName", font = 0, size = RANKING.TOP10.NAME.SIZE, ref = 120 + i - 1, overflow = 1}
        texts[#texts+1] = {id = RANKING.ID_PREFIX .. i .. "SmallPlayerName", font = 0, size = RANKING.TOP10.NAME.SIZE, ref = 2, overflow = 1}
        texts[#texts+1] = {id = RANKING.ID_PREFIX .. i .. "SmallAnonymousName", font = 0, size = RANKING.TOP10.NAME.SIZE, constantText = "Anonymous", overflow = 1}
    end

    -- スクロール時の順位表示
    for i = 1, 10 do
        vals[#vals+1] = {id = RANKING.ID_PREFIX .. i .. "Index", src = 0, x = 1817, y = 405, w = RANKING.SCROLLED.INDEX.W * 11, h = RANKING.SCROLLED.INDEX.H, divx = 11, divy = 1, digit = 5, ref = 390 + i - 1, space = -1}
    end

    return skin
end

--[[
    ランキングのユーザを1つ出力する. 順位はここでは出力しない
    
    @param rank 描画位置
    @param param 描画に必要な座標パラメータ群
    @param isDrawSelfRankFunc 自分自身のランクとして描画
    @param isDrawOtherRankFunc 他者のランクとして描画
    @param isDrawFunc 描画するか
]]
ranking.functions.dstARank = function(index, params, isDrawSelfRankFunc, isDrawOtherRankFunc, isDrawFunc)
    local skin = {destination = {}}
    local dst = skin.destination

    -- 自分のランクなら目印をつける
    dst[#dst+1] = {
        id = "rankInBg", draw = function () return isDrawSelfRankFunc(index) end, dst = {
            {x = params.OWN_BG.X(RANKING), y = params.OWN_BG.Y(RANKING, index), w = params.OWN_BG.W, h = params.OWN_BG.H}
        }
    }

    -- 自分以外の名前
    dst[#dst+1] = {
        id = RANKING.ID_PREFIX .. index .. "SmallAnonymousName", draw = function () return isDrawOtherRankFunc(index) and ranking.isHideName end, dst = {
            {x = params.NAME.X(RANKING), y = params.NAME.Y(RANKING, index), w = params.NAME.W, h = params.NAME.SIZE, r = 0, g = 0, b = 0}
        }
    }
    dst[#dst+1] = {
        id = RANKING.ID_PREFIX .. index .. "SmallName", draw = function () return isDrawOtherRankFunc(index) and ranking.isHideName == false end, dst = {
            {x = params.NAME.X(RANKING), y = params.NAME.Y(RANKING, index), w = params.NAME.W, h = params.NAME.SIZE, r = 0, g = 0, b = 0}
        }
    }

    -- 自分の名前
    if RANKING.IS_SHOW_PLAYER_NAME then
        dst[#dst+1] = {
            id = RANKING.ID_PREFIX .. index .. "SmallPlayerName", draw = function () return isDrawSelfRankFunc(index) end, dst = {
                {x = params.NAME.X(RANKING), y = params.NAME.Y(RANKING, index), w = params.NAME.W, h = params.NAME.SIZE, r = 0, g = 0, b = 0}
            }
        }
    else
        dst[#dst+1] = {
            id = RANKING.ID_PREFIX .. index .. "SmallName", draw = function () return isDrawSelfRankFunc(index) end, dst = {
                {x = params.NAME.X(RANKING), y = params.NAME.Y(RANKING, index), w = params.NAME.W, h = params.NAME.SIZE, r = 0, g = 0, b = 0}
            }
        }
    end

    dst[#dst+1] = {
        id = RANKING.ID_PREFIX .. index .. "SmallExScore", draw = function () return isDrawFunc(index) end, dst = {
            {x = params.NUM.X(RANKING), y = params.NUM.Y(RANKING, index), w = params.NUM.W, h = params.NUM.H, r = 255, g = 0, b = 102}
        }
    }

    if not isSimpleRankingInformation() then
        -- RATEは黒のみ
        dst[#dst+1] = {
            id = RANKING.ID_PREFIX .. index .. "SmallPercentage", draw = function () return isDrawFunc(index) end, dst = {
                {x = params.RATE.X(RANKING), y = params.RATE.Y(RANKING, index), w = NUMBERS_18PX.W, h = NUMBERS_18PX.H, r = 0, g = 0, b = 0}
            }
        }
        dst[#dst+1] = {
            id = "18pxDot", filter = 1, draw = function () return isDrawFunc(index) end, dst = {
                {x = params.RATE.X_DOT(RANKING), y = params.RATE.Y_SYMBOL(RANKING, index), w = 8, h = params.RATE.SIZE, r = 0, g = 0, b = 0}
            }
        }
        dst[#dst+1] = {
            id = RANKING.ID_PREFIX .. index .. "SmallPercentageAfterDot", draw = function () return isDrawFunc(index) end, dst = {
                {x = params.RATE.X_AF_DOT(RANKING), y = params.RATE.Y(RANKING, index), w = NUMBERS_18PX.W, h = NUMBERS_18PX.H, r = 0, g = 0, b = 0}
            }
        }
        dst[#dst+1] = {
            id = "18pxPercent", filter = 1, draw = function () return isDrawFunc(index) end, dst = {
                {x = params.RATE.X_PERCENT(RANKING), y = params.RATE.Y_SYMBOL(RANKING, index), w = 24, h = params.RATE.SIZE, r = 0, g = 0, b = 0}
            }
        }
        -- スコア差分
        dst[#dst+1] = {
            id = RANKING.ID_PREFIX .. index .. "SmallDiff", draw = function () return isDrawOtherRankFunc(index) end, dst = {
                {x = params.DIFF.X(RANKING), y = params.DIFF.Y(RANKING, index), w = NUMBERS_18PX.W, h = NUMBERS_18PX.H}
            }
        }
    end

    dst[#dst+1] = {
        id = RANKING.ID_PREFIX .. index .. "SmallLamp", draw = function () return isDrawFunc(index) end, dst = {
            {x = params.LAMP.X(RANKING), y = params.LAMP.Y(RANKING, index), w = params.LAMP.W, h = params.LAMP.H}
        }
    }

    return skin
end

ranking.functions.dstMaskBg = function ()
    return {
        destination = {
            {
                id = "graphMaskBg", draw = ranking.functions.isShowRanking, dst = {
                    {x = RANKING.WND.X - RANKING.WND.SHADOW, y = RANKING.WND.Y - RANKING.WND.SHADOW, w = RANKING.WND.W + RANKING.WND.SHADOW*2, h = RANKING.WND.H + RANKING.WND.SHADOW*2}
                }
            }
        }
    }
end

ranking.functions.isSelfRank = function (targetRank, playerName)
    local selfRank = main_state.number(179)
    if selfRank == nil then return false end
    return selfRank == targetRank and playerName == "YOU"
end

ranking.functions.dst = function ()
    local skin = {destination = {}}
    local isDrawFunc = function (rank)
        if ranking.numOfPlayer ~= nil and ranking.numOfPlayer >= rank then
            return ranking.functions.isShowRanking()
        end
        return false
    end
    destinationStaticWindowBg(skin, RESULT_BASE_WINDOW.ID, RANKING.WND.X, RANKING.WND.Y, RANKING.WND.W, RANKING.WND.H, RESULT_BASE_WINDOW.EDGE_SIZE, RESULT_BASE_WINDOW.SHADOW_LEN, {}, ranking.functions.isShowRanking)
    local dst = skin.destination

    local isViewTop10 = function () return ranking.isScrolled == false end

    -- top3部分の背景を描画
    dst[#dst+1] = {
        id = "rankTop3Bg", draw = function () return isDrawFunc(0) and isViewTop10() end, dst = {
            {x = RANKING.TOP3BG.X(RANKING), y = RANKING.TOP3BG.Y(RANKING), w = RANKING.TOP3BG.W, h = RANKING.TOP3BG.H}
        }
    }

    -- top10表示時
    do
        for i = 1, 10 do
            local params = RANKING.TOP3
            if i > 3 then
                params = RANKING.TOP10
            end

            local isSelfRank = function () return ranking.functions.isSelfRank(main_state.number(390 + i - 1), main_state.text(120 + i - 1)) end

            local isDrawSelfRankInner = function () return isDrawFunc(i) and isSelfRank() and isViewTop10() end
            local isDrawOtherRankInner = function () return isDrawFunc(i) and not isSelfRank() and isViewTop10() end
            local isDrawFuncInner = function () return isDrawFunc(i) and isViewTop10() end

            if i <= 3 then
                dst[#dst+1] = {
                    id = "rankInTop3Bg", draw = function () return isDrawSelfRankInner() end, dst = {
                        {x = params.OWN_BG.X(RANKING), y = params.OWN_BG.Y(RANKING, i), w = params.OWN_BG.W, h = params.OWN_BG.H}
                    }
                }
                -- 自分以外の名前
                dst[#dst+1] = {
                    id = RANKING.ID_PREFIX .. i .. "Name", draw = function () return isDrawOtherRankInner() and ranking.isHideName == false end, dst = {
                        {x = params.NAME.X(RANKING), y = params.NAME.Y(RANKING, i), w = params.NAME.W, h = params.NAME.SIZE}
                    }
                }
                dst[#dst+1] = {
                    id = RANKING.ID_PREFIX .. i .. "AnonymousName", draw = function () return isDrawOtherRankInner() and ranking.isHideName end, dst = {
                        {x = params.NAME.X(RANKING), y = params.NAME.Y(RANKING, i), w = params.NAME.W, h = params.NAME.SIZE}
                    }
                }
                -- 自分の名前
                if RANKING.IS_SHOW_PLAYER_NAME then
                    dst[#dst+1] = {
                        id = RANKING.ID_PREFIX .. i .. "PlayerName", draw = function () return isDrawSelfRankInner() end, dst = {
                            {x = params.NAME.X(RANKING), y = params.NAME.Y(RANKING, i), w = params.NAME.W, h = params.NAME.SIZE, r = 0, g = 0, b = 0}
                        }
                    }
                else
                    dst[#dst+1] = {
                        id = RANKING.ID_PREFIX .. i .. "Name", draw = function () return isDrawSelfRankInner() end, dst = {
                            {x = params.NAME.X(RANKING), y = params.NAME.Y(RANKING, i), w = params.NAME.W, h = params.NAME.SIZE, r = 0, g = 0, b = 0}
                        }
                    }
                end
                dst[#dst+1] = {
                    id = RANKING.ID_PREFIX .. i .. "ExScore", draw = function () return isDrawOtherRankInner() end, dst = {
                        {x = params.NUM.X(RANKING), y = params.NUM.Y(RANKING, i), w = params.NUM.W, h = params.NUM.H, r = 255, g = 213, b = 230}
                    }
                }
                dst[#dst+1] = {
                    id = RANKING.ID_PREFIX .. i .. "ExScore", draw = function () return isDrawSelfRankInner() end, dst = {
                        {x = params.NUM.X(RANKING), y = params.NUM.Y(RANKING, i), w = params.NUM.W, h = params.NUM.H, r = 255, g = 0, b = 102}
                    }
                }
                if not isSimpleRankingInformation() then
                    -- 他人は白
                    dst[#dst+1] = {
                        id = RANKING.ID_PREFIX .. i .. "Percentage", draw = function () return isDrawOtherRankInner() end, dst = {
                            {x = params.RATE.X(RANKING), y = params.RATE.Y(RANKING, i), w = NUMBERS_24PX.W, h = NUMBERS_24PX.H}
                        }
                    }
                    dst[#dst+1] = {
                        id = "24pxDot", filter = 1, draw = function () return isDrawOtherRankInner() end, dst = {
                            {x = params.RATE.X_DOT(RANKING), y = params.RATE.Y_SYMBOL(RANKING, i), w = 8, h = params.RATE.SIZE}
                        }
                    }
                    dst[#dst+1] = {
                        id = RANKING.ID_PREFIX .. i .. "PercentageAfterDot", draw = function () return isDrawOtherRankInner() end, dst = {
                            {x = params.RATE.X_AF_DOT(RANKING), y = params.RATE.Y(RANKING, i), w = NUMBERS_24PX.W, h = NUMBERS_24PX.H}
                        }
                    }
                    dst[#dst+1] = {
                        id = "24pxPercent", filter = 1, draw = function () return isDrawOtherRankInner() end, dst = {
                            {x = params.RATE.X_PERCENT(RANKING), y = params.RATE.Y_SYMBOL(RANKING, i), w = 24, h = params.RATE.SIZE}
                        }
                    }
                    -- 自分のときは黒
                    dst[#dst+1] = {
                        id = RANKING.ID_PREFIX .. i .. "Percentage", draw = function () return isDrawSelfRankInner() end, dst = {
                            {x = params.RATE.X(RANKING), y = params.RATE.Y(RANKING, i), w = NUMBERS_24PX.W, h = NUMBERS_24PX.H, r = 0, g = 0, b = 0}
                        }
                    }
                    dst[#dst+1] = {
                        id = "24pxDot", filter = 1, draw = function () return isDrawSelfRankInner() end, dst = {
                            {x = params.RATE.X_DOT(RANKING), y = params.RATE.Y_SYMBOL(RANKING, i), w = 8, h = params.RATE.SIZE, r = 0, g = 0, b = 0}
                        }
                    }
                    dst[#dst+1] = {
                        id = RANKING.ID_PREFIX .. i .. "PercentageAfterDot", draw = function () return isDrawSelfRankInner() end, dst = {
                            {x = params.RATE.X_AF_DOT(RANKING), y = params.RATE.Y(RANKING, i), w = NUMBERS_24PX.W, h = NUMBERS_24PX.H, r = 0, g = 0, b = 0}
                        }
                    }
                    dst[#dst+1] = {
                        id = "24pxPercent", filter = 1, draw = function () return isDrawSelfRankInner() end, dst = {
                            {x = params.RATE.X_PERCENT(RANKING), y = params.RATE.Y_SYMBOL(RANKING, i), w = 24, h = params.RATE.SIZE, r = 0, g = 0, b = 0}
                        }
                    }
                    dst[#dst+1] = {
                        id = RANKING.ID_PREFIX .. i .. "Diff", draw = function () return isDrawOtherRankInner() end, dst = {
                            {x = params.DIFF.X(RANKING), y = params.DIFF.Y(RANKING, i), w = NUMBERS_18PX.W, h = NUMBERS_18PX.H}
                        }
                    }
                end
                dst[#dst+1] = {
                    id = RANKING.ID_PREFIX .. i .. "Lamp", draw = function () return isDrawFuncInner() end, dst = {
                        {x = params.LAMP.X(RANKING), y = params.LAMP.Y(RANKING, i), w = params.LAMP.W, h = params.LAMP.H}
                    }
                }
            else
                mergeSkin(skin, ranking.functions.dstARank(i, params, isDrawSelfRankInner, isDrawOtherRankInner, isDrawFuncInner))
            end
            dst[#dst+1] = {
                id = RANKING.ID_PREFIX .. i .. "Symbol", draw = function () return isDrawFuncInner() end, dst = {
                    {x = params.SYMBOL.X(RANKING), y = params.SYMBOL.Y(RANKING, i), w = params.SYMBOL.W, h = params.SYMBOL.H}
                }
            }
        end
    end

    -- スクロール時のランキング
    do
        local params = RANKING.SCROLLED
        for i = 1, 10 do
            local drawRank = main_state.number(390 + i - 1)
            local isSelfRank = function () return ranking.functions.isSelfRank(main_state.number(390 + i - 1), main_state.text(120 + i - 1)) end

            local isDrawSelfRank = function () return isDrawFunc(i) and isSelfRank() and not isViewTop10() end
            local isDrawOtherRank = function () return isDrawFunc(i) and not isSelfRank() and not isViewTop10() end
            local isDrawFuncInner = function () return isDrawFunc(i) and not isViewTop10() end

            mergeSkin(skin, ranking.functions.dstARank(i, params, isDrawSelfRank, isDrawOtherRank, isDrawFuncInner))
            dst[#dst+1] = {
                id = RANKING.ID_PREFIX .. i .. "Index", draw = function () return isDrawFuncInner() end, dst = {
                    {x = params.INDEX.X(RANKING), y = params.INDEX.Y(RANKING, i), w = params.INDEX.W, h = params.INDEX.H}
                }
            }

        end
    end

    -- プライバシーボタン
    dst[#dst+1] = {
        id = "privacyButton", draw = function () return isDrawFunc(0) end, dst = {
            {x = RANKING.PRIVACY.X(RANKING), y = RANKING.PRIVACY.Y(RANKING), w = RANKING.PRIVACY.W, h = RANKING.PRIVACY.H}
        }
    }
    return skin
end

return ranking.functions