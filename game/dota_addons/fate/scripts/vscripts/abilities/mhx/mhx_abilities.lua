
function OnQ(keys)
	local caster = keys.caster
	local ability = keys.ability
	local range = ability:GetSpecialValueFor("range")
	local targetpoint = ability:GetCursorPosition()

	--marble here
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mhx_q_buff", {})

	local fRange = ability:GetSpecialValueFor("range")

	caster:EmitSound("MHX.QSFX")
    -- Sound effects
    if caster:HasModifier("modifier_alternate_02") then
		caster:EmitSound("KIRITO.Q")
    else
		caster:EmitSound("MHX.Q" ..math.random(1,2))
    end

 	AbilityBlinkNoEffects(caster,targetpoint, fRange, {})

 	local newpos = caster:GetAbsOrigin()

	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)

	local particleeff1 = ParticleManager:CreateParticle("particles/mhx/mhx_q.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particleeff1, 0, caster:GetAbsOrigin())

	MhxCheckCombo(caster,ability)
end
-- Table to track damage instances
local damageInstances = {}

function OnWStart(keys)
    -- Reset the damage instances table for this cast
    damageInstances = {}

    local caster = keys.caster
    local ability = keys.ability 
    local speed = ability:GetSpecialValueFor("projectile_speed")
    local range = ability:GetSpecialValueFor("range")
    local width = ability:GetSpecialValueFor("width")
    local cast_delay = ability:GetSpecialValueFor("cast_delay")
    local targetpoint = ability:GetCursorPosition()

    StartAnimation(caster, {duration = 0.3, activity=ACT_DOTA_CAST_ABILITY_4_END, rate=3})

    giveUnitDataDrivenModifier(caster, caster, "pause_sealenabled", cast_delay)
    Timers:CreateTimer(cast_delay, function()
        local air_burst = 
        {
            Ability = ability,
            EffectName = "particles/mhx/mhx_w.vpcf",
            iMoveSpeed = speed,
            vSpawnOrigin = caster:GetAbsOrigin(),
            fDistance = range - width + 100,
            fStartRadius = width,
            fEndRadius = width,
            Source = caster,
            bHasFrontalCone = true,
            bReplaceExisting = false,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            fExpireTime = GameRules:GetGameTime() + 2.0,
            bDeleteOnHit = false,
            vVelocity = caster:GetForwardVector() * speed,
        }   

        local forward_vector = caster:GetForwardVector()

        caster.air_burst = ProjectileManager:CreateLinearProjectile(air_burst)

        -- Sound effects
        if caster:HasModifier("modifier_alternate_02") then
        	caster:EmitSound("KIRITO.W" ..math.random(1,2))
        else
        	caster:EmitSound("MHX.W" ..math.random(1,2))
        end
        caster:EmitSound("MHX.WSFX")
        caster:EmitSound("MHX.WSFXFOLLOW1")
        caster:EmitSound("MHX.WSFXFOLLOW2")
        
        if(caster.BurstAcquired) then
            local split_range = ability:GetSpecialValueFor("w_split_range")
            local split_delay = ability:GetSpecialValueFor("split_delay")
            local originsplit = caster:GetAbsOrigin() + caster:GetForwardVector() * range
            -- Launch split projectiles on expiration
            Timers:CreateTimer(split_delay, function()
                LaunchSplitProjectiles(caster, ability, originsplit, speed, width, split_range, split_damage_perc, forward_vector)
            end)
        end
    end)
end

function OnWHit(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability

    if not IsValidEntity(target) or target:IsNull() then return end

    -- Initialize damage instances for this target if not already done
    if not damageInstances[target:GetEntityIndex()] then
        damageInstances[target:GetEntityIndex()] = 0
    end

    -- Maximum damage instances per target
    local maxDamageInstances = 2

    -- Apply damage only if the target has taken less than the max instances
    if damageInstances[target:GetEntityIndex()] < maxDamageInstances then
        local base_damage = ability:GetSpecialValueFor("damage")
        DoDamage(caster, target, base_damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
        
        -- Increment damage instance count for this target
        damageInstances[target:GetEntityIndex()] = damageInstances[target:GetEntityIndex()] + 1
    end

    target:EmitSound("MHX.WSFX2")
    if not target:IsMagicImmune() or not IsImmuneToSlow(target) then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_mhx_w_debuff", {Duration = 1})
	end
end

function LaunchSplitProjectiles(caster, ability, origin, speed, width, split_range, split_damage_perc,fowardvec)
	EmitSoundOnLocationWithCaster(origin, "MHX.WSFX", caster)
	EmitSoundOnLocationWithCaster(origin, "MHX.WSFXFOLLOW1", caster)
	EmitSoundOnLocationWithCaster(origin, "MHX.WSFXFOLLOW2", caster)

	local forward_vector = fowardvec
	local angle1 = RotatePosition(Vector(0,0,0), QAngle(0, 45, 0), forward_vector)
	local angle2 = RotatePosition(Vector(0,0,0), QAngle(0, -45, 0), forward_vector)
	-- Store projectiles in a table with unique IDs
	-- First split projectile
	local split_projectile1 = {
		Ability = ability,
        EffectName = "particles/mhx/mhx_w.vpcf",
        iMoveSpeed = speed,
        vSpawnOrigin = origin,
        fDistance = split_range,
        fStartRadius = width,
        fEndRadius = width,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 2.0,
        bDeleteOnHit = false,
        vVelocity = angle1 * speed,
	}
	ProjectileManager:CreateLinearProjectile(split_projectile1)

	-- Second split projectile
	local split_projectile2 = {
		Ability = ability,
        EffectName = "particles/mhx/mhx_w.vpcf",
        iMoveSpeed = speed,
        vSpawnOrigin = origin,
        fDistance = split_range,
        fStartRadius = width,
        fEndRadius = width,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 2.0,
        bDeleteOnHit = false,
        vVelocity = angle2 * speed,
	}
	ProjectileManager:CreateLinearProjectile(split_projectile2)
end

function OnE(keys)
	local caster = keys.caster
	local ability = keys.ability
	local aoe = ability:GetSpecialValueFor("aoe")
	local damage = ability:GetSpecialValueFor("damage")
	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local refactor_damage = ability:GetSpecialValueFor("refactor_damage")
	local refactor_root = ability:GetSpecialValueFor("refactor_root")
	local refactor_delay = ability:GetSpecialValueFor("refactor_delay")

	StartAnimation(caster, {duration = cast_delay, activity=ACT_DOTA_CAST_ABILITY_2_END, rate=2})
	giveUnitDataDrivenModifier(caster, caster, "jump_pause", cast_delay)
	giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", cast_delay - 0.15)

    -- Sound effects
    if caster:HasModifier("modifier_alternate_02") then
    	caster:EmitSound("KIRITO.E" ..math.random(1,3))
    else
		caster:EmitSound("MHX.EVOICE")
    end


    Timers:CreateTimer(cast_delay - 0.125, function()
		caster:EmitSound("MHX.ESFX2")
   		Timers:CreateTimer(0.05, function()
		caster:EmitSound("MHX.ESFXFOLLOW2")
		end)
	end)

    Timers:CreateTimer(cast_delay, function()
		caster:EmitSound("MHX.ESFX")
   		Timers:CreateTimer(0.05, function()
		caster:EmitSound("MHX.ESFXFOLLOW")
		end)
		if caster:IsAlive() then	
			StartAnimation(caster, {duration=cast_delay - 0.25, activity=ACT_DOTA_ATTACK_EVENT, rate=1.2})

			local particleeff1 = ParticleManager:CreateParticle("particles/mhx/mhx_e.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff1, 0, caster:GetAbsOrigin())

			local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for k,v in pairs(targets) do
				if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
			       	DoDamage(caster, v, damage , DAMAGE_TYPE_MAGICAL, 0, ability, false)
    				Timers:CreateTimer(refactor_delay, function()
			       		DoDamage(caster, v, refactor_damage , DAMAGE_TYPE_MAGICAL, 0, ability, false)
						v:AddNewModifier(caster, ability, "modifier_rooted", {Duration = refactor_root}) 
						local particleeff11 = ParticleManager:CreateParticle("particles/econ/items/ursa/ursa_ti10/ursa_ti10_earthshock_electric_center.vpcf", PATTACH_ABSORIGIN, v)
						ParticleManager:SetParticleControl(particleeff11, 0, v:GetAbsOrigin())
						local particleeff22 = ParticleManager:CreateParticle("particles/econ/items/ursa/ursa_ti10/ursa_ti10_earthshock_electric_vertical_child.vpcf", PATTACH_ABSORIGIN, v)
						ParticleManager:SetParticleControl(particleeff22, 0, v:GetAbsOrigin())
						local particleeff33 = ParticleManager:CreateParticle("particles/econ/items/vengeful/vengeful_arcana/vengeful_arcana_nether_swap_explosion_shockwave_top.vpcf", PATTACH_ABSORIGIN, v)
						ParticleManager:SetParticleControl(particleeff33, 0, v:GetAbsOrigin())
						local particleeff44 = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic_shock.vpcf", PATTACH_ABSORIGIN, v)
						ParticleManager:SetParticleControl(particleeff44, 0, v:GetAbsOrigin())
    				end)
		       	end
		    end
		end
	end)
end

function OnR(keys)
	local caster = keys.caster
	local ability = keys.ability

	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local range = ability:GetSpecialValueFor("range")
	local width = ability:GetSpecialValueFor("width")
	local damage_drag = ability:GetSpecialValueFor("damage_drag")
	local damage_slash = ability:GetSpecialValueFor("damage_slash")
	local slash_count = ability:GetSpecialValueFor("slash_count")
	local slash_duration = ability:GetSpecialValueFor("slash_duration")
	local burst_delay = ability:GetSpecialValueFor("burst_delay")
	local damage_burst = ability:GetSpecialValueFor("damage_burst")
	local burst_aoe = ability:GetSpecialValueFor("burst_aoe")
	local drag_stun = ability:GetSpecialValueFor("drag_stun")
	local targetpoint = ability:GetCursorPosition()

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mhx_r_charging", {})

	if caster.ActionAcquired then
		local qability = caster:FindAbilityByName("mhx_q_upgrade")
		local extra_range = qability:GetSpecialValueFor("extra_r_range")
		range = range + extra_range
	end

	local targetpoint = ability:GetCursorPosition()

	local caster_position = caster:GetAbsOrigin()
	local direction = (targetpoint - caster_position):Normalized()
	-- Initial target position
	local target_position = caster_position + direction * range

	-- Reduce the range in steps of 100 until a traversable point is found
	while not GridNav:IsTraversable(target_position) or GridNav:IsBlocked(target_position) do
	    range = range - 100
	    target_position = caster_position + direction * range

	    -- Break the loop if range is reduced to zero or less, to avoid infinite loop
	    if range <= 0 then
	        target_position = caster_position  -- Set to caster position as a fallback
	        break
	    end
	end

	local particleeff1 = ParticleManager:CreateParticle("particles/mhx/mhx_r_floor_indicator.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particleeff1, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particleeff1, 1, target_position)

	local particleeff12 = ParticleManager:CreateParticle("particles/mhx/mhx_r_cast.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particleeff12, 0, caster:GetAbsOrigin())

	local casterslashingPosition = caster_position + direction * (range * 5 / 8)

    local d_ability = caster:FindAbilityByName("mhx_d")
	local ministun_duration = d_ability:GetSpecialValueFor("ministun_duration") / 2
	local ministun_chance = d_ability:GetSpecialValueFor("ministun_chance")

	local stun_chance_multiplier = ability:GetSpecialValueFor("stun_chance_multiplier")
	ministun_chance = ministun_chance * stun_chance_multiplier

	if caster:HasModifier("modifier_mhx_prana") then
		local bonus_r_slash_damage = d_ability:GetSpecialValueFor("bonus_r_slash_damage")
		local bonus_r_slash_count = d_ability:GetSpecialValueFor("bonus_r_slash_count")

		slash_count = slash_count + bonus_r_slash_count
		damage_slash = damage_slash + bonus_r_slash_damage

		caster:RemoveModifierByName("modifier_mhx_prana")
	end

	local soundindex = math.random(1,3)
	--playchargingaudio here.
    if caster:HasModifier("modifier_alternate_02") then
    	EmitGlobalSound("KIRITO.RSTART" ..soundindex)
    else
		EmitGlobalSound("MHX.RCAST" ..math.random(1,2))
    end

	EmitGlobalSound("MHX.RCASTSFX")

    Timers:CreateTimer(0.3, function()
		StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_3 , rate=1})
	end)

    Timers:CreateTimer(cast_delay - 0.1, function()
		if caster:IsAlive() then	
			local particleeff13 = ParticleManager:CreateParticle("particles/mhx/mhx_r_dash.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff13, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(particleeff13, 1, target_position)
		end
	end)


    --REMMEMBER TO CHECK FI TARGET IS INSIDE MARBLE, IF YES IGNORE POS DRAG, DEAL DASH DAMAGE END

	if caster.DualAcquired then
		local bonus_agi_slash_damage = ability:GetSpecialValueFor("bonus_agi_slash_damage")
		damage_slash = damage_slash + (bonus_agi_slash_damage * caster:GetAgility())
		print(damage_slash)
	end

    Timers:CreateTimer(cast_delay, function()
		EmitGlobalSound("MHX.RDASH")

		    if caster:HasModifier("modifier_alternate_02") then
		    	EmitGlobalSound("KIRITO.RBLAST" ..soundindex)
		    else
				EmitGlobalSound("MHX.RBURSTVOICE")
		    end

		if caster:IsAlive() then	
			caster:SetAbsOrigin(casterslashingPosition)
			giveUnitDataDrivenModifier(caster, caster, "jump_pause", slash_duration + burst_delay)
			StartAnimation(caster, {duration=slash_duration + 0.2, activity=ACT_DOTA_CAST_ABILITY_3_END, rate=2.5})

			local particleeff14 = ParticleManager:CreateParticle("particles/mhx/mhx_r_slash_start.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff14, 0, target_position)
			local particleeff15 = ParticleManager:CreateParticle("particles/mhx/mhx_r_slash_area3.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff15, 0, target_position)
			local particleeff16 = ParticleManager:CreateParticle("particles/mhx/mhx_r_cast1.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff16, 0, target_position)

    		local targets = FindUnitsInLine(caster:GetTeamNumber(), caster_position, target_position, nil, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
			for k,v in pairs(targets) do
				if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
					v:SetAbsOrigin(target_position)
        			FindClearSpaceForUnit(v, target_position, true)
			       	DoDamage(caster, v, damage_drag , DAMAGE_TYPE_MAGICAL, 0, ability, false)	 
					v:AddNewModifier(caster, ability, "modifier_stunned", {Duration = drag_stun}) 
		       	end
		    end

			local interval = slash_duration / slash_count  -- Time between each slash

			for i = 1, slash_count do
			    Timers:CreateTimer(i * interval, function()
			        -- This will be called every 'interval' seconds for 'slash_count' times
			        -- Perform your slash logic here (e.g., apply damage, play animation, etc.)
			        -- Example: DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
					local rng = RandomInt(0,100)
					if (rng < 32) then
						local particleeff17 = ParticleManager:CreateParticle("particles/mhx/mhx_r_slashfinal.vpcf", PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(particleeff17, 0, target_position)
					end

					local particleeff18 = ParticleManager:CreateParticle("particles/mhx/mhx_r_slashfinal.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(particleeff18, 0, target_position)

					EmitSoundOnLocationWithCaster(target_position, "MHX.RSLASH" ..math.random(1,4), caster)
					EmitSoundOnLocationWithCaster(target_position, "MHX.RSLASHBONUS" ..math.random(1,2), caster)
					EmitSoundOnLocationWithCaster(target_position, "MHX.RSLASHBONUSPLUS", caster)

					local targets = FindUnitsInRadius(caster:GetTeam(), target_position, nil, burst_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)

					-- Check if there are any targets found
					if #targets > 0 then
					    -- Choose a random index
					    local random_index = RandomInt(1, #targets)  -- Random number between 1 and the number of targets
					    local random_target = targets[random_index]   -- Get the random target

					    -- Check if the selected target is valid and apply damage
					    if IsValidEntity(random_target) and not random_target:IsNull() and random_target:IsAlive() then
							local rng = RandomInt(0,100)
							if (rng < ministun_chance) then
								random_target:AddNewModifier(caster, ability, "modifier_stunned", {Duration = ministun_duration}) 
							end

					        DoDamage(caster, random_target, damage_slash, DAMAGE_TYPE_MAGICAL, 0, ability, false)
					    end
					end
			    end)
			end
		end
	end)


    Timers:CreateTimer(cast_delay + slash_duration + burst_delay - 0.2, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_CAST_ABILITY_2_END, rate=2})
	end)


    Timers:CreateTimer(cast_delay + slash_duration + burst_delay, function()
		if caster:IsAlive() then	
			EmitGlobalSound("MHX.RBURSTSFXFOLLOW")

			EmitGlobalSound("MHX.RBURSTSFX" ..math.random(1,2))

			local particleeff19 = ParticleManager:CreateParticle("particles/mhx/mhx_r_slash_area.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff19, 0, target_position)

			local targets = FindUnitsInRadius(caster:GetTeam(), target_position, nil, burst_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for k,v in pairs(targets) do
				if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
			       	DoDamage(caster, v, damage_burst , DAMAGE_TYPE_MAGICAL, 0, ability, false)	 
		       	end
		    end
		end
	end)

	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
end

function FaceUnit(caster, target)
    if not caster or not target or not target:IsAlive() then
        return
    end

    -- Calculate the direction from the caster to the target
    local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()

    -- Set the caster's forward vector to face the target
    caster:SetForwardVector(direction)
end

function OnCombo(keys)
	local caster = keys.caster
	local ability = keys.ability

	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local range = ability:GetSpecialValueFor("range")
	local width = ability:GetSpecialValueFor("width")
	local damage_slash = ability:GetSpecialValueFor("damage_slash")
	local slash_count = ability:GetSpecialValueFor("slash_count")
	local slash_duration = ability:GetSpecialValueFor("slash_duration")
	local burst_delay = ability:GetSpecialValueFor("burst_delay")
	local damage_burst = ability:GetSpecialValueFor("damage_burst")
	local damage_slash_agi_scale = ability:GetSpecialValueFor("damage_slash_agi_scale")
	local targetpoint = ability:GetCursorPosition()

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_mhx_combo_cooldown", {Duration = ability:GetCooldown(1)})
    if caster.DualAcquired then
		local mhx_r = caster:FindAbilityByName("mhx_r_upgrade")
		mhx_r:StartCooldown(mhx_r:GetCooldown(mhx_r:GetLevel()))
    else
		local mhx_r = caster:FindAbilityByName("mhx_r")
		mhx_r:StartCooldown(mhx_r:GetCooldown(mhx_r:GetLevel()))
    end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mhx_r_charging", {})
	giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", cast_delay)

	local targetpoint = ability:GetCursorPosition()

	local caster_position = caster:GetAbsOrigin()
	local direction = (targetpoint - caster_position):Normalized()
	-- Initial target position
	local target_position = caster_position + direction * range

	-- Reduce the range in steps of 100 until a traversable point is found
	while not GridNav:IsTraversable(target_position) or GridNav:IsBlocked(target_position) do
	    range = range - 100
	    target_position = caster_position + direction * range

	    -- Break the loop if range is reduced to zero or less, to avoid infinite loop
	    if range <= 0 then
	        target_position = caster_position  -- Set to caster position as a fallback
	        break
	    end
	end

	local particleeff1 = ParticleManager:CreateParticle("particles/mhx/mhx_r_cast.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particleeff1, 0, caster:GetAbsOrigin() + Vector(0,0,30))
	local particleeff12 = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_g_cowlofice_b.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particleeff12, 0, caster:GetAbsOrigin() + Vector(0,0,30))
	local particleeff13 = ParticleManager:CreateParticle("particles/creatures/aghanim/aghanim_blink_ground_rings.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particleeff13, 0, caster:GetAbsOrigin() + Vector(0,0,30))
	local particleeff14 = ParticleManager:CreateParticle("particles/creatures/aghanim/aghanim_portal_summon_impact_cast_ground.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particleeff14, 0, caster:GetAbsOrigin() + Vector(0,0,30))

    if caster:HasModifier("modifier_alternate_02") then
	EmitGlobalSound("KIRITO.COMBOSTART")
    else
	EmitGlobalSound("MHX.COMBOSTARTVOICE")
    end


    Timers:CreateTimer(0.1, function()
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_3 , rate=1})
	end)

    local d_ability = caster:FindAbilityByName("mhx_d")
	local ministun_duration = d_ability:GetSpecialValueFor("ministun_duration") / 2
	local ministun_chance = d_ability:GetSpecialValueFor("ministun_chance")

	local stun_chance_multiplier = ability:GetSpecialValueFor("stun_chance_multiplier")
	ministun_chance = ministun_chance * stun_chance_multiplier

	if caster:HasModifier("modifier_mhx_prana") then
		local bonus_r_slash_damage = d_ability:GetSpecialValueFor("bonus_r_slash_damage")
		local bonus_r_slash_count = d_ability:GetSpecialValueFor("bonus_r_slash_count")

		slash_count = slash_count + bonus_r_slash_count
		damage_slash = damage_slash + bonus_r_slash_damage

		caster:RemoveModifierByName("modifier_mhx_prana")
	end

	damage_slash = damage_slash + damage_slash_agi_scale * caster:GetAgility()

	--DASHING CHECK
    Timers:CreateTimer(cast_delay, function()
		if caster:IsAlive() then	
			StartAnimation(caster, {duration=slash_duration + 0.2, activity=ACT_DOTA_CAST_ABILITY_3_END, rate=2.5})


    		Timers:CreateTimer(1, function()
				StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_3_END, rate=2.5})
			end)

			giveUnitDataDrivenModifier(caster, caster, "jump_pause", slash_duration + burst_delay)

			local particleeff1 = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_splinter_explosion_flare_ring.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff1, 0, caster:GetAbsOrigin() + Vector(0,0,30))
			local particleeff12 = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/void_spirit_prison_end_top_flare.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff12, 0, caster:GetAbsOrigin() + Vector(0,0,30))
			local particleeff13 = ParticleManager:CreateParticle("particles/econ/events/ti10/soccer_ball/soccer_ball_dust.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff13, 10, caster:GetAbsOrigin() + Vector(0,0,30))

			-- Find unit in line, furthest from caster
			local targets = FindUnitsInLine(caster:GetTeamNumber(), caster_position, target_position, nil, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
			local particleeff14 = ParticleManager:CreateParticle("particles/mhx/mhx_path.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff14, 0, caster:GetAbsOrigin())
			-- Check if there are any targets
			if not targets or #targets == 0 then
				--SET CD TO FAIL CD
				ability:EndCooldown()
				local fail_cooldown = ability:GetSpecialValueFor("fail_cooldown")
				caster:RemoveModifierByName("modifier_mhx_combo_cooldown")
    			ability:ApplyDataDrivenModifier(caster, caster, "modifier_mhx_combo_cooldown", {Duration = fail_cooldown})
				ability:StartCooldown(fail_cooldown)
				caster:SetAbsOrigin(target_position)
				ParticleManager:SetParticleControl(particleeff14, 1, target_position)
				caster:RemoveModifierByName("pause_sealdisabled")
				caster:RemoveModifierByName("jump_pause")
				return 
			end

			local furthest_target = nil
			local max_distance = 0
			-- Loop through targets to find the furthest one
			for _, target in pairs(targets) do
				if IsValidEntity(target) and not target:IsNull() and target:IsAlive() then
					local distance = (target:GetAbsOrigin() - caster_position):Length2D()
					if distance > max_distance then
						max_distance = distance
						furthest_target = target
					end
				end
			end

			local calculateoffset = caster_position - furthest_target:GetAbsOrigin()
			local dirNew = (furthest_target:GetAbsOrigin() - caster_position):Normalized()
			local casterslashingPosition = furthest_target:GetAbsOrigin() + dirNew * 125

			ParticleManager:SetParticleControl(particleeff14, 1, furthest_target:GetAbsOrigin())
			EmitGlobalSound("MHX.RDASH")

		    if caster:HasModifier("modifier_alternate_02") then
				EmitGlobalSound("KIRITO.COMBOCAST")
				EmitGlobalSound("KIRITO.COMBOBGM")
		    else
				EmitGlobalSound("MHX.COMBOSUCCESS")
		    end

			caster:SetAbsOrigin(casterslashingPosition)

			local particleeff167 = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/astral_step_portal_flare.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff167, 0, caster:GetAbsOrigin() + Vector(0,0,30))
			local particleeff188 = ParticleManager:CreateParticle("particles/mhx/mhx_r_slash_start.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff188, 0, caster:GetAbsOrigin() + Vector(0,0,30))
			local particleeff19 = ParticleManager:CreateParticle("particles/mhx/mhx_r_slash_area2.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff19, 0, caster:GetAbsOrigin() + Vector(0,0,30))
			local particleeff10 = ParticleManager:CreateParticle("particles/mhx/mhx_r_cast2.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff10, 0, caster:GetAbsOrigin() + Vector(0,0,30))

			local interval = slash_duration / slash_count  -- Time between each slash

			for i = 1, slash_count do
			    Timers:CreateTimer(i * interval, function()
			    	if furthest_target:IsAlive() and not furthest_target:IsNull() then
				    	caster:SetAbsOrigin(furthest_target:GetAbsOrigin() + dirNew * 125)
				        -- This will be called every 'interval' seconds for 'slash_count' times
				        -- Perform your slash logic here (e.g., apply damage, play animation, etc.)
				        -- Example: DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
						FaceUnit(caster, furthest_target)
			    	end
			    	
					local rng = RandomInt(0,100)
					if (rng < 20) then
						local particleeff1 = ParticleManager:CreateParticle("particles/mhx/mhx_combo_slashfinal.vpcf", PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(particleeff112, 0, furthest_target:GetAbsOrigin())
					end

					local particleeff112 = ParticleManager:CreateParticle("particles/mhx/mhx_combo_slashfinal.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(particleeff112, 0, furthest_target:GetAbsOrigin())
					local particleeff1111 = ParticleManager:CreateParticle("particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_cast_lightning_sparks.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(particleeff1111, 1, furthest_target:GetAbsOrigin() + Vector(0,0,50))
					local particleeff134 = ParticleManager:CreateParticle("particles/econ/items/disruptor/disruptor_ti8_immortal_weapon/disruptor_ti8_immortal_thunder_strike_buff_sparks_b.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(particleeff134, 3, furthest_target:GetAbsOrigin() + Vector(0,0,50))


					EmitSoundOnLocationWithCaster(furthest_target:GetAbsOrigin(), "MHX.RSLASH" ..math.random(1,4), caster)
					EmitSoundOnLocationWithCaster(furthest_target:GetAbsOrigin(), "MHX.RSLASHBONUS" ..math.random(1,2), caster)
					EmitSoundOnLocationWithCaster(furthest_target:GetAbsOrigin(), "MHX.RSLASHBONUSPLUS", caster)

				    -- Check if the selected target is valid and apply damage
				    if IsValidEntity(furthest_target) and not furthest_target:IsNull() then
						local rng = RandomInt(0,100)
						if (rng < ministun_chance) then
							furthest_target:AddNewModifier(caster, ability, "modifier_stunned", {Duration = ministun_duration}) 
						end
				        DoDamage(caster, furthest_target, damage_slash, DAMAGE_TYPE_MAGICAL, 0, ability, false)
				    end
			    end)
			end

		    Timers:CreateTimer(slash_duration + burst_delay - 0.12 - 0.2, function()
				StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_CAST_ABILITY_2_END, rate=2})
			end)

			Timers:CreateTimer(slash_duration + burst_delay - 0.12, function()
				if caster:IsAlive() then	
					local particleeff169 = ParticleManager:CreateParticle("particles/mhx/mhx_combo_x2.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(particleeff169, 0, furthest_target:GetAbsOrigin())
					local particleeff165 = ParticleManager:CreateParticle("particles/mhx/mhx_combo_x.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(particleeff165, 0, furthest_target:GetAbsOrigin())
				end
			end)

			Timers:CreateTimer(slash_duration + burst_delay, function()
				if caster:IsAlive() then	
					EmitGlobalSound("MHX.RBURSTSFX" ..math.random(1,2))
					EmitGlobalSound("MHX.RBURSTSFXFOLLOW")

					local particleeff1666 = ParticleManager:CreateParticle("particles/mhx/mhx_r_slash_area.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(particleeff1666, 0, furthest_target:GetAbsOrigin())

					DoDamage(caster, furthest_target, damage_burst , DAMAGE_TYPE_MAGICAL, 0, ability, false)	 

					if furthest_target:IsAlive() and not furthest_target:IsNull() then
				    	caster:SetAbsOrigin(furthest_target:GetAbsOrigin() + dirNew * 125)
					else
						caster:SetAbsOrigin(caster:GetAbsOrigin())
					end
				end
			end)
		end

		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
	end)
end

function OnBuff(keys)
    local caster = keys.caster
    local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")

    if caster:HasModifier("modifier_alternate_02") then
		caster:EmitSound("KIRITO.D")
    end
    caster:EmitSound("MHX.DSFX")
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_mhx_prana", {Duration = duration})

    --KiyoCheckCombo(caster,ability)
end 

function OnAttack(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
	local ministun_chance = ability:GetSpecialValueFor("ministun_chance")
	local ministun_duration = ability:GetSpecialValueFor("ministun_duration")

	local rng = RandomInt(0,100)
	if (rng < ministun_chance) then
		target:AddNewModifier(caster, ability, "modifier_stunned", {Duration = ministun_duration}) 
	end
end

function OnBurstSa(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.BurstAcquired) then
		hero.BurstAcquired = true
		UpgradeAttribute(hero, "mhx_w", "mhx_w_upgrade", true)
		hero.WSkill = "mhx_w_upgrade"

		NonResetAbility(hero)

		-- UpgradeAttribute(hero, "kinghassan_azrael", "kinghassan_azrael_upgraded", true)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnPranaSa(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.PranaAcquired) then
		hero.PranaAcquired = true
		hero:FindAbilityByName("mhx_d"):SetLevel(2)

		NonResetAbility(hero)

		-- UpgradeAttribute(hero, "kinghassan_azrael", "kinghassan_azrael_upgraded", true)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnActionSa(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.ActionAcquired) then
		hero.ActionAcquired = true
		UpgradeAttribute(hero, "mhx_q", "mhx_q_upgrade", true)
		hero.qSkill = "mhx_q_upgrade"

		NonResetAbility(hero)

		-- UpgradeAttribute(hero, "kinghassan_azrael", "kinghassan_azrael_upgraded", true)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnDualSa(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.DualAcquired) then
		hero.DualAcquired = true
		UpgradeAttribute(hero, "mhx_r", "mhx_r_upgrade", true)
		hero.rSkill = "mhx_r_upgrade"

		NonResetAbility(hero)

		-- UpgradeAttribute(hero, "kinghassan_azrael", "kinghassan_azrael_upgraded", true)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function MhxCheckCombo(caster, ability)
    if math.ceil(caster:GetStrength()) >= 25 and math.ceil(caster:GetAgility()) >= 25 and math.ceil(caster:GetIntellect()) >= 25 then 
    	if caster.DualAcquired then
	    	if caster:FindAbilityByName("mhx_r_upgrade"):IsCooldownReady() and not caster:HasModifier("modifier_mhx_combo_cooldown") then 
	    		ability:ApplyDataDrivenModifier(caster, caster, "modifier_combo_window", {duration = 3})
	    	end
    	else
	    	if caster:FindAbilityByName("mhx_r"):IsCooldownReady() and not caster:HasModifier("modifier_mhx_combo_cooldown") then 
	    		ability:ApplyDataDrivenModifier(caster, caster, "modifier_combo_window", {duration = 3})
	    	end
    	end
    end
end

function OnComboWindow(keys)
	local caster = keys.caster
	if caster.DualAcquired then
		caster:SwapAbilities("mhx_r_upgrade", "mhx_combo", false, true)
	else
		caster:SwapAbilities("mhx_r", "mhx_combo", false, true)
	end
end

function OnComboWindowBroken(keys)
	local caster = keys.caster
	if caster.DualAcquired then
		caster:SwapAbilities("mhx_combo", "mhx_r_upgrade", false, true)
	else
		caster:SwapAbilities("mhx_combo", "mhx_r", false, true)
	end
end

function OnComboWindowDeath(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_combo_window")
end
