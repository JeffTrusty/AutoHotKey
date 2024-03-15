; COM Inspector v1.0.1 from Alguimist  https://www.autohotkey.com/boards/viewtopic.php?t=10157
; Based on CLSID Registry Scanner and iTypeInfo (credits to jethrow)
; https://autohotkey.com/board/topic/57339-clsid-registry-scanner-comactivex/
; https://autohotkey.com/board/topic/78967-enumerate-com-object-members-itypeinfo/
; More COM resources here: https://the-Automator.com/COM

#NoEnv
#SingleInstance Off
;~ #NoTrayIcon ;Joe Glines commented out
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
;SetRegView 32 ; Read entries from HKCR\Wow6432Node\CLSID when using x64 AHK

Global Entries := {}
;~ Menu Tray, Icon, %A_ScriptDir%\lib\COM Inspector.ico
COMInspectorIcon:="C:\WINDOWS\system32\shell32.dll"
Menu, Tray, Icon, %COMInspectorIcon%,57 ;Set custom Script icon

Gui Main: New, +LabelMain +hWndhMainWnd +Resize

Menu FileMenu, Add, Export as CSV`tCtrl+S, Export
Menu FileMenu, Add
Menu FileMenu, Add, E&xit`tEsc, MainClose

Menu EditMenu, Add, Copy CLSID, Copy
Menu EditMenu, Add, Copy ProgID, Copy
Menu EditMenu, Add, Copy Description, Copy
Menu EditMenu, Add
Menu EditMenu, Add, Copy All Rows, Copy

Menu ClassMenu, Add, Inspect Interface`tCtrl+I, InspectInterface
Menu ClassMenu, Add
Menu ClassMenu, Add, Properties`tCtrl+P, ShowProperties
Menu ClassMenu, Add
Menu ClassMenu, Add, Advanced Search..., AdvancedSearch

Menu HelpMenu, Add, COM Object Reference (AHK Forum), OnlineRef
Menu HelpMenu, Add
Menu HelpMenu, Add, About, ShowAbout

Menu MenuBar, Add, &File, :FileMenu
Menu MenuBar, Add, &Edit, :EditMenu
Menu MenuBar, Add, &Class, :ClassMenu
Menu MenuBar, Add, &Help, :HelpMenu
Gui Menu, MenuBar

Gui Font, s9, Segoe UI
Gui Color, 0xF1F5FB
Gui Add, ListView, hWndhMainList vMainList gListViewHandler x0 y0 w864 h446 +LV0x14000, Class ID|ProgID|Description
Gui Add, ComboBox, hWndhCbxSearch vKeyword gSearch x10 y456 w240
Gui Add, Text, vLblSearch x267 y456 w64 h23 +0x200, Search in:
Gui Add, CheckBox, vChkCLSID gSearch x335 y456 w64 h23 +Checked, CLSID
Gui Add, CheckBox, vChkProgID gSearch x404 y456 w68 h23 +Checked, ProgID
Gui Add, CheckBox, vChkDesc gSearch x478 y456 w87 h23 +Checked, Description
Gui Add, CheckBox, vChkRegEx gSearch x576 y456 w158 h23, Using Regular Expression
Gui Add, Text, vLblItems x758 y456 w95 h23 +0x200 +Right, Loading...
Gui Show, w864 h489, COM Inspector

LV_ModifyCol(1, 258)
LV_ModifyCol(2, 235)
LV_ModifyCol(3, 350)

GuiControl -Redraw, %hMainList%
Loop Reg, HKCR\CLSID, K
{
    If (SubStr(A_LoopRegName, 1, 1) == "{") {
        RegRead ProgID, HKCR\CLSID\%A_LoopRegName%\ProgID
        RegRead Desc, HKCR\%ProgID%
        If (Desc == "") {
            RegRead Desc, HKCR\CLSID\%A_LoopRegName%
        }

        LV_Add("", A_LoopRegName, ProgID, Desc)

        Entries[A_Index, "CLSID"] := A_LoopRegName
        Entries[A_Index, "ProgID"] := ProgID
        Entries[A_Index, "Desc"] := Desc
    }
}
GuiControl +Redraw, %hMainList%

LV_ModifyCol(1, "Sort")

GuiControl,, LblItems, % LV_GetCount() . " Items"

DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hMainList, "WStr", "Explorer", "Ptr", 0)

