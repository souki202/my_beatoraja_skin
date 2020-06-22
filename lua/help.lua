local main_state = require("main_state")
require("define")
require("my_window")
require("input")

local TEXTURE_SIZE = 2048
local PARTS_OFFSET = HEIGHT + 32

local POPUP_WINDOW = {
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
    }
}

local help = {
    WND = {
        X = 160,
        Y = 90,
        W = 1600,
        H = 900
    },
    BUTTON = {
        X = 728,
        Y = 12,
        W = 142,
        H = 62,
    },
    H1 = {
        X = 62,
        Y = 845,
        H = 30,
    },
    ITEM = {
        AREA = {
            X = 49,
            W = 1502,
            Y = 86,
            START_Y = 760, -- WNDからの相対
            H = 724,
        },
        BG = {
            HEADER = {
                X = 49,
                W = 1502,
                H = 50,
                EDGE_W = 11,
                INTERVAL = 64,
                VIEW_DELAY = 300,
            },
            ITEM = {
                W = 1502,
                H = 36,
                BRIGHT = 75,
                INTERVAL = 38,
            },
        },
        TEXT = {
            X = 76,
            Y = 12, -- これだけ各項目からの差分
            H = 24,
        }
    },
    ANIMATION_TIME = 150,
    closeTime = 0;

    isOpening = false, -- 開いている最中かどうか
    isClosing = false, -- 閉じている最中かどうか
    hasAllClosed = true, -- すべて閉じている状態かどうか
    didProcessAllClose = false, -- すべて閉じる処理を完了したかどうか
    hasOpened = false, -- 開いている状態かどうか

    TIME_PER_Y = 1000, -- Y座標-1ごとにtime(ms)をどれだけ足すか

    minScrollY = 0,
    scrollY = 0,
    maxScrollY = 0,

    WINDOW_TIMER = 10010,
    TIMER_START = 10011,
    TIME_GAPS = {},
    START_TIME = 50000000,
    TEXTS = {
        { -- これが全要素持っているやつ
            HEADER = "選曲画面操作",
            item = {
                {
                    TEXT = "プレイ開始",
                    timerId = 0,
                    description = {
                        TEXT = "1鍵, エンターキー, 決定ボタンのいずれかでプレイを開始することができます.",
                        timerId = 0,
                    },
                },
                {
                    TEXT = "プラクティス",
                    description = {
                        TEXT = "3鍵を押すと, プラクティスモードでプレイできます.\nプラクティスでは, 開始, 終了位置の変更や, 各種オプション, TOTAL値等を設定しながら練習することが可能です.",
                    },
                },
                {
                    TEXT = "オートプレイ",
                    description = {
                        TEXT = "5鍵を押すか, AUTOボタンでオートプレイを鑑賞できます.",
                    },
                },
                {
                    TEXT = "リプレイ",
                    description = {
                        TEXT = "6鍵で再生するリプレイを変更でき, 7鍵で再生できます. 各リプレイの保存条件はbeatoraja起動時のプレイオプションタブから設定可能です.",
                    },
                },
            },
            timerId = 0,
            time = 0,
            y = 0, -- 1項目目の初期座標に対する相対値
        },
        {
            HEADER = "テスト2",
            item = {
                {
                    TEXT = "プレイ開始2",
                    timerId = 0,
                    description = {
                        TEXT = "221鍵, エンターキー, 決定ボタンのいずれかでプレイを開始することができます.",
                        timerId = 0,
                    },
                },
                {
                    TEXT = "プラクティス2",
                    description = {
                        TEXT = "223鍵を押すと, プラクティスモードでプレイできます.\nプラクティスでは, 開始, 終了位置の変更や, 各種オプション, TOTAL値等を設定しながら練習することが可能です.",
                    },
                },
                {
                    TEXT = "オートプレイ2",
                    description = {
                        TEXT = "225鍵を押すか, AUTOボタンでオートプレイを鑑賞できます.",
                    },
                },
                {
                    TEXT = "リプレイ2",
                    description = {
                        TEXT = "226鍵で再生するリプレイを変更でき, 7鍵で再生できます. 各リプレイの保存条件はbeatoraja起動時のプレイオプションタブから設定可能です.",
                    },
                },
            },
        },
        {
            HEADER = "テスト23",
            item = {
                {
                    TEXT = "プレイ開始3",
                    timerId = 0,
                    description = {
                        TEXT = "331鍵, エンターキー, 決定ボタンのいずれかでプレイを開始することができます.",
                        timerId = 0,
                    },
                },
                {
                    TEXT = "プラクティス3",
                    description = {
                        TEXT = "333鍵を押すと, プラクティスモードでプレイできます.\nプラクティスでは, 開始, 終了位置の変更や, 各種オプション, TOTAL値等を設定しながら練習することが可能です.",
                    },
                },
                {
                    TEXT = "オートプレイ3",
                    description = {
                        TEXT = "335鍵を押すか, AUTOボタンでオートプレイを鑑賞できます.",
                    },
                },
                {
                    TEXT = "リプレイ3",
                    description = {
                        TEXT = "336鍵で再生するリプレイを変更でき, 7鍵で再生できます. 各リプレイの保存条件はbeatoraja起動時のプレイオプションタブから設定可能です.",
                    },
                },
            },
        },
    },

    FUNCTIONS = {},
}

