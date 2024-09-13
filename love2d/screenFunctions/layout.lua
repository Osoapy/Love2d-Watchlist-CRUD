function drawBackground(background)
    love.graphics.setColor(1, 1, 1)
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.draw(background, 0, 0, 0, screenWidth / background:getWidth(), screenHeight / background:getHeight())
end

function drawFilmList(films, scrollY, filmHeight, visibleFilmCount, screenWidth, screenHeight)
    local leftDivX, leftDivY = screenWidth * 0.05, screenHeight * 0.1
    local leftDivWidth, leftDivHeight = screenWidth * 0.3, screenHeight * 0.5

    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", leftDivX, leftDivY, leftDivWidth, leftDivHeight)
    love.graphics.setScissor(leftDivX, leftDivY, leftDivWidth, leftDivHeight)
    
    local filmStartIndex = math.floor(scrollY / filmHeight) + 1
    local filmEndIndex = math.min(filmStartIndex + visibleFilmCount - 1, #films)
    for i = filmStartIndex, filmEndIndex do
        local film = films[i]
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(film.nome, leftDivX + 10, leftDivY + (i - filmStartIndex) * filmHeight - scrollY, leftDivWidth - 20, "left")
    end
    love.graphics.setScissor()
end

function drawMessage(screenWidth, screenHeight)
    local messageDivX, messageDivY = screenWidth * 0.05, screenHeight * 0.65
    local messageDivWidth, messageDivHeight = screenWidth * 0.3, screenHeight * 0.25
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", messageDivX, messageDivY, messageDivWidth, messageDivHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.printf("YOU ARE WHAT YOU ARE WATCHING", messageDivX, messageDivY + 10, messageDivWidth, "center")
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