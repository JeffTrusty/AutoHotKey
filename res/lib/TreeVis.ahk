#Requires Autohotkey v2.0+
TreeVis(*){
	static Size:=1
	if((Size:=!Size))
		sGui.Show('h' WinHeight)
	else{
		sGui.Show('AutoSize')
		;ControlFocus,SysTreeView321,%ID%
	}
}