-- Stringfy function
function stringfy(value, currentDepth, indentSize)
    skipNewlines = skipNewlines or false
    currentDepth = currentDepth or 0
    indentSize = indentSize or 0

    local result = ""
    local indentString = string.rep("  ", currentDepth)

    if type(value) == "table" then
        result = result .. "{"

        local isFirst = true
        for key, item in pairs(value) do
            if not isFirst then
                result = result .. ","
            end
            isFirst = false

            -- Serialize the key
            local keyString
            if type(key) == "number" then
                keyString = "[" .. key .. "]"
            else
                keyString = "[" .. string.format("%q", key) .. "]"
            end

            result = result .. indentString .. keyString .. " = "

            -- Serialize the value
            result = result .. stringfy(item, currentDepth + 1, indentSize)
        end

        result = result .. "}"
    elseif type(value) == "number" then
        result = result .. tostring(value)
    elseif type(value) == "string" then
        result = result .. string.format("%q", value)
    elseif type(value) == "boolean" then
        result = result .. (value and "true" or "false")
    else
        result = result .. "\"[unsupported datatype:" .. type(value) .. "]\""
    end

    return result
end

-- Parse string function
function parse(string)
    local func, err = load("return " .. string)
    if not func then
        error("Erro ao carregar tabela: " .. err)
    end
    local ok, result = pcall(func)
    if not ok then
        error("Erro ao executar função de desserialização: " .. result)
    end
    return result
end