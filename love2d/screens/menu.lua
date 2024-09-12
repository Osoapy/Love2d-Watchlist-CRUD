local menu = {}

function menu.load()
    -- Carregar a imagem do background
    background = love.graphics.newImage("assets/background.png")
    -- Verificar se a imagem foi carregada corretamente
    if not background then
        error("Erro ao carregar a imagem do background!")
    end

    -- Inicializa a tela principal
    love.window.setTitle("Menu")

    -- Inicializa os botões (sem posição fixa ainda)
    menu.buttons = {
        {label = "Filme", screen = "screen1"},
        {label = "Série", screen = "screen2"},
        {label = "Reality show", screen = "screen3"}
    }
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

    -- Definir a área da "div" no lado direito da tela
    local divWidth = screenWidth * 0.35  -- 20% da largura da tela
    local divHeight = screenHeight * 0.8 -- 80% da altura da tela (com top/bottom de 10%)
    local divX = screenWidth - divWidth - screenWidth * 0.05  -- 20px de margem da direita
    local divY = screenHeight * 0.1  -- 10% do topo

    -- Desenhar a "div" semitransparente atrás dos botões
    love.graphics.setColor(1, 0.9, 0.76, 0.21)  -- Definir a cor como preta com 50% de transparência
    love.graphics.rectangle("fill", divX, divY, divWidth, divHeight)

    -- Desenhar o título "CRIAR / EDITAR" no topo da "div"
    love.graphics.setColor(1, 1, 1)  -- Branco para o texto
    love.graphics.setFont(love.graphics.newFont(24))  -- Definir o tamanho da fonte
    love.graphics.printf("CRIAR / EDITAR", divX, divY + 10, divWidth, "center")

    -- Definir o tamanho dos botões proporcional ao tamanho da "div"
    local buttonWidth = divWidth * 0.8  -- 80% da largura da div
    local buttonHeight = divHeight * 0.15  -- 15% da altura da div (4 botões com espaçamento)

    -- Desenhar os botões dentro da div
    for i, button in ipairs(menu.buttons) do
        local buttonX = divX + (divWidth - buttonWidth) / 2  -- Centralizado horizontalmente
        local buttonY = divY + 50 + (i - 1) * (buttonHeight + 20) -- Espaçamento de 20px entre botões e o título

        -- Desenhar o botão
        love.graphics.setColor(1, 1, 1, 0)
        love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(button.label, buttonX, buttonY + (buttonHeight / 3), buttonWidth, "center")
    end
end

function menu.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        -- Obter as dimensões da tela para calcular a área de clique dinamicamente
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()

        local divWidth = screenWidth * 0.2
        local divHeight = screenHeight * 0.8
        local divX = screenWidth - divWidth - 20
        local divY = screenHeight * 0.1

        local buttonWidth = divWidth * 0.8
        local buttonHeight = divHeight * 0.15

        -- Verificar se o clique foi em algum botão
        for i, btn in ipairs(menu.buttons) do
            local buttonX = divX + (divWidth - buttonWidth) / 2
            local buttonY = divY + 50 + (i - 1) * (buttonHeight + 20)

            if x >= buttonX and x <= buttonX + buttonWidth and y >= buttonY and y <= buttonY + buttonHeight then
                print(btn.label .. " clicado!")
                -- Lógica para trocar de tela (caso aplicável)
                changeScreen(btn.screen)
            end
        end
    end
end

return menu