local commons = require("modules.select.commons")
local TEXTURE_SIZE = 2048

SIMPLE_WND_AREA = {
    X = 160,
    Y = 90,
    W = 1600,
    H = 900
}

POPUP_WINDOW_SELECT = {
    SHADOW_LEN = 0,
    EDGE_SIZE = 32,
    ID = {
        UPPER_LEFT   = "popUpWindowUpperLeft",
        UPPER_RIGHT  = "popUpWindowUpperRight",
        BOTTOM_RIGHT = "popUpWindowBottomRight",
        BOTTOM_LEFT  = "popUpWindowBottomLeft",
        TOP          = "popUpWindowTopEdge",
        LEFT         = "popUpWindowLeftEdge",
        BOTTOM       = "popUpWindowBottomEdge",
        RIGHT        = "popUpWindowRightEdge",
        BODY         = "popUpWindowBody",
    },
    SRC_X = 1908,
    SRC_Y = TEXTURE_SIZE - (32 * 2 + 0 * 2 + 1),
}

BASE_WINDOW = {
    SHADOW_LEN = 7,
    EDGE_SIZE = 10,
    ID = {
       UPPER_LEFT   = "baseWindowUpperLeft",
       UPPER_RIGHT  = "baseWindowUpperRight",
       BOTTOM_RIGHT = "baseWindowBottomRight",
       BOTTOM_LEFT  = "baseWindowBottomLeft",
       TOP    = "baseWindowTopEdge",
       LEFT   = "baseWindowLeftEdge",
       BOTTOM = "baseWindowBottomEdge",
       RIGHT  = "baseWindowRightEdge",
       BODY = "baseWindowBody",
    }
}

RESULT_BASE_WINDOW = {
    SHADOW_LEN = 14,
    EDGE_SIZE = 10,
    ID = {
       UPPER_LEFT   = "baseWindowUpperLeft",
       UPPER_RIGHT  = "baseWindowUpperRight",
       BOTTOM_RIGHT = "baseWindowBottomRight",
       BOTTOM_LEFT  = "baseWindowBottomLeft",
       TOP    = "baseWindowTopEdge",
       LEFT   = "baseWindowLeftEdge",
       BOTTOM = "baseWindowBottomEdge",
       RIGHT  = "baseWindowRightEdge",
       BODY = "baseWindowBody",
    }
}

HEADER = {
    MARKER = {
        X = 32,
        Y = 842,
        W = 16,
        H = 42,
    },
    UNDERBAR = {
        X = 52,
        Y = 842,
        W = 1516,
        H = 2,
    },
    TEXT = {
        X = 62,
        Y = 844,
        W = 1516,
        FONT_SIZE = 30,
    }
}

SUB_HEADER = {
    EDGE = { -- 本体は計算する
        W = 16,
        H = 42,
        LEFT_ID = "subHeaderLeft",
        RIGHT_ID = "subHeaderRight",
    },
    FONT_SIZE = 24,
}

CLOSE_BUTTON = {
    SRC_X = 1557,
    SRC_Y = commons.PARTS_OFFSET + 771,
    W = 142,
    H = 62,
    Y = 12,
}

-- idsの中身はすべてこれにする
-- {
--     UPPER_LEFT,
--     UPPER_RIGHT,
--     BOTTOM_RIGHT,
--     BOTTOM_LEFT,
--     TOP,
--     LEFT,
--     BOTTOM,
--     RIGHT,
--     BODY,
-- }

function loadPopupWindowSelect(skin)
    loadWindow(
        skin,
        POPUP_WINDOW_SELECT.ID,
        POPUP_WINDOW_SELECT.SRC_X,
        POPUP_WINDOW_SELECT.SRC_Y,
        POPUP_WINDOW_SELECT.EDGE_SIZE, POPUP_WINDOW_SELECT.SHADOW_LEN
    )
end

