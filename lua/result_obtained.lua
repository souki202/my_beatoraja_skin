require("define")
require("userdata")
require("input")
require("sound")
require("my_window")
local main_state = require("main_state")
local luajava = require("luajava")
local input = luajava.bindClass("com.badlogic.gdx.Input")

local NUM_36PX = {
    SRC = 0,
    SRC_X = 1808,
    SRC_Y = 54,
    W = 20,
    H = 26,

    DOT_SIZE = 5,
}

local NUM_36PX_RICH = {
    SRC = 0,
    SRC_X = 1784,
    SRC_Y = 54,
    W = 22,
    H = 30,

    DOT_SIZE = 5,
}

local RANK = {
    FRAME = {
        X = function() return 280 end,
        Y = function() return 285 end,
        W = 1360,
        H = 294,
    },

    CIRCLE = {
        X = function(rank) return rank.FRAME.X() + 19 end,
        Y = function(rank) return rank.FRAME.Y() + 19 end,
        SIZE = 256,
        SIZE_S = 244,
        ROTATION_TIME = 5000,
    },

    RANK = {
        TEXT = {
            X = function(rank) return rank.FRAME.X() + 147 end,
            Y = function(rank) return rank.FRAME.Y() + 166 end,
        },
        NUM = {
            X = function(rank) return rank.FRAME.X() + 69 end,
            Y = function(rank) return rank.FRAME.Y() + 80 end,
            W = 55,
            H = 76,
        },
        SHINE = {
            X = function(rank) return rank.CIRCLE.X(rank) + rank.CIRCLE.SIZE / 2 end,
            Y = function(rank) return rank.CIRCLE.Y(rank) + rank.CIRCLE.SIZE / 2 end,
            MAX_SIZE = 1280,
        },
    },

    NEXT = {
        AREA = {
          X = function(rank) return rank.FRAME.X() + 1049 end,
          Y = function(rank) return rank.FRAME.Y() + 89 end,
        },
        NEXT = {
            X = function(rank) return rank.NEXT.AREA.X(rank) + 153 end, -- h, wは36pxのやつ
            Y = function(rank) return rank.NEXT.AREA.Y(rank) + 12 end,
        },
        SLASH = {
            X = function(rank) return rank.NEXT.AREA.X(rank) + 141 end,
            Y = function(rank) return rank.NEXT.AREA.Y(rank) + 11 end,
            W = 10,
            H = 28,
        },
        NOW = {
            X = function(rank) return rank.NEXT.AREA.X(rank) + 139 - rank.NEXT.DIGIT * NUM_36PX.W end,
            Y = function(rank) return rank.NEXT.NEXT.Y(rank) end,
        },
        DIGIT = 6,
    },

    GAUGE = {
        X = function(rank) return rank.FRAME.X() + 192 end,
        Y = function(rank) return rank.FRAME.Y() + 22 end,
        W = 1150,
        H = 64,
        START_TIME = 1000000,
        GAUGE_RANGE = 1000000,
    },

    REMAIND = {
        TEXT = {
            W = 66,
            H = 35,
        },
        NUM = {
            X = function(rank) return rank.GAUGE.X(rank) + 1134 end,
            Y = function(rank) return rank.GAUGE.Y(rank) + 16 end,
        },
    },

    NUM = {
        ADD = {
            X = function(rank) return rank.GAUGE.X(rank) + 1134 - rank.NUM.ADD.W*7 end,
            Y = function(rank) return rank.GAUGE.Y(rank) + 16 end,
            W = 22,
            H = 30,
        },
    },
    FONT_SIZE = 48
}

local DROPS = {
    WND = {
        X = function() return 295 end,
        Y = function() return 197 end,
        W = 574,
        H = 86
    },
    COIN = {
        X = function(drops) return drops.WND.X() + 20 end,
        Y = function(drops) return drops.WND.Y() + 11 end,
        SIZE = 64,
        NUM = {
            X = function(drops) return drops.COIN.X(drops) + 346 end,
            Y = function(drops) return drops.COIN.Y(drops) + 3 end,
            SIZE = 48,
        },
        ADD_NUM = {
            X = function(drops) return drops.COIN.X(drops) + 393 end,
            Y = function(drops) return drops.COIN.Y(drops) + 17 end,
        },
    },
}

