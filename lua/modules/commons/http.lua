local luajava = require("luajava")

local function httpConnection(url)
    local lines = {}
    local url2 = luajava.newInstance("java.net.URL", url);
    local urlConn = url2:openConnection()
    urlConn:setRequestMethod("GET")
    urlConn:setConnectTimeout(200) -- バージョンチェックは失敗しても良いので, タイムアウトが早くても問題ない
    if pcall(function() urlConn:connect() end) then
        local status = urlConn:getResponseCode()
        if status == 200 then
            local reader = luajava.newInstance("java.io.BufferedReader", luajava.newInstance("java.io.InputStreamReader", urlConn:getInputStream(), "utf8"))
            -- 1行ごとに配列へ
            local hasLine = true
            while hasLine do
                local line = reader:readLine()
                if line then
                    table.insert(lines, line)
                else
                    hasLine = false
                end
            end
        else
            print("HTTPステータスが正常ではありません: " .. status)
        end
    else
        print("connectに失敗しました")
        return
    end
    return lines
end

-- 各スキンのバージョンを確認する
-- @param  {array} versions 現在のバージョンの文字列の配列 手前から, セレクト, リザルト, decide, プレイ, リザルト2
-- @return {boolean} 新しいバージョンがあるかの配列. それぞれのindexは上に対応しているか, nil 取得に失敗すれば空の配列
function skinVersionCheck(nowVersions)
    local err, v = pcall(httpConnection, "https://tori-blog.net/wp-content/uploads/skin/version")
    local isNews = {}
    if v then
        local n = math.min(#v, #nowVersions)
        for i = 1, n do
            isNews[i] = tonumber(nowVersions[i]) < tonumber(v[i])
        end
    else
        print("スキンのバージョンチェックに失敗しました")
    end

    return isNews
end