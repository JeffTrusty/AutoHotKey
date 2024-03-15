#Requires Autohotkey v1.1.36+
Obj := {language: "The way how animals communicate"}
Obj.language := "English"


MsgBox % Obj.language
MsgBox % Obj["language"]