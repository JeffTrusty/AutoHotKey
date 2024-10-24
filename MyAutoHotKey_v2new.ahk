﻿#Requires AutoHotkey v2.0+
#MaxThreadsPerHotkey 5 ; allow same hotkey to be run while it is already running IE a hotkey to toggle something
Persistent ; script will stay running after the auto-execute section (top part of the script) completes
#SingleInstance Force ; Replaces the old instance of this script automatically
#UseHook
InstallKeybdHook()
SendMode("Input") ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir(A_ScriptDir) ; Ensure consistent working dir.
SetNumLockState("AlwaysOn")
SetCapsLockState("AlwaysOff")
SetScrollLockState("AlwaysOff")
SetTitleMatchMode(2)
DetectHiddenWindows(true)
CoordMode("Mouse", "Screen")
TraySetIcon 'C:\Development\AHK\Jjt Avatar.png'
A_crlf := "`r`n"

if !WinExist("NoScreenLock.ahk")
    Run("C:\Development\AHK\NoScreenLock.ahk")
if !WinExist("GetActivefilePath.ahk")
    Run("C:\Development\AHK\GetActivePath\GetActivefilePath.ahk") ; Win-P
if !WinExist("FlexiFinder.ahk")
    Run("C:\Development\AHK\FlexiFinder\FlexiFinder.ahk") ; Win-F
; if !WinExist("DockWin.ahk")
;     Run("C:\Development\AHK\Misc\DockWin.ahk")
; if !WinExist("AHKScriptHub.ahk")
;     Run("C:\Development\AHK\Misc\AHKScriptHub.ahk")
; Sleep(2000) ; wait 2 seconds
; if !WinExist("AHKHotkeyStringLookup.ahk")
;     Run("C:\Development\AHK\Misc\AHKHotkeyStringLookup.ahk")
Variables:
    MSID := "jtrusty"
    PrimaryPassword := "jjt-083731214900"
    Return

    /*
    Control-Shift-2: ; Move applications to left screen
    ^+2:: ;Move applications to left screen
    {
        WinGetPos,X,Y,,,SimpleSpy - the-Automator.com
        if (X!=0) {
            WinMove, SimpleSpy - the-Automator.com,,-500, 10
            WinRestore, SimpleSpy - the-Automator.com
        }
        WinGetPos,X,Y,,,Window Spy
        if (X!=0) {
            WinMove, Window Spy,,-380, 290
            WinRestore, Window Spy
        }
        WinGetPos,X,Y,,,ahk_exe EXCEL.EXE
        if (X!=0) {
            WinMove, ahk_exe EXCEL.EXE,,-2560, 50
            WinRestore, ahk_exe EXCEL.EXE
        }
        WinGetPos,X,Y,,,ahk_exe Code.exe
        if (X!=0) {
            WinMove, ahk_exe Code.exe,,-2475, 100
            WinRestore, ahk_exe Code.exe
        }

        ; MsgBox, % X
        Return
    }

    */
Mouse_Controls:
    WheelLeft:: ; Wheel-Left Mouse Button move active window to mouse position
    {
        MouseGetPos &x, &y
        WinMove(x, y, , , "A")
        Return
    }

    MButton:: ; Middle Mouse Button move active window to mouse position
    {
        SendInput '31214900'
        ; Run("C:\Development\AHK\PopupMenu\DisplayPopupMenuV2.ahk")
    }

    ::Wheel-Right::Quick Access PopupQuick Access Popup

