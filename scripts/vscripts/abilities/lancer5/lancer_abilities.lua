
function CuTakeDamage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local currentHealth = caster:GetHealth()

	local max_damage = ability:GetSpecialValueFor("max_damage")
	local revive_health = ability:GetSpecialValueFor("revive_health")
	local active_dur = ability:GetSpecialValueFor("active_dur")

	if currentHealth <= 0 and keys.ability:IsCooldownReady() and keys.DamageTaken <= max_damage and not caster:HasModifier("modifier_battle_continuation_cooldown")  and IsRevivePossible(caster) then
		caster:SetHealth(revive_health)

		if not caster:HasModifier("modifier_cu_battle_continuation_active") then
			HardCleanse(caster)
			caster:EmitSound("Cu_Battlecont")
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_cu_battle_continuation_active", {})
			local reviveFx = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(reviveFx, 3, caster:GetAbsOrigin())

			Timers:CreateTimer( active_dur, function()
				ParticleManager:DestroyParticle( reviveFx, false )
			end)
		end		
	end
end

function OnBattleContThink(keys)
	local caster = keys.caster
	local ability = keys.ability
	local revive_health = ability:GetSpecialValueFor("revive_health")
	caster:SetHealth(revive_health)
end

function OnBattleContEnd (keys)
	local caster = keys.caster 
	local ability = keys.ability 
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_cu_battle_continuation_cooldown", {duration = ability:GetCooldown(1)})
	ability:StartCooldown(ability:GetCooldown(1))
end

function OnPFAStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lancer_protection_from_arrows_active", {})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lancer_protection_from_arrows_cooldown", {Duration = ability:GetCooldown(1)})

	local soundQueue = math.random(1,4)
	caster:EmitSound("Cu_Skill_" .. soundQueue)

	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.45})
end

function OnPFAThink(keys)
	local caster = keys.caster
	local ability = keys.ability
	ProjectileManager:ProjectileDodge(caster)
end

function OnRuneMagicStart (keys)
	local caster = keys.caster 
	local ability = keys.ability 
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lancer_rune_magic_check", {})
	caster.IsRuneUse = false
	ability:EndCooldown()
end

