Init_notifications()
{
	local
	global vars, settings

	vars.notifications := {}, ini := IniBatchRead("ini" vars.poe_version "\notifications.ini")
	settings.notifications := {"events": {}, "features": {}, "fSize": !Blank(check := ini.settings["font-size"]) ? check : settings.general.fSize * 2}
	settings.notifications.event_list := (vars.poe_version? [] : ["graftblood", "infamous", "hideout"])
	settings.notifications.event_list2 := ["lootfilter", "updater"]
	LLK_FontDimensions(settings.notifications.fSize, font_height, font_width), settings.notifications.fHeight := font_height, settings.notifications.fWidth := font_width
	settings.notifications.color := !Blank(check := ini.settings["font-color"]) ? check : "FF0000"
	settings.notifications.color1 := !Blank(check := ini.settings["background color"]) ? check : "FFFFFF"
	settings.notifications.duration := !Blank(check := ini.settings.duration) ? check : 5
	settings.notifications.opacity := !Blank(check := ini.settings.opacity) ? check : 5
	settings.notifications.position := !Blank(check := ini.settings.position) ? check : 1
	For i, v in ["", 2]
		For index, val in settings.notifications["event_list" v]
			key := (i = 1 ? "events" : "features"), settings.notifications[key][val] := !Blank(check := ini[key][val]) ? check : 0
			, settings.notifications["color_" val] := !Blank(check := ini.settings["text-color " val]) ? check : (i = 1 ? "FF0000" : "0000FF")
			, settings.notifications["color1_" val] := !Blank(check := ini.settings["background-color " val]) ? check : "FFFFFF"
	Loop 3
		settings.notifications.events["hideout_t" A_Index] := !Blank(check := ini.events["hideout T" A_Index]) ? check : 1
}

Notification(type := "")
{
	local
	global vars, settings
	static height

	If !type
	{
		type := "hideout", tier := vars.notifications.hideout.tier
		If (vars.log.areaID != vars.notifications.hideout.ID || vars.log.areaseed != vars.notifications.hideout.seed)
		{
			vars.notifications.hideout := {}
			Return
		}
	}
	If !(notification_type := (LLK_HasVal(settings.notifications.event_list, type) ? "events" : (LLK_HasVal(settings.notifications.event_list2, type) ? "features" : "")))
		Return

	text := Lang_Trans((notification_type = "events" ? "mechanic_" : "notification_") . type), color := settings.notifications["color_" type], background := settings.notifications["color1_" type]
	position := settings.notifications.position, text := (position > 2 ? StrReplace(text, " ", "`n",, 1) : text)

	If (type = "hideout")
		text .= " (" Lang_Trans("global_tiers", tier) ")"
	LLK_ToolTip(text, settings.notifications.duration, 10000, 10000, "notifications_" type, color, settings.notifications.fSize, (position = 4 ? "Right" : ""), settings.notifications.opacity * 51,, background)
	WinGetPos,,, Width, Height, % "ahk_id" vars.hwnd["tooltip_notifications_" type]
	count := LLK_HasKey(vars.hwnd, "tooltip_notifications_", 1,, 1).Count()

	Switch position
	{
		case 1:
		xPos := vars.monitor.x + vars.client.xc - Width/2, yPos := vars.client.y + (count - 1) * height - (count - 1)
		case 2:
		xPos := vars.monitor.x + vars.client.xc - Width/2, yPos := vars.client.y + vars.client.h - count * height + (count - 1)
		case 3:
		xPos := vars.client.x, yPos := vars.monitor.y + vars.client.yc - Height/2 + (count - 1) * height - (count - 1)
		case 4:
		xPos := vars.client.x + vars.client.w - Width, yPos := vars.monitor.y + vars.client.yc - Height/2 + (count - 1) * height - (count - 1)
	}
	Gui, % "tooltipnotifications_" type ": Show", % "NA x" xPos " y" yPos
}

Notification_Hideout(ID, seed)
{
	local
	global vars, settings
	static hideouts := {"mapworldsterrace": 1, "mapworldshauntedmansion": 1, "mapworldsmoontemple": 1, "mapworldstorturechamber": 1, "mapworldsdig": 1, "mapworldscrimsontemple": 1, "mapworldssunkencity": 1
	, "mapworldssummit": 2, "mapworldstower": 2, "mapworldsiceberg": 2, "mapworldsorchard": 2
	, "mapworldsarcade": 3, "mapworldspromenade": 3, "mapworldsatoll": 3, "mapworldsmoontempleunique": 3, "mapworldsacademy": 3, "mapworldsivorytemple": 3, "mapworldsgraveyard": 3}

	If !((tier := hideouts[ID]) && settings.notifications["hideout_t" tier])
		Return
	vars.notifications.hideout := {"ID": ID, "seed": seed, "tier": tier}
	SetTimer, Notification, -10000
}

Notification_InfamousMerc(clientTXT_line)
{
	local
	global vars, settings, json
	static FirstApproach

	If !IsObject(FirstApproach)
	{
		lang := FileExist("data\" settings.general.lang_client "\mercenaries.json") ? settings.general.lang_client : "english"
		file := LLK_FileRead("data\" lang "\mercenaries.json"), FirstApproach := json.load(file)
	}

	For index, line in FirstApproach
		If InStr(clientTXT_line, line)
			Return 1
}