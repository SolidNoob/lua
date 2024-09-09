-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empêche Love de filtrer les contours des images quand elles sont redimensionnées
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

require("inputs")

-- Table pour stocker l'état global du jeu
GameState = {
    isPaused = false  -- Variable pour gérer l'état de pause
}

local pigeon = {}

local pipes = {}  -- Table qui contiendra toutes les paires de tuyaux
local pipeWidth = 30
local pipeGap = 300  -- Espace entre les tuyaux (haut/bas)
local pipeSpawnInterval = 0.5  -- Intervalle de temps entre l'apparition de chaque tuyau
local timer = 0

local colors = {} -- Table pour stocker les couleurs progressives
local colorIndex = 1  -- Indice pour suivre la couleur actuelle

-- Fonction de chargement : initialisation du jeu
function love.load()
    -- Cette fonction est appelée une seule fois au début
  
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  
  pigeon.x = 50     -- Position X initiale
  pigeon.y = 300    -- Position Y initiale
  pigeon.width = 20 -- Largeur de l'oiseau
  pigeon.height = 20 -- Hauteur de l'oiseau
  pigeon.gravity = 500  -- Gravité qui affecte l'oiseau
  pigeon.jumpHeight = -300  -- Hauteur du saut
  pigeon.velocityY = 0  -- Vitesse verticale de l'oiseau
  pigeon.speed = 1000
  pigeon.color = {1, 1, 0}  -- Couleur initiale jaune

  -- Appel de la fonction pour générer les couleurs au démarrage du jeu
  generateColors()
end

-- Fonction pour générer la suite de couleurs progressives
function generateColors()
    -- Vert vers bleu
    for i = 0, 4 do
        table.insert(colors, {0, 1 - i * 0.2, i * 0.2})  -- De vert à bleu
    end
    
    -- Bleu vers mauve
    for i = 0, 4 do
        table.insert(colors, {i * 0.2, 0, 1})  -- De bleu à mauve
    end
    
    -- Mauve vers rose
    for i = 0, 4 do
        table.insert(colors, {1, 0, 1 - i * 0.2})  -- De mauve à rose
    end
    
    -- Rose vers rouge
    for i = 0, 4 do
        table.insert(colors, {1, i * 0.2, i * 0.2})  -- De rose à rouge
    end
end

-- Fonction pour générer une nouvelle paire de tuyaux
function spawnPipe()
    local pipeHeight = math.random(50, screenHeight - pipeGap - 50)

    -- Créer une paire de tuyaux
    local pipe = {
        x = screenWidth,  -- Les tuyaux apparaissent à droite de l'écran
        yTop = pipeHeight - love.graphics.getHeight(),  -- Hauteur du tuyau supérieur (position inversée)
        yBottom = pipeHeight + pipeGap,  -- Hauteur du tuyau inférieur
        width = pipeWidth,
        color = colors[colorIndex]  -- Assigner une couleur au tuyau
    }
     -- Incrémenter l'indice de la couleur, et recommencer la séquence si nécessaire
    colorIndex = colorIndex + 1
    if colorIndex > #colors then
        colorIndex = 1
    end
    
    table.insert(pipes, pipe)  -- Ajouter la paire de tuyaux à la table
end

function jump()
    pigeon.velocityY = pigeon.jumpHeight
end

function checkCollision(pipe)
    -- Dimensions de l'oiseau
    local birdLeft = pigeon.x
    local birdRight = pigeon.x + pigeon.width
    local birdTop = pigeon.y
    local birdBottom = pigeon.y + pigeon.height

    -- Dimensions du tuyau
    local pipeLeft = pipe.x
    local pipeRight = pipe.x + pipe.width
    local pipeTop = pipe.yTop
    local pipeBottom = pipe.yBottom

    -- Collision avec le tuyau supérieur
    if birdRight > pipeLeft and birdLeft < pipeRight and birdTop < pipeTop + love.graphics.getHeight() then
        return true
    end

    -- Collision avec le tuyau inférieur
    if birdRight > pipeLeft and birdLeft < pipeRight and birdBottom > pipeBottom then
        return true
    end

    return false
