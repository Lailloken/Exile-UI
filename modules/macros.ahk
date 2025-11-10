Init_macros()
{
	local
	global vars, settings

	If !FileExist("ini" vars.poe_version "\chat macros.ini")
		IniWrite, % "", % "ini" vars.poe_version "\chat macros.ini", settings

	If !IsObject(settings.macros)
		settings.macros := {}
	ini := IniBatchRead("ini" vars.poe_version "\chat macros.ini")

	settings.macros.sMenu := !Blank(check := ini.settings["widget-menu size"]) ? check : Max(settings.general.fSize, 10)
	settings.macros.animations := !Blank(check := ini.settings.animations) ? check : 1
	settings.macros.hotkey_fasttravel := hotkey_fasttravel := !Blank(check := ini.settings["fasttravel hotkey"]) ? check : ""
	If !Blank(hotkey_fasttravel) && Hotkeys_Convert(hotkey_fasttravel)
	{
		Hotkey, IfWinActive, ahk_group poe_ahk_window
		Hotkey, % Hotkeys_Convert(hotkey_fasttravel), Macro_FastTravel, On
	}

	settings.macros.hotkey_custommacros := hotkey_custommacros := !Blank(check := ini.settings["custommacros hotkey"]) ? check : ""
	If !Blank(hotkey_custommacros) && Hotkeys_Convert(hotkey_custommacros)
	{
		Hotkey, IfWinActive, ahk_group poe_ahk_window
		Hotkey, % Hotkeys_Convert(hotkey_custommacros), Macro_CustomMacros, On
	}

	settings.macros.label_0 := "", settings.macros.enable_0 := !Blank(check := ini.macros["enable 0"]) ? check : 1
	settings.macros.command_0 := !Blank(check := ini.macros["command 0"]) ? (check = "blank" ? "" : check) : "/exit"
	Loop 8
		settings.macros["command_" A_Index] := !Blank(check := ini.macros["command " A_Index]) ? (check = "blank" ? "" : check) : (A_Index = 1 ? "/dnd" : "")
		, settings.macros["label_" A_Index] := !Blank(check := ini.macros["label " A_Index]) ? (check = "blank" ? "" : check) : (A_Index = 1 ? "dnd" : "")
		, settings.macros["enable_" A_Index] := !Blank(check := ini.macros["enable " A_Index]) ? check : 1

	If !IsObject(vars.macros)
		vars.macros := {}
	For index, val in (vars.macros.fasttravels := (!vars.poe_version ? ["kingsmarch", "monastery", "menagerie", "heist", "sanctum", "delve", "guild"] : ["guild"]))
		settings.macros[val] := !Blank(check := ini.settings["enable " val]) ? check : 1
}

Macro_CustomMacros(cHWND := "", mode := "", hotkey := 1)
{
	local
	global vars, settings

	If (A_TickCount < vars.radial.last + 250)
		Return
	start := A_TickCount
	While !longpress && (GetKeyState(settings.macros.hotkey_custommacros, "P") || GetKeyState(Hotkeys_Convert(settings.macros.hotkey_custommacros), "P"))
		If (A_TickCount >= start + 250)
			longpress := 1
		Else Sleep 25

	If !IsObject(mode) && !longpress
		mode := (settings.macros.enable_0 ? {"check": 0} : "")
	Else If !IsObject(mode)
	{
		selection := {5: "settings"}, added := 1
		Loop 8
			If !settings.macros["enable_" A_Index] || Blank(settings.macros["label_" A_Index])
				Continue
			Else selection[vars.radial.order[added]] := A_Index, added += 1
		vars.radial.active := "custommacros", Gui_RadialMenu(selection)

		KeyWait, % settings.macros.hotkey_custommacros
		KeyWait, % Hotkeys_Convert(settings.macros.hotkey_custommacros)
		vars.radial.last := A_TickCount
		Return
	}

	If (mode.check = "settings")
		Settings_menu("macros")
	Else If !Blank(mode.check)
	{
		KeyWait, LButton
		Clipboard := settings.macros["command_" mode.check]
		ClipWait, 0.1
		WinActivate, % "ahk_id " vars.hwnd.poe_client
		WinWaitActive, % "ahk_id " vars.hwnd.poe_client,, 2
		If !ErrorLevel && !Blank(Clipboard)
			SendInput, {ENTER}^v{ENTER}
	}
}

Macro_FastTravel(cHWND := "", mode := "", hotkey := 1)
{
	local
	global vars, settings

	If (A_TickCount < vars.radial.last + 250)
		Return
	start := A_TickCount
	While !longpress && (GetKeyState(settings.macros.hotkey_fasttravel, "P") || GetKeyState(Hotkeys_Convert(settings.macros.hotkey_fasttravel), "P"))
		If (A_TickCount >= start + 250)
			longpress := 1
		Else Sleep 25

	If !IsObject(mode) && !longpress
		mode := {"check": "hideout"}
	Else If !IsObject(mode)
	{
		selection := {5: "settings"}, added := 1
		For index, travel in vars.macros.fasttravels
			If !settings.macros[travel]
				Continue
			Else selection[vars.radial.order[added]] := travel, added += 1
		vars.radial.active := "fasttravel", Gui_RadialMenu(selection)

		KeyWait, % settings.macros.hotkey_fasttravel
		KeyWait, % Hotkeys_Convert(settings.macros.hotkey_fasttravel)
		vars.radial.last := A_TickCount
		Return
	}

	If (mode.check = "settings")
		Settings_menu("macros")
	Else If mode.check
	{
		KeyWait, LButton
		Clipboard := "/" mode.check
		ClipWait, 0.1
		WinActivate, % "ahk_id " vars.hwnd.poe_client
		WinWaitActive, % "ahk_id " vars.hwnd.poe_client,, 2
		If !ErrorLevel
			SendInput, {ENTER}^v{ENTER}
	}
}
