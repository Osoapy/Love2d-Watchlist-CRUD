local menu = {}

-- Configurações de layout
local scrollY = 0
local filmHeight = 30
local visibleFilmCount
local inputFields = {}
local currentField = nil
local allFilms = {}
local filmFile = "archives/filme.txt"
local background
local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

-- Campos editáveis
local fields = {
    {display = "Nome", key = "nome"},
    {display = "Data de Lançamento", key = "dataLancamento"},
    {display = "Produtora", key = "produtora"},
    {display = "Diretor", key = "diretor"},
    {display = "Receita", key = "receita"},
    {display = "Orçamento", key = "orcamento"}
}

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
    allFilms = returnAllObjects(filmFile)
    visibleFilmCount = math.floor(love.graphics.getHeight() * 0.5 / filmHeight)
end

function menu.draw()
    -- Configurar cor e desenhar o background
    drawBackground(background)

    -- Desenhar o resto do layout
    drawFilmList(allFilms, scrollY, filmHeight, visibleFilmCount, screenWidth, screenHeight)
    drawMessage(screenWidth, screenHeight)
    drawAttributes(fields, inputFields, screenWidth, screenHeight)

    -- Botões
    drawButtons(screenWidth, screenHeight)
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        -- Verificar se o clique foi nos botões de salvar ou excluir
        local screenWidth = love.graphics.getWidth()
        local attributesDivWidth = screenWidth * 0.35
        local attributesDivHeight = love.graphics.getHeight() * 0.8
        local attributesDivX = screenWidth - attributesDivWidth - screenWidth * 0.05
        local attributesDivY = love.graphics.getHeight() * 0.1

        local buttonWidth = attributesDivWidth * 0.4
        local buttonHeight = 40
        local buttonY = attributesDivY + attributesDivHeight - buttonHeight - 20
        local saveButtonX = attributesDivX + 10
        local deleteButtonX = attributesDivX + attributesDivWidth - buttonWidth - 10

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

        -- Clique no botão Salvar
        if x > saveButtonX and x < saveButtonX + buttonWidth and y > buttonY and y < buttonY + buttonHeight then
            filmFile = "archives/filme.txt"
            local savingFilm = {}
            for _, field in ipairs(fields) do
                savingFilm[field.key] = inputFields[field.key]
            end

            -- Agora você pode adicionar esse novo filme à lista de filmes ou salvar em arquivo
            table.insert(allFilms, savingFilm)
            local actualFilm = newFilm(savingFilm)

            -- Adiciona o filme ao arquivo
            addInFile(filmFile, actualFilm.getSerialized())

            -- Os campos continuam editáveis, então não limpar os campos após salvar
        end

        -- Clique no botão Excluir
        if x > deleteButtonX and x < deleteButtonX + buttonWidth and y > buttonY and y < buttonY + buttonHeight then
            print("Excluir clicado!")
            -- Ação de excluir
        end

        -- Verificar se o clique foi na área de rolagem
        local divX = screenWidth * 0.05
        local divY1 = screenHeight * 0.1
        local divHeight = screenHeight * 0.5
        if x >= divX and x <= divX + screenWidth * 0.45 and y >= divY1 and y <= divY1 + divHeight then
            local clickY = y - divY1
            scrollY = clickY - (divHeight / 2) + (filmHeight / 2)
            scrollY = math.max(0, math.min(scrollY, #allFilms * filmHeight - divHeight))
        end
    end
end

function menu.textinput(t)
    if currentField then
        inputFields[currentField] = inputFields[currentField] .. t
    end
end

function menu.keypressed(key)
    if currentField then
        if key == "backspace" then  -- Verifica se a tecla pressionada é backspace
            -- Apenas remove o último caractere se houver algum texto
            if #inputFields[currentField] > 0 then
                inputFields[currentField] = inputFields[currentField]:sub(1, -2)
            end
        end
    end
end

function menu.mousemoved(x, y, dx, dy)
    local screenHeight = love.graphics.getHeight()
    local divHeight = screenHeight * 0.5
    if love.mouse.isDown(1) then
        scrollY = math.max(0, math.min(scrollY - dy, #allFilms * filmHeight - divHeight))
    end
end

return menu