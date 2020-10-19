colors = {'green', 'blue', 'red', 'yellow', 'orange', 'black', 'pink'}
table.insert(colors, 'purple')
print(#colors)

for i = 1, #colors do 
  print(colors[i])
end

colors.title = 'My colors'
for key, color in pairs(colors) do
  print(key, color)
end


local rows = {}
rows[1] = {}
rows[1][1] = 'A'
rows[1][2] = 'B'
rows[2] = {}
rows[2][1] = 'C'
rows[2][2] = 'D'

for keyRow, row in pairs(rows) do
    for keyCol, col in pairs(rows[keyRow]) do
      print(keyRow, keyCol, rows[keyRow][keyCol])
    end
end

for i = 1, #rows do 
  for j = 1, #rows[1] do
      print(i, j, rows[i][j])
  end 
end