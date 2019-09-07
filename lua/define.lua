BASE_WIDTH = 1920
BASE_HEIGHT = 1080
WIDTH = 1920
HEIGHT = 1080

NORMAL_TEXT_SIZE = 32
LARGE_TITLE_TEXT_SIZE = NORMAL_TEXT_SIZE * 2
NORMAL_DESCENDER_LINE = 3 -- フォントサイズ64

function CalcAdaptWidth(fhdSize)
	return math.floor(fhdSize / BASE_WIDTH * WIDTH)
end

function CalcAdaptHeight(fhdSize)
	return math.floor(fhdSize / BASE_HEIGHT * HEIGHT)
end

function CalcTextVerticalMiddle(fontSize, targetY)
	return targetY - fontSize / 2 - math.floor((fontSize / LARGE_TITLE_TEXT_SIZE) * NORMAL_DESCENDER_LINE)
end