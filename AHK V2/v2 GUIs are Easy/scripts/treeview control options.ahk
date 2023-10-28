#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
tv := main.addTreeView('w150 r10 -Lines')

pID := tv.add('Main',,'Expand')

loop 10
	tv.add('Child' a_index, pID)

pID := tv.add('Settings',, 'Expand')

loop 10
	tv.add('Child' a_index, pID)

main.Show()
return