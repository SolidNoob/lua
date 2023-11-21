io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local pad = {
  x = 0,
  y = 0,
  width = 80,
  height = 20
}

local ball = {
  x = 0,
  y = 0,
  radius = 10,
  isOnPad = false,
  x_speed = 0,
  y_speed = 0
}

local block = {
  width = 0,
  height = 0
}

local stage = {}

local sounds = {}

function play_sound(sound_name)
  local clone = sounds[sound_name]:clone()
  clone:play()
end

function love.load()  
  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()
  
  sounds['rebound'] = love.audio.newSource("assets/sounds/rebound.wav", "static")
  sounds['game_over'] = love.audio.newSource("assets/sounds/lost.wav", "static")
  
  block.height = 25
  block.width = screen_width / 15
  
  pad.y = screen_height - pad.height - 5
  
  init_game()
end

function love.update(dt)
  pad.x = love.mouse.getX()
  if pad.x - pad.width / 2 < 0 then pad.x = 0 + pad.width / 2 end
  if pad.x + pad.width / 2 >= screen_width then pad.x = screen_width - pad.width / 2 end
  
  if ball.isOnPad then
    ball.x = pad.x
    ball.y = pad.y - ball.radius
  else
    ball.x = ball.x + ball.x_speed * dt
    ball.y = ball.y + ball.y_speed * dt
  end
  
  local column = math.floor(ball.x / block.width) + 1
  local row = math.floor(ball.y / block.height) + 1
  if row >= 1 and row <= #stage and column >= 1 and column <= 15 then  
    if stage[row][column] == 1 then 
      ball.y_speed = ball.y_speed * -1
      stage[row][column] = 0
      play_sound('rebound')
    end
  end
  
  
  if ball.x > screen_width then
    ball.x = screen_width
    ball.x_speed = ball.x_speed * -1
      play_sound('rebound')
  end
  
  if ball.x < 0 then 
    ball.x = 0
    ball.x_speed = ball.x_speed * -1
    play_sound('rebound')
  end
  
  if ball.y < 0 then 
    ball.y = 0
    ball.y_speed = ball.y_speed * -1
  end
  
  if ball.y > screen_height then
    -- ball has fallen
    ball.isOnPad = true
    play_sound('game_over')
  end
  
  local y_pad_ball_collision = pad.y - ball.radius
  if ball.y > y_pad_ball_collision then
    local dist = math.abs(pad.x - ball.x)
    if dist < pad.width / 2 then
      ball.y_speed = ball.y_speed * -1
      ball.y = y_pad_ball_collision
      play_sound('rebound')
    end
  end
  
end

function love.draw()
  -- stage
  local block_x, block_y = 0, 0
  for row = 1, 6 do
    block_x = 0
    for column = 1, 15 do
      if stage[row][column] == 1 then 
        love.graphics.rectangle('fill', block_x, block_y, block.width - 1, block.height - 1)
      end
      block_x = block_x + block.width
    end
    block_y = block_y + block.height
  end
  
  -- pad
  love.graphics.rectangle('fill', pad.x  - pad.width / 2, pad.y, pad.width, pad.height)
  
  -- ball
  love.graphics.circle('fill', ball.x, ball.y, ball.radius)
end

function love.keypressed(key)
  print(key)
end

function love.mousepressed(x, y, n)
  if ball.isOnPad then
    ball.isOnPad = false
    ball.x_speed = 200
    ball.y_speed = -200
  end
end

function init_game()
  ball.isOnPad = true
  
  stage = {}
  for row = 1, 6 do
      stage[row] = {}
    for column = 1, 15 do
      stage[row][column] = 1
    end
  end

end
