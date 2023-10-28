#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
tabCtrl := main.addTab3('',['Login', 'Notifications', 'Settings'])

lorem :=
(
"What is Lorem Ipsum?
Lorem Ipsum is simply dummy text of the printing and typesetting industry.
Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
when an unknown printer took a galley of type and scrambled it to make a type specimen book.
It has survived not only five centuries, but also the leap into electronic typesetting,
remaining essentially unchanged. It was popularised in the 1960s with the release
of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
)

main.addPicture('vLogo w300 h-1', "D:\Cloud\RaptorX\OneDrive\Desktop\scripts\codeimages.png")
main.addText('w300', lorem)
main.addText('', 'User Name')
main.addEdit('vUserName w300')
main.addText('', 'Password')
main.addEdit('vPassword w300 Password')
main.addButton('w75', 'Login').onEvent('Click', Login)
main.addButton('x+m w75', 'Cancel').onEvent('Click', ExitProgram)

tabCtrl.UseTab(2)
main.addDropdownlist('vType w150', ['Event', 'Reminder']).choose(1)
main.addDateTime('vTime x+m w150', 'Time')
main.addMonthCal('vDate x10 y+m w-2')

main.addTexT('x20 y+m ', 'Settings:')
main.addCheckBox('vMakeSound Checked', 'Make a Sound')
main.addCheckBox('vShowPopup Checked', 'Show Notification')

main.addTexT('', 'Title:')
main.addEdit('vNotificationTitle w150 r1')
main.addTexT('', 'Text:')
main.addEdit('vNotificationText w635 r20')
main.addButton('w75', 'Save').onEvent('Click', SaveNotification)
main.addButton('x+m w75', 'Cancel').onEvent('Click', ExitProgram)

tabCtrl.UseTab()
main.addButton('w75', 'Previous')
main.addButton('x+m w75', 'Next')
main.addButton('x+m w75', 'Cancel')

main.Show()
return

Login(*)
{
	msgbox tabCtrl.text
	main['Logo'].value := "D:\Cloud\RaptorX\OneDrive\Desktop\scripts\codedotorg.png"
	; msgbox main['UserName'].text "`n"  main['Password'].text
	main.Submit()
}


SaveNotification(*)
{
}

ExitProgram(*)
{
	ExitApp
}
