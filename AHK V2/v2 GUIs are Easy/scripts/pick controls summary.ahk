#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.addDropdownlist('vType w150', ['Event', 'Reminder']).choose(1)
main.addDateTime('vTime x+m w150', 'Time')
main.addMonthCal('vDate xm w-2')

main.addTexT('', 'Settings:')
main.addCheckBox('vMakeSound Checked', 'Make a Sound')
main.addCheckBox('vShowPopup Checked', 'Show Notification')

main.addTexT('', 'Title:')
main.addEdit('vNotificationTitle w150 r1')
main.addTexT('', 'Text:')
main.addEdit('vNotificationText w635 r20')
main.addButton('w75', 'Save').onEvent('Click', SaveNotification)
main.addButton('x+m w75', 'Cancel').onEvent('Click', ExitApplication)
main.Show()
return

SaveNotification(*)
{
}

ExitApplication(*)
{
	Exitapp
}