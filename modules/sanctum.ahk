Init_sanctum()
{
	local
	global vars, settings, JSON

	If !FileExist("ini" vars.poe_version "\sanctum.ini")
		IniWrite, % "", % "ini" vars.poe_version "\sanctum.ini", settings

	If !IsObject(vars.sanctum)
	{
		vars.sanctum := {"pixels": {}, "targets": {}, "avoid": {}, "avoids": {}, "blocks": {}, "info": {}, "rooms": [{}, {}, {}, {}]}
		If !vars.poe_version
			For outer in [1, 2, 3, 4]
				For inner in [1, 2, 3, 4, 5]
					vars.sanctum.rooms[outer][Lang_Trans("sanctum_rooms_" inner "_" outer) ":`n" Lang_Trans("sanctum_rooms_" inner)] := 1

		If !vars.poe_version
			For key, array in vars.lang
				If (key = "sanctum_info")
					For index, val in array
						vars.sanctum.info[val] := 1
	}

	If !IsObject(settings.sanctum)
		settings.sanctum := {}

	ini := IniBatchRead("ini" vars.poe_version "\sanctum.ini")
	settings.sanctum.fSize := !Blank(check := ini.settings["font-size"]) ? check : settings.general.fSize
	LLK_FontDimensions(settings.sanctum.fSize, fHeight, fWidth), settings.sanctum.fWidth := fWidth, settings.sanctum.fHeight := fHeight
	settings.sanctum.relics := !Blank(check := ini.settings["enable relic management"]) ? check : 1
	settings.sanctum.cheatsheet := !Blank(check := ini.settings["enable cheat-sheet"]) ? check : 0
	settings.sanctum.gridspacing := Round(vars.client.h/240)

	vars.sanctum.pixels.path := !Blank(check := ini.data["pixels path"]) ? json.load(check) : {}
	vars.sanctum.pixels.room := !Blank(check := ini.data["pixels room"]) ? json.load(check) : {}
	vars.sanctum.floor := !Blank(check := ini.data.floor) ? check : 0
	If InStr(ini.data["grid snapshot"], "exit") && (SubStr(ini.data["grid snapshot"], 1, 1) . SubStr(ini.data["grid snapshot"], 0) = "[]")
		vars.sanctum.grid := json.load(ini.data["grid snapshot"])

	h := vars.client.h
	If vars.poe_version
		vars.sanctum.relics := {"search": [], "coords": {"x": h * (2/15), "x2": -h * (29/60), "y": h * 0.3, "xGrid": h * 0.055, "yGrid": h * 0.055, "wGrid": h * 0.045, "xConfirm": h * 0.1125, "wConfirm": h * 0.125, "yConfirm": h * 0.2708, "hConfirm": h * 0.0375}}
	Else vars.sanctum.relics := {"search": [], "coords": {"x": h * (2/15), "x2": -h * (29/60), "y": h * 0.31, "xGrid": h * 0.055, "yGrid": h * 0.055, "wGrid": h * 0.045, "xConfirm": h * 0.1125, "wConfirm": h * 0.125, "yConfirm": h * 0.2708, "hConfirm": h * 0.0375}}

	If !Blank(relic_grid := ini.data["relic grid"]) && (SubStr(relic_grid, 1, 1) . SubStr(relic_grid, 0) = "[]")
		vars.sanctum.relics.grid := json.load(relic_grid), vars.sanctum.relics.grid0 := relic_grid
	Else
	{
		vars.sanctum.relics.grid := []
		Loop 20
			vars.sanctum.relics.grid.Push([])
		vars.sanctum.relics.grid0 := json.dump(vars.sanctum.relics.grid)
	}

	If !vars.poe_version
	{
		wSnip := vars.sanctum.wSnip := Round(vars.client.h * 0.8), hSnip := vars.sanctum.hSnip := Round(vars.client.h * (5/9))
		vars.sanctum.xSnip := Round(vars.client.w//2 - wSnip/2), vars.sanctum.ySnip := Round(vars.client.h * (7/45))
		vars.sanctum.wBox := Round(hSnip * 0.11), vars.sanctum.hBox := Round(hSnip * 0.14)
		vars.sanctum.radius := Round(hSnip/40), vars.sanctum.radius2 := Round(vars.sanctum.radius * 0.65), vars.sanctum.gap := Round(hSnip * 0.035)
		vars.sanctum.relics.items := {"censer relic": [1, 2], "urn relic": [2, 1], "processional relic": [1, 3], "tome relic": [3, 1], "candlestick relic": [1, 4], "coffer relic": [2, 2], "papyrus relic": [4, 1]}
	}
	Else
	{
		wSnip := vars.sanctum.wSnip := Round(vars.client.h * (5/6)), hSnip := vars.sanctum.hSnip := Round(vars.client.h * 0.5)
		vars.sanctum.xSnip := Round(vars.client.w//2 - wSnip/2), vars.sanctum.ySnip := Round(vars.client.h * (5/24))
		vars.sanctum.wBox := vars.sanctum.hBox :=  Round(vars.client.h * (1/15))
		vars.sanctum.radius := vars.sanctum.radius2 := Round(hSnip/40), vars.sanctum.gap := Round(hSnip/24)
		vars.sanctum.relics.items := {"urn relic": [1, 2], "seal relic": [2, 1], "amphora relic": [1, 3], "tapestry relic": [3, 1], "vase relic": [1, 4], "coffer relic": [2, 2], "incense relic": [4, 1]}
	}
	vars.sanctum.columns := [], vars.sanctum.rows := [], vars.sanctum.column1 := []

	For index, val in (!vars.poe_version ? [0, 0.188, 0.37875, 0.57125, 0.76125, 0.9525, 1.144] : [0, 0.2333, 0.4466, 0.66, 0.8733, 1.0866, 1.3])
		vars.sanctum.columns.Push(Floor(hSnip * val))
	For index, val in (!vars.poe_version ? [0, 0.09, 0.175, 0.26, 0.345, 0.43, 0.517, 0.6, 0.687, 0.77, 0.86] : [1/60, 0.1, 11/60, 16/60, 21/60, 26/60, 31/60, 36/60, 41/60, 46/60, 51/60])
		vars.sanctum.rows.Push(Floor(hSnip * val))
	For index, val in (!vars.poe_version ? [0.225, 0.43, 0.64] : [5/24, 0.42, 19/30])
		vars.sanctum.column1.Push(Floor(hSnip * val))
}

Sanctum(cHWND := "", hotkey := 0)
{
	local
	global vars, settings
	static toggle := 0, dimensions := [], floors

	If vars.sanctum.scanning
		Return

	If !floors
		floors := !vars.poe_version ? ["cellar", "vaults", "nave", "crypt"] : ["sanctum_1", "sanctum_2", "sanctum_3", "sanctum_4"]

	If (cHWND = "close")
	{
		GuiControl, +Hidden, % vars.hwnd.sanctum.scan
		GuiControl, +Hidden, % vars.hwnd.sanctum.scan2
		GuiControl, +Hidden, % vars.hwnd.sanctum.cal_room
		GuiControl, +Hidden, % vars.hwnd.sanctum.cal_room2
		GuiControl, +Hidden, % vars.hwnd.sanctum.cal_path
		GuiControl, +Hidden, % vars.hwnd.sanctum.cal_path2
		Sleep 50
		LLK_Overlay(vars.hwnd.sanctum.main, "hide"), LLK_Overlay(vars.hwnd.sanctum.second, "hide"), vars.sanctum.active := 0
		Return
	}
	Else If (cHWND = "lock")
	{
		vars.sanctum.lock := 1
		GuiControl, -Hidden, % vars.hwnd.sanctum.cal_room
		GuiControl, -Hidden, % vars.hwnd.sanctum.cal_room2
		GuiControl, -Hidden, % vars.hwnd.sanctum.cal_path
		GuiControl, -Hidden, % vars.hwnd.sanctum.cal_path2

		If (vars.sanctum.pixels.path.Count() * vars.sanctum.pixels.room.Count())
		{
			GuiControl, -Hidden, % vars.hwnd.sanctum.scan
			GuiControl, -Hidden, % vars.hwnd.sanctum.scan2
		}
		Else
		{
			GuiControl, +Hidden, % vars.hwnd.sanctum.scan
			GuiControl, +Hidden, % vars.hwnd.sanctum.scan2
		}
		KeyWait, Space
		Return
	}
	Else If (cHWND = "trans")
	{
		WinSet, TransColor, Purple 1, % "ahk_id " vars.hwnd.sanctum.main
		KeyWait, LALT
		WinSet, TransColor, Purple 125, % "ahk_id " vars.hwnd.sanctum.main
		Return
	}

	If !Blank(cHWND)
	{
		check := LLK_HasVal(vars.hwnd.sanctum, cHWND), control := SubStr(check, InStr(check, "_") + 1)

		If (check = "scan")
		{
			If (vars.system.click = 1)
				error := !Sanctum_Scan()
			Else
			{
				If FileExist("img\sanctum scan" vars.poe_version ".jpg")
				{
					GuiControl, -Hidden, % vars.hwnd.sanctum.scanned_img
					KeyWait, RButton
					GuiControl, +Hidden, % vars.hwnd.sanctum.scanned_img
				}
				Else KeyWait, RButton
				Return
			}
		}
		Else If InStr(check, "cal_")
		{
			If (vars.system.click = 1)
				Sanctum_Calibrate(control)
			Else If LLK_Progress(vars.hwnd.sanctum["cal_" control "2"], "RButton")
			{
				vars.sanctum.pixels[control] := {}
				IniDelete, % "ini" vars.poe_version "\sanctum.ini", data, % "pixels " control
				GuiControl, +BackgroundMaroon, % vars.hwnd.sanctum["cal_" control "2"]
			}
			Sanctum("lock")
			Return
		}
		Else
		{
			LLK_ToolTip("no action")
			Return
		}
	}
	floor := vars.sanctum.floor, correct_floor := (InStr(vars.log.areaID, floors[floor]) || !vars.poe_version && InStr(vars.log.areaID, "foyer_" floor))

	If Blank(cHWND) && vars.hwnd.sanctum.uptodate
	{
		If floor && correct_floor
			LLK_Overlay(vars.hwnd.sanctum.main, "show")
		Else GuiControl, +BackgroundMaroon, % vars.hwnd.sanctum.scan2
		LLK_Overlay(vars.hwnd.sanctum.second, "show"), vars.sanctum.active := 1
		Return
	}

	toggle := !toggle, GUI_name := "sanctum" toggle, GUI_name2 := "sanctum2" toggle
	wSnip := vars.sanctum.wSnip, hSnip := vars.sanctum.hSnip
	wBox := vars.sanctum.wBox, hBox := vars.sanctum.hBox
	xSnip := vars.sanctum.xSnip, ySnip := vars.sanctum.ySnip
	grid := vars.sanctum.grid

	Gui, %GUI_name%: New, % "-Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDhwnd_sanctum", LLK-UI: Sanctum Overlay
	Gui, %GUI_name%: Font, % "s" settings.sanctum.fSize + 4 " cBlack w1000", % vars.system.font
	Gui, %GUI_name%: Color, Purple
	WinSet, TransColor, Purple 125
	Gui, %GUI_name%: Margin, 0, 0
	hwnd_old := vars.hwnd.sanctum.main, hwnd_old2 := vars.hwnd.sanctum.second, vars.hwnd.sanctum := {"main": hwnd_sanctum, "GUI_name": GUI_name}, vars.sanctum.lock := 0

	If correct_floor
		For iColumn, vColumn in grid
		{
			For iRoom, vRoom in vColumn
			{
				color := vars.sanctum.avoids[iColumn . iRoom] ? "Fuchsia" : vars.sanctum.targets[iColumn . iRoom] ? "Lime" : "White"
				Gui, %GUI_name%: Add, Text, % "BackgroundTrans HWNDhwnd Center x" vRoom.x " y" vRoom.y " w" wBox " h" hBox, % Sanctum_Connections(iColumn, iRoom, 1)
				Gui, %GUI_name%: Add, Progress, % "xp yp wp hp Disabled HWNDhwnd2 BackgroundBlack c" color, 100
				vars.hwnd.sanctum["room_" iColumn . iRoom] := hwnd, vars.hwnd.sanctum["room_" iColumn . iRoom "|"] := hwnd2
			}
		}

	Gui, %GUI_name%: Show, % "NA x" vars.client.x + xSnip " y" vars.client.y + ySnip
	LLK_Overlay(hwnd_sanctum, "show", 1, GUI_name), LLK_Overlay(hwnd_old, "destroy")

	Gui, %GUI_name2%: New, % "-Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDhwnd_sanctum2"
	Gui, %GUI_name2%: Font, % "s" settings.sanctum.fSize " cWhite", % vars.system.font
	Gui, %GUI_name2%: Color, Purple
	WinSet, TransColor, Purple
	Gui, %GUI_name2%: Margin, 0, 0
	vars.hwnd.sanctum.second := hwnd_sanctum2, vars.hwnd.sanctum.GUI_name2 := GUI_name2

	Gui, %GUI_name2%: Add, Text, % "Section x" xSnip " y" ySnip " Border BackgroundTrans w" wSnip " h" hSnip
	If FileExist("img\sanctum scan" vars.poe_version ".jpg")
	{
		Gui, %GUI_name2%: Add, Pic, % "xp yp wp hp Hidden HWNDhwnd", % "img\sanctum scan" vars.poe_version ".jpg"
		vars.hwnd.sanctum.scanned_img := hwnd
	}
	Gui, %GUI_name2%: Add, Pic, % "xp yp h" settings.general.fHeight " w-1 Border BackgroundTrans", % "HBitmap:*" vars.pics.global.help
	Gui, %GUI_name2%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd BackgroundBlack", 0
	vars.hwnd.help_tooltips["sanctum_general"] := hwnd

	LLK_PanelDimensions([Lang_Trans("global_scan", 2), Lang_Trans("sanctum_calibrate"), Lang_Trans("sanctum_calibrate", 2)], settings.sanctum.fSize, wButtons, hButtons)
	For index, val in [Lang_Trans("global_scan", 2), Lang_Trans("sanctum_calibrate"), Lang_Trans("sanctum_calibrate", 2)]
	{
		style := (index = 1) ? "Section x" xSnip - wButtons + 1 " y" ySnip : "xs y+-1", style .= !InStr(val, "`n") ? " 0x200" : ""
		Gui, %GUI_name2%: Add, Text, % style " Border BackgroundTrans Center gSanctum w" wButtons " h" hButtons " HWNDhwnd" index . (check != "scan" ? " Hidden" : ""), % " " StrReplace(val, "`n", " `n ") " "
		color := (index = 1 && (!grid.Count() || !correct_floor)) || (index = 2 && !vars.sanctum.pixels.path.Count()) || (index = 3 && !vars.sanctum.pixels.room.Count()) ? "Maroon" : "Black"
		style := (index = 1) ? " Range0-7 cGreen" : " Range0-500 Vertical cRed"
		Gui, %GUI_name2%: Add, Progress, % "xp yp wp hp Disabled Background" color " HWNDhwnd" index "2" style . (check != "scan" ? " Hidden" : ""), 0
	}
	vars.hwnd.sanctum.scan := hwnd1, vars.hwnd.sanctum.scan2 := vars.hwnd.help_tooltips["sanctum_scan"] := hwnd12
	vars.hwnd.sanctum.cal_path := hwnd2, vars.hwnd.sanctum.cal_path2 := vars.hwnd.help_tooltips["sanctum_calibrate paths"] := hwnd22
	vars.hwnd.sanctum.cal_room := hwnd3, vars.hwnd.sanctum.cal_room2 := vars.hwnd.help_tooltips["sanctum_calibrate rooms"] := hwnd32

	If settings.sanctum.cheatsheet && floor && correct_floor
	{
		For key in vars.sanctum.rooms[floor]
			Gui, %GUI_name2%: Add, Text, % (A_Index = 1 ? "Section x0 y0" : "ys x+-1") " Border Hidden HWNDhwnd Center BackgroundTrans", % " " StrReplace(key, "`n", " `n ") " "
		ControlGetPos, xControl, yControl, wControl, hControl,, ahk_id %hwnd%
		wCheatsheet := xControl + wControl

		For key in vars.sanctum.rooms[floor]
		{
			style := (A_Index = 1) ? "Section x" xSnip + (wSnip - wCheatsheet)//2 " y" ySnip + hSnip - 1 : "ys x+-1"
			Gui, %GUI_name2%: Add, Text, % style " Border HWNDhnwd Center BackgroundTrans", % " " StrReplace(key, "`n", " `n ") " "
			Gui, %GUI_name2%: Add, Progress, % "xp yp wp hp Disabled Background202040", 0
		}
		ControlGetPos, xLast, yLast, wLast, hLast,, ahk_id %hwnd%

		For key in vars.sanctum.info
			Gui, %GUI_name2%: Add, Text, % (A_Index = 1 ? "Section x0 y0" : "ys x+-1") " Border Hidden HWNDhwnd Center BackgroundTrans", % " " StrReplace(key, "`n", " `n ") " "
		ControlGetPos, xControl, yControl, wControl, hControl,, ahk_id %hwnd%
		wCheatsheet := xControl + wControl

		For key in vars.sanctum.info
		{
			style := (A_Index = 1) ? "Section x" xSnip + (wSnip - wCheatsheet)//2 " y" ySnip + hSnip + hLast - 2 : "ys x+-1"
			Gui, %GUI_name2%: Add, Text, % style " Border Center BackgroundTrans", % " " StrReplace(key, "`n", " `n ") " "
			Gui, %GUI_name2%: Add, Progress, % "xp yp wp hp Disabled Background202040", 0
		}
	}

	Gui, %GUI_name2%: Show, % "NA x" vars.client.x " y" vars.client.y
	LLK_Overlay(vars.hwnd.sanctum.second, "show", 1, GUI_name2), LLK_Overlay(hwnd_old2, "destroy")
	If error
		LLK_ToolTip(Lang_Trans("global_fail"), 1,,,, "Red")
	vars.sanctum.active := 1, vars.hwnd.sanctum.uptodate := 1
}

Sanctum_Calibrate(mode)
{
	local
	global vars, settings, JSON

	pSnip := SnippingTool(), pixels := {}
	If (pSnip <= 0)
		Return
	Gdip_GetImageDimensions(pSnip, wSnip, hSnip)

	Loop, % wSnip
	{
		x_coord := A_Index - 1
		Loop, % hSnip
		{
			y_coord := A_Index - 1
			pixel := Gdip_GetPixelColor(pSnip, x_coord, y_coord, 4)
			If !pixels[pixel]
				pixels[pixel] := 1
			Else pixels[pixel] += 1
		}
	}
	Gdip_DisposeImage(pSnip)
	For color, count in pixels
		pixel_count .= (!pixel_count ? "" : "`n") count " x " color
	Sort, pixel_count, D`n N R
	Loop, Parse, pixel_count, `n, % " `r"
		If (mode = "path") || (mode = "room" && A_Index < 11)
			vars.sanctum.pixels[mode][SubStr(A_LoopField, InStr(A_LoopField, " x ") + 3)] := 1

	If vars.sanctum.pixels[mode].Count()
	{
		IniWrite, % """" json.dump(vars.sanctum.pixels[mode]) """", % "ini" vars.poe_version "\sanctum.ini", data, % "pixels " mode
		GuiControl, +BackgroundBlack, % vars.hwnd.sanctum["cal_" mode "2"]
	}
}

Sanctum_Connections(column, row, main := 0)
{
	local
	global vars, settings

	For exit in vars.sanctum.grid[column][row].exits
		If !vars.sanctum.avoids[exit]
			connections .= " " Sanctum_Connections(SubStr(exit, 1, 1), SubStr(exit, 2)), connections1 .= " " exit

	If main
	{
		connections .= " " connections1, connections1 := {}
		Loop, Parse, connections, %A_Space%, %A_Space%
			If A_LoopField
				connections1[A_LoopField] := 1
		Return connections1.Count()
	}
	Return connections . connections1
}

Sanctum_Mark(room, mode, hold := 0)
{
	local
	global vars, settings

	room := StrReplace(room, "|"), column := SubStr(room, 1, 1), row := SubStr(room, 2)
	grid := vars.sanctum.grid

	If (mode = 1) && (vars.sanctum.avoids[room] || vars.sanctum.blocks[room] || room = vars.sanctum.current)
	|| (mode = 2) && !vars.sanctum.avoid[room] && (InStr(vars.sanctum.target "," vars.sanctum.current, room) || vars.sanctum.blocks[room])
	|| (mode = 3) && (vars.sanctum.avoids[room])
	; block clicks on purple/black rooms, block right-clicks on primary green room
		Return

	If (mode = 1)
		vars.sanctum.target := (vars.sanctum.target = room) ? "" : room, vars.sanctum.targets := {}
	Else If (mode = 2)
		vars.sanctum.avoid[room] := !vars.sanctum.avoid[room], vars.sanctum.avoids := {}, vars.sanctum.targets := {}, vars.sanctum.blocks := {}
	Else vars.sanctum.current := (vars.sanctum.current = room) ? "" : room, vars.sanctum.blocks := {}

	Loop 7 ; banned rooms based on primary purple room(s)
	{
		column := 8 - A_Index
		For iRoom, vRoom in grid[column]
		{
			check := vRoom.exits.Count()
			For exit in vRoom.exits
				check -= vars.sanctum.avoids[exit] ? 1 : 0
			If !check || vars.sanctum.avoid[column . iRoom]
				vars.sanctum.avoids[column . iRoom] := 1
		}
	}

	Loop 7 ; inaccessible rooms behind (already passed) and ahead (resulting from bans)
	{
		column := A_Index
		For iRoom, vRoom in grid[column]
		{
			check := Max(1, vRoom.entries.Count())
			If grid[column - 1].Count()
				For entrance in vRoom.entries
					check -= vars.sanctum.avoids[entrance] || vars.sanctum.blocks[entrance] ? 1 : 0
			If (vars.sanctum.current != column . iRoom) && (!check || vars.sanctum.current && (column <= SubStr(vars.sanctum.current, 1, 1)))
				vars.sanctum.blocks[column . iRoom] := 1
		}
	}

	Loop 7 ; green path from primary green room
	{
		column := 8 - A_Index
		For iRoom, vRoom in grid[column]
		{
			If vars.sanctum.current && (column = SubStr(vars.sanctum.current, 1, 1))
				Break
			check := 0, check1 := Max(1, vRoom.entries.Count())
			For entrance in vRoom.entries
				check1 -= vars.sanctum.avoids[entrance] || vars.sanctum.blocks[entrance] ? 1 : 0
			For exit in vRoom.exits
				If !vars.sanctum.avoids[exit]
					check += vars.sanctum.targets[exit] ? 1 : 0
			If check1 && check || (vars.sanctum.target = column . iRoom)
				vars.sanctum.targets[column . iRoom] := 1
		}
	}

	For iColumn, vColumn in grid ; apply new colors to rooms
		For iRoom, vRoom in vColumn
		{
			If vars.sanctum.blocks[iColumn . iRoom]
				GuiControl, % "+cBlack +Background" (vars.sanctum.avoid[iColumn . iRoom] ? "White" : "Black"), % vars.hwnd.sanctum["room_" iColumn . iRoom "|"]
			Else If vars.sanctum.avoids[iColumn . iRoom]
				GuiControl, % "+cFuchsia +Background" (vars.sanctum.avoid[iColumn . iRoom] ? "White" : "Black"), % vars.hwnd.sanctum["room_" iColumn . iRoom "|"]
			Else If (vars.sanctum.current = iColumn . iRoom)
				GuiControl, % "+cYellow +BackgroundBlack", % vars.hwnd.sanctum["room_" iColumn . iRoom "|"]
			Else If vars.sanctum.targets[iColumn . iRoom]
				GuiControl, % "+cLime +Background" (vars.sanctum.target = iColumn . iRoom ? "White" : "Black"), % vars.hwnd.sanctum["room_" iColumn . iRoom "|"]
			Else GuiControl, +cWhite +BackgroundBlack, % vars.hwnd.sanctum["room_" iColumn . iRoom "|"]

			If (mode != 1) ; recalculate number of connections
				GuiControl, Text, % vars.hwnd.sanctum["room_" iColumn . iRoom], % vars.sanctum.avoids[iColumn . iRoom] || vars.sanctum.blocks[iColumn . iRoom] ? "" : Sanctum_Connections(iColumn, iRoom, 1)
		}
	Sleep, 250
	While (mode = 3) && hold && GetKeyState("MButton", "P")
	{
		If (vars.general.wMouse = vars.hwnd.sanctum.main) && vars.general.cMouse && (check := LLK_HasVal(vars.hwnd.sanctum, vars.general.cMouse))
		&& ((check := StrReplace(SubStr(check, InStr(check, "_") + 1), "|")) != vars.sanctum.current)
			Sanctum_Mark(check, 3)
		Sleep 100
	}
}

Sanctum_Relics(cHWND := "")
{
	local
	global vars, settings, db, json
	static toggle := 0

	If (cHWND = "trans")
	{
		For control, hwnd in vars.hwnd.sanctum_relics
			If InStr(control, "cell_")
			{
				GuiControl, +Hidden, % hwnd
				GuiControl, movedraw, % hwnd
			}
		KeyWait, SC038
		For control, hwnd in vars.hwnd.sanctum_relics
			If InStr(control, "cell_")
			{
				GuiControl, -Hidden, % hwnd
				GuiControl, movedraw, % hwnd
			}
		Return
	}
	Else If (cHWND = "close")
	{
		LLK_Overlay(vars.hwnd.sanctum_relics.main, "destroy"), vars.hwnd.sanctum_relics.main := ""
		If ((check := json.dump(vars.sanctum.relics.grid)) != vars.sanctum.relics.grid0)
			IniWrite, % (vars.sanctum.relics.grid0 := check), % "ini" vars.poe_version "\sanctum.ini", data, relic grid
		Return
	}
	Else If cHWND
	{
		check := LLK_HasVal(vars.hwnd.sanctum_relics, (cHWND = "click") ? vars.general.cMouse : cHWND), control := SubStr(check, InStr(check, "_") + 1)
		If (cHWND = "click") && !RegExMatch(check, "i)(mod_|clear)")
			Return
		If (InStr(check, "mod_"))
		{
			KeyWait, LButton
			KeyWait, RButton
			If InStr(A_ThisHotkey, "L")
			{
				If (check1 := LLK_HasVal(vars.sanctum.relics.search, control))
					vars.sanctum.relics.search.RemoveAt(check1)
				Else If (vars.sanctum.relics.search.Count() = 2)
					vars.sanctum.relics.search.RemoveAt(1), vars.sanctum.relics.search.Push(control)
				Else vars.sanctum.relics.search.Push(control)
			}
			Else
			{
				If vars.sanctum.relics.inventory
					Return
				WinActivate, % "ahk_id " vars.hwnd.poe_client
				WinWaitActive, % "ahk_id " vars.hwnd.poe_client
				regex := Trim(StrReplace(control, "#", ".*"), " +%")
				Clipboard := Trim(StrReplace(regex, " ", "."), " .*")
				SendInput, ^{f}
				Sleep 100
				SendInput, {DEL}^{v}{Enter}
				Return
			}
		}
		Else If (check = "clear")
		{
			If LLK_Progress(vars.hwnd.sanctum_relics.clear_bar, "LButton")
			{
				vars.sanctum.relics.grid := [], vars.sanctum.relics.search := []
				Loop 20
					vars.sanctum.relics.grid.Push([])
				vars.sanctum.relics.grid0 := json.dump(vars.sanctum.relics.grid)
				IniDelete, % "ini" vars.poe_version "\sanctum.ini", data, relic grid
			}
			Else Return
		}
		Else
		{
			LLK_ToolTip("no action")
			Return
		}
	}

	If !IsObject(db.relics)
		DB_Load("relics")

	toggle := !toggle, GUI_name := "sanctum_relics" toggle
	coords := vars.sanctum.relics.coords, spacing := settings.sanctum.gridspacing, grid := vars.sanctum.relics.grid, items := vars.sanctum.relics.items, fWidth := settings.sanctum.fWidth
	search := vars.sanctum.relics.search, inventory := vars.sanctum.relics.inventory := vars.pixels.inventory

	Gui, %GUI_name%: New, % "-Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDhwnd_relics", LLK-UI: relic manager
	Gui, %GUI_name%: Font, % "cWhite s" settings.sanctum.fSize, % vars.system.font
	Gui, %GUI_name%: Color, Purple
	WinSet, TransColor, Purple
	Gui, %GUI_name%: Margin, 0, 0
	hwnd_old := vars.hwnd.sanctum_relics.main, vars.hwnd.sanctum_relics := {"main": hwnd_relics, "GUI_name": GUI_name}

	mods := {}, cell_mods := []
	For index, val in grid
	{
		For iCell, vCell in val
		{
			If (iCell = 1)
				relic := vCell
			Else
			{
				value := ""
				Loop, Parse, vCell
					If IsNumber(A_LoopField)
						value .= A_LoopField
					Else If value && !IsNumber(A_LoopField)
						Break

				value := !value ? 1 : value
				mod := LLK_StringCase(StrReplace(StrReplace(vCell, "an additional", "# additional"), value, "#"))
				mods[mod] := mods[mod] ? mods[mod] + value : value
				If !IsObject(cell_mods[index])
					cell_mods[index] := []
				cell_mods[index].Push(mod)
			}
		}
		If !val.Count()
			Continue
		row := 1, cell := index, search_check := 0
		While (cell > 5)
			cell -= 5, row += 1
		x := coords.xGrid + (cell - 1) * (coords.wGrid + spacing)
		y := coords.yGrid + (row - 1) * (coords.wGrid + spacing)

		For iSearch, vSearch in search
			If LLK_HasVal(cell_mods[index], vSearch)
				search_check += 1

		Gui, %GUI_name%: Add, Progress, % "Disabled HWNDhwnd x" x + 3 " y" y + 3 " w" items[relic].1 * coords.wGrid + (items[relic].1 - 1) * spacing - 6
		. " h" items[relic].2 * coords.wGrid + (items[relic].2 - 1) * spacing - 6 " BackgroundPurple", 0
		Gui, %GUI_name%: Add, Progress, % "Disabled xp-3 yp-3 wp+6 hp+6 HWNDhwnd2 Background" (search_check = 2 ? "Fuchsia" : (search_check ? "Lime" : "White")), 0
		vars.hwnd.sanctum_relics["cell_" index] := hwnd, vars.hwnd.sanctum_relics["cell_" index "_2"] := hwnd2
	}
	Gui, %GUI_name%: Add, Text, % "Section BackgroundTrans Border HWNDhwnd x" coords.xGrid - 1 " y" coords.yGrid - 1 " w" (width := coords.wGrid * 5 + 4 * spacing) + 2 " h" (height := coords.wGrid * 4 + 3 * spacing) + 2
	Gui, %GUI_name%: Add, Text, % "Section BackgroundTrans Border HWNDhwnd2 x" coords.xGrid - 2 " y" coords.yGrid - 2 " w" (width := coords.wGrid * 5 + 4 * spacing) + 4 " h" (height := coords.wGrid * 4 + 3 * spacing) + 4
	Gui, %GUI_name%: Add, Progress, % "Disabled BackgroundPurple xp yp wp hp", 0
	vars.hwnd.sanctum_relics["cell_0"] := hwnd, vars.hwnd.sanctum_relics["cell_00"] := hwnd2

	Gui, %GUI_name%: Add, Pic, % "xp y+-1 Border BackgroundTrans h" settings.general.fHeight " w-1", % "HBitmap:*" vars.pics.global.help
	Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd BackgroundBlack", 0
	vars.hwnd.help_tooltips["sanctumrelics_general"] := hwnd

	Gui, %GUI_name%: Add, Pic, % "x+0 yp hp-2 w-1 Border BackgroundTrans", % "HBitmap:*" vars.pics.global.close
	Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd2 BackgroundBlack Vertical Range0-500 cMaroon", 0
	vars.hwnd.sanctum_relics.clear := vars.hwnd.sanctum_relics.clear_bar := vars.hwnd.help_tooltips["sanctumrelics_clear"] := hwnd2

	base_x := vars.client.x + vars.client.w/2, base_y := vars.client.y + coords.y
	coords.mouse3 := {"x": [base_x + coords[inventory ? "x2" : "x"] + coords.xConfirm, base_x + coords[inventory ? "x2" : "x"] + coords.xConfirm + coords.wConfirm], "y": [base_y + coords.yConfirm, base_y + coords.yConfirm + coords.hConfirm]}

	mods2 := {}, dimensions := []
	For mod, val in mods
	{
		mod2 := db.relics[mod].1
		If Blank(mod2)
			mods2.unknown := !mods2.unknown ? [1] : [mods2.unknown + 1]
		Else mods2[mod2] := [val . (db.relics[mod].2 ? "%" : ""), mod], dimensions.Push(val . (db.relics[mod].2 ? "%" : ""))
	}

	LLK_PanelDimensions(dimensions, settings.sanctum.fSize, wValues, hValues), wText := vars.client.h * 0.35 - 2* fWidth - wValues
	For mod, val in mods2
	{
		Gui, %GUI_name%: Add, Text, % (A_Index = 1 ? "Section x" fWidth + wValues " y" vars.client.h / 3 : "xs y+0") " BackgroundTrans HWNDhwnd w" wText . (LLK_HasVal(search, val.2) ? " cLime" : ""), % mod ;Trim(mod, " %+x")
		If val.2
			vars.hwnd.sanctum_relics["mod_" val.2] := hwnd
		Gui, %GUI_name%: Add, Text, % "xp-" fWidth " yp wp+" 2 * fWidth " hp Border BackgroundTrans"
		Gui, %GUI_name%: Add, Text, % "x0 yp hp 0x200 Border Right BackgroundTrans w" wValues, % val.1 " "
		Gui, %GUI_name%: Add, Progress, % "Disabled xp yp hp BackgroundBlack w" wValues + wText + 2 * fWidth, 0
	}

	If mods2.Count()
	{
		Gui, %GUI_name%: Add, Pic, % "xp y+-1 Border BackgroundTrans h" settings.general.fHeight " w-1", % "HBitmap:*" vars.pics.global.help
		Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd BackgroundBlack", 0
		vars.hwnd.help_tooltips["sanctumrelics_mods"] := hwnd
	}

	coords.mouse := {"x": [base_x + coords[inventory ? "x2" : "x"] + coords.xGrid, base_x + coords[inventory ? "x2" : "x"] + coords.xGrid + width], "y": [base_y + coords.yGrid, base_y + coords.yGrid + height]}
	Gui, %GUI_name%: Show, % "NA x" base_x + coords[inventory ? "x2" : "x"] " y" vars.client.y + coords.y
	LLK_Overlay(hwnd_relics, "show",, GUI_name), LLK_Overlay(hwnd_old, "destroy")
}

Sanctum_RelicsClick()
{
	local
	global vars, settings

	coords := vars.sanctum.relics.coords, w := coords.wGrid, spacing := settings.sanctum.gridspacing, items := vars.sanctum.relics.items, grid := vars.sanctum.relics.grid
	inventory := vars.sanctum.relics.inventory
	For outer in [1, 2, 3, 4]
		For inner in [1, 2, 3, 4, 5]
		{
			cell := ""
			x := vars.client.x + vars.client.w/2 + coords[inventory ? "x2" : "x"] + coords.xGrid + (inner - 1) * (w + spacing), y := vars.client.y + coords.y + coords.yGrid + (outer - 1) * (w + spacing)
			If LLK_IsBetween(vars.general.xMouse, x, x + w) && LLK_IsBetween(vars.general.yMouse, y, y + w)
			{
				cell := (outer - 1) * 5 + inner
				Break 2
			}
		}

	If !cell
		Return

	Clipboard := ""
	If settings.hotkeys.item_descriptions && settings.hotkeys.rebound_alt
		SendInput, % "{" settings.hotkeys.item_descriptions " down}^{c}{" settings.hotkeys.item_descriptions " up}"
	Else SendInput, !^{c}

	ClipWait, 0.1
	If vars.poe_version && !settings.general.dev
		If settings.hotkeys.item_descriptions && settings.hotkeys.rebound_alt
			SendInput, % "{" settings.hotkeys.item_descriptions " up}"
		Else SendInput, {ALT up}

	For key, val in items
		If InStr(Clipboard, key)
		{
			relic := key
			Break
		}

	If !relic
		grid[cell] := ""
	Else
	{
		clip := StrSplit(Clipboard, "{", " "), grid[cell] := []
		grid[cell].Push(relic)

		For index, val in clip
		{
			If !InStr(val, "}")
				Continue
			val := SubStr(val, InStr(val, "}") + 1), val := InStr(val, "---") ? SubStr(val, 1, InStr(val, "---") - 1) : val
			val := Trim(val, " `r`n"), val := Iteminfo_ModRangeRemove(val)
			grid[cell].Push(val)
		}

		If (check := items[relic].1 - 1)
			Loop, % check
				grid[cell + A_Index] := 1
		If (check := items[relic].2 - 1)
			Loop, % check
				grid[cell + A_Index * 5] := 1
		If (items[relic].1 = items[relic].2)
			grid[cell + 6] := 1
	}
	Sanctum_Relics()
}

Sanctum_Scan(mode := "")
{
	local
	global vars, settings, JSON
	static floors := {"cellar": 1, "vaults": 2, "nave": 3, "crypt": 4}
	, colors := ["4294967295", "4294967040", "4278255615", "4294902015", "4286611584", "4278222976", "4294937600", "4287299723", "4286578644", "4294951115", "4280193279"]
	;			white,		yellow,		cyan,		magenta,		gray,	teal,		orange,	dark magenta,	aqua marine,		pink,	dodger blue

	wSnip := vars.sanctum.wSnip, hSnip := vars.sanctum.hSnip
	wBox := vars.sanctum.wBox, hBox := vars.sanctum.hBox
	radius := vars.sanctum.radius, radius2 := vars.sanctum.radius2, gap := vars.sanctum.gap
	columns := vars.sanctum.columns, rows := vars.sanctum.rows, column1 := vars.sanctum.column1
	xSnip := vars.sanctum.xSnip, ySnip := vars.sanctum.ySnip
	vars.sanctum.scanning := 1

	If !InStr(vars.log.areaID, "sanctum") || InStr(vars.log.areaID, "fellshrine")
		Return
	grid := []
	pBitmap := Gdip_BitmapFromHWND(vars.hwnd.poe_client, 1)
	pCrop := Gdip_CloneBitmapArea(pBitmap, settings.general.oGamescreen + xSnip, ySnip, wSnip, hSnip,, 1)
	Gdip_DisposeImage(pBitmap)

	For iColumn, vColumn in columns
	{
		If (iColumn = 1)
		{
			grid.1 := []
			For iRow, vRow in column1
			{
				If !vars.poe_version && (InStr(vars.log.areaID, "sanctumfoyer_1") || InStr(vars.log.areaID, "sanctumcellar")) && InStr("13", iRow)
				|| vars.poe_version && InStr(vars.log.areaID, "sanctum_1") && InStr("13", iRow)
					Continue

				grid.1.Push({"x": vColumn, "y": vRow, "entries": {}, "exits": {}})
				Gdip_SetPixel(pCrop, vColumn + wBox/2, vRow + hBox/2, "4294901760")
				Loop, % wBox//4
					Gdip_SetPixel(pCrop, vColumn + wBox/2 - A_Index, vRow + hBox/2, "4294901760"), Gdip_SetPixel(pCrop, vColumn + wBox/2 + A_Index, vRow + hBox/2, "4294901760")
					, Gdip_SetPixel(pCrop, vColumn + wBox/2, vRow + hBox/2 - A_Index, "4294901760"), Gdip_SetPixel(pCrop, vColumn + wBox/2, vRow + hBox/2 + A_Index, "4294901760")
			}
			Continue
		}
		Else If (iColumn = 2) && vars.poe_version && InStr(vars.log.areaID, "sanctum_1")
		{
			grid.2 := [{"x": vColumn, "y": rows.4, "entries": {"11": 1}, "exits": {}}, {"x": vColumn, "y": rows.6, "entries": {"11": 1}, "exits": {}}, {"x": vColumn, "y": rows.8, "entries": {"11": 1}, "exits": {}}]
			Continue
		}

		x_coord := vColumn + wBox * 0.4 - 1, yMin := 100000
		Loop, % wBox/5
		{
			x_coord += 1
			Loop, % hSnip
			{
				y_coord := A_Index - 1
				pixel := Gdip_GetPixelColor(pCrop, x_coord, y_coord, 4)
				If vars.sanctum.pixels.room[pixel]
				{
					yMin := (y_coord < yMin) ? y_coord : yMin
					Gdip_SetPixel(pCrop, x_coord, y_coord, "4294901760")
					Continue 2
				}
			}
		}
		first_row := 0
		For iRow, vRow in rows
		{
			If LLK_IsBetween(yMin, vRow, vRow + hBox/2) || first_row && (!Mod(first_row, 2) && !Mod(iRow, 2) || Mod(first_row, 2) && Mod(iRow, 2)) && (iRow <= (11 - (first_row - 1)))
			{
				If !IsObject(grid[iColumn])
					grid[iColumn] := []
				first_row := !first_row ? iRow : first_row, grid[iColumn].Push({"x": vColumn, "y": vRow, "entries": {}, "exits": {}})

				Gdip_SetPixel(pCrop, vColumn + wBox/2, vRow + hBox/2, "4294901760")
				Loop, % wBox//4
					Gdip_SetPixel(pCrop, vColumn + wBox/2 - A_Index, vRow + hBox/2, "4294901760"), Gdip_SetPixel(pCrop, vColumn + wBox/2 + A_Index, vRow + hBox/2, "4294901760")
					, Gdip_SetPixel(pCrop, vColumn + wBox/2, vRow + hBox/2 - A_Index, "4294901760"), Gdip_SetPixel(pCrop, vColumn + wBox/2, vRow + hBox/2 + A_Index, "4294901760")
			}
		}
		If !grid[iColumn].Count()
		{
			error := 1, grid := []
			Break
		}
	}

	If !error
		For iColumn, vColumn in columns
		{
			GuiControl,, % vars.hwnd.sanctum.scan2, % iColumn
			If (iColumn = 7)
			{
				For iRoom in grid.7
					grid.7[iRoom].exits.81 := 1
				Break
			}
			Else If (iColumn = 1) && vars.poe_version && InStr(vars.log.areaID, "sanctum_1")
			{
				grid.1.2.exits := {"21": 1, "22": 1, "23": 1}
				Continue
			}

			x_coord := Round(vColumn + wBox/2 + (vars.poe_version ? wBox/3 : 0) - 1), paths := []
			Loop
			{
				x_coord += 1
				If (x_coord >= columns[iColumn + 1] + wBox/2)
					Break
				If !vars.poe_version && (vars.client.h > 1200) && Mod(x_coord, (vars.client.h >= 1800) ? 3 : 2)
					Continue
				Loop, % hSnip
				{
					y_coord := A_Index - 1
					If (y_coord >= rows.11 + hBox * 0.6)
						Break
					Else If (grid[iColumn].Count() < grid[iColumn + 1].Count()) && (y_coord <= grid[iColumn + 1].1.y)
						Continue

					pixel := Gdip_GetPixelColor(pCrop, x_coord, y_coord, 4)
					If vars.sanctum.pixels.path[pixel]
					{
						For iPath, vPath in paths
						{
							If LLK_IsBetween(x_coord, vPath[vPath.MaxIndex()].1, vPath[vPath.MaxIndex()].1 + radius) && LLK_IsBetween(y_coord, vPath[vPath.MaxIndex()].2 - radius, vPath[vPath.MaxIndex()].2 + radius)
							{
								paths[iPath].Push([x_coord, y_coord])
								Gdip_SetPixel(pCrop, x_coord, y_coord, colors[iPath])
								Continue 2
							}
						}
						paths.Push([[x_coord, y_coord]])
						Gdip_SetPixel(pCrop, x_coord, y_coord, colors[paths.MaxIndex()])
					}
				}
			}

			For iPath, vPath in paths
			{
				Sanctum_SimpleLinearRegression(vPath, a, b)
				Loop
				{
					If (A_Index < columns[iColumn])
						Continue
					If (A_Index > columns[iColumn + 1])
						Break
					Gdip_SetPixel(pCrop, A_Index + wBox/2, a + b * (A_Index + wBox/2), colors[iPath])
				}

				start := a + b * (columns[iColumn] + wBox/2), end := a + b * (columns[iColumn + 1] + wBox/2), result := {}
				For index, val in [0, 1]
					For iRow, vRow in grid[iColumn + val]
						If LLK_IsBetween(!val ? start : end, vRow.y + hBox/4, vRow.y + hBox * 0.75)
						{
							result[!val ? "start" : "end"] := [iColumn + val, iRow]
							Break
						}

				If (IsObject(result.start) * IsObject(result.end))
					grid[result.start.1][result.start.2].exits[result.end.1 . result.end.2] := 1
				Else
				{
					error := 1, grid := []
					Gdip_SetPixel(pCrop, vPath.1.x, vPath.1.y, colors[iPath])
					Loop, % wBox//4
						Gdip_SetPixel(pCrop, vPath.1.1 - A_Index, vPath.1.2, colors[iPath]), Gdip_SetPixel(pCrop, vPath.1.1 + A_Index, vPath.1.2, colors[iPath])
						, Gdip_SetPixel(pCrop, vPath.1.1, vPath.1.2 - A_Index, colors[iPath]), Gdip_SetPixel(pCrop, vPath.1.1, vPath.1.2 + A_Index, colors[iPath])
					Break
				}
			}
			If error
				Break

			For iRoom, vRoom in grid[iColumn]
				For exit in vRoom.exits
					grid[iColumn + 1][SubStr(exit, 2)].entries[iColumn . iRoom] := 1
		}

	If !error
		For iColumn, vColumn in grid
			Loop, % vColumn.Length()
				If !(vColumn[A_Index].entries.Count() + vColumn[A_Index].exits.Count())
					grid[iColumn].Delete(A_Index)

	Gdip_SaveBitmapToFile(pCrop, "img\sanctum scan" vars.poe_version ".jpg", 100)
	Gdip_DisposeImage(pCrop)
	vars.sanctum.grid := grid.Clone()

	If !error
	{
		vars.sanctum.target := vars.sanctum.current := "", vars.sanctum.targets := {}
		vars.sanctum.avoid := {}, vars.sanctum.avoids := {}, vars.sanctum.blocks := {}
		If !vars.poe_version
			vars.sanctum.floor := InStr(vars.log.areaID, "sanctumfoyer") ? SubStr(vars.log.areaID, InStr(vars.log.areaID, "_") + 1, 1) : floors[StrReplace(vars.log.areaID, "sanctum")]
		Else vars.sanctum.floor := SubStr(vars.log.areaID, 9, 1)
		IniWrite, % vars.sanctum.floor, % "ini" vars.poe_version "\sanctum.ini", data, floor
		IniWrite, % """" json.dump(grid) """", % "ini" vars.poe_version "\sanctum.ini", data, grid snapshot
	}
	Else
	{
		vars.sanctum.floor := ""
		IniDelete, % "ini" vars.poe_version "\sanctum.ini", data, floor
		IniDelete, % "ini" vars.poe_version "\sanctum.ini", data, grid snapshot
	}

	GuiControl, % "+Background" (error ? "Maroon" : "Black"), % vars.hwnd.sanctum.scan2
	GuiControl,, % vars.hwnd.sanctum.scan2, 0
	vars.sanctum.scanning := 0
	Return !error
}

Sanctum_SimpleLinearRegression(array, ByRef a, ByRef b)
{
	local
	global vars, settings

	If !IsObject(array)
		Return

	sX := sY := 0
	Loop, % array.Count()
		sX += array[A_Index].1, sY += array[A_Index].2

	mX := sX / array.Count(), mY := sY / array.Count(), sXY := sXX := 0
	Loop, % array.Count()
		X := array[A_Index].1 - mX, Y := array[A_Index].2 - mY, sXY += X * Y, sXX += X * X

	b := sXY / sXX
	a := mY - b * mX
}
