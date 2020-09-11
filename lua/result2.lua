local common = require("result2_common")
local header = common.header()

local function main()
    return common.main()
end

return {
    header = header,
    main = main
}