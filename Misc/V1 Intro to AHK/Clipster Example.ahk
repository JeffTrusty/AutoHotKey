/*	
* Want a clear path for learning AutoHotkey? Take a look at our AutoHotkey courses here: the-Automator.com/Learn        
* They're structured in a way to make learning AHK EASY & come with a 200% moneyback guarantee so you have NOTHING to risk!    
*/
#SingleInstance
#Requires AutoHotkey v2.0
#include <clipster> ;Make sure you have the Clipster and WinAPI libraries in your LIB folder!

;********************Clipster Examples******************************
:*X:h.tac::Clipster("the-Automator.com") ; sending url
:*X:h.lrn::Clipster("the-Automator.com/learn") ; sending url

:*X:h.gr::Clipster("Looking forward to seeing you`n at the next AHK Hero call","{enter 2}") ; Sending Greetings

:*X:h.red::Clipster("<strong><span style='color:red'></span></strong>","{Left 16}") ; Bold & Red
:*X:h.input::Clipster("<input></input>","{Left 8}") ;Input Tag
:*X:h.span::Clipster("<span></span>","{Left 7}") ;Span Tag
:*X:h.div::Clipster("<div></div>","{Left 6}") ;Div Tag
:*X:h.p::Clipster("<p></p>","{Left 4}") ;P tag

;********************Navigating to folders**************************	
:*X:l.ahk::Clipster('S:\lib\irfan\','{enter}') ; path open dialogbox
:*X:p.icon::Clipster('S:\lib\Icons\','{enter}') ;Open icons folder

;********************Pasting HTML***********************************	
f10::Clipster("You can <b>get the latest</b> <a href='https://the-automator.com/snip'>Window Snipping</a> Tool","html") ;Pasting simple HTML

textPA := "
( Join<br>
    <a href=https://the-Automator.com/PromptAssist>Prompt Assistance</a> is a very simple, easy to use, tool that allows you to have your text templates at your fingertips. 
    It's super easy to use, fast, and reliable. 
    You can get your copy of Prompt Assistant <a href=https://the-Automator.com/PromptAssist>here</a>.
)"
f11::Clipster( textPA ,"html") ;More advanced version of HTML

;********************Pasting Images*********************************
:*X:p.ru::Clipster("S:\lib\irfan\testing\Rufaydium.jpg","pic") ; Pasting a picture
:*X:p.dos::Clipster("S:\AHK Images\custom\Courses\funnyMemes\dosbuycomputer.png","pic") ; Pasting DOS meme
:*X:p.amt::Clipster("S:\AHK Images\AmT.png","pic") ; Pasting automate my task
