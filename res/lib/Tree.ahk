#Requires Autohotkey v2.0+
Tree(hParentWnd, ParentID) {
	;WinGet WinList, ControlListHwnd, ahk_id %hParentWnd%
	WinList := WinGetControlsHwnd('ahk_id ' hParentWnd)
	;Loop Parse, WinList, `n
	for Hwnd in WinList
	{
		If (GetParent(Hwnd) != hParentWnd) {
			Continue
		}
		
		Class := WinGetClass( 'ahk_id ' Hwnd )
		If (IsChild(Hwnd)) {
			Text := ControlGetText(Hwnd)
		} Else {
			Text := WinGetTitle('ahk_id ' Hwnd)
		}
		Text:=StrLen(Text)>50?SubStr(Text,1,50) "..":Text
		
		If (Text != "") {
			Text := " - " . Text
		}
		
		Invisible := !IsWindowVisible(Hwnd)
		
		If (!g_TreeShowAll && Invisible) {
			Continue
		}
		
		If (Invisible) {
			Text .= " (hidden)"
		}
		Icon:=GetWindowIcon(Hwnd,Class)
		TreeIDs[(P1:=TV.Add(Class Text,ParentID,"Icon" Icon))] := Hwnd
		Tree(Hwnd,P1)
	}
}