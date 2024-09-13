local menu = {}

-- Variáveis de controle de rolagem
local scrollY = 0
local scrollSpeed = 10
local divHeight
local filmHeight = 30 -- Altura de cada item de filme na lista
local visibleFilmCount -- Número de filmes visíveis na div

function menu.load()
    -- Carregar a imagem do background
    background = love.graphics.newImage("assets/background.png")
    if not background then
        error("Erro ao carregar a imagem do background!")
    end

    -- Obter as dimensões da tela
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Inicializa a tela principal
    love.window.setTitle("Menu")

    -- Inicializa os botões (sem posição fixa ainda)
    menu.buttons = {
        {label = "Filme", screen = "screen1"},
        {label = "Série", screen = "screen2"},
        {label = "Reality show", screen = "screen3"}
    }

    -- Recebe todos os filmes a serem listados
    filmFile = "archives/filme.txt"
    allFilms = returnAllObjects(filmFile)
    visibleFilmCount = #allFilms
    -- é um objeto com uma propriedade nome
end

function menu.draw()
    -- Resetar a cor para branco antes de desenhar o background
    love.graphics.setColor(1, 1, 1)

    -- Obter as dimensões da tela e do background
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local bgWidth = background:getWidth()
    local bgHeight = background:getHeight()

    -- Calcular os fatores de escala para ajustar o background ao tamanho da tela
    local scaleX = screenWidth / bgWidth
    local scaleY = screenHeight / bgHeight

    -- Desenhar o background ajustado
    love.graphics.draw(background, 0, 0, 0, scaleX, scaleY)

    -- Definir as áreas das "divs" no lado esquerdo da tela
    local divWidth = screenWidth * 0.45  -- 45% da largura da tela
    local divHeight = screenHeight * 0.5 -- 50% da altura da tela
    local secondDivHeight = screenHeight * 0.3 -- 30% da altura da tela
    local spacing = screenHeight * 0.05  -- Espaçamento entre as divs (5% da altura da tela)
    local divX = screenWidth * 0.05  -- 5% de margem da esquerda

    -- Primeira div (superior)
    local divY1 = screenHeight * 0.1  -- 10% do topo
    love.graphics.setColor(1, 0.9, 0.76, 0.21)  -- Cor com transparência
    love.graphics.rectangle("fill", divX, divY1, divWidth, divHeight)

    -- Ativar recorte para a área da div de filmes
    love.graphics.setScissor(divX, divY1, divWidth, divHeight)

    -- Desenhar a lista de filmes com rolagem
    love.graphics.setColor(0, 0, 0)  -- Preto para o texto
    local filmStartIndex = math.floor(scrollY / filmHeight) + 1
    local filmEndIndex = math.min(filmStartIndex + visibleFilmCount - 1, #allFilms)

    for i = filmStartIndex, filmEndIndex do
        local film = allFilms[i]
        love.graphics.printf(film.nome, divX + 10, divY1 + (i - filmStartIndex) * filmHeight - scrollY, divWidth - 20, "left")
    end

    -- Desativar recorte
    love.graphics.setScissor()

    -- Segunda div (inferior)
    local divY2 = divY1 + divHeight + spacing  -- Logo abaixo da primeira
    love.graphics.setColor(1, 0.9, 0.76, 0.21)  -- Cor com transparência 
    love.graphics.rectangle("fill", divX, divY2, divWidth, secondDivHeight)

    -- Texto dentro da segunda div (inferior)
    love.graphics.setColor(1, 1, 1)  -- Branco
    love.graphics.setFont(love.graphics.newFont(30))  -- Define um tamanho de fonte maior
    love.graphics.printf("YOU ARE WHAT YOU ARE WATCHING", divX, divY2 + secondDivHeight / 2 - 15, divWidth, "center")

    -- Definir o tamanho dos botões proporcional ao tamanho da "div"
    local rightDivWidth = screenWidth * 0.35  -- 35% da largura da tela
    local rightDivHeight = screenHeight * 0.8 -- 80% da altura da tela
    local rightDivX = screenWidth - rightDivWidth - screenWidth * 0.05  -- Margem da direita
    local rightDivY = screenHeight * 0.1  -- 10% do topo

    -- Desenhar a "div" direita semitransparente atrás dos botões
    love.graphics.setColor(1, 0.9, 0.76, 0.21)  -- Cor com transparência
    love.graphics.rectangle("fill", rightDivX, rightDivY, rightDivWidth, rightDivHeight)

    -- Desenhar o título "CRIAR / EDITAR" no topo da "div" direita
    love.graphics.setColor(1, 1, 1)  -- Branco para o texto
    love.graphics.printf("CRIAR / EDITAR", rightDivX, rightDivY + 10, rightDivWidth, "center")

    -- Definir o tamanho dos botões proporcional ao tamanho da "div"
    local buttonWidth = rightDivWidth * 0.8
    local buttonHeight = rightDivHeight * 0.15

    -- Desenhar os botões dentro da div direita
    for i, button in ipairs(menu.buttons) do
        local buttonX = rightDivX + (rightDivWidth - buttonWidth) / 2
        local buttonY = rightDivY + 50 + (i - 1) * (buttonHeight + 20)

        -- Desenhar o botão
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(button.label, buttonX, buttonY + (buttonHeight / 3), buttonWidth, "center")
    end
end

function menu.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()

        local rightDivWidth = screenWidth * 0.35
        local rightDivHeight = screenHeight * 0.8
        local rightDivX = screenWidth - rightDivWidth - screenWidth * 0.05
        local rightDivY = screenHeight * 0.1

        local buttonWidth = rightDivWidth * 0.8
        local buttonHeight = rightDivHeight * 0.15

        -- Definir as áreas das "divs" no lado esquerdo da tela
        local leftWidth = screenWidth * 0.45  -- 45% da largura da tela
        local leftDivHeight = screenHeight * 0.5 -- 50% da altura da tela
        local leftDivX = screenWidth * 0.05  -- 5% de margem da esquerda
        local divY1 = screenHeight * 0.1  -- 10% do topo

        -- Verificar se o clique foi em algum botão
        for i, btn in ipairs(menu.buttons) do
            local buttonX = rightDivX + (rightDivWidth - buttonWidth) / 2
            local buttonY = rightDivY + 50 + (i - 1) * (buttonHeight + 20)

            if x >= buttonX and x <= buttonX + buttonWidth and y >= buttonY and y <= buttonY + buttonHeight then
                print(btn.label .. " clicado!")
                -- Lógica para trocar de tela (caso aplicável)
                changeScreen(btn.screen)
            end
        end

        -- Verificar se o clique foi em uma área de rolagem (opcional)
        if x >= leftDivX and x <= leftDivX + leftWidth and y >= divY1 and y <= divY1 + leftDivHeight then
            -- Calcular a posição do clique dentro da área de rolagem
            local clickY = y - divY1
            -- Ajustar a rolagem para que o item clicado fique visível no topo da div
            scrollY = clickY - (leftDivHeight / 2) + (filmHeight / 2)
            -- Garantir que a rolagem esteja dentro dos limites
            scrollY = math.max(0, math.min(scrollY, #allFilms * filmHeight - leftDivHeight))
        end
    end
end

function menu.mousemoved(x, y, dx, dy, istouch)
    -- Atualizar a rolagem com base no movimento do mouse
    local screenHeight = love.graphics.getHeight()
    local leftDivHeight = screenHeight * 0.5 -- 50% da altura da tela
    if love.mouse.isDown(1) then
        scrollY = math.max(0, math.min(scrollY - dy, #allFilms * filmHeight - leftDivHeight))
    end
end

return menu
