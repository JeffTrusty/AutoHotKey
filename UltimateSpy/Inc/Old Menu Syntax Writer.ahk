#SingleInstance
#Requires Autohotkey v2.0-
;--
;@Ahk2Exe-SetVersion     0.3.0
;@Ahk2Exe-SetMainIcon    res\main.ico
;@Ahk2Exe-SetProductName
;@Ahk2Exe-SetDescription
/**
 * ============================================================================ *
 * @Author   : Lexikos                                                          *
 * @Homepage :                                                                  *
 *                                                                              *
 * @Created  : June 07, 2015                                                    *
 * @Modified : April 28, 2023                                                   *
 * ============================================================================ *
 * Want a clear path for learning AutoHotkey?                                   *
 * Take a look at our AutoHotkey courses here: the-Automator.com/Discover          *
 * They're structured in a way to make learning AHK EASY                        *
 * And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
 * ============================================================================ *
 */

#Include <ScriptObject\ScriptObject>

OnMessage 0x0202, WM_LBUTTONUP

global script := {base         : ScriptObj
                 ,name          : regexreplace(A_ScriptName, '\.\w+')
                 ,version      : '0.2.0'
                 ,author       : 'Lexikos'
                 ,email        : ''
                 ,crtdate      : 'June 07, 2015'
                 ,moddate      : 'April 28, 2023'
                 ,homepagetext : 'Alt Menu Search'
                 ,homepagelink : 'https://www.autohotkey.com/boards/viewtopic.php?f=6&t=8085'
                 ,donateLink   : 'https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6'
                 ,resfolder    : A_ScriptDir '\res'
                 ,iconfile     : A_ScriptDir '\res\sct.ico'
                 ,configfile   : A_ScriptDir '\settings.ini'
                 ,configfolder : A_ScriptDir ''}

if !FileExist(script.configfile)
	IniWrite true, script.configfile, 'General', 'v1CodeSelected'

isWin11 := VerCompare(A_OSVersion, '10.0.22000') < 0 ? false : true
TraySetIcon 'imageres.dll', isWin11 ? 76 : 1

A_TrayMenu.Delete()
A_TrayMenu.Add('About', (*)=> false)
A_TrayMenu.Add()
A_TrayMenu.Add('Edit', (*)=> Edit())
A_TrayMenu.Add('Reload', (*)=> Reload())
A_TrayMenu.Add('Exit', (*)=> ExitApp())

for label,icon in Map('Edit',90,'Reload',230,'Exit',85)
	A_TrayMenu.SetIcon(label, 'imageres.dll', icon)

main := Gui('+Resize +MinSize +MaxSize' A_ScreenWidth 'x')
main.MarginX := main.MarginY := 5
main.width := 500
main.dragging := false

main.SetFont('s11')
main.AddPicture('vWinFinder w-1 h30', 'res\FindTool1.bmp').OnEvent('Click', FindWindow)
main.AddText('vTargetWindow x+m yp+3 h30 w' main.width - 30 - main.MarginX, 'Drag the tool check the target window').SetFont('s13')
main.AddEdit('vQuery xm w' main.width).OnEvent('Change', Filter)
lv := main.AddListView('y+2 w' main.width ' r21 -Hdr', ['Menu ID', 'Menu Name'])
lv.OnEvent('DoubleClick', lvHandler)
lv.ModifyCol(1, 0)

oldSel := IniRead(script.configfile, 'General', 'v1CodeSelected', true)

main.AddRadio('vV1Code Checked' oldSel, 'V1 Code').OnEvent('Click', SaveCodeSelection)
main.AddRadio('vV2Code Checked' (!oldSel) ' x+m', 'V2 Code').OnEvent('Click', SaveCodeSelection)
mainstatus := main.AddStatusBar()

main.show()
return

lvHandler(obj, row)
{
	static WM_COMMAND := 0x0111
	static template   := 'PostMessage 0x111, {1}, 0,,{2}"ahk_id" WinExist("{3}") `; Runs --> {4}'

	if !row
		return

	id := lv.GetText(row, 1)
	path := lv.GetText(row, 2)

	if GetKeyState('Ctrl')
		PostMessage WM_COMMAND, id, 0,, WinExist(main['TargetWindow'].value)
	else
	{
		A_Clipboard := Format(template, id, (main['V1Code'].value ? '% ' : ''), main['TargetWindow'].value, path)
		ToolTip 'Copied to Clipboard:`n' A_Clipboard
		SetTimer (*)=>ToolTip(), -3500
	}
}