SearchItems =
(Join|
ADODB.Connection
CDO.Message
Excel.Application
htmlfile
InternetExplorer.Application
MSScriptControl.ScriptControl
MSXML2.DOMDocument.6.0
Outlook.Application
SAPI.SpInprocRecognizer
SAPI.SpVoice
Schedule.Service
Scripting.Dictionary
Scripting.FileSystemObject
Shell.Application
Shell.Explorer
WIA.ImageFile
WinHttp.WinHttpRequest.5.1
WMPlayer.OCX
Word.Application
WScript.Shell
)

Param = %1%
If (Param != "") {
    SearchItems := Param . "||" . SearchItems
}
GuiControl, Main:, Keyword, %SearchItems%

If (Param != "") {
    GoSub Search
} Else {
    GuiControl, Main: Focus, %hCbxSearch%
}

If (hEdit := DllCall("GetWindow", "Ptr", hCbxSearch, "UInt", GW_CHILD := 5, "Ptr")) {
    DllCall("SendMessage", "Ptr", hEdit, "UInt", 0x1501, "Ptr", 1, "WStr", "Search", "Ptr") ; EM_SETCUEBANNER
}

Menu ContextMenu, Add, Inspect Interface, InspectInterface
Menu ContextMenu, Add
Menu ContextMenu, Add, Copy CLSID, Copy
Menu ContextMenu, Add, Copy ProgID, Copy
Menu ContextMenu, Add, Copy Description, Copy
Menu ContextMenu, Add
Menu ContextMenu, Add, Copy All Rows, Copy
Menu ContextMenu, Add, Export as CSV, Export
Menu ContextMenu, Add
Menu ContextMenu, Add, Properties, ShowProperties

Gui TypeInfo: New, +LabelTypeInfo +Resize +OwnerMain
Gui Font, s9, Segoe UI
Gui Add, ListView, hWndhInfoList x8 y8 w738 h389 +LV0x14000, ID|Name|Type|Args|DocString
DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hInfoList, "WStr", "Explorer", "Ptr", 0)
LV_ModifyCOl(1, 40)
LV_ModifyCOl(2, 146)
LV_ModifyCOl(3, 70)
LV_ModifyCOl(4, 40)
LV_ModifyCOl(5, 420)
;Gui Add, Text, x10 y409 w30 h23 +0x200, IID:
;Gui Add, Edit, vIID x42 y410 w250 h21 +ReadOnly
Gui Add, Button, gTypeInfoClose x660 y409 w84 h24 +Default, &OK
Gui Show, w755 h444 Hide

;~ #Include %A_ScriptDir%\Lib\AutoXYWH.ahk
;~ #Include %A_ScriptDir%\Lib\InputBoxEx.ahk

; Advanced search initial value
WMIQuery := "Select * from Win32_ClassicCOMClassSetting where InProcServer32 like ""%ieframe.dll"""

OnMessage(0x211, "OnWM_ENTERMENULOOP")
Return

MainEscape:
MainClose:
    ExitApp

MainSize:
    If (A_EventInfo == 1) {
        Return
    }

    AutoXYWH("wh", hMainList)
    AutoXYWH("y",  hCbxSearch)
    AutoXYWH("y*", "LblSearch")
    AutoXYWH("y*", "ChkCLSID")
    AutoXYWH("y*", "ChkProgID")
    AutoXYWH("y*", "ChkDesc")
    AutoXYWH("y*", "ChkRegEx")
    AutoXYWH("xy*", "LblItems")
Return

MainContextMenu:
    If (A_GuiControl == "MainList" && LV_GetNext()) {
        Menu ContextMenu, Show
    }
Return

InspectInterface:
    Gui Main: Default
    If (Row := LV_GetNext()) {
        LV_GetText(CLSID, Row, 1)
        ShowTypeInfo(CLSID)
    }
Return

ListViewHandler:
    If (A_GuiEvent == "DoubleClick" && Row := LV_GetNext()) {
        LV_GetText(CLSID, Row, 1)
        ShowTypeInfo(CLSID)
    }
Return

