function drawFilmList(films, scrollY, filmHeight, scrollbarWidth)
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    local divWidth = screenWidth * 0.45
    local leftDivX, leftDivY = screenWidth * 0.05, screenHeight * 0.1
    local leftDivHeight = screenHeight * 0.5

    -- Recalcular o número de filmes visíveis com base na altura da tela
    local visibleFilmCount = math.floor(leftDivHeight / filmHeight)

    -- Desenha a área da lista de filmes
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", leftDivX, leftDivY, divWidth, leftDivHeight)
    
    -- Definir a área de clipping (ajusta conforme a tela aumenta)
    love.graphics.setScissor(leftDivX, leftDivY, divWidth, leftDivHeight)

    -- Ajustar o início e fim da lista com base no scroll
    local filmStartIndex = math.floor(scrollY / filmHeight) + 1
    local filmEndIndex = math.min(filmStartIndex + visibleFilmCount - 1, #films)

    for i = filmStartIndex, filmEndIndex do
        local film = films[i]
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(film.nome, leftDivX + 10, leftDivY + (i - filmStartIndex) * filmHeight - (scrollY % filmHeight), divWidth - 30, "left")
    end

    -- Remover o scissor após desenhar
    love.graphics.setScissor()

    -- Recalcular e desenhar a barra de rolagem
    local scrollbarHeight = math.max((leftDivHeight / (#films * filmHeight)) * leftDivHeight, 20)
    local scrollbarX = leftDivX + divWidth + 10
    local scrollbarY = leftDivY + (scrollY / (#films * filmHeight)) * leftDivHeight

    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.rectangle("fill", scrollbarX, scrollbarY, scrollbarWidth, scrollbarHeight)
end