local NO_DROP = {
    WND = {
        X = function() return 295 end,
        Y = function() return 66 end,
        W = 1330,
        H = 64,
    },
    TEXT = {
        X = function(noDrop) return noDrop.WND.X() + noDrop.WND.W / 2 end,
        Y = function(noDrop) return noDrop.WND.Y() + 14 end,
        SIZE = 30,
    },
}

local resultObtained = {
    val = {
        before = {
            coin = 0,
            exp = 0, -- このexpは累計値
            rank = 1,
        },
        anim = {},
        add = {},
        after = {},
        addExpPerMs = 0,
        addCoinPerMs = 0,
    },

    activateTime = 0,

    TIMER_ID = 10010,
    RANKUP_TIMER = 10012,
    APPEAR_TIME = 300,
    BEFORE_WAIT_TIME = 500,
    AFTER_WAIT_TIME = 600,
    ANIMATION_TIME = 700,

    didPlayExpSe = false,
    didDispose = false,

    ramp = 0,
    isShortageStamina = false,

    functions = {},
}


local transitionMode = 0

-- 出現後に操作するtimer
function resultRankGaugeTimer()
    if resultObtained.activateTime == main_state.timer_off_value
        or (main_state.time() - resultObtained.activateTime) / 1000 < resultObtained.APPEAR_TIME then
        return main_state.timer_off_value
    end
    local n = userData.rank.getNowRankExp(resultObtained.val.anim.exp, resultObtained.val.anim.rank)
    local t = (RANK.GAUGE.START_TIME + RANK.GAUGE.GAUGE_RANGE * math.min(n / userData.rank.getNext(resultObtained.val.anim.rank), 1)) * 1000
    return main_state.time() - t
end

local function isTransitionByRight()
    return transitionMode == 925
end

local function isTransitionByLeft()
    return transitionMode == 926
end

local function isTransitionByDecide()
    return transitionMode == 927
end

local function canGetDrops()
    return resultObtained.ramp > 1 and resultObtained.isShortageStamina == false
end

local function acquisitionExp(animVals)
    if resultObtained.didPlayExpSe == false then
        -- 経験値入手効果音
        Sound.play(RANK.EXP_SE, 0.6)
        resultObtained.didPlayExpSe = true
    end
    animVals.exp = animVals.exp + resultObtained.val.addExpPerMs * getDeltaTime() / 1000
    if animVals.exp >= resultObtained.val.after.exp then
        animVals.exp = resultObtained.val.after.exp
    end
    if animVals.exp >= userData.rank.getSumExp(animVals.rank) then
        -- rankup
        main_state.set_timer(resultObtained.RANKUP_TIMER, main_state.time())
        animVals.rank = animVals.rank + 1
        Sound.play(RANK.RANKUP_SE, 1.0)
    end
end

local function acquisitionCoin(animVals)
    animVals.coin = animVals.coin + resultObtained.val.addCoinPerMs * getDeltaTime() / 1000
    if animVals.coin >= resultObtained.val.after.coin then
        animVals.coin = resultObtained.val.after.coin
    end
end

function obtainedTimer()
    -- 起動するアクション周り
    if resultObtained.activateTime == main_state.timer_off_value then
        if getElapsedTime() > 2000*1000
            and (isTransitionByRight() and isKeyPressed(input.Keys.RIGHT)
            or isTransitionByLeft() and isKeyPressed(input.Keys.LEFT)
            or isTransitionByDecide() and main_state.timer(2) >= 0 and canGetDrops()) then

            resultObtained.activateTime = main_state.time()
        end
    elseif resultObtained.activateTime ~= main_state.timer_off_value and canGetDrops() then
        local animVals = resultObtained.val.anim
        -- 表示中のロジック
        if (main_state.time() - resultObtained.activateTime) / 1000 > resultObtained.APPEAR_TIME + resultObtained.BEFORE_WAIT_TIME  then
            -- 各種入手周り
            acquisitionExp(animVals)
            acquisitionCoin(animVals)

            -- 経験値入手音とランクアップ音が終了したらdispose
            -- ゲームを起動してから終了するまでAudioDriverのインスタンスは維持されるぽいので, disposeしなくても別にリークしない(メモリのリソースが再利用されるだけ)
            local isEndSe = (main_state.time() - resultObtained.activateTime) / 1000 > resultObtained.APPEAR_TIME + resultObtained.BEFORE_WAIT_TIME + 500
            if isEndSe and resultObtained.didDispose == false then
                myPrint("効果音をメモリから解放")
                Sound.stop(RANK.EXP_SE)
                Sound.stop(RANK.RANKUP_SE)
                Sound.dispose(RANK.EXP_SE)
                Sound.dispose(RANK.RANKUP_SE)
                resultObtained.didDispose = true
            end
        end
    end

    return resultObtained.activateTime