ShowTypeInfo(CLSID) {
    Try {
        Obj := GetKeyState("Shift", "P")
            ? ComObjCreate(CLSID, "{00000000-0000-0000-C000-000000000046}") ; IUnknown
            : ComObjCreate(CLSID)
    } Catch e {
        Extra := (e.Extra != "") ? "`n`n" . e.Extra : ""
        MsgBox 0x2010, COM Inspector, % e.Message . Extra
        Return
    }

    pti := GetTypeInfo(Obj)
    ComMembers := EnumComMembers(pti)

    Gui TypeInfo: Default
    LV_Delete()

    Loop Parse, ComMembers, `n
    {
        Fields := StrSplit(A_loopfield, "|")
        LV_Add("", Fields[1], Fields[2], Fields[3], Fields[4], Fields[5])
    }

    Gui TypeInfo: Show,, % ComObjType(Obj, "Name") . " Interface"

    ;IID := ComObjType(Obj, "IID")
    ;GuiControl, TypeInfo:, IID, %IID%
}

TypeInfoSize:
    If (A_EventInfo == 1) {
        Return
    }

    AutoXYWH("wh", hInfoList)
    AutoXYWH("xy", "Button1")
Return

TypeInfoEscape:
TypeInfoClose:
    Gui TypeInfo: Hide
Return

GetTypeInfo(ptr) {
    If (ComObjType(ptr) == 9) {
        ptr := ComObjValue(ptr)
    }

    ; Check if *ptr* has ITypeInfo Interface
    GetTypeInfoCount := vTable(ptr, 3)
    DllCall(GetTypeInfoCount, "Ptr", ptr, "Ptr*", HasITypeInfo)
    If (!HasITypeInfo) {
        MsgBox 0x2010, COM Inspector, ITypeInfo Interface not supported.
        Return
    }

    GetTypeInfo := vTable(ptr, 4)
    If (DllCall(GetTypeInfo, "Ptr", ptr, "UInt", 0, "UInt", 0, "Ptr*", pti) == 0) {
        Return pti
    }
}

vTable(ptr, n) { ; See ComObjQuery documentation
    Return NumGet(NumGet(ptr + 0), n * A_PtrSize)
}

EnumComMembers(pti) { ; Releases ITypeInfo Interface
    Static InvKind := {1: "[method]", 2: "[get]", 4: "[put]", 8: "[putref]"}

    ; COM Methods
    GetTypeAttr := vTable(pti, 3)
    ReleaseTypeAttr := vTable(pti, 19)
    GetRefTypeOfImplType := vTable(pti, 8)
    GetRefTypeInfo := vTable(pti, 14)
    GetFuncDesc := vTable(pti, 5)
    ReleaseFuncDesc := vTable(pti, 20)
    GetDocumentation := vTable(pti, 12)

    ;GetVarDesc := vTable(pti, 6)
    ;GetNames := vTable(pti, 7)
    ;ReleaseVarDesc := vTable(pti, 21)

    ; Get cFuncs (number of functions)
    DllCall(GetTypeAttr, "Ptr", pti, "Ptr*", typeAttr)
    cFuncs := NumGet(typeAttr + 0, 40 + A_PtrSize, "Short")
    cImplTypes := NumGet(typeAttr + 0, 44 + A_PtrSize, "Short")
    DllCall(ReleaseTypeAttr, "Ptr", pti, "Ptr", typeAttr)

    ; Get Inherited Class
    If (cImplTypes) {
        DllCall(GetRefTypeOfImplType, "Ptr", pti, "Int", 0, "Int*", pRefType)
        DllCall(GetRefTypeInfo, "Ptr", pti, "Ptr", pRefType, "Ptr*", pti2)
        ; Get Interface Name
        DllCall(GetDocumentation, "Ptr", pti2, "Int", -1, "Ptr*", Name, "Ptr", 0, "Ptr", 0, "Ptr", 0)
        If (StrGet(Name) != "IDispatch") {
            t .= EnumComMembers(pti2) "`n"
        } Else {
            ObjRelease(pti2)
        }
    }

    ; Get Member IDs
    Loop %cFuncs% {
        DllCall(GetFuncDesc, "Ptr", pti, "Int", A_Index - 1, "Ptr*", FuncDesc)
        ID := NumGet(FuncDesc + 0, "Short") ; Get Member ID
        n := NumGet(FuncDesc + 0, 4 + 3 * A_PtrSize, "Int") ; Get InvKind
        Args := NumGet(FuncDesc + 0, 12 + 3 * A_PtrSize, "Short") ; Get Num of Args
        ; Opt := NumGet(FuncDesc + 0, 14 + 3 * A_PtrSize, "Short") ; Get Num of Opt Args
        DllCall(ReleaseFuncDesc, "Ptr", pti, "Ptr", FuncDesc)
        DllCall(GetDocumentation, "Ptr", pti, "Int", ID, "Ptr*", Name, "Ptr*", DocString, "Ptr", 0, "Ptr", 0)

        If (StrGet(Name, "UTF-16")) { ; Exclude Members that didn't return a Name
            t .= ID "|" StrGet(Name, "UTF-16") "|" InvKind[n] "|" Args "|" StrGet(DocString, "UTF-16") "`n"
        }
    }

    ; Formatting & cleanup
    t := SubStr(t, 1, -1)
    Sort t, ND`n
    ObjRelease(pti)

    Return t
}

Search:
    Gui Main: Submit, NoHide

    GuiControl -Redraw, %hMainList%
    LV_Delete()

    Func := ChkRegEx ? "RegExMatch" : "InStr"

    For Each, Item in Entries {
        If ((ChkProgID && %Func%(Item.ProgID, Keyword))
        || (ChkDesc && %Func%(Item.Desc, Keyword))
        || (ChkCLSID && %Func%(Item.CLSID, Keyword))) {
            LV_Add("", Item.CLSID, Item.ProgID, Item.Desc)
        }
    }

    UpdateStatusBar()

    LV_ModifyCol(1, "Sort")
    GuiControl +Redraw, %hMainList%
Return

ShowProperties:
    Gui Main: Default
    Row := LV_GetNext()
    LV_GetText(CLSID, Row, 1)

    Gui Properties: New, +LabelProperties -MinimizeBox +OwnerMain
    Gui Font, s9, Segoe UI
    Gui Add, ListView, hWndhPropList x7 y8 w430 h428 +LV0x14000, Property|Value
    LV_ModifyCol(1, 160)
    LV_ModifyCol(2, 266)
    Gui Add, Link, x9 y454 w200 h23
    , <a href="https://msdn.microsoft.com/en-us/library/aa394087(v=vs.85).aspx">Properties Reference</a>
    Gui Add, Button, gPropertiesClose x351 y449 w84 h24 Default, &OK
    Gui Show, w444 h484, Properties
    DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hPropList, "WStr", "Explorer", "Ptr", 0)

    StrQuery := "Select * from Win32_ClassicCOMClassSetting where ComponentId = '" . CLSID . "'"
    For Item in ComObjGet("winmgmts:").ExecQuery(StrQuery) {
        LV_Add("", "AppID", Item.AppID)
        LV_Add("", "AutoConvertToClsid", Item.AutoConvertToClsid)
        LV_Add("", "AutoTreatAsClsid", Item.AutoTreatAsClsid)
        ;LV_Add("", "Caption", Item.Caption)
        LV_Add("", "ComponentId", Item.ComponentId)
        LV_Add("", "Control", (Item.Control) ? "True" : "False")
        LV_Add("", "DefaultIcon", Item.DefaultIcon)
        LV_Add("", "Description", Item.Description)
        LV_Add("", "InprocHandler", Item.InprocHandler)
        LV_Add("", "InprocHandler32", Item.InprocHandler32)
        ;LV_Add("", "InprocServer", Item.InprocServer)
        LV_Add("", "InprocServer32", Item.InprocServer32)
        LV_Add("", "Insertable", (Item.Insertable) ? "True" : "False")
        ;LV_Add("", "JavaClass", (Item.JavaClass) ? "True" : "False")
        ;LV_Add("", "LocalServer", Item.LocalServer)
        LV_Add("", "LocalServer32", Item.LocalServer32)
        LV_Add("", "LongDisplayName", Item.LongDisplayName)
        LV_Add("", "ProgId", Item.ProgId)
        ;LV_Add("", "SettingID", Item.SettingID)
        LV_Add("", "ShortDisplayName", Item.ShortDisplayName)
        LV_Add("", "ThreadingModel", Item.ThreadingModel)
        LV_Add("", "ToolBoxBitmap32", Item.ToolBoxBitmap32)
        LV_Add("", "TreatAsClsid", Item.TreatAsClsid)
        LV_Add("", "TypeLibraryId", Item.TypeLibraryId)
        LV_Add("", "Version", Item.Version)
        LV_Add("", "VersionIndependentProgId", Item.VersionIndependentProgId)
    }
Return

PropertiesEscape:
PropertiesClose:
    Gui Properties: Destroy
Return

Copy:
    Gui Main: Default
    Row := LV_GetNext()

    If (A_ThisMenuItem == "Copy All Rows") {
        ControlGet Items, List,,, ahk_id %hMainList%

    } Else {
        Items := ""
        Row := 0
        Col := {"Copy CLSID": 1, "Copy ProgID": 2, "Copy Description": 3}[A_ThisMenuItem]

        While(Row := LV_GetNext(Row)) {
            LV_GetText(Text, Row, Col)
            Items .= Text . "`r`n"
        }
    }

    Clipboard := RTrim(Items, "`r`n")
Return

TypeInfoContextMenu:
PropertiesContextMenu:
    ThisGUI := A_Gui
    Menu CopyListMenu, Add, Copy List, CopyList
    Menu CopyListMenu, Show
Return

CopyList:
    ControlGet Items, List,,, % "ahk_id " . (ThisGUI == "TypeInfo" ? hInfoList : hPropList)
    Clipboard := Items
Return

Export:
    FileSelectFile Filename, S16, COM Inspector.csv, Save, Comma Delimited (*.csv)
    If (ErrorLevel) {
        Return
    }

    If (!InStr(Filename, ".csv") && !FileExist(Filename . ".csv")) {
        Filename .= ".csv"
    }

    Output := """CLSID"",""ProgID"",""Description""`r`n"
    ControlGet Items, List,,, ahk_id %hMainList%
    Loop Parse, Items, `n, `r
    {
        Output .= """" . RegExReplace(A_LoopField, "`t", """,""") . """`r`n"
    }

    FileEncoding UTF-8
    FileDelete %Filename%
    FileAppend %Output%, %Filename%
