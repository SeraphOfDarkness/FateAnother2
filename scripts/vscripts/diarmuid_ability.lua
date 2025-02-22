LinkLuaModifier("modifier_golden_rose_of_mortality", "abilities/diarmuid/modifier_golden_rose_of_mortality", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_doublespear_buidhe", "abilities/diarmuid/modifier_doublespear_buidhe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_doublespear_dearg", "abilities/diarmuid/modifier_doublespear_dearg", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mark_of_exorcism", "abilities/diarmuid/modifier_mark_of_exorcism", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_charges", "modifiers/modifier_charges", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_golden_rose", "abilities/diarmuid/modifiers/modifier_golden_rose", LUA_MODIFIER_MOTION_NONE)

function OnLoveSpotStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_love_spot", {})
	DiarmuidCheckCombo(caster, keys.ability)

	caster:EmitSound("Hero_Warlock.ShadowWord")
	Timers:CreateTimer(keys.Duration, function()
		caster:StopSound("Hero_Warlock.ShadowWord")
	end)

end

function OnLovespotThink(keys)
	local caster = keys.caster
	local ability = keys.ability
	local forcemove = {
		UnitIndex = nil,
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION ,
		Position = nil
	}

	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, keys.Radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for k,v in pairs(targets) do
		if IsFemaleServant(v) then
			ability:ApplyDataDrivenModifier(caster, v, "modifier_love_spot_charmed", {})
			giveUnitDataDrivenModifier(caster, v, "silenced", 0.25)
			forcemove.UnitIndex = v:entindex()
			forcemove.Position = caster:GetAbsOrigin() 
			v:Stop()
			ExecuteOrderFromTable(forcemove) 
			--giveUnitDataDrivenModifier(caster, v, "pause_sealenabled", 0.5)
		    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
		    ParticleManager:SetParticleControl(particle, 0, v:GetAbsOrigin())
		end
	end
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
end

