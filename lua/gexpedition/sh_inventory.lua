function GexAddInventoryToEnt(ent,size)
	--naming everything gex cause if not I might fuck up someone else's thing.
	ent.gexinventory = {}
	ent.gexinvmaxsize = size
	--doesn't return based on whether a slot is available
	function ent:GexCanStore(item)
		--making an intentional limit to just SOLID_VPHYSICS, as you should not be able to pick up brush entities, static entities, or npcs. HOWEVER, I may add support for specifically npcs later, they're just tricky and dangerous.
		local phys = item:GetPhysicsObject()
		return item:GetSolid()==SOLID_VPHYSICS and IsValid(phys) and phys:IsMotionEnabled()
	end
	-- called on the container to store an item, slot is optional, will give up if the slot it's looking for is taken or doesn't exist
	function ent:GexStore(item,slot) 
		local findSlot = slot or self:GexConvenientSlot()
		if self:GexCanStore(item) and findSlot and not self.gexinventory[findSlot] then
			item.gexstore = item.gexstore or {}
			item.gexstore.container = self
			self.gexinventory[findSlot] = item
			item:SetNoDraw(true)
			item:SetSolid(SOLID_NONE)
			local phys = item:GetPhysicsObject()
			--gexcanstore confirms that there is a valid physics object and that it is unfrozen.
			phys:EnableMotion(false)
			PrintTable(self.gexinventory)
		end
	end
	function ent:GexSlotValid(slot)
		return (not IsValid(self.gexinventory[slot])) and (not self.gexinvmaxsize or slot <= self.gexinvmaxsize)
	end
	-- finds a convenient slot to store an item in, or nil if there's none
	function ent:GexConvenientSlot()
		local i = 1
		while not self:GexSlotValid(i) and (not self.gexinvmaxsize or i < self.gexinvmaxsize) do
			i = i + 1
		end
		return self:GexSlotValid(i) and i or nil
	end
	-- finds the slot an item is stored in, or nil if it fails
	function ent:GexSlotOf(item)
		return table.KeyFromValue(self.gexinventory,item)
	end
	--removes invalid entities
	function ent:GexCleanInventory()
		for key,value in pairs(self.gexinventory) do
			if not IsValid(value) then
				self.gexinventory[key] = nil
			end
		end
	end
	-- expels an item from a slot
	function ent:GexDrop(slot)
		item:SetNoDraw(false)
		item:SetSolid(SOLID_VPHYSICS)
		local phys = item:GetPhysicsObject()
		phys:EnableMotion(true)
		--world's smallest memory leak technically, but anything that is picked up has permanent support for items
		item.gexstore.container = nil 
	end
end
if SERVER then
	util.AddNetworkString( "updateGexInventory" )
	net.Receive("updateGexInventory",function(_,ply)
		local container = net.ReadEntity()
		if not container.gexinventory then return end
		container:GexCleanInventory()
		net.Start("updateGexInventory")
		net.WriteEntity(container)
		net.WriteTable(container.gexinventory)
		net.Send(ply)
	end)
end
if CLIENT then
	net.Receive("updateGexInventory",function()
		local container = net.ReadEntity()
		local contents = net.ReadTable()
		container.gexinventory = contents
	end)
end