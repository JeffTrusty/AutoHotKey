#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
tv := main.addTreeView('w150 r10')

pID := tv.add('Main')
tv.add('Second', pID)
tv.add('Third', pID)
main.Show()
return