function loadBaseWindowSelect(skin)
    loadWindow(
        skin,
        BASE_WINDOW.ID,
        TEXTURE_SIZE - (BASE_WINDOW.EDGE_SIZE * 2 + BASE_WINDOW.SHADOW_LEN * 2 + 1) - 3,
        TEXTURE_SIZE - (BASE_WINDOW.EDGE_SIZE * 2 + BASE_WINDOW.SHADOW_LEN * 2 + 1),
        BASE_WINDOW.EDGE_SIZE, BASE_WINDOW.SHADOW_LEN
    )
end

function loadBaseWindowResult(skin)
    loadWindow(
        skin,
        RESULT_BASE_WINDOW.ID,
        0, 0,
        RESULT_BASE_WINDOW.EDGE_SIZE, RESULT_BASE_WINDOW.SHADOW_LEN
    )
end

function loadCloseButtonSelect(skin, id, act)
    table.insert(skin.image, {
        id = id, src = 0, x = CLOSE_BUTTON.SRC_X, y = CLOSE_BUTTON.SRC_Y, w = CLOSE_BUTTON.W, h = CLOSE_BUTTON.H, act = act
    })
end

function loadHeaderSelect(skin)
    table.insert(skin.image, {
        id = "popUpWindowHeaderLeft", src = 2, x = 392, y = TEXTURE_SIZE - HEADER.MARKER.H, w = HEADER.MARKER.W, h = HEADER.MARKER.H
    })
end

function loadSubHeaderSelect(skin)
    table.insert(skin.image, {
        id = SUB_HEADER.EDGE.LEFT_ID, src = 2, x = 0, y = 1966, w = SUB_HEADER.EDGE.W, h = SUB_HEADER.EDGE.H
    })
    table.insert(skin.image, {
        id = SUB_HEADER.EDGE.RIGHT_ID, src = 2, x = SUB_HEADER.EDGE.W, y = 1966, w = SUB_HEADER.EDGE.W, h = SUB_HEADER.EDGE.H
    })
end

function loadBaseSelect(skin)
    loadPopupWindowSelect(skin)
    loadBaseWindowSelect(skin)
    loadSubHeaderSelect(skin)
    loadHeaderSelect(skin)
end

function loadWindow(skin, ids, x, y, edgeSize, shadow)
    local sumEdgeSize = edgeSize + shadow
    -- 四隅
    table.insert(skin.image, {
        id = ids.UPPER_LEFT, src = 0, x = x, y = y,
        w = sumEdgeSize, h = sumEdgeSize, act = 0
    })
    table.insert(skin.image, {
        id = ids.UPPER_RIGHT, src = 0, x = x + sumEdgeSize + 1, y = y,
        w = sumEdgeSize, h = sumEdgeSize, act = 0
    })
    table.insert(skin.image, {
        id = ids.BOTTOM_RIGHT, src = 0, x = x + sumEdgeSize + 1, y = y + sumEdgeSize + 1,
        w = sumEdgeSize, h = sumEdgeSize, act = 0
    })
    table.insert(skin.image, {
        id = ids.BOTTOM_LEFT, src = 0, x = x, y = y + sumEdgeSize + 1,
        w = sumEdgeSize, h = sumEdgeSize, act = 0
    })

    -- 各辺
    table.insert(skin.image, {
        id = ids.TOP, src = 0, x = x + sumEdgeSize, y = y,
        w = 1, h = sumEdgeSize, act = 0
    })
    table.insert(skin.image, {
        id = ids.LEFT, src = 0, x = x + sumEdgeSize + 1, y = y + sumEdgeSize,
        w = sumEdgeSize, h = 1, act = 0
    })
    table.insert(skin.image, {
        id = ids.BOTTOM, src = 0, x = x + sumEdgeSize, y = y + sumEdgeSize + 1,
        w = 1, h = sumEdgeSize, act = 0
    })
    table.insert(skin.image, {
        id = ids.RIGHT, src = 0, x = x, y = y + sumEdgeSize,
        w = sumEdgeSize, h = 1, act = 0
    })

    -- 本体
    table.insert(skin.image, {
        id = ids.BODY, src = 0, x = x + sumEdgeSize, y = y + sumEdgeSize,
        w = 1, h = 1, act = 0
    })
end

