#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <ScriptObject\ScriptObject>

;--
;@Ahk2Exe-SetVersion     0.1.0
;@Ahk2Exe-SetMainIcon    res\main.ico
;@Ahk2Exe-SetProductName Setting Scrollbar
;@Ahk2Exe-SetDescription Setting Scrollbar by the-Automator
/*
/**
 * ============================================================================ *
 * @Author   : Joe                                                              *
 * @Homepage : the-automator.com                                                *
 *                                                                              *
 * @Created  : August 24, 2024                                                  *
 * ============================================================================ *
 * Want a clear path for learning AutoHotkey?                                   *
 * Take a look at our AutoHotkey courses here: the-Automator.com/Discover       *
 * They're structured in a way to make learning AHK EASY                        *
 * And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
 * ============================================================================ *
 */

/*
This work by the-Automator.com is licensed under CC BY 4.0

Attribution — You must give appropriate credit , provide a link to the license,
and indicate if changes were made.
You may do so in any reasonable manner, but not in any way that suggests the licensor
endorses you or your use.
No additional restrictions — You may not apply legal terms or technological measures that
legally restrict others from doing anything the license permits.
*/

script := {
	base         : ScriptObj(),
	version      : "0.1.0",
	hwnd         : '',
	author       : "the-Automator",
	email        : "joe@the-automator.com",
	crtdate      : "24 August 2024",
	moddate      : "24 August 2024",
	resfolder    : A_ScriptDir "\res",
	iconfile     : A_ScriptDir '\res\main.ico',
	config       : A_ScriptDir "\settings.ini",
	homepagetext : "the-automator.com/ScrollbarWidth",
	homepagelink : "the-automator.com//ScrollbarWidth?src=app",
	donateLink   : "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6",
}

tray := A_TrayMenu
tray.Delete()
tray.Add("About",(*) => Script.About())
tray.Add("Donate",(*) => Run(script.donateLink))
tray.Add()
tray.AddStandard()

OnError logerrors

Logerrors(err, mode)
{
    line := err.What '`t' err.extra '`t' err.Message '`t' err.Line '`t' err.File '`n'
    FileAppend line, 'error.log', 'utf-8'
    return -1
}

TraySetIcon("C:\WINDOWS\system32\ieframe.dll", 27)
Himg := A_ScriptDir "\res\HScrollBar.png"
Vimg := A_ScriptDir "\res\VScrollBar.png"
RegeditScroll := "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics"
ScrollWidth := RegRead(RegeditScroll, "ScrollWidth")
ScrollHeight := RegRead(RegeditScroll, "ScrollHeight")

SW := RegValuetoPixel(ScrollWidth)

centerofverticalimg := 110
MyGui := Gui(,'Change Scroll Bars Widths')

MyGui.SetFont('S12')
MyGui.Add("Text",'x+m-80 yp+' centerofverticalimg ' w210 right', "Scroll Bar Width")
Edit1SW := myGui.AddEdit('x+m yp-3 w60 vChangemyScrollWidth').OnEvent("Change", ChengeingCtrl)

MyGui.AddUpDown('x+m Range17-34',SW)
MyGui.Add("Picture", 'xm+260 yp-' centerofverticalimg-10 ' +Border vhimg', Himg) 

pic2  := MyGui.Add("Picture", "xm yp+205 +Border w250 vvimg center", vimg)
pic2.GetPos(,&pic2y)
MyGui.pic2y := pic2y

MyGui.Add("Button", "xm+50 yp+50 w115 h40", "Reset").OnEvent("Click", Reset)
MyGui.Add("Button", "x+m w115 h40 vapplybutton", "Apply").OnEvent("Click", Apply)
;MyGui.Add("Button", "x+m w115 h30", "Cancel").OnEvent("Click", Cancel)
MyGui.OnEvent('Close', (*) => ExitApp())

ChengeingCtrl()
MyGui.Show()

Reset(*)
{
    WS_EX_TOPMOST := 0x40000
    MyGui["ChangemyScrollWidth"].value := 17
    MyGui["himg"].Move(,,17)
    MyGui["himg"].Value := Himg
    MyGui["vimg"].Move(,MyGui.pic2y,,17)
    MyGui["vimg"].Value := vimg
    MyGui["applybutton"].opt('-Disabled')
}

ChengeingCtrl(*)
{
    DisabledApplybutton()
    Hpixel := MyGui["ChangemyScrollWidth"].value
    MyGui["himg"].Move(,,Hpixel)
    MyGui["himg"].Value := Himg

    MyGui["vimg"].Move(,MyGui.pic2y+17-Hpixel,,Hpixel)
    MyGui["vimg"].Value := vimg
}

Apply(*)
{
    WS_EX_TOPMOST := 0x40000
    RegwriteScroll()
    res := MsgBox("In order to apply the changes, your computer needs to reboot.`n`nWould you like to reboot now?", "System Reboot Required", "Icon? YesNoCancel " WS_EX_TOPMOST)
    if (res = 'No')
    {
        DisabledApplybutton
        return !!MsgBox('Changes will be applied on your next reboot', 'Info', 'Iconi ' WS_EX_TOPMOST)
    }
    if (res = 'Cancel')
        return    
    Shutdown 2 ; Reboots the system
    
}

RegwriteScroll()
{
    wpixel  := MyGui["ChangemyScrollWidth"].value
    wreg    := PixeltoRegValue(wpixel)    
    RegWrite wreg, "REG_SZ", RegeditScroll, "ScrollWidth"
}

RegValuetoPixel(RegValue)
{
    return Floor(Abs(RegValue/15))
}

PixeltoRegValue(pixel)
{
    return -((pixel)*15)
}

Cancel(*)
{
    MyGui.Destroy()
}


DisabledApplybutton()
{
    ScrollWidth := RegRead(RegeditScroll, "ScrollWidth")
    FromRegedit_ScrolWidht := Floor(Abs(ScrollWidth / 15))
    FromGui_ScrolWidht := MyGui["ChangemyScrollWidth"].value

    IF(FromRegedit_ScrolWidht = FromGui_ScrolWidht)
        MyGui["applybutton"].opt('+Disabled')
    else
        MyGui["applybutton"].opt('-Disabled')
}


