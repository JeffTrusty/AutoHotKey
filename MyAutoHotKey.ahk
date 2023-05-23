#Requires Autohotkey v1.1.36+ 64-Bit
#Include C:\Development\AHK\startupDirectives.ahk ; default settings
; #Include C:\Development\AHK\MS4000.ahk  ; Hooks for MS 4000 keyboard
; #Include C:\Development\AHK\MS-LXM-1000.ahk  ; Hooks for MS LXM-1000 keyboard
; #Include C:\Development\AHK\MyMS4000Keys.ahk
; #Include C:\Development\AHK\AppsKey.ahk
IfWinNotExist, NoScreenLock.ahk
    Run, C:\Development\AHK\NoScreenLock.ahk
IfWinNotExist, AHKScriptHub.ahk
    Run, C:\Development\AHK\AHKScriptHub.ahk
sleep, 2000 ; wait 2 seconds
IfWinNotExist, AHKHotkeyStringLookup.ahk
    Run, C:\Development\AHK\AHKHotkeyStringLookup.ahk
Variables:
MSID := "jtrusty"
PrimaryPassword := "jjt-083731214900"
Return


; Control-Shift-2: ; Move applications to left screen
; ^+2:: ;Move applications to left screen
; {
;     WinGetPos,X,Y,,,SimpleSpy - the-Automator.com
;     if (X!=0) {
;         WinMove, SimpleSpy - the-Automator.com,,-500, 10
;         WinRestore, SimpleSpy - the-Automator.com
;     }
;     WinGetPos,X,Y,,,Window Spy
;     if (X!=0) {
;         WinMove, Window Spy,,-380, 290
;         WinRestore, Window Spy
;     }
;     WinGetPos,X,Y,,,ahk_exe EXCEL.EXE
;     if (X!=0) {
;         WinMove, ahk_exe EXCEL.EXE,,-2560, 50
;         WinRestore, ahk_exe EXCEL.EXE
;     }
;     WinGetPos,X,Y,,,ahk_exe Code.exe
;     if (X!=0) {
;         WinMove, ahk_exe Code.exe,,-2475, 100
;         WinRestore, ahk_exe Code.exe
;     }

;     ; MsgBox, % X
;     Return
; }

Control_Modifiers:
^1:: ; Open AFCU.xlsm
    If WinActive(ahk_exe EXCEL.EXE)
    {
        SendRaw, ^1
    }
    Else
    {
        Run, C:\Users\jeff_\OneDrive\Documents\AFCU.xlsm
    }
    return

^2:: ; Open Austin.xls
    If WinActive(ahk_exe EXCEL.EXE)
    {
        Send, ^2
    }
    Else
    {
        Run, C:\Users\jeff_\OneDrive\Documents\Austin Hours.xlsx
    }
    return

^3:: ;Jeff AFCU login
If WinActive("America First Credit Union")
    {
        Sendraw, 3422995
        Send, {Enter}
        Sleep 400
        Sendraw, Sun25Day!
        Send, {Enter}
    }
    Return

^4:: ;Sherry AFCU login
If WinActive("America First Credit Union")
    {
        Send, 3623840
        Send, {Enter}
        Sleep 400
        Sendraw, tarbaby1
        Send, {Enter}
    }
    Return



^0:: ; Reset Ctrl, Alt, Shift state and reload AHK script
{
    Send, {Alt Up}
    Send, {Ctrl Up}
    Send, {Shift Up}
    Send, {LWinUp}
    Reload, 0
    Return
}

ControlShift_Modifiers:
^+a:: ; Run Move Active Window to primary screen
{
    ; Run C:\Development\AHK\ShowActiveWindow.ahk
    ; Return
    MouseGetPos, x, y
    WinMove A,, %x%, %y%
    Return
}

^+d:: ;Safe In Cloud master password
{
    Send, Dr@g0n{Enter}
    Return
}

