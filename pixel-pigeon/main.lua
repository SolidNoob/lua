-- Afficher des traces dans la console pendant l'exécution
io.stdout:setvbuf('no')

-- Empêche Love de filtrer les contours des images pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Débogage dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

require("inputs")

GameState = {
    isPaused = false  -- Gestion de la pause
}

local pigeon = {}
local pipes = {}
local particles = {}
local colors = {}
local colorIndex = 1
local pipeWidth = 30
local pipeGap = 300
local pipeSpawnInterval = 0.5
local timer = 0

-- Initialisation du jeu
function love.load()
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    pigeon.x = 300
    pigeon.y = 300
    pigeon.width = 20
    pigeon.height = 20
    pigeon.speed = 1000
    pigeon.color = {1, 1, 0}
    pigeon.rotation = 0
    
    generateColors()
end

-- Générer la suite de couleurs pour les tuyaux
function generateColors()
    -- Vert vers Cyan
    for i = 0, 4 do
        table.insert(colors, {0, 1, i * 0.2})  -- De vert à cyan
    end

    -- Cyan vers Bleu
    for i = 0, 4 do
        table.insert(colors, {0, 1 - i * 0.2, 1})  -- De cyan à bleu
    end

    -- Bleu vers Mauve
    for i = 0, 4 do
        table.insert(colors, {i * 0.2, 0, 1})  -- De bleu à mauve
    end

    -- Mauve vers Rose
    for i = 0, 4 do
        table.insert(colors, {1, i * 0.2, 1 - i * 0.2})  -- De mauve à rose
    end

    -- Rose vers Rouge
    for i = 0, 4 do
        table.insert(colors, {1, 1 - i * 0.2, 1 - i * 0.2})  -- De rose à rouge
    end

    -- Rouge vers Orange
    for i = 0, 4 do
        table.insert(colors, {1, i * 0.2, 0})  -- De rouge à orange
    end

    -- Orange vers Jaune
    for i = 0, 4 do
        table.insert(colors, {1, 1, i * 0.2})  -- De orange à jaune
    end

    -- Jaune vers Vert
    for i = 0, 4 do
        table.insert(colors, {1 - i * 0.2, 1, 0})  -- De jaune à vert
    end
end


-- Générer une nouvelle paire de tuyaux
function spawnPipe()
    local pipeHeight = math.random(50, screenHeight - pipeGap - 50)
    local pipe = {
        x = screenWidth,
        yTop = pipeHeight - love.graphics.getHeight(),
        yBottom = pipeHeight + pipeGap,
        width = pipeWidth,
        color = colors[colorIndex],
        isClosing = false,  
        closingSpeed = 200,
        transitionAlpha = 0  -- La transition commence à 0 (100% "line", 0% "fill")
    }
    colorIndex = colorIndex % #colors + 1
    table.insert(pipes, pipe)
end

function jump()
    pigeon.velocityY = pigeon.jumpHeight
end

function checkCollision(pipe)
    local birdLeft = pigeon.x
    local birdRight = pigeon.x + pigeon.width
    local birdTop = pigeon.y
    local birdBottom = pigeon.y + pigeon.height
    local pipeLeft = pipe.x
    local pipeRight = pipe.x + pipe.width

    if (birdRight > pipeLeft and birdLeft < pipeRight) then
        if (birdTop < pipe.yTop + love.graphics.getHeight()) or (birdBottom > pipe.yBottom) then
            return true
        end
    end
    return false
end

