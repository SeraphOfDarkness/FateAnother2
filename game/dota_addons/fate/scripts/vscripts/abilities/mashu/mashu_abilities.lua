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

function MashuCheckCombo(caster, ability)
	print(ability:GetAbilityName())
    if math.ceil(caster:GetStrength()) >= 25 and math.ceil(caster:GetAgility()) >= 25 and math.ceil(caster:GetIntellect()) >= 25 then 
		if string.match(ability:GetAbilityName(), "mashu_snowflake") and not caster:HasModifier("modifier_mashu_combo_cooldown") then 
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_combo_window", {duration = 3})
		elseif string.match(ability:GetAbilityName(), "mashu_snowflake_upgrade") and not caster:HasModifier("modifier_mashu_combo_cooldown") then 
    	print("here3")
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_combo_window", {duration = 3})
		end
    end
end

function OnComboWindow(keys)
	local caster = keys.caster
	caster:SwapAbilities(caster.RSkill, "mashu_combo", false, true)
end

function OnComboWindowBroken(keys)
	local caster = keys.caster
	caster:SwapAbilities(caster.RSkill, "mashu_combo", true, false)
end

function OnComboWindowDeath(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_combo_window")
end

function OnUltUp(keys)
	local caster = keys.caster
	local ability = keys.ability 
	local hero = caster.HeroUnit

	if caster.Barrel then
		caster:FindAbilityByName("mashu_punishment_upgrade"):SetLevel(ability:GetLevel())
	else
		caster:FindAbilityByName("mashu_punishment"):SetLevel(ability:GetLevel())
	end
end

function OnProtectProc(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = caster.ProtectTarget
    local max_range = ability:GetSpecialValueFor("max_range")
    local damage_proc = ability:GetSpecialValueFor("damage_proc")
    local mana_restore = ability:GetSpecialValueFor("mana_restore")
    local invul = ability:GetSpecialValueFor("invul")
    local red_cooldown = ability:GetSpecialValueFor("red_cooldown")
    local aoe = ability:GetSpecialValueFor("aoe")
    local damage = ability:GetSpecialValueFor("damage")

	if keys.DamageTaken >= 50 then
		if target:HasModifier("modifier_mashu_parry") then
    		target:RemoveModifierByName("modifier_mashu_parry") 
			giveUnitDataDrivenModifier(caster, caster, "jump_pause", invul)
		end

		if target:HasModifier("modifier_mashu_protect") then
    		target:RemoveModifierByName("modifier_mashu_protect") 
			giveUnitDataDrivenModifier(caster, caster, "jump_pause", invul)
			caster:SetAbsOrigin(target:GetAbsOrigin())		
		end

		local reviveFx = ParticleManager:CreateParticle("particles/mashu/mashuw/mashuw.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(reviveFx, 0, caster:GetAbsOrigin())

		StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK2, rate=1.1})

    	caster:EmitSound("Mashu.W" .. math.random(1,2))
    	caster:EmitSound("Mashu.WPop1")
    	caster:EmitSound("Mashu.WPop2")

		caster:GiveMana(mana_restore)
		ability:StartCooldown(ability:GetCooldownTimeRemaining() - red_cooldown)
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)

		local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		for k,v in pairs(targets) do
			if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
	       		DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)	       	
	       	end
	    end
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
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.8})

    caster:EmitSound("Mashu.E" .. math.random(1,4))

	Timers:CreateTimer(cast_delay, function()
    	caster:EmitSound("Mashu.EPop1")
    	caster:EmitSound("Mashu.EPop2")

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_mashu_dmg_reduc", {})

		local reviveFx = ParticleManager:CreateParticle("particles/mashu/mashue.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(reviveFx, 0, caster:GetAbsOrigin())

		local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		for k,v in pairs(targets) do
			if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
				ability:ApplyDataDrivenModifier(caster, v, "modifier_mashu_taunt", {})
				v:MoveToTargetToAttack(caster)

				if caster.Amalgam then
   					local damage_from_max_health = ability:GetSpecialValueFor("damage_from_max_health")
	       			DoDamage(caster, v, caster:GetMaxHealth() * damage_from_max_health, DAMAGE_TYPE_MAGICAL, 0, ability, false)	    
				end
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

	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.75})

    caster:EmitSound("Mashu.QStart")

	caster:PreventDI()
	caster:SetPhysicsFriction(0)
	caster:SetPhysicsVelocity(backward * dash_back * 1.5)
   	caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	
	giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", dash_duration)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mashu_bunker_bolting", {})
