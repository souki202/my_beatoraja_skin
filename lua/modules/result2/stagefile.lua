require("modules.result.commons")
require("modules.result2.commons")
local main_state = require("main_state")

local stagefile = {
    functions = {}
}

local STAGEFILE = {
    X = 1137,
    Y = 492,
    W = 640,
    H = 480,
    BG_ALPHA = 255,
}

local TAB_LIST = {STAGEFILE = 1, GROOVE = 2, CUSTOM_GROOVE = 3, SCORE = 4}

local tab = {
    nowTab = TAB_LIST.STAGEFILE,
    numOfTabs = 4,
}

stagefile.functions.changeTab = function ()
    -- タブ切り替え
    if isPressedUp() then
        myPrint("move tab up")
        tab.nowTab = tab.nowTab - 1
        if tab.nowTab < 1 then
            tab.nowTab = tab.numOfTabs
        end
        if not getIsViewCostomGrooveGauge() and tab.nowTab == TAB_LIST.CUSTOM_GROOVE then
            tab.nowTab = TAB_LIST.GROOVE
        end
        myPrint("nowTab: " .. tab.nowTab)
    elseif isPressedDown() then
        myPrint("move tab down")
        tab.nowTab = tab.nowTab + 1
        if tab.nowTab > tab.numOfTabs then
            tab.nowTab = 1
        end

        if not getIsViewCostomGrooveGauge() and tab.nowTab == TAB_LIST.CUSTOM_GROOVE then
            tab.nowTab = TAB_LIST.SCORE
        end
        myPrint("nowTab: " .. tab.nowTab)
    end
    return 1
end

stagefile.functions.changeTabByButton = function ()
    tab.nowTab = tab.nowTab + 1
    if tab.nowTab > tab.numOfTabs then
        tab.nowTab = 1
    end
    if not getIsViewCostomGrooveGauge() and tab.nowTab == TAB_LIST.CUSTOM_GROOVE then
        tab.nowTab = TAB_LIST.SCORE
    end
    myPrint("nowTab: " .. tab.nowTab)
end

stagefile.functions.getTabList = function ()
    return TAB_LIST
end

stagefile.functions.getStageFileArea = function ()
    return {X = STAGEFILE.X, Y = STAGEFILE.Y, W = STAGEFILE.W, H = STAGEFILE.H}
end

stagefile.functions.getNowTab = function ()
    return tab.nowTab
end

stagefile.functions.getIsDrawStagefile = function ()
    return tab.nowTab == TAB_LIST.STAGEFILE
end

stagefile.functions.load = function ()
    tab.nowTab = getStageFileAreaDefaultView()
    return {
        image = {
            {id = "noImage", src = 20, x = 0, y = 0, w = -1, h = -1},
            {id = "switcStagefileWindowButton", src = 999, x = 0, y = 0, w = 1, h = 1, act = stagefile.functions.changeTabByButton},
        },
        customTimers = {
            {id = CUSTOM_TIMERS.CUSTOM_TIMERS_RESULT2, timer = stagefile.functions.changeTab}
        }
    }
end

stagefile.functions.dst = function ()
    return {
        destination = {
            {
                id = "noImage", draw = function () return stagefile.functions.getIsDrawStagefile() and main_state.option(190) end, stretch = 1, filter = 1, dst = {
                    {x = STAGEFILE.X, y = STAGEFILE.Y, w = STAGEFILE.W, h = STAGEFILE.H}
                }
            },
            {
                id = "black", draw = function () return stagefile.functions.getIsDrawStagefile() and main_state.option(191) end, dst = {
                    {x = STAGEFILE.X, y = STAGEFILE.Y, w = STAGEFILE.W, h = STAGEFILE.H, a = STAGEFILE.BG_ALPHA}
                }
            },
            {
                id = -100, draw = function () return stagefile.functions.getIsDrawStagefile() and main_state.option(191) end, stretch = 1, filter = 1, dst = {
                    {x = STAGEFILE.X, y = STAGEFILE.Y, w = STAGEFILE.W, h = STAGEFILE.H}
                }
            },
        }
    }
end

return stagefile.functions