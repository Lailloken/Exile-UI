#NoTrayIcon
#NoEnv
#SingleInstance Force
#Requires AutoHotkey >=1.1.36 <2
#Include data\JSON.ahk

SetBatchLines, -1
WinWait, % "Exile UI: OCR",, 2
If ErrorLevel
	ExitApp
WinGetText, vars, % "Exile UI: OCR"
If !InStr(vars, """client"":")
	ExitApp

comms := json.Load(Trim(vars, " `n`r`t"))
If !comms.Count()
{
	StringSend("JSON error")
	ExitApp
}

scan_start := A_TickCount
poe_client := comms.client, clip := comms.clip, blackbars := comms.blackbars, runeshaping := comms.runeshaping, english := (comms.language = "english"), debug := comms.debug
If (usecase := comms.usecase)
	%usecase% := 1
For index, val in comms.params
	%val% := 1
For index, val in clip
	If !IsNumber(val)
	{
		StringSend("OCR failed")
		ExitApp
	}

If !(pToken := Gdip_Startup(1))
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit("Exit")

ScreenCap()
If runeshaping
	Runeshaping()
Else Generic()

ExitApp
Return

#Include %A_WorkingDir%\data\External Functions.ahk

Blank(var)
{
	If (var = "")
		Return 1
}

Exit()
{
	global

	Gdip_Shutdown(pToken)
}

Generic()
{
	global

	hbmBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0), pIRandomAccessStream := HBitmapToRandomAccessStream(hbmBitmap), Gdip_DisposeImage(pBitmap)
	text := ocr_uwp(pIRandomAccessStream, (english ? "en" : "FirstAvailable")), ObjRelease(pIRandomAccessStream)
	StringUpper, text, text

	If !Blank(debug) && GetKeyState(debug, "P")
	{
		Gui, test: New, -DPIScale +LastFound +AlwaysOnTop +ToolWindow, OCR debug
		Gui, test: Margin, 5, 5
		Gui, test: Font, s14
		Gui, test: Add, Pic, % "Section w" wCap " h" hCap, % "HBitmap:*" hbmBitmap
		Gui, test: Add, Text, ys, % text
		Gui, test: Add, Text, xs, % "scan time: " A_TickCount - scan_start " ms"
		Gui, test: Show
		WinWaitClose, OCR debug
	}
	Else StringSend(text ? "OCR successful:`n" text : "OCR failed")
	DeleteObject(hbmBitmap)
}

Runeshaping()
{
	global

	yLast := 0, HBMs := [], aText := []

	;pEffect := Gdip_CreateEffect(5, 0, 25), Gdip_BitmapApplyEffect(pBitmap, pEffect), Gdip_DisposeEffect(pEffect)
	;pEffect := Gdip_CreateEffect(2, 0, 100), Gdip_BitmapApplyEffect(pBitmap, pEffect), Gdip_DisposeEffect(pEffect)
	Loop
	{
		If controller
			high_tier := 1
		hClip := Round(poe_client.2 * (high_tier ? 3/40 : 2/45)) * 2
		If (yLast + hClip >= clip.4 * 2)
			Break
	
		pBitmap_clone := Gdip_CloneBitmapArea(pBitmap, 0, yLast + (high_tier ? hClip//2 : 0), wCap*2, (high_tier ? hClip//2 : hClip),, 1)
		hbmBitmap_clone := Gdip_CreateHBITMAPFromBitmap(pBitmap_clone, 0), Gdip_DisposeImage(pBitmap_clone)

		If !controller
		{
			pBitmap_clone1 := Gdip_CloneBitmapArea(pBitmap, Floor(poe_client.2 * (13/120)) * 2, yLast + (high_tier ? hClip//2 : 0), Floor(poe_client.2 * (43/160)) * 2, (high_tier ? hClip//2 : hClip),, 1)
			hbmBitmap_clone1 := Gdip_CreateHBITMAPFromBitmap(pBitmap_clone1, 0), Gdip_DisposeImage(pBitmap_clone1)
		}
		pIRandomAccessStream := HBitmapToRandomAccessStream(high_tier ? hbmBitmap_clone : hbmBitmap_clone1), text := ocr_uwp(pIRandomAccessStream, (english ? "en" : "FirstAvailable")), ObjRelease(pIRandomAccessStream)
		text := Trim(text, "`n`t* "), text := ((check := InStr(text, "`n",, 0)) ? SubStr(text, check + 1) : text)
		StringUpper, text, text

		If (StrLen(text) <= 5)
		{
			If !high_tier
				high_tier := 1
			Else
			{
				high_tier := "", yLast += Round(poe_client.2 * (2/45)) * 2
				DeleteObject(hbmBitmap_clone)
				Break
			}
		}
		Else yLast += hClip, aText.Push(text . (high_tier ? " [1]" : "")), HBMs.Push(hbmBitmap_clone), high_tier := "", text_all .= (!text_all ? "" : "`n") . aText[aText.MaxIndex()]
		If !controller
			DeleteObject(hbmBitmap_clone1)
	}

	Gdip_DisposeImage(pBitmap)
	StringUpper, text_all, text_all
	If !Blank(debug) && GetKeyState(debug, "P") && text_all
	{
		WinGetPos, xWin, yWin, wWin, hWin, ahk_class POEWindowClass
		Gui, test: New, -DPIScale +LastFound +AlwaysOnTop +ToolWindow, OCR debug
		Gui, test: Margin, 5, 5
		Gui, test: Font, s14
		Gui, test: Add, Text, % "Hidden HWNDhwnd", bla
		ControlGetPos,,,, hControl,, ahk_id %hwnd%
		For index, hbm in HBMs
		{
			Gui, test: Add, Pic, % "Section " (index = 1 ? "xp yp" : "xs") " w" wCap " h" poe_client.2 * (InStr(aText[index], "[") ? 3/80 : 2/45), % "HBitmap:*" hbm
			Gui, test: Add, Text, % "ys yp+" (poe_client.2 * (InStr(aText[index], "[") ? 3/80 : 2/45))//2 - hControl//2, % aText[index]
		}
		Gui, test: Add, Text, % "Section xs", % "scan time: " A_TickCount - scan_start " ms"
		Gui, test: Show, % "NA x" xWin + Round(poe_client.2//2 * 1.1) " y" yWin
		WinWaitClose, OCR debug
	}
	Else StringSend(text_all ? "OCR successful:`n" text_all : "OCR failed")
	
	For index, hbmBitmap in HBMs
		DeleteObject(hbmBitmap)
}

ScreenCap()
{
	global

	pBitmap := Gdip_BitmapFromHWND(poe_client.1, 1)
	If blackbars
		pBitmap_copy := Gdip_CloneBitmapArea(pBitmap, blackbars.1, blackbars.2, blackbars.3, blackbars.4,, 1), Gdip_DisposeImage(pBitmap), pBitmap := pBitmap_copy
	pBitmap_cropped := Gdip_CloneBitmapArea(pBitmap, clip.1, clip.2, clip.3, clip.4,, 1)
	Gdip_DisposeBitmap(pBitmap), pBitmap := pBitmap_cropped

	Gdip_GetImageDimensions(pBitmap, wCap, hCap)
	pBitmap_resized := Gdip_ResizeBitmap(pBitmap, wCap*2, hCap*2, 1, 7, 1), Gdip_DisposeImage(pBitmap), pBitmap := pBitmap_resized

	For index, val in comms.effects
		pEffect := Gdip_CreateEffect(val.1, val.2, val.3, val.4), Gdip_BitmapApplyEffect(pBitmap, pEffect), Gdip_DisposeEffect(pEffect)
}

StringSend(ByRef string) ;based on example #4 on https://www.autohotkey.com/docs/v1/lib/OnMessage.htm
{
	local
	global vars

	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
	SizeInBytes := (StrLen(string) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)
	NumPut(&string, CopyDataStruct, 2*A_PtrSize)
	SendMessage, 0x004A, 0, &CopyDataStruct,, % "Exile UI: OCR"
	Return (ErrorLevel = "FAIL" ? 0 : ErrorLevel)
}
