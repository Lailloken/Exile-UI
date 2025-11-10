Gui_CheckBounds(ByRef xPos, ByRef yPos, width, height)
{
	local
	global vars, settings

	xPos := (xPos < vars.monitor.x) ? vars.monitor.x : (xPos + width >= vars.monitor.x + vars.monitor.w ? vars.monitor.x + vars.monitor.w - width : xPos)
	yPos := (yPos < vars.monitor.y) ? vars.monitor.y : (yPos + height >= vars.monitor.y + vars.monitor.h ? vars.monitor.y + vars.monitor.h - height : yPos)
}

Gui_ClientFiller(mode := "") ;creates a black full-screen GUI to fill blank space between the client and monitor edges when using custom resolutions
{
	local
	global vars, settings

	If Blank(mode)
	{
		Gui, ClientFiller: New, -Caption +ToolWindow +LastFound HWNDhwnd
		Gui, ClientFiller: Color, Black
		WinSet, TransColor, Fuchsia
		Gui, ClientFiller: Add, Progress, % "Disabled BackgroundFuchsia x" vars.client.x - vars.monitor.x " y" vars.client.y - vars.monitor.y " w" vars.client.w " h" vars.client.h, 0
		vars.hwnd.ClientFiller := hwnd
	}
	Else If (mode = "show")
	{
		WinSet, AlwaysOnTop, On, % "ahk_id " vars.hwnd.poe_client
		Gui, ClientFiller: Show, % "NA x" vars.monitor.x " y" vars.monitor.y " Maximize"
		LLK_Overlay(vars.hwnd.ClientFiller, "show",, "ClientFiller")
		WinWait, % "ahk_id " vars.hwnd.ClientFiller
		WinSet, AlwaysOnTop, Off, % "ahk_id " vars.hwnd.poe_client
	}
}

Gui_CreateGraph(width, height, graph, color)
{
	local
	global vars, settings
	static brush, pen

	wPen := Ceil(height/80)
	If !IsObject(brush)
		brush := {"black": Gdip_BrushCreateSolid(0xFF000000)}, pen := {"baseline": Gdip_CreatePen(0xFFFFFFFF, 1)}

	hbmBitmap := CreateDIBSection(width, height), hdcBitmap := CreateCompatibleDC(), obmBitmap := SelectObject(hdcBitmap, hbmBitmap), gBitmap := Gdip_GraphicsFromHDC(hdcBitmap)
	Gdip_FillRectangle(gBitmap, brush.black, 0, 0, width, height)

	wMargins := Round(width/40), hMargins := Round(height/20), width2 := width - 2*wMargins, height2 := height - 2*hMargins, line := []
	If !pen[color]
		pen[color] := Gdip_CreatePen(0xFF . color, wPen)
	If !brush[color]
		brush[color] := Gdip_BrushCreateSolid(0xFF . color)

	min := max := running := 0
	For index, val in graph
		running += val, min := (running < min ? running : min), max := (running > max ? running : max)

	xScale := Floor(width2 / graph.Count()), yScale := Round(height2 / (max + Abs(min)), 4)
	baseline := hMargins + max * yScale, running := 0, line.InsertAt(1, wMargins, baseline)
	Gdip_DrawCurve(gBitmap, pen.baseline, [wMargins, baseline, width - wMargins, baseline])
	Gdip_SetSmoothingMode(gBitmap, 4)
	For index, val in graph
	{
		running += val, line.Push(index * xScale), line.Push(baseline - running * yScale)
		Gdip_FillRectangleC(gBitmap, brush[color], index * xScale, baseline - running * yScale, wPen)
	}

	Gdip_DrawCurve(gBitmap, pen[color], line, 0)

	SelectObject(hdcBitmap, obmBitmap), DeleteDC(hdcBitmap), Gdip_DeleteGraphics(gBitmap)
	Return hbmBitmap
}

Gui_Dummy(hwnd) ;used for A_Gui checks: "If (A_Gui = hwnd)" doesn't work reliably if the hwnd is blank, so this function returns -1 instead
{
	local

	If Blank(hwnd)
		Return -1
	Else Return hwnd
}