end

function OnBunkerBoltThink(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius_detect = ability:GetSpecialValueFor("radius_detect")

	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius_detect, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	for k,v in pairs(targets) do
		if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
		    caster:RemoveModifierByName("modifier_mashu_bunker_bolting")

			local damage = ability:GetSpecialValueFor("damage")
			local aoe = ability:GetSpecialValueFor("aoe")
			local stun_duration = ability:GetSpecialValueFor("stun_duration")

			local targets2 = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			for k,v in pairs(targets2) do
				if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
				    caster:RemoveModifierByName("modifier_mashu_bunker_bolting")

					local reviveFx = ParticleManager:CreateParticle("particles/mashu/mashuq/mashuq.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
					ParticleManager:SetParticleControl(reviveFx, 0, caster:GetAbsOrigin())

    				caster:EmitSound("Mashu.Q" .. math.random(1,4))
					EmitSoundOnLocationWithCaster(caster:GetAbsOrigin() , "Mashu.QPop", {})
					EmitSoundOnLocationWithCaster(caster:GetAbsOrigin() , "Mashu.QPop2", {})

					if caster.Barrel then
	   					local damage_per_strength = ability:GetSpecialValueFor("damage_per_strength")
		       			DoDamage(caster, v, damage + caster:GetStrength() * damage_per_strength, DAMAGE_TYPE_MAGICAL, 0, ability, false)	    
					else
						DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
					end

					v:AddNewModifier(caster, ability, "modifier_stunned", {Duration = stun_duration})
		       	end
		    end
		    print("damage dealt once")
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

function OnMashuUlt(keys)
	local caster = keys.caster 
	local ability = keys.ability 
    local radius = ability:GetSpecialValueFor("radius")
    local cast_delay = ability:GetSpecialValueFor("cast_delay")
    local active_instant_heal = ability:GetSpecialValueFor("active_instant_heal")
    local channel_time = ability:GetSpecialValueFor("channel_time")
    local invul = ability:GetSpecialValueFor("invul")

	local eff = ParticleManager:CreateParticle("particles/mashu/mashur/mashur1.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(eff, 0, caster:GetAbsOrigin())


	giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", channel_time)
	StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.8})
    caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4 , 0.8)

	Timers:CreateTimer(cast_delay, function()
		giveUnitDataDrivenModifier(caster, caster, "jump_pause", invul)
	    EmitGlobalSound("Mashu.R" .. math.random(1,2))
	end)

	Timers:CreateTimer(channel_time, function()
		--HardCleanse(caster)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin() , "Mashu.RPop1", {})
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin() , "Mashu.RPop2", {})
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin() , "Mashu.RPop3", {})

		ParticleManager:DestroyParticle( eff, true )

		local reviveFx = ParticleManager:CreateParticle("particles/mashu/mashur/particlepop/mashur-pop1.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(reviveFx, 0, caster:GetAbsOrigin())

		local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		for k,v in pairs(targets) do
			if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
				ability:ApplyDataDrivenModifier(caster, v, "modifier_mashu_snowflake", {})
				v:FateHeal(active_instant_heal, caster, true)
			end
	    end
	    MashuCheckCombo(caster,ability)
	end)	
end

