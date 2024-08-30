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
;********************Example 1***********************************
; shows the default notification with simple text. it dissapears after 3 seconds
Notify.Show({BDText:'this is a test'}) ;btw--> Notify.Show('this is a test') ;this does the same thing

;********************Example 2***********************************
;shows a default notification with simple text dissapearing in 5 seconds
Notify.Show({BDText: 'this is a test that stays up for 5 seconds', GenDuration:5})

;********************Example 3***********************************
; Creates a 3 Second Notification with Body and Header with color and Body font size
Notify.Show({BDText:"will close in 3 seconds", HDText:"The Automator", GenBGcolor:"silver", BDFontSize:"15"})

;********************Example 4***********************************
; Creating a Notification with background color changed
Notify.Show({BDText:'Notify with silver Background',GenBGColor:'White'})
*/

;********************Example 5***********************************
; this is another example to use Notify function with multiple parameters
Notify.Show({
			HDText      : "The Automator",
			HDFontSize  : 20,
			HDFontColor : "Black",
			HDFont      : "Impact",
			BDText      : "Notify with multiple paramaters",
			BDFontSize  : 18,
			BDFontColor : "0x298939",
			BDFont      : "Consolas",
			GenBGColor  : "0xFFD23E",
			GenDuration : 0 
	})

;********************Color List***********************************
; this Method will list all supported string colors and list will be copied into the clipboard
Notify.ColorList()