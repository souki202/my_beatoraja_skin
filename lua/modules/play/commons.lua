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

function getKeyFlashHeightIndex()
	return 5 - (929 - getTableValue(skin_config.option, "キービーム長さ", 925))
end

function getKeyFlashAppearAnimationTimeIndex()
	return 5 - (934 - getTableValue(skin_config.option, "キービーム出現時間", 930))
end

function getKeyFlashDelAnimationTimeIndex()
	return 5 - (989 - getTableValue(skin_config.option, "キービーム消失時間", 985))
end

function iskeyFlashAppearNormalAnimation()
	return getTableValue(skin_config.option, "キービーム出現アニメーション", 975) == 975
end

function iskeyFlashAppearFromEdgeAnimation()
	return getTableValue(skin_config.option, "キービーム出現アニメーション", 975) == 976
end

function iskeyFlashAppearFromCenterAnimation()
	return getTableValue(skin_config.option, "キービーム出現アニメーション", 975) == 977
end

function iskeyFlashDelNormalAnimation()
	return getTableValue(skin_config.option, "キービーム消失アニメーション", 980) == 980
end

function iskeyFlashDelFromEdgeAnimation()
	return getTableValue(skin_config.option, "キービーム消失アニメーション", 980) == 981
end

function iskeyFlashDelFromCenterAnimation()
	return getTableValue(skin_config.option, "キービーム消失アニメーション", 980) == 982
end

function isDrwaBackKeyBeam()
	return getTableValue(skin_config.option, "後方キービーム", 935) == 935
end

function isDrawLargeBga()
	return getTableValue(skin_config.option, "黒帯部分のBGA表示", 945) == 945
end

function isBgaOnLeftUpper()
	return getTableValue(skin_config.option, "BGA枠", 940) == 940
end

function isBgaOnLeft()
	return getTableValue(skin_config.option, "BGA枠", 940) == 941
end

function isFullScreenBga()
	return getTableValue(skin_config.option, "BGA枠", 940) == 942
end

function drawDiffBestScore()
	return getTableValue(skin_config.option, "スコア差表示", 991) == 992
end

function drawDiffTargetScore()
	return getTableValue(skin_config.option, "スコア差表示", 991) == 991
end

function drawDiffUpperJudge()
	if not (drawDiffBestScore() or drawDiffTargetScore()) then return false end
	return getTableValue(skin_config.option, "スコア差表示位置", 995) == 996
end

function drawDiffLaneSide()
	if not (drawDiffBestScore() or drawDiffTargetScore()) then return false end
	return getTableValue(skin_config.option, "スコア差表示位置", 995) == 995
end

function getLaneAlpha()
	local v = getTableValue(skin_config.offset, "レーンの黒背景(既定値192 255で透明)", {a = 192}).a
	if v == 0 then return 192 end
	return v
end

function drawSideJudgeGraph()
	return getTableValue(skin_config.option, "サイド部分のグラフ", 10001) == 10001
end

function drawSideEarlyLateGraph()
	return getTableValue(skin_config.option, "サイド部分のグラフ", 10001) == 10002
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