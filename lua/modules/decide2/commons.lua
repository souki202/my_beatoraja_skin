require("modules.commons.define")

function getLoadingType()
    return getTableValue(skin_config.option, "種類", 910) - 909
end

function getRawSceneTime()
    return getOffsetValueWithDefault("ロード時間 (ミリ秒, 既定値2000)", {x = 2000}).x
end

function getSceneTimeBlurred()
    return getOffsetValueWithDefault("ロード時間のぶれ (ミリ秒, 既定値300)", {x = 300}).x
end

function getSceneTime()
    local b = getSceneTimeBlurred();
    return getRawSceneTime() + math.random(-b, b)
end
