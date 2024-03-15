/*
Text Case Converter Plus+
 ╞═══════════✏ Notes ✏═══════════╡
» Light mode on by default.
» *TempText is just whats been selected/copied.
» ** If you have a case where you DONT want TempText to be pasted (like for the date Case), just put  Exit  at the end of it so it Exits the process instead of continuing down and pasting TempText (putting Exit makes it not paste TempText)

; ◦ ◦ ◦ ◦ ◦ ◦ ◦ Base Script Notes ◦ ◦ ◦ ◦ ◦ ◦ ◦
» Refresh Script ════  Ctrl + HOME key rapidly clicked 2 times. (# TapCounts)
» Exit Script ════════  Ctrl + Escape key rapidly clicked 3 times. (# TapCounts)

» Script Updater: Auto-reload script upon saved changes.
    ─ If you make any changes to the script file and save it, the script will automatically reload itself and continue running without manual intervention.
 ╞────────✏ Notes End ✏────────╡
*/

; ╞═══════════ Auto-Execute ═══════════╡
Gosub, AutoExecute

; ╞──────── Auto-Execute End ────────╡

; ╞───────────── MENUS ───────────────╡

GroupAdd All

; Menu Case, Add, • • • • • • • • • • • •,  CCase
Menu Case, Add
Menu Case, Color, D6F1FF
Menu Case, Add, &1 UPPERCASE, CCase
Menu Case, Add, &2 lowercase, CCase
Menu Case, Add, &3 Title Case, CCase
Menu Case, Add, &4 Sentence case, CCase
Menu Case, Add, &5 iNVERT cASE, CCase
; ◦ ◦ ◦ ◦ ◦ ◦ ◦
Menu Adds, Add
Menu Adds, Color, D1FFF0
Menu Adds, Add, Insert Date (MM/DD/YY), CCase
; Menu Adds, Add, Insert Degree Symbol (°), CCase
Menu Adds, Add
; ◦ ◦ ◦ ◦ ◦ ◦ ◦ ; ◦ ◦ ◦ ◦ ◦ ◦ ◦
Menu Cases Insert, Add
Menu Cases Insert, Add, raNDoM cASE, CCase
Menu Cases Insert, Add, Reverse Case - esaC esreveR, CCase
Menu Cases Insert, Add, SpOnGeBoB cAsE, CCase
Menu Cases Insert, Add, S p r e a d  T e x t C a s e, CCase
Menu Adds, Add, Other Cases: , :Cases Insert 	 ; ←←← OTHER CASES HEADER.
Menu Case, Add, Additionals: , :Adds 		 ; ←←← ADDITIONALS HEADER.
Menu Cases Insert, Add
Menu Adds, Add
Menu Case, Add
Menu Cases Insert, Color, FFF8C7
Menu Insert, Add
; ; Arrow sub-menu
; Menu Arrow, Add
; Menu Arrow, Color, FFF8C7
; Menu Arrow, Add, Insert Up Arrow (↑), CCase
; Menu Arrow, Add, Insert Down Arrow (↓), CCase
; Menu Arrow, Add, Insert Left Arrow (←), CCase
; Menu Arrow, Add, Insert Right Arrow (→), CCase
; Menu Arrow, Add
; Menu Arrow, Add, Insert Horizontal Arrow (↔), CCase
; Menu Arrow, Add, Insert Verticle Arrow (↕), CCase
; Menu Arrow, Add
; Menu Arrow, Add, Insert UpLeft Arrow (↖), CCase
; Menu Arrow, Add, Insert UpRight Arrow (↗), CCase
; Menu Arrow, Add, Insert DownRight Arrow (↘), CCase
; Menu Arrow, Add, Insert DownLeft Arrow (↙), CCase
; Menu Arrow, Add
; Bullet Sub-Menu
; Menu Bullet, Add
; Menu Bullet, Color, FFF8C7
; Menu Bullet, Add, Insert Big Dot Bullet (●), CCase
; Menu Bullet, Add, Insert Small Dot Bullet (•), CCase
; Menu Bullet, Add, Insert Big Square Bullet (■), CCase
; Menu Bullet, Add, Insert Small Square Bullet (▪), CCase
; Menu Bullet, Add
; Menu Bullet, Add, Insert Big Empty Square Bullet (☐), CCase
; Menu Bullet, Add, Insert Small Empty Square Bullet (▫), CCase
; Menu Bullet, Add, Insert Big EmptyDot Bullet (○), CCase
; Menu Bullet, Add, Insert Small Empty Dot Bullet (◦), CCase
; Menu Bullet, Add
; Menu Bullet, Add, Insert Black Diamond Bullet (◆), CCase
; Menu Bullet, Add, Insert Empty Diamond Bullet (◇), CCase
; Menu Bullet, Add, Insert Centered Diamond Bullet (◈), CCase
; Menu Bullet, Add
; Menu Bullet, Add, Insert Black Diamond Star Bullet (✦), CCase
; Menu Bullet, Add, Insert Empty Diamond Star Bullet (✧), CCase
; Menu Bullet, Add
; Enclosure Sub-Menu
; Menu Encloser, Add
; Menu Encloser, Color, FFF8C7
; Menu Encloser, Add, Insert ″...″ Quotes, CCase
; Menu Encloser, Add, Insert '...' Apostrophes, CCase
; Menu Encloser, Add, Insert `*...* Asterisks, CCase
; Menu Encloser, Add
; Menu Encloser, Add, Insert (...) Parentheses, CCase
; Menu Encloser, Add, Insert `[...] Square Brackets, CCase
; Menu Encloser, Add, Insert `{...} Curly Brackets, CCase
; Menu Encloser, Add
; Fractions eighths Sub-Menu
; Menu 8ths, Add
; Menu 8ths, Color, FFF8C7
; Menu 8ths, Add, Insert (⅛), CCase
; Menu 8ths, Add, Insert (¼), CCase
; Menu 8ths, Add, Insert (⅜), CCase
; Menu 8ths, Add, Insert (½), CCase
; Menu 8ths, Add, Insert (⅝), CCase
; Menu 8ths, Add, Insert (¾), CCase
; Menu 8ths, Add, Insert (⅞), CCase
; Menu 8ths, Add
; ╞────Fractions Fifths sub-menu
; Menu 5ths, Add
; Menu 5ths, Color, FFF8C7
; Menu 5ths, Add, Insert (⅒), CCase
; Menu 5ths, Add, Insert (⅕), CCase
; Menu 5ths, Add, Insert (⅖), CCase
; Menu 5ths, Add, Insert (⅗), CCase
; Menu 5ths, Add, Insert (⅘), CCase
; Menu 5ths, Add
; ; ╞──Fractions Thirds sub-ment
; Menu 3rds, Add
; Menu 3rds, Color, FFF8C7
; Menu 3rds, Add, Insert (↉), CCase
; Menu 3rds, Add, Insert (⅑), CCase
; Menu 3rds, Add, Insert (⅙), CCase
; Menu 3rds, Add, Insert (⅓), CCase
; Menu 3rds, Add, Insert (⅔), CCase
; Menu 3rds, Add, Insert (⅚), CCase
; Menu 3rds, Add
; Spaces sub-menu
; Menu Space, Add
; Menu Space, Color, FFF8C7
; Menu Space, Add, Insert Zero-Width ▏​▏, CCase
; Menu Space, Add, Insert Hair-Width ▏ ▏, CCase
; Menu Space, Add, Insert Six-Per-Em ▏ ▏, CCase
; Menu Space, Add, Insert Thin-Width ▏ ▏, CCase
; Menu Space, Add, Insert Punctuation ▏ ▏, CCase
; Menu Space, Add, Insert Four-Per-Em ▏ ▏, CCase
; Menu Space, Add, Insert Three-Per-Em ▏ ▏, CCase
; Menu Space, Add, Insert Figure-Width ▏ ▏, CCase
; Menu Space, Add, Insert En-Width ▏ ▏, CCase
; Menu Space, Add, Insert Em-Width ▏ ▏, CCase
; Menu Space, Add, Insert Braille-Blank ▏⠀▏, CCase
; Menu Space, Add, Insert WhiteSpaceman ▏👨🏻‍🚀▏, CCase
; Menu Space, Add
; Menu Arrow Insert, Add, Arrows: , :Arrow
; Menu Bullet Insert, Add, Bullets: , :Bullet
; Menu Encloser Insert, Add, Enclosers: , :Encloser
; ; ◦ ◦ ◦ ◦ ◦ ◦ ◦
; Menu Fraction Insert, Add
; Menu Fraction Insert, Add, Eighths: , :8ths
; Menu Fraction Insert, Add
; Menu Fraction Insert, Add, Thirds: , :3rds
; Menu Fraction Insert, Add
; Menu Fraction Insert, Add, Fifths: , :5ths
; Menu Fraction Insert, Add
; ◦ ◦ ◦ ◦ ◦ ◦ ◦
; Menu Space Insert, Add, Spaces: , :Space
; Menu Insert, Add, Arrows: , :Arrow Insert 	 ; ←←← ARROWS HEADER
; Menu Insert, Add
; Menu Insert, Add, Bullets: , :Bullet Insert 	 ; ←←← BULLETS HEADER
; Menu Insert, Add
; Menu Insert, Add, Enclosers: , :Encloser Insert 	 ; ←←← ENCLOSERS HEADER
; Menu Insert, Add
; Menu Insert, Add, Fractions: , :Fraction Insert 	 ; ←←← FRACTIONS HEADER.
; Menu Insert, Add
; Menu Insert, Add, Spaces: , :Space Insert 	 ; ←←← SPACES HEADER.
; Menu Insert, Color, D1FFF0
; Menu Case, Add, Inserts: , :Insert 		 ; ←←← INSERTS HEADER.
; Menu Insert, Add
; ◦ ◦ ◦ ◦ ◦ ◦ ◦
; Menu Case, Add
; Menu Case, Add, Toggle Dark Mode, CCase
; ; Menu Case, Add, • • • • • • • • • • • • ,  CCase
; Menu Case, Add

; ▎░░░░░░░░░ HOTKEY ░░░░░░░░░▎
#If GetKeyState("Ctrl","P")

    *Y:: 	; ←←←←←← Trigger Key
        Gosub, IndicateDot1
        Gui, Color, LIME
        Gosub, IndicateDot2
        KeyWait CapsLock,T.2
        If !ErrorLevel
        {
            KeyWait CapsLock,D T.1
            If !ErrorLevel
            {
                sleep 100
                send ^a
                sleep 200
                GetText(TempText)
                Menu Case, Show
            }
            Else
            {
                GetText(TempText)
                Menu Case, Show
            }
        }
    Return
#If

; ╞═══════════ SWITCH CASES ═══════════╡

CCase:
    Switch A_ThisMenuItem {

    ; ╞───────────── Main Cases ───────────────╡
    ; ╞─────── Press Number To Switch Case ───────╡

    Case "&1 UPPERCASE":
        StringUpper, TempText, TempText

    Case "&2 lowercase":
        StringLower, TempText, TempText

    Case "&3 Title Case":
        StringLower, TempText, TempText, T

    Case "&4 Sentence case":
        StringLower, TempText, TempText
        TempText := RegExReplace(TempText, "((?:^|[.!?]\s+)[a-z])", "$u1")

    Case "&5 iNVERT cASE":
        {
            CopyClipboardCLM()
            Inv_Char_Out := ""
            Loop % StrLen(Clipboard)
            {
                Inv_Char := SubStr(Clipboard, A_Index, 1)
                if Inv_Char is Upper
                    Inv_Char_Out := Inv_Char_Out Chr(Asc(Inv_Char) + 32)
                else if Inv_Char is Lower
                    Inv_Char_Out := Inv_Char_Out Chr(Asc(Inv_Char) - 32)
                else
                    Inv_Char_Out := Inv_Char_Out Inv_Char
            }
            Clipboard := Inv_Char_Out
            PasteClipboardCLM()
        }

    ; ╞═══════════ Additionals ═══════════╡

    Case "Insert Date (MM/DD/YY)":
        FormatTime, CurrentDateTime,,MM/dd/yy
        SendInput %CurrentDateTime%
        exit

    Case "Insert Degree Symbol (°)":
        SendInput {Raw}°
        Return

    ; ╞───────────── Other Cases ──────────────╡

    Case "SpOnGeBoB cAsE":
        {
            CopyClipboardCLM()
            Inv_Char_Out := ""
            StringLower, Clipboard, Clipboard
            Loop, Parse, Clipboard
            {
                if (Mod(A_Index, 2) = 0)
                    Inv_Char_Out .= Format("{1:L}", A_LoopField)
                else
                    Inv_Char_Out .= Format("{1:U}", A_LoopField)
            }
            Clipboard := Inv_Char_Out
            PasteClipboardCLM()
        }

    Case "S p r e a d  T e x t  C a s e":
        {
            vText := "exemple"
            TempText := % RegExReplace(TempText, "(?<=.)(?=.)", " ")
        }

    Case "raNDoM cASE":
        {
            CopyClipboardCLM()
            RandomCase := ""
            for _, v in StrSplit(Clipboard)
            {
                Random, r, 0, 1
                RandomCase .= Format("{:" (r?"L":"U") "}", v)
            }
            Clipboard := RandomCase
            PasteClipboardCLM()
        }

    Case "Reverse Case - esaC esreveR":
        Temp2 =
        StringReplace, TempText, TempText, `r`n, % Chr(29), All
        Loop Parse, TempText
            Temp2 := A_LoopField . Temp2
        StringReplace, TempText, Temp2, % Chr(29), `r`n, All

    ; ╞═══════════ Inserts ═══════════╡

    ; ╞─────────────  Arrows ──────────────────╡

    Case "Insert Up Arrow (↑)":
        SendInput {Raw}↑
        Return

    Case "Insert Down Arrow (↓)":
        SendInput {Raw}↓
        Return

    Case "Insert Left Arrow (←)":
        SendInput {Raw}←
        Return

    Case "Insert Right Arrow (→)":
        SendInput {Raw}→
        Return

    Case "Insert Horizontal Arrow (↔)":
        SendInput {Raw}↔
        Return

    Case "Insert Verticle Arrow (↕)":
        SendInput {Raw}↕
        Return

    Case "Insert UpLeft Arrow (↖)":
        SendInput {Raw}↖
        Return

    Case "Insert UpRight Arrow (↗)":
        SendInput {Raw}↗
        Return

    Case "Insert DownLeft Arrow (↙)":
        SendInput {Raw}↙
        Return

    Case "Insert DownRight Arrow (↘)":
        SendInput {Raw}↘
        Return

    ; ╞─────────────  Bullets ──────────────────╡ 5

    Case "Insert Big Dot Bullet (●)":
        SendInput {Raw}●
        Return

    Case "Insert Small Dot Bullet (•)":
        SendInput {Raw}•
        Return

    Case "Insert Big Square Bullet (■), CCase":
        SendInput {Raw}■
        Return

    Case "Insert Small Square Bullet (▪)":
        SendInput {Raw}▪
        Return

    Case "Insert Big Empty Square Bullet (☐)":
        SendInput {Raw}☐
        Return

    Case "Insert Small Empty Square Bullet (▫)":
        SendInput {Raw}▫
        Return

    Case "Insert Big EmptyDot Bullet (○)":
        SendInput {Raw}○
        Return

    Case "Insert Small Empty Dot Bullet (◦)":
        SendInput {Raw}◦
        Return

    Case "Insert Black Diamond Bullet (◆)":
        SendInput {Raw}◆
        Return

    Case "Insert Empty Diamond Bullet (◇)":
        SendInput {Raw}◇
        Return

    Case "Insert Centered Diamond Bullet (◈)":
        SendInput {Raw}◈
        Return

    Case "Insert Black Diamond Star Bullet (✦)":
        SendInput {Raw}✦
        Return

    Case "Insert Empty Diamond Star Bullet (✧)":
        SendInput {Raw}✧
        Return

    ; ╞───────────── Enclosers ─────────────────╡ 2

    Case "″...″ Quotes":
        TempText := RegExReplace(TempText, "\s+$")
        TempText := """" TempText """"

    Case "'...' Apostrophes":
        TempText := RegExReplace(TempText, "\s+$")
        TempText := "'" TempText "'"

    Case "(...) Parentheses":
        TempText := RegExReplace(TempText, "\s+$")
        TempText := "(" TempText ")"

    Case "`{...} Curly Brackets":
        TempText := RegExReplace(TempText, "\s+$")
        TempText := "{" TempText "}"

    Case "`[...] Square Brackets":
        TempText := RegExReplace(TempText, "\s+$")
        TempText := "[" TempText "]"

    Case "`*...* Asterisks":
        TempText := RegExReplace(TempText, "\s+$")
        TempText := "*" TempText "*"

    ; ╞───────────── Fractions ─────────────────╡ 3.5

    Case "Insert (⅛)":
        SendInput {Raw}⅛
        Return

    Case "Insert (¼)":
        SendInput {Raw}¼
        Return

    Case "Insert (⅜)":
        SendInput {Raw}⅜
        Return

    Case "Insert (½)":
        SendInput {Raw}½
        Return

    Case "Insert (⅝)":
        SendInput {Raw}⅝
        Return

    Case "Insert (¾)":
        SendInput {Raw}¾
        Return

    Case "Insert (⅞)":
        SendInput {Raw}⅞
        Return

    Case "Insert (↉)":
        SendInput {Raw}↉
        Return

    Case "Insert (⅑)":
        SendInput {Raw}⅑
        Return

    Case "Insert (⅙)":
        SendInput {Raw}⅙
        Return

    Case "Insert (⅓)":
        SendInput {Raw}⅓
        Return

    Case "Insert (⅔)":
        SendInput {Raw}⅔
        Return

    Case "Insert (⅚)":
        SendInput {Raw}⅚
        Return

    Case "Insert (⅒)":
        SendInput {Raw}⅒
        Return

    Case "Insert (⅕)":
        SendInput {Raw}⅕
        Return

    Case "Insert (⅖)":
        SendInput {Raw}⅖
        Return

    Case "Insert (⅗)":
        SendInput {Raw}⅗
        Return

    Case "Insert (⅘)":
        SendInput {Raw}⅘
        Return

    ; ╞─────────────  Spaces ──────────────────╡ 6

    Case "Insert Zero-Width ▏​▏":
        SendInput {Raw}​
        Return

    Case "Insert Hair-Width ▏ ▏":
        SendInput {Raw}
        Return

    Case "Insert Six-Per-Em ▏ ▏":
        SendInput {Raw}
        Return

    Case "Insert Thin-Width ▏ ▏":
        SendInput {Raw}
        Return

    Case "Insert Punctuation ▏ ▏":
        SendInput {Raw}
        Return

    Case "Insert Four-Per-Em ▏ ▏":
        SendInput {Raw}
        Return

    Case "Insert Three-Per-Em ▏ ▏":
        SendInput {Raw}
        Return

    Case "nsert Figure-Width ▏ ▏":
        SendInput {Raw}
        Return

    Case "Insert En-Width ▏ ▏":
        SendInput {Raw}
        Return

    Case "Insert Em-Width ▏ ▏":
        SendInput {Raw}
        Return

    Case "Insert Braille-Blank ▏⠀▏":
        SendInput {Raw}⠀
        Return

    Case "Insert WhiteSpaceman ▏👨🏻‍🚀▏":
        SendInput {Raw}👨🏻‍🚀
        Return

    ; ╞───────────────────────────────────────╡

    ; ╞═══════════ Dark Mode ═══════════╡

    Case "Toggle Dark Mode":
        If (DarkMode)
        {
            DarkMode := false
            MenuDark(3) ; Set to ForceLight
            WelcomeTrayTipLight()
        }
        else
        {
            DarkMode := true
            MenuDark(2) ; Set to ForceDark
            WelcomeTrayTipDark()
        }
        Return
    }
    SetCapsLockState, Off

    ; ╞═══════════ This has to be at BOTTOM OF ALL THE CASE THINGS (Pastes TempText) ═══════════╡

    PutText(TempText)
    SetCapsLockState, Off