Return

OnlineRef:
    Try {
        Run http://www.autohotkey.com/board/topic/56987-com-object-reference-autohotkey-l/
    }
Return

ShowAbout:
    OnMessage(0x44, "OnMsgBox")
    Gui +OwnDialogs
    MsgBox 0x80, About, COM Inspector v1.0.0`nInformation about COM classes.
    OnMessage(0x44, "")
Return

OnMsgBox() {
	DetectHiddenWindows On
	Process Exist
	If (WinExist("ahk_class #32770 ahk_pid " . ErrorLevel)) {
        ;~ hIcon := LoadPicture(A_ScriptDir . "\..\Icons\COM Inspector.ico", "w32 Icon1", _)
		hIcon := LoadPicture(COMInspectorIcon, "w32 Icon1", _)
		SendMessage 0x172, 1, %hIcon% , Static1 ; STM_SETIMAGE
	}
}

OnWM_ENTERMENULOOP(wParam, lParam, msg, hWnd) {
    Gui Main: Default
    Command := LV_GetNext() ? "Enable" : "Disable"
    Menu EditMenu, %Command%, Copy CLSID
    Menu EditMenu, %Command%, Copy ProgID
    Menu EditMenu, %Command%, Copy Description
    Menu ClassMenu, %Command%, Inspect Interface`tCtrl+I
    Menu ClassMenu, %Command%, Properties`tCtrl+P
}

AdvancedSearch:
Content := "See Win32_ClassicCOMClassSetting on <a href=""https://msdn.microsoft.com/en-us/library/aa394087(v=vs.85).aspx"">MSDN</a> for details.`n"

