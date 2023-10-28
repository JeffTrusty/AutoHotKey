#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.addPicture('vMyImage w-1 h400 AltSubmit', 'D:\Cloud\RaptorX\OneDrive\Desktop\scripts\codedotorg.png')
main.Show()

Sleep 2000

main['MyImage'].value := 'D:\Cloud\RaptorX\OneDrive\Desktop\scripts\codeimages.png'
return