end

resultObtained.functions.setRampAndUpdateFadeTime = function(skin, ramp, isShortageStamina)
    resultObtained.ramp = ramp
    resultObtained.isShortageStamina = isShortageStamina
    -- 決定キー(自動遷移版)なら, 画面を出すときのみfadeを弄る
    if isTransitionByDecide() and ramp > 1 then
        local fade = math.max(getTableValue(skin_config.offset, "経験値等画面表示秒数 (決定キーの場合, 最小1秒)", {x = 1}).x, 1) * 1000
        skin.fadeout = fade + resultObtained.APPEAR_TIME + resultObtained.BEFORE_WAIT_TIME + resultObtained.AFTER_WAIT_TIME
    end
end

resultObtained.functions.init = function()
    Sound.init()

    -- exp入手前のuserdataを入れておく
    resultObtained.val.before.rank = userData.rank.rank
    resultObtained.val.before.exp = userData.rank.exp
    resultObtained.val.before.coin = userData.tokens.coin

    resultObtained.val.anim.rank = resultObtained.val.before.rank
    resultObtained.val.anim.exp = resultObtained.val.before.exp
    resultObtained.val.anim.coin = resultObtained.val.before.coin

    transitionMode = getTableValue(skin_config.option, "経験値等画面遷移", 925)

    resultObtained.activateTime = main_state.timer_off_value

    RANK.EXP_SE = skin_config.get_path("../sounds/expget.wav")
    RANK.RANKUP_SE = skin_config.get_path("../sounds/rankup.wav")
end

