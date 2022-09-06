local N = 10
local VAL_RAN_RANGE = {-1, 10}
local TIME_RAN_RANGE = {150, 300}
local MAX_VAL = 100
local START_TIME = 300
local WAIT_TIME = 300


function normalize(timeTable, sceneTime)
    local maxTime = timeTable[#timeTable].time
    local maxVal = timeTable[#timeTable].val

    for i = 1, #timeTable do
        timeTable[i].time = START_TIME + math.floor(timeTable[i].time / maxTime * (sceneTime - WAIT_TIME - START_TIME))
        timeTable[i].val = math.floor(timeTable[i].val / maxVal * MAX_VAL)
    end
    timeTable[#timeTable].time = sceneTime - WAIT_TIME
    timeTable[#timeTable].val = MAX_VAL
end

return {
    getLoadingTimeTable = function(sceneTime)
        local table = {{time=0, val=0}} -- {time, value}
        do
            local time = 0
            local val = 0;
            for i = 1, N do
                time = time + math.random(TIME_RAN_RANGE[1], TIME_RAN_RANGE[2])
                val = val + math.max(0, math.random(VAL_RAN_RANGE[1], VAL_RAN_RANGE[2]))
                table[#table+1] = {time=time, val=val}
            end
        end
        if (table[#table].val == table[#table - 1].val) then
            table[#table].val = table[#table].val * 1.1
        end

        -- 正規化
        normalize(table, sceneTime)
        return table
    end,
}