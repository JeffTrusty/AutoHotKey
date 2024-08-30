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
## What is a CallBack?
A callback is like giving a friend a phone number to call you back when they have completed a task you asked them to do. 
In programming, a callback is a piece of code (like a function) that you provide to another piece of code, 
so that it can be executed later, usually after a certain event or condition is met.

So, in your AutoHotkey class, when you use a callback, you are essentially saying, “Hey, go do this task, and when you’re done, 
call me back (execute this specific piece of code)”. This allows your program to continue running and doing other things while it waits for the task to be completed.
*/

;********************Example 1***********************************
; Creating a Notification with a Callback. GenCallback function will be called when User clicks notification;
Notify.Show({BDText: "Please Call me Back when I click", GenSound:'Ring01', GenCallback :  eventClick}) ; eventClick is the name of your Custom 


eventClick(*) ; callback event function
{
  msgbox( "Ring Ring! as you've clicked I am Calling you back")
}

;********************Example 2***********************************
; Callback in single line using fat arrow
url := 'www.the-Automator.com/hero'
Notify.Show({BDText: 'You need to Visit`n' url  '`nClick here ', HDText:'Notify', GenCallback : (*) =>Run(url)})


;********************Example 3***********************************
; 

folder := A_ScriptDir
loop files, folder "\*.ahk" , 'FR'
    count := a_index
Notify.show({BDText:'Click here to Open the Folder',HDText:'File count: ' count, GenCallback : (*) =>Run(folder)})


;********************Example 4***********************************
; Download complete Notify callback will open download folder
url := 'https://the-Automator.com/download/img/logo/200moneybackguarantee.png'
Notify.Show({BDText:'waiting while we download the image',GenDuration : 0})
try FileDelete dFile := A_Temp '\automator.png'
Download  url, dFile
Notify.CloseLast() ; close last Notification
Notify.Show({BDText: 'Download complete`nClick to Open', HDText:'Notify', GenCallback : (*) =>Run(dFile)})



;********************Example 5***********************************
; playing MidiFile

Notify.Show({BDText:'Playing midi file: Need a Hero, click to stop playing',GenSound:'..\Audio\Need a Hero.mid',GenDuration:0,GenCallback:StopPlayingSound})

StopPlayingSound(*)
{
    try SoundPlay("") ; https://www.autohotkey.com/docs/v2/lib/SoundPlay.htm#Remarks setting it blank to stop playing the sound
}







