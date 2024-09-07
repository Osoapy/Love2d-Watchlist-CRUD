function newBackClass(object)
    -- Constructor
    local self = {
        nome = nome or "",
        diretor = diretor or "",
        dataLancamento = dataLancamento or "",
        produtora = produtora or ""
    }

    -- Using object
    object = object or {}

    -- Adding object parameters
    if object.nome then 
        self.nome = object.nome
    end
    if object.diretor then
        self.diretor = object.diretor
    end
    if object.dataLancamento then
        self.dataLancamento = object.dataLancamento
    end
    if object.produtora then
        self.produtora = object.produtora
    end

    -- Setters
    local setNome = function(nome)
        self.nome = nome
    end

    local setDiretor = function(diretor)
        self.diretor = diretor
    end

    local setDataLancamento = function(dataLancamento)
        self.dataLancamento = dataLancamento
    end

    local setProdutora = function(produtora)
        self.produtora = produtora
    end

    -- Getters
    local getNome = function()
        return self.nome
    end

    local getDiretor = function()
        return self.diretor
    end

    local getDataLancamento = function()
        return self.dataLancamento
    end

    local getProdutora = function()
        return self.produtora
    end

    -- Functions
    local getBackClassSerialized = function()
        o =  {
            dataLancamento = self.dataLancamento,
            nome = self.nome,
            diretor = self.diretor,
            produtora = self.produtora
        }
        return o
    end

    local ping = function () print("ping") end

    return {
        -- Setters
        setNome = setNome,
        setDiretor = setDiretor,
        setDataLancamento = setDataLancamento,
        setProdutora = setProdutora,

        -- Getters
        getNome = getNome,
        getDiretor = getDiretor,
        getDataLancamento = getDataLancamento,
        getProdutora = getProdutora,

        -- Functions
        getBackClassSerialized = getBackClassSerialized,
        ping = ping
    }
end

return newBackClass