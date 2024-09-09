local menu = {}

function menu.load()
    -- Inicializa a tela principal
    love.window.setTitle("Tela Principal")
    menu.buttons = {
        {label = "Tela 1", x = 100, y = 100, w = 200, h = 50, screen = "screen1"},
        {label = "Tela 2", x = 100, y = 200, w = 200, h = 50, screen = "screen2"},
        {label = "Tela 3", x = 100, y = 300, w = 200, h = 50, screen = "screen3"},
        {label = "Tela 4", x = 100, y = 400, w = 200, h = 50, screen = "screen4"},
    }
end

function menu.draw()
    love.graphics.clear(0.5, 0.5, 0.5)
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