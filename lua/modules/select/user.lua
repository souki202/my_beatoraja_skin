local commons = require("modules.select.commons")
local main_state = require("main_state")

local selectUserdata = {
    functions = {}
}

local NORMAL_NUMBER_SRC_X = 946
local NORMAL_NUMBER_SRC_Y = commons.PARTS_OFFSET
local NORMAL_NUMBER_W = 15
local NORMAL_NUMBER_H = 21
local STATUS_NUMBER_W = 18
local STATUS_NUMBER_H = 23

-- 上部の統計情報的な部分の各種
local USER_DATA = {
    WND = {
        X = 72,
        Y = 976,
    },
    SLASH = {
        W = 5,
        H = 12,
    },
    NUM = {
        W = 10,
        H = 12,
    },
}

local RANK = {
    OLD = {
        NUM_W = 18,
        NUM_H = 24,
    },
    NEW = {
        NUM_W = 18,
        NUM_H = 24,
        X = 235, -- 影含まず
        Y = 59,
    },

    IMG = {
        W = 106,
        H = 46,
        X = 18,
        Y = 48,
    },
}

local EXP = {
    FRAME = {
        W = 222,
        H = 48,
        X = 18,
        Y = 2,
    },
    GAUGE = {
        X = 13,
        Y = 12,
        W = 196,
        H = 24,
    },
    NUM = {
        X = 190, -- gaugeからの差分
        Y = 6,
        DIGIT = 6,
    },
    SLASH = {
        Y = 6,
    },
    REFLECTION = {
        W = 37,
        H = 24,
    },
}

local STAMINA = { -- 座標はUSER_DATA.WNDからの差分
    LABEL = {
        X = 278,
        Y = 64,
        W = 106,
        H = 30,
    },
    HEAL = {
        PREFIX = {
            W = 29,
            H = 16,
            X = 284,
            Y = 50
        },
        TIME = {
            RANK_W = 16,
            RANK_H = 16,
            MIN_X = 324,
            MIN_Y = 50,
            SEC_X = 361,
            SEC_Y = 50,
            NUM_X = 324,
            NUM2_X = 361,
            NUM_Y = 52,
            NUM_W = 10,
            NUM_H = 12,
            MAX_X = 314,
            MAX_Y = 50,
            MAX_W = 33,
            MAX_H = 16
        },
    },
    GAUGE = {
        FRAME = {
            X = 388,
            Y = 46,
            W = 222,
            H = 48,
        },
        GAUGE = {
            X = 13,
            Y = 12,
            W = 196,
            H = 24,
        },
        REFLECTION = {
            W = 37,
            H = 24,
        },
        NUM = {
            X = 190, -- gaugeからの差分
            Y = 6,
            MAX_DIGIT = 3,
            NOW_DIGIT = 6,
        },
        SLASH = {
            Y = 6,
        },
    },
}

local MONEY = {
    COIN = {
        W = 33,
        H = 33,
        X = 285, -- USER_DATA.WNDからの差分
        Y = 5,
        NUM_X = 156, -- xからの差分
        NUM_Y = 8
    },
    DIA = {
        W = 40,
        H = 34,
        X = 451,
        Y = 5,
        NUM_X = 156, -- xからの差分
        NUM_Y = 8
    },
    NUM = {
        X = 156, -- 各xからの差分
        Y = 8,
        W = 13,
        H = 18,
    },
}



function calcStamina()
    local tn = main_state.number(74)
    if tn > 0 then
        switchVisibleNumber("useStaminaValue", true)
        setValue("useStaminaValue", userData.calcUseStamina(tn))
    else
        switchVisibleNumber("useStaminaValue", false)
    end
end

function updateStamina()
    if getFrame() % 60 == 0 then -- 単なる負荷軽減
        userData.updateRemainingStamina()
    end
end

function updateStaminaGauge()
    local p = userData.stamina.now / userData.stamina.tbl[userData.rank.rank]
    p = math.max(0, math.min(p, 1))
    return main_state.time() - p * 20 * 1000 * 1000
end

function updateUseStamina()
    if getFrame() % 20 == 0 then -- 単なる負荷軽減
        local tn = main_state.number(106)
        if tn > 0 then
            local requireStamina = userData.calcUseStamina(tn)
            setValue("useStaminaValue", requireStamina)
            switchVisibleNumber("useStaminaValue", true)
        else
            switchVisibleNumber("useStaminaValue", false)
        end
    end
