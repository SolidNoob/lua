io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

require 'functions/sounds'
Snake = require 'class/Snake'

local grid = {}
local snake = Snake:new(0, 0, 0, 0, 0, '')

function love.load()  
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  
  loadSounds()
  
  timer = 0
  initGame()
  
end

function love.update(dt)
  --[[
  timer = timer + dt
  if timer >= 0.016 then
    timer = 0
    snake:move(dt)
  end
  ]]--
  snake:move(dt)
  
  local head = snake.elements[1]
  
  
  if love.keyboard.isDown('left') and head.direction ~= 'RIGHT' then
    head.nextDirection = 'LEFT'
    --head.xTarget = head.width * (currentXCell - 1)
  end

  if love.keyboard.isDown('right') and head.direction ~= 'LEFT' then
    head.nextDirection = 'RIGHT'
    --head.xTarget = head.width * (currentXCell + 1)
  end
  
  if love.keyboard.isDown('up') and head.direction ~= 'DOWN' then
    head.nextDirection = 'UP'
    --head.yTarget = head.height * (currentYCell - 1)
  end

  if love.keyboard.isDown('down') and head.direction ~= 'UP' then
    head.nextDirection = 'DOWN'
    --head.yTarget = head.height * (currentYCell + 1)
  end
    
  
  
  
  if love.keyboard.isDown('space') then 
    -- snake:addElement()
  end
  
  if love.keyboard.isDown('escape') then
    --print('EXITEXITEXITEXITEXITEXITEXITEXITEXITEXITEXITEXITEXITEXITEXITEXITEXITEXITEXIT')
    --os.exit()
    initGame()
  end
end

function love.draw()
  for n=1,#snake.elements do
    local currentElement = snake.elements[n]
    
    if n == 2 then
      love.graphics.setColor(1, 0.6, 0.6, 1)
    end
    if n == 3 then
      love.graphics.setColor(0.6, 1, 0.6, 1)
    end
    if n == 4 then
      love.graphics.setColor(0.6, 0.6, 1, 1)
    end
    
    love.graphics.rectangle("fill", currentElement.x, currentElement.y, currentElement.width, currentElement.height)
    love.graphics.setColor(1, 1, 1, 1)
  end
  
  nbRows = screenHeight / snake.elements[1].height
  nbColumns = screenWidth / snake.elements[1].width
  for row = 1, nbRows do
    love.graphics.rectangle("fill", 0, (row - 1) * snake.elements[1].height, screenWidth, 1)
    for column = 1, nbColumns do
      love.graphics.rectangle("fill", (column - 1) * snake.elements[1].width, 0, 1, screenHeight)
    end
  end
end


function love.mousepressed(x, y, n)
 
end

function love.keypressed(key)
  if key == 'space' then 
    --snake.speed = snake.speed * 2
    snake:addElement() 
  end
end

function initGame()
  
  snake.speed = 1.5
  snake.elements = {
    {
      x = screenWidth / 2,
      y = screenHeight / 2,
      width = 20,
      height = 20,
      direction = 'RIGHT',
      nextDirection = 'RIGHT'
    }
  }
  snake.elements[1].xTarget = snake.elements[1].x + snake.elements[1].width
end

 
--function initGrid()
--for row = 1, 40 do
--for column = 1, 60 do
--grid[row][column] = 0
--end
--end
--end