-- Mise à jour du jeu
function love.update(dt)
    if GameState.isPaused then return end
    
     -- Rotation permanente : 2π radians (360°) en 4 secondes
    pigeon.rotation = pigeon.rotation + (math.pi * 2 / 4) * dt
    -- Réinitialiser la rotation après un tour complet 
    if pigeon.rotation > math.pi * 2 then
        pigeon.rotation = pigeon.rotation - math.pi * 2
    end

    -- Générer de nouveaux tuyaux à intervalles réguliers
    timer = timer + dt
    if timer > pipeSpawnInterval then
        spawnPipe()
        timer = 0
    end

    -- Déplacement des tuyaux
    for i = #pipes, 1, -1 do
        local pipe = pipes[i]
        pipe.x = pipe.x - 200 * dt
        
        -- Supprimer les tuyaux sortis de l'écran
        if pipe.x + pipe.width < 0 then
            table.remove(pipes, i)
        end
        
        -- Fermer les tuyaux si nécessaire
        if pipe.isClosing then
            pipe.transitionAlpha = math.min(pipe.transitionAlpha + dt, 1)

            -- Les tuyaux se rapprochent vers le centre
            pipe.yTop = pipe.yTop + pipe.closingSpeed * dt
            pipe.yBottom = pipe.yBottom - pipe.closingSpeed * dt

            -- Si les tuyaux se rejoignent, arrêter la fermeture
            if pipe.yTop + love.graphics.getHeight() >= pipe.yBottom then
                pipe.yTop = pipe.yBottom - love.graphics.getHeight()
            end
        end
    end

    -- Déplacement de l'oiseau (Pigeon)
    if love.keyboard.isDown("up") then pigeon.y = pigeon.y - pigeon.speed * dt end
    if love.keyboard.isDown("down") then pigeon.y = pigeon.y + pigeon.speed * dt end
    if love.keyboard.isDown("left") then pigeon.x = pigeon.x - pigeon.speed * dt end
    if love.keyboard.isDown("right") then pigeon.x = pigeon.x + pigeon.speed * dt end

    -- Empêcher l'oiseau de sortir de l'écran
    pigeon.y = math.max(0, math.min(love.graphics.getHeight() - pigeon.height, pigeon.y))
    pigeon.x = math.max(0, math.min(love.graphics.getWidth() - pigeon.width, pigeon.x))

    -- Vérification des collisions et changement de couleur
    for _, pipe in ipairs(pipes) do
        if checkCollision(pipe) then
            GameState.isPaused = true
            break
        end
        if pigeon.x > pipe.x + pipe.width then
            pigeon.color = pipe.color
            pipe.isClosing = true
        end
    end

    -- Générer une particule
    local newParticle = {
        x = pigeon.x - 5,
        y = pigeon.y + pigeon.height / 2,
        size = math.random(6, 8),
        life = 0.75,
        rotation = math.random() * math.pi * 2,
        rotationSpeed = math.random(-2, 2),
        speedX = math.random(-50, -20),
        speedY = math.random(-10, 10)
    }
    table.insert(particles, newParticle)

    -- Mise à jour des particules
    for i = #particles, 1, -1 do
        local p = particles[i]
        p.life = p.life - dt
        p.x = p.x + p.speedX * dt
        p.y = p.y + p.speedY * dt
        p.rotation = p.rotation + p.rotationSpeed * dt
        if p.life <= 0 then
            table.remove(particles, i)
        end
    end
end

-- Dessiner le jeu
function love.draw()
    -- Dessiner les particules
    for _, p in ipairs(particles) do
        love.graphics.setColor(pigeon.color[1], pigeon.color[2], pigeon.color[3], p.life)
        love.graphics.push()
        love.graphics.translate(p.x, p.y)
        love.graphics.rotate(p.rotation)
        love.graphics.rectangle("line", -p.size / 2, -p.size / 2, p.size, p.size)
        love.graphics.pop()
    end

    -- Dessiner les tuyaux
    for _, pipe in ipairs(pipes) do
        -- Couleur originale du tuyau
        local r, g, b = pipe.color[1], pipe.color[2], pipe.color[3]

        -- Dessiner la version "line" avec une transparence qui diminue
        love.graphics.setColor(r, g, b, 1 - pipe.transitionAlpha)
        love.graphics.rectangle("line", pipe.x, pipe.yTop, pipe.width, love.graphics.getHeight())
        love.graphics.rectangle("line", pipe.x, pipe.yBottom, pipe.width, love.graphics.getHeight() - pipe.yBottom)

        -- Dessiner la version "fill" avec une transparence qui augmente
        love.graphics.setColor(r, g, b, pipe.transitionAlpha)
        love.graphics.rectangle("fill", pipe.x, pipe.yTop, pipe.width, love.graphics.getHeight())
        love.graphics.rectangle("fill", pipe.x, pipe.yBottom, pipe.width, love.graphics.getHeight() - pipe.yBottom)
    end

    -- Dessiner l'oiseau
    love.graphics.setColor(pigeon.color)
    love.graphics.push()  
    love.graphics.translate(pigeon.x + pigeon.width / 2, pigeon.y + pigeon.height / 2)  
    love.graphics.rotate(pigeon.rotation)  
    love.graphics.rectangle("fill", -pigeon.width / 2, -pigeon.height / 2, pigeon.width, pigeon.height) 
    love.graphics.pop()

    -- Afficher le message de pause
    if GameState.isPaused then
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf('Pause - Press "P" to resume', 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end
end
