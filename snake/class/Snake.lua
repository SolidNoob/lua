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
        previousX = 0,
        previousY = 0,
        nextX = 0,
        nextY = 0,
        width = width,
        height = height,
        direction = direction,
        previousDirection = direction,
        nextDirection = direction,
        xTarget = 0,
        yTarget = 0,
        currentXCell = 0,
        currentYCell = 0,
        previousXCell = 0,
        previousYCell = 0,
        nextXCell = 0,
        nextYCell = 0,
        moveDistanceX = 0,
        moveDistanceX = 0,
        previousMoveDistanceX = 0,
        previousMoveDistanceY = 0
      }
    }
  }
  setmetatable(instance, {__index = Snake})
  
  return instance
end

function Snake:addElement(dt)
  local lastElement = self.elements[#self.elements]
  local newElement = {
    x = math.floor(lastElement.x / lastElement.width) * lastElement.width,
    y = math.floor(lastElement.y / lastElement.height) * lastElement.height,
    width = lastElement.width,
    height = lastElement.height,
    direction = lastElement.direction
  }
  
  --[[
  local lastElementXCell = math.floor(lastElement.x / lastElement.width) + 1
  local lastElementYCell = math.floor(lastElement.y / lastElement.height) + 1
  if newElement.direction == 'UP' then
    newElement.y = lastElement.height * (lastElementYCell + 1)
  elseif newElement.direction == 'DOWN' then
    newElement.y = lastElement.height * (lastElementYCell - 1)
  elseif newElement.direction == 'RIGHT' then
    newElement.x = lastElement.width * (lastElementXCell - 1)
  elseif newElement.direction == 'LEFT' then
    newElement.x = lastElement.width * (lastElementXCell + 1)
  end
  ]]--
  
  table.insert(self.elements, newElement)
  
  --[[
  for n=1,#self.elements do
    local currentElement = self.elements[n]
    print (n, currentElement.x, currentElement.y, currentElement.direction)
  end
  ]]--
end

function Snake:move(dt)
  local head = self.elements[1]
  for n=1,#self.elements do
    self.elements[n].previousX = self.elements[n].x
    self.elements[n].previousY = self.elements[n].y
    self.elements[n].previousMoveDistanceX = self.elements[n].moveDistanceX
    self.elements[n].previousMoveDistanceY = self.elements[n].moveDistanceY
    if n == 1 then
      head.previousXCell = head.currentXCell
      head.previousYCell = head.currentYCell
      head.currentXCell = math.floor(head.x / head.width) + 1
      head.currentYCell = math.floor(head.y / head.height) + 1
      --print(head.x, head.xTarget, head.y, head.yTarget, currentXCell, currentYCell, head.direction, head.nextDirection)
      if head.direction == 'UP' then
        head.yTarget = head.height * (head.currentYCell - 1)
        head.y = head.y - head.height * dt * self.speed * 10
        head.moveDistanceY = 0 - head.height * dt * self.speed * 10
        head.moveDistanceX = 0
        head.nextX = head.x
        head.nextY = head.y - head.height * dt * self.speed * 10
        if head.y <= head.yTarget then
          if head.direction ~= head.nextDirection then
            head.y = head.yTarget
          end
            head.previousDirection = head.direction
          head.direction = head.nextDirection
        end
      elseif head.direction == 'DOWN' then
        head.yTarget = head.height * (head.currentYCell + 0)
        head.y = head.y + head.height * dt * self.speed * 10
        head.moveDistanceY = 0 + head.height * dt * self.speed * 10
        head.moveDistanceX = 0
        head.nextX = head.x
        head.nextY = head.y + head.height * dt * self.speed * 10
        if head.y >= head.yTarget then
          if head.direction ~= head.nextDirection then
            head.y = head.yTarget
          end
            head.previousDirection = head.direction
          head.direction = head.nextDirection
        end
      elseif head.direction == 'RIGHT' then
        head.xTarget = head.width * (head.currentXCell + 0)
        head.x = head.x + head.width * dt * self.speed * 10
        head.moveDistanceY = 0
        head.moveDistanceX = 0 + head.width * dt * self.speed * 10
        head.nextY = head.y
        head.nextX = head.x + head.width * dt * self.speed * 10
        if head.x >= head.xTarget then
          if head.direction ~= head.nextDirection then
            head.x = head.xTarget
          end
            head.previousDirection = head.direction
          head.direction = head.nextDirection
        end
      elseif head.direction == 'LEFT' then
        head.xTarget = head.width * (head.currentXCell - 1)
        head.x = head.x - head.width * dt * self.speed * 10
        head.moveDistanceY = 0
        head.moveDistanceX = 0 - head.width * dt * self.speed * 10
        head.nextY = head.y
        head.nextX = head.x - head.width * dt * self.speed * 10
        if head.x <= head.xTarget then
          if head.direction ~= head.nextDirection then
            head.x = head.xTarget
          end
            head.previousDirection = head.direction
          head.direction = head.nextDirection
        end
      end
      head.nextXCell = math.floor(head.nextX / head.width) + 1
      head.nextYCell = math.floor(head.nextY / head.height) + 1
    else
      self.elements[n].x = self.elements[n].x + self.elements[n-1].previousMoveDistanceX
      self.elements[n].y = self.elements[n].y + self.elements[n-1].previousMoveDistanceY
      
      --[[
      if self.elements[n-1].previousDirection == 'UP' then
        self.elements[n].x = self.elements[n-1].previousX
        self.elements[n].y = self.elements[n-1].previousY + self.elements[n].height
      elseif self.elements[n-1].previousDirection == 'DOWN' then
        self.elements[n].x = self.elements[n-1].previousX
        self.elements[n].y = self.elements[n-1].previousY - self.elements[n].height
      elseif self.elements[n-1].previousDirection == 'RIGHT' then
        self.elements[n].x = self.elements[n-1].previousX - self.elements[n].width
        self.elements[n].y = self.elements[n-1].previousY
      elseif self.elements[n-1].previousDirection == 'LEFT' then
        self.elements[n].x = self.elements[n-1].previousX + self.elements[n].width
        self.elements[n].y = self.elements[n-1].previousY
      end
      self.elements[n].direction = self.elements[n-1].previousDirection
      --]]
      
      
      --[[
      self.elements[n].x = self.elements[n-1].previousX
      self.elements[n].y = self.elements[n-1].previousY
      self.elements[n].direction = self.elements[n-1].direction
      --]]
      
      
      --[[
      if self.elements[n-1].previousDirection == 'UP' then
        self.elements[n].x = self.elements[n-1].x
        self.elements[n].y = (self.elements[n-1].currentYCell - 1) * self.elements[n-1].height
      elseif self.elements[n-1].previousDirection == 'DOWN' then
        self.elements[n].x = self.elements[n-1].x
        self.elements[n].y = (self.elements[n-1].currentYCell + 1) * self.elements[n-1].height
      elseif self.elements[n-1].previousDirection == 'RIGHT' then
        self.elements[n].x = (self.elements[n-1].currentXCell - 1) * self.elements[n-1].width
        self.elements[n].y = self.elements[n-1].y
      elseif self.elements[n-1].previousDirection == 'LEFT' then
        self.elements[n].x = (self.elements[n-1].currentXCell + 1) * self.elements[n-1].width
        self.elements[n].y = self.elements[n-1].y
      end
      self.elements[n].direction = self.elements[n-1].previousDirection
        --]]
      
      --[[
      local previousXCell = math.floor(self.elements[n-1].x / self.elements[n-1].width) + 1
      local previousYCell = math.floor(self.elements[n-1].y / self.elements[n-1].height) + 1
      local currentXCell = math.floor(self.elements[n].x / self.elements[n].width) + 1
      local currentYCell = math.floor(self.elements[n].y / self.elements[n].height) + 1
      
     if previousXCell ~= currentXCell then
     self.elements[n].x = self.elements[n-1].x
     end
     if previousYCell ~= currentYCell then
     self.elements[n].y = self.elements[n-1].y
     end
     self.elements[n].direction = self.elements[n-1].direction
        --]]
        
      
       --[[
      if self.elements[n-1].direction == 'UP' then
        self.elements[n].y = self.elements[n-1].y + self.elements[n].height
        self.elements[n].x = self.elements[n-1].x
      elseif self.elements[n-1].direction == 'DOWN' then
        self.elements[n].y = self.elements[n-1].y - self.elements[n].height
        self.elements[n].x = self.elements[n-1].x
      elseif self.elements[n-1].direction == 'RIGHT' then
        self.elements[n].x = self.elements[n-1].x - self.elements[n].width
        self.elements[n].y = self.elements[n-1].y
      elseif self.elements[n-1].direction == 'LEFT' then
        self.elements[n].x = self.elements[n-1].x + self.elements[n].width
        self.elements[n].y = self.elements[n-1].y
      end
       self.elements[n].direction = self.elements[n-1].direction
      --]]
      
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

function Snake:selfCollision()
  local nbElement = #self.elements
  local head = self.elements[1]
  if nbElement > 1 then
    for n=2,nbElement do
      local currentElement = self.elements[n]
          
      if head.direction == 'UP' then
        if head.x >= currentElement.x and head.x < currentElement.x + currentElement.width and head.y <= currentElement.y + currentElement.height and head.y >= currentElement.y then
          return true
        end
      elseif head.direction == 'DOWN' then
        if head.x >= currentElement.x and head.x < currentElement.x + currentElement.width and head.y + head.height >= currentElement.y and head.y <= currentElement.y + currentElement.height then
          return true
        end
      elseif head.direction == 'RIGHT' then
        if head.x + head.width >= currentElement.x and head.x <= currentElement.x + currentElement.width and head.y >= currentElement.y and head.y < currentElement.y + currentElement.height then
          return true
        end
      elseif head.direction == 'LEFT' then
        if head.x <= currentElement.x + currentElement.width and head.x + head.width > currentElement.x and head.y >= currentElement.y and head.y < currentElement.y + currentElement.height then
          return true
        end
      end
    end
  end
  return false
end

return Snake