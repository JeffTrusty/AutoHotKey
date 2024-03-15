class APICall
{
	static http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	static _baseURL := ""
	static _endpoint := ""
	static _token := ""
	static _headers := {}
	static _cookies := {}
	
	baseURL[]
	{
		get {
			return APICall._baseURL
		}
		set {
			fixedURL := (!RegExMatch(value, "^http(s)?://") ? "https://" : "") value
			fixedURL := RegExReplace(value, "\/$")
			return APICall._baseURL := fixedURL
		}
	}
	endpoint[]
	{
		get {
			return APICall._endpoint
		}
		set {
			fixedURL := RegExReplace(value, "^\/")
			return APICall._endpoint := fixedURL
		}
	}
	token[]
	{
		get {
			return APICall._token
		}
		set {
			return APICall._token := value
		}
	}
	headers[]
	{
		get {
			return APICall._headers
		}
		set {
			; confirm that is an object
			return APICall._headers := value
		}
	}
	cookies[]
	{
		get {
			return APICall._cookies
		}
		set {
			for cookie,val in value
				http.setRequestHeader("Cookie", cookie "=" value)
			return APICall._cookies := value
		}
	}

	Call(method:="GET", payload := "")
	{
		http := APICall.http

		URL := APICall._baseURL "/" APICall._endpoint

		http.open(method, URL)
		
		for header,val in this.headers
			http.setRequestHeader(header, val)
		
		for cookie,val in this.cookies
			http.setRequestHeader("Cookie", cookie "=" val)

		http.send(payload)

		return http.responseText
	}
}

; setup the object
api := new APICall

api.baseURL := "https://api.zoom.us/v2/"

IniRead, token, ..\files\apis.ini, sites, zoom
api.token := token
api.headers := {authorization: "Bearer " token}

meetingID := 0 ; set to your meeting id

; perform api calls
api.endpoint := "meetings/" meetingID
OutputDebug, % api.call()

api.endpoint := "meetings/" meetingID "/polls"
OutputDebug, % api.call()