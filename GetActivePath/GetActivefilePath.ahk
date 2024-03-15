#Requires AutoHotkey v2+ 64-Bit
#SingleInstance Force
/*
 * ============================================================================ *
 * Want a clear path for learning AutoHotkey?                                   *
 * Take a look at our AutoHotkey courses here: the-Automator.com/Discover       *
 * They're structured in a way to make learning AHK EASY                        *
 * And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
 * ============================================================================ *
*/
; It get the File path from the Follwing programs 
;~ Excel, Word, PowerPoint, Publisher ,VLC
;~ VScode, AHK Studio, SciTE4AHK
;~ Explorer, Directory Opus, TotalCommander, WinSCP, AutoHotkey32.exe
;~ Chrome, firefox: if nothing select gets url; if text is selected, builds pretty hyperlink 
;~ Open & save Dialog Boxes
;~ AHK Script Path from thise GUIs:

#Include <ObjectFromWindow>
#include <NotifyV2>
#include <UIA>
#include <ScriptObj\scriptobj>
#Include <WinClip>
#Include <WinClipAPI>
#include <Cjson>
#Include <VSCodeHotkeyBind>

BindVScodeHotkey('f13')

ini := A_ScriptDir "\Sethotkey.ini" 
myGui := Gui()
myGui.BackColor := "White"

myGui.oldHK  := IniRead(ini,"Hotkeys" ,"Set Copy Key",'^+c')

myGui.AddText("+0x200", "Set Hotkey to Copy Path")
myGui.AddHotkey("vHK ", StrReplace(myGui.oldHK,"#"))

myGui.AddCheckbox('x+m yp+3 vSet_Win','Win')
if InStr(myGui.oldHK,"#")
	myGui['Set_Win'].value := true
else
	myGui['Set_Win'].value := false

Hotkey(myGui.oldHK,GetActivatePath,'on')
myGui.AddButton( "xm w100", "&Apply").OnEvent("Click",SetHotkey)
myGui.AddButton( "w100 x+m", "&Cancel").OnEvent("Click",(*) => myGui.Hide())

myGui.Title := "Set Hotkey"

if !FileExist(ini)
	myGui.Show()

script := {
	        base : ScriptObj(),
			hwnd : 0,
	     version : "1.0.3",
	      author : "the-Automator",
	       email : "joe@the-automator.com",
	     crtdate : "",
	     moddate : "",
	   resfolder : A_ScriptDir '\res',
	    iconfile : A_ScriptDir '\res\gap.ico' ,
	homepagetext : "the-automator.com/GAP",
	homepagelink : "the-automator.com/GAP?src=app",
	  donateLink : "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6"
}

tray := A_TrayMenu
tray.Delete()
tray.Add("Set Hotkey`t" HKToString(myGui.oldHK),(*) => mygui.Show())
tray.Add "Wrap Path in Quotes", Quotes
tray.Add "Remove URL Tracking", Removalurl

if (IniRead(ini,"Remove_url" ,'Removal',0) = 1)
	tray.Check "Remove URL Tracking"
else
	tray.UnCheck "Remove URL Tracking"

if (IniRead(ini,"Quotes" ,'Stat',0) = 1)
	tray.Check "Wrap Path in Quotes"
else
	tray.UnCheck "Wrap Path in Quotes"


Removalurl(*)
{
	if (IniRead(ini,"Remove_url" ,'Removal',0) = 1)
	{
		tray.UnCheck "Remove URL Tracking"
		IniWrite 0, ini, 'Remove_url', 'Removal'
	}	
	else
	{
		tray.Check "Remove URL Tracking"
		IniWrite 1, ini, 'Remove_url', 'Removal'
	}
}

Quotes(*)
{
	if (IniRead(ini,"Quotes" ,'Stat',0) = 1)
	{
		tray.UnCheck "Wrap Path in Quotes"
		IniWrite 0, ini, 'Quotes', 'Stat'
	}	
	else
	{
		tray.Check "Wrap Path in Quotes"
		IniWrite 1, ini, 'Quotes', 'Stat'
	}
}


