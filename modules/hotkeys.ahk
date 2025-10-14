Init_hotkeys()
{
	local
	global vars, settings, db

	If !FileExist("ini" vars.poe_version "\hotkeys.ini")
		IniWrite, % "", % "ini" vars.poe_version "\hotkeys.ini", settings

	If !IsObject(vars.hotkeys)
		vars.hotkeys := {"scan_codes": {"00A": 9, "00B": 0}}

	settings.hotkeys := {}, ini := IniBatchRead("ini" vars.poe_version "\hotkeys.ini")
	settings.hotkeys.rebound_alt := !Blank(check := ini.settings["advanced item-info rebound"]) ? check : 0
	settings.hotkeys.item_descriptions := !Blank(check := ini.hotkeys["item-descriptions key"]) ? check : ""
	If !settings.hotkeys.item_descriptions
		settings.hotkeys.rebound_alt := 0
	settings.hotkeys.rebound_c := !Blank(check := ini.settings["c-key rebound"]) ? check : 0
	settings.hotkeys.movekey := !Blank(check := ini.hotkeys["move-key"]) ? check : "lbutton"
	settings.hotkeys.omniblock := !Blank(check := ini.hotkeys["block omnikey's native function"]) ? check : 0
	settings.hotkeys.omnikey := vars.omnikey.hotkey := !Blank(check := ini.hotkeys["omni-hotkey"]) ? check : "MButton"
	settings.hotkeys.omnikey2 := vars.omnikey.hotkey2 := !Blank(check := ini.hotkeys["omni-hotkey2"]) ? check : ""
	settings.hotkeys.emergencykey := !Blank(check := ini.hotkeys["emergency hotkey"]) ? check : "space"

	Hotkey, If,
	Hotkey, % "LWin & " Hotkeys_Convert(settings.hotkeys.emergencykey), LLK_Restart, On
	Hotkey, % "RWin & " Hotkeys_Convert(settings.hotkeys.emergencykey), LLK_Restart, On

	If !settings.hotkeys.omnikey2
		settings.hotkeys.rebound_c := 0
	settings.hotkeys.tab := vars.hotkeys.tab := !Blank(check := ini.hotkeys["tab replacement"]) ? check : "tab"
	settings.hotkeys.tabblock := (settings.hotkeys.tab = "capslock") ? 1 : !Blank(check := ini.hotkeys["block tab-key's native function"]) ? check : 0

	If (StrLen(vars.hotkeys.tab) > 1)
		Loop, Parse, % "!+#^"
			vars.hotkeys.tab := StrReplace(vars.hotkeys.tab, A_LoopField)

	Hotkey, If, settings.maptracker.kills && settings.features.maptracker && (vars.maptracker.refresh_kills = 1)
	Hotkey, % Hotkeys_Convert(settings.hotkeys.omnikey), Maptracker_Kills, On

	Hotkey, IfWinActive, ahk_group poe_ahk_window
	If !settings.hotkeys.rebound_c
		Hotkey, % (!settings.hotkeys.omniblock ? "*~" : "*") . Hotkeys_Convert(settings.hotkeys.omnikey), Omnikey, On
	Else
	{
		Hotkey, % (!settings.hotkeys.omniblock ? "*~" : "*") . Hotkeys_Convert(settings.hotkeys.omnikey2), Omnikey, On
		Hotkey, % (!settings.hotkeys.omniblock ? "*~" : "*") . Hotkeys_Convert(settings.hotkeys.omnikey), Omnikey2, On
	}

	For index, val in ["", 2]
		If (StrLen(vars.omnikey["hotkey" val]) > 1)
			Loop, Parse, % "+!^#"
				vars.omnikey["hotkey" val] := StrReplace(vars.omnikey["hotkey" val], A_LoopField)

	Hotkey, If, (vars.cheatsheets.active.type = "image") && vars.hwnd.cheatsheet.main && !vars.cheatsheets.tab && WinExist("ahk_id " vars.hwnd.cheatsheet.main)
	Hotkey, % Hotkeys_Convert(settings.hotkeys.tab), Cheatsheet_TAB, On

	Hotkey, IfWinActive, ahk_group poe_ahk_window
	Hotkey, % Hotkeys_Convert(settings.hotkeys.tab), Hotkeys_Tab, On

	Hotkey, If, WinExist("ahk_id "vars.hwnd.horizons.main)
	Loop, Parse, % "abcdefghijklmnopqrstuvwxyz"
		Hotkey, % "*" Hotkeys_Convert(A_LoopField), HorizonsTooltip, On

	If vars.client.stream
		Return

	Hotkey, If, (settings.features.iteminfo && !settings.iteminfo.omnikey || settings.features.mapinfo && !settings.mapinfo.omnikey || settings.features.anoints) && WinActive("ahk_id " vars.hwnd.poe_client)
	Hotkey, % (settings.hotkeys.rebound_alt && settings.hotkeys.item_descriptions) ? "*~" Hotkeys_Convert(settings.hotkeys.item_descriptions) : "*~" Hotkeys_Convert("ALT"), Hotkeys_Alt, On
}

