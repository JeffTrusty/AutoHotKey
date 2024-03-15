#Requires Autohotkey v2.0+

Classes := [] ; for Find
Borders := []
loop 4
	Borders.Push(g := Gui('-Caption +ToolWindow +AlwaysOnTop')), g.BackColor := "Red"

ImageList := CreateImageList()
Width:=85,XPos:=115,WinHeight:=180
; Main Gui
sGui := Gui("+AlwaysOnTop",AppName)
sGui.OnEvent('close',(*)=>ExitApp())

; Crosshair watch
watch := sGui.AddPicture('x10 y12 w31 h28',Bitmap1)
watch.OnEvent('click',FindToolHandler)
sGui.AddText('x48 y10',"Drag the Finder Tool over a window to select it.`nThen release the mouse")

; disbaled handle
;sGui.AddText('x28 y+20 w' Width ' h23 +0x202',"Handle:")
;sGui.AddEdit('vEdtHandle ReadOnly x' XPos ' yp w356 h21')

sGui.AddText('vTxtText x28 w' Width ' h21 +0x202', "Text:")
sGui.AddEdit('vEdtText x' XPos ' yp w290 h21')
sGui.AddButton('vBtnSetText x412 yp-1 w60 h23',"&Set Text").OnEvent('click',SetText)
sGui.AddText('x28 w' Width ' +0x202', "Parent Window:")
sGui.AddEdit('vEdtClass x' XPos ' y150 w356 r3 ReadOnly yp -Wrap') ; -E0x200 ReadOnly ;This should show parent window
sGui.AddText('x28 w' Width ' h21 +0x202','ClassNN/Control:')
sGui.AddEdit('vEdtClassNN x' XPos ' yp w356 h21 ReadOnly') ; -E0x200 ReadOnly ;
sGui.AddButton('x' XPos ' w84 h24', '&Find...').OnEvent('click',ShowFindDlg)
sGui.AddButton('x' XPos+90 ' yp w84 h24 vTreeVis', '&Tree...').OnEvent('click',TreeVis)
sGui.AddText('x+m yp+4 w150 vAdmincheck cRed')

; Tree View
TV := sGui.AddTreeView('xm w460 h250 ImageList' ImageList ' AltSubmit')
TV.OnEvent('click',ShowItem)
sGui.AddButton(, '&Refresh All').OnEvent('click',ShowTree)

px := IniRead(IniFile,'Settings','x','Center')
px := IniRead(IniFile,'Settings','y','Center')
sGui.Show('h' WinHeight)


; Find Gui
fGui := Gui('+AlwaysOnTop +Owner' sGui.hwnd,'Find Window' )
fGui.OnEvent('close',(*) => sGui.Opt('-Disabled'))
fGui.SetFont('s9','Segoe UI')
fGui.BackColor := 'white'
fGui.AddText('x15 y16 w81 h23 +0x200', 'Text or Title:')
fGui.AddEdit('vEdtFindByText x144 y17 w286 h21').OnEvent('change',FindWindow)
fGui.AddCheckbox('vChkFindRegEx x441 y16 w120 h23', 'Regular Expression').OnEvent('click',FindWindow)
fgui.AddText('x15 y54 w79 h23 +0x200', 'Class Name:')
fGui.AddComboBox('vCbxFindByClass x144 y54 w286').OnEvent('change',FindWindow)
fGui.AddText('x15 y93 w110 h23 +0x200', 'Process ID or Name:')
fGui.AddComboBox('vCbxFindByProcess x144 y93 w286').OnEvent('change',FindWindow)

; List View for Find Gui
flv := fGui.AddListView('x10 y130 w554 h185 +LV0x14000', ['hWnd','Class','Text','Process'])
flv.OnEvent('DoubleClick',FindListHandler)
flv.ModifyCol(1, 0)
flv.ModifyCol(2, 133)
flv.ModifyCol(3, 285)
flv.ModifyCol(4, 112)
fGui.AddText('x0 y329 w578 h50 +Border -Background')
fGui.AddButton('vfOKBtn x381 y342 w88 h25 Default +disabled', 'OK').OnEvent('click',FindOK)
fGui.AddButton('x477 y342 w88 h25', 'Cancel').OnEvent('click',FindClose)



; MouseMove(*)
; {
; 	Global Moving
; 	Moving := 1
; 	intiBorder('Flash')
; }
