require("modules.commons.define")
local main_state = require("main_state")
local playCommons = require("modules.play.commons")
local songInfo = require("modules.commons.songinfo")
local scores = require("modules.play.score")
local lanes = require("modules.play.lanes")
local judges = require("modules.play.judges")
local life = require("modules.play.life")
local scoreGraph = require("modules.play.score_graph")
local bga = require("modules.play.bga")
local title = require("modules.play.title")
local progress = require("modules.play.progress_bar")
local judgeDetail = require("modules.play.judge_detail")
local hispeed = require("modules.play.hispeed")
local sideInfo = require("modules.play.side_info")
local grow = require("modules.play.grow")
local bomb = require("modules.play.bomb")
local loading = require("modules.play.loading")
local finish = require("modules.play.finish")
local fade = require("modules.play.fade")
local visualizer = require("modules.play.visualizer")
local autoplay = require("modules.play.autoplay")
local logger = require("modules.play.logger")
local musicDetail = require("modules.play.music_detail")
local options = require("modules.play.options")

options.init()

local header = {
    type = 0,
    name = "Social Skin" .. (DEBUG and " play dev" or ""),
    w = WIDTH,
    h = HEIGHT,
    loadend = 2500,
    playstart = playCommons.startTime,
    scene = 36000000,
    input = 500,
    close = 2000,
    fadeout = fade.getFadeoutTime(),

    property = options.getProperty(),
    filepath = options.getFilepath(),
    offset = options.getOffset(),
    category = options.getCategory(),
}

