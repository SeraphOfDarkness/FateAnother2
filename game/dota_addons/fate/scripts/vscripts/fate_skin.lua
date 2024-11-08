
FateSkin = FateSkin or class({})
--SkinTables = LoadKeyValues("scripts/npc/fate_skin.kv")

function FateSkin:construct()
	print('fate skin start')
	--self.SkinTables = SkinTables
end

function FateSkin:ApplySkin(hHero, iSkin, aLvL, dID)
	self.UnAvailableSkin = LoadKeyValues("scripts/npc/skin_unavailable.txt")
	self.SkinTables = LoadKeyValues("scripts/npc/fate_skin.kv")
	self.LSiD = 0
	if type(iSkin) ~= "number" then 
		iSkin = tonumber(iSkin)
	end
	local hero_name = hHero:GetUnitName()
	if self:IsLimitedSkin(hero_name .. "_" .. tostring(iSkin)) then 
		local playerId = hHero:GetPlayerOwnerID()
		if not self:CheckLImited(self.LSiD, playerId, aLvL, dID) then
			return nil 
		end
	end

	if self.SkinTables[hero_name] == nil then
		return
	end

	local old_skin = -1
	for k,v in pairs (self.SkinTables[hero_name]) do 
		if v.model == hHero:GetModelName() then 
			old_skin = tonumber(k)
			print('old skin id ' .. k)
			if tonumber(k) > 0 then 
				print('remove old modifier' .. tonumber(k))
				hHero:RemoveAbility("alternative_0" .. tonumber(k))
				hHero:RemoveModifierByName("modifier_alternate_0" .. tonumber(k))
			end
			if v.attachment ~= nil then
				for a,b in pairs(v.attachment) do 
					local prop = Attachments:GetCurrentAttachment(hHero, a)
					if prop ~= nil and not prop:IsNull() then 
						prop:RemoveSelf() 
					end
				end
			end
			break 
		end
	end

	
	if iSkin > 0 then
		print('apply new modifier ' .. iSkin)
		hHero:AddAbility("alternative_0" .. iSkin)
    	hHero:FindAbilityByName("alternative_0" .. iSkin):SetLevel(1)
    end

	hHero:SetModel(self.SkinTables[hero_name][tostring(iSkin)].model)
	hHero:SetOriginalModel(self.SkinTables[hero_name][tostring(iSkin)].model)
	hHero:SetModelScale(self.SkinTables[hero_name][tostring(iSkin)].scale)

	if self.SkinTables[hero_name][tostring(iSkin)].attachment ~= nil then
		for k,v in pairs (self.SkinTables[hero_name][tostring(iSkin)].attachment) do
			Attachments:AttachProp(hHero, k, v)
		end
	end
end

function FateSkin:CheckLImited(sID, playerId, aLvL, dID)
	self.ContributeUnlock = LoadKeyValues("scripts/npc/contributeunlock.txt")
	if self.UnAvailableSkin.UnAvai[sID] ~= nil then
		print('limited skin detect')
		if aLvL ~= nil then
			print('dev try to give limited skin')
			if aLvL == 5 and tostring(PlayerResource:GetSteamAccountID(dID)) == "96116520" then 
				return true
			elseif self.ContributeUnlock[skin][tostring(PlayerResource:GetSteamAccountID(playerId))] ~= nil and self.ContributeUnlock[skin][tostring(PlayerResource:GetSteamAccountID(playerId))] == 1 then 
				return true
			end
		end
		if PlayerTables:GetTableValue("database", "db", playerId) == true and iupoasldm.jyiowe[playerId].IFY ~= nil then
			return iupoasldm.jyiowe[playerId].IFY.SKID[sID]			
		end
	end
	return false 
end

function FateSkin:IsLimitedSkin(sHeroSkin)
	for sID, skin in pairs (self.UnAvailableSkin.UnAvai) do 
		print(sID, skin, sHeroSkin)
		if string.match(skin, sHeroSkin) then 
			--print(sHeroName)
			self.LSiD = sID
			return true
		end
	end
	return false 
end
