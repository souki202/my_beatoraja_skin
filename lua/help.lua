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
    MASK = {
        X = 49, -- Yは計算
        W = 1502,
        UPPER_H = 90,
        BOTTOM_H = 86,
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
                X = 49,
                W = 1502,
                H = 36,
                BRIGHT = 75,
                INTERVAL = 38,
                APPEAR_ANIMATION_TIME = 100 * 1000, -- マイクロ秒
            },
        },
        TEXT = {
            X = 76,
            Y = 12, -- これだけ各項目からの差分
            HEADER_H = 24,
            ITEM_H = 20,
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
    START_TIME = 10000000,
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
            y = 0, -- 1項目目の初期座標に対する, すべての項目が閉じているときの相対座標
            nowY = 0, -- 各項目の最新座標
            isOpen = false,
            openAnimationTime = 0
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

    DETAIL = {
        timerId = 0,
        HEADER = {
            X = 118,
            Y = 768,
            W = 16, -- OPTION_INFO.HEADER2_EDGE_BG_W
            H = 42, -- OPTION_INFO.HEADER2_EDGE_BG_H
        },
    },

    isOpenDescription = false,

    FUNCTIONS = {},
}

local operationState = {
    isClicking = false,
    isScrollStop = false,
    clickTime = 0,
    dy = 0,
    numAbsMove = 0,
    totalY = 0
}

local function getIsInRect(x, y, tx, ty, w, h)
    return tx <= x and x <= tx + w and ty <= y and y <= ty + h
end

function itemListOperation()
    if isLeftClicking() == true then
        myPrint("ヘルプ操作領域クリック")
        operationState.isClicking = true
    elseif isRightClicking() == true then
        closeHelpList()
    end
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
            local hy = item.nowY

            local isSelect = getIsInRect(x, y, 0, hy, help.ITEM.BG.HEADER.W, help.ITEM.BG.HEADER.H)
            if isSelect then
                return i, 0
            end

            for j, item2 in pairs(item.item) do
                if item2.timerId ~= nil and item2.timerId >= 10000 and item.isOpen and item.openAnimationTime >= help.ITEM.BG.ITEM.APPEAR_ANIMATION_TIME then
                    local iy = hy - help.ITEM.BG.ITEM.INTERVAL * j
                    isSelect = getIsInRect(x, y, 0, iy, help.ITEM.BG.ITEM.W, help.ITEM.BG.ITEM.H)
                    if isSelect then
                        return i, j
                    end
                end
            end
        end
    end

    return 0, 0
end

help.FUNCTIONS.updateOperationArea = function()
    if operationState.isClicking then
        if isLeftClicking() == false then
            operationState.isClicking = false
            if operationState.numAbsMove <= 20 then
                -- メニューを選択する(あれば)
                local h, i = help.FUNCTIONS.selectItem()
                myPrint("選択情報", "header: " .. h, "item: " .. i)

                -- openする
                if h > 0 and i == 0 then
                    help.TEXTS[h].isOpen = not help.TEXTS[h].isOpen
                elseif h > 0 and i > 0 then
                    -- 小項目をクリックしたら詳細表示
                    help.isOpenDescription = true

                end
            end

            operationState.numAbsMove = 0
        else
            operationState.dy = getDeltaY()
            operationState.numAbsMove = operationState.numAbsMove + math.abs(operationState.dy + getDeltaX())
            -- スクロールする高さがなければ終わり
            if operationState.totalY <= help.ITEM.AREA.H then
                operationState.dy = 0
                return
            end
            help.scrollY = help.scrollY + operationState.dy
        end
    end
    help.scrollY = math.min(math.max(math.min(help.ITEM.AREA.H - operationState.totalY, 0), help.scrollY), 0)
end

-- yは1項目目に対する相対座標
help.FUNCTIONS.examineOutOfArea = function(y, h)
    y = y + help.WND.Y + help.ITEM.AREA.START_Y
    -- 上側に出ている
    local upperY = help.WND.Y + help.ITEM.AREA.Y + help.ITEM.AREA.H
    if upperY <= y then return true end

    -- 下側に出ている
    local bottomY = help.WND.Y + help.ITEM.AREA.Y
    if y + h <= bottomY then return true end
    return false
end

