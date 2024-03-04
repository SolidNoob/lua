-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

local background = {
  x = 0,
  y = 0,
  currentBackground = 'forest',
  images = {},
  xSpeed = 120
}

local hero = {
  x = 0,
  y = 0,
  isJumping = false,
  xSpeed = 1,
  yVelocity = 0,
  jumpHeight = -250,
  frames = {},
  frame = 1,
  width = 0,
  height = 0,
  displayHitbox = false
}

local groundPosition = 0
local musicManager = {}

local sndJump = love.audio.newSource("assets/sounds/sfx_movement_jump13.wav", "static")
local sndLanding = love.audio.newSource("assets/sounds/sfx_movement_jump13_landing.wav", "static")

function createMusicManager()
  local musicManager = {
    musics = {},
    currentMusic = 0 
  }
  function musicManager.addMusic(name, music)
    musicManager.musics[name] = music
    musicManager.musics[name]:setLooping(true)
    musicManager.musics[name]:setVolume(0)
  end
  
  function musicManager.update()
    for index, music in pairs(musicManager.musics) do
      if index == musicManager.currentMusic then
        if music:getVolume() < 1 then
          music:setVolume(music:getVolume() + 0.01)
        end
      else
        if music:getVolume() > 0 then
          music:setVolume(music:getVolume() - 0.01)
        end
      end
    end
  end

  function musicManager.playMusic(name)
    if musicManager.musics[name]:getVolume() == 0 and musicManager.currentMusic ~= name then
      musicManager.musics[name]:play(true)
    end
    musicManager.currentMusic = name
  end
  
  return musicManager
end

function love.load()
  
  love.window.setMode(512 * 2, 256 * 2)
  
  screenWidth = love.graphics.getWidth() / 2
  screenHeight = love.graphics.getHeight() / 2
  
  background.images['forest'] = love.graphics.newImage('/assets/images/forest.png')
  background.images['volcano'] = love.graphics.newImage('/assets/images/volcano.png')
  
  groundPosition = screenHeight - 33
  
  for i = 1, 8 do
    hero.frames[i] = love.graphics.newImage('/assets/images/hero-day-'..i..'.png')
  end
  hero.width = hero.frames[1]:getWidth()
  hero.height = hero.frames[1]:getHeight()
  hero.y = groundPosition
  
  musicManager = createMusicManager()
  musicManager.addMusic('forest', love.audio.newSource("assets/sounds/cool.mp3", "stream"))
  musicManager.addMusic('volcano', love.audio.newSource("assets/sounds/techno.mp3", "stream"))
  musicManager.playMusic('forest')
  
end

function love.update(dt)
  
  if love.keyboard.isDown('left') and hero.x > 0 then 
    hero.x = hero.x - hero.xSpeed * 50 * dt
  elseif love.keyboard.isDown('right') and hero.x < screenWidth - hero.width then 
    --print(hero.x..' -> '..screenWidth)
    hero.x = hero.x + hero.xSpeed * 50 * dt
  end
  
  if hero.x < screenWidth / 2 - hero.width / 2 then
    background.currentBackground = 'forest'
    musicManager.playMusic(background.currentBackground)
  else
    background.currentBackground = 'volcano'
    musicManager.playMusic(background.currentBackground)
  end
  
  background.x = background.x - background.xSpeed * dt
  if background.x <= 0 - background.images[background.currentBackground]:getWidth() then
    background.x = 1
  end
  
  hero.y = hero.y + hero.yVelocity * dt
  if hero.isJumping and hero.y >= groundPosition then
    hero.isJumping = false
    hero.y = groundPosition
    hero.yVelocity = 0
    sndLanding:play()
  end
  if hero.isJumping then 
    hero.yVelocity = hero.yVelocity + 600 * dt
  end
  
  hero.frame = hero.frame + 12 * dt
  if hero.frame >= #hero.frames + 1 then
    hero.frame = 1
  end
  
  musicManager.update()
end

function love.draw()
  love.graphics.scale(2,2)
  
  local currentBackgroundImage = background.images[background.currentBackground]
  love.graphics.draw(currentBackgroundImage, background.x, background.y)
  if background.x < 1 then
    love.graphics.draw(currentBackgroundImage, background.x + currentBackgroundImage:getWidth(), background.y)
  end
  
  if hero.displayHitbox then
    love.graphics.setColor(1, 0.4, 0.4)
    love.graphics.rectangle('fill', hero.x, hero.y, hero.width, hero.height)
  end 

  love.graphics.draw(hero.frames[math.floor(hero.frame)], hero.x, hero.y)
  
  love.graphics.setColor(1, 0.4, 0.4)
  love.graphics.line(screenWidth / 2, 0, screenWidth / 2, screenHeight)
  love.graphics.setColor(1, 1, 1)
end

function love.keypressed(key)
  
  print(key)  
  
  
  if key == 'up' and hero.isJumping == false then
    hero.isJumping = true
    hero.yVelocity = hero.jumpHeight
    sndJump:play()
  end
  
  if key == 'space' then
    hero.displayHitbox = not hero.displayHitbox
  end
  
end