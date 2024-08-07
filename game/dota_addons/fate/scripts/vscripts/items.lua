cdummy = nil
itemKV = LoadKeyValues("scripts/npc/npc_items_custom.txt")

function ParseCombinationKV()
	for k,v in pairs(itemKV) do
		if string.match(k, "recipe") then
			for k2, v2 in pairs(v) do
				if k2 == "ItemRequirements" then
					for k3, v3 in pairs(v2) do

						--print("Item Name : " .. k)
						comp1, comp2 = string.match(v3, "([^;]+);([^;]+)")
						if k == "item_recipe_healing_scroll" then
							comp1 = "item_mana_essence"
							comp2 = "item_recipe_healing_scroll"
						elseif k == "item_recipe_a_plus_scroll" then
							comp1 = "item_a_scroll"
							comp2 = "item_recipe_a_plus_scroll"
						end
						--print(comp1 .. " " .. comp2)
					end
				end
			end
		end
	end
end


function OnManaEssenceAcquired(keys)
end

WARP_POINT_LEFT = Vector(-3662,5269,386)
WARP_POINT_RIGHT = Vector(7284,-162,394)

function OnWarpL(trigger)
	local hero = trigger.activator
	if hero:HasItemInInventory("item_portal_key") then 
		local key = hero:FindItemInInventory("item_portal_key")
		key:ApplyDataDrivenModifier(hero, hero, "modifier_portal_buff", {})
		key:ApplyDataDrivenModifier(hero, hero, "modifier_portal_invis", {})
		hero:RemoveItem(key)
		hero:SetAbsOrigin(WARP_POINT_LEFT + RandomVector(200))
		FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
		hero:AddNewModifier(hero, nil, "modifier_camera_follow", {duration = 1.0})
		hero.IsWarpCooldown = true 
		Timers:CreateTimer(3, function()
			hero.IsWarpCooldown = false 
		end)
	else
		if not hero.IsFreeWarpUse and not hero.IsWarpCooldown then 
			hero.IsFreeWarpUse = true 
			hero:SetAbsOrigin(WARP_POINT_LEFT + RandomVector(200))
			FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
			hero:AddNewModifier(hero, nil, "modifier_camera_follow", {duration = 1.0})
			hero.IsWarpCooldown = true 
			Timers:CreateTimer(3, function()
				hero.IsWarpCooldown = false 
			end)
		end
	end
	--[[if not hero.IsFreeWarpUse then 
		hero.IsFreeWarpUse = true 
		hero:SetAbsOrigin(WARP_POINT_LEFT + RandomVector(200))
		FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
		hero:AddNewModifier(hero, nil, "modifier_camera_follow", {duration = 1.0})
	elseif hero.IsFreeWarpUse and hero:HasItemInInventory("item_portal_key") and not hero.IsWarpCooldown then 
		local key = hero:FindItemInInventory("item_portal_key")
		hero:RemoveItem(key)
		hero:SetAbsOrigin(WARP_POINT_LEFT + RandomVector(200))
		FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
		hero:AddNewModifier(hero, nil, "modifier_camera_follow", {duration = 1.0})
		hero.IsWarpCooldown = true 
		Timers:CreateTimer(3, function()
			hero.IsWarpCooldown = false 
		end)
	end]]
end

function OnWarpR(trigger)
	local hero = trigger.activator
	if hero:HasItemInInventory("item_portal_key") then 
		local key = hero:FindItemInInventory("item_portal_key")
		key:ApplyDataDrivenModifier(hero, hero, "modifier_portal_buff", {})
		key:ApplyDataDrivenModifier(hero, hero, "modifier_portal_invis", {})
		hero:RemoveItem(key)
		hero:SetAbsOrigin(WARP_POINT_RIGHT + RandomVector(200))
		FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
		hero:AddNewModifier(hero, nil, "modifier_camera_follow", {duration = 1.0})
		hero.IsWarpCooldown = true 
		Timers:CreateTimer(3, function()
			hero.IsWarpCooldown = false 
		end)
	else
		if not hero.IsFreeWarpUse and not hero.IsWarpCooldown then 
			hero.IsFreeWarpUse = true 
			hero:SetAbsOrigin(WARP_POINT_RIGHT + RandomVector(200))
			FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
			hero:AddNewModifier(hero, nil, "modifier_camera_follow", {duration = 1.0})
			hero.IsWarpCooldown = true 
			Timers:CreateTimer(3, function()
				hero.IsWarpCooldown = false 
			end)
		end
	end
	--[[if not hero.IsFreeWarpUse then 
		hero.IsFreeWarpUse = true 
		hero:SetAbsOrigin(WARP_POINT_RIGHT + RandomVector(200))
		FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
		hero:AddNewModifier(hero, nil, "modifier_camera_follow", {duration = 1.0})
	elseif hero.IsFreeWarpUse and hero:HasItemInInventory("item_portal_key") and not hero.IsWarpCooldown then 
		local key = hero:FindItemInInventory("item_portal_key")
		hero:RemoveItem(key)
		hero:SetAbsOrigin(WARP_POINT_RIGHT + RandomVector(200))
		FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
		hero:AddNewModifier(hero, nil, "modifier_camera_follow", {duration = 1.0})
		hero.IsWarpCooldown = true 
		Timers:CreateTimer(3, function()
			hero.IsWarpCooldown = false 
		end)
	end]]
