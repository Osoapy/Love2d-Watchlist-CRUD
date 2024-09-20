local menu = {}

-- Configurações de layout
local scrollY = 0
local filmHeight = 30
local visibleFilmCount
local inputFields = {}
local currentField = nil
local allFilms = {}
local allSeries = {}
local allRealityShows = {}
local background
local divBackground
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

local everyObject = {};

function menu.load()
    -- Carregar a imagem do background
    background = love.graphics.newImage("assets/background.png")
    assert(background, "Erro ao carregar a imagem do background!")

    -- Carregar a imagem da div
    divBackground = love.graphics.newImage("assets/divBG.png")
    assert(background, "Erro ao carregar a imagem da div!")

    -- Inicializa a tela principal
    love.window.setTitle("Menu")

    -- Inicializa os botões
    menu.buttons = {
        {label = "Filme", screen = "adicionarFilme"},
        {label = "Série", screen = "adicionarSerie"},
        {label = "Reality show", screen = "adicionarRealityShow"}
    }
end

function menu.draw()
    -- Recalcular as dimensões da tela e das divs
    screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    divWidth, divHeight = screenWidth * 0.45, screenHeight * 0.5
    divX, divY1 = screenWidth * 0.05, screenHeight * 0.1
    messageDivX, messageDivY = screenWidth * 0.05, screenHeight * 0.65
    messageDivWidth, messageDivHeight = screenWidth * 0.3, screenHeight * 0.25
    spacing = screenHeight * 0.05
    divY2 = divY1 + divHeight + spacing

    -- Configurar cor e desenhar o background
    drawBackground(background)

    local leftDivX, leftDivY = screenWidth * 0.05, screenHeight * 0.1
    local leftDivHeight = screenHeight * 0.5

    drawFilmListDiv(leftDivX, leftDivY, divWidth, leftDivHeight)
    
    -- Configurar cor e desenhar o background
    drawDivBG(divBackground, leftDivX, leftDivY, divWidth, leftDivHeight)

    -- Segunda div (mensagem)
    drawMessage()

    -- Div direita
    drawAttributes({}, {}, 1)

    -- Botões
    drawResponsiveButtons(menu.buttons)
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
    end
end

return menu