function OnMashuPunishment(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local speed = ability:GetSpecialValueFor("projectile_speed")
	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local width = ability:GetSpecialValueFor("width")
	local length = ability:GetSpecialValueFor("throw_length")
	local target_point = ability:GetCursorPosition()

	giveUnitDataDrivenModifier(caster, caster, "pause_sealenabled", 0.3 + cast_delay)
	StartAnimation(caster, {duration=0.9, activity=ACT_DOTA_ATTACK, rate=1.5})

	Timers:CreateTimer(cast_delay, function()

	    EmitGlobalSound("Mashu.DFStart")

		if caster:IsAlive() then
			local Arrow =
			{
				Ability = keys.ability,
		        EffectName = "particles/mashu/mashudf/shieldproj.vpcf",
		        iMoveSpeed = 9999,
		        vSpawnOrigin = caster:GetOrigin(),
		        fDistance = length,
		        fStartRadius = width,
		        fEndRadius = width,
		        Source = caster,
		        bHasFrontalCone = true,
		        bReplaceExisting = false,
		        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		        fExpireTime = GameRules:GetGameTime() + 3.0,
				bDeleteOnHit = true,
				vVelocity = caster:GetForwardVector() * speed,
			}
			ProjectileManager:CreateLinearProjectile(Arrow)
		end
	end)
end

function OnPunishmentHit(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target 
	local damage = ability:GetSpecialValueFor("damage")
	local stun_revoke = ability:GetSpecialValueFor("stun_revoke")

	if caster:IsAlive() then
	    EmitGlobalSound("Mashu.DF" .. math.random(1,3))

	    EmitGlobalSound("Mashu.DFPop1")
	    EmitGlobalSound("Mashu.DFPop2")

		local particle = ParticleManager:CreateParticle("particles/mashu/mashudf/pop/mashudfpop1.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())		

		caster:SetAbsOrigin(target:GetAbsOrigin())		
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.8})


		giveUnitDataDrivenModifier(caster, target, "pause_sealdisabled", stun_revoke + 0.2)
		giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", stun_revoke - 0.2)

		if caster.Barrel then
			local damage_per_strength = ability:GetSpecialValueFor("damage_per_strength")
   			DoDamage(caster, target, damage + caster:GetStrength() * damage_per_strength, DAMAGE_TYPE_MAGICAL, 0, ability, false)	    
		else
			DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
		end
	end
end


function OnMashuCombo(keys)
	local caster = keys.caster 
	local ability = keys.ability 
    local radius = ability:GetSpecialValueFor("radius")
    local cast_delay = ability:GetSpecialValueFor("cast_delay")
    local channel_time = ability:GetSpecialValueFor("channel_time")
    local active_instant_heal = ability:GetSpecialValueFor("active_instant_heal")
    local invul = ability:GetSpecialValueFor("invul")

	local masterCombo = caster.MasterUnit2:FindAbilityByName("mashu_combo")
	masterCombo:EndCooldown()
	masterCombo:StartCooldown(ability:GetCooldown(1))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mashu_combo_cooldown", {duration = ability:GetCooldown(ability:GetLevel())})
	caster:RemoveModifierByName("modifier_combo_window")

	local charging = ParticleManager:CreateParticle("particles/mashu/mashucombo/mashucombochannel.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(charging, 0, caster:GetAbsOrigin())

	EmitGlobalSound("Mashu.Combo1")
	EmitGlobalSound("Mashu.ComboCharging1")
	EmitGlobalSound("Mashu.ComboCharging2")
	EmitGlobalSound("Mashu.ComboCharging3")

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mashu_combo_chanting", {})

	giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", channel_time)
	StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.8})


	Timers:CreateTimer(0.95, function()
		FreezeAnimation(caster,6)
	end)


	Timers:CreateTimer(2.2, function()
		if caster:IsAlive() then
		EmitGlobalSound("Mashu.ComboShieldAppear")
		EmitGlobalSound("Mashu.ComboShieldAppear2")
		else
			ParticleManager:DestroyParticle( charging, true )
		end
	end)	

	Timers:CreateTimer(4.3, function()
		if caster:IsAlive() then
		EmitGlobalSound("Mashu.ComboShieldAppear")
		EmitGlobalSound("Mashu.ComboShieldAppear2")
		else
			ParticleManager:DestroyParticle( charging, true )
		end
	end)	

	Timers:CreateTimer(0.1, function()
		if caster:IsAlive() then
		EmitGlobalSound("Mashu.ComboShieldAppear")
		EmitGlobalSound("Mashu.ComboShieldAppear2")
		else
			ParticleManager:DestroyParticle( charging, true )
		end
	end)

	Timers:CreateTimer(2, function()
		if caster:IsAlive() then
			EmitGlobalSound("Mashu.Combo2")
		else
			ParticleManager:DestroyParticle( charging, true )
		end
	end)

	Timers:CreateTimer(5, function()
		if caster:IsAlive() then
			EmitGlobalSound("Mashu.Combo3")
		else
			ParticleManager:DestroyParticle( charging, true )
		end
	end)

	Timers:CreateTimer(channel_time, function()
		if caster:IsAlive() then

			EmitGlobalSound("Mashu.ComboPop")
			EmitGlobalSound("Mashu.ComboPop2")

			local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			for k,v in pairs(targets) do
				if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
					ability:ApplyDataDrivenModifier(caster, v, "modifier_mashu_combo", {})
					v:FateHeal(active_instant_heal, caster, true)

    				local barrier_amount = ability:GetSpecialValueFor("barrier_amount")
					ability:ApplyDataDrivenModifier(v, v, "modifier_mashu_combo_barrier", {})
					stack = v:GetModifierStackCount("modifier_mashu_combo_barrier", v) or 0
					v:SetModifierStackCount("modifier_mashu_combo_barrier", v,barrier_amount)

					local fx = ParticleManager:CreateParticle("particles/mashu/mashucombo/mashucombopop.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
					ParticleManager:SetParticleControl(fx, 0, v:GetAbsOrigin())
				end
		    end
		end
	end)	
end

function OnBarrierDamaged(keys)
	local caster = keys.caster 
	local unit = keys.unit 
	local currentHealth = unit:GetHealth() 

	stack = unit:GetModifierStackCount("modifier_mashu_combo_barrier", unit) or 0
	stack = stack - keys.DamageTaken
	unit:SetModifierStackCount("modifier_mashu_combo_barrier", unit,stack)

	if stack <= 0 then
		if currentHealth + stack <= 0 then
		else
			unit:RemoveModifierByName("modifier_mashu_combo_barrier")
			unit:SetHealth(currentHealth + keys.DamageTaken + stack)
			stack = 0
		end
	else
		unit:SetHealth(currentHealth + keys.DamageTaken)
	end
end

function OnBarrelUpgrade(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.Barrel) then
		hero.Barrel = true

		UpgradeAttribute(hero, "mashu_bunker_bolt", "mashu_bunker_bolt_upgrade" , true)
		hero.QSkill = "mashu_bunker_bolt_upgrade"
		UpgradeAttribute(hero, "mashu_punishment", "mashu_punishment_upgrade" , true)
		hero.FSkill = "mashu_punishment_upgrade"

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnShieldUpgrade(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.Shield) then
		hero.Shield = true

		UpgradeAttribute(hero, "mashu_protect", "mashu_protect_upgrade" , true)
		hero.WSkill = "mashu_protect_upgrade"

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnChalkUpgrade(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.Chalk) then
		hero.Chalk = true

		if hero:HasModifier("modifier_combo_window") then
			hero:RemoveModifierByName("modifier_combo_window")
		end

		UpgradeAttribute(hero, "mashu_snowflake", "mashu_snowflake_upgrade" , true)
		hero.RSkill = "mashu_snowflake_upgrade"

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnAmalgamUpgrade(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.Amalgam) then
		hero.Amalgam = true

		UpgradeAttribute(hero, "mashu_taunt", "mashu_taunt_upgrade" , true)
		hero.ESkill = "mashu_taunt_upgrade"

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end
