
function OnAbilityCastInvisBroke(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	if caster:HasModifier("modifier_shukuchi_invis") then 
		caster:RemoveModifierByName("modifier_shukuchi_invis")
	end
end

function OnFlagCast(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	if IsValidEntity(caster.flag) and caster.flag:IsAlive() then
		caster:Interrupt()
    	SendErrorMessage(caster:GetPlayerOwnerID(), "#Cannot_Summon")
    	return
    end
    OnSeiganStop(keys)
end

function OnFlagStart (keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local flag_origin = caster:GetAbsOrigin() + caster:GetForwardVector() * 100
	local radius = ability:GetSpecialValueFor("radius")
	local min_summon = ability:GetSpecialValueFor("min_summon")
	local max_summon = ability:GetSpecialValueFor("max_summon")
	local duration = ability:GetSpecialValueFor("duration")
	local flag_health = ability:GetSpecialValueFor("flag_health")
	local summon_count = RandomInt(min_summon, max_summon)

	if IsValidEntity(caster.flag) and caster.flag:IsAlive() then
    	ability:EndCooldown()
    	caster:GiveMana(ability:GetManaCost(ability:GetLevel())) 
    	SendErrorMessage(caster:GetPlayerOwnerID(), "#Cannot_Summon")
    	return
    end

    --[[local iskandar = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, FIND_ANY_ORDER, false)
    for _,iskander in pairs(iskandar) do
    	if iskander:GetName() == "npc_fate_hero_chen" then 
    		caster.bIskandarAllied = true
    	end
    end]]

	caster.flag = CreateUnitByName("okita_flag", flag_origin, true, nil, nil, caster:GetTeamNumber())
	caster.flag:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
	caster.flag:SetBaseMaxHealth(flag_health)
	caster.flag:SetForwardVector(caster:GetForwardVector())
	caster.flag:SetControllableByPlayer(caster:GetPlayerID(), true)
	caster.flag:FindAbilityByName("okita_flag_of_sincerity_passive"):SetLevel(1)
	caster.flag:SetOwner(caster)
	FindClearSpaceForUnit(caster.flag, flag_origin , true)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_flag_summon", {})

	caster.currentflaghealth = flag_health
	caster.flagorigin = flag_origin
	caster.flagradius = radius
	caster.duration = duration
	--[[if caster.flag:GetOrigin().y >= -2000 then 
		caster.flagspawnrealworld = true
	print('flag spawn real world')
	else 
	 	caster.flagspawnrealworld = false
	end]]

	if caster.cacheunit == nil then 
		caster.cacheunit = {}
	end

	if caster.shinsengumi == nil then 
		caster.shinsengumi = {}
	end

	for i = 1,summon_count do
		Timers:CreateTimer(i*0.1, function()
	    	caster.shinsengumi[i] = CreateUnitByName("okita_shinsengumi", flag_origin + RandomVector(150) , true, nil, nil, caster:GetTeamNumber())
	    	FindClearSpaceForUnit(caster.shinsengumi[i], flag_origin + RandomVector(150), true)
	    	caster.shinsengumi[i]:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
	    	caster.shinsengumi[i]:SetControllableByPlayer(caster:GetPlayerID(), true)
			caster.shinsengumi[i]:SetForwardVector(caster:GetForwardVector())
			caster.shinsengumi[i]:FindAbilityByName("okita_shinsengumi_passive"):SetLevel(1)
			caster.shinsengumi[i]:SetOwner(caster)
		end)
   	end

   	caster.shinsengumi_count = summon_count

   	if caster.IsCoadOfOathsAcquired then 
   		if RandomInt(1, 100) <= ability:GetSpecialValueFor("summon_chance") then
	   		caster.Hijikata = CreateUnitByName("okita_hijikata", flag_origin + RandomVector(150) , true, nil, nil, caster:GetTeamNumber())
	    	FindClearSpaceForUnit(caster.Hijikata, flag_origin + RandomVector(150), true)
	    	caster.Hijikata:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
	    	caster.Hijikata:SetControllableByPlayer(caster:GetPlayerID(), true)
			caster.Hijikata:SetForwardVector(caster:GetForwardVector())
			caster.Hijikata:FindAbilityByName("okita_head_shinsengumi_passive"):SetLevel(1)
			caster.Hijikata:FindAbilityByName("okita_law_of_shinsengumi_passive"):SetLevel(1)
			caster.Hijikata:FindAbilityByName("okita_hijikata_undying_sincerity"):SetLevel(1)
			caster.Hijikata:SetOwner(caster)
			caster.shinsengumi_count = caster.shinsengumi_count + 1
		end
	end
   

   	--particle area 
   	local sacredZoneFx = ParticleManager:CreateParticle("particles/custom/okita/okita_flag_zone.vpcf", PATTACH_WORLDORIGIN, caster.flag)
	ParticleManager:SetParticleControl(sacredZoneFx, 0, flag_origin)
	ParticleManager:SetParticleControl(sacredZoneFx, 1, Vector(1,1,radius))
	ParticleManager:SetParticleControl(sacredZoneFx, 14, Vector(radius,0,0))
	caster.CurrentFlagParticle = sacredZoneFx
end

function OnFlagTakeDamagePassive (keys)
	local caster = keys.caster 
	local hero = caster:GetOwnerEntity()
	local ability = keys.ability
	local currenthealth = caster:GetHealth()
	if caster:IsAlive() then
		currenthealth = currenthealth - 1
		caster:SetHealth(currenthealth)
		if currenthealth <= 0 then
			OnFlagDeath(hero)
		end
	end
end

function OnFlagThinkPassive (keys)
	local caster = keys.caster 
	local hero = caster:GetOwnerEntity()
	local ability = keys.ability 

	 -- apply shinsengumi brother buff
	local okita = FindUnitsInRadius(hero:GetTeam(), caster:GetOrigin(), nil, hero.flagradius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,h in pairs (okita) do
		if h:GetUnitName() == hero:GetUnitName() then 		
			if h:HasModifier("modifier_weak_constitution") then 
				for _,v in pairs(hero.shinsengumi) do
					if v and IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
						ability:ApplyDataDrivenModifier(caster, v, "modifier_weak_buff", {})
					end
				end
			end
		end
	end	

	if hero.shinsengumi_count <= 0 or not IsInSameRealm(caster:GetOrigin(), hero:GetOrigin()) then 
		hero:RemoveModifierByName("modifier_flag_summon")
    end

    for _,s in pairs(hero.shinsengumi) do
		if s and IsValidEntity(s) then
			if not IsInSameRealm(caster:GetAbsOrigin(), s:GetAbsOrigin()) then 
				s:ForceKill(true)
			end
        end
	end
end 

function OnSummonFlagDestroy(keys)
	local caster = keys.caster 
	if caster.flag == nil then return end

	OnFlagDeath(caster)
end

function OnFlagDeath(hero)

	ParticleManager:DestroyParticle( hero.CurrentFlagParticle, false )
	ParticleManager:ReleaseParticleIndex( hero.CurrentFlagParticle )

	for _,v in pairs(hero.shinsengumi) do
		if v and IsValidEntity(v) then
			--table.insert(hero.cacheunit, v)
	        v:ForceKill(true)
	    end
	end
	if IsValidEntity(hero.Hijikata) then 
		--table.insert(hero.cacheunit, hero.Hijikata)
		hero.Hijikata:ForceKill(true)
	end
	if IsValidEntity(hero.flag) then  
		hero.flag:ForceKill(true)
	end
	if hero:HasModifier("modifier_weak_buff") then 
		hero:RemoveModifierByName("modifier_weak_buff")
	end	

	hero.shinsengumi_count = 0
end

function OnOkitaDeath (keys)
	local caster = keys.caster 
	local ability = keys.ability 

	caster:RemoveModifierByName("modifier_flag_summon")
end

function OnFlagDeathPassive (keys)
	local caster = keys.caster 
	local hero = caster:GetOwnerEntity()

	hero:RemoveModifierByName("modifier_flag_summon")
end 

function OnShinsengumiThinkPassive (keys)
	local caster = keys.caster 
	local hero = caster:GetOwnerEntity()

	if not IsValidEntity(hero.flag) then
		if caster:IsAlive() then
        	caster:RemoveSelf()
        end
    end

	if math.abs((caster:GetOrigin() - hero.flagorigin):Length2D()) > hero.flagradius then
		local diff = caster:GetOrigin() - hero.flagorigin
		diff = diff:Normalized()

		caster:SetAbsOrigin(hero.flagorigin + diff * hero.flagradius)
	--print("Abs Origin To Set", (TheatreCenter + diff * self.TheatreSize))
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
	end
end 

function OnShinsengumiDeath (keys)
	local caster = keys.caster 
	local hero = caster:GetOwnerEntity()
	hero.shinsengumi_count = hero.shinsengumi_count - 1
	if hero.shinsengumi_count <= 0 then 
		hero:RemoveModifierByName("modifier_flag_summon")
	end
end

function OnLawShinsengumiCheck(keys)
	local caster = keys.caster 
	local hero = caster:GetOwnerEntity() 
	local ability = keys.ability
	local target = keys.target 
	if IsShinsengumi(target) then 
		ability:ApplyDataDrivenModifier(caster, target, "modifier_law_of_shinsengumi_buff", {})
	end
end

function OnLawShinsengumiDestroy(keys)
	local target = keys.target 
	target:RemoveModifierByName("modifier_law_of_shinsengumi_buff")
end

function OnUndyingSincerityCast(keys)
	local caster = keys.caster 
	local ability = keys.ability
	local target = keys.target  
	if target:GetName() == "npc_dota_ward_base" then 
		caster:Interrupt() 
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Invalid_Target")
		return
	end
end

function OnUndyingSincerityStart(keys)
	local caster = keys.caster 
	local ability = keys.ability
	local target = keys.target  
	local range = ability:GetSpecialValueFor("range")
	local speed = ability:GetSpecialValueFor("speed")
	local damage = ability:GetSpecialValueFor("damage")
	local stun = ability:GetSpecialValueFor("stun")

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_undying_sincerity", {})

	local hijikata = Physics:Unit(caster) 
	if caster:IsAlive() then
		caster:SetPhysicsVelocity(caster:GetForwardVector() * speed)
		caster:PreventDI()
	    caster:SetPhysicsFriction(0)
		caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	    caster:FollowNavMesh(false)	
	    caster:SetAutoUnstuck(false)
	    caster:OnPhysicsFrame(function(unit)
			local diff = target:GetAbsOrigin() - unit:GetAbsOrigin()
			local dir = diff:Normalized()
			unit:SetPhysicsVelocity(dir * speed)
			if diff:Length() >= 1500 or not IsInSameRealm(target:GetAbsOrigin(), caster:GetAbsOrigin()) or target:IsInvulnerable() or target:IsInvisible() then 
				unit:RemoveModifierByName("modifier_undying_sincerity")
				unit:PreventDI(false)
				unit:SetPhysicsVelocity(Vector(0,0,0))
				unit:OnPhysicsFrame(nil)
				unit:OnHibernate(nil)
				unit:SetAutoUnstuck(true)
		        FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		        return
			elseif diff:Length() <= 100 then
				unit:RemoveModifierByName("modifier_undying_sincerity")
				unit:PreventDI(false)
				unit:SetPhysicsVelocity(Vector(0,0,0))
				unit:OnPhysicsFrame(nil)
				unit:OnHibernate(nil)
				unit:SetAutoUnstuck(true)
		        FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

		        if IsValidEntity(target) and not target:IsNull() and target:IsAlive() then 
		        	target:AddNewModifier(unit, ability, "modifier_stunned", {Duration = stun})
		        end
		        DoDamage(unit, target, damage, DAMAGE_TYPE_PURE, 0, ability, false)
		        
		    end
		end)
	end
end

function AddExhaust(keys, modifier)
	local caster = keys.caster 

	if not IsValidEntity(caster) or caster:IsNull() or not caster:IsAlive() then return end

	local ability = caster:FindAbilityByName("okita_weak_constitution")
	if ability == nil then 
		ability = caster:FindAbilityByName("okita_weak_constitution_upgrade")
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_weak_constitution_progress", {})

	local current_stack = caster:GetModifierStackCount("modifier_weak_constitution_progress", caster) or 0 

	caster:SetModifierStackCount("modifier_weak_constitution_progress", caster, current_stack + modifier)
	caster.weak_progress = current_stack + modifier
end

function OnSoundAttack(keys)
	local caster = keys.caster 
	caster:EmitSound("Hero_Juggernaut.Attack")
end

function OnWeakConstitutionThink(keys)
	local caster = keys.caster 
	local ability = keys.ability 

	if caster:HasModifier("round_pause") then 
		caster:RemoveModifierByName("modifier_weak_constitution_progress")
		return
	end

	if caster:HasModifier("modifier_shukuchi_breath") or caster:HasModifier("modifier_hira_seigan_thinker") or caster:HasModifier("modifier_sandanzuki_window") or caster:HasModifier("modifier_sandanzuki_dash") or caster:HasModifier("modifier_tennen_base") then 
		return 
	end

	if not caster:HasModifier('modifier_weak_constitution_progress') then 
		return 
	end

	local current_stack = caster:GetModifierStackCount("modifier_weak_constitution_progress", caster) or 0 
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local base_cough = ability:GetSpecialValueFor("base_cough")
	local max_cough = ability:GetSpecialValueFor("max_cough")
	local base_cough_delay = ability:GetSpecialValueFor("base_cough_delay")

	if caster.weak_progress >= max_cough then
		Timers:RemoveTimer('cough_timer1'.. caster:GetPlayerOwnerID())
		Timers:RemoveTimer('cough_timer2'.. caster:GetPlayerOwnerID())
		caster.CoughTrigger1 = nil
		caster.CoughTrigger = nil
		caster:Stop()
		stun_duration = stun_duration * 2
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_weak_constitution", {})
		caster:EmitSound("Okita.Cough")
		caster:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		local bloodsplash = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_bloodstain.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(bloodsplash, 1, caster:GetAbsOrigin())

		caster:RemoveModifierByName("modifier_weak_constitution_progress")
		caster.CoughTrigger = true

		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(bloodsplash, false)
			ParticleManager:ReleaseParticleIndex(bloodsplash)
		end)
	elseif caster.weak_progress >= (base_cough + max_cough)/2 then 
		stun_duration = stun_duration * 1.5
		if not caster.CoughTrigger1 then
			caster.CoughTrigger1 = true
			Timers:CreateTimer('cough_timer2' .. caster:GetPlayerOwnerID(), {
				endTime = ability:GetSpecialValueFor("base_cough_delay") / 2,
				callback = function()
				Timers:RemoveTimer('cough_timer1' .. caster:GetPlayerOwnerID())
		        if caster:IsAlive() then
					caster:Stop()
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_weak_constitution", {})
					caster:EmitSound("Okita.Cough")
					caster:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
					local bloodsplash = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_bloodstain.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
					ParticleManager:SetParticleControl(bloodsplash, 1, caster:GetAbsOrigin())

					caster:RemoveModifierByName("modifier_weak_constitution_progress")
					caster.CoughTrigger1 = nil
					caster.CoughTrigger = nil

					Timers:CreateTimer(3, function()
						ParticleManager:DestroyParticle(bloodsplash, false)
						ParticleManager:ReleaseParticleIndex(bloodsplash)
					end)
				end
		    end})
		end
	elseif caster.weak_progress >= base_cough then 
		if not caster.CoughTrigger then
			caster.CoughTrigger = true
			Timers:CreateTimer('cough_timer1' .. caster:GetPlayerOwnerID(), {
				endTime = ability:GetSpecialValueFor("base_cough_delay"),
				callback = function()
		        if caster:IsAlive() then
					caster:Stop()
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_weak_constitution", {})
					caster:EmitSound("Okita.Cough")
					caster:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
					local bloodsplash = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_bloodstain.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
					ParticleManager:SetParticleControl(bloodsplash, 1, caster:GetAbsOrigin())

					caster:RemoveModifierByName("modifier_weak_constitution_progress")
					caster.CoughTrigger = nil
					Timers:CreateTimer(3, function()
						ParticleManager:DestroyParticle(bloodsplash, false)
						ParticleManager:ReleaseParticleIndex(bloodsplash)
					end)
				end
		    end})
		end
	end
end

function OnWeakConstitutionRecovery(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	if ability == nil then 
		ability = caster:FindAbilityByName("okita_weak_constitution_upgrade")
	end
	local recovery_progress = ability:GetSpecialValueFor("recovery")
	local base_cough = ability:GetSpecialValueFor("base_cough")

	if not IsValidEntity(caster) or caster:IsNull() or not caster:IsAlive() then return end

	if caster.weak_progress > recovery_progress and caster.weak_progress < base_cough then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_weak_constitution_progress", {})
		caster:SetModifierStackCount("modifier_weak_constitution_progress", caster, caster.weak_progress - recovery_progress)
		caster.weak_progress = math.max(0, caster.weak_progress - recovery_progress)  
	else
		caster.weak_progress = 0
	end
	
end

function OnWeakConstitutionCreate(keys)
	local caster = keys.caster 
	caster.CoughTrigger = false 
end

function OnCoughUp (keys)
	local caster = keys.caster 

	if not caster:IsAlive() then return end

	OnSeiganStop(keys)

	local ability = keys.ability 
	local hp_loss_percent = ability:GetSpecialValueFor("hp_loss_percent") / 100
	local hp_loss = caster:GetHealth() * hp_loss_percent
	local cough_up = {
		victim = caster,
		attacker = caster,
		damage = hp_loss,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL, --Optional.
		ability = ability, --Optional.
	}
	ApplyDamage(cough_up)	
end

function OnWeakConstitutionAttack (keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local exhaust = ability:GetSpecialValueFor("exhaust")
	
	AddExhaust(keys, exhaust)
end

function OnShukuchiStart (keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target_loc = ability:GetCursorPosition()
	local leap_range = ability:GetSpecialValueFor("leap_range")
	local exhaust = ability:GetSpecialValueFor("exhaust")

	if IsLocked(caster) and not caster:HasModifier("modifier_hira_seigan_thinker") then
		keys.ability:EndCooldown() 
		caster:GiveMana(ability:GetManaCost(1)) 
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Cannot_Blink")
        return
    end

    OnSeiganStop(keys)

    if (target_loc - caster:GetAbsOrigin()):Length2D() > leap_range then
		target_loc = caster:GetAbsOrigin() + (((target_loc - caster:GetAbsOrigin()):Normalized()) * leap_range)
	end

	local frontvec = (target_loc - caster:GetAbsOrigin()):Normalized()

	ProjectileManager:ProjectileDodge(caster)
	AddExhaust(keys, exhaust)

	local dummy = CreateUnitByName("visible_dummy_unit", caster:GetOrigin(), false, caster, caster, caster:GetTeamNumber())
    dummy:FindAbilityByName("dummy_visible_unit_passive"):SetLevel(1)
    dummy:SetDayTimeVisionRange(0)
    dummy:SetNightTimeVisionRange(0)
    dummy:SetOrigin(caster:GetOrigin() - frontvec * 100)
    dummy:SetForwardVector(frontvec)

	local particle1 = ParticleManager:CreateParticle("particles/custom/atalanta/sting/ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
    ParticleManager:SetParticleControlEnt(particle1, 1, dummy, PATTACH_ABSORIGIN_FOLLOW, nil, dummy:GetAbsOrigin(), false)
    ParticleManager:ReleaseParticleIndex(particle1)

	FindClearSpaceForUnit(caster, target_loc, true)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shukuchi_invis", {})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shukuchi_breath", {})

	Timers:CreateTimer(2, function()
		if IsValidEntity(dummy) then
        	dummy:RemoveSelf()
        end
    end)
end

function OnTennenAttack(keys)
	local caster = keys.caster
	local ability = keys.ability 
	local max_stacks = ability:GetSpecialValueFor("max_stacks") 

	if not IsValidEntity(caster) or caster:IsNull() or not caster:IsAlive() then return end

	local current_stack = caster:GetModifierStackCount("modifier_tennen_passive", caster) or 0 

	if current_stack + 1 > max_stacks then 
		caster:RemoveModifierByName("modifier_tennen_bonus")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_tennen_bonus", {})
		caster:SetModifierStackCount("modifier_tennen_passive", caster, max_stacks)
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_tennen_bonus", {})
		caster:SetModifierStackCount("modifier_tennen_passive", caster, current_stack + 1)
		caster:CalculateStatBonus(true)
	end
end

function OnTennenThink(keys)
	local caster = keys.caster 
	if not caster:HasModifier("modifier_tennen_bonus") then 
		caster:SetModifierStackCount("modifier_tennen_passive", caster, 0)
	end
end

function OnTennenDeath(keys)
	local caster = keys.caster 
	caster:SetModifierStackCount("modifier_tennen_passive", caster, 0)
end

function OnTennenBonusDestroy(keys)
	local caster = keys.caster
	local ability = keys.ability 
	local current_stack = caster:GetModifierStackCount("modifier_tennen_passive", caster)
	caster:SetModifierStackCount("modifier_tennen_passive", caster, current_stack - 1)
	caster:CalculateStatBonus(true)
end

function OnTenninRishinStart (keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local exhaust = ability:GetSpecialValueFor("exhaust")

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_tennen_base", {})
	AddExhaust(keys, exhaust)

	OnSeiganStop(keys)

	OkitaCheckCombo(caster, ability)
end 

function OnSeiganStart(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local duration = ability:GetSpecialValueFor("duration")
	local shield = ability:GetSpecialValueFor("shield")

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_hira_seigan_shield", {})
	caster.IsShieldBreak = false
	caster.SeiganShield = shield
	caster.attacker = caster
	caster.SeiganStop = false
	StartAnimation(caster, {duration=duration, activity=ACT_DOTA_CAST_ABILITY_5, rate=2.0})
	Timers:CreateTimer(0.5, function()
		FreezeAnimation(caster)
	end)
	--[[caster.SeiganTimer = Timers:CreateTimer(duration - 0.1, function()
		if caster:IsAlive() then
			caster.IsShieldBreak = true
		end
	end)]]
end

function OnSeiganCreate(keys)
	local caster = keys.caster 
	local ability = keys.ability
	caster.forwardvec = caster:GetForwardVector()
	caster:SwapAbilities(ability:GetAbilityName(), "okita_hira_seigan_stop", false, true)
	
	caster.seiganring = ParticleManager:CreateParticle("particles/custom/okita/hira_seigen_ring2.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(caster.seiganring, 1, caster:GetAbsOrigin() + Vector(0,0, 100))

	caster.seiganshield = ParticleManager:CreateParticle("particles/custom/okita/hira_seigen_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(caster.seiganshield, 0, caster:GetAbsOrigin())
	caster:EmitSound("Hero_KeeperOfTheLight.Illuminate.Charge")
end

function OnSeiganDestroy(keys)
	local caster = keys.caster 
	local ability = keys.ability
	UnfreezeAnimation(caster)
	EndAnimation(caster)
	caster:SwapAbilities(ability:GetAbilityName(), "okita_hira_seigan_stop", true, false)

	ParticleManager:DestroyParticle(caster.seiganshield, true)
	ParticleManager:ReleaseParticleIndex(caster.seiganshield)

	ParticleManager:DestroyParticle(caster.seiganring, true)
	ParticleManager:ReleaseParticleIndex(caster.seiganring)
	
	caster:StopSound("Hero_KeeperOfTheLight.Illuminate.Charge")
	if caster.IsShieldBreak == true or caster.SeiganStop == false then 
		OnSeiganFireBeam(keys)
	end
end

function OnSeiganStop(keys)
	local caster = keys.caster 
	caster.SeiganStop = true
	UnfreezeAnimation(caster)
	EndAnimation(caster)
	caster:RemoveModifierByName("modifier_hira_seigan_shield")

	--[[if caster.SeiganTimer ~= nil then 
		Timers:RemoveTimer(caster.SeiganTimer)
		caster.SeiganTimer = nil
	end]]
end

function OnSeiganTakeDamage(keys)
	local caster = keys.caster 
	local currentHealth = caster:GetHealth() 

	-- Create particles
	local onHitParticleIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit_sphere.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( onHitParticleIndex, 2, caster:GetAbsOrigin() )
	
	Timers:CreateTimer( 0.5, function()
		ParticleManager:DestroyParticle( onHitParticleIndex, false )
		ParticleManager:ReleaseParticleIndex( onHitParticleIndex )
	end)

	caster.SeiganShield = caster.SeiganShield - keys.DamageTaken
	if caster.SeiganShield <= 0 then
		if currentHealth + caster.SeiganShield <= 0 then
			--print("lethal")
		else
			caster.SeiganShield = 0
			caster.IsShieldBreak = true
			caster.attacker = keys.attacker
			--print("rho broken, but not lethal")
			caster:RemoveModifierByName("modifier_hira_seigan_shield")
			caster:SetHealth(currentHealth + keys.DamageTaken + caster.SeiganShield)

			--Timers:RemoveTimer(caster.SeiganTimer)
		end
	else
		--print("rho not broken, remaining shield : " .. rhoTarget.rhoShieldAmount)
		caster:SetHealth(currentHealth + keys.DamageTaken)
		caster:SetModifierStackCount("modifier_rho_aias", caster, caster.SeiganShield)
	end
end

function OnSeiganFireBeam(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local attacker = caster.attacker 
	local beam_width = ability:GetSpecialValueFor("beam_width")
	local beam_range = ability:GetSpecialValueFor("beam_range")
	local beam_speed = ability:GetSpecialValueFor("beam_speed")
	local fx = "particles/custom/okita/okita_seigan_beam.vpcf"
	local forwardvec = caster:GetForwardVector()

	local beam = {
		Ability = ability,
        EffectName = nil, --"particles/custom/false_assassin/fa_quickdraw.vpcf",
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = beam_range,
        fStartRadius = beam_width,
        fEndRadius = beam_width,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = true,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 2.0,
		bDeleteOnHit = false,
		vVelocity = forwardvec * beam_speed
	}

	if attacker ~= caster then 
		local target_loc = attacker:GetAbsOrigin()
		local caster_loc = caster:GetAbsOrigin()
		target_loc.z = caster_loc.z
		forwardvec = (target_loc - caster_loc):Normalized() 
		if forwardvec == Vector(0,0,0) then 
			caster:SetAngles(0, 0, 0)
		end
		beam.vVelocity = forwardvec * beam_speed
		caster:SetForwardVector(forwardvec)

	end

	UnfreezeAnimation(caster)
	EndAnimation(caster)

	Timers:CreateTimer(0.1, function()
		local angle = caster:GetAnglesAsVector().y
		
		local end_point = GetRotationPoint(caster:GetAbsOrigin(),beam_range,angle)

		local projectile = ProjectileManager:CreateLinearProjectile(beam)
		StartAnimation(caster, {duration = beam_range / beam_speed + 0.2, activity=ACT_DOTA_ATTACK_EVENT, rate = 5.0})
		giveUnitDataDrivenModifier(caster, caster, "dragged", beam_range / beam_speed + 0.2)
		
		if caster:HasModifier("modifier_alternate_02") then
			fx = "particles/custom/okita/okita_seigan_beam_black.vpcf"
		end

		
		local seigan_beam = ParticleManager:CreateParticle(fx, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(seigan_beam, 0, caster:GetAbsOrigin() + Vector(0,0,100))
		ParticleManager:SetParticleControl(seigan_beam, 1, end_point + Vector(0,0,100))
		caster:EmitSound("Hero_Invoker.EMP.Discharge")

		Timers:CreateTimer(beam_range / beam_speed + 0.2, function()
			ParticleManager:DestroyParticle( seigan_beam, false )
			ParticleManager:ReleaseParticleIndex( seigan_beam )
		end)
	end)
end

function OnSeiganBeamHit(keys)
	if keys.target == nil then return end
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target
	local min_damage = ability:GetSpecialValueFor("min_damage")
	local max_damage = ability:GetSpecialValueFor("max_damage")
	local shield = ability:GetSpecialValueFor("shield")
	local damage = min_damage + ((max_damage - min_damage) * (1 - caster.SeiganShield/shield))

	DoDamage(caster, target, damage, DAMAGE_TYPE_PURE, 0, ability, false)
end

--[[function OnSeiganChannelStart(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local duration = ability:GetSpecialValueFor("duration")

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_hira_seigan_thinker", {})
	StartAnimation(caster, {duration=duration, activity=ACT_DOTA_CAST_ABILITY_5, rate=2.0})
end

function OnSeiganCreate(keys)
	local caster = keys.caster 
	caster.SeiganCharge = 0
	caster.seiganring = ParticleManager:CreateParticle("particles/custom/okita/hira_seigen_ring2.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(caster.seiganring, 1, caster:GetAbsOrigin() + Vector(0,0, 100))

	caster.seiganshield = ParticleManager:CreateParticle("particles/custom/okita/hira_seigen_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(caster.seiganshield, 0, caster:GetAbsOrigin())
	caster:EmitSound("Hero_KeeperOfTheLight.Illuminate.Charge")
end

function OnSeiganThink(keys)
	local caster = keys.caster 
	caster.SeiganCharge = caster.SeiganCharge + 0.1 
	if caster.SeiganCharge == 0.5 then 
		FreezeAnimation(caster)
	end
end

function OnSeiganDestroy(keys)
	local caster = keys.caster 
	ParticleManager:DestroyParticle(caster.seiganshield, true)
	ParticleManager:ReleaseParticleIndex(caster.seiganshield)

	ParticleManager:DestroyParticle(caster.seiganring, true)
	ParticleManager:ReleaseParticleIndex(caster.seiganring)
	caster:StopSound("Hero_KeeperOfTheLight.Illuminate.Charge")
end

function OnSeiganInterrupt(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local radius = ability:GetSpecialValueFor("radius")
	local base_damage = ability:GetSpecialValueFor("base_damage")
	local charge_damage = ability:GetSpecialValueFor("charge_damage")
	caster:RemoveModifierByName("modifier_hira_seigan_thinker")
	UnfreezeAnimation(caster)
	local exhaust = ability:GetSpecialValueFor("exhaust")
	exhaust = math.floor(exhaust * caster.SeiganCharge / 3)
	AddExhaust(keys, exhaust)


	local damage = base_damage + (charge_damage * caster.SeiganCharge)

	local count = 20 + 40 * caster.SeiganCharge / 3

	--StartAnimation(caster, {duration = 1.0, activity=ACT_DOTA_ATTACK, rate = 5.0})

	for i=1, math.floor(count/2) do
		Timers:CreateTimer(0.003*i, function()
			local angle = RandomInt(0, 360)
			local random1 = RandomInt(200, radius-1)
			local random2 = RandomInt(150, radius-1)
	        local startLoc = GetRotationPoint(caster:GetAbsOrigin(),random1,angle) 
	        local endLoc = GetRotationPoint(caster:GetAbsOrigin(),random2,angle + RandomInt(120, 240))
	        local fxIndex = ParticleManager:CreateParticle( "particles/okita/okita_jce_slash.vpcf", PATTACH_ABSORIGIN, caster)
	        ParticleManager:SetParticleControl( fxIndex, 0, startLoc + Vector(0,0,radius*math.abs(math.sqrt(1 - (random1/radius)^2))))
	        ParticleManager:SetParticleControl( fxIndex, 1, endLoc + Vector(0,0,radius*math.abs(math.sqrt(1 - (random2/radius)^2))))
	        ParticleManager:SetParticleControl( fxIndex, 3, endLoc + Vector(0,0,radius*math.abs(math.sqrt(1 - (random2/radius)^2))))
	        caster:EmitSound("Tsubame_Slash_" .. math.random(1,3))
	    end)
    end

    local unitGroup = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for i = 1, #unitGroup do
		DoDamage(caster, unitGroup[i], damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
	end
end

function OnSeiganSuccess(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local beam_width = ability:GetSpecialValueFor("beam_width")
	local beam_range = ability:GetSpecialValueFor("beam_range")
	local exhaust = ability:GetSpecialValueFor("exhaust")
	local fx = "particles/custom/okita/okita_seigan_beam.vpcf"
	AddExhaust(keys, exhaust)
	UnfreezeAnimation(caster)
	EndAnimation(caster)
	local forwardvec = caster:GetForwardVector()
	local speed = 2500
	caster:RemoveModifierByName("modifier_hira_seigan_thinker")
	StartAnimation(caster, {duration = beam_range / speed + 0.2, activity=ACT_DOTA_ATTACK_EVENT, rate = 5.0})


	local beam = {
		Ability = ability,
        EffectName = nil,--"particles/custom/false_assassin/fa_quickdraw.vpcf",
        iMoveSpeed = speed,
        vSpawnOrigin = caster:GetOrigin(),
        fDistance = beam_range,
        fStartRadius = beam_width,
        fEndRadius = 150,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = true,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 2.0,
		bDeleteOnHit = false,
		vVelocity = forwardvec * speed
	}
	giveUnitDataDrivenModifier(caster, caster, "drag_pause", beam_range / speed + 0.2)
	local projectile = ProjectileManager:CreateLinearProjectile(beam)
	local dummy_loc = caster:GetAbsOrigin()
	local dummy = CreateUnitByName("dummy_unit", dummy_loc, false, caster, caster, caster:GetTeamNumber())
	dummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1)
	dummy:SetForwardVector(forwardvec)

	if caster:HasModifier("modifier_alternate_02") then
		fx = "particles/custom/okita/okita_seigan_beam_black.vpcf"
	end
	
	local seigan_beam = ParticleManager:CreateParticle(fx, PATTACH_WORLDORIGIN, dummy)
	ParticleManager:SetParticleControl(seigan_beam, 0, caster:GetAbsOrigin() + Vector(0,0,100))
	ParticleManager:SetParticleControl(seigan_beam, 1, caster:GetAbsOrigin() + (Vector(forwardvec.x, forwardvec.y,0) * beam_range) + Vector(0,0,100)) 
	ParticleManager:SetParticleControl(seigan_beam, 3, dummy:GetAbsOrigin() + Vector(0,0,100))
	caster:EmitSound("Hero_Invoker.EMP.Discharge")


	Timers:CreateTimer(function()
		if IsValidEntity(dummy) then
			dummy_loc = dummy_loc + (speed * 0.05) * Vector(forwardvec.x, forwardvec.y, 0)
			dummy:SetAbsOrigin(GetGroundPosition(dummy_loc, nil))
			return 0.05
		else
			return nil
		end
	end)	

	Timers:CreateTimer(beam_range / speed + 0.2, function()
		ParticleManager:DestroyParticle( seigan_beam, false )
		ParticleManager:ReleaseParticleIndex( seigan_beam )
		if IsValidEntity(dummy) then
			dummy:RemoveSelf()
		end
	end)
end

function OnSeiganBeamHit(keys)
	if keys.target == nil then return end
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target
	local duration = ability:GetSpecialValueFor("duration")
	local base_damage = ability:GetSpecialValueFor("base_damage")
	local charge_damage = ability:GetSpecialValueFor("charge_damage")
	local damage = base_damage + (charge_damage * duration)

	DoDamage(caster, target, damage, DAMAGE_TYPE_PURE, 0, ability, false)
end

function OnSeiganTakeDamage(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.attacker
	local damage_taken = keys.DamageTaken
	local dmg_threshold = ability:GetSpecialValueFor("dmg_threshold")

	if caster:GetTeam() ~= target:GetTeam() then 
		if damage_taken >= dmg_threshold then
			if caster:IsChanneling() then 
				ability:EndChannel(true)
			end
			caster:RemoveModifierByName("modifier_hira_seigan_thinker")
		end
	end
end]]

function OnSandanzukiUpgrade(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	if caster.IsKikuIchimonjiAcquired then 
		if ability:GetLevel() ~= caster:FindAbilityByName("okita_sandanzuki_charge3_upgrade"):GetLevel() then 
			caster:FindAbilityByName("okita_sandanzuki_charge3_upgrade"):SetLevel(ability:GetLevel())
		end
	else
		if ability:GetLevel() ~= caster:FindAbilityByName("okita_sandanzuki_charge3"):GetLevel() then 
			caster:FindAbilityByName("okita_sandanzuki_charge3"):SetLevel(ability:GetLevel())
		end
	end
end

function OnSandanzukiStart(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local exhaust = ability:GetSpecialValueFor("exhaust")

	OnSeiganStop(keys)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_sandanzuki_window", {})
	EmitSoundOn("Okita.FirstStep", caster)
	if exhaust > 30 then 
		AddExhaust(keys, exhaust - 30)
	end
end

function OnSandanzukiWindowCreate(keys)
	local caster = keys.caster 
	local ability = keys.ability 

	if caster.IsKikuIchimonjiAcquired then
		caster:SwapAbilities("okita_sandanzuki_upgrade", "okita_sandanzuki_charge1", false, true)
	else
		caster:SwapAbilities("okita_sandanzuki", "okita_sandanzuki_charge1", false, true)
	end
end

function OnSandanzukiWIndowDestroy(keys)
	local caster = keys.caster 
	if caster.IsKikuIchimonjiAcquired then 
		caster:SwapAbilities("okita_sandanzuki_upgrade", caster:GetAbilityByIndex(5):GetAbilityName(), true, false)
	else
		caster:SwapAbilities("okita_sandanzuki", caster:GetAbilityByIndex(5):GetAbilityName(), true, false)
	end
end

function OnSandanzukiWIndowDeath(keys)
	local caster = keys.caster 
	caster:RemoveModifierByName("modifier_sandanzuki_window")
end

function OnSandanzukiDash(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target_loc = ability:GetCursorPosition()
	local forwardvec = (target_loc - caster:GetAbsOrigin()):Normalized()
	local dash_speed = ability:GetSpecialValueFor("dash_speed")
	local distance = ability:GetSpecialValueFor("distance")
	local exhaust = ability:GetSpecialValueFor("exhaust")
	local target_point = caster:GetAbsOrigin() + (forwardvec * distance)
	local duration = distance / dash_speed

	if GridNav:IsBlocked(target_loc) or not GridNav:IsTraversable(target_loc) then
		ability:EndCooldown() 
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Cannot_Travel")
		return 
	end 

	OnSeiganStop(keys)

	local frontvec = (target_loc - caster:GetAbsOrigin()):Normalized()

	local dummy = CreateUnitByName("visible_dummy_unit", caster:GetOrigin(), false, caster, caster, caster:GetTeamNumber())
    dummy:FindAbilityByName("dummy_visible_unit_passive"):SetLevel(1)
    dummy:SetDayTimeVisionRange(0)
    dummy:SetNightTimeVisionRange(0)
    dummy:SetOrigin(caster:GetOrigin() - frontvec * 100)
    dummy:SetForwardVector(frontvec)

	local particle1 = ParticleManager:CreateParticle("particles/custom/atalanta/sting/ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
    ParticleManager:SetParticleControlEnt(particle1, 1, dummy, PATTACH_ABSORIGIN_FOLLOW, nil, dummy:GetAbsOrigin(), false)
    ParticleManager:ReleaseParticleIndex(particle1)

	local dash_fx = ParticleManager:CreateParticle("particles/okita/okita_afterimage_windrunner.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(dash_fx, 0, caster:GetAbsOrigin())

	AddExhaust(keys, exhaust)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_sandanzuki_dash", {Duration = duration})
	StartAnimation(caster, {duration=duration, activity=ACT_DOTA_CAST_ABILITY_6, rate=0.5 / duration})

	ProjectileManager:ProjectileDodge(caster)

	if ability:GetAbilityName() == "okita_sandanzuki_charge1" then
		EmitSoundOn("Okita.SecondStep", caster)
		caster:SwapAbilities("okita_sandanzuki_charge1", "okita_sandanzuki_charge2", false, true)
	elseif ability:GetAbilityName() == "okita_sandanzuki_charge2" then
		EmitSoundOn("Okita.ThirdStep", caster)
		if caster.IsKikuIchimonjiAcquired then
			caster:SwapAbilities("okita_sandanzuki_charge2", "okita_sandanzuki_charge3_upgrade", false, true)
		else
			caster:SwapAbilities("okita_sandanzuki_charge2", "okita_sandanzuki_charge3", false, true)
		end
	elseif ability:GetAbilityName() == "okita_sandanzuki_charge3" or ability:GetAbilityName() == "okita_sandanzuki_charge3_upgrade" then
		EmitGlobalSound("Okita.Mumyo")
		local mumyo = 
		{
			Ability = ability,
	        --EffectName = "",
	        iMoveSpeed = dash_speed,
	        vSpawnOrigin = caster:GetAbsOrigin(),
	        fDistance = distance,
	        fStartRadius = 180,
	        fEndRadius = 180,
	        Source = caster,
	        bHasFrontalCone = true,
	        bReplaceExisting = false,
	        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	        iUnitTargetType = DOTA_UNIT_TARGET_HERO,
	        fExpireTime = GameRules:GetGameTime() + 2.0,
			bDeleteOnHit = true,
			vVelocity = forwardvec * dash_speed
		}
		local projectile = ProjectileManager:CreateLinearProjectile(mumyo)
		caster:RemoveModifierByName("modifier_sandanzuki_window")
	end

	local okita = Physics:Unit(caster) 
	if caster:IsAlive() then
		caster:SetPhysicsVelocity(caster:GetForwardVector() * dash_speed)
		caster:PreventDI()
	    caster:SetPhysicsFriction(0)
		caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	    caster:FollowNavMesh(false)	
	    caster:SetAutoUnstuck(false)
	    caster:OnPhysicsFrame(function(unit)
			local diff = target_point - unit:GetAbsOrigin()
			local dir = diff:Normalized()
			unit:SetPhysicsVelocity(dir * dash_speed)
			if diff:Length() <= 150 or not unit:HasModifier("modifier_sandanzuki_dash") then
				unit:RemoveModifierByName("modifier_sandanzuki_dash")
				EndAnimation(unit)
				unit:PreventDI(false)
				unit:SetBounceMultiplier(0)
				unit:SetPhysicsVelocity(Vector(0,0,0))
				unit:OnPhysicsFrame(nil)
				unit:OnHibernate(nil)
				unit:OnPreBounce(nil)
				unit:SetAutoUnstuck(true)
		        FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		        if string.match(ability:GetAbilityName(), "okita_sandanzuki_charge3") then
		        	giveUnitDataDrivenModifier(caster, caster, "jump_pause_postlock", 0.2)
		        end
		    end
		end)
	    Timers:CreateTimer(duration, function()
	    	ParticleManager:DestroyParticle(dash_fx, true)
	    	ParticleManager:ReleaseParticleIndex(dash_fx)
	    	if IsValidEntity(dummy) then
	    		dummy:RemoveSelf()
	    	end
	    end)
	end
end

function OnSandanzukiHit(keys)
	if keys.target == nil then return end
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target
	local damage = ability:GetSpecialValueFor("base_damage")
	local bonus_agi_ratio = ability:GetSpecialValueFor("bonus_agi_ratio")
	local exhaust = ability:GetSpecialValueFor("exhaust")
	local delay_duration = ability:GetSpecialValueFor("delay_duration")

	local newkeys = {
		caster = caster, 
		ability = caster:FindAbilityByName("okita_tennen")
	}
	

	if caster.IsKikuIchimonjiAcquired then 
		damage = damage + bonus_agi_ratio * caster:GetAgility() 
	end

	local slash_loc = target:GetAbsOrigin()

	local slashIndex = ParticleManager:CreateParticle( "particles/custom/false_assassin/tsubame_gaeshi/tsubame_gaeshi_windup_indicator_flare.vpcf", PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl(slashIndex, 0, slash_loc)
    ParticleManager:SetParticleControl(slashIndex, 1, Vector(500,0,150))
    ParticleManager:SetParticleControl(slashIndex, 2, Vector(0.2,0,0))

    Timers:CreateTimer(0.4, function()
        local particle = ParticleManager:CreateParticle("particles/custom/false_assassin/tsubame_gaeshi/slashes.vpcf", PATTACH_ABSORIGIN, caster)
        ParticleManager:SetParticleControl(particle, 0, slash_loc)
    end)
    Timers:CreateTimer(delay_duration, function()
        EmitGlobalSound("Okita.Sandanzuki")
        
        if IsValidEntity(target) and not target:IsNull() then
	        target:EmitSound("Tsubame_Slash_" .. math.random(1,3))
	        DoDamage(caster, target, damage, DAMAGE_TYPE_PURE, 0, ability, false)
	        OnTennenAttack(newkeys)
	    end
    end)
    Timers:CreateTimer(delay_duration + 0.1, function()
        if IsValidEntity(target) and not target:IsNull() then
	        target:EmitSound("Tsubame_Slash_" .. math.random(1,3))
	        DoDamage(caster, target, damage, DAMAGE_TYPE_PURE, 0, ability, false)
	        OnTennenAttack(newkeys)
	    end
    end)
    Timers:CreateTimer(delay_duration + 0.2, function()
        if IsValidEntity(target) and not target:IsNull() then
	        target:EmitSound("Tsubame_Focus")
	        DoDamage(caster, target, damage, DAMAGE_TYPE_PURE, 0, ability, false)
	        OnTennenAttack(newkeys)
	    end
    end)
end

function OnMindEyeStart (keys)
	local caster = keys.caster 
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration") 
	OnSeiganStop(keys)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_okita_mind_eye", {})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_okita_mind_eye_cooldown", {Duration = ability:GetCooldown(1)})
end

function OnMindEyeThink(keys)
	local caster = keys.caster
	local ability = keys.ability
	ProjectileManager:ProjectileDodge(caster)
end

function OnMindEyeTakeDamage(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.attacker
	local distance = ability:GetSpecialValueFor("distance")
	if not target:IsRealHero() then 
		target = target:GetOwnerEntity()
	end
	if caster:GetTeam() ~= target:GetTeam() then
		caster:RemoveModifierByName("modifier_okita_mind_eye")
		caster:SetHealth(caster:GetHealth() + keys.DamageTaken)
		HardCleanse(caster)

		local backvec = -caster:GetForwardVector()
		local dashback = Physics:Unit(caster)
		local origin = caster:GetOrigin()

		caster:PreventDI()
		caster:SetPhysicsFriction(0)

		caster:SetPhysicsVelocity(backvec * distance * 3)
	   	caster:SetNavCollisionType(PHYSICS_NAV_HALT)
	   	StartAnimation(caster, {duration=0.33, activity=ACT_DOTA_CAST_ABILITY_3, rate=2.5})
	   	giveUnitDataDrivenModifier(caster, caster, "jump_pause", 0.33)
		
		caster:OnPhysicsFrame(function(unit) -- pushback distance check
			local unitOrigin = unit:GetAbsOrigin()
			local diff = unitOrigin - origin
			local n_diff = diff:Normalized()
			unit:SetPhysicsVelocity(unit:GetPhysicsVelocity():Length() * n_diff) -- track the movement of target being pushed back
			if diff:Length() > distance or not caster:HasModifier("jump_pause") then -- if pushback distance is over 150, stop it
				unit:PreventDI(false)
				unit:SetPhysicsVelocity(Vector(0,0,0))
				unit:OnPhysicsFrame(nil)
				EndAnimation(unit)
				FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
			end
		end)
	end
end

function OkitaCheckCombo(caster, ability)
	if math.ceil(caster:GetStrength()) >= 25 and math.ceil(caster:GetAgility()) >= 25 and math.ceil(caster:GetIntellect()) >= 25 then
		if string.match(ability:GetAbilityName(), "okita_tennen") and not caster:HasModifier("modifier_zekken_cooldown") then
			if caster.IsKikuIchimonjiAcquired then
				if caster:FindAbilityByName("okita_sandanzuki_upgrade"):IsCooldownReady() and caster:FindAbilityByName("okita_zekken_upgrade"):IsCooldownReady() then 
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_zekken_window", {})	
				end
			else
				if caster:FindAbilityByName("okita_sandanzuki"):IsCooldownReady() and caster:FindAbilityByName("okita_zekken"):IsCooldownReady() then 
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_zekken_window", {})	
				end
			end
		end
	end
end

function OnZekkenWindow(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.IsKikuIchimonjiAcquired then
		caster:SwapAbilities("okita_sandanzuki_upgrade", "okita_zekken_upgrade", false, true) 
	else
		caster:SwapAbilities("okita_sandanzuki", "okita_zekken", false, true) 
	end
end

function OnZekkenWindowDestroy(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.IsKikuIchimonjiAcquired then
		caster:SwapAbilities("okita_sandanzuki_upgrade", "okita_zekken_upgrade", true, false) 
	else
		caster:SwapAbilities("okita_sandanzuki", "okita_zekken", true, false) 
	end
end

function OnZekkenWindowDied(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_zekken_window")
end

function OnZekkenStart (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target_loc = ability:GetCursorPosition()
	local forwardvec = (target_loc - caster:GetAbsOrigin()):Normalized()
	local dash_speed = ability:GetSpecialValueFor("dash_speed")
	local distance = ability:GetSpecialValueFor("distance")
	local exhaust = ability:GetSpecialValueFor("exhaust")
	local interval = ability:GetSpecialValueFor("interval")
	local atk_count = ability:GetSpecialValueFor("atk_count")
	local target_point = caster:GetAbsOrigin() + (forwardvec * distance)
	local duration = distance / dash_speed

	caster.ZekkenTarget = nil
	caster.ZekkenSlashBack = nil
	caster.ZekkenSound = nil
	caster.ZekkenOrigin = caster:GetAbsOrigin()
	caster.last_hit_start = nil
	caster.last_hit_distance = 0

	--[[local origindummy = CreateUnitByName("visible_dummy_unit", caster.ZekkenOrigin, false, caster, caster, caster:GetTeamNumber())
    origindummy:FindAbilityByName("dummy_visible_unit_passive"):SetLevel(1)
    origindummy:SetDayTimeVisionRange(0)
    origindummy:SetNightTimeVisionRange(0)]]
    if caster:HasModifier("modifier_alternate_02") then 
		EmitGlobalSound("OkitaAlter.Precombo")
	else
		EmitGlobalSound("Okita.Precombo")
	end
	-- Set master's combo cooldown
	local masterCombo = caster.MasterUnit2:FindAbilityByName("okita_zekken")
	masterCombo:EndCooldown()
	masterCombo:StartCooldown(keys.ability:GetCooldown(1))
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_zekken_cooldown", {Duration = ability:GetCooldown(1)})

	local mumyo = caster:FindAbilityByName("okita_sandanzuki")
	if mumyo == nil then 
		mumyo = caster:FindAbilityByName("okita_sandanzuki_upgrade")
	end
	mumyo:StartCooldown(mumyo:GetCooldown(mumyo:GetLevel()))

	caster:RemoveModifierByName("modifier_zekken_window")

	local frontvec = (target_loc - caster:GetAbsOrigin()):Normalized()

	local dummy = CreateUnitByName("visible_dummy_unit", caster:GetOrigin(), false, caster, caster, caster:GetTeamNumber())
    dummy:FindAbilityByName("dummy_visible_unit_passive"):SetLevel(1)
    dummy:SetDayTimeVisionRange(0)
    dummy:SetNightTimeVisionRange(0)
    dummy:SetOrigin(caster:GetOrigin() - frontvec * 100)
    dummy:SetForwardVector(frontvec)

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_zekken_checker", {Duration = distance / dash_speed})
    StartAnimation(caster, {duration=distance / dash_speed, activity=ACT_DOTA_CAST_ABILITY_6, rate=1.5})

	local particle1 = ParticleManager:CreateParticle("particles/custom/atalanta/sting/ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
    ParticleManager:SetParticleControlEnt(particle1, 1, dummy, PATTACH_ABSORIGIN_FOLLOW, nil, dummy:GetAbsOrigin(), false)
    ParticleManager:ReleaseParticleIndex(particle1)

    Timers:CreateTimer(1.0, function()
    	if IsValidEntity(dummy) then
    		dummy:RemoveSelf()
    	end
    end)

	local dash_fx = ParticleManager:CreateParticle("particles/custom/gilgamesh/enuma_elish/cracks_smoke.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(dash_fx, 0, caster:GetAbsOrigin())

	giveUnitDataDrivenModifier(caster, caster, "jump_pause", 4.0)

	local okita = Physics:Unit(caster) 
	if caster:IsAlive() then
		caster:SetPhysicsVelocity(caster:GetForwardVector() * dash_speed)
		caster:PreventDI()
	    caster:SetPhysicsFriction(0)
		caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	    caster:FollowNavMesh(false)	
	    caster:SetAutoUnstuck(false)
	    caster:OnPhysicsFrame(function(unit)
			local diff = target_point - unit:GetAbsOrigin()
			local dir = diff:Normalized()
			unit:SetPhysicsVelocity(dir * dash_speed)
			if diff:Length() <= 150 or unit:HasModifier("modifier_zekken") or not unit:HasModifier("modifier_zekken_checker") then
				EndAnimation(unit)
				unit:PreventDI(false)
				unit:SetPhysicsVelocity(Vector(0,0,0))
				unit:OnPhysicsFrame(nil)
				unit:OnHibernate(nil)
				unit:SetAutoUnstuck(true)
		        FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		        ParticleManager:DestroyParticle(dash_fx, true)
	    		ParticleManager:ReleaseParticleIndex(dash_fx)
	    		if unit:IsAlive() and unit.ZekkenTarget ~= nil then 
	    			giveUnitDataDrivenModifier(unit, unit.ZekkenTarget, "pause_sealenabled", interval * atk_count + 1.5)
	    			local center = unit.ZekkenTarget:GetAbsOrigin()
		    		unit:AddEffects(EF_NODRAW)
					local radius = ability:GetSpecialValueFor("radius")
					for i = 1, atk_count do 
						Timers:CreateTimer(i * interval, function()	
							AddExhaust(keys, 2)
							local angle = RandomInt(0, 360)
				            local startLoc = GetRotationPoint(center,RandomInt(radius - 200, radius),angle)
				            local endLoc = GetRotationPoint(center,RandomInt(radius - 200, radius),angle + RandomInt(120, 240))
				            local fxIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt_serrakura.vpcf", PATTACH_ABSORIGIN, caster)
				            ParticleManager:SetParticleControl( fxIndex, 0, startLoc + Vector(0,0,RandomInt(100,200)))
				            ParticleManager:SetParticleControl( fxIndex, 1, endLoc + Vector(0,0,RandomInt(100,200)))
				            caster:EmitSound("Tsubame_Slash_" .. math.random(1,3))
							local unitGroup = FindUnitsInRadius(unit:GetTeam(), center, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
				            if i == 15 then 
								unit:RemoveEffects(EF_NODRAW)
								unit.last_hit_start = center + (forwardvec * radius)
								unit:SetAbsOrigin(unit.last_hit_start)
								unit:SetForwardVector(-forwardvec)
								unit:SetAngles(0, 0, 0)
							end
				            for j = 1, #unitGroup do
				            	if #unitGroup ~= 0 then
					                
					                if IsValidEntity(unitGroup[j]) and not unitGroup[j]:IsNull() and not unitGroup[j]:HasModifier("modifier_stunned") and not IsImmuneToCC(unitGroup[j]) then 
					                	ApplyAirborne(unit, unitGroup[j], (atk_count - i) * interval)
					                end
					                unit:PerformAttack( unitGroup[j], true, true, true, true, false, false, true )
					            end
							end
							
						end)
					end

					Timers:CreateTimer(atk_count * interval + 0.5, function()	
						if unit:IsAlive() then
							unit:EmitSound("Tsubame_Focus")							
							local dash_speed = ability:GetSpecialValueFor("dash_speed")
							unit.last_hit_distance = (unit.ZekkenOrigin - unit.last_hit_start):Length2D()
							StartAnimation(unit, {duration=unit.last_hit_distance / dash_speed, activity=ACT_DOTA_CAST_ABILITY_6, rate=1.5})
							ability:ApplyDataDrivenModifier(unit, unit, "modifier_zekken_checker", {Duration = unit.last_hit_distance / dash_speed + 0.1})
							local dash_back_speed = 200
							AddExhaust(keys, 10)
							unit:SetPhysicsVelocity(-forwardvec * dash_speed)
							unit:PreventDI()
						    unit:SetPhysicsFriction(0)
							unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)
						    unit:FollowNavMesh(false)	
						    unit:SetAutoUnstuck(false)
						    unit:OnPhysicsFrame(function(unit)
						    	if not unit.ZekkenSlashBack then 
						    		CreateSlashFx(unit, unit:GetAbsOrigin() + Vector(0,0,200), unit.ZekkenOrigin + Vector(0,0,200))
						    		unit.ZekkenSlashBack = true 
						    	end
						    	local last_hit_radius = ability:GetSpecialValueFor("last_hit_radius")
								local last_hit_damage = ability:GetSpecialValueFor("last_hit_damage")
								local LastThrustTargets = FindUnitsInRadius(unit:GetTeam(), unit:GetAbsOrigin(), nil, last_hit_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
								for k,v in pairs (LastThrustTargets) do 
									if IsValidEntity(v) and not v:IsNull() and not v:HasModifier("modifier_zekken_checker") then 
										ability:ApplyDataDrivenModifier(unit, v, "modifier_zekken_checker", {})
										v:AddNewModifier(unit, nil, "modifier_stunned", {Duration = 1.0})
										DoDamage(unit, v, last_hit_damage, DAMAGE_TYPE_PURE, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, ability, false)
									end
								end
						    	unit:SetPhysicsVelocity(-forwardvec * dash_back_speed)
						    	if (unit:GetAbsOrigin() - unit.last_hit_start):Length() < 200 then 
						    		dash_back_speed = dash_back_speed + 1000 
							    	if dash_back_speed > dash_speed then 
							    		dash_back_speed = dash_speed
							    		
						    		end
						    	elseif (unit:GetAbsOrigin() - unit.last_hit_start):Length() >= unit.last_hit_distance - 200 and (unit:GetAbsOrigin() - unit.last_hit_start):Length() < unit.last_hit_distance - 50 then 
						    		
						    		dash_back_speed = dash_back_speed - 400
						    		if dash_back_speed < 200 then 
						    			dash_back_speed = 200 
						    		end
						    		local new_forward = (unit.ZekkenTarget:GetAbsOrigin() - unit:GetAbsOrigin()):Normalized()
						    		unit:SetForwardVector(new_forward)
						    		unit:SetAngles(0, 0, 0)
						    	elseif (unit:GetAbsOrigin() - unit.last_hit_start):Length() >= unit.last_hit_distance or not unit:HasModifier("modifier_zekken_checker") then 
						    		if not unit.ZekkenSound then 
						    			if unit:HasModifier("modifier_alternate_02") then 
						    				EmitGlobalSound("Okita.Zekken" .. RandomInt(1, 3))
						    			else
							    			EmitGlobalSound("Okita.Zekken1") 
							    		end
							    		unit.ZekkenSound = true 
							    	end
						    		unit:PreventDI(false)
									unit:SetPhysicsVelocity(Vector(0,0,0))
									unit:OnPhysicsFrame(nil)
									unit:OnHibernate(nil)
									unit:SetAutoUnstuck(true)
							        FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
							        Timers:CreateTimer(1.0, function()
								        if unit.ZekkenTarget:IsAlive() and unit:IsAlive() and IsInSameRealm(unit:GetAbsOrigin(), unit.ZekkenTarget:GetAbsOrigin()) then  
								        	local newest_forward = (unit.ZekkenTarget:GetAbsOrigin() - unit:GetAbsOrigin()):Normalized()
								        	local beam_distance = ability:GetSpecialValueFor("beam_distance")
											local beam_radius = ability:GetSpecialValueFor("beam_radius")
											AddExhaust(keys, exhaust - (atk_count * 2) - 10)
								        	local zekken_beam = 
											{
												Ability = ability,
											    --EffectName = "",
											    iMoveSpeed = 5000,
											    vSpawnOrigin = unit:GetAbsOrigin(),
											    fDistance = beam_distance,
											    fStartRadius = beam_radius,
											    fEndRadius = beam_radius,
											    Source = unit,
											    bHasFrontalCone = true,
											    bReplaceExisting = false,
											    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
											    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
											    iUnitTargetType = DOTA_UNIT_TARGET_ALL,
											    fExpireTime = GameRules:GetGameTime() + 2.0,
												bDeleteOnHit = false,
												vVelocity = newest_forward * 5000
											}
											local projectile = ProjectileManager:CreateLinearProjectile(zekken_beam)
											local beam_fx = ParticleManager:CreateParticle("particles/okita/okita_zekken_beam.vpcf", PATTACH_ABSORIGIN, unit)
							    			ParticleManager:SetParticleControl(beam_fx, 0, unit:GetAbsOrigin() + Vector(0,0,100))
							    			ParticleManager:SetParticleControl(beam_fx, 1, unit:GetAbsOrigin() + Vector(0,0,100))
							    			ParticleManager:SetParticleControl(beam_fx, 3, unit:GetAbsOrigin() + newest_forward*beam_distance + Vector(0,0,100))
											--Timers:CreateTimer(0.2, function()
												EmitGlobalSound("karna_vasavi_explosion")
											--end)
											StartAnimation(unit, {duration=(beam_distance / 5000) + 0.2, activity=ACT_DOTA_ATTACK_EVENT, rate=2.0})
											Timers:CreateTimer(beam_distance / 5000 + 0.2, function()
												unit:RemoveModifierByName("jump_pause")
												ParticleManager:DestroyParticle(beam_fx, true)
											end)
										else
											unit:RemoveModifierByName("jump_pause")
											return
										end	
									end)								
								end
							end)
						end
					end)
				else
					unit:RemoveModifierByName("jump_pause")
					return
				end

	    	elseif unit:IsAlive() then 
	    		local FindTarget = FindUnitsInRadius(unit:GetTeam(), unit:GetAbsOrigin(), nil, 180, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		    	if FindTarget[1] ~= nil then 
		    		unit.ZekkenTarget = FindTarget[1]
		    		ability:ApplyDataDrivenModifier(unit, unit, "modifier_zekken", {Duration = interval * atk_count + 0.5})
		    	end
		    else
		    	unit:RemoveModifierByName("jump_pause")
		    	return
		    end
		end)
	else
		caster:RemoveModifierByName("jump_pause")
		return
	end
end

function OnZekkenBeamHit(keys)
	if keys.target == nil then return end
	local caster = keys.caster
	local ability = keys.ability
	if ability == nil then 
		ability = caster:FindAbilityByName("okita_zekken_upgrade")
	end
	local target = keys.target

	if not IsValidEntity(target) or target:IsNull() or not target:IsAlive() then return end

	local beam_damage = ability:GetSpecialValueFor("beam_damage")
	if caster.IsKikuIchimonjiAcquired then
		local beam_kiku_agi_ratio = ability:GetSpecialValueFor("beam_kiku_agi_ratio")
		beam_damage = beam_damage + beam_kiku_agi_ratio * caster:GetAgility() 
	end

	DoDamage(caster, target, beam_damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
end

function OnCoatOfOathsAcquired(keys)
	local caster = keys.caster
	local ability = keys.ability
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsCoadOfOathsAcquired) then

		hero.IsCoadOfOathsAcquired = true
		
		hero:FindAbilityByName("okita_coat_of_oaths"):SetLevel(1)

		UpgradeAttribute(hero, 'okita_flag_of_sincerity', 'okita_flag_of_sincerity_upgrade', true)

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnMindEyeAcquired(keys)
	local caster = keys.caster
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsMindEyeAcquired) then

		hero.IsMindEyeAcquired = true

		if hero.IsPersistenceAcquired then
			hero:SwapAbilities("okita_weak_constitution_upgrade", "okita_mind_eye", false, true)
		else
			hero:SwapAbilities("okita_weak_constitution", "okita_mind_eye", false, true)
		end

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnKikuIchimonjiAcquired(keys)
	local caster = keys.caster
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsKikuIchimonjiAcquired) then

		if hero:HasModifier("modifier_zekken_window") then 
			hero:RemoveModifierByName("modifier_zekken_window")
		end

		if hero:HasModifier("modifier_sandanzuki_window") then 
			hero:RemoveModifierByName("modifier_sandanzuki_window")
		end

		hero.IsKikuIchimonjiAcquired = true

		hero:AddAbility("okita_sandanzuki_charge3_upgrade")
		hero:AddAbility("okita_sandanzuki_upgrade")
		hero:FindAbilityByName("okita_sandanzuki_charge3_upgrade"):SetLevel(hero:FindAbilityByName("okita_sandanzuki"):GetLevel())
		hero:FindAbilityByName("okita_sandanzuki_upgrade"):SetLevel(hero:FindAbilityByName("okita_sandanzuki"):GetLevel())
		hero:SwapAbilities("okita_sandanzuki_upgrade", "okita_sandanzuki", true, false) 
		if not hero:FindAbilityByName("okita_sandanzuki"):IsCooldownReady() then 
			hero:FindAbilityByName("okita_sandanzuki_upgrade"):StartCooldown(hero:FindAbilityByName("okita_sandanzuki"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("okita_sandanzuki")
		hero:RemoveAbility("okita_sandanzuki_charge3")

		hero:AddAbility("okita_zekken_upgrade")
		hero:FindAbilityByName("okita_zekken_upgrade"):SetLevel(1)
		if not hero:FindAbilityByName("okita_zekken"):IsCooldownReady() then 
			hero:FindAbilityByName("okita_zekken_upgrade"):StartCooldown(hero:FindAbilityByName("okita_zekken"):GetCooldownTimeRemaining())
		end
		hero:RemoveAbility("okita_zekken")

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnPersistenceAcquired(keys)
	local caster = keys.caster
	local ability = keys.ability
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsPersistenceAcquired) then

		hero.IsPersistenceAcquired = true
		
		if hero.IsMindEyeAcquired then 
			UpgradeAttribute(hero, 'okita_weak_constitution', 'okita_weak_constitution_upgrade', false)
		else
			UpgradeAttribute(hero, 'okita_weak_constitution', 'okita_weak_constitution_upgrade', true)
		end

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnKyokujiAcquired(keys)
	local caster = keys.caster
	local ability = keys.ability
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsKyokujiAcquired) then

		hero.IsKyokujiAcquired = true

		UpgradeAttribute(hero, 'okita_shukuchi', 'okita_shukuchi_upgrade', true)

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end	

function OnPeerlessAcquired(keys)
	local caster = keys.caster
	local ability = keys.ability
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.PeerlessAcquired) then

		hero.PeerlessAcquired = true

		UpgradeAttribute(hero, 'okita_tennen', 'okita_tennen_upgrade', true)
		UpgradeAttribute(hero, 'okita_hira_seigan', 'okita_hira_seigan_upgrade', true)

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end										


	



	