/* ^+b:: ; Block Comment based on running application and title of file being edited
If WinActive("ahk_exe Ssms.exe")
{
   Send, --*/ Comment:{Enter}{Enter}{Enter}{Enter}--Commit{Enter}--RollBack{Enter}--*/
   Return
}
If WinActive("ahk_exe Code.exe") and WinGetTitle, Title, .ahk
{
   Send, */ Comment:    */
   Return
}
If WinActive("ahk_exe Code.exe") and WinGetTitle, Title, .js
{
   Send, */ Comment:    */
   Return
}
If WinActive("ahk_exe Code.exe") and WinGetTitle, Title, .html
{
   Send, <!-- Comment: -->
   Return
}
If WinActive("ahk_exe Code.exe") and WinGetTitle, Title, .css
{
   Send, */ Comment:    */
   Return
}
Return
 */
^+m::
{
    MouseGetPos, x, y
    WinMove A,, %x%, %y%
    Return
}

^!r:: ; Ctrl-Alt-r run macro recorder
{
    Run "C:\Development\AHK\AHK-Recorder.ahk"
    Return
}

^+q:: ; Run AHK-Toolkit
    {
        Run "C:\Development\AHK\AHK-ToolKit.exe"
        ;Run "C:\Development\AHK\Quick AHKv2 Converter\Quick AHKv2 Converter.exe"
        Return
    }

F13::MsgBox "F13"
F14::MsgBox "F14"
F15::MsgBox "F15"

Windows_Modifiers:
#c:: ;Run Chrome Browser
    {
        Run Chrome.exe
        Return
    }

; ControlE: ; Edit AHK Script
; ^e::edit ; Edit AHK Script

#g:: ;Google search of highlighted text
{
    Send, ^c
    Sleep 50
    Run, https://www.google.com/search?q=%clipboard%
    Return
}

#n:: ;Run Notepad
    {
        Run Notepad.exe c:\temp.txt
        Return
    }

#o:: ;Run Obsidian
    {
        Run C:\Users\jeff_\AppData\Local\Obsidian\Obsidian.exe
        Return
    }

Windows_W: ; Get currently active window title
#w:: ; Get currently active window title
    {
        WinGetTitle, Title, A
        MsgBox,, The active window is: %Title% ,, 4
        Return
    }

; #^!+W:: ; Office key
; msgbox "Office key"
; ; Send ^!+W
; return

#+F21::Run, https://www.google.com ;Search button on lxm-1000

#+s::MsgBox "Snipping Key" ; on lxm-1000
#Tab::MsgBox "Win+Tab or Next to Snipping Key" ; on lxm-1000
; #l::MsgBox "Lock Button" ; on lxm-1000

Alt_Modifiers:
Alt_M: ;Display mouse position relative to active application
!m:: ;Alt-M: Display mouse position relative to active application
{
    xpos=0
    ypos=0
    MouseGetPos, xpos, ypos
    MsgBox,, Mouse Position, Mouse Position X: %xpos% Y: %ypos%, % 5
    return
}

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
:*:@gm::jeff.trusty@gmail.com ; *=don't require a white-space character (tab, space, return)
:*:@op::jeff.trusty@optum.com ; *=don't require a white-space character (tab, space, return)
:*:@ho::jeff_trusty@hotmail.com ; *=don't require a white-space character (tab, space, return)
:*:@cl::console.log(````);{Left}{Left}{Left}
:*:jjt::jjt-0837{enter}
::lorem::Remember, a Jedi can feel the Force flowing through him. You mean it controls your actions? Partially. But it also obeys your commands.

:R*?:dddd:: ;Today's date
    {
        FormatTime, CurrentDateTime,, MMM-dd-yyyy
        SendInput %CurrentDateTime%
        return
    }

;:or:j@::jeff.trusty@gmail.com ; place options between the starting colons. o=alltrim of the replacement text, r=don't interprupt special keys (!^#+), *=don't require a white-space Character (tab, space, return)


::Fav1::VS Code
::Fav2::Free Commander
::Fav3::Obsidian
::Ofc-D::OneDrive
::Ofc-X::Excel
::Ofc-N::OneNote
::Ofc-O::Outlook
::Ofc-P::PowerPoint
::Ofc-T::Teams
::Ofc-W::Word
; ::Alt_F1::Bring up AHK HotString definitions
