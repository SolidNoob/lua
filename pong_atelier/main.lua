pad = {}
pad.x = 0
pad.y = 0
pad.width = 20
pad.height = 80
pad.speed = 10

ball = {}
ball.x = 400
ball.y = 300
ball.width = 20
ball.height = 20
ball.speed_x = 5
ball.speed_y = 5

function initBall()
  ball.x = (love.graphics.getWidth() / 2) - (ball.width / 2)
  ball.y = (love.graphics.getHeight() / 2) - (ball.height / 2)
end

function love.load()
  initBall()
end

function love.update()
  if love.keyboard.isDown('down') and pad.y < love.graphics.getHeight() - pad.height then
    pad.y = pad.y + pad.speed
  end
  if love.keyboard.isDown('up') and pad.y > 0 then
    pad.y = pad.y - pad.speed
  end
  --[=====[ 
  if love.keyboard.isDown('right') and pad.x < love.graphics.getWidth() - pad.width then
    pad.x = pad.x + pad.speed
  end
  if love.keyboard.isDown('left') and pad.x > 0 then
    pad.x = pad.x - pad.speed
  end
  --]=====]

  
  ball.x = ball.x + ball.speed_x
  ball.y = ball.y + ball.speed_y
  
  
  if ball.y >= love.graphics.getHeight() - ball.height then 
    ball.speed_y = ball.speed_y * -1
  end 
  if ball.y <= 0 then 
    ball.speed_y = ball.speed_y * -1
  end 
  if ball.x >= love.graphics.getWidth() - ball.width then 
    ball.speed_x = ball.speed_x * -1
  end 
  if ball.x <= 0 then 
    ball.speed_x = ball.speed_x * -1
    initBall()
  end 
  
  
  if ball.x == (pad.x + pad.width) then
    if (ball.y + ball.height) >= pad.y and ball.y <= (pad.y + pad.height) then 
      ball.x = pad.x + pad.width
      ball.speed_x = ball.speed_x * -1
      ball.speed_y = ball.speed_y * -1
    end
  end
  
  
  
  
  
end

function love.draw()
  love.graphics.rectangle('fill', pad.x, pad.y, pad.width, pad.height)
  love.graphics.rectangle('fill', ball.x, ball.y, ball.width, ball.height)
end
