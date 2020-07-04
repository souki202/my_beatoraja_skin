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
-- @param  number selectVersion 現在のバージョンの文字列
-- @param  number resultVersion
-- @return boolean, boolean 新しいバージョンがあればtrue, ないか, 接続失敗すればfalse 1個目はセレクト, 2個目はresult
function skinVersionCheck(selectVersion, resultVersion, decideVersion, playVersion)
    local err, v = pcall(httpConnection, "https://tori-blog.net/wp-content/uploads/skin/version")

    if v then
        if  #v < 2 then
            print("バージョンチェックに失敗しました")
            return false, false, false, false
        elseif #v == 2 then
            return tonumber(selectVersion) < tonumber(v[1]), tonumber(resultVersion) < tonumber(v[2]), false, false
        elseif #v == 3 then
            return tonumber(selectVersion) < tonumber(v[1]), tonumber(resultVersion) < tonumber(v[2]), tonumber(decideVersion) < tonumber(v[3]), false
        elseif #v >= 4 then
            return tonumber(selectVersion) < tonumber(v[1]), tonumber(resultVersion) < tonumber(v[2]), tonumber(decideVersion) < tonumber(v[3]), tonumber(playVersion) < tonumber(v[4])
        end
    else
        return false, false, false, false
    end

    return false, false, false, false
end