#Requires AutoHotkey v2.0+
#MaxThreadsPerHotkey 5 ; allow same hotkey to be run while it is already running IE a hotkey to toggle something
Persistent ; script will stay running after the auto-execute section (top part of the script) completes
#SingleInstance Force ; Replaces the old instance of this script automatically
#UseHook
InstallKeybdHook
/*
 * ========================================================================================= *
 * @author           Jeff Trusty
 * @version          Dec.20.2024
 * @copyright        Copyright (c) 2024 Jeff Trusty
 * @modified         2024-12-20
 * @description      My AutoHotKey script for home
 * ========================================================================================= *
 */
;SendMode("Input") ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir(A_ScriptDir) ; Ensure consistent working dir.
SetNumLockState("AlwaysOn")
SetCapsLockState("AlwaysOff")
SetScrollLockState("AlwaysOff")
SetTitleMatchMode(2)
DetectHiddenWindows(true)
CoordMode("Mouse", "Screen")
TraySetIcon 'C:\Users\jeff_\OneDrive\Development\AHK\Jjt Avatar.png'
A_crlf := "`r`n"

if !WinExist("NoScreenLock.ahk")
    Run("C:\Users\jeff_\OneDrive\Development\AHK\NoScreenLock.ahk")
; if !WinExist("GetActivefilePath.ahk")
;     Run("C:\Users\jeff_\OneDrive\Documents\Development\AHK\GetActivePath\GetActiveFilePath.ahk") ; Win-P
; if !WinExist("FlexiFinder.ahk")
;     Run("C:\Users\jeff_\OneDrive\Documents\Development\AHK\FlexiFinder\FlexiFinder.ahk") ; Win-F
; if !WinExist("DockWin.ahk")
;     Run("C:\Users\jeff_\OneDrive\Documents\Development\AHK\Misc\DockWin.ahk")
; if !WinExist("AHKScriptHub.ahk")
;     Run("C:\Users\jeff_\OneDrive\Documents\Development\AHK\Misc\AHKScriptHub.ahk")
; Sleep(2000) ; wait 2 seconds
; if !WinExist("AHKHotkeyStringLookup.ahk")
;     Run("C:\Users\jeff_\OneDrive\Documents\Development\AHK\Misc\AHKHotkeyStringLookup.ahk")
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
    ^q::
    WheelLeft:: ; Wheel-Left Mouse Button move active window to mouse position
    {
        MouseGetPos &x, &y
        WinMove x, y, , , 'A'
        Return
    }

    MButton:: ; Middle Mouse Button move active window to mouse position
    {
        SendInput '31214900'
        ; Run("C:\Development\AHK\PopupMenu\DisplayPopupMenuV2.ahk")
    }

    ; ::Wheel-Right::Quick Access PopupQuick Access Popup

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

    #HotIf WinActive("America First Credit Union")
    ^3:: ;Jeff AFCU login
    {
        Send("{Raw}3422995")
        Send("{Enter}")
        Sleep(2000)
        Send("{Raw}Sun25Day!")
        Send("{Enter}")
        Return
    }

    ^4:: ;Sherry AFCU login
    {
        Send(3623840)
        Send("{Enter}")
        Sleep(2000)
        Send("{Raw}tarbaby1")
        Send("{Enter}")
        Return
    }

    ^5:: ;Austin AFCU login
    {
        Send(24238511)
        Send("{Enter}")
        Sleep(2000)
        Send("{Raw}5Gjk3WvW77jb65H7w3hMmcCH")
        Send("{Enter}")
        Return
    }
    #HotIf

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
        If WinActive('ahk_exe EXCEL.EXE')
        {
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

    ; ^+m:: ; Move active window to mouse position
    ; {
    ;     MouseGetPos(&x, &y)
    ;     WinMove(x, y, , , "A")
    ;     Return
    ; }

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
        Run("`"C:\Users\jeff_\AppData\Local\Programs\Microsoft VS Code\Code.exe`" C:\Development\AHK\temp.md")
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
    ; #Tab:: MsgBox("`"Win+Tab or Next to Snipping Key`"") ; on lxm-1000
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
    /* HotString Options:
        Place options between the first 2 colons followed by the hotstring and 2 more colons
        * Don't require white-space character to initiate (tab, space, enter)
        C Case sensitive
        O Omit ending character
        R Send RAW. Allows AHK Special characters to be sent (# ^ ! + < >)
        SE SendEvent
        SI SendInput
        SP SendPlay  may allow hotstrings to work in a broader variety of games
        T  Send Text mode IE each character by character RAW
        K10 KeyDelay 10ms
    */

HotStrings:  ; In Quick Access Popup in Snippets section
    :*:.s1::-SqlInstance $SQL1
    :*:.s2::-SqlInstance $SQL2
    :OSEK10*:@gm::jeff.trusty@gmail.com
    :OSEK10*:/gm::jeff.trusty@gmail.com
    ; :*RO:/gm::jeff.trusty@gmail.com
    ; :*:/gm::
    ; {
    ;     Clip := ClipboardAll()
    ;     A_Clipboard := "jeff.trusty@gmail.com"
    ;     Send "^v"
    ;     A_Clipboard := Clip
    ;     Return
    ; }
    ; :*:/op::
    ; {
    ;     Clip := ClipboardAll()
    ;     A_Clipboard := "jeff.trusty@optum.com"
    ;     Send "^v"
    ;     A_Clipboard := Clip
    ;     Return
    ; }
    ; :*:/ho::
    ; {
    ;     Clip := ClipboardAll()
    ;     A_Clipboard := "jeff_trusty@hotmail.com"
    ;     Send "^v"
    ;     A_Clipboard := Clip
    ;     Return
    ; }
    :*SE:/cl::console.log(````);{Left}{Left}{Left}
    :*SE:/do::Do I need to take Travis to work today?{Enter}
    :*SE:/jjt::
    {
        Clip := ClipboardAll()
        A_Clipboard := "jjt-0837{enter}"
        Send "^v"
        A_Clipboard := Clip
        Return
    }
    :*OSE:/lorem:: ; Jedi Lorem
    {
        Clip := ClipboardAll()
        A_Clipboard := "Remember, a Jedi can feel the Force flowing through him. You mean it controls your actions? Partially. But it also obeys your commands."
        Send "^v"
        A_Clipboard := Clip
        Return
    }
    :*OSE:/ahk::AutoHotKey ; SE=SendEvent K10=KeyDelay 10ms
    :*OSE:dddd:: ;Today's date
    {
        CurrentDateTime := FormatTime(, "MM-dd-yyyy")
        SendInput(CurrentDateTime)
        return
    }


    ::Fav1::VS Code
    ::Fav2::Directory Opus
    ::Fav3::Vivaldi Browser
    ::Ofc-D::OneDrive
    ::Ofc-X::Excel
    ::Ofc-N::VS Code Temp.md
    ::Ofc-O::Outlook
    ::Ofc-P::PowerPoint
    ::Ofc-T::Teams
    ::Ofc-W::Word
    ; ::Alt_F1::Bring up AHK HotString definitions

/* Function to open an application */
; OpenApp(appPath)
; {
;     if !IsSet(appPath) || appPath = ""
;     {
;         TrayTip("Error", "Invalid Application Path",2)
;     }
;     try
;     {
;         if WinExist("ahk_exe " appPath)
;         {
;             WinActivate()
;         }
;         else
;         {
;             switch appPath
;             {
;                 case 'Phone Link':
;                     RunApp(appPath)
;                 default:
;                     Run(appPath)
;             }
;     } catch Error as e
;     {
;         TrayTip("Error"), "Failed to open application: " appPath "`n" e.message,2)
;     }
; }

/* Function to run an App Store Application */
; runApp('Phone Link') ;this will launch Phone Link

runApp(appName)
{ ; https://www.autohotkey.com/boards/viewtopic.php?p=438517#p438517
    For app in ComObject('Shell.Application').NameSpace('shell:AppsFolder').Items
        (app.Name = appName) && RunWait('explorer shell:appsFolder\' app.Path)
}

