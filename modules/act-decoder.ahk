Init_actdecoder()
{
	local
	global vars, settings, json

	If !FileExist("ini" vars.poe_version "\act-decoder.ini")
		IniWrite, % "", % "ini" vars.poe_version "\act-decoder.ini", settings

	If !IsObject(vars.actdecoder)
	{
		vars.actdecoder := {}
		Try vars.actdecoder.file_list := json.Load(LLK_FileRead("img\GUI\act-decoder\file-list" vars.poe_version ".json"))
	}
	vars.actdecoder.zone_layouts := {}, vars.actdecoder.files := {}

	If vars.actdecoder.file_list.Count()
		Loop, Files, % "img\GUI\act-decoder\zones" vars.poe_version "\*"
			If !vars.actdecoder.file_list[A_LoopFileName]
				If settings.general.dev
					outdated := 1
				Else FileDelete, % A_LoopFilePath

	If outdated
		MsgBox, % "file-list outdated"

	Loop, Files, % "img\GUI\act-decoder\zones" vars.poe_version "\*"
		If (check := InStr(A_LoopFileName, " "))
		{
			vars.actdecoder.files[StrReplace(A_LoopFileName, "." A_LoopFileExt)] := 1
			vars.actdecoder.zones[SubStr(StrReplace(A_LoopFileName, "." A_LoopFileExt), 1, InStr(A_LoopFileName, " ") - 1)] := 1
			vars.actdecoder.zone_layouts[SubStr(A_LoopFileName, 1, check - 1)] := {}
		}

	settings.actdecoder := {}, ini := IniBatchRead("ini" vars.poe_version "\act-decoder.ini")
	settings.actdecoder.xLayouts := !Blank(check := ini.settings["zone-layouts x"]) ? check : ""
	settings.actdecoder.yLayouts := !Blank(check := ini.settings["zone-layouts y"]) ? check : ""
	settings.actdecoder.sLayouts0 := settings.actdecoder.sLayouts := !Blank(check := ini.settings["zone-layouts size"]) ? check : (vars.poe_version ? 0.7 : 1)
	settings.actdecoder.sLayouts1 := !Blank(check := ini.settings["zone-layouts locked size"]) ? check : 0
	settings.actdecoder.aLayouts := !Blank(check := ini.settings["zone-layouts arrangement"]) ? check : "vertical"
	settings.actdecoder.trans_zones := !Blank(check := ini.settings["zone transparency"]) ? check : 10
	settings.actdecoder.generic := !Blank(check := ini.settings["show generic layouts"]) ? check : 0
	settings.actdecoder.hotkey := hotkey := !Blank(check := ini.settings["alternative hotkey"]) ? check : ""

	Hotkey, If, vars.actdecoder.zones[vars.log.areaID] && WinActive("ahk_group poe_ahk_window")
	If !GetKeyVK(hotkey)
		settings.actdecoder.hotkey := ""
	Else Hotkey, % Hotkeys_Convert(hotkey), Actdecoder_Hotkey, On
}

Actdecoder_Hotkey()
{
	local
	global vars, settings

	KeyWait, % settings.actdecoder.hotkey, T0.25
	If !ErrorLevel
	{
		SendInput, % "{" settings.actdecoder.hotkey "}"
		Return
	}

	vars.actdecoder.tab := 1
	If Actdecoder_ZoneLayouts()
		active := 1
	Else 
	{
		vars.actdecoder.tab := 0
		LLK_ToolTip(Lang_Trans("m_actdecoder_missing"),,,,, "Red")
	}

	KeyWait, % settings.actdecoder.hotkey
	If !active
		Return
	If !vars.actdecoder.layouts_lock
		LLK_Overlay(vars.hwnd.actdecoder.main, "destroy"), vars.hwnd.actdecoder.main := ""
	Else If settings.actdecoder.sLayouts1
		Actdecoder_ZoneLayouts(2)

	If vars.hwnd.actdecoder.main
	{
		If !settings.actdecoder.sLayouts1
		{
			WinSet, TransColor, % "Green " (settings.actdecoder.trans_zones * 25), % "ahk_id " vars.hwnd.actdecoder.main
			Gui, % Gui_Name(vars.hwnd.actdecoder.main) ": +E0x20"
		}
		For key, val in vars.hwnd.actdecoder
			If LLK_PatternMatch(key, "", ["_rotate", "_flip", "helppanel", "alignment", "reset", "drag"],,, 0)
				GuiControl, % "+hidden", % val
	}

	vars.actdecoder.tab := 0
	If (settings.actdecoder.sLayouts != settings.actdecoder.sLayouts0)
		IniWrite, % (settings.actdecoder.sLayouts0 := settings.actdecoder.sLayouts), % "ini" vars.poe_version "\act-decoder.ini", Settings, zone-layouts size
}