function destinationStaticBaseWindow(skin, x, y, w, h)
    destinationStaticWindowBg(skin, BASE_WINDOW.ID, x, y, w, h, BASE_WINDOW.EDGE_SIZE, BASE_WINDOW.SHADOW_LEN * 2, {}, nil)
end

function destinationStaticBaseWindowSelect(skin, x, y, w, h)
    destinationStaticWindowBg(skin, BASE_WINDOW.ID, x, y, w, h, BASE_WINDOW.EDGE_SIZE, BASE_WINDOW.SHADOW_LEN, {}, nil)
end

function destinationStaticBaseWindowResult(skin, x, y, w, h)
    destinationStaticWindowBg(skin, RESULT_BASE_WINDOW.ID, x, y, w, h, RESULT_BASE_WINDOW.EDGE_SIZE, RESULT_BASE_WINDOW.SHADOW_LEN, {}, nil)
end

-- ウィンドウを描画
-- @param  array skin
-- @param  array ids UPPER_LEFT~BODYの読み込みで指定するid
-- @param  number x 左下座標
-- @param  number y 左下座標
-- @param  number w 影を除く大きさ
-- @param  number h 影を除く大きさ
-- @param  number edgeSize 角丸のサイズ
-- @param  number shadow 影の長さ
-- @param  array op
-- それぞれ影を除いた座標
function destinationStaticWindowBg(skin, ids, x, y, w, h, edgeSize, shadow, op, draw)
    local sumEdgeSize = edgeSize + shadow

    -- 四隅
    table.insert(skin.destination, {
        id = ids.UPPER_LEFT, op = op, draw = draw, dst = {
            {x = x - shadow, y = y + h - edgeSize, w = sumEdgeSize, h = sumEdgeSize}
        }
    })
    table.insert(skin.destination, {
        id = ids.UPPER_RIGHT, op = op, draw = draw, dst = {
            {x = x + w - edgeSize, y = y + h - edgeSize, w = sumEdgeSize, h = sumEdgeSize}
        }
    })
    table.insert(skin.destination, {
        id = ids.BOTTOM_RIGHT, op = op, draw = draw, dst = {
            {x = x + w - edgeSize, y = y - shadow, w = sumEdgeSize, h = sumEdgeSize}
        }
    })
    table.insert(skin.destination, {
        id = ids.BOTTOM_LEFT, op = op, draw = draw, dst = {
            {x = x - shadow, y = y - shadow, w = sumEdgeSize, h = sumEdgeSize}
        }
    })

    -- 各辺
    table.insert(skin.destination, {
        id = ids.TOP, op = op, draw = draw, dst = {
            {x = x + edgeSize, y = y + h - edgeSize, w = w - edgeSize * 2, h = sumEdgeSize}
        }
    })
    table.insert(skin.destination, {
        id = ids.LEFT, op = op, draw = draw, dst = {
            {x = x + w - edgeSize, y = y + edgeSize, w = sumEdgeSize, h = h - edgeSize * 2}
        }
    })
    table.insert(skin.destination, {
        id = ids.BOTTOM, op = op, draw = draw, dst = {
            {x = x + edgeSize, y = y - shadow, w = w - edgeSize * 2, h = sumEdgeSize}
        }
    })
    table.insert(skin.destination, {
        id = ids.RIGHT, op = op, draw = draw, dst = {
            {x = x - shadow, y = y + edgeSize, w = sumEdgeSize, h = h - edgeSize * 2}
        }
    })

    -- 本体
    table.insert(skin.destination, {
        id = ids.BODY, op = op, draw = draw, dst = {
            {x = x + edgeSize, y = y + edgeSize, w = w - edgeSize * 2, h = h - edgeSize * 2}
        }
    })
end

