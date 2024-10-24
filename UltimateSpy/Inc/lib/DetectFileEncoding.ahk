#Requires AutoHotkey v2.0

DetectFileEncoding(filePath) {
    try {
        ; Read the first few bytes of the file
        fileObj := FileOpen(filePath, "r")
        if !fileObj {
            throw Error("Unable to open file: " . filePath)
        }

        ; Read the first 3 bytes
        buffer := Buffer(3)
        bytes := fileObj.RawRead(buffer, 3)
        fileObj.Close()

        ; Check for UTF-8 BOM (Byte Order Mark)
        if (buffer[1] == 0xEF && buffer[2] == 0xBB && buffer[3] == 0xBF) {
            return "UTF-8 with BOM"
        }

        ; If no BOM, read more content for analysis
        fileObj := FileOpen(filePath, "r")
        content := fileObj.Read(1024)  ; Read up to 1024 characters
        fileObj.Close()

        ; Check for UTF-8 characteristics
        if (RegExMatch(content, "[\xC2-\xDF][\x80-\xBF]|[\xE0-\xEF][\x80-\xBF]{2}|[\xF0-\xF4][\x80-\xBF]{3}")) {
            return "UTF-8 without BOM"
        }

        ; If no UTF-8 characteristics found, assume ANSI
        return "ANSI"
    } catch as err {
        return "Error: " . err.Message
    }
}