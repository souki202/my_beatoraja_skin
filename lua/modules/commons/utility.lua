local main_state = require("main_state")

local utils = {
    functions = {}
}

--[[
    IRのランプ毎のプレイ人数のレートを取得するためのID一覧を取得

    @return {max, perfect, ... , failed, noplay}
]]
utils.functions.getIrPlayerLampRateIds = function ()
    return {225, 223, 219, 209, 217, 215, 213, 207, 205, 211, 203}
end

--[[
    IRのランプ毎のプレイ人数の小数点以下のレートを取得するためのID一覧を取得

    @return {max, perfect, ... , failed, noplay}
]]
utils.functions.getIrPlayerLampRateAfterDotIds = function ()
    return {240, 239, 238, 233, 237, 236, 235, 232, 231, 234, 230}
end

--[[
    IRのランプ毎のプレイ人数を取得するためのID一覧を取得

    @return {max, perfect, ... , failed, noplay}
]]
utils.functions.getIrPlayerLampAmountIds = function ()
    return {224, 222, 218, 208, 216, 214, 212, 206, 204, 210, 202}
end

return utils.functions