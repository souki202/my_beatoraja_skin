local common = require("result3_common")
local header = common.header()

local function main()
    return common.main()
end

return {
    header = header,
    main = main
}