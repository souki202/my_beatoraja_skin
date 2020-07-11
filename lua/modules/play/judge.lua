require("modules.commons.define")
local commons = require("modules.play.commons")
local lanes = require("modules.play.lanes")

local judges = {
    functions = {}
}

local JUDGES = {
    APPEAR_TIME = 100,
    X = lanes.getAreaX() + lanes.getLaneW() / 2,
    Y = 490,
    W = 160,
    H = 31,
    
    IDS = {"Perfect", "Great", "Good", "Bad", "Poor", "Miss"},
    ID_PREFIX = "judge",
}

local COMBO = {
    W = 29,
    H = 38,
}

judges.functions.load = function ()
    local skin = {
        image = {},
        value = {
            {id = "nowCombo", src = 6, x = 0, y = 0, w = COMBO.W * 10, h = COMBO.H, divx = 10, digit = 5, ref = 75}
        },
        judge = {
            id = "judges",
            index = 0,
            images = {},
            numbers = {},
            shift = isDrawComboNextToTheJudge()
        }
    }
    local imgs = skin.image

    -- 判定読み込み
    for i = 1, #JUDGES.IDS do
        imgs[#imgs+1] = {id = JUDGES.ID_PREFIX .. JUDGES.IDS[i], src = 5, x = 0, y = JUDGES.H * (i - 1), w = JUDGES.W, h = JUDGES.H}
    end

    skin.judge = {

    }
end