end

-- Fonction de mise à jour : gère la logique du jeu
function love.update(dt)
    -- Cette fonction est appelée à chaque image pour mettre à jour la logique du jeu
    if GameState.isPaused then
        return  -- Sortir de love.update si le jeu est en pause
    end
    
    -- Gestion de l'apparition des tuyaux à intervalles réguliers
    timer = timer + dt
    if timer > pipeSpawnInterval then
        spawnPipe()  -- Générer un nouveau tuyau
        timer = 0
    end

    -- Déplacement des tuyaux vers la gauche
    for i, pipe in ipairs(pipes) do
        pipe.x = pipe.x - 200 * dt  -- 200 pixels/sec pour le déplacement des tuyaux

        -- Supprimer les tuyaux qui sont sortis de l'écran (hors de vue)
        if pipe.x + pipeWidth < 0 then
            table.remove(pipes, i)
        end
    end
    
    -- Appliquer la gravité sur l'oiseau
    --pigeon.velocityY = pigeon.velocityY + pigeon.gravity * dt

    -- Mettre à jour la position verticale de l'oiseau
    --pigeon.y = pigeon.y + pigeon.velocityY * dt
    if love.keyboard.isDown("up") then
        pigeon.y = pigeon.y - pigeon.speed * dt
    end
    if love.keyboard.isDown("down") then
        pigeon.y = pigeon.y + pigeon.speed * dt
    end
    if love.keyboard.isDown("left") then
        pigeon.x = pigeon.x - pigeon.speed * dt
    end
    if love.keyboard.isDown("right") then
        pigeon.x = pigeon.x + pigeon.speed * dt
    end


     -- Empêcher l'oiseau de sortir de l'écran
    if pigeon.y < 0 then
        pigeon.y = 0
    end
    if pigeon.y + pigeon.height > love.graphics.getHeight() then
        pigeon.y = love.graphics.getHeight() - pigeon.height
    end
    if pigeon.x < 0 then
        pigeon.x = 0
    end
    if pigeon.x + pigeon.width > love.graphics.getWidth() then
        pigeon.x = love.graphics.getWidth() - pigeon.width
    end
    
    -- Vérifier les collisions avec le premier tuyau visible
   for _, pipe in ipairs(pipes) do
        if checkCollision(pipe) then
            print("Collision avec un tuyau !")
            GameState.isPaused = true  -- Activer la pause lors de la collision
            break  -- Arrêter la boucle si une collision est détectée
        end
        
        -- Vérifier si l'oiseau traverse entre les tuyaux sans collision
        local birdPassedPipe = (pigeon.x > pipe.x + pipe.width)
        if birdPassedPipe then
            -- L'oiseau est passé entre les tuyaux, on change sa couleur
            pigeon.color = pipe.color
        end
    end
end

-- Fonction d'affichage : dessine les objets à l'écran
function love.draw()
    -- Cette fonction est appelée à chaque image pour dessiner sur l'écran
    
    
    -- Parcourir la table de tuyaux pour les dessiner
    for _, pipe in ipairs(pipes) do
        love.graphics.setColor(pipe.color) -- Utiliser la couleur assignée au tuyau

        -- Dessiner le tuyau supérieur (partie inversée en haut)
        love.graphics.setLineWidth(1)  -- Épaisseur du contour à 1 pixel
        love.graphics.rectangle("line", pipe.x, pipe.yTop, pipe.width, love.graphics.getHeight())

        -- Dessiner le tuyau inférieur
        love.graphics.rectangle("line", pipe.x, pipe.yBottom, pipe.width, love.graphics.getHeight() - pipe.yBottom)
    end
    
    love.graphics.setColor(pigeon.color) -- Dessiner l'oiseau avec sa couleur actuelle
    love.graphics.rectangle("fill", pigeon.x, pigeon.y, pigeon.width, pigeon.height)
    
    
       -- Afficher un message de pause si le jeu est en pause
    if GameState.isPaused then
        love.graphics.setColor(1, 0, 0)  -- Couleur rouge pour le texte
        love.graphics.printf('Pause - Press "P" to resume', 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end
end