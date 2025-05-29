/**
 * =========================================================================== *
 * Want a clear path for learning AutoHotkey?                                  *
 * Take a look at our AutoHotkey courses here: the-Automator.com/Discover      *
 * They're structured in a way to make learning AHK EASY                       *
 * And come with a 200% moneyback guarantee so you have NOTHING to risk!       *
 * =========================================================================== *
 * @author      the-Automaotr                                                  *
 * @version     0.0.1                                                          *
 * @copyright   Copyright (c) 2024 The Automator                               *
 * @link        https://www.the-automator.com/                                 *
 * @created     YYYY-DD-MM                                                     *
 * @modified    YYYY-DD-MM                                                     *
 * @description                                                                *
 * =========================================================================== *
 * @license     CC BY 4.0                                                      *
 * =========================================================================== *
   This work by the-Automator.com is licensed under CC BY 4.0

   Attribution — You must give appropriate credit , provide a link to the license,
   and indicate if changes were made.

   You may do so in any reasonable manner, but not in any way that suggests the licensor
   endorses you or your use.

   No additional restrictions — You may not apply legal terms or technological measures that
   legally restrict others from doing anything the license permits.
 */
;@Ahk2Exe-SetVersion     "0.0.1"
;@Ahk2Exe-SetMainIcon    res\main.ico
;@Ahk2Exe-SetProductName
;@Ahk2Exe-SetDescription
#Requires Autohotkey v2.0+
#SingleInstance
#Include <ScriptObject>

script := {
	base         : ScriptObj(),
	version      : "0.0.1",
	hwnd         : 0,
	author       : "the-Automator",
	email        : "joe@the-automator.com",
	crtdate      : "",
	moddate      : "",
	resfolder    : A_ScriptDir "\res",
	iconfile     : 'mmcndmgr.dll' ,
	config       : A_ScriptDir "\settings.ini",
	homepagetext : "SimpleMenuForSendingText",
	homepagelink : "the-automator.com/SimpleMenuForSendingText?src=app",
	donateLink   : "", ; "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6"
}

tray := A_TrayMenu
tray.Delete()
tray.add('Open Folder',(*)=>Run(A_ScriptDir))
tray.SetIcon("Open Folder","shell32.dll",4)
tray.Add("About",(*) => Script.About())
; tray.Add("Donate",(*) => Run(script.donateLink))
tray.Add()
tray.AddStandard()



; #Include <default_Settings>

Text:=
(
	"!Q10_SCR_VEH_TYPES_OWN
	!Q13_SCR_LIK_CONSIDER_NEXTPURCHASE
	!Q14_SCR_AGREE_EV
	!Q18_SCR_ETHNIC
	!Q23_AGREE_AIRPERCEPT
	!Q24_HOWGETTOAIRPORT
	!Q25_WHY_NOT_DRIVE_TO_AIRPORT
	!Q29_WHEREPARKATAIRPORT
	!Q30_AGREE_AIRSAFDAMAGE
	!Q31_ENHANCE_PARKING_EXPERIENCE
	!Q36_AGREE_CONFID_RENTAL
	!Q38_REASONPURCHASEEV
	!Q43_AGREE_EVRANGESTATEMENTS
	!Q44_AGREE_RENEW_SUSTAINABLE
	!Q46_PREVENTS_CHARGING_AT_PRIM_AIRPORT_MORE_OFTEN
	!Q50_AGREE_PRIMAIRPORT_STATEMENTS_1
	!Q51_AGREE_PRIMAIRPORT_STATEMENTS_2
	!Q52_AGREE_PRIMAIRPORT_STATEMENTS_3
	!Q53_AGREECOSTCONV
	!Q54_AGREE_EV_CHARGING_LEVELS_AIR
	!Q55_AGREE_AIRPORTEVCONC
	!Q56_AGREE_EV_FUTURE_CONCEPTS
	!Q57_AGREE_AIRPORTVALET"
)

^7::TextMenu(Text)

TextMenu(TextOptions){
	MyMenu := Menu()
	For MenuItems in StrSplit(TextOptions,"`n")
		MyMenu.Add(MenuItems, Action)

	MyMenu.Show()
}

Action(ItemName, *)
{
	OldClipboard := A_Clipboard
	A_Clipboard := ItemName
	Send '^v'
	Sleep 1000
	A_Clipboard:=OldClipboard
	return
}
