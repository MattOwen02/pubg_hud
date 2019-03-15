hook.Add("OnPlayerChat", "OpenCFG", function(ply, text, team)
	if ply == LocalPlayer() && (text == "!pubg") then
		local igcfg = vgui.Create("DFrame")
		igcfg:SetSize(800,600)
		igcfg:SetTitle("PUBG Client Config")
		igcfg:MakePopup()
		igcfg:Center()
		igcfg:SetSkin("IGCFG")

		function igcfg:Paint(w, h)
			draw.RoundedBox(5, 0, 0, w, h, Color(35,35,35,255))
		end

		local tabs = vgui.Create("DPropertySheet", igcfg)
			tabs:Dock(FILL)

		local panel1 = vgui.Create("DPanel", tabs)
			tabs:AddSheet("Main Config", panel1)
		
		local rpvars = vgui.Create("DCheckBoxLabel", panel1)
			rpvars:SetPos(20,15)
			rpvars:SetTextColor(Color(35,35,35))
			rpvars:SetText("DarkRP Variables")
			rpvars:SetValue(0)
			rpvars:SizeToContents()	

		local hpbar_label = vgui.Create("DLabel", panel1)
			hpbar_label:SetPos(20,40)
			hpbar_label:SetTextColor(Color(35,35,35))
			hpbar_label:SetText("HP Bar Color")

		local hpbar = vgui.Create( "DRGBPicker", panel1)
			hpbar:SetPos(20,55)
			hpbar:SetSize(30,190)

		local hpbar_cube = vgui.Create("DColorCube", panel1)
			hpbar_cube:SetPos(55,55)
			hpbar_cube:SetSize(190,190)

		function hpbar:OnChange(col)
			local h = ColorToHSV(col)
			local _, s, v = ColorToHSV(hpbar_cube:GetRGB())

			col = HSVToColor(h,s,v)
			hpbar_cube:SetColor(col)

			UpdateColor(col)
		end
		return true
	end
end)