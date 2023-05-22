#Requires Autohotkey v2.0+ 64-Bit

MyGui := Gui(, "Title")
MyGui.Add("Text",, "First name:")
MyGui.Add("Text",, "Last name:")
MyGui.Add("Edit", "w150 vFirstName ym")
MyGui.Add("Edit", "w150 vLastName")
MyGui.Add("Button", "default", "OK").OnEvent("Click",ProcessUserInput)
MyGui.OnEvent("Close",ProcessUserInput)
MYGui.Show()

ProcessUserInput(*)
{
    Saved := MyGui.Submit()
    MsgBox("You Entered '" Saved.FirstName " " Saved.LastName "'.")
}