require("modules.commons.define")
require("modules.commons.easing")
require("modules.result.commons")
require("modules.result2.commons")
local main_state = require("main_state")
local judges = require("modules.result2.judges")
local scoreDetail = require("modules.result2.score_detail")

local VIEW_TYPES = {
    RANKING = 1, LAMPS = 2
}

local ranking = {
    numOfPlayers = 0,
    isOpened = false,
    viewType = VIEW_TYPES.RANKING,
    timeForWindow = 9999999,
    openTime = 0,
    isDrawRankCache = {},
    isScrolled = false,
    functions = {}
}

local RANKING = {
    AREA = {
        X = WIDTH / 2,
        Y = 0,
        W = WIDTH / 2,
        SHADOW_W = 1005,
        H = HEIGHT,
        DIMMER_ALPHA = 90,
    },
    SWITCH_AREA = {
        X = WIDTH / 2,
        Y = 0,
        W = WIDTH / 2,
        H = 490,
    },
    HEADER = {
        W = WIDTH / 2,
        H = 45,
        X = function (self) return self.AREA.X end,
        Y = function (self) return self.AREA.Y + 1020 end,
    },
    RANK = {
        OLD = {
            -- w, h, spaceはjudges.getSmallNumSize()する
            X = function (self) return self.AREA.X + 298 - 15 - 5 * (judges.getSmallNumSize().W + judges.getSmallNumSize().SPACE) end,
            Y = function (self) return self.AREA.Y + 946 end,
        },
        ARROW = {
            X = function (self) return self.AREA.X + 338 end,
            Y = function (self) return self.AREA.Y + 946 end,
            W = 43,
            H = 57,
        },
        NOW = {
            -- w, h, spaceはjudges.getLargeNumSize()する
            X = function (self) return self.AREA.X + 602 - 5 * (judges.getLargeNumSize().W + judges.getLargeNumSize().SPACE) + 5 end,
            Y = function (self) return self.AREA.Y + 944 end,
        },
        SLUSH = {
            -- w, h, spaceはjudges.getSmallNumSize()する
            X = function (self) return self.AREA.X + 616 end,
            Y = function (self) return self.AREA.Y + 944 end,
        },
        PLAYERS = {
            -- w, h, spaceはjudges.getSmallNumSize()する
            X = function (self) return self.AREA.X + 785 - 15 - 5 * (judges.getSmallNumSize().W + judges.getSmallNumSize().SPACE) end,
            Y = function (self) return self.AREA.Y + 946 end,
        },
    },
    GRAPH = {
        AREA = {
            X = function (self) return self.AREA.X + 360 end,
            Y = function (self) return self.AREA.Y + 30 end,
            W = 580,
            H = 880,
        },
        SCORERANK_LINE = {
            -- AAA 1, AA 2, ... F 8
            X = function (self, scoreRank) return self.GRAPH.AREA.X(self) + self.GRAPH.AREA.W * (1 - 0.11111 * scoreRank) end,
            Y = function (self) return self.GRAPH.AREA.Y(self) end,
            W = 1,
            H = 880,
            ALPHA = 90,
        },
        DIMMER_ALPHA = 90,
        LINE = {
            Y = function (self, idx) return self.GRAPH.AREA.Y(self) + 800 - self.GRAPH.LINE.INTERVAL_Y * (idx - 1) end,
            ORDER = {
                X = function (self) return self.AREA.X + 16 end,
                Y = function (self, idx) return self.GRAPH.LINE.Y(self, idx) + 35 end,
                W = 15,
                H = 21,
            },
            NAME = {
                X = function (self) return self.AREA.X + 110 end,
                Y = function (self, idx) return self.GRAPH.LINE.Y(self, idx) + 26 end,
                W = 207,
                FONT_SIZE = 36,
            },
            SCORE = {
                X = function (self) return self.GRAPH.AREA.X(self) + 8 end,
                Y = function (self, idx) return self.GRAPH.LINE.GAUGE.Y(self, idx) + 7 end,
                W = 24,
                H = 31,
                SPACE = -8,
            },
            DIFF = {
                X = function (self) return self.GRAPH.AREA.X(self) + 8 end,
                Y = function (self, idx) return self.GRAPH.LINE.Y(self, idx) + 3 end,
                W = 24,
                H = 31,
                SPACE = -8,
            },
            GAUGE = {
                X = function (self) return self.GRAPH.AREA.X(self) end,
                Y = function (self, idx) return self.GRAPH.LINE.Y(self, idx) + 29 end,
                W = 580,
                H = 47,
                ALPHA = 180,
            },
            INTERVAL_Y = 80,
        },
    },
    THEORETICAL = 0,
    MY_BEST_SCORE = 0,
    IS_SHOW_PLAYER_NAME = false,
    ANIMATION = {
        MOVE_TIME = 200,
        CLOSE_TIME = 1000000,
        MAX_TIME = 100000000,

        GAUGE_APPEAR_WAIT = 500,
        GAUGE_APPEAR_ANIMATION_END = 1000,
        SCORE_GRAPH_PER_W = 1000,
    },
}

