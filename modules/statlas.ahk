Init_statlas()
{
	local
	global vars, settings

	If !vars.poe_version
		Return

	If !FileExist("ini" vars.poe_version "\statlas.ini")
		IniWrite, % "", % "ini" vars.poe_version "\statlas.ini", settings
	If !IsObject(settings.statlas)
		settings.statlas := {}

	ini := IniBatchRead("ini" vars.poe_version "\statlas.ini")
	settings.statlas.fSize := !Blank(check := ini.settings["font-size"]) ? check : settings.general.fSize
	settings.statlas.tier := settings.statlas.tier0 := !Blank(check := ini.settings["filter tier"]) ? check : 15
	settings.statlas.maptracker := !Blank(check := ini.settings["include map-tracker data"]) ? check : (settings.features.maptracker ? 1 : 0)
	settings.statlas.notable := !Blank(check := ini.settings["show atlas-notable effect"]) ? check : 1
	settings.statlas.zoom := settings.statlas.zoom0 := !Blank(check := ini.settings.zoom) ? check : 0.25
	LLK_FontDimensions(settings.statlas.fSize, font_height, font_width), settings.statlas.fWidth := font_width, settings.statlas.fHeight := font_height
}

Statlas()
{
	local
	global vars, settings, db

	start := A_TickCount
	If !IsObject(db.maps)
		DB_Load("maps")
	Gui, statlas_comms: New, -DPIScale -Caption +LastFound +AlwaysOnTop +ToolWindow +Border, % "Exile UI: statlas"
	WinSet, Trans, 1
	Gui, statlas_comms: Add, Text,, % "client: " vars.hwnd.poe_client
	. "`nclip: " vars.general.xMouse - vars.client.x - vars.client.h//8 "|" vars.general.yMouse - vars.client.y + Round(vars.client.h * 0.03) "|" vars.client.h//4 "|" Round(vars.client.h/(settings.statlas.notable ? 10 : 12)) "`n"
	. (settings.general.blackbars ? "blackbars: " vars.client.x - vars.monitor.x "|0|" vars.client.w "|" vars.client.h "`n" : "")
	Gui, statlas_comms: Show, NA x10000 y10000

	vars.statlas := {}
	Run, modules\_ocr thread.ahk,, UseErrorLevel

	If ErrorLevel
		Return
	Else
		While !ocr_failed && Blank(vars.statlas.text)
		{
			If (A_TickCount >= start + 1000) || (vars.statlas.text = "OCR failed")
				ocr_failed := 1
			Sleep 25
		}

	If ocr_failed
		Return
	text := SubStr(vars.statlas.text, InStr(vars.statlas.text, ":") + 2), text := StrReplace(text, "  ", " ")
	vars.statlas := {}

	Loop, Parse, text, `n, " `r`t"
		If A_LoopField
		{
			line := A_LoopField
			If !vars.statlas.map
			{
				For key, val in db.maps.maps
					If RegExMatch(val.name, "i)^" StrReplace(line, " ", ".*") "$")
					{
						vars.statlas.map := [key, val.name]
						vars.statlas.boss := val.boss
						Continue 2
					}
				Continue
			}
			If !vars.statlas.biome && RegExMatch(StrReplace(A_LoopField, " "), "i)^" Lang_Trans("maps_biome"))
				For key, val in db.maps.biomes
					If RegExMatch(StrReplace(line, " "), "i)" key "$")
					{
						vars.statlas.biome := key
						Continue 2
					}
		}

	If !vars.statlas.map
		Return
	Else Return 1
}

Statlas_GUI(mode := "")
{
	local
	global vars, settings, db
	static toggle := 0, wColumn, wColumns, lang := ["global_maps", "maptracker_time", "mapinfo_rip", "statlas_kills"], xPos, yPos, wait, fSize

	If wait
		Return

	mode0 := mode, wait := vars.statlas.wait := 1
	If InStr(mode, "tier_")
		If InStr(mode, "minus") && (settings.statlas.tier = 1) || InStr(mode, "plus") && (settings.statlas.tier = 18)
		{
			wait := 0
			Return
		}
		Else settings.statlas.tier += InStr(mode, "plus") ? 1 : -1, mode := ""

	If InStr(mode, "zoom_")
		If InStr(mode, "minus") && (Round(settings.statlas.zoom, 2) = 0.20) || InStr(mode, "plus") && (Round(settings.statlas.zoom, 2) = 0.50)
		|| (LLK_IsBetween(vars.general.xMouse, vars.statlas.coords.1, vars.statlas.coords.3) && LLK_IsBetween(vars.general.yMouse, vars.statlas.coords.2, vars.statlas.coords.4))
		{
			wait := 0
			Return
		}
		Else settings.statlas.zoom += InStr(mode, "plus") ? 0.05 : -0.05, mode := ""

	toggle := !toggle, GUI_name := "statlas" toggle
	map := vars.statlas.map, boss := vars.statlas.boss, biome := vars.statlas.biome
	league := LLK_MaxIndex(vars.maptracker.leagues)
	Gui, %GUI_name%: New, % "-Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDhwnd_statlas"
	Gui, %GUI_name%: Font, % "s" settings.statlas.fSize " cWhite", % vars.system.font
	Gui, %GUI_name%: Color, Purple
	WinSet, TransColor, Purple
	Gui, %GUI_name%: Margin, 0, 0
	hwnd_old := vars.hwnd.statlas.main, vars.hwnd.statlas := {"main": hwnd_statlas}

	If !IsObject(vars.maptracker.entries)
		Maptracker_LogsLoad()

	If InStr(mode0, "zoom_")
	{
		For key, val in vars.pics.statlas
			DeleteObject(val)
		vars.pics.statlas := {}
	}

	wPics := vars.client.h * settings.statlas.zoom
	If !vars.pics.statlas[map.1]
		vars.pics.statlas[map.1] := LLK_ImageCache("img\GUI\statlas\" map.1 ".jpg", wPics)
	If (filecheck := FileExist("img\GUI\statlas\" boss ".jpg")) && !vars.pics.statlas[boss]
		vars.pics.statlas[boss] := LLK_ImageCache("img\GUI\statlas\" boss ".jpg", wPics)

	Gui, %GUI_name%: Add, Text, % "Section BackgroundTrans Border Center cLime w" wPics * 2 + 4, % map.2
	Gui, %GUI_name%: Add, Progress, % "Disabled BackgroundBlack xp yp wp hp", 0
	Gui, %GUI_name%: Add, Pic, % "Section xs y+-1 Border", % "HBitmap:*" vars.pics.statlas[map.1]
	If filecheck
		Gui, %GUI_name%: Add, Pic, % "ys Border", % "HBitmap:*" vars.pics.statlas[boss]
	Else
	{
		Gui, %GUI_name%: Add, Text, % "ys  wp hp Center 0x200 Border BackgroundTrans", % boss
		Gui, %GUI_name%: Add, Progress, % "Disabled BackgroundBlack xp yp wp hp", 0
	}

	If !mode && settings.statlas.maptracker
	{
		stats := {}
		For index, val in ["current", "legacy"]
			stats[val] := {"runs": 0, "deaths": 0, "deathruns": 0, "run": 0, "kills": 0, "killruns": 0, "total_runs": 0}
		For date, runs in vars.maptracker.entries
		{
			timeframe := LLK_IsBetween(StrReplace(date, "/"), league.2, league.3) ? "current" : "legacy"
			stats[timeframe].total_runs += runs.Count()
			For iMaprun, vMaprun in runs
			{
				If InStr(vMaprun.map, map.2) && (vMaprun.tier >= settings.statlas.tier)
				{
					stats[timeframe].run += vMaprun.run, stats[timeframe].runs += 1
					If vMaprun.kills
						stats[timeframe].kills += vMaprun.kills, stats[timeframe].killruns += 1
					If vMaprun.deaths
						stats[timeframe].deaths += vMaprun.deaths, stats[timeframe].deathruns += 1
				}
			}
		}

		For index, val in ["current", "legacy"]
		{
			If stats[val].kills
				stats[val].kills := Round(stats[val].kills/stats[val].killruns), stats[val].kills := Round(stats[val].kills/(stats[val].run/stats[val].runs/60))
			If stats[val].runs
				stats[val].deaths := StrReplace(Round(stats[val].deathruns/stats[val].runs * 100, 1), ".0") "%"
				, stats[val].run := FormatSeconds(Round(stats[val].run/stats[val].runs), 0)
			Else stats[val].deaths := "0%"
		}

		dimensions := stats.legacy.runs ? [Lang_Trans("global_league"), Lang_Trans("statlas_legacy")] : [Lang_Trans("global_league")]
		For index, val in ["runs", "run", "deaths", "kills"]
		{
			dimensions.Push(stats.current[val])
			If stats.legacy.runs
				dimensions.Push(stats.legacy[val])
		}
		LLK_PanelDimensions(dimensions, settings.statlas.fSize, wColumns, hColumns)
	}

	If settings.statlas.notable && vars.statlas.biome
	{
		Gui, %GUI_name%: Add, Text, % "Section BackgroundTrans xs y+-1 Border Center cYellow w" wPics * 2 + 4, % Lang_Trans("maps_biome") " " biome " (" db.maps.biomes[biome] ")"
		Gui, %GUI_name%: Add, Progress, % "Disabled BackgroundBlack xp yp wp hp", 0
	}

	If !wColumn || (fSize != settings.statlas.fSize)
		LLK_PanelDimensions([Lang_Trans("global_maps"), StrReplace(Lang_Trans("mapinfo_rip"), ":"), Lang_Trans("maptracker_time"), Lang_Trans("statlas_kills")], settings.statlas.fSize, wColumn, hColumn)
		, wColumn += Mod(wColumn, 2) ? 0 : 1

	If settings.statlas.maptracker
	{
		filters_column := [Lang_Trans("statlas_filters"), Lang_Trans("global_tier") " " settings.statlas.tier "+"]
		LLK_PanelDimensions(filters_column, settings.statlas.fSize, wFilters, hFilters)
		Gui, %GUI_name%: Add, Text, % "Section xs y+-1 BackgroundTrans Border Center w" wFilters " x" wPics - wColumns - wFilters + 2, % Lang_Trans("statlas_filters")
		Gui, %GUI_name%: Add, Progress, % "Disabled BackgroundBlack xp yp wp hp", 0
		Gui, %GUI_name%: Add, Text, % "xs BackgroundTrans Border Center w" wFilters, % Lang_Trans("global_tier") " " settings.statlas.tier "+"
		Gui, %GUI_name%: Add, Progress, % "Disabled BackgroundBlack HWNDhwnd xp yp wp hp", 0
		ControlGetPos, xTier, yTier, wTier, hTier,, ahk_id %hwnd%
		vars.hwnd.statlas.tier := vars.hwnd.help_tooltips["statlas_tier"] := hwnd
		
		Gui, %GUI_name%: Add, Text, % "Section ys BackgroundTrans Border Center HWNDhwnd w" wColumns, % Lang_Trans("global_league")
		ControlGetPos, xFirst, yFirst,,,, ahk_id %hwnd%
		If stats.legacy.runs
			Gui, %GUI_name%: Add, Text, % "ys BackgroundTrans Border Center w" wColumns, % Lang_Trans("statlas_legacy")
		Gui, %GUI_name%: Add, Text, % "ys BackgroundTrans Border Center cLime w" wColumn
		
		For index, val in ["runs", "run", "deaths", "kills"]
		{
			Gui, %GUI_name%: Add, Text, % "Section xs BackgroundTrans Right Border w" wColumns, % stats.current[val] " "
			If stats.legacy.runs
				Gui, %GUI_name%: Add, Text, % "ys BackgroundTrans Border w" wColumns, % " " stats.legacy[val]
			Gui, %GUI_name%: Add, Text, % "ys BackgroundTrans Border HWNDhwnd w" wColumn, % " " StrReplace(Lang_Trans(lang[index]), ":")
			ControlGetPos, xLast, yLast, wLast, hLast,, ahk_id %hwnd%
		}
		Gui, %GUI_name%: Add, Progress, % "Disabled BackgroundBlack x" xFirst " y" yFirst " w" xLast + wLast - xFirst " h" yLast + hLast - yFirst, 0
	}

	Gui, %GUI_name%: Show, NA x10000 y10000
	WinGetPos,,, width, height, ahk_id %hwnd_statlas%
	If !mode0 || InStr(mode0, "zoom_")
		xPos := vars.general.xMouse - width//2, yPos := vars.general.yMouse - height - vars.client.h//50
	Gui_CheckBounds(xPos, yPos, width, height)
	Gui, %GUI_name%: Show, % "NA x" xPos " y" yPos
	vars.statlas.coords := [xPos + xTier, yPos + yTier, xPos + xTier + wTier, yPos + yTier + hTier]
	LLK_Overlay(hwnd_statlas, "show",, GUI_name), LLK_Overlay(hwnd_old, "destroy"), wait := vars.statlas.wait := 0
}
