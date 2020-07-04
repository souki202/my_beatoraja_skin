require("define")
require("position")
local main_state = require("main_state")

local STAGE_FILE = {
	X = 68,
	Y = 300,
	W = 640,
	H = 480,
}

local FADEOUT = 1500

local TEXT_OFFSET = 708

local ARTISTS = {
	WND = {
		Y = function() return 348 end,
		H = 48,
	},
	MAIN = {
		FONT_SIZE = 30,
		X = function() return TEXT_OFFSET + 909 end,
		Y = function(artists) return artists.WND.Y() + 8 end,
		W = 560,
	},
	SUB = {
		FONT_SIZE = 30,
		X = function() return TEXT_OFFSET + 303 end,
		Y = function(artists) return artists.WND.Y() + 8 end,
		W = 560,
	},
}

local TITLE = {
	WND = {
		Y = function() return 404 end,
		H = 80,
	},
	FONT_SIZE = 56,
	X = function() return TEXT_OFFSET + 606 end,
	Y = function(title) return title.WND.Y() + 8 end,
	W = 1180,
}

local GENRE = {
	WND = {
		Y = function() return 492 end,
		H = 48,
	},
	FONT_SIZE = 30,
	X = function() return TEXT_OFFSET + 606 end,
	Y = function(genre) return genre.WND.Y() + 8 end,
	W = 1180,
}

local WND_BAR = {
	A = 192
}

local INTRO_ANIM = {
	TIME = 1000
}

local CURTAIN = {
	CIRCLE = {
		SIZE = 1371
	},
	BOX = {
		W = 5120,
	},
	SHINE = {
		W = 1861,
		H = 1078,
	},
	LINE = {
		START_Y = 589,
		INTERVAL_Y = 25,
		APPEAR_TIME_VAR = FADEOUT / 7,
	},
	PARTICLE = {
		N = 3000,
		LOOP_TIME = FADEOUT / 50,
		ANGLE_VAR = 20, -- radian +-(ANGLE_VAR/2) だけばらつく

		MOVE_X = 1000, -- 飛んでからのxの移動量
		FADEOUT_X = 600, -- 飛んでからこれだけのx移動するとフェードアウト開始
		MOVE_X_VAR = 500, -- xの移動量のばらつき
		FADEOUT_TIME = FADEOUT / 3, -- 飛んでから消えるまでのms
		FADEOUT_TIME_VAR = FADEOUT / 7, -- 飛んでから消えるまでのmsのばらつき

		MOVE_R = 500, -- 飛んでからx軸周りに移動するときの距離
		MOVE_R_VAR = 500, -- ばらつき
		TIME_RES = 2, -- ms毎にパーティクルをばらまく
		ALPHA = 128,
		ALPHA_VAR = 48,

		SIZE = 86,
		SIZE_VAR = 20,
	},
	TEXT = {
		DIV_W = 6, -- このpx毎に分割してsrc入れる 1404の約数で. 2x2x3x3x3x13
		W = 1404,
		H = 256,
		COLORED_DELAY_TIME = FADEOUT / 10,
		-- COLORED_DEL1 = 40,
		-- COLORED_DEL2 = 80,
		-- COLORED_DEL_TIME = 30,
		APPEAR_TIME = FADEOUT / 7,
		RICH_APPEAR_TIME = FADEOUT / 30
	},
	FROM_X = -1000,
	TO_X = WIDTH + 550,
	CLOSE_TIME = FADEOUT / 3,
	REVERSE_TIME = FADEOUT * 0.9, -- fade開始からの経過時間
	OVERALL_FADEOUT_START = FADEOUT * 0.8,
}

local FOV = 90

-- @param  int t アニメーション開始からの時間
-- @param  int s 開始の値
-- @param  int e 終了の値
-- @param  int d アニメーション時間
local function easeOut(t, s, e, d)
    local c = e - s
    local rate = t / d
    rate = 1 - (rate - 1) * (rate - 1)
    return c * rate + s