local operationState = {
    isClicking = false,
    isScrollStop = false,
    clickTime = 0,
    dy = 0,
    numAbsDy = 0,
}

function itemListOperation()
    myPrint("ヘルプ操作領域クリック")
    operationState.isClicking = true
end

local function getIsInRect(x, y, tx, ty, w, h)
    return tx <= x and x <= tx + w and ty <= y and y <= ty + h
end

-- @return number, number HEADERのインデックス, 項目のインデックス (非選択なら0)
help.FUNCTIONS.selectItem = function()
    local x, y = getMousePos()
    -- 操作領域右上になるようになおす
    x = x - (help.WND.X + help.ITEM.AREA.X)
    y = HEIGHT - y - (help.WND.Y + help.ITEM.AREA.START_Y)
    myPrint(x, y)

    for i, item in pairs(help.TEXTS) do
        if item.timerId ~= nil and item.timerId >= 10000 then
            -- ヘッダー部分
            local hy = item.y - help.scrollY

            local isSelect = getIsInRect(x, y, 0, hy, help.ITEM.BG.HEADER.W, help.ITEM.BG.HEADER.H)
            if isSelect then
                return i, 0
            end

            for j, item2 in pairs(item.item) do
                if item2.timerId ~= nil and item2.timerId >= 10000 then
                    local iy = hy + help.ITEM.BG.ITEM.INTERVAL * j
                    isSelect = getIsInRect(x, y, 0, hy, help.ITEM.BG.ITEM.W, help.ITEM.BG.ITEM.H)
                    if isSelect then
                        return 0, j
                    end
                end
            end
        end
    end

    return 0, 0
end

help.FUNCTIONS.updateScroll = function()
    if operationState.isClicking then
        if isLeftClicking() == false then
            operationState.isClicking = false
            if operationState.numAbsDy <= 20 then
                -- メニューを選択する(あれば)
                local h, i = help.FUNCTIONS.selectItem()
                myPrint("選択情報", "header: " .. h, "item: " .. i)
            end

            operationState.numAbsDy = 0
        else
            operationState.dy = getDeltaY()
            operationState.numAbsDy = operationState.numAbsDy + math.abs(operationState.dy)
            help.scrollY = help.scrollY + operationState.dy
        end
    end
    -- print(operationState.dy)
end

