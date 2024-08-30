#Requires AutoHotkey v2.0

; curl --user ftpusername:ftpuserpass -o outputdirname\test.txt  ftp://host/test.txt
; /the-automator.com/public_html/download/img/thumbs/SAJ4oAZOKcY.jpg
Class curlFTP
{
	__New(User,Pass,FTPurl)
	{
		if !FileExist(A_winDir '\System32\CURL.EXE')
		{
			Notify.Show('CURL.EXE not found in System32, Please download and install it from https://curl.haxx.se/download.html')
			ExitApp
		}
		this.User   := User
		this.Pass   := Pass
		this.FTPurl := FTPurl
		this.temp   := 'temp.txt'
		this.cmdDir := A_ScriptDir
		this.Visibility := 'hide'
		return this
	}

	ChangeCmdDIR(dir)
	{
		this.cmdDir := dir
	}

	ChangeTemp(Temp)
	{
		this.temp := Temp
	}

	Download(FTPfileName,Localpath)
	{
		script := 'curl --user {1}:{2} -o "{3}" {4}' 
		script := Format(script, this.User , this.Pass , Localpath, this.FTPurl this.urlEncode(FTPfileName))
		Runwait(script, this.cmdDir,this.Visibility)
	}

	DownloadAll(Localpath,skipfile)
	{
		mScript := ''
		for i, FTPfileName in this.list()
		{
			if FTPfileName = skipfile
				continue
			script := 'curl --user {1}:{2} -o "{3}" {4}' 
			mScript := Format(script, this.User , this.Pass , Localpath "\" FTPfileName , this.FTPurl this.urlEncode(FTPfileName))
			Runwait(mScript, this.cmdDir,this.Visibility)
		}
	}

	Upload(Localpath)
	{	
		Script := 'curl -T "{3}" --user {1}:{2} {4}'
		script := Format(script,this.User,this.Pass,Localpath,this.FTPurl)
		Runwait(script, this.cmdDir, this.Visibility)
	}

	GetInfo(FTPfileName)
	{
		; curl ftp://ftp.example.com/directory/
		Script := 'curl --user {1}:{2} {3} -o {4}'
		script := Format(script,this.User,this.Pass,this.FTPurl this.urlEncode(FTPfileName),this.temp)
		Runwait(script, this.cmdDir,this.Visibility)
		return this.TempRead()
	}

	Dir()
	{
		; curl ftp://ftp.example.com/directory/
		Script := 'curl --user {1}:{2} {3} -o {4}'
		script := Format(script,this.User,this.Pass,this.FTPurl,this.temp)
		Runwait(script, this.cmdDir,this.Visibility)
		return this.TempRead()
	}

	Del(delfile)
	{
		;curl -v -u username:pwd ftp://host/FileTodelete.xml -Q "DELE FileTodelete.xml"
		Script := 'curl --user {1}:{2} {3} -Q "Dele {4}" -o {5}'
		script := Format(script,this.User,this.Pass,this.FTPurl,delfile,this.temp)
		Runwait(script, this.cmdDir,this.Visibility)
		return this.TempRead()
	}

	DeleteAll()
	{
		for i, file in xx := this.List()
			this.Del(file)
	}

	List()
	{
		Script := 'curl --user {1}:{2} --list-only {3} -o {4}'
		script := Format(script,this.User,this.Pass,this.FTPurl,this.temp)
		Runwait(script, this.cmdDir,this.Visibility)
		return this.TempRead()
	}

	TempRead()
	{
		list := []
		tempresult := this.cmdDir '\' this.temp
		if FileExist(tempresult)
		{
			content := FileRead(tempresult)
			FileDelete(tempresult)
			if content = ""
				return 0
			for file in StrSplit(content, "`n",'`r')
			{
				if file = ".."
				|| file = "."
				|| file = ""
					continue
				list.Push(file)
			}
			return list
		}
		return 0
	}

	urlEncode(str, sExcepts := "-_.", enc := "UTF-8")
	{
		hex := "00", func := "msvcrt\swprintf"
		buff := Buffer(StrPut(str, enc)), StrPut(str, buff, enc)   ;转码
		encoded := ""
		Loop {
			if (!b := NumGet(buff, A_Index - 1, "UChar"))
				break
			ch := Chr(b)
			; "is alnum" is not used because it is locale dependent.
			if (b >= 0x41 && b <= 0x5A ; A-Z
			|| b >= 0x61 && b <= 0x7A ; a-z
			|| b >= 0x30 && b <= 0x39 ; 0-9
			|| InStr(sExcepts, Chr(b), true))
				encoded .= Chr(b)
			else {
				DllCall(func, "Str", hex, "Str", "%%%02X", "UChar", b, "Cdecl")
				encoded .= hex
			}
		}
		return encoded
	}

}


