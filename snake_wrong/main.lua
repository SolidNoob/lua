io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

require 'functions/sounds'
Snake = require 'class/Snake'

local snake = Snake:new(0, 0, 0, 0, 0, '')

function love.load()  
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  
  loadSounds()
  
  init_game()
end

function love.update(dt)
  snake:move(dt)
  
  if love.keyboard.isDown('left') and snake.elements[1].direction ~= 'RIGHT' then
    snake.elements[1].direction = 'LEFT'
  end

  if love.keyboard.isDown('right') and snake.elements[1].direction ~= 'LEFT' then
    snake.elements[1].direction = 'RIGHT'
  end
  
  if love.keyboard.isDown('up') and snake.elements[1].direction ~= 'DOWN' then
    snake.elements[1].direction = 'UP'
  end

  if love.keyboard.isDown('down') and snake.elements[1].direction ~= 'UP' then
    snake.elements[1].direction = 'DOWN'
  end
  
  
  
  if love.keyboard.isDown('space') then 
    -- snake:addElement()
  end
  
  if love.keyboard.isDown('escape') then
    init_game()
  end
end

function love.draw()
  for n=1,#snake.elements do
    local currentElement = snake.elements[n]
    love.graphics.rectangle("fill", currentElement.x, currentElement.y, currentElement.width, currentElement.height)
  end
end

function love.mousepressed(x, y, n)
 
end

function love.keypressed(key)
  if key == 'space' then 
    snake:addElement() 
  end
end

function init_game()
  snake.speed = 100
  snake.elements = {
    {
      x = screenWidth / 2,
      y = screenHeight / 2,
      width = 20,
      height = 20,
      direction = 'RIGHT'
    }
  }
end
