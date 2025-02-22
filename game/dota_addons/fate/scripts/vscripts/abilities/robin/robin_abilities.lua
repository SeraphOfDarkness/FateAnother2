function OnFacelessKingTakeDamage(keys)
    local caster = keys.caster
    local ability = keys.ability
    local invis_chance = ability:GetSpecialValueFor("invis_chance")
    local invis_duration = ability:GetSpecialValueFor("invis_duration")

    local rng = RandomInt(0, 100)
    if rng <= invis_chance then
    	if caster:HasModifier("modifier_faceless_king_cooldown") then
    		return 0
    	else
    		if caster.IsFacelessKingAcquired then
				local particle = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_ambient_smoke.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())		
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_scurry_aura_leaves_activation.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())		
				local particle = ParticleManager:CreateParticle("particles/econ/items/hoodwink/hood_2021_blossom/hood_2021_blossom_scurry_aura_shock_start.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())		

    			ability:StartCooldown(ability:GetSpecialValueFor("passive_cooldown"))
		        ability:ApplyDataDrivenModifier(caster, caster, "modifier_faceless_king_invis", {})
		        ability:ApplyDataDrivenModifier(caster, caster, "modifier_faceless_king_cooldown", {Duration = ability:GetSpecialValueFor("passive_cooldown")})

				caster:EmitSound("Robin.FacelessKingProc")
				caster:EmitSound("Robin.FacelessKingProcSFX")
    		else
    			if caster:GetMana() > ability:GetManaCost(1) then
					local particle = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_ambient_smoke.vpcf", PATTACH_ABSORIGIN, caster)
					ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())		
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_scurry_aura_leaves_activation.vpcf", PATTACH_ABSORIGIN, caster)
					ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())		
					local particle = ParticleManager:CreateParticle("particles/econ/items/hoodwink/hood_2021_blossom/hood_2021_blossom_scurry_aura_shock_start.vpcf", PATTACH_ABSORIGIN, caster)
					ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())	
    				
		    		caster:SpendMana(ability:GetManaCost(1), ability)
		    		ability:StartCooldown(ability:GetSpecialValueFor("passive_cooldown"))
			        ability:ApplyDataDrivenModifier(caster, caster, "modifier_faceless_king_invis", {})
			        ability:ApplyDataDrivenModifier(caster, caster, "modifier_faceless_king_cooldown", {Duration = ability:GetSpecialValueFor("passive_cooldown")})

			        caster:EmitSound("Robin.FacelessKingProc")
					caster:EmitSound("Robin.FacelessKingProcSFX")
			    else
			    	return 0
			    end
    		end
    	end
    end
end 

function OnFacelessKingStart(keys)
	local caster = keys.caster
    local ability = keys.ability
    local invis_duration = ability:GetSpecialValueFor("invis_duration")

    local particle = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_ambient_smoke.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())		
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_scurry_aura_leaves_activation.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())		
	local particle = ParticleManager:CreateParticle("particles/econ/items/hoodwink/hood_2021_blossom/hood_2021_blossom_scurry_aura_shock_start.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())		

    ability:StartCooldown(ability:GetCooldown(1))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_faceless_king_invis", {})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_faceless_king_cooldown", {Duration = ability:GetCooldown(1)})

	caster:EmitSound("Robin.FacelessKingProc")
	caster:EmitSound("Robin.FacelessKingProcSFX")

end

function OnInvisDeath(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_faceless_king_invis")
end

function OnInvisBonus(keys)
	local caster = keys.caster
	local ability =keys.ability
	caster:RemoveModifierByName("modifier_faceless_king_invis")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_faceless_bonus", {})
end

function DealInvisDamage(caster, target)
	if caster:HasModifier("modifier_faceless_bonus") then
		local ability = caster:FindAbilityByName("robin_faceless_king_upgrade")
		local bonus_invis_agi = ability:GetSpecialValueFor("bonus_invis_agi")
		DoDamage(caster, target, caster:GetAgility() * bonus_invis_agi , DAMAGE_TYPE_PURE, 0, ability, false)
	end
end

function OnRighteousCrit(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability

    if not target:IsRealHero() or target:IsIllusion() then return end

    --local crit_chance = ability:GetSpecialValueFor("crit_chance")
    local agi_scale_crit = ability:GetSpecialValueFor("agi_scale_crit")
    local more_gold = ability:GetSpecialValueFor("more_gold") / 100 
    local target_gold = target:GetGold()
    --print('enemy gold = ' .. target_gold)
    local gold_steal = math.min(target_gold, ability:GetSpecialValueFor("gold_steal"))

    if gold_steal > 0 then
	    caster:ModifyGold(gold_steal, true, 0)
	    target:SpendGold(gold_steal, 0)
	    PopupGoldGain(caster, gold_steal)
	    PopupGoldGain(target, gold_steal, 1)

	    --[[local goldPopupFx = ParticleManager:CreateParticle("particles/custom/system/gold_popup.vpcf", PATTACH_CUSTOMORIGIN, caster)
	    ParticleManager:SetParticleControl( goldPopupFx, 0, caster:GetAbsOrigin())
	    ParticleManager:SetParticleControl( goldPopupFx, 1, Vector(10,300,0))
	    ParticleManager:SetParticleControl( goldPopupFx, 2, Vector(2,#tostring(gold_steal), 0))
	    ParticleManager:SetParticleControl( goldPopupFx, 3, Vector(255, 200, 33))

	    local goldlossFx = ParticleManager:CreateParticle("particles/custom/system/gold_popup.vpcf", PATTACH_CUSTOMORIGIN, target)
	    ParticleManager:SetParticleControl( goldlossFx, 0, target:GetAbsOrigin())
	    ParticleManager:SetParticleControl( goldlossFx, 1, Vector(10,300,0))
	    ParticleManager:SetParticleControl( goldlossFx, 2, Vector(2,#tostring(-gold_steal), 0))
	    ParticleManager:SetParticleControl( goldlossFx, 3, Vector(255, 200, 33))]]
	end

    --local rng = RandomInt(0, 100)

    if target:GetGold() <= caster:GetGold() * more_gold then
	    DoDamage(caster, target, caster:GetAgility() * agi_scale_crit , DAMAGE_TYPE_MAGICAL, 0, ability, false)
    end
end 

function OnGoldGain(keys)
	local caster = keys.caster
	local ability = keys.ability 
	local target = keys.target
	local goldgain = ability:GetSpecialValueFor("goldpersecond")

    if caster:IsAlive() then 
    	caster:ModifyGold(goldgain, true, 0)
    	--caster:SetGold(0, false)
    	--caster:SetGold(caster:GetGold() + goldgain, true) 
    end
end

function OnSaboteurOpen(keys)
	local caster = keys.caster
	local ability = keys.ability 

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_robin_saboteur_open", {})

	if caster.IsSubversiveAcquired then
		caster:SwapAbilities(caster:GetAbilityByIndex(0):GetAbilityName(), "robin_saboteur_pitfall_upgrade", false, true)
		caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "robin_saboteur_barrel_upgrade", false, true)
		caster:SwapAbilities(caster:GetAbilityByIndex(2):GetAbilityName(), "robin_saboteur_scout_familliar", false, true)
		caster:SwapAbilities(caster.DSkill, "robin_saboteur_poison_well", false, true)
		caster:SwapAbilities(caster:GetAbilityByIndex(4):GetAbilityName(), "robin_saboteur_close", false, true)
	else
		caster:SwapAbilities(caster:GetAbilityByIndex(0):GetAbilityName(), "robin_saboteur_pitfall", false, true)
		caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "robin_saboteur_barrel", false, true)
		caster:SwapAbilities(caster:GetAbilityByIndex(2):GetAbilityName(), "fate_empty2", false, true)
		caster:SwapAbilities(caster:GetAbilityByIndex(4):GetAbilityName(), "robin_saboteur_close", false, true)
	end
end

function OnSaboteurClose(keys)
	local caster = keys.caster
	local ability = keys.ability 

		caster:SwapAbilities(caster:GetAbilityByIndex(0):GetAbilityName(), caster.QSkill, false, true)
		--[[if caster:HasModifier("modifier_robin_hunter_rain") then
			caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "robin_hunter_rain", false, true)
		else]]
		caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), caster.WSkill, false, true)
		--end
		caster:SwapAbilities(caster:GetAbilityByIndex(2):GetAbilityName(), caster.ESkill, false, true)
		caster:SwapAbilities(caster:GetAbilityByIndex(3):GetAbilityName(), caster.DSkill, false, true)
		caster:SwapAbilities(caster:GetAbilityByIndex(4):GetAbilityName(), caster.FSkill, false, true)

	caster:RemoveModifierByName("modifier_robin_saboteur_open")
end

function OnRighteousSwap(keys)
	local caster = keys.caster
	local ability = keys.ability 

	if caster:HasModifier("modifier_robin_hunter_rain") then
		caster:RemoveModifierByName("modifier_robin_hunter_rain")
		caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), caster.WSkill, false, true)
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_robin_hunter_rain", {})
		caster:SwapAbilities(caster:GetAbilityByIndex(1):GetAbilityName(), "robin_hunter_rain", false, true)
	end