end

function OnBaseEntered(trigger)
	local hero = trigger.activator
	hero.IsInBase = true
	SendErrorMessage(hero:GetPlayerOwnerID(), "#Entered_Base")
end

function OnBaseLeft(trigger)
	local hero = trigger.activator
        if not hero then
            return
        end
	hero.IsInBase = false
	SendErrorMessage(hero:GetPlayerOwnerID(), "#Left_Base")
end

function OnTrioBaseEnter(hero, team)
	if hero:GetUnitName() == "npc_dota_hero_wisp" then return end
	hero.IsInBase = true
	local dur = 9999
	if IsInToolsMode() then 
		dur = 0.5
	end
	if hero:GetTeam() == team then
		giveUnitDataDrivenModifier(hero, hero, "spawn_invulnerable", dur)
	end
	SendErrorMessage(hero:GetPlayerOwnerID(), "#Entered_Base")
end

function OnTrioBaseLeft(hero, team)
	if not hero then return end
	hero.IsInBase = false
	hero:RemoveModifierByName("spawn_invulnerable")
	if hero:GetTeam() == team then
		giveUnitDataDrivenModifier(hero, hero, "spawn_invulnerable", 3)
	end
	SendErrorMessage(hero:GetPlayerOwnerID(), "#Left_Base")
end

function OnTrioBase1Entered(trigger)
	local hero = trigger.activator
	OnTrioBaseEnter(hero, DOTA_TEAM_GOODGUYS)
end

function OnTrioBase1Left(trigger)
	local hero = trigger.activator
	OnTrioBaseLeft(hero, DOTA_TEAM_GOODGUYS)
end

function OnTrioBase2Entered(trigger)
	local hero = trigger.activator
	OnTrioBaseEnter(hero, DOTA_TEAM_BADGUYS)
end

function OnTrioBase2Left(trigger)
	local hero = trigger.activator
	OnTrioBaseLeft(hero, DOTA_TEAM_BADGUYS)
end

function OnTrioBase3Entered(trigger)
	local hero = trigger.activator
	OnTrioBaseEnter(hero, DOTA_TEAM_CUSTOM_1)
end

function OnTrioBase3Left(trigger)
	local hero = trigger.activator
	OnTrioBaseLeft(hero, DOTA_TEAM_CUSTOM_1)
end

function OnTrioBase4Entered(trigger)
	local hero = trigger.activator
	OnTrioBaseEnter(hero, DOTA_TEAM_CUSTOM_2)
end

function OnTrioBase4Left(trigger)
	local hero = trigger.activator
	OnTrioBaseLeft(hero, DOTA_TEAM_CUSTOM_2)
end

function OnFFABaseEntered(trigger)
	local hero = trigger.activator
	hero.IsInBase = true
	SendErrorMessage(hero:GetPlayerOwnerID(), "#Entered_Base")
end

function OnFFABaseLeft(trigger)
	local hero = trigger.activator
	if not hero then return end
	hero.IsInBase = false
	SendErrorMessage(hero:GetPlayerOwnerID(), "#Left_Base")
end