function dstSimplePopUpWindowSelect(skin, bgCloseAreaId, timer, animationTime)
    -- 背景
    table.insert(skin.destination, {
        id = bgCloseAreaId, timer = timer, loop = animationTime, dst = {
            {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 0},
            {time = animationTime, a = 64},
        }
    })

    local initial = {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 0, h = 0}
    local dst = {
        initial,
        {time = animationTime, x = SIMPLE_WND_AREA.X, y = SIMPLE_WND_AREA.Y, w = SIMPLE_WND_AREA.W, h = SIMPLE_WND_AREA.H},
    }
    destinationWindowWithTimer(skin, POPUP_WINDOW_SELECT.ID, POPUP_WINDOW_SELECT.EDGE_SIZE, POPUP_WINDOW_SELECT.SHADOW_LEN, {}, timer, animationTime, dst)
end

function dstCloseButton(skin, closeButtonId, timer, animationTime)
    -- closeボタン
    table.insert(skin.destination, {
        id = closeButtonId, timer = timer, loop = animationTime, dst = {
            {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 0, h = 0},
            {time = animationTime, x = SIMPLE_WND_AREA.X + (SIMPLE_WND_AREA.W - CLOSE_BUTTON.W) / 2, y = SIMPLE_WND_AREA.Y + CLOSE_BUTTON.Y, w = CLOSE_BUTTON.W, h = CLOSE_BUTTON.H}
        }
    })
end


-- 数値描画の基準座標におけるdstの中身. それぞれで, x,yが定義されていれば各桁に適した座標に修正する.
-- x, yは影を除くウィンドウ左下座標
-- w, hは影を除くウィンドウ全体の大きさを指定する
function destinationWindowWithTimer(skin, ids, edgeSize, shadow, op, timer, loop, baseDst)
    local sumEdgeSize = edgeSize + shadow
    local ids2 = {
        ids.UPPER_LEFT,
        ids.UPPER_RIGHT,
        ids.BOTTOM_RIGHT,
        ids.BOTTOM_LEFT,
        ids.TOP,
        ids.LEFT,
        ids.BOTTOM,
        ids.RIGHT,
        ids.BODY,
    }
    local dx = {
        - shadow,
        - edgeSize,
        - edgeSize,
        - shadow,
        edgeSize,
        - edgeSize,
        edgeSize,
        - shadow,
        edgeSize,
    }

    local dy = {
        - edgeSize,
        - edgeSize,
        - shadow,
        - shadow,
        - edgeSize,
        edgeSize,
        - shadow,
        edgeSize,
        edgeSize,
    }

    local isAddW = {
        false,
        true,
        true,
        false,
        false,
        true,
        false,
        false,
        false
    }
    local isAddH = {
        true,
        true,
        false,
        false,
        true,
        false,
        false,
        false,
        false,
    }
    local doUseSumEdgeSizeW = {
        true, true, true, true, false, true, false, true, false
    }
    local doUseSumEdgeSizeH = {
        true, true, true, true, true, false, true, false, false
    }

    local function copyDst(t)
        local t2 = {}
        for k,v in pairs(t) do
          t2[k] = v
        end
        return t2
    end

    -- それぞれのedgeについて
    for i = 1, 9 do
        -- dstを組み立てる
        local newestW = 0
        local newestH = 0
        local newestX = 0
        local newestY = 0
        local dst = {}
        for _, value in pairs(baseDst) do
            -- 元の入ってきたものを破壊しないように複製
            local newDst = copyDst(value)
            if table.in_key(newDst, "w") then
                newestW = newDst["w"]
                -- w 書き換え
                if doUseSumEdgeSizeW[i] then
                    newDst["w"] = sumEdgeSize
                else
                    newDst["w"] = newestW - edgeSize * 2
                end
            end

            if table.in_key(newDst, "h") then
                newestH = newDst["h"]
                -- h 書き換え
                if doUseSumEdgeSizeH[i] then
                    newDst["h"] = sumEdgeSize
                else
                    newDst["h"] = newestH - edgeSize * 2
                end
            end

            if table.in_key(newDst, "x") then
                newestX = newDst["x"]
            end
            newDst["x"] = newestX + dx[i]
            if isAddW[i] then
                newDst["x"] = newDst["x"] + newestW
            end

            if table.in_key(newDst, "y") then
                newestY = newDst["y"]
            end
            newDst["y"] = newestY + dy[i]
            if isAddH[i] then
                newDst["y"] = newDst["y"] + newestH
            end

            table.insert(dst, newDst)
        end
        table.insert(skin.destination, {
            id = ids2[i],
            op = op, timer = timer, loop = loop, dst = dst
        })
    end
