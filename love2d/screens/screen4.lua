local screen4 = {}

function screen4.load()
    love.window.setTitle("Tela 4")
end

function screen4.draw()
    love.graphics.clear(1, 1, 0)  -- Cor de fundo amarela
    love.graphics.printf("Esta é a Tela 4", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end

return screen4