local LAMPS = {
    AREA = RANKING.AREA,
    LABEL = {
        X = function () return RANKING.AREA.X + 70 end,
        Y = function (idx) return RANKING.GRAPH.LINE.Y(RANKING, idx) + 26 end,
        W = 221,
        H = 39,
    },
    GRAPH = {
        AREA = RANKING.GRAPH.AREA,
        LINE = {
            Y = RANKING.GRAPH.LINE.Y,
            INTERVAL_Y = RANKING.GRAPH.LINE.INTERVAL_Y,
            GAUGE = RANKING.GRAPH.LINE.GAUGE,
            VALUE = RANKING.GRAPH.LINE.SCORE,
            PERCENTAGE = RANKING.GRAPH.LINE.DIFF,
        },
    },
    IDS = {"max", "perfect", "fullcombo", "exhard", "hard", "normal", "easy", "laeasy", "aeasy", "failed"},
}

LAMPS.GRAPH.LINE.VALUE.X = function (self) return self.GRAPH.AREA.X(self) + 9 end
LAMPS.GRAPH.LINE.PERCENTAGE.X = function (self) return self.GRAPH.AREA.X(self) + 92 end

ranking.functions.isSelfRank = function (targetRank, playerName, index)
    local selfRank = main_state.number(179)
    if selfRank == nil then return false end
    -- 11番目は, 自分が11位より下なら自分として表示
    if index == 11 then
        return true
    end
    return selfRank == targetRank and playerName == "YOU"
end

ranking.functions.getIsDrawRank = function (rank)
    return ranking.viewType == VIEW_TYPES.RANKING and ranking.isDrawRankCache[rank]
end

ranking.functions.getIsDrawLamps = function ()
    return ranking.viewType == VIEW_TYPES.LAMPS
end

ranking.functions.getIsDrawTheRankForCache = function (rank)
    local selfRank = main_state.number(179)
    -- 自分が10位以内かつスクロールしていないなら11位は描画しない
    if rank == 11 and ranking.isScrolled == false and (selfRank == nil or selfRank <= 10) then
        return false
    elseif rank == 11 then
        return RANKING.MY_BEST_SCORE >= 0
    end
    return main_state.number(380 + (rank - 1)) >= 0
end

ranking.functions.getScoreRate = function (rank)
    -- 11番目描画するなら, 自己ベのみ
    if rank == 11 and ranking.functions.getIsDrawRank(rank) then
        return RANKING.MY_BEST_SCORE / RANKING.THEORETICAL
    end
    if ranking.functions.getIsDrawRank(rank) then
        return main_state.number(380 + (rank - 1)) / RANKING.THEORETICAL
    else
        return 0
    end
end

ranking.functions.getDiffScore = function (rank)
    if rank == 11 and ranking.functions.getIsDrawRank(rank) then
        return 0
    end
    if ranking.functions.getIsDrawRank(rank) then
        return RANKING.MY_BEST_SCORE - main_state.number(380 + (rank - 1))
    else
        return MIN_VALUE
    end
end

ranking.functions.switchOpenStateTimer = function ()
    if isPressedRight() then
        ranking.functions.switchOpenState()
    end
    return 1
end