local function helpMainLogic()
    help.FUNCTIONS.updateScroll()

    local now = main_state.time()

    for _, item in pairs(help.TEXTS) do
        -- 現在のy座標に対応するtimeを求める 間違いなく震えるので少し動かす
        local time = help.FUNCTIONS.yToTime(item.y + 0.25 - help.scrollY) * 1000
        if item.timerId ~= nil and item.timerId >= 10000 then
            -- ヘッダー部分

            main_state.set_timer(item.timerId, now - time)

            for _, item2 in pairs(item.item) do
                if item2.timerId ~= nil and item2.timerId >= 10000 then
                    -- 各項目部分
                    main_state.set_timer(item2.timerId, now - time)
                    main_state.set_timer(item2.description.timerId, now - time)
                end
            end
        end
    end
end

function helpTimer()
    if help.hasAllClosed and help.didProcessAllClose == false then
        help.FUNCTIONS.allClose()
        help.didProcessAllClose = true
    elseif help.isOpening then
        -- 開ききったらstateを変える
        if main_state.time() - main_state.timer(help.WINDOW_TIMER) >= (help.ANIMATION_TIME + help.ITEM.BG.HEADER.VIEW_DELAY)*1000 then
            -- myPrint("開ききった: " .. main_state.time() - main_state.timer(help.WINDOW_TIMER))
            help.isOpening = false
            help.hasOpened = true
        end
    elseif help.isClosing then
        help.closeTime = help.closeTime - getDeltaTime()
        help.FUNCTIONS.setAllTimer(getElapsedTime() - help.closeTime)
        -- 閉じきったら後処理
        if help.closeTime <= 0 then
            -- myPrint("閉じきった: " .. main_state.time() - main_state.timer(help.WINDOW_TIMER))
            help.FUNCTIONS.allClose()
            help.isClosing = false
        end
    elseif help.hasOpened then -- ここがメインロジック
        helpMainLogic()
    end
end


function openHelpList()
    if help.isOpening == false and help.hasOpened == false then
        -- myPrint("ヘルプを開く")
        help.isOpening = true
        help.hasOpened = false
        help.didProcessAllClose = false
        help.hasAllClosed = false
        main_state.set_timer(help.WINDOW_TIMER, main_state.time())
    end
end

function closeHelpList()
    if help.isClosing == false and help.hasAllClosed == false and help.hasOpened == true then
        -- myPrint("ヘルプを閉じる")
        help.isOpening = false
        help.hasOpened = false
        help.isClosing = true
        help.closeTime = help.ANIMATION_TIME * 1000
    end
end

help.FUNCTIONS.setAllTimer = function(time)
    main_state.set_timer(help.WINDOW_TIMER, time)
    for _, item in pairs(help.TEXTS) do
        if item.timerId ~= nil and item.timerId >= 10000 then
            main_state.set_timer(item.timerId, time)
            for _, item2 in pairs(item.item) do
                if item2.timerId ~= nil and item2.timerId >= 10000 then
                    main_state.set_timer(item2.timerId, time)
                    main_state.set_timer(item2.description.timerId, time)
                end
            end
        end
    end
end

help.FUNCTIONS.allClose = function()
    help.FUNCTIONS.setAllTimer(main_state.timer_off_value)
end

help.FUNCTIONS.activateAllTimer = function()
    help.FUNCTIONS.setAllTimer(main_state.time())
end

