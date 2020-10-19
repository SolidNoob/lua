local imgPerso      -- image principale (le personnage)
local imgCroix      -- image d'une croix qui servira de repère visuel pour voir la coordonnée x et y
local x,y = 0,0     -- position
local ox,oy = 0,0   -- origine
local rotation = 0  -- rotation
local scale=1
local bAnimScale = false
local animScale=-0.01
local font = love.graphics.newFont(14) -- font (nécessaire pour mesurer l'affichage des textes)

-- Chargement des images et centrage de la position de départ
function love.load()
  love.graphics.setBackgroundColor(.2,.2,.2)  
  imgPerso = love.graphics.newImage("images/personnage.png")
  imgCroix = love.graphics.newImage("images/croix.png")
  x = love.graphics.getWidth()/2
  y = love.graphics.getHeight()/2
  ox = 0
  oy = 0
end

-- Réponses aux touches pour modifier les valeurs de démonstration
-- Et animation du zoom de l'image
function love.update(dt)
  
  if bAnimScale == true then
    scale = scale + animScale
    if scale <= 0.5 then
      scale = 0.5
      animScale = 0 - animScale
    end
    if scale >= 1 then
      scale = 1
      animScale = 0 - animScale
    end
  end
  
  local shift = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")
  local ctrl = love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")
  
  if love.keyboard.isDown("right") and ctrl == true and shift == false then
    rotation = rotation + 0.01
  end
  if love.keyboard.isDown("left") and ctrl == true and shift == false 
  then
    rotation = rotation - 0.01
  end
  
  if love.keyboard.isDown("right") and shift and ctrl == false then
    ox = ox + 1
  end
  if love.keyboard.isDown("left") and shift and ctrl == false then
    ox = ox - 1
  end
  if love.keyboard.isDown("up") and shift and ctrl == false then
    oy = oy - 1
  end
  if love.keyboard.isDown("down") and shift and ctrl == false then
    oy = oy + 1
  end

  if love.keyboard.isDown("right") and shift == false and ctrl == false then
    x = x + 1
  end
  if love.keyboard.isDown("left") and shift == false and ctrl == false then
    x = x - 1
  end
  if love.keyboard.isDown("up") and shift == false and ctrl == false then
    y = y - 1
  end
  if love.keyboard.isDown("down") and shift == false and ctrl == false then
    y = y + 1
  end
end

function love.draw()
  -- Affichage des valeurs et de l'aide
  love.graphics.print("x="..tostring(x).." |  y="..tostring(y).." | ".."ox="..tostring(ox).." | oy="..tostring(oy), 0 , 0)
  love.graphics.print("c=centrer origine | v=reset origine | r=reset rotation | a=Animer scaling", 0, font:getHeight("X"))
  love.graphics.print("flèches=changer x,y | shift+flèches=changer origine | ctrl+flèches=rotation", 0, font:getHeight("X") * 2)
  
  -- Affichage de l'image du personnage à sa position (x,y) avec sa rotation (rotation) et son origine (ox,oy)
  love.graphics.draw(imgPerso, x, y, rotation, scale, scale, ox, oy)
  
  -- Affichage d'une croix : repère de la coordonnée originale, sans modification d'origine
  love.graphics.draw(imgCroix, x, y, 0, 1, 1, 8, 8)
  
  -- Affichage complémentaire de l'origine, autour de la croix
  local sox,soy = tostring(ox), tostring(oy)
  love.graphics.print(ox, x - font:getWidth(sox) / 2, y - 25)
  love.graphics.print(oy, x - font:getWidth(soy) - 10, y - font:getHeight(soy) / 2)
end

-- Raccourcis claviers pour centrer l'origine ou remettre à 0 origine et rotation
function love.keypressed(key)
  if key == "a" then
    scale = 1
    if bAnimScale == false then
      bAnimScale = true
    else
      bAnimScale = false
    end
  end

  if key == "c" then
    ox = imgPerso:getWidth() / 2    -- origine x = moitié de la largeur de l'image
    oy = imgPerso:getHeight() / 2   -- origine y = moitié de la hauteur de l'image
  end
  if key == "v" then
    ox = 0 -- remise à 0 de l'origine x
    oy = 0 -- remise à 0 de l'origine y
  end
  if key == "r" then
    rotation = 0 -- remise à 0 de la rotation
  end
end