function printTable(t, indent, tableHistory)
    indent = indent or ""
    tableHistory = tableHistory or {}
    if tableHistory[t] then
        print(indent .. "*reference*")
        return
    end
    tableHistory[t] = true
    for k, v in pairs(t) do
        local valueType = type(v)
        if valueType == "table" then
            print(indent .. tostring(k) .. ":")
            printTable(v, indent .. "  ", tableHistory)
        else
            print(indent .. tostring(k) .. ": " .. tostring(v))
        end
    end
end
