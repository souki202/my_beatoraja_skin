require("modules.commons.define")
local main_state = require("main_state")

local commons = {
    keys = 7
}

function setKeys(keys)
    commons.keys = keys
end

function is1P()
	if skin_config == nil or skin_config.option == nil then return true end
    return getTableValue(skin_config.option, "プレイ位置", 900) == 900
end

function isMirrorTable()
    return getTableValue(skin_config.option, "ターンテーブル位置", 950) == 951
end

function isDrawSeparator()
    return getTableValue(skin_config.option, "レーン区切り線", 915) == 915
end

function isDrawJudgeLine()
    return getTableValue(skin_config.option, "判定ライン", 920) == 920
end

function isDrawBlueLaneBg()
    return getTableValue(skin_config.option, "レーン色分け", 910) == 910
end

function isDrawLaneSymbol()
    return getTableValue(skin_config.option, "レーンのシンボル", 965) == 965
end

function isDrawComboNextToTheJudge()
    return getTableValue(skin_config.option, "コンボ位置", 971) == 970
end

function isDrawComboBottom()
    return getTableValue(skin_config.option, "コンボ位置", 971) == 971
end

function isDrawComboOuterLane()
    return getTableValue(skin_config.option, "コンボ位置", 971) == 973
end

function isDrawEarlyLate()
	return getTableValue(skin_config.option, "EARLY, LATE表示", 906) == 906
end

function isDrawErrorJudgeTimeIncludetPg()
	return getTableValue(skin_config.option, "EARLY, LATE表示", 906) == 907
end

function isDrawErrorJudgeTimeExcludePg()
	return getTableValue(skin_config.option, "EARLY, LATE表示", 906) == 908
end

function getDifficultyValueForColor()
	local dif = 0
	local op = getTableValue(skin_config.option, "難易度毎の色変化", 955)
	if op == 955 then
		for i = 150, 155 do
			if main_state.option(i) then
				dif = i - 149
			end
		end
	end
	for i = 956, 961 do
		if op == i then
			dif = i - 955
		end
	end
	return dif
end

return commons