function OnChargeStart(keys)
	local caster = keys.caster
	local target = keys.target

	if caster:HasModifier("modifier_charges") then
		keys.ability:EndCooldown()
		local modifier = caster:FindModifierByName("modifier_charges")
		local CDBetweenQ = caster.MasterUnit2:FindAbilityByName("diarmuid_attribute_crimson_rose_of_exorcism"):GetSpecialValueFor("cd_between_Q")
		if modifier:GetStackCount() == 0 then
			keys.ability:StartCooldown(modifier:GetRemainingTime())
		else
			keys.ability:StartCooldown(CDBetweenQ)
		end
	end

	if IsSpellBlocked(keys.target) then return end -- Linken effect checker

	local diff = (target:GetAbsOrigin() - caster:GetAbsOrigin() ):Normalized() 
	caster:SetAbsOrigin(target:GetAbsOrigin() - diff*100) 
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)



	if caster:HasModifier("modifier_double_spearsmanship") then keys.Damage = keys.Damage * 2 end
	local targets = FindUnitsInRadius(caster:GetTeam(), target:GetOrigin(), nil, keys.Radius , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	for k,v in pairs(targets) do
        	DoDamage(caster, v, keys.Damage, DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
        	v:AddNewModifier(caster, v, "modifier_stunned", {Duration = 0.5})
    	end

	if not IsImmuneToSlow(target) then
		keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_warriors_charge_slow", {})
	end


	--particle
	caster:EmitSound("Hero_Huskar.Life_Break")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 3, caster:GetAbsOrigin())
	Timers:CreateTimer( 2.0, function()
		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
	end)
end

function OnDSStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:HasModifier("modifier_rampant_warrior") then return end--appears stacking W and Combo is possible from sealing, remove if stacking is intended feature
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_double_spearsmanship", {duration = keys.Duration})
end

function OnDSLanded(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if not caster.bIsDoubleAttackOnCD then
		Timers:CreateTimer(0.033, function()
			caster:PerformAttack( target, true, true, true, true, false, false, false )
			caster.bIsDoubleAttackOnCD = true
			Timers:CreateTimer(0.066, function()
				caster.bIsDoubleAttackOnCD = false
			end)
		end)
	end
end

function OnRampantWarriorStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	caster:EmitSound("Hero_Clinkz.DeathPact")
	caster:FindAbilityByName("diarmuid_double_spearsmanship"):StartCooldown(19)
	-- Set master's combo cooldown
	local masterCombo = caster.MasterUnit2:FindAbilityByName(keys.ability:GetAbilityName())
	masterCombo:EndCooldown()
	masterCombo:StartCooldown(keys.ability:GetCooldown(1))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_rampant_warrior_cooldown", {duration = ability:GetCooldown(ability:GetLevel())})
	if caster:HasModifier("modifier_double_spearsmanship") then --appears stacking W and Combo is possible from sealing, remove if stacking is intended feature
		caster:RemoveModifierByName("modifier_double_spearsmanship")
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_rampant_warrior", {duration = keys.Duration})

	caster:FindAbilityByName("diarmuid_double_spearsmanship"):ApplyDataDrivenModifier(caster, caster, "modifier_rampant_warrior_combo", {duration = keys.Duration})
	local particle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 3, caster:GetAbsOrigin())
	Timers:CreateTimer( 2.0, function()
		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
	end)
end

function OnRampantWarriorCrit(keys)
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_rampant_warrior_crit_hit", {})
end

function OnGaeCastStart(keys)
	local caster = keys.caster
	local particleName
	if keys.ability == caster:FindAbilityByName("diarmuid_gae_buidhe") then
		caster:EmitSound("ZL.Buidhe_Cast")
		particleName = "particles/custom/diarmuid/diarmuid_gae_cast.vpcf"
	elseif keys.ability == caster:FindAbilityByName("diarmuid_gae_dearg") and caster:GetName() == "npc_dota_hero_huskar" then
		caster:EmitSound("ZL.Dearg_Cast")
		particleName = "particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift.vpcf"
	elseif caster:GetName() == "npc_dota_hero_sven" then
		caster:EmitSound("Lancelot.Growl_Local")
		particleName = "particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift.vpcf"
	end

	if (keys.ability == caster:FindAbilityByName("diarmuid_gae_buidhe") and caster:HasModifier("modifier_doublespear_dearg")) or (keys.ability == caster:FindAbilityByName("diarmuid_gae_dearg") and caster:HasModifier("modifier_doublespear_buidhe")) then
		local CastReduction = caster.MasterUnit2:FindAbilityByName("diarmuid_attribute_double_spear_strike"):GetSpecialValueFor("cast_reduction")
		local NewCastPoint = keys.CastTime - CastReduction
		keys.ability:SetOverrideCastPoint(NewCastPoint)
	end

	local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin()) -- target effect location
	ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin()) -- circle effect location
	Timers:CreateTimer( 2.0, function()
		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
	end)
end

