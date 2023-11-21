io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local sounds = {}
local player = {
  x = 0,
  y = 0,
  angle = 0,
  vx = 0,
  vy = 0,
  speed = 0,
  engineIsOn = false,
  sprite = nil,
  fireSprite = nil
}


function love.load()  
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  
  player.sprite = love.graphics.newImage("assets/images/spaceship.png")
  player.fireSprite = love.graphics.newImage("assets/images/fire.png")
  
  sounds['collision'] = love.audio.newSource("assets/sounds/rebound.wav", "static")
  sounds['gameOver'] = love.audio.newSource("assets/sounds/lost.wav", "static")
  
  init_game()
end

function love.update(dt)
  player.vy = player.vy + (0.6 * dt)
  
  player.x = player.x + player.vx
  player.y = player.y + player.vy
  
  if love.keyboard.isDown('up') or love.keyboard.isDown('space') then
    player.engineIsOn = true
    local angleRadian = math.rad(player.angle)
    local forceX = math.cos(angleRadian) * (player.speed * dt)
    local forceY = math.sin(angleRadian) * (player.speed * dt)
    player.vx = player.vx + forceX
    player.vy = player.vy + forceY
  else
    player.engineIsOn = false
  end
  
  if love.keyboard.isDown('left') then
    player.angle = player.angle - 90 * dt
  end
  if love.keyboard.isDown('right') then
    player.angle = player.angle + 90 * dt
  end
  
  if love.keyboard.isDown('escape') then
    init_game()
  end
end

function love.draw()
  love.graphics.draw(player.sprite, player.x, player.y, math.rad(player.angle), 1, 1, player.sprite:getWidth() / 2, player.sprite:getHeight() / 2)
  
  if player.engineIsOn then 
    love.graphics.draw(player.fireSprite, player.x, player.y, math.rad(player.angle), 1, 1, player.fireSprite:getWidth() / 2, player.fireSprite:getHeight() / 2)
  end
end

function love.mousepressed(x, y, n)
 
end

function love.keypressed(key)
  print(key)
end

function init_game()
  player.x = screenWidth / 2
  player.y = screenHeight / 2
  player.engineIsOn = false
  player.speed = 3
  player.angle = -90
  player.vx = 0
  player.vy = 0
end

function playSound(sound_name)
  local clone = sounds[sound_name]:clone()
  clone:play()
end
