local screen2 = {}

function screen2.load()
    love.window.setTitle("Tela 2")
end

function screen2.draw()
    love.graphics.clear(0, 1, 0)  -- Cor de fundo verde
    love.graphics.printf("Esta é a Tela 2", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end

return screen2