function OnRuneMagicUpgrade (keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.IsCelticRuneAcquired then
		caster:FindAbilityByName("lancer_rune_of_disengage_upgrade"):SetLevel(ability:GetLevel())
		caster:FindAbilityByName("lancer_rune_of_combat_upgrade"):SetLevel(ability:GetLevel())
		caster:FindAbilityByName("lancer_rune_of_ferocity"):SetLevel(ability:GetLevel())
		caster:FindAbilityByName("lancer_rune_of_protection_upgrade"):SetLevel(ability:GetLevel())
		caster:FindAbilityByName("lancer_rune_of_flame_upgrade"):SetLevel(ability:GetLevel())
	else
		caster:FindAbilityByName("lancer_rune_of_disengage"):SetLevel(ability:GetLevel())
		caster:FindAbilityByName("lancer_rune_of_combat"):SetLevel(ability:GetLevel())
		caster:FindAbilityByName("lancer_rune_of_ferocity"):SetLevel(ability:GetLevel())
		caster:FindAbilityByName("lancer_rune_of_protection"):SetLevel(ability:GetLevel())
		caster:FindAbilityByName("lancer_rune_of_flame"):SetLevel(ability:GetLevel())
	end
end

function OnRuneMagicOpen (keys)
	local caster = keys.caster
	local ability = keys.ability 
	-- window
	if caster:HasModifier("modifier_wesen_gae_bolg_window") then 
		caster:RemoveModifierByName("modifier_wesen_gae_bolg_window")
	end
	if caster.IsCelticRuneAcquired then
		caster:SwapAbilities("lancer_rune_magic_upgrade", "lancer_rune_of_disengage_upgrade", false, true)
		caster:SwapAbilities("lancer_relentless_spear", "lancer_rune_of_combat_upgrade", false, true)
		if caster.IsHeartSeekerAcquired then
			caster:SwapAbilities("lancer_gae_bolg_upgrade", "lancer_rune_of_ferocity", false, true)
		else
			caster:SwapAbilities("lancer_gae_bolg", "lancer_rune_of_ferocity", false, true)
		end
		if caster.IsPFAAcquired then
			caster:SwapAbilities("lancer_protection_from_arrows", "lancer_rune_of_protection_upgrade", false, true)
		else
			caster:SwapAbilities("fate_empty1", "lancer_rune_of_protection_upgrade", false, true)
		end
		if caster.IsBCImproved then
			caster:SwapAbilities("lancer_battle_continuation_upgrade", "lancer_rune_magic_close", false, true)
		else
			caster:SwapAbilities("lancer_battle_continuation", "lancer_rune_magic_close", false, true)
		end
		if caster.IsDeathFlightAcquired then
			caster:SwapAbilities("lancer_gae_bolg_jump_upgrade", "lancer_rune_of_flame_upgrade", false, true)
		else
			caster:SwapAbilities("lancer_gae_bolg_jump", "lancer_rune_of_flame_upgrade", false, true)
		end
	else
		caster:SwapAbilities("lancer_rune_magic", "lancer_rune_of_disengage", false, true)
		caster:SwapAbilities("lancer_relentless_spear", "lancer_rune_of_combat", false, true)
		if caster.IsHeartSeekerAcquired then
			caster:SwapAbilities("lancer_gae_bolg_upgrade", "lancer_rune_of_ferocity", false, true)
		else
			caster:SwapAbilities("lancer_gae_bolg", "lancer_rune_of_ferocity", false, true)
		end
		if caster.IsPFAAcquired then
			caster:SwapAbilities("lancer_protection_from_arrows", "lancer_rune_of_protection", false, true)
		else
			caster:SwapAbilities("fate_empty1", "lancer_rune_of_protection", false, true)
		end
		if caster.IsBCImproved then
			caster:SwapAbilities("lancer_battle_continuation_upgrade", "lancer_rune_magic_close", false, true)
		else
			caster:SwapAbilities("lancer_battle_continuation", "lancer_rune_magic_close", false, true)
		end
		if caster.IsDeathFlightAcquired then
			caster:SwapAbilities("lancer_gae_bolg_jump_upgrade", "lancer_rune_of_flame", false, true)
		else
			caster:SwapAbilities("lancer_gae_bolg_jump", "lancer_rune_of_flame", false, true)
		end
	end
end

function OnRuneMagicClose (keys)
	local caster = keys.caster
	local ability = keys.ability 

	if caster.IsCelticRuneAcquired then
		caster:SwapAbilities("lancer_rune_magic_upgrade", "lancer_rune_of_disengage_upgrade", true, false)
		caster:SwapAbilities("lancer_relentless_spear", "lancer_rune_of_combat_upgrade", true, false)
		if caster.IsHeartSeekerAcquired then
			caster:SwapAbilities("lancer_gae_bolg_upgrade", "lancer_rune_of_ferocity", true, false)
		else
			caster:SwapAbilities("lancer_gae_bolg", "lancer_rune_of_ferocity", true, false)
		end
		if caster.IsPFAAcquired then
			caster:SwapAbilities("lancer_protection_from_arrows", "lancer_rune_of_protection_upgrade", true, false)
		else
			caster:SwapAbilities("fate_empty1", "lancer_rune_of_protection_upgrade", true, false)
		end
		if caster.IsBCImproved then
			caster:SwapAbilities("lancer_battle_continuation_upgrade", "lancer_rune_magic_close", true, false)
		else
			caster:SwapAbilities("lancer_battle_continuation", "lancer_rune_magic_close", true, false)
		end
		if caster.IsDeathFlightAcquired then
			caster:SwapAbilities("lancer_gae_bolg_jump_upgrade", "lancer_rune_of_flame_upgrade", true, false)
		else
			caster:SwapAbilities("lancer_gae_bolg_jump", "lancer_rune_of_flame_upgrade", true, false)
		end
	else
		caster:SwapAbilities("lancer_rune_magic", "lancer_rune_of_disengage", true, false)
		caster:SwapAbilities("lancer_relentless_spear", "lancer_rune_of_combat", true, false)
		if caster.IsHeartSeekerAcquired then
			caster:SwapAbilities("lancer_gae_bolg_upgrade", "lancer_rune_of_ferocity", true, false)
		else
			caster:SwapAbilities("lancer_gae_bolg", "lancer_rune_of_ferocity", true, false)
		end
		if caster.IsPFAAcquired then
			caster:SwapAbilities("lancer_protection_from_arrows", "lancer_rune_of_protection", true, false)
		else
			caster:SwapAbilities("fate_empty1", "lancer_rune_of_protection", true, false)
		end
		if caster.IsBCImproved then
			caster:SwapAbilities("lancer_battle_continuation_upgrade", "lancer_rune_magic_close", true, false)
		else
			caster:SwapAbilities("lancer_battle_continuation", "lancer_rune_magic_close", true, false)
		end
		if caster.IsDeathFlightAcquired then
			caster:SwapAbilities("lancer_gae_bolg_jump_upgrade", "lancer_rune_of_flame", true, false)
		else
			caster:SwapAbilities("lancer_gae_bolg_jump", "lancer_rune_of_flame", true, false)
		end
	end
	if caster.IsRuneUse == true and not caster.IsCelticRuneAcquired then 
		caster:FindAbilityByName("lancer_rune_magic"):StartCooldown(caster:FindAbilityByName("lancer_rune_magic"):GetCooldown(caster:FindAbilityByName("lancer_rune_magic"):GetLevel()))
	end
end

function OnRuneMagicCloseStart (keys)
	local caster = keys.caster 
	caster:RemoveModifierByName("modifier_lancer_rune_magic_check")
end

function Disengage(keys)
	local caster = keys.caster
	local backward = caster:GetForwardVector() * keys.Distance
	local newLoc = caster:GetAbsOrigin() - backward
	local diff = newLoc - caster:GetAbsOrigin()
	caster.IsRuneUse = true
	HardCleanse(caster)
	local i = 1
	while GridNav:IsBlocked(newLoc) or not GridNav:IsTraversable(newLoc) or i == 100 do
		i = i+1
		newLoc = caster:GetAbsOrigin() + diff:Normalized() * (keys.Distance - i*10)
	end
	Timers:CreateTimer(0.033, function() 
		caster:SetAbsOrigin(newLoc)
		ProjectileManager:ProjectileDodge(caster) 
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
	end)
	if not caster.IsCelticRuneAcquired then 
		caster:RemoveModifierByName("modifier_lancer_rune_magic_check")
	end
end

function OnTrapStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local targetPoint = ability:GetCursorPosition()
	caster.IsRuneUse = true
	local lancertrap = CreateUnitByName("lancer_trap", targetPoint, true, caster, caster, caster:GetTeamNumber())
	Timers:CreateTimer(1.0, function()
		if IsValidEntity(lancertrap) and not lancertrap:IsNull() and lancertrap:IsAlive() then
			LevelAllAbility(lancertrap)
			ability:ApplyDataDrivenModifier(caster, lancertrap, "modifier_lancer_rune_of_flame", {})
		end
		return
	end)

	if not caster.IsCelticRuneAcquired then 
		caster:RemoveModifierByName("modifier_lancer_rune_magic_check")
	end
end

function OnTrapThink(keys)
	local caster = keys.caster
	local ability = keys.ability
	if ability == nil then 
		ability = caster:FindAbilityByName("lancer_rune_of_flame_upgrade")
	end
	local trap = keys.target
	local trap_mark = trap:GetAbsOrigin()
	local stun = ability:GetSpecialValueFor("stun_duration")
	local damage = ability:GetSpecialValueFor("damage")
	local radius = ability:GetSpecialValueFor("radius")
	local targets = FindUnitsInRadius(caster:GetTeam(), trap:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	if #targets > 0 then
		for i = 1, #targets do
			if IsValidEntity(targets[i]) and not targets[i]:IsNull() and not IsImmuneToCC(targets[i]) then
				targets[i]:AddNewModifier(caster, ability, "modifier_stunned", { Duration = stun })
			end
			DoDamage(caster, targets[i], damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
			
		end

		--local fxDummy = CreateUnitByName("dummy_unit", trap:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
		--fxDummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1)	

		local trapFX = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(trapFX, 0, trap_mark)

		trap:EmitSound("Hero_TemplarAssassin.Trap.Explode")
		trap:RemoveModifierByName("modifier_lancer_rune_of_flame")

		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(trapFX, false )
			ParticleManager:ReleaseParticleIndex(trapFX)
			--if IsValidEntity(fxDummy) then
			--	fxDummy:RemoveSelf()
			--end
		end)
	end
end

function OnTrapDestroy(keys)
	local trap = keys.target 
	trap:ForceKill(true)
end

function OnCombatStart (keys)
	local caster = keys.caster 
	local ability = keys.ability 
	caster.IsRuneUse = true
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lancer_rune_of_combat", {})
	if not caster.IsCelticRuneAcquired then 
		caster:RemoveModifierByName("modifier_lancer_rune_magic_check")
	end
end

function OnCombatAttack(keys)
	local caster = keys.caster 
	local ability = keys.ability 

	if not IsValidEntity(caster) or caster:IsNull() then return end

	local stacks = caster:GetModifierStackCount("modifier_lancer_rune_of_combat", caster) or 0
	caster:SetModifierStackCount("modifier_lancer_rune_of_combat", caster, stacks + 1)
end

function OnFerocityAttack(keys)
	local caster = keys.caster 

	if not IsValidEntity(caster) or caster:IsNull() then return end

	local ability = keys.ability 
	local attack_speed_loss = ability:GetSpecialValueFor("attack_speed_loss")
	local stacks = caster:GetModifierStackCount("modifier_lancer_rune_of_ferocity", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lancer_rune_of_ferocity_progress", {})
	if stacks < attack_speed_loss then
		caster:SetModifierStackCount("modifier_lancer_rune_of_ferocity", caster, 0)
	else 
		caster:SetModifierStackCount("modifier_lancer_rune_of_ferocity", caster, stacks - attack_speed_loss)
	end
end

function OnFerocityStop(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local max_aspd = ability:GetSpecialValueFor("max_aspd")
	caster:SetModifierStackCount("modifier_lancer_rune_of_ferocity", caster, max_aspd)
end

function OnRuneProtectionStart(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	caster.IsRuneUse = true
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lancer_rune_of_protection", {})
	if not caster.IsCelticRuneAcquired then 
		caster:RemoveModifierByName("modifier_lancer_rune_magic_check")
	end
end 

function OnRelentlessSpearCast(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target 
	if target:GetName() == "npc_dota_ward_base" then 
		caster:Stop()
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Invalid_Target")
	elseif caster:HasModifier("modifier_self_disarm") then 
		caster:Stop()
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Disarmed")
		return
	end
end

function OnRelentlessSpearStart(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = keys.target
	local duration = ability:GetSpecialValueFor("duration")
	ability.target = target
	caster:EmitSound("cu_skill_" .. math.random(1,4))
	CuCheckCombo(caster,ability)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_relentless_spear", {})
	--[[StartAnimation(caster, {duration=duration * 2 / 7, activity=ACT_DOTA_CAST_ABILITY_3_END , rate=1.0})
	Timers:CreateTimer(duration * 2 / 7, function()
		if caster:IsAlive() and caster:HasModifier("modifier_relentless_spear") then
			StartAnimation(caster, {duration=duration * 3 / 7, activity=ACT_DOTA_CAST_ABILITY_3_END , rate=1.0})
			Timers:CreateTimer(duration * 3 / 7, function()
				if caster:IsAlive() and caster:HasModifier("modifier_relentless_spear") then
					StartAnimation(caster, {duration=duration * 2 / 7, activity=ACT_DOTA_CAST_ABILITY_3_END , rate=1.0})
				end
			end)
		end
	end)]]
end

function OnRelentlessSpearInterrupt(keys)
	local caster = keys.caster 
	caster:RemoveModifierByName("modifier_relentless_spear")
end

function OnRelentlessSpearAttack(keys)
	local caster = keys.caster 
	local ability = keys.ability 
	local target = ability.target

	if not IsValidEntity(target) or target:IsNull() or not target:IsAlive() then return end

	if target:GetTeam() == caster:GetTeam() then return end

	local duration = ability:GetSpecialValueFor("interval")
	local attack_damage = caster:GetAverageTrueAttackDamage(caster)
	if caster:IsAlive() then 
		
		--caster:PerformAttack(target, true, true, true, true, false, true, true)
		target:AddNewModifier(caster, ability, "modifier_stunned", { Duration = duration})
		target:EmitSound("Hero_PhantomLancer.Attack")

		DoDamage(caster, target, attack_damage, DAMAGE_TYPE_PHYSICAL, 0, ability, false)

		if caster:HasModifier("modifier_alternate_02") or caster:HasModifier("modifier_alternate_03") then 
			StartAnimation(caster, {duration=0.35, activity=ACT_DOTA_ATTACK_EVENT_BASH , rate=2.5})
		elseif caster:HasModifier("modifier_alternate_01") then 
			StartAnimation(caster, {duration=0.35, activity=ACT_DOTA_ATTACK2 , rate=2.5})
		else
			StartAnimation(caster, {duration=0.35, activity=ACT_DOTA_CAST_ABILITY_3_END , rate=2.5})
		end
		if caster:HasModifier("modifier_lancer_rune_of_combat") then 
			local stacks = caster:GetModifierStackCount("modifier_lancer_rune_of_combat", caster) or 0
			caster:SetModifierStackCount("modifier_lancer_rune_of_combat", caster, stacks + 1)
		end
	end
end	

function GBAttachEffect(keys)
	local caster = keys.caster
	local target = keys.target
	if target:GetName() == "npc_dota_ward_base" then 
		caster:Stop()
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Invalid_Target")
		return
	elseif caster:HasModifier("modifier_self_disarm") then 
		caster:Stop()
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Disarmed")
		return
	end
	local GBCastFx = ParticleManager:CreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(GBCastFx, 1, caster:GetAbsOrigin()) -- target effect location
	ParticleManager:SetParticleControl(GBCastFx, 2, caster:GetAbsOrigin()) -- circle effect location
	Timers:CreateTimer( 2.0, function()
		ParticleManager:DestroyParticle( GBCastFx, false )
		ParticleManager:ReleaseParticleIndex(GBCastFx)
	end)
	if string.match(keys.ability:GetAbilityName(), "lancer_gae_bolg") then
		if caster:HasModifier("modifier_alternate_02") or caster:HasModifier("modifier_alternate_03") then 
			EmitGlobalSound("Rin-Lancer.Gae")
		else
			EmitGlobalSound("Lancer.GaeBolg")
		end
	end
end


function OnGBTargetHit(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local ply = caster:GetPlayerOwner()
	local HBThreshold = ability:GetSpecialValueFor("heart_break")
	local Damage = ability:GetSpecialValueFor("damage")
	local stun = ability:GetSpecialValueFor("stun")

	local flashIndex = ParticleManager:CreateParticle( "particles/custom/diarmuid/gae_dearg_slash.vpcf", PATTACH_CUSTOMORIGIN, caster )
    ParticleManager:SetParticleControl( flashIndex, 2, caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl( flashIndex, 3, caster:GetAbsOrigin() )
    if caster:HasModifier("modifier_alternate_02") then 
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_ATTACK_EVENT_BASH, rate=1})
	else
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_ATTACK, rate=3})
	end

	-- Add dagon particle
	local dagon_particle = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf",  PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControlEnt(dagon_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_lance", caster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(dagon_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
	local particle_effect_intensity = 500
	ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity,0,0))
	target:EmitSound("Hero_Lion.Impale")
	
	Timers:CreateTimer( 3.0, function()
		ParticleManager:DestroyParticle( dagon_particle, false )
		ParticleManager:DestroyParticle( flashIndex, false )
	end)

	if IsSpellBlocked(target) then -- no damage but play the effect
	else
		giveUnitDataDrivenModifier(caster, target, "can_be_executed", 0.033)

		-- Blood splat
		local splat = ParticleManager:CreateParticle("particles/generic_gameplay/screen_blood_splatter.vpcf", PATTACH_EYES_FOLLOW, target)	
		local culling_kill_particle = ParticleManager:CreateParticle("particles/custom/lancer/lancer_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 8, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)	

		if not IsImmuneToCC(target) then
			target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun})
		end

		DoDamage(caster, target, Damage, DAMAGE_TYPE_MAGICAL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, ability, false)
		
		if IsValidEntity(target) and not target:IsNull() and target:IsAlive() then 
			if target:GetHealthPercent() < HBThreshold and not target:IsMagicImmune() and not IsUnExecute(target) then
				local hb = ParticleManager:CreateParticle("particles/custom/lancer/lancer_heart_break_txt.vpcf", PATTACH_CUSTOMORIGIN, target)
				ParticleManager:SetParticleControl( hb, 0, target:GetAbsOrigin())
				
				target:Execute(ability, caster, { bExecution = true })
				
				Timers:CreateTimer( 3.0, function()
					ParticleManager:DestroyParticle( hb, false )
					ParticleManager:ReleaseParticleIndex(hb)
				end)
			end  -- check for HB
		end

		Timers:CreateTimer( 3.0, function()
			ParticleManager:DestroyParticle( splat, false )
			ParticleManager:DestroyParticle( culling_kill_particle, false )
			ParticleManager:ReleaseParticleIndex(culling_kill_particle)	
		end)
	end

	
end

function OnCuGBAOECast(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:HasModifier("modifier_self_disarm") then 
		caster:Stop()
		SendErrorMessage(caster:GetPlayerOwnerID(), "#Disarmed")
		return
	end
	caster.GBCastFx = ParticleManager:CreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(caster.GBCastFx, 1, caster:GetAbsOrigin()) -- target effect location
	ParticleManager:SetParticleControl(caster.GBCastFx, 2, caster:GetAbsOrigin()) -- circle effect location
end

function OnCuGBAOEStart(keys)

	local caster = keys.caster
	local ability = keys.ability
	local targetPoint = ability:GetCursorPosition()
	local radius = ability:GetSpecialValueFor("radius")
	local projectileSpeed = ability:GetSpecialValueFor("speed")
	local ply = caster:GetPlayerOwner()
	local ascendCount = 0
	local descendCount = 0

	Timers:CreateTimer( 1.0, function()
		ParticleManager:DestroyParticle( caster.GBCastFx, false )
	end)

	if (caster:GetAbsOrigin() - targetPoint):Length2D() > 2500 then 
		caster:SetMana(caster:GetMana() + ability:GetManaCost(ability:GetLevel())) 
		ability:EndCooldown() 
		return
	end

	if caster:HasModifier("modifier_alternate_02") or caster:HasModifier("modifier_alternate_03") then 
		EmitGlobalSound("Rin-Lancer.Gae")
	else
		EmitGlobalSound("lancer_gae_bolg_2")
	end

	giveUnitDataDrivenModifier(caster, caster, "jump_pause", 0.8)
	Timers:CreateTimer(0.8, function()
		giveUnitDataDrivenModifier(caster, caster, "jump_pause_postdelay", 0.15)
	end)
	Timers:CreateTimer(0.95, function()
		giveUnitDataDrivenModifier(caster, caster, "jump_pause_postlock", 0.2)
	end)

	Timers:CreateTimer('gb_throw' .. caster:GetPlayerOwnerID(), {
		endTime = 0.35,
		callback = function()
		StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=2})
		local projectileOrigin = caster:GetAbsOrigin() + Vector(0,0,300)

		local particle_name = "particles/custom/lancer/lancer_gae_bolg_projectile.vpcf"
		local throw_particle = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(throw_particle, 0, projectileOrigin)
		ParticleManager:SetParticleControl(throw_particle, 1, (targetPoint - projectileOrigin):Normalized() * projectileSpeed)
		ParticleManager:SetParticleControl(throw_particle, 9, projectileOrigin)

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_self_disarm", {})

		local travelTime = (targetPoint - projectileOrigin):Length() / projectileSpeed
		Timers:CreateTimer(travelTime, function()
			ParticleManager:DestroyParticle(throw_particle, false)
			OnCuGBAOEHit(caster, ability, targetPoint)
		end)
	end})

	Timers:CreateTimer('gb_ascend' .. caster:GetPlayerOwnerID(), {
		endTime = 0,
		callback = function()
	   	if ascendCount == 15 then return end
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,50))
		ascendCount = ascendCount + 1;
		return 0.033
	end
	})

	Timers:CreateTimer("gb_descend" .. caster:GetPlayerOwnerID(), {
	    endTime = 0.3,
	    callback = function()
	    	if descendCount == 15 then return end
			caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,-50))
			descendCount = descendCount + 1;
	      	return 0.033
	    end
	})
