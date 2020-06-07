local common = require("result_common_simple")
local header = common.header

local function main()
    return common.main()
end

return {
    header = header,
    main = main
}