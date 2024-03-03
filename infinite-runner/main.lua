-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

local sndJump = love.audio.newSource("assets/sounds/sfx_movement_jump13.wav", "static")

local musicCool = love.audio.newSource("assets/sounds/cool.mp3", "stream")
musicCool:setLooping(true)
musicCool:play(true)

function love.load()
  
  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()
  
end

function love.update(dt)
  
end

function love.draw()
 
end

function love.keypressed(key)
  
  print(key)
  if key == 'up' then
    sndJump:play()
  end
  
  if key == 's' then
    musicCool:pause()
  end
  if key == 'p' then
    musicCool:play()
  end
  if key == 'q' then
    musicCool:setPitch(2)
  end
  if key == 'd' then
    musicCool:setPitch(0.5)
  end
  
end