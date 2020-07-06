local commons = require("modules.select.commons")
local background = {
    functions = {}
}

background.functions.isEnableSlideshow = function ()
    return getTableValue(skin_config.option, "スライドショー(pngのみ)", 960) ~= 960
end

background.functions.load = function ()
    local skin = {
        source = {
            {id = 1, path = "../select/background/*.png"},
            {id = 101, path = "../select/background/*.mp4"},
        },
        image = {}
    }

    local c = getTableValue(skin_config.option, "背景形式", 915)
    local slideType = getTableValue(skin_config.option, "スライドショー(pngのみ)", 960)
    if background.functions.isEnableSlideshow() then

    else
        if c == 915 then
            table.insert(skin.image, {id = "background", src = 1, x = 0, y = 0, w = -1, h = -1})
        elseif c == 916 then
            table.insert(skin.image, {id = "background", src = 101, x = 0, y = 0, w = -1, h = -1})
        end
    end

end

return background.functions