///////////////////////////////////
//            ConVars            //
///////////////////////////////////
include("pubg/config.lua")
include("pubg/hud_fonts.lua")

// Format Number
local function formatNumber(n)
	if not n then return "" end
	if n >= 1e14 then return tostring(n) end
	n = tostring(n)
	local sep = sep or ","
	local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
	end
	return n
end

// Text Align
local left = TEXT_ALIGN_LEFT
local center = TEXT_ALIGN_CENTER
local right = TEXT_ALIGN_RIGHT

///////////////////////////////////
//            Main HUD           //
///////////////////////////////////
local function DrawBaseHUD()
	// Start Health
	local plyHealth = LocalPlayer():Health() or ""
	local plyTextHealth = LocalPlayer():Health() or ""
	if plyHealth > 100 then plyHealth = 100 end
	if plyHealth < 0 then plyHealth = 0 end

	if plyTextHealth > 100 then
		healthtext = {}
		healthtext["pos"] = {ScrW() / 2 + 178, ScrH() - 41}
		healthtext["color"] = Color(255,255,255,255)
		healthtext["text"] = plyTextHealth
		healthtext["font"] = "HealthFont"
		healthtext["xalign"] = left

		draw.TextShadow(healthtext, 1, 255)
	end

	draw.RoundedBox(0, ScrW() / 2 - 175, ScrH() - 45, 350, 25, Color(0,0,0,155))
	if plyHealth != 0 then
		draw.RoundedBox(0, ScrW() / 2 - 175, ScrH() - 44, (350) * plyHealth / 100, 23, Color(245,245,245,245), TEXT_ALIGN_CENTER)
	end
	if plyHealth <= 75 then
		draw.RoundedBox(0, ScrW() / 2 - 175, ScrH() - 44, (350) * plyHealth / 100, 23, Color(255,112,112,255), TEXT_ALIGN_CENTER)
	end
	if plyHealth <= 50 then
		draw.RoundedBox(0, ScrW() / 2 - 175, ScrH() - 44, (350) * plyHealth / 100, 23, Color(255,91,91,255), TEXT_ALIGN_CENTER)
	end
	if plyHealth <= 25 then
		draw.RoundedBox(0, ScrW() / 2 - 175, ScrH() - 44, (350) * plyHealth / 100, 23, Color(255,58,58,255), TEXT_ALIGN_CENTER)
	end
	if plyHealth <= 10 then
		draw.RoundedBox(0, ScrW() / 2 - 175, ScrH() - 44, (350) * plyHealth / 100, 23, Color(221,17,17,255), TEXT_ALIGN_CENTER)
	end
	surface.SetDrawColor(Color(255,255,255,50))
	surface.DrawOutlinedRect(ScrW() / 2 - 176, ScrH() - 45, 352, 25)
	// End Health

	// Start Armor
	local plyArmor = LocalPlayer():Armor() or ""
	if plyArmor > 100 then plyArmor = 100 end
	if plyArmor < 0 then plyArmor = 0 end

	if DrawHealth != 0 then
		draw.RoundedBox(0, ScrW() / 2 - 175, ScrH () - 24, (350) * plyArmor / 100, 3, Color(34,89,201,255))
	end

	if plyArmor > 1 then
		surface.SetDrawColor(255,255,255,170)
		surface.SetMaterial(Material("pubg/armor.png"))
		surface.DrawTexturedRect(ScrW() / 2 - 230, ScrH() - 51, 35, 35)
	end

	if plyArmor >= 50 then
		surface.SetDrawColor(255,255,255,170)
		surface.SetMaterial(Material("pubg/helmet.png"))
		surface.DrawTexturedRect(ScrW() / 2 - 300, ScrH() - 51, 35, 35)
	end
	// End Armor

	// Start Players Online
	draw.RoundedBox(0, ScrW() - 140, 30, 40, 35, Color(0,0,0,155))
	draw.RoundedBox(0, ScrW() - 100, 30, 70, 35, Color(255,255,255,85))

	plycounttext = {}
	plycounttext["pos"] = {ScrW() - 120, 33}
	plycounttext["color"] = Color(255,255,255,255)
	plycounttext["text"] = #player.GetAll()
	plycounttext["font"] = "PlyCountFont"
	plycounttext["xalign"] = center

	alivetext = {}
	alivetext["pos"] = {ScrW() - 99, 33}
	alivetext["color"] = Color(0,0,0,80)
	alivetext["text"] = "ALIVE"
	alivetext["font"] = "AliveFont"
	draw.TextShadow(plycounttext, 1, 255)
	draw.TextShadow(alivetext, 1, 50)

	draw.SimpleText(#player.GetAll(), "PlyCountFont", ScrW() - 120, 33, Color(255,255,255,255), center)
	draw.SimpleText("ALIVE", "AliveFont", ScrW() - 99, 33, Color(0,0,0,155))
	// End Players Online

	// Start DarkRP Vars
	if DarkRPVariables == true then
		local plyJob = LocalPlayer():getDarkRPVar("job") or ""
		local jobColor = team.GetColor(LocalPlayer():Team())
		local plyMoney = "$"..formatNumber(LocalPlayer():getDarkRPVar("money") or 0)
		local plySalary = LocalPlayer():getDarkRPVar("salary") or ""
		
		jobtext = {}
		jobtext["pos"] = {ScrW() / 2 - 175, ScrH() - 20}
		jobtext["color"] = jobColor
		jobtext["text"] = plyJob
		jobtext["font"] = "DarkRPFont"
		jobtext["xalign"] = left

		moneytext = {}
		moneytext["pos"] = {ScrW() / 2 + 175, ScrH() - 20}
		moneytext["color"] = Color(0,255,0,255)
		moneytext["text"] = plyMoney.."("..plySalary..")"
		moneytext["font"] = "DarkRPFont"
		moneytext["xalign"] = right
		draw.TextShadow(jobtext, 1, 255)
		draw.TextShadow(moneytext, 1, 255)
	end
	// End DarkRP Vars

	// Start Ammo
	local weapon = LocalPlayer():GetActiveWeapon()
	if (weapon:IsValid()) then
        if (not table.HasValue(WeaponsNotDraw, weapon:GetClass())) then
        	surface.SetDrawColor(255,255,255,100)
			surface.SetMaterial(Material("pubg/bullet.png"))
			surface.DrawTexturedRect(ScrW() / 2 - 16, ScrH() - 94, 32, 32)

			local clip = LocalPlayer():GetActiveWeapon():Clip1()
			cliptext = {}
			cliptext["pos"] = {ScrW() / 2 - 10, ScrH() - 98}
			cliptext["color"] = Color(255,255,255,230)
			cliptext["text"] = clip
			cliptext["font"] = "ClipFont"
			cliptext["xalign"] = right

			local extra = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) or ""
			extracliptext = {}
			extracliptext["pos"] = {ScrW() / 2 + 10, ScrH() - 91}
			extracliptext["color"] = Color(255,255,255,180)
			extracliptext["text"] = extra
			extracliptext["font"] = "ExtraClipFont"
			extracliptext["xalign"] = left

			draw.TextShadow(cliptext, 2, 200)
			draw.TextShadow(extracliptext, 2, 150)
		end
	end
	// End Ammo

	// Start Stance
	if LocalPlayer():Crouching() then
		// Crouching Shadow
		surface.SetDrawColor(255,255,255,205)
		surface.SetMaterial(Material("pubg/crouching-shadow.png"))
		surface.DrawTexturedRect(ScrW() - 53, ScrH() - 53, 38, 38)

		surface.SetDrawColor(255,255,255,205)
		surface.SetMaterial(Material("pubg/crouching.png"))
		surface.DrawTexturedRect(ScrW() - 54, ScrH() - 54, 38, 38)
	else
		// Standing Shadow
		surface.SetDrawColor(255,255,255,205)
		surface.SetMaterial(Material("pubg/standing-shadow.png"))
		surface.DrawTexturedRect(ScrW() - 53, ScrH() - 53, 38, 38)
		
		surface.SetDrawColor(255,255,255,205)
		surface.SetMaterial(Material("pubg/standing.png"))
		surface.DrawTexturedRect(ScrW() - 54, ScrH() - 54, 38, 38)
	end
	// End Stance
