function OnPoisonousBite(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local duration = ability:GetSpecialValueFor("duration")
	local damage = ability:GetSpecialValueFor("damage")
	local damage_burst = ability:GetSpecialValueFor("damage_burst")
	local stay_range = ability:GetSpecialValueFor("stay_range")
	local radius = ability:GetSpecialValueFor("radius")

   	caster:EmitSound("Semi.AssassinR")

	Timers:CreateTimer(cast_delay / 2, function()
		if caster:IsAlive() then
		   	target:EmitSound("Semi.AssassinRSFX")
		   	target:EmitSound("Semi.AssassinRSFX2")

			local particle = ParticleManager:CreateParticle("particles/semiramis/basmu_claw_new.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())

			local particlewound = ParticleManager:CreateParticle("particles/custom/semiramis/open_wounds.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(particlewound, 0, target:GetAbsOrigin())

		   	if caster.IsAbsoluteAcquired then
		   		if IsFemaleServant(target) then
		   		else
		   			damage = damage + 300
		   		end
		   	end

		   	if caster.IsCharmAcquired then
				local damage_per_int = ability:GetSpecialValueFor("damage_per_int")
				DoDamage(caster, target, damage + (damage_per_int * caster:GetIntellect()) , DAMAGE_TYPE_MAGICAL, 0, ability, false)
			else
				DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
			end

			target:AddNewModifier(caster, ability, "modifier_semiramis_poisonous_bite_debuff", {Duration = duration})

			Timers:CreateTimer(duration, function()

				ParticleManager:DestroyParticle(particlewound, true )

				if caster:IsAlive() then
					local distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()
					if(distance < stay_range) then

					   	target:EmitSound("Semi.AssassinRSFXPop")
					   	target:EmitSound("Semi.AssassinRSFXPop2")

						local enemies = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
						for k,v in pairs(enemies) do
							if IsValidEntity(v) and not v:IsNull() and not v:IsMagicImmune() then
							   	if caster.IsCharmAcquired then
									local burst_per_int = ability:GetSpecialValueFor("burst_per_int")
									DoDamage(caster, target, damage_burst + (burst_per_int * caster:GetIntellect()) , DAMAGE_TYPE_MAGICAL, 0, ability, false)
								else
									DoDamage(caster, target, damage_burst, DAMAGE_TYPE_MAGICAL, 0, ability, false)
								end
								v:AddNewModifier(caster, ability, "modifier_semiramis_poisonous_bite_debuff", {Duration = duration})
							end	
						end

						local particle = ParticleManager:CreateParticle("particles/custom/semiramis/basmu_poison_d.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
						ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
						ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))

					end
				end
			end)
		end
	end)
end

function OnLevelupQCas(keys)
	local caster = keys.caster
	local ability = keys.ability

	caster:FindAbilityByName("semiramis_presence_concealment"):SetLevel(ability:GetLevel())
end
function OnLevelupWCas(keys)
	local caster = keys.caster
	local ability = keys.ability

	if caster.IsCharmAcquired then
		caster:FindAbilityByName("semiramis_snek_spit_poison_upgrade"):SetLevel(ability:GetLevel())
	else
		caster:FindAbilityByName("semiramis_snek_spit_poison"):SetLevel(ability:GetLevel())
	end
end
function OnLevelupRCas(keys)
	local caster = keys.caster
	local ability = keys.ability

	if caster.IsCharmAcquired then
		caster:FindAbilityByName("semiramis_poisonous_bite_upgrade"):SetLevel(ability:GetLevel())
	else
		caster:FindAbilityByName("semiramis_poisonous_bite"):SetLevel(ability:GetLevel())
	end
end

function SemiramisChainsCast(keys)

	LinkLuaModifier("modifier_binding_chains", "abilities/semiramis/modifiers/modifier_binding_chains", LUA_MODIFIER_MOTION_NONE)

	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local bind_duration = ability:GetSpecialValueFor("duration")
	local damage = ability:GetSpecialValueFor("damage")

	local magic_res = target:GetMagicalArmorValue()

	bind_duration = bind_duration * (1 - magic_res)

	if caster.IsCharmAcquired then
		DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	end

   	caster:EmitSound("Semi.CasterQ")
   	target:EmitSound("Semi.CasterQSFX")
   	target:EmitSound("Semi.CasterQSFX2")
	target:AddNewModifier(caster, ability, "modifier_binding_chains", { Duration = bind_duration })
end

function OnBarrierStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ply = caster:GetPlayerOwner()

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_semiramis_shield", {})
	
	if caster.ShieldAmount == nil then 
		caster.ShieldAmount = keys.ShieldAmount
	else
		caster.ShieldAmount = caster.ShieldAmount + keys.ShieldAmount
	end
	if caster.ShieldAmount > keys.MaxShield then
		caster.ShieldAmount = keys.MaxShield
	end
	
   	caster:EmitSound("Semi.CasterW")
   	caster:EmitSound("Semi.CasterWSFX")

	-- Create particle
	if caster.DurabilityParticleIndex == nil then
		local prev_amount = 0.0
		Timers:CreateTimer( function()
				-- Check if shield still valid
				if caster.ShieldAmount > 0 and caster:HasModifier( "modifier_semiramis_shield" ) then
					-- Check if it should update
					if prev_amount ~= caster.ShieldAmount then
						-- Change particle
						local digit = 0
						if caster.ShieldAmount > 999 then
							digit = 4
						elseif caster.ShieldAmount > 99 then
							digit = 3
						elseif caster.ShieldAmount > 9 then
							digit = 2
						else
							digit = 1
						end
						if caster.DurabilityParticleIndex ~= nil then
							-- Destroy previous
							ParticleManager:DestroyParticle( caster.DurabilityParticleIndex, true )
							ParticleManager:ReleaseParticleIndex( caster.DurabilityParticleIndex )
						end
						-- Create new one
						caster.DurabilityParticleIndex = ParticleManager:CreateParticle( "particles/custom/caster/caster_argos_durability.vpcf", PATTACH_CUSTOMORIGIN, caster )
						ParticleManager:SetParticleControlEnt( caster.DurabilityParticleIndex, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true )
						ParticleManager:SetParticleControl( caster.DurabilityParticleIndex, 1, Vector( 0, math.floor( caster.ShieldAmount ), 0 ) )
						ParticleManager:SetParticleControl( caster.DurabilityParticleIndex, 2, Vector( 1, digit, 0 ) )
						ParticleManager:SetParticleControl( caster.DurabilityParticleIndex, 3, Vector( 100, 100, 255 ) )
						
						prev_amount = caster.ShieldAmount	
					end
					
					return 0.1
				else
					if caster.DurabilityParticleIndex ~= nil then
						ParticleManager:DestroyParticle( caster.DurabilityParticleIndex, true )
						ParticleManager:ReleaseParticleIndex( caster.DurabilityParticleIndex )
						caster.DurabilityParticleIndex = nil
					end
					return nil
				end
			end
		)
	end
end

function OnRecallCreate(keys)
	local target = keys.target 
	local ability = keys.ability 
	target.IsRecallCanceled = false

	for k,v in pairs(keys) do
		print(k,v)
	end
end

function OnRecallTakeDamage(keys)
	local target = keys.unit 
	local ability = keys.ability 

	target.IsRecallCanceled = true
	target:RemoveModifierByName("modifier_semiramis_mass_recall")
end

function OnRecallDestroy(keys)
	local target = keys.target 
	local caster = keys.caster 
	local ability = keys.ability 
	local max_range = keys.MaxRange

	if target.IsRecallCanceled then
		return
	end

	local distance = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
	if distance <= max_range then
		target:EmitSound("Semi.GardenMassTeleportPull")
		if caster:IsAlive() then
			target:SetAbsOrigin(caster:GetAbsOrigin() + RandomVector(100))
			FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
		end
	end
end

function OnMassRecallCast(keys)
	local caster = keys.caster
	local ability = keys.ability
	local targetLoc = ability:GetCursorPosition()
	local aoe = ability:GetSpecialValueFor("radius")
	local delay = ability:GetSpecialValueFor("delay")

   	EmitGlobalSound("Semi.GardenMassTeleportCast")
   	
	local enemies = FindUnitsInRadius(caster:GetTeam(), targetLoc, nil, aoe, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(enemies) do
		if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
    		ability:ApplyDataDrivenModifier(caster, v, "modifier_semiramis_mass_recall", {Duration = delay})
	    end
	end
end

function OnBarrierDamaged(keys)
	local caster = keys.caster 
	local currentHealth = caster:GetHealth() 

	caster.ShieldAmount = caster.ShieldAmount - keys.DamageTaken
	if caster.ShieldAmount <= 0 then
		if currentHealth + caster.ShieldAmount <= 0 then
		else
			caster:RemoveModifierByName("modifier_semiramis_shield")
			caster:SetHealth(currentHealth + keys.DamageTaken + caster.ShieldAmount)
			caster.ShieldAmount = 0
		end
	else
		caster:SetHealth(currentHealth + keys.DamageTaken)
	end
end

function OnBarrierThink(keys)
	local caster = keys.caster 
	local ability = keys.ability

	if caster.ShieldAmount == keys.MaxShield then
		return
	end

	if caster.ShieldAmount < keys.MaxShield then
		caster.ShieldAmount = caster.ShieldAmount + keys.Regen
		if caster.ShieldAmount > keys.MaxShield then
		caster.ShieldAmount = keys.MaxShield
		end
	end
end

function OnClassSwap(keys)
	local caster = keys.caster
	local ability = keys.ability 
	
	if caster:HasModifier("modifier_dual_class_cooldown") then
		return 1
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dual_class_cooldown", {})

		if caster:HasModifier("modifier_combo_window") then 
			caster:RemoveModifierByName("modifier_combo_window")
		end

		if caster:HasModifier("modifier_semiramis_class_assassin")  then
			caster:RemoveModifierByName("modifier_semiramis_class_assassin")
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_semiramis_class_caster", {})

			if caster.IsCharmAcquired then
				caster:SwapAbilities(caster:GetAbilityByIndex(0):GetAbilityName(), "semiramis_binding_chains_upgrade", false, true)
			else
				caster:SwapAbilities(caster:GetAbilityByIndex(0):GetAbilityName(), "semiramis_binding_chains", false, true)
			end

			caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "semiramis_barrier", false, true)
			caster:SwapAbilities(caster:GetAbilityByIndex(2):GetAbilityName(), "semiramis_beam_bombard", false, true)

			if caster.IsTerritoryAcquired then
				caster:SwapAbilities(caster:GetAbilityByIndex(5):GetAbilityName(), "semiramis_hanging_gardens_upgrade", false, true)
			else
				caster:SwapAbilities(caster:GetAbilityByIndex(5):GetAbilityName(), "semiramis_hanging_gardens", false, true)
			end
		else
			caster:RemoveModifierByName("modifier_semiramis_class_caster")
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_semiramis_class_assassin", {})
			caster:SwapAbilities(caster:GetAbilityByIndex(0):GetAbilityName(), "semiramis_presence_concealment", false, true)
			caster:SwapAbilities(caster:GetAbilityByIndex(2):GetAbilityName(), "semiramis_poisonous_cloud", false, true)

			if caster.IsCharmAcquired then
				caster:SwapAbilities(caster:GetAbilityByIndex(5):GetAbilityName(), "semiramis_poisonous_bite_upgrade", false, true)
				caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "semiramis_snek_spit_poison_upgrade", false, true)
			else
				caster:SwapAbilities(caster:GetAbilityByIndex(5):GetAbilityName(), "semiramis_poisonous_bite", false, true)
				caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "semiramis_snek_spit_poison", false, true)
			end
		end
	end