end

selectUserdata.functions.init = function ()
    -- 無し. global initialize側でユーザデータは読み込んでいる
end

selectUserdata.functions.load = function (skin)
    local imgs = skin.image
    local vals = skin.value
    -- 上部プレイヤー情報 expゲージの背景とゲージ本体は汎用カラー
    imgs[#imgs+1] = {id = "rankTextImg", src = 0, x = 1298, y = commons.PARTS_OFFSET + 267, w = RANK.IMG.W, h = RANK.IMG.H}
    imgs[#imgs+1] = {id = "coin", src = 0, x = 1410, y = commons.PARTS_OFFSET + 263, w = MONEY.COIN.W, h = MONEY.COIN.H}
    imgs[#imgs+1] = {id = "dia", src = 0, x = 1410 + MONEY.COIN.W, y = commons.PARTS_OFFSET + 263, w = MONEY.DIA.W, h = MONEY.DIA.H}
    imgs[#imgs+1] = {id = "expGaugeFrame", src = 0, x = 1298, y = commons.PARTS_OFFSET + 313, w = EXP.FRAME.W, h = EXP.FRAME.H}
    imgs[#imgs+1] = {id = "expGaugeNew", src = 0, x = PARTS_TEXTURE_SIZE - 10, y = commons.PARTS_OFFSET + 1, w = 1, h = 1}
    imgs[#imgs+1] = {id = "gaugeReflection", src = 0, x = 1520, y = commons.PARTS_OFFSET + 313, w = EXP.REFLECTION.W, h = EXP.REFLECTION.H}
    imgs[#imgs+1] = {id = "staminaTextImg", src = 0, x = 1434, y = commons.PARTS_OFFSET + 361, w = STAMINA.LABEL.W, h = STAMINA.LABEL.H}
    imgs[#imgs+1] = {id = "staminaRemainPrefix", src = 0, x = 1557, y = commons.PARTS_OFFSET + 311, w = STAMINA.HEAL.PREFIX.W, h = STAMINA.HEAL.PREFIX.H}
    imgs[#imgs+1] = {id = "staminaMinuteText", src = 0, x = 1557 + STAMINA.HEAL.PREFIX.W, y = commons.PARTS_OFFSET + 311, w = STAMINA.HEAL.TIME.RANK_W, h = STAMINA.HEAL.TIME.RANK_H}
    imgs[#imgs+1] = {id = "staminaSecondText", src = 0, x = 1557 + STAMINA.HEAL.PREFIX.W + STAMINA.HEAL.TIME.RANK_W, y = commons.PARTS_OFFSET + 311, w = STAMINA.HEAL.TIME.RANK_W, h = STAMINA.HEAL.TIME.RANK_H}
    imgs[#imgs+1] = {id = "staminaMaxText", src = 0, x = 1557 + STAMINA.HEAL.PREFIX.W + STAMINA.HEAL.TIME.RANK_W + STAMINA.HEAL.TIME.RANK_W, y = commons.PARTS_OFFSET + 311, w = STAMINA.HEAL.TIME.MAX_W, h = STAMINA.HEAL.TIME.MAX_H}
    imgs[#imgs+1] = {id = "userStatusValueSlash", src = 0, x = 1534, y = commons.PARTS_OFFSET + 391, w = USER_DATA.SLASH.W, h = USER_DATA.SLASH.H}
    -- 上部プレイヤー情報
    vals[#vals+1] = {id = "numOfCoin", src = 0, x = 1434, y = commons.PARTS_OFFSET + 403, w = MONEY.NUM.W * 10, h = MONEY.NUM.H, divx = 10, digit = 8, ref = 33, align = 0}
    vals[#vals+1] = {id = "numOfDia", src = 0, x = 1434, y = commons.PARTS_OFFSET + 403, w = MONEY.NUM.W * 10, h = MONEY.NUM.H, divx = 10, digit = 8, ref = 30, align = 0}
    vals[#vals+1] = {id = "oldRankValue", src = 0, x = NORMAL_NUMBER_SRC_X, y = commons.PARTS_OFFSET + NORMAL_NUMBER_H + STATUS_NUMBER_H, w = RANK.OLD.NUM_W * 10, h = RANK.OLD.NUM_H, divx = 10, digit = 4, ref = 17, align = 0}
    vals[#vals+1] = {id = "rankValue", src = 0, x = NORMAL_NUMBER_SRC_X, y = commons.PARTS_OFFSET + NORMAL_NUMBER_H + STATUS_NUMBER_H, w = RANK.OLD.NUM_W * 10, h = RANK.OLD.NUM_H, divx = 10, digit = 4, align = 0, value = function() return userData.rank.rank end}
    vals[#vals+1] = {id = "expGauge", src = 0, x = PARTS_TEXTURE_SIZE - 10, y = commons.PARTS_OFFSET, w = 10, h = 10, divy = 10, digit = 1, ref = 31, align = 1}
    vals[#vals+1] = {id = "expGaugeRemnant", src = 0, x = PARTS_TEXTURE_SIZE - 10, y = commons.PARTS_OFFSET + 10, w = 10, h = 10, divy = 10, digit = 1, ref = 31, align = 1}
    -- rank
    vals[#vals+1] = {id = "expNextValue", src = 0, x = 1434, y = commons.PARTS_OFFSET + 391, w = USER_DATA.NUM.W * 10, h = USER_DATA.NUM.H, divx = 10, digit = 6, space = -1, value = function() return userData.rank.tbl[userData.rank.rank] - userData.rank.tbl[userData.rank.rank - 1] end}
    vals[#vals+1] = {id = "expNowValue", src = 0, x = 1434, y = commons.PARTS_OFFSET + 391, w = USER_DATA.NUM.W * 10, h = USER_DATA.NUM.H, divx = 10, digit = 6, space = -1, value = function() return userData.rank.exp - userData.rank.tbl[userData.rank.rank - 1] end}
    -- stamina
    vals[#vals+1] = {id = "staminaMaxValue", src = 0, x = 1434, y = commons.PARTS_OFFSET + 391, w = USER_DATA.NUM.W * 10, h = USER_DATA.NUM.H, divx = 10, divy = 1, space = -1, digit = STAMINA.GAUGE.NUM.MAX_DIGIT, value = function() return userData.stamina.tbl[userData.rank.rank] end}
    vals[#vals+1] = {id = "staminaNowValue", src = 0, x = 1434, y = commons.PARTS_OFFSET + 391, w = USER_DATA.NUM.W * 10, h = USER_DATA.NUM.H, divx = 10, divy = 1, space = -1, digit = STAMINA.GAUGE.NUM.NOW_DIGIT, value = function() return userData.stamina.now end}
    vals[#vals+1] = {
        id = "nextStaminaHealMinute", src = 0, x = 1434, y = commons.PARTS_OFFSET + 391, w = USER_DATA.NUM.W * 10, h = USER_DATA.NUM.H, divx = 10, divy = 1, digit = 2, space = -1,
        value = function()
            local m, _ = userData.getNextHealStaminaRemainTime()
            return m
        end
    }
    vals[#vals+1] = {
        id = "nextStaminaHealSecond", src = 0, x = 1434, y = commons.PARTS_OFFSET + 391, w = USER_DATA.NUM.W * 10, h = USER_DATA.NUM.H, divx = 10, divy = 1, digit = 2, space = -1,
        value = function()
            local _, s = userData.getNextHealStaminaRemainTime()
            return s
        end
    }
end

selectUserdata.functions.dst = function (skin)
    local dst = skin.destination
    dst[#dst+1] = {
        id = "rankTextImg", dst = {
            {x = USER_DATA.WND.X + RANK.IMG.X, y = USER_DATA.WND.Y + RANK.IMG.Y, w = RANK.IMG.W, h = RANK.IMG.H}
        }
    }
    dst[#dst+1] = {
        id = "coin", dst = {
            {x = USER_DATA.WND.X + MONEY.COIN.X, y = USER_DATA.WND.Y + MONEY.COIN.Y, w = MONEY.COIN.W, h = MONEY.COIN.H}
        }
    }
    dst[#dst+1] = {
        id = "dia", dst = {
            {x = USER_DATA.WND.X + MONEY.DIA.X, y = USER_DATA.WND.Y + MONEY.DIA.Y, w = MONEY.DIA.W, h = MONEY.DIA.H}
        }
    }
    dst[#dst+1] = {
        id = "numOfCoin", dst = {
            {x = USER_DATA.WND.X + MONEY.COIN.X + MONEY.NUM.X - MONEY.NUM.W * 8, y = USER_DATA.WND.Y + MONEY.COIN.Y + MONEY.NUM.Y, w = MONEY.NUM.W, h = MONEY.NUM.H}
        }
    }
    dst[#dst+1] = {
        id = "numOfDia", dst = {
            {x = USER_DATA.WND.X + MONEY.DIA.X + MONEY.NUM.X - MONEY.NUM.W * 8, y = USER_DATA.WND.Y + MONEY.DIA.Y + MONEY.NUM.Y, w = MONEY.NUM.W, h = MONEY.NUM.H}
        }
    }

    -- プレイヤーのランク出力
    if getTableValue(skin_config.option, "上部プレイヤー情報仕様", 950) == 951 then
        dst[#dst+1] = {
            id = "oldRankValue", dst = {
                {x = USER_DATA.WND.X + RANK.NEW.X - RANK.OLD.NUM_W * 4, y = USER_DATA.WND.Y + RANK.NEW.Y, w = RANK.OLD.NUM_W, h = RANK.OLD.NUM_H}
            }
        }
    elseif getTableValue(skin_config.option, "上部プレイヤー情報仕様", 950) == 950 then
        dst[#dst+1] = {
            id = "rankValue", dst = {
                {x = USER_DATA.WND.X + RANK.NEW.X - RANK.NEW.NUM_W * 4, y = USER_DATA.WND.Y + RANK.NEW.Y, w = RANK.NEW.NUM_W, h = RANK.NEW.NUM_H}
            }
        }
    end

    -- 経験値バー出力
    do
        local frameX = USER_DATA.WND.X + EXP.FRAME.X
        local frameY = USER_DATA.WND.Y + EXP.FRAME.Y
        local gaugeX = frameX + EXP.GAUGE.X
        local gaugeY = frameY + EXP.GAUGE.Y
        dst[#dst+1] = {
            id = "white", dst = {
                {x = gaugeX , y = gaugeY, w = EXP.GAUGE.W, h = EXP.GAUGE.H}
            }
        }
        if getTableValue(skin_config.option, "上部プレイヤー情報仕様", 950) == 951 then
            dst[#dst+1] = {
                id = "expGauge", dst = {
                    {x = gaugeX, y = gaugeY, w = EXP.GAUGE.W, h = EXP.GAUGE.H}
                }
            }
        elseif getTableValue(skin_config.option, "上部プレイヤー情報仕様", 950) == 950 then
            local now = userData.rank.getSumExp(userData.rank.rank - 1)
            local next = userData.rank.getSumExp(userData.rank.rank)
            local p = (userData.rank.exp - now) / (next - now)
            myPrint("現在レベルの累計経験値: " .. now)
            myPrint("次レベルの必要累計経験値: " .. next)
            myPrint("次レベルまでの経験値の進行度: " .. p)
            p = math.max(0, math.min(p, 1))
            dst[#dst+1] = {
                id = "expGaugeNew", dst = {
                    {x = gaugeX, y = gaugeY, w = EXP.GAUGE.W * p, h = EXP.GAUGE.H}
                }
            }
        end
        dst[#dst+1] = {
            id = "gaugeReflection", loop = 0, dst = {
                {time = 0, x = gaugeX - 8, y = gaugeY, w = 8, h = EXP.REFLECTION.H, a = 196},
                {time = 4000},
                {time = 4070, w = EXP.REFLECTION.W * 1.5},
                {time = 4680, x = gaugeX + EXP.GAUGE.W - EXP.REFLECTION.W * 1.5},
                {time = 4750, x = gaugeX + EXP.GAUGE.W, w = 8},
            }
        }
        dst[#dst+1] = {
            id = "expGaugeFrame", dst = {
                {x = frameX, y = frameY, w = EXP.FRAME.W, h = EXP.FRAME.H}
            }
        }

        if getTableValue(skin_config.option, "上部プレイヤー情報仕様", 950) == 950 then
            local sub = 20
            local now = userData.rank.exp

            if userData.rank.rank > 1 then
                sub = userData.rank.tbl[userData.rank.rank] - userData.rank.tbl[userData.rank.rank - 1]
                now = userData.rank.exp - userData.rank.tbl[userData.rank.rank - 1]
            end

            -- 次レベルの, 現在レベルとの相対経験値を表示
            dst[#dst+1] = {
                id = "expNextValue", dst = {
                    {x = gaugeX + EXP.NUM.X - (USER_DATA.NUM.W - 1) * EXP.NUM.DIGIT, y = gaugeY + EXP.NUM.Y, w = USER_DATA.NUM.W, h = USER_DATA.NUM.H}
                }
            }

            -- スラッシュ
            local offsetX = calcValueDigit(sub, false) * (USER_DATA.NUM.W - 1) + 3
            myPrint("経験値の数値表示オフセット: " .. offsetX)
            dst[#dst+1] = {
                id = "userStatusValueSlash", dst = {
                    {x = gaugeX + EXP.NUM.X - offsetX - USER_DATA.SLASH.W, y = gaugeY + EXP.SLASH.Y, w = USER_DATA.SLASH.W, h = USER_DATA.SLASH.H}
                }
            }

            -- 現在値
            dst[#dst+1] = {
                id = "expNowValue", dst = {
                    {x = gaugeX + EXP.NUM.X - offsetX - USER_DATA.SLASH.W - 2 - (USER_DATA.NUM.W - 1) * EXP.NUM.DIGIT, y = gaugeY + EXP.NUM.Y, w = USER_DATA.NUM.W, h = USER_DATA.NUM.H}
                }
            }
        end
    end

    -- スタミナ表示
    do
        -- ラベル部分
        dst[#dst+1] = {
            id = "staminaTextImg", dst = {
                {x = USER_DATA.WND.X + STAMINA.LABEL.X, y = USER_DATA.WND.Y + STAMINA.LABEL.Y, w = STAMINA.LABEL.W, h = STAMINA.LABEL.H}
            }
        }
        -- "あと"の文字
        dst[#dst+1] = {
            id = "staminaRemainPrefix", draw = function() return not userData.getIsMaxStamina() end, dst = {
                {x = USER_DATA.WND.X + STAMINA.HEAL.PREFIX.X, y = USER_DATA.WND.Y + STAMINA.HEAL.PREFIX.Y, w = STAMINA.HEAL.PREFIX.W, h = STAMINA.HEAL.PREFIX.H}
            }
        }

        -- 分の値
        dst[#dst+1] = {
            id = "nextStaminaHealMinute", draw = function() return not userData.getIsMaxStamina() end, dst = {
                {x = USER_DATA.WND.X + STAMINA.HEAL.TIME.NUM_X - USER_DATA.NUM.W * 2 + 1, y = USER_DATA.WND.Y + STAMINA.HEAL.TIME.NUM_Y, w = USER_DATA.NUM.W, h = USER_DATA.NUM.H}
            }
        }
        -- 分の文字
        dst[#dst+1] = {
            id = "staminaMinuteText", draw = function() return not userData.getIsMaxStamina() end, dst = {
                {x = USER_DATA.WND.X + STAMINA.HEAL.TIME.MIN_X, y = USER_DATA.WND.Y + STAMINA.HEAL.TIME.MIN_Y, w = STAMINA.HEAL.TIME.RANK_W, h = STAMINA.HEAL.TIME.RANK_H}
            }
        }
        -- 秒の値
        dst[#dst+1] = {
            id = "nextStaminaHealSecond", draw = function() return not userData.getIsMaxStamina() end, dst = {
                {x = USER_DATA.WND.X + STAMINA.HEAL.TIME.NUM2_X - USER_DATA.NUM.W * 2, y = USER_DATA.WND.Y + STAMINA.HEAL.TIME.NUM_Y, w = USER_DATA.NUM.W, h = USER_DATA.NUM.H}
            }
        }
        -- 秒の文字
        dst[#dst+1] = {
            id = "staminaSecondText", draw = function() return not userData.getIsMaxStamina() end, dst = {
                {x = USER_DATA.WND.X + STAMINA.HEAL.TIME.SEC_X, y = USER_DATA.WND.Y + STAMINA.HEAL.TIME.SEC_Y, w = STAMINA.HEAL.TIME.RANK_W, h = STAMINA.HEAL.TIME.RANK_H}
            }
        }
        -- MAXの文字
        dst[#dst+1] = {
            id = "staminaMaxText", draw = function() return userData.getIsMaxStamina() end, dst = {
                {x = USER_DATA.WND.X + STAMINA.HEAL.TIME.MAX_X, y = USER_DATA.WND.Y + STAMINA.HEAL.TIME.MAX_Y, w = STAMINA.HEAL.TIME.MAX_W, h = STAMINA.HEAL.TIME.MAX_H}
            }
        }

        -- スタミナのゲージ
        local frameX = USER_DATA.WND.X + STAMINA.GAUGE.FRAME.X
        local frameY = USER_DATA.WND.Y + STAMINA.GAUGE.FRAME.Y
        local gaugeX = frameX + STAMINA.GAUGE.GAUGE.X
        local gaugeY = frameY + STAMINA.GAUGE.GAUGE.Y
        dst[#dst+1] = {
            id = "white", dst = {
                {x = gaugeX , y = gaugeY, w = STAMINA.GAUGE.GAUGE.W, h = STAMINA.GAUGE.GAUGE.H}
            }
        }
        -- スタミナ本体
        local p = userData.stamina.now / userData.stamina.tbl[userData.rank.rank]
        dst[#dst+1] = {
            id = "white", timer = 10006, dst = {
                {time = 0, x = gaugeX, y = gaugeY, w = 0, h = EXP.GAUGE.H, r = 255, g = 227, b = 98},
                {time = 20000, x = gaugeX, y = gaugeY, w = STAMINA.GAUGE.GAUGE.W, h = STAMINA.GAUGE.GAUGE.H},
                {time = 100000}
            }
        }
        -- フレームと反射
        dst[#dst+1] = {
            id = "gaugeReflection", loop = 0, dst = {
                {time = 0, x = gaugeX - 8, y = gaugeY, w = 8, h = STAMINA.GAUGE.REFLECTION.H, a = 196},
                {time = 4000},
                {time = 4070, w = STAMINA.GAUGE.REFLECTION.W * 1.5},
                {time = 4680, x = gaugeX + STAMINA.GAUGE.GAUGE.W - STAMINA.GAUGE.REFLECTION.W * 1.5},
                {time = 4750, x = gaugeX + STAMINA.GAUGE.GAUGE.W, w = 8},
            }
        }
        dst[#dst+1] = {
            id = "expGaugeFrame", dst = {
                {x = frameX, y = frameY, w = STAMINA.GAUGE.FRAME.W, h = STAMINA.GAUGE.FRAME.H}
            }
        }

        -- スタミナ数値表示
        -- 最大値
        dst[#dst+1] = {
            id = "staminaMaxValue", dst = {
                {x = gaugeX + STAMINA.GAUGE.NUM.X - USER_DATA.NUM.W * STAMINA.GAUGE.NUM.MAX_DIGIT, y = gaugeY + STAMINA.GAUGE.NUM.Y, w = USER_DATA.NUM.W, h = USER_DATA.NUM.H}
            }
        }
        -- 最大値の桁数分だけずらす
        local offsetX = calcValueDigit(userData.stamina.tbl[userData.rank.rank], false) * USER_DATA.NUM.W + 2
        myPrint("スタミナの数値表示オフセット: " .. offsetX)
        -- スラッシュ
        dst[#dst+1] = {
            id = "userStatusValueSlash", dst = {
                {x = gaugeX + STAMINA.GAUGE.NUM.X - offsetX - USER_DATA.SLASH.W, y = gaugeY + STAMINA.GAUGE.SLASH.Y, w = USER_DATA.SLASH.W, h = USER_DATA.SLASH.H}
            }
        }
        -- 現在値
        dst[#dst+1] = {
            id = "staminaNowValue", dst = {
                {x = gaugeX + STAMINA.GAUGE.NUM.X - offsetX - USER_DATA.SLASH.W - 2 - (USER_DATA.NUM.W - 1) * STAMINA.GAUGE.NUM.NOW_DIGIT, y = gaugeY + STAMINA.GAUGE.NUM.Y, w = USER_DATA.NUM.W, h = USER_DATA.NUM.H}
            }
        }
    end
end

return selectUserdata.functions