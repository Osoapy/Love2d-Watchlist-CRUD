function drawBackground(background)
    love.graphics.setColor(1, 1, 1)
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.draw(background, 0, 0, 0, screenWidth / background:getWidth(), screenHeight / background:getHeight())
end

function drawFilmList(films, scrollY, filmHeight, visibleFilmCount, screenWidth, screenHeight, scrollbarWidth, scrollbarHeight)
    local divWidth = screenWidth * 0.45  -- Usar a mesma largura da div na função drawMessage
    local leftDivX, leftDivY = screenWidth * 0.05, screenHeight * 0.1
    local leftDivWidth, leftDivHeight = divWidth, screenHeight * 0.5  -- Atualizar a largura para ser igual à segunda div

    -- Desenha a área da lista de filmes
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", leftDivX, leftDivY, divWidth, leftDivHeight)
    love.graphics.setScissor(leftDivX, leftDivY, divWidth, leftDivHeight)

    -- Ajustar o início e fim da lista com base no scroll
    local filmStartIndex = math.floor(scrollY / filmHeight) + 1
    local filmEndIndex = math.min(filmStartIndex + visibleFilmCount - 1, #films)

    for i = filmStartIndex, filmEndIndex do
        local film = films[i]
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(film.nome, leftDivX + 10, leftDivY + (i - filmStartIndex) * filmHeight - (scrollY % filmHeight), divWidth - 30, "left")
    end

    love.graphics.setScissor()

    -- Desenhar a barra de rolagem
    local scrollbarX = leftDivX + leftDivWidth + 10
    local scrollbarHeight = (leftDivHeight / (#films * filmHeight)) * leftDivHeight
    local scrollbarY = leftDivY + (scrollY / (#films * filmHeight)) * leftDivHeight
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.rectangle("fill", scrollbarX, scrollbarY, scrollbarWidth, scrollbarHeight)
end

function drawMessage(screenWidth, screenHeight)
    local divWidth, divHeight = screenWidth * 0.45, screenHeight * 0.5
    local divX, divY1 = screenWidth * 0.05, screenHeight * 0.1
    local messageDivX, messageDivY = screenWidth * 0.05, screenHeight * 0.65
    local messageDivWidth, messageDivHeight = screenWidth * 0.3, screenHeight * 0.25
    local secondDivHeight = screenHeight * 0.3
    local spacing = screenHeight * 0.05
    local divY2 = divY1 + divHeight + spacing
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", divX, divY2, divWidth, secondDivHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.printf("YOU ARE WHAT YOU ARE WATCHING", divX, divY2 + secondDivHeight / 2 - 15, divWidth, "center")
end

function drawAttributes(fields, inputFields, screenWidth, screenHeight)
    local attributesDivX = screenWidth * 0.6
    local attributesDivY = screenHeight * 0.1
    local attributesDivWidth = screenWidth * 0.35
    local attributesDivHeight = screenHeight * 0.8
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", attributesDivX, attributesDivY, attributesDivWidth, attributesDivHeight)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(20))
    for i, field in ipairs(fields) do
        love.graphics.printf(field.display .. ": ", attributesDivX + 10, attributesDivY + 30 + (i - 1) * 40, attributesDivWidth - 20, "left")
        love.graphics.rectangle("line", attributesDivX + 120, attributesDivY + 30 + (i - 1) * 40, attributesDivWidth - 130, 30)
        local value = inputFields[field.key] or ""
        love.graphics.printf(value, attributesDivX + 125, attributesDivY + 35 + (i - 1) * 40, attributesDivWidth - 140, "left")
    end
end

function drawButtons(screenWidth, screenHeight)
    local attributesDivX = screenWidth * 0.6
    local attributesDivY = screenHeight * 0.1
    local attributesDivWidth = screenWidth * 0.35
    local attributesDivHeight = screenHeight * 0.8

    local buttonWidth, buttonHeight = attributesDivWidth * 0.4, 40
    local buttonY = attributesDivY + attributesDivHeight - buttonHeight - 20
    local saveButtonX, deleteButtonX = attributesDivX + 10, attributesDivX + attributesDivWidth - buttonWidth - 10

    -- Botão Salvar
    love.graphics.setColor(0, 0.5, 0)
    love.graphics.rectangle("fill", saveButtonX, buttonY, buttonWidth, buttonHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Salvar", saveButtonX, buttonY + 10, buttonWidth, "center")

    -- Botão Excluir
    love.graphics.setColor(0.5, 0, 0)
    love.graphics.rectangle("fill", deleteButtonX, buttonY, buttonWidth, buttonHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Excluir", deleteButtonX, buttonY + 10, buttonWidth, "center")
end