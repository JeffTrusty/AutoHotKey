#Requires AutoHotkey v2.0

   csvFilePath := FileSelect(1, , "Select the CSV file to import your Servers from", "*.csv")

   if (csvFilePath != "") {
     accountArray := CSVtoDict(csvFilePath)
     MsgBox accountArray[1]["ServerDescription"] . " | " . accountArray[1]["ServerName"]		;If no headers, then return the indices instead (e.g. accountArray[1][1], accountArray[1][2])
   }

CSVprs(str)								;creates an array of the elements of a CSV string
{
  arr := []
  Loop Parse, str, "CSV"
    arr.Push(A_LoopField)
  return arr
}

CSVtoDict(file)
{
  array := Map()
  data := StrSplit(FileRead(file), "`n", "`r")
  hdr := CSVprs(data.RemoveAt(1))				;reads the 1st line into an array and deletes it from the data array. Remove this line if your data does not have Headers.

  for x, y in data
  {
    array[x] := Map()
    for k, v in CSVprs(y)
      array[x][hdr[k]] := v				;change [hdr[k]] to just [k] if no headers
  }
  Return array
}

