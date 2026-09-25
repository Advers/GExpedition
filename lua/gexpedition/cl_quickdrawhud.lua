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
local hud = Material( "editor/flatignorez" )
local menuShown = false
local count = 4
hook.Add( "HUDPaint", "DrawQuickSelectHUD", function()
	if not input.IsKeyDown( KEY_H ) then 
		menuShown = false 
		return 
	end
	if not menuShown then 
		menuShown = true
		count = math.random(1,15)
	end
	cam.Start2D()
	for i=1,count do
		local grey = i/count*50+20
		surface.SetDrawColor( grey, grey, grey, 200 )
		local roll = math.pi*i/count*2
		local length = ScrH()/3
		local offset = ScrH()/8
		surface.SetMaterial(hud)
		DrawPizzaSlice(roll,offset,length,math.pi/count)
		surface.SetDrawColor( color_white )
		surface.SetMaterial(placeholder)
		local size = ScrH()/2.3/math.sqrt(count)
		local distance = count > 1 and (offset+length/2.5) or 0
		surface.DrawTexturedRect( math.sin(roll) * distance + ScrW()/2 - size/2, math.cos(roll) * distance+ScrH()/2 - size/2, size, size )
	end
	cam.End2D()
end)