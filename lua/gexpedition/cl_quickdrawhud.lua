local function DrawPizzaSlice(roll,offset,length,rolloff)
	local vertices = 0
	local polygon = {}
	local detail = 4
	for i = 0,detail do
		local rolloffreal = rolloff * (i/detail-0.5)*2
		polygon[vertices + 1] = { x = math.sin(roll-rolloffreal) * (offset+length) + ScrW()/2, y = math.cos(roll-rolloffreal) * (offset+length) + ScrH()/2 }
		vertices = vertices + 1
	end
	polygon[vertices + 1] = { x = math.sin(roll-rolloff) * offset + ScrW()/2, y = math.cos(roll-rolloff) * offset + ScrH()/2 }
	vertices = vertices + 1
	polygon[vertices + 1] = { x = math.sin(roll+rolloff) * offset + ScrW()/2, y = math.cos(roll+rolloff) * offset + ScrH()/2 }
	vertices = vertices + 1
	surface.DrawPoly(polygon)
end
local placeholder = Material( "vgui/cursors/no" )
local item = Material( "icon16/bricks.png" )
local hud = Material( "editor/flatignorez" )
local menuShown = false
local count = 1
Gex_InventoryOpen = false
function Gex_OpenInventory()
	if Gex_InventoryOpen then return end
	local weapon = LocalPlayer():GetWeapon( "gex_inventory" )
	Gex_InventoryOpen = true
	local mouseDelta = {0,0}
	hook.Add( "HUDPaint", "DrawQuickSelectHUD", function()
		cam.Start2D()
		count = 0
		local icons = {}
		for key,value in pairs(weapon.gexinventory) do
			count = count + 1
			icons[key] = value and item or placeholder
		end
		if count == 0 then
			count = 1
			icons[1] = placeholder
		end
		local mouseAngle = math.atan( mouseDelta[1]/mouseDelta[2] ) + (mouseDelta[2]<0 and math.pi or 0)
		for i=1,count do
			local roll = math.pi*i/count*2
			local divergence = math.abs(math.AngleDifference(roll*180/math.pi,mouseAngle*180/math.pi))
			local selected = divergence<180/count
			local grey = (180-divergence)/2 + (selected and 50 or 0)
			surface.SetDrawColor( grey, grey, grey, 200 )
			local length = ScrH()/3
			local offset = ScrH()/8
			surface.SetMaterial(hud)
			DrawPizzaSlice(roll,offset,length*(selected and 1.1 or 1),math.pi/count)
			surface.SetDrawColor( color_white )
			surface.SetMaterial( icons[i] )
			local size = ScrH()/2.3/math.sqrt(count)
			local distance = count > 1 and (offset+length/2.5) or 0
			surface.DrawTexturedRect( math.sin(roll) * distance + ScrW()/2 - size/2, math.cos(roll) * distance+ScrH()/2 - size/2, size, size )
		end
		cam.End2D()
	end)
	hook.Add("InputMouseApply", "UpdateQuickSelectCursor",function(cmd, x, y, ang)
		mouseDelta[1] = (mouseDelta[1] + x) / 1.01
		mouseDelta[2] = (mouseDelta[2] + y) / 1.01
		cmd:SetMouseX( 0 )
		cmd:SetMouseY( 0 )
		return true
	end)
end
function Gex_CloseInventory()
	if not Gex_InventoryOpen then return end
	Gex_InventoryOpen = false
	hook.Remove( "HUDPaint", "DrawQuickSelectHUD")
	hook.Remove( "InputMouseApply", "UpdateQuickSelectCursor")
end
function Gex_ToggleInventory()
	if Gex_InventoryOpen then
		Gex_CloseInventory()
	else
		Gex_OpenInventory()
	end
	return Gex_InventoryOpen
end