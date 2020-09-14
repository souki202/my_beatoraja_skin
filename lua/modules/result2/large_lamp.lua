local largeLamp = {
    functions = {}
}

local LARGE_LAMP = {
    PREFIX = {"failed", "aeasy", "laeasy", "easy", "normal", "hard", "exhard", "fullcombo", "perfect", "perfect"},
    AREA = {
        Y = function (self) return (HEIGHT - self.AREA.H) / 2 end,
        W = WIDTH, -- 約数 1, 2, 3, 4, 5, 6, 8, 10, 12, 15, 16, 20, 24, 30, 32, 40, 48, 60, 64, 80, 96, 120, 128, 160, 192, 240, 320, 384, 480, 640, 960, 1920
        H = 300,
        DIV_X = 480, -- 偶数かつWを割り切れる値 上のリストのいずれかで, 大きいほうが細かい
        LINE_DIV_X = 160,
        PER_W = function (self) return self.AREA.W / self.AREA.DIV_X end,
        LINE_PER_W = function (self) return self.AREA.W / self.AREA.LINE_DIV_X end,
    },
    ANIMATION = {
        WAIT_TIME = 200,
        BRIGHT_TEXT_ANIM_TIME = 500,
        END_TEXT_APPEAR = 1000,
        TEXT_DEL_START_TIME = 1300,
        TEXT_DEL_END_TIME = 1400,
        ALL_TEXT_DEL_TIME = 1800, -- 線が全部消えるのもこれ

        LINE_APPEAR_TIME = 50,
        END_LINE_APPEAR = 500, -- そのラインにおけるすべてのパーツが出現完了する時刻
        LINE_DEL_START_TIME = 1100, -- 1個目のパーツが消え始める時刻
        LINE_DEL_END_TIME = 1150, -- 1個目のパーツが完全に消える時刻
        LINE_ALL_DEL_TIME = 1500, -- 1本目のラインのパーツがすべて消える時刻
        EACH_LINE_DT = 100, -- 最後のは400ずれることを頭に入れて全体を計算

        DIMMER_DEL_START_TIME = 1300,
        DIMMER_DEL_END_TIME = 1600,
    },
    DIMMER = {
        ALPHA = 128,
    },
    LINES = {
        Y = function (self) return (HEIGHT - self.LINES.H) / 2 - 64 end,
        W = WIDTH,
        H = 256,
        MOVE_X = 128,
        MOVE_X_DELTA = -64,
        NUM_OF_LINES = 5,
        ALPHA = 192,
    }
}

largeLamp.functions.getAnimationEndTime = function ()
    return LARGE_LAMP.ANIMATION.ALL_TEXT_DEL_TIME
end

largeLamp.functions.getLampId = function (clearType)
    if clearType == 0 then
        print("今回のランプがNO PLAYです")
        clearType = 5
    end
    return LARGE_LAMP.PREFIX[clearType]
end

largeLamp.functions.load = function ()
    local skin = {image = {}}
    local imgs = skin.image

    do
        local perW = LARGE_LAMP.AREA.PER_W(LARGE_LAMP)
        for i = 1, LARGE_LAMP.AREA.DIV_X do
            -- 文字の読み込み
            imgs[#imgs+1] = {
                id = "largeLampTextPart" .. i, src = 3, x = perW * (i - 1), y = 0, w = perW, h = LARGE_LAMP.AREA.H
            }
            imgs[#imgs+1] = {
                id = "largeLampTextBrightPart" .. i, src = 3, x = perW * (i - 1), y = LARGE_LAMP.AREA.H, w = perW, h = LARGE_LAMP.AREA.H
            }
        end
    end
    do
        local perW = LARGE_LAMP.AREA.LINE_PER_W(LARGE_LAMP)
        for i = 1, LARGE_LAMP.AREA.LINE_DIV_X do
            -- 線の読み込み
            for j = 1, LARGE_LAMP.LINES.NUM_OF_LINES do
                imgs[#imgs+1] = {
                    id = "largeLampLine" .. j .. "Part" .. i, src = 4, x = perW * (i - 1), y = LARGE_LAMP.LINES.H * (j - 1), w = perW, h = LARGE_LAMP.LINES.H
                }
            end
        end
    end
    return skin
