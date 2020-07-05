local luajava = require("luajava")

local gdx = luajava.bindClass("com.badlogic.gdx.Gdx")
local audio = nil

-- できればdisposeできる場面で (さらに止めそこねると鳴り続けるのでループはさせない)
-- ゲームを起動してから終了するまでAudioDriverのインスタンスは維持されるぽいので, disposeしなくても一応リークしない(メモリのリソースが再利用されるだけ)
-- ただdisposeしないとorajaを終了するまで, 本スキンから破棄できる形でリソースが残る
Sound = {
    init = function()
        pcall(function() audio = gdx.app:getApplicationListener():getAudioProcessor() end)
    end,

    -- @param  string path 音源のファイルパス
    -- @param  float vol 音量 最大1.0
    play = function(path, vol)
        pcall(function() audio:play(path, vol) end)
    end,

    -- playLoop = function(path)
    --     if Sound.isPlaying(path) then
    --         audio:stop(path)
    --     end
    --     audio:play(path, 1,0, true)
    -- end,

    isPlaying = function(path)
        return pcall(function() return audio:isPlaying(path) end)
    end,

    stop = function(path)
        pcall(function() audio:stop(path) end)
    end,

    dispose = function(path)
        pcall(function() audio:dispose(path) end)
    end
}
