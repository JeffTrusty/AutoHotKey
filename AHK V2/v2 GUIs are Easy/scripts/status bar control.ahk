#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
sb := main.addStatusBar('', '`t0 Rows Selected')
sb.setParts(100, 100)
sb.SetText('`t0 Rows in view', 2)
sb.SetText('`t`t1.0.9', 3)

main.Show('w600 h400')
return