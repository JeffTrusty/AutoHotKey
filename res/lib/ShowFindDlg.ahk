#Requires Autohotkey v2.0+

ShowFindDlg(*)
{
    sGui.Opt('+Disabled')
    fGui.Show('w574 h377')
	initFindWindow()
}

initFindWindow()
{
	Global Classes
	SetExplorerTheme(fGui.hwnd)
	for hThisWnd in allc := WinGetList()
	{
		WClass := WinGetClass( 'ahk_id ' hThisWnd )
		AddUniqueClass(WClass)
		for control in WinGetControlsHwnd('ahk_id ' hThisWnd)
		{
			CClass := WinGetClass('ahk_id ' control)
			AddUniqueClass(CClass)
		}
	}

	fGui['CbxFindByClass'].Add(Classes)
	;ClassList := ""
	;Loop Classes.Length
	;	 GuiCtrl.Add()
		;ClassList .= Classes[A_Index] . "|"
	;fGui['CbxFindByClass'].text := ClassList

	Processes := []
	For Process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process") {
		If (Process.ProcessID < 10) {
			Continue
		}
		
		Unique := True
		Loop Processes.Length
		{
			If (Process.Name == Processes[A_Index]) {
				Unique := False
				Break
			}
		}
		
		If (Unique) {
			Processes.Push(Process.Name)
		}
	}

	fGui['CbxFindByProcess'].Add(Processes)
	; ProcList := ""
	; MaxItems := Processes.Length()
	; Loop MaxItems
	; ProcList .= Processes[MaxItems - A_Index + 1] . "|"
	; GuiControl,, CbxFindByProcess, %ProcList%

}

AddUniqueClass(ClassName) {
	Unique := True
	Loop Classes.Length
	{
		If (ClassName == Classes[A_Index]) {
			Unique := False
			Break
		}
	}
	
	If (Unique) {
		Classes.Push(ClassName)
	}
}

SetExplorerTheme(hWnd) {
	DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hWnd, "WStr", "Explorer", "Ptr", 0)
}

FindClose(*)
{
    sGui.Opt('-Disabled')
    fGui.Hide()
}

FindListHandler(obj,info) => FindOK()

FindOK(*)
{
	
	hWnd := flv.GetText((row:=flv.GetNext()) ? row : 1)
	; iClass := flv.GetText(row? row : 1,2)
	Ancestor:=GetAncestor(hWnd)

		Title := WinGetTitle( 'ahk_id ' Ancestor)
		wClass := WinGetClass('ahk_id ' Ancestor)
		try Class := ControlGetClassNN(hWnd +0)
		catch
			Class := ''

		Text := ControlGetText(hWnd +0)
		WProcPID := WinGetPID('ahk_id ' hWnd)
		EXE := ProcessGetName(WProcPID)
		
	;GuiControl,, EdtHandle, %hWnd%

	sGui['EdtText'].value := Text
	sGui['EdtClass'].value := Title "`r`nahk_class " wClass "`r`nahk_exe " EXE
	sGui['EdtClassNN'].value := Class
	FindClose()
}


; FindWindow(*)
; {

; }

FindWindow(*)
{
	flv.Opt('-redraw')
	flv.Delete()
	for hThisWnd in WinGetList()
	{
		If (hThisWnd == fGui.hwnd) 
		|| (hThisWnd == sGui.hwnd) 
			Continue
	
		WClass := WinGetClass( 'ahk_id ' hThisWnd )
		WTitle := WinGetTitle( 'ahk_id ' hThisWnd)
		WProcPID := WinGetPID('ahk_id ' hThisWnd)
		try WProcess := ProcessGetName(WProcPID)
		Class := WinGetClass('ahk_id ' hThisWnd)

		If (m := MatchCriteria(WTitle, WClass, type(fGui['CbxFindByProcess'].Text) = 'integer' ? WProcPID : WProcess)) 
		{
			flv.Add("", hThisWnd, WClass, WTitle, WProcess)
		}


		

		for control in WinGetControlsHwnd('ahk_id ' hThisWnd)
		{
			CText := ControlGetText(control)
			CClass := WinGetClass( 'ahk_id ' control)
			CProcPID := WinGetPID('ahk_id ' hThisWnd)
			CProcess := ProcessGetName(CProcPID)
			
			If (m := MatchCriteria(CText, CClass, type(fGui['CbxFindByProcess'].Text) = 'integer' ? CProcPID : CProcess)) {
				flv.Add("", control, CClass, CText, CProcess)
			}
		}
	}
	fGui['fOKBtn'].enabled := (flv.GetCount() > 0 ? true : false)
	flv.Opt('+redraw')
}

MatchCriteria(Text, Class, Process) {
	EdtFindByText := fGui['EdtFindByText'].value
	CbxFindByClass := fGui['CbxFindByClass'].Text
	CbxFindByProcess := fGui['CbxFindByProcess'].Text
	If (EdtFindByText != "") {
		If (fGui['ChkFindRegEx'].value) {
			If (RegExMatch(Text, EdtFindByText) < 1) {
				Return False
			}
		} Else {
			If (!InStr(Text, EdtFindByText)) {
				Return False
			}
		}
	}
	
	If (CbxFindByClass != "" && !InStr(Class, CbxFindByClass)) {
		Return False
	}
	
	If (CbxFindByProcess != "") {
		Return type(Process) ? CbxFindByProcess == Process : InStr(Process, CbxFindByProcess)
	}
	
	Return True
}


/*

FindOK:
Gui ListView, %hFindList%
LV_GetText(hWnd, (row:=LV_GetNext()) ? row : 1)

Gui, %hSpyWnd%:Default
Ancestor:=GetAncestor(hWnd)
WinGetTitle,Title,ahk_id%hWnd%
ControlGetText,Text,,ahk_id%hWnd%
WinGet,EXE,ProcessName,ahk_id%hWnd%
WinGetClass,Class,ahk_id%hWnd%

GuiControl,, EdtHandle, %hWnd%
GuiControl,, EdtText, %Text%
GuiControl,, EdtClass, % "Title " Title "`r`nahk_class " Class "`r`nahk_exe " EXE

WinActivate ahk_id %hSpyWnd%
Gui Find: Hide
Return

FindListHandler:
If (A_GuiEvent == "DoubleClick") {
	GoSub FindOK
}
Return
IsNumber(n) {
	If n Is Number
		Return True
	Return False
}
*/