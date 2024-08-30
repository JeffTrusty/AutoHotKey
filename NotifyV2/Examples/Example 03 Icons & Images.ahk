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
; We can also use Icon in out notification
Notify.Show({GenIcon:"Critical"}) ; notify with Just an Icon

;********************Example 2***********************************

Notify.Show({BDText:"Notify with Question Icon",GenIcon:"Question"}) ; Notify with Icon and Body Text

;********************Example 3***********************************

Notify.Show({BDText:"Notify with Exclamation Icon",HDText:"Notify Icon",GenIcon:"Exclamation"}) ; Notify with Icon, Body Text and Header

;********************Example 4***********************************

Notify.Show({GenIcon:"Information",GenSound:'Exclamation'}) ; Notify with Icon, and sound 

;********************Example 5***********************************

Notify.Show({GenIcon:"Security",GenIconSize:70}) ; Notify with Icon Modified IconSize

;********************Example 6***********************************
; We can use Image with Icon paramater 
Notify.Show({GenIcon:"C:\Windows\Web\Wallpaper\Windows\img0.jpg",GenIconSize:70,BDText:"Windows 10 Wallpaper"})

;********************Example 7***********************************
; Image with Size 100x100 pixels
Notify.Show({GenIcon:"..\res\The-Automator.png",GenIconSize:100,BDText:"Notify text",HDText:"The-Automator"})

;********************Example 8***********************************
; Notify with Icon File path
Notify.Show({GenIcon:"..\res\The-Automator.ico",BDText:"Notify text",HDText:"The-Automator"})

;********************Example 9***********************************
; Notify with Shell.dll Icon[numbers]
Notify.Show({GenIcon:17,GenIconSize:70}) ; can be used any Shell.dll GenIcon number https://diymediahome.org/wp-content/uploads/shell32_icons.jpg

;********************Example 10***********************************
; exmaple getting Icon from Executable 
Notify.Show({BDText:'it keeps the setting',GenIcon: 'C:\Windows\System32\changepk.exe'})

;********************Example 11***********************************
; We can also use Icon Picker to have visual help for getting icon number
; click Icon to copy the Icon number you want
; Notify.IconPicker


; Notify.GenIconList() ; List of GenIcon
