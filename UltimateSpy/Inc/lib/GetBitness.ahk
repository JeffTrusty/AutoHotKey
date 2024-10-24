#Requires AutoHotkey v2.0

CheckExeBitness(exePath) {
    try {
        ; Open the file
        file := FileOpen(exePath, "r")
        if !file {
            return "Error: Unable to open file"
        }

        ; Seek to the MS-DOS header
        file.Seek(0x3C, 0)
        peOffset := file.ReadUInt()

        ; Seek to the PE signature
        file.Seek(peOffset, 0)
        if (file.ReadUInt() != 0x4550) { ; "PE\0\0"
            return "Error: Invalid PE signature"
        }

        ; Read the Machine field from the COFF header
        file.Seek(peOffset + 4, 0)
        machine := file.ReadUShort()

        ; Close the file
        file.Close()

        ; Determine bitness based on the Machine field
        switch machine {
            case 0x014C:
                return "32-bit"
            case 0x8664:
                return "64-bit"
            default:
                return "Unknown bitness"
        }
    } catch as err {
        return "Error: " . err.Message
    }
}