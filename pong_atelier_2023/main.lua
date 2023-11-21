pad_l = {
  x = 10,
  y = 10,
  width = 10,
  height = 80,
  speed = 10,
  score = 0
}

pad_r = {
  x = 0,
  y = 0,
  width = 10,
  height = 80,
  speed = 10,
  score = 0
}

ball = {
  x = 0,
  y = 0,
  width = 20,
  height = 20,
  speed_x = 5,
  speed_y = 5,
  initial_speed_x = 0,
  initial_speed_y = 0
}

trailList = {}

function love.load()
  local font = love.graphics.newFont("assets/fonts/PixelMaster.ttf", 40)
  love.graphics.setFont(font)
  
  soundRebound = love.audio.newSource("assets/sounds/rebound.wav", "static")
  soundLost = love.audio.newSource("assets/sounds/lost.wav", "static")
  
  ball.initial_speed_x = ball.speed_x
  ball.initial_speed_y = ball.speed_y
  resetBall()
  resetPads()
end

function love.update(deltatime)
  handleInputs()
  handleTrail(deltatime)
  moveBall()
end

function love.draw()
  love.graphics.rectangle("fill", pad_l.x, pad_l.y, pad_l.width, pad_l.height)
  love.graphics.rectangle("fill", pad_r.x, pad_r.y, pad_l.width, pad_l.height)
  drawTrail()
  love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
  
  local font = love.graphics.getFont()
  local score = pad_l.score.."   "..pad_r.score
	local score_width = font:getWidth(score)
  love.graphics.print(score, (love.graphics.getWidth() / 2) - (score_width / 2), 5)
end

function handleTrail(deltatime)
  for n = #trailList, 1, -1 do
    local trailItem = trailList[n]
    trailItem.lifespan = trailItem.lifespan - deltatime
    trailItem.x = trailItem.x + trailItem.velocity_x
    trailItem.y = trailItem.y + trailItem.velocity_y
    if trailItem.lifespan <= 0 then
      table.remove(trailList, n)
    end
  end
  
  table.insert(trailList, {
    x = ball.x,
    y = ball.y,
    velocity_x = math.random(-1, 1),
    velocity_y = math.random(-1, 1),
    r = math.random(-1, 1),
    v = math.random(-1, 1),
    b = math.random(-1, 1),
    lifespan = 1
  })
end

function drawTrail()
  for n=1,#trailList do
    local trailItem = trailList[n]
    love.graphics.setColor(0.5, 0.5, 0.5, trailItem.lifespan / 2)
    love.graphics.rectangle("fill", trailItem.x, trailItem.y, ball.width, ball.height)
    
    -- love.graphics.setColor(trailItem.r, trailItem.v, trailItem.b, trailItem.lifespan / 2)
    -- love.graphics.rectangle("line", trailItem.x, trailItem.y, ball.width, ball.height)
    
    -- love.graphics.setColor(1, 1, 1, trailItem.lifespan / 2)
    -- love.graphics.circle("fill", trailItem.x, trailItem.y, 5)
  end
    love.graphics.setColor(1, 1, 1, 1)
end

function resetBall()   
  ball.speed_x = ball.initial_speed_x
  ball.speed_y = ball.initial_speed_y
  ball.x = love.graphics.getWidth() / 2 - ball.width / 2
  ball.y = love.graphics.getHeight() / 2 - ball.height / 2
  trailList = {} 
end

function resetPads()
  pad_l.x = 0
  pad_l.y = love.graphics.getHeight() / 2 - pad_l.height / 2
  pad_r.x = love.graphics.getWidth() - pad_r.width
  pad_r.y = love.graphics.getHeight() / 2 - pad_r.height / 2
end

function moveBall()
  if ball.x >= love.graphics.getWidth() - ball.width then
    -- ball.speed_x = ball.speed_x * -1
    local clone = soundLost:clone()
    clone:play()
    resetBall()
    pad_l.score = pad_l.score + 1
  end
  if ball.x <= 0 then 
    -- ball.speed_x = ball.speed_x * -1
    local clone = soundLost:clone()
    clone:play()
    resetBall()
    pad_r.score = pad_r.score + 1
  end
  
  ball.x = ball.x + ball.speed_x
  
  if ball.y >= love.graphics.getHeight() - ball.height then
    ball.speed_y = ball.speed_y * -1
  end
  if ball.y <= 0 then
    ball.speed_y = ball.speed_y * -1
  end
  ball.y = ball.y + ball.speed_y
  
  local isCollision = false
  if ball.x <= pad_l.x + pad_l.width then 
    if ball.y + ball.height > pad_l.y and ball.y < pad_l.y + pad_l.height then 
      isCollision = 'left'
      ball.speed_x = ball.speed_x * -1
      ball.x = pad_l.x + pad_l.width + 1 -- padding
    end
  end
  
   if ball.x + ball.width >= pad_r.x then 
    if ball.y + ball.height > pad_r.y and ball.y < pad_r.y + pad_r.height then 
      isCollision = 'right'
      ball.speed_x = ball.speed_x * -1
      ball.x = pad_r.x - ball.width - 1 -- padding
    end
  end
  
  if isCollision ~= false then 
    love.audio.play(soundRebound)
    if ball.speed_x < 0 then 
      ball.speed_x = ball.speed_x - 2
    else
      ball.speed_x = ball.speed_x + 2
    end
   --[=====[
    if isCollision == 'left' then
      pad_l.height = pad_l.height - 20
    else 
      pad_r.height = pad_r.height - 20
    end
    --]=====]
  end
end

function handleInputs()
  if love.keyboard.isDown('x') then
    pad_l.y = pad_l.y + pad_l.speed
    if pad_l.y + pad_l.height + pad_l.speed > love.graphics.getHeight() then 
      pad_l.y = love.graphics.getHeight() - pad_l.height 
    end
  end
  
  if love.keyboard.isDown('s') then
    pad_l.y = pad_l.y - pad_l.speed
    if pad_l.y < 0 then pad_l.y = 0 end
  end
  
  if love.keyboard.isDown('down') then
    pad_r.y = pad_r.y + pad_r.speed
    if pad_r.y + pad_r.height + pad_r.speed > love.graphics.getHeight() then 
      pad_r.y = love.graphics.getHeight() - pad_r.height 
    end
  end
  
  if love.keyboard.isDown('up') then
    pad_r.y = pad_r.y - pad_r.speed
    if pad_r.y < 0 then pad_r.y = 0 end
  end
  
  if love.keyboard.isDown('escape') then
    resetBall()
    resetPads()
  end
   --[=====[ 
  if love.keyboard.isDown('w') then
    pad_l.x = pad_l.x - pad_l.speed
    if pad_l.x < 0 then pad_l.x = 0 end 
  end
  
  if love.keyboard.isDown('c') then
    pad_l.x = pad_l.x + pad_l.speed
    if pad_l.x >= love.graphics.getWidth() - pad_l.width then 
      pad_l.x = love.graphics.getWidth() - pad_l.width 
    end
  end
    --]=====]
end




























































