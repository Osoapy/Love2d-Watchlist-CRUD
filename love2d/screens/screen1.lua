local screen1 = {}

function screen1.load()
    love.window.setTitle("Tela 1")
end

function screen1.draw()
    love.graphics.clear(1, 0, 0)  -- Cor de fundo vermelha
    love.graphics.printf("Esta é a Tela 1", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end

return screen1