local function helpMainLogic()
    help.FUNCTIONS.updateOperationArea()

    local now = main_state.time()
    local sumOpenMenuGap = 0

    for _, item in pairs(help.TEXTS) do
        if item.timerId ~= nil and item.timerId >= 10000 then
            -- ヘッダー部分
            -- 現在のy座標に対応するtimeを求める 間違いなく震えるので少し動かす
            item.nowY = item.y + 0.25 - help.scrollY - sumOpenMenuGap
            local time = help.FUNCTIONS.yToTime(item.nowY) * 1000

            if help.FUNCTIONS.examineOutOfArea(item.nowY, help.ITEM.BG.HEADER.H) then
                -- 外に出ていたら表示しない
                main_state.set_timer(item.timerId, main_state.timer_off_value)
            else
                main_state.set_timer(item.timerId, now - time)
            end

            -- 開くアニメーションの時間更新
            if item.isOpen then
                item.openAnimationTime = item.openAnimationTime + getDeltaTime()
            else
                item.openAnimationTime = item.openAnimationTime - getDeltaTime()
            end
            item.openAnimationTime = math.max(0, math.min(item.openAnimationTime, help.ITEM.BG.ITEM.APPEAR_ANIMATION_TIME))

            local maxGap = 0

            for j, item2 in pairs(item.item) do
                if item2.timerId ~= nil and item2.timerId >= 10000 then
                    local offset = -6
                    if item.openAnimationTime  ~= 0 then
                        offset = j * help.ITEM.BG.ITEM.INTERVAL * item.openAnimationTime / help.ITEM.BG.ITEM.APPEAR_ANIMATION_TIME
                    end

                    maxGap = math.max(maxGap, offset)

                    -- 各項目部分
                    local iy = item.y + 0.25 - help.scrollY - offset - sumOpenMenuGap
                    time = help.FUNCTIONS.yToTime(iy) * 1000
                    

                    if help.FUNCTIONS.examineOutOfArea(iy, help.ITEM.BG.ITEM.H) then
                        -- 外に出ていたら表示しない
                        main_state.set_timer(item2.timerId, main_state.timer_off_value)
                    else
                        main_state.set_timer(item2.timerId, now - time)
                    end

                end
            end

            -- 小項目の最も下の位置のずれだけ次の大項目をずらす
            sumOpenMenuGap = sumOpenMenuGap + maxGap
        end
    end
    operationState.totalY = sumOpenMenuGap + #help.TEXTS * help.ITEM.BG.HEADER.INTERVAL
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

    -- 各項目の背景
    table.insert(skin.image, {
        id = "whiteListItem", src = 999, x = 2, y = 0, w = 1, h = 1
    })

    -- 項目を隠したり, action発生を妨害したり
    table.insert(skin.image, {
        id = "whiteMask", src = 999, x = 2, y = 0, w = 1, h = 1, act = 0
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
            table.insert(skin.text, {
                id = item2.TEXT .. "Detail", font = 0, size = 24, overflow = 1, constantText = item2.TEXT
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

    -- 操作用オブジェクト出力
    table.insert(skin.destination, {
        id = "blankHelpOperation", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            initial,
            {time = help.ANIMATION_TIME - 1},
            {time = help.ANIMATION_TIME, x = help.WND.X + help.ITEM.AREA.X, y = help.WND.Y + help.ITEM.AREA.Y, w = help.ITEM.AREA.W, h = help.ITEM.AREA.H}
        }
    })
end

-- 項目の上に乗せる出力
help.FUNCTIONS.setWindowDestination2 = function(skin)
    local initial = {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 0, h = 0}

    -- 上部マスク
    table.insert(skin.destination, {
        id = "whiteMask", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            initial,
            {time = help.ANIMATION_TIME, x = help.WND.X + help.MASK.X, y = help.WND.Y + help.ITEM.AREA.Y + help.ITEM.AREA.H, w = help.MASK.W, h = help.MASK.UPPER_H}
        }
    })
    -- 下部マスク
    table.insert(skin.destination, {
        id = "whiteMask", timer = help.WINDOW_TIMER, loop = help.ANIMATION_TIME, dst = {
            initial,
            {time = help.ANIMATION_TIME, x = help.WND.X + help.MASK.X, y = help.WND.Y, w = help.MASK.W, h = help.MASK.UPPER_H}
        }
    })


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
end

-- yは操作領域最上部項目の座標からの相対座標
help.FUNCTIONS.yToTime = function(y)
    return help.START_TIME + y * help.TIME_PER_Y
end

help.FUNCTIONS.setListDestination = function(skin)
    local timer = help.TIMER_START
    local viewTime = help.ANIMATION_TIME + help.ITEM.BG.HEADER.VIEW_DELAY

    for i, item in pairs(help.TEXTS) do
        -- 各項目の出力
        for j, item2 in pairs(item.item) do
            -- 各項目用にtimer移動
            timer = timer + 1
            -- 背景
            table.insert(skin.destination, {
                id = "whiteListItem", timer = timer, loop = -1, dst = {
                    -- 開幕の登場する部分
                    {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0, r = 75, g = 75, b = 75, acc = 0},
                    {time = viewTime - 1},
                    {time = viewTime, x = help.WND.X + help.ITEM.BG.ITEM.X, y = help.WND.Y + help.ITEM.AREA.START_Y, w = help.ITEM.BG.ITEM.W, h = help.ITEM.BG.ITEM.H, a = 255},

                    -- 動く部分
                    {time = help.FUNCTIONS.yToTime(-3000), y = help.WND.Y + help.ITEM.AREA.START_Y - 3000},
                    {time = help.FUNCTIONS.yToTime(3000), y = help.WND.Y + help.ITEM.AREA.START_Y + 3000},
                    {time = 99999999},
                }
            })
            -- 文字
            table.insert(skin.destination, {
                id = item2.TEXT, timer = timer, loop = -1, dst = {
                    -- 開幕の登場する部分
                    {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0, acc = 0},
                    {time = viewTime - 1},
                    {time = viewTime, x = help.WND.X + help.ITEM.TEXT.X, y = help.WND.Y + help.ITEM.AREA.START_Y, w = help.ITEM.BG.ITEM.W, h = help.ITEM.TEXT.ITEM_H, a = 255},

                    -- 動く部分
                    {time = help.FUNCTIONS.yToTime(-3000), y = help.WND.Y + help.ITEM.AREA.START_Y - 3000 + 6},
                    {time = help.FUNCTIONS.yToTime(3000), y = help.WND.Y + help.ITEM.AREA.START_Y + 3000 + 6},
                    {time = 99999999},
                }
            })
            item2.timerId = timer
            timer = timer + 1
            item2.description.timerId = timer
        end

        timer = timer + 1

        -- headerの出力
        item.timerId = timer
        local bgIds = {"helpHeaderBgLeft", "helpHeaderBgCenter", "helpHeaderBgRight", item.HEADER}
        local allX = {
            help.WND.X + help.ITEM.BG.HEADER.X,
            help.WND.X + help.ITEM.BG.HEADER.X + help.ITEM.BG.HEADER.EDGE_W,
            help.WND.X + help.ITEM.BG.HEADER.X + help.ITEM.BG.HEADER.W - help.ITEM.BG.HEADER.EDGE_W,
            help.WND.X + help.ITEM.TEXT.X,
        }
        local offsetY = {0, 0, 0, help.ITEM.TEXT.Y}
        local allW = {help.ITEM.BG.HEADER.EDGE_W, help.ITEM.BG.HEADER.W - help.ITEM.BG.HEADER.EDGE_W * 2, help.ITEM.BG.HEADER.EDGE_W, 9999}
        local allH = {help.ITEM.BG.HEADER.H, help.ITEM.BG.HEADER.H, help.ITEM.BG.HEADER.H, help.ITEM.TEXT.HEADER_H}
        for j, id in pairs(bgIds) do
            local b = 255
            if bgIds[j] == item.HEADER then
                b = 0
            end
            table.insert(skin.destination, {
                id = id, timer = item.timerId, loop = -1, dst = {
                    -- 開幕の登場する部分
                    {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0, r = b, g = b, b = b, acc = 0},
                    {time = viewTime - 1},
                    {time = viewTime, x = allX[j], y = help.WND.Y + help.ITEM.AREA.START_Y, w = allW[j], h = allH[j], a = 255},

                    -- 動く部分
                    {time = help.FUNCTIONS.yToTime(-3000), y = help.WND.Y + help.ITEM.AREA.START_Y - 3000 + offsetY[j]},
                    {time = help.FUNCTIONS.yToTime(3000), y = help.WND.Y + help.ITEM.AREA.START_Y + 3000 + offsetY[j]},
                    {time = 99999999},
                }
            })
        end

        -- この項目にどれだけyがずれているかの初期値を設定する
        item.y = -(i - 1) * help.ITEM.BG.HEADER.INTERVAL
        item.nowY = item.y

        item.isOpen = false
        item.openAnimationTime = 0
    end

    -- 詳細項目の出力
    -- 項目背景(オプションのを使いまわし)
    timer = timer + 1
    table.insert(skin.destination, {
        id = "optionHeader2LeftBg", timer = timer, loop = -1, dst = {
            -- 開幕の登場する部分
            {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0},
            {time = viewTime, x = help.WND.X + help.DETAIL.HEADER.X},
        }
    })

    for i, item in pairs(help.TEXTS) do
        -- 各項目の出力
        for j, item2 in pairs(item.item) do
            timer = timer + 1
            table.insert(skin.destination, {
                id = item2.TEXT .. "Detail", timer = timer, loop = -1, dst = {
                    -- 開幕の登場する部分
                    {time = 0, x = WIDTH / 2, y = HEIGHT / 2, w = 1, h = 1, a = 0},
                    {time = viewTime},
                }
            })
        end
    end
end

return help.FUNCTIONS