function OnBuidheStart(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local ply = caster:GetPlayerOwner()
	local nStacks = keys.nStacks
	local unitReduction = 10
	local currentStack = target:GetModifierStackCount("modifier_gae_buidhe", ability)

	if IsSpellBlocked(keys.target) then return end -- Linken effect checker
	if caster:HasModifier("modifier_rampant_warrior_combo") then
		ability:EndCooldown()
		ability:RefundManaCost()
		local modifier = caster:FindModifierByName("modifier_rampant_warrior_combo")
		local RWDuration = modifier:GetRemainingTime()
		local RW = caster:FindAbilityByName("diarmuid_rampant_warrior")
		local DurationPenalty = RW:GetSpecialValueFor("duration_penalty")
		caster:RemoveModifierByName("modifier_rampant_warrior_combo")
		caster:RemoveModifierByName("modifier_rampant_warrior")
		caster:FindAbilityByName("diarmuid_double_spearsmanship"):ApplyDataDrivenModifier(caster, caster, "modifier_rampant_warrior_combo", {duration = RWDuration - DurationPenalty})
		caster:FindAbilityByName("diarmuid_rampant_warrior"):ApplyDataDrivenModifier(caster, caster, "modifier_rampant_warrior", {duration = RWDuration - DurationPenalty})
	end

	local healthDiff = target:GetHealth()
	DoDamage(caster, target, keys.Damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)

	healthDiff = healthDiff - target:GetHealth()
	nStacks = math.ceil(healthDiff / 10)	

	if target:GetHealth() > 0 and target:IsAlive() and caster:IsAlive() then	
		if caster.IsGoldenRoseAcquired then 
			target:AddNewModifier(caster, ability, "modifier_golden_rose", {Duration = ability:GetSpecialValueFor("bleed_duration")})
		end	
		target:RemoveModifierByName("modifier_gae_buidhe") 
		ability:ApplyDataDrivenModifier(caster, target, "modifier_gae_buidhe", {}) 
		target:SetModifierStackCount("modifier_gae_buidhe", ability, currentStack + nStacks)
		if target:IsRealHero() then target:CalculateStatBonus() end
	end

	currentStack = target:GetModifierStackCount("modifier_gae_buidhe", ability) --refresh currentstack after debuff

  	if target:GetMaxHealth() < currentStack * unitReduction then -- for heroes that modifies maxHp like avenger with E
		target:Execute(ability, caster)
	elseif target:GetHealth() > (target:GetMaxHealth() - currentStack * unitReduction) then
		target:SetHealth(target:GetMaxHealth() - currentStack * unitReduction)
	end

	Timers:CreateTimer(function()
		if not target:HasModifier("modifier_gae_buidhe") then return end
		-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff_symbol.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
  --   	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin() )
  		if target:GetMaxHealth() < currentStack * unitReduction then -- for heroes that modifies maxHp like avenger with E
			target:Execute(ability, caster)
		elseif target:GetHealth() > (target:GetMaxHealth() - currentStack * unitReduction) then
			target:SetHealth(target:GetMaxHealth() - currentStack * unitReduction)
		end
		return 0.033
		end
	)

	EmitGlobalSound("ZL.Gae_Buidhe")
	target:EmitSound("Hero_Lion.Impale")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_diarmuid_gae_buidhe_anim", {})
	PlayGaeEffect(target)
	-- Add dagon particle
	local dagon_particle = ParticleManager:CreateParticle("particles/custom/diarmuid/diarmuid_gae_buidhe.vpcf",  PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControlEnt(dagon_particle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), false)
	local particle_effect_intensity = 600
	ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity))
	Timers:CreateTimer( 2.0, function()
		ParticleManager:DestroyParticle( dagon_particle, false )
		ParticleManager:ReleaseParticleIndex( dagon_particle )
	end)

	if caster.IsDoubleSpearAcquired then
		local Duration = caster.MasterUnit2:FindAbilityByName("diarmuid_attribute_double_spear_strike"):GetSpecialValueFor("duration")
		caster:AddNewModifier(caster, caster, "modifier_doublespear_buidhe", {duration = Duration})
		caster:RemoveModifierByName("modifier_doublespear_dearg")
	end

	ability:SetOverrideCastPoint(keys.CastTime)

	--[[if caster.IsDoubleSpearAcquired and caster.IsDoubleSpearReady and caster:FindAbilityByName("diarmuid_gae_dearg"):IsCooldownReady() and caster:GetMana() >= 550 then
		--print("Double spear activated")
		local dearg = caster:FindAbilityByName("diarmuid_gae_dearg")
		local minDamage = dearg:GetLevelSpecialValueFor("min_damage", dearg:GetLevel()-1)
		local maxDamage = dearg:GetLevelSpecialValueFor("max_damage", dearg:GetLevel()-1)
		keys.MinDamage = minDamage
		keys.MaxDamage = maxDamage
		Timers:CreateTimer(0.033, function()
			caster:FindAbilityByName("diarmuid_gae_dearg"):StartCooldown(32)
			local doublestrike = caster:FindAbilityByName("diarmuid_double_spear_strike")
			doublestrike:StartCooldown(55)
			if doublestrike:GetToggleState() == true then
				doublestrike:ToggleAbility()
			end
			caster:SetMana(caster:GetMana() - 550)
			Timers:CreateTimer(55.2, function()
				if doublestrike:IsCooldownReady() and not doublestrike:GetToggleState() then 
					doublestrike:ToggleAbility()
				end
			end)
			OnDeargStart(keys)
		end)
		--caster:CastAbilityOnTarget(target, caster:FindAbilityByName("diarmuid_gae_dearg"), caster:GetPlayerID())
	end]]
