require("classes.backClass")
require("functions.stringFunctions")

function newSerie(object)
    -- Constructor
    local self = {
        type = "serie",

        -- Adding object parameters
        temporadas = object.temporadas or "0",
        episodios = object.episodios or "0",
        status = object.status or "0"
    }

    -- Using object
    object = object or {}

    -- Setters
    local setEpisodios = function(episodios)
        self.episodios = episodios
    end

    local setTemporadas = function(temporadas)
        self.temporadas = temporadas
    end

    local setStatus = function(status)
        self.status = status
    end

    -- Getters
    local getEpisodios = function()
        return self.episodios
    end

    local getTemporadas = function()
        return self.temporadas
    end

    local getStatus = function()
        return self.status
    end

    local getType = function()
        return self.type
    end

    -- Defining what I'll export
    local returnObject = newBackClass(object)
    
    -- Setters
    returnObject.setEpisodios = setEpisodios
    returnObject.setTemporadas = setTemporadas
    returnObject.setStatus = setStatus

    -- Getters
    returnObject.getTemporadas = getTemporadas
    returnObject.getEpisodios = getEpisodios
    returnObject.getStatus = getStatus
    returnObject.getType = getType

    -- Functions
    returnObject.getSerialized = function()
        local serializedTable = returnObject.getBackClassSerialized()
        serializedTable.temporadas = self.temporadas
        serializedTable.episodios = self.episodios
        serializedTable.status = self.status

        return stringfy(serializedTable)
    end

    return returnObject
end

return newSerie