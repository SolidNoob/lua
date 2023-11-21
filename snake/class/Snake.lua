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
        direction = direction,
        nextDirection = nextDirection,
        xTarget = 0,
        yTarget = 0,
        targetReached = false
      }
    }
  }
  setmetatable(instance, {__index = Snake})
  
  return instance
end

function Snake:addElement(dt)
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
  for n=#self.elements, 1, -1 do
    if n == 1 then
      local head = self.elements[1]
      local currentXCell = math.floor(head.x / head.width) + 1
      local currentYCell = math.floor(head.y / head.height) + 1
      print(head.x, head.xTarget, head.y, head.yTarget, currentXCell, currentYCell, head.direction, head.nextDirection)
      if head.direction == 'UP' then
        head.yTarget = head.height * (currentYCell - 1)
        head.y = head.y - head.height * dt * self.speed * 10
        if head.y <= head.yTarget then
          head.targetReached = true
          if head.direction ~= head.nextDirection then
            head.y = head.yTarget
          end
          head.direction = head.nextDirection
        end
      elseif head.direction == 'DOWN' then
        head.yTarget = head.height * (currentYCell + 0)
        head.y = head.y + head.height * dt * self.speed * 10
        if head.y >= head.yTarget then
          head.targetReached = true
          if head.direction ~= head.nextDirection then
            head.y = head.yTarget
          end
          head.direction = head.nextDirection
        end
      elseif head.direction == 'RIGHT' then
        head.xTarget = head.width * (currentXCell + 0)
        head.x = head.x + head.width * dt * self.speed * 10
        if head.x >= head.xTarget then
          head.targetReached = true
          if head.direction ~= head.nextDirection then
            head.x = head.xTarget
          end
          head.direction = head.nextDirection
        end
      elseif head.direction == 'LEFT' then
        head.xTarget = head.width * (currentXCell - 1)
        head.x = head.x - head.width * dt * self.speed * 10
        if head.x <= head.xTarget then
          head.targetReached = true
          if head.direction ~= head.nextDirection then
            head.x = head.xTarget
          end
          head.direction = head.nextDirection
        end
      end
    else
      --[[ 
      --self.elements[n].x = self.elements[n-1].x
      --self.elements[n].y = self.elements[n-1].y
      --self.elements[n].direction = self.elements[n-1].direction
      if self.elements[n].direction == 'UP' then
        self.elements[n].y = self.elements[n-1].y - self.elements[n].height * dt * self.speed * 10
      elseif self.elements[n].direction == 'DOWN' then
        self.elements[n].y = self.elements[n-1].y + self.elements[n].height * dt * self.speed * 10
      elseif self.elements[n].direction == 'RIGHT' then
        self.elements[n].x = self.elements[n-1].x + self.elements[n].width * dt * self.speed * 10
      elseif self.elements[n].direction == 'LEFT' then
        self.elements[n].x = self.elements[n-1].x - self.elements[n].width * dt * self.speed * 10
      end
      --]]
    end
  end
end

return Snake