end

function OnPitfallCast(keys)
    local caster = keys.caster
    local ability = keys.ability
    local targetpoint = ability:GetCursorPosition()
	local duration = ability:GetSpecialValueFor("trap_duration")
	local damage = ability:GetSpecialValueFor("damage")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local radius = ability:GetSpecialValueFor("radius")
	local activated = false
	
    caster:EmitSound("Robin.PitfallTrap")
	caster:EmitSound("Robin.PitfallTrapSFX")

	local trap_dummy = CreateUnitByName("robin_pitfall", targetpoint, false, caster, caster, caster:GetTeamNumber())
	--trap_dummy:FindAbilityByName("dummy_unit_passive_no_fly"):SetLevel(1)
	trap_dummy:AddNewModifier(caster, ability, "modifier_kill", {Duration = duration})
	trap_dummy:SetAbsOrigin(trap_dummy:GetAbsOrigin() + Vector(0,0,20))
	ability:ApplyDataDrivenModifier(caster, trap_dummy, "modifier_robin_pitfall_checker", {})

	--[[local trap = ParticleManager:CreateParticleForTeam("particles/robin/pitfall/robin_pitfall.vpcf", PATTACH_CUSTOMORIGIN, caster, caster:GetTeamNumber())
	ParticleManager:SetParticleControl(trap, 0, targetpoint)

	for i=duration,0,-0.5 do	
		Timers:CreateTimer(i, function()
			activated = PitfallCheck(keys,activated,targetpoint,trap)
		end)
	end

	Timers:CreateTimer(duration + 1, function()
		ParticleManager:DestroyParticle(trap, true)
	end)]]
end