-- userdata更新後, image, value, text後に呼び出す
resultObtained.functions.load = function(skin)
    local values = resultObtained.val
    values.after.rank = userData.rank.rank
    values.after.exp = userData.rank.exp
    values.after.coin = userData.tokens.coin

    values.add.rank = values.after.rank - values.before.rank
    values.add.exp = values.after.exp - values.before.exp
    values.add.coin = values.after.coin - values.before.coin

    values.addExpPerMs = values.add.exp / resultObtained.ANIMATION_TIME
    values.addCoinPerMs = values.add.coin / resultObtained.ANIMATION_TIME

    table.insert(skin.customTimers, {id = resultObtained.TIMER_ID, timer = "obtainedTimer"})
    -- table.insert(skin.customTimers, {id = resultObtained.TIMER_ID+1, timer = "resultRankGaugeTimer"})
    table.insert(skin.customTimers, {id = resultObtained.RANKUP_TIMER}) -- ランクアップ時のタイマー

    table.insert(skin.image, {
        id = "purpleRed", src = 999, x = 3, y = 0, w = 1, h = 1
    })

    -- ランクフレーム
    table.insert(skin.image, {
        id = "rankFrame", src = 0, x = 680, y = 1387, w = RANK.FRAME.W, h = RANK.FRAME.H
    })
    table.insert(skin.image, {
        id = "rankCircle", src = 0, x = 1626, y = 1791, w = RANK.CIRCLE.SIZE, h = RANK.CIRCLE.SIZE
    })
    table.insert(skin.image, {
        id = "rankCircle2", src = 0, x = 1804, y = 1143, w = RANK.CIRCLE.SIZE_S, h = RANK.CIRCLE.SIZE_S
    })
    table.insert(skin.image, {
        id = "rankGaugeBg", src = 0, x = 1625, y = 1983, w = 1, h = RANK.GAUGE.H
    })
    table.insert(skin.image, {
        id = "rankReflection", src = 0, x = 1624, y = 1983, w = 1, h = RANK.GAUGE.H
    })
    -- ランク
    table.insert(skin.value, {
        id = "animationRankValue", src = 0, x = 1388, y = 225, w = RANK.RANK.NUM.W*10, h = RANK.RANK.NUM.H, divx = 10, digit = 3, align = 2, space = -2,
        value = function() return values.anim.rank end
    })
    table.insert(skin.text, {
        id = "rankText", font = 0, size = RANK.FONT_SIZE, constantText = "RANK", align = 1
    })
    -- nextと現在の経験値
    table.insert(skin.value, {
        id = "nextExpValue", src = NUM_36PX.SRC, x = NUM_36PX.SRC_X, y = NUM_36PX.SRC_Y, w = NUM_36PX.W * 10, h = NUM_36PX.H, divx = 10, digit = RANK.NEXT.DIGIT, align = 1,
        value = function() return userData.rank.getNext(values.anim.rank) end
    })
    table.insert(skin.image, {
        id = "nowExpSlash", src = NUM_36PX.SRC, x = 1789, y = 52, w = RANK.NEXT.SLASH.W, h = RANK.NEXT.SLASH.H
    })
    table.insert(skin.value, {
        id = "nowExpValue", src = NUM_36PX.SRC, x = NUM_36PX.SRC_X, y = NUM_36PX.SRC_Y, w = NUM_36PX.W * 10, h = NUM_36PX.H, divx = 10, digit = RANK.NEXT.DIGIT, align = 0,
        value = function() return userData.rank.getNowRankExp(values.anim.exp, values.anim.rank) end
    })
    -- あと
    table.insert(skin.image, {
        id = "nextRemaindExpText", src = 0, x = 649, y = 204, w = RANK.REMAIND.TEXT.W, h = RANK.REMAIND.TEXT.H
    })
    table.insert(skin.value, {
        id = "nextRemaindExpValue", src = 0, x = NUM_36PX_RICH.SRC_X, y = 362, w = NUM_36PX_RICH.W * 10, H = NUM_36PX_RICH.H, divx = 10, digit = 6, space = -2,
        value = function() return userData.rank.calcNext(values.anim.rank) end
    })
    -- 獲得量
    table.insert(skin.value, {
        id = "addExpValue", src = NUM_36PX.SRC, x = NUM_36PX_RICH.SRC_X, y = 302, w = NUM_36PX_RICH.W * 12, h = NUM_36PX_RICH.H * 2, divx = 12, divy = 2, digit = 7, space = -2,
        value = function() return values.add.exp end
    })
    -- コイン
    table.insert(skin.image, {
        id = "coin", src = 0, x = 715, y = 204, w = DROPS.COIN.SIZE, h = DROPS.COIN.SIZE
    })
    table.insert(skin.text, {
        id = "coinValue", font = 0, size = DROPS.COIN.NUM.SIZE, align = 2,
        value = function() return values.anim.coin end
    })
    -- 獲得量
    table.insert(skin.value, {
        id = "addCoinValue", src = NUM_36PX.SRC, x = NUM_36PX_RICH.SRC_X, y = 302, w = NUM_36PX_RICH.W * 12, h = NUM_36PX_RICH.H * 2, divx = 12, divy = 2, digit = 7, align = 1,
        value = function() return values.add.coin end
    })

    -- NO DROPS
    local msg = "スタミナが不足しているため, 報酬を獲得できません."
    if resultObtained.ramp <= 1 then
        msg = "FAILED, またはコース等かつFULLCOMBO未満の場合は報酬を獲得できません."
    end
    table.insert(skin.text, {
        id = "noDropMessageText", font = 0, size = NO_DROP.TEXT.SIZE, align = 1,
        constantText = msg
    })
end

