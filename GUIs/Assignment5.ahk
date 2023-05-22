#SingleInstance, Force

Gui, New,, Assignment 5

Gui, Add, Groupbox, w150 h85, Option 1
Gui, Add, Checkbox, xp+10 yp+20 vCheckboxVar1, QuickAccessPopup.com
Gui, Add, Checkbox, vCheckboxVar2,the-Automator.com
Gui, Add, Checkbox, vCheckboxVar3,autohotkey.com/boards

Gui, Add, Groupbox,  xp-10 yp+20 w150 h85, Option 2
Gui, Add, Radio, xp+10 yp+20 vRadioVar, QuickAccessPopup.com
Gui, Add, Radio,, the-Automator.com
Gui, Add, Radio,, autohotkey.com/boards

Gui, Add, dropdownlist, xp-10 yp+40 vDropdownVar, QuickAccessPopup.com|the-Automator.com|autohotkey.com/boards

Gui, Add, Combobox, yp+40 w200 vComboboxVar, QuickAccessPopup.com|the-Automator.com|autohotkey.com/boards

Gui, Add, Text, yp+45, Enter your favorite number:
Gui, Add, Edit, w75 vUpDownEditVar
Gui, Add, UpDown, range1-100 vUpDownVar

Gui, Add, Text, yp+40, Enter your birthday:
Gui, Add, MonthCal, vDateSelected range20200101-20201231 multi

Gui Add, Button, w150 gSubmit, Display selections
Gui Show
return

Submit:
Gui, Submit, nohide
msgbox % CheckboxVar1
msgbox % CheckboxVar2
msgbox % CheckboxVar3
msgbox % RadioVar
msgbox % DropdownVar
msgbox % ComboboxVar
msgbox % UpDownVar
msgbox % DateSelected
ExitApp
return

GuiEscape:
GuiClose:
  ; msgbox Exiting app.
  ExitApp
