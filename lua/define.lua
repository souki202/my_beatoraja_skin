BASE_WIDTH = 1920
BASE_HEIGHT = 1080
WIDTH = 1920
HEIGHT = 1080

NORMAL_TEXT_SIZE = 32
LARGE_TITLE_TEXT_SIZE = NORMAL_TEXT_SIZE * 2
NORMAL_DESCENDER_LINE = 3 -- フォントサイズ64

function getTableValue(tbl, key, defaultValue)
    for k, v in pairs(tbl) do
        if key == k then
            return v
        end
    end
    return defaultValue
end