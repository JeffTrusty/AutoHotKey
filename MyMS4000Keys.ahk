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
        Send, Dr@g0n{Enter}
        Return
    }

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
    Run, C:\Users\jeff_\OneDrive\Documents\AFCU.xlsm
    return

MsNatural4000_Favorites2:
    Run, C:\Users\jeff_\OneDrive\Documents\Austin Hours.xlsx
    return

MsNatural4000_Favorites3:
    Run, C:\Users\jeff_\OneDrive\Documents\Milage.xlsx
    return

MsNatural4000_Favorites4:
    Run, C:\Users\jeff_\OneDrive\Documents\PowerConsumption.xlsx
    return

MsNatural4000_Favorites5:
    Reload
    Return

; ======

Browser_Home:: ;AFCU My login
If WinActive("America First Credit Union")
    {
        Sendraw, 3422995
        Send, {Enter}
        Sleep 400
        Sendraw, Sun25Day!
        Send, {Enter}
    }
    Return

Browser_Search:: ;AFCU Sherry's login
If WinActive("America First Credit Union")
    {
        Send, 3623840
        Send, {Enter}
        Sleep 400
        Sendraw, tarbaby1
        Send, {Enter}
    }
    Return


Launch_Mail:: ;Lock computer
{
    DllCall("user32.dll\LockWorkStation")
    Return
}