end

-- アニメーションの状態から, 対応する時刻を取得する
-- @param  int n 現在の値
-- @param  int s 開始の値
-- @param  int e 終了の値
-- @param  int d アニメーション時間
local function easeOutTime(n, s, e, d)
	local c = e - s
	-- n = c * rate + s
	-- n - s = c * rate
	-- rate = (n - s) / c
	local rate = (n - s) / c
	-- r2 = 1-(r-1)^2
	-- r2 = 1 - (r^2 - 2r + 1)
	-- r2 = -r^2 + 2r
	-- r^2 - 2r + r2 = 0
	if rate > 1 then return d end
	return d * (1 - math.sqrt(1 - rate))
end

local function dithering(v)
	local v2 = v - math.floor(v)
	return math.random() < v2 and math.ceil(v) or math.floor(v)
end

local function getDifficultyValueForColor()
	local dif = 0
	local op = getTableValue(skin_config.option, "難易度毎の色変化", 920)
	if op == 920 then
		for i = 150, 155 do
			if main_state.option(i) then
				dif = i - 149
			end
		end
	end
	for i = 921, 926 do
		if op == i then
			dif = i - 920
		end
	end
	return dif
end

-- 難易度と設定に適した色を取得する
-- @return int, int, int r, g, b
local function getDifficultyColor()
	local dif = getDifficultyValueForColor()
	local colors = {{128, 128, 128}, {137, 204, 137}, {137, 204, 204}, {204, 164, 108}, {204, 104, 104}, {204, 102, 153}}
	return colors[dif][1], colors[dif][2], colors[dif][3]
end

local function getCurtainShineColor()
	local dif = getDifficultyValueForColor()
	local colors = {{255, 255, 255}, {218, 255, 218}, {218, 255, 255}, {255, 218, 183}, {255, 218, 218}, {255, 81, 200}}
	return colors[dif][1], colors[dif][2], colors[dif][3]
end

local function getTextColor()
	local dif = getDifficultyValueForColor()
	local colors = {{255, 255, 255}, {0, 255, 0}, {0, 255, 255}, {255, 218, 0}, {255, 0, 0}, {255, 31, 150}}
	return colors[dif][1], colors[dif][2], colors[dif][3]
end

local function getTextColor2()
	local dif = getDifficultyValueForColor()
	local colors = {{255, 255, 255}, {248, 255, 248}, {248, 255, 255}, {255, 248, 213}, {255, 248, 248}, {255, 131, 250}}
	return colors[dif][1], colors[dif][2], colors[dif][3]
end

local header = {
    type = 6,
    name = "Social Skin" .. (DEBUG and " decide dev" or ""),
    w = WIDTH,
    h = HEIGHT,
	fadeout = FADEOUT,
    scene = 3000,
	input = 500,
	property = {
        {
            name = "背景形式", item = {{name = "画像(png)", op = 915}, {name = "動画(mp4)", op = 916}}, def = "画像(png)"
		},
		{ -- 926まで使用
			name = "難易度毎の色変化", item = {{name = "あり", op = 920}, {name = "灰固定", op = 921}, {name = "緑固定", op = 922}, {name = "青固定", op = 923}, {name = "橙固定", op = 924}, {name = "赤固定", op = 925}, {name = "紫固定", op = 926}}, def = "あり"
		},
        {
            name = "ジャケット位置", item = {{name = "左", op = 930}, {name = "右", op = 931}}, def = "左"
		},
		{ -- 940番台も使うかも
			name = "アニメーション時間", item = {{name = "0.75倍", op = 935}, {name = "1倍", op = 936}, {name = "1.5倍", op = 937}, {name = "2倍", op = 938}, {name = "3倍", op = 939}}, def = "1倍"
		},
		{--  950番台すべて
			name = "パーティクル数", item = {{name = "0", op = 950}, {name = "0.25倍", op = 951}, {name = "0.5倍", op = 952}, {name = "1倍", op = 953}, {name = "1.5倍", op = 954}, {name = "2倍", op = 955}, {name = "3倍", op = 956}}, def = "1倍"
		}
	},
    filepath = {
		{name = "ファイルパス-------------", path = "../dummy/*"},
        {name = "背景(png)", path = "../decide/background/*.png", def = "default"},
		{name = "背景(mp4)", path = "../decide/background/*.mp4"},
		{name = "NoImage画像", path = "../decide/noimage/*.png", def = "default"},
	},
}

