;*******************************************************
; Want a clear path for learning AutoHotkey; Take a look at our AutoHotkey courses.
;They're structured in a way to make learning AHK EASY:  https://the-Automator.com/Learn
;*******************************************************
#SingleInstance
#Requires AutoHotkey v2.0+ ; prefer 64-Bit
;**************************************
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

TextMenu(Text)

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
