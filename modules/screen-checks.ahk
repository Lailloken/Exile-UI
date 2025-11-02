Init_screenchecks()
{
	local
	global vars, settings

	If !FileExist("ini" vars.poe_version "\screen checks (" vars.client.h "p).ini")
		IniWrite, % "", % "ini" vars.poe_version "\screen checks (" vars.client.h "p).ini", gamescreen

	If (vars.client.h0 / vars.client.w0 < (5/12)) ;if the client is running a resolution that's wider than 21:9, there is a potential for black bars on each side
		settings.general.blackbars := LLK_IniRead("ini" vars.poe_version "\config.ini", "Settings", "black-bar compensation", 0) ;reminder: keep it in config.ini (instead of screen checks.ini) because it's not resolution-specific
	Else settings.general.blackbars := 0

	If settings.general.blackbars ;apply offsets if black-bar compensation is enabled
	{
		settings.general.oGamescreen := Format("{:0.0f}", (vars.client.w0 - (vars.client.h0 / (5/12))) / 2) ;get the width of the black bars (as an offset for pixel-checks)
		vars.client.x := vars.client.x0 + settings.general.oGamescreen, vars.client.w := vars.client.w0 - 2*settings.general.oGamescreen
	}
	Else settings.general.oGamescreen := 0

	vars.pixelsearch := {}, coords := LLK_IniRead("data\Resolutions.ini", vars.client.h "p", "gamescreen coordinates" vars.poe_version), coords := StrSplit(coords, ",", " ", 2)
	If (coords.Count() = 2)
		vars.pixelsearch.gamescreen := {"x1": coords.1, "y1": coords.2}
	Else If vars.poe_version
		vars.pixelsearch.gamescreen := {"x1": vars.client.x + vars.client.w - 1 - Round(vars.client.h/15), "y1": vars.client.y - 1 + Round(vars.client.h/24), "x2": vars.client.x + vars.client.w - 1, "y2": vars.client.y - 1 + Round(vars.client.h/24) + Round(vars.client.h/60)}

	ini := IniBatchRead("ini" vars.poe_version "\screen checks (" vars.client.h "p).ini")
	vars.pixelsearch.gamescreen.color1 := ini.gamescreen["color 1"]
	vars.pixelsearch.inventory := {"x1": 0, "x2": 0, "x3": 6, "y1": 0, "y2": 6, "y3": 0, "check": 0}
	Loop 3
		vars.pixelsearch.inventory["color" A_Index] := ini.inventory["color " A_Index]

	vars.pixelsearch.variation := 0, vars.pixelsearch.list := {"gamescreen": 1, "inventory": 1}
	vars.imagesearch := {}
	If !vars.poe_version
	{
		vars.imagesearch.search := ["skilltree", "betrayal", "sanctum", "exchange"] ;this array is parsed when doing image-checks: order is important (place static checks in front for better performance)
		vars.imagesearch.list := {"betrayal": 1, "exchange": 1, "skilltree": 1, "stash": 0, "sanctum": 1} ;this object is parsed when listing image-checks in the settings menu
		vars.imagesearch.checks := {"betrayal": {"x": vars.client.w - Round((1/72) * vars.client.h) * 2 , "y": Round((1/72) * vars.client.h), "w": Round((1/72) * vars.client.h), "h": Round((1/72) * vars.client.h)}
		, "skilltree": {"x": vars.client.w//2 - Round((1/16) * vars.client.h)//2, "y": Round(0.054 * vars.client.h), "w": Round((1/16) * vars.client.h), "h": Round(0.02 * vars.client.h)}
		, "stash": {"x": Round(0.27 * vars.client.h), "y": Round(0.055 * vars.client.h), "w": Round(0.07 * vars.client.h), "h": Round((1/48) * vars.client.h)}}
	}
	Else
	{
		vars.imagesearch.search := ["skilltree", "atlas", "sanctum", "exchange"] ;this array is parsed when doing image-checks: order is important (place static checks in front for better performance)
		vars.imagesearch.list := {"atlas": 1, "exchange": 1, "skilltree": 1, "sanctum": 1} ;this object is parsed when listing image-checks in the settings menu
		vars.imagesearch.checks := {"skilltree": {"x": vars.client.w//2 - vars.client.h//16, "y": Round(0.018 * vars.client.h), "w": vars.client.h//8, "h": Round(0.02 * vars.client.h)}
		, "atlas": {"x": vars.client.w//2 - vars.client.h//16, "y": Round(0.018 * vars.client.h), "w": vars.client.h//8, "h": Round(0.02 * vars.client.h)}}
	}
	vars.imagesearch.variation := 15
	vars.imagesearch.checks.exchange := {"x": Round(vars.client.w/2 - vars.client.h/8), "y": Round(vars.client.h/9), "w": Round(vars.client.h * (17/72)), "h": Round(vars.client.h * 0.023)}
	vars.imagesearch.checks.sanctum := {"x": vars.client.w//2, "y": Round(vars.client.h * 0.069), "w": Round(vars.client.h/36), "h": Round(vars.client.h/36)}

	For key in vars.imagesearch.list
		parse := StrSplit(ini[key]["last coordinates"], ","), vars.imagesearch[key] := {"check": 0, "x1": parse.1, "y1": parse.2, "x2": parse.3, "y2": parse.4}
}

Screenchecks_ImageRecalibrate(mode := "", check := "")
{
	local
	global vars, settings
	static hwnd_gui2

	If InStr(mode, "button")
	{
		KeyWait, % mode, D
		MouseGetPos, x1, y1
		Gui, LLK_snip_area: New, % "-Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow HWNDhwnd_gui2"
		Gui, LLK_snip_area: Margin, 0, 0
		Gui, LLK_snip_area: Color, Aqua
		WinSet, Trans, 75
		While GetKeyState(mode, "P")
		{
			MouseGetPos, x2, y2
			xPos := Min(x1, x2), yPos := Min(y1, y2), w := Abs(x1 - x2), h := Abs(y1 - y2)
			If w && h
				Gui, LLK_snip_area: Show, % "NA x" xPos " y" yPos " w" w " h" h
			Sleep 10
		}
		If WinExist("ahk_id " hwnd_gui2)
		{
			WinGetPos, x, y, w, h, ahk_id %hwnd_gui2%
			vars.snipping_tool.coords_area := {"x": x, "y": y, "w": w, "h": h}
			If InStr(mode, "LButton")
				vars.snipping_tool.GUI := 0
		}
	}
	Else If mode && IsObject(vars.snipping_tool.coords_area)
	{
		Switch mode
		{
			Case "w":
				vars.snipping_tool.coords_area[GetKeyState("Shift", "P") ? "h" : "y"] -= 1
			Case "a":
				vars.snipping_tool.coords_area[GetKeyState("Shift", "P") ? "w" : "x"] -= 1
			Case "s":
				vars.snipping_tool.coords_area[GetKeyState("Shift", "P") ? "h" : "y"] += 1
			Case "d":
				vars.snipping_tool.coords_area[GetKeyState("Shift", "P") ? "w" : "x"] += 1
			Case "space":
				vars.snipping_tool.GUI := 0
		}
		Gui, LLK_snip_area: Show, % "NA x" vars.snipping_tool.coords_area.x " y" vars.snipping_tool.coords_area.y " w" vars.snipping_tool.coords_area.w " h" vars.snipping_tool.coords_area.h
	}
	If mode
		Return

	If (check && vars.system.click = 1)
	{
		pBitmap := Gdip_BitmapFromHWND(vars.hwnd.poe_client, 1), checks := vars.imagesearch.checks
		If settings.general.blackbars
			pBitmap_copy := Gdip_CloneBitmapArea(pBitmap, settings.general.oGamescreen,, vars.client.w, vars.client.h,, 1), Gdip_DisposeImage(pBitmap), pBitmap := pBitmap_copy
		pClip := Gdip_CloneBitmapArea(pBitmap, checks[check].x, checks[check].y, checks[check].w, checks[check].h,, 1), Gdip_DisposeImage(pBitmap)
	}
	Else
	{
		Clipboard := "", vars.general.gui_hide := 1, LLK_Overlay("hide"), vars.snipping_tool := {"GUI": 1}
		pBitmap := Gdip_BitmapFromHWND(vars.hwnd.poe_client, 1), Gdip_GetImageDimensions(pBitmap, width, height), hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)

		Gui, LLK_snip: New, % "-Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDhwnd_gui"
		Gui, LLK_snip: Font, % "s" Round(settings.general.fSize * 1.5) " cAqua", % vars.system.font
		Gui, LLK_snip: Margin, 0, 0
		Loop 6
			text .= (!text ? " " : "`n ") Lang_Trans("screen_snipinstructions", A_Index) " "
		vars.hwnd.snipping_tool := {"main": hwnd_gui}, align := "left", LLK_PanelDimensions([text], settings.general.fSize * 2, wText, hText)
		Gui, LLK_snip: Add, Text, % "x0 y" height//2 - hText//2 " w" width " h" hText " BackgroundTrans Left HWNDhwnd_text", % text
		If !vars.pics.global.square_black_trans
			vars.pics.global.square_black_trans := LLK_ImageCache("img\GUI\square_black_trans.png")
		Gui, LLK_snip: Add, Pic, % "x0 y0 wp h" height " BackgroundTrans", % "HBitmap:*" vars.pics.global.square_black_trans
		Gui, LLK_snip: Add, Pic, % "xp yp wp hp", HBitmap:*%hBitmap%*
		Gui, LLK_snip: Show, NA x10000 y10000 w%width% h%height%
		WinGetPos, xPos, yPos, width, height, ahk_id %hwnd_gui%
		Gui, LLK_snip: Show, % "x" vars.monitor.x + vars.monitor.w / 2 - width//2 " y" vars.monitor.y + vars.monitor.h / 2 - height//2
		WinGetPos, xPos, yPos, width, height, ahk_id %hwnd_gui%
		vars.snipping_tool.coords := {"x": xPos, "y": yPos, "w": width, "h": height}, coords := vars.snipping_tool.coords

		If vars.client.stream
			Sleep, 1000
		While vars.snipping_tool.GUI && WinActive("ahk_id " hwnd_gui)
		{
			If (align = "left") && (vars.general.xMouse <= coords.x + coords.w // 2)
			{
				GuiControl, +Right, % hwnd_text
				GuiControl, movedraw, % hwnd_text
				align := "right"
			}
			Else If (align = "right") && (vars.general.xMouse >= coords.x + coords.w // 2)
			{
				GuiControl, +Left, % hwnd_text
				GuiControl, movedraw, % hwnd_text
				align := "left"
			}
			Sleep 100
		}

		Gui, LLK_snip: Destroy
		Gui, LLK_snip_area: Destroy
		vars.general.gui_hide := 0, LLK_Overlay("show")
		If IsObject(area := vars.snipping_tool.coords_area)
		&& LLK_IsBetween(area.x, coords.x, coords.x + coords.w) && LLK_IsBetween(area.y, coords.y, coords.y + coords.h)
		&& LLK_IsBetween(area.x + area.w, coords.x, coords.x + coords.w) && LLK_IsBetween(area.y + area.h, coords.y, coords.y + coords.h)
			pClip := Gdip_CloneBitmapArea(pBitmap, area.x - coords.x, area.y - coords.y, area.w, area.h,, 1)
		Else LLK_ToolTip(Lang_Trans("global_screencap") "`n" Lang_Trans("global_fail"), 2,,,, "red", settings.general.fSize,,, 1)
		Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap), vars.snipping_tool.GUI := 0
	}
	Return pClip
}

Screenchecks_ImageSearch(name := "") ;performing image screen-checks: use parameter to perform a specific check, leave blank to go through every check
{
	local
	global vars, settings

	For key, val in vars.imagesearch.search
		vars.imagesearch[val].check := 0 ;reset results for all checks
	check := 0

	If !name && !Settings_ScreenChecksValid("image").1.Count()
		Return

	pHaystack := Gdip_BitmapFromHWND(vars.hwnd.poe_client, 1) ;take screenshot from client
	If settings.general.blackbars
		pCopy := Gdip_CloneBitmapArea(pHaystack, vars.client.x - vars.monitor.x, 0, vars.client.w, vars.client.h,, 1), Gdip_DisposeBitmap(pHaystack), pHaystack := pCopy

	For index, val in vars.imagesearch.search
	{
		If name ;if parameter was passed to function, override val
			val := name

		If (val != name) && ((settings.features[val] = 0) || (val = "skilltree" && !settings.features.leveltracker) || (val = "stash" && (!settings.features.maptracker || !settings.maptracker.loot)))
			continue ;skip check if the connected feature is not enabled

		If !vars.pics.screen_checks[val]
			vars.pics.screen_checks[val] := LLK_ImageCache("img\Recognition (" vars.client.h "p)\GUI\" val . vars.poe_version ".bmp")

		If InStr(A_Gui, "settings_menu") ;when testing a screen-check via the settings, check the whole screenshot
			x1 := 0, y1 := 0, x2 := 0, y2 := 0, settings_menu := 1
		Else If !vars.imagesearch[val].x1 || !FileExist("img\Recognition (" vars.client.h "p)\GUI\" val . vars.poe_version ".bmp") ;skip check if reference-image or coordinates are missing
			continue
		Else If (val = "exchange")
			x1 := vars.client.w * 0.25, y1 := Round(vars.client.h/9), x2 := Round(vars.client.w/2 + vars.client.h * (18/144)), y2 := Round(vars.client.h/9 + vars.client.h * 0.024)
		Else x1 := vars.imagesearch[val].x1, y1 := vars.imagesearch[val].y1, x2 := vars.imagesearch[val].x2, y2 := vars.imagesearch[val].y2

		pNeedle := Gdip_CreateBitmapFromHBITMAP(vars.pics.screen_checks[val]) ;load the reference image
		If (Gdip_ImageSearch(pHaystack, pNeedle, LIST, x1, y1, x2, y2, vars.imagesearch.variation,, 1, 1) > 0) ;search within the screenshot
		{
			Gdip_GetImageDimension(pNeedle, width, height)
			vars.imagesearch[val].check := 1, vars.imagesearch[val].found := StrSplit(LIST, ",")
			vars.imagesearch[val].found.1 -= settings.general.oGamescreen, vars.imagesearch[val].found.3 := width, vars.imagesearch[val].found.4 := height
			If settings_menu && (SubStr(LIST, 1, InStr(LIST, ",") - 1) != vars.imagesearch[val].x1 || SubStr(LIST, InStr(LIST, ",") + 1) != vars.imagesearch[val].y1) ;if the coordinates are different from those saved in the ini, update them
			{
				coords := LIST "," SubStr(LIST, 1, InStr(LIST, ",") - 1) + Format("{:0.0f}", width) "," SubStr(LIST, InStr(LIST, ",") + 1) + Format("{:0.0f}", height)
				IniWrite, % coords, % "ini" vars.poe_version "\screen checks ("vars.client.h "p).ini", % val, last coordinates
				Loop, Parse, coords, `,
				{
					If (A_Index = 1)
						vars.imagesearch[val].x1 := A_LoopField
					Else If (A_Index = 2)
						vars.imagesearch[val].y1 := A_LoopField
					Else If (A_Index = 3)
						vars.imagesearch[val].x2 := A_LoopField
					Else vars.imagesearch[val].y2 := A_LoopField
				}
			}
			Gdip_DisposeImage(pNeedle)
			Gdip_DisposeImage(pHaystack)
			Return 1
		}
		Else Gdip_DisposeImage(pNeedle)
		If name
			break
	}
	Gdip_DisposeImage(pHaystack)
	Return 0
}

Screenchecks_Info(name) ;holding the <info> button to view instructions
{
	local
	global vars, settings

	If !IsObject(vars.help.screenchecks[name])
		Return

	Gui, screencheck_info: New, -Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +Border +E0x20 +E0x02000000 +E0x00080000 HWNDscreencheck_info
	Gui, screencheck_info: Color, 202020
	Gui, screencheck_info: Margin, % settings.general.fWidth/2, % settings.general.fWidth/2
	Gui, screencheck_info: Font, % "s"settings.general.fSize - 2 " cWhite", % vars.system.font
	vars.hwnd.screencheck_info := {"main": screencheck_info}

	If FileExist("img\GUI\screen-checks\"name . (name = "exchange" ? "" : vars.poe_version) ".jpg")
	{
		pBitmap0 := Gdip_CreateBitmapFromFile("img\GUI\screen-checks\" name . (name = "exchange" ? "" : vars.poe_version) ".jpg"), pBitmap := Gdip_ResizeBitmap(pBitmap0, vars.settings.w - settings.general.fWidth - 1, 10000, 1, 7, 1), Gdip_DisposeImage(pBitmap0)
		hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), Gdip_DisposeImage(pBitmap)
		Gui, screencheck_info: Add, Pic, % "Section w"vars.settings.w - settings.general.fWidth - 1 " h-1", HBitmap:%hBitmap%
	}

	For index, text in vars.help.screenchecks[name . (RegExMatch(name, "i)gamescreen") ? vars.poe_version : "")]
	{
		font := InStr(text, "(/bold)") ? "bold" : "", font .= InStr(text, "(/underline)") ? (font ? " " : "") "underline" : "", font := !font ? "norm" : font
		text := StrReplace(StrReplace(text, "(/bold)"), "(/underline)")
		Gui, screencheck_info: Font, % font
		Gui, screencheck_info: Add, Text, % (A_Index = 1 ? "Section " : "xs y+0 ") "w"vars.settings.w - settings.general.fWidth - 1, % text
	}

	Gui, screencheck_info: Show, NA x10000 y10000
	WinGetPos, x, y, w, h, ahk_id %screencheck_info%
	xPos := vars.settings.x, yPos := (vars.settings.y + h > vars.monitor.y + vars.monitor.h) ? vars.monitor.y + vars.monitor.h - h : vars.settings.y
	Gui, screencheck_info: Show, % "NA x"xPos " y"yPos
	KeyWait, LButton
	Gui, screencheck_info: Destroy
}

Screenchecks_PixelRecalibrate(name) ;recalibrating a pixel-check
{
	local
	global vars, settings, json

	object := {}, result := 1
	Switch name
	{
		Case "gamescreen":
			loopcount := 1
		Case "inventory":
			loopcount := 3
	}
	Loop %loopcount%
	{
		PixelGetColor, color, % vars.client.x + vars.client.w - 1 - vars.pixelsearch[name]["x" A_Index], % vars.client.y + vars.pixelsearch[name]["y" A_Index], RGB
		IniWrite, % """" (vars.pixelsearch[name]["color" A_Index] := object["color" A_Index] := color) """", % "ini" vars.poe_version "\screen checks ("vars.client.h "p).ini", %name%, color %A_Index%
	}
	If vars.general.MultiThreading
		StringSend("pixel-" name "=" json.dump(object))
	Return 1
}

Screenchecks_PixelRecalibrate2(name)
{
	local
	global vars, settings, json

	Gui, pixel_crosshair: New, -Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +E0x20 +E0x02000000 +E0x00080000 HWNDcrosshair
	Gui, pixel_crosshair: Color, Aqua
	Gui, pixel_crosshair: Margin, 0, 0
	Gui, pixel_crosshair: Add, Text, % "BackgroundTrans w1 h1"

	Gui, pixel_zoom: New, -Caption +E0x80000 +E0x20 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs HWNDzoom
	Gui, pixel_zoom: Show, NA

	object := {}
	While GetKeyState("LButton", "P")
	{
		pBitmap := Gdip_BitmapFromScreen(vars.general.xMouse - 5 "|" vars.general.yMouse - 11 "|" 11 "|" 11)
		hbmBitmap := CreateDIBSection(88, 88), hdcBitmap := CreateCompatibleDC(), obmBitmap := SelectObject(hdcBitmap, hbmBitmap), gBitmap := Gdip_GraphicsFromHDC(hdcBitmap)
		Gdip_SetInterpolationMode(gBitmap, 5)
		Gdip_DrawImage(gBitmap, pBitmap, 0, 0, 88, 88, 0, 0, 11, 11)
		UpdateLayeredWindow(zoom, hdcBitmap, vars.general.xMouse - 100, vars.general.yMouse - 44, 88, 88)
		Gdip_DisposeImage(pBitmap)
		SelectObject(hdcBitmap, obmBitmap)
		DeleteObject(hbmBitmap)
		DeleteDC(hdcBitmap)
		Gdip_DeleteGraphics(gBitmap)

		Gui, pixel_crosshair: Show, % "NA x" vars.general.xMouse " y" vars.general.yMouse - 5
		Sleep 50
	}
	Gui, pixel_crosshair: Destroy
	Gui, pixel_zoom: Destroy
	PixelGetColor, color, vars.general.xMouse, vars.general.yMouse - 5, RGB
	IniWrite, % (vars.pixelsearch[name].color1 := object["color1"] := (color ? color : "")), % "ini" vars.poe_version "\screen checks (" vars.client.h "p).ini", % name, color 1

	If vars.general.MultiThreading
		StringSend("pixel-" name "=" json.dump(object))
	Return color
}

Screenchecks_PixelSearch(name) ;performing pixel-checks
{
	local
	global vars, settings

	pixel_check := 1, pixels := vars.pixelsearch
	Switch name
	{
		Case "gamescreen":
			loopcount := 1
		Case "inventory":
			loopcount := 3
	}

	Loop %loopcount%
	{
		If (pixels[name]["color" A_Index] = "ERROR") || Blank(pixels[name]["color" A_Index])
		{
			pixel_check := 0
			Break
		}

		If vars.poe_version && (name = "gamescreen")
			PixelSearch, x, y, % pixels.gamescreen.x1, % pixels.gamescreen.y1, % pixels.gamescreen.x2, % pixels.gamescreen.y2, % pixels.gamescreen.color1, % pixels.variation, Fast RGB
		Else PixelSearch, x, y, % vars.client.x + vars.client.w - 1 - pixels[name]["x" A_Index], % vars.client.y + pixels[name]["y" A_Index], % vars.client.x + vars.client.w - 1 - pixels[name]["x" A_Index]
		, % vars.client.y + pixels[name]["y" A_Index], % pixels[name]["color" A_Index], % pixels.variation, Fast RGB

		pixel_check -= ErrorLevel
		If (pixel_check < 1)
			Break
	}
	Return pixel_check
}

SnippingTool(mode := 0)
{
	local
	global vars, settings

	KeyWait, LButton
	If mode && !WinExist("ahk_id " vars.hwnd.snip.main)
	{
		Gui, snip: New, -DPIScale +LastFound +ToolWindow +AlwaysOnTop +Resize HWNDhwnd, Exile UI: snipping widget
		Gui, snip: Color, Aqua
		WinSet, trans, 100
		vars.hwnd.snip := {"main": hwnd}

		Gui, snip: Add, Picture, % "x"settings.general.fWidth*5 " y"settings.general.fHeight*2 " h"settings.general.fHeight " w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.snip.help := vars.hwnd.help_tooltips["snip_about"] := hwnd
		If vars.snip.w
			Gui, snip: Show, % "x" vars.snip.x " y" vars.snip.y " w" vars.snip.w - vars.system.xBorder*2 " h" vars.snip.h - vars.system.caption - vars.system.yBorder*2
		Else Gui, snip: Show, % "x" vars.monitor.x + vars.client.xc - settings.general.fWidth * 16 " y" vars.monitor.y + vars.client.yc - settings.general.fHeight * 6 " w"settings.general.fWidth*31 " h"settings.general.fHeight*11
		Return 0
	}
	Else If !mode && WinExist("ahk_id " vars.hwnd.snip.main)
		SnipGuiClose()

	vars.general.gui_hide := 1, LLK_Overlay("hide")
	If A_Gui
		Gui, %A_Gui%: Hide

	If mode
	{
		WinGetPos, x, y, w, h, % "ahk_id "vars.hwnd.snip.main
		Gui, snip: Hide
		sleep 100
		pBitmap := Gdip_BitmapFromScreen(x + vars.system.xborder "|" y + vars.system.yborder + vars.system.caption "|" w - vars.system.xborder*2 "|" h - vars.system.yborder*2 - vars.system.caption)
		Gui, snip: Show
	}
	Else pBitmap := Screenchecks_ImageRecalibrate()

	vars.general.gui_hide := 0, LLK_Overlay("show")
	If A_Gui
		Gui, %A_Gui%: Show, NA
	If (pBitmap <= 0)
	{
		LLK_ToolTip(Lang_Trans("global_screencap") "`n" Lang_Trans("global_fail"), 2,,,, "red")
		Return 0
	}
	If WinExist("ahk_id "vars.hwnd.snip.main)
		WinActivate, % "ahk_id "vars.hwnd.snip.main

	Return pBitmap
}

SnippingToolMove()
{
	local
	global vars, settings

	WinGetPos, x, y, w, h, % "ahk_id "vars.hwnd.snip.main
	Switch A_ThisHotkey
	{
		Case "*up":
			If GetKeyState("Alt", "P")
				h -= GetKeyState("Ctrl", "P") ? 10 : 1
			Else y -= GetKeyState("Ctrl", "P") ? 10 : 1
		Case "*down":
			If GetKeyState("Alt", "P")
				h += GetKeyState("Ctrl", "P") ? 10 : 1
			Else y += GetKeyState("Ctrl", "P") ? 10 : 1
		Case "*left":
			If GetKeyState("Alt", "P")
				w -= GetKeyState("Ctrl", "P") ? 10 : 1
			Else x -= GetKeyState("Ctrl", "P") ? 10 : 1
		Case "*right":
			If GetKeyState("Alt", "P")
				w += GetKeyState("Ctrl", "P") ? 10 : 1
			Else x += GetKeyState("Ctrl", "P") ? 10 : 1
	}
	WinMove, % "ahk_id "vars.hwnd.snip.main,, %x%, %y%, %w%, %h%
}