end

function OnBuidheOwnerDeath(keys)
	local caster = keys.caster
    LoopOverHeroes(function(hero)
    	hero:RemoveModifierByName("modifier_gae_buidhe")
    end)
end

function OnBuidheBearerDeath(keys)
	--PrintTable(keys)
	local unit = keys.unit
	unit:RemoveModifierByName("modifier_gae_buidhe")
end

function OnDeargStart(keys)
	ArsenalReturnMana(keys.caster)
	local caster = keys.caster
	local target = keys.target
	local ply = caster:GetPlayerOwner()
	if IsSpellBlocked(keys.target) then return end -- Linken effect checker

	if caster:HasModifier("modifier_rampant_warrior_combo") then
		keys.ability:EndCooldown()
		keys.ability:RefundManaCost()
		local modifier = caster:FindModifierByName("modifier_rampant_warrior_combo")
		local RWDuration = modifier:GetRemainingTime()
		local RW = caster:FindAbilityByName("diarmuid_rampant_warrior")
		local DurationPenalty = RW:GetSpecialValueFor("duration_penalty")
		caster:RemoveModifierByName("modifier_rampant_warrior_combo")
		caster:RemoveModifierByName("modifier_rampant_warrior")
		caster:FindAbilityByName("diarmuid_double_spearsmanship"):ApplyDataDrivenModifier(caster, caster, "modifier_rampant_warrior_combo", {duration = RWDuration - DurationPenalty})
		caster:FindAbilityByName("diarmuid_rampant_warrior"):ApplyDataDrivenModifier(caster, caster, "modifier_rampant_warrior", {duration = RWDuration - DurationPenalty})
	end

	ApplyStrongDispel(target)

	local damage = 0
	local maxDamageDist = 200
	local minDamageDist = 500

	if caster.IsCrimsonRoseAcquired then
		maxDamageDist = 300
	end
	
	local distDiff =  minDamageDist - maxDamageDist
	local damageDiff = keys.MaxDamage - keys.MinDamage
	local distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() 
	if distance <= maxDamageDist then 
		damage = keys.MaxDamage
	elseif maxDamageDist < distance and distance < minDamageDist then
		damage = keys.MinDamage + damageDiff * (minDamageDist - distance) / distDiff
	elseif minDamageDist <= distance then
		damage = keys.MinDamage
	end

	--print(damage)

	DoDamage(caster, target, damage, DAMAGE_TYPE_PURE, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, keys.ability, false)

	local magicResist = target:GetBaseMagicalResistanceValue()
	--print(magicResist)

	--print("Gae Dearg dealt " .. damage .. " damage to target")
	--[[if target:HasModifier("modifier_mark_of_mortality") then
		local detonateDamage = target:GetMaxHealth() * caster:FindAbilityByName("diarmuid_gae_dearg"):GetSpecialValueFor("mortality_pct")/100
		DoDamage(caster, target, detonateDamage, DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
		print("Detonate")
		target:RemoveModifierByName("modifier_mark_of_mortality")
	end]]

	if caster.IsCrimsonRoseAcquired then
		giveUnitDataDrivenModifier(caster, target, "revoked", 2.0)
		local diff = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
		caster:SetAbsOrigin(target:GetAbsOrigin() - diff * 100)
		FindClearSpaceForUnit( caster, caster:GetAbsOrigin(), true )
		--target:AddNewModifier(caster, target, "modifier_mark_of_exorcism", {duration = 10.0})
	end

	--[[if caster.IsDoubleSpearAcquired then
		target:AddNewModifier(caster, target, "modifier_stunned", {Duration = 0.5})
	end]]

	if caster:GetName() == "npc_dota_hero_huskar" then EmitGlobalSound("ZL.Gae_Dearg") end
	target:EmitSound("Hero_Lion.Impale")
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_diarmuid_gae_dearg_anim", {})
	PlayGaeEffect(target)
	-- Add dagon particle
	local dagon_particle = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf",  PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControlEnt(dagon_particle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), false)
	local particle_effect_intensity = 600
	ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity))
	Timers:CreateTimer( 2.0, function()
		ParticleManager:DestroyParticle( dagon_particle, false )
		ParticleManager:ReleaseParticleIndex( dagon_particle )
	end)

	if caster.IsDoubleSpearAcquired then
		local Duration = caster.MasterUnit2:FindAbilityByName("diarmuid_attribute_double_spear_strike"):GetSpecialValueFor("duration")
		caster:AddNewModifier(caster, caster, "modifier_doublespear_dearg", {duration = Duration})
		caster:RemoveModifierByName("modifier_doublespear_buidhe")
	end

	keys.ability:SetOverrideCastPoint(keys.CastTime)

	--[[if caster.IsDoubleSpearAcquired and caster.IsDoubleSpearReady and caster:FindAbilityByName("diarmuid_gae_buidhe"):IsCooldownReady() and caster:GetMana() >= 550 then
		--print("Double spear activated")
		local buidhe = caster:FindAbilityByName("diarmuid_gae_buidhe")
		keys.Damage = buidhe:GetLevelSpecialValueFor("damage", buidhe:GetLevel()-1)
		keys.ability = buidhe
		Timers:CreateTimer(0.033, function()
			caster:FindAbilityByName("diarmuid_gae_buidhe"):StartCooldown(32)
			local doublestrike = caster:FindAbilityByName("diarmuid_double_spear_strike")
			doublestrike:StartCooldown(55)
			if doublestrike:GetToggleState() == true then
				doublestrike:ToggleAbility()
			end
			caster:SetMana(caster:GetMana() - 550)
			Timers:CreateTimer(55.2, function()
				if doublestrike:IsCooldownReady() and not doublestrike:GetToggleState() then 
					doublestrike:ToggleAbility()
				end
			end)
			OnBuidheStart(keys)
		end)
		--caster:CastAbilityOnTarget(target, caster:FindAbilityByName("diarmuid_gae_dearg"), caster:GetPlayerID())
	end]]
