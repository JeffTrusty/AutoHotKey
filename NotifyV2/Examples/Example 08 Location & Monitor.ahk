#Requires AutoHotkey v2.0

/*
 * ============================================================================ *
* Want a clear path for learning AutoHotkey?                                   *
* Take a look at our AutoHotkey courses here: the-Automator.com/Discover          *
* They're structured in a way to make learning AHK EASY                        *
* And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
* ============================================================================ *
*/
#Requires AutoHotkey v2+
#Include ..\NotifyV2.ahk

/*
	## Location
	by default Notification will show up on Primary Monitor
	User Can Show Notification on any of Connected Display, utilizing same 
	Monitor Number autohotkey uses to Identify Displays

	To show Notification to Certain Display User have to add Parameter called
	'GenMonitor' i.e {GenMonitor:1} where number is the Display number passing 
	wrong display number will show the notification on Primary Monitor

*/


/*
; Display Notification on Second Monitor
Notify.show({HDText:'Monitor # 2',BDText:'This is Display Number 2 According to autohotkey',GenMonitor:2})
*/

/*
	## Location

	Notification Displayed on RightBottom on the Monitor and Stack upon previous
	Notification

	User can Display Notification On any Location on the Monitor, User has to 
	add 'GenLoc' parameter i.e {GenLoc:'c'} where is 'c' is Value case-InSensitive location for center, Value Can be following:

	C, Center: 
		to display Notification on Center (does not support Stacking)
	RightBottom, BottomRight, RB, BR:
		to display Notification on Center RightBottom
	LeftBottom, BottomLeft, BL, LB:
		to display Notification on Center LeftBotton
	TopLeft, LeftTop, TL, LT:
		to display Notification on Center TopLeft
	TopRight, RightTop, TR, RT:
		to display Notification on Center TopRight

	x & y:
		'x400 y700' to display Notification by Screen Coord (does not support Stacking)

	Notification will be mentioned withing Working area that mean they will not 
	overlap Taskbar unless user is using X and Y coord.
*/

	; Notify.Show({BDText:'Displaying Notfication in Center',GenLoc:'center'})

	; Notify.Show({BDText:'Displaying Notfication in Right Bottom',GenLoc:'RB'})

	; Notify.Show({BDText:'Displaying Notfication in Top Left',GenLoc:'TopLeft'})

	; Notify.Show({BDText:'Displaying Notfication in Top Right',GenLoc:'Topright'})

	; Notify.Show({BDText:'Displaying Notfication in Bottom Left',GenLoc:'BL'})

	; Notify.Show({BDText:'Displaying Notfication on x400 y400',GenLoc:'x400 y400'})

/*
	; Since NotifyV2 is using AHK Monitor numbering so here is example from the 
	; following Documentation link converted to Notify 
	; https://www.autohotkey.com/docs/v2/lib/Monitor.htm#ExLoopAll

	; but this will display Monitor Info Notification on their pertaining Monitor
	; so you user can see How AHK see the Monitor Numbering 

	Notify.DisplayCheck()
*/



;a Test to check Notification and Stacking on all Monitor and all Locations
/*

Locations := ['RB','LB','TR','TL','c',]
Duration := 0
Notify.show({HDtext:'Default Monitor',BDtext:'Dislpaying notification on Primary Monitor',GenDuration:Duration})

for index, loc in Locations
	Loop MonitorGetCount()
		Notify.show({HDtext:'Monitor #' a_index ' ' loc,BDtext:'Dislpaying notification on Monitor ' a_index,GenMonitor:a_index,GenDuration:Duration,GenLoc:loc})

Locations := ['BottomRight','LeftBottom','TopRight','LeftTop','c',]
for index, loc in Locations
	Loop MonitorGetCount()
		Notify.show({HDtext:'Monitor #' a_index ' ' loc,BDtext:'Second Cycle`nDislpaying notification on Monitor ' a_index,GenMonitor:a_index,GenDuration:Duration,GenLoc:loc})
Locations := ['BR','BL','RT','LT','c',]
for index, loc in Locations
	Loop MonitorGetCount()
		Notify.show({HDtext:'Monitor #' a_index ' ' loc,BDtext:'third Cycle`nDislpaying notification on Monitor ' a_index,GenMonitor:a_index,GenDuration:Duration,GenLoc:loc})

		Notify.show({HDtext:'Monitor X and Y Pos',GenDuration:Duration,BDtext:'showing Notify X400 Y400 ',GenLoc:'x400 y400'})

*/

	Loop MonitorGetCount()
		Notify.show({HDtext:'Monitor #' a_index ,BDtext:'Dislpaying notification on Monitor ' a_index,GenMonitor:a_index,GenDuration:5,GenLoc:'c'})