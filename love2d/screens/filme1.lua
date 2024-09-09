-- Importing
require("classes.filme")
require("functions.dao")

-- Global variables
filmFile = "archives/filme.txt"
inputField = {active = nil, text = ""}  -- Para lidar com campos de entrada
inputs = {
    nome = "",
    dataLancamento = "",
    produtora = "",
    diretor = "",
    receita = "",
    orcamento = ""
}
fields = {"Nome", "Data de Lançamento", "Produtora", "Diretor", "Receita", "Orçamento"}
currentField = 1
completed = false

-- Funções LÖVE
function love.load()
    filme = nil
end

function love.draw()
    -- Exibir campos de texto e capturar entrada do usuário
    for i, field in ipairs(fields) do
        love.graphics.printf(field .. ": ", 50, 50 + (i * 30), 100, "left")
        love.graphics.rectangle("line", 200, 50 + (i * 30), 200, 25)
        
        -- Garantindo que `nil` vire uma string vazia
        local value = inputs[field:lower()] or ""

        if currentField == i then
            love.graphics.printf(inputField.text, 210, 55 + (i * 30), 180, "left")
        else
            love.graphics.printf(value, 210, 55 + (i * 30), 180, "left")
        end
    end

    -- Botão de confirmar
    love.graphics.printf("Pressione ENTER para confirmar a entrada", 50, 300, 400, "left")

    if completed then
        love.graphics.printf("Filme salvo!", 50, 350, 400, "left")
    end
end

function love.keypressed(key)
    -- Navegar entre os campos e finalizar a entrada
    if key == "return" then
        -- Salvar valor do campo atual
        inputs[fields[currentField]:lower()] = inputField.text
        inputField.text = ""

        currentField = currentField + 1

        -- Se todos os campos forem preenchidos
        if currentField > #fields then
            saveFilm()
            completed = true
            currentField = #fields  -- Para evitar passar do número de campos
        end
    elseif key == "backspace" then
        -- Apagar o último caractere
        inputField.text = inputField.text:sub(1, -2)
    end
end

function love.textinput(t)
    if currentField <= #fields then
        inputField.text = inputField.text .. t
    end
end

return filme1