GetSubMenu(hMenu, &menuItems, parent:=''){

	static MF_BYPOSITION := 0x00000400

	Loop DllCall('GetMenuItemCount', 'ptr', hMenu)
	{
		itemPos := A_Index-1
		szlpString := DllCall('GetMenuString',
		                      'ptr' , hMenu,            ; [in]            HMENU  hMenu,
		                      'uint', itemPos,          ; [in]            UINT   uIDItem,
		                      'ptr' , 0,                ; [out, optional] LPWSTR lpString,
		                      'int' , 0,                ; [in]            int    cchMax,
		                      'uint', MF_BYPOSITION,    ; [in]            UINT   flags
		                      'int')

		itemString := Buffer(szlpString*2+1) ; account for wide unicode strings and NULL character
		szCopied := DllCall('GetMenuString',
		                    'ptr' , hMenu,            ; [in]            HMENU  hMenu,
		                    'uint', itemPos,          ; [in]            UINT   uIDItem,
		                    'ptr' , itemString.Ptr,   ; [out, optional] LPWSTR lpString,
		                    'int' , itemString.Size,  ; [in]            int    cchMax,
		                    'uint', MF_BYPOSITION,    ; [in]            UINT   flags
		                    'int')
		if !szCopied
			continue


		itemString := StrReplace(StrGet(itemString, 'utf-16'), '&')

		itemID := DllCall('GetMenuItemID', 'ptr', hMenu, 'int', itemPos)
		if itemID = -1
		&& hSubMenu := DllCall('GetSubMenu', 'ptr', hMenu, 'int', itemPos, 'ptr'){
				GetSubMenu(hSubMenu, &menuItems, parent itemString '>')
				continue
		}
		menuItems .= itemID '`t' parent RegExReplace(itemString, '`t.*') '`n'
	}
}

GetMenu(hwnd)
{
	if !hMenu := DllCall('GetMenu', 'ptr', hwnd, 'ptr')
		return ''
	GetSubMenu(hMenu, &test)
	if !IsSet(test)
		return ''
	return Trim(test, '`n')
}

FindWindow(*)
{
	static hCrossHair := LoadPicture('res\CrossHair.cur', 'w32 h32', &OutImageType)

	; this dllcall, allows us to capture the WM_LBUTTONUP message
	; when the mouse leaves our main window
	; https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setcapture
	DllCall('SetCapture','Ptr', main.Hwnd)

	main.oldCursor := DllCall('SetCursor','Ptr', hCrossHair,'Ptr')
	MouseGetPos ,,,&ctrl, 2
	if ctrl != main['WinFinder'].hwnd
		return

	main.dragging := true
	main['WinFinder'].value := 'res\FindTool2.bmp'
}

WM_LBUTTONUP(wParam, lParam, msg, hwnd)
{

	if !main.dragging
		return

	; releases capture set by FindWindow function
	DllCall('ReleaseCapture')
	DllCall('SetCursor','Ptr', main.oldCursor,'Ptr')

	main.dragging := false
	main['WinFinder'].value := 'res\FindTool1.bmp'

	MouseGetPos ,,&winHwnd,&ctrlHwnd, 2
	lv.Delete()
	title := StrSplit(WinGetTitle(winHwnd), ' - ')
	main['TargetWindow'].value := title.Length ? title[title.Length] : 'unknown program'
	mainstatus.SetText(' 0 menu items found.')
	main['TargetWindow'].SetFont('cRed bold')

	if winHwnd = main.hwnd
		return
	else if !main.menu := GetMenu(winHwnd)
	{
		SoundPlay '*16'
		return main['TargetWindow'].value := main['TargetWindow'].value ' doesnt have a Win32 Menu'        ; MsgBox('The selected program doesnt have a Win32 Menu', 'No Menu', 'IconX')
	}

	for item in StrSplit(main.menu, '`n')
		lv.Add('', StrSplit(item, '`t')*)

	main['TargetWindow'].SetFont('cGreen')
	mainstatus.SetText(' ' lv.GetCount() ' menu items found.')
}


Filter(*)
{
	if !main.menu
		return

	lv.Delete()
	for item in StrSplit(main.menu, '`n')
		if item ~= 'i)\Q' main['Query'].value '\E'
			lv.Add('', StrSplit(item, '`t')*)
}

SaveCodeSelection(*) => IniWrite(main['V1Code'].value, script.configfile, 'General', 'v1CodeSelected')