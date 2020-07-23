local common = require("result_common")

common.setIsCourseResult(true)
local header = common.header()

local function main()

    local skin = common.main()
    skin.type = 15

    return skin
end

header.type = 15

return {
    header = header,
    main = main
}