end

local function DeathNotice()
	local deathnotice_time = CreateConVar("deathnotice_time", "6", FCVAR_REPLICATED, "Amount of time to show death notice")
	local NPC_Color = Color(250,50,50,255)
	local deaths = {}

	function GAMEMODE:AddDeathNotice(attacker, team1, inflictor, victim, team2)
		local death = {}
		death_time = CurTime()
		death_left = victim
		death_right = attacker
		death_phrase = nil

		if death_left == death_right then
			death_right = nil
			death_phrase = suicideMsg
		end

		table.insert(deaths, death)
	end

	local function DrawDeaths(x, y, death, deathnotice_time)
		local fadeout = (death_time + deathnotice_time) - CurTime()
		local alpha = math.Clamp(fadeout * 255, 0, 255)

		draw.SimpleText(death_left .. "test" .. death_right, "DeathNoticeFont", 20, ScrH() - 300, Color(255,255,255), TEXT_ALIGN_LEFT )
	end
	
	function GAMEMODE:DrawDeathNotice( x, y )
		if (GetConVarNumber( "cl_drawhud" ) == 0) then return end
		local deathnotice_time = deathnotice_time:GetFloat()
		x = x * ScrW()
		y = y * ScrH()
	
		-- Draw
		for k, death in pairs( deaths ) do
			if ( death_time + deathnotice_time > CurTime() ) then
				if ( death.lerp ) then
					x = x * 0.3 + death.lerp.x * 0.7
					y = y * 0.3 + death.lerp.y * 0.7
				end
		
				death.lerp = death.lerp or {}
				death.lerp.x = x
				death.lerp.y = y
				
				y = DrawDeaths( x, y, death, deathnotice_time )
			end
		end

		for k, death in pairs( deaths ) do
			if ( death_time + deathnotice_time > CurTime() ) then
				return
			end
		end
		deaths = {}
	end
