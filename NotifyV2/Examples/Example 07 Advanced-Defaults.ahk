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
; We can change Default Parameters at once and after that all notification will follow those default paramaters
Notify.Show({BDText:'Before changing defaults'}) ;btw--> Notify.Show('this is a test') this does the same thing
sleep 1000
Notify.Default := {
    HDText        :"Notice",
    HDFontSize    :"28",
    HDFontColor   :"Black",
    HDFont        :"Impact",
    BDFontSize    :"18",
    BDFontColor   :"Blue",
    BDFont        :"Book Antiqua",
    GenDuration   :10,
    GenBGColor    :"0x008800",
    GenSound      : "*16",
    GenIcon       : 2,
    GenIconSize   : 50,
    GenMonitor    : 5
}
Notify.Show({BDText:'after changing defaults'})
sleep 1000
Notify.Show({BDText:'it keeps the setting while changing Icon, using GenIcon Parameter',GenIcon: 'C:\Windows\System32\changepk.exe'})
sleep 1000
Notify.Default.GenBGColor := 'White'
sleep 1000
Notify.Show(
    {
        BDText:'or we can change single default parameter at once', 
        GenIcon:'C:\Program Files (x86)\Microsoft Office\root\Office16\WINWORD.EXE'
    })

; ********************Pulling list of supported: Colors, Sounds, and Icons***********************************
; Notify.ColorList()   ; List of Supported Colors
; Notify.SoundList()   ; List of Supported Sounds
; Notify.GenIconList() ; List of GenIcons
;Notify.IconPicker()  ; Runs Icon Picker using shell32.dll

