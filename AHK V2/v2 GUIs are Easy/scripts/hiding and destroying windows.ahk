#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('+Resize', 'Main window')

main.Show('w600 h300')
return

F1::main.hide()
F2::main.show()
F3::main.destroy()