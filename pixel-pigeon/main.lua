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
local pipeWidth = 60
local pipeGap = 150  -- Espace entre les tuyaux (haut/bas)
local pipeSpawnInterval = 1  -- Intervalle de temps entre l'apparition de chaque tuyau
local timer = 0

-- Fonction de chargement : initialisation du jeu
function love.load()
    -- Cette fonction est appelée une seule fois au début
  
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  
  pigeon.x = 50     -- Position X initiale
  pigeon.y = 300    -- Position Y initiale
  pigeon.width = 40 -- Largeur de l'oiseau
  pigeon.height = 30 -- Hauteur de l'oiseau
  pigeon.gravity = 500  -- Gravité qui affecte l'oiseau
  pigeon.jumpHeight = -300  -- Hauteur du saut
  pigeon.velocityY = 0  -- Vitesse verticale de l'oiseau
end

-- Fonction pour générer une nouvelle paire de tuyaux
function spawnPipe()
    local pipeHeight = math.random(50, screenHeight - pipeGap - 50)

    -- Créer une paire de tuyaux
    local pipe = {
        x = screenWidth,  -- Les tuyaux apparaissent à droite de l'écran
        yTop = pipeHeight - love.graphics.getHeight(),  -- Hauteur du tuyau supérieur (position inversée)
        yBottom = pipeHeight + pipeGap,  -- Hauteur du tuyau inférieur
        width = pipeWidth
    }
    
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
    pigeon.velocityY = pigeon.velocityY + pigeon.gravity * dt

    -- Mettre à jour la position verticale de l'oiseau
    pigeon.y = pigeon.y + pigeon.velocityY * dt

    -- Empêcher l'oiseau de sortir de l'écran par le bas
    if pigeon.y + pigeon.height > love.graphics.getHeight() then
        pigeon.y = love.graphics.getHeight() - pigeon.height
        pigeon.velocityY = 0
    end
    
    -- Vérifier les collisions avec le premier tuyau visible
    if #pipes > 0 then
        local firstPipe = pipes[1]
        if checkCollision(firstPipe) then
            -- Collision détectée, fin du jeu ou autre action
            print("Collision !")
            GameState.isPaused = true  -- Activer la pause lors de la collision
        end
    end
end

-- Fonction d'affichage : dessine les objets à l'écran
function love.draw()
    -- Cette fonction est appelée à chaque image pour dessiner sur l'écran
    
    -- Parcourir la table de tuyaux pour les dessiner
    for _, pipe in ipairs(pipes) do
        love.graphics.setColor(0, 1, 0)  -- Couleur verte pour les tuyaux

        -- Dessiner le tuyau supérieur (partie inversée en haut)
        love.graphics.rectangle("fill", pipe.x, pipe.yTop, pipe.width, love.graphics.getHeight())

        -- Dessiner le tuyau inférieur
        love.graphics.rectangle("fill", pipe.x, pipe.yBottom, pipe.width, love.graphics.getHeight() - pipe.yBottom)
    end
    
    love.graphics.setColor(1, 1, 0) -- Couleur jaune pour l'oiseau
    love.graphics.rectangle("fill", pigeon.x, pigeon.y, pigeon.width, pigeon.height)
end