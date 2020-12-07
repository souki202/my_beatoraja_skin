local luajava = require("luajava")

local Desktop = luajava.bindClass("java.awt.Desktop")

local desktop = {
    functions = {}
}

desktop.functions.openUrlByBrowser = function (url)
    if url == "" then
        return
    end

    local isSuccess, _ = pcall(function ()
        local uri = luajava.newInstance("java.net.URI", url);
        Desktop:getDesktop():browse(uri)
    end)
    if not isSuccess then
        print("urlのオープンに失敗しました: " .. url)
    end
end

return desktop.functions