--[[
    ランキング画面を切り替える
    closed -> ranking -> lamps -> closed の順
]]
ranking.functions.switchOpenState = function ()
    -- 表示の状態の操作
    if not ranking.isOpened then
        ranking.viewType = VIEW_TYPES.RANKING
        ranking.isOpened = true
    elseif ranking.isOpened and ranking.viewType == VIEW_TYPES.RANKING then
        ranking.viewType = VIEW_TYPES.LAMPS
    else
        ranking.isOpened = false
    end
    myPrint("ランキング画面切り替え: " .. (ranking.isOpened and "opened" or "closed"))
    myPrint("ランキング画面切り替え type: " .. (ranking.viewType == VIEW_TYPES.RANKING and "ranking" or "lamps"))

    -- 各種タイマの操作
    if ranking.isOpened and ranking.viewType == VIEW_TYPES.RANKING then
        ranking.timeForWindow = main_state.time()
        ranking.openTime = main_state.time()
    elseif ranking.isOpened and ranking.viewType == VIEW_TYPES.LAMPS then
        -- グラフのアニメーションをするためにウィンドウを開いた直後の時刻にする
        ranking.openTime = main_state.time() - RANKING.ANIMATION.MOVE_TIME
    else
        ranking.timeForWindow = main_state.time() - RANKING.ANIMATION.CLOSE_TIME * 1000
    end
end

ranking.functions.isOpenedWindow = function ()
    return ranking.isOpened
end

ranking.functions.windowAnimationTimer = function ()
    -- isdrawを更新
    for i = 1, 11 do
        ranking.isDrawRankCache[i] = ranking.functions.getIsDrawTheRankForCache(i)
    end

    local t = main_state.time()
    local moveTime = RANKING.ANIMATION.MOVE_TIME
    ranking.numOfPlayers = main_state.number(180)
    if ranking.isOpened then
        if t - ranking.timeForWindow > moveTime * 1000 then
            ranking.timeForWindow = t - moveTime * 1000
        end
        return ranking.timeForWindow
    else
        if t - ranking.timeForWindow > (RANKING.ANIMATION.CLOSE_TIME + moveTime) * 1000 then
            ranking.timeForWindow = t - (RANKING.ANIMATION.CLOSE_TIME + moveTime) * 1000
        end
        return ranking.timeForWindow
    end
end

ranking.functions.updateScoreGraph = function (rank)
    local t = main_state.time()
    local timeSceneOpening = t - ranking.openTime
    -- 非表示状態か, その順位は表示しない場合
    if not ranking.isOpened or ranking.viewType ~= VIEW_TYPES.RANKING or not ranking.functions.getIsDrawRank(rank) or timeSceneOpening < RANKING.ANIMATION.GAUGE_APPEAR_WAIT * 1000 then
        return t
    end

    local startTime = RANKING.ANIMATION.GAUGE_APPEAR_WAIT * 1000
    local endTime = RANKING.ANIMATION.GAUGE_APPEAR_ANIMATION_END * 1000
    local nowTime = math.max(startTime, math.min(timeSceneOpening, endTime)) - startTime
    -- ゲージアニメーション開始
    local score = 0
    if rank == 11 then score = RANKING.MY_BEST_SCORE
    else score = main_state.number(380 + (rank - 1))
    end
    local maxW = score / RANKING.THEORETICAL * RANKING.GRAPH.LINE.GAUGE.W
    -- 現在のwを取得
    local w = easing.easeOut(nowTime, 0, maxW, endTime - startTime)
    return t - w * RANKING.ANIMATION.SCORE_GRAPH_PER_W * 1000
end