local function init(skin)
	if getTableValue(skin_config.option, "ジャケット位置", 930) == 931 then
		TEXT_OFFSET = 0
		STAGE_FILE.X = WIDTH - STAGE_FILE.X - STAGE_FILE.W
	end

	local mulTable = {0.75, 1, 1.5, 2, 3}
	for i = 935, 939 do
		if getTableValue(skin_config.option, "アニメーション時間", 936) == i then
			local mul = mulTable[i - 934]
			FADEOUT = FADEOUT * mul
			skin.fadeout = FADEOUT
			CURTAIN.LINE.APPEAR_TIME_VAR = FADEOUT / 7
			CURTAIN.PARTICLE.LOOP_TIME = FADEOUT / 50
			CURTAIN.PARTICLE.FADEOUT_TIME = FADEOUT / 3
			CURTAIN.PARTICLE.FADEOUT_TIME_VAR = FADEOUT / 7
			CURTAIN.TEXT.COLORED_DELAY_TIME = FADEOUT / 10
			CURTAIN.TEXT.APPEAR_TIME = FADEOUT / 15
			CURTAIN.CLOSE_TIME = FADEOUT / 3
			CURTAIN.TEXT.RICH_APPEAR_TIME = FADEOUT / 30
			CURTAIN.REVERSE_TIME = FADEOUT * 0.9
			CURTAIN.OVERALL_FADEOUT_START = FADEOUT * 0.85
		end
	end
	mulTable = {0, 0.25, 0.5, 1, 1.5, 2, 3}
	for i = 950, 956 do
		if getTableValue(skin_config.option, "パーティクル数", 953) == i then
			local mul = mulTable[i - 949]
			CURTAIN.PARTICLE.N = CURTAIN.PARTICLE.N * mul
		end
	end
end

