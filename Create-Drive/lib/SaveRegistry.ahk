#SingleInstance
#Requires Autohotkey v2.0+


for arg in A_Args
{
	switch arg
	{
	case '-f':
		folder := A_Args[A_Index+1]
	case '-d':
		drive := A_Args[A_Index+1]
	case '-del':
		drive := A_Args[A_Index+1]
	default:
		continue
	}
	cmd .= arg ' "' A_Args[A_Index+1] '" '
}
else
{
	MsgBox 'Missing parameters`nFolder: ' (folder??'') '`nDrive: ' (drive??''), 'Error', 'IconX'
	return
}