ranking.functions.updateLampsGraph = function (lampValueId)
    local t = main_state.time()
    local timeSceneOpening = t - ranking.openTime
    if not ranking.isOpened or ranking.viewType ~= VIEW_TYPES.LAMPS or timeSceneOpening < RANKING.ANIMATION.GAUGE_APPEAR_WAIT * 1000 then
        return t
    end

    local startTime = RANKING.ANIMATION.GAUGE_APPEAR_WAIT * 1000
    local endTime = RANKING.ANIMATION.GAUGE_APPEAR_ANIMATION_END * 1000
    local nowTime = math.max(startTime, math.min(timeSceneOpening, endTime)) - startTime
    -- ゲージアニメーション開始
    local totalPlayer = main_state.number(180)
    if totalPlayer == 0 then
        return t
    end
    local thisLampPlayer = main_state.number(lampValueId)
    if thisLampPlayer < 0 then
        return t
    end
    local maxW = thisLampPlayer / totalPlayer * LAMPS.GRAPH.LINE.GAUGE.W
    local w = easing.easeOut(nowTime, 0, maxW, endTime - startTime)
    return t - w * RANKING.ANIMATION.SCORE_GRAPH_PER_W * 1000
end

ranking.functions.load = function ()
    ranking.timeForWindow = -(RANKING.ANIMATION.CLOSE_TIME + RANKING.ANIMATION.MOVE_TIME) * 1000
    -- とりあえず全部非表示
    for i = 1, 11 do
        ranking.isDrawRankCache[i] = false
    end

    local smallNum = judges.getSmallNumSize()
    local largeNum = judges.getLargeNumSize()
    RANKING.THEORETICAL = main_state.number(74) * 2
    RANKING.MY_BEST_SCORE = math.max(main_state.number(150), main_state.number(71))
    RANKING.IS_SHOW_PLAYER_NAME = isShowOwnPlayerNameInRanking()
    RANKING.GRAPH.LINE.GAUGE.ALPHA = getRankingGaugeAlpha()
    LAMPS.GRAPH.LINE.GAUGE.ALPHA = getRankingGaugeAlpha()
    local skin = {
        image = {
            {id = "rankingBokehBg", src = getBokehBgSrc(), x = RANKING.AREA.X, y = HEIGHT - RANKING.AREA.Y - RANKING.AREA.H, w = RANKING.AREA.W, h = RANKING.AREA.H},
            {id = "rankingWindowShadow", src = 26, x = 0, y = 0, w = -1, h = -1},
            {id = "rankingHeader", src = 25, x = 0, y = 0, w = -1, h = -1},
            {id = "playersSlush", src = 27, x = 598, y = 0, w = largeNum.W, h = largeNum.H},
            {id = "rankingArrow", src = 28, x = 0, y = 0, w = -1, h = -1},
            {id = "rankingGraphAreaShadow", src = 29, x = 0, y = 0, w = -1, h = -1},
            {id = "switchRankingWindowButton", src = 999, x = 0, y = 0, w = 1, h = 1, act = ranking.functions.switchOpenState},
        },
        value = {
            {id = "oldRankValue", src = 27, x = 0, y = largeNum.H, w = smallNum.W * 10, h = smallNum.H, divx = 10, digit = 5, space = smallNum.SPACE, ref = 182},
            {id = "nowRankValue", src = 27, x = 0, y = 0, w = largeNum.W * 10, h = largeNum.H, divx = 10, digit = 5, space = largeNum.SPACE, ref = 179},
            {id = "numOfPlayersValue", src = 27, x = 0, y = largeNum.H, w = smallNum.W * 10, h = smallNum.H, divx = 10, digit = 5, space = smallNum.SPACE, ref = 180},
        },
        text = {},
        imageset = {},
        customTimers = {
            {id = CUSTOM_TIMERS_RESULT2.SWITCH_RANKING, timer = ranking.functions.switchOpenStateTimer},
            {id = CUSTOM_TIMERS_RESULT2.RANKING_WND_TIMER, timer = ranking.functions.windowAnimationTimer},
            {
                id = CUSTOM_TIMERS_RESULT2.RANKING_TICK, timer = function ()
                    -- スクロールしているか調べる
                    ranking.isScrolled = false
                    for i = 1, 10 do
                        ranking.isScrolled = ranking.isScrolled or (main_state.number(389 + i) > i)
                    end
                end
            }
        }
    }
    local imgs = skin.image
    local texts = skin.text
    local vals = skin.value
    local imagesets = skin.imageset
    local timers = skin.customTimers
    -- 各ランクのランプ用imagesetを作成
    local lamps = {}
    for i = 1, 11 do
        local id = "rankLampType" .. i
        imgs[#imgs+1] = {id = id, src = 31, x = i - 1, y = 0, w = 1, h = RANKING.GRAPH.LINE.GAUGE.H}
        lamps[i] = id
    end
    -- 順位読み込み
    for i = 1, 11 do
        texts[#texts+1] = {id = "rank" .. i .. "PlayerName", font = 0, size = RANKING.GRAPH.LINE.NAME.FONT_SIZE, ref = 2, overflow = 1}
        if i == 11 then
            texts[#texts+1] = {
                id = "rank" .. i .. "Name", font = 0, size = RANKING.GRAPH.LINE.NAME.FONT_SIZE, constantText = "YOU", overflow = 1
            }
            vals[#vals+1] = scoreDetail.loadGray30Number("rank" .. i .. "Score", 5, 0, 0, nil, function () return RANKING.MY_BEST_SCORE end)
            imagesets[#imagesets+1] = {id = "rank" .. i .. "ScoreGraph", ref = 370, images = lamps}
        else
            texts[#texts+1] = {
                id = "rank" .. i .. "Name", font = 0, size = RANKING.GRAPH.LINE.NAME.FONT_SIZE, ref = 120 + (i - 1), overflow = 1
            }
            vals[#vals+1] = scoreDetail.loadGray30Number("rank" .. i .. "Score", 5, 0, 0, 380 + (i - 1), nil)
            imagesets[#imagesets+1] = {id = "rank" .. i .. "ScoreGraph", ref = 390 + (i - 1), images = lamps}
        end
        if i <= 10 then
            vals[#vals+1] = {
                id = "rank" .. i .. "Index", src = 33, x = 0, y = 0, w = RANKING.GRAPH.LINE.ORDER.W * 11, h = RANKING.GRAPH.LINE.ORDER.H, divx = 11, divy = 1, digit = 5, ref = 390 + i - 1
            }
        end
        vals[#vals+1] = scoreDetail.loadGray30NumberWithSign("rank" .. i .. "DiffScore", 5, 0, 0, nil, function () return ranking.functions.getDiffScore(i) end)
        timers[#timers+1] = {id = CUSTOM_TIMERS_RESULT2.RANKING_SCORE_GRAPH1_TIMER + (i - 1), timer = function () return ranking.functions.updateScoreGraph(i) end}
    end

    -- ランプグラフ用の読み込み
    local valueId = {224, 222, 218, 208, 216, 214, 212, 206, 204, 210}
    local rateId = {225, 223, 219, 209, 217, 215, 213, 207, 205, 211} -- NO PLAY(202)は入れない
    local afId = {240, 239, 238, 233, 237, 236, 235, 232, 231, 234}
    for i, id in ipairs(LAMPS.IDS) do
        -- グラフ用. ランキングと仕様を合わせるため普通のimageで
        imgs[#imgs+1] = {
            id = id .. "LampGraph", src = 31, x = #LAMPS.IDS - (i - 1), y = 0, w = 1, h = RANKING.GRAPH.LINE.GAUGE.H
        }
        -- ラベル
        imgs[#imgs+1] = {
            id = id .. "LampLabel", src = 32, x = 0, y = LAMPS.LABEL.H * (i - 1), w = LAMPS.LABEL.W, h = LAMPS.LABEL.H
        }
        -- パーセンテージ
        mergeSkin(skin, scoreDetail.loadRate30Number(id .. "LampRateValue", 1, rateId[i], afId[i]))
        -- 人数
        vals[#vals+1] = scoreDetail.loadGray30Number(id .. "LampValue", 5, 0, 0, valueId[i], nil)
        timers[#timers+1] = {id = CUSTOM_TIMERS_RESULT2.LAMPS_GRAPH_TIMER + (i - 1), timer = function () return ranking.functions.updateLampsGraph(valueId[i]) end}
    end

    return skin
end

ranking.functions.dstLamp = function ()
    local skin = {destination = {}}
    local isDrawLamp = ranking.functions.getIsDrawLamps
    local dst = skin.destination
    local num30 = scoreDetail.getGray30NumData()
    for i = 1, #LAMPS.IDS do
        local id = LAMPS.IDS[i]
        -- ランプのラベル
        dst[#dst+1] = {
            id = id .. "LampLabel", draw = isDrawLamp, dst = {
                {x = LAMPS.LABEL.X(), y = LAMPS.LABEL.Y(i), w = LAMPS.LABEL.W, h = LAMPS.LABEL.H}
            }
        }
        -- gauge
        dst[#dst+1] = {
            id = id .. "LampGraph", draw = isDrawLamp, timer = CUSTOM_TIMERS_RESULT2.LAMPS_GRAPH_TIMER + (i - 1), loop = RANKING.ANIMATION.SCORE_GRAPH_PER_W * RANKING.GRAPH.LINE.GAUGE.W, dst = {
                {time = 0, x = LAMPS.GRAPH.LINE.GAUGE.X(LAMPS), y = LAMPS.GRAPH.LINE.GAUGE.Y(LAMPS, i), w = 0, h = LAMPS.GRAPH.LINE.GAUGE.H, a = LAMPS.GRAPH.LINE.GAUGE.ALPHA},
                {time = RANKING.ANIMATION.SCORE_GRAPH_PER_W * LAMPS.GRAPH.LINE.GAUGE.W, w = LAMPS.GRAPH.LINE.GAUGE.W},
            }
        }
        -- 人数
        dst[#dst+1] = {
            id = id .. "LampValue", draw = isDrawLamp, dst = {
                {x = LAMPS.GRAPH.LINE.VALUE.X(LAMPS), y = LAMPS.GRAPH.LINE.VALUE.Y(LAMPS, i), w = LAMPS.GRAPH.LINE.VALUE.W, h = LAMPS.GRAPH.LINE.VALUE.H}
            }
        }
        -- パーセンテージ
        local pid = id .. "LampRateValue"
        local p = dstPercentageWithoutSign(pid, pid .. "Dot", pid .. "AfterDot", pid .. "Percent", 1, LAMPS.GRAPH.LINE.PERCENTAGE.X(LAMPS), LAMPS.GRAPH.LINE.PERCENTAGE.Y(LAMPS, i), LAMPS.GRAPH.LINE.VALUE.W, LAMPS.GRAPH.LINE.VALUE.H, 0, num30.DOT, num30.PERCENT)
        for _, value in pairs(p.destination) do
            value.draw = isDrawLamp
        end
        mergeSkin(skin, p)
    end

    return skin
end

ranking.functions.dst = function ()
    local smallNum = judges.getSmallNumSize()
    local largeNum = judges.getLargeNumSize()

    local skin = {
        destination = {
            {
                id = "rankingBokehBg", dst = {
                    {x = RANKING.AREA.X, y = RANKING.AREA.Y, w = RANKING.AREA.W, h = RANKING.AREA.H}
                }
            },
            {
                id = "rankingWindowShadow", dst = {
                    {x = RANKING.AREA.X - (RANKING.AREA.SHADOW_W - RANKING.AREA.W), y = RANKING.AREA.Y, w = RANKING.AREA.SHADOW_W, h = RANKING.AREA.H}
                }
            },
            {
                id = "black", dst = {
                    {x = RANKING.AREA.X, y = RANKING.AREA.Y, w = RANKING.AREA.W, h = RANKING.AREA.H, a = RANKING.AREA.DIMMER_ALPHA}
                }
            },
            -- header
            {
                id = "rankingHeader", dst = {
                    {x = RANKING.HEADER.X(RANKING), y = RANKING.HEADER.Y(RANKING), w = RANKING.HEADER.W, h = RANKING.HEADER.H}
                },
            },
            -- ランキング情報
            {
                id = "oldRankValue", dst = {
                    {x = RANKING.RANK.OLD.X(RANKING), y = RANKING.RANK.OLD.Y(RANKING), w = smallNum.W, h = smallNum.H}
                }
            },
            {
                id = "rankingArrow", dst = {
                    {x = RANKING.RANK.ARROW.X(RANKING), y = RANKING.RANK.ARROW.Y(RANKING), w = RANKING.RANK.ARROW.W, h = RANKING.RANK.ARROW.H}
                }
            },
            {
                id = "nowRankValue", dst = {
                    {x = RANKING.RANK.NOW.X(RANKING), y = RANKING.RANK.NOW.Y(RANKING), w = largeNum.W, h = largeNum.H}
                }
            },
            {
                id = "playersSlush", dst = {
                    {x = RANKING.RANK.SLUSH.X(RANKING), y = RANKING.RANK.SLUSH.Y(RANKING), w = largeNum.W, h = largeNum.H}
                }
            },
            {
                id = "numOfPlayersValue", dst = {
                    {x = RANKING.RANK.PLAYERS.X(RANKING), y = RANKING.RANK.PLAYERS.Y(RANKING), w = smallNum.W, h = smallNum.H}
                }
            },
        }
    }
    local dst = skin.destination
    -- ランキング部分dimmer
    dst[#dst+1] = {
        id = "black", dst = {
            {x = RANKING.GRAPH.AREA.X(RANKING), y = RANKING.GRAPH.AREA.Y(RANKING), w = RANKING.GRAPH.AREA.W, h = RANKING.GRAPH.AREA.H, a = RANKING.GRAPH.DIMMER_ALPHA}
        }
    }
    -- 各ランクの線
    for i = 1, 8 do
        if i <= 3 then
            dst[#dst+1] = {
                id = "white", dst = {
                    {x = RANKING.GRAPH.SCORERANK_LINE.X(RANKING, i), y = RANKING.GRAPH.SCORERANK_LINE.Y(RANKING), w = RANKING.GRAPH.SCORERANK_LINE.W, h = RANKING.GRAPH.SCORERANK_LINE.H, a = RANKING.GRAPH.SCORERANK_LINE.ALPHA}
                }
            }
        end
    end
    -- ランクの出力
    for i = 1, 11 do
        local isDrawRank = ranking.functions.getIsDrawRank
        local isDrawSelfRank = function ()
            if not isDrawRank(i) then return false end
            if i == 11 then return true end
            return ranking.functions.isSelfRank(main_state.number(390 + i - 1), main_state.text(120 + i - 1), i)
        end
        local isDrawOtherRank = function ()
            if i > 10 then return false end
            return isDrawRank(i) and not ranking.functions.isSelfRank(main_state.number(390 + i - 1), main_state.text(120 + i - 1), i)
        end

        -- order
        dst[#dst+1] = {
            id = "rank" .. i .. "Index", draw = function () return isDrawRank(i) end, dst = {
                {x = RANKING.GRAPH.LINE.ORDER.X(RANKING), y = RANKING.GRAPH.LINE.ORDER.Y(RANKING, i), w = RANKING.GRAPH.LINE.ORDER.W, h = RANKING.GRAPH.LINE.ORDER.H}
            }
        }
        -- name
        -- 自分以外の名前
        dst[#dst+1] = {
            id = "rank" .. i .. "Name", draw = function () return isDrawOtherRank() end, filter = 1, dst = {
                {x = RANKING.GRAPH.LINE.NAME.X(RANKING), y = RANKING.GRAPH.LINE.NAME.Y(RANKING, i), w = RANKING.GRAPH.LINE.NAME.W, h = RANKING.GRAPH.LINE.NAME.FONT_SIZE}
            }
        }
        -- 自分の名前
        if RANKING.IS_SHOW_PLAYER_NAME then
            dst[#dst+1] = {
                id = "rank" .. i .. "PlayerName", draw = function () return isDrawSelfRank() end, filter = 1, dst = {
                    {x = RANKING.GRAPH.LINE.NAME.X(RANKING), y = RANKING.GRAPH.LINE.NAME.Y(RANKING, i), w = RANKING.GRAPH.LINE.NAME.W, h = RANKING.GRAPH.LINE.NAME.FONT_SIZE}
                }
            }
        else
            dst[#dst+1] = {
                id = "rank" .. i .. "Name", draw = function () return isDrawSelfRank() end, filter = 1, dst = {
                    {x = RANKING.GRAPH.LINE.NAME.X(RANKING), y = RANKING.GRAPH.LINE.NAME.Y(RANKING, i), w = RANKING.GRAPH.LINE.NAME.W, h = RANKING.GRAPH.LINE.NAME.FONT_SIZE}
                }
            }
        end
        --gauge
        dst[#dst+1] = {
            id = "rank" .. i .. "ScoreGraph", draw = function () return isDrawRank(i) end, timer = CUSTOM_TIMERS_RESULT2.RANKING_SCORE_GRAPH1_TIMER + (i - 1), loop = RANKING.ANIMATION.SCORE_GRAPH_PER_W * RANKING.GRAPH.LINE.GAUGE.W, dst = {
                {time = 0, x = RANKING.GRAPH.LINE.GAUGE.X(RANKING), y = RANKING.GRAPH.LINE.GAUGE.Y(RANKING, i), w = 0, h = RANKING.GRAPH.LINE.GAUGE.H, a = RANKING.GRAPH.LINE.GAUGE.ALPHA},
                {time = RANKING.ANIMATION.SCORE_GRAPH_PER_W * RANKING.GRAPH.LINE.GAUGE.W, w = RANKING.GRAPH.LINE.GAUGE.W},
            }
        }
        -- exscore
        dst[#dst+1] = {
            id = "rank" .. i .. "Score", draw = function () return isDrawRank(i) end, dst = {
                {x = RANKING.GRAPH.LINE.SCORE.X(RANKING), y = RANKING.GRAPH.LINE.SCORE.Y(RANKING, i), w = RANKING.GRAPH.LINE.SCORE.W, h = RANKING.GRAPH.LINE.SCORE.H}
            }
        }
        dst[#dst+1] = {
            id = "rank" .. i .. "DiffScore", draw = function () return isDrawRank(i) end, dst = {
                {x = RANKING.GRAPH.LINE.SCORE.X(RANKING), y = RANKING.GRAPH.LINE.DIFF.Y(RANKING, i), w = RANKING.GRAPH.LINE.DIFF.W, h = RANKING.GRAPH.LINE.DIFF.H}
            }
        }
    end
    -- 影を重ねる
    dst[#dst+1] = {
        id = "rankingGraphAreaShadow", dst = {
            {x = RANKING.GRAPH.AREA.X(RANKING), y = RANKING.GRAPH.AREA.Y(RANKING), w = RANKING.GRAPH.AREA.W, h = RANKING.GRAPH.AREA.H}
        }
    }
    -- 開いているとき用のスイッチ
    dst[#dst+1] = {
        id = "switchRankingWindowButton", dst = {
            {x = RANKING.AREA.X, y = RANKING.AREA.Y, w = RANKING.AREA.W, h = RANKING.AREA.H}
        }
    }

    -- ランプ側読み込み
    mergeSkin(skin, ranking.functions.dstLamp())

    -- ゲージ以外の全てにアニメーション用のタイマとxを設定
    do
        local moveTime = RANKING.ANIMATION.MOVE_TIME
        local moveW = RANKING.AREA.SHADOW_W
        for i = 1, #dst do
            local d = dst[i]
            local toX = d.dst[1].x
            local fromX = toX + moveW
            if d.timer == nil then
                d.timer = CUSTOM_TIMERS_RESULT2.RANKING_WND_TIMER
                d.loop = 99999999
                d.dst[1].time = 0
                d.dst[1].x = fromX
                d.dst[1].acc = 2
                d.dst[2] = {time = moveTime, x = toX}
                d.dst[3] = {time = RANKING.ANIMATION.CLOSE_TIME, x = toX}
                d.dst[4] = {time = RANKING.ANIMATION.CLOSE_TIME + moveTime, x = fromX}
                -- 背景だけアルファのアニメーションを加える
                if d.id == "rankingBokehBg" then
                    d.dst[1].a = 0
                    d.dst[2].a = 255
                end
            end
        end
    end

    -- マウスdeスイッチ用の出力
    dst[#dst+1] = {
        id = "switchRankingWindowButton", dst = {
            {x = RANKING.SWITCH_AREA.X, y = RANKING.SWITCH_AREA.Y, w = RANKING.SWITCH_AREA.W, h = RANKING.SWITCH_AREA.H}
        }
    }
    return skin
end

return ranking.functions