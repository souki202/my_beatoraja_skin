local luajava = require("luajava")

local ImageIO = luajava.bindClass("javax.imageio.ImageIO")

local image = {}

image.newInstance = function ()
    return {
        img = nil,
        g = nil,

        createBufferedImage = function (self, width, height)
            local status, _ = pcall(function ()
                self.img = luajava.newInstance("java.awt.image.BufferedImage", width, height, 6) -- 6はTYPE_4BYTE_ABGR
                self.g = self.img:getGraphics()
            end)
            if not status then
                print("BufferedImageの作成に失敗しました.")
            end
        end,

        outputImage = function (self, fileName)
            local status, _ = pcall(function ()
                ImageIO:write(self.img, "png", luajava.newInstance("java.io.File", fileName))
            end)
            if not status then
                print("画像の出力に失敗しました. fileName: " .. fileName)
            end
        end
    }
end

return image