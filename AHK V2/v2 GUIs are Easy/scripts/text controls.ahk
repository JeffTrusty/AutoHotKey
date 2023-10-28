#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')

main.AddText('vDescription w300', 'Exit code: 0    Time: 25.53')
main.AddText('cBlue w300', 'Exit code:')
main.Show()
return

F1::main['Description'].value := '"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" /ErrorStdOut "D:\Cloud\RaptorX\OneDrive\Desktop\text controls.ahk"'