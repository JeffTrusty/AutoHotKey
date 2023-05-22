#SingleInstance, Force

Gui, New,, Assignment 2
Gui, Add, dropdownlist, vColorOption, Red|Blue|Green
Gui, Add, dropdownlist, vDayOfWeekOption x+10, Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday
Gui, Add, Button, w75 gSubmit, Execute
Gui Show
return

Submit:
Gui Submit, Nohide
msgbox %ColorOption%
msgbox %DayOfWeekOption%
ExitApp
return


GuiEscape:
msgbox Esc key was pressed. Exiting app.

GuiClose:
ExitApp