Gui_HelpToolTip(HWND_key)
{
	local
	global vars, settings
	static toggle := 0

	If vars.general.drag
		Return

	WinGetPos, xControl, y, wControl, h, % "ahk_id " vars.hwnd.help_tooltips[HWND_key]
	If Blank(y) || Blank(h)
	{
		MouseGetPos, x, y
		h := settings.general.fHeight
	}
	HWND_key := StrReplace(HWND_key, "|"), check := SubStr(HWND_key, 1, InStr(HWND_key, "_") - 1), control := SubStr(HWND_key, InStr(HWND_key, "_") + 1)
	If (check = "donation")
		check := "settings", donation := 1
	HWND_checks := {"cheatsheet": 0, "cheatsheets": "cheatsheet_menu", "maptracker": "maptracker_logs", "maptrackernotes": "maptrackernotes_edit", "notepad": 0, "leveltracker": "leveltracker_screencap", "leveltrackereditor": "leveltracker_editor", "leveltrackerschematics": "skilltree_schematics", "actdecoder": 0, "lootfilter": 0, "snip": 0, "lab": 0, "searchstrings": "searchstrings_menu", "statlas": 0, "updater": "update_notification", "geartracker": 0, "seed-explorer": "legion", "radial": 0, "recombination": 0, "sanctum": 0, "sanctumrelics": "sanctum_relics", "anoints": 0, "exchange": 0, "alarm": 0, "leveltrackergems": "leveltracker_gempickups", "leveltrackergemcutting": "leveltracker_gemcutting"}

	If (check = "alarm") && InStr(HWND_key, "set ")
		WinGetPos, xWin, yWin, wWin, hWin, % "ahk_id " vars.hwnd.alarm.alarm_set.main
	Else If (check != "settings")
		WinGetPos, xWin, yWin, wWin, hWin, % "ahk_id " vars.hwnd[(HWND_checks[check] = 0) ? check : HWND_checks[check]][(check = "leveltrackerschematics") ? "info" : "main"]

	For index, val in ["xWin", "yWin", "wWin", "hWin"]
		If !IsNumber(%val%)
			%val% := 0

	If (check = "lab" && InStr(control, "square"))
		vars.help.lab[control] := [vars.lab.compass.rooms[StrReplace(control, "square")].name], vars.help.lab[control].1 .= (vars.help.lab[control].1 = vars.lab.room.2) ? " (" Lang_Trans("lab_movemarker") ")" : ""

	If (check = "lootfilter" && InStr(control, "tooltip"))
		database := vars.lootfilter.filter, lootfilter := 1
	Else If (check = "leveltrackergems") && InStr(control, "gem ")
		database := vars.leveltracker_gempickups.tooltips, gempickups := 1
	Else database := donation ? vars.settings.donations : !IsObject(vars.help[check][control]) ? vars.help2 : vars.help

	tooltip_width := (check = "settings") ? vars.settings.w - vars.settings.wSelection : (wWin - 2) * (check = "cheatsheets" && vars.cheatsheet_menu.type = "advanced" ? 0.5 : InStr("leveltrackereditor, sanctum", check) ? 0.75 : 1)
	tooltip_width := (check = "actdecoder") ? 600 * Max(settings.actdecoder.sLayouts, 1) : (RegExMatch(check, "i)anoints|gemcutting") ? settings.general.fWidth * 50 : tooltip_width)
	tooltip_width := (check = "cheatsheet" ? settings.general.fWidth * 40 : tooltip_width)

	If (check = "exchange")
		tooltip_width := vars.exchange.wTooltip, xWin := xControl + wControl/2 - tooltip_width/2 - 1, yWin := y + h
	Else If (check = "alarm" || check = "leveltrackerschematics")
		tooltip_width := vars.monitor.h * 0.4, xWin := xWin + wWin/2 - tooltip_width/2
	Else If (check = "radial")
		tooltip_width := wWin * 2

	If !tooltip_width
		Return

	toggle := !toggle, GUI_name := "help_tooltip" toggle
	Gui, %GUI_name%: New, -Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +Border +E0x20 +E0x02000000 +E0x00080000 HWNDtooltip
	Gui, %GUI_name%: Color, 202020
	Gui, %GUI_name%: Margin, 0, 0
	Gui, %GUI_name%: Font, % "s" settings.general.fSize - 2 " cWhite", % vars.system.font
	hwnd_old := vars.hwnd.help_tooltips.main, vars.hwnd.help_tooltips.main := tooltip, vars.general.active_tooltip := vars.general.cMouse

	;LLK_PanelDimensions(vars.help[check][control], settings.general.fSize, width, height,,, 0)
	If lootfilter
	{
		target_array := Lootfilter_ChunkCompare(database[StrReplace(control, "tooltip ")],,, lootfilter_chunk), target_array := StrSplit(lootfilter_chunk, "`n", "`r`t")
		Loop, % (count := target_array.Count())
			If LLK_StringCompare(target_array[count - (A_Index - 1)], ["class", "#"])
				target_array.RemoveAt(count - (A_Index - 1))
	}
	Else If gempickups
		target_array := database[SubStr(control, 5)]
	Else target_array := (donation ? database[control].2.Clone() : database[check][control].Clone())

	If (control = "leveltracker profile select")
	{
		profile := LLK_ControlGet(vars.general.cMouse), profile := (profile = 1 ? "" : profile), ini := IniBatchRead("ini" vars.poe_version "\leveling guide" profile ".ini", "info")
		If (name := ini.info.name)
			target_array.InsertAt(1, Trim(ini.info.character ":`n" name, "`n:") "(/underline)(/bold)")
	}

	If InStr(control, "updater changelog")
		For index0, val in vars.updater.changelog
		{
			If !InStr(control, val.1.1)
				Continue
			For index, text in val
				If (index > 1)
				{
					Gui, %GUI_name%: Add, Text, % "x0 y-1000 Hidden w"tooltip_width - settings.general.fWidth, % StrReplace(StrReplace(text, "&", "&&"), "(/highlight)")
					Gui, %GUI_name%: Add, Text, % (index = 2 ? "x0 y0" : "xs") " Section Border BackgroundTrans hp+"settings.general.fWidth " w"tooltip_width, % ""
					Gui, %GUI_name%: Add, Text, % "HWNDhwnd xp+"settings.general.fWidth/2 " yp+"settings.general.fWidth/2 " w"tooltip_width - settings.general.fWidth . (InStr(text, "(/highlight)") ? " cFF8000" : ""), % StrReplace(StrReplace(text, "&", "&&"), "(/highlight)")
				}
		}
	Else
		For index, text in target_array
		{
			font := InStr(text, "(/bold)") ? "bold" : "", font .= InStr(text, "(/underline)") ? (font ? " " : "") "underline" : "", font := !font ? "norm" : font, text := StrReplace(text, "&", "&&")
			color := (InStr(text, "(/highlight)") ? "FF8000" : "White")
			For index0, remove in ["underline", "bold", "highlight"]
				text := StrReplace(text, "(/" remove ")")
			Gui, %GUI_name%: Font, % font
			Gui, %GUI_name%: Add, Text, % "x0 y-1000 Hidden w"tooltip_width - settings.general.fWidth, % LLK_StringCase(text)
			Gui, %GUI_name%: Add, Text, % (A_Index = 1 ? "Section x0 y0" : "Section xs") " Border BackgroundTrans hp+"settings.general.fWidth " w"tooltip_width, % ""
			Gui, %GUI_name%: Add, Text, % "Center xp+"settings.general.fWidth/2 " yp+"settings.general.fWidth/2 " w"tooltip_width - settings.general.fWidth . (vars.lab.room.2 && InStr(text, vars.lab.room.2) ? " cLime" : " c" color), % LLK_StringCase(text)
		}

	Gui, %GUI_name%: Show, NA AutoSize x10000 y10000
	WinGetPos,,, width, height, ahk_id %tooltip%
	xPos := (check = "settings") ? vars.settings.x + vars.settings.wSelection - 1 : xWin + (check = "leveltrackereditor" ? (wWin - 2)//8 : 0)
	yPos := InStr(control, "updater changelog") && (height > vars.monitor.h - (y + h)) ? y - height - 1 : (y + h + height + 1 > vars.monitor.y + vars.monitor.h) ? y - height : y + h

	If (check = "lootfilter")
		yPos := vars.lootfilter.yPos - height, yPos := (yPos < vars.monitor.y) ? vars.monitor.y : yPos
	Else If (check = "statlas")
		yPos := yWin + hWin
	Else If (check = "exchange")
		yPos := yWin
	Else If (check = "alarm")
		yPos := yWin - height + 1
	Else If (check = "leveltrackerschematics")
		xPos := vars.client.x + vars.client.w/2 - tooltip_width/2
	Else If (check = "leveltrackergemcutting")
		xPos := (control = "general" ? xControl : xControl + wControl), yPos := (control = "general" ? y + h : y)
	Else If (check = "radial")
		xPos := xWin + wWin/2 - tooltip_width/2

	If (check = "alarm" && yPos < vars.monitor.y)
		yPos := yWin + hWin - 1

	If (check != "leveltrackereditor")
		Gui_CheckBounds(xPos, yPos, width, height)
	Gui, %GUI_name%: Show, % "NA x"xPos " y"(InStr("notepad, lab, leveltracker, snip, searchstrings, maptracker", check) ? yWin - (InStr("maptracker", check) ? height - 1 : 0) : yPos)
	LLK_Overlay(tooltip, (width < 10) ? "hide" : "show",, GUI_name), LLK_Overlay(hwnd_old, "destroy")
}

Gui_MenuWidget(cHWND := "", mode := "", hotkey := 1)
{
	local
	global vars, settings

	If !IsObject(mode)
	{
		selection := {5: "settings"}, added := 1
		For index, feature in ["leveltracker", "maptracker", "notepad", "anoints"]
			If !settings.general.dev && (feature = "anoints" && !vars.client.stream)
				Continue
			Else If settings.features[feature] || settings.qol[feature]
				selection[vars.radial.order[added]] := feature, added += 1

		vars.radial.active := "menu", Gui_RadialMenu(selection)
		If !Blank(settings.hotkeys.menuwidget)
		{
			KeyWait, % settings.hotkeys.menuwidget
			KeyWait, % Hotkeys_Convert(settings.hotkeys.menuwidget)
		}
		Return
	}
	
	longpress := mode.longpress
	Switch mode.check
	{
		Default:
			LLK_ToolTip("no action")

		Case "anoints":
			If !longpress
				Anoints()
			Else Switch Gui_RadialMenu({2: "settings", 5: "anoints"}, "LButton")
			{
				Case "anoints":
					Anoints()
				Case "settings":
					Settings_menu("anoints")
			}

		Case "leveltracker":
			If !longpress
			{
				If (hotkey = 1)
					Leveltracker(cHWND, hotkey)
				Else If (hotkey = 2) && settings.leveltracker.geartracker
					Geartracker("toggle")
			}
			Else Switch Gui_RadialMenu({2: "settings", 4: "close", 5: "leveltracker", 6: (settings.leveltracker.geartracker ? "geartracker" : "")}, "LButton")
			{
				Case "close":
					Leveltracker_Toggle("destroy"), vars.hwnd.leveltracker := ""
				Case "geartracker":
					Geartracker("toggle")
				Case "leveltracker":
					Leveltracker(vars.general.cMouse, 1)
				Case "settings":
					Settings_menu("leveling tracker")
			}

		Case "maptracker":
			If !longpress
				Maptracker("", hotkey)
			Else Switch Gui_RadialMenu({2: "settings", 5: "maptracker", 6: (vars.maptracker.pause ? "resume" : "pause")}, "LButton")
			{
				Case "pause":
					Maptracker("", 2)
				Case "resume":
					Maptracker("", 2)
				Case "settings":
					Settings_menu("mapping tracker")
				Case "maptracker":
					Maptracker("", 1)
			}

		Case "notepad":
			If !longpress
				Notepad(hotkey = 1 ? "open" : "quick")
			Else Switch Gui_RadialMenu({2: "settings", 4: "close", 5: "notepad", 6: "quick-note"}, "LButton")
			{
				Case "close":
					For key, hwnd in vars.hwnd.notepad_widgets
						LLK_Overlay(hwnd, "destroy")
					vars.hwnd.notepad_widgets := {}, vars.notepad_widgets := {}
				Case "notepad":
					Notepad("open")
				Case "quick-note":
					Notepad("quick")
				Case "settings":
					Settings_menu("minor qol tools")
			}

		Case "settings":
			If !longpress
			{
				If WinExist("ahk_id "vars.hwnd.settings.main)
					Settings_menuClose()
				Else Settings_menu()
			}
			Else Switch Gui_RadialMenu({2: "restart", 5: "settings", 8: "close"}, "LButton")
			{
				Case "close":
					ExitApp
				Case "restart":
					LLK_Restart()
				Case "settings":
					Settings_menu()
			}
	}
}

Gui_Name(GuiHWND)
{
	local
	global vars

	For index, val in vars.GUI
		If !Blank(LLK_HasVal(val, GuiHWND))
			Return val.name
}

Gui_RadialMenu(selection := "", longpress := 0)
{
	local
	global vars, settings
	static toggle := 0

	active := (vars.radial.active = "menu" ? "menu" : "macros"), height := 2 * (settings[(active = "menu" ? "general" : "macros")].sMenu + 6), toggle := !toggle, GUI := "radial_menu" toggle
	vars.radial.click_select := (longpress ? vars.radial.click_select : ""), vars.radial.wait := 1

	Gui, %GUI%: New, -DPIScale -Caption +LastFound +AlwaysOnTop +ToolWindow HWNDradial_menu +E0x02000000 +E0x00080000
	Gui, %GUI%: Color, Purple
	WinSet, TransColor, Purple
	Gui, %GUI%: Margin, % (margin := Round(height/6)), % margin
	Gui, %GUI%: Font, % "s" settings.general.fSize - 2 " cWhite", % vars.system.font
	hwnd_old := vars.hwnd.radial.main, vars.hwnd.radial := {"main": radial_menu, "indexed": {}}, positions := []

	Loop 9
	{
		index := A_Index, val := selection[index]
		If val && !IsNumber(val)
		{
			click := vars.radial.click_select
			If (click && (click != "settings") || InStr("fasttravel, custommacros", vars.radial.active)) && (val = "settings")
				img := "settings_bg"
			Else img := (val = "close" && click = "notepad" ? "notepad_close" : (val = "close" && click = "leveltracker" ? "leveltracker_close" : val))
			file := (val = "leveltracker" && !(vars.hwnd.leveltracker.main || vars.leveltracker.toggle)) ? "0" : (val = "anoints" ? vars.poe_version : "")
			file := (val = "maptracker" && vars.maptracker.pause) ? 0 : file
			If !vars.pics.radial[active][img . file]
				vars.pics.radial[active][img . file] := LLK_ImageCache("img\GUI\radial menu\" img . file ".png", height)
			If !vars.pics.radial[active].square_black
				vars.pics.radial[active].square_black := LLK_ImageCache("img\GUI\square_black.png", height)
			If RegExMatch(val, "i)(leveltracker|maptracker)$")
				If !vars.pics.radial[active][img . (file = "0" ? "" : "0")]
					vars.pics.radial[active][img . (file = "0" ? "" : "0")] := LLK_ImageCache("img\GUI\radial menu\" img . (file = "0" ? "" : "0") ".png", height)
		}

		style := (InStr("147", index) ? "Section" : "") . (InStr("47", index) ? " xs" : (index = 1 ? "" : " ys"))
		If !val
			Gui, %GUI%: Add, Progress, % style " w" height + 2 " h" height + 2 " Disabled BackgroundTrans Hidden Border HWNDhwnd"
		Else If (val != "settings" && vars.radial.active = "custommacros")
		{
			Gui, %GUI%: Add, Text, % style " w" height + 2 " h" height + 2 " Center 0x200 BackgroundTrans Border HWNDhwnd0", % settings.macros["label_" val]
			Gui, %GUI%: Add, Pic, % "xp yp Border HWNDhwnd", % "HBitmap:*" vars.pics.radial[active].square_black
		}
		Else
		{
			Gui, %GUI%: Add, Pic, % style " Border BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.radial[active][img . file]
			If (vars.radial.active = "menu" && val = "settings") && (!vars.radial.click_select || vars.radial.click_select = "settings")
				Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd Border BackgroundBlack c" (vars.update.1 ? (vars.update.1 > 0 ? "Lime" : "Red") : "Black"), 100
		}

		If val
		{
			vars.hwnd.radial[val] := vars.hwnd.radial.indexed[index] := hwnd
			If (vars.radial.active = "custommacros")
				vars.hwnd.radial.indexed[index "_text"] := hwnd0
			entry := (!Blank(check0 := vars.radial.click_select) ? check0 " " val : val)

			If check0 && (check0 != "settings") && (val = "settings")
				vars.hwnd.help_tooltips["radial_settings sub-menu" handle] := hwnd, handle .= "|"
			Else If vars.help.radial[entry].Count() || vars.help2.radial[entry].Count()
				vars.hwnd.help_tooltips["radial_" entry] := hwnd
		}
		Else vars.hwnd.radial.indexed[index] := hwnd
		ControlGetPos, xPos, yPos,,,, ahk_id %hwnd%
		positions[index] := [xPos, yPos]
	}

	If (vars.radial.active = "menu") && settings.general.animations || InStr("fasttravel, custommacros", vars.radial.active) && settings.macros.animations
		Loop 9
		{
			ControlMove,, % positions[5].1 + (positions[A_Index].1 - positions.5.1) / 2, positions.5.2 + (positions[A_Index].2 - positions.5.2) / 2,,, % "ahk_id " vars.hwnd.radial.indexed[A_Index]
			If (vars.radial.active = "custommacros")
				GuiControl, +Hidden, % vars.hwnd.radial.indexed[A_Index "_text"]
		}

	If !longpress
		xPos := vars.general.xMouse - 2 * margin - 1.5 * height, yPos := vars.general.yMouse - 2 * margin - 1.5 * height
	Else xPos := vars.radial.selection.x - 2 * margin - height, yPos := vars.radial.selection.y - 2 * margin - height

	Gui_CheckBounds(xPos, yPos, 4 * margin + 3 * height, 4 * margin + 3 * height)
	Gui, %GUI%: Show, % "NA x" xPos " y" yPos
	LLK_Overlay(radial_menu, "show",, GUI), LLK_Overlay(hwnd_old, "destroy")
	WinGetPos, xWin, yWin, wWin, hWin, % "ahk_id " radial_menu
	vars.radial.window := {"x1": xWin, "y1": yWin, "x2": xWin + wWin, "y2": yWin + hWin}

	SetControlDelay, 0
	If (vars.radial.active = "menu") && settings.general.animations || InStr("fasttravel, custommacros", vars.radial.active) && settings.macros.animations
	{
		Loop, % (count := positions.5.1 - positions.4.1)
		{
			outer := A_Index
			If (A_Index < count * 0.75)
				Continue
			Loop, % 9
				If (A_Index != 5) && vars.hwnd.radial.indexed[A_Index]
				{
					xPos := positions.5.1 + (InStr("147", A_Index) ? -outer : (InStr("369", A_Index) ? outer : 0))
					yPos := positions.5.2 + (InStr("123", A_Index) ? -outer : (InStr("789", A_Index) ? outer : 0))
					ControlMove,, % xPos, % yPos,,, % "ahk_id " vars.hwnd.radial.indexed[A_Index]
				}
		}
		If (vars.radial.active = "custommacros")
			Loop 9
				GuiControl, -Hidden, % vars.hwnd.radial.indexed[A_Index "_text"]
	}
	vars.radial.wait := 0, vars.radial.last := A_TickCount

	If longpress
	{
		KeyWait, % longpress
		val := LLK_HasVal(vars.hwnd.radial, vars.general.cMouse), LLK_Overlay(vars.hwnd.radial.main, "destroy"), vars.hwnd.radial.main := ""
		Return val
	}
	Else vars.radial.hover_select := ""

	If settings.hotkeys.menuwidget
		KeyWait, % settings.hotkeys.menuwidget
}

Gui_RadialMenu2(cHWND := "", hotkey := 1)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.radial, cHWND), control := SubStr(check, InStr(check, "_") + 1), start := A_TickCount
	While GetKeyState("LButton", "P") && !longpress
		If (A_TickCount >= start + 200)
		{
			WinGetPos, xSelection, ySelection, wSelection, hSelection, % "ahk_id " cHWND
			longpress := 1, vars.radial.click_select := check, vars.radial.selection := {"x": xSelection - 2, "y": ySelection - 2}
		}
		Else Sleep 25

	If !longpress
		LLK_Overlay(vars.hwnd.radial.main, "destroy"), vars.hwnd.radial.main := ""

	If !Blank(check)
		If (vars.radial.active = "menu")
			Gui_MenuWidget(cHWND, {"longpress": longpress, "check": check}, hotkey)
		Else If (vars.radial.active = "fasttravel")
			Macro_FastTravel(cHWND, {"longpress": longpress, "check": check}, hotkey)
		Else Macro_CustomMacros(cHWND, {"longpress": longpress, "check": check}, hotkey)

	If longpress
		LLK_Overlay(vars.hwnd.radial.main, "destroy"), vars.hwnd.radial.main := ""
}

LLK_ControlGet(cHWND, GUI_name := "", subcommand := "")
{
	local

	If GUI_name
		GUI_name := GUI_name ": "
	GuiControlGet, parse, % GUI_name subcommand, % cHWND
	Return parse
}

LLK_ControlGetPos(cHWND, return_val)
{
	local

	ControlGetPos, x, y, width, height,, ahk_id %cHWND%
	Switch return_val
	{
		Case "x":
			Return x
		Case "y":
			Return y
		Case "w":
			Return width
		Case "h":
			Return height
	}
}

LLK_Drag(width, height, ByRef xPos, ByRef yPos, top_left := 0, gui_name := "", snap := 0, xOffset := 0, yOffset := 0, ignore_bounds := 0) ; top_left parameter: GUI will be aligned based on top-left corner
{
	local
	global vars, settings

	protect := (vars.pixelsearch.gamescreen.x1 < 8) ? 8 : vars.pixelsearch.gamescreen.x1 + 1, vars.general.drag := 1
	MouseGetPos, xMouse, yMouse

	If top_left
		xPos := xMouse - xOffset, yPos := yMouse - yOffset
	Else xPos := xMouse, yPos := yMouse

	If !gui_name
		gui_name := A_Gui

	If !gui_name
	{
		LLK_ToolTip("missing gui-name",,,,, "red")
		sleep 1000
		Return
	}

	If !ignore_bounds
	{
		xPos := (xPos < vars.monitor.x) ? vars.monitor.x : xPos, yPos := (yPos < vars.monitor.y) ? vars.monitor.y : yPos
		xPos -= vars.monitor.x, yPos -= vars.monitor.y
		If (xPos >= vars.monitor.w)
			xPos := vars.monitor.w - 1
		If (yPos >= vars.monitor.h)
			yPos := vars.monitor.h - 1
	}

	If (xPos >= vars.monitor.w / 2) && !top_left
		xTarget := xPos - width + 1 - xOffset
	Else xTarget := xPos + (!top_left ? xOffset : 0)

	If (yPos >= vars.monitor.h / 2) && !top_left
		yTarget := yPos - height + 1 - yOffset
	Else yTarget := yPos + (!top_left ? yOffset : 0)

	If !ignore_bounds
	{
		If top_left && (xTarget + width > vars.monitor.w)
			xTarget := vars.monitor.w - width, xPos := xTarget
		If top_left && (yTarget + height > vars.monitor.h)
			yTarget := vars.monitor.h - height, yPos := yTarget
	}

	If snap && LLK_IsBetween(xMouse, vars.monitor.x + vars.client.xc * 0.9, vars.monitor.x + vars.client.xc * 1.1)
		xPos := "", xTarget := vars.client.xc - width/2 + 1
	Else If snap && LLK_IsBetween(yMouse, vars.monitor.y + vars.client.yc * 0.9, vars.monitor.y + vars.client.yc * 1.1)
		yPos := "", yTarget := vars.client.yc - height/2 + 1

	Gui, %gui_name%: Show, % (vars.client.stream ? "" : "NA ") "x" vars.monitor.x + xTarget " y" vars.monitor.y + yTarget
}

LLK_FontDefault()
{
	local
	global vars, settings

	Return LLK_IniRead("data\Resolutions.ini", vars.monitor.h "p", "font", 16)
}

LLK_FontDimensions(size, ByRef font_height_x, ByRef font_width_x)
{
	local
	global vars

	Gui, font_size: New, -DPIScale -Caption +LastFound +AlwaysOnTop +ToolWindow +Border
	Gui, font_size: Margin, 0, 0
	Gui, font_size: Color, Black
	Gui, font_size: Font, % "cWhite s"size, % vars.system.font
	Gui, font_size: Add, Text, % "Border HWNDhwnd", % "7"
	GuiControlGet, font_check_, Pos, % hwnd
	font_height_x := font_check_h
	font_width_x := font_check_w
	Gui, font_size: Destroy
}

LLK_FontSizeGet(height, ByRef font_width) ;returns a font-size that approximates the height passed to the function
{
	local
	global vars

	Gui, font_size: New, -DPIScale -Caption +LastFound +AlwaysOnTop +ToolWindow
	Gui, font_size: Margin, 0, 0
	Gui, font_size: Color, Black
	Loop
	{
		Gui, font_size: Font, % "cWhite s"A_Index, % vars.system.font
		Gui, font_size: Add, Text, % "Border HWNDhwnd", % "7"
		ControlGetPos,,, font_width, font_height,, % "ahk_id "hwnd
		check += (font_height > height) ? 1 : 0
		If check
		{
			Gui, font_size: Destroy ;it would be technically correct to return A_Index - 1 (i.e. the last index where font_height was still lower than height), but there is a lot of leeway with font-heights ;cont
			Return A_Index + 2 ;because every text exclusively uses lower-case letters
		}
	}
}

LLK_ImageCache(file, resize := "", use_height := "")
{
	local
	global vars, settings

	pBitmap := Gdip_CreateBitmapFromFile(file), resizeY := 10000
	If IsNumber(use_height)
		resize := 10000, resizeY := use_height
	If IsNumber(resize)
		pBitmap_resized := Gdip_ResizeBitmap(pBitmap, resize, resizeY, 1, 7, 1), Gdip_DisposeBitmap(pBitmap), pBitmap := pBitmap_resized
	pHBM := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0), Gdip_DisposeImage(pBitmap)
	Return pHBM
}