end

function dstCloseArea(skin, id, op, timer, animationTime)
    table.insert(skin.destination, {
        id = id, timer = timer, loop = animationTime, op = op, dst = {
            {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0},
            {time = 1},
            {time = animationTime, x = SIMPLE_WND_AREA.X + 49, y = SIMPLE_WND_AREA.Y + 86, w = 1502, h = 724, a = 0}
        }
    })
end

-- フォントサイズは30
function dstHeaderSelect(skin, op, timer, animationTime, textId)
    -- 左の斜線部分
    table.insert(skin.destination, {
        id = "popUpWindowHeaderLeft", timer = timer, loop = animationTime, op = op, dst = {
            {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 0, h = 0},
            {time = animationTime, x = SIMPLE_WND_AREA.X + HEADER.MARKER.X, y = SIMPLE_WND_AREA.Y + HEADER.MARKER.Y, w = HEADER.MARKER.W, h = HEADER.MARKER.H}
        }
    })
    -- header下線
    table.insert(skin.destination, {
        id = "purpleRed", timer = timer, loop = animationTime, op = op, dst = {
            {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 0, h = 0},
            {time = animationTime, x = SIMPLE_WND_AREA.X + HEADER.UNDERBAR.X, y = SIMPLE_WND_AREA.Y + HEADER.UNDERBAR.Y, w = HEADER.UNDERBAR.W, h = HEADER.UNDERBAR.H}
        }
    })

    table.insert(skin.destination, {
        id = textId, timer = timer, loop = animationTime, op = op, dst = {
            {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0, r = 0, g = 0, b = 0},
            {time = 1, a = 255}, -- w, hを0にするとエラーが出る場合があることの対処
            {time = animationTime, x = SIMPLE_WND_AREA.X + HEADER.TEXT.X, y = SIMPLE_WND_AREA.Y + HEADER.TEXT.Y, w = HEADER.TEXT.W, h = HEADER.TEXT.FONT_SIZE, a = 255}
        }
    })
end

-- x, yは絶対座標
-- フォントサイズは24
function dstSubHeaderSelect(skin, x, y, w, op, timer, animationTime, textId, isCenteringText)
    -- 左
    table.insert(skin.destination, {
        id = SUB_HEADER.EDGE.LEFT_ID, timer = timer, loop = animationTime, op = op, dst = {
            {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 0, h = 0},
            {time = animationTime, x = x, y = y, w = SUB_HEADER.EDGE.W, h = SUB_HEADER.EDGE.H}
        }
    })
    -- 中央
    table.insert(skin.destination, {
        id = "white", timer = timer, loop = animationTime, op = op, dst = {
            {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 0, h = 0, r = 64, g = 64, b = 64},
            {time = animationTime, x = x + SUB_HEADER.EDGE.W, y = y, w = w - SUB_HEADER.EDGE.W * 2, h = SUB_HEADER.EDGE.H}
        }
    })
    -- 右
    table.insert(skin.destination, {
        id = SUB_HEADER.EDGE.RIGHT_ID, timer = timer, loop = animationTime, op = op, dst = {
            {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 0, h = 0},
            {time = animationTime, x = x + w - SUB_HEADER.EDGE.W, y = y, w = SUB_HEADER.EDGE.W, h = SUB_HEADER.EDGE.H}
        }
    })
    -- 文字
    if textId ~= nil then
        local textX = x + w / 2
        if not isCenteringText then
            textX = x + 20
        end
        table.insert(skin.destination, {
            id = textId, timer = timer, loop = animationTime, op = op, dst = {
                {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0},
                {time = 1, a = 255}, -- w, hを0にするとエラーが出る場合があることの対処
                {time = animationTime, x = textX, y = y + 7, w = w, h = SUB_HEADER.FONT_SIZE, a = 255}
            }
        })
    end
end

function dstSwitchWindowItem(dst, timer, animationTime)

end