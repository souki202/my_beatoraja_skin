local main_state = require("main_state")
require("modules.result.commons")

CUSTOM_TIMERS_RESULT3 = {
    EXSCORE_GETNUM_TIMER_START = 10100, -- 11000までこれ
}

function getGrooveGaugeAreaGraph()
    return (getTableValue(skin_config.option, "各種グラフ グルーヴゲージ部分", 945) % 5) + 1
end

function getGaugeTypeAtDetailWindow1()
    return (getTableValue(skin_config.option, "各種グラフ 詳細画面1個目", 936) % 5) + 1
end

function getGaugeTypeAtDetailWindow2()
    return (getTableValue(skin_config.option, "各種グラフ 詳細画面2個目", 942) % 5) + 1
end

function getStageFileAreaDefaultView()
    return (getTableValue(skin_config.option, "ステージファイル部分の初期表示", 915) % 5) + 1
end