Actdecoder_ImageSelect(pic)
{
	local
	global vars, settings

	vars.actdecoder.zone_layouts[vars.log.areaID] := {"exclude": vars.actdecoder.zone_layouts[vars.log.areaID].exclude, "subzone": pic, (pic): vars.actdecoder.zone_layouts[vars.log.areaID][pic].Clone()}
	Loop, Files, % "img\GUI\act-decoder\zones" vars.poe_version "\" vars.log.areaID " " pic "_*"
	{
		file := StrReplace(A_LoopFileName, "." A_LoopFileExt), file := SubStr(file, InStr(file, " ") + 1)
		vars.actdecoder.zone_layouts[vars.log.areaID][file] := vars.actdecoder.zone_layouts[vars.log.areaID][pic].Clone()
	}
}

Actdecoder_ZoneLayouts(mode := 0, click := 0, cHWND := "")
{
	local
	global vars, settings
	static toggle := 0

	If !settings.features.actdecoder
		Return

	If InStr(mode, "SC00")
	{
		For index, val in vars.actdecoder.loaded
			If vars.actdecoder.files[vars.log.areaID " " val "_1"]
				selection := 1
		hotkey := SubStr(mode, 0) - 1, subzone := vars.actdecoder.zone_layouts[vars.log.areaID].subzone, target := vars.actdecoder.loaded[hotkey]
		If (vars.actdecoder.loaded.Count() = 1) && !selection
			Return
		If !InStr(target, "x") && FileExist("img\GUI\act-decoder\zones" vars.poe_version "\" vars.log.areaID " " target "_*") && !(selection && hotkey = 3)
			Actdecoder_ImageSelect(target), check := 1
		Else If (vars.actdecoder.zone_layouts[vars.log.areaID].subzone || !vars.actdecoder.files[vars.log.areaID " " target "_1"] || InStr(vars.actdecoder.loaded.1, "y"))
		&& vars.actdecoder.loaded[hotkey] && !InStr(vars.actdecoder.loaded[hotkey], "x") && (vars.actdecoder.loaded.Count() >= hotkey)
		{
			For index, val in vars.actdecoder.loaded
				If (index != hotkey)
					vars.actdecoder.zone_layouts[vars.log.areaID].exclude .= (vars.actdecoder.zone_layouts[vars.log.areaID].exclude ? "|" : "") "\s" val, check := 1
		}
		Else If !vars.actdecoder.zone_layouts[vars.log.areaID].subzone && selection && !InStr(vars.actdecoder.loaded.1, "y") && (!InStr(vars.actdecoder.loaded[hotkey], "x") || hotkey = 3)
		{
			If (hotkey = 3)
			{
				For index, val in vars.actdecoder.loaded
					If (index < 3)
						vars.actdecoder.zone_layouts[vars.log.areaID].exclude .= (vars.actdecoder.zone_layouts[vars.log.areaID].exclude ? "|" : "") "\s" val, check := 1
			}
			Else If vars.actdecoder.loaded[hotkey]
				vars.actdecoder.zone_layouts[vars.log.areaID].subzone := vars.actdecoder.loaded[hotkey], check := 1
		}
		Else If InStr(target, "x")
			vars.actdecoder.zone_layouts[vars.log.areaID].exclude .= (vars.actdecoder.zone_layouts[vars.log.areaID].exclude ? "|" : "") "\s" target, check := 1
		If !check
			Return
	}
	Else If InStr(mode, "SC0")
		vars.actdecoder.zone_layouts[vars.log.areaID] := {}

	If InStr(mode, "SC0")
		KeyWait, % SubStr(mode, InStr(mode, "SC"))

	If cHWND
	{
		check := LLK_HasVal(vars.hwnd.actdecoder, cHWND), pic := SubStr(check, InStr(check, " ") + 1), control := SubStr(check, InStr(check, "_") + 1)
		If InStr(check, "helppanel")
		{
			KeyWait, % Hotkeys_RemoveModifiers(A_ThisHotkey)
			Return
		}

		If (check = "alignment")
		{
			If (click = 2)
				Return
			IniWrite, % (settings.actdecoder.aLayouts := (settings.actdecoder.aLayouts = "vertical") ? "horizontal" : "vertical"), % "ini" vars.poe_version "\act-decoder.ini", settings, zone-layouts arrangement
			x := (settings.actdecoder.aLayouts = "vertical") ? 0 : "", y := (settings.actdecoder.aLayouts = "vertical") ? "" : 0
			KeyWait, LButton
			KeyWait, RButton
		}
		Else If (check = "reset_bar")
		{
			KeyWait, LButton
			vars.actdecoder.zone_layouts[vars.log.areaID] := {}
		}
		Else If (check = "drag")
		{
			If (click = 1)
			{
				start := A_TickCount
				WinGetPos,,, width, height, % "ahk_id "vars.hwnd.actdecoder.main
				While GetKeyState("LButton", "P")
					If (A_TickCount >= start + 200)
					{
						longpress := 1
						LLK_Drag(width, height, x, y,, "actdecoder_zones" toggle, 1,,, 1)
						Sleep 1
					}
				If longpress
					vars.general.drag := 0
			}
			Else x := (settings.actdecoder.aLayouts = "horizontal") ? "" : 0, y := (settings.actdecoder.aLayouts = "horizontal") ? 0 : ""
			KeyWait, LButton
			KeyWait, RButton
		}
		Else If LLK_PatternMatch(check, "", ["_rotate", "_flip"])
		{
			control := SubStr(check, InStr(check, " ",, 0) + 1), control := SubStr(control, 1, InStr(control, "_",, 0) - 1)
			If !IsObject(vars.actdecoder.zone_layouts[vars.log.areaID][control])
				vars.actdecoder.zone_layouts[vars.log.areaID][control] := [0]

			max_index := vars.actdecoder.zone_layouts[vars.log.areaID][control].MaxIndex()
			If InStr(check, "_rotate")
			{
				angle := 90 * (InStr(A_ThisHotkey, "LButton") ? 1 : -1)
				If IsNumber(LLK_MaxIndex(vars.actdecoder.zone_layouts[vars.log.areaID][control]))
				{
					vars.actdecoder.zone_layouts[vars.log.areaID][control][max_index] += angle
					vars.actdecoder.zone_layouts[vars.log.areaID][control][max_index] *= (Abs(vars.actdecoder.zone_layouts[vars.log.areaID][control][max_index]) >= 360) ? 0 : 1
				}
				Else vars.actdecoder.zone_layouts[vars.log.areaID][control].Push(angle)
			}
			Else
			{
				flip := InStr(A_ThisHotkey, "LButton") ? "h" : "v"
				If !IsNumber(vars.actdecoder.zone_layouts[vars.log.areaID][control][max_index]) && (flip = vars.actdecoder.zone_layouts[vars.log.areaID][control][max_index])
					vars.actdecoder.zone_layouts[vars.log.areaID][control].Pop()
				Else vars.actdecoder.zone_layouts[vars.log.areaID][control].Push(flip)
			}
		}
		Else If InStr(check, "imagereset_")
		{
			KeyWait, LButton
			KeyWait, RButton
			vars.actdecoder.zone_layouts[vars.log.areaID].Delete(control)
		}
		Else If (click = 1) && !InStr(check, " x") && FileExist("img\GUI\act-decoder\zones" vars.poe_version "\" vars.log.areaID " " pic "_*")
			Actdecoder_ImageSelect(pic)
		Else If (click = 1) && !InStr(check, " x") && (vars.actdecoder.loaded.Count() != 1)
		{
			control := SubStr(check, InStr(check, " ") + 1)
			For index, val in vars.actdecoder.loaded
				If (control != val)
					vars.actdecoder.zone_layouts[vars.log.areaID].exclude .= (vars.actdecoder.zone_layouts[vars.log.areaID].exclude ? "|" : "") "\s" val
		}
		Else Return
	}

	If !Blank(x) || !Blank(y)
	{
		IniWrite, % (settings.actdecoder.xLayouts := x), % "ini" vars.poe_version "\act-decoder.ini", settings, zone-layouts x
		IniWrite, % (settings.actdecoder.yLayouts := y), % "ini" vars.poe_version "\act-decoder.ini", settings, zone-layouts y
	}
	If (click = 1) && (check = "drag")
		Return

	If !vars.actdecoder.zone_layouts[vars.log.areaID]
	{
		LLK_Overlay(vars.hwnd.actdecoder.main, "destroy"), vars.hwnd.actdecoder.main := "", vars.actdecoder.current_zone := vars.log.areaID
		Return
	}

	alignment := settings.actdecoder.aLayouts, rota_block := {"g1_4": 1, "g1_14": 1, "g1_15": 1, "g2_4_3": 1, "g3_11": 1, "g3_16": 1}
	If (vars.actdecoder.current_zone != vars.log.areaID)
		vars.actdecoder.current_zone := vars.log.areaID
	toggle := !toggle, GUI_name := "actdecoder_zones" toggle
	Gui, %GUI_name%: New, % "-DPIScale +LastFound -Caption +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDactdecoder_zones" (mode = 2 ? " +E0x20" : "")
	Gui, %GUI_name%: Font, % "s" settings.general.fSize + 4 " Bold cWhite", % vars.system.font
	Gui, %GUI_name%: Color, % "Green"
	If (mode = 2)
		WinSet, TransColor, % "Green " (settings.actdecoder.trans_zones * 25)
	Else WinSet, TransColor, % "Green 255"

	Gui, %GUI_name%: Margin, % (margin := Floor(vars.monitor.h/200)), % margin
	hwnd_old := vars.hwnd.actdecoder.main, vars.hwnd.actdecoder := {"main": actdecoder_zones}

	Gui, %GUI_name%: Add, Pic, % "Section Border BackgroundTrans HWNDhwnd h" settings.general.fHeight " w-1" (vars.actdecoder.tab ? "" : " Hidden"), % "HBitmap:*" vars.pics.global.help
	Gui, %GUI_name%: Add, Progress, % "Disabled HWNDhwnd1 xp yp wp hp BackgroundBlack" (vars.actdecoder.tab ? "" : " Hidden"), 0
	vars.hwnd.actdecoder.helppanel := hwnd, vars.hwnd.actdecoder.helppanel_bar := vars.hwnd.help_tooltips["actdecoder_help panel"] := hwnd1

	If !vars.pics.zone_layouts.drag
		vars.pics.zone_layouts.drag := LLK_ImageCache("img\GUI\drag.png")
	Gui, %GUI_name%: Add, Pic, % (alignment = "vertical" ? "ys" : "xs") " Border HWNDhwnd h" settings.general.fHeight " w-1" (vars.actdecoder.tab ? "" : " Hidden")
		, % "HBitmap:*" vars.pics.zone_layouts.drag
	vars.hwnd.actdecoder.drag := vars.hwnd.help_tooltips["actdecoder_drag"] := hwnd

	If !vars.pics.zone_layouts.vertical
		vars.pics.zone_layouts.vertical := LLK_ImageCache("img\GUI\vertical_alignment.png"), vars.pics.zone_layouts.horizontal := LLK_ImageCache("img\GUI\horizontal_alignment.png")
	Gui, %GUI_name%: Add, Pic, % (alignment = "vertical" ? "ys" : "xs") " Border HWNDhwnd h" settings.general.fHeight " w-1" (vars.actdecoder.tab ? "" : " Hidden")
		, % "HBitmap:*" vars.pics.zone_layouts[(alignment = "vertical" ? "horizontal" : "vertical")]
	vars.hwnd.actdecoder.alignment := vars.hwnd.help_tooltips["actdecoder_alignment"] := hwnd

	For key, val in vars.actdecoder.zone_layouts[vars.log.areaID]
		If IsObject(val) && (val.1 || val.Count() > 1) || !IsObject(val) && !Blank(val)
			reset_check := 1

	If reset_check
	{
		Gui, %GUI_name%: Add, Pic, % (alignment = "vertical" ? "ys" : "xs") " Border HWNDhwnd BackgroundTrans h" settings.general.fHeight " w-1" (vars.actdecoder.tab ? "" : " Hidden"), % "HBitmap:*" vars.pics.global.revert
		Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 BackgroundBlack" (vars.actdecoder.tab ? "" : " Hidden"), 0
		vars.hwnd.actdecoder.reset := hwnd, vars.hwnd.actdecoder.reset_bar := vars.hwnd.help_tooltips["actdecoder_reset"] := hwnd1
	}

	subzone := vars.actdecoder.zone_layouts[vars.log.areaID].subzone, pic_count := ypic_count := pic_count0 := 0, vars.actdecoder.loaded := [], deep := selection := 0
	While InStr(subzone, "_",,, deep + 1)
		deep += 1

	For outer in [1, 2]
	{
		count := 0 ;, pic_count := (alignment = "vertical") && vars.actdecoder.tab ? Min(4, pic_count) : pic_count
		exclude := vars.actdecoder.zone_layouts[vars.log.areaID].exclude
		Loop, Files, % "img\GUI\act-decoder\zones" vars.poe_version "\" StrReplace(vars.log.areaID, vars.poe_version ? "c_" : "") " *"
		{
			file := StrReplace(A_LoopFileName, "." A_LoopFileExt), file := SubStr(file, InStr(file, " ") + 1)
			selection += (vars.actdecoder.files[vars.log.areaID " " file "_1"] ? 1 : 0)
			If !RegExMatch(A_LoopFileName, "i)" (subzone ? "\s(" subzone "|x(_x){" deep "})_." : "\s(\d|x)") "\.(jpg|png)$") && !(pic_count0 = 0 && InStr(A_LoopFileName, " y"))
			|| exclude && RegExMatch(A_LoopFileName, "i)" StrReplace(vars.log.areaID, vars.poe_version ? "c_" : "") . exclude "\.") || !pic_count0 && InStr(A_LoopFileName, " x")
			;|| selection && (count > 3) && !RegExMatch(A_LoopFileName, "i)\s(x|y)")
			|| settings.actdecoder.generic && !InStr(A_LoopFileName, " y") && vars.actdecoder.files[StrReplace(vars.log.areaID, "c_") " y_1"]
				Continue

			count += 1, pic_count += (outer = 1 ? (selection && (count = 3) && !InStr(file, "x") ? 0.2 : (count < 4 || InStr(file, "x") ? 1 : 0)) : 0), pic_count0 += (outer = 1) && !RegExMatch(A_LoopFileName, "i)\s(x|y)") ? 1 : 0
			ypic_count += InStr(A_LoopFileName, " y") ? 1 : 0

			If (outer = 1)
				Continue
			If (alignment = "vertical")
				style := (!selection || (selection && count < 4) || InStr(file, "x") ? " Section xs" : " ys")
			Else style := (!selection || (selection && count < 4) || InStr(file, "x") ? " Section ys" : " xs") ;" Section ys"

			pBitmap := Gdip_CreateBitmapFromFile(A_LoopFilePath), Gdip_GetImageDimension(pBitmap, width, height)
			For index, operation in vars.actdecoder.zone_layouts[vars.log.areaID][file]
				If IsNumber(operation)
				{
					If (operation = 0)
						Continue
					If InStr("90,270", Abs(operation)) && (alignment = "horizontal") && (width != height)
					{
						pBitmap_corrected := Gdip_ResizeBitmap(pBitmap, height, 10000, 1,, 1), Gdip_DisposeBitmap(pBitmap)
						pBitmap := pBitmap_corrected
					}
					operation := (operation < 0) ? 360 + operation : operation
					Gdip_ImageRotateFlip(pBitmap, operation//90)

					If InStr("90,270", Abs(operation)) && (alignment = "vertical") && (width != height)
					{
						pBitmap_corrected := Gdip_ResizeBitmap(pBitmap, width, 10000, 1,, 1), Gdip_DisposeBitmap(pBitmap)
						pBitmap := pBitmap_corrected
					}
					Gdip_GetImageDimension(pBitmap, width, height)
				}
				Else Gdip_ImageRotateFlip(pBitmap, (operation = "h" ? 4 : 6))

			new_width := Round(vars.actdecoder.tab && (mode != 2) || !settings.actdecoder.sLayouts1 ? width * settings.actdecoder.sLayouts : vars.monitor.h * (settings.actdecoder.sLayouts1 * 0.05 + 0.1))
			new_width := (new_width * pic_count + margin * (pic_count + 2) + settings.general.fHeight >= (axis := vars.monitor[(settings.actdecoder.aLayouts = "vertical" ? "h" : "w")])) ? Round(axis / (pic_count + 0.33)) : new_width
			While Mod(new_width, 8)
				new_width -= 1
			new_width := (selection && (count > 2) && !InStr(file, "x") ? new_width/8 : new_width)
			pBitmap_resized := Gdip_ResizeBitmap(pBitmap, new_width * (InStr(A_LoopFileName, "x") ? 0.66 : 1), 10000, 1, 7, 1)
			Gdip_DisposeBitmap(pBitmap)
			hbmBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap_resized, 0), Gdip_DisposeBitmap(pBitmap_resized)

			hidden := (mode = 2 || pic_count = 1 && (!vars.actdecoder.files[StrReplace(A_LoopFileName, "." A_LoopFileExt) "_1"] || subzone || InStr(file, "y")) || selection && (InStr(file, "x") || count > 3) ? "Hidden " : "")
			Gui, %GUI_name%: Add, Text, % hidden "BackgroundTrans Center w" settings.general.fHeight . style, % (selection && count > 2 && !InStr(file, "x") ? 3 : count)
			Gui, %GUI_name%: Add, Picture, % "Border HWNDhwnd xp yp", % "HBitmap:" hbmBitmap
			vars.hwnd.actdecoder[vars.log.areaID " " file] := hwnd, DeleteObject(hbmBitmap)
			vars.actdecoder.loaded.Push(selection && count > 2 && !InStr(file, "x") ? "" : file)

			If (count = 1)
				ControlGetPos, xFirst, yFirst,,,, ahk_id %hwnd%

			If vars.poe_version && vars.actdecoder.tab && (mode != 2) && !rota_block[vars.log.areaID] && !InStr(file, "x") && !(selection && count > 2)
			{
				If !vars.pics.zone_layouts.rotate
					vars.pics.zone_layouts.rotate := LLK_ImageCache("img\GUI\rotate.png")
				If !vars.pics.zone_layouts.flip
					vars.pics.zone_layouts.flip := LLK_ImageCache("img\GUI\flip.png")
				Gui, %GUI_name%: Add, Pic, % "Border HWNDhwnd " (alignment = "horizontal" ? "xs" : "ys") " h" settings.general.fHeight " w-1", % "HBitmap:*" vars.pics.zone_layouts.flip
				vars.hwnd.actdecoder[vars.log.areaID " " file "_flip"] := vars.hwnd.help_tooltips["actdecoder_flip" handle0] := hwnd
				Gui, %GUI_name%: Add, Pic, % "Border HWNDhwnd " (alignment = "horizontal" ? "x+" settings.general.fWidth//2 " yp" : "y+" settings.general.fWidth//2 " xp") " h" settings.general.fHeight " w-1"
					, % "HBitmap:*" vars.pics.zone_layouts.rotate
				vars.hwnd.actdecoder[vars.log.areaID " " file "_rotate"] := vars.hwnd.help_tooltips["actdecoder_rotate" handle0] := hwnd, handle0 .= "|"
				If (vars.actdecoder.zone_layouts[vars.log.areaID][file].Count() > 1) || vars.actdecoder.zone_layouts[vars.log.areaID][file].1
				{
					Gui, %GUI_name%: Add, Pic, % "Border HWNDhwnd0 BackgroundTrans " (alignment = "horizontal" ? "x+" settings.general.fWidth//2 " yp" : "y+" settings.general.fWidth//2 " xp") " h" settings.general.fHeight " w-1", % "HBitmap:*" vars.pics.global.revert
					Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd BackgroundBlack", 0
					vars.hwnd.actdecoder["imagereset_" file] := hwnd, vars.hwnd.actdecoder["imageresetpic_" file] := hwnd0
				}
			}
		}
		If !pic_count0
			If !FileExist("img\GUI\act-decoder\zones" vars.poe_version "\" StrReplace(vars.log.areaID, vars.poe_version ? "c_" : "") " y*")
				vars.actdecoder.zone_layouts[vars.log.areaID].exclude := "", pic_count0 := 1, pic_count := 3
			Else If !ypic_count
				Loop, Parse, exclude, |
				{
					If (A_Index = 1)
						vars.actdecoder.zone_layouts[vars.log.areaID].exclude := ""
					If !InStr(A_LoopField, "y")
						vars.actdecoder.zone_layouts[vars.log.areaID].exclude .= (!vars.actdecoder.zone_layouts[vars.log.areaID].exclude ? "" : "|") A_LoopField
				}
	}

	reset_check := 0
	For key, val in vars.actdecoder.zone_layouts[vars.log.areaID]
		If IsObject(val) || !Blank(val)
			reset_check := 1

	If vars.actdecoder.tab && !reset_check
	{
		GuiControl, +Hidden, % vars.hwnd.actdecoder.reset
		GuiControl, +Hidden, % vars.hwnd.actdecoder.reset_bar
	}

	If (mode = 1)
	{
		pBitmap := Gdip_CreateBitmapFromFile("img\GUI\act-decoder\zones" vars.poe_version "\explanation" (!pic_count0 ? "_y" : "") "." (!vars.poe_version && !pic_count0 ? "png" : "jpg"))
		Gdip_GetImageDimension(pBitmap, wInfo, hInfo)
		pBitmap_resized := Gdip_ResizeBitmap(pBitmap, wInfo * settings.actdecoder.sLayouts, 10000, 1, 7, 1), Gdip_DisposeBitmap(pBitmap)
		hbmBitmap2 := Gdip_CreateHBITMAPFromBitmap(pBitmap_resized, 0), Gdip_DisposeBitmap(pBitmap_resized)
		Gui, %GUI_name%: Add, Picture, % "Border " (alignment = "horizontal" ? "xs x" xFirst " y" new_width + margin*4 + settings.general.fHeight : "ys y" yFirst " x" new_width + margin*4 + settings.general.fHeight), % "HBitmap:" hbmBitmap2
		DeleteObject(hbmBitmap2)
	}
	Gui, %GUI_name%: Show, % "NA AutoSize x10000 y10000"
	WinGetPos,,, w, h, % "ahk_id " vars.hwnd.actdecoder.main
	xPos := Blank(settings.actdecoder.xLayouts) ? (alignment = "horizontal" ? vars.monitor.x + vars.client.xc - w/2 : vars.monitor.x) : vars.monitor.x + settings.actdecoder.xLayouts
	yPos := Blank(settings.actdecoder.yLayouts) ? (alignment = "vertical" ? vars.monitor.y + vars.monitor.h/2 - h/2 : vars.monitor.y) : vars.monitor.y + settings.actdecoder.yLayouts
	xPos := (xPos >= vars.monitor.x + vars.monitor.w / 2) ? xPos - w + 1 : xPos, yPos := (yPos >= vars.monitor.y + vars.monitor.h / 2) ? yPos - h + 1 : yPos
	;Gui_CheckBounds(xPos, yPos, w, h)

	Gui, %GUI_name%: Show, % "NA AutoSize x" xPos " y" yPos
	LLK_Overlay(actdecoder_zones, "show",, GUI_name), LLK_Overlay(hwnd_old, "destroy")
	Return 1
}

Actdecoder_ZoneLayoutsSize(hotkey)
{
	local
	global vars, settings
	static resizing

	If (hotkey = "SC039")
	{
		vars.actdecoder.layouts_lock := !vars.actdecoder.layouts_lock
		KeyWait, SC039
		Return
	}

	WinGetPos,,, w, h, % "ahk_id "vars.hwnd.actdecoder.main
	If (hotkey = "WheelDown" && settings.actdecoder.sLayouts < 0.4) || (hotkey = "WheelUp" && settings.actdecoder.sLayouts * (vars.poe_version ? 660 : 256) >= vars.monitor.h * 0.6) || resizing
		Return

	If (hotkey != "MButton")
		settings.actdecoder.sLayouts += (hotkey = "WheelDown") ? -0.1 : 0.1, resizing := 1
	Actdecoder_ZoneLayouts((hotkey = "MButton") ? 1 : 0)
	If (hotkey = "MButton")
	{
		KeyWait, MButton
		Actdecoder_ZoneLayouts()
	}
	resizing := 0
}
