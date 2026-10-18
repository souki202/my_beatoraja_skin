local desktop = {
    functions = {}
}

-- beatoraja 0.8.9以降はluajava(java.awt.Desktop)が使えず, スキンから任意のURLをブラウザで開く手段が無い
desktop.functions.canOpenUrl = function ()
    return false
end

desktop.functions.openUrlByBrowser = function (url)
    if url == nil or url == "" then
        return
    end
    print("このバージョンのbeatorajaではスキンからURLを開けません: " .. url)
end

return desktop.functions
