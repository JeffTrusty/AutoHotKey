#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.addGroupBox('w300 r2.4', 'Settings')
main.addCheckBox('xp+10 yp+20', 'Start with Windows')
main.addCheckBox('', 'Hide Main Window')
main.addButton('xm w75', 'OK')
main.Show()
return