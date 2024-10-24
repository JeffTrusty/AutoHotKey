#Requires Autohotkey v2.0+
/*
 * ============================================================================ *
 * Want a clear path for learning AutoHotkey?                                   *
 * Take a look at our AutoHotkey courses here: the-Automator.com/Discover          *
 * They're structured in a way to make learning AHK EASY                        *
 * And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
 * ============================================================================ *
 */

;~ Simple_Spy.ahk   by Maestrith and Joe Glines and V2 conversion by Xeo786
;~ Inspired & borrowed from:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=28220  by Alguimist
;#MaxMem 640
;#KeyHistory 0
#SingleInstance Force
;@Ahk2Exe-SetMainIcon res\WinSpy.ico
#include <ScriptObj\scriptobj>
; SetWorkingDir A_ScriptDir
DetectHiddenWindows "On"
CoordMode "Mouse", "Screen"
DllCall("SetThreadDpiAwarenessContext", "Ptr", -3, "Ptr") ; multi monitor DPI awarness
SetControlDelay -1
SetWinDelay -1
;SetBatchLines -1
;ListLines "Off"

script := {
	        base : ScriptObj(),
	     version : "1.2.3",
	      author : "the-Automator",
	       email : "joe@the-automator.com",
	     crtdate : "",
	     moddate : "",
       resfolder : A_ScriptDir "\res",
        iconfile : A_ScriptDir "\res\WinSpy.ico",
          config : A_ScriptDir "\settings.ini",
	homepagetext : "the-Automator.com/simplespy",
	homepagelink : "the-Automator.com/simplespy?src=app",
	  donateLink : "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6",
}
 ; system Tray Info 
TraySetIcon Script.iconfile ; A_ScriptDir "\res\WinSpy.ico"
tray := A_TrayMenu
tray.Delete()
; tray.Add("Check for Updates", Update)
tray.Add("About",(*) => script.about())
tray.Add()
tray.Add("Reload",(*) => Reload())
tray.Add("Exit",(*) => Exitapp())
; system Tray Info 

TreeIds := map()
g_TreeShowAll := False
IniFile := Script.config ;A_ScriptDir "\settings.ini"
AppName := regexreplace(A_ScriptName, "\.\w+") " - the-Automator.com"
Bitmap1 := script.resfolder '\FindTool1.bmp' ; A_ScriptDir "\res\FindTool1.bmp"
Bitmap2 := script.resfolder '\FindTool2.bmp' ; A_ScriptDir "\res\FindTool2.bmp"

; Crosshair Cursor change
hCrossHair := DllCall("LoadImage", "Int", 0
                                   , "Str", A_ScriptDir "\res\CrossHair.cur"
                                   , "Int", 2 ; IMAGE_CURSOR
                                   , "Int", 32, "Int", 32
                                   , "UInt", 0x10, "Ptr") ; LR_LOADFROMFILE

TreeIcons := script.resfolder "\TreeIcons.icl"
Moving := 0
OnMessage(0x200,checkMouseMove)

+Escape:: ;Exit
{
     ExitApp
}

#Include lib\Gui.ahk
#Include lib\admincheck.ahk
#Include lib\ShowBorder.ahk
#Include lib\FindToolHandler.ahk
#Include lib\MouseMove.ahk
#Include lib\SetHandle.ahk
#Include lib\SetText.ahk
#Include lib\ShowTree.ahk
#Include lib\CreateImageList.ahk
#Include lib\Tree.ahk
#Include lib\IsChild.ahk
#Include lib\ShowFindDlg.ahk
#Include lib\TreeVis.ahk
#Include lib\ShowItem.ahk
#Include lib\GetFileIcon.ahk
#Include lib\GetWindowIcon.ahk
#Include lib\IsWindowVisible.ahk
#Include lib\GetParent.ahk
#Include lib\LButtonUp.ahk
#Include lib\GetAncestor.ahk
#Include lib\Control GetClassNN.ahk
#Include lib\MenuFunctions.ahk