function AutoTransferItem(hero, itemname)
	local transferitem = nil
	local space_item = nil
	for i = 0,5 do 
		local stash_item = hero:GetItemInSlot(i + 9)
		if stash_item ~= nil and stash_item:GetName() == itemname and stash_item:GetPurchaseTime() == GameRules:GetGameTime() then 
			transferitem = stash_item
			break
		end
	end

	for j = 0,5 do
		if hero:GetItemInSlot(j) == nil then 
			space_item = true 
			break
		end
	end

	if transferitem ~= nil and space_item ~= nil then
		local itemName = transferitem:GetName()
		local charges = transferitem:GetCurrentCharges()
		local newItem = CreateItem(itemName, nil, nil)
		newItem:SetCurrentCharges(charges)
		transferitem:RemoveSelf()
		--Timers:CreateTimer( 0.033, function()

		hero:AddItem(newItem)
		CheckItemCombination(hero)
		
	end

	CheckItemCombinationInStash(hero)
	SaveStashState(hero)

end

function TransferItem(keys)
	local item = keys.ability
	local caster = keys.caster
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	local stash_item = hero:GetItemInSlot(keys.Slot+8) -- This looks for slot 6/7/8/9/10/11(Stash)
	local space_item = nil

	for i = 0,5 do
		if hero:GetItemInSlot(i) == nil then 
			space_item = true 
			break
		end
	end

	--PrintTable(stash_item)
	-- If item is found, remove it from stash and add it to hero
	if stash_item ~= nil and space_item ~= nil then
		--[[If hero has empty inventory slot, move item to hero
		local hero_item = hero:GetItemInSlot(i)
		for i=0, 5 do
			if hero_item == nil then
				hero:AddItem(stash_item)
				caster:RemoveItem(stash_item)
				return
			end
		end]]
		local itemName = stash_item:GetName()
		local charges = stash_item:GetCurrentCharges()
		local newItem = CreateItem(itemName, nil, nil)
		newItem:SetCurrentCharges(charges)
		stash_item:RemoveSelf()
		--Timers:CreateTimer( 0.033, function()

		hero:AddItem(newItem)
		CheckItemCombination(hero)

		SaveStashState(hero)
	else
		SendErrorMessage(hero:GetPlayerOwnerID(), "#No_Items_Found")
	end

end

function RefundItem(caster, item)
	local charges = item:GetCurrentCharges()
	if charges == 0 then
		-- if the item has zero charges, it is removed from
		-- the inventory, therefore we have to recreate the item
		local itemName = item:GetAbilityName()
		item = CreateItem(itemName, caster, nil)
		item:SetCurrentCharges(1)
		caster:AddItem(item)
	else
		item:SetCurrentCharges(charges + 1)
	end
	item:EndCooldown()
end

function PotInstantHeal(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end
	SetShareCooldown(ability, caster)
	local health_heal = ability:GetSpecialValueFor("health_heal")
	local mana_heal = ability:GetSpecialValueFor("mana_heal")
	caster:FateHeal(health_heal, caster, false)

	if not IsManaLess(caster) then
		caster:GiveMana(mana_heal)
	end

	local healFx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_g.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(healFx, 1, caster:GetAbsOrigin()) -- target effect location

	-- Destroy particle
	Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle(healFx, false)
	end)
end

function TPScroll(keys)
	local caster = keys.caster
	local ability = keys.ability
	if IsTPLocked(caster) then
		RefundItem(caster, ability)
		caster:Stop()
		return
	end
	local targetPoint = keys.target_points[1]
	--print(caster:GetAbsOrigin().y .. " and " .. caster:GetAbsOrigin().x)
	if caster:GetAbsOrigin().y < -2000 or targetPoint.y < -2000 then
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Invalid_Location")
		RefundItem(caster, ability)
		caster:Stop()
		return
	end

	caster.TPLoc = nil
	local targets = FindUnitsInRadius(caster:GetTeam(), targetPoint, nil, 10000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_OTHER, 0, FIND_CLOSEST, false)
	if targets[1] == nil or targets[1]:GetAbsOrigin().y < -2000 then
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Invalid_Location")
		RefundItem(caster, ability)
		caster:Stop()
		return
	else
		caster.TPLoc = targets[1]:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())


		local pfx2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl(pfx2, 0, caster.TPLoc)

		caster:EmitSound("Hero_Wisp.Relocate")
		EmitSoundOnLocationWithCaster(caster.TPLoc, "Hero_Wisp.Relocate", targets[1])

		-- Destroy particle
		Timers:CreateTimer(2.0, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:DestroyParticle(pfx2, false)
		end)
	end

end

function TPSuccess(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end
	caster:EmitSound("Hero_Wisp.Return")
	caster:SetAbsOrigin(caster.TPLoc)
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
end

function MassTPSuccess(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end
	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 1000
            , DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if caster.TPLoc == nil then
		FireGameEvent( 'custom_error_show', { player_ID = caster:GetPlayerOwnerID(), _error = "Must Have Ward Nearby Targeted Location" } )
		caster:AddItem(CreateItem("item_teleport_scroll" , caster, nil))
	else
		caster:EmitSound("Hero_Wisp.Return")
		for k,v in pairs(targets) do
			v:SetAbsOrigin(caster.TPLoc)
			FindClearSpaceForUnit(v, v:GetAbsOrigin(), true)
		end
	end
end

function TPFail(keys)
end

LinkLuaModifier("modifier_no_collide", "items/modifiers/modifier_no_collide", LUA_MODIFIER_MOTION_NONE)

function WardFam(keys)
	local caster = keys.caster
	local ability = keys.ability
	local hero = keys.caster:GetPlayerOwner():GetAssignedHero()
	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end
	hero.ServStat:useWard()
	local targetPoint = keys.target_points[1]
	caster.ward = CreateUnitByName("ward_familiar", targetPoint, true, caster, caster, caster:GetTeamNumber())

	caster.ward:SetDayTimeVisionRange(keys.Radius)
	caster.ward:SetNightTimeVisionRange(keys.Radius)
	caster.ward:AddNewModifier(caster, caster, "modifier_invisible", {})
	caster.ward:AddNewModifier(caster, caster, "modifier_no_collide", {})
	caster.ward:AddNewModifier(caster, caster, "modifier_item_ward_true_sight", {true_sight_range = keys.Radius, duration = keys.Duration})
    caster.ward:AddNewModifier(caster, caster, "modifier_kill", {duration = keys.Duration})
    giveUnitDataDrivenModifier(caster.ward, caster.ward, "modifier_ward_dmg_reduce", {duration = keys.Duration})
    EmitSoundOnLocationForAllies(targetPoint,"DOTA_Item.ObserverWard.Activate",caster)
end

function WardOnTakeDamage(keys)
	if keys.unit.dmgcooldown ~= true then
		keys.unit.dmgcooldown = true
		--print("Took Dmg")
		local dmgtable = {
	        attacker = keys.attacker,
	        victim = keys.unit,
	        damage = 2,
	        damage_type = DAMAGE_TYPE_PURE,
	    }
	    --print(dmgtable.attacker:GetName(), dmgtable.victim:GetName(), dmgtable.damage)
	    ApplyDamage(dmgtable)
	    Timers:CreateTimer(0.05, function()
			keys.unit.dmgcooldown = false
		end)
	end
end

function OnWardDeath(keys)
	local caster = keys.caster

end

function ScoutFam(keys)
	local caster = keys.caster
	local ability = keys.ability
	local hero = keys.caster:GetPlayerOwner():GetAssignedHero()
	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end
	local pid = caster:GetPlayerID()
	hero.ServStat:useFamiliar()
	local scout = CreateUnitByName("scout_familiar", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	scout:SetControllableByPlayer(pid, true)
	keys.ability:ApplyDataDrivenModifier(caster, scout, "modifier_banished", {})
	LevelAllAbility(scout)
   	scout:AddNewModifier(caster, nil, "modifier_kill", {duration = 30})
end

function BecomeWard(keys)
	local caster = keys.caster
	local origin = caster:GetAbsOrigin()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if GridNav:IsBlocked(origin)
		or not GridNav:IsTraversable(origin)
		or origin.y < -2000
	then
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Invalid_Location")
		hero:ModifyGold(600, true , 0)
		return
	end
	hero.ServStat:useWard()
	hero.ServStat:trueWorth(1200)

	local transform = CreateUnitByName("sentry_familiar", caster:GetAbsOrigin(), true, hero, hero, caster:GetTeamNumber())	
	local wardPos = transform:GetAbsOrigin()
	transform:SetDayTimeVisionRange(375)
	transform:SetNightTimeVisionRange(375)
	transform:AddNewModifier(hero, hero, "modifier_invisible", {})
	transform:AddNewModifier(hero, hero, "modifier_item_ward_true_sight", {true_sight_range = 1400, duration = 30})
	transform:AddNewModifier(hero, hero, "modifier_kill", {duration = 30})
	giveUnitDataDrivenModifier(transform, transform, "modifier_ward_dmg_reduce", {duration = 30})
	caster:EmitSound("DOTA_Item.ObserverWard.Activate")
	caster:RemoveSelf()
end

function SpiritLink(keys)
	--print("Spirit Link Used")
	local caster = keys.caster
	local ability = keys.ability
	local hero = keys.caster:GetPlayerOwner():GetAssignedHero()
	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end

	local targets = keys.target_entities
	hero.ServStat:useLink()
	--local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)
	local linkTargets = {}
	caster:EmitSound("Hero_Warlock.FatalBonds" )
	-- set up table for link
	for i=1,#targets do
		if targets[i]:GetUnitName() ~= "pseudo_illusion" then
			linkTargets[i] = targets[i]
			--print("Added hero to link table : " .. targets[i]:GetName())
			RemoveHeroFromLinkTables(targets[i])

			-- particle
	    	local pulseFx = ParticleManager:CreateParticle( "particles/units/heroes/hero_warlock/warlock_fatal_bonds_pulse.vpcf", PATTACH_CUSTOMORIGIN, caster )
		    ParticleManager:SetParticleControl( pulseFx, 0, caster:GetAbsOrigin() + Vector(0,0,100))
		    ParticleManager:SetParticleControl( pulseFx, 1, targets[i]:GetAbsOrigin() + Vector(0,0,100))
		end
	end

	-- add list of linked targets to hero table
	for i=1,#targets do
		targets[i].linkTable = linkTargets
		--print("Table Contents " .. i .. " : " .. targets[i]:GetName())
		keys.ability:ApplyDataDrivenModifier(caster, targets[i], "modifier_share_damage", {})
	end
end

function OnLinkDestroyed(keys)
	local caster = keys.caster
	local target = keys.target
end

function GemOfResonance(keys)
	-- body
end


function Blink(keys)
	local caster = keys.caster
	local ability = keys.ability
	local casterPos = caster:GetAbsOrigin()
	local targetPoint = keys.target_points[1]
	local newTargetPoint = nil

	if IsLocked(caster) or caster:HasModifier("jump_pause_nosilence") or caster:HasModifier("modifier_story_for_someones_sake") then
		keys.ability:EndCooldown()
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Cannot_Blink")
		return
	end

	--[[if caster:HasModifier("modifier_aestus_domus_aurea_enemy") 
		or caster:HasModifier("modifier_aestus_domus_aurea_ally") 
		or caster:HasModifier("modifier_aestus_domus_aurea_nero") then
		
		keys.ability:EndCooldown()
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Cannot_Blink")
		return
		local target = 0
		local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		for i=1, #targets do
			target = targets[i]
			if target:GetName() == "npc_dota_hero_lina" then
				break
			end
		end
		if not IsFacingUnit(caster, target, 90) then
			keys.ability:EndCooldown()
			SendErrorMessage(caster:GetPlayerOwnerID(), "#Cannot_Blink")
			return
		end

	end]]


	if GridNav:IsBlocked(targetPoint) or not GridNav:IsTraversable(targetPoint) then
		keys.ability:EndCooldown()
		if ability:GetName() == "caster_5th_dimensional_jump" then
			caster:GiveMana(150) -- 150 being mana cost of Dimensional Jump
		end
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Cannot_Travel")
		return
	end


	-- particle
	local particle = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, casterPos)
	caster:EmitSound("Hero_Antimage.Blink_out")
	local particle2 = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle2, 0, targetPoint)

	-- blink
	local diff = targetPoint - caster:GetAbsOrigin()
	if diff:Length() <= 1000 then
		caster:SetAbsOrigin(targetPoint)
		ProjectileManager:ProjectileDodge(caster)
		--ParticleManager:SetParticleControl(particle2, 0, targetPoint)
		EmitSoundOnLocationWithCaster(targetPoint, "Hero_Antimage.Blink_in", caster)
	else
		newTargetPoint = caster:GetAbsOrigin() + diff:Normalized() * 1000
		local i = 1
		while GridNav:IsBlocked(newTargetPoint) or not GridNav:IsTraversable(newTargetPoint) or i == 100 do
			i = i+1
			newTargetPoint = caster:GetAbsOrigin() + diff:Normalized() * (1000 - i*10)
		end

		caster:SetAbsOrigin(newTargetPoint)
		ProjectileManager:ProjectileDodge(caster)
		ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin())
		EmitSoundOnLocationWithCaster(newTargetPoint, "Hero_Antimage.Blink_in", caster)
	end

	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)

	Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle(particle, false)
		ParticleManager:DestroyParticle(particle2, false)
	end)
