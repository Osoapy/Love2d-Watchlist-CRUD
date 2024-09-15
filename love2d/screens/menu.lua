local menu = {}

-- Configurações de layout
local scrollY = 0
local filmHeight = 30
local visibleFilmCount
local inputFields = {}
local currentField = nil
local allFilms = {}
local filmFile = "archives/filme.txt"
local background
local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

local divWidth, divHeight = screenWidth * 0.45, screenHeight * 0.5
local divX, divY1 = screenWidth * 0.05, screenHeight * 0.1
local messageDivX, messageDivY = screenWidth * 0.05, screenHeight * 0.65
local messageDivWidth, messageDivHeight = screenWidth * 0.3, screenHeight * 0.25
local secondDivHeight = screenHeight * 0.3
local spacing = screenHeight * 0.05
local divY2 = divY1 + divHeight + spacing

local isDraggingScrollbar = false
local scrollbarY = 0
local scrollbarHeight
local scrollbarWidth = 20
local totalHeight
local clickedIndex

local rightDivWidth = screenWidth * 0.35
local rightDivHeight = screenHeight * 0.8
local rightDivX, rightDivY = screenWidth - rightDivWidth - screenWidth * 0.05, screenHeight * 0.1

function menu.load()
    -- Carregar a imagem do background
    background = love.graphics.newImage("assets/background.png")
    assert(background, "Erro ao carregar a imagem do background!")

    -- Inicializa a tela principal
    love.window.setTitle("Menu")

    -- Inicializa os botões
    menu.buttons = {
        {label = "Filme", screen = "adicionarFilme"},
        {label = "Série", screen = "adicionarSerie"},
        {label = "Reality show", screen = "adicionarRealityShow"}
    }

    -- Recebe todos os filmes a serem listados
    filmFile = "archives/filme.txt"
    allFilms = returnAllObjects(filmFile)
    totalHeight = #allFilms * filmHeight
    visibleFilmCount = math.floor(love.graphics.getHeight() * 0.5 / filmHeight)
end

function menu.draw()
    -- Recalcular as dimensões da tela
    screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

    -- Recalcular as dimensões das divs
    divWidth, divHeight = screenWidth * 0.45, screenHeight * 0.5
    divX, divY1 = screenWidth * 0.05, screenHeight * 0.1
    messageDivX, messageDivY = screenWidth * 0.05, screenHeight * 0.65
    messageDivWidth, messageDivHeight = screenWidth * 0.3, screenHeight * 0.25
    secondDivHeight = screenHeight * 0.3
    spacing = screenHeight * 0.05
    divY2 = divY1 + divHeight + spacing
    
    -- Configurar cor e desenhar o background
    drawBackground(background)

    -- Definir e desenhar a primeira div
    drawFilmList(allFilms, scrollY, filmHeight, visibleFilmCount, scrollbarWidth, scrollbarHeight)

    -- Segunda div
    drawMessage(screenWidth, screenHeight)
    
    -- Div direita
    drawAttributes({}, {}, 1)

    -- Botões
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("CRIAR / EDITAR", rightDivX, rightDivY + 10, rightDivWidth, "center")
    local buttonWidth, buttonHeight = rightDivWidth * 0.8, rightDivHeight * 0.15
    for i, button in ipairs(menu.buttons) do
        local buttonX, buttonY = rightDivX + (rightDivWidth - buttonWidth) / 2, rightDivY + 50 + (i - 1) * (buttonHeight + 20)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(button.label, buttonX, buttonY + (buttonHeight / 3), buttonWidth, "center")
    end
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
        local rightDivWidth = screenWidth * 0.35
        local rightDivHeight = screenHeight * 0.8
        local rightDivX = screenWidth - rightDivWidth - screenWidth * 0.05
        local rightDivY = screenHeight * 0.1

        -- Verificar se o clique foi em algum botão
        for i, btn in ipairs(menu.buttons) do
            local buttonX = rightDivX + (rightDivWidth - rightDivWidth * 0.8) / 2
            local buttonY = rightDivY + 50 + (i - 1) * (rightDivHeight * 0.15 + 20)
            if x >= buttonX and x <= buttonX + rightDivWidth * 0.8 and y >= buttonY and y <= buttonY + rightDivHeight * 0.15 then
                changeScreen(btn.screen)
            end
        end

        if x >= divX and x <= divX + divWidth and y >= divY1 and y <= divY1 + divHeight then
            clickedIndex = math.floor((y - divY1 + scrollY) / filmHeight) + 1

            -- Verifica se o índice está dentro da lista de filmes
            if clickedIndex >= 1 and clickedIndex <= #allFilms then
                local selectedFilm = allFilms[clickedIndex]

                -- Chama a função de mudança de tela para a tela de edição de filmes
                changeScreen("adicionarFilme", clickedIndex)
            end
        end
    end
end
    
-- Função para detectar a rolagem do mouse
function menu.wheelmoved(x, y)
    local screenHeight = love.graphics.getHeight()
    local divHeight = screenHeight * 0.5
    -- Limitar o scroll para não ir além do último filme
    scrollY = math.max(0, math.min(scrollY - y * 20, totalHeight - divHeight))
end

return menu