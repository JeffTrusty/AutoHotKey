#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; script will stay running after the auto-execute section (top part of the script) completes
#SingleInstance Force ; Replaces the old instance of this script automatically
SendMode Input ; Recommended for new scripts due to its superior speed and reliability

#Include MS4000.ahk
SetTitleMatchMode,2
return ; nothing to do in the main part of the script

; === Use the zoom button to scroll ===
DoScroll:
    if (ScrollDir = 1)
        SendInput, {WheelUp}
    else
        SendInput, {WheelDown}
    return

MsNatural4000_ZoomDown:
    ScrollDir := 2
    GoSub, DoScroll
    SetTimer, DoScroll, 80
    return

MsNatural4000_ZoomUp:
    ScrollDir := 1
    GoSub, DoScroll
    SetTimer, DoScroll, 80
    return

MsNatural4000_KeyUp:
    ScrollDir := 0
    SetTimer, DoScroll, Off
    return
; ======

; === Example of using modifiers while pressing a button ===
MsNatural4000_MyFavorites:
    if MsNatural4000.keyModifiers.Shift {
        MsgBox Shift and MyFavorites button
        return
    }

    if MsNatural4000_keyModifiers.LCtrl and MsNatural4000.keyModifiers.RCtrl {
        MsgBox LeftCtrl+RightCtrl and MyFavorites button
        return
    }

    if MsNatural4000.keyModifiers.Fn {
        MsgBox "My Favorites Button while Fn-lock is Enabled"
    }

    return
; ======

; === Map extra numpad's keys to their ordinary functionality ===
; numpad "="
MsNatural4000_NumpadEqual:
    Send {=}
    return

; numpad "("
MsNatural4000_NumpadLeftBracket:
    Send {(}
    return

; numpad ")"
MsNatural4000_NumpadRightBracket:
    Send {)}
    return
; ======

; === Use favorites buttons ===
MsNatural4000_Favorites1:
    Sendraw, Sun25Day!
    Send, {enter}
    return

MsNatural4000_Favorites2:
    Sendraw, Dr@g0n
    Send, {enter}
    return

MsNatural4000_Favorites3:
    Sendraw, tarbaby1
    Send, {enter}
    return

MsNatural4000_Favorites4:
    MsgBox Favorites 4
    return

MsNatural4000_Favorites5:
    Reload
; ======

#n:: Run Notepad.exe

#c:: Run Chrome.exe

;Google search of highlighted text
#g::
{
    Send, ^c
    Sleep 50
    Run, https://www.google.com/search?q=%clipboard%
    Return
}


; Lock workstation
; AppsKey::DllCall("user32.dll\LockWorkStation")

Browser_Home::
If WinActive("America First Credit Union")
    {
        Sendraw, 3422995
        Send, {Enter}
        Sleep 400
        Sendraw, Sun25Day!
        Send, {Enter}
    }
    Return


Browser_Search::
If WinActive("America First Credit Union")
    {
        Send, 3623840
        Send, {Enter}
        Sleep 400
        Sendraw, tarbaby1
        Send, {Enter}
    }
    Return


Launch_Mail::
    DllCall("user32.dll\LockWorkStation")
    Return

::lorem::Remember, a Jedi can feel the Force flowing through him. You mean it controls your actions? Partially. But it also obeys your commands.


; when I type j@ AHK will type my email address
:*:j@::jeff.trusty@gmail.com ; *=don't require a white-space character (tab, space, return)
;:or:j@::jeff.trusty@gmail.com ; place options between the starting colons. o=alltrim of the replacement text, r=don't interprupt special keys (!^#+), *=don't require a white-space Character (tab, space, return)

;:*:@cl::console.log();


; encrypt AHK files
; youtube.com/watch?v=bYIuZ1u3Ux0

; Master AHK tray Icon
; Youtu.be/6sZs-oJKFTk

; Change AHK tray icon
; Youtu.be/gTY2sXZvGnk

; AHK GUIs
; https://www.youtube.com/watch?v=oQHz1E7j4i0&t=4s

;  # = Windows Key, ^ = Ctrl, ! = Alt, < = Left-Alt, > = Right-Alt, + = Shift, & combines mouse and keyboard

; Get currently active window title
#w::
{
WinGetTitle, Title, A
MsgBox,, The active window is: %Title% ,, 4
Return
}

; If in JavaScript file
#IfWinActive, .js
    :*:@cl::Console.Log("");
    return
#If

; If in Excel
#IfWinActive,, xls
{
    ; Todays date
    ^+t::
    SendInput, %A_YYYY%-%A_MM%-%A_DD%
    Send {Enter}
    Return

    ; First of current year
    ^+y::
    FormatTime, boyDate,%A_YYYY%0101, MM/dd/yyyy
    ; MsgBox,, FirstOfYearDate, %boyDate%, 5
    Send, %boyDate%
    Return

    ; Last date of current year
    ^+r::
    FormatTime, eoyDate,%A_YYYY%1231, MM/dd/yyyy
    ; MsgBox,, EndOfYearDate, %eoyDate%, 5
    Send, %eoyDate%
    Return


    ; First of current month
    ^+m::
    FormatTime, bomDate,%A_YYYY%%A_MM%01, MM/dd/yyyy
    ; MsgBox,, FirstOfMonthDate, %bomDate%, 5
    Send, %bomDate%
    Return

    ; End of current Month
    ^+h::
    EOM := endOfMonth(%A_YYYY%-%A_MM%-%A_DD%)
    FormatTime, eomDate,%EOM%, MM/dd/yyyy
    ; MsgBox,, EndOfMonthDate, %eomDate%, 5
    Send, %eomDate%
    Return

    ; Yesterday
    ^+NumpadSub::
    yesterday := DateAdd(%A_NOW%,-1,"Days")
    FormatTime, yesterday, % yesterday, MM/dd/yyyy
    ; MsgBox,, YesterdaysDate, %yesterday%, 5
    Send, %yesterday%
    Return

    ; Tomorrow
    ^+NumpadAdd::
    tomorrow := DateAdd(%A_NOW%,+1,"Days")
    FormatTime, tomorrow, % tomorrow, MM/dd/yyyy
    ; MsgBox,, tomorrowsDate, %tomorrow%, 5
    Send, %tomorrow%
    Return


    endOfMonth(date)
    {
        ; get current month and year
        FormatTime, date, %date%, yyyyMM
        StringRight, month, date, 2
        FormatTime, year, %date%, yyyy
        ; select first day of the following month
        If month < 12
        {
            month++
            If month < 10 ; add leading zero
                month = 0%month%
            date = %year%%month%01
        }
        Else
        {
            year++
            date = %year%0101
        }
        ; select last day of actual month
        date += -1, Days
        ; return date
        Return date
    }

    DateAdd(DateTime, Time, TimeUnits)
    {
        EnvAdd, DateTime, % Time, % TimeUnits
        return DateTime
    }


}
