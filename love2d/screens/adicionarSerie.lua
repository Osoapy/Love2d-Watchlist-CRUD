local menu = {}

-- Configurações de layout
local scrollY = 0
local filmHeight = 30
local visibleFilmCount
local inputFields = {}
local currentField = nil
local allSeries = {}
local serieFile = "archives/serie.txt"
local background
local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

local divWidth, divHeight = screenWidth * 0.45, screenHeight * 0.5
local divX, divY1 = screenWidth * 0.05, screenHeight * 0.1
local messageDivX, messageDivY = screenWidth * 0.05, screenHeight * 0.65
local messageDivWidth, messageDivHeight = screenWidth * 0.3, screenHeight * 0.25
local secondDivHeight = screenHeight * 0.3
local spacing = screenHeight * 0.05
local divY2 = divY1 + divHeight + spacing

local isDraggingScrollbar = false
local scrollbarY = 0
local scrollbarHeight
local scrollbarWidth = 20
local totalHeight
local clickedIndex

local buttonSize = screenWidth * 0.05  -- O botão será 5% da largura da tela
local buttonBackX = divX  -- Manter alinhado com a esquerda da div1
local buttonBackY = divY1 - buttonSize - 10  -- Colocar o botão 10px acima da div1

-- Variável para armazenar o índice do filme selecionado
local selectedSerieIndex = nil

-- Campos editáveis
local fields = {
    {display = "Nome", key = "nome"},
    {display = "Data de Lançamento", key = "dataLancamento"},
    {display = "Produtora", key = "produtora"},
    {display = "Diretor", key = "diretor"},
    {display = "Temporadas", key = "temporadas"},
    {display = "Episodios", key = "episodios"},
    {display = "Status", key = "status"}
}