Return

; ╞──────── BOTTOM OF ALL THE CASE THINGS End ────────╡

; ╞═══════════ Functions ═══════════╡

GetText(ByRef MyText = "")
{
    SavedClip := ClipboardAll
    Clipboard =
    Send ^c
    ClipWait 0.5
    If ERRORLEVEL
    {
        Clipboard := SavedClip
        MyText =
        Return
    }
    MyText := Clipboard
    Clipboard := SavedClip
    Return MyText
}

PutText(MyText)
{
    SavedClip := ClipboardAll
    Clipboard =
    Sleep 20
    Clipboard := MyText
    Send ^v
    Sleep 100
    Clipboard := SavedClip
    Return
}

CopyClipboard()
{
    global ClipSaved := ""
    ClipSaved := ClipboardAll
    Clipboard := ""
    Send {Ctrl down}c{Ctrl up}
    Sleep 150
    ClipWait, 1.5, 1
    if ErrorLevel
    {
        MsgBox, 262208, AutoHotkey, Copy to clipboard failed!
        Clipboard := ClipSaved
        ClipSaved := ""
        Return
    }
}

CopyClipboardCLM()
{
    global ClipSaved
    WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    if (class ~= "(Cabinet|Explore)WClass|Progman")
        Send {F2}
    Sleep 100
    CopyClipboard()
    if (ClipSaved != "")
        Clipboard := Clipboard
    else
        Exit
}