Hotkeys_Alt()
{
	local
	global vars, settings

	start := A_TickCount
	While !longpress && !GetKeyState("TAB", "P") && (GetKeyState("ALT", "P") || settings.hotkeys.rebound_alt && GetKeyState(settings.hotkeys.item_descriptions, "P"))
	{
		If (A_TickCount >= start + 150)
			longpress := 1
		Sleep 10
	}

	If !(GetKeyState("Ctrl", "P") || GetKeyState("Shift", "P")) && longpress && (vars.general.MultiThreading && vars.pixels.inventory || !vars.general.MultiThreading && Screenchecks_PixelSearch("inventory"))
	{
		Clipboard := ""
		If settings.hotkeys.rebound_alt && settings.hotkeys.item_descriptions
			SendInput, % "{" settings.hotkeys.item_descriptions " down}^{c}{" settings.hotkeys.item_descriptions " up}"
		Else SendInput, !^{c}
		ClipWait, 0.1

		If Clipboard
		{
			vars.omnikey.item := {}, Omni_ItemInfo(), item := vars.omnikey.item
			If settings.features.mapinfo && !settings.mapinfo.omnikey && (Omni_Context(0, 1) = "mapinfo") ;RegExMatch(item.name . item.itembase, "i)\smap$|waystone")
			{
				If Mapinfo_Parse(1, vars.poe_version)
					Mapinfo_GUI()
			}
			Else If vars.hwnd.anoints.main && RegExMatch(vars.omnikey.item.name, "Liquid\s.*|.*\sOil")
				Anoints("stock")
			Else If settings.features.anoints && RegExMatch(vars.omnikey.item.name, "Liquid\s.*|.*\sOil")
				Anoints()
			Else If settings.features.iteminfo && !settings.iteminfo.omnikey
				Iteminfo()
		}
	}
	KeyWait, ALT
	If settings.hotkeys.rebound_alt && settings.hotkeys.item_descriptions
		KeyWait, % settings.hotkeys.item_descriptions

	If !settings.iteminfo.omnikey
		LLK_Overlay(vars.hwnd.iteminfo.main, "destroy")
	If !settings.mapinfo.omnikey
		LLK_Overlay(vars.hwnd.mapinfo.main, "destroy")
}

Hotkeys_Convert(key)
{
	local
	static exceptions := ["LButton", "MButton", "RButton", "WheelUp", "WheelDown", "XButton", "Up", "Down", "Left", "Right"], modifiers := ["~", "*", "#", "+", "!", "^"]

	If (StrLen(key) > 1)
		For index, modifier in modifiers
			If InStr(key, modifier) && (SubStr(key, 0) != modifier)
				key := StrReplace(key, modifier,,, 1), append .= modifier

	For index, exception in exceptions
		If InStr(key, exception)
			Return append . key
	Return append "SC0" Format("{:X}", GetKeySC(key))
}

Hotkeys_ESC()
{
	local
	global vars, settings

	If WinExist("LLK-UI: Clone-Frames Borders")
		Cloneframes_SettingsRefresh(), vars.hwnd.cloneframe_borders.main := ""
	Else If WinExist("Exile UI: RGB-Picker")
		vars.RGB_picker.cancel := 1
	Else If vars.snipping_tool.GUI
		vars.snipping_tool := {"GUI": 0}
	Else If WinExist("LLK-UI: notepad reminder")
		WinActivate, ahk_group poe_window
	Else If WinActive("ahk_id " vars.hwnd.notepad.main)
		Notepad("save"), LLK_Overlay(vars.hwnd.notepad.main, "destroy"), vars.hwnd.notepad.main := ""
	Else If vars.hwnd.exchange.main
		Exchange("close")
	Else If vars.hwnd.leveltracker_gemcutting.main
		Leveltracker_PobGemCutting("close")
	Else If !vars.general.drag && vars.hwnd.leveltracker_gemlinks.main && WinExist("ahk_id " vars.hwnd.leveltracker_gemlinks.main)
		LLK_Overlay(vars.hwnd.leveltracker_gemlinks.main, "destroy"), vars.hwnd.leveltracker_gemlinks.main := vars.leveltracker.gemlinks.drag := ""
	Else If vars.hwnd.anoints.main
		Anoints("close")
	Else If vars.hwnd.sanctum_relics.main
		Sanctum_Relics("close")
	Else If vars.leveltracker.skilltree_schematics.GUI
		Leveltracker_PobSkilltree("close")
	Else If WinExist("ahk_id " vars.hwnd.lootfilter.main)
		Lootfilter_GUI("close")
	Else If WinExist("ahk_id " vars.hwnd.recombination.main)
	{
		LLK_Overlay(vars.hwnd.recombination.main, "destroy"), vars.hwnd.recombination.main := ""
		If !vars.recombination.item1.locked
			vars.recombination.item1 := {}
		If !vars.recombination.item2.locked
			vars.recombination.item2 := {}
	}
	Else If vars.hwnd.alarm.alarm_set.main && WinExist("ahk_id " vars.hwnd.alarm.alarm_set.main)
	{
		Gui, alarm_set: Destroy
		vars.hwnd.alarm.alarm_set := ""
	}
	Else If WinExist("ahk_id " vars.hwnd.sanctum.second)
	{
		If !vars.sanctum.scanning
			Sanctum("close")
	}
	Else If WinExist("ahk_id " vars.hwnd.stash_index.main)
		Stash_PriceIndex("destroy")
	Else If WinExist("ahk_id " vars.hwnd.stash.main)
		Stash_Close()
	Else If WinExist("ahk_id " vars.hwnd.stash_picker.main) || vars.stash.enter
	{
		Stash_PricePicker("destroy"), vars.stash.enter := 0
		SendInput, {ESC}
	}
	Else If WinExist("ahk_id " vars.hwnd.compat_test)
	{
		Gui, compat_test: Destroy
		If vars.OCR.debug
		{
			vars.OCR.debug := 0
			SendInput, % "{" settings.OCR.z_hotkey "}"
		}
		Else If settings.OCR.allow
			Settings_menu(vars.settings.active)
		Else LLK_Overlay(vars.hwnd.settings.main, "show", 0)
	}
	Else If WinExist("ahk_id " vars.hwnd.ocr_tooltip.main)
		OCR_Close()
	Else If WinExist("ahk_id " vars.hwnd.maptracker_logs.sum_tooltip)
		Gui, maptracker_tooltip: Destroy
	Else If WinExist("ahk_id "vars.hwnd.legion.main)
		Legion_Close()
	Else If WinExist("ahk_id " vars.hwnd.maptracker_dates.main)
		LLK_Overlay(vars.hwnd.maptracker_dates.main, "destroy")
	Else If WinExist("ahk_id " vars.hwnd.maptracker_logs.maptracker_edit)
		Gui, maptracker_edit: Destroy
	Else If WinExist("ahk_id " vars.hwnd.maptrackernotes_edit.main)
		LLK_Overlay(vars.hwnd.maptrackernotes_edit.main, "destroy")
	Else If WinExist("ahk_id "vars.hwnd.mapinfo.main)
		LLK_Overlay(vars.hwnd.mapinfo.main, "destroy")
	Else If vars.maptracker.loot
		Maptracker_GUI()
	Else If WinExist("ahk_id "vars.hwnd.maptracker_logs.main)
	{
		LLK_Overlay(vars.hwnd.maptracker_logs.main, "hide")
		If !settings.general.dev
			WinActivate, ahk_group poe_window
	}
	Else If WinExist("ahk_id "vars.hwnd.geartracker.main)
		Geartracker_GUI("toggle")
	Else If WinExist("ahk_id " vars.hwnd.searchstrings_context)
	{
		Gui, searchstrings_context: Destroy
		vars.hwnd.Delete("searchstrings_context")
	}
	Else If WinExist("ahk_id " vars.hwnd.omni_context.main)
	{
		Gui, omni_context: Destroy
		vars.hwnd.Delete("omni_context")
	}
	Else If WinExist("ahk_id " vars.hwnd.cheatsheet_calibration.main)
	{
		Gui, cheatsheet_calibration: Destroy
		vars.hwnd.Delete("cheatsheet_calibration")
	}
	Else If WinExist("ahk_id " vars.hwnd.cheatsheet.main)
		Cheatsheet_Close()
	Else If WinExist("ahk_id " vars.hwnd.iteminfo.main) || WinExist("ahk_id " vars.hwnd.iteminfo_markers.1)
		Iteminfo_Close(1)
	Else
	{
		SendInput, {ESC down}
		KeyWait, ESC
		SendInput, {ESC up}
	}
	KeyWait, ESC
}

