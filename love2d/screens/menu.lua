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
    menu.buttons = {
        {label = "Tela 1", x = 100, y = 100, w = 200, h = 50, screen = "screen1"},
        {label = "Tela 2", x = 100, y = 200, w = 200, h = 50, screen = "screen2"},
        {label = "Tela 3", x = 100, y = 300, w = 200, h = 50, screen = "screen3"},
        {label = "Tela 4", x = 100, y = 400, w = 200, h = 50, screen = "screen4"},
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

    -- Desenhar os botões
    for _, button in ipairs(menu.buttons) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(button.label, button.x, button.y + 15, button.w, "center")
    end
end

function menu.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for _, btn in ipairs(menu.buttons) do
            if x >= btn.x and x <= btn.x + btn.w and y >= btn.y and y <= btn.y + btn.h then
                changeScreen(btn.screen)
            end
        end
    end
end

return menu