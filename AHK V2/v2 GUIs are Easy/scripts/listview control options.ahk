#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
lv := main.AddListView('w600 r10 Grid Checked', ['File Name', 'File Path', 'File Size'])

loop 10
	lv.Add('', 'Name' a_index, 'Path' a_index, 'Size' a_index)

main.Show()
return