-- カスタムタイマ, カスタムアクション, textの後に配置すること
help.FUNCTIONS.loadHelpItem = function(skin)
    loadBaseWindow(
        skin,
        POPUP_WINDOW.ID,
        1908,
        TEXTURE_SIZE - (POPUP_WINDOW.EDGE_SIZE * 2 + POPUP_WINDOW.SHADOW_LEN * 2 + 1),
        POPUP_WINDOW.EDGE_SIZE, POPUP_WINDOW.SHADOW_LEN
    )

    -- ボタン
    table.insert(skin.customEvents, {id = 1000, action = "openHelpList()"})
    table.insert(skin.customEvents, {id = 1001, action = "closeHelpList()"})
    table.insert(skin.customEvents, {id = 1002, action = "itemListOperation()"})

    table.insert(skin.image, {
        id = "helpOpenButton", src = 0, x = 1415, y = PARTS_OFFSET + 771, w = help.BUTTON.W, h = help.BUTTON.H, act = 1000
    })
    table.insert(skin.image, {
        id = "helpCloseButton", src = 0, x = 1415 + help.BUTTON.W, y = PARTS_OFFSET + 771, w = help.BUTTON.W, h = help.BUTTON.H, act = 1001
    })

    -- 背景は閉じるボタン
    table.insert(skin.image, {
        id = "blackHelpClose", src = 999, x = 1, y = 0, w = 1, h = 1, act = 1001
    })

    -- メニュー開閉移動用のダミー
    table.insert(skin.image, {
        id = "blankHelpOperation", src = 999, x = 1, y = 0, w = 1, h = 1, act = 1002
    })

    table.insert(skin.image, {
        id = "whiteListItem", src = 999, x = 1, y = 0, w = 1, h = 1, act = 1002
    })

    -- 各ヘッダー項目
    table.insert(skin.image, {
        id = "helpHeaderBgLeft", src = 2, x = 1591, y = TEXTURE_SIZE - help.ITEM.BG.HEADER.H, w = help.ITEM.BG.HEADER.EDGE_W, h = help.ITEM.BG.HEADER.H
    })
    table.insert(skin.image, {
        id = "helpHeaderBgCenter", src = 2, x = 1591 + help.ITEM.BG.HEADER.EDGE_W, y = TEXTURE_SIZE - help.ITEM.BG.HEADER.H, w = 1, h = help.ITEM.BG.HEADER.H
    })
    table.insert(skin.image, {
        id = "helpHeaderBgRight", src = 2, x = 1591 + help.ITEM.BG.HEADER.EDGE_W + 1, y = TEXTURE_SIZE - help.ITEM.BG.HEADER.H, w = help.ITEM.BG.HEADER.EDGE_W, h = help.ITEM.BG.HEADER.H
    })

    -- 各テキスト
    for _, item in pairs(help.TEXTS) do
        -- header
        table.insert(skin.text, {
            id = item.HEADER, font = 0, size = 24, overflow = 1, constantText = item.HEADER
        })
        -- 各項目
        for _, item2 in pairs(item.item) do
            -- 各項目文字
            table.insert(skin.text, {
                id = item2.TEXT, font = 0, size = 20, overflow = 1, constantText = item2.TEXT
            })
            -- 詳細テキスト
            table.insert(skin.text, {
                id = item2.description.TEXT, font = 0, size = 16, wrapping = true, constantText = item2.description.TEXT
            })
        end
    end
end

help.FUNCTIONS.destinationOpenButton = function(skin)
    table.insert(skin.destination, {
        id = "helpOpenButton", dst = {
            {x = 1768, y = 0, w = help.BUTTON.W, h = help.BUTTON.H}
        }
    })
end

help.FUNCTIONS.setWindowDestination = function(skin)
    -- 背景
    table.insert(skin.destination, {
        id = "blackHelpClose", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 0},
            {time = help.ANIMATION_TIME, a = 64},
        }
    })

    local initial = {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 0, h = 0}

    local dst = {
        initial,
        {time = help.ANIMATION_TIME, x = help.WND.X, y = help.WND.Y, w = help.WND.W, h = help.WND.H},
    }
    destinationWindowWithTimer(skin, POPUP_WINDOW.ID, POPUP_WINDOW.EDGE_SIZE, POPUP_WINDOW.SHADOW_LEN, {}, help.WINDOW_TIMER, help.ANIMATION_TIME, dst)

    -- closeボタン
    table.insert(skin.destination, {
        id = "helpCloseButton", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            initial,
            {time = help.ANIMATION_TIME, x = help.WND.X + help.BUTTON.X, y = help.WND.Y + help.BUTTON.Y, w = help.BUTTON.W, h = help.BUTTON.H}
        }
    })

    -- 大ヘッダー
    table.insert(skin.destination, {
        id = "optionHeaderLeft", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            initial,
            {time = help.ANIMATION_TIME, x = 192, y = 932, w = 16, h = 42} -- 古いところからコピペ
        }
    })
    -- 下線
    table.insert(skin.destination, {
        id = "purpleRed", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            initial,
            {time = help.ANIMATION_TIME, x = 212, y = 932, w = 1516, h = 2} -- 古いところからコピペ
        }
    })
    -- 文字
    table.insert(skin.destination, {
        id = "helpText", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, r = 0, g = 0, b = 0}, -- w = 0でないのはバグ対策
            {time = help.ANIMATION_TIME, x = help.WND.X + help.H1.X, y = help.WND.Y + help.H1.Y, w = 999, h = help.H1.H}
        }
    })

    -- 操作用オブジェクト出力
    table.insert(skin.destination, {
        id = "blankHelpOperation", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            initial,
            {time = help.ANIMATION_TIME - 1},
            {time = help.ANIMATION_TIME, x = help.WND.X + help.ITEM.AREA.X, y = help.WND.Y + help.ITEM.AREA.Y, w = help.ITEM.AREA.W, h = help.ITEM.AREA.H}
        }
    })
