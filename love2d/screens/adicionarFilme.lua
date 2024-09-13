local menu = {}

-- Variáveis de controle de rolagem
local scrollY = 0
local filmHeight = 30
local visibleFilmCount

-- Campos de texto editáveis
local fields = {
    {display = "Nome", key = "nome"},
    {display = "Data de Lançamento", key = "dataLancamento"},
    {display = "Produtora", key = "produtora"},
    {display = "Diretor", key = "diretor"},
    {display = "Receita", key = "receita"},
    {display = "Orçamento", key = "orcamento"}
}

local inputFields = {}  -- Para armazenar os textos dos campos
local currentField = nil

function menu.load()
    -- Carregar a imagem do background
    background = love.graphics.newImage("assets/background.png")
    assert(background, "Erro ao carregar a imagem do background!")

    -- Inicializa a tela principal
    love.window.setTitle("Menu")

    -- Inicializa os campos de texto
    for _, field in ipairs(fields) do
        inputFields[field.key] = ""
    end

    -- Recebe todos os filmes a serem listados
    filmFile = "archives/filme.txt"
    allFilms = returnAllObjects(filmFile)
    visibleFilmCount = math.floor(love.graphics.getHeight() * 0.5 / filmHeight)
end

function menu.draw()
    -- Configurar cor e desenhar o background
    love.graphics.setColor(1, 1, 1)
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.draw(background, 0, 0, 0, screenWidth / background:getWidth(), screenHeight / background:getHeight())

    -- Div para a lista de filmes
    local leftDivWidth = screenWidth * 0.3
    local leftDivHeight = screenHeight * 0.5
    local leftDivX, leftDivY1 = screenWidth * 0.05, screenHeight * 0.1
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", leftDivX, leftDivY1, leftDivWidth, leftDivHeight)

    -- Ativar recorte para a área da div de filmes
    love.graphics.setScissor(leftDivX, leftDivY1, leftDivWidth, leftDivHeight)

    -- Desenhar a lista de filmes com rolagem
    love.graphics.setColor(0, 0, 0)
    local filmStartIndex = math.floor(scrollY / filmHeight) + 1
    local filmEndIndex = math.min(filmStartIndex + visibleFilmCount - 1, #allFilms)
    for i = filmStartIndex, filmEndIndex do
        local film = allFilms[i]
        love.graphics.printf(film.nome, leftDivX + 10, leftDivY1 + (i - filmStartIndex) * filmHeight - scrollY, leftDivWidth - 20, "left")
    end

    -- Desativar recorte
    love.graphics.setScissor()

    -- Div para a mensagem
    local messageDivWidth = screenWidth * 0.3
    local messageDivHeight = screenHeight * 0.4
    local messageDivX, messageDivY = leftDivX, leftDivY1 + leftDivHeight + screenHeight * 0.05
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", messageDivX, messageDivY, messageDivWidth, messageDivHeight)

    -- Exibir título da mensagem
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.printf("YOU ARE WHAT YOU ARE WATCHING", messageDivX, messageDivY + 10, messageDivWidth, "center")

    -- Div para os atributos
    local attributesDivWidth = screenWidth * 0.35
    local attributesDivHeight = screenHeight * 0.8
    local attributesDivX = screenWidth - attributesDivWidth - screenWidth * 0.05
    local attributesDivY = screenHeight * 0.1
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", attributesDivX, attributesDivY, attributesDivWidth, attributesDivHeight)

    -- Desenhar os campos de texto na div de atributos
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(20))
    for i, field in ipairs(fields) do
        love.graphics.printf(field.display .. ": ", attributesDivX + 10, attributesDivY + 30 + (i - 1) * 40, attributesDivWidth - 20, "left")
        love.graphics.rectangle("line", attributesDivX + 120, attributesDivY + 30 + (i - 1) * 40, attributesDivWidth - 130, 30)
        local value = inputFields[field.key] or ""
        love.graphics.printf(value, attributesDivX + 125, attributesDivY + 35 + (i - 1) * 40, attributesDivWidth - 140, "left")
    end
end

function menu.keypressed(key)
    if currentField then
        if key == "return" then
            -- Finalizar edição do campo atual
            currentField = nil
        elseif key == "backspace" then
            -- Apagar o último caractere
            if #inputFields[currentField] > 0 then
                inputFields[currentField] = inputFields[currentField]:sub(1, -2)
            end
        end
    end
end

function menu.textinput(t)
    if currentField then
        inputFields[currentField] = inputFields[currentField] .. t
    end
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        local attributesDivWidth = love.graphics.getWidth() * 0.35
        local attributesDivX = love.graphics.getWidth() - attributesDivWidth - love.graphics.getWidth() * 0.05
        local attributesDivY = love.graphics.getHeight() * 0.1

        -- Verificar se o clique foi em algum campo de texto da div de atributos
        for i, field in ipairs(fields) do
            local fieldX = attributesDivX + 120
            local fieldY = attributesDivY + 30 + (i - 1) * 40
            local fieldWidth = attributesDivWidth - 130
            local fieldHeight = 30
            if x > fieldX and x < fieldX + fieldWidth and y > fieldY and y < fieldY + fieldHeight then
                currentField = field.key
                break
            end
        end

        -- Caso o clique não tenha sido em nenhum campo, finalizar a edição
        if not currentField then
            currentField = nil
        end
    end
end

return menu
