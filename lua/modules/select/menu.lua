require("modules.commons.my_window")
local commons = require("modules.select.commons")
local main_state = require("main_state")

local menu = {
    isOpen = false,
    openTime = 0,
    nowTimeForClose = 0,
    functions = {}
}

local MENU = {
    TIMER_ID = 13100,
    ANIMATION_TIME = 150,
    WND = {
        X = function() return WIDTH - 33 end, -- width - STORAGE_W
        OPEN_X = function(self) return WIDTH - self.WND.W(self) + BASE_WINDOW.EDGE_SIZE end,
        Y = function() return 42 end,
        STORAGE_W = 33,
        W = function (self)
            return 27 + 6 + self.BUTTON.INTERVAL_X * #self.BUTTON.IDS + BASE_WINDOW.EDGE_SIZE
        end,
        H = 64
    },
    SWITCH = {
        X = function(self) return self.WND.X() + 7 end,
        OPEN_X = function(self) return self.WND.OPEN_X(self) + 7 end,
        Y = function(self) return self.WND.Y() + 17 end,
        W = 19,
        H = 30,
    },
    BUTTON = {
        W = 142,
        H = 62,
        Y = function(self) return self.WND.Y() + 1 end,
        INTERVAL_X = 137,
        START_X = function(self) return self.WND.X() + 27 end,
        OPENED_START_X = function(self) return self.WND.OPEN_X(self) + 27 end,
        IDS = {"statisticsOpenButton", "helpOpenButton", "volumesOpenButton"}, -- 左から
    },
}

function switchMenu()
    if menu.isOpen == false then
        main_state.set_timer(MENU.TIMER_ID, main_state.time())
        menu.openTime = main_state.time()
        menu.isOpen = true
    else
        menu.nowTimeForClose = MENU.ANIMATION_TIME * 1000
        menu.isOpen = false
    end
end

function menuTimer()
    if menu.isOpen == false then
        menu.nowTimeForClose = math.max(menu.nowTimeForClose - getDeltaTime(), 0)
        return main_state.time() - menu.nowTimeForClose
    end
    return menu.openTime
end

menu.functions.load = function ()
    -- ボタン類
    -- open用のcustomEventはとりあえず決め打ちで, その定義は各種対応するluaファイルで
    -- ウィンドウは読み込み済み
    return {
        customTimers = {
            {id = MENU.TIMER_ID, timer = "menuTimer"}
        },
        image = {
            {
                id = "helpOpenButton", src = 0, x = 1415, y = commons.PARTS_OFFSET + 771, w = CLOSE_BUTTON.W, h = CLOSE_BUTTON.H, act = 1000
            },
            {
                id = "statisticsOpenButton", src = 0, x = 1761, y = commons.PARTS_OFFSET + 771, w = CLOSE_BUTTON.W, h = CLOSE_BUTTON.H, act = 1010
            },
            {
                id = "volumesOpenButton", src = 0, x = 1903, y = commons.PARTS_OFFSET + 771, w = CLOSE_BUTTON.W, h = CLOSE_BUTTON.H, act = 1020
            },
            {
                id = "switchButton", src = 0, x = 1389, y = PARTS_TEXTURE_SIZE - MENU.SWITCH.H, w = MENU.SWITCH.W, h = MENU.SWITCH.H
            },
            {
                id = "switchButtonDummy", src = 999, x = 0, y = 0, w = 1, h = 1, act = "switchMenu()"
            },
        }
    }
end

menu.functions.dst = function ()
    local skin = {destination = {}}
    local dst = skin.destination

    -- 開いている時に画面のどこを押しても閉じるように
    dst[#dst+1] = {
        id = "switchButtonDummy", timer = MENU.TIMER_ID, loop = MENU.ANIMATION_TIME, dst = {
            {time = 0, x = 0, y = 0, w = 0, h = 0, acc = 3},
            {time = MENU.ANIMATION_TIME, w = WIDTH, h = HEIGHT}
        }
    }

    local wndDst = {
        {time = 0, x = MENU.WND.X(), y = MENU.WND.Y(), w = MENU.WND.W(MENU), h = MENU.WND.H},
        {time = MENU.ANIMATION_TIME, x = MENU.WND.OPEN_X(MENU)},
    }
    destinationWindowWithTimer(skin, BASE_WINDOW.ID, BASE_WINDOW.EDGE_SIZE, BASE_WINDOW.SHADOW_LEN, {}, MENU.TIMER_ID, MENU.ANIMATION_TIME, wndDst)

    -- アイコンの出力
    dst[#dst+1] = {
        id = "switchButton", timer = MENU.TIMER_ID, loop = MENU.ANIMATION_TIME, dst = {
            {time = 0, x = MENU.SWITCH.X(MENU), y = MENU.SWITCH.Y(MENU), w = MENU.SWITCH.W, h = MENU.SWITCH.H, angle = 0},
            {time = MENU.ANIMATION_TIME, x = MENU.SWITCH.OPEN_X(MENU), angle = 180}
        }
    }
    dst[#dst+1] = {
        id = "switchButtonDummy", timer = MENU.TIMER_ID, loop = MENU.ANIMATION_TIME, dst = {
            {time = 0, x = MENU.WND.X(), y = MENU.WND.Y(), w = MENU.WND.STORAGE_W, h = MENU.WND.H},
            {time = MENU.ANIMATION_TIME, x = MENU.SWITCH.OPEN_X(MENU)}
        }
    }

    -- ボタンの出力
    for i, id in ipairs(MENU.BUTTON.IDS) do
        dst[#dst+1] = {
            id = id, timer = MENU.TIMER_ID, loop = MENU.ANIMATION_TIME, dst = {
                {time = 0, x = MENU.BUTTON.START_X(MENU) + MENU.BUTTON.INTERVAL_X * (i - 1), y = MENU.BUTTON.Y(MENU), w = 0, h = 0},
                {time = 1, w = MENU.BUTTON.W, h = MENU.BUTTON.H},
                {time = MENU.ANIMATION_TIME, x = MENU.BUTTON.OPENED_START_X(MENU) + MENU.BUTTON.INTERVAL_X * (i - 1)}
            }
        }
    end
    return skin
end

return menu.functions