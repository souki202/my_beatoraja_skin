local common = require("result_common")
local header = common.header

local function main()
    common.setIsCourseResult(true)

    local skin = common.main()
    skin.type = 15

    return skin
end

header.type = 15

return {
    header = header,
    main = main
}