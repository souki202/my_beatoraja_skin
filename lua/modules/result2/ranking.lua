require("modules.commons.easing")
require("modules.result.commons")
require("modules.result2.commons")
local main_state = require("main_state")
local judges = require("modules.result2.judges")
local scoreDetail = require("modules.result2.score_detail")

local ranking = {
    numOfPlayers = 0,
    isOpened = false,
    timeForAnimation = 9999999,
    openTime = 0,
    isDrawRankCache = {},
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
                X = function (self) return self.AREA.X + 18 end,
                Y = function (self, idx) return self.GRAPH.LINE.Y(self, idx) + 35 end,
                W = 34,
                H = 34,
            },
            NAME = {
                X = function (self) return self.AREA.X + 70 end,
                Y = function (self, idx) return self.GRAPH.LINE.Y(self, idx) + 26 end,
                W = 272,
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

ranking.functions.isSelfRank = function (targetRank)
    local selfRank = main_state.number(179)
    if selfRank == nil then return false end
    -- 11番目は, 自分が11位より下なら自分として表示
    if targetRank == 11 and selfRank > 11 then
        return true
    end
    return selfRank == targetRank
end

ranking.functions.getIsDrawTheRank = function (rank)
    return ranking.isDrawRankCache[rank]
end

ranking.functions.getIsDrawTheRankForCache = function (rank)
    local selfRank = main_state.number(179)
    -- 自分が10位以内なら11位は描画しない
    if rank == 11 and (selfRank == nil or selfRank <= 10) then
        return false
    end
    -- 11位以下なら自分のスコアで判定(必ずtrue?)
    if rank == 11 and selfRank >= 11 then
        return RANKING.MY_BEST_SCORE >= 0
    end
    return main_state.number(380 + (rank - 1)) >= 0
end

ranking.functions.getScoreRate = function (rank)
    -- 11番目描画するなら, 自己ベのみ
    if rank == 11 and ranking.functions.getIsDrawTheRank(rank) then
        return RANKING.MY_BEST_SCORE / RANKING.THEORETICAL
    end
    if ranking.functions.getIsDrawTheRank(rank) then
        return main_state.number(380 + (rank - 1)) / RANKING.THEORETICAL
    else
        return 0
    end
end

ranking.functions.getDiffScore = function (rank)
    if rank == 11 and ranking.functions.getIsDrawTheRank(rank) then
        return 0
    end
    if ranking.functions.getIsDrawTheRank(rank) then
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

ranking.functions.switchOpenState = function ()
    ranking.isOpened = not ranking.isOpened
    myPrint("ランキング画面切り替え: " .. (ranking.isOpened and "opened" or "closed"))
    if ranking.isOpened then
        ranking.timeForAnimation = main_state.time()
        ranking.openTime = main_state.time()
    else
        ranking.timeForAnimation = main_state.time() - RANKING.ANIMATION.CLOSE_TIME * 1000
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
        if t - ranking.timeForAnimation > moveTime * 1000 then
            ranking.timeForAnimation = t - moveTime * 1000
        end
        return ranking.timeForAnimation
    else
        if t - ranking.timeForAnimation > (RANKING.ANIMATION.CLOSE_TIME + moveTime) * 1000 then
            ranking.timeForAnimation = t - (RANKING.ANIMATION.CLOSE_TIME + moveTime) * 1000
        end
        return ranking.timeForAnimation
    end
end

ranking.functions.updateScoreGraph = function (rank)
    local t = main_state.time()
    local timeSceneOpening = t - ranking.openTime
    if not ranking.isOpened or not ranking.functions.getIsDrawTheRank(rank) or timeSceneOpening < RANKING.ANIMATION.GAUGE_APPEAR_WAIT * 1000 then
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

ranking.functions.load = function ()
    ranking.timeForAnimation = -(RANKING.ANIMATION.CLOSE_TIME + RANKING.ANIMATION.MOVE_TIME) * 1000
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
            imgs[#imgs+1] = {
                id = "rank" .. i .. "OrderLabel", src = 30, x = 0, y = RANKING.GRAPH.LINE.ORDER.H * (i - 1), w = RANKING.GRAPH.LINE.ORDER.W, h = RANKING.GRAPH.LINE.ORDER.H
            }
            texts[#texts+1] = {
                id = "rank" .. i .. "Name", font = 0, size = RANKING.GRAPH.LINE.NAME.FONT_SIZE, ref = 120 + (i - 1), overflow = 1
            }
            vals[#vals+1] = scoreDetail.loadGray30Number("rank" .. i .. "Score", 5, 0, 0, 380 + (i - 1), nil)
            imagesets[#imagesets+1] = {id = "rank" .. i .. "ScoreGraph", ref = 390 + (i - 1), images = lamps}
        end
        vals[#vals+1] = scoreDetail.loadGray30NumberWithSign("rank" .. i .. "DiffScore", 5, 0, 0, nil, function () return ranking.functions.getDiffScore(i) end)
        timers[#timers+1] = {id = CUSTOM_TIMERS_RESULT2.RANKING_SCORE_GRAPH1_TIMER + (i - 1), timer = function () return ranking.functions.updateScoreGraph(i) end}
    end
    return skin
end

ranking.functions.dst = function ()
    local smallNum = judges.getSmallNumSize()
    local largeNum = judges.getLargeNumSize()
    local isDrawRank = ranking.functions.getIsDrawTheRank
    local isDrawSelfRank = function (targetRank) return isDrawRank(targetRank) and ranking.functions.isSelfRank(targetRank) end
    local isDrawOtherRank = function (targetRank) return isDrawRank(targetRank) and not ranking.functions.isSelfRank(targetRank) end

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
        -- order
        dst[#dst+1] = {
            id = "rank" .. i .. "OrderLabel", draw = function () return isDrawRank(i) end, dst = {
                {x = RANKING.GRAPH.LINE.ORDER.X(RANKING), y = RANKING.GRAPH.LINE.ORDER.Y(RANKING, i), w = RANKING.GRAPH.LINE.ORDER.W, h = RANKING.GRAPH.LINE.ORDER.H}
            }
        }
        -- name
        -- 自分以外の名前
        dst[#dst+1] = {
            id = "rank" .. i .. "Name", draw = function () return isDrawOtherRank(i) end, filter = 1, dst = {
                {x = RANKING.GRAPH.LINE.NAME.X(RANKING), y = RANKING.GRAPH.LINE.NAME.Y(RANKING, i), w = RANKING.GRAPH.LINE.NAME.W, h = RANKING.GRAPH.LINE.NAME.FONT_SIZE}
            }
        }
        -- 自分の名前
        if RANKING.IS_SHOW_PLAYER_NAME then
            dst[#dst+1] = {
                id = "rank" .. i .. "PlayerName", draw = function () return isDrawSelfRank(i) end, filter = 1, dst = {
                    {x = RANKING.GRAPH.LINE.NAME.X(RANKING), y = RANKING.GRAPH.LINE.NAME.Y(RANKING, i), w = RANKING.GRAPH.LINE.NAME.W, h = RANKING.GRAPH.LINE.NAME.FONT_SIZE}
                }
            }
        else
            dst[#dst+1] = {
                id = "rank" .. i .. "Name", draw = function () return isDrawSelfRank(i) end, filter = 1, dst = {
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

    -- グラフ以外の全てにアニメーション用のタイマとxを設定
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