local function main()
	local skin = {}
	-- ヘッダ情報をスキン本体にコピー
	for k, v in pairs(header) do
		skin[k] = v
	end

	init(skin)

	skin.source = {
        {id = 0, path = "../decide/parts/parts.png"},
		{id = 1, path = "../decide/background/*.png"},
		{id = 2, path = "../decide/background/*.mp4"},
        {id = 3, path = "../decide/noimage/*.png"},
        {id = 4, path = "../decide/parts/curtain.png"},
        {id = 5, path = "../decide/parts/largeshine.png"},
        {id = 6, path = "../decide/parts/text.png"},
        {id = 999, path = "../common/colors/colors.png"}
	}

	skin.image = {
		{id = "noImage", src = 3, x = 0, y = 0, w = -1, h = -1},
		{id = "curtainEdge", src = 4, x = 0, y = 0, w = -1, h = -1},
		{id = "largeShine", src = 5, x = 0, y = 0, w = -1, h = -1},
		{id = "particle0", src = 0, x = 0, y = 0, w = CURTAIN.PARTICLE.SIZE, h = CURTAIN.PARTICLE.SIZE},
		{id = "particle1", src = 0, x = CURTAIN.PARTICLE.SIZE, y = 0, w = CURTAIN.PARTICLE.SIZE, h = CURTAIN.PARTICLE.SIZE},
		{id = "black", src = 999, x = 1, y = 0, w = 1, h = 1},
        {id = "white", src = 999, x = 2, y = 0, w = 1, h = 1},
	}

	-- 文字を読み込む
	local img = skin.image
	for i = 0, CURTAIN.TEXT.W, CURTAIN.TEXT.DIV_W do
		img[#img+1] = {
			id = "textRich2" .. i, src = 6, x = i, y = 0, w = CURTAIN.TEXT.DIV_W, h = CURTAIN.TEXT.H
		}
		img[#img+1] = {
			id = "textRich" .. i, src = 6, x = i, y = CURTAIN.TEXT.H, w = CURTAIN.TEXT.DIV_W, h = CURTAIN.TEXT.H
		}
		img[#img+1] = {
			id = "textColored" .. i, src = 6, x = i, y = CURTAIN.TEXT.H*2, w = CURTAIN.TEXT.DIV_W, h = CURTAIN.TEXT.H
		}
		img[#img+1] = {
			id = "textWhite" .. i, src = 6, x = i, y = CURTAIN.TEXT.H*3, w = CURTAIN.TEXT.DIV_W, h = CURTAIN.TEXT.H
		}
	end


	local c = getTableValue(skin_config.option, "背景形式", 915)
    if c == 915 then
        table.insert(skin.image, {id = "background", src = 1, x = 0, y = 0, w = -1, h = -1})
    elseif c == 916 then
        table.insert(skin.image, {id = "background", src = 2, x = 0, y = 0, w = -1, h = -1})
    end

	skin.font = {
		{id = 0, path = "../common/fonts/SourceHanSans-Regular.otf"}
	}

	skin.text = {
		{id = "genre", font = 0, size = GENRE.FONT_SIZE, ref = 13, align = 1, overflow = 1},
        {id = "title", font = 0, size = TITLE.FONT_SIZE, ref = 12, align = 1, overflow = 1},
		{id = "artist", font = 0, size = ARTISTS.MAIN.FONT_SIZE, ref = 14, align = 1, overflow = 1},
        {id = "subArtist", font = 0, size = ARTISTS.SUB.FONT_SIZE, ref = 15, align = 1, overflow = 1},
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
	local dst = skin.destination
	-- タイトル等の背景
	do
		local r, g, b = getDifficultyColor()
		-- ジャンル
		dst[#dst+1] = {
			id = "white", loop = INTRO_ANIM.TIME, dst = {
				{time = 0, x = WIDTH + 1000, y = GENRE.WND.Y(), w = WIDTH, h = GENRE.WND.H, acc = 2, r = r, g = g, b = b, a = WND_BAR.A},
				{time = INTRO_ANIM.TIME, x = 0}
			}
		}
		dst[#dst+1] = {
			id = "genre", loop = INTRO_ANIM.TIME, dst = {
				{time = 0, x = WIDTH, y = GENRE.Y(GENRE), w = GENRE.W, h = GENRE.FONT_SIZE, acc = 2},
				{time = INTRO_ANIM.TIME, x = GENRE.X()}
			}
		}
		-- タイトル
		dst[#dst+1] = {
			id = "white", loop = INTRO_ANIM.TIME, dst = {
				{time = 0, x = WIDTH + 500, y = TITLE.WND.Y(), w = WIDTH, h = TITLE.WND.H, acc = 2, r = r, g = g, b = b, a = WND_BAR.A},
				{time = INTRO_ANIM.TIME, x = 0}
			}
		}
		dst[#dst+1] = {
			id = "title", loop = INTRO_ANIM.TIME, dst = {
				{time = 0, x = WIDTH, y = TITLE.Y(TITLE), w = TITLE.W, h = TITLE.FONT_SIZE, acc = 2},
				{time = INTRO_ANIM.TIME, x = TITLE.X()}
			}
		}
		-- アーティスト
		dst[#dst+1] = {
			id = "white", loop = INTRO_ANIM.TIME, dst = {
				{time = 0, x = WIDTH, y = ARTISTS.WND.Y(), w = WIDTH, h = ARTISTS.WND.H, acc = 2, r = r, g = g, b = b, a = WND_BAR.A},
				{time = INTRO_ANIM.TIME, x = 0}
			}
		}
		dst[#dst+1] = {
			id = "artist", loop = INTRO_ANIM.TIME, dst = {
				{time = 0, x = WIDTH, y = ARTISTS.MAIN.Y(ARTISTS), w = ARTISTS.MAIN.W, h = ARTISTS.MAIN.FONT_SIZE, acc = 2},
				{time = INTRO_ANIM.TIME, x = ARTISTS.MAIN.X()}
			}
		}
		dst[#dst+1] = {
			id = "subArtist", loop = INTRO_ANIM.TIME, dst = {
				{time = 0, x = WIDTH, y = ARTISTS.SUB.Y(ARTISTS), w = ARTISTS.SUB.W, h = ARTISTS.SUB.FONT_SIZE, acc = 2},
				{time = INTRO_ANIM.TIME, x = ARTISTS.SUB.X()}
			}
		}
	end

	do
		-- stage file
		-- ステージファイル背景
		dst[#dst+1] = {
			id = "black", op = {191}, loop = INTRO_ANIM.TIME, dst = {
				{time = 0, x = -STAGE_FILE.W, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H, acc = 2},
                {time = INTRO_ANIM.TIME, x = STAGE_FILE.X}
			}
		}
        -- noステージファイル背景
		dst[#dst+1] = {
            id = "noImage", op = {190}, stretch = 1, loop = INTRO_ANIM.TIME, dst = {
				{time = 0, x = -STAGE_FILE.W, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H, acc = 2},
                {time = INTRO_ANIM.TIME, x = STAGE_FILE.X}
            }
		}
        -- ステージファイル
		dst[#dst+1] = {
            id = -100, op = {191}, filter = 1, stretch = 1, loop = INTRO_ANIM.TIME, dst = {
				{time = 0, x = -STAGE_FILE.W, y = STAGE_FILE.Y, w = STAGE_FILE.W, h = STAGE_FILE.H, acc = 2},
                {time = INTRO_ANIM.TIME, x = STAGE_FILE.X}
            }
        }
	end

	-- ここからfadeoutアニメーション
	do
		-- まずカーテンが閉まる
		dst[#dst+1] = { -- カーテン上
			id = "curtainEdge", timer = 2, loop = CURTAIN.CLOSE_TIME, dst = {
				{time = 0, x = CURTAIN.FROM_X, y = HEIGHT / 2 - CURTAIN.CIRCLE.SIZE, w = CURTAIN.CIRCLE.SIZE, h = CURTAIN.CIRCLE.SIZE, acc = 2},
				{time = CURTAIN.CLOSE_TIME, x = CURTAIN.TO_X}
			}
		}
		dst[#dst+1] = { -- カーテン下
			id = "curtainEdge", timer = 2, loop = CURTAIN.CLOSE_TIME, dst = {
				{time = 0, x = CURTAIN.FROM_X, y = HEIGHT / 2 + CURTAIN.CIRCLE.SIZE, w = CURTAIN.CIRCLE.SIZE, h = -CURTAIN.CIRCLE.SIZE, acc = 2},
				{time = CURTAIN.CLOSE_TIME, x = CURTAIN.TO_X}
			}
		}
		dst[#dst+1] = { -- カーテン下
			id = "black", timer = 2, loop = CURTAIN.CLOSE_TIME, dst = {
				{time = 0, x = CURTAIN.FROM_X - CURTAIN.BOX.W, y = 0, w = CURTAIN.BOX.W, h = HEIGHT, acc = 2},
				{time = CURTAIN.CLOSE_TIME, x = CURTAIN.TO_X - CURTAIN.BOX.W}
			}
		}

		-- shine周りの座標定義 パーティクルにも
		local shineStartX = CURTAIN.TO_X - CURTAIN.SHINE.W / 2 + 10
		local shineToX = -CURTAIN.SHINE.W
		local shineStartY = CURTAIN.LINE.START_Y - CURTAIN.LINE.INTERVAL_Y * 4 - CURTAIN.SHINE.H / 2

		-- パーティクル
		local frontParticleDsts = {}
		local closeTime = CURTAIN.CLOSE_TIME
		local d = CURTAIN.REVERSE_TIME - CURTAIN.CLOSE_TIME
		local particlePerMs = CURTAIN.PARTICLE.N / d * CURTAIN.PARTICLE.TIME_RES
		local particle = CURTAIN.PARTICLE
		-- 各種先に記録して高速化
		local fadeoutTime = particle.FADEOUT_TIME
		local fadeoutTimeVar = math.ceil(particle.FADEOUT_TIME_VAR / 2)
		local moveR = particle.MOVE_R
		local moveRVar = math.ceil(particle.MOVE_R_VAR / 2)
		local moveXVar = math.ceil(particle.MOVE_X_VAR / 2)
		local angleVar = math.ceil(particle.ANGLE_VAR / 2)
		local moveX = particle.MOVE_X
		local fadeoutX = particle.FADEOUT_X
		local size = particle.SIZE
		local sizeVar = math.ceil(particle.SIZE_VAR / 2)
		local alpha = particle.ALPHA
		local alphaVar = math.ceil(particle.ALPHA_VAR / 2)
		for i = 1, d, particle.TIME_RES do
			-- 時刻iで飛ばすパーティクルの数を計算
			local n = dithering(particlePerMs)
			-- x軸周りに飛ばす方向の基本値を計算
			local baseAngle = ((i % particle.LOOP_TIME) / particle.LOOP_TIME) * 2
			-- 時刻iでの光球の位置を計算
			local shineX = easeOut(i, shineStartX, shineToX, d) + CURTAIN.SHINE.W / 2
			if shineX > -10 then
				-- yは今のところ直線なので固定値
				local particleStartY = CURTAIN.LINE.START_Y - CURTAIN.LINE.INTERVAL_Y * 4
				-- パーティクルを飛ばす基点x とりあえずばらつきなし
				local particleStartX = shineX
				-- 飛ばす
				for j = 1, n do
					-- local particleImg = math.random(0, 1)
					local particleImg = 0
					-- フェードアウト周り
					local eachFadeoutTime = fadeoutTime + math.random(-fadeoutTimeVar, fadeoutTimeVar)
					local fadeoutP = fadeoutX / moveX
					local fadeoutStartTime = eachFadeoutTime * fadeoutP
					local eachSize = size + math.random(-sizeVar, sizeVar)

					local eachAlpha = alpha + math.random(-alphaVar, alphaVar)

					-- 飛ばす方向
					local a = (baseAngle + (math.random(-angleVar, angleVar) / 180)) * math.pi
					-- 飛ばす距離(中間座標と最終座標)
					local xVar = math.random(-moveXVar, moveXVar)
					local particleFadeStartX = particleStartX + fadeoutP * xVar
					local toX = particleStartX + xVar
					-- y, zの飛ぶ距離
					local len = moveR + math.random(-moveRVar, moveRVar)
					local toY = particleStartY + len * math.sin(a)
					local toZ = len * math.cos(a)
					local fadeoutStartY = particleStartY + len * math.sin(a) * fadeoutP
					local fadeoutStartZ = fadeoutP * toZ

					local fx, fy = perspectiveProjection(particleFadeStartX, fadeoutStartY, fadeoutStartZ, FOV)
					local tx, ty = perspectiveProjection(toX, toY, toZ, FOV)
					local fs, _ = perspectiveProjectionSize(eachSize, eachSize, fadeoutStartZ, FOV)
					local ts, _ = perspectiveProjectionSize(eachSize, eachSize, toZ, FOV)

					-- 手前に飛んでくる場合は, 文字より後にdstを挿入
					local d1 = {
						id = "particle" .. particleImg, timer = 2, loop = -1, dst = {
							{time = 0, x = particleStartX - eachSize / 2, y = particleStartY - eachSize / 2, w = eachSize, h = eachSize, a = 0, r = r, g = g, b = b},
							{time = closeTime + i - 1, a = 0},
							{time = closeTime + i, a = eachAlpha},
							{time = closeTime + fadeoutStartTime - 1 + i, x = fx - fs / 2, y = fy - fs / 2, w = fs, h = fs}
						}
					}
					local d2 = {
						id = "particle" .. particleImg, timer = 2, loop = -1, dst = {
							{time = 0, x = fx - fs / 2, y = fy - fs / 2, w = fs, h = fs, a = 0, acc = 2, r = r, g = g, b = b},
							{time = closeTime + fadeoutStartTime + i - 1, a = 0},
							{time = closeTime + fadeoutStartTime + i, a = eachAlpha},
							{time = closeTime + eachFadeoutTime + i, x = tx - ts / 2, y = ty - ts / 2, w = ts, h = ts, a = 0}
						}
					}
					if toZ < 0 then -- 手前に飛んでくるパーティクルは後でdstに入れる
						frontParticleDsts[#frontParticleDsts+1] = d1
						frontParticleDsts[#frontParticleDsts+1] = d2
					else -- 奥に飛んでいくパーティクルは先にdstに入れる
						dst[#dst+1] = d1
						dst[#dst+1] = d2
					end
				end
			end
		end

		-- 線が出てくる
		do
			local r, g, b = getCurtainShineColor()
			for i = 1, 5 do
				local timeOffst = math.random(0, CURTAIN.LINE.APPEAR_TIME_VAR)
				dst[#dst+1] = {
					id = "white", timer = 2, loop = CURTAIN.CLOSE_TIME + timeOffst, dst = {
						{time = timeOffst, x = 0, y = CURTAIN.LINE.START_Y - CURTAIN.LINE.INTERVAL_Y * (i - 1), w = 0, h = 2, acc = 2, r = r, g = g, b = b},
						{time = CURTAIN.CLOSE_TIME + timeOffst, w = WIDTH}
					}
				}
			end
		end
		dst[#dst+1] = { -- 光球
			id = "largeShine", timer = 2, loop = -1, dst = {
				{time = 0, x = CURTAIN.FROM_X - CURTAIN.SHINE.W / 2 + 10, y = (HEIGHT - CURTAIN.SHINE.H) / 2, w = CURTAIN.SHINE.W, h = CURTAIN.SHINE.H, angle = 0, acc = 2, r = r, g = g, b = b},
				{time = CURTAIN.CLOSE_TIME, x = CURTAIN.TO_X - CURTAIN.SHINE.W / 2 + 10, angle = -270}
			}
		}
		-- 光球が戻ってくる
		dst[#dst+1] = { -- 光球
			id = "largeShine", timer = 2, loop = FADEOUT, dst = {
				{time = 0, x = shineStartX, y = shineStartY, w = CURTAIN.SHINE.W, h = CURTAIN.SHINE.H, angle = -270, a = 0, acc = 2, r = r, g = g, b = b},
				{time = CURTAIN.CLOSE_TIME, a = 255},
				{time = CURTAIN.REVERSE_TIME, x = shineToX, angle = 90}
			}
		}

		do
			-- まず白文字
			local r, g, b = getTextColor()
			local div = CURTAIN.TEXT.DIV_W
			local w = CURTAIN.TEXT.W
			local startX = (WIDTH - w) / 2
			local h = CURTAIN.TEXT.H
			local y = (HEIGHT - CURTAIN.TEXT.H) / 2
			local appearTime = CURTAIN.TEXT.APPEAR_TIME
			local richAppearTime = CURTAIN.TEXT.RICH_APPEAR_TIME
			local coloredDelayTime = CURTAIN.TEXT.COLORED_DELAY_TIME
			local coloredD1 = CURTAIN.TEXT.COLORED_DEL1
			local coloredD2 = CURTAIN.TEXT.COLORED_DEL2
			local coloredDelTime = CURTAIN.TEXT.COLORED_DEL_TIME
			for i = 0, w, div do
				local textX = startX + i
				local time = easeOutTime(textX - div, CURTAIN.FROM_X, CURTAIN.TO_X, CURTAIN.CLOSE_TIME)
				local delColoredTime = CURTAIN.CLOSE_TIME + easeOutTime(textX, shineStartX + CURTAIN.SHINE.W / 2, shineToX + CURTAIN.SHINE.W / 2, d)
				dst[#dst+1] = {
					id = "textWhite" .. i, timer = 2, loop = time + appearTime, dst = {
						{time = 0, x = textX, y = y, w = div, h = h, a = 0, acc = 0},
						{time = time},
						{time = time + appearTime, a = 255}
					}
				}
				dst[#dst+1] = {
					id = "textColored" .. i, timer = 2, loop = delColoredTime + richAppearTime, dst = {
						{time = 0, x = textX, y = y, w = div, h = h, a = 0, r = r, g = g, b = b, acc = 0},
						{time = time + coloredDelayTime},
						{time = time + appearTime + coloredDelayTime, a = 255},
						{time = delColoredTime},
						{time = delColoredTime + richAppearTime, a = 0}
						-- {time = time + appearTime + coloredDelayTime + coloredD1-1, a = 0},
						-- {time = time + appearTime + coloredDelayTime + coloredD1 + coloredDelTime - 1, a = 0},
						-- {time = time + appearTime + coloredDelayTime + coloredD1 + coloredDelTime, a = 255},
						-- {time = time + appearTime + coloredDelayTime + coloredD2-1, a = 0},
						-- {time = time + appearTime + coloredDelayTime + coloredD2 + coloredDelTime - 1, a = 0},
						-- {time = time + appearTime + coloredDelayTime + coloredD2 + coloredDelTime, a = 255},
					}
				}
			end
			-- rich
			r, g, b = getCurtainShineColor()
			local sr, sg, sb = getTextColor2()
			for i = 0, w, div do
				local textX = startX + i
				local time = CURTAIN.CLOSE_TIME + easeOutTime(textX, shineStartX + CURTAIN.SHINE.W / 2, shineToX + CURTAIN.SHINE.W / 2, d)
				dst[#dst+1] = {
					id = "textRich" .. i, timer = 2, loop = time + richAppearTime, dst = {
						{time = 0, x = textX, y = y, w = div, h = h, a = 0, r = r, g = g, b = b, acc = 0},
						{time = time-1},
						{time = time},
						{time = time + richAppearTime, a = 255}
					}
				}
				dst[#dst+1] = {
					id = "textRich2" .. i, timer = 2, loop = time + richAppearTime, dst = {
						{time = 0, x = textX, y = y, w = div, h = h, a = 0, r = sr, g = sg, b = sb, acc = 0},
						{time = time-1},
						{time = time},
						{time = time + richAppearTime, a = 255}
					}
				}
			end

		end


		-- 手前に飛んでくるパーティクルを入れる
		for i = 1, #frontParticleDsts do
			dst[#dst+1] = frontParticleDsts[i]
		end
	end

	-- 全体のフェードアウト
	dst[#dst+1] = {
		id = "black", timer = 2, loop = FADEOUT, dst = {
			{time = 0, x = 0, y = 0, w = WIDTH, h = HEIGHT, a = 0},
			{time = CURTAIN.OVERALL_FADEOUT_START},
			{time = FADEOUT, a = 255}
		}
	}

    return skin
end

return {
    header = header,
    main = main
}