PasteClipboardCLM()
{
    global ClipSaved
    WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    if (class ~= "(Cabinet|Explore)WClass|Progman")
        Send {F2}
    Send ^v
    Sleep 100
    Clipboard := ClipSaved
    ClipSaved := ""
    Exit
}

SetCapsLockState, Off
Send, {capslock up}

; ╞═══════════ Dark Mode ═══════════╡

DarkMode := false

MenuDark()

MenuDark(Dark := 2) { ; 0=Default  1=AllowDark  2=ForceDark  3=ForceLight  4=Max
    static uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
    static SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
    static FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
    DllCall(SetPreferredAppMode, "int", Dark)
    DllCall(FlushMenuThemes)
}

; ╞──────── Dark Mode End ────────╡

; ╞═══════════ Dark/Light Mode Activated Gui ═══════════╡

WelcomeTrayTipDark() {
    static GuiCreated := 0
    static HwndWelcomeScreen1
    static MonRight, MonBottom
    if !GuiCreated {
        GuiCreated := 1
        Gui, WelcomeScreen1:New,
            +AlwaysOnTop
            -Caption
            +ToolWindow
            +HwndHwndWelcomeScreen1
            +LastFound
            -DPIScale
            +E0x20 ; Clickthrough=E0x20
        Gui, WelcomeScreen1:Margin, 10, 20
        Gui, WelcomeScreen1:Font, s14 w600 q5, Segoe UI
        Gui, WelcomeScreen1:Color, BLACK
        Gui, WelcomeScreen1:Add, Text, y20 c46BCFF, Dark Mode Activated
        WinSet, Transparent, 0
        SysGet, P, MonitorPrimary
        SysGet, Mon, MonitorWorkArea, % P
        Gui, WelcomeScreen1:Show, Hide
        WinGetPos, X, Y, W, H
        WinMove, % MonRight - W - 10, % MonBottom - H - 10
        WinSet, Region, 0-0 W%W% H%H% R20-20
    }
    Gui, WelcomeScreen1:Show, NA
    bf := Func("AnimateFadeIn").Bind(HwndWelcomeScreen1)
    SetTimer, %bf%, -200
}
; ◦ SWITCH ◦
WelcomeTrayTipLight() {
    static GuiCreated := 0
    static HwndWelcomeScreen
    static MonRight, MonBottom
    if !GuiCreated {
        GuiCreated := 1
        Gui, WelcomeScreen:New,
            +AlwaysOnTop
            -Caption
            +ToolWindow
            +HwndHwndWelcomeScreen
            +LastFound
            -DPIScale
            +E0x20 ; Clickthrough=E0x20
        Gui, WelcomeScreen:Margin, 10, 20
        Gui, WelcomeScreen:Font, s14 w600 q5, Segoe UI
        Gui, WelcomeScreen:Color, WHITE
        Gui, WelcomeScreen:Add, Text, y20 c1AFF1A, Light Mode Activated
        WinSet, Transparent, 0
        SysGet, P, MonitorPrimary
        SysGet, Mon, MonitorWorkArea, % P
        Gui, WelcomeScreen:Show, Hide
        WinGetPos, X, Y, W, H
        WinMove, % MonRight - W - 10, % MonBottom - H - 10
        WinSet, Region, 0-0 W%W% H%H% R20-20
    }
    Gui, WelcomeScreen:Show, NA
    bf := Func("AnimateFadeIn").Bind(HwndWelcomeScreen)
    SetTimer, %bf%, -200
}

