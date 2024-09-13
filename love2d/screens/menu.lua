local menu = {}

-- Variáveis de controle de rolagem
local scrollY = 0
local filmHeight = 30
local visibleFilmCount

function menu.load()
    -- Carregar a imagem do background
    background = love.graphics.newImage("assets/background.png")
    assert(background, "Erro ao carregar a imagem do background!")

    -- Inicializa a tela principal
    love.window.setTitle("Menu")

    -- Inicializa os botões
    menu.buttons = {
        {label = "Filme", screen = "screen1"},
        {label = "Série", screen = "screen2"},
        {label = "Reality show", screen = "screen3"}
    }

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

    -- Definir e desenhar a primeira div
    local divWidth, divHeight = screenWidth * 0.45, screenHeight * 0.5
    local divX, divY1 = screenWidth * 0.05, screenHeight * 0.1
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", divX, divY1, divWidth, divHeight)

    -- Ativar recorte para a área da div de filmes
    love.graphics.setScissor(divX, divY1, divWidth, divHeight)

    -- Desenhar a lista de filmes com rolagem
    love.graphics.setColor(0, 0, 0)
    local filmStartIndex = math.floor(scrollY / filmHeight) + 1
    local filmEndIndex = math.min(filmStartIndex + visibleFilmCount - 1, #allFilms)
    for i = filmStartIndex, filmEndIndex do
        local film = allFilms[i]
        love.graphics.printf(film.nome, divX + 10, divY1 + (i - filmStartIndex) * filmHeight - scrollY, divWidth - 20, "left")
    end

    -- Desativar recorte
    love.graphics.setScissor()

    -- Segunda div
    local secondDivHeight = screenHeight * 0.3
    local spacing = screenHeight * 0.05
    local divY2 = divY1 + divHeight + spacing
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", divX, divY2, divWidth, secondDivHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.printf("YOU ARE WHAT YOU ARE WATCHING", divX, divY2 + secondDivHeight / 2 - 15, divWidth, "center")

    -- Div direita
    local rightDivWidth = screenWidth * 0.35
    local rightDivHeight = screenHeight * 0.8
    local rightDivX, rightDivY = screenWidth - rightDivWidth - screenWidth * 0.05, screenHeight * 0.1
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", rightDivX, rightDivY, rightDivWidth, rightDivHeight)

    -- Botões
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("CRIAR / EDITAR", rightDivX, rightDivY + 10, rightDivWidth, "center")
    local buttonWidth, buttonHeight = rightDivWidth * 0.8, rightDivHeight * 0.15
    for i, button in ipairs(menu.buttons) do
        local buttonX, buttonY = rightDivX + (rightDivWidth - buttonWidth) / 2, rightDivY + 50 + (i - 1) * (buttonHeight + 20)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(button.label, buttonX, buttonY + (buttonHeight / 3), buttonWidth, "center")
    end
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
        local rightDivWidth = screenWidth * 0.35
        local rightDivHeight = screenHeight * 0.8
        local rightDivX = screenWidth - rightDivWidth - screenWidth * 0.05
        local rightDivY = screenHeight * 0.1

        -- Verificar se o clique foi em algum botão
        for i, btn in ipairs(menu.buttons) do
            local buttonX = rightDivX + (rightDivWidth - rightDivWidth * 0.8) / 2
            local buttonY = rightDivY + 50 + (i - 1) * (rightDivHeight * 0.15 + 20)
            if x >= buttonX and x <= buttonX + rightDivWidth * 0.8 and y >= buttonY and y <= buttonY + rightDivHeight * 0.15 then
                changeScreen(btn.screen)
            end
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

function menu.mousemoved(x, y, dx, dy)
    local screenHeight = love.graphics.getHeight()
    local divHeight = screenHeight * 0.5
    if love.mouse.isDown(1) then
        scrollY = math.max(0, math.min(scrollY - dy, #allFilms * filmHeight - divHeight))
    end
end

return menu