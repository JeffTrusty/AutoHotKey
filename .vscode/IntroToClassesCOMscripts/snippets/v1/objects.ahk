#Requires Autohotkey v1.1.36+
Obj := {red: "0xff0000",blue: "0x0000ff", green:"0x00ff00"}
; Obj := Object("red", "0xff0000", "blue", "0x0000ff", "green", "0x00ff00")

MsgBox % Obj["red"]