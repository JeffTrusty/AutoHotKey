context_menu := Menu()
edit_submenu := Menu()
copy_submenu := Menu()
exit_submenu := Menu()

context_menu.Add('Open', (*)=>Msgbox('Open'))
context_menu.Add('Close', (*)=>Msgbox('Close'))
context_menu.SetIcon("Close", "C:\WINDOWS\system32\compstui.dll", 12)
context_menu.Add()
context_menu.Add('New', (*)=>Msgbox('New'))
context_menu.Add('Exit', (*)=>Msgbox('Exit'))
context_menu.Add()
context_menu.Add('Edit', edit_submenu)
context_menu.Add('Copy', copy_submenu)

edit_submenu.Add('item1', (*)=>Msgbox('item1'))
edit_submenu.Add('item2', (*)=>Msgbox('item2'))
edit_submenu.Add('item3', (*)=>Msgbox('item3'))

copy_submenu.Add('item1', (*)=>Msgbox('item1'))
copy_submenu.Add('item2', (*)=>Msgbox('item2'))
copy_submenu.Add('item3', (*)=>Msgbox('item3'))
copy_submenu.Add()
copy_submenu.Add('Exit', exit_submenu)

exit_submenu.Add('item1', (*)=>Msgbox('item1'))
exit_submenu.Add('item2', (*)=>Msgbox('item2'))
exit_submenu.Add('item3', (*)=>Msgbox('item3'))
return

f1::context_menu.Show()


obj := Json.Load(fileread('menu.json'))

for menu_name, item in obj
  sleep 10

str := Json.Dump(context_menu)
FileAppend str, 'menu.json'
