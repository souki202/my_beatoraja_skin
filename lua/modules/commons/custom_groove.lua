--[[
    カスタムグルーヴゲージ画像のファイル管理

    beatoraja 0.8.9以降はLuaからファイルを削除できず(os.remove不可), 書き込みもluaディレクトリ配下に限られるため,
    lua/generated/custom_groove/ 以下の決まった数のファイル名を順番に上書きして使う.
    スキン画像はパスでキャッシュされるので, 同じファイル名を再び使うまでにキャッシュが破棄されるだけの数をローテーションする.

    キャッシュ(ResourcePool)はスキン読み込みのたびに世代が1進み, 世代数(skinPixmapGen, 最大100)を超えると破棄される.
    1プレイにつき最低2回(プレイ, リザルト)スキンを読み込むので, N個のファイルを使い回すと再利用までに2N世代以上進む.
    2N > 100 となるよう, 余裕を持たせて60個とする. (1ファイル約200KB, 合計約12MB)
]]

local customGroove = {}

local DIR_PATH = "generated/custom_groove/"
local ID_PATH = DIR_PATH .. "id.txt"
local COUNTER_PATH = DIR_PATH .. "counter.txt"
local NUM_OF_SLOTS = 60

local function readFirstLine(path)
    local f = io.open(skin_config.get_path(path), "r")
    if f == nil then
        return nil
    end
    local line = f:read("*l")
    f:close()
    return line
end

local function writeText(path, text)
    local f = io.open(skin_config.get_path(path), "w")
    if f == nil then
        print("ファイルの書き込みに失敗しました: " .. path)
        return false
    end
    f:write(text)
    f:close()
    return true
end

-- skin_config.get_pathに渡すパス
customGroove.getImagePath = function (id)
    return DIR_PATH .. "groove_" .. id .. ".png"
end

-- 次に出力する画像のIDを払い出す
customGroove.nextImageId = function ()
    local counter = tonumber(readFirstLine(COUNTER_PATH) or "") or -1
    counter = (counter + 1) % NUM_OF_SLOTS
    writeText(COUNTER_PATH, tostring(counter))
    return tostring(counter)
end

customGroove.writeImageId = function (id)
    return writeText(ID_PATH, id)
end

-- リザルトで読み込む画像のIDを取得する. 次回以降に古い画像を表示しないよう, 読み込んだらIDは消去する
-- @return string|nil 画像が無ければnil
customGroove.takeImageId = function ()
    local id = readFirstLine(ID_PATH)
    if id == nil or id == "" then
        return nil
    end
    writeText(ID_PATH, "")
    return id
end

return customGroove
