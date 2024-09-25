function drawTextWithShadow(text, x, y, limit, align)
    -- Sombra preta
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(text, x + 2, y + 2, limit, align)

    -- Texto branco
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(text, x, y, limit, align)
end

function drawBackground(background)
    love.graphics.setColor(1, 1, 1)
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.draw(background, 0, 0, 0, screenWidth / background:getWidth(), screenHeight / background:getHeight())
end

function drawDivBG(background, leftDivX, leftDivY, divWidth, leftDivHeight)
    love.graphics.setColor(1, 1, 1, 0.43)
    love.graphics.draw(background, leftDivX, leftDivY, 0, divWidth / background:getWidth(), leftDivHeight / background:getHeight())
end

function drawFilmListDiv(leftDivX, leftDivY, divWidth, leftDivHeight)
    -- Draw film list div
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", leftDivX, leftDivY, divWidth, leftDivHeight)
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
        if film then
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf(film.nome, leftDivX + 10, leftDivY + (i - filmStartIndex) * filmHeight - (scrollY % filmHeight), divWidth - 30, "left")
        end
    end

    -- Remover o scissor após desenhar
    love.graphics.setScissor()

    -- Recalcular e desenhar a barra de rolagem
    local scrollbarHeight = math.max((leftDivHeight / (#films * filmHeight)) * leftDivHeight, 20)
    local scrollbarX = leftDivX + divWidth + 10
    local scrollbarY = leftDivY + (scrollY / (#films * filmHeight)) * leftDivHeight

    if #films <= visibleFilmCount then
        scrollbarHeight = leftDivHeight  -- Quando há poucos filmes
        scrollbarY = leftDivY  -- Sem necessidade de rolar
    end

    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.rectangle("fill", scrollbarX, scrollbarY, scrollbarWidth, scrollbarHeight)
end

function drawBackButton(buttonImage) 
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

    local buttonSize = screenWidth * 0.05  
    local buttonBackX = screenWidth * 0.05  
    local buttonBackY = screenHeight * 0.1 - buttonSize - 10  

    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", buttonBackX, buttonBackY, buttonSize, buttonSize)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(buttonImage, buttonBackX, buttonBackY, 0, buttonSize / buttonImage:getWidth(), buttonSize / buttonImage:getHeight())
end

function drawResponsiveButtons(buttons)
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

    local rightDivWidth = screenWidth * 0.35
    local rightDivHeight = screenHeight * 0.8
    local rightDivX, rightDivY = screenWidth - rightDivWidth - screenWidth * 0.05, screenHeight * 0.1

    local buttonWidth, buttonHeight = rightDivWidth * 0.8, rightDivHeight * 0.15

    -- Drawing the title
    love.graphics.setColor(1, 1, 1)
    drawTextWithShadow("CRIAR / EDITAR", rightDivX, rightDivY + 10, rightDivWidth, "center")

    -- Going by each button in a responsive way
    for i, button in ipairs(buttons) do
        local buttonX = rightDivX + (rightDivWidth - buttonWidth) / 2
        local buttonY = rightDivY + 50 + (i - 1) * (buttonHeight + 20)

        love.graphics.setColor(1, 0.9, 0.76, 0.43)
        love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)

        love.graphics.setColor(0, 0, 0)
        drawTextWithShadow(button.label, buttonX, buttonY + (buttonHeight / 3), buttonWidth, "center")
    end
end

function drawMessage()
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    local divWidth, divHeight = screenWidth * 0.45, screenHeight * 0.5
    local divX, divY1 = screenWidth * 0.05, screenHeight * 0.1
    local messageDivX, messageDivY = screenWidth * 0.05, screenHeight * 0.65
    local messageDivWidth, messageDivHeight = screenWidth * 0.3, screenHeight * 0.25
    local secondDivHeight = screenHeight * 0.25
    local spacing = screenHeight * 0.05
    local divY2 = divY1 + divHeight + spacing
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", divX, divY2, divWidth, secondDivHeight)
    love.graphics.setColor(1, 1, 1)
    drawTextWithShadow("YOU ARE WHAT YOU ARE WATCHING", divX, divY2 + secondDivHeight / 2 - 15, divWidth, "center")
end

function drawAttributes(fields, inputFields, drawHalf)
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    local attributesDivX = screenWidth * 0.6
    local attributesDivY = screenHeight * 0.1
    local attributesDivWidth = screenWidth * 0.35
    local attributesDivHeight = screenHeight * 0.8
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", attributesDivX, attributesDivY, attributesDivWidth, attributesDivHeight)

    -- Adicionar título CRIAR / EDITAR
    love.graphics.setColor(1, 1, 1)
    drawTextWithShadow("CRIAR / EDITAR", attributesDivX, attributesDivY + 10, attributesDivWidth, "center")

    drawHalf = drawHalf or nil

    local smallFont = love.graphics.newFont("fonts/zenKaku.ttf", 19.5)
    love.graphics.setFont(smallFont)

    if not drawHalf then
        for i, field in ipairs(fields) do
            -- Espaçamento entre o texto e o campo
            local textX = attributesDivX + 10
            local fieldX = attributesDivX + 150

            -- Desenhar o texto com sombra
            drawTextWithShadow(field.display .. ": ", textX, attributesDivY + 60 + (i - 1) * 40, attributesDivWidth - 20, "left")

            -- Desenhar o campo preenchível
            love.graphics.setColor(1, 0.9, 0.76, 0.21)
            love.graphics.rectangle("line", fieldX, attributesDivY + 60 + (i - 1) * 40, attributesDivWidth - 160, 30)
            local value = inputFields[field.key] or ""

            -- Desenhar o valor do campo
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(value, fieldX + 5, attributesDivY + 60 + (i - 1) * 40, attributesDivWidth - 170, "left")
        end
    end

    love.graphics.setFont(myFont)
end

function drawButtons(selectedFilmIndex)
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

    local attributesDivX = screenWidth * 0.6
    local attributesDivY = screenHeight * 0.1
    local attributesDivWidth = screenWidth * 0.35
    local attributesDivHeight = screenHeight * 0.8

    local buttonWidth, buttonHeight = attributesDivWidth * 0.4, attributesDivHeight * 0.1
    local buttonY = attributesDivY + attributesDivHeight - buttonHeight - 60  -- Centralizando verticalmente
    local saveButtonX, deleteButtonX = attributesDivX + 10, attributesDivX + attributesDivWidth - buttonWidth - 10
    local borderRadius = 5

    local function drawRoundedButton(x, y, width, height, color)
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", x, y, width, height)
    end

    if selectedFilmIndex then
        -- Delete
        drawRoundedButton(saveButtonX, buttonY, buttonWidth, buttonHeight, {0.5, 0, 0})
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Excluir", saveButtonX, buttonY + 10, buttonWidth, "center")

        -- Alter
        drawRoundedButton(deleteButtonX, buttonY, buttonWidth, buttonHeight, {0, 0.5, 0})
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Alterar", deleteButtonX, buttonY + 10, buttonWidth, "center")
    else
        -- Clean
        drawRoundedButton(saveButtonX, buttonY, buttonWidth, buttonHeight, {0.5, 0, 0})
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Limpar", saveButtonX, buttonY + 10, buttonWidth, "center")

        -- Save
        drawRoundedButton(deleteButtonX, buttonY, buttonWidth, buttonHeight, {0, 0.5, 0})
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Salvar", deleteButtonX, buttonY + 10, buttonWidth, "center")
    end
end