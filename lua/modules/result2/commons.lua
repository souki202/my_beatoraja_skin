local main_state = require("main_state")
require("modules.result.commons")

function getRankFrameBgAlpha()
	return 255 - getOffsetValueWithDefault("ランクの額縁の背景の透明度(既定値165 255で透明)", {a = 165}).a
end

function getBokehBgSrc()
    return getBgSrc() + 100
end