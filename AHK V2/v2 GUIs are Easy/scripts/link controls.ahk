#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.AddLink('', 'This is a control that will open <a href="https://the-Automator.com">the-Automator.com</a>')
main.Show()
return