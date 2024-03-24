;******************************************************************************
; Want a clear path for learning AutoHotkey?                                  *
; Take a look at our AutoHotkey Udemy courses.                                *
; They're structured in a way to make learning AHK EASY                       *
; Right now you can  get a coupon code here: https://the-Automator.com/Learn  *
;******************************************************************************
#SingleInstance, Force

#include <scan>
#include <outline>
#include <ScriptObj\ScriptObj>

#Include gui\main.ahk

global script := {base         : script
                 ,name         : regexreplace(A_ScriptName, "\.\w+")
                 ,version      : "0.1.0"
                 ,author       : "Joe Glines"
                 ,email        : "Joe@the-automator.com"
                 ,homepagetext : "the-Automator.com"
                 ,homepagelink : "https://the-automator.com"
                 ,donateLink   : "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6"
                 ;~ ,iconfile     : "\sct.ico"
                 ,iconfile     : "A_WinDir\ \sct.ico"
                 ,configfile   : "\settings.ini"
                 ,resfolder    : A_ScriptDir "\res"
                 ,configfolder : A_AppData "\" regexreplace(A_ScriptName, "\.\w+")}

gui show, w%mainGuiWidth%
return