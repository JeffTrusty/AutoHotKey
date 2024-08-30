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

;********************Example 1***********************************
; We can use html with Link parameter instead and BDtext shall not be used
Notify.Show({Link:'Click on following Hyperlink to open url`n<a href="https://the-Automator.com" >the-Automator</a>'})

;********************Example 2***********************************
; We can use html just like we use HTML in AHK Gui

Notify.Show(
    {
        Link:'We can use html for link just like AHK Gui<a href="https://www.autohotkey.com/docs/v2/lib/GuiControls.htm#Link" >Link</a>',
        HDText:'AHK Documentation reference'
    }
    )


;********************Example 3***********************************
; We can also use HTML benefit to use multiple link within one Notification

Notify.Show(
    {
        Link:(
            'Multiple Hyper links'
            '`n1<a href="https://www.autohotkey.com/docs/v2/index.htm" >Quick reference</a>'
            '`n2<a href="https://www.autohotkey.com/docs/v2/FAQ.htm" >FAQ</a>'
            '`n3<a href="https://www.autohotkey.com/docs/v2/ChangeLog.htm" >Recent Changes</a>'
        ),
        HDText: 'Multiple Links',
        GenDuration:10
    }
    )
   

