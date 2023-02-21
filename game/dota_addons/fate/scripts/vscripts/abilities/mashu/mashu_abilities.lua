function OnProtectCastStart(keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local cast_delay = ability:GetSpecialValueFor("cast_delay")

	Timers:CreateTimer(cast_delay, function()
		if caster.ProtectTarget == nil then
		    if target == caster then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_mashu_parry", {})
		    else
				ability:ApplyDataDrivenModifier(caster, target, "modifier_mashu_protect", {})
		    end
	    	caster.ProtectTarget = keys.target
		else
			if caster.ProtectTarget:HasModifier("modifier_mashu_protect") then
		    	caster.ProtectTarget:RemoveModifierByName("modifier_mashu_protect")
		    end
		    if caster.ProtectTarget:HasModifier("modifier_mashu_parry") then
		    	caster.ProtectTarget:RemoveModifierByName("modifier_mashu_parry") 
		    end

	    	caster.ProtectTarget = keys.target
		    if target == caster then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_mashu_parry", {})
		    else
				ability:ApplyDataDrivenModifier(caster, target, "modifier_mashu_protect", {})
		    end
	   	end
	end)
end 

function OnProtectProc(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = caster.ProtectTarget
    local max_range = ability:GetSpecialValueFor("max_range")
    local damage_proc = ability:GetSpecialValueFor("damage_proc")
    local mana_restore = ability:GetSpecialValueFor("mana_restore")
    local red_cooldown = ability:GetSpecialValueFor("red_cooldown")

	if keys.DamageTaken >= 200 then
		if target:HasModifier("modifier_mashu_parry") then
    		target:RemoveModifierByName("modifier_mashu_parry") 
		end

		if target:HasModifier("modifier_mashu_protect") then
    		target:RemoveModifierByName("modifier_mashu_protect") 
		end

		local reviveFx = ParticleManager:CreateParticle("particles/mashu/mashuw/mashuw.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(reviveFx, 0, caster:GetAbsOrigin())

		caster:SetAbsOrigin(target:GetAbsOrigin())
		caster:GiveMana(mana_restore)
		ability:StartCooldown(ability:GetCooldownTimeRemaining() - red_cooldown)
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
	end
end

function OnProtectThink(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = caster.ProtectTarget
    local max_range = ability:GetSpecialValueFor("max_range")
	local distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() 

	if distance > max_range then
		if target:HasModifier("modifier_mashu_parry") then
    		target:RemoveModifierByName("modifier_mashu_parry") 
		end

		if target:HasModifier("modifier_mashu_protect") then
    		target:RemoveModifierByName("modifier_mashu_protect") 
		end	
	end
end

function OnMashuTaunt(keys)
	local caster = keys.caster 
	local ability = keys.ability 
    local radius = ability:GetSpecialValueFor("radius")
    local cast_delay = ability:GetSpecialValueFor("cast_delay")
    local channel_time = ability:GetSpecialValueFor("channel_time")

	giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", channel_time)

	Timers:CreateTimer(cast_delay, function()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_mashu_dmg_reduc", {})

		local reviveFx = ParticleManager:CreateParticle("particles/mashu/mashue.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(reviveFx, 0, caster:GetAbsOrigin())

		local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		for k,v in pairs(targets) do
			if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
				ability:ApplyDataDrivenModifier(caster, v, "modifier_mashu_taunt", {})
				v:MoveToTargetToAttack(caster)
	       	end
	    end
	end)
end

function OnMashuTauntThink(keys)
	local unit = keys.target 
	local caster = keys.caster 
	local ability = keys.ability

	if caster:IsAlive() then
	    local particle = ParticleManager:CreateParticle("particles/mashu/mashu_taunted.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	    ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())
		unit:MoveToTargetToAttack(caster)
   	else
		unit:RemoveModifierByName("modifier_mashu_taunt")
   	end
end

function OnMashuTauntDestroy(keys)
	local unit = keys.target 
	unit:SetForceAttackTarget(nil)	
end

function OnBunkerBolt(keys)
	local caster = keys.caster
	local ability = keys.ability
	local dash_back = ability:GetSpecialValueFor("range")
	local dash_duration = ability:GetSpecialValueFor("dash_duration")

	local dashback = Physics:Unit(caster)
	local origin = caster:GetOrigin()
	local backward = caster:GetForwardVector()

	caster:PreventDI()
	caster:SetPhysicsFriction(0)
	caster:SetPhysicsVelocity(backward * dash_back)
   	caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	
	giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", dash_duration)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mashu_bunker_bolting", {})
end

function OnBunkerBoltThink(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius_detect = ability:GetSpecialValueFor("radius_detect")

	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius_detect, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)

	if targets == nil then return end

	local damage = ability:GetSpecialValueFor("damage")
	local aoe = ability:GetSpecialValueFor("aoe")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")

	local targets2 = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	for k,v in pairs(targets2) do
		if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
		    caster:RemoveModifierByName("modifier_mashu_bunker_bolting")

			local reviveFx = ParticleManager:CreateParticle("particles/mashu/mashuq/mashuq.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(reviveFx, 0, caster:GetAbsOrigin())

			DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
			v:AddNewModifier(caster, ability, "modifier_stunned", {Duration = stun_duration})
		    return
       	end
    end
end

function OnBunkerBoltDeath(keys)
	local caster = keys.caster

	caster:PreventDI(false)
	caster:SetPhysicsVelocity(Vector(0,0,0))
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
end