function menu.load(wasCalled)
    wasCalled = wasCalled or nil

    -- Carregar a imagem do background
    background = love.graphics.newImage("assets/background.png")
    assert(background, "Erro ao carregar a imagem do background!")

    -- Inicializa a tela principal
    love.window.setTitle("Séries")

    -- Carregar a imagem do botão
    buttonImage = love.graphics.newImage("assets/button_image.png")  -- Certifique-se de ter a imagem
    assert(background, "Erro ao carregar a imagem do botão!")

    -- Inicializar o botão com as dimensões da tela
    updateButtonDimensions()

    -- Inicializa os campos de texto
    for _, field in ipairs(fields) do
        inputFields[field.key] = ""
    end

    -- Recebe todos os filmes a serem listados
    allSeries = returnAllObjects(serieFile)
    visibleFilmCount = math.floor(love.graphics.getHeight() * 0.5 / filmHeight)

    -- Calcula a altura da barra de rolagem
    scrollbarHeight = math.max(visibleFilmCount / #allSeries * screenHeight * 0.5, 20)
    totalHeight = #allSeries * filmHeight

    if wasCalled then
        local selectedFilm = allSeries[wasCalled]
        selectedSerieIndex = wasCalled

        -- Preenche os campos de texto com os valores do filme selecionado
        for _, field in ipairs(fields) do
            inputFields[field.key] = selectedFilm[field.key] or ""
        end
    end
end

function updateButtonDimensions()
    -- Recalcular o tamanho e posição do botão conforme a tela
    buttonSize = screenWidth * 0.05  -- O botão será 5% da largura da tela
    buttonBackX = divX  -- Manter alinhado com a esquerda da div1
    buttonBackY = divY1 - buttonSize - 10  -- Colocar o botão 10px acima da div1
end

function menu.draw()
    -- Recalcular as dimensões da tela
    screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

    -- Recalcular as dimensões das divs
    divWidth, divHeight = screenWidth * 0.45, screenHeight * 0.5
    divX, divY1 = screenWidth * 0.05, screenHeight * 0.1
    messageDivX, messageDivY = screenWidth * 0.05, screenHeight * 0.65
    messageDivWidth, messageDivHeight = screenWidth * 0.3, screenHeight * 0.25
    secondDivHeight = screenHeight * 0.3
    spacing = screenHeight * 0.05
    divY2 = divY1 + divHeight + spacing

    -- Configurar cor e desenhar o background
    drawBackground(background)

    -- Atualizar as dimensões do botão
    updateButtonDimensions()

    -- Desenhar o botão responsivo
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", buttonBackX, buttonBackY, buttonSize, buttonSize)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(buttonImage, buttonBackX, buttonBackY, 0, buttonSize / buttonImage:getWidth(), buttonSize / buttonImage:getHeight())

    -- Desenhar o resto do layout
    drawFilmList(allSeries, scrollY, filmHeight, visibleFilmCount, scrollbarWidth, scrollbarHeight)
    drawMessage()
    drawAttributes(fields, inputFields)

    -- Botões
    drawButtons(selectedSerieIndex)
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

        -- Clique no botão de voltar ao menu
        if x >= buttonBackX and x <= buttonBackX + buttonSize and y >= buttonBackY and y <= buttonBackY + buttonSize then
            changeScreen("menu")
        end

        -- Clique num filme
        if not isDraggingScrollbar and x >= divX and x <= divX + divWidth and y >= divY1 and y <= divY1 + divHeight then
            clickedIndex = math.floor((y - divY1 + scrollY) / filmHeight) + 1

            -- Verifica se o índice está dentro da lista de filmes
            if clickedIndex >= 1 and clickedIndex <= #allSeries then
                selectedSerieIndex = clickedIndex
                local selectedFilm = allSeries[clickedIndex]

                -- Preenche os campos de texto com os valores do filme selecionado
                for _, field in ipairs(fields) do
                    inputFields[field.key] = selectedFilm[field.key] or ""
                end
            end
        end

        if not selectedSerieIndex then
            -- Clique no botão Salvar
            if x > deleteButtonX and x < deleteButtonX + buttonWidth and y > buttonY and y < buttonY + buttonHeight then
                local savingSerie = {}
                for _, field in ipairs(fields) do
                    savingSerie[field.key] = inputFields[field.key]
                end

                -- Agora você pode adicionar esse novo filme à lista de filmes ou salvar em arquivo
                table.insert(allSeries, savingSerie)
                local actualFilm = newSerie(savingSerie)

                -- Adiciona o filme ao arquivo
                addInFile(serieFile, actualFilm.getSerialized())

                -- Os campos continuam editáveis, então não limpar os campos após salvar
            end

            -- Clique no botão Limpar
            if x > saveButtonX and x < saveButtonX + buttonWidth and y > buttonY and y < buttonY + buttonHeight then
                for _, field in ipairs(fields) do
                    inputFields[field.key] = ""
                end
            end
        else
            -- Clique no botão Alterar
            if x > deleteButtonX and x < deleteButtonX + buttonWidth and y > buttonY and y < buttonY + buttonHeight then
                local savingSerie = {}

                for _, field in ipairs(fields) do
                    savingSerie[field.key] = inputFields[field.key]
                end

                alterFile(serieFile, savingSerie, allSeries[clickedIndex].nome, "serie")

                for _, field in ipairs(fields) do
                    inputFields[field.key] = ""
                end

                selectedSerieIndex = nil
            end

            -- Clique no botão Excluir
            if x > saveButtonX and x < saveButtonX + buttonWidth and y > buttonY and y < buttonY + buttonHeight then
                deleteInFile(serieFile, inputFields["nome"])

                for _, field in ipairs(fields) do
                    inputFields[field.key] = ""
                end

                selectedSerieIndex = nil
            end
        end

        -- Verifica se o clique foi na barra de rolagem
        local leftDivX, leftDivY = screenWidth * 0.05, screenHeight * 0.1
        local leftDivWidth, leftDivHeight = screenWidth * 0.3, screenHeight * 0.5
        local scrollbarX = leftDivX + leftDivWidth + 10

        if x >= scrollbarX and x <= scrollbarX + scrollbarWidth and y >= scrollbarY and y <= scrollbarY + scrollbarHeight then
            isDraggingScrollbar = true
        else
            isDraggingScrollbar = false
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
            if inputFields then
                if #inputFields[currentField] > 0 then
                    inputFields[currentField] = inputFields[currentField]:sub(1, -2)
                end
            end
        end
    end
end

-- Função de controle do movimento do scroll
function menu.mousemoved(x, y, dx, dy)
    local screenHeight = love.graphics.getHeight()
    local divHeight = screenHeight * 0.5
    if love.mouse.isDown(1) then
        -- Limitar o scroll entre 0 e a altura total menos a altura da div
        scrollY = math.max(0, math.min(scrollY - dy, totalHeight - divHeight))
    end
end
    
-- Função para detectar a rolagem do mouse
function menu.wheelmoved(x, y)
    local screenHeight = love.graphics.getHeight()
    local divHeight = screenHeight * 0.5
    -- Limitar o scroll para não ir além do último filme
    scrollY = math.max(0, math.min(scrollY - y * 20, totalHeight - divHeight))
end

return menu