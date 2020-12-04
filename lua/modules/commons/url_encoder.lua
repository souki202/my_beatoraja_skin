--[[----------------------------------------------------------------------------
 Copyright 2014 S. Tanaka
 All Rights Reserved.
--------------------------------------------------------------------------------
URLEncoder.lua
Encodes any strings into URL encoded strings with a rule based on rawurlencode in PHP.
------------------------------------------------------------------------------]]
URLEncoder = {
    encode = function(str)
            if (not str) then
                return str
            end

            str = string.gsub (str, "\n", "\r\n")
            str = string.gsub (str, "([^0-9a-zA-Z ])", -- locale independent
                function (c) return string.format ("%%%02X", string.byte(c)) end)
            str = string.gsub (str, " ", "+")

            return str
        end,
    decode = function(str)
            str = string.gsub(str, "%%([0-9a-fA-F][0-9a-fA-F])",
                function (c) return string.char(tonumber("0x" .. c)) end)
            str = string.gsub (str, "\n", "\r\n")
            return str
        end,
}