local function main()
    local skin = {}
	-- ヘッダ情報をスキン本体にコピー
	for k, v in pairs(header) do
		skin[k] = v
    end

    globalInitialize(skin)
    songInfo.loadSongInfo(main_state.text(10))

    skin.source = {
        {id = 0, path = "../play/parts/parts.png"},
        {id = 5, path = "../play/parts/judges/*.png"},
        {id = 28, path = "../play/parts/judges/early/*.png"},
        {id = 29, path = "../play/parts/judges/late/*.png"},
        {id = 6, path = "../play/parts/combo/*.png"},
        {id = 11, path = "../play/parts/bombs/wave1/*.png"},
        {id = 12, path = "../play/parts/bombs/particle1/*.png"},
        {id = 13, path = "../play/parts/bombs/animation1/*.png"},
        {id = 14, path = "../play/parts/bombs/wave2/*.png"},
        {id = 15, path = "../play/parts/bombs/particle2/*.png"},
        {id = 16, path = "../play/parts/bombs/animation2/*.png"},
        {id = 17, path = "../play/parts/ready/*.png"},
        {id = 18, path = "../play/parts/background/*.png"},
        {id = 19, path = "../play/parts/fc/shine_circle.png"},
        {id = 20, path = "../play/parts/fc/fireworks/default.png"},
        {id = 21, path = "../play/parts/fc/particle/default.png"},
        {id = 22, path = "../play/parts/versatilitybga/*.png"},
        {id = 23, path = "../play/parts/versatilitybga/*.mp4"},
        {id = 25, path = "../play/parts/visualizer/bar.png"},
        {id = 26, path = "../play/parts/visualizer/reflection.png"},
        {id = 40, path = "../play/parts/groove/indicators/*.png"},
        {id = 41, path = "../play/parts/groove/gauge100/default.png"},
        {id = 42, path = "../play/parts/groove/types/*.png"},
        {id = 43, path = "../play/parts/groove/frame/*.png"},
        {id = 50, path = "../play/parts/exscore/label/*.png"},
        {id = 60, path = "../play/parts/bga/mask/*.png"},
        {id = 61, path = "../play/parts/bga/frame/normal/*.png"},
        {id = 62, path = "../play/parts/bga/frame/large/*.png"},
        {id = 63, path = "../play/parts/bga/frame/full/*.png"},
        {id = 70, path = "../play/parts/title/frame/*.png"},
        {id = 80, path = "../play/parts/lane/laneside/*.png"},
        {id = 81, path = "../play/parts/lane/notes/original/*.png"},
        {id = 82, path = "../play/parts/lane/notes/normal/*.png"},
        {id = 83, path = "../play/parts/lane/judgeline/layer1/*.png"},
        {id = 84, path = "../play/parts/lane/judgeline/layer2/*.png"},
        {id = 86, path = "../play/parts/lane/lanecover/default.png"},
        {id = 87, path = "../play/parts/lane/liftcover/default.png"},
        {id = 88, path = "../play/parts/lane/laneside/state/nogood/*.png"},
        {id = 89, path = "../play/parts/lane/laneside/state/nomiss/*.png"},
        {id = 90, path = "../play/parts/lane/laneside/state/survival/*.png"},
        {id = 91, path = "../play/parts/lane/laneside/state/clear/*.png"},
        {id = 92, path = "../play/parts/lane/laneside/state/fail/*.png"},
        {id = 100, path = "../play/parts/detail/noimage/*.png"},
        {id = 101, path = "../play/parts/detail/frame/*.png"},
        {id = 102, path = "../play/parts/detail/stagefileframe/*.png"},
        {id = 103, path = "../play/parts/detail/bg/*.png"},
        {id = 104, path = "../sounds/key/*.wav"},
        {id = 999, path = "../commON/colors/colors.png"}
    }

    skin.image = {
        {id = "blank", src = 999, x = 0, y = 0, w = 1, h = 1},
        {id = "black", src = 999, x = 1, y = 0, w = 1, h = 1},
        {id = "white", src = 999, x = 2, y = 0, w = 1, h = 1},
    }

    skin.font = {
		{id = 0, path = "../common/fonts/SourceHanSans-Regular.otf"},
    }

    -- 各種読み込み
    mergeSkin(skin, scores.load())
    mergeSkin(skin, logger.load())
    mergeSkin(skin, bga.load())
    mergeSkin(skin, title.load())
    mergeSkin(skin, grow.load())
    mergeSkin(skin, lanes.load())
    mergeSkin(skin, progress.load())
    mergeSkin(skin, sideInfo.load())
    mergeSkin(skin, judges.load())
    mergeSkin(skin, life.load())
    mergeSkin(skin, scoreGraph.load())
    mergeSkin(skin, judgeDetail.load())
    mergeSkin(skin, hispeed.load())
    mergeSkin(skin, bomb.load())
    mergeSkin(skin, loading.load())
    mergeSkin(skin, finish.load())
    mergeSkin(skin, fade.load())
    mergeSkin(skin, autoplay.load())
    if isDrawVisualizer1() then
        mergeSkin(skin, visualizer.load())
    end
    mergeSkin(skin, musicDetail.load())

    skin.destination = {}

    -- 各種出力
    mergeSkin(skin, bga.dst())
    if isDrawVisualizer1() then
        mergeSkin(skin, visualizer.dst())
    end
    mergeSkin(skin, title.dst())
    mergeSkin(skin, progress.dst())
    mergeSkin(skin, sideInfo.dst())
    mergeSkin(skin, hispeed.dst())
    mergeSkin(skin, lanes.dst()) -- キービーム, リフト, レーンカバー, グローはここの中でmergeSkin
    mergeSkin(skin, bomb.dst())
    mergeSkin(skin, judges.dst())
    mergeSkin(skin, life.dst())
    mergeSkin(skin, scoreGraph.dst())
    mergeSkin(skin, judgeDetail.dst())
    mergeSkin(skin, musicDetail.dst())
    mergeSkin(skin, autoplay.dst())
    mergeSkin(skin, loading.dst())
    mergeSkin(skin, finish.dst())
    mergeSkin(skin, fade.dst())
    return skin
end

return {
    header = header,
    main = main
}