end

--[[function PlayGaeEffect(target)
	local culling_kill_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(culling_kill_particle, 8, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(culling_kill_particle)
	Timers:CreateTimer( 2.0, function()
		ParticleManager:DestroyParticle( culling_kill_particle, false )
		ParticleManager:ReleaseParticleIndex( culling_kill_particle )
	end)
end ]]

function OnMindEyeStart(keys)
	local caster = keys.caster
	local sightdummy = CreateUnitByName("sight_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
	sightdummy:SetDayTimeVisionRange(caster:GetDayTimeVisionRange() + 150)
	sightdummy:SetNightTimeVisionRange(caster:GetNightTimeVisionRange() + 150)
	local sightdummypassive = sightdummy:FindAbilityByName("dummy_unit_passive")
	sightdummypassive:SetLevel(1)

	caster.MindsEyeDummy = sightdummy

	Timers:CreateTimer(function() 
		if not IsValidEntity(sightdummy) then return end
		if caster:IsAlive() then
			sightdummy:SetAbsOrigin(caster:GetAbsOrigin())
		else
			sightdummy:SetAbsOrigin(caster.MasterUnit:GetAbsOrigin())
		end
		return 0.2
	end)
end

function OnMindEyeEnd(keys)
	local caster = keys.caster
	if IsValidEntity(caster.MindsEyeDummy) then 
		caster.MindsEyeDummy:ForceKill(true)
	end
end

function OnDSToggleOn(keys)
	local caster = keys.caster
	--print("double spear on")
	caster.IsDoubleSpearReady = true
end

function OnDSToggleOff(keys)
	local caster = keys.caster
	--print("double spear off")
	caster.IsDoubleSpearReady = false
end

function OnLoveSpotImproved(keys)
    local caster = keys.caster
    local ply = caster:GetPlayerOwner()
    local hero = caster:GetPlayerOwner():GetAssignedHero()
    hero.IsLoveSpotImproved = true
    hero:FindAbilityByName("diarmuid_love_spot"):SetLevel(2)
    -- Set master 1's mana 
    local master = hero.MasterUnit
    master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnMindEyeAcquired(keys)
    local caster = keys.caster
    local ply = caster:GetPlayerOwner()
    local hero = caster:GetPlayerOwner():GetAssignedHero()
    hero.IsMindEyeAcquired = true
    hero:AddAbility("diarmuid_minds_eye") 
    hero:FindAbilityByName("diarmuid_minds_eye"):SetLevel(1)
    hero:FindAbilityByName("diarmuid_minds_eye"):SetHidden(true)
    hero:SetDayTimeVisionRange(1100)
    hero:SetNightTimeVisionRange(1100)
    -- Set master 1's mana 
    local master = hero.MasterUnit
    master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnGoldenRoseAcquired(keys)
    local caster = keys.caster
    local ply = caster:GetPlayerOwner()
    local hero = caster:GetPlayerOwner():GetAssignedHero()
    hero.IsGoldenRoseAcquired = true
    hero:AddNewModifier(hero, ability, "modifier_golden_rose_of_mortality", {})
    -- Set master 1's mana 
    local master = hero.MasterUnit
    master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnCrimsonRoseAcquired(keys)
    local caster = keys.caster
    local ply = caster:GetPlayerOwner()
    local hero = caster:GetPlayerOwner():GetAssignedHero()
    hero.IsCrimsonRoseAcquired = true
		Timers:CreateTimer(function()
			if hero:IsAlive() then 
		    hero:AddNewModifier(hero, hero:FindAbilityByName("diarmuid_warriors_charge"), "modifier_charges",
		    	{
		    		max_count = 2,
		    		start_count = 1,
		    		replenish_time = 9
		    	}
		    )
				return nil
			else
				return 1
			end
		end)
    -- Set master 1's mana 
    local master = hero.MasterUnit
    master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnDoubleSpearAcquired(keys)
    local caster = keys.caster
    local ply = caster:GetPlayerOwner()
    local hero = caster:GetPlayerOwner():GetAssignedHero()
    hero.IsDoubleSpearAcquired = true
    --[[hero.IsDoubleSpearReady = true
    hero:SwapAbilities("fate_empty1", "diarmuid_double_spear_strike", false, true) 
	hero:FindAbilityByName("diarmuid_double_spear_strike"):ToggleAbility()]]
    -- Set master 1's mana 
    local master = hero.MasterUnit
    master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function DiarmuidCheckCombo(caster, ability)
	if caster:GetStrength() >= 19.1 and caster:GetAgility() >= 19.1 and caster:GetIntellect() >= 19.1 then
		if ability == caster:FindAbilityByName("diarmuid_love_spot") and caster:FindAbilityByName("diarmuid_double_spearsmanship"):IsCooldownReady() and caster:FindAbilityByName("diarmuid_rampant_warrior"):IsCooldownReady()  then
			caster:SwapAbilities("diarmuid_double_spearsmanship", "diarmuid_rampant_warrior", false, true) 
			Timers:CreateTimer({
				endTime = 3,
				callback = function()
				caster:SwapAbilities("diarmuid_double_spearsmanship", "diarmuid_rampant_warrior", true, false) 
			end
			})
		end
	end
end
