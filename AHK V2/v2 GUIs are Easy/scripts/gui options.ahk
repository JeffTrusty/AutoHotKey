#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('+Resize', 'Main window')
preferences := Gui('+ToolWindow +AlwaysOnTop', 'Preferences')

main.Show('w600 h300')
preferences.show('w200 h400')