local commons = require("modules.select.commons")

local searchBox = {
    functions = {}
}

local SEARCH_BOX = {
    WND = {
        X = 73,
        Y = 10,
        W = 616, -- 影込み
        H = 62,
        SHADOW = 7,
    },
    TEXT = {
        X = 48,
        Y = 12,
        W = 540,
        FONT_SIZE = 24,
    }
}

searchBox.functions.load = function ()
    return {
        image = {
            -- 検索ボックス
            {id = "searchBox", src = 0, x = 773, y = PARTS_TEXTURE_SIZE - SEARCH_BOX.WND.H, w = SEARCH_BOX.WND.W, h = SEARCH_BOX.WND.H},
        },
        text = {
            {id = "searchText", font = 0, size = SEARCH_BOX.TEXT.FONT_SIZE, ref = 30},
        },
    }
end

searchBox.functions.dst = function ()
    return {
        destination = {
            -- 検索ボックス
            {
                id = "searchBox", dst = {
                    {x = SEARCH_BOX.WND.X - SEARCH_BOX.WND.SHADOW, y = SEARCH_BOX.WND.Y - SEARCH_BOX.WND.SHADOW, w = SEARCH_BOX.WND.W, h = SEARCH_BOX.WND.H}
                }
            },
            -- テキスト入力欄
            {
                id = "searchText", filter = 1, dst = {
                    {x = SEARCH_BOX.WND.X + SEARCH_BOX.TEXT.X, y = SEARCH_BOX.WND.Y + SEARCH_BOX.TEXT.Y, w = SEARCH_BOX.TEXT.W, h = SEARCH_BOX.TEXT.FONT_SIZE}
                }
            },
        }
    }
end

return searchBox.functions