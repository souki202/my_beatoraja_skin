local main_state = require("main_state")
local compat = require("modules.commons.compat")
local desktop = {}
local legacyDesktop

local function getLegacyDesktop()
    if legacyDesktop == nil then
        local Desktop = compat.javaClass("java.awt.Desktop")
        local ok, value = pcall(function ()
            if Desktop:isDesktopSupported() then return Desktop:getDesktop() end
        end)
        legacyDesktop = ok and value or false
    end
    return legacyDesktop or nil
end

function desktop.canOpenUrl()
    return main_state.open_url ~= nil or getLegacyDesktop() ~= nil
end

-- クリックイベント中に起動する。新APIの拒否時に別経路へ切り替えない。
function desktop.openUrlByBrowser(url)
    if type(url) ~= "string" or #url > 2048 or string.find(url, "%s") then return false end
    local authority = string.match(url, "^https?://([^/%?#]+)")
    if not authority or string.find(authority, "@", 1, true) then return false end
    local ok, result
    if main_state.open_url then
        ok, result = pcall(main_state.open_url, url)
    else
        local browser = getLegacyDesktop()
        if not browser then return false end
        ok, result = pcall(function ()
            browser:browse(compat.getJava().newInstance("java.net.URI", url))
            return true
        end)
    end
    if not ok or result ~= true then
        print("URLを開けませんでした: " .. url)
        return false
    end
    return true
end

return desktop