end

function OnCuGBAOEHit(caster, ability, targetPoint)
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")
	if caster.IsDeathFlightAcquired then 
		local bonus_agi = ability:GetSpecialValueFor("bonus_agi") 
		damage = damage + (bonus_agi * caster:GetAgility())
	end
	local knock_duration = ability:GetSpecialValueFor("knock_duration")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")

	Timers:CreateTimer(0.15, function()
		local targets = FindUnitsInRadius(caster:GetTeam(), targetPoint, nil, radius
	            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		for k,v in pairs(targets) do
			DoDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0, ability, false)
			if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
		        ApplyAirborne(caster, v, knock_duration)
		        if not IsImmuneToCC(v) then
		        	v:AddNewModifier(caster, v, "modifier_stunned", {Duration = stun_duration})
		        end
		    end
	    end
	    
	    local fire = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rainofchaos_start_breakout_fallback_mid.vpcf", PATTACH_WORLDORIGIN, caster)
		local crack = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_cracks.vpcf", PATTACH_WORLDORIGIN, caster)
		local explodeFx1 = ParticleManager:CreateParticle("particles/custom/lancer/lancer_gae_bolg_hit.vpcf", PATTACH_WORLDORIGIN, caster )
		ParticleManager:SetParticleControl( fire, 0, targetPoint)
		ParticleManager:SetParticleControl( crack, 0, targetPoint)
		ParticleManager:SetParticleControl( explodeFx1, 0, targetPoint)
		ScreenShake(caster:GetOrigin(), 7, 1.0, 2, 2000, 0, true)
		caster:EmitSound("Misc.Crash")
	    Timers:CreateTimer( 3.0, function()
			ParticleManager:DestroyParticle( crack, false )
			ParticleManager:DestroyParticle( fire, false )
			ParticleManager:DestroyParticle( explodeFx1, false )
		end)
	end)

	Timers:CreateTimer(0.75, function()
	    local tProjectile = {
	       	Target = caster,
		    vSourceLoc = targetPoint,
		    Ability = ability,
		    EffectName = "particles/custom/lancer/soaring/spear.vpcf",
		    iMoveSpeed = 3000,
        	bDodgeable = false,
		    flExpireTime = GameRules:GetGameTime() + 10,
	   	}

	   	ProjectileManager:CreateTrackingProjectile(tProjectile)
	end)	
