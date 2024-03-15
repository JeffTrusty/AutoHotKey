#Requires v2.0-
Obj := {name: "Isaias", lastName: "Baez"}


; This will fail as you cannot loop through properties.
; You can only loop through key-value pairs and array indexes
for key,value in Obj ; Obj.OwnProps() use this if you want to loop through properties
	msgbox value