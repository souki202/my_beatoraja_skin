local main_state = require("main_state")

-- beatoraja 0.8.9以降はluajavaが使えないため, main_stateのaudio_*関数を使用する
-- パスはスキンのluaディレクトリ配下のみ再生可能
-- できればdisposeできる場面で (さらに止めそこねると鳴り続けるのでループはさせない)
Sound = {
    init = function()
    end,

    -- @param  string path 音源のファイルパス
    -- @param  float vol 音量 最大1.0 (システム音量に乗算される)
    play = function(path, vol, loop)
        if loop then
            pcall(main_state.audio_loop, path, vol)
        else
            pcall(main_state.audio_play, path, vol)
        end
    end,

    -- 0.8.9では再生中かどうかは取得できない
    isPlaying = function(_)
        return false
    end,

    stop = function(path)
        pcall(main_state.audio_stop, path)
    end,

    dispose = function(path)
        pcall(main_state.audio_dispose, path)
    end
}
