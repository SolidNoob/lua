local Apple = {}

function Apple:new(x, y, width, height)
  local instance = {
    x = x,
    y = y,
    width = width,
    height = height,
    currentXCell = 0,
    currentYCell = 0
  }
  setmetatable(instance, {__index = Apple})
  return instance
end

function Apple:pop(x, y)
  self.x = x
  self.y = y
  self.currentXCell = math.floor(self.x / self.width) + 1
  self.currentYCell = math.floor(self.y / self.height) + 1
end

return Apple