end

hook.Add("HUDPaint", "HUDPaint", function()
	DrawBaseHUD()
	DeathNotice()
end)

local function drawOverhead( ply, dist )
	local eye = LocalPlayer():GetEyeTrace()
	if !ply:Alive() then return end

	local offset = Vector( 0, 0, 80 )
	local ang = LocalPlayer():EyeAngles()
	local pos = ply:GetPos() + offset + ang:Up()

	ang:RotateAroundAxis( ang:Forward(), 90)
	ang:RotateAroundAxis( ang:Right(), 90)

	local plyName = ply:Nick()
	local plyJob = ply:getDarkRPVar("job")
	local jobColor = team.GetColor( LocalPlayer():Team() )
	local plyMoney = "$"..formatNumber(LocalPlayer():getDarkRPVar("money") or 0)
	local plySalary = LocalPlayer():getDarkRPVar("salary") or ""
	local dist = ply:GetPos():Distance( LocalPlayer():GetShootPos() )
	if HUDOverhead == true then
		if dist < 250 then
			cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), .05 )
				draw.SimpleText(plyName, "OverheadNameFont", -132, 15, Color(2, 133, 140,255), left)
				draw.SimpleText(plyJob, "OverheadRPFont", -132, 90, jobColor, left)
				draw.SimpleText(plyMoney .. "(" .. plySalary .. ")", "OverheadRPFont", -132, 125, Color(0,255,0,255), left)

				local plyHealth = ply:Health() or ""
				local plyTextHealth = ply:Health() or ""
				if plyHealth > 100 then plyHealth = 100 end
				if plyHealth < 0 then plyHealth = 0 end

				if plyTextHealth > 100 then
					draw.SimpleText(plyTextHealth, "OverheadHealthFont", 240, 58, Color(255,255,255,255), left)
				end

				draw.RoundedBox(0, -129, 61, 350, 28, Color(0,0,0,155))
				if plyHealth != 0 then
					draw.RoundedBox(0, -129, 61, (350) * plyHealth / 100, 28, Color(255,255,255,255), center)
				end	
				if plyHealth <= 75 then
					draw.RoundedBox(0, -129, 61, (350) * plyHealth / 100, 28, Color(255,112,112,255), center)
				end
				if plyHealth <= 50 then
					draw.RoundedBox(0, -129, 61, (350) * plyHealth / 100, 28, Color(255,91,91,255), center)
				end
				if plyHealth <= 25 then
					draw.RoundedBox(0, -129, 61, (350) * plyHealth / 100, 28, Color(255,58,58,255), center)
				end
				if plyHealth <= 10 then
					draw.RoundedBox(0, -129, 61, (350) * plyHealth / 100, 28, Color(221,17,17,255), center)
				end
				surface.SetDrawColor(Color(255,255,255,50))
				surface.DrawOutlinedRect(-130, 60, 352, 30)

				local plyArmor = ply:Armor() or ""
				if plyArmor > 100 then plyArmor = 100 end
				if plyArmor < 0 then plyArmor = 0 end

				if DrawHealth != 0 then
					draw.RoundedBox(0, -129, 86, (350) * plyArmor / 100, 3, Color(34,89,201,255), center)
				end

				if plyArmor > 1 then
					surface.SetDrawColor(255,255,255,170)
					surface.SetMaterial(Material("pubg/armor.png"))
					surface.DrawTexturedRect(-190, 30, 52, 52)
				end

				if plyArmor >= 50 then
					surface.SetDrawColor(255,255,255,170)
					surface.SetMaterial(Material("pubg/helmet.png"))
					surface.DrawTexturedRect(-280, 30, 52, 52)
				end
			cam.End3D2D()
		end
	end
end
hook.Add("PostPlayerDraw", "drawOverhead", drawOverhead)

local function HideThings(name)
	if(name == "CHudHealth") or (name == "CHudBattery") then
		return false
	end
end
hook.Add("HUDShouldDraw", "HideThings", HideThings)

function hideammo(name)
	for k, v in pairs({"CHudAmmo", "CHudSecondaryAmmo"}) do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "HideOurAmmo", hideammo)

local hideHUDElements = {
    ["DarkRP_HUD"]              = true,
    ["DarkRP_EntityDisplay"]    = true,
    ["DarkRP_LocalPlayerHUD"]   = true,
    ["DarkRP_Hungermod"]        = true,
    ["DarkRP_Agenda"]           = true,
}

hook.Add("HUDShouldDraw", "HUDHideHUD", function(name)
    if hideHUDElements[name] then return false end
end)
