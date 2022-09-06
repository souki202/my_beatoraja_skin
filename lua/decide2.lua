local main_state = require("main_state")
require("modules.decide2.commons")

local FADE = {
	OUT_TIME = 300,
	IN_TIME = 300;
}

local LUA_NAMES = {
	"simple",
}

local header = {
    type = 6,
    name = "NowLoading" .. (DEBUG and " decide dev" or ""),
    w = WIDTH,
    h = HEIGHT,
	fadeout = FADE.OUT_TIME,
    scene = 2000,
	input = 500,
	property = {
		{
            name = "種類", item = {{name = "シンプル", op = 910}}, def = "シンプル"
        }
	},
    filepath = {
        {name = "背景", path = "../decide2/bg/*", def = "default"},
		-- {name = "NoImage画像", path = "../decide2/noimage/*", def = "default"},
	},
	offset = {
		{name = "ロード時間 (ミリ秒, 既定値2000)", x = 0},
		{name = "ロード時間のぶれ (ミリ秒, 既定値300)", x = 0},
	}
}

local function main()
	local skin = {}
	-- ヘッダ情報をスキン本体にコピー
	for k, v in pairs(header) do
		skin[k] = v
	end

	local b = getSceneTimeBlurred();
	skin.scene = math.max(getRawSceneTime() + math.random(-b, b), 1)

	skin.source = {
		{id = 0, path = "../decide2/bg/*"},
		-- {id = 1, path = "../decide2/noimage/*"},
        {id = 999, path = "../common/colors/colors.png"},
	}

	skin.image = {
		{id = "background", src = 0, x = 0, y = 0, w = -1, h = -1},
		-- {id = "noImage", src = 1, x = 0, y = 0, w = -1, h = -1},
		{id = "black", src = 999, x = 1, y = 0, w = 1, h = 1},
        {id = "white", src = 999, x = 2, y = 0, w = 1, h = 1},
	}

	skin.font = {
		{id = 0, path = "../common/fonts/SourceHanSans-Regular.otf"}
	}

	skin.text = {
	}

	skin.destination = {
        -- 背景
        {
            id = "background",
            dst = {
                {x = 0, y = 0, w = WIDTH, h = HEIGHT}
            }
        },
	}

	-- ほかパーツは設定に応じて
	do
		local typeIndex = getTableValue(skin_config.option, "種類", 910) - 909
		local d = require("modules.decide2.types." .. LUA_NAMES[typeIndex]);
		mergeSkin(skin, d.load(skin.scene))
		mergeSkin(skin, d.dst())
	end

	mergeSkin(skin, {
		destination = {
			-- fadein
			{id = "black", loop = -1, dst = {
                {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 255},
                {time = FADE.IN_TIME, a = 0}
            }},
			-- fadeout
			{id = "black", timer = 2, loop = FADE.OUT_TIME, dst = {
                {time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 0},
                {time = FADE.OUT_TIME, a = 255}
            }},
		}
	})

    return skin
end

return {
    header = header,
    main = main
}