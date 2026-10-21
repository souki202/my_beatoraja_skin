local main_state = require("main_state")
local bmsSearch = require("modules.commons.bms_search")
local musicDetail = {}
local request, selectionKey
local event = {name = "", url = ""}

function musicDetail.getHttpTimer() return 10700 end
function musicDetail.getEventData() return event end

function musicDetail.clearViewData()
    if request then request:cancel() end
    request, selectionKey = nil, nil
    event = {name = "", url = ""}
end

-- タイマーは既存の「楽曲データベースの使用」設定に従う。
function musicDetail.fetchMusicDetail()
    if not main_state.option(2) or main_state.option(1030) then
        musicDetail.clearViewData()
        return 0
    end
    return musicDetail._fetchMusicDetail(1000, main_state.timer(11))
end

function musicDetail.fetchMusicDetailOnPlay()
    return musicDetail._fetchMusicDetail(0, 0)
end

function musicDetail._fetchMusicDetail(waitTime, time)
    local sha256 = main_state.text(1031)
    if type(sha256) ~= "string" or #sha256 ~= 64 or not sha256:match("^%x+$") then
        musicDetail.clearViewData()
        return 0
    end
    sha256 = sha256:lower()
    if selectionKey ~= sha256 then
        musicDetail.clearViewData()
        selectionKey = sha256
    end
    if (main_state.time() - time) / 1000 < waitTime then return 0 end
    if not request then
        request = bmsSearch.get(sha256)
        event = request.data
        request:runHttpRequest()
    end
    request:update()
    return 0
end

function musicDetail.loadPlay()
    musicDetail.clearViewData()
    return {}
end

function musicDetail.loadSelect()
    musicDetail.clearViewData()
    return {}
end

function musicDetail.dst() return {destination = {}} end

return musicDetail