Hotkeys_RemoveModifiers(hotkey)
{
	local
	global vars, settings

	hotkey0 := hotkey
	Loop, Parse, % "~*#+!^"
		hotkey := StrReplace(hotkey, A_LoopField)

	If Blank(hotkey)
		hotkey := hotkey0
	Return hotkey
}

Hotkeys_Tab()
{
	local
	global vars, settings
	static stash_toggle := 0

	start := A_TickCount
	If WinExist("ahk_id " vars.hwnd.stash.main) && !WinActive("ahk_id " vars.hwnd.settings.main)
	{
		WinActivate, % "ahk_id " vars.hwnd.poe_client
		WinWaitActive, % "ahk_id " vars.hwnd.poe_client
		If !stash_toggle
		{
			Clipboard := """note:"""
			SendInput, ^{f}
			Sleep 100
			SendInput, {DEL}^{v}{ENTER}
		}
		Else
		{
			SendInput, ^{f}
			Sleep 100
			SendInput, {DEL}{ENTER}
		}
		stash_toggle := !stash_toggle
		KeyWait, % vars.hotkeys.tab
		Return
	}

	If settings.features.statlas && LLK_StringCompare(vars.log.areaID, ["hideout"]) && Screenchecks_ImageSearch("atlas")
		While GetKeyState(vars.hotkeys.tab, "P")
			If (A_TickCount >= start + 200)
			{
				If !WinExist("statlas debug") && Statlas()
					Statlas_GUI()
				Else If !WinExist("statlas debug")
					LLK_ToolTip(Lang_Trans("global_fail"),,,,, "Red")

				KeyWait, % vars.hotkeys.tab
				Gui, statlas_comms: Destroy
				LLK_Overlay(vars.hwnd.statlas.main, "destroy"), vars.hwnd.statlas.main := ""
				If (settings.statlas.tier0 != settings.statlas.tier)
					IniWrite, % (settings.statlas.tier0 := settings.statlas.tier), % "ini" vars.poe_version "\statlas.ini", settings, filter tier
				If (settings.statlas.zoom0 != settings.statlas.zoom)
					IniWrite, % (settings.statlas.zoom0 := settings.statlas.zoom), % "ini" vars.poe_version "\statlas.ini", settings, zoom
				Return
			}

	If settings.features.exchange && !vars.hwnd.exchange.main && LLK_StringCompare(vars.log.areaID, ["hideout"]) && Screenchecks_ImageSearch("exchange")
			While GetKeyState(vars.hotkeys.tab, "P")
				If (A_TickCount >= start + 200)
				{
					Exchange()
					KeyWait, % vars.hotkeys.tab
					Return
				}

	While settings.qol.notepad && vars.hwnd.notepad_widgets.Count() && GetKeyState(vars.hotkeys.tab, "P")
		If (A_TickCount >= start + 200)
		{
			active .= " notepad", vars.notepad.toggle := 1
			For key, val in vars.hwnd.notepad_widgets
			{
				Gui, % Gui_Name(val) ": -E0x20"
				WinSet, Transparent, Off, % "ahk_id "val
			}
			Break
		}

	While settings.features.sanctum && InStr(vars.log.areaID, "sanctum") && !InStr(vars.log.areaID, "fellshrine") && GetKeyState(vars.hotkeys.tab, "P")
		If (A_TickCount >= start + 200)
		{
			active .= " sanctum", vars.sanctum.lock := 0
			If !WinExist("ahk_id " vars.hwnd.sanctum.second)
				Sanctum()
			Break
		}

	While settings.general.hide_toolbar && GetKeyState(vars.hotkeys.tab, "P")
		If (A_TickCount >= start + 200)
		{
			active .= " LLK-panel"
			LLK_Overlay(vars.hwnd.LLK_panel.main, "show")
			Break
		}

	While settings.qol.alarm && GetKeyState(vars.hotkeys.tab, "P")
		If (A_TickCount >= start + 200)
		{
			active .= " alarm", vars.alarm.toggle := 1, Alarm()
			Break
		}

	While settings.features.actdecoder && !(settings.qol.lab && InStr(vars.log.areaID, "labyrinth") && !InStr(vars.log.areaID, "_trials_")) && GetKeyState(vars.hotkeys.tab, "P")
		If (A_TickCount >= start + 200)
		{
			vars.actdecoder.tab := 1
			If Actdecoder_ZoneLayouts()
				active .= " actdecoder"
			Else vars.actdecoder.tab := 0
			Break
		}

	While settings.features.leveltracker && !(settings.qol.lab && InStr(vars.log.areaID, "labyrinth") && !InStr(vars.log.areaID, "_trials_")) && GetKeyState(vars.hotkeys.tab, "P")
		If (A_TickCount >= start + 200)
		{
			active .= " leveltracker", vars.leveltracker.overlays := 1, Leveltracker_Hints()
			Break
		}

	map := vars.mapinfo.active_map
	While settings.features.mapinfo && settings.mapinfo.tabtoggle && map.name && GetKeyState(vars.hotkeys.tab, "P")
	&& (LLK_HasVal(vars.mapinfo.categories, vars.log.areaname, 1) || (InStr(map.name, vars.log.areaname) || vars.poe_version && LLK_StringCompare(vars.log.areaID, ["map"])) || LLK_StringCompare(vars.log.areaID, ["hideout"]) || InStr(vars.log.areaID, "heisthub") || InStr(map.english, "invitation") && LLK_PatternMatch(vars.log.areaID, "", ["MavenHub", "PrimordialBoss"]))
		If (A_TickCount >= start + 200)
		{
			active .= " mapinfo", vars.mapinfo.toggle := 1, Mapinfo_GUI(2)
			Break
		}

	While settings.features.maptracker && !vars.maptracker.pause && Maptracker_Check(2) && GetKeyState(vars.hotkeys.tab, "P")
		If (A_TickCount >= start + 200)
		{
			vars.maptracker.toggle := 1, active .= " maptracker", Maptracker_GUI()
			If settings.maptracker.mechanics
				SetTimer, Maptracker_MechanicsCheck, -1
			Break
		}

	While settings.qol.lab && InStr(vars.log.areaID, "labyrinth") && !InStr(vars.log.areaID, "_trials") && GetKeyState(vars.hotkeys.tab, "P")
		If (A_TickCount >= start + 200)
		{
			active .= " lab", vars.lab.toggle := 1, Lab()
			Break
		}

	If !active && settings.features.leveltracker && !settings.leveltracker.pobmanual && !Screenchecks_PixelSearch("gamescreen") && Screenchecks_ImageSearch("skilltree") && !(settings.general.dev && WinActive("ahk_exe Code.exe"))
	&& !GetKeyState("ALT", "P")
	{
		If !vars.leveltracker.skilltree_schematics.GUI
			Leveltracker_PobSkilltree()
		Else Leveltracker_PobSkilltree("close")
		Return
	}

	If !settings.hotkeys.tabblock && !active
	{
		SendInput, % "{" vars.hotkeys.tab " DOWN}"
		KeyWait, % vars.hotkeys.tab
		SendInput, % "{" vars.hotkeys.tab " UP}"
	}
	Else KeyWait, % vars.hotkeys.tab

	If longpress
		Leveltracker_PobSkilltree("close")
	If InStr(active, "sanctum") && !vars.sanctum.lock && !vars.sanctum.scanning
		Sanctum("close")
	If InStr(active, "LLK-panel") && settings.general.hide_toolbar
		LLK_Overlay(vars.hwnd.LLK_panel.main, "hide")
	If InStr(active, "alarm")
	{
		vars.alarm.toggle := 0
		LLK_Overlay(vars.hwnd.alarm.main, "destroy")
	}
	If InStr(active, "notepad")
	{
		vars.notepad.toggle := 0
		For key, val in vars.hwnd.notepad_widgets
		{
			Gui, % Gui_Name(val) ": +E0x20"
			WinSet, Transparent, % (key = "notepad_reminder_feature") ? 250 : 50 * settings.notepad.trans, % "ahk_id "val
		}
	}
	If InStr(active, "actdecoder")
	{
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
	If InStr(active, "leveltracker")
		vars.leveltracker.overlays := 0
	If InStr(active, "mapinfo")
		LLK_Overlay(vars.hwnd.mapinfo.main, "destroy"), vars.mapinfo.toggle := 0
	If InStr(active, "maptracker")
		vars.maptracker.toggle := 0, LLK_Overlay(vars.hwnd.maptracker.main, "hide")
	If InStr(active, " lab") && WinExist("ahk_id "vars.hwnd.lab.main)
		LLK_Overlay(vars.hwnd.lab.main, "destroy"), LLK_Overlay(vars.hwnd.lab.button, "destroy"), vars.lab.toggle := 0
	;If vars.hwnd.alarm.alarm_set.main && WinExist("ahk_id " vars.hwnd.alarm.alarm_set.main)
	;	WinActivate, % "ahk_id " vars.hwnd.alarm.alarm_set.main
	;Else If active && !settings.general.dev
	If active && !settings.general.dev
		WinActivate, ahk_group poe_window
}

;pre-defined contexts for hotkey command
#If settings.maptracker.kills && settings.features.maptracker && (vars.maptracker.refresh_kills = 1)
#If WinExist("ahk_id "vars.hwnd.horizons.main)
#If vars.hwnd.leveltracker.main && WinActive("ahk_group poe_ahk_window") && WinExist("ahk_id " vars.hwnd.leveltracker.main)
#If (settings.features.iteminfo && !settings.iteminfo.omnikey || settings.features.mapinfo && !settings.mapinfo.omnikey || settings.features.anoints) && WinActive("ahk_id " vars.hwnd.poe_client)
#If (vars.log.areaID = vars.maptracker.map.id) && settings.features.maptracker && settings.maptracker.mechanics && settings.maptracker.portal_reminder && vars.maptracker.map.content.Count() && WinActive("ahk_id " vars.hwnd.poe_client)
#If vars.leveltracker.skilltree_schematics.GUI && WinActive("ahk_group poe_ahk_window")

#If vars.hwnd.exchange.main && WinExist("ahk_id " vars.hwnd.exchange.main)
~SC0038::Exchange("hide")

#If vars.hwnd.leveltracker_gemcutting.main && WinExist("ahk_id " vars.hwnd.leveltracker_gemcutting.main)
~SC0038::Leveltracker_PobGemCutting("hide")

#If vars.hwnd.exchange.main && (vars.general.wMouse = vars.hwnd.exchange.main)
*WheelUp::Exchange("hotkey", "WheelUp")
*WheelDown::Exchange("hotkey", "WheelDown")

#If vars.hwnd.exchange.main && Exchange_coords() && WinExist("ahk_id " vars.hwnd.exchange.main) && (WinActive("ahk_id " vars.hwnd.exchange.main) || WinActive("ahk_id " vars.hwnd.poe_client))
~LButton::Exchange2("LButton")
~RButton::Exchange2("RButton")
SC0039::Exchange2("Space")

#If vars.hwnd.anoints.main && (vars.general.wMouse = vars.hwnd.anoints.main) && IsNumber(SubStr(LLK_HasVal(vars.hwnd.anoints, vars.general.cMouse), 1, 1))
WheelUp::Anoints("stock+")
WheelDown::Anoints("stock-")

#If vars.hwnd.statlas.main && (vars.general.cMouse = vars.hwnd.statlas.tier)
WheelUp::Statlas_GUI("tier_plus")
WheelDown::Statlas_GUI("tier_minus")

#If vars.hwnd.statlas.main
WheelUp::Statlas_GUI("zoom_plus")
WheelDown::Statlas_GUI("zoom_minus")

#If vars.hwnd.leveltracker_editor.main && (vars.general.wMouse = vars.hwnd.leveltracker_editor.main)
WheelUp::
WheelDown::Leveltracker_GuideEditor(A_ThisHotkey)

#If vars.hwnd.stash.main && WinExist("ahk_id " vars.hwnd.stash.main) && InStr(vars.stash.hover, "tab_")
*~LButton::Stash(StrReplace(vars.stash.hover, "tab_"))

#If vars.hwnd.stash.main && WinExist("ahk_id " vars.hwnd.stash.main) && IsObject(vars.stash.regex)
&& LLK_IsBetween(vars.general.xMouse, vars.client.x + vars.stash.regex.x, vars.client.x + vars.stash.regex.x + vars.stash.regex.w)
&& LLK_IsBetween(vars.general.yMouse, vars.client.y + vars.stash.regex.y, vars.client.y + vars.stash.regex.y + vars.stash.regex.h)
LButton::Stash_Hotkeys("regex")

#If !vars.general.drag && vars.hwnd.leveltracker_gemlinks.main && WinExist("ahk_id " vars.hwnd.leveltracker_gemlinks.main)
WheelUp::Leveltracker_PobGemLinks("hotkey1")
WheelDown::Leveltracker_PobGemLinks("hotkey2")

#If vars.leveltracker.skilltree_schematics.GUI && WinExist("ahk_id " vars.hwnd.skilltree_schematics.main)
&& !(vars.general.cMouse && InStr(vars.hwnd.skilltree_schematics.color_1bar "," vars.hwnd.skilltree_schematics.color_2bar, vars.general.cMouse))
&& !(settings.general.dev && WinActive("ahk_exe Code.exe"))
RButton::Leveltracker_PobSkilltree("drag")
SC002::Leveltracker_PobSkilltree("ascendancy 1")
SC003::Leveltracker_PobSkilltree("ascendancy 2")
SC004::Leveltracker_PobSkilltree("ascendancy 3")
SC005::Leveltracker_PobSkilltree("ascendancy 4")
SC010::Leveltracker_PobSkilltree("prev")
SC012::Leveltracker_PobSkilltree("next")
SC011::Leveltracker_PobSkilltree("overview")
SC038::Leveltracker_PobSkilltree("hide")
MButton::Leveltracker_PobSkilltree("reset")

#If settings.features.sanctum && vars.sanctum.active && WinExist("ahk_id " vars.hwnd.sanctum.second) && !vars.sanctum.lock ;last condition needed to make the space-key usable again after initial lock
*SC039::Sanctum("lock")

#If settings.features.sanctum && vars.sanctum.active && WinExist("ahk_id " vars.hwnd.sanctum.second)
*SC038::Sanctum("trans")

#If settings.features.sanctum && vars.sanctum.active && WinExist("ahk_id " vars.hwnd.sanctum.main) && (vars.general.wMouse = vars.hwnd.sanctum.main) && vars.general.cMouse && (check := LLK_HasVal(vars.hwnd.sanctum, vars.general.cMouse))
*LButton::Sanctum_Mark(SubStr(check, InStr(check, "_") + 1), 1)
*RButton::Sanctum_Mark(SubStr(check, InStr(check, "_") + 1), 2)
*MButton::Sanctum_Mark(SubStr(check, InStr(check, "_") + 1), 3, 1)

#If vars.hwnd.sanctum_relics.main && LLK_IsBetween(vars.general.xMouse, vars.sanctum.relics.coords.mouse3.x.1, vars.sanctum.relics.coords.mouse3.x.2) && LLK_IsBetween(vars.general.yMouse, vars.sanctum.relics.coords.mouse3.y.1, vars.sanctum.relics.coords.mouse3.y.2)
~LButton::Sanctum_Relics("close")

#If vars.hwnd.sanctum_relics.main && LLK_IsBetween(vars.general.xMouse, vars.sanctum.relics.coords.mouse.x.1, vars.sanctum.relics.coords.mouse.x.2) && LLK_IsBetween(vars.general.yMouse, vars.sanctum.relics.coords.mouse.y.1, vars.sanctum.relics.coords.mouse.y.2)
RButton::Sanctum_RelicsClick()

#If vars.hwnd.sanctum_relics.main && vars.general.cMouse && (vars.general.wMouse = vars.hwnd.sanctum_relics.main)
LButton::
RButton::Sanctum_Relics("click")

#If vars.hwnd.sanctum_relics.main
*~SC038::Sanctum_Relics("trans")

#If vars.hwnd.stash_picker.main && vars.general.cMouse && WinExist("ahk_id " vars.hwnd.stash_picker.main) && LLK_PatternMatch(LLK_HasVal(vars.hwnd.stash_picker, vars.general.cMouse), "", ["confirm_", "bulk"])
WheelUp::Stash_PricePicker("+")
WheelDown::Stash_PricePicker("-")
MButton::Stash_PricePicker("reset")

#If vars.hwnd.stash.main && WinActive("ahk_id " vars.hwnd.poe_client) && WinExist("ahk_id " vars.hwnd.stash.main)
*SC002::Stash_Hotkeys(1)
*SC003::Stash_Hotkeys(2)
*SC004::Stash_Hotkeys(3)
*SC005::Stash_Hotkeys(4)
*SC006::Stash_Hotkeys(5)
~+LButton::Stash_Hotkeys("LButton")
~RButton::Stash_Hotkeys("RButton")

#If vars.hwnd.stash.main && vars.stash.hover && !InStr(vars.stash.hover, "tab_") && WinActive("ahk_id " vars.hwnd.poe_client) && WinExist("ahk_id " vars.hwnd.stash.main)
SC039::Stash_Hotkeys("Space")
SC038::Stash_Hotkeys("LAlt")

#If WinActive("ahk_id " vars.hwnd.poe_client) && vars.stash.enter
~*SC01C::vars.stash.enter := 0, Stash_PricePicker("destroy")

#If vars.general.wMouse && (vars.general.wMouse = vars.hwnd.ClientFiller) ;prevent clicking and activating the filler GUI
*MButton::
*LButton::
*RButton::Return

#If vars.OCR.GUI ;sending inputs for screen-reading
*WheelUp::vars.OCR.wGUI += ((vars.OCR.wGUI + 30) * 2 >= vars.client.w || (vars.OCR.hGUI + 15) * 2 >= vars.client.h) ? 0 : 30, vars.OCR.hGUI += ((vars.OCR.wGUI + 30) * 2 >= vars.client.w || (vars.OCR.hGUI + 15) * 2 >= vars.client.h) ? 0 : 15
*WheelDown::vars.OCR.wGUI -= (vars.OCR.wGUI - 30 >= vars.client.h / 10 + 30 && vars.OCR.hGUI - 15 >= vars.client.h / 10 + 15) ? 30 : 0, vars.OCR.hGUI -= (vars.OCR.wGUI - 30 >= vars.client.h / 10 + 30 && vars.OCR.hGUI - 15 >= vars.client.h / 10 + 15) ? 15 : 0

#If vars.hwnd.ocr_tooltip.main && vars.general.wMouse && (vars.general.wMouse = vars.hwnd.ocr_tooltip.main) ;hovering over the ocr tooltip
*LButton::OCR_Close()
*SC039::OCR_Highlight("space")
*SC002::OCR_Highlight(1)
*SC003::OCR_Highlight(2)
*SC004::OCR_Highlight(3)
*SC005::OCR_Highlight(4)
*SC006::OCR_Highlight(5)

#If vars.snipping_tool.GUI && WinActive("ahk_id " vars.hwnd.snipping_tool.main)
*SC011::Screenchecks_ImageRecalibrate("w")
*SC01E::Screenchecks_ImageRecalibrate("a")
*SC01F::Screenchecks_ImageRecalibrate("s")
*SC020::Screenchecks_ImageRecalibrate("d")
SC039::Screenchecks_ImageRecalibrate("space")
LButton::Screenchecks_ImageRecalibrate("LButton")
RButton::Screenchecks_ImageRecalibrate("RButton")

#If vars.hwnd.ocr_tooltip.main && WinExist("ahk_id " vars.hwnd.ocr_tooltip.main)
~SC02A::
~SC02A UP::
WinSet, TransColor, % "Purple " (InStr(A_ThisHotkey, "UP") ? "255" : 0), % "ahk_id " vars.hwnd.ocr_tooltip.main
Return

#If !vars.mapinfo.toggle && (vars.system.timeout = 0) && (vars.general.wMouse = vars.hwnd.poe_client) && WinExist("ahk_id "vars.hwnd.mapinfo.main) ;clicking the client to hide the map-info tooltip

LButton::LLK_Overlay(vars.hwnd.mapinfo.main, "destroy")

#If (vars.system.timeout = 0) && vars.general.wMouse && !Blank(LLK_HasVal(vars.hwnd.lab, vars.general.wMouse)) && vars.general.cMouse && !Blank(LLK_HasVal(vars.hwnd.lab, vars.general.cMouse)) ;hovering the lab-layout button and clicking a room

*LButton::Lab("override")
*RButton::Return

#If (vars.system.timeout = 0) && vars.general.wMouse && (LLK_HasVal(vars.hwnd.lab, vars.general.wMouse) = "button") ;hovering the lab-layout button and clicking it

*LButton::Lab("link")
*RButton::Return

#If (vars.system.timeout = 0) && vars.general.wMouse && !Blank(LLK_HasVal(vars.hwnd.lab, vars.general.wMouse)) && vars.general.cMouse && Blank(LLK_HasVal(vars.hwnd.lab, vars.general.cMouse))

*LButton::Return
*RButton::Return

#If vars.hwnd.notepad.main && (vars.general.cMouse = vars.hwnd.notepad.note) && WinActive("ahk_id " vars.hwnd.notepad.main)
*RButton::Notepad("color")

#If (vars.system.timeout = 0) && vars.general.wMouse && (vars.general.wMouse = vars.hwnd.LLK_panel.main)

*LButton::Gui_ToolbarButtons(vars.general.cMouse, 1)
*RButton::Gui_ToolbarButtons(vars.general.cMouse, 2)

#If (vars.system.timeout = 0) && vars.general.wMouse && !Blank(LLK_HasVal(vars.hwnd.notepad_widgets, vars.general.wMouse)) ;hovering a notepad-widget and dragging or deleting it

*LButton::Notepad_Widget(LLK_HasVal(vars.hwnd.notepad_widgets, vars.general.wMouse), 1)
*RButton::Notepad_Widget(LLK_HasVal(vars.hwnd.notepad_widgets, vars.general.wMouse), 2)
*WheelUp::Notepad_Widget(LLK_HasVal(vars.hwnd.notepad_widgets, vars.general.wMouse), 3)
*WheelDown::Notepad_Widget(LLK_HasVal(vars.hwnd.notepad_widgets, vars.general.wMouse), 4)

#If (vars.system.timeout = 0) && vars.actdecoder.tab && vars.general.cMouse && !Blank(LLK_HasVal(vars.hwnd.actdecoder, vars.general.cMouse)) ;hovering the act-decoder overlay and clicking elements

*LButton::Actdecoder_ZoneLayouts(0, 1, vars.general.cMouse)
*RButton::Actdecoder_ZoneLayouts(0, 2, vars.general.cMouse)

#If (vars.system.timeout = 0) && (vars.general.wMouse = vars.hwnd.maptracker.main) && !Blank(LLK_HasVal(vars.hwnd.maptracker, vars.general.cMouse)) ;hovering the maptracker-panel and clicking valid elements

*LButton::Maptracker(vars.general.cMouse, 1)
*RButton::Maptracker(vars.general.cMouse, 2)

#If (vars.system.timeout = 0) && (vars.general.wMouse = vars.hwnd.maptracker.main) ;prevent clicking the maptracker-panel (and losing focus of the game-client) if not hovering valid elements
*LButton::
*RButton::Return

#If (vars.system.timeout = 0) && (vars.general.wMouse = vars.hwnd.leveltracker.controls1) && !Blank(LLK_HasVal(vars.hwnd.leveltracker, vars.general.cMouse)) ;hovering the leveltracker-controls and clicking

*LButton::Leveltracker(vars.general.cMouse, 1)
*RButton::Leveltracker(vars.general.cMouse, 2)

#If (vars.system.timeout = 0) && (vars.general.wMouse = vars.hwnd.alarm.main) && !Blank(LLK_HasVal(vars.hwnd.alarm, vars.general.cMouse)) ;hovering the alarm-timer and clicking

*LButton::Alarm(1, vars.general.cMouse)
*RButton::Alarm(2, vars.general.cMouse)

#If (vars.system.timeout = 0) && (vars.general.wMouse = vars.hwnd.alarm.alarm_set.main) && vars.general.cMouse && InStr(vars.hwnd.alarm.alarm_set.start "," vars.hwnd.alarm.alarm_set.cancel, vars.general.cMouse)

*LButton::Alarm("alarm_set", vars.general.cMouse)

#If (vars.system.timeout = 0) && ((vars.general.wMouse = vars.hwnd.mapinfo.main) && !Blank(LLK_HasVal(vars.hwnd.mapinfo, vars.general.cMouse)) || (vars.general.wMouse = vars.hwnd.settings.main) && InStr(LLK_HasVal(vars.hwnd.settings, vars.general.cMouse), "mapmod_")) ;ranking map-mods

*SC002::Mapinfo_Rank(1)
*SC003::Mapinfo_Rank(2)
*SC004::Mapinfo_Rank(3)
*SC005::Mapinfo_Rank(4)
*SC039::Mapinfo_Rank("Space")
*RButton::Mapinfo_Rank(0)

#If (vars.system.timeout = 0) && settings.maptracker.loot && (vars.general.xMouse > vars.monitor.x + vars.monitor.w/2) ;ctrl-clicking loot into stash and logging it

~*^LButton::Maptracker_Loot()
^RButton::Maptracker_Loot("back")

#If !(vars.general.wMouse && !Blank(LLK_HasVal(vars.hwnd.notepad_widgets, vars.general.wMouse))) && vars.actdecoder.tab ;resizing the act-decoder overlay

SC039::
MButton::
WheelUp::
WheelDown::Actdecoder_ZoneLayoutsSize(A_ThisHotkey)

#If settings.leveltracker.pobmanual && settings.leveltracker.pob && WinActive("ahk_exe Path of Building.exe") && !WinExist("ahk_id " vars.hwnd.leveltracker_screencap.main) ;opening the screen-cap menu via m-clicking in PoB

MButton::Leveltracker_ScreencapMenu()

#If (vars.tooltip_mouse.name = "searchstring") ;scrolling through sub-strings in search-strings

SC001::
WheelUp::
WheelDown::String_Scroll(A_ThisHotkey)

#If (vars.system.timeout = 0) && settings.features.iteminfo && vars.general.wMouse && (vars.general.wMouse = vars.hwnd.iteminfo.main) && WinActive("ahk_group poe_ahk_window") ;applying highlighting to item-mods in the item-info tooltip

*LButton::
*RButton::
If vars.general.cMouse && !Blank(LLK_HasVal(vars.hwnd.iteminfo, vars.general.cMouse)) ;this check prevents the tooltip from being clicked/activated (since the L/RButton press is not sent to the client)
	Iteminfo_HighlightApply(vars.general.cMouse)
Else If vars.general.cMouse && !Blank(LLK_HasVal(vars.hwnd.iteminfo.inverted_mods, vars.general.cMouse))
	Iteminfo_ModInvert(vars.general.cMouse)
Return

#If (settings.features.iteminfo && settings.iteminfo.trigger || settings.features.mapinfo && settings.mapinfo.trigger) && vars.general.shift_trigger && (vars.general.wMouse = vars.hwnd.poe_client) ;shift-clicking currency onto items and triggering certain features

~+LButton UP::Iteminfo_Trigger(1)
+RButton::Iteminfo_Marker()

#If (settings.features.iteminfo && settings.iteminfo.trigger || settings.features.mapinfo && settings.mapinfo.trigger) && !vars.general.shift_trigger && (vars.general.wMouse = vars.hwnd.poe_client) && Screenchecks_PixelSearch("inventory")
;shift-right-clicking currency to shift-click items after

~+RButton UP::Iteminfo_Trigger()

#If vars.hwnd.searchstrings_context && WinExist("ahk_id " vars.hwnd.searchstrings_context) && (vars.general.wMouse = vars.hwnd.poe_client) ;closing the search-strings context menu when clicking into the client

~LButton::
Gui, searchstrings_context: Destroy
vars.hwnd.Delete("searchstrings_context")
Return

#If vars.hwnd.omni_context.main && WinExist("ahk_id " vars.hwnd.omni_context.main) && (vars.general.wMouse = vars.hwnd.poe_client) ;closing the omni-key context menu when clicking into the client

~LButton::
Gui, omni_context: destroy
vars.hwnd.Delete("omni_context")
Return

#If (vars.hwnd.iteminfo.main && WinExist("ahk_id " vars.hwnd.iteminfo.main) || vars.hwnd.iteminfo_markers.1 && WinExist("ahk_id " vars.hwnd.iteminfo_markers.1)) && (vars.general.wMouse = vars.hwnd.poe_client)
;closing the item-info tooltip and its markers when clicking into the client
~LButton::Iteminfo_Close(1)

#If (vars.system.timeout = 0) && settings.features.iteminfo && vars.general.wMouse && !Blank(LLK_HasVal(vars.hwnd.iteminfo_comparison, vars.general.wMouse)) ;long-clicking the gear-update buttons on gear-slots in the inventory to update/remove selected gear

LButton::
RButton::Iteminfo_GearParse(LLK_HasVal(vars.hwnd.iteminfo_comparison, vars.general.wMouse))

#If vars.cloneframes.editing && vars.general.cMouse && !Blank(LLK_HasVal(vars.cloneframes.scroll, vars.general.cMouse))

*WheelUp::
*WheelDown::Cloneframes_SettingsApply(vars.general.cMouse, A_ThisHotkey)

#If (vars.general.wMouse != vars.hwnd.settings.main) && WinExist("LLK-UI: Clone-Frames Borders") ;moving clone-frame borders via clicks

*LButton::
*RButton::
*MButton::Cloneframes_Snap(LTrim(A_ThisHotkey, "~*"))

#If WinActive("ahk_id "vars.hwnd.snip.main) ;moving the snip-widget via arrow keys

SC001::snipGuiClose()
*Up::
*Down::
*Left::
*Right::SnippingToolMove()

#If vars.cheatsheets.tab && vars.hwnd.cheatsheet.main && WinExist("ahk_id " vars.hwnd.cheatsheet.main) ;clearing the cheatsheet quick-access (unused atm)

SC039::
Gui, cheatsheet: Destroy
vars.hwnd.Delete("cheatsheet")
vars.cheatsheets.active := ""
KeyWait, SC039
Return

#If vars.general.wMouse && vars.hwnd.cheatsheet.main && (vars.general.wMouse = vars.hwnd.cheatsheet.main) && (vars.cheatsheets.active.type = "advanced") ;ranking things in advanced cheatsheets

*SC002::Cheatsheet_Rank(1)
*SC003::Cheatsheet_Rank(2)
*SC004::Cheatsheet_Rank(3)
*SC005::Cheatsheet_Rank(4)
SC039::Cheatsheet_Rank("space")

#If vars.general.wMouse && vars.hwnd.betrayal_info.main && (vars.general.wMouse = vars.hwnd.betrayal_info.main) ;ranking betrayal rewards

SC002::Betrayal_Rank(1)
SC003::Betrayal_Rank(2)
SC004::Betrayal_Rank(3)
SC039::Betrayal_Rank("Space")

#If (vars.cheatsheets.active.type = "image") && vars.hwnd.cheatsheet.main && !vars.cheatsheets.tab && WinExist("ahk_id " vars.hwnd.cheatsheet.main) ;image-cheatsheet hotkeys

WheelDown::
SC03B::Cheatsheet_Image("", "F1")
WheelUp::
SC03C::Cheatsheet_Image("", "F2")
MButton::
SC03D::Cheatsheet_Image("", "F3")
SC039::Cheatsheet_Image("", "space")
SC002::Cheatsheet_Image("", 1)
SC003::Cheatsheet_Image("", 2)
SC004::Cheatsheet_Image("", 3)
SC005::Cheatsheet_Image("", 4)
SC006::Cheatsheet_Image("", 5)
SC007::Cheatsheet_Image("", 6)
SC008::Cheatsheet_Image("", 7)
SC009::Cheatsheet_Image("", 8)
SC00A::Cheatsheet_Image("", 9)
SC00B::Cheatsheet_Image("", 0)
Up::
Down::
Left::
Right::
RButton::
SC01E::
SC030::
SC02E::
SC020::
SC012::
SC021::
SC022::
SC023::
SC017::
SC024::
SC025::
SC026::
SC032::
SC031::
SC018::
SC019::
SC010::
SC013::
SC01F::
SC014::
SC016::
SC02F::
SC011::
SC02D::
SC02C::
SC015::Cheatsheet_Image("", A_ThisHotkey)

#IfWinActive ahk_group poe_window

#IfWinActive ahk_group poe_ahk_window

SC001::Hotkeys_ESC()

#If
