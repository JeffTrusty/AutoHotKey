#SingleInstance Force

#include <acc>
#include <UIA>
#include <ObjectFromWindowV2>
#include <ScriptObj\scriptobj>
/*
* ============================================================================ *
* Want a clear path for learning AutoHotkey?                                   *
* Take a look at our AutoHotkey courses here: the-Automator.com/Learn          *
* They're structured in a way to make learning AHK EASY                        *
* And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
* ============================================================================ *
*/
Toolname := "the-Automator Discovery Tool"
MyGui := Gui('+AlwaysOnTop +Toolwindow',Toolname)
script := {
	        base : ScriptObj(),
            hwnd : MyGui.hwnd,
	     version : "1.0.0",
	      author : "the-Automator",
	       email : "joe@the-automator.com",
	     crtdate : "",
	     moddate : "",
       resfolder : A_ScriptDir "\res",
        iconfile : 'shell32.dll' , ;A_ScriptDir "\res\UltimateSpybg512.ico",
        ;  config : A_ScriptDir "\settings.ini",
	homepagetext : "www.the-Automator.com/discovery",
	homepagelink : "www.the-Automator.com/discovery?src=discTool",
	  donateLink : "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6",
}

TraySetIcon script.iconfile, 23

tray := A_TrayMenu
tray.Delete()
tray.Add("About",(*) => script.About() ) ; Run('https://' script.homepagelink))
tray.Add("Donate",(*) => Run(script.donateLink))
tray.Add()
tray.AddStandard()

if !A_IsAdmin
{
    Run '*runas ' A_ScriptFullPath
    ExitApp
}


Lbutton_Pressed := false
CH := {h:100,w:100}
CoordMode "mouse","screen"
MyGui.OnEvent("close",(*) => ExitApp())

CR := MyGui.AddPicture('h' CH.h ' w' CH.w  ,a_scriptdir "\res\crosshairbg.png")
SB := MyGui.AddStatusBar(, "Drag Drop CrossHair on any window")
SB.SetParts(250)
MyGui.SetFont("s12")
isadmin := MyGui.AddText('+hidden cRed Center w100 ','Admin Mode Required')
MyGui.SetFont("s10")
CR.OnEvent("click",Ctrl_Click)
LV := MyGui.AddListView("x+m ys h150 w400",['Interface',"Simplicity","link to Source"])
LV.onEvent('DoubleClick',gotosource)
sharebtn := MyGui.AddButton('+disabled','Share')
sharebtn.OnEvent('click',ShowSubmitReportDialogBox)
MyGui.AddButton('x+m','Clear').OnEvent('click',ClearInspector)
MyGui.AddButton('x+m vpsr','Launch Steps Recorder').OnEvent( 'click',(*) => Run('psr.exe') )
Mygui.Show('hide')
MyGui.GetPos(,,&mainWidth)
MyGui.AddLink('yp+7 xp+' mainWidth - 300  ,'<a href="https://the-Automator.com/Consult?src=discTool">Help</a>') ; https://the-automator.com/HowUseDiscoveryTool
Mygui.Show('autosize')

Report := Gui("+AlwaysOnTop +Owner" MyGui.hwnd,"Submit Report")
Report.OnEvent('close',(*) => MyGui.Opt("-Disabled"))
ReportAnswer := "Following information give us an idea with what kind of tool we are dealing with and how much effort we need be needed based on the scores, we will approach you within 7 workingdays after the receving of this report"
Note1 := 'Note: your email address will not be published anywhere.'
Note2 := 'A valid email address is necessary if you want to receive your our reponse by email'
Report.AddGroupBox( "Section Wrap w400 h80","Why we need this Report?")
Report.AddText('xs+10 ys+25 Wrap w380',ReportAnswer)

