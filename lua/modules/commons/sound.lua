local main_state = require("main_state")
local compat = require("modules.commons.compat")
local audio

local function legacyAudio()
    if not audio then
        local ok, value = pcall(function ()
            return compat.javaClass("com.badlogic.gdx.Gdx").app:getApplicationListener():getAudioProcessor()
        end)
        if ok then audio = value end
    end
    return audio
end

local function invoke(api, method, path)
    local ok, result
    if main_state[api] then
        ok, result = pcall(main_state[api], path)
    elseif not main_state.audio_play then
        ok, result = pcall(function () return legacyAudio()[method](audio, path) end)
    end
    return ok == true and result ~= false
end

Sound = {
    init = function ()
        if not main_state.audio_play then legacyAudio() end
    end,
    play = function (path, vol, loop)
        vol = math.max(0, math.min(2, vol or 1))
        local api = loop and "audio_loop" or "audio_play"
        if main_state[api] then
            local ok, result = pcall(main_state[api], path, vol)
            return ok and result ~= false
        end
        if main_state.audio_play then return false end
        local ok, result = pcall(function ()
            local systemVolume = main_state.volume_sys and main_state.volume_sys() or 1
            return legacyAudio():play(path, vol * systemVolume, loop == true)
        end)
        return ok and result ~= false
    end,
    preload = function (path)
        if main_state.audio_preload then return invoke("audio_preload", "play", path) end
        return Sound.play(path, 0, false)
    end,
    isPlaying = function (path)
        if main_state.audio_play then return false end
        local ok, playing = pcall(function () return legacyAudio():isPlaying(path) end)
        return ok and playing == true
    end,
    stop = function (path) return invoke("audio_stop", "stop", path) end,
    dispose = function (path)
        Sound.stop(path)
        return invoke("audio_dispose", "dispose", path)
    end,
}
