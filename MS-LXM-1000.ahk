#include nsAHKHID.ahk

; the script relies on CRYPT_STRING_NOCRLF Win32Api flag which is supported only since Vista
if A_OSVersion in WIN_2003,WIN_XP,WIN_2000
{
    MsgBox This script requires Windows Vista or later.
    ExitApp
}

if (A_PtrSize != 8) {
    MsgBox This script needs to be run using 64 bit version of Autohotkey like "AutoHotkeyU64.exe"
    ExitApp
}

class TMsNatural4000
{
    ; Microsoft Natural 4000 keyboard vendor and product ids
    static vendorId = 0x045E
    static productId = 0x00DB

    static keyCodeToNameMapping :=  { 0x0417000000000000: "MsNatural4000_Favorites1"
                                    , 0x0418000000000000: "MsNatural4000_Favorites2"
                                    , 0x0419000000000000: "MsNatural4000_Favorites3"
                                    , 0x01E2000000000000: "MsNatural4000_VolumeMute"
                                    , 0x01EA000000000000: "MsNatural4000_VolumeDown"
                                    , 0x01E9000000000000: "MsNatural4000_VolumeUp"
                                    , 0x01CD000000000000: "MsNatural4000_MediaPlayPause"}

    __New() {
        global AHKHID
        OnMessage(0x00FF, ObjBindMethod(this, "HandleInputMessage")) ; subscrube for WM_INPUT
        AHKHID.Register(12, 1, A_ScriptHwnd, AHKHID.RIDEV_INPUTSINK) ; the keyboard has UsagePage=12 and Usage=1
    }

    HandleInputMessage(wParam, lParam) {
        Critical ; otherwise you can get ERROR_INVALID_HANDLE

        global AHKHID

        ; if the event came from not a HID device we don't need to handle it
        devType := AHKHID.GetInputInfo(lParam, AHKHID.II_DEVTYPE)
        if (devType != AHKHID.RIM_TYPEHID) {
            return
        }

        inputInfo := AHKHID.GetInputInfo(lParam, AHKHID.II_DEVHANDLE)
        numberOfBytes := AHKHID.GetInputData(lParam, uData)
        vendorId := AHKHID.GetDevInfo(inputInfo, AHKHID.DI_HID_VENDORID, True)
        productId := AHKHID.GetDevInfo(inputInfo, AHKHID.DI_HID_PRODUCTID, True)

        ; if "vendorId" and "deviceId" don't much, the event came from a different device
        if (vendorId != this.vendorId) or (productId != this.productId) {
            return
        }

        ; keycode must be 8 bytes long
        if (numberOfBytes != 8) {
            MsgBox Fatal error, wrong number of bytes: %numberOfBytes%
        }

        hexString := "0x" . this.BinaryDataToHexDecimalString(uData, numberOfBytes)
        keyCode := this.SeparateKeyModifiers(hexString)
        keyName := this.keyCodeToNameMapping[keyCode]
        this.OnKey(keyName, keyCode, hexString)
    }

    ; event function, you can override it for some reason
    OnKey(keyName, keyCode, hexString) {
        ; call a subroutine related to the pressed key name if this subroutine exists
        if IsLabel(keyName) {
            Gosub, %keyName%
        }
    }

    SeparateKeyModifiers(hexString) {
        ; convert hexdecimal string representation to value
        code := hexString + 0

        modifiers := {}
        modifiers["Fn"] := (code & 0x10000) != 0
        modifiers["LCtrl"] := (code & 0x01) != 0
        modifiers["LShift"] := (code & 0x02) != 0
        modifiers["LAlt"] := (code & 0x04) != 0
        modifiers["LWin"] := (code & 0x08) != 0
        modifiers["RCtrl"] := (code & 0x10) != 0
        modifiers["RShift"] := (code & 0x20) != 0
        modifiers["RAlt"] := (code & 0x40) != 0
        modifiers["RWin"] := (code & 0x80) != 0
        modifiers["Ctrl"] := modifiers["LCtrl"] or modifiers["RCtrl"]
        modifiers["Shift" ] := modifiers["LShift"] or modifiers["RShift"]
        modifiers["Alt"] := modifiers["LAlt"] or modifiers["RAlt"]
        modifiers["Win"] := modifiers["LWin"] or modifiers["RWin"]

        ; store modifiers in a object variable
        this.keyModifiers := modifiers

        codeWithoutModifiers := code & 0x0FFFFFFFFFFEFF00
        return codeWithoutModifiers
    }

    BinaryDataToHexDecimalString(ByRef binaryVar, binaryVarSize)
    {
        ; https://docs.microsoft.com/en-us/windows/win32/api/wincrypt/nf-wincrypt-cryptbinarytostringa
        ; 0x4000000c = CRYPT_STRING_NOCRLF & CRYPT_STRING_HEX

        ; calculate output string size
        DllCall("crypt32.dll\CryptBinaryToString", "Ptr", &binaryVar, "UInt", binaryVarSize, "UInt", 0x4000000c, "Ptr", 0, "UInt*", outputSize)

        ; allocate buffer for storing resulting string
        VarSetCapacity(hexVar, outputSize * ( A_Isunicode ? 2 : 1 ), 1)

        ; convert binary data to the string
        DllCall("crypt32.dll\CryptBinaryToString", "Ptr", &binaryVar, "UInt", binaryVarSize, "UInt", 0x4000000c, "Ptr", &hexVar, "UInt*", outputSize)

        return StrGet(&hexVar)
    }
}

MsNatural4000 := new TMsNatural4000()
