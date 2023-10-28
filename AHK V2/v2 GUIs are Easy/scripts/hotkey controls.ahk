#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.addEdit('vUserName w150 r1', 'Isaias Baez')
main.addEdit('vLogin w150 r1 Number', '')
main.addEdit('vPassword w150 r1 Password', '')

main.addHotkey('vHotkeyVal w150 r1', '^a')
main.Show()

msgbox main['HotkeyVal'].value
return