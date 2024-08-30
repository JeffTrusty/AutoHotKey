#SingleInstance
#Requires Autohotkey v2.0-
;--
;@Ahk2Exe-SetVersion     0.1.0
; @Ahk2Exe-SetMainIcon    res\main.ico
;@Ahk2Exe-SetProductName Drive Mapper
;@Ahk2Exe-SetDescription Allows you to map folders as if they were normal hard drives
/**
 * ============================================================================ *
 * @Author   : RaptorX                                                          *
 * @Homepage :                                                                  *
 *                                                                              *
 * @Created  : May 26, 2023                                                     *
 * @Modified : August 26, 2023                                                  *
 * ============================================================================ *
 * Want a clear path for learning AutoHotkey?                                   *
 * Take a look at our AutoHotkey courses.                                 *
 * They're structured in a way to make learning AHK EASY                        *
 * Discover how easy AutoHotkey is here: https://the-Automator.com/Discover   *
 * ============================================================================ *
 */

main := Gui()
main.BackColor:='white'
main.OnEvent('Close', (*)=>ExitApp())
main.OnEvent('Escape', (*)=>ExitApp())

lvDrives := main.AddListView('w600 r10 Grid', ['Drive', 'Path'])
lvDrives.OnEvent('Click', (*)=> main['RemoveDrive'].Enabled := lvDrives.GetNext())

xloc := 600 + main.MarginX - 75 * 3 - main.MarginX * 2
main.AddButton('x' xloc ' w75', 'Add').OnEvent('Click', (*)=>addDrive.show())
main.AddButton('vRemoveDrive x+m w75 Disabled', 'Remove').OnEvent('Click', UnMountDrive)
main.AddButton('x+m w75', 'Exit').OnEvent('Click', (*)=>ExitApp())

drives := LoadDrives()
for drive,path in drives.existing
	lvDrives.Add('', drive, path)

loop lvDrives.GetCount('Col')
	lvDrives.ModifyCol(A_Index, 'AutoHdr')

addDrive := Gui('+AlwaysOnTop')
addDrive.BackColor:='white'
addDrive.AddText('c000072','Drive:')
addDrive.AddDropDownList('vsel_drive w150', drives.available)
addDrive.AddCheckbox('vauto_mount x+m yp+3 Checked', 'Mount on Startup')
addDrive.AddText('xm c000072','Folder Path:')
addDrive.AddEdit('vfolder_path w300')
addDrive.AddButton('x+m yp-1 w75', 'Browse').OnEvent('Click', SelectFolder)

xloc := 300+75+addDrive.MarginX*2 - 75*2 - addDrive.MarginX
addDrive.AddButton('x' xloc ' y+20 w75', 'Add').OnEvent('Click', MountDrive)
addDrive.AddButton('x+m w75', 'Cancel').OnEvent('Click', ResetAddGui)

main.Show()
return

SelectFolder(*)
{
	addDrive.Opt('+OwnDialogs')
	if !sel_folder := FileSelect('D 2')
		return

	addDrive['folder_path'].Value := sel_folder
}

ResetAddGui(*)
{
	addDrive['sel_drive'].Choose(0)
	addDrive['folder_path'].text := ''
	addDrive.Hide()
}

LoadDrives()
{
	available_drives := []
	existing_drives := Map()

	static REGKey := 'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices'
	loop 26
	{
		drive := Chr(A_Index + 64) ':\'
		if attr := FileExist(drive)
		{
			try
			{
				drive_path := unset
				drive_path := RegRead(REGKey, Trim(drive, '\'))
				drive_path := StrReplace(drive_path, '\??\')
				drive_path := StrReplace(drive_path, '\\', '\')
			}
			existing_drives.Set(drive, attr ~= 'S' ? 'Local Drive' : drive_path ?? 'Temporal Virtual Drive')
		}
		else if !FileExist(drive)
			available_drives.Push(drive)
	}

	return {available: available_drives, existing: existing_drives}
}

MountDrive(*)
{
	static tmpFile := A_Temp '\admindrive.ahk'
	static HKKey := 'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices'

	addDrive.Opt('+OwnDialogs')
	if !addDrive['folder_path'].text
	|| !addDrive['sel_drive'].text
	|| !FileExist(addDrive['folder_path'].text)
		return MsgBox('You must select a drive to mount and an existing folder', 'Error', 'IconX')

	drive := Trim(addDrive['sel_drive'].text, '\')
	folder := addDrive['folder_path'].text

	addDrive.Submit()
	addDrive['folder_path'].text := ''
	addDrive['sel_drive'].Delete(addDrive['sel_drive'].value)

	template :=
	(Ltrim
		"RunWait '" A_ComSpec " /c subst.exe {1} `"{2}`"',, 'Hide'"
		(addDrive['auto_mount'].value ? ("`nRegWrite '\??\{3}', 'REG_SZ', '{4}', '{1}'") : '')
	)
	hfile := FileOpen(tmpFile, 'w-', 'UTF-8')
	hfile.Write('#Requires Autohotkey v2.0+`n')
	hfile.Write(Format(template, drive, folder, StrReplace(folder, '\', '\\',,,1), HKKey))
	hfile.Close()

	RunWait A_ComSpec ' /c subst.exe ' drive ' `"' folder '`"',, 'Hide'
	RunWait '*RunAs "' A_AhkPath '" /script "' tmpFile '"',, 'Hide'
	FileDelete tmpFile

	if !FileExist(drive)
		return 	MsgBox('There was a problem mounting the drive. It will be mounted on startup.')

	lvDrives.Add('', drive '\', folder)
}

#HotIf lvDrives.Focused
Del::
UnMountDrive(*)
{
	static tmpFile := A_Temp '\admindrive.ahk'
	static HKKey := 'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices'

	hfile := FileOpen(tmpFile, 'w-', 'UTF-8')
	hfile.Write('#Requires Autohotkey v2.0+`n')

	question :=
	(
		'Are you sure you want to remove ' lvDrives.GetCount('S') ' drives?
		Local hard drives will NOT be removed by this action.'
	)
	if MsgBox(question,,'Y/N Icon?') != 'Yes'
		return

	while row := lvDrives.GetNext()
	{
		drive := Trim(lvDrives.GetText(row, 1), '\')
		cmd .= 'subst.exe /d ' drive ' & '
		
		if RegRead(HKKey, drive, '')
			hfile.Write("RegDelete '" HKKey "', '" drive "'`n")

		lvDrives.Delete(row)
	}
	cmd := Trim(cmd, ' & ')

	RunWait A_ComSpec ' /c ' cmd,, 'Hide'
	hfile.Write("RunWait '" A_ComSpec " /c " cmd "',, 'Hide'")
	hfile.Close()
	
	RunWait '*RunAs "' A_AhkPath '" /script "' tmpFile '"',, 'Hide'
	FileDelete tmpFile
	drives := LoadDrives()
	addDrive['sel_drive'].Delete()
	addDrive['sel_drive'].Add(drives.available)
}

^a::lvDrives.Modify(0, 'select')
#HotIf addDrive.FocusedCtrl.type = 'Edit'
^BackSpace::Send '^+{Left}{Delete}'
#HotIf