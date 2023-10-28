#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')

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

main.addPicture('vLogo w300 h-1', "codeimages.png")
main.addText('w300', lorem)
main.addText('', 'User Name')
main.addEdit('vUserName w300')
main.addText('', 'Password')
main.addEdit('vPassword w300 Password')
main.addButton('w75', 'Login').onEvent('Click', Login)
main.addButton('x+m w75', 'Cancel').onEvent('Click', ExitProgram)
main.Show()
return


Login(*)
{
	main['Logo'].value := "codedotorg.png"
	msgbox main['UserName'].text "`n" main['Password'].text
	main.Submit()
}

ExitProgram(*)
{
	ExitApp
}