Report.AddGroupBox( "Section xs Wrap w400 h150","Submission")
Report.AddText('xs+20 ys+30','Name')
Report.AddEdit('x+m+30 yp w200 vUser',A_UserName)
;Report.AddText('xs+20 y+m','e-mail')
;Report.AddEdit('x+m+30 yp w200 vEmail').OnEvent('change',EMailcheker)
Report.AddText('xs+10 y+m Wrap',Note1)
Report.AddText('xs+10 y+m Wrap w380',Note2)
Report.AddRadio("xs vShareonly +checked","Just Share Data").OnEvent('click',checkshare)
Report.AddRadio('x+m',"I need Help").OnEvent('click',checkshare)
infobox := Report.AddGroupBox( "Section xs Wrap w400 h150 hidden","Info")
infoedit := Report.AddEdit('xs+10 ys+20 r8 w380 vData hidden')

Submitbtn := Report.AddButton('xs+' 380-37 ' w60','Submit')
Submitbtn.OnEvent('click',SubmitUserReport)
Submitbtn.Move(,250) ; by doing this I have resolved autosize issues



Report.Show('autosize hide')

Crosshair := Gui("-SysMenu +AlwaysOnTop -Border -Caption +Owner" MyGui.hwnd )
Crosshair.AddPicture('x0 y0 h' CH.h ' w' CH.w   ,a_scriptdir "\res\Crosshair.png")
Crosshair.MarginX := 0
Crosshair.MarginY := 0
Crosshair.Show('hide')
WinSetTransColor('white ' 100 ,Crosshair)


SetTimer (*) => mygui['psr'].enabled := processexist('psr.exe') ? false : true, 1000


checkshare(*)
{
    infobox.visible := !report['Shareonly'].value
    infoedit.visible := !report['Shareonly'].value 
    if !report['Shareonly'].value
    {
        Submitbtn.Move(,420)
    }
    else
        Submitbtn.Move(,250)
    report.Show('AutoSize')
}

gotosource(obj,row)
{
    if row 
        run 'HTTP://' LV.GetText(row,3)
}

ClearInspector(*)
{
    LV.Delete()
    isadmin.visible := 0
    Report.Data := ''
    sharebtn.enabled := 0
}

updateLV(iHwnd,controlnn,pid)
{
    LV.Delete()
    Win32 := Acc := UIA := COM := Win32Menu := 'not found'
    MyGui.Title := progTitle := WinGetTitle('ahk_id' iHwnd)
    ;Report.iTitle 
    Report.Data := (
        '`n`n*********Please do not change following code***********'
        . "`nTitle: " progTitle 
        . "`nahk_class " WinGetClass('ahk_id' iHwnd)
        . "`nahk_exe " WinGetProcessName('ahk_id' iHwnd)
        . "`nahk_pid " pid
        . "`nahk_id " iHwnd
        . "`n`nInterfaces: "
        )
    cols := Map(
        'Win32 Menu', {status:isMenuAvailable(iHwnd), score: 10,Link:'the-Automator.com/MenuWriter' },
        'Win32', {status:getWin32Controlcount(iHwnd), score: 9,Link:'the-Automator.com/Controls'},
        'StatusBar', {status:instr(controlnn,'statusbar'), score: 9,Link:'the-Automator.com/StatusBar'},
        'ImageSearch', {status:1, score: 8,Link:'the-Automator.com/AmT'},
        'COM', {status:isCOMAvailable(iHwnd), score: 7,link:'the-Automator.com/COM'},
        'Rufaydium',{status:isBrowser(pid), score: 6,Link:'the-Automator.com/Rufaydium'},
        'ACC', {status:isACCAvailable(iHwnd), score: 5,Link:'the-Automator.com/ACC'},
        'UIA', {status:isUIAAvailable(iHwnd), score: 2,Link:'the-Automator.com/UIA'},
        'Messages', {status:1, score: 1,Link:'the-Automator.com/messages'}
    )
    for title, info in cols
        if info.status
        {
            LV.Add(,title,info.score,info.Link)
            Report.Data .= title ", "
        }
    Report.Data .= '`nisAdmin: ' (isadmin.visible? 'true' : 'false')

    loop LV.GetCount('col')
        LV.ModifyCol(A_Index,"AutoHdr")

    LV.ModifyCol(2, 'Integer SortDesc Center')
    SB.SetText("`tComplete.Drag Drop CrossHair on any window")
    sharebtn.enabled := 1
}


