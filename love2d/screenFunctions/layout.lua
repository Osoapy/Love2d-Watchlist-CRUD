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

    -- Use window height for calculate films visible
    local visibleFilmCount = math.floor(leftDivHeight / filmHeight)

    -- Draw film list div
    love.graphics.setColor(1, 0.9, 0.76, 0.21)
    love.graphics.rectangle("fill", leftDivX, leftDivY, divWidth, leftDivHeight)
    
    -- Clipping adjusting
    love.graphics.setScissor(leftDivX, leftDivY, divWidth, leftDivHeight)

    -- Use the scroll for defining the start & ending
    local filmStartIndex = math.floor(scrollY / filmHeight) + 1
    local filmEndIndex = math.min(filmStartIndex + visibleFilmCount - 1, #films)

    for i = filmStartIndex, filmEndIndex do
        local film = films[i]
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(film.nome, leftDivX + 10, leftDivY + (i - filmStartIndex) * filmHeight - (scrollY % filmHeight), divWidth - 30, "left")
    end

    -- Removing clipping
    love.graphics.setScissor()

    -- Calculating the scroll area
    local scrollbarX = leftDivX + divWidth + 10
    local scrollbarHeight
    local scrollbarY

    if #films <= visibleFilmCount then
        scrollbarHeight = leftDivHeight  -- When the is not much films it is the same height as the div
        scrollbarY = leftDivY  -- No need to scroll
    else
        scrollbarHeight = math.max((visibleFilmCount / #films) * leftDivHeight, 20)  
        scrollbarY = leftDivY + (scrollY / (filmHeight * #films)) * leftDivHeight 
    end

    -- Drawing the scroll
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
    love.graphics.printf("CRIAR / EDITAR", rightDivX, rightDivY + 10, rightDivWidth, "center")

    -- Going by each button in a responsive way
    for i, button in ipairs(buttons) do
        local buttonX = rightDivX + (rightDivWidth - buttonWidth) / 2
        local buttonY = rightDivY + 50 + (i - 1) * (buttonHeight + 20)

        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)

        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(button.label, buttonX, buttonY + (buttonHeight / 3), buttonWidth, "center")
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
    local borderRadius = 5

    local function drawRoundedButton(x, y, width, height, color)
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", x + borderRadius, y, width - borderRadius * 2, height)
        
        love.graphics.arc("fill", x + borderRadius, y + borderRadius, borderRadius, math.pi, 3 * math.pi / 2)  -- Canto superior esquerdo
        love.graphics.arc("fill", x + width - borderRadius, y + borderRadius, borderRadius, 3 * math.pi / 2, 0)  -- Canto superior direito
        love.graphics.arc("fill", x + borderRadius, y + height - borderRadius, borderRadius, math.pi / 2, math.pi)  -- Canto inferior esquerdo
        love.graphics.arc("fill", x + width - borderRadius, y + height - borderRadius, borderRadius, 0, math.pi / 2)  -- Canto inferior direito
        
        love.graphics.rectangle("fill", x, y + borderRadius, borderRadius, height - borderRadius * 2)  -- Lado esquerdo
        love.graphics.rectangle("fill", x + width - borderRadius, y + borderRadius, borderRadius, height - borderRadius * 2)  -- Lado direito
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