end

function StashBlink(keys)
	local caster = keys.caster
	local casterinitloc = caster:GetAbsOrigin()
	local targetPoint = keys.target_points[1]
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	caster:SetAbsOrigin(hero:GetAbsOrigin())
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)

	Timers:CreateTimer(8.0, function()
		caster:SetAbsOrigin(casterinitloc)
		return
	end)

	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local particle2 = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle2, 1, caster:GetAbsOrigin()) -- target effect location
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
end

function ManaEssence(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end
	ability:ApplyDataDrivenModifier(caster, caster, "item_pot_regen", {})
	caster:EmitSound("DOTA_Item.ClarityPotion.Activate")
end

function BerserkScroll(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end
	SetShareCooldown(ability, caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_berserk_scroll", {})
	caster:EmitSound("DOTA_Item.MaskOfMadness.Activate")
end

function SpeedGem(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:HasModifier("jump_pause_nosilence") or caster:HasModifier("modifier_story_for_someones_sake") then
		RefundItem(caster, ability)
		return
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_speed_gem", {})
	caster:EmitSound("DOTA_Item.PhaseBoots.Activate")
end

function CScroll(keys)
	local caster = keys.caster
	local ability = keys.ability 
	local dability = caster:FindAbilityByName("presence_detection_passive")
	local target = keys.target
	local speed = ability:GetSpecialValueFor("speed")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local damage = ability:GetSpecialValueFor("damage")
	--local hero = keys.caster:GetPlayerOwner():GetAssignedHero()
	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end

	SetShareCooldown(ability, caster)
	local c_scroll = {
		Target = target,
		Ability = dability,
		EffectName = "particles/units/heroes/hero_lina/lina_base_attack.vpcf",
		Source = caster,
		iMoveSpeed = speed,
		bDrawsOnMinimap = false, 
		bVisibleToEnemies = true,
		bProvidesVision = false, 
		flExpireTime = GameRules:GetGameTime() + 5, 
		bDodgeable = true,
		Damage = damage,
		Stun = stun_duration
	}

	ProjectileManager:CreateTrackingProjectile(c_scroll) 

	--print('fire c scroll')

	--[[local pid = caster:GetPlayerID()
	cdummy = CreateUnitByName("dummy_unit", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	cdummy:AddNewModifier(caster, caster, "modifier_kill", {duration = 10})
	local dummy_passive = cdummy:FindAbilityByName("dummy_unit_passive")
	dummy_passive:SetLevel(1)
	local fire = cdummy:FindAbilityByName("dummy_c_scroll")
	fire:SetLevel(1)
	if fire:IsFullyCastable() then
		cdummy:CastAbilityOnTarget(keys.target, fire, pid)
	end]]
	caster.ServStat:useC()
	--caster:RemoveItem(keys.ability)

	--[[Timers:CreateTimer(5.0, function()
		if IsValidEntity(cdummy) and not cdummy:IsNull() then
			cdummy:RemoveSelf()
		end
	end)]]

end

function CScrollHit(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	--print('c scroll hit')
	local stun_duration = keys.Stun or 1
	local damage = keys.Damage or 100

	if IsSpellBlocked(target) then return end

	target:EmitSound("Hero_EmberSpirit.FireRemnant.Explode")
	if not target:IsMagicImmune() and not IsImmuneToCC(target) then
		target:AddNewModifier(caster, ability, "modifier_stunned", {Duration = stun_duration})
	end

	DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
end

function CScrollEnd(keys)
	local caster = keys.caster
	local target = keys.target
	if IsValidEntity(caster) and not caster:IsNull() then
		caster:RemoveSelf()
	end
end

function BScroll(keys)
	local caster = keys.caster
	local ability = keys.ability
	--local hero = keys.caster:GetPlayerOwner():GetAssignedHero()

	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end

	if not caster:IsRealHero() then return end

	SetShareCooldown(ability, caster)

	caster.ServStat:useB()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_b_scroll", {})
	caster.BShieldAmount = keys.ShieldAmount
	caster:EmitSound("DOTA_Item.ArcaneBoots.Activate")

end

function DScroll(keys)
	local caster = keys.caster
	local ability = keys.ability
	--local hero = keys.caster:GetPlayerOwner():GetAssignedHero()

	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end

	if not caster:IsRealHero() then return end

	SetShareCooldown(ability, caster)

	--caster.ServStat:useB()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_d_scroll", {})
	caster.DShieldAmount = keys.ShieldAmount
	caster:EmitSound("DOTA_Item.ArcaneBoots.Activate")

end

function EScroll(keys)
	local caster = keys.caster
	local ability = keys.ability
	--local hero = keys.caster:GetPlayerOwner():GetAssignedHero()

	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end

	if not caster:IsRealHero() then return end

	SetShareCooldown(ability, caster)

	--caster.ServStat:useB()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_e_scroll", {})
	caster:EmitSound("DOTA_Item.ArcaneBoots.Activate")

end

function FScroll(keys)
	local caster = keys.caster
	local ability = keys.ability
	--local hero = keys.caster:GetPlayerOwner():GetAssignedHero()

	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end

	if not caster:IsRealHero() then return end

	SetShareCooldown(ability, caster)

	--caster.ServStat:useB()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_f_scroll", {})
	caster:EmitSound("Hero_Marci.Rebound.Cast")

end

LinkLuaModifier("modifier_a_scroll", "items/modifiers/modifier_a_scroll", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_a_scroll_sated", "items/modifiers/modifier_a_scroll_sated", LUA_MODIFIER_MOTION_NONE)

function AScroll(keys)
	local caster = keys.caster
	local ability = keys.ability
	--local hero = keys.caster:GetPlayerOwner():GetAssignedHero()
	local mres = ability:GetSpecialValueFor("bonus_mr")
	local duration = ability:GetSpecialValueFor("duration")
	local satedCooldown = ability:GetSpecialValueFor("satedCooldown")
	local penalty = ability:GetSpecialValueFor("penalty") / 100
	--local satedCooldown = ability:GetCooldown(1) * 0.5

	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end

	if not caster:IsRealHero() then return end

	SetShareCooldown(ability, caster)

	caster.ServStat:useA()
	--ability:ApplyDataDrivenModifier(caster, caster, "modifier_a_scroll", {})
	if caster:HasModifier("modifier_a_scroll_sated") then
		mres = mres * (1 - penalty)
	end

	caster:AddNewModifier(caster, ability, "modifier_a_scroll", { Duration = duration,
																  MagicResistance = mres,
																  Armor = 0,})
	caster:AddNewModifier(caster, ability, "modifier_a_scroll_sated", { Duration = satedCooldown})
	caster:EmitSound("Hero_Oracle.FatesEdict.Cast")
end

function APlusScroll(keys)
	local caster = keys.caster
	local ability = keys.ability
	--local hero = keys.caster:GetPlayerOwner():GetAssignedHero()
	local mres = ability:GetSpecialValueFor("bonus_mr")
	local armor = ability:GetSpecialValueFor("bonus_armor")
	local duration = ability:GetSpecialValueFor("duration")
	local healing = ability:GetSpecialValueFor("healing")
	local satedCooldown = ability:GetSpecialValueFor("satedCooldown")
	local penalty = ability:GetSpecialValueFor("penalty") / 100

	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end

	if not caster:IsRealHero() then return end

	SetShareCooldown(ability, caster)

	caster.ServStat:useA()

	caster:FateHeal(healing, caster, false)
	--ability:ApplyDataDrivenModifier(caster, caster, "modifier_a_scroll", {})
	if caster:HasModifier("modifier_a_scroll_sated") then
		mres = mres * (1 - penalty)
	end

	caster:AddNewModifier(caster, ability, "modifier_a_scroll", { MagicResistance = mres,
																  Armor = armor,
																  Duration = duration })
	caster:AddNewModifier(caster, ability, "modifier_a_scroll_sated", { Duration = satedCooldown})

	caster:EmitSound("Hero_Oracle.FatesEdict.Cast")
	caster:EmitSound("DOTA_Item.Mekansm.Activate")
end

LinkLuaModifier("modifier_sex_scroll_root","items/modifiers/modifier_sex_scroll_root", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sex_scroll_slow","items/modifiers/modifier_sex_scroll_slow", LUA_MODIFIER_MOTION_NONE)

function SScroll(keys)
	local caster = keys.caster
	local ability = keys.ability
	--local hero = keys.caster:GetPlayerOwner():GetAssignedHero()
	local lock_duration = ability:GetSpecialValueFor("lock_duration")
	local slow_duration = ability:GetSpecialValueFor("slow_duration")
	local damage = ability:GetSpecialValueFor("damage")
	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end
	local target = keys.target

	if not caster:IsRealHero() then return end

	SetShareCooldown(ability, caster)

	caster.ServStat:useS()

	if IsSpellBlocked(keys.target) then return end
	

	if not IsImmuneToCC(target) and not IsLightningResist(target) then
		target:AddNewModifier(caster, ability, "modifier_sex_scroll_root", {Duration = lock_duration})
	end

	if not IsImmuneToSlow(target) and not IsImmuneToCC(target) and not IsLightningResist(target) then
		target:AddNewModifier(caster, ability, "modifier_sex_scroll_slow", {Duration = slow_duration})
	end

	local boltFx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl(boltFx, 0, caster:GetAbsOrigin() + Vector(0,0,200))
	ParticleManager:SetParticleControl(boltFx, 1, target:GetAbsOrigin() + Vector(0,0,200))

	--local lightningBoltFx = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_ABSORIGIN, target)
	--ParticleManager:SetParticleControl(lightningBoltFx,0, caster:GetAbsOrigin() + Vector(0,0,200))
	--ParticleManager:SetParticleControl(lightningBoltFx,1, target:GetAbsOrigin() + Vector(0,0,200))

	target:EmitSound("Hero_Zuus.GodsWrath.Target")

	if not IsLightningResist(target) then
		DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
		if IsValidEntity(target) and target:IsAlive() then
			ApplyPurge(target)	
		end
	end

	Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle(boltFx, false)
		--ParticleManager:DestroyParticle(lightningBoltFx, false)
		ParticleManager:ReleaseParticleIndex(boltFx)
		--ParticleManager:ReleaseParticleIndex(lightningBoltFx)
	end)

end

function EXScroll(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	--local hero = keys.caster:GetPlayerOwner():GetAssignedHero()
	local lock_duration = ability:GetSpecialValueFor("lock_duration")
	local slow_duration = ability:GetSpecialValueFor("slow_duration")
	local damage = ability:GetSpecialValueFor("damage")
	local search_aoe = ability:GetSpecialValueFor("search_aoe")
	local max_targets = ability:GetSpecialValueFor("max_targets")
	local forkCount = 0
	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end

	if not caster:IsRealHero() then return end

	SetShareCooldown(ability, caster)

	caster.ServStat:useEX()
	
	if IsSpellBlocked(target) then return end

	target:EmitSound("Hero_Zuus.GodsWrath.Target")
	giveUnitDataDrivenModifier(caster, target, "silenced", 0.1)

	local hero_targets = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, search_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	local creep_targets = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, search_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

	for k,v in pairs(hero_targets) do
		if forkCount >= max_targets then return end

		if v == target then 
			if not IsImmuneToCC(v) and not IsLightningResist(v) then
				v:AddNewModifier(caster, ability, "modifier_sex_scroll_root", {Duration = lock_duration})
			end
		end
	
		if not IsImmuneToSlow(v) and not IsImmuneToCC(v) and not IsLightningResist(v) then
			v:AddNewModifier(caster, ability, "modifier_sex_scroll_slow", {Duration = slow_duration})
		end

		--local boltFx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		--:SetParticleControl(boltFx, 0, caster:GetAbsOrigin() + Vector(0,0,200))
		--ParticleManager:SetParticleControl(boltFx, 1, v:GetAbsOrigin() + Vector(0,0,200))

		local lightningBoltFx = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:SetParticleControl(lightningBoltFx,0, caster:GetAbsOrigin() + Vector(0,0,200))
		ParticleManager:SetParticleControl(lightningBoltFx,1, v:GetAbsOrigin() + Vector(0,0,200))

		if not IsLightningResist(v) then
			DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
			if IsValidEntity(v) and v:IsAlive() then
				ApplyPurge(v)
			end
		end

		Timers:CreateTimer(2.0, function()
			--ParticleManager:DestroyParticle(boltFx, false)
			ParticleManager:DestroyParticle(lightningBoltFx, false)
			--ParticleManager:ReleaseParticleIndex(boltFx)
			ParticleManager:ReleaseParticleIndex(lightningBoltFx)
		end)

		forkCount = forkCount + 1
	end

	if forkCount < max_targets then
		for k,v in pairs(creep_targets) do
			if forkCount >= max_targets then return end

			--local boltFx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
			--ParticleManager:SetParticleControl(boltFx, 0, caster:GetAbsOrigin() + Vector(0,0,200))
			--ParticleManager:SetParticleControl(boltFx, 1, v:GetAbsOrigin() + Vector(0,0,200))

			local lightningBoltFx = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
			ParticleManager:SetParticleControl(lightningBoltFx,0, caster:GetAbsOrigin() + Vector(0,0,200))
			ParticleManager:SetParticleControl(lightningBoltFx,1, v:GetAbsOrigin() + Vector(0,0,200))

			DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)

			if IsValidEntity(v) and v:IsAlive() then
				ApplyPurge(v)
			end

			Timers:CreateTimer(2.0, function()
				--ParticleManager:DestroyParticle(boltFx, false)
				ParticleManager:DestroyParticle(lightningBoltFx, false)
				--ParticleManager:ReleaseParticleIndex(boltFx)
				ParticleManager:ReleaseParticleIndex(lightningBoltFx)
			end)

			forkCount = forkCount + 1
		end
	end

	--local boltFx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	--local lightningBoltFx = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_ABSORIGIN, target)
	--ParticleManager:SetParticleControl(boltFx, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z+((target:GetBoundingMaxs().z - target:GetBoundingMins().z)/2)))

	
	--[[local dist = target:GetAbsOrigin() - caster:GetAbsOrigin()
	local targets = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin() + dist:Normalized() * 150, nil, 600
            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

	if not IsLightningResist(target) then
		DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
		if IsValidEntity(target) and target:IsAlive() then
			ApplyPurge(target)
		end
	end

	for k,v in pairs(targets) do
		if forkCount == 4 then return end
		if v ~= target then
	        
	        local bolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	        ParticleManager:SetParticleControl(bolt, 1, Vector(v:GetAbsOrigin().x,v:GetAbsOrigin().y,v:GetAbsOrigin().z+((v:GetBoundingMaxs().z - v:GetBoundingMins().z)/2)))
	        DoDamage(caster, v, 600, DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
	        Timers:CreateTimer(2.0, function()
				ParticleManager:DestroyParticle(bolt, false)
			end)

			--ParticleManager:SetParticleControl(lightningBoltFx,0, caster:GetAbsOrigin())
			--ParticleManager:SetParticleControl(lightningBoltFx,1, v:GetAbsOrigin())
	        forkCount = forkCount + 1
    	end
    end

   	Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle(boltFx, false)
		--ParticleManager:DestroyParticle(lightningBoltFx, false)
	end)]]
	
end



function HealingScroll(keys)
	local caster = keys.caster
	local ability = keys.ability
	local heal_amount = ability:GetSpecialValueFor("heal_amount")
	local radius = ability:GetSpecialValueFor("radius")

	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end

	SetShareCooldown(ability, caster)

	local healFx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_g.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	
	for k,v in pairs(targets) do
		if v:GetName() ~= "npc_dota_ward_base" and not string.match(v:GetUnitName(), "dummy") then
			ParticleManager:SetParticleControl(healFx, 1, v:GetAbsOrigin()) -- target effect location
    	    v:FateHeal(heal_amount, caster, true)
       		ability:ApplyDataDrivenModifier(caster, v, "modifier_healing_scroll", {})
       	end
    end

   	Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle(healFx, false)
		ParticleManager:ReleaseParticleIndex(healFx)
	end)
end

function AntiMagic(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:HasModifier("jump_pause_nosilence") then
		RefundItem(caster, ability)
		return
	end
	caster:EmitSound("DOTA_Item.BlackKingBar.Activate")
	HardCleanse(caster)
	caster:RemoveModifierByName("modifier_zabaniya_curse")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_magic_immunity", {})
end

function Replenish(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:HasModifier("jump_pause_nosilence")
		or caster:GetHealth() == caster:GetMaxHealth() and caster:GetMana() == caster:GetMaxMana()
	then
		RefundItem(caster, ability)
		return
	end

	SetShareCooldown(ability, caster)

	caster:SetHealth(caster:GetMaxHealth())
	caster:SetMana(caster:GetMaxMana())
	ability:ApplyDataDrivenModifier(caster, caster, "shard_of_replenishment_armor_buff", {})

	caster:EmitSound("DOTA_Item.Mekansm.Activate")
	local mekFx = ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

   	Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle(mekFx, false)
	end)
end
