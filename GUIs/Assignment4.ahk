#SingleInstance, Force
Gui, new
Gui, Add, Text,, First Name:
Gui, Add, Edit, w200 vFirstName X+5

Gui, Add, Text, xs, Last Name:
Gui, Add, Edit, w200 vLastName X+5

Gui, Add, Text, xs, Email Address:
Gui, Add, Edit, Y+1 w600 vEmailAddress X+5

Gui, Add, link, xs, <a href="www.the-automator.com"> AutoHotKey.com</a>

Gui, Add, Picture,xs w200 h-1, MiscPicture.jpg

Gui, Add, Button, xs w75 gSubmit Default, Cool ; Default option sets Enter as hot key

Gui Show
return

Submit:
Gui Submit, Nohide
ExitApp
return
