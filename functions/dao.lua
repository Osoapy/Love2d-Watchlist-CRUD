-- Importing
require("classes.filme")
require("functions.stringFunctions")

-- DAO Functions
function printFile(filename)
    local file = io.open(filename, "r")
    if not file then
        print("Erro ao abrir o arquivo.")
        return
    end

    for line in file:lines() do
        print(line)
    end

    file:close()
end

function addInFile(filename, string)
    local file = io.open(filename, "r")
    if not file then
        print("Erro ao abrir o arquivo.")
        return
    end

    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()
    
    table.insert(lines, string)

    file = io.open(filename, "w")
    for i, line in ipairs(lines) do
        file:write(line .. "\n")
    end
    file:close()
end


function alterFile(filename, obj, nome, type)
    -- Getting the newLine
    local newLine
    if type == "filme" then
        newLine = newFilm(obj)
    elseif type == "serie" then
        newLine = newSerie(obj)
    elseif type == "realityShow" then
        newLine = newRealityShow(obj)
    end

    local file = io.open(filename, "r")
    if not file then
        print("Erro ao abrir o arquivo.")
        return
    end

    local lines = {}
    for line in file:lines() do
        local deserializedTable = parse(line)

        print(deserializedTable)
        print(newLine)

        if deserializedTable and deserializedTable["nome"] == nome then 
            -- Substitui a linha correspondente
            table.insert(lines, newLine.getSerialized())
        else
            -- Mantém a linha atual
            table.insert(lines, line)
        end
    end
    file:close()

    -- Reescreve o arquivo com as mudanças
    file = io.open(filename, "w")
    for _, line in ipairs(lines) do
        file:write(line .. "\n")
    end
    file:close()
end
