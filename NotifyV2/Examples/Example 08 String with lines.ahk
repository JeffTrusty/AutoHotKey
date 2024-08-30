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

str := 
(
	"
		Hello World!
		How are you doing?
		What's up?
	"
)

Notify.Show(str)