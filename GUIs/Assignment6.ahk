#SingleInstance, Force

Gui Add, Tab3, vTabVar gShowVar, Videos|Images|Links

Gui Add, Edit, w50
Gui Add, Edit, w100
Gui Add, Edit, w125

Gui Tab, Images
Gui Add, Edit, w25
Gui Add, Edit, w50
Gui Add, Edit, w75

Gui Tab, Links
Gui Add, Edit, w100
Gui Add, Edit, w200
Gui Add, Edit, w300

Gui Show
Return

ShowVar:
Gui Submit, nohide
msgbox % TabVar
Return