; ╞──────── Dark/Light Mode Activated Gui End ────────╡

; ╞═══════════ Gui FadeIn-Out Function ═══════════╡

AnimateFadeIn(hwnd) {
    static Value := 0
    WinSet, Transparent, % Value+=15, % "ahk_id" hwnd
    if (Value >= 255) {
        Value := 0
        bf := Func("AnimateFadeOut").Bind(hwnd)
        SetTimer, %bf%, -1000
    } else {
        bf := Func("AnimateFadeIn").Bind(hwnd)
        SetTimer, %bf%, -15
    }
}
; ◦ SWITCH ◦
AnimateFadeOut(hwnd) {
    static Value := 255
    WinSet, Transparent, % Value-=15, % "ahk_id" hwnd
    if (Value <= 0) {
        Value := 255
        Gui, %hwnd%:Hide
    } else {
        bf := Func("AnimateFadeOut").Bind(hwnd)
        SetTimer, %bf%, -15
    }
}

; ╞──────── Gui FadeIn-Out Function End ────────╡

; ╞═══════════ Reload/Exit Routine ═══════════╡
RETURN

; ◦ ◦ ◦ ◦ ◦ ◦ ◦ RELOAD  SCRIPT ◦ ◦ ◦ ◦ ◦ ◦ ◦