WMIQuery := InputBoxEx("WMI Query",Content,"Advanced Search",WMIQuery,"","",hMainWnd,600,"",COMInspectorIcon )
        ;~ , A_ScriptDir . "\..\Icons\COM Inspector.ico"

If (!ErrorLevel && WMIQuery != "") {
        Gui Main: Default
        LV_Delete()

        For Item in ComObjGet("winmgmts:").ExecQuery(WMIQuery) {
            LV_Add("", Item.ComponentId, Item.ProgId, Item.Description)
        }

        UpdateStatusBar()
    }
Return

UpdateStatusBar() {
    Gui Main: Default
    Count := LV_GetCount()
    GuiControl,, LblItems, % Count == 0 ? "Not Found" : (Count == 1) ? "1 Item" : Count . " Items"
}

;********************InputBoxEx - originally in separate file as #include ***********************************
InputBoxEx(Instruction := "", Content := "", Title := "", Default := "", Control := "", Options := "", Owner := "", Width := "", Pos := "", Icon := "", IconIndex := 1, WindowOptions := "", Timeout := "") {
    Static hWnd, py, p1, p2, c, cy, ch, Input, e, ey, eh, f, ww, ExitCode

    Gui New, hWndhWnd LabelInputBoxEx -0xA0000
    Gui % (Owner) ? "+Owner" . Owner : ""
    Gui Font
    Gui Color, White
    Gui Margin, 10, 12
    py := 10
    Width := (Width) ? Width : 430

    If (Instruction != "") {
        Gui Font, s12 c0x003399, Segoe UI
        Gui Add, Text, vp1 y10, %Instruction%
        py := 40
    }

    Gui Font, s9 cDefault, Segoe UI

    If (Content != "") {
        Gui Add, Link, % "vp2 x10 y" . py . " w" . (Width - 20), %Content%
    }

    GuicontrolGet c, Pos, % (Content != "") ? "p2" : "p1"
    py := (Instruction != "" || Content !="") ? (cy + ch + 16) : 22
    Gui Add, % (Control != "") ? Control : "Edit", % "vInput x10 y" . py . " w" . (Width - 20) . "h21 " . Options, %Default%

    GuiControlGet e, Pos, Input
    py := ey + eh + 20
    Gui Add, Text, hWndf y%py% -Background +Border ; Footer

    Gui Add, Button, % "gInputBoxExOK x" . (Width - 176) . " yp+12 w80 h23 Default", &OK
    Gui Add, Button, % "gInputBoxExClose xp+86 yp w80 h23", &Cancel

    Gui Show, % "w" . Width . " " . Pos, %Title%
    Gui +SysMenu %WindowOptions%
    If (Icon != "") {
        hIcon := LoadPicture(Icon, "Icon" . IconIndex, ErrorLevel)
        SendMessage 0x80, 0, hIcon,, ahk_id %hWnd% ; WM_SETICON
    }

    WinGetPos,,, ww,, ahk_id %hWnd%
    Guicontrol MoveDraw, %f%, % "x-1 " . " w" . ww . " h" . 48

    If (Timeout) {
        SetTimer InputBoxExTIMEOUT, % Round(Timeout) * 1000
    }

    If (Owner) {
        WinSet Disable,, ahk_id %Owner%
    }

    GuiControl Focus, Input
    Gui Font

    WinWaitClose ahk_id %hWnd%
    ErrorLevel := ExitCode
    Return Input

    InputBoxExESCAPE:
    InputBoxExCLOSE:
    InputBoxExTIMEOUT:
    InputBoxExOK:
        SetTimer InputBoxExTIMEOUT, Delete

        If (Owner) {
            WinSet Enable,, ahk_id %Owner%
        }

        Gui %hWnd%: Submit
        Gui %hWnd%: Destroy
        ExitCode := (A_ThisLabel == "InputBoxExOK") ? 0 : (A_ThisLabel == "InputBoxExTIMEOUT") ? 2 : 1
    Return
}