end

function OnCuGBReturn (keys)
	local caster = keys.caster
	local ability = keys.ability 
	local target = keys.target

	if not IsValidEntity(target) or target:IsNull() or not target:IsAlive() then return end

	if target == nil then return end

	target:RemoveModifierByName("modifier_self_disarm")
end

function OnGBComboHit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local hb_threshold = ability:GetSpecialValueFor("hb_threshold")
	local damage = ability:GetSpecialValueFor("damage")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local ply = caster:GetPlayerOwner()
	local dash_speed = 3000

	if not caster.IsHeartSeekerAcquired and IsSpellBlocked(target) then
		return
	end

	-- Set master's combo cooldown
	local masterCombo = caster.MasterUnit2:FindAbilityByName("lancer_wesen_gae_bolg")
	masterCombo:EndCooldown()
	masterCombo:StartCooldown(keys.ability:GetCooldown(1))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_wesen_gae_bolg_cooldown", {duration = ability:GetCooldown(ability:GetLevel())})
	if caster:HasModifier("modifier_wesen_gae_bolg_window") then 
		caster:RemoveModifierByName("modifier_wesen_gae_bolg_window")
	end

	giveUnitDataDrivenModifier(caster, caster, "pause_sealdisabled", 3.0)
	StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.5})
	Timers:CreateTimer(1.6, function()
		if caster:IsAlive() then
			if caster:HasModifier("modifier_alternate_02") then 
				StartAnimation(caster, {duration=3, activity=ACT_DOTA_ATTACK_EVENT, rate=1})
			else
				StartAnimation(caster, {duration=3, activity=ACT_DOTA_ATTACK, rate=3})
			end
		end
	end)
	local soundQueue = math.random(1,4)

	if soundQueue ~= 4 then
		caster:EmitSound("Cu_Combo_" .. soundQueue)
		target:EmitSound("Cu_Combo_" .. soundQueue)
	else
		caster:EmitSound("Lancer.Heartbreak")
		target:EmitSound("Lancer.Heartbreak")
	end
	if caster.IsHeartSeekerAcquired then
		caster:FindAbilityByName("lancer_gae_bolg_upgrade"):StartCooldown(caster:FindAbilityByName("lancer_gae_bolg_upgrade"):GetCooldown(caster:FindAbilityByName("lancer_gae_bolg_upgrade"):GetLevel()))
	else
		caster:FindAbilityByName("lancer_gae_bolg"):StartCooldown(caster:FindAbilityByName("lancer_gae_bolg"):GetCooldown(caster:FindAbilityByName("lancer_gae_bolg"):GetLevel()))
	end
	Timers:CreateTimer(1.8, function() 
		if (caster.IsHeartSeekerAcquired or caster:IsAlive()) and target:IsAlive() then

			if not IsValidEntity(target) or target:IsNull() then return end

		    local lancer = Physics:Unit(caster)

		    --keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_wesen_gae_bolg_pierce_anim", {})

		    caster:OnHibernate(function(unit)
		    	caster:SetPhysicsVelocity((target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized() * 3000)
		    	caster:PreventDI()
		    	caster:SetPhysicsFriction(0)
		    	caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
		    	caster:FollowNavMesh(false)	
		    	caster:SetAutoUnstuck(false)
		    	caster:OnPhysicsFrame(function(unit)
					local diff = target:GetAbsOrigin() - caster:GetAbsOrigin()
					local dir = diff:Normalized()
					if IsInSameRealm(caster:GetAbsOrigin(), target:GetAbsOrigin()) then
						unit:SetPhysicsVelocity(dir * dash_speed)
					else
						unit:SetPhysicsVelocity(dir * dash_speed * 10)
					end
					local forward_vec = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
					forward_vec.z = 0
					caster:SetForwardVector(forward_vec)
					caster:RemoveModifierByName("modifier_zhuge_liang_array_enemy")
					caster:RemoveModifierByName("modifier_aestus_domus_aurea_enemy")

					if diff:Length() < 100 then
				  		caster:RemoveModifierByName("pause_sealdisabled")
						unit:PreventDI(false)
						unit:SetPhysicsVelocity(Vector(0,0,0))
						unit:OnPhysicsFrame(nil)
						unit:OnHibernate(nil)
						unit:SetAutoUnstuck(true)
			        	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

				        local RedScreenFx = ParticleManager:CreateParticle("particles/custom/screen_red_splash.vpcf", PATTACH_EYES_FOLLOW, caster)
				        Timers:CreateTimer( 3.0, function()
							ParticleManager:DestroyParticle( RedScreenFx, false )
						end)
			        	target:EmitSound("Hero_Lion.Impale")
			        	if caster:HasModifier("modifier_alternate_02") then 
							StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_ATTACK_EVENT_BASH, rate=1})
						else
			        		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_ATTACK, rate=2})
			        	end

						ApplyStrongDispel(target)

						giveUnitDataDrivenModifier(caster, target, "can_be_executed", 0.033)

						target:AddNewModifier(caster, target, "modifier_stunned", {duration = stun_duration})

				    	DoDamage(caster, target, damage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY, keys.ability, false)

						if IsValidEntity(target) and not target:IsNull() and target:IsAlive() then
							if target:GetHealthPercent() < hb_threshold and not target:IsMagicImmune() and not IsUnExecute(target) then
								local hb = ParticleManager:CreateParticle("particles/custom/lancer/lancer_heart_break_txt.vpcf", PATTACH_CUSTOMORIGIN, target)
								ParticleManager:SetParticleControl( hb, 0, target:GetAbsOrigin())
								target:Execute(ability, caster, { bExecution = true })
								
								Timers:CreateTimer( 3.0, function()
									ParticleManager:DestroyParticle( hb, false )
									ParticleManager:ReleaseParticleIndex(hb)
								end)
							end  -- check for HB
						end

						-- Blood splat
						local splat = ParticleManager:CreateParticle("particles/generic_gameplay/screen_blood_splatter.vpcf", PATTACH_EYES_FOLLOW, target)	
						local culling_kill_particle = ParticleManager:CreateParticle("particles/custom/lancer/lancer_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN, target)
						ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
						ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
						ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
						ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
						ParticleManager:SetParticleControlEnt(culling_kill_particle, 8, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)	

						-- Add dagon particle
						local dagon_particle = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf",  PATTACH_ABSORIGIN_FOLLOW, caster)
						ParticleManager:SetParticleControlEnt(dagon_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
						local particle_effect_intensity = 800
						ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity,0,0))
						
						Timers:CreateTimer( 3.0, function()
							ParticleManager:DestroyParticle( dagon_particle, false )
							--ParticleManager:DestroyParticle( flashIndex, false )
							ParticleManager:DestroyParticle( splat, false )
							ParticleManager:DestroyParticle( culling_kill_particle, false )
							ParticleManager:ReleaseParticleIndex(culling_kill_particle)	
						end)
					end
				end)
		    end)
			return
		end
	end)
