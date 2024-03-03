-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

hero1 = {
  spriteSheet = null,
  frames = {},
  currentFrame = 1,
  x = 10,
  y = 10
}

hero2 = {
  sprites = {},
  frame = 1,
  x = 50,
  y = 10
}

background = {
  image = nil,
  x = 0,
  y = 0
}

function love.load()
  
  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()
  
  background.image = love.graphics.newImage('/assets/images/fond.jpg')
  
  hero2.sprites[1] = love.graphics.newImage('/assets/images/hero1.png')
  hero2.sprites[2] = love.graphics.newImage('/assets/images/hero2.png')
  
  hero1.spriteSheet = love.graphics.newImage('/assets/images/herosheet.png')
  hero1.frames[1] = love.graphics.newQuad(0,0,24,24, hero1.spriteSheet:getWidth(), hero1.spriteSheet:getHeight())
  hero1.frames[2] = love.graphics.newQuad(24,0,24,24, hero1.spriteSheet:getWidth(), hero1.spriteSheet:getHeight())
end

function love.update(dt)
  hero2.frame = hero2.frame + 2 * dt
  if hero2.frame >= #hero2.sprites + 1 then
    hero2.frame = 1
  end
  hero2.x = hero2.x + 10 * dt
  hero2.y = hero2.y + 10 * dt
  
  
  hero1.currentFrame = hero1.currentFrame + 3 * dt
  if hero1.currentFrame >= #hero1.frames + 1 then
    hero1.currentFrame = 1
  end
  hero1.x = hero1.x + 10 * dt
  hero1.y = hero1.y + 10 * dt
end

function love.draw()
  love.graphics.draw(background.image, background.x, background.y)
  
  love.graphics.scale(4, 4)
  
  love.graphics.draw(hero2.sprites[math.floor(hero2.frame)], hero2.x, hero2.y)
  
  love.graphics.draw(hero1.spriteSheet, hero1.frames[math.floor(hero1.currentFrame)], hero1.x, hero1.y)
  
  love.graphics.print("Frame = "..math.floor(hero1.currentFrame).." -> "..hero1.currentFrame, 0, 0)
end

function love.keypressed(key)
  
  print(key)
  
end