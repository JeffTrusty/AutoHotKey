actions := Gui('ToolWindow AlwaysOnTop', 'VSConfigure - Actions')
actions.OnEvent('Close', (*)=>ExitApp())

actions.SetFont('s10 c3b3bf7 bold', 'Arial')
actions.AddText('', 'Actions to perform')
actions.SetFont()

wdth := 250
tree := actions.AddTreeView('w' wdth ' r5 Checked -HScroll')
tree.OnEvent('Click', UpdateTree)
optAll := tree.Add('Select All', 0, 'Check Expand')

for opt in ['Make VSCode the Default Editor', 'Delete User Folder', 'Delete Extensions', 'Install Extensions']
	tree.Add(opt, optAll, 'Check')

actions.AddButton('x' wdth+actions.MarginX-75 ' w75','Next').OnEvent('Click', NextStep)

NextStep(*)
{
	static PBS_MARQUEE := 0x8
	static vsCodeOpen := false

	actions.Submit()

	prgWdth := 300
	progress := Gui('+ToolWindow +AlwaysOnTop', 'Working')
	progress.AddText('vTitle w' prgWdth ' Center', 'Starting...')
	progress.AddProgress('vBar w' prgWdth ' h3 ' PBS_MARQUEE)

	progress.Show()
	SetTimer UpdateBar(*)=>progress['bar'].value := true, 50
	while nextItem := tree.GetNext(nextItem ?? 0, 'Checked')
	{
		switch tree.GetText(nextItem)
		{
		case 'Make VSCode the Default Editor':
			progress['Title'].Value := 'Setting up the default editor'
			RegWrite '"C:\Program Files\Microsoft VS Code\Code.exe" "%1"', 'REG_SZ',
			         'HKCU\SOFTWARE\Classes\AutoHotkeyScript\shell\edit\command'
		case 'Delete User Folder':
			if ProcessExist('code.exe')
			{
				if MsgBox('VSCode seems to be open, do you want to close it?', 'Warning', 'Icon? Y/N') = 'Yes'
					while pid := ProcessExist('code.exe')
						ProcessClose(pid)
				else
				{
					MsgBox 'Settings wont be reset', 'Info', 'Icon!'
					continue
				}
			}

			progress['Title'].Value := 'Deleting VSCode User Folder'
			try
			{
				loop files (path := A_AppData '\Code') '\*.*', 'FDR'
					FileRecycle(A_LoopFileFullPath), Sleep(10)

				DirCreate path '\User'

				FileAppend '{`n' settings '`n}', path '\User\settings.json'
			}
			catch Error as err
				MsgBox 'There was a problem removing the user folder.`n'
				.      'The system returned the following error:`n`n' err.what '`n`n' err.Message '`n'
				.      'path: ' path
		case 'Delete Extensions':
			if vsCodeOpen
				continue

			progress['Title'].Value := 'Deleting Extensions'
			try
			{
				loop files (path := StrReplace(A_WinDir, '\WINDOWS') '\Users\' A_UserName '\.vscode') '\*.*', 'FDR'
					FileRecycle(A_LoopFileFullPath), Sleep(10)
			}
			catch Error as err
				MsgBox 'There was a problem removing the extensions folder.`n'
				.      'The system returned the following error:`n`n' err.what '`n`n' err.Message '`n'
				.      'path: ' path
		case 'Install Extensions':
			SetTimer UpdateBar, 0
			progress.Destroy()
			extensions.Show()
			return
		}
		Sleep 10 ; give time to the progress bar to update
	}

	SetTimer UpdateBar, 0
	ShowPopUp('https://www.the-automator.com/adsinfo')
}

UpdateTree(ctrl, info)
{
	tree.modify(info, 'Select')
	topChild := tree.GetChild(optAll)
	switch info {
		case optAll:
			isChecked := tree.Get(info, 'Checked')
			tree.Modify(topChild, 'Check' isChecked)
			while nextItem := tree.GetNext(nextItem ?? topChild)
				tree.Modify(nextItem, 'Check' isChecked)
		default:
			tree.Modify(optAll, '-Check')
	}
}