end

function CuCheckCombo (caster, ability)
	if math.ceil(caster:GetStrength()) >= 25 and math.ceil(caster:GetAgility()) >= 25 and math.ceil(caster:GetIntellect()) >= 25 then
		if string.match(ability:GetAbilityName(), "lancer_relentless_spear") and not caster:HasModifier("modifier_wesen_gae_bolg_cooldown") then
			if caster.IsHeartSeekerAcquired then 
				if caster:FindAbilityByName("lancer_gae_bolg_upgrade"):IsCooldownReady() and caster:FindAbilityByName("lancer_wesen_gae_bolg_upgrade"):IsCooldownReady() then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_wesen_gae_bolg_window", {})
				end
			else
				if caster:FindAbilityByName("lancer_gae_bolg"):IsCooldownReady() and caster:FindAbilityByName("lancer_wesen_gae_bolg"):IsCooldownReady() then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_wesen_gae_bolg_window", {})
				end
			end
		end
	end
end

function OnWesenWindowCreate(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.IsHeartSeekerAcquired then
		caster:SwapAbilities("lancer_gae_bolg_upgrade", "lancer_wesen_gae_bolg_upgrade", false, true) 
	else
		caster:SwapAbilities("lancer_gae_bolg", "lancer_wesen_gae_bolg", false, true) 
	end
end

function OnWesenWindowDestroy(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.IsHeartSeekerAcquired then
		caster:SwapAbilities("lancer_gae_bolg_upgrade", "lancer_wesen_gae_bolg_upgrade", true, false) 
	else
		caster:SwapAbilities("lancer_gae_bolg", "lancer_wesen_gae_bolg", true, false) 
	end
end

function OnWesenWindowDied(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("modifier_wesen_gae_bolg_window")
end

function OnImproveBCAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsBCImproved) then
	
		hero.IsBCImproved = true

		if hero:HasModifier("modifier_lancer_rune_magic_check") then 
			UpgradeAttribute(hero, 'lancer_battle_continuation', 'lancer_battle_continuation_upgrade', false)
		else
			UpgradeAttribute(hero, 'lancer_battle_continuation', 'lancer_battle_continuation_upgrade', true)
		end

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnDeathFlightAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsDeathFlightAcquired) then

		hero.IsDeathFlightAcquired = true

		if hero:HasModifier("modifier_lancer_rune_magic_check") then 
			UpgradeAttribute(hero, 'lancer_gae_bolg_jump', 'lancer_gae_bolg_jump_upgrade', false)
		else
			UpgradeAttribute(hero, 'lancer_gae_bolg_jump', 'lancer_gae_bolg_jump_upgrade', true)
		end

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnPFAAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsPFAAcquired) then

		hero.IsPFAAcquired = true

		hero:FindAbilityByName("lancer_protection_from_arrows"):SetLevel(1) 
		
		if hero:HasModifier("modifier_lancer_rune_magic_check") then 
			hero:FindAbilityByName("lancer_protection_from_arrows"):SetHidden(true)
		else
			hero:SwapAbilities("fate_empty1" , "lancer_protection_from_arrows", false, true)
		end

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnHeartseekerAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsHeartSeekerAcquired) then

		hero.IsHeartSeekerAcquired = true

		if hero:HasModifier("modifier_wesen_gae_bolg_window") then 
			hero:RemoveModifierByName("modifier_wesen_gae_bolg_window")
		end 

		if hero:HasModifier("modifier_lancer_rune_magic_check") then 
			UpgradeAttribute(hero, 'lancer_gae_bolg', 'lancer_gae_bolg_upgrade', false)
		else
			UpgradeAttribute(hero, 'lancer_gae_bolg', 'lancer_gae_bolg_upgrade', true)
		end

		UpgradeAttribute(hero, 'lancer_wesen_gae_bolg', 'lancer_wesen_gae_bolg_upgrade', false)


		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end

function OnCelticRuneAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster.HeroUnit

	if not MasterCannotUpgrade(hero, caster, keys.ability, hero.IsCelticRuneAcquired) then

		hero.IsCelticRuneAcquired = true

		hero:AddAbility("lancer_rune_of_disengage_upgrade")
		hero:FindAbilityByName("lancer_rune_of_disengage_upgrade"):SetLevel(hero:FindAbilityByName("lancer_rune_magic"):GetLevel())
		if not hero:FindAbilityByName("lancer_rune_of_disengage"):IsCooldownReady() then 
			hero:FindAbilityByName("lancer_rune_of_disengage_upgrade"):StartCooldown(hero:FindAbilityByName("lancer_rune_of_disengage"):GetCooldownTimeRemaining())
		end

		hero:AddAbility("lancer_rune_of_combat_upgrade")
		hero:FindAbilityByName("lancer_rune_of_combat_upgrade"):SetLevel(hero:FindAbilityByName("lancer_rune_magic"):GetLevel())
		if not hero:FindAbilityByName("lancer_rune_of_combat"):IsCooldownReady() then 
			hero:FindAbilityByName("lancer_rune_of_combat_upgrade"):StartCooldown(hero:FindAbilityByName("lancer_rune_of_combat"):GetCooldownTimeRemaining())
		end

		hero:AddAbility("lancer_rune_of_protection_upgrade")
		hero:FindAbilityByName("lancer_rune_of_protection_upgrade"):SetLevel(hero:FindAbilityByName("lancer_rune_magic"):GetLevel())
		if not hero:FindAbilityByName("lancer_rune_of_protection"):IsCooldownReady() then 
			hero:FindAbilityByName("lancer_rune_of_protection_upgrade"):StartCooldown(hero:FindAbilityByName("lancer_rune_of_protection"):GetCooldownTimeRemaining())
		end

		hero:AddAbility("lancer_rune_of_flame_upgrade")
		hero:FindAbilityByName("lancer_rune_of_flame_upgrade"):SetLevel(hero:FindAbilityByName("lancer_rune_magic"):GetLevel())
		if not hero:FindAbilityByName("lancer_rune_of_flame"):IsCooldownReady() then 
			hero:FindAbilityByName("lancer_rune_of_flame_upgrade"):StartCooldown(hero:FindAbilityByName("lancer_rune_of_flame"):GetCooldownTimeRemaining())
		end

		hero:AddAbility("lancer_rune_magic_upgrade")
		hero:FindAbilityByName("lancer_rune_magic_upgrade"):SetLevel(hero:FindAbilityByName("lancer_rune_magic"):GetLevel())

		if hero:HasModifier("modifier_lancer_rune_magic_check") then 
			hero:SwapAbilities("lancer_rune_of_disengage_upgrade", "lancer_rune_of_disengage", true, false) 
			hero:SwapAbilities("lancer_rune_of_combat_upgrade", "lancer_rune_of_combat", true, false) 
			hero:SwapAbilities("lancer_rune_of_protection_upgrade", "lancer_rune_of_protection", true, false) 
			hero:SwapAbilities("lancer_rune_of_flame_upgrade", "lancer_rune_of_flame", true, false) 
			hero:FindAbilityByName("lancer_rune_magic_upgrade"):SetHidden(true)
		else
			hero:SwapAbilities("lancer_rune_magic_upgrade", "lancer_rune_magic", true, false) 
		end

		hero:RemoveAbility("lancer_rune_of_disengage")
		hero:RemoveAbility("lancer_rune_of_combat")
		hero:RemoveAbility("lancer_rune_of_protection")
		hero:RemoveAbility("lancer_rune_of_flame")
		hero:RemoveAbility("lancer_rune_magic")

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
	end
end