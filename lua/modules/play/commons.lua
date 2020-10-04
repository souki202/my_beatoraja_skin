require("modules.commons.define")
local main_state = require("main_state")

local commons = {
	keys = 7,
	startTime = 1500,
	calcTimeLeftSecond = function () return main_state.number(163) * 60 + main_state.number(164) end,
}

CUSTOM_TIMERS = {
	LIFE = 10010,
	JUDGE = 10101,
	VISUALIZER = 10200,
	SCORE_VALUE = 11100,
	SCORE_VALUE_INITIAL = 11101,
	LOGGER = 11000,
	LOGGER_SAVE = 11001,
	LOGGER_UPDATE = 12001,
	MY_BPM_TIMER = 12100,
	UPDATE_GAUGE_STATE = 12101,
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
	local v = getTableValue(skin_config.offset, "レーンの黒背景(255で透明)", {a = 0}).a
	if v == 0 then return 0 end
	return v
end

function drawSideJudgeGraph()
	return getTableValue(skin_config.option, "サイド部分のグラフ", 10001) == 10001
end

function drawSideEarlyLateGraph()
	return getTableValue(skin_config.option, "サイド部分のグラフ", 10001) == 10002
end

function isDrawBombParticle()
	return getTableValue(skin_config.option, "ボムのパーティクル", 10005) == 10005
end

function getParticle1AnimationType()
	return getTableValue(skin_config.option, "ボムのparticle1のアニメーション", 10010) - 10010
end

function getParticle2AnimationType()
	return getTableValue(skin_config.option, "ボムのparticle2のアニメーション", 10015) - 10015
end

function isTransparentBombAnimationBlackBg()
	return getTableValue(skin_config.option, "ボムのanimation1と2の黒背景透過", 10020) == 10020
end

function isVersatilitybgaPng()
	return getTableValue(skin_config.option, "汎用BGA形式", 10025) == 10025
end

function getNoteType()
	return getTableValue(skin_config.option, "ノートの画像", 10030) - 10030
end

function isDrawVisualizer1()
	return getTableValue(skin_config.option, "ビジュアライザー1", 10055) == 10055
end

function isThinVisualizerBarType()
	return getTableValue(skin_config.option, "ビジュアライザー1の棒線タイプ", 10036) == 10036
end

function getVisualizerBarQuantityLevel()
	return 10047 - getTableValue(skin_config.option, "ビジュアライザー1の棒線の多さ", 10042)
end

function isVisualizerProtrusionBombBase()
	return getTableValue(skin_config.option, "ビジュアライザー1の山の出現位置", 10050) == 10050
end

function isDrawVisualizerBackSideReflection()
	return getTableValue(skin_config.option, "ビジュアライザー1の奥側の反射", 10060) == 10060
end

function getVisualizerBarTransparencyValue()
	return getOffsetValueWithDefault("ビジュアライザー1のバーの透明度(既定値64 255で透明)", {a = 64}).a
end

function getVisualizerReflectionTransparencyValue()
	return getOffsetValueWithDefault("ビジュアライザー1の反射の透明度(既定値196 255で透明)", {a = 195}).a
end

function getLifeGaugeEffectThresholdIdx()
	return getTableValue(skin_config.option, "グルーヴゲージの通知エフェクトの基準", 10066) - 10064
end

function getLifeGaugeEffectSizeYOffset()
	return getOffsetValueWithDefault("グルーブゲージの通知エフェクトの大きさ差分(%)", {y = 0}).y
end

function isDrawGauge100Particle()
	return getTableValue(skin_config.option, "ゲージ100%時のキラキラ", 10070) == 10070
end

function getNumOfGauge100Particles()
	return getOffsetValueWithDefault("ゲージ100%時のキラキラの数(既定値20)", {x = 20}).x
end

function isBaseBpmTypeStartBpm()
	return getTableValue(skin_config.option, "BPM変化の判定基準", 10081) == 10080
end

function isBaseBpmTypeMainBpm()
	return getTableValue(skin_config.option, "BPM変化の判定基準", 10081) == 10081
end

function slowBpmCalcType()
	return getTableValue(skin_config.option, "低速時のEARLY, LATE位置変更基準", 10077) - 10075
end

function getKeyBeamTransparency()
	return getOffsetValueWithDefault("キービームの透明度(既定値64 255で透明)", {a = 64}).a
end

function getKeyBeamWhiteBrightness()
	return getOffsetValueWithDefault("白鍵キービームの明るさ(単位% 既定値100)", {x = 100}).x
end

function getKeyBeamWhiteSaturation()
	return getOffsetValueWithDefault("白鍵キービームの彩度(単位% 既定値30)", {x = 30}).x
end

function getKeyBeamBlueBrightness()
	return getOffsetValueWithDefault("青鍵キービームの明るさ(単位% 既定値100)", {x = 100}).x
end

function getKeyBeamBlueSaturation()
	return getOffsetValueWithDefault("青鍵キービームの彩度(単位% 既定値60)", {x = 60}).x
end

function isOutputLog()
	return getTableValue(skin_config.option, "リザルト用ログ出力", 10085) == 10085
end

function isEarlyLateJudgeImage()
	return getTableValue(skin_config.option, "判定画像分類", 10090) == 10091
end

function isHiddenGrooveGauge()
	return getTableValue(skin_config.option, "グルーヴゲージ隠し", 10096) == 10095
end

function isVerticalGrooveGauge()
	return getTableValue(skin_config.option, "グルーヴゲージ位置", 10100) == 10101
end

function getScoreRateSampleNotes()
	return getOffsetValueWithDefault("スコアレートのサンプルノーツ数(既定値50)", {x = 50}).x
end

function getScoreRateSampleMicroSec()
	return getOffsetValueWithDefault("スコアレートのサンプル取得の最大時間(単位秒 既定値10)", {x = 10}).x * 1000 * 1000
end

function isEnableBackBgaBokeh()
	return getTableValue(skin_config.option, "黒帯部分のBGA表示のぼかし", 10106) == 10105
end

function getTargetRateType()
	return getTableValue(skin_config.option, "ターゲットスコアのレート変動(ログ出力有効時)", 10110) - 10110
end

function getLaneSideAnimationTime()
	return getOffsetValueWithDefault("レーンサイドの1ループのアニメーション時間(単位拍子 既定値8 -1でアニメーションなし)", {x = 8}).x
end

function getIsChangeLaneSideByGaugeState()
	return getTableValue(skin_config.option, "レーンサイドの画像変化", 10116) == 10116
end

function getIsLaneSideColorToMatchDifficulyColor()
	return getTableValue(skin_config.option, "レーンサイドを難易度毎の色変化に合わせる", 10121) == 10120
end

function getIsJudgeLineLayer1ColorToMatchDifficulyColor()
	return getTableValue(skin_config.option, "判定ライン(Layer1)を難易度毎の色変化に合わせる", 10126) == 10125
end

function getIsJudgeLineLayer2ColorToMatchDifficulyColor()
	return getTableValue(skin_config.option, "判定ライン(Layer2)を難易度毎の色変化に合わせる", 10131) == 10130
end

function getIsDrawGrow()
	return getTableValue(skin_config.option, "グロー表示", 10136) == 10135
end

function getBombParticle1AlphaEasingType()
	return getTableValue(skin_config.option, "ボムのparticle1のアルファ変化", 10142) % 5 + 1
end

function getBombParticle2AlphaEasingType()
	return getTableValue(skin_config.option, "ボムのparticle2のアルファ変化", 10147) % 5 + 1
end

function getBombParticle1MoveEasingType()
	return getTableValue(skin_config.option, "ボムのparticle1の座標変化", 10150) % 5 + 1
end

function getBombParticle2MoveEasingType()
	return getTableValue(skin_config.option, "ボムのparticle2の座標変化", 10155) % 5 + 1
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

function getSimpleLineColor()
	local dif = getDifficultyValueForColor()
	local colors = {{255, 255, 255}, {137, 204, 137}, {137, 204, 204}, {204, 164, 108}, {204, 104, 104}, {204, 102, 153}}
	return colors[dif][1], colors[dif][2], colors[dif][3]
end

return commons