end

largeLamp.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    local waitTime = LARGE_LAMP.ANIMATION.WAIT_TIME
    -- 背景のディマー
    dst[#dst+1] = {
        id = "black", loop = -1, dst = {
            {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = LARGE_LAMP.DIMMER.ALPHA},
            {time = waitTime + LARGE_LAMP.ANIMATION.DIMMER_DEL_START_TIME},
            {time = waitTime + LARGE_LAMP.ANIMATION.DIMMER_DEL_END_TIME}
        }
    }

    do
        -- 線の出力 シンプルに横から出てくる
        do
            local perW = LARGE_LAMP.AREA.LINE_PER_W(LARGE_LAMP)
            for j = 1, LARGE_LAMP.LINES.NUM_OF_LINES do
                local lineGapTime = LARGE_LAMP.ANIMATION.EACH_LINE_DT * (j - 1)
                local dt = (LARGE_LAMP.ANIMATION.END_LINE_APPEAR - LARGE_LAMP.ANIMATION.LINE_APPEAR_TIME) / LARGE_LAMP.AREA.DIV_X
                local delDt = (LARGE_LAMP.ANIMATION.LINE_ALL_DEL_TIME - LARGE_LAMP.ANIMATION.LINE_DEL_END_TIME) / LARGE_LAMP.AREA.DIV_X
                for i = 1, LARGE_LAMP.AREA.LINE_DIV_X do
                    local partsGapTime = lineGapTime + dt * (i - 1)
                    local delGapTime = lineGapTime + delDt * (i - 1)
                    local mx = LARGE_LAMP.LINES.MOVE_X + LARGE_LAMP.LINES.MOVE_X_DELTA * (j - 1)
                    dst[#dst+1] = {
                        id = "largeLampLine" .. j .. "Part" .. i, loop = -1, dst = {
                            {time = 0, x = perW * (i - 1) + mx, y = LARGE_LAMP.LINES.Y(LARGE_LAMP), w = perW, h = LARGE_LAMP.LINES.H, a = 0},
                            {time = waitTime + partsGapTime},
                            {time = waitTime + partsGapTime + LARGE_LAMP.ANIMATION.LINE_APPEAR_TIME, a = LARGE_LAMP.LINES.ALPHA},
                            {time = waitTime + delGapTime + LARGE_LAMP.ANIMATION.LINE_DEL_START_TIME},
                            {time = waitTime + delGapTime + LARGE_LAMP.ANIMATION.LINE_DEL_END_TIME, a = 0}
                        }
                    }
                end
            end
        end

        -- 文字の出力
        do
            local perW = LARGE_LAMP.AREA.PER_W(LARGE_LAMP)
            local centerIdx = LARGE_LAMP.AREA.DIV_X / 2 -- 中央左は-0から, 右は+1から開始
            local brightTextAnimTime = LARGE_LAMP.ANIMATION.BRIGHT_TEXT_ANIM_TIME - waitTime
            local y = LARGE_LAMP.AREA.Y(LARGE_LAMP)
            local h = LARGE_LAMP.AREA.H
            local dt = (LARGE_LAMP.ANIMATION.END_TEXT_APPEAR - brightTextAnimTime / 2 - waitTime) / (LARGE_LAMP.AREA.DIV_X / 2)
            local delDt = (LARGE_LAMP.ANIMATION.ALL_TEXT_DEL_TIME - LARGE_LAMP.ANIMATION.TEXT_DEL_END_TIME) / (LARGE_LAMP.AREA.DIV_X / 2)
            local delAnimTime = LARGE_LAMP.ANIMATION.TEXT_DEL_END_TIME - LARGE_LAMP.ANIMATION.TEXT_DEL_START_TIME
            for i = 1, LARGE_LAMP.AREA.DIV_X / 2 do
                local li = centerIdx - (i - 1)
                local ri = centerIdx + i
                local ownDt = dt * (i - 1)
                -- 左側の文字
                -- 普通の文字
                dst[#dst+1] = {
                    id = "largeLampTextPart" .. li, loop = -1, dst = {
                        {time = 0, x = perW * (li - 1), y = y, w = perW, h = h, a = 0, acc = 1},
                        {time = waitTime + ownDt + brightTextAnimTime / 2}, -- brightが消え始めると同時に出現し始める
                        {time = waitTime + ownDt + brightTextAnimTime, a = 255}, -- bright消えたら完全に見える状態
                        {time = waitTime + delDt * (i - 1) + LARGE_LAMP.ANIMATION.TEXT_DEL_START_TIME},
                        {time = waitTime + delDt * (i - 1) + LARGE_LAMP.ANIMATION.TEXT_DEL_END_TIME, a = 0},
                    }
                }
                -- 明るい方
                dst[#dst+1] = {
                    id = "largeLampTextBrightPart" .. li, loop = -1, dst = {
                        {time = 0, x = perW * (li - 1), y = y, w = perW, h = h, a = 0, acc = 1},
                        {time = waitTime + ownDt},
                        {time = waitTime + ownDt + brightTextAnimTime / 2, a = 255},
                        {time = waitTime + ownDt + brightTextAnimTime, a = 0},
                        {time = waitTime + delDt * (i - 1) + LARGE_LAMP.ANIMATION.TEXT_DEL_START_TIME - delAnimTime},
                        {time = waitTime + delDt * (i - 1) + LARGE_LAMP.ANIMATION.TEXT_DEL_START_TIME, a = 255},
                        {time = waitTime + delDt * (i - 1) + LARGE_LAMP.ANIMATION.TEXT_DEL_END_TIME, a = 0},
                    }
                }

                -- 右側の文字
                -- 普通の文字
                dst[#dst+1] = {
                    id = "largeLampTextPart" .. ri, loop = -1, dst = {
                        {time = 0, x = perW * (ri - 1), y = y, w = perW, h = h, a = 0, acc = 1},
                        {time = waitTime + ownDt + brightTextAnimTime / 2}, -- brightが消え始めると同時に出現し始める
                        {time = waitTime + ownDt + brightTextAnimTime, a = 255}, -- bright消えたら完全に見える状態
                        {time = waitTime + delDt * (i - 1) + LARGE_LAMP.ANIMATION.TEXT_DEL_START_TIME},
                        {time = waitTime + delDt * (i - 1) + LARGE_LAMP.ANIMATION.TEXT_DEL_END_TIME, a = 0},
                    }
                }
                -- 明るい方
                dst[#dst+1] = {
                    id = "largeLampTextBrightPart" .. ri, loop = -1, dst = {
                        {time = 0, x = perW * (ri - 1), y = y, w = perW, h = h, a = 0, acc = 1},
                        {time = waitTime + ownDt},
                        {time = waitTime + ownDt + brightTextAnimTime / 2, a = 255},
                        {time = waitTime + ownDt + brightTextAnimTime, a = 0},
                        {time = waitTime + delDt * (i - 1) + LARGE_LAMP.ANIMATION.TEXT_DEL_START_TIME - delAnimTime},
                        {time = waitTime + delDt * (i - 1) + LARGE_LAMP.ANIMATION.TEXT_DEL_START_TIME, a = 255},
                        {time = waitTime + delDt * (i - 1) + LARGE_LAMP.ANIMATION.TEXT_DEL_END_TIME, a = 0},

                    }
                }
            end
        end
    end
    return skin
end

return largeLamp.functions