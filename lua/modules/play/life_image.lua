local image = require("modules.commons.image")

local LIFE_IMAGE = {

}

local life = {
    image = nil,
    functions = {}
}

life.functions.load = function ()
    life.image = image:newInstance()
end