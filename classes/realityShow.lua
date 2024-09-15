require("classes.backClass")
require("functions.stringFunctions")

function newRealityShow(object)
    -- Constructor
    local self = {
        type = "realityShow",

        -- Adding object parameters
        idioma = object.idioma or "0",
        formato = object.formato or "0",
        status = object.status or "0",
        apresentador = object.apresentador or "0"
    }

    -- Using object
    object = object or {}

    -- Setters
    local setFormato = function(formato)
        self.formato = formato
    end

    local setIdioma = function(idioma)
        self.idioma = idioma
    end

    local setStatus = function(status)
        self.status = status
    end

    local setApresentador = function(apresentador)
        self.apresentador = apresentador
    end

    -- Getters
    local getFormato = function()
        return self.formato
    end

    local getIdioma = function()
        return self.idioma
    end

    local getStatus = function()
        return self.status
    end

    local getApresentador = function()
        return self.apresentador
    end

    local getType = function()
        return self.type
    end

    -- Defining what I'll export
    local returnObject = newBackClass(object)
    
    -- Setters
    returnObject.setFormato = setFormato
    returnObject.setIdioma = setIdioma
    returnObject.setStatus = setStatus
    returnObject.setApresentador = setApresentador

    -- Getters
    returnObject.getIdioma = getIdioma
    returnObject.getFormato = getFormato
    returnObject.getStatus = getStatus
    returnObject.getApresentador = getApresentador
    returnObject.getType = getType

    -- Functions
    returnObject.getSerialized = function()
        local serializedTable = returnObject.getBackClassSerialized()
        serializedTable.idioma = self.idioma
        serializedTable.formato = self.formato
        serializedTable.status = self.status

        return stringfy(serializedTable)
    end

    return returnObject
end

return newRealityShow