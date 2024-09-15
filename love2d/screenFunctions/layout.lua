function drawBackground(background)
    love.graphics.setColor(1, 1, 1)
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.draw(background, 0, 0, 0, screenWidth / background:getWidth(), screenHeight / background:getHeight())
end

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

    -- Cálculo da barra de rolagem
    local scrollbarX = leftDivX + divWidth + 10
    local scrollbarHeight
    local scrollbarY

    if #films <= visibleFilmCount then
        -- Quando o número de filmes for menor ou igual ao número de filmes visíveis
        scrollbarHeight = leftDivHeight  -- A barra de rolagem ocupa toda a altura da div
        scrollbarY = leftDivY  -- Sem necessidade de rolagem
    else
        -- Quando há mais filmes que a área visível
        scrollbarHeight = math.max((visibleFilmCount / #films) * leftDivHeight, 20)  -- Ajusta a altura da barra
        scrollbarY = leftDivY + (scrollY / (filmHeight * #films)) * leftDivHeight  -- Ajusta a posição da barra
    end

    -- Desenhar a barra de rolagem
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.rectangle("fill", scrollbarX, scrollbarY, scrollbarWidth, scrollbarHeight)
end

function drawMessage()
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
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
    love.graphics.printf("YOU ARE WHAT YOU ARE WATCHING", divX, divY2 + secondDivHeight / 2 - 15, divWidth, "center")
end

function drawAttributes(fields, inputFields, drawHalf)
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    local attributesDivX = screenWidth * 0.6
    local attributesDivY = screenHeight * 0.1
    local attributesDivWidth = screenWidth * 0.35
    local attributesDivHeight = screenHeight * 0.8
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", attributesDivX, attributesDivY, attributesDivWidth, attributesDivHeight)

    drawHalf = drawHalf or nil

    if(not drawHalf) then
        for i, field in ipairs(fields) do
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(field.display .. ": ", attributesDivX + 10, attributesDivY + 30 + (i - 1) * 40, attributesDivWidth - 20, "left")

            love.graphics.setColor(1, 0.9, 0.76, 0.21)
            love.graphics.rectangle("line", attributesDivX + 120, attributesDivY + 40 + (i - 1) * 40, attributesDivWidth - 130, 30)
            local value = inputFields[field.key] or ""

            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(value, attributesDivX + 125, attributesDivY + 30 + (i - 1) * 40, attributesDivWidth - 140, "left")
        end
    end
end

function drawButtons(selectedFilmIndex)
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

    local attributesDivX = screenWidth * 0.6
    local attributesDivY = screenHeight * 0.1
    local attributesDivWidth = screenWidth * 0.35
    local attributesDivHeight = screenHeight * 0.8

    local buttonWidth, buttonHeight = attributesDivWidth * 0.4, 40
    local buttonY = attributesDivY + attributesDivHeight - buttonHeight - 20
    local saveButtonX, deleteButtonX = attributesDivX + 10, attributesDivX + attributesDivWidth - buttonWidth - 10

    if selectedFilmIndex then
        -- Botão Excluir
        love.graphics.setColor(0.5, 0, 0)
        love.graphics.rectangle("fill", saveButtonX, buttonY, buttonWidth, buttonHeight)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Excluir", saveButtonX, buttonY + 10, buttonWidth, "center")

        -- Botão Alterar
        love.graphics.setColor(0, 0.5, 0)
        love.graphics.rectangle("fill", deleteButtonX, buttonY, buttonWidth, buttonHeight)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Alterar", deleteButtonX, buttonY + 10, buttonWidth, "center")
    else
        -- Botão Limpar
        love.graphics.setColor(0.5, 0, 0)
        love.graphics.rectangle("fill", saveButtonX, buttonY, buttonWidth, buttonHeight)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Limpar", saveButtonX, buttonY + 10, buttonWidth, "center")

        -- Botão Salvar
        love.graphics.setColor(0, 0.5, 0)
        love.graphics.rectangle("fill", deleteButtonX, buttonY, buttonWidth, buttonHeight)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Salvar", deleteButtonX, buttonY + 10, buttonWidth, "center")
    end
end