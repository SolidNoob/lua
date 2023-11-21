local Snake = {}

function Snake:new(x, y, width, height, speed, direction)
  local instance = {
    --x = x,
    --y = y,
    speed = speed,
    elements = {
      {
        x = x,
        y = y,
        width = width,
        height = height,
        direction = direction
      }
    }
  }
  setmetatable(instance, {__index = Snake})
  
  return instance
end

function Snake:addElement()
  local lastElement = self.elements[#self.elements]
  local newElement = {
    x = lastElement.x,
    y = lastElement.y,
    width = lastElement.width,
    height = lastElement.height,
    direction = lastElement.direction
  }
  if newElement.direction == 'UP' then
    newElement.y = newElement.y - newElement.height
  elseif newElement.direction == 'DOWN' then
    newElement.y = newElement.y + newElement.height
  elseif newElement.direction == 'RIGHT' then
    newElement.x = newElement.x - newElement.width
  elseif newElement.direction == 'LEFT' then
    newElement.x = newElement.x + newElement.width
  end
  table.insert(self.elements, newElement)
  for n=1,#self.elements do
    local currentElement = self.elements[n]
    print (n, currentElement.x, currentElement.y, currentElement.direction)
  end
end

function Snake:move(dt)
  for n=1,#self.elements do
    local currentElement = self.elements[n]
      if currentElement.direction == 'UP' then
        currentElement.y = currentElement.y - self.speed * dt
      elseif currentElement.direction == 'DOWN' then
        currentElement.y = currentElement.y + self.speed * dt
      elseif currentElement.direction == 'RIGHT' then
        currentElement.x = currentElement.x + self.speed * dt
      elseif currentElement.direction == 'LEFT' then
        currentElement.x = currentElement.x - self.speed * dt
      end
      
      if n > 1 then
        currentElement.direction = self.elements[n - 1].direction
      end
  end
end

return Snake