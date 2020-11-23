require("modules.commons.define")
local commons = require("modules.play.commons")
local scores = require("modules.play.score")
local lanes = require("modules.play.lanes")
local main_state = require("main_state")

local DIFFICULTIES = {
    VERY_EASY = 1,
    EASY = 2,
    NORMAL = 3,
    HARD = 4,
    VERY_HARD = 5,
}

local virtualJudge = {
    difficulty = DIFFICULTIES.EASY,
    
    functions = {}
}