isBrowser(pid)
{
    SB.SetText("checking for Browser controls")
    Switch name := ProcessGetName(pid),0
    {
        case 'Chrome.exe', 'msedge.exe', 'firefox.exe','Opera.exe','Brave.exe': return 1
        Default: return 0
    }
    SB.SetText("checking for ACC and UIA")
}

getWin32Controlcount(iHwnd)
{
    SB.SetText("checking for Win32 Contorls")
    Win32 := 0
    for control in WinGetControls('ahk_id' iHwnd)
    {
        if InStr(Controlslist, RegExReplace(control,"\d+$"))
            ++Win32 
    }
    return Win32
}

isMenuAvailable(iHwnd) => DllCall("user32\GetMenu","UInt", iHwnd)
isACCAvailable(iHwnd) => IsObject(Acc.ElementFromHandle('ahk_id' iHwnd))
isUIAAvailable(iHwnd) => IsObject(UIA.ElementFromHandle('ahk_id' iHwnd))

isCOMAvailable(iHwnd)
{
    SB.SetText("checking for COM")
    for ctrl in WinGetControls(iHwnd)
    {
        try com := IsObject(ObjectFromWindow(OBJID_NATIVEOM, 'ahk_id' iHwnd, ctrl))
        if com
            return true
    }
    return false    
}


Ctrl_Click(*)
{
    Global Lbutton_Pressed
    Lbutton_Pressed := true
    Crosshair.Show()
    WinSetTransColor('white ' 0 ,CR)
    SB.SetText("Waiting CrossHair Drop...")
    while Lbutton_Pressed
    {
        MouseGetPos &X, &Y
        sleep 5
        Crosshair.Move(X- (CH.h/2),Y- (CH.w/2))
    }
    Crosshair.hide()
    WinSetTransColor('white ' 255 ,CR)
    WinWaitNotActive WinExist(Crosshair)
    ;sleep 2000
    A_Clipboard := ""
    MouseGetPos &X, &Y, &iHwnd, &Controlnn

    if Mygui.hwnd = iHwnd
        return SB.SetText("Drag Drop CrossHair on any window")
    SB.SetText("Reading...")
    pid := WinGetPID('ahk_id' iHwnd)
    ;isadmin.value := IsProcessElevated(ProcessExist(ProcessName))
    isadmin.visible := IsProcessElevated(pid)
    updateLV(iHwnd, Controlnn,pid)
   ; msgbox A_Clipboard "`n`n" 
}


~Lbutton Up::
{
    Global Lbutton_Pressed
    Lbutton_Pressed := false
}

; https://github.com/jNizM/ahk-scripts-v2/blob/main/src/ProcessThreadModule/IsProcessElevated.ahk
IsProcessElevated(ProcessID)
{
    static INVALID_HANDLE_VALUE              := -1
    static PROCESS_QUERY_INFORMATION         := 0x0400
    static PROCESS_QUERY_LIMITED_INFORMATION := 0x1000
    static TOKEN_QUERY                       := 0x0008
    static TOKEN_QUERY_SOURCE                := 0x0010
    static TokenElevation                    := 20

    hProcess := DllCall("OpenProcess", "UInt", PROCESS_QUERY_INFORMATION, "Int", False, "UInt", ProcessID, "Ptr")
    if (!hProcess) || (hProcess = INVALID_HANDLE_VALUE)
    {
        hProcess := DllCall("OpenProcess", "UInt", PROCESS_QUERY_LIMITED_INFORMATION, "Int", False, "UInt", ProcessID, "Ptr")
        if (!hProcess) || (hProcess = INVALID_HANDLE_VALUE)
            throw OSError()
    }

    if !(DllCall("advapi32\OpenProcessToken", "Ptr", hProcess, "UInt", TOKEN_QUERY | TOKEN_QUERY_SOURCE, "Ptr*", &hToken := 0))
    {
        DllCall("CloseHandle", "Ptr", hProcess)
        throw OSError()
    }

    if !(DllCall("advapi32\GetTokenInformation", "Ptr", hToken, "Int", TokenElevation, "UInt*", &IsElevated := 0, "UInt", 4, "UInt*", &Size := 0))
    {
        DllCall("CloseHandle", "Ptr", hToken)
        DllCall("CloseHandle", "Ptr", hProcess)
        throw OSError()
    }

    DllCall("CloseHandle", "Ptr", hToken)
    DllCall("CloseHandle", "Ptr", hProcess)
    return IsElevated
}


