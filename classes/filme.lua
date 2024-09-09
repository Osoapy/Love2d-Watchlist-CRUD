require("classes.backClass")
require("functions.stringFunctions")

function newFilm(object)
    -- Constructor
    local self = {
        type = "filme",

        -- Adding object parameters
        orcamento = object.orcamento or "0",
        receita = object.receita or "0"
    }

    -- Using object
    object = object or {}

    -- Setters
    local setOrcamento = function(orcamento)
        self.orcamento = orcamento
    end

    local setReceita = function(receita)
        self.receita = receita
    end

    -- Getters
    local getOrcamento = function()
        return self.orcamento
    end

    local getReceita = function()
        return self.receita
    end

    local getType = function()
        return self.type
    end

    -- Defining what I'll export
    local returnObject = newBackClass(object)
    
    -- Setters
    returnObject.setOrcamento = setOrcamento
    returnObject.setReceita = setReceita

    -- Getters
    returnObject.getReceita = getReceita
    returnObject.getOrcamento = getOrcamento
    returnObject.getType = getType

    -- Functions
    returnObject.getSerialized = function()
        local serializedTable = returnObject.getBackClassSerialized()
        serializedTable.receita = self.receita
        serializedTable.orcamento = self.orcamento

        return stringfy(serializedTable)
    end

    return returnObject
end

return newFilm