;tray.Add("Wrap Path in Quotes" HKToString(myGui.oldHK),(*) => mygui.Show())
;tray.Check("Wrap Path in Quotes")
;tray.Add("Wrap Path in Quotes`t" HKToString(myGui.oldHK),(*) => mygui.Show())

tray.Add("About",(*) => Script.About())
tray.Add("Donate",(*) => Run(script.donateLink))
tray.Add()
tray.AddStandard()
TraySetIcon script.iconfile

; Notify.IconPicker
Notify.Default.HDText := "Path: File Address Copied"
Notify.Default.BDFontSize := "15"
Notify.Default.BDFontcolor := "black"
Notify.Default.HDFontcolor := "green"
;~ ^r::reload

;********************Use Control+ Shift+ C to Get active Path on the clipboard***********************************
;^+c::
GetActivatePath(*)
{
	; ****** msgs *******
	static Protectedmsg := 'Document is Protected.`nPlease enable editing!`n<a href="https://youtu.be/JiHKmS-NMeI">Watch this Video</a> for more information'
	static StatusMsg := 'Program cannot accept Commands right now.`nTry changing the status of the program'
	static DialogMsg := 'Program is in a Dialog box.`nPlease close the dialog box and try again'
	;*********************
	Quotes := IniRead(ini,"Quotes" ,'Stat',0)
	TW_url := IniRead(ini,"Remove_url" ,'Removal',0)
	Name := ProcessGetName(pid := WinGetPID("A"))
	
	if RegExMatch(Name, 'grepWin.*.exe') ; 'grepWin-.*_portable.exe'
		Name := 'grepWin.exe'

	if hwnd := WinActive('ahk_class #32770')
	&& Name != 'grepWin.exe'
	{
		Filepath := GetOpenSaveDialogPath(hwnd)
		AppPath := ProcessGetPath(name)
		A_Clipboard  := Filepath
		ClipWait
		Notify.show({BDText:Filepath,GenIcon:IsSet(AppPath)?AppPath:""})
		return
	}
	else
	{
		switch Name, false {
			;********************Chrome***********************************
			case "chrome.exe",'firefox.exe','msedge.exe','opera.exe','brave.exe':
			A_Clipboard := ''
			Send '^c'
			ClipWait(2)
			Btext := A_Clipboard
			text := A_Clipboard
			sleep 400
			A_Clipboard := ''
			Send( '^l')
			sleep 400
			Send( '^c')
			if !ClipWait(2)
			{
				Notify.show("Failed to get URL")
				return
			}
			url := A_Clipboard
			Full_url := url
			A_Clipboard := url := regexreplace(url,"^(https?:\/\/(www\.)?.*)\?(.*)","$1") ; disable this line to get full url
			AppPath := ProcessGetPath(name)
			
			if !text
			&& !url {
				return Notify.show("Failed to get URL")
			}
			else if !text
				&& url {
				return Notify.show({BDText:url,GenIcon:IsSet(AppPath)?AppPath:"",HDText:'URL Copied'})
			}
			
			wc := WinClip()
			if TW_url
			{
				html:= '<span><a href=' url '>' text '</a></span>' ;Build href
				guiCtrlHtml := '<a href="' url '">' text '</a>' ;Build href
				wc.Clear()
				wc.SetHTML( html ) ;set clipboard to be Hyperlink	
				return Notify.show({link:guiCtrlHtml,GenIcon:IsSet(AppPath)?AppPath:"",HDText:'HyperLink Copied'})
			}
			else
			{
				html:= '<span><a href=' Full_url '>' text '</a></span>' ;Build href
				guiCtrlHtml := '<a href="' Full_url '">' text '</a>' ;Build href
				wc.Clear()
				wc.SetHTML( html ) ;set clipboard to be Hyperlink

				return Notify.show({link:guiCtrlHtml,GenIcon:IsSet(AppPath)?AppPath:"",HDText:'HyperLink Copied'})
			}			
			;********************Excel***********************************
			case "Excel.exe":
			NativeObj := ObjectFromWindow(OBJID_NATIVEOM, WinActive('a'), "EXCEL71")
			Info := ComObjType(NativeObj,'name')
			Switch info,0
			{
				Case 'ProtectedViewWindow': 
				
				return Notify.show({link:Protectedmsg})
				Case '': return Notify.show(StatusMsg)
				Case 'IAccessible':return Notify.show(DialogMsg)
			} 
			
			AppPath := NativeObj.Application.Path '\' Name
			file := NativeObj.Application.activeWorkBook
			Filepath := file.path "\" file.name
			
			;********************Word***********************************
			case "WinWord.exe","Word.exe":
			NativeObj := ObjectFromWindow(OBJID_NATIVEOM, WinActive('a'), "_WwG1") ; "ahk_exe " Name ' ahk_pid ' Pid
			;NativeObj := ComObjActive('word.application')
			Info := ComObjType(NativeObj,'name')
			Switch info,0
			{
				Case 'ProtectedViewWindow': 
				return Notify.show({link:Protectedmsg})
				Case '': return Notify.show(StatusMsg)
				Case 'IAccessible':return Notify.show(DialogMsg)
			} 
			
			file := NativeObj.Application.activedocument
			AppPath := NativeObj.Application.Path '\' Name
			Filepath := file.path "\" file.name
			
			;*********************PowerPoint**********************************
			case "PowerPnt.exe":
			; NativeObj := ObjectFromWindow(OBJID_NATIVEOM, WinActive('a'))
			NativeObj := ComObjActive("PowerPoint.Application")
			Info := ComObjType(NativeObj,'name')
			Switch info,0
			{
				Case 'ProtectedViewWindow': 
				return Notify.show({link:Protectedmsg})
				Case '': return Notify.show(StatusMsg)
				Case 'IAccessible':return Notify.show(DialogMsg)
				;Case '_Application': Notify.show("power point")
			} 
			
			file := NativeObj.ActivePresentation
			AppPath := NativeObj.Path '\' Name
			Filepath := file.path "\" file.name
			
			;********************Publisher***********************************
			case "MsPub.exe":
			NativeObj := ComObjActive("Publisher.Application")
			file := NativeObj.ActiveDocument
			AppPath := NativeObj.Path '\' Name
			Filepath := file.path "\" file.name
			
			;********************VS Code************************************
			case "Code.exe":
			A_Clipboard := ''
			SetKeyDelay(10,10)
			Send('{ctrl up}{shift up}{c up}')
			ControlSend('{f13}',,'ahk_exe ' name) ; this is the default hotkey, if you change yours, it would not work
			if ClipWait(2)
			{
				Filepath := A_Clipboard
				AppPath := ProcessGetPath(name)
			}
			
			;********************WinSCP*************************************
			Case 'WinSCP.exe':
			A_Clipboard := ''
			SetKeyDelay(50)
			Send('{ctrl up}{shift up}{c up}')
			ControlSend('^!c','a','ahk_exe' name)
			;Send('^!c')
			sleep 100
			if ClipWait(2)
			{
				Filepath := A_Clipboard
				FilePath := RegExReplace(FilePath,'\/(.*)\/public_html','https://$1') ; fixing fpt address
				AppPath := ProcessGetPath(name)
			}
			;********************Total Commander****************************
			Case 'TOTALCMD64.EXE','TOTALCMD32.EXE','TOTALCMD.EXE':
			A_Clipboard := ''
			PostMessage 0x111, 39, 0,,'ahk_exe ' name ; Runs --> Mark>Copy Names With Path To Clipboard
			if ClipWait(2)
			{
				Filepath := A_Clipboard
				AppPath := ProcessGetPath(name)
			}
			;********************Scite**************************************
			case "SciTE.exe":
			; NativeObj := ObjectFromWindow(OBJID_NATIVEOM, "ahk_exe " Name, "SciTeTabCtrl1")
			NativeObj := ComObjActive("SciTE4AHK.Application")
			Filepath := file := ComObjActive("SciTE4AHK.Application").CurrentFile
			AppPath := NativeObj.SciTEDir '\' Name
			;********************FileSearchEX*******************************
			case "FileSearchEX.exe":
			List := StrSplit(ListViewGetContent("Selected", 'TTntListView.UnicodeClass1', 'ahk_exe' name),'`n')
			path := ''
			for index, itemline in List
			{
				item := StrSplit(itemline, "`t") 
				path .= item[2] . item[1] '`n'
			}
			if List.length > 0
				Filepath := Trim(path ,'`n')
			AppPath := ProcessGetPath(name)
			;********************GrepWin************************************
			case "grepWin.exe":
			ptext := ControlGetText('Edit1','ahk_pid' pid)
			ControlFocus('SysListView321','ahk_pid ' pid)
			List := StrSplit(ListViewGetContent("Selected", 'SysListView321', 'ahk_pid' pid),'`n')
			sleep 100
			path := ''
			for index, itemline in List
			{
				item := StrSplit(itemline, "`t") 
				path .= ptext StrReplace(item[4],'\.','') . item[1] '`n'
			}

			if List.length > 0
				Filepath := Trim(path ,'`n')
			AppPath := ProcessGetPath(pid)
			;********************Directory Opus*****************************
			case "dopus.exe":
			A_Clipboard := ''
			
			SetKeyDelay(10,10)
			ControlSend('^+c',,'ahk_exe ' name)
			if ClipWait(2)
			{
				Filepath := A_Clipboard
				AppPath := ProcessGetPath(name)
			}
			
			;********************AHK STudio/ AHK program***********************************
			Case "AutoHotkey32.exe", "AutoHotkey64.exe" ,"AutoHotkeyU32.exe","AutoHotkeyU64.exe":
			;&& wingetTitle(x.hwnd(1)) ~= "AHK Studio"
			try x:=ComObjActive("{DBD5A90A-A85C-11E4-B0C7-43449580656B}")
			if IsSet(x) 
			&& IsObject(x)
			&& WinActive('ahk_id' x.hwnd(1))
			{
				Filepath := Trim(strreplace(WinGetTitle(x.hwnd(1)),'AHK Studio - '),'*')
				AppPath :=  x.path() '\AHKStudio.ico'
			}
			else
			{
				for process in ComObjGet("winmgmts:").ExecQuery("SELECT * FROM Win32_Process WHERE Name = '" name "'")
				{
					if process.processid = PID
					{
						if RegExMatch(var := process.CommandLine, Name '(\")?.*\"(?<path>.*)\"',&out)
							Filepath := out['path']			
						AppPath := ProcessGetPath(name)
					}
				}
			}
			
			;********************Explorer***********************************
			case "explorer.exe":
			Filepath := Explorer_GetSelection()
			AppPath := ExplorerIconNumber := 5
			
			;********************VLC***********************************
			case 'vlc.exe':
			SetKeyDelay(10,10)
			ControlSend('^i','a','ahk_exe ' name)
			WinWaitActive "Current Media Information ahk_exe vlc.exe"
			vlcEl := UIA.ElementFromHandle("Current Media Information ahk_exe vlc.exe")
			Filepath := vlcEl.ElementFromPath("4").Value
			Send('{Esc}')
			AppPath := ProcessGetPath(name)
			Default:
			for i, Title in StrSplit(WinGetTitle('a'),'-')
			{
				if RegExMatch(Trim(Title),'\d:\\',&regPath)
				{
					Filepath := regPath[1]
					AppPath := ProcessGetPath(name)
					break
				}
			}
		}
	}

	;*******************************************************
	;********************End of Case Statements***********************************
	;*******************************************************
	
	Notify.Default.HDText := Name ": Address Copied"
	if IsSet(Filepath)
	{
		if RegExMatch(Filepath,"^\\")
			return Notify.show("UnSaved File! - Save it first")
		
		if !instr(Filepath,":\") and !instr(Filepath,"https")
		 	return Notify.show("Failed to get Path")
		A_Clipboard  := Filepath
		ClipWait
		if Quotes
		{
			for i, str in StrSplit(Filepath, "`n","`r")
				Filepathstr .= '"' str '"`n'
			Filepathstr := Trim(Filepathstr,'`n')
			Notify.show({BDText: Filepathstr,GenIcon:IsSet(AppPath)?AppPath:""})
			A_Clipboard  := Filepathstr
		}	
		else
			Notify.show({BDText:Filepath,GenIcon:IsSet(AppPath)?AppPath:""})
		return
	}
	else
		return Notify.show("Failed to get Path")
	
}


Explorer_GetSelection(hwnd:='',ReturnType:="string")
{
	ToReturn := []
	process := WinGetProcessName('ahk_id' hwnd := hwnd? hwnd:WinExist('A'))
	class := WinGetClass('ahk_id' hwnd)
	if (process != 'explorer.exe')
		return (ToolTip('Nothing was Selected'), SetTimer((*)=>Tooltip, 2500), ToReturn)
	
	if (class ~= 'i)Progman|WorkerW')
	{
		files:=ListViewGetContent('Selected Col1', 'SysListView321', 'ahk_class' class)
		Loop Parse, files, '`n', '`r'
			ToReturn.Push(A_Desktop '\' A_LoopField)
	}
	else if (class ~= '(Cabinet|Explore)WClass')
	{
		for window in ComObject('Shell.Application').Windows
		{
			if (window.hwnd!=hwnd)
				continue
			sel := window.Document.SelectedItems
			break
		}
		if IsSet(sel)
			for item in sel
				ToReturn.Push(item.path)
	}
	if(ReturnType = "string")
	{
		paths := ""
		for path in ToReturn
			paths .= path "`n"
		return trim(paths,"`n")
	}
	return ToReturn
}

GetOpenSaveDialogPath(hwnd)
{
	Send( '^l')
	sleep 400
	if !folderPath := ControlGetText( 'Edit2', 'ahk_id' hwnd)
		folderPath := ControlGetText( 'Edit3', 'ahk_id' hwnd)
	Send( '{esc}')
	Path := ControlGetText( 'Edit1', 'ahk_id' hwnd)
	switch folderPath
	{
		Case 'Documents'  : Path := A_MyDocuments '\' Path
		Case 'Desktop'    : Path := A_Desktop '\' Path
		Case 'Gallery'    : Path := 'C:\Users\' A_UserName '\Pictures\Screenshots\' Path
		Case 'Music'      : Path := 'C:\Users\' A_UserName '\Music\' Path
		Case 'Videos'     : Path := 'C:\Users\' A_UserName '\Videos\' Path
		Case 'Downloads'  : Path := 'C:\Users\' A_UserName '\Downloads\' Path
		Case 'Pictures'   : Path := 'C:\Users\' A_UserName '\Pictures\' Path
		Case 'OneDrive'   : Path := 'C:\Users\' A_UserName '\OneDrive\' Path
		Case '3D Objects' : Path := 'C:\Users\' A_UserName '\3D Objects\' Path
		Default           : Path := folderPath '\' Path
	}

	;FolderPath:=SubStr(FolderPath,10)
	return StrReplace(Path,'\\','\')
}


SetHotkey(*)
{
	mygui.Hide()
	oldHK := myGui.oldHK
	Hotkey(myGui.oldHK,GetActivatePath,'off')
	Set_Win := myGui['Set_Win'].value
	if Set_Win
		IniWrite myGui.oldHK := "#" myGui['HK'].value, ini, "Hotkeys" ,"Set Copy Key"
	else
		IniWrite myGui.oldHK := myGui['HK'].value, ini, "Hotkeys" ,"Set Copy Key"
	Hotkey(myGui.oldHK,GetActivatePath, 'on')
	tray.Rename('Set Hotkey`t' HKToString(oldHK), 'Set Hotkey`t' HKToString(myGui.oldHK))
}

HKToString(hk)
{
	; removed logging due to performance issues
	; Log.Add(DEBUG_ICON_INFO, A_Now, A_ThisFunc, 'started', 'none')

	if !hk
		return

	temphk := []

	if InStr(hk, '#')
		temphk.Push('Win+')
	if InStr(hk, '^')
		temphk.Push('Ctrl+')
	if InStr(hk, '+')
		temphk.Push('Shift+')
	if InStr(hk, '!')
		temphk.Push('Alt+')

	hk := RegExReplace(hk, '[#^+!]')
	for mod in temphk
		fixedMods .= mod

	; Log.Add(DEBUG_ICON_INFO, A_Now, A_ThisFunc, 'ended', 'none')
	return (fixedMods ?? '') StrUpper(hk)
}