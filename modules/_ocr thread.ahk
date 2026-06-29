#NoTrayIcon
#NoEnv
#SingleInstance Force
#Requires AutoHotkey >=1.1.36 <2

SetBatchLines, -1
WinWait, % "Exile UI: OCR",, 2
If ErrorLevel
	ExitApp
WinGetText, vars, % "Exile UI: OCR"
If !InStr(vars, "client: ")
	ExitApp
poe_client := SubStr(vars, 9), poe_client := SubStr(poe_client, 1, InStr(poe_client, "`n") - 1), poe_client := StrSplit(poe_client, "|")
clip := SubStr(vars, InStr(vars, "clip: ") + 6), clip := SubStr(clip, 1, InStr(clip, "`n") - 1), clip := StrSplit(clip, "|")
If (check := InStr(vars, "blackbars:"))
	blackbars := SubStr(vars, check + 11), blackbars := SubStr(blackbars, 1, InStr(blackbars, "`n") - 1), blackbars := StrSplit(blackbars, "|")
runeshaping := InStr(vars, "runeshaping"), debug := InStr(vars, "debug"), english := InStr(vars, "english")

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
If runeshaping
	Runeshaping()
Else Statlas()
ExitApp
Return

#Include %A_WorkingDir%\data\External Functions.ahk

Runeshaping()
{
	global

	start := A_TickCount, pBitmap := Gdip_BitmapFromHWND(poe_client.1, 1), yLast := 0, HBMs := [], aText := []
	If blackbars
		pBitmap_copy := Gdip_CloneBitmapArea(pBitmap, blackbars.1, blackbars.2, blackbars.3, blackbars.4,, 1), Gdip_DisposeImage(pBitmap), pBitmap := pBitmap_copy
	pBitmap_cropped := Gdip_CloneBitmapArea(pBitmap, clip.1, clip.2, clip.3, clip.4,, 1)
	Gdip_DisposeBitmap(pBitmap), pBitmap := pBitmap_cropped

	Gdip_GetImageDimensions(pBitmap, width, height)
	pBitmap_resized := Gdip_ResizeBitmap(pBitmap, width*2, height*2, 1, 7, 1), Gdip_DisposeImage(pBitmap), pBitmap := pBitmap_resized
	;pEffect := Gdip_CreateEffect(5, 0, 25), Gdip_BitmapApplyEffect(pBitmap, pEffect), Gdip_DisposeEffect(pEffect)
	;pEffect := Gdip_CreateEffect(2, 0, 100), Gdip_BitmapApplyEffect(pBitmap, pEffect), Gdip_DisposeEffect(pEffect)
	Loop
	{
		hClip := Round(poe_client.2 * (high_tier ? 3/40 : 2/45)) * 2
		If (yLast + hClip >= clip.4 * 2)
			Break
		pBitmap_clone := Gdip_CloneBitmapArea(pBitmap, 0, yLast, width*2, hClip,, 1)
		hbmBitmap_clone := Gdip_CreateHBITMAPFromBitmap(pBitmap_clone, 0), Gdip_DisposeImage(pBitmap_clone)
		pIRandomAccessStream := HBitmapToRandomAccessStream(hbmBitmap_clone), text := ocr_uwp(pIRandomAccessStream, (english ? "en" : "FirstAvailable")), ObjRelease(pIRandomAccessStream)
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
		Else yLast += hClip, aText.Push(Trim(text, "`n`t ") . (high_tier ? " [1]" : "")), HBMs.Push(hbmBitmap_clone), high_tier := "", text_all .= (!text_all ? "" : "`n") . aText[aText.MaxIndex()]
	}

	Gdip_DisposeImage(pBitmap)
	StringUpper, text_all, text_all
	If debug && GetKeyState("ALT", "P") && text_all
	{
		WinGetPos, xWin, yWin, wWin, hWin, ahk_class POEWindowClass
		Gui, test: New, -DPIScale +LastFound +AlwaysOnTop +ToolWindow, OCR debug
		Gui, test: Margin, 5, 5
		Gui, test: Font, s14
		Gui, test: Add, Text, % "Hidden HWNDhwnd", bla
		ControlGetPos,,,, hControl,, ahk_id %hwnd%
		For index, hbm in HBMs
		{
			Gui, test: Add, Pic, % "Section " (index = 1 ? "xp yp" : "xs") " w" width " h" poe_client.2 * (InStr(aText[index], "[") ? 3/40 : 2/45), % "HBitmap:*" hbm
			Gui, test: Add, Text, % "ys yp+" (poe_client.2 * (InStr(aText[index], "[") ? 3/40 : 2/45))//2 - hControl//2, % aText[index]
		}
		Gui, test: Add, Text, % "Section xs", % "scan time: " A_TickCount - start " ms"
		Gui, test: Show, % "NA x" xWin + Round(poe_client.2//2 * 1.1) " y" yWin
		WinWaitClose, OCR debug
	}
	Else StringSend(text_all ? "OCR successful:`n" text_all : "OCR failed")
	
	For index, hbmBitmap in HBMs
		DeleteObject(hbmBitmap)
	Gdip_Shutdown(pToken)
}

Statlas()
{
	global

	pBitmap := Gdip_BitmapFromHWND(poe_client.1, 1)
	If blackbars
		pBitmap_copy := Gdip_CloneBitmapArea(pBitmap, blackbars.1, blackbars.2, blackbars.3, blackbars.4,, 1), Gdip_DisposeImage(pBitmap), pBitmap := pBitmap_copy
	pBitmap_cropped := Gdip_CloneBitmapArea(pBitmap, clip.1, clip.2, clip.3, clip.4,, 1)
	Gdip_DisposeBitmap(pBitmap), pBitmap := pBitmap_cropped

	Gdip_GetImageDimensions(pBitmap, width, height)
	pBitmap_resized := Gdip_ResizeBitmap(pBitmap, width*2, height*2, 1, 7, 1), Gdip_DisposeImage(pBitmap), pBitmap := pBitmap_resized
	;pEffect := Gdip_CreateEffect(5, 0, 25), Gdip_BitmapApplyEffect(pBitmap, pEffect), Gdip_DisposeEffect(pEffect)
	;pEffect := Gdip_CreateEffect(2, 0, 100), Gdip_BitmapApplyEffect(pBitmap, pEffect), Gdip_DisposeEffect(pEffect)
	hbmBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0), pIRandomAccessStream := HBitmapToRandomAccessStream(hbmBitmap), Gdip_DisposeImage(pBitmap)
	text := ocr_uwp(pIRandomAccessStream, (english ? "en" : "FirstAvailable")), ObjRelease(pIRandomAccessStream)
	If GetKeyState("ALT", "P")
	{
		Gui, test: New, -DPIScale +LastFound +AlwaysOnTop +ToolWindow, OCR debug
		Gui, test: Add, Pic, Section, % "HBitmap:*" hbmBitmap
		Gui, test: Add, Text, xs, % "OCR result:`n" text
		Gui, test: Show
		WinWaitClose, OCR debug
	}
	Else StringSend(text ? "OCR successful:`n" text : "OCR failed")
	DeleteObject(hbmBitmap)
	Gdip_Shutdown(pToken)
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
