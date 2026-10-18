--[[
    パレット形式(最大255色+透明)の画像を作成してPNGとして出力する

    beatoraja 0.8.9以降はluajava(java.awt.image.BufferedImage, javax.imageio.ImageIO)が使えないため,
    PNGのエンコードをLuaで行う. 圧縮は行わない(無圧縮のdeflateブロック)ので, 小さい画像向け.
    出力先はスキンのluaディレクトリ配下に制限される.
]]

local band, bor, bxor, rshift = bit32.band, bit32.bor, bit32.bxor, bit32.rshift
local unpack = table.unpack or unpack
local compat = require("modules.commons.compat")

local CRC_TABLE = {}
for i = 0, 255 do
    local c = i
    for _ = 1, 8 do
        if band(c, 1) == 1 then
            c = bxor(0xEDB88320, rshift(c, 1))
        else
            c = rshift(c, 1)
        end
    end
    CRC_TABLE[i] = c
end

local function crcUpdateString(crc, str)
    local len = #str
    local CHUNK = 4096
    for i = 1, len, CHUNK do
        local bytes = {string.byte(str, i, math.min(i + CHUNK - 1, len))}
        for j = 1, #bytes do
            crc = bxor(CRC_TABLE[band(bxor(crc, bytes[j]), 0xFF)], rshift(crc, 8))
        end
    end
    return crc
end

local function uint32be(v)
    return string.char(band(rshift(v, 24), 0xFF), band(rshift(v, 16), 0xFF), band(rshift(v, 8), 0xFF), band(v, 0xFF))
end

-- 数値配列をstring.charで文字列化する (引数の数の上限を避けるため分割する)
local function bytesToString(bytes, n)
    local parts = {}
    local CHUNK = 4096
    for i = 1, n, CHUNK do
        parts[#parts + 1] = string.char(unpack(bytes, i, math.min(i + CHUNK - 1, n)))
    end
    return table.concat(parts)
end

local function chunk(chunkType, data)
    local crc = crcUpdateString(0xFFFFFFFF, chunkType)
    crc = crcUpdateString(crc, data)
    return uint32be(#data) .. chunkType .. data .. uint32be(bxor(crc, 0xFFFFFFFF))
end

local image = {}

image.newInstance = function ()
    return {
        width = 0,
        height = 0,
        -- pixels[y * width + x + 1] = パレットのインデックス (0は透明)
        pixels = nil,
        palette = nil,
        paletteIndex = nil,

        -- 以前のBufferedImage版との互換用. createBufferedImageが成功していればtrue
        img = nil,

        createBufferedImage = function (self, width, height)
            self.width = width
            self.height = height
            self.pixels = {}
            for i = 1, width * height do
                self.pixels[i] = 0
            end
            self.palette = {{0, 0, 0, 0}}
            self.paletteIndex = {}
            self.img = true
        end,

        -- @return number パレットのインデックス (r, g, b, a は0~255)
        getColorIndex = function (self, r, g, b, a)
            local key = ((a * 256 + r) * 256 + g) * 256 + b
            local idx = self.paletteIndex[key]
            if idx == nil then
                if #self.palette >= 256 then
                    return 0
                end
                self.palette[#self.palette + 1] = {r, g, b, a}
                idx = #self.palette - 1
                self.paletteIndex[key] = idx
            end
            return idx
        end,

        -- 左上原点
        setPixel = function (self, x, y, colorIndex)
            if x < 0 or x >= self.width or y < 0 or y >= self.height then
                return
            end
            self.pixels[y * self.width + x + 1] = colorIndex
        end,

        outputImage = function (self, fileName)
            local status, err = pcall(function ()
                local w, h = self.width, self.height
                local pixels = self.pixels

                -- 画像データ (各行の先頭にフィルタタイプ0)
                local raw = {}
                local n = 0
                local adlerA, adlerB = 1, 0
                for y = 0, h - 1 do
                    n = n + 1
                    raw[n] = 0
                    adlerB = adlerB + adlerA
                    local base = y * w
                    for x = 1, w do
                        local v = pixels[base + x]
                        n = n + 1
                        raw[n] = v
                        adlerA = adlerA + v
                        adlerB = adlerB + adlerA
                    end
                    adlerA = adlerA % 65521
                    adlerB = adlerB % 65521
                end
                local adler = bor(adlerB * 65536, adlerA)

                -- zlibストリーム (無圧縮ブロック)
                local rawString = bytesToString(raw, n)
                local zparts = {string.char(0x78, 0x01)}
                local MAX_BLOCK = 65535
                local pos = 1
                while pos <= n do
                    local len = math.min(MAX_BLOCK, n - pos + 1)
                    local final = (pos + len > n) and 1 or 0
                    local nlen = 0xFFFF - len
                    zparts[#zparts + 1] = string.char(final, band(len, 0xFF), rshift(len, 8), band(nlen, 0xFF), rshift(nlen, 8))
                    zparts[#zparts + 1] = string.sub(rawString, pos, pos + len - 1)
                    pos = pos + len
                end
                zparts[#zparts + 1] = uint32be(adler)
                local idat = table.concat(zparts)

                -- パレット
                local plte, trns = {}, {}
                for i, c in ipairs(self.palette) do
                    plte[#plte + 1] = string.char(c[1], c[2], c[3])
                    trns[i] = c[4]
                end

                local ihdr = uint32be(w) .. uint32be(h) .. string.char(8, 3, 0, 0, 0)
                local png = string.char(0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A)
                    .. chunk("IHDR", ihdr)
                    .. chunk("PLTE", table.concat(plte))
                    .. chunk("tRNS", bytesToString(trns, #trns))
                    .. chunk("IDAT", idat)
                    .. chunk("IEND", "")

                local f = compat.openFile(fileName, "wb")
                if f == nil then
                    error("ファイルを開けません")
                end
                f:write(png)
                f:close()
            end)
            if not status then
                print("画像の出力に失敗しました. fileName: " .. tostring(fileName) .. " " .. tostring(err))
            end
            return status
        end
    }
end

return image
