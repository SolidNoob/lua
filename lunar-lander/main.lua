io.stdout:setvbuf('no')

local spaceship = {
  x = 0,
  y = 0,
  angle = 270,
  speed = 3,
  vx = 0,
  vy = 0,
  sprite = love.graphics.newImage('images/ship.png'),
  engineSprite = love.graphics.newImage('images/engine.png'),
  engineOn = false
}

function love.load()
  windowWidth = love.graphics.getWidth()
  windowHeight = love.graphics.getHeight()
  
  spaceship.x = windowWidth / 2
  spaceship.y = windowHeight / 2
end

function love.update(dt)
  
  if love.keyboard.isDown('left') then
    spaceship.angle = spaceship.angle - (90 * dt)
    if spaceship.angle < 0 then
      spaceship.angle = 360
    end
  end
  if love.keyboard.isDown('right') then
    spaceship.angle = spaceship.angle + (90 * dt)
    if spaceship.angle > 360 then
      spaceship.angle = 0
    end
  end
  
  spaceship.engineOn = love.keyboard.isDown('space')
  if spaceship.engineOn then
    local strengthX = math.cos(math.rad(spaceship.angle)) * spaceship.speed * dt
    local strengthY = math.sin(math.rad(spaceship.angle)) * spaceship.speed * dt
    spaceship.vx = spaceship.vx + strengthX
    spaceship.vy = spaceship.vy + strengthY
  end
  
  
  spaceship.vy = spaceship.vy + 0.6 * dt
  if math.abs(spaceship.vx) > 1 then
    if spaceship.vx > 0 then 
      spaceship.vx = 1
    else
      spaceship.vx = -1
    end
  end
  if math.abs(spaceship.vy) > 1 then
    if spaceship.vy > 0 then 
      spaceship.vy = 1
    else
      spaceship.vy = -1
    end
  end
  
  spaceship.x = spaceship.x + spaceship.vx
  spaceship.y = spaceship.y + spaceship.vy
  
  if spaceship.y >= (windowHeight - spaceship.sprite:getHeight() / 2) then
    spaceship.y = windowHeight - spaceship.sprite:getHeight() / 2
  end  
end


function love.draw()
  love.graphics.draw(spaceship.sprite, spaceship.x, spaceship.y, math.rad(spaceship.angle), 1, 1, spaceship.sprite:getWidth() / 2, spaceship.sprite:getHeight() / 2)
  if spaceship.engineOn then
    love.graphics.draw(spaceship.engineSprite, spaceship.x, spaceship.y, math.rad(spaceship.angle), 1, 1, spaceship.engineSprite:getWidth() / 2, spaceship.engineSprite:getHeight() / 2)
  end
  
  local sDebug = "Debug:"
  sDebug = sDebug.."angle = "..tostring(spaceship.angle)
  sDebug = sDebug.."vx = "..tostring(spaceship.vx)
  sDebug = sDebug.."vy = "..tostring(spaceship.vy)
  love.graphics.print(sDebug, 0, 0)
end