end

function OnPassiveThink(keys)
	local caster = keys.caster
	local ability = keys.ability 

	caster:SetMana(caster:GetMana() + 1)
	-- body
end

function OnPresenceConcealmentDeath(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_semiramis_presence_concealment")
end

function OnPresenceConcealmentStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_semiramis_presence_concealment", {})

    caster:EmitSound("KingHassan.WSFX")

	local particle = ParticleManager:CreateParticle("particles/econ/items/drow/drow_ti6/drow_ti6_silence_wave_ground_dust.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle,4, caster:GetAbsOrigin())		
	ParticleManager:SetParticleControl(particle,5, caster:GetAbsOrigin())		
end

function OnHangingGardensCast(keys)
	local caster = keys.caster
	local ability = keys.ability
	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local quake_radius = ability:GetSpecialValueFor("quake_radius")
	local damage = ability:GetSpecialValueFor("damage")
	local damage_radius = ability:GetSpecialValueFor("damage_radius")
	local targetpoint = ability:GetCursorPosition()

	local garden_health = ability:GetSpecialValueFor("garden_health")
	local garden_damage = ability:GetSpecialValueFor("garden_damage")
	local garden_movespeed = ability:GetSpecialValueFor("garden_movespeed")

	giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", cast_delay)

	ScreenShake(caster:GetOrigin(), 3, 0.2, 3.5, 4000, 0, true)

	local cracks = ParticleManager:CreateParticle( "particles/semiramis/hanging_garden_crack.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(cracks, 0, targetpoint)

	EmitGlobalSound("Semi.CasterR1")
	EmitGlobalSound("Semi.CasterR1SFX")


	Timers:CreateTimer(cast_delay, function()
		if caster:IsAlive() then

	   		EmitGlobalSound("Semi.CasterR2")
	   		EmitGlobalSound("Semi.CasterR2SFX")

			ParticleManager:DestroyParticle(cracks, true)
			ScreenShake(caster:GetOrigin(), 7, 0.3, 2.5, 4000, 0, true)

			local tEnemies = FindUnitsInRadius(caster:GetTeam(), targetpoint, nil, quake_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for k,v in pairs(tEnemies) do
				if IsValidEntity(v) and not v:IsNull() and not v:IsMagicImmune() then
					ability:ApplyDataDrivenModifier(caster,v, "modifier_semiramis_babylon_quake",{})
				end	
			end

			local enemies = FindUnitsInRadius(caster:GetTeam(), targetpoint, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for k,v in pairs(enemies) do
				if IsValidEntity(v) and not v:IsNull() and not v:IsMagicImmune() then
					DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
				end	
			end

			local garden = nil

			print("garden parameter")
			print(garden_health)
			print(garden_damage)

			if IsValidEntity(caster.HangingGardens) and caster.HangingGardens:IsAlive() then
				garden = caster.HangingGardens
				caster.HangingGardens:SetAbsOrigin(targetpoint)	

				Timers:CreateTimer(0.05, function()
					garden:SetMaxHealth(garden_health)
					garden:SetBaseMaxHealth(garden_health)
					garden:SetHealth(garden_health - 1)
					garden:SetMana(garden:GetMaxMana() * 0.5)
					garden:SetBaseDamageMin(garden_damage)
					garden:SetBaseDamageMax(garden_damage)
					garden:SetBaseMoveSpeed(garden_movespeed)
				end)

				if garden:HasModifier("modifier_semiramis_babylon_quake") then
					garden:RemoveModifierByName("modifier_semiramis_babylon_quake")
				end
			else
				garden = CreateUnitByName("semiramis_hanging_gardens", targetpoint, true, nil, caster, caster:GetTeamNumber())	

				Timers:CreateTimer(0.05, function()
					garden:SetMaxHealth(garden_health)
					garden:SetBaseMaxHealth(garden_health)
					garden:SetHealth(garden_health - 1)
					garden:SetMana(garden:GetMaxMana() * 0.5)
					garden:SetBaseDamageMin(garden_damage)
					garden:SetBaseDamageMax(garden_damage)
					garden:SetBaseMoveSpeed(garden_movespeed)
				end)

				caster.HangingGardens = garden	
			end	

			if caster.IsTerritoryAcquired then
				garden:FindAbilityByName("semiramis_summon_birds"):SetLevel(2)
				garden:FindAbilityByName("hanging_gardens_mass_recall"):SetLevel(2)
				garden:FindAbilityByName("hanging_gardens_bombard"):SetLevel(2)
				garden:FindAbilityByName("hanging_gardens_mount"):SetLevel(2)
				garden:FindAbilityByName("hanging_garden_presence"):SetLevel(2)
				garden:SwapAbilities("fate_empty1", "hanging_garden_presence", false, true)
				garden:FindAbilityByName("semiramis_hanging_garden_sikera_usum"):SetLevel(2)
			end	

			garden:AddNewModifier(caster, nil, "modifier_kill", { Duration = ability:GetSpecialValueFor("duration") })


			local rocks = ParticleManager:CreateParticle( "particles/semiramis/hanging_garden_build.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( rocks, 0, targetpoint)

			garden:SetControllableByPlayer(caster:GetPlayerID(), true)
			garden:SetOwner(caster)
			FindClearSpaceForUnit(caster.HangingGardens, garden:GetAbsOrigin(), true)

			SemiCheckCombo(caster,ability)
		end
	end)
end

function SemiCheckCombo(caster, ability)
    if math.ceil(caster:GetStrength()) >= 25 and math.ceil(caster:GetAgility()) >= 25 and math.ceil(caster:GetIntellect()) >= 25 then 
		if string.match(ability:GetAbilityName(), caster.RSkill) and not caster:HasModifier("modifier_tiatum_umu_cooldown") then 
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_combo_window", {duration = 5})
		end
    end
end

function OnComboWindow(keys)
	local caster = keys.caster
	caster:SwapAbilities(caster.RSkill, "semiramis_combo", false, true)
end

function OnComboWindowBroken(keys)
	local caster = keys.caster
	if caster:HasModifier("modifier_semiramis_class_assassin") then
		return
	else
		caster:SwapAbilities("semiramis_combo", caster.RSkill, false, true)
	end
end

function OnComboWindowDeath(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_combo_window")
end

function OnComboConditionCheck(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local targetpoint = ability:GetCursorPosition() 
	local min_range = ability:GetSpecialValueFor("minimum_range")
	local semi_range = ability:GetSpecialValueFor("semi_range")
	local garden = caster.HangingGardens

	local distancetogarden = (caster:GetAbsOrigin() - garden:GetAbsOrigin()):Length2D()
	local distancetotarget = (targetpoint - garden:GetAbsOrigin()):Length2D()

	if distancetogarden > semi_range then 
		caster:Interrupt() 
        SendErrorMessage(caster:GetPlayerOwnerID(), "#Hero is Too Far")
        return 
	end

	if distancetotarget < min_range then 
		caster:Interrupt() 
        SendErrorMessage(caster:GetPlayerOwnerID(), "#Too Close to Garden")
        return 
	end
end

function OnTiatumUmuCast(keys)
	local caster = keys.caster
	local ability = keys.ability
	local targetpoint = ability:GetCursorPosition()
	local radius = ability:GetSpecialValueFor("radius")
	local dps = ability:GetSpecialValueFor("dps")
	local duration = ability:GetSpecialValueFor("duration")
	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local garden = caster.HangingGardens

	local ult = caster:FindAbilityByName(caster.RSkill)
	ult:StartCooldown(ult:GetCooldown(ult:GetLevel()))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_tiatum_umu_cooldown", {})	
	caster:RemoveModifierByName("modifier_combo_window")

   	EmitGlobalSound("Semi.Combo")

	if garden == nil then
		garden = CreateUnitByName("semiramis_hanging_gardens", targetpoint, true, nil, caster, caster:GetTeamNumber())		
		garden:SetMaxHealth(ult:GetSpecialValueFor("garden_health"))
		garden:SetMana(garden:GetMaxMana() * 0.4)
		garden:SetBaseDamageMin(ult:GetSpecialValueFor("garden_damage"))
		garden:SetBaseDamageMax(ult:GetSpecialValueFor("garden_damage"))
		garden:SetBaseMoveSpeed(ult:GetSpecialValueFor("garden_movespeed"))
		garden:SetControllableByPlayer(caster:GetPlayerID(), true)
		garden:SetOwner(caster)
		FindClearSpaceForUnit(caster.HangingGardens, garden:GetAbsOrigin(), true)
	end

	caster:SetAbsOrigin(garden:GetAbsOrigin())
	FindClearSpaceForUnit(caster, garden:GetAbsOrigin(), true)

	giveUnitDataDrivenModifier(caster, garden, "jump_pause", cast_delay + duration + 0.25)
	giveUnitDataDrivenModifier(caster, caster, "jump_pause", cast_delay + duration + 0.25)

	local slow = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 20000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	for k,v in pairs(slow) do
		if IsInSameRealm(v:GetAbsOrigin(), caster:GetAbsOrigin()) then 
			ability:ApplyDataDrivenModifier(caster, v, "modifier_tiatum_umu_cast", {})	
		end
	end

	local charge = ParticleManager:CreateParticle( "particles/semiramis/tiatum_umu_channel.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( charge, 0, garden:GetAbsOrigin() + Vector(0,0,200))

	Timers:CreateTimer(cast_delay - 0.8, function()
		local Shine = ParticleManager:CreateParticle( "particles/semiramis/tiatum_umu_shine.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( Shine, 0, garden:GetAbsOrigin() + Vector(0,0,200))


		local blink_prevent = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 20000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for k,v in pairs(blink_prevent) do
			if IsInSameRealm(v:GetAbsOrigin(), caster:GetAbsOrigin()) then 
				ability:ApplyDataDrivenModifier(caster, v, "modifier_tiatum_umu_execute", {})	
			end
		end
	end)

	Timers:CreateTimer(cast_delay + 0.1, function()
		local laser = ParticleManager:CreateParticle( "particles/semiramis/tiatum_umu_laser.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( laser, 0, garden:GetAbsOrigin() + Vector(0,0,200))
		ParticleManager:SetParticleControl( laser, 1, targetpoint)

		Timers:CreateTimer(duration, function()
			local flek = ParticleManager:CreateParticle( "particles/semiramis/tiatum_umu_ground_flek.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl(flek, 0, targetpoint)
			ParticleManager:DestroyParticle(laser,true)
		end)

		for i=duration,0,-0.1 do	
			Timers:CreateTimer(i, function()
				local enemies = FindUnitsInRadius(caster:GetTeam(), targetpoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				for k,v in pairs(enemies) do
					if IsValidEntity(v) and not v:IsNull() and not v:IsMagicImmune() then
						DoDamage(caster, v, dps/10, DAMAGE_TYPE_MAGICAL, 0, ability, false)
					end	
				end
			end)
		end
	end)

	Timers:CreateTimer(cast_delay + 0.05, function()
		local explosion = ParticleManager:CreateParticle( "particles/semiramis/tiatum_umu_explosion_area.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( explosion, 0, targetpoint)
	end)

	Timers:CreateTimer(cast_delay + duration, function()
		local scorch = ParticleManager:CreateParticle( "particles/semiramis/tiatum_umu_scorch.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl(scorch, 0, targetpoint)
	end)
end

function OnMountStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local max_range = ability:GetSpecialValueFor("max_range")
	local hero = caster:GetOwnerEntity()

	local maxhealth = caster:GetMaxHealth()
	local curhealth = caster:GetHealth()

	Timers:CreateTimer(0, function()
		if caster:IsAlive() and not hero:HasModifier("jump_pause") then
			if hero.IsMounted then
				if GridNav:IsBlocked(caster:GetAbsOrigin()) or not GridNav:IsTraversable(caster:GetAbsOrigin()) then
					keys.ability:EndCooldown()
					SendErrorMessage(caster:GetPlayerOwnerID(), "#Cannot_Unmount")

						caster:SetMaxHealth(maxhealth)
						caster:SetBaseMaxHealth(maxhealth)
						caster:SetHealth(curhealth)
					return			
				else
					hero:RemoveModifierByName("modifier_semiramis_mounted")
					caster:RemoveModifierByName("modifier_garden_mounted")
					caster:SwapAbilities("semiramis_hanging_garden_sikera_usum", "fate_empty3", false, true) 
					hero.IsMounted = false
					SendMountStatus(hero)

					caster:SetMaxHealth(maxhealth)
					caster:SetBaseMaxHealth(maxhealth)
					caster:SetHealth(curhealth)
				end
			elseif (caster:GetAbsOrigin() - hero:GetAbsOrigin()):Length2D() < max_range and not hero:HasModifier("stunned") and not hero:HasModifier("modifier_stunned") then 
				hero.IsMounted = true
				ability:ApplyDataDrivenModifier(caster, hero, "modifier_semiramis_mounted", {})
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_garden_mounted", {})  
				caster:SwapAbilities("fate_empty3", "semiramis_hanging_garden_sikera_usum", false, true) 
				SendMountStatus(hero)

					caster:SetMaxHealth(maxhealth)
					caster:SetBaseMaxHealth(maxhealth)
					caster:SetHealth(curhealth)
				return 
			end
		end
	end)
end

function OnHangingGardenSikeraUsum(keys)
	local caster = keys.caster
	local ability = keys.ability
	local targetpoint = ability:GetCursorPosition()
	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")
	local dps = ability:GetSpecialValueFor("dps")
	local duration = ability:GetSpecialValueFor("duration")

	Timers:CreateTimer(cast_delay, function()
		if caster:IsAlive() then

			EmitSoundOnLocationWithCaster(targetpoint, "Semi.GardenBasmu", {})
			EmitSoundOnLocationWithCaster(targetpoint, "Semi.GardenBasmu2", {})

			local cloud = ParticleManager:CreateParticle("particles/custom/semiramis/basmu_circle_parent.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(cloud, 0, targetpoint)

			local enemies = FindUnitsInRadius(caster:GetTeam(), targetpoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for k,v in pairs(enemies) do
				if IsValidEntity(v) and not v:IsNull() and not v:IsMagicImmune() then
					DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
				end	
			end

			for i=duration,0,-0.5 do	
				Timers:CreateTimer(i, function()
					local enemies = FindUnitsInRadius(caster:GetTeam(), targetpoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
					for k,v in pairs(enemies) do
						if IsValidEntity(v) and not v:IsNull() and not v:IsMagicImmune() then
							DoDamage(caster, v, dps/2, DAMAGE_TYPE_MAGICAL, 0, ability, false)
						end	
					end
				end)
			end

			Timers:CreateTimer(duration + 0.5, function()
				ParticleManager:DestroyParticle(cloud,true)
			end)
		end
	end)
end

function GardenFollow(keys)
	local caster = keys.caster
	local hero = caster:GetOwnerEntity()
	if IsValidEntity(caster) then
		hero:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,450))
	end
end

function OnGardenDeath(keys)
	local caster = keys.caster
	local hero = caster:GetOwnerEntity()
	hero.IsMounted = false
	hero:RemoveModifierByName("modifier_semiramis_mounted")
	SendMountStatus(hero)
end

function OnPoisonousCloudCast(keys)
	local caster = keys.caster
	local ability = keys.ability
	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")
	local duration = ability:GetSpecialValueFor("duration")

   	caster:EmitSound("Semi.AssassinE")

	Timers:CreateTimer(cast_delay, function()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_semiramis_poisonous_cloud_buff", {})
	end)
end

function OnPoisonCloudThink(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")

	local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if enemies == nil then return end

   	caster:EmitSound("Semi.AssassinESFX")
	local cloud = ParticleManager:CreateParticle( "particles/custom/semiramis/basmu_poison.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( cloud, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl( cloud, 1, Vector(radius,0,0))

	for k,v in pairs(enemies) do
		if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
			DoDamage(caster, v, damage / 2, DAMAGE_TYPE_MAGICAL, 0, ability, false)
    		ability:ApplyDataDrivenModifier(caster, v, "modifier_semiramis_poisonous_cloud_debuff", {})
	    end
	end
end

function OnGardenPresenceThink(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")
	local mana_drain_per_second = ability:GetSpecialValueFor("mana_drain_per_second")

	if caster:GetOwnerEntity():IsAlive() == false then
		DoDamage(caster, caster, 9999, DAMAGE_TYPE_PURE, 0, ability, false)
	end


	local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if enemies == nil then return end

	for k,v in pairs(enemies) do
		if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
			v:SetMana(v:GetMana() - mana_drain_per_second)
			caster:SetMana(caster:GetMana() + mana_drain_per_second)
    		ability:ApplyDataDrivenModifier(caster, v, "modifier_garden_mana_drain_debuff", {})
	    end
	end
end

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

function OnDualClassAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsDualClassAcquired) then

		UpgradeAttribute(hero, "semiramis_dual_class", "semiramis_dual_class_upgrade" , true)

		hero.IsDualClassAcquired= true
		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnTerritoryAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsTerritoryAcquired) then

		if hero:HasModifier("modifier_combo_window") then
			hero:RemoveModifierByName("modifier_combo_window")
		end

		if hero:HasModifier("modifier_semiramis_class_assassin") then
			UpgradeAttribute(hero, "semiramis_hanging_gardens", "semiramis_hanging_gardens_upgrade" , false)
		else
			UpgradeAttribute(hero, "semiramis_hanging_gardens", "semiramis_hanging_gardens_upgrade" , true)
		end

		hero.IsTerritoryAcquired= true
		hero.RSkill = "semiramis_hanging_gardens_upgrade"
		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnAbsoluteAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsAbsoluteAcquired) then

		UpgradeAttribute(hero, "fate_empty1", "semiramis_absolute_queen" , true)

		hero.IsAbsoluteAcquired = true
		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnCharmerAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsCharmAcquired) then

		if hero:HasModifier("modifier_semiramis_class_assassin") then
			UpgradeAttribute(hero, "semiramis_binding_chains", "semiramis_binding_chains_upgrade" , false)
			UpgradeAttribute(hero, "semiramis_snek_spit_poison", "semiramis_snek_spit_poison_upgrade" , true)
			UpgradeAttribute(hero, "semiramis_poisonous_bite", "semiramis_poisonous_bite_upgrade" , true)
		else
			UpgradeAttribute(hero, "semiramis_binding_chains", "semiramis_binding_chains_upgrade" , true)
			UpgradeAttribute(hero, "semiramis_snek_spit_poison", "semiramis_snek_spit_poison_upgrade" , false)
			UpgradeAttribute(hero, "semiramis_poisonous_bite", "semiramis_poisonous_bite_upgrade" , false)
		end

		hero.IsCharmAcquired = true
		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end