LLK_Overlay(guiHWND, mode := "show", NA := 1, gui_name0 := "")
{
	local
	global vars, settings

	If Blank(guiHWND)
		Return

	If !Blank(gui_name0)
		vars.GUI.Push({"name": gui_name0, "hwnd": guiHWND, "show": 0, "dummy": ""})

	For index, val in vars.GUI
		If !Blank(LLK_HasVal(val, guiHWND))
		{
			gui_name := val.name, gui_index := index
			Break
		}

	If !InStr("showhide", guiHWND) && (Blank(gui_name) || Blank(gui_index))
		Return

	If (guiHWND = "hide")
	{
		For index, val in vars.GUI
		{
			If (val.hwnd = vars.hwnd.settings.main) && (vars.settings.active = "betrayal-info") || !WinExist("ahk_id " val.hwnd) || InStr(vars.hwnd.cheatsheet_menu.main "," vars.hwnd.searchstrings_menu.main "," vars.hwnd.leveltracker_screencap.main "," vars.hwnd.notepad.main "," vars.hwnd.leveltracker_editor.main "," vars.hwnd.leveltracker_gempickups.main, val.hwnd)
				Continue
			Gui, % val.name ": Hide"
		}
	}
	Else If (guiHWND = "show")
	{
		For index, val in vars.GUI
		{
			ControlGetPos, x,,,,, % "ahk_id " val.dummy
			If !val.show || Blank(x)
				Continue
			Gui, % val.name ": Show", % (NA ? "NA" : "")
		}
	}
	Else If (mode = "show") || (mode = "hide") && !Blank(gui_name0)
	{
		If !vars.GUI[gui_index].dummy
		{
			Gui, %gui_name%: Add, Text, Hidden x0 y0 HWNDhwnd, % "" ;add a dummy text-control to the GUI with which to check later on if it has been destroyed already (via ControlGetPos)
			vars.GUI[gui_index].dummy := hwnd, vars.GUI[gui_index].show := (mode = "show") ? 1 : 0
		}
		Else vars.GUI[gui_index].show := 1
		Gui, %gui_name%: Show, % (mode = "show" ? (NA ? "NA" : "") : "Hide")
	}
	Else If (mode = "hide")
	{
		If WinExist("ahk_id " guiHWND)
			Gui, %gui_name%: Hide
		vars.GUI[gui_index].show := 0
	}
	Else If (mode = "destroy")
	{
		If vars.GUI[gui_index].dummy
			ControlGetPos, x,,,,, % "ahk_id " vars.GUI[gui_index].dummy
		If WinExist("ahk_id " guiHWND) || !Blank(x)
			Gui, %gui_name%: Destroy
	}
	Else If (mode = "check")
	{
		If vars.GUI[gui_index].dummy
			ControlGetPos, x,,,,, % "ahk_id " vars.GUI[gui_index].dummy
		Return x
	}

	For index, val in vars.GUI ;check for GUIs that have already been destroyed
	{
		ControlGetPos, x,,,,, % "ahk_id " val.dummy
		If Blank(x)
			remove .= index ";"
	}
	Loop, Parse, remove, `;
		If IsNumber(A_LoopField)
			vars.GUI.RemoveAt(A_LoopField)
}

LLK_PanelDimensions(array, fSize, ByRef width, ByRef height, align := "left", header_offset := 0, margins := 1, min_width := 0)
{
	local
	global vars

	Gui, panel_dimensions: New, -DPIScale -Caption +LastFound +AlwaysOnTop +ToolWindow
	Gui, panel_dimensions: Margin, 0, 0
	Gui, panel_dimensions: Color, Black
	Gui, panel_dimensions: Font, % "s"fSize + header_offset " cWhite", % vars.system.font
	width := min_width ? 9999 : 0, height := 0, string := array.1

	If min_width
	{
		array := []
		Loop, % Max(LLK_InStrCount(string, " "), 1)
		{
			outer := A_Index, new_string := ""
			Loop, Parse, string, %A_Space%
				new_string .= A_LoopField . (outer = A_Index ? "`n" : " ")
			If (SubStr(new_string, 0) = "`n")
				new_string := SubStr(new_string, 1, -1)
			array.Push(new_string)
		}
	}

	For index, val in array
	{
		font := InStr(val, "(/bold)") ? "bold" : "", font .= InStr(val, "(/underline)") ? (font ? " " : "") "underline" : "", font := !font ? "norm" : font
		Gui, panel_dimensions: Font, % font
		val := StrReplace(StrReplace(StrReplace(val, "&&", "&"), "(/bold)"), "(/underline)"), val := StrReplace(val, "&", "&&")
		Gui, panel_dimensions: Add, Text, % align " HWNDhwnd Border", % header_offset && (index = 1) ? " " val : margins ? " " StrReplace(val, "`n", " `n ") " " : val
		Gui, panel_dimensions: Font, % "norm s"fSize
		WinGetPos,,, w, h, ahk_id %hwnd%
		height := (h > height) ? h : height
		width := (min_width && w < width || !min_width && w > width) ? w : width
		min_string := (w = width) ? val : min_string
	}

	Gui, panel_dimensions: Destroy
	;width := Format("{:0.0f}", width* 1.25)
	If min_width
		Return min_string
	While Mod(width, 2)
		width += 1
	While Mod(height, 2)
		height += 1
}

