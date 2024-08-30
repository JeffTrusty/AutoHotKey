/*
 * ============================================================================ *
* Want a clear path for learning AutoHotkey?                                   *
* Take a look at our AutoHotkey courses here: the-Automator.com/Discover          *
* They're structured in a way to make learning AHK EASY                        *
* And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
* ============================================================================ *
*/

/*
We can also use Command Line parameters to use our Notify Class with same parameters with addition of '-'
for example: 'BDText' will become '-BDtext'

This will give Notify class a benefit, that if we compile notify class then other programs will be able 
to use notify class using CMD

following example are using AHK 'Run' function to use Notify class and we can notice that we are not 
including notify class anywhere within this script
*/

;********************Example 1***********************************
; we can use Multiple Parameters  
Run 'S:\lib\Notify\v2\NotifyV2.ahk'  ' -BDText "CMD Simple Example"' 

;********************Example 2***********************************
; User can also use commpiled executable of notify library
Run 'S:\lib\Notify\v2\NotifyV2.exe'  ' -BDText "CMD Simple Example"'


;********************Getting Lib Path***********************************
; Getting Notify.ahk path, or we can use notify.exe incase we complie
; Path := 'S:\lib\Notify\v2\NotifyV2.ahk'
Path := "S:\lib\Notify\v2\NotifyV2.exe"
Run Path ' -BDText "User can add paramater such as sound" -GenSound "*16"'
; Path := A_ScriptDir '\..\NotifyV2.ahk'
;Path := A_AhkPath ' "' A_ScriptDir '\..\NotifyV2.ahk"'
;msgbox Path1 "`n" Path2 "`n" Path3
;********************Example 3***********************************
; User can add paramater such as sound


;********************Example 4***********************************
; we can simplify commandline by creating a Param Variable


params :=
(Join`s
'   -BDText "using Params Variable and joing Parameters`nClick to close"
    -HDText "CMD Params"
    -GenDuration 0'
)
Run Path ' ' params 




;********************Example 5***********************************
; another Example

params :=
(Join`s
'   -BDText "Click here to close so you other script will take notice and stop waiting till notify finishes"
	-HDText "Notify V2"
	-GenIcon 7
	-GenIconSize 50
	-GenBGColor "White"
	-GenDuration 10'
)
Run Path ' ' params


;********************Example 5***********************************
; Example of Link in CMD and escaping double qoutes is not simple

params :=
(Join`s comments
	'-HDText
	"Link Example" ; Changing header Text
	-GenDuration 
	3 ; Notification will stays for 10 Seconds
	'
)

link := 
(
	
	'-Link "Multiple Hyper links
	`n1<a href=""https://www.autohotkey.com/docs/v2/index.htm"">Quick reference</a>
	`n2<a href=""https://www.autohotkey.com/docs/v2/FAQ.htm"">FAQ</a>
	`n3<a href=""https://www.autohotkey.com/docs/v2/ChangeLog.htm"">Recent Changes</a>"'
)

Run  Path ' ' link ' ' params 





