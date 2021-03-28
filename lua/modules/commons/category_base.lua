function createInstance()
    local options = {
        property = {},
        filepath = {},
        offset = {},
        category = {},

        functions = {},
    }

    options.functions.init = function ()
        local props = {options.property, options.filepath, options.offset}
        local nameToProps = {}
        -- 整理
        local n = 1
        for _, ops in ipairs(props) do
            for _, op in ipairs(ops) do
                nameToProps[op.name] = op
            end
        end

        -- カテゴリー割当
        for _, cat in ipairs(options.category) do
            cat.item = {}
            for i, name in ipairs(cat.myItems) do
                cat.item[i] = n
                nameToProps[name].category = n
                n = n + 1
            end
        end
    end

    options.functions.getProperty = function ()
        return options.property
    end
    options.functions.getFilepath = function ()
        return options.filepath
    end
    options.functions.getOffset = function ()
        return options.offset
    end
    options.functions.getCategory = function ()
        return options.category
    end

    return options
end

return {
    createInstance = createInstance
}