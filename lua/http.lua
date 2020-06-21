luajava = require("luajava")

function httpConnection(url)
    local lines = {}
    local url = luajava.newInstance( "java.net.URL", url);
    local urlConn = url:openConnection()
    urlConn:setRequestMethod("GET")
    urlConn:setConnectTimeout(200)
    if pcall(function() urlConn:connect() end) then
        local status = urlConn:getResponseCode()
        if status == 200 then
            local reader = luajava.newInstance("java.io.BufferedReader", luajava.newInstance("java.io.InputStreamReader", urlConn:getInputStream(), "utf8"))
            -- バージョンは1行しかない
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

-- セレクトスキンのバージョンを確認する
-- @param  string nowVersion 現在のバージョンの文字列
-- @return boolean, boolean 新しいバージョンがあればtrue, ないか, 接続失敗すればfalse 1個目はセレクト, 2個目はresult
function skinVersionCheck(selectVersion, resultVersion)
    local err, v = pcall(httpConnection, "https://tori-blog.net/wp-content/uploads/skin/version")

    if  #v ~= 2 then
        print("バージョンチェックに失敗しました")
        return false, false
    end
    return tonumber(selectVersion) < tonumber(v[1]), tonumber(resultVersion) < tonumber(v[2])
end