LLK_Progress(HWND_bar, key, HWND_control := "", key_wait := 1) ;HWND_bar = HWND of the progress bar, key = key that is held down to fill the progress bar, HWND_control = HWND of the button (to undo clipping)
{
	local

	start := A_TickCount
	While GetKeyState(key, "P")
	{
		GuiControl,, %HWND_bar%, % A_TickCount - start
		If (A_TickCount >= start + 600)
		{
			GuiControl,, %HWND_bar%, 0 ;reset the progress bar to 0
			If HWND_control
				GuiControl, movedraw, %HWND_control% ;redraw the button that was held down (otherwise the progress bar will remain on top of it)
			If key_wait
				KeyWait, % key
			Return 1
		}
		Sleep 20
	}
	GuiControl,, %HWND_bar%, 0
	If HWND_control
		GuiControl, movedraw, %HWND_control%
	Return 0
}

LLK_ToolTip(message, duration := 1, x := "", y := "", name := "", color := "White", size := "", align := "", trans := "", center := 0, background := "", center_text := 0)
{
	local
	global vars, settings

	If !name
		name := 1

	vars.tooltip.wait := 1

	If !size
		size := settings.general.fSize

	If Blank(trans)
		trans := 255

	If align
		align := " " align

	xPos := InStr(x, "+") || InStr(x, "+-") ? vars.general.xMouse + StrReplace(x, "+") : (x != "") ? x : vars.general.xMouse
	yPos := InStr(y, "+") || InStr(y, "+-") ? vars.general.yMouse + StrReplace(y, "+") : (y != "") ? y : vars.general.yMouse

	Gui, tooltip%name%: New, % "-DPIScale +E0x20 +LastFound +AlwaysOnTop +ToolWindow -Caption +Border +E0x02000000 +E0x00080000 HWNDhwnd"
	Gui, tooltip%name%: Color, % Blank(background) ? "Black" : background
	Gui, tooltip%name%: Margin, % settings.general.fwidth / 2, 0
	WinSet, Transparent, % trans
	Gui, tooltip%name%: Font, % "s" size* (name = "update" ? 1.4 : 1) " cWhite", % vars.system.font
	vars.hwnd["tooltip" name] := hwnd

	Gui, tooltip%name%: Add, Text, % "c"color align (center_text ? " Center" : ""), % message
	Gui, tooltip%name%: Show, % "NA x10000 y10000"
	WinGetPos,,, w, h, ahk_id %hwnd%

	If center
		xPos -= w//2

	xPos := (xPos + w > vars.monitor.x + vars.monitor.w) ? vars.monitor.x + vars.monitor.w - w : (xPos < vars.monitor.x ? vars.monitor.x : xPos)
	If IsNumber(y)
		yPos := (yPos + h > vars.monitor.y + vars.monitor.h) ? vars.monitor.y + vars.monitor.h - h : yPos
	Else yPos := (yPos - h < vars.monitor.y) ? vars.monitor.y + h : yPos

	Gui, tooltip%name%: Show, % "NA x"xPos " y"yPos - (y = "" || InStr(y, "+") || InStr(y, "-") ? h : 0)
	LLK_Overlay(hwnd, "show",, "tooltip" name)
	If duration
		vars.tooltip[hwnd] := A_TickCount + duration*1000
	vars.tooltip.wait := 0
}