ShowSubmitReportDialogBox(*)
{
    MyGui.Opt("+Disabled")
    Report.Opt("+Owner" MyGui.hwnd)
    Report.show('AutoSize')
}

EMailcheker(*)
{
    if RegExMatch(Report['Email'].value,'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        Submitbtn.enabled := true
    else
        Submitbtn.enabled := false
    
}

SubmitUserReport(*)
{
    Report.submit()
    MyGui.Opt("+Disabled")
    ;info := Report['User'].value "`n"  Report['Email'].value "`n`n" Report.Data
    ;msgbox  info,, 'Owner' MyGui.hwnd
   
    ;email := TextEncode(Report['Email'].value)
    Subject := TextEncode('Automator Inspector: User ' Report['User'].value  ) ; ' email: ' Report['Email'].value
    Body := TextEncode( (Report['Data'].value?Report['Data'].value:"") Report.Data)
    Run 'mailto:DiscoveryTool@the-Automator.com?Subject=' Subject '&Body=' Body
    MyGui.Opt("-Disabled")
}


TextEncode(str, sExcepts := "-_.", enc := "UTF-8")
{
    hex := "00", func := "msvcrt\swprintf"
    buff := Buffer(StrPut(str, enc)), StrPut(str, buff, enc)   ;转码
    encoded := ""
    Loop {
        if (!b := NumGet(buff, A_Index - 1, "UChar"))
            break
        ch := Chr(b)
        ; "is alnum" is not used because it is locale dependent.
        if (b >= 0x41 && b <= 0x5A ; A-Z
            || b >= 0x61 && b <= 0x7A ; a-z
            || b >= 0x30 && b <= 0x39 ; 0-9
            || InStr(sExcepts, Chr(b), true))
            encoded .= Chr(b)
        else {
            DllCall(func, "Str", hex, "Str", "%%%02X", "UChar", b, "Cdecl")
            encoded .= hex
        }
    }
    return encoded
}
; https://docs.testarchitect.com/8.5/automation-guide/application-testing/testing-desktop-applications/testing-win32-applications/list-of-supported-win32-controls/
/*
Control	Class(es)
Button	BUTTON
Check Box	BUTTON
Combo Box	COMBOBOX
Date Time Picker	SysDateTimePick32
Edit Box	EDIT
Group Box	BUTTON
Hot Key Control	HOTKEY_CLASS (msctls_hotkey32)
IP Address Control	SysIPAddress32
List Box	LISTBOX
List View	WC_LISTVIEW (SysListView)
Month Calendar	MONTHCAL_CLASS (SysMonthCal32)
Picture	STATIC
Progress Bar	PROGRESS_CLASS (msctls_progress)
Radio Button	BUTTON
Rich Edit	RICHEDIT
RichEdit20A
RichEdit20W

Scroll Bar	SCROLLBAR
Slider	TRACKBAR_CLASS (msctls_trackbar)
Spin Control	msctls_updown32
Split Button	BUTTON
Static Text	STATIC
Status Bar	STATUSCLASSNAME (msctls_statusbar32)
SysLink	SYSLINK
Tab Control	WC_TABCONTROL (SysTabControl)
Toolbar Control	TOOLBARCLASSNAME (ToolbarWindow32)
Tree View Control	WC_TREEVIEW (SysTreeView)

*/

Controlslist :=
(
"Button
SysListView32
SysTreeView
SysHeader32
Static
Edit
ComboBox
msctls_hotkey32
SysMonthCal32
SysDateTimePick32
msctls_statusbar32
msctls_progress
Scroll Bar
msctls_trackbar
msctls_updown32
SYSLINK
SysTabControl
ToolbarWindow32
RICHEDIT
RICHEDIT20A
RICHEDIT20W
SysIPAddress32"
)