#NoTrayIcon
#NoEnv
#SingleInstance Force
#Requires AutoHotkey >=1.1.36 <2

SetBatchLines, -1
WinWait, % "Exile UI: statlas",, 2
If ErrorLevel
	ExitApp
WinGetText, vars, % "Exile UI: statlas"
If !InStr(vars, "client: ")
	ExitApp
poe_client := SubStr(vars, 9), poe_client := SubStr(poe_client, 1, InStr(poe_client, "`n") - 1)
clip := SubStr(vars, InStr(vars, "clip: ") + 6), clip := SubStr(clip, 1, InStr(clip, "`n") - 1), clip := StrSplit(clip, "|")
If (check := InStr(vars, "blackbars:"))
	blackbars := SubStr(vars, check + 11), blackbars := SubStr(blackbars, 1, InStr(blackbars, "`n") - 1), blackbars := StrSplit(blackbars, "|")

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
Statlas()
ExitApp
Return

#Include %A_WorkingDir%\data\External Functions.ahk

Statlas()
{
	global

	pBitmap := Gdip_BitmapFromHWND(poe_client, 1)
	If blackbars
		pBitmap_copy := Gdip_CloneBitmapArea(pBitmap, blackbars.1, blackbars.2, blackbars.3, blackbars.4,, 1), Gdip_DisposeImage(pBitmap), pBitmap := pBitmap_copy
	pBitmap_cropped := Gdip_CloneBitmapArea(pBitmap, clip.1, clip.2, clip.3, clip.4,, 1)
	Gdip_DisposeBitmap(pBitmap), pBitmap := pBitmap_cropped

	Gdip_GetImageDimensions(pBitmap, width, height)
	pBitmap_resized := Gdip_ResizeBitmap(pBitmap, width*2, height*2, 1, 7, 1), Gdip_DisposeImage(pBitmap), pBitmap := pBitmap_resized
	pEffect := Gdip_CreateEffect(5, 0, 25), Gdip_BitmapApplyEffect(pBitmap, pEffect), Gdip_DisposeEffect(pEffect)
	;pEffect := Gdip_CreateEffect(2, 0, 100), Gdip_BitmapApplyEffect(pBitmap, pEffect), Gdip_DisposeEffect(pEffect)
	hbmBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0), pIRandomAccessStream := HBitmapToRandomAccessStream(hbmBitmap), Gdip_DisposeImage(pBitmap)
	text := ocr_uwp(pIRandomAccessStream), ObjRelease(pIRandomAccessStream)
	If GetKeyState("D", "P")
	{
		Gui, test: New, -DPIScale +LastFound +AlwaysOnTop +ToolWindow, statlas debug
		Gui, test: Add, Pic, Section, % "HBitmap:*" hbmBitmap
		Gui, test: Add, Text, xs, % "OCR result:`n" text
		Gui, test: Show, NA
		WinWaitClose, statlas debug
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
	SendMessage, 0x004A, 0, &CopyDataStruct,, % "Exile UI: statlas"
	Return (ErrorLevel = "FAIL" ? 0 : ErrorLevel)
}
