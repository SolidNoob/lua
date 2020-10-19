function process(number1, operation, number2)
  if operation == '+' then
    return number1 + number2
  elseif operation == '-' then
    return number1 - number2
  elseif operation == '/' then
    return number1 / number2
  elseif operation == '*' then
    return number1 * number2
  end
end

local number = 0
number = process(2, "*", 9)
print(number)
number = process(2, "+", -2)
print(number)
number = process(2, "-", -4)
print(number)
number = process(2, "/", 0)
print(number)