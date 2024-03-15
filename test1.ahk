#Requires AutoHotKey v2.0

; Arrays are index driven
colors := ['red', 'blue', 'green']
for each, color in colors ; in arrays, the for loop doesn't require the index (each)
{
  msgbox color
}
; Maps are key driven
colorMap := Map(
  'red', 123
  'blue', 456
  'green', 789
)
for key, value in colorMap
{
  msgbox key ' ' value
}