^Home:: 		 ; (Ctrl + ([Home] times (# of TapCounts)))
    if (A_TimeSincePriorHotkey > 250)
    {
        TapCount := 1
        KeyWait, Esc
    } else {
        TapCount++
        if (TapCount = 2) 	 ; ←←← Set TapCount to # of key taps wanted.
        {
            Gosub, IndicateDot1
            Gui, Color, YELLOW 		 ; ←←← IndicateDot Color.
            Gosub, IndicateDot2
            Reload
        } else {
            KeyWait, Esc
        }
    }
Return

; ◦ ◦ ◦ ◦ ◦ ◦ ◦ EXIT SCRIPT ◦ ◦ ◦ ◦ ◦ ◦ ◦

^Esc:: 		; (Ctrl + ([Esc] times (# of TapCounts)))
    if (A_TimeSincePriorHotkey > 250)
    {
        TapCount := 1
        KeyWait, Esc
    } else {
        TapCount++
        if (TapCount = 3) 	 ; ←←← Set TapCount to # of key taps wanted.
        {
            Gosub, IndicateDot1
            Gui, Color, RED 		 ; ←←← IndicateDot Color.
            Gosub, IndicateDot2
            Gui, Destroy
            ExitApp
        } else {
            KeyWait, Esc
        }
    }
Return

; ╞──────── Reload/Exit Routine End ────────╡

; ╞═══════════ Script Updater ═══════════╡
UpdateCheck: 				 ; Check if the script file has been modified.
    oldModTime := currentModTime
    FileGetTime, currentModTime, %A_ScriptFullPath%
    ; ◦ ◦ ◦ ◦ ◦ ◦ If the modification timestamp has changed, reload the script.
    if (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Gosub, IndicateDot1
    Gui, Color, BLUE 		 ; ←←← IndicateDot Color.
    Gosub, IndicateDot2
    Reload

; ╞──────── Script Updater End ────────╡

; ╞═══════════ Auto-Execute Sub ═══════════╡
AutoExecute:
    #NoEnv
    #SingleInstance, Force
    #Persistent
    DetectHiddenWindows, On
    SendMode Input ; Makes Send synonymous with SendInput.
    SetBatchLines -1 ; Determines how fast a script will run.
    SetKeyDelay, 250 ; Sets TapCount allowed delay time (milliseconds) for script Exit. (tied to Reload/Exit routine)
    SetTimer, UpdateCheck, 500 ; Checks for script changes every 1/2 second. (Script Updater)
    SetTitleMatchMode 2 ; Sets the matching behavior of the WinTitle parameter.
    SetWorkingDir %A_ScriptDir% ; Scripts own directory. (, FileSelectFolder) - allows user to select a folder.
    Menu, Tray, Icon, wmploc.dll, 99 ; Local White Star tray Icon.

; ╞──────── Auto-Execute Sub End ────────╡

; ╞═══════════ GoSubs ═══════════╡
IndicateDot1:
    Gui, Destroy
    SysGet, MonitorWorkArea, MonitorWorkArea
    SysGet, TaskbarPos, 4
    Gui, +AlwaysOnTop -Caption +hwndHGUI +LastFound
Return

; ◦ ◦ ◦ ◦ ◦ ◦ ◦ ◦ ◦ ◦ ◦ ◦

IndicateDot2:
    Gui, Margin, 13, 13 	 ; ←←← Dot Size.
    Gui, Show, Hide
    WinGetPos, , , WinWidth, WinHeight, ahk_id %HGUI%
    NewX := MonitorWorkAreaRight - 80
    NewY := MonitorWorkAreaBottom - WinHeight - 5
    R := Min(WinWidth, WinHeight) // 1 	 ; ←←← Set value of cornering. (0.5=Oval, 0=square, 1= round, 5=rounded corners).
    WinSet, Region, 0-0 W%WinWidth% H%WinHeight% R%R%-%R%
    Gui, Show, x%NewX% y%NewY%
    ; SoundGet, master_volume
    ; SoundSet, 2
    ; Soundbeep, 2100, 150
    ; SoundSet, % master_volume
    Sleep, 500
    Gui, Destroy
Return

; ╞──────── GoSubs End ────────╡

; ╞──────────────────────────╡
; ╞═══════════ Script End ═══════════╡
; ╞──────────────────────────╡
