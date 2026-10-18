-- APIの存在で分岐する。限定的なluajava facadeを完全なJava環境と扱わない。
local main_state = require("main_state")
local compat = {}
local javaClasses = {}
local java

function compat.getJava()
    if java == nil then
        local ok, value = pcall(require, "luajava")
        java = ok and value or false
    end
    return java or nil
end

function compat.javaClass(name)
    if javaClasses[name] == nil then
        local j = compat.getJava()
        local ok, value = pcall(function () return j.bindClass(name) end)
        javaClasses[name] = ok and value or false
    end
    return javaClasses[name] or nil
end

function compat.hasMethod(object, name)
    if object == nil then return false end
    local ok, value = pcall(function () return object[name] end)
    return ok and value ~= nil
end

function compat.makeDirectory(path)
    if main_state.file_mkdir then
        local ok, result = pcall(main_state.file_mkdir, path)
        return ok and result == true
    end
    local ok, result = pcall(function ()
        local file = compat.getJava().newInstance("java.io.File", path)
        return file:isDirectory() or file:mkdirs()
    end)
    return ok and result == true
end

function compat.openFile(path, mode)
    if mode and (string.find(mode, "w", 1, true) or string.find(mode, "a", 1, true)) then
        local parent = string.match(path, "^(.*)[/\\][^/\\]+$")
        if parent then compat.makeDirectory(parent) end
    end
    local ok, file, err = pcall(io.open, path, mode or "r")
    if not ok then return nil, file end
    return file, err
end

function compat.deleteFile(path)
    if main_state.file_delete then
        local ok, result = pcall(main_state.file_delete, path)
        return ok and result == true
    end
    if os and os.remove then
        local ok, result = pcall(os.remove, path)
        return ok and result == true
    end
    return false
end

-- 0.8.8以前だけで旧配置からコピーする。新APIの拒否を別の手段で迂回しない。
function compat.copyLegacyFile(path, legacyPath)
    if main_state.file_mkdir then return false end
    local ok, exists = pcall(function ()
        return compat.getJava().newInstance("java.io.File", path):exists()
    end)
    -- 読めない既存ファイルも上書きしない。不在を確認できた旧版だけでコピーする。
    if not ok or exists then return false end
    local existing = compat.openFile(path, "r")
    if existing then existing:close() return false end
    local old = compat.openFile(legacyPath, "r")
    if not old then return false end
    local data = old:read("*a")
    old:close()
    if data == nil then return false end
    local file = compat.openFile(path, "w")
    if not file then return false end
    local result = file:write(data)
    file:close()
    return result ~= nil
end

function compat.listFiles(path)
    local paths = {}
    if main_state.file_list then
        local ok, result = pcall(main_state.file_list, path)
        if ok and type(result) == "string" then
            for name in string.gmatch(result, "[^\r\n]+") do
                local okFile, isFile = pcall(function ()
                    local file = compat.getJava().newInstance("java.io.File", name)
                    if compat.hasMethod(file, "isFile") then return file:isFile() end
                end)
                -- 初期facadeやluajavaなしの環境では、読み取り可能なファイルだけを使う。
                if not okFile or isFile == nil then
                    local file = compat.openFile(name, "rb")
                    isFile = file ~= nil
                    if file then file:close() end
                end
                if isFile then
                    paths[#paths + 1] = string.gsub(name, "\\", "/")
                end
            end
        end
    else
        local ok, files = pcall(function ()
            return compat.getJava().newInstance("java.io.File", path):listFiles()
        end)
        if ok and files then
            for i = 1, #files do
                local file = files[i]
                local isFile, filePath = pcall(function ()
                    if type(file) == "string" then return file end
                    if file:isFile() then return tostring(file:getPath()) end
                end)
                if isFile and filePath then
                    paths[#paths + 1] = string.gsub(filePath, "\\", "/")
                end
            end
        end
    end
    table.sort(paths)
    return paths
end

return compat
