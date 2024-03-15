#Requires Autohotkey v2.0-beta.7

OBJID_WINDOW            := 0x00000000
OBJID_SYSMENU           := 0xFFFFFFFF
OBJID_TITLEBAR          := 0xFFFFFFFE
OBJID_MENU              := 0xFFFFFFFD
OBJID_CLIENT            := 0xFFFFFFFC
OBJID_VSCROLL           := 0xFFFFFFFB
OBJID_HSCROLL           := 0xFFFFFFFA
OBJID_SIZEGRIP          := 0xFFFFFFF9
OBJID_CARET             := 0xFFFFFFF8
OBJID_CURSOR            := 0xFFFFFFF7
OBJID_ALERT             := 0xFFFFFFF6
OBJID_SOUND             := 0xFFFFFFF5
OBJID_QUERYCLASSNAMEIDX := 0xFFFFFFF4
OBJID_NATIVEOM          := 0xFFFFFFF0

/** v0.1.0 | By RaptorX
 * Wrapper function for [AccessibleObjectFromWindow](https://docs.microsoft.com/en-us/windows/win32/api/oleacc/nf-oleacc-accessibleobjectfromwindow)
 *
 * Borrowed & tweaked from Acc.ahk Standard Library by Sean
 * * Updated by jethrow
 * * Updated to v2 by RaptorX
 *
 * ### Params:
 * - `idObject` - Type of object that can be returned by the app
 *                more info can be found [here](https://docs.microsoft.com/en-us/windows/desktop/WinAuto/object-identifiers)
 * - `WinTitle` - Title of the window that has a comObject
 * ClassNN  [optional] - ClassNN of a control from a window that returns a comObject
 *
 * ### Returns:
 * - `False`  - No COM object could be created
 * - `ComObj` - ComObject returned by the application based on the type selected by idObject
 *
 * ### Examples:
 * Get the application object from MS Word
 * ```
	wd := ObjectFromWindow(OBJID_NATIVEOM, "- Word ahk_class OpusApp", "_WwG1")
	wd := wd.Application
 * ```
 * Get the application object from MS Excel
 * ```
	xl := ObjectFromWindow(OBJID_NATIVEOM, "- Excel", "EXCEL71")
	xl := xl.Application
 * ```
 */
ObjectFromWindow(idObject, WinTitle?, ClassNN?) {
	oldMode := A_TitleMatchMode
	SetTitleMatchMode 2
	if IsSet(ClassNN)
		hwnd := ControlGetHwnd(ClassNN, WinTitle?)
	else
		hwnd := WinExist(WinTitle?)
	SetTitleMatchMode oldMode

	IID := Buffer(16)
	res := DllCall("oleacc\AccessibleObjectFromWindow"
	              ,"ptr" , hwnd
	              ,"uint", idObject &= 0xFFFFFFFF
	              ,"ptr" , -16 + NumPut("int64", idObject == 0xFFFFFFF0 ? 0x46000000000000C0 : 0x719B3800AA000C81
	                                   , NumPut("int64", idObject == 0xFFFFFFF0 ? 0x0000000000020400 : 0x11CF3C3D618736E0, IID))
	              ,"ptr*", ComObj := ComValue(9,0))

	return res ? res : ComObj
}