end

-- yは操作領域最上部項目の座標からの相対座標
help.FUNCTIONS.yToTime = function(y)
    return help.START_TIME + y * help.TIME_PER_Y
end

help.FUNCTIONS.setListDestination = function(skin)
    local timer = help.TIMER_START
    for i, item in pairs(help.TEXTS) do
        item.timerId = timer
        -- headerの出力
        local viewTime = help.ANIMATION_TIME + help.ITEM.BG.HEADER.VIEW_DELAY
        local bgIds = {"helpHeaderBgLeft", "helpHeaderBgCenter", "helpHeaderBgRight", item.HEADER}
        local allX = {
            help.WND.X + help.ITEM.BG.HEADER.X,
            help.WND.X + help.ITEM.BG.HEADER.X + help.ITEM.BG.HEADER.EDGE_W,
            help.WND.X + help.ITEM.BG.HEADER.X + help.ITEM.BG.HEADER.W - help.ITEM.BG.HEADER.EDGE_W,
            help.WND.X + help.ITEM.TEXT.X,
        }
        local offsetY = {0, 0, 0, help.ITEM.TEXT.Y}
        local allW = {help.ITEM.BG.HEADER.EDGE_W, help.ITEM.BG.HEADER.W - help.ITEM.BG.HEADER.EDGE_W * 2, help.ITEM.BG.HEADER.EDGE_W, 9999}
        local allH = {help.ITEM.BG.HEADER.H, help.ITEM.BG.HEADER.H, help.ITEM.BG.HEADER.H, help.ITEM.TEXT.H}
        for j, id in pairs(bgIds) do
            local b = 255
            if bgIds[j] == item.HEADER then
                print("hige")
                b = 0
            end
            table.insert(skin.destination, {
                id = id, timer = timer, loop = -1, dst = {
                    -- 開幕の登場する部分
                    {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0, r = b, g = b, b = b, acc = 0},
                    {time = viewTime - 1},
                    {time = viewTime, x = allX[j], y = help.WND.Y + help.ITEM.AREA.START_Y, w = allW[j], h = allH[j], a = 255},

                    -- 動く部分
                    {time = help.FUNCTIONS.yToTime(-3000), y = help.WND.Y + help.ITEM.AREA.START_Y - 3000 + offsetY[j]},
                    {time = help.FUNCTIONS.yToTime(0), y = help.WND.Y + help.ITEM.AREA.START_Y + offsetY[j]},
                    {time = help.FUNCTIONS.yToTime(3000), y = help.WND.Y + help.ITEM.AREA.START_Y + 3000 + offsetY[j]},
                    {time = 99999999},
                }
            })
        end

        -- この項目にどれだけyがずれているかの初期値を設定する
        item.y = -(i - 1) * help.ITEM.BG.HEADER.INTERVAL

        -- 各項目用にtimer移動
        timer = timer + 1
    end
end

return help.FUNCTIONS