RGB_Convert(RGB)
{
	local

	If InStr(RGB, " ")
	{
		Loop, Parse, RGB, % A_Space
			If (A_Index < 4)
				converted .= Format("{:02X}", A_LoopField)
		Return converted
	}
	For index, val in ["red", "green", "blue"]
		%val% := Format("{:i}", "0x" SubStr(RGB, 1 + 2*(index - 1), 2))
	Return [red, green, blue]
}

RGB_Picker(RGB := "")
{
	local
	global vars, settings
	static palette, hwnd_r, hwnd_g, hwnd_b, hwnd_edit_r, hwnd_edit_g, hwnd_edit_b, hwnd_final, sliders

	If !palette
	{
		palette := []
		palette.Push(["330000", "660000", "990000", "CC0000", "FF0000", "FF3333", "FF6666", "FF9999", "FFCCCC"])
		palette.Push(["331900", "663300", "994C00", "CC6600", "FF8000", "FF9933", "FFB266", "FFCC99", "FFE5CC"])
		palette.Push(["333300", "666600", "999900", "CCCC00", "FFFF00", "FFFF33", "FFFF66", "FFFF99", "FFFFCC"])
		palette.Push(["193300", "336600", "4C9900", "66CC00", "80FF00", "99FF33", "B2FF66", "CCFF99", "E5FFCC"])
		palette.Push(["003300", "006600", "009900", "00CC00", "00FF00", "33FF33", "66FF66", "99FF99", "CCFFCC"])
		palette.Push(["003319", "006633", "00994C", "00CC66", "00FF80", "33FF99", "66FFB2", "99FFCC", "CCFFE5"])
		palette.Push(["003333", "006666", "009999", "00CCCC", "00FFFF", "33FFFF", "66FFFF", "99FFFF", "CCFFFF"])
		palette.Push(["001933", "003366", "004C99", "0066CC", "0080FF", "3399FF", "66B2FF", "99CCFF", "CCE5FF"])
		palette.Push(["000033", "000066", "000099", "0000CC", "0000FF", "3333FF", "6666FF", "9999FF", "CCCCFF"])
		palette.Push(["190033", "330066", "4C0099", "6600CC", "7F00FF", "9933FF", "B266FF", "CC99FF", "E5CCFF"])
		palette.Push(["330033", "660066", "990099", "CC00CC", "FF00FF", "FF33FF", "FF66FF", "FF99FF", "FFCCFF"])
		palette.Push(["330019", "660033", "99004C", "CC0066", "FF007F", "FF3399", "FF66B2", "FF99CC", "FFCCE5"])
		palette.Push(["000000", "202020", "404040", "606060", "808080", "A0A0A0", "C0C0C0", "E0E0E0", "FFFFFF"])
	}

	If (A_Gui = "RGB_palette")
	{
		Loop, Parse, % "rgb"
			If (RGB = hwnd_%A_LoopField%)
				GuiControl,, % hwnd_edit_%A_LoopField%, % (input := LLK_ControlGet(RGB))
			Else If (RGB = hwnd_edit_%A_LoopField%)
			{
				If ((input := LLK_ControlGet(RGB)) > 255)
				{
					GuiControl, -gRGB_Picker, % RGB
					GuiControl,, % RGB, % (input := 255)
					GuiControl, +gRGB_Picker, % RGB
				}
				GuiControl,, % hwnd_%A_LoopField%, % input
			}
		Return
	}

	hwnd_GUI := {}, vars.RGB_picker := {"cancel": 0}
	Gui, RGB_palette: New, -Caption -DPIScale +LastFound +ToolWindow +AlwaysOnTop +Border HWNDhwnd +E0x02000000 +E0x00080000 HWNDhwnd_palette, Exile UI: RGB-Picker
	Gui, RGB_palette: Color, Black
	Gui, RGB_palette: Font, % "s" settings.general.fSize " cWhite", % vars.system.font
	Gui, RGB_palette: Margin, % settings.general.fWidth, % settings.general.fWidth

	For index0, val0 in palette
		For index, val in val0
		{
			style := (A_Index = 1) ? "Section " (index0 != 1 ? "ys x+-1" : "") : "xs y+" (LLK_IsBetween(index, 5, 6) ? settings.general.fWidth / 5 : -1), columns := index0
			Gui, RGB_palette: Add, Text, % style " Center 0x200 BackgroundTrans HWNDhwnd_" val " w" settings.general.fWidth * 2 " h" settings.general.fWidth * 2 " c" (index >= 5 ? "Black" : "White"), % (RGB = val) ? "X" : ""
			If (RGB = val)
				marked := val
			Gui, RGB_palette: Add, Progress, % "xp yp Disabled Background646464 c" val " w" settings.general.fWidth * 2 " h" settings.general.fWidth * 2 " HWNDhwnd", 100
			hwnd_GUI[hwnd] := """" val """"
		}

	For index, val in RGB_Convert(RGB)
	{
		letter := (index = 1 ? "R" : (index = 2 ? "G" : "B"))
		Gui, RGB_palette: Add, Text, % "Section Border Center " (index = 1 ? "x" settings.general.fWidth " y+-1" : "xs y+-1") " w" settings.general.fWidth*3, % letter
		Gui, RGB_palette: Add, Slider, % "ys x+-1 hp Border Range0-255 Tooltip gRGB_Picker HWNDhwnd_" letter " w" settings.general.fWidth*20 - 9, % val
		Gui, RGB_palette: Font, % "s" settings.general.fSize - 4
		Gui, RGB_palette: Add, Edit, % "ys Number Right Limit3 x+-1 hp cBlack gRGB_Picker HWNDhwnd_edit_" letter " w" settings.general.fWidth*3 - 1, % val
		Gui, RGB_palette: Font, % "s" settings.general.fSize
	}
	Gui, RGB_palette: Add, Progress, % "Disabled xs y+-1 Section hp HWNDhwnd_final Background646464 c" (Blank(RGB) ? "000000" : RGB) " w" settings.general.fWidth*3, 100
	Gui, RGB_palette: Add, Text, % "ys x+-1 Border HWNDhwnd_save 0x200", % " " Lang_Trans("global_apply") " "

	Gui, RGB_palette: Show, % "NA x10000 y10000"
	WinGetPos,,, w, h, ahk_id %hwnd_palette%
	xPos := vars.general.xMouse - (vars.general.xMouse - vars.monitor.x + w >= vars.monitor.w ? w - settings.general.fWidth : settings.general.fWidth)
	yPos := vars.general.yMouse - (vars.general.yMouse - vars.monitor.y + h >= vars.monitor.h ? h - settings.general.fWidth : settings.general.fWidth)

	ControlFocus,, ahk_id %hwnd_save%
	Gui, RGB_palette: Show, % "x" xPos " y" yPos
	While (vars.general.wMouse != hwnd_palette) && !timeout
	{
		If !start
			start := A_TickCount
		If (A_TickCount >= start + 1000) && (vars.general.wMouse != hwnd_palette)
			timeout := 1
		Sleep 10
	}
	While Blank(picked_rgb) && (vars.general.wMouse = hwnd_palette) && !vars.RGB_picker.cancel
	{
		KeyWait, LButton, D T0.1
		If !ErrorLevel && hwnd_GUI.HasKey(vars.general.cMouse)
			hover_last := vars.general.cMouse, rgb := StrReplace(hwnd_GUI[hover_last], """")
		Else If !ErrorLevel && (vars.general.cMouse = hwnd_save)
			picked_rgb := current_rgb
		Else
		{
			current_rgb := ""
			Loop, Parse, % "rgb"
				current_rgb .= Format("{:02X}", LLK_ControlGet(hwnd_%A_LoopField%))
			GuiControl, +c%current_rgb%, % hwnd_final
			If (current_rgb != marked)
				GuiControl, Text, % hwnd_%marked%, % ""
			If (hwnd_%current_rgb%)
			{
				GuiControl, Text, % hwnd_%current_rgb%, % "X"
				marked := current_rgb
			}
			Sleep 10
			Continue
		}
		KeyWait, LButton
		If (rgb != rgb_last)
		{
			rgb_last := rgb, sliders := RGB_Convert(rgb)
			For index, val in ["r", "g", "b"]
			{
				GuiControl,, % hwnd_%val%, % sliders[index]
				GuiControl,, % hwnd_edit_%val%, % sliders[index]
				GuiControl, Text, % hwnd_%marked%, % ""
				GuiControl, Text, % hwnd_%rgb%, % "X"
				marked := rgb
			}
		}
	}
	KeyWait, LButton
	Gui, RGB_palette: Destroy
	vars.Delete("RGB_picker")
	Return picked_rgb
}

ToolTip_Mouse(mode := "", timeout := 0)
{
	local
	global vars, settings
	static name, start

	If mode
	{
		If (mode = "reset")
			name := "", start := ""
		Else
		{
			vars.tooltip_mouse := {"name": mode, "timeout": timeout}
			SetTimer, ToolTip_Mouse, 10
		}
		Return
	}

	Switch vars.tooltip_mouse.name
	{
		Case "chromatics":
			text := Lang_Trans("omnikey_chromes") . "`n" . Lang_Trans("omnikey_escape")
			If GetKeyState("Space", "P") ;GetKeyState("Ctrl", "P") && GetKeyState("v", "P")
			{
				SetTimer, ToolTip_Mouse, Delete
				KeyWait, Space
				Sleep, 100
				SendInput, % "^{a}{BS}" vars.omnikey.item.sockets "{TAB}" vars.omnikey.item.str "{TAB}" vars.omnikey.item.dex "{TAB}" vars.omnikey.item.int "{TAB}{TAB}"
				vars.tooltip_mouse := ""
			}
		Case "cluster":
			text := Lang_Trans("omnikey_clustersearch") . "`n" . Lang_Trans("omnikey_escape")
			If GetKeyState("Control", "P") && GetKeyState("F", "P")
			{
				SetTimer, ToolTip_Mouse, Delete
				Clipboard := vars.omnikey.item.cluster_enchant
				KeyWait, F
				Sleep, 100
				SendInput, ^{a}^{v}
				Sleep, 100
				vars.tooltip_mouse := ""
			}
		Case "searchstring":
			text := Lang_Trans("omnikey_scroll") . " " . (InStr(vars.searchstrings.clipboard, ";") ? "" : vars.searchstrings.active.3 "/" vars.searchstrings.active.4) . "`n" . Lang_Trans("omnikey_escape")
		Case "killtracker":
			text := Lang_Trans("maptracker_kills")
		Case "lab":
			text := "-> " . Lang_Trans("omnikey_labimport") . "`n-> " . Lang_Trans("omnikey_labimport", 2) . "`n-> " . Lang_Trans("omnikey_labimport", 3) . "`n-> " . Lang_Trans("omnikey_labimport", 4) . "`n-> " . Lang_Trans("omnikey_labimport", 5) . "`n-> " Lang_Trans("omnikey_labimport", 6) . "`n" . Lang_Trans("omnikey_escape")
	}

	If vars.tooltip_mouse.timeout && WinActive("ahk_group poe_window") && IsNumber(start) && (A_TickCount >= start + 1000) || GetKeyState("ESC", "P") && (name != "killtracker") || !vars.tooltip_mouse
	{
		Gui, tooltip_mouse: Destroy
		vars.hwnd.Delete("tooltip_mouse"), name := "", start := "", vars.tooltip_mouse := ""
		SetTimer, ToolTip_Mouse, Delete
		Return
	}

	If vars.hwnd.tooltip_mouse.main && !WinExist("ahk_id " vars.hwnd.tooltip_mouse.main) || (name != vars.tooltip_mouse.name)
	{
		start := A_TickCount
		Gui, tooltip_mouse: New, % "-DPIScale +E0x20 +LastFound +AlwaysOnTop +ToolWindow -Caption +Border HWNDhwnd +E0x02000000 +E0x00080000"
		Gui, tooltip_mouse: Color, Black
		Gui, tooltip_mouse: Margin, % settings.general.fwidth / 2, 0
		WinSet, Transparent, 255
		Gui, tooltip_mouse: Font, % "s"settings.general.fSize " cWhite", % vars.system.font
		Gui, tooltip_mouse: Add, Text, % "HWNDhwnd1"(vars.tooltip_mouse.name = "searchstring" ? " w"settings.general.fWidth*14 : ""), % text
		vars.hwnd.tooltip_mouse := {"main": hwnd, "text": hwnd1}
	}

	name := vars.tooltip_mouse.name
	MouseGetPos, xPos, yPos
	Gui, tooltip_mouse: Show, % "NA x"xPos + settings.general.fWidth*3 " y"yPos
}