resultObtained.functions.dst = function (skin)
    local dst = skin.destination
    local atime = resultObtained.APPEAR_TIME

    -- 背景
    dst[#dst+1] = {
        id = "background", timer = resultObtained.TIMER_ID, loop = atime, dst = {
            {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 0},
            {time = atime, a = 255}
        }
    }
    -- グラフ下
    dst[#dst+1] = {
        id = "rankGaugeBg", timer = resultObtained.TIMER_ID, loop = atime, dst = {
            {time = 0, x = RANK.GAUGE.X(RANK) + WIDTH, y = RANK.GAUGE.Y(RANK), w = RANK.GAUGE.W, h = RANK.GAUGE.H, acc = 2},
            {time = atime, x = RANK.GAUGE.X(RANK)}
        }
    }
    -- グラフ本体
    local p = math.min(userData.rank.getNowRankExp(resultObtained.val.before.exp, resultObtained.val.before.rank) / userData.rank.getNext(resultObtained.val.before.rank), 1)
    dst[#dst+1] = {
        id = "purpleRed", timer = resultObtained.TIMER_ID, loop = atime+1, dst = {
            {time = 0, x = RANK.GAUGE.X(RANK) + WIDTH, y = RANK.GAUGE.Y(RANK), w = RANK.GAUGE.W * p, h = RANK.GAUGE.H, acc = 2},
            {time = atime, x = RANK.GAUGE.X(RANK)},
            {time = atime+1, a = 0}
        }
    }
    dst[#dst+1] = {
        id = "purpleRed", timer = "resultRankGaugeTimer", loop = RANK.GAUGE.START_TIME + RANK.GAUGE.GAUGE_RANGE, dst = {
            {time = 0, x = RANK.GAUGE.X(RANK) + WIDTH, y = RANK.GAUGE.Y(RANK), w = RANK.GAUGE.W * p, h = RANK.GAUGE.H, a = 0, acc = 0},
            {time = atime, x = RANK.GAUGE.X(RANK)},
            {time = atime + 1, a = 255},

            {time = RANK.GAUGE.START_TIME, a = 255, w = 0},
            {time = RANK.GAUGE.START_TIME + RANK.GAUGE.GAUGE_RANGE, w = RANK.GAUGE.W},
        }
    }
    dst[#dst+1] = {
        id = "rankReflection", timer = resultObtained.TIMER_ID, loop = atime, dst = {
            {time = 0, x = RANK.GAUGE.X(RANK) + WIDTH, y = RANK.GAUGE.Y(RANK), w = RANK.GAUGE.W, h = RANK.GAUGE.H, acc = 2},
            {time = atime, x = RANK.GAUGE.X(RANK)}
        }
    }
    -- フレーム
    -- RANK部分背景
    dst[#dst+1] = { -- 出現前
        id = "rankCircle", timer = resultObtained.TIMER_ID, loop = atime+1, dst = {
            {time = 0, x = RANK.CIRCLE.X(RANK) + WIDTH, y = RANK.CIRCLE.Y(RANK), w = RANK.CIRCLE.SIZE, h = RANK.CIRCLE.SIZE, a = 0, acc = 2},
            {time = atime, x = RANK.CIRCLE.X(RANK)},
            {time = atime+1, a = 0},
        }
    }
    dst[#dst+1] = { -- 出現後に回るやつ
        id = "rankCircle", timer = resultObtained.TIMER_ID, loop = atime+1, filter = 1, dst = {
            {time = 0, x = RANK.CIRCLE.X(RANK) + WIDTH, y = RANK.CIRCLE.Y(RANK), w = RANK.CIRCLE.SIZE, h = RANK.CIRCLE.SIZE, a = 0},
            {time = atime, x = RANK.CIRCLE.X(RANK)},
            {time = atime+1, a = 255, angle = 0},
            {time = atime + RANK.CIRCLE.ROTATION_TIME, angle = 360},
        }
    }
    dst[#dst+1] = {
        id = "rankCircle2", timer = resultObtained.TIMER_ID, loop = atime, dst = {
            {time = 0, x = RANK.CIRCLE.X(RANK) + WIDTH + 6, y = RANK.CIRCLE.Y(RANK) + 6, w = RANK.CIRCLE.SIZE_S, h = RANK.CIRCLE.SIZE_S, acc = 2},
            {time = atime, x = RANK.CIRCLE.X(RANK) + 6},
        }
    }
    -- 本体
    dst[#dst+1] = {
        id = "rankFrame", timer = resultObtained.TIMER_ID, loop = atime, dst = {
            {time = 0, x = RANK.FRAME.X() + WIDTH, y = RANK.FRAME.Y(), w = RANK.FRAME.W, h = RANK.FRAME.H, acc = 2},
            {time = atime, x = RANK.FRAME.X()}
        }
    }
    -- ランクの文字と値
    dst[#dst+1] = {
        id = "rankText", timer = resultObtained.TIMER_ID, loop = atime, dst = {
            {time = 0, x = RANK.RANK.TEXT.X(RANK) + WIDTH, y = RANK.RANK.TEXT.Y(RANK), w = 300, h = RANK.FONT_SIZE, acc = 2, r = 0, g = 0, b = 0},
            {time = atime, x = RANK.RANK.TEXT.X(RANK)}
        }
    }
    dst[#dst+1] = {
        id = "animationRankValue", timer = resultObtained.TIMER_ID, loop = atime, dst = {
            {time = 0, x = RANK.RANK.NUM.X(RANK) + WIDTH, y = RANK.RANK.NUM.Y(RANK), w = RANK.RANK.NUM.W, h = RANK.RANK.NUM.H, acc = 2},
            {time = atime, x = RANK.RANK.NUM.X(RANK)}
        }
    }

    -- 獲得量
    dst[#dst+1] = {
        id = "addExpValue", timer = resultObtained.TIMER_ID, loop = atime + 400, dst = {
            {time = 0, x = RANK.NUM.ADD.X(RANK), y = RANK.NUM.ADD.Y(RANK) - 30, w = NUM_36PX_RICH.W, h = NUM_36PX_RICH.H, a = 0},
            {time = atime},
            {time = atime + 400, y = RANK.NUM.ADD.Y(RANK), a = 255},
        }
    }

    -- NEXT
    dst[#dst+1] = {
        id = "nextExpValue", timer = resultObtained.TIMER_ID, loop = atime, dst = {
            {time = 0, x = RANK.NEXT.NEXT.X(RANK) + WIDTH, y = RANK.NEXT.NEXT.Y(RANK), w = NUM_36PX.W, h = NUM_36PX.H, acc = 2, r = 42, g = 42, b = 42},
            {time = atime, x = RANK.NEXT.NEXT.X(RANK)}
        }
    }
    dst[#dst+1] = {
        id = "nowExpSlash", timer = resultObtained.TIMER_ID, loop = atime, dst = {
            {time = 0, x = RANK.NEXT.SLASH.X(RANK) + WIDTH, y = RANK.NEXT.SLASH.Y(RANK), w = RANK.NEXT.SLASH.W, h = RANK.NEXT.SLASH.H, acc = 2},
            {time = atime, x = RANK.NEXT.SLASH.X(RANK)}
        }
    }
    dst[#dst+1] = {
        id = "nowExpValue", timer = resultObtained.TIMER_ID, loop = atime, dst = {
            {time = 0, x = RANK.NEXT.NOW.X(RANK) + WIDTH, y = RANK.NEXT.NOW.Y(RANK), w = NUM_36PX.W, h = NUM_36PX.H, acc = 2, r = 42, g = 42, b = 42},
            {time = atime, x = RANK.NEXT.NOW.X(RANK)}
        }
    }

    -- 入手物周り
    local wndDst = {
        {time = 0, x = DROPS.WND.X() + WIDTH, y = DROPS.WND.Y(), w = DROPS.WND.W, h = DROPS.WND.H, acc = 2},
        {time = atime, x = DROPS.WND.X()}
    }
    destinationWindowWithTimer(skin, BASE_WINDOW.ID, BASE_WINDOW.EDGE_SIZE, BASE_WINDOW.SHADOW_LEN, {}, resultObtained.TIMER_ID, atime, wndDst)
    -- コイン
    dst[#dst+1] = {
        id = "coin", timer = resultObtained.TIMER_ID, loop = atime, dst = {
            {time = 0, x = DROPS.COIN.X(DROPS) + WIDTH, y = DROPS.COIN.Y(DROPS), w = DROPS.COIN.SIZE, h = DROPS.COIN.SIZE, acc = 2},
            {time = atime, x = DROPS.COIN.X(DROPS)}
        }
    }
    -- 現在値
    dst[#dst+1] = {
        id = "coinValue", timer = resultObtained.TIMER_ID, loop = atime, dst = {
            {time = 0, x = DROPS.COIN.NUM.X(DROPS) + WIDTH, y = DROPS.COIN.NUM.Y(DROPS), w = 999, h = DROPS.COIN.NUM.SIZE, acc = 2, r = 42, g = 42, b = 42},
            {time = atime, x = DROPS.COIN.NUM.X(DROPS)}
        }
    }
    -- 獲得量
    dst[#dst+1] = {
        id = "addCoinValue", timer = resultObtained.TIMER_ID, loop = atime + 400, dst = {
            {time = 0, x = DROPS.COIN.ADD_NUM.X(DROPS), y = DROPS.COIN.ADD_NUM.Y(DROPS) - 30, w = NUM_36PX_RICH.W, h = NUM_36PX_RICH.H, a = 0},
            {time = atime},
            {time = atime + 400, y = DROPS.COIN.ADD_NUM.Y(DROPS), a = 255}
        }
    }

    -- no drop
    if canGetDrops() == false then
        wndDst = {
            {time = 0, x = NO_DROP.WND.X() + WIDTH, y = NO_DROP.WND.Y(), w = NO_DROP.WND.W, h = NO_DROP.WND.H, acc = 2},
            {time = atime, x = NO_DROP.WND.X()}
        }
        destinationWindowWithTimer(skin, BASE_WINDOW.ID, BASE_WINDOW.EDGE_SIZE, BASE_WINDOW.SHADOW_LEN, {}, resultObtained.TIMER_ID, atime, wndDst)
        dst[#dst+1] = {
            id = "noDropMessageText", timer = resultObtained.TIMER_ID, loop = atime, dst = {
                {time = 0, x = NO_DROP.TEXT.X(NO_DROP) + WIDTH, y = NO_DROP.TEXT.Y(NO_DROP), w = 1330, h = NO_DROP.TEXT.SIZE, acc = 2, r = 42, g = 42, b = 42},
                {time = atime, x = NO_DROP.TEXT.X(NO_DROP)}
            }
        }
    end

    -- ランクアップ時のエフェクト
    dst[#dst+1] = {
        id = "rankShineCircle", timer = resultObtained.RANKUP_TIMER, loop = -1, blend = 2, dst = {
            {time = 0, x = RANK.RANK.SHINE.X(RANK), y = RANK.RANK.SHINE.Y(RANK), w = 0, h = 0},
            {
                time = 400 * 0.5,
                x = RANK.RANK.SHINE.X(RANK) - RANK.RANK.SHINE.MAX_SIZE / 2 * 0.75,
                y = RANK.RANK.SHINE.Y(RANK) - RANK.RANK.SHINE.MAX_SIZE / 2 * 0.75,
                w = RANK.RANK.SHINE.MAX_SIZE * 0.75, h = RANK.RANK.SHINE.MAX_SIZE * 0.75
            },
            {
                time = 400,
                x = RANK.RANK.SHINE.X(RANK) - RANK.RANK.SHINE.MAX_SIZE / 2,
                y = RANK.RANK.SHINE.Y(RANK) - RANK.RANK.SHINE.MAX_SIZE / 2,
                w = RANK.RANK.SHINE.MAX_SIZE, h = RANK.RANK.SHINE.MAX_SIZE,
                a = 0
            }
        }
    }
    dst[#dst+1] = {
        id = "rankShineCircle", timer = resultObtained.RANKUP_TIMER, loop = -1,  dst = {
            {time = 0, x = RANK.RANK.SHINE.X(RANK), y = RANK.RANK.SHINE.Y(RANK), w = 0, h = 0, a = 64},
            {
                time = 400 * 0.5,
                x = RANK.RANK.SHINE.X(RANK) - RANK.RANK.SHINE.MAX_SIZE / 2 * 0.75,
                y = RANK.RANK.SHINE.Y(RANK) - RANK.RANK.SHINE.MAX_SIZE / 2 * 0.75,
                w = RANK.RANK.SHINE.MAX_SIZE * 0.75, h = RANK.RANK.SHINE.MAX_SIZE * 0.75
            },
            {
                time = 400,
                x = RANK.RANK.SHINE.X(RANK) - RANK.RANK.SHINE.MAX_SIZE / 2,
                y = RANK.RANK.SHINE.Y(RANK) - RANK.RANK.SHINE.MAX_SIZE / 2,
                w = RANK.RANK.SHINE.MAX_SIZE, h = RANK.RANK.SHINE.MAX_SIZE,
                a = 0
            }
        }
    }
end

return resultObtained.functions