; =================================================================================
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;             add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
; ---------------------------------------------------------------------------------
; Version: 2015-5-29 / Added 'reset' option (by tmplinshi)
;          2014-7-03 / toralf
;          2014-1-2  / tmplinshi
; requires AHK version : 1.1.13.01+
; =================================================================================
AutoXYWH(DimSize, cList*) {       ; http://ahkscript.org/boards/viewtopic.php?t=1079
    Static cInfo := {}
 
    If (DimSize = "reset") {
        Return cInfo := {}
    }
 
    For i, ctrl in cList {
        ctrlID := A_Gui ":" ctrl
        If (cInfo[ctrlID].x = "") {
            GuiControlGet i, %A_Gui%: Pos, %ctrl%
            MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
            fx := fy := fw := fh := 0
            For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) {
                If (!RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", f%dim%)) {
                    f%dim% := 1
                }
            }
            cInfo[ctrlID] := {x: ix, fx: fx, y: iy, fy: fy, w: iw, fw: fw, h: ih, fh: fh, gw: A_GuiWidth, gh: A_GuiHeight, a: a, m: MMD}
        } Else If (cInfo[ctrlID].a.1) {
            dgx := dgw := A_GuiWidth - cInfo[ctrlID].gw, dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
            Options := ""
            For i, dim in cInfo[ctrlID]["a"] {
                Options .= dim . (dg%dim% * cInfo[ctrlID]["f" . dim] + cInfo[ctrlID][dim]) . A_Space
            }
            GuiControl, % A_Gui ":" cInfo[ctrlID].m, % ctrl, % Options
        }
    }
}