function PitfallCheck(keys)
	local caster = keys.caster
    local ability = keys.ability
    if ability == nil then 
    	ability = caster:FindAbilityByName("robin_saboteur_pitfall_upgrade")
    end
    local trap = keys.target
    local trap_loc = trap:GetAbsOrigin()
	local damage = ability:GetSpecialValueFor("damage")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local radius = ability:GetSpecialValueFor("radius")

	local enemies = FindUnitsInRadius(caster:GetTeam(), trap_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	if enemies[1] == nil then return end 

	for k,v in pairs(enemies) do
		if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
	       	DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	       	if not IsImmuneToCC(v) then
	       		if caster.IsSubversiveAcquired then
	       			v:SetAbsOrigin(trap_loc + RandomVector(20))
	       		end
				v:AddNewModifier(caster, ability, "modifier_stunned", { Duration = stun_duration })
			end	
       	end
    end

    trap:EmitSound("Robin.PitfallTriggerSFX")
    trap:ForceKill(false)

    local smoke = ParticleManager:CreateParticle("particles/dev/library/base_dust_hit_smoke.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(smoke, 0, trap_loc)	
end

function OnBarrelCast(keys)
    local caster = keys.caster
    local ability = keys.ability
    local targetpoint = ability:GetCursorPosition()
	local duration = ability:GetSpecialValueFor("trap_duration")
	local damage = ability:GetSpecialValueFor("damage")
	local radius = ability:GetSpecialValueFor("radius")
	
	caster:EmitSound("Robin.BarrelTrapSFX")

	local trap_dummy = CreateUnitByName("robin_barrel", targetpoint, false, caster, caster, caster:GetTeamNumber())
	--trap_dummy:FindAbilityByName("dummy_unit_passive_no_fly"):SetLevel(1)
	trap_dummy:AddNewModifier(caster, ability, "modifier_kill", {Duration = duration})
	trap_dummy:SetAbsOrigin(trap_dummy:GetAbsOrigin() + Vector(0,0,20))
	ability:ApplyDataDrivenModifier(caster, trap_dummy, "modifier_robin_barrel_checker", {})
	

	--[[local trap = ParticleManager:CreateParticleForTeam("particles/robin/barrel/robin_barrel.vpcf", PATTACH_CUSTOMORIGIN, caster, caster:GetTeamNumber())
	ParticleManager:SetParticleControl(trap, 0, targetpoint)

	for i=duration,0,-0.5 do	
		Timers:CreateTimer(i, function()
			activated = BarrelCheck(keys,activated,targetpoint,trap)
		end)
	end

	Timers:CreateTimer(duration + 1, function()
		ParticleManager:DestroyParticle(trap, true)
	end)]]
end

function BarrelCheck(keys)
	local caster = keys.caster
    local ability = keys.ability
    if ability == nil then 
    	ability = caster:FindAbilityByName("robin_saboteur_barrel_upgrade")
    end
    local trap = keys.target
    local trap_loc = trap:GetAbsOrigin()
	local root = ability:GetSpecialValueFor("root_duration")
	local damage = ability:GetSpecialValueFor("damage")
	local radius = ability:GetSpecialValueFor("radius")

	local enemies = FindUnitsInRadius(caster:GetTeam(), trap_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	if enemies[1] == nil then return end 

	local trapglobalfx = ParticleManager:CreateParticle("particles/robin/barrel/robin_barrel.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(trapglobalfx, 0, trap_loc)

	trap:EmitSound("Robin.BarrelTrapExplodeSFX")

	Timers:CreateTimer(0.15, function()
		local detonate = ParticleManager:CreateParticle("particles/econ/items/techies/techies_arcana/techies_remote_mines_detonate_arcana.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(detonate, 0, trap_loc)
		ParticleManager:DestroyParticle(trapglobalfx, true)
		ParticleManager:ReleaseParticleIndex(trapglobalfx)
		for k,v in pairs(enemies) do
			if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then	
		       	DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	       	end
	    end
    end)

    trap:ForceKill(false)
end

function OnRootsCast(keys)
    local caster = keys.caster
    local ability = keys.ability
    local targetpoint = ability:GetCursorPosition()
	local duration = ability:GetSpecialValueFor("duration")
	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local damage = ability:GetSpecialValueFor("damage")
	local dps = ability:GetSpecialValueFor("dps")
	local radius = ability:GetSpecialValueFor("radius")

    caster:EmitSound("Robin.Roots")

	giveUnitDataDrivenModifier(caster, caster, "pause_sealenabled", cast_delay - 0.5)

	--RobinCheckCombo(caster,ability)
	local particleeff = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green_spotlight.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particleeff, 0, caster:GetAbsOrigin() + Vector(0,0,-100))		

	RobinCheckCombo(caster,ability)

	Timers:CreateTimer(cast_delay / 2, function()
		ScreenShake(caster:GetOrigin(), 3, 0.2, 1, 2000, 0, true)
	end)

	Timers:CreateTimer(cast_delay, function()

    	caster:EmitSound("Robin.RootsSFX")
    	caster:EmitSound("Robin.RootsSFX2")

		local root = ParticleManager:CreateParticle("particles/robin/thorn/robin_root.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(root, 0, targetpoint)
		
		Timers:CreateTimer(duration + 0.5, function()
			ParticleManager:DestroyParticle(root, false)
		end)

		local targets = FindUnitsInRadius(caster:GetTeam(), targetpoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)

		for k,v in pairs(targets) do
			if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
				if caster.IsTaxineAcquired then
					local scale = ability:GetSpecialValueFor("damage_per_int") * caster:GetIntellect()
					DoDamage(caster, v, damage + scale, DAMAGE_TYPE_MAGICAL, 0, ability, false)
				else
		       		DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
		        end
	       	end
	    end

		for i=duration,0,-0.25 do	
			Timers:CreateTimer(i, function()
				local enemies = FindUnitsInRadius(caster:GetTeam(), targetpoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				if enemies == nil then return end

				for k,v in pairs(enemies) do
					if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
						if caster.IsTaxineAcquired then
							local scale = ability:GetSpecialValueFor("int_scale_dps") * caster:GetIntellect()
						    DoDamage(caster, v, (dps + scale) / 4, DAMAGE_TYPE_MAGICAL, 0, ability, false)
						else
						    DoDamage(caster, v, dps / 4, DAMAGE_TYPE_MAGICAL, 0, ability, false)
					    end

					    if not IsImmuneToSlow(v) then
		        			ability:ApplyDataDrivenModifier(caster, v, "modifier_robin_roots_slow", {})
		        		end
				    end
				end
			end)
		end
	end)

end

function OnParalyzingArrow(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local speed = ability:GetSpecialValueFor("speed")
	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local width = ability:GetSpecialValueFor("width")
	local length = ability:GetSpecialValueFor("length")
	local target_point = ability:GetCursorPosition()
	local dash_back = ability:GetSpecialValueFor("dash_back")

	giveUnitDataDrivenModifier(caster, caster, "pause_sealenabled", 0.3 + cast_delay)

	local num = RandomInt(0, 100)

    if num <= 50 then
    	caster:EmitSound("Robin.ParalyzingArrow")
    else
    	caster:EmitSound("Robin.ParalyzingArrow2")
    end


	Timers:CreateTimer(cast_delay, function()

		--Timers:CreateTimer(0.15, function()
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.0})
		--end)	

    	caster:EmitSound("Robin.ParalyzingArrowSFX")

		if caster:IsAlive() then
		local particle = ParticleManager:CreateParticle("particles/econ/items/lone_druid/lone_druid_cauldron/druid_entangle_antler_dust.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())		

			local Arrow =
			{
				Ability = keys.ability,
		        EffectName = "particles/robin/paralyzingarrow/base_linear_projectile_model.vpcf",
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

			local dashback = Physics:Unit(caster)
			local origin = caster:GetOrigin()
			local backward = -caster:GetForwardVector()

			giveUnitDataDrivenModifier(caster, caster, "jump_pause", 0.3)

			caster:PreventDI()
			caster:SetPhysicsFriction(0)
			caster:SetPhysicsVelocity(backward * dash_back * 2.5)
		   	caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
			
			Timers:CreateTimer(0.3, function() 
				caster:PreventDI(false)
				caster:SetPhysicsVelocity(Vector(0,0,0))
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
			end)
		end

	end)
end

function OnParalyzingArrowHit(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target 
	local damage = ability:GetSpecialValueFor("damage")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local knock = ability:GetSpecialValueFor("knock")

	if caster.IsTaxineAcquired then
		local scale = ability:GetSpecialValueFor("damage_per_int") * caster:GetIntellect()
		DoDamage(caster, target, damage + scale, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	else		
		DoDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	end

	DealInvisDamage(caster, target)

	if not IsKnockbackImmune(target) then 
		local knockback = { should_stun = true,
                            knockback_duration = 0.2,
                            duration = 0.2,
                            knockback_distance = knock,
                            knockback_height = 0,
                            center_x = caster:GetAbsOrigin().x,
                            center_y = caster:GetAbsOrigin().y,
                            center_z = caster:GetAbsOrigin().z }

        target:AddNewModifier(caster, ability, "modifier_knockback", knockback)
	end

	if not IsImmuneToCC(target) then
		target:AddNewModifier(caster, ability, "modifier_stunned", {Duration = stun_duration})
	end

	if caster.IsTaxineAcquired then
		if not IsImmuneToSlow(target) then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_robin_paralyze", {})
		end
	end

    target:EmitSound("Robin.ParalyzingArrowHitSFX")

	local particle = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold_flash.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())		
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock_impact_b.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin() + Vector(0,0,50))			
	local particle = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold_flash.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())	
end

function OnHunterRain(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target 
	local speed = ability:GetSpecialValueFor("speed")
	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local width = ability:GetSpecialValueFor("width")
	local length = ability:GetSpecialValueFor("length")
	local amount = ability:GetSpecialValueFor("arrow_amount")

	local target_point = ability:GetCursorPosition()

	giveUnitDataDrivenModifier(caster, caster, "pause_sealenabled", cast_delay + amount * 0.046)

    caster:EmitSound("Robin.HunterRain")

	Timers:CreateTimer(cast_delay, function()

		for i=0, amount ,1 do

			Timers:CreateTimer(0.045 * i, function()

				local vectordir = RotatePosition( Vector(0,0,0), QAngle( 0, (amount * 3) - (6 * i) , 0 ), caster:GetForwardVector():Normalized() )
				if caster:IsAlive() then
			   		caster:EmitSound("Robin.HunterRainPewSFX")
					local Arrow =
					{
						Ability = keys.ability,
				        EffectName = "particles/robin/hunterrain/base_linear_projectile_model.vpcf",
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
						vVelocity = vectordir * speed,
					}

					ProjectileManager:CreateLinearProjectile(Arrow)
				end

			end)

		end
	end)
end

function OnHunterRainHit(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target 
	local damage = ability:GetSpecialValueFor("damage")
	local scale = ability:GetSpecialValueFor("damage_per_agi") * caster:GetAgility()

	target:EmitSound("Robin.HunterRainHitSFX")

	DoDamage(caster, target, damage + scale, DAMAGE_TYPE_PHYSICAL, 0, ability, false)

	DealInvisDamage(caster, target)

	local particle = ParticleManager:CreateParticle("particles/econ/items/drow/drow_ti9_immortal/drow_ti9_marksman_gem_flash.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 3, target:GetAbsOrigin() + Vector(0,0,50))		

	if caster.IsViperAcquired then
		if not IsImmuneToCC(target) then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_robin_hunter_rain_debuff", {})
		end
	end
end

function OnSkillWLevelup(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	if caster.IsViperAcquired then
		caster:FindAbilityByName("robin_hunter_rain_upgrade"):SetLevel(ability:GetLevel())
	else
		caster:FindAbilityByName("robin_hunter_rain"):SetLevel(ability:GetLevel())
	end
end

function OnYewBowStart(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target 
	local speed = ability:GetSpecialValueFor("speed")
	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local dash_back = ability:GetSpecialValueFor("dash_back")
	local dash_time = 0.15

	if IsSpellBlocked(target) then return end -- Linken effect checker

	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})
	giveUnitDataDrivenModifier(caster, caster, "modifier_stunned", cast_delay + 0.1)
	giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", cast_delay - 0.1)

	local particle = ParticleManager:CreateParticle("particles/ui/blessing_icon_unlock_green_swirl_01.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin() + Vector(0,0,150))		
	local particle = ParticleManager:CreateParticle("particles/ui/blessing_icon_unlock_green_swirl_02.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin() + Vector(0,0,150))	

	local particleeff = ParticleManager:CreateParticle("particles/ui/blessing_icon_ambient_green.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particleeff, 0, caster:GetAbsOrigin() + Vector(0,0,150))		

	EmitGlobalSound("Robin.YewBow")

	Timers:CreateTimer(0.2, function()
		FreezeAnimation(caster,0.5)
	end)	

	Timers:CreateTimer(cast_delay, function()

    	caster:EmitSound("Robin.YewBowSFX")
    	caster:EmitSound("Robin.YewBowSFX2")

		ParticleManager:DestroyParticle(particleeff, false)
		if caster:IsAlive() then
			local projectile = {
		    	Target = target,
				Source = caster,
				Ability = ability,	
	        	EffectName = "particles/robin/yewbowarrow/yewbowarrow.vpcf",
	        	--EffectName = "particles/robin/yewbowarrow-combo/yewbowarrow.vpcf",
		        iMoveSpeed = speed,
				vSourceLoc= caster:GetAbsOrigin(),
		        iSourceAttachment = caster:GetAbsOrigin() + Vector(0,0,20),
				bDrawsOnMinimap = false,
		        bDodgeable = true,
		        bIsAttack = false,
		        flExpireTime = GameRules:GetGameTime() + 3,
	   		}

	    	ProjectileManager:CreateTrackingProjectile(projectile)

			local dashback = Physics:Unit(caster)
			local origin = caster:GetOrigin()
			local backward = -caster:GetForwardVector()

			caster:PreventDI()
			caster:SetPhysicsFriction(0)
			caster:SetPhysicsVelocity(backward * dash_back / dash_time)
		   	caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
			
			Timers:CreateTimer(dash_time, function() 
				caster:PreventDI(false)
				caster:SetPhysicsVelocity(Vector(0,0,0))
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
			end)
		else
			return
		end
	end)
end

function OnYewBowHit(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target 
    local damage_physical = ability:GetSpecialValueFor("damage_physical")
    local damage_magical = ability:GetSpecialValueFor("damage_magical")
    local radius = ability:GetSpecialValueFor("radius")

    if not IsValidEntity(target) or target:IsNull() or not target:IsAlive() then return end

	if target == nil then return end

    if IsSpellBlocked(target) then return end

	target:EmitSound("Robin.YewBowHitSFX")
	target:EmitSound("Robin.YewBowHitSFX2")
	local pot_hit = ParticleManager:CreateParticle("particles/robin/yewbow-combo/dragon_knight_transform_green_smoke03.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pot_hit, 0, target:GetAbsOrigin())	
	local pot_hit = ParticleManager:CreateParticle("particles/robin/yewbow-combo/yewboweffxplode.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pot_hit, 0, target:GetAbsOrigin())	
	local pot_hit = ParticleManager:CreateParticle("particles/robin/yewbow-combo/yewbowshine.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pot_hit, 0, target:GetAbsOrigin())		
	local pot_hit = ParticleManager:CreateParticle("particles/robin/yewbow-combo/yewbowgrass.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pot_hit, 0, target:GetAbsOrigin())	
	local pot_hit = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_eyesintheforest_k.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pot_hit, 0, target:GetAbsOrigin())	

	if caster.IsGuerillaAcquired then
		local bypass_armor = ability:GetSpecialValueFor("ignore_armor_amount")
		local agiscale = ability:GetSpecialValueFor("damage_per_agi") * caster:GetAgility()
		damage_physical = damage_physical + agiscale 
		DoDamage(caster, target, damage_physical * bypass_armor / 100, DAMAGE_TYPE_PHYSICAL, 2, ability, false)
		DoDamage(caster, target, damage_physical * (100 - bypass_armor) / 100, DAMAGE_TYPE_PHYSICAL, 0, ability, false)
	else
		DoDamage(caster, target, damage_physical, DAMAGE_TYPE_PHYSICAL, 0, ability, false)
	end
	DealInvisDamage(caster, target)
	giveUnitDataDrivenModifier(caster, target, "modifier_stunned", 0.4)

	local enemies = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(enemies) do
		if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
				if caster.IsTaxineAcquired then
					local scale = ability:GetSpecialValueFor("damage_per_int") * caster:GetIntellect()
	       			DoDamage(caster, v, damage_magical + scale, DAMAGE_TYPE_MAGICAL, 0, ability, false)
				else		
	       			DoDamage(caster, v, damage_magical, DAMAGE_TYPE_MAGICAL, 0, ability, false)
				end
    		ability:ApplyDataDrivenModifier(caster, v, "modifier_robin_yew_bow", {})
    		v:SetModifierStackCount("modifier_robin_yew_bow", caster, math.abs(ability:GetSpecialValueFor("heal_red")))
	    end
	end
end

function OnYewBowThink(keys)
	local caster = keys.caster
	local ability = keys.ability 
	local target = keys.target
	local dps = ability:GetSpecialValueFor("dps")

	if caster.IsTaxineAcquired then
		local scale = ability:GetSpecialValueFor("dps_per_int") * caster:GetIntellect()
		DoDamage(caster, target, (dps + scale) /4, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	else
		DoDamage(caster, target, dps /4, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	end
end

function RobinCheckCombo(caster, ability)
    if math.ceil(caster:GetStrength()) >= 25 and math.ceil(caster:GetAgility()) >= 25 and math.ceil(caster:GetIntellect()) >= 25 then 
		if string.match(ability:GetAbilityName(), caster.ESkill) and caster:FindAbilityByName(caster.RSkill):IsCooldownReady() and not caster:HasModifier("modifier_robin_combo_cooldown") then 
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_combo_window", {duration = 5})
		end
    end
end

function OnComboWindow(keys)
	local caster = keys.caster
	if caster.IsTaxineAcquired then
		caster:SwapAbilities(caster.RSkill, "robin_combo_upgrade", false, true)
	else
		caster:SwapAbilities(caster.RSkill, "robin_combo", false, true)
	end
end

function OnComboWindowBroken(keys)
	local caster = keys.caster
	if caster.IsTaxineAcquired then
		caster:SwapAbilities(caster.RSkill, "robin_combo_upgrade", true, false)
	else
		caster:SwapAbilities(caster.RSkill, "robin_combo", true, false)
	end
end

function OnComboWindowDeath(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_combo_window")
end

function OnComboCast(keys)
    local caster = keys.caster
    local ability = keys.ability
    local targetpoint = ability:GetCursorPosition()
	local cast_delay = ability:GetSpecialValueFor("cast_delay")
	local damage = ability:GetSpecialValueFor("damage")
	local radius = ability:GetSpecialValueFor("radius")
	local speed = ability:GetSpecialValueFor("speed")

	local masterCombo = caster.MasterUnit2:FindAbilityByName("robin_combo")
	masterCombo:EndCooldown()
	masterCombo:StartCooldown(ability:GetCooldown(1))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_robin_combo_cooldown", {duration = ability:GetCooldown(ability:GetLevel())})
	caster:RemoveModifierByName("modifier_combo_window")

	giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", cast_delay + 0.4)

    Timers:CreateTimer(0.45, function()
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})

		EmitGlobalSound("Robin.Combo")

	    Timers:CreateTimer(0.5, function()
	   		caster:EmitSound("Robin.ComboSFX")
			local particleeff = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_vines_small.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particleeff, 0, caster:GetAbsOrigin() + Vector(0,0,-100))
		end)	

		local ult = caster:FindAbilityByName(caster.RSkill)
		ult:StartCooldown(ult:GetCooldown(ult:GetLevel()))
		

		--StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.6})
		giveUnitDataDrivenModifier(caster, caster, "modifier_stunned", cast_delay + 0.1)
		giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", cast_delay - 0.1)

		local targetdummy = CreateUnitByName("dummy_unit", targetpoint , false, caster, caster, caster:GetTeamNumber())
		targetdummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1) 
		targetdummy:AddNewModifier(caster, nil, "modifier_phased", {duration=9})
		targetdummy:AddNewModifier(caster, nil, "modifier_kill", {duration=9})

		Timers:CreateTimer(0.3, function()
			FreezeAnimation(caster,cast_delay - 0.4)
		end)	

		Timers:CreateTimer(cast_delay, function()

		if caster:IsAlive() then
			EmitGlobalSound("Robin.YewBowSFX")
			EmitGlobalSound("Robin.YewBowSFX2")

			local projectile = {
		    	Target = targetdummy,
				Source = caster,
				Ability = ability,	
	        	EffectName = "particles/robin/yewbowarrow-combo/yewbowarrow.vpcf",
		        iMoveSpeed = speed,
				vSourceLoc= caster:GetAbsOrigin(),
		        iSourceAttachment = caster:GetAbsOrigin() + Vector(0,0,20),
				bDrawsOnMinimap = false,
		        bDodgeable = true,
		        bIsAttack = false,
		        flExpireTime = GameRules:GetGameTime() + 3,
				bProvidesVision = true,                           -- Optional
				iVisionRadius = 150,                              -- Optional
				iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
		   		}
		    	ProjectileManager:CreateTrackingProjectile(projectile)
		    end

		end)		
	end)
end

function OnComboHit(keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
	local damage = ability:GetSpecialValueFor("damage")
	local radius = ability:GetSpecialValueFor("radius")
	local damage_chain_yew = ability:GetSpecialValueFor("damage_yew_bonus")
	local damage_chain_smoke = ability:GetSpecialValueFor("damage_smoke_bonus")
	local damage_chain_roots = ability:GetSpecialValueFor("damage_roots_bonus")
	local damage_paralyze_bonus = ability:GetSpecialValueFor("damage_paralyze_bonus")
	local damage_viper_bonus = ability:GetSpecialValueFor("damage_viper_bonus")
	local chain_radius = ability:GetSpecialValueFor("chain_poison_radius")

	EmitGlobalSound("Robin.ComboHitSFX")
	EmitGlobalSound("Robin.ComboHitSFX2")
	EmitGlobalSound("Robin.ComboHitSFX3")

	local targetdummy = CreateUnitByName("sight_dummy_unit", target:GetAbsOrigin() , false, caster, caster, caster:GetTeamNumber())
	targetdummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1) 
	targetdummy:AddNewModifier(caster, nil, "modifier_phased", {duration=3})
	targetdummy:AddNewModifier(caster, nil, "modifier_kill", {duration=3})

	local root = ParticleManager:CreateParticle("particles/robin/yewbow-combo/yewbow-combo-explode.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(root, 0, target:GetAbsOrigin())
	
	local targets = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)

	for k,v in pairs(targets) do
		if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
	       	DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)	 
	       	DealInvisDamage(caster, v)      	
       	end
    end

	local duration = ability:GetSpecialValueFor("duration")
	local dps = ability:GetSpecialValueFor("dps")
	local chain_dmg = 0

	for i=duration,0,-0.25 do	
		Timers:CreateTimer(i, function()
			local enemies = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			if enemies == nil then return end

			for k,v in pairs(enemies) do
				if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
					if v:HasModifier("modifier_robin_yew_bow") or v:HasModifier("modifier_robin_roots_slow") or v:HasModifier("modifier_robin_poison_smoke") or v:HasModifier("modifier_robin_hunter_rain_debuff") or v:HasModifier("modifier_robin_paralyze") then
			       		local chain_targets = FindUnitsInRadius(caster:GetTeam(), v:GetAbsOrigin(), nil, chain_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			       		if v:HasModifier("modifier_robin_yew_bow") then 
			       			chain_dmg = chain_dmg + damage_chain_yew
			       		end
			       		if v:HasModifier("modifier_robin_roots_slow") then 
			       			chain_dmg = chain_dmg + damage_chain_roots
			       		end
			       		if v:HasModifier("modifier_robin_poison_smoke") then 
			       			chain_dmg = chain_dmg + damage_chain_smoke
			       		end
			       		if v:HasModifier("modifier_robin_hunter_rain_debuff") then 
			       			chain_dmg = chain_dmg + damage_viper_bonus
			       		end
			       		if v:HasModifier("modifier_robin_paralyze") then 
			       			chain_dmg = chain_dmg + damage_paralyze_bonus
			       		end
			       		for _,j in pairs (chain_targets) do
			       			DoDamage(caster, v, chain_dmg / 4, DAMAGE_TYPE_MAGICAL, 0, ability, false)
			       		end
			       	end

					if caster.IsTaxineAcquired then
						local scale = ability:GetSpecialValueFor("dps_per_int") * caster:GetIntellect()
					    DoDamage(caster, v, (dps + scale) / 4, DAMAGE_TYPE_MAGICAL, 0, ability, false)
					else
					    DoDamage(caster, v, dps / 4, DAMAGE_TYPE_MAGICAL, 0, ability, false)
				    end
			    end
			end
		end)
	end

end

function OnPoisonSmokeStart(keys)
	local caster = keys.caster
    local ability = keys.ability
    local targetpoint = ability:GetCursorPosition()
	local duration = ability:GetSpecialValueFor("trap_duration")
	local damage = ability:GetSpecialValueFor("damage")
	local radius = ability:GetSpecialValueFor("radius")
	
	caster:EmitSound("Robin.PoisonSmoke")

	local trap_dummy = CreateUnitByName("robin_bomb", targetpoint, false, caster, caster, caster:GetTeamNumber())
	--trap_dummy:FindAbilityByName("dummy_unit_passive_no_fly"):SetLevel(1)
	trap_dummy:AddNewModifier(caster, ability, "modifier_kill", {Duration = duration})
	trap_dummy:SetAbsOrigin(trap_dummy:GetAbsOrigin() + Vector(0,0,20))
	ability:ApplyDataDrivenModifier(caster, trap_dummy, "modifier_robin_bomb_checker", {})
end

function BombCheck(keys)
	local caster = keys.caster
    local ability = keys.ability
    local trap = keys.target
    local trap_loc = trap:GetAbsOrigin()
    local trap_radius = ability:GetSpecialValueFor("trap_radius")

	local enemies = FindUnitsInRadius(caster:GetTeam(), trap_loc, nil, trap_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	if enemies[1] == nil then return end 
	
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	trap:EmitSound("Robin.PoisonSmokeSFX")

	--local pot_fx = ParticleManager:CreateParticle("particles/robin/poisonsmoke/poisonbottlemodel.vpcf", PATTACH_ABSORIGIN, caster)

	local pot_hit = ParticleManager:CreateParticle("particles/robin/poisonsmoke/poisonsmoke.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pot_hit, 0, trap_loc)
	ParticleManager:SetParticleControl(pot_hit, 1, Vector(duration,0,0))
	ParticleManager:SetParticleControl(pot_hit, 2, Vector(radius,0,0))

	trap:EmitSound("Robin.PitfallTriggerSFX")
    trap:ForceKill(false)	

	local dummy = CreateUnitByName("dummy_unit", trap_loc, false, caster, caster, caster:GetTeamNumber())
	dummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1) 
	dummy:AddNewModifier(caster, nil, "modifier_kill", {duration= duration})
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_robin_poison_smoke_aura", {})
	Timers:CreateTimer(duration, function()
		ParticleManager:DestroyParticle(pot_hit, true)
		ParticleManager:ReleaseParticleIndex(pot_hit)
	end)
end

function OnPoisonSmokeThink(keys)
	local caster = keys.caster
	local ability = keys.ability 
	local target = keys.target
	local dps = ability:GetSpecialValueFor("dps")

	if target:IsAlive() then
		DoDamage(caster, target, dps/2, DAMAGE_TYPE_MAGICAL, 0, ability, false)
		--[[local currenthp = target:GetHealth()

		Timers:CreateTimer(0.5, function()
			if target:IsAlive() and target:HasModifier("modifier_robin_poison_smoke") then
				if target:GetHealth() >= currenthp + 150 then
					DoDamage(caster, target, target:GetMaxHealth() * heal_damage / 100, DAMAGE_TYPE_MAGICAL, 0, ability, false)
					target:RemoveModifierByName("modifier_robin_poison_smoke")
					
					local root = ParticleManager:CreateParticle("particles/units/heroes/hero_viper/viper_viper_strike_impact_b.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(root,1, target:GetAbsOrigin())					
					local root = ParticleManager:CreateParticle("particles/units/heroes/hero_viper/viper_viper_strike_impact.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(root,0, target:GetAbsOrigin())
					ParticleManager:SetParticleControl(root,1, target:GetAbsOrigin())
				end
			end
		end)]]
	end
end

function OnSummonFamilliarStart(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local pid = caster:GetPlayerOwner():GetPlayerID()

	local duration = ability:GetSpecialValueFor( "lifetime" )

	caster:EmitSound("Robin.FamilliarSFX")

	-- Summon spooky skeletal 
	local spooky = CreateUnitByName("robin_bird", caster:GetAbsOrigin(), true, nil, nil, caster:GetTeamNumber()) 
	spooky:SetControllableByPlayer(pid, true)
	spooky:SetOwner(caster:GetPlayerOwner():GetAssignedHero())
	FindClearSpaceForUnit(spooky, spooky:GetAbsOrigin(), true)

	ability:ApplyDataDrivenModifier(caster, spooky, "modifier_robin_scout_familliar", {})
	spooky:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
	spooky:SetAbsOrigin(spooky:GetAbsOrigin() + Vector(0,0,40))

	Timers:CreateTimer(0.05, function()
		spooky:MoveToPosition(caster:GetAbsOrigin() + Vector(2,2,0))
	end)
end

function OnSaboteurUpgrade(keys)
	local caster = keys.caster
	local ability = keys.ability 
	--local hero = caster.HeroUnit

	if caster.IsSubversiveAcquired then
		caster:FindAbilityByName("robin_saboteur_pitfall_upgrade"):SetLevel(ability:GetLevel())
		caster:FindAbilityByName("robin_saboteur_barrel_upgrade"):SetLevel(ability:GetLevel())
	else
		caster:FindAbilityByName("robin_saboteur_pitfall"):SetLevel(ability:GetLevel())
		caster:FindAbilityByName("robin_saboteur_barrel"):SetLevel(ability:GetLevel())
	end
	caster:FindAbilityByName("robin_saboteur_scout_familliar"):SetLevel(ability:GetLevel())
	caster:FindAbilityByName("robin_saboteur_poison_well"):SetLevel(ability:GetLevel())
end

function OnRobinAttack(keys)
	local caster = keys.caster 
	local target = keys.target 
	local ability = keys.ability 

	if caster:HasModifier("modifier_robin_poison_arrow_buff") then return end 

	AddPoisonStack(keys, 1)
end

function AddPoisonStack(keys, iStack)
	local caster = keys.caster
	local ability = caster:FindAbilityByName("robin_poison_arrow")
	local maxStack = ability:GetSpecialValueFor("max_stack")

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_robin_poison_arrow_stack", {})

	local stack = caster:GetModifierStackCount("modifier_robin_poison_arrow_stack", caster) or 0 
	local newstack = math.min(stack + iStack, maxStack)
	caster:SetModifierStackCount("modifier_robin_poison_arrow_stack", caster, newstack)

	if caster.tPoisonArrow == nil then 
		caster.tPoisonArrow = {
			"modifier_robin_yew_bow",
			"modifier_robin_roots_slow",
		}
	end

	if newstack >= maxStack then
		caster:RemoveModifierByName("modifier_robin_poison_arrow_stack")
		local random = RandomInt(1, #caster.tPoisonArrow)
		caster.PoisonArrowDebuff = caster.tPoisonArrow[random]
		caster.arrow_fx = nil
		caster.arrow_projectile = nil
		caster.ability_name = nil
		if caster.PoisonArrowDebuff == "modifier_robin_yew_bow" then 
			caster.arrow_fx = "particles/robin/arrow_symbol_yellow.vpcf"
			caster.arrow_projectile = "particles/robin/yewbow_arrow.vpcf"
			caster.ability_name = caster.RSkill 
		elseif caster.PoisonArrowDebuff == "modifier_robin_roots_slow" then 
			caster.arrow_fx = "particles/robin/arrow_symbol_pink.vpcf"
			caster.arrow_projectile = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_base_attack_v2.vpcf"
			caster.ability_name = caster.ESkill 
		elseif caster.PoisonArrowDebuff == "modifier_robin_paralyze" then 
			caster.arrow_fx = "particles/robin/arrow_symbol_blue.vpcf"  
			caster.arrow_projectile = "particles/econ/items/hoodwink/hoodwink_2022_immortal/hoodwink_2022_immortal_base_attack_blossom.vpcf"		
			caster.ability_name = caster.WSkill 
		elseif caster.PoisonArrowDebuff == "modifier_robin_hunter_rain_debuff" then 
			caster.arrow_fx = "particles/robin/arrow_symbol_red.vpcf" 
			caster.arrow_projectile = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_base_attack.vpcf"
			caster.ability_name = caster.FSkill 
		elseif caster.PoisonArrowDebuff == "modifier_robin_poison_smoke" then 
			caster.arrow_fx = "particles/robin/arrow_symbol_green.vpcf"
			caster.arrow_projectile = "particles/econ/items/hoodwink/hoodwink_2022_immortal/hoodwink_2022_immortal_base_attack.vpcf"
			caster.ability_name = "robin_saboteur_poison_well" 
		end 
		caster:SetRangedProjectileName(caster.arrow_projectile)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_robin_poison_arrow_buff", {})
	end
end

function OnRobinPoisonAttack(keys)
	local caster = keys.caster 
	local target = keys.target 

	--[[local ability_name = ""

	print('poison = ' .. caster.PoisonArrowDebuff)

	if caster.PoisonArrowDebuff == "modifier_robin_yew_bow" then 
		ability_name = caster.RSkill 
	elseif caster.PoisonArrowDebuff == "modifier_robin_roots_slow" then 
		ability_name = caster.ESkill 
	elseif caster.PoisonArrowDebuff == "modifier_robin_paralyze" then 
		ability_name = caster.WSkill 
	elseif caster.PoisonArrowDebuff == "modifier_robin_hunter_rain_debuff" then 
		ability_name = caster.FSkill 
	elseif caster.PoisonArrowDebuff == "modifier_robin_poison_smoke" then 
		ability_name = "robin_saboteur_poison_well" 
	end
	print('ability name = ' .. ability_name)]]
	caster:FindAbilityByName(caster.ability_name):ApplyDataDrivenModifier(caster, target, caster.PoisonArrowDebuff, {Duration = 1.0})
	if caster.ability_name == caster.RSkill then 
		target:SetModifierStackCount(caster.PoisonArrowDebuff, caster, math.abs(caster:FindAbilityByName(caster.ability_name):GetSpecialValueFor("heal_red")))
	end
	caster:RemoveModifierByName("modifier_robin_poison_arrow_buff")
end

function OnRobinPoisonSFX(keys)
	local caster = keys.caster
	--[[local fx_name = ""
	if caster.PoisonArrowDebuff == "modifier_robin_yew_bow" then 
		fx_name = "particles/robin/arrow_symbol_yellow.vpcf"
		caster:SetRangedProjectileName("particles/robin/yewbowarrow/yewbowarrow.vpcf")
	elseif caster.PoisonArrowDebuff == "modifier_robin_roots_slow" then 
		fx_name = "particles/robin/arrow_symbol_pink.vpcf"
		caster:SetRangedProjectileName("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_base_attack_v2.vpcf")
	elseif caster.PoisonArrowDebuff == "modifier_robin_paralyze" then 
		fx_name = "particles/robin/arrow_symbol_blue.vpcf"  
		caster:SetRangedProjectileName("particles/econ/items/hoodwink/hoodwink_2022_immortal/hoodwink_2022_immortal_base_attack_blossom.vpcf")		
	elseif caster.PoisonArrowDebuff == "modifier_robin_hunter_rain_debuff" then 
		fx_name = "particles/robin/arrow_symbol_red.vpcf" 
		caster:SetRangedProjectileName("particles/econ/items/drow/drow_ti9_immortal/drow_ti9_base_attack.vpcf")
	elseif caster.PoisonArrowDebuff == "modifier_robin_poison_smoke" then 
		fx_name = "particles/robin/arrow_symbol_green.vpcf"
		caster:SetRangedProjectileName("particles/econ/items/hoodwink/hoodwink_2022_immortal/hoodwink_2022_immortal_base_attack.vpcf")
	end ]]
	caster.arrowfx = ParticleManager:CreateParticle(caster.arrow_fx, PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl(caster.arrowfx, 0, caster:GetAbsOrigin())
end

function OnRobinPoisonSFXDestroy(keys)
	local caster = keys.caster
	caster:SetRangedProjectileName("particles/units/heroes/hero_drow/drow_base_attack.vpcf")
	ParticleManager:DestroyParticle(caster.arrowfx, true)
	ParticleManager:ReleaseParticleIndex(caster.arrowfx)
	caster.PoisonArrowDebuff = nil
end

function OnSubversiveAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsSubversiveAcquired) then

		hero.IsSubversiveAcquired = true
		if hero:HasModifier("modifier_robin_saboteur_open") then
			UpgradeAttribute(hero, "robin_saboteur_open", "robin_saboteur_open_upgrade" , false)
			UpgradeAttribute(hero, "robin_saboteur_pitfall", "robin_saboteur_pitfall_upgrade" , true)
			UpgradeAttribute(hero, "robin_saboteur_barrel", "robin_saboteur_barrel_upgrade" , true)
			hero:SwapAbilities(hero:GetAbilityByIndex(2):GetAbilityName(), "robin_saboteur_scout_familliar", false, true)
			hero:SwapAbilities(hero:GetAbilityByIndex(3):GetAbilityName(), "robin_saboteur_poison_well", false, true)
		else
			UpgradeAttribute(hero, "robin_saboteur_open", "robin_saboteur_open_upgrade" , true)
			UpgradeAttribute(hero, "robin_saboteur_pitfall", "robin_saboteur_pitfall_upgrade" , false)
			UpgradeAttribute(hero, "robin_saboteur_barrel", "robin_saboteur_barrel_upgrade" , false)
			hero:RemoveModifierByName("modifier_robin_saboteur_open")
		end

		hero.QSkill = "robin_saboteur_open_upgrade"

		if hero.tPoisonArrow == nil then 
			hero.tPoisonArrow = {
				"modifier_robin_yew_bow",
				"modifier_robin_roots_slow",
			}
		end

		table.insert(hero.tPoisonArrow, "modifier_robin_poison_smoke")

		NonResetAbility(hero)
		-- UpgradeAttribute(hero, "kinghassan_azrael", "kinghassan_azrael_upgraded", true)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnRighteousThiefAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsRighteousThiefAcquired) then

		hero.IsRighteousThiefAcquired = true
		if hero:HasModifier("modifier_robin_saboteur_open") then
			UpgradeAttribute(hero, "robin_faceless_king", "robin_faceless_king_upgrade" , false)
		else
			UpgradeAttribute(hero, "robin_faceless_king", "robin_faceless_king_upgrade" , true)
		end
		hero:FindAbilityByName("robin_righteous_thief"):SetLevel(1)

		hero.DSkill = "robin_faceless_king_upgrade"
		--[[if hero:HasModifier("modifier_robin_saboteur_open") then
			UpgradeAttribute(hero, "robin_clairvoyance", "robin_righteous_thief" , false)
		else
			UpgradeAttribute(hero, "robin_clairvoyance", "robin_righteous_thief" , true)
		end

		hero.FSkill = "robin_righteous_thief"]]
		NonResetAbility(hero)
		-- UpgradeAttribute(hero, "kinghassan_azrael", "kinghassan_azrael_upgraded", true)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnFacelessKingAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsFacelessKingAcquired) then

		hero.IsFacelessKingAcquired = true
		if hero:HasModifier("modifier_robin_saboteur_open") then
			if hero.IsSubversiveAcquired then
				UpgradeAttribute(hero, "robin_faceless_king", "robin_faceless_king_upgrade" , false)
			else
				UpgradeAttribute(hero, "robin_faceless_king", "robin_faceless_king_upgrade" , true)
			end
		else
			UpgradeAttribute(hero, "robin_faceless_king", "robin_faceless_king_upgrade" , true)
		end

		hero.DSkill = "robin_faceless_king_upgrade"
		NonResetAbility(hero)
		-- UpgradeAttribute(hero, "kinghassan_azrael", "kinghassan_azrael_upgraded", true)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnGuerillaAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsGuerillaAcquired) then

		if hero:HasModifier("modifier_combo_window") then
			hero:RemoveModifierByName("modifier_combo_window")
		end
		
		hero.IsGuerillaAcquired = true

		if hero.IsTaxineAcquired then
			UpgradeAttribute(hero, "robin_yew_bow_taxine", "robin_yew_bow_upgrade" , true)
			hero.RSkill = "robin_yew_bow_upgrade"
		else
			UpgradeAttribute(hero, "robin_yew_bow", "robin_yew_bow_guerilla" , true)
			hero.RSkill = "robin_yew_bow_guerilla"
		end

		if hero:HasModifier("modifier_robin_saboteur_open") then
			if hero.IsViperAcquired then
				UpgradeAttribute(hero, "robin_hunter_rain", "robin_hunter_rain_upgrade" , false)
				hero.FSkill = "robin_hunter_rain_upgrade"
				table.insert(hero.tPoisonArrow, "modifier_robin_hunter_rain_debuff")
			else
				hero.FSkill = "robin_hunter_rain"
			end
		else
			if hero.IsViperAcquired then
				hero:SwapAbilities(hero.FSkill, "robin_hunter_rain", false, true)
				UpgradeAttribute(hero, "robin_hunter_rain", "robin_hunter_rain_upgrade" , true)
				hero.FSkill = "robin_hunter_rain_upgrade"
				table.insert(hero.tPoisonArrow, "modifier_robin_hunter_rain_debuff")
			else
				hero:SwapAbilities(hero.FSkill, "robin_hunter_rain", false, true)
				hero.FSkill = "robin_hunter_rain"
			end
		end

		NonResetAbility(hero)
		-- UpgradeAttribute(hero, "kinghassan_azrael", "kinghassan_azrael_upgraded", true)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnTaxineAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsTaxineAcquired) then

		if hero:HasModifier("modifier_combo_window") then
			hero:RemoveModifierByName("modifier_combo_window")
		end

		hero.IsTaxineAcquired = true
		if hero:HasModifier("modifier_robin_saboteur_open") then
			UpgradeAttribute(hero, "robin_paralyzing_arrow", "robin_paralyzing_arrow_upgrade" , false)
			UpgradeAttribute(hero, "robin_roots", "robin_roots_upgrade" , false)		
		else
			UpgradeAttribute(hero, "robin_paralyzing_arrow", "robin_paralyzing_arrow_upgrade" , true)	
			UpgradeAttribute(hero, "robin_roots", "robin_roots_upgrade" , true)
		end

		hero.WSkill = "robin_paralyzing_arrow_upgrade"
		hero.ESkill = "robin_roots_upgrade"

		if hero.IsGuerillaAcquired then
			UpgradeAttribute(hero, "robin_yew_bow_guerilla", "robin_yew_bow_upgrade" , true)
			hero.RSkill = "robin_yew_bow_upgrade"
		else
			UpgradeAttribute(hero, "robin_yew_bow", "robin_yew_bow_taxine" , true)
			hero.RSkill = "robin_yew_bow_taxine"
		end

		UpgradeAttribute(hero, "robin_combo", "robin_combo_upgrade" , false)

		if hero.tPoisonArrow == nil then 
			hero.tPoisonArrow = {
				"modifier_robin_yew_bow",
				"modifier_robin_roots_slow",
			}
		end

		table.insert(hero.tPoisonArrow, "modifier_robin_paralyze")

		NonResetAbility(hero)
		-- UpgradeAttribute(hero, "kinghassan_azrael", "kinghassan_azrael_upgraded", true)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnViperAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsViperAcquired) then

		hero.IsViperAcquired = true
		if hero.tPoisonArrow == nil then 
			hero.tPoisonArrow = {
				"modifier_robin_yew_bow",
				"modifier_robin_roots_slow",
			}
		end
		if hero:HasModifier("modifier_robin_saboteur_open") then
			if hero.IsGuerillaAcquired then
				UpgradeAttribute(hero, "robin_hunter_rain", "robin_hunter_rain_upgrade" , false)
				hero.FSkill = "robin_hunter_rain_upgrade"
				table.insert(hero.tPoisonArrow, "modifier_robin_hunter_rain_debuff")			
			end
		else
			if hero.IsGuerillaAcquired then				
				UpgradeAttribute(hero, "robin_hunter_rain", "robin_hunter_rain_upgrade" , true)	
				hero.FSkill = "robin_hunter_rain_upgrade"
				table.insert(hero.tPoisonArrow, "modifier_robin_hunter_rain_debuff")			
			end
		end
		hero:FindAbilityByName("robin_poison_arrow"):SetLevel(1)

		

		NonResetAbility(hero)
		-- UpgradeAttribute(hero, "kinghassan_azrael", "kinghassan_azrael_upgraded", true)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end


--[[

function OnPitfallCast(keys)
    local caster = keys.caster
    local ability = keys.ability
    local targetpoint = ability:GetCursorPosition()
	local pid = caster:GetPlayerOwner():GetPlayerID()
	local duration = ability:GetSpecialValueFor("trap_duration")
	
	local spooky = CreateUnitByName("medea_skeleton_warrior", targetpoint, true, nil, nil, caster:GetTeamNumber()) 
	spooky:SetControllableByPlayer(pid, true)
	spooky:SetOwner(caster:GetPlayerOwner():GetAssignedHero())
	FindClearSpaceForUnit(spooky, spooky:GetAbsOrigin(), true)

	ability:ApplyDataDrivenModifier(caster, spooky, "modifier_robin_pitfall", {})
	spooky:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})

	spooky:SetMaxHealth(10)
	spooky:SetHealth(10)
	spooky:SetMaxMana(0)
	spooky:SetMana(0)
	spooky:SetModel("models/han/default/han_by_zefiroft.vmdl")
	spooky:SetOriginalModel("models/han/default/han_by_zefiroft.vmdl")
	spooky:SetModelScale(1)	
end

function OnPitfallThink(keys)
	print(keys.caster)
	print(keys.ability)
	print(keys[1])
	print(keys[2])
	print(keys[3])
	print(keys[4])
	print(keys[5])
	print(keys[6])
	print(self)

	local caster = keys.caster
	local ability = keys.ability 
	local damage = ability:GetSpecialValueFor("damage")
	local stun = ability:GetSpecialValueFor("stun_duration")
	local radius = ability:GetSpecialValueFor("radius")

	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin() , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)

	if targets == nil then return
	else
		for k,v in pairs(targets) do
			if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
		       	DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
				v:AddNewModifier(caster, ability, "modifier_stunned", { Duration = stun })
	       	end
	    end
	end
end

]]--
