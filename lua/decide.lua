require("define")
-- local BASE_WIDTH = 1920
-- local BASE_HEIGHT = 1080
-- local WIDTH = 1920
-- local HEIGHT = 1080

-- 定数郡
local TITLE_FRAME_Y = 400
local TITLE_FRAME_H = 96
local GENRE_FRAME_H = TITLE_FRAME_H / 2
local GENRE_FRAME_Y = TITLE_FRAME_Y + TITLE_FRAME_H + 8
local ARTIST_FRAME_H = TITLE_FRAME_H / 2
local ARTIST_FRAME_Y = TITLE_FRAME_Y - ARTIST_FRAME_H - 8

local header = {
    type = 6,
    name = "Flat skin",
    w = WIDTH,
    h = HEIGHT,
	fadeout = 500,
    scene = 3000,
    input = 500,
    filepath = {
        {name = "背景", path = "../decide/background/*.png"},
	},
	offset = {
		{name = "タイトル背景の透明度(-255で透明)", id = 40, a = 0},
		{name = "曲情報の位置", id = 41, y = 0}
	}
}

local function main()
	local skin = {}
	-- ヘッダ情報をスキン本体にコピー
	for k, v in pairs(header) do
		skin[k] = v
	end

	skin.source = {
		{id = 0, path = "../decide/background/*.png"},
		{id = 1, path = "../common/colors/difficulty.png"}
	}

	skin.image = {
		{id = "background", src = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT},
	}

	for i = 0, 4 do
		table.insert(skin.image, {id = "baseColor" .. i, src = 1, x = i, y = 0, w = 1, h = 1})
	end

	skin.font = {
		{id = 0, path = "../common/fonts/SourceHanSans-Light.otf"}
	}

	skin.text = {
		{id = "genre", font = 0, size = CalcAdaptWidth(NORMAL_TEXT_SIZE), ref = 13, align = 1},
		{id = "title", font = 0, size = CalcAdaptWidth(LARGE_TITLE_TEXT_SIZE), ref = 12, align = 1},
		{id = "artist", font = 0, size = CalcAdaptWidth(NORMAL_TEXT_SIZE), ref = 14, align = 1},
	}

	skin.destination = {
		-- カバー無し時の背景
		{
			id = "background",
			dst = {
				{x = 0, y = 0, w = WIDTH, h = HEIGHT}
			}
		},
		-- カバー(あれば)
		{
			id = -100,
			dst = {
				{x = 0, y = 0, w = WIDTH, h = HEIGHT}
			}
		},
	}

	-- 背景(難易度毎の色に)
	for i = 0, 4 do
		table.insert(skin.destination, {
			id = "baseColor" .. i, offsets = {40, 41}, op = {151 + i},
			dst = {
				{x = 0, y = CalcAdaptHeight(GENRE_FRAME_Y), w = WIDTH, h = CalcAdaptHeight(GENRE_FRAME_H), a = 255},
			}
		})
		table.insert(skin.destination, {
			id = "baseColor" .. i, offsets = {40, 41}, op = {151 + i},
			dst = {
				{x = 0, y = CalcAdaptHeight(TITLE_FRAME_Y), w = WIDTH, h = CalcAdaptHeight(TITLE_FRAME_H), a = 255},
			}
		})
		table.insert(skin.destination, {
			id = "baseColor" .. i, offsets = {40, 41}, op = {151 + i},
			dst = {
				{x = 0, y = CalcAdaptHeight(ARTIST_FRAME_Y), w = WIDTH, h = CalcAdaptHeight(ARTIST_FRAME_H), a = 255},
			}
		})
	end

	-- ジャンル文字
	table.insert(skin.destination, {
		id = "genre", loop = 2000, offsets = {41},
		dst = {
			{
				time = 0,
				x = CalcAdaptWidth(WIDTH / 2 - 40),
				y = CalcAdaptHeight(CalcTextVerticalMiddle(NORMAL_TEXT_SIZE, GENRE_FRAME_Y + GENRE_FRAME_H / 2)),
				w = NORMAL_TEXT_SIZE,
				h = NORMAL_TEXT_SIZE
			},
			{time = 2000, x = CalcAdaptWidth(WIDTH / 2 + 40)}
		}
	})

	-- タイトル文字
	table.insert(skin.destination, {
		id = "title", offsets = {41},
		dst = {
			{
				x = CalcAdaptWidth(960),
				y = CalcAdaptHeight(CalcTextVerticalMiddle(LARGE_TITLE_TEXT_SIZE, TITLE_FRAME_Y + TITLE_FRAME_H / 2)),
				w = LARGE_TITLE_TEXT_SIZE, h = LARGE_TITLE_TEXT_SIZE
			}
		}
	})

	-- アーティスト文字
	table.insert(skin.destination, {
		id = "artist", loop = 2000, offsets = {41},
		dst = {
			{
				time = 0,
				x = CalcAdaptWidth(WIDTH / 2 + 40),
				y = CalcAdaptHeight(CalcTextVerticalMiddle(NORMAL_TEXT_SIZE, ARTIST_FRAME_Y + ARTIST_FRAME_H / 2)),
				w = NORMAL_TEXT_SIZE,
				h = NORMAL_TEXT_SIZE
			},
			{time = 2000, x = CalcAdaptWidth(WIDTH / 2 - 40)}
		}
	})


    return skin
end

return {
    header = header,
    main = main
}