#Requires Autohotkey v2.0+
ShowTree(*){
	TV.Delete()
	RootID:=TV.Add("Desktop",0,"Icon2")
	TreeIDs[RootID]:=DllCall("GetDesktopWindow","Ptr")
	;SplashTextOn,200,100,Getting Windows,Please Wait...
	
	;WinGet WinList, List
	;Loop %WinList% 
	for hwnd in WinGetList()
	{
		Class := WinGetClass('ahk_id ' hWnd)
		Title := WinGetTitle('ahk_id ' hWnd)
		if(Title != ""){
			Title := " - " . Title
		}
		Invisible := !IsWindowVisible(hWnd)
		if(!g_TreeShowAll && Invisible) {
			Continue
		}
		if(Invisible) {
			Title.=" (hidden)"
		}
		Icon:=GetWindowIcon(hWnd,Class,True)
		Text:=Class Title,Text:=StrLen(Text)>40?SubStr(Text,1,40) "...":Text
		TreeIDs[(P1:=TV.Add(Text,RootID,"Icon" Icon))]:=hWnd
		Tree(hWnd,P1)
	}
	TV.Opt('+redraw')
	;GuiControl,+Redraw,SysTreeView321
	;ControlFocus,SysTreeView321,%ID%
	c1 := TV.GetChild(0)
	if C1
		TV.Modify(c1,"Select Vis")
	;SplashTextOff
}