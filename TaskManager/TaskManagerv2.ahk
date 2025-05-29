/*****
;Todo
2) create download  Price is $4.99
3) Create prettylink
4) Debug..  still glitchy
*/


#Requires AutoHotkey v2.0
#SingleInstance Force

; Include the ScriptObject library (assuming it's compatible with AHK v2)
; #Include <ScriptObject\ScriptObject>
; #Include <S:\lib\v2\ScriptObject\ScriptObject>
#include "S:\lib\v2\ScriptObject\ScriptObject.ahk"
script := {base: ScriptObj
    ,name: RegExReplace(A_ScriptName, "\.\w+")
    ,version: "0.2.0"
    ,author: "fenchai (v1) / Assistant (v2 conversion)"
    ,email: ""
    ,crtdate: "September 07, 2019"
    ,moddate: "July 17, 2024"
    ,homepagetext: ""
    ,homepagelink: ""
    ,donateLink: "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6"
    ,resfolder: A_ScriptDir "\res"
    ,configfile: A_ScriptDir "\TaskManager.ini"
    ,configfolder: A_ScriptDir ""}

SetWorkingDir A_ScriptDir

AppWindow := "Task Manager with Filter | come on Microsoft, if I could do it..."
LogFile := script.configfile

Read_Log()
IsProcessElevated := GetProcessElevated(DllCall("GetCurrentProcessId", "UInt"))
colHeadersArr := ["Process Name", "PID", "HWND", "CPU", "RAM (MB)", "File Path", "Executable Path"]

if (!IsProcessElevated) {
    colHeadersArr.RemoveAt(4)
}

colHeaders := ""
for v in colHeadersArr {
    colHeaders .= "|" v
}
colHeaders := LTrim(colHeaders, "|")

; Build Tray Menu
A_TrayMenu.Delete()
A_TrayMenu.Add(AppWindow, (*) => MainGui.Show())
A_TrayMenu.Default := AppWindow
A_TrayMenu.Add()
A_TrayMenu.Add("Reset Position", (*) => ResetPosition())
A_TrayMenu.Add("F5 -Refresh", (*) => Fill_LVP())
A_TrayMenu.Add("Delete -Kill Selected", (*) => Kill())
A_TrayMenu.Add()
; A_TrayMenu.Add("About", (*) => script.about())
A_TrayMenu.Add()
A_TrayMenu.Add("Edit", (*) => Edit())
A_TrayMenu.Add("Reload", (*) => Reload())
A_TrayMenu.add('Open Folder',(*)=>Run(A_ScriptDir))
A_TrayMenu.SetIcon("Open Folder","shell32.dll",4)
A_TrayMenu.Add("Exit", (*) => ExitApp())

; GUI variables
GH -= 39
GW -= 15

GX := GX < 0 ? 0 : GX
GY := GY < 0 ? 0 : GY
GW := GW < 600 ? 900 : GW
GH := GH < 0 ? 600 : GH

; Build GUI
MainGui := Gui("+AlwaysOnTop +Resize", AppWindow)
MainGui.AddEdit("w300 Section vQuery")
MainGui.AddButton("ys-1 w75 vUpdateBtn Default", "Filter").OnEvent("Click", (*) => Fill_LVP())
MainGui.AddButton("ys w75 vClearBtn", "Clear").OnEvent("Click", (*) => Clear())
MainGui.AddButton("ys vEndTaskBtn", "End Process (es)").OnEvent("Click", (*) => Kill())
MainGui.AddEdit("ys w20 Number vTypedRefreshPeriod")
MainGui.AddText("ys yp+3", "Refresh Period (s)")
MainGui.AddText("Section xs vCpu", "CPU Load: 00 %").Opt("cGreen w700")
MainGui.AddText("ys vRam", "Used RAM: 00 %").Opt("cGreen w700")
MainGui.AddCheckbox("ys vShowSystemProcesses", "Show System").OnEvent("Click", (*) => Fill_LVP())
MainGui.AddText("ys vCount", "Preparing data...")
LVP := MainGui.AddListView("Section xs w" GW - 20 " r29 vLVP", colHeadersArr)

LVP.OnEvent("ContextMenu", (*)=> rightClickEvt())
LVP.OnEvent("DoubleClick", (lv, info)=> openFileLocation())
LVP.OnEvent("DoubleClick", (lv, info)=>
    (fPath := LVP.GetText(LVP.GetNext(), IsProcessElevated ? 6 : 5),
    SB.SetText(fPath))
)

LVP.OnEvent("ItemSelect", (*)=>
    (fPath := LVP.GetText(LVP.GetNext(), IsProcessElevated ? 6 : 5),
    SB.SetText(fPath))
)

(SB := MainGui.AddStatusBar()).SetText("Select an item to see the file path")

SetWindowTheme(LVP)

; Fill GUI
Fill_LVP()

loop LVP.GetCount('Col')
    LVP.ModifyCol(A_Index, 'AutoHdr')

MainGui.Show(Format("x{} y{} h{} w{}", GX, GY, GH, GW))

; Timers and other stuffs after GUI is built
OnMessage(0x03, WN_MOVE)  ; tracks window move
OnMessage(0x0200, WM_MOUSEMOVE)  ; tracks mouse move

SetTimer(UpdateStats, 500)  ; set timer for cpu, ram updates periodically
TypedRefreshPeriod := IniRead(LogFile, "Preferences", "RefreshPeriod", "0")
MainGui["TypedRefreshPeriod"].Value := TypedRefreshPeriod ? TypedRefreshPeriod : 0
setRefreshPeriod()  ; set the refresh period manually

; Main GUI events
MainGui.OnEvent("Size", Gui_Size)
MainGui.OnEvent("Close", (*) => ExitApp())
MainGui.OnEvent("Escape", (*) => ExitApp())

; Run the script
MainGui.Show()

return

; Rest of the functions will follow in subsequent parts

; ... (previous code remains the same)

UpdateStats() {
    MainGui["Cpu"].Text := "CPU Load: " . cpuload() . "%"
    MainGui["Ram"].Text := "Used RAM: " . memoryload() . "%"
}

; Format_Columns() {
;     if (IsProcessElevated) {
;         LVP.ModifyCol(1, MainGui.Pos.W * (150/701))
;         LVP.ModifyCol(2, MainGui.Pos.W * (50/701) " Integer")
;         LVP.ModifyCol(3, MainGui.Pos.W * (70/701) " Integer SortDesc")
;         LVP.ModifyCol(4, MainGui.Pos.W * (50/701) " Integer")
;         LVP.ModifyCol(5, MainGui.Pos.W * (60/701) " Integer")
;         LVP.ModifyCol(6, MainGui.Pos.W * (315/701) " Text")
;         LVP.ModifyCol(7, MainGui.Pos.W * (315/701))
;     } else {
;         LVP.ModifyCol(1, MainGui.Pos.W * (150/701))
;         LVP.ModifyCol(2, MainGui.Pos.W * (50/701) " Integer")
;         LVP.ModifyCol(3, MainGui.Pos.W * (70/701) " Integer SortDesc")
;         LVP.ModifyCol(4, MainGui.Pos.W * (60/701) " Integer")
;         LVP.ModifyCol(5, MainGui.Pos.W * (315/701) " Text")
;         LVP.ModifyCol(6, MainGui.Pos.W * (315/701))
;     }
; }

Enter_Redirector() {
    currFocus := ControlGetFocus("A")

    if (currFocus = MainGui['Query'].hwnd || currFocus = MainGui['ClearBtn'].hwnd) {
        Fill_LVP()
    } else if (currFocus == MainGui['TypedRefreshPeriod'].hwnd) {
        setRefreshPeriod()
    } else if (currFocus == LVP.Hwnd) {
        CustomFilter()
    }
}

Clear() {
    MainGui["Query"].Value := ""
    MainGui["Query"].Focus()
    Fill_LVP()
}

Fill_LVP() {

    DllCall('QueryPerformanceFrequency', 'Int64*', &freq := 0)
    DllCall('QueryPerformanceCounter', 'Int64*', &CounterBefore := 0)

    MainGui["LVP"].Opt("-Redraw")
    MainGui.Submit(false)

    if (IsProcessElevated) {
        setSeDebugPrivilege()
    }

    LVP.Delete()
    ImageList := IL_Create()
    LVP.SetImageList(ImageList)

    count := 0
    static wmi := ComObject("WbemScripting.SWbemLocator").ConnectServer()
    for process in wmi.ExecQuery("Select * from Win32_Process") {

        ; OutputDebug process.ExecutablePath ' //// ' ProcessPath(process.Name) '`n'
        ; try OutputDebug ProcessGetPath(process.Name) ' //// ' process.ExecutablePath
        if (process.ExecutablePath = "")
            continue

        if !(process.Name ~= 'iS)\Q' MainGui["Query"].Text '\E')
        && !(process.CommandLine ~= 'iS)\Q' MainGui["Query"].Text '\E')
        && !(process.ExecutablePath ~= 'iS)\Q' MainGui["Query"].Text '\E')
            continue

        try
        {
            if !IL_Add(ImageList, process.ExecutablePath)
                IL_Add(ImageList, A_WinDir "\explorer.exe")
        }
        catch
            IL_Add(ImageList, A_WinDir "\explorer.exe")

        count++
        hwnd := WinExist('ahk_pid' process.processId)
        if MainGui["ShowSystemProcesses"].Value {
            LVP.Add("Icon" count
                , process.Name
                , process.processId
                , hwnd ? hwnd : ''
                , Round(getProcessTimes(ProcessCreationTime(process.processId)), 2)
                , Round(process.WorkingSetSize / 1000000, 2)
                , process.CommandLine, process.ExecutablePath)
        } else {
            LVP.Add("Icon" count
                , process.Name
                , process.processId
                , hwnd ? hwnd : ''
                , Round(process.WorkingSetSize / 1000000, 2)
                , process.CommandLine, process.ExecutablePath)
        }
    }

    MainGui["Count"].Text := count . " Processes"

    LVP.ModifyCol(2, "Integer")

    MainGui["LVP"].Opt("+Redraw")
    DllCall('QueryPerformanceCounter', 'Int64*', &CounterAfter := 0)
    OutputDebug 'Elapsed time: ' (CounterAfter - CounterBefore) / freq ' sec`n'
}

LVAdd(process, addType := "withCPU") {

}

getRowName() {
    return LVP.GetText(LVP.GetNext())
}

setRefreshPeriod() {
    TypedRefreshPeriod := MainGui["TypedRefreshPeriod"].Value
    if (TypedRefreshPeriod > 0) {
        SetTimer(AppRefreshPeriod, TypedRefreshPeriod * 1000)
    } else {
        SetTimer(AppRefreshPeriod, 0)
    }
    IniWrite(TypedRefreshPeriod ? TypedRefreshPeriod : 0, LogFile, "Preferences", "RefreshPeriod")
}

AppRefreshPeriod() {
    Fill_LVP()
}

; LVP_Events(LVP, RowNumber) {
;     if (A_GuiEvent == "RightClick") {
;         rightClickEvt()
;     } else if (A_GuiEvent == "DoubleClick") {
;         openFileLocation()
;     } else if (A_GuiEvent == "Normal" || A_GuiEvent == "K") {
;         fPath := LVP.GetText(LVP.GetNext(), IsProcessElevated ? 6 : 5)
;         MainGui.StatusBar.SetText(fPath)
;     }
; }

rightClickEvt() {
    RowNumber := 0
    selected := Map()
    Loop {
        RowNumber := LVP.GetNext(RowNumber)
        if !RowNumber
            break
        pid := LVP.GetText(RowNumber, 2)
        pname := LVP.GetText(RowNumber, 1)
        selected[RowNumber " ) " pname] := pid
    }

    SelectedName := LVP.GetText(A_EventInfo, 1)

    LVItem := selected.Count = 1 ? SelectedName : selected.Count " Processes Selected"

    LVPMenu := Menu()
    LVPMenu.Add("Filter on " SelectedName, (*) => CustomFilter())
    LVPMenu.Add("Copy Selected", (*) => CopySelected())
    LVPMenu.Add()
    LVPMenu.Add("End " (selected.Count > 1 ? selected.Count " Processes" : "Process"), (*) => Kill())
    LVPMenu.Add("Restart " (selected.Count > 1 ? selected.Count " Processes" : "Process"), (*) => restartProcesses())
    LVPMenu.Add("Open " (selected.Count > 1 ? selected.Count " Directories" : "Directory"), (*) => openFileLocation())

    LVPMenu.Show()
}

CustomFilter() {
    MainGui["Query"].Value := getRowName()
    Fill_LVP()
}

CopySelected() {
    clipText := ""
    row := 0
    while (row := LVP.GetNext(row)) {
        line := ""
        Loop LVP.GetCount("Column") {
            line .= LVP.GetText(row, A_Index) "`t"
        }
        clipText .= RTrim(line, "`t") "`n"
    }
    A_Clipboard := clipText
}

; ... (more functions to follow in the next part)
; ... (previous code remains the same)

openFileLocation() {
    RowNumber := 0
    selected := Map()
    Loop {
        RowNumber := LVP.GetNext(RowNumber)
        if !RowNumber
            break
        pid := LVP.GetText(RowNumber, 2)
        fPath := LVP.GetText(RowNumber, 5)
        selected[pid] := fPath
    }

    for pid, path in selected {
        SplitPath(CleanPath(path),, &directory)
        Run(directory)
    }
}

CleanPath(orig_path) {
    path := pos := 0
    while (pos := RegExMatch(orig_path, "i)(^|\s)(?<path>`"(\w:\\[^:]+?)`"|(\w:\\[^:\s]+?)\s)", &matched, pos ? pos + 1 : 1))
        path := StrReplace(matched["path"], "`"")
    return path
}

Kill() {
    MainGui.Opt('+OwnDialogs')
    RowNumber := 0
    selected := Map()
    Loop {
        RowNumber := LVP.GetNext(RowNumber)
        if !RowNumber
            break
        pname := LVP.GetText(RowNumber, 1)
        pid := LVP.GetText(RowNumber, 2)
        path := LVP.GetText(RowNumber, 5)
        selected[pid] := {name: pname, path: CleanPath(path)}
    }

    selected_parsed := "Kill " selected.Count " Item" (selected.Count > 1 ? "s?" : "?") "`n"

    for pid, info in selected
        selected_parsed .= "[" pid "] " info.name ":`n" info.path "`n`n"

    if (selected.Count <= 0) {
        MsgBox("Nothing to Kill -_-", , 0x40)
        return
    }

    if (MsgBox(selected_parsed, , 0x34) = "Yes") {
        for pid, info in selected
            ProcessClose(pid)

        Fill_LVP()
    }
}

restartProcesses() {
    RowNumber := 0
    selected := Map()
    Loop {
        RowNumber := LVP.GetNext(RowNumber)
        if !RowNumber
            break
        pid := LVP.GetText(RowNumber, 2)
        fPath := LVP.GetText(RowNumber, 7)
        selected[pid] := fPath
    }

    for pid, path in selected {
        ProcessClose(pid)
        Run(path)
    }
}

Read_Log() {
    global GX, GY, GH, GW

    LogConfig := "
    (
    [Position]
    LogX=20
    LogY=20
    LogH=600
    LogW=500
    [Preferences]
    RefreshPeriod=0
    )"

    if !FileExist(LogFile)
        FileAppend(LogConfig, LogFile)

    GX := IniRead(LogFile, "Position", "LogX", 20)
    GY := IniRead(LogFile, "Position", "LogY", 20)
    GH := IniRead(LogFile, "Position", "LogH", 600)
    GW := IniRead(LogFile, "Position", "LogW", 500)
}

Write_Log() {
    WinGetPos(&GX, &GY, &GW, &GH, AppWindow)
    IniWrite(GX, LogFile, "Position", "LogX")
    IniWrite(GY, LogFile, "Position", "LogY")
    IniWrite(GH, LogFile, "Position", "LogH")
    IniWrite(GW, LogFile, "Position", "LogW")
}

ResetPosition() {
    IniWrite(20, LogFile, "Position", "LogX")
    IniWrite(20, LogFile, "Position", "LogY")
    Reload()
}

Gui_Size(thisGui, MinMax, Width, Height) {
    if (MinMax = -1)
        return

    LVP.Opt("-Redraw")
    LVwidth := Width - 15
    LVheight := Height - 80

    LVP.Move(, , LVwidth, LVheight)
    ; Format_Columns()
    Write_Log()
    LVP.Opt("+Redraw")
}

WN_MOVE(wParam, lParam, msg, hwnd) {
    Write_Log()
}

WM_MOUSEMOVE(wParam, lParam, msg, hwnd) {
    static TT := ""

    if (hwnd = MainGui["UpdateBtn"].hwnd) {
        TT := "F5 to refresh"
    } else if (hwnd = MainGui["ClearBtn"].hwnd) {
        TT := "You can also press DEL while typing"
    } else if (hwnd = MainGui["EndTaskBtn"].hwnd) {
        TT := "Can end single or Multiple Processes`nPress DEL on item to do the same"
    } else if (hwnd = MainGui["TypedRefreshPeriod"].hwnd) {
        TT := "type seconds and press Enter"
    } else {
        ToolTip()
    }

    ToolTip(TT)
}

CheckProcessExist(ProcessName) {
    if ProcessName is Integer
        return ProcessName
    else
        return ProcessExist(ProcessName)
}

ProcessPath(ProcessName) {
    ProcessId := CheckProcessExist(ProcessName) ; InStr(ProcessName, ".") ?  : ProcessName
    hProcess := DllCall("Kernel32.dll\OpenProcess", "UInt", 0x0400|0x0010, "Int", 0, "Ptr", ProcessId, "Ptr")
    if (hProcess) {
        FileNameSize := 260
        ; VarSetStrCapacity(ModuleFileName, (FileNameSize + 1) * 2, 0)

        ;ModuleFileName := Buffer((FileNameSize + 1) * 2, 0)
        VarSetStrCapacity(&ModuleFileName, (FileNameSize + 1) * 2)
        if !(DllCall("Psapi.dll\GetModuleFileNameExW", "Ptr", hProcess, "Ptr", 0, "Str", ModuleFileName, "UInt", FileNameSize))
            if !(DllCall("Kernel32.dll\K32GetModuleFileNameExW", "Ptr", hProcess, "Ptr", 0, "Str", ModuleFileName, "UInt", FileNameSize))
                DllCall("Kernel32.dll\QueryFullProcessImageNameW", "Ptr", hProcess, "UInt", 0, "Str", ModuleFileName, "UInt*", FileNameSize)
        DllCall("Kernel32.dll\CloseHandle", "Ptr", hProcess)
        return ModuleFileName
    }
    return ""
}

ProcessCreationTime(PID) {
    hPr := DllCall("OpenProcess", "UInt", 0x0400, "Int", 0, "UInt", PID, "Ptr")
    if (hPr) {
        UTC := Buffer(8, 0)
        if (DllCall("GetProcessTimes", "Ptr", hPr, "Ptr", UTC, "Ptr", 0, "Ptr", 0, "Ptr", 0)) {
            DllCall("CloseHandle", "Ptr", hPr)
            LocalProcess := Buffer(8, 0)
            DllCall("FileTimeToLocalFileTime", "Ptr", UTC, "Ptr", LocalProcess)
            AT := 1601
            AT += NumGet(LocalProcess, 0, "Int64") // 10000000, "Seconds"
            return FormatTime(AT, "hh:mm:ss yy-MM-dd")
        }
        DllCall("CloseHandle", "Ptr", hPr)
    }
    return ""
}

; ... (more functions to follow in the next part)

; ... (previous code remains the same)

GlobalMemoryStatusEx() {
    static MEMORYSTATUSEX := Buffer(64, 0)
    NumPut("UInt", 64, MEMORYSTATUSEX, 0)
    if (DllCall("Kernel32.dll\GlobalMemoryStatusEx", "Ptr", MEMORYSTATUSEX)) {
        return {2: NumGet(MEMORYSTATUSEX, 8, "UInt64")
            , 3: NumGet(MEMORYSTATUSEX, 16, "UInt64")
            , 4: NumGet(MEMORYSTATUSEX, 24, "UInt64")
            , 5: NumGet(MEMORYSTATUSEX, 32, "UInt64")}
    }
    return {}
}

MemoryLoad() {
    static MEMORYSTATUSEX := Buffer(64, 0)
    NumPut("UInt", 64, MEMORYSTATUSEX, 0)
    if (!DllCall("GlobalMemoryStatusEx", "Ptr", MEMORYSTATUSEX))
        throw Error("Call to GlobalMemoryStatusEx failed: " A_LastError, -1)
    return NumGet(MEMORYSTATUSEX, 4, "UInt")
}

CPULoad() {
    Static prevIdleTime, prevKernelTime, prevUserTime

    if !IsSet(prevIdleTime)
        Return !DllCall("GetSystemTimes", "Int64P", &prevIdleTime:=0, "Int64P", &prevKernelTime:=0, "Int64P", &prevUserTime:=0)

    DllCall( "GetSystemTimes", "Int64P", &currentIdleTime:=0, "Int64P", &currentKernelTime:=0, "Int64P", &currentUserTime:=0)

    IdleTime   := prevIdleTime - currentIdleTime
    KernelTime := prevKernelTime - currentKernelTime
    UserTime   := prevUserTime - currentUserTime
    SystemTime := KernelTime + UserTime

    ; save current for next calculation
    prevIdleTime := currentIdleTime, prevKernelTime := currentKernelTime, prevUserTime := currentUserTime
    Return (SystemTime - IdleTime) * 100  // SystemTime
}

getProcessTimes(PID) {
    static aPIDs := Map(), hasSetDebug := false

    if (aPIDs.Has(PID) && A_TickCount - aPIDs[PID].tickPrior < 250)
        return aPIDs[PID].usagePrior

    hProc := DllCall("OpenProcess", "UInt", 0x1000, "Int", 0, "Ptr", PID, "Ptr")
    if (!hProc)
        return -2

    lpCreationTime := Buffer(8, 0), lpExitTime := Buffer(8, 0)
    lpKernelTimeProcess := Buffer(8, 0), lpUserTimeProcess := Buffer(8, 0)
    DllCall("GetProcessTimes", "Ptr", hProc, "Ptr", lpCreationTime, "Ptr", lpExitTime, "Ptr", lpKernelTimeProcess, "Ptr", lpUserTimeProcess)
    DllCall("CloseHandle", "Ptr", hProc)

    lpIdleTimeSystem := Buffer(8, 0), lpKernelTimeSystem := Buffer(8, 0), lpUserTimeSystem := Buffer(8, 0)
    DllCall("GetSystemTimes", "Ptr", lpIdleTimeSystem, "Ptr", lpKernelTimeSystem, "Ptr", lpUserTimeSystem)

    if (aPIDs.Has(PID)) {
        systemKernelDelta := NumGet(lpKernelTimeSystem, 0, "Int64") - aPIDs[PID].lpKernelTimeSystem
        systemUserDelta := NumGet(lpUserTimeSystem, 0, "Int64") - aPIDs[PID].lpUserTimeSystem
        procKernalDelta := NumGet(lpKernelTimeProcess, 0, "Int64") - aPIDs[PID].lpKernelTimeProcess
        procUserDelta := NumGet(lpUserTimeProcess, 0, "Int64") - aPIDs[PID].lpUserTimeProcess
        totalSystem := systemKernelDelta + systemUserDelta
        totalProcess := procKernalDelta + procUserDelta
        result := 100 * totalProcess / totalSystem
    } else {
        result := -1
    }

    aPIDs[PID] := {lpKernelTimeSystem: NumGet(lpKernelTimeSystem, 0, "Int64")
        , lpUserTimeSystem: NumGet(lpUserTimeSystem, 0, "Int64")
        , lpKernelTimeProcess: NumGet(lpKernelTimeProcess, 0, "Int64")
        , lpUserTimeProcess: NumGet(lpUserTimeProcess, 0, "Int64")
        , tickPrior: A_TickCount
        , usagePrior: result}

    return result
}

setSeDebugPrivilege(enable := true) {
    h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", DllCall("GetCurrentProcessId"), "Ptr")
    if (!h)
        return false

    hToken := 0
    if (!DllCall("Advapi32.dll\OpenProcessToken", "Ptr", h, "UInt", 32, "Ptr*", &hToken)) {
        DllCall("CloseHandle", "Ptr", h)
        return false
    }

    SE_PRIVILEGE_ENABLED := 0x00000002
    TOKEN_QUERY := 0x0008
    TOKEN_ADJUST_PRIVILEGES := 0x0020

    LUID := Buffer(8, 0)
    if (!DllCall("Advapi32.dll\LookupPrivilegeValue", "Ptr", 0, "Str", "SeDebugPrivilege", "Ptr", LUID)) {
        DllCall("CloseHandle", "Ptr", hToken)
        DllCall("CloseHandle", "Ptr", h)
        return false
    }

    NewState := Buffer(16, 0)
    NumPut("UInt", 1, NewState, 0)
    NumPut("Int64", NumGet(LUID, 0, "Int64"), NewState, 4)
    NumPut("UInt", enable ? SE_PRIVILEGE_ENABLED : 0, NewState, 12)

    result := DllCall("Advapi32.dll\AdjustTokenPrivileges", "Ptr", hToken, "Int", false, "Ptr", NewState, "UInt", 0, "Ptr", 0, "Ptr", 0)

    DllCall("CloseHandle", "Ptr", hToken)
    DllCall("CloseHandle", "Ptr", h)
    return result
}

GetProcessElevated(ProcessID) {
    hProcess := DllCall("OpenProcess", "UInt", 0x1000, "Int", 0, "UInt", ProcessID, "Ptr")
    if (!hProcess)
        throw Error("OpenProcess failed: " A_LastError, -1)

    hToken := 0
    if (!DllCall("Advapi32.dll\OpenProcessToken", "Ptr", hProcess, "UInt", 0x0008, "Ptr*", &hToken)) {
        DllCall("CloseHandle", "Ptr", hProcess)
        throw Error("OpenProcessToken failed: " A_LastError, -1)
    }

    IsElevated := 0
    if (!DllCall("Advapi32.dll\GetTokenInformation", "Ptr", hToken, "Int", 20, "UInt*", &IsElevated, "UInt", 4, "UInt*", &size := 0)) {
        DllCall("CloseHandle", "Ptr", hToken)
        DllCall("CloseHandle", "Ptr", hProcess)
        throw Error("GetTokenInformation failed: " A_LastError, -1)
    }

    DllCall("CloseHandle", "Ptr", hToken)
    DllCall("CloseHandle", "Ptr", hProcess)
    return IsElevated
}

SetWindowTheme(handle) {
    if (A_OSVersion = "WIN_10" || A_OSVersion = "WIN_11") {
        ClassName := Buffer(1024, 0)
        if (DllCall("User32.dll\GetClassName", "Ptr", handle, "Str", ClassName, "Int", 512)) {
            if (StrGet(ClassName) = "SysListView32" || StrGet(ClassName) = "SysTreeView32") {
                if (!DllCall("Uxtheme.dll\SetWindowTheme", "Ptr", handle, "WStr", "Explorer", "Ptr", 0))
                    return true
            }
        }
    }
    return false
}

; Global hotkeys
#HotIf WinActive(AppWindow)

F5:: Fill_LVP()

Del:: {
    currFocus := ControlGetFocus("A")
    if (currFocus = MainGui["Query"].hwnd || currFocus = MainGui["TypedRefreshPeriod"].hwnd) {
        Send("^a{Del}{Enter}")
    } else if (currFocus = LVP.Hwnd) {
        Kill()
    }
}

#HotIf