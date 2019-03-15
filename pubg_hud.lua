if SERVER then
	AddCSLuaFile("pubg/config.lua")
	AddCSLuaFile("pubg/hud_main.lua")
	AddCSLuaFile("pubg/hud_fonts.lua")
	AddCSLuaFile("pubg/hud_vgui.lua")

	resource.AddFile("materials/pubg/bullet.png")
    resource.AddFile("materials/pubg/armor.png")
    resource.AddFile("materials/pubg/helmet.png")
    resource.AddWorkshop("1148369256")
else
	include("pubg/hud_main.lua")
	include("pubg/hud_vgui.lua")
end