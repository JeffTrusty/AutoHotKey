
iniFile := A_Desktop '\settings.ini'

x := IniRead(iniFile, 'Settings', 'x', 0)
y := IniRead(iniFile, 'Settings', 'y', 0)
w := IniRead(iniFile, 'Settings', 'w', 300)
h := IniRead(iniFile, 'Settings', 'h', 200)

main := Gui('+Resize')
main.OnEvent('Size', SaveSettings)
main.Show('w' w ' h' h ' x' x ' y' y)

OnMessage(WM_MOVE := 0x0003, SaveSettings)
return

SaveSettings(*)
{
  main.GetPos(&x, &y, &w, &h)

  IniWrite(x, iniFile, 'Settings', 'x')
  IniWrite(y, iniFile, 'Settings', 'y')
  IniWrite(w, iniFile, 'Settings', 'w')
  IniWrite(h, iniFile, 'Settings', 'h')
}