Control_Modifiers:

    $^[:: ; Wrap highlighted text with []  ** DOES NOT WORK AS EXPECTED IN VS CODE **
    {
        oldClip := ClipboardAll() ; Save the existing clipboard
        A_Clipboard := "" ; clear the clipboard
        Send "^c" ; copy to the clipboard whatever is highlighted if anything

        SendText("[")
        Send("^v")      ; paste what was highlighted
        SendText("]")
        A_Clipboard := oldClip ; Restore the clipboard

    }

    ; #HotIf WinActive('- Notepad') ; Only run if Notepad
    ; ^F1::
    ; {
    ;     MsgBox("Ctrl-F1 pressed while in Notepad")
    ;     Return
    ; }
    ; #HotIf

    ^1:: ; Open AFCU.xlsm
    {
        Run("C:\Users\jeff_\OneDrive\Documents\AFCU.xlsm")
        return
    }

    ^2:: ; Open Austin.xls
    {
        Run("C:\Users\jeff_\OneDrive\Documents\Austin Hours.xlsx")
        return
    }

    ^3:: ;Jeff AFCU login
    { ; V1toV2: Added bracket
        If WinActive("America First Credit Union") {
            Send("{Raw}3422995")
            Send("{Enter}")
            Sleep(2000)
            Send("{Raw}Sun25Day!")
            Send("{Enter}")
            Return
        }
    } ; V1toV2: Added Bracket before hotkey or Hotstring

    ^4:: ;Sherry AFCU login
    { ; V1toV2: Added bracket
        If WinActive("America First Credit Union") {
            Send(3623840)
            Send("{Enter}")
            Sleep(2000)
            Send("{Raw}tarbaby1")
            Send("{Enter}")
            Return
        }
    } ; V1toV2: Added Bracket before hotkey or Hotstring

    ^5:: ;Austin AFCU login
    { ; V1toV2: Added bracket
        If WinActive("America First Credit Union") {
            Send(24238511)
            Send("{Enter}")
            Sleep(2000)
            Send("{Raw}5Gjk3WvW77jb65H7w3hMmcCH")
            Send("{Enter}")
            Return
        }
    } ; V1toV2: Added Bracket before hotkey or Hotstring

    ^6:: ;BitWarden Password
    {
        send("{Raw}Suddenly706(metal(meat((")
    }
    ^0:: ; Reset Ctrl, Alt, Shift state and reload AHK script
    {
        Send("{Alt Up}")
        Send("{Ctrl Up}")
        Send("{Shift Up}")
        Send("{LWinUp}")
        Reload()
        Return
    }

ControlShift_Modifiers:
    ^+1:: ; Move applications to primary screen
    {
        WinMove(0, 40, 1885, 1010, "ahk_exe vivaldi.exe")
        ; WinMove(500, 0, 1900, 1025, "- Files")
        ; If WinActive("'ahk_class dopus.lister") {
        WinMove(500, 0, 1900, 1025, "ahk_class dopus.lister ahk_exe dopus.exe")
        ; }
        If WinActive('ahk_exe EXCEL.EXE') {
            WinMove(1450, 350, 1100, 990, "ahk_exe EXCEL.EXE")
        }
    }

    ^+a:: ; Run Move Active Window to primary screen
    {
        ; Run C:\Development\AHK\ShowActiveWindow.ahk
        ; Return
        MouseGetPos(&x, &y)
        WinMove(x, y, , , "A")
        Return
    }

    ^+d:: ;Safe In Cloud master password
    {
        Send("Dr@g0n{Enter}")
        Return
    }

    ^+m:: ; Move active window to mouse position
    {
        MouseGetPos(&x, &y)
        WinMove(x, y, , , "A")
        Return
    }

    ^!r:: ; Ctrl-Alt-r run macro recorder
    {
        Run("`"C:\Development\AHK\AHK-Recorder.ahk`"")
        Return
    }

    ^+t:: ; Run AHK-Toolkit
    {
        Run("C:\Development\AHK\AHK-ToolKit.exe")
        ;Run "C:\Development\AHK\Quick AHKv2 Converter\Quick AHKv2 Converter.exe"
        Return
    }

    ^+v:: ; Ctrl-Shift-V paste last 3 clipboard items
    {
        Send("#v")
        Sleep 100
        Send("{Down}{Down}{Enter}")
    }

    F13:: ; Upper forward mouse button
    {
        MsgBox("Upper forward mouse button")
    }
    F14:: ; Upper middle mouse button
    {
        MsgBox("Upper middle mouse button")
    }
    F15:: ; Upper rear mouse button
    {
        MsgBox("Upper rear mouse button")
    }

Windows_Modifiers:
    #c:: ;Run Chrome Browser
    {
        Run("Chrome.exe")
        Return
    }

    #e:: ;Run Directory Opus
    {
        Run("C:\Program Files\GPSoftware\Directory Opus\dopus.exe")
        Return
    }

    #g:: ;Google search of highlighted text
    {
        Send("^c")
        Sleep(50)
        Run("https://www.google.com/search?q=" A_Clipboard)
        Return
    }

    #n:: ;Open Code with Temp file
    {
        Run("`"C:\Users\jeff_\AppData\Local\Programs\Microsoft VS Code\Code.exe`" c:\Temp\Temp.md")
        Return
    }

    ; #o:: ;Run Obsidian
    ;     {
    ;         Run C:\Users\jeff_\AppData\Local\Obsidian\Obsidian.exe
    ;         Return
    ;     }

Windows_W: ; Get currently active window title
    #w:: ; Get currently active window title
    {
        Title := WinGetTitle("A")
        MsgBox("", "The active window is: " Title, "T4")
        Return
    }

    ; #^!+W:: ; Office key
    ; msgbox "Office key"
    ; ; Send ^!+W
    ; return

    #+F21:: Run("https://www.google.com") ;Search button on lxm-1000

    #+s:: MsgBox("`"Snipping Key`"") ; on lxm-1000
    #Tab:: MsgBox("`"Win+Tab or Next to Snipping Key`"") ; on lxm-1000
    ; #l::MsgBox("`"Lock Button`"") ; on lxm-1000

Alt_Modifiers:
    ; Alt_M: ;Display mouse position relative to active application
    ; !m:: ;Alt-M: Display mouse position relative to active application
    ;     {
    ;         xpos := "0"
    ;         ypos := "0"
    ;         MouseGetPos(&xpos, &ypos)
    ;         MsgBox("Mouse Position X: " xpos " Y: " ypos ", "  5", "Mouse Position", "")
    ;         return
    ;     }

    ; encrypt AHK files
    ; youtube.com/watch?v=bYIuZ1u3Ux0

    ; Master AHK tray Icon
    ; Youtu.be/6sZs-oJKFTk

    ; Change AHK tray icon
    ; Youtu.be/gTY2sXZvGnk

    ; AHK GUIs
    ; https://www.youtube.com/watch?v=oQHz1E7j4i0&t=4s

    ;  # = Windows Key, ^ = Ctrl, ! = Alt, < = Left-Alt, > = Right-Alt, + = Shift, & combines mouse and keyboard

HotStrings:
    :*:.s1::-SqlInstance $SQL1
    :*:.s2::-SqlInstance $SQL2
    :*:@gm::jeff.trusty@gmail.com ; *=don't require a white-space character (tab, space, return)
    :*:@op::jeff.trusty@optum.com ; *=don't require a white-space character (tab, space, return)
    :*:@ho::jeff_trusty@hotmail.com ; *=don't require a white-space character (tab, space, return)
    :*:@cl::console.log(````);{Left}{Left}{Left}
    :*:jjt::jjt-0837{enter}
    :*:QAP::Quick Access Popup
    :SEK10*:/ahk::AutoHotKey ; SE=SendEvent K10=KeyDelay 10ms
    ::lorem:: ; Jedi Lorem
    {
        A_Clipboard := "Remember, a Jedi can feel the Force flowing through him. You mean it controls your actions? Partially. But it also obeys your commands."
        Send "^v"
        Return
    }

    :R*?:dddd:: ;Today's date
    {
        CurrentDateTime := FormatTime(, "MMM-dd-yyyy")
        SendInput(CurrentDateTime)
        return
    }

    ; ;:or:j@::jeff.trusty@gmail.com ; place options between the starting colons. o=alltrim of the replacement text, r=don't interprupt special keys (!^#+), *=don't require a white-space Character (tab, space, return)

    ::Fav1::VS Code
    ::Fav2::Azure Data Studio
    ::Fav3::Edge Browser
    ::Ofc-D::OneDrive
    ::Ofc-X::Excel
    ::Ofc-N::VS Code Temp.md
    ::Ofc-O::Outlook
    ::Ofc-P::PowerPoint
    ::Ofc-T::Teams
    ::Ofc-W::Word
    ; ::Alt_F1::Bring up AHK HotString definitions

