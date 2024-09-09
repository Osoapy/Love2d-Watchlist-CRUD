local screen3 = {}

function screen3.load()
    love.window.setTitle("Tela 3")
end

function screen3.draw()
    love.graphics.clear(0, 0, 1)  -- Cor de fundo azul
    love.graphics.printf("Esta é a Tela 3", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end

return screen3
