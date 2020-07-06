local commons = require("modules.select.commons")

local course = {
    functions = {}
}
local COURSE_FONT_SIZE = 32

-- コース表示
local COURSE = {
    BG_W = 772,
    LABEL_W = 192,
    LABEL_H = 64,
    INTERVAL_Y = 64 + 16,
    SONGNAME_W = 538,
    BASE_Y = 832,

    OPTION = {
        BASE_X = 65,
        BASE_Y = 434,

        BG_W = 694 + 14,
        BG_H = 64 + 14,
        BG_EDGE_W = 17,
        SETTING_START_X = 87,
        HEADER_OFFSET_Y = 47,
        VALUE_OFFSET_Y = 18,
        HEADER_W = 120,
        HEADER_H = 20,
        INTERVAL_X = 136,
        VALUE_W = 120,
        VALUE_H = 18,
    },
}

course.functions.load = function ()
    return {
        image = {
            -- 段位, コースの曲一覧部分
            {id = "courseBarBg", src = 0, x = 0, y = commons.PARTS_OFFSET + 468, w = COURSE.BG_W, h = COURSE.LABEL_H + 14},
            {id = "courseMusic1Label", src = 0, x = 773, y = commons.PARTS_OFFSET + 519 + COURSE.LABEL_H*0, w = COURSE.LABEL_W, h = COURSE.LABEL_H},
            {id = "courseMusic2Label", src = 0, x = 773, y = commons.PARTS_OFFSET + 519 + COURSE.LABEL_H*1, w = COURSE.LABEL_W, h = COURSE.LABEL_H},
            {id = "courseMusic3Label", src = 0, x = 773, y = commons.PARTS_OFFSET + 519 + COURSE.LABEL_H*2, w = COURSE.LABEL_W, h = COURSE.LABEL_H},
            {id = "courseMusic4Label", src = 0, x = 773, y = commons.PARTS_OFFSET + 519 + COURSE.LABEL_H*3, w = COURSE.LABEL_W, h = COURSE.LABEL_H},
            {id = "courseMusic5Label", src = 0, x = 773, y = commons.PARTS_OFFSET + 519 + COURSE.LABEL_H*4, w = COURSE.LABEL_W, h = COURSE.LABEL_H},
            -- コースのオプション
            {id = "courseBgEdgeLeft"   , src = 0, x = 1811                              , y = PARTS_TEXTURE_SIZE - COURSE.OPTION.BG_H, w = COURSE.OPTION.BG_EDGE_W, h = COURSE.OPTION.BG_H},
            {id = "courseBgMiddle"     , src = 0, x = 1811 + COURSE.OPTION.BG_EDGE_W    , y = PARTS_TEXTURE_SIZE - COURSE.OPTION.BG_H, w = 1, h = COURSE.OPTION.BG_H},
            {id = "courseBgMiddleRight", src = 0, x = 1811 + COURSE.OPTION.BG_EDGE_W + 1, y = PARTS_TEXTURE_SIZE - COURSE.OPTION.BG_H, w = COURSE.OPTION.BG_EDGE_W, h = COURSE.OPTION.BG_H},
            {id = "courseHeaderBg"     , src = 0, x = 1898, y = commons.PARTS_OFFSET + 168 + COURSE.OPTION.HEADER_H*0, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H},
            {id = "courseHeaderOption" , src = 0, x = 1898, y = commons.PARTS_OFFSET + 168 + COURSE.OPTION.HEADER_H*1, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H},
            {id = "courseHeaderHiSpeed", src = 0, x = 1898, y = commons.PARTS_OFFSET + 168 + COURSE.OPTION.HEADER_H*2, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H},
            {id = "courseHeaderJudge"  , src = 0, x = 1898, y = commons.PARTS_OFFSET + 168 + COURSE.OPTION.HEADER_H*3, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H},
            {id = "courseHeaderGauge"  , src = 0, x = 1898, y = commons.PARTS_OFFSET + 168 + COURSE.OPTION.HEADER_H*4, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H},
            {id = "courseHeaderLnType" , src = 0, x = 1898, y = commons.PARTS_OFFSET + 168 + COURSE.OPTION.HEADER_H*5, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H},
            {id = "courseSettingClass"      , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*0, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingMirror"     , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*1, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingRandom"     , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*2, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingNoSpeed"    , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*3, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingNoGood"     , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*4, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingNoGreat"    , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*5, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingGaugeLR2"   , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*6, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingGauge5Keys" , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*7, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingGauge7Keys" , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*8, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingGauge9Keys" , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*9, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingGauge24Keys", src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*10, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingGaugeLn"    , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*11, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingGaugeCn"    , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*12, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingGaugeHcn"   , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*13, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
            {id = "courseSettingNoSetting"  , src = 0, x = 1898, y = commons.PARTS_OFFSET + 288 + COURSE.OPTION.VALUE_H*14, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H},
        },
        text = {
            {id = "course1Text", font = 0, size = COURSE_FONT_SIZE, ref = 150, align = 2, overflow = 1},
            {id = "course2Text", font = 0, size = COURSE_FONT_SIZE, ref = 151, align = 2, overflow = 1},
            {id = "course3Text", font = 0, size = COURSE_FONT_SIZE, ref = 152, align = 2, overflow = 1},
            {id = "course4Text", font = 0, size = COURSE_FONT_SIZE, ref = 153, align = 2, overflow = 1},
            {id = "course5Text", font = 0, size = COURSE_FONT_SIZE, ref = 154, align = 2, overflow = 1},
        }
    }
end

course.functions.dst = function ()
    local skin = {destination = {
        -- コース曲一覧表示は下のforで
        -- コースオプション
        -- BG
        {
            id = "courseBgEdgeLeft", op = {3}, dst = {
                {x = COURSE.OPTION.BASE_X, y = COURSE.OPTION.BASE_Y, w = COURSE.OPTION.BG_EDGE_W, h = COURSE.OPTION.BG_H}
            }
        },
        {
            id = "courseBgMiddle", op = {3}, dst = {
                {x = COURSE.OPTION.BASE_X + COURSE.OPTION.BG_EDGE_W, y = COURSE.OPTION.BASE_Y, w = COURSE.OPTION.BG_W - COURSE.OPTION.BG_EDGE_W * 2, h = COURSE.OPTION.BG_H}
            }
        },
        {
            id = "courseBgMiddleRight", op = {3}, dst = {
                {x = COURSE.OPTION.BASE_X + COURSE.OPTION.BG_W - COURSE.OPTION.BG_EDGE_W, y = COURSE.OPTION.BASE_Y, w = COURSE.OPTION.BG_EDGE_W, h = COURSE.OPTION.BG_H}
            }
        },
        -- 値
        -- 譜面オプション
        {
            id = "courseHeaderBg", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseHeaderOption", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseSettingClass", op = {3, 1002}, dst = {
                {x = COURSE.OPTION.SETTING_START_X, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingMirror", op = {3, 1003}, dst = {
                {x = COURSE.OPTION.SETTING_START_X, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingRandom", op = {3, 1004}, dst = {
                {x = COURSE.OPTION.SETTING_START_X, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingNoSetting", op = {3, -1002, -1003, -1004}, dst = {
                {x = COURSE.OPTION.SETTING_START_X, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        -- ハイスピ
        {
            id = "courseHeaderBg", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*1, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseHeaderHiSpeed", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*1, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseSettingNoSpeed", op = {3, 1005}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*1, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingNoSetting", op = {3, -1005}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*1, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        -- 判定
        {
            id = "courseHeaderBg", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*2, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseHeaderJudge", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*2, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseSettingNoGood", op = {3, 1006}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*2, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingNoGreat", op = {3, 1007}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*2, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingNoSetting", op = {3, -1006, -1007}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*2, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        -- ゲージ
        {
            id = "courseHeaderBg", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseHeaderGauge", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseSettingGaugeLR2", op = {3, 1010}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingGauge5Keys", op = {3, 1011}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingGauge7Keys", op = {3, 1012}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingGauge9Keys", op = {3, 1013}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingGauge24Keys", op = {3, 1014}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingNoSetting", op = {3, -1010, -1011, -1012, -1013, -1014}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*3, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        -- LN
        {
            id = "courseHeaderBg", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*4, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseHeaderLnType", op = {3}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*4, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.HEADER_OFFSET_Y, w = COURSE.OPTION.HEADER_W, h = COURSE.OPTION.HEADER_H}
            }
        },
        {
            id = "courseSettingGaugeLn", op = {3, 1015}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*4, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingGaugeCn", op = {3, 1016}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*4, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingGaugeHcn", op = {3, 1017}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*4, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
        {
            id = "courseSettingNoSetting", op = {3, -1015, -1016, -1017}, dst = {
                {x = COURSE.OPTION.SETTING_START_X + COURSE.OPTION.INTERVAL_X*4, y = COURSE.OPTION.BASE_Y + COURSE.OPTION.VALUE_OFFSET_Y, w = COURSE.OPTION.VALUE_W, h = COURSE.OPTION.VALUE_H}
            }
        },
    }}
    -- コースの曲一覧
    for i = 1, 5 do
        local y = COURSE.BASE_Y - COURSE.INTERVAL_Y * (i - 1) -- 14は上下の影
        -- 背景
        table.insert(skin.destination, {
            id = "courseBarBg", op = {3}, dst = {
                {x = 0, y = y, w = COURSE.BG_W, h = COURSE.LABEL_H + 14}
            }
        })
        -- 1st等のラベル
        table.insert(skin.destination, {
            id = "courseMusic" .. i .. "Label", op = {3}, dst = {
                {x = -2, y = y + 7, w = COURSE.LABEL_W, h = COURSE.LABEL_H}
            }
        })
        -- 曲名
        table.insert(skin.destination, {
            id = "course" .. i .. "Text", op = {3}, filter = 1, dst = {
                {x = 750, y = y + 20, w = COURSE.SONGNAME_W, h = COURSE_FONT_SIZE, r = 0, g = 0, b = 0}
            }
        })
    end
    return skin
end

return course.functions