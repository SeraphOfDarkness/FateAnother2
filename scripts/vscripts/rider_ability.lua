nailUsed = false
nailTime = 0

LinkLuaModifier("modifier_vision_provider", "abilities/general/modifiers/modifier_vision_provider", LUA_MODIFIER_MOTION_NONE)

function OnMysticEyesStart(keys)
	local caster = keys.caster
	StartMysticEyesTimer(keys)
end

function OnMysticEyesDeath(keys)
	local caster = keys.caster
	Timers:RemoveTimer("MysticEyes_passive_timer")
end

function OnMysticEyesRespawn(keys)
	local caster = keys.caster
	StartMysticEyesTimer(keys)
end

modName = "modifier_rider_5th_mystic_eye_enemy"
function StartMysticEyesTimer(keys)
	local caster = keys.caster
	Timers:CreateTimer('MysticEyes_passive_timer', {
		endTime = 0,
		callback = function()
		local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, keys.Radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for k,v in pairs(targets) do
			if v ~= caster then 
				if IsFacingUnit(v, caster, 120) then
					keys.ability:ApplyDataDrivenModifier(caster,v, modName, {})
				end
			end
			
	    end
	    return 0.25
	end})
end

function OnMonstrousStrengthProc(keys)
	local hTarget = keys.target
	local hCaster = keys.caster
	local hAbility = keys.ability
	local fStunDuration = 0.1
	local fDamage = 75

	if hTarget:HasModifier("modifier_breaker_gorgon") then
		fStunDuration = 0.5
		fDamage = 250
	end

	hTarget:AddNewModifier(hCaster, hAbility, "modifier_stunned", { duration = fStunDuration })
	DoDamage(hCaster, hTarget, fDamage , DAMAGE_TYPE_PHYSICAL, 0, hAbility, false)
end

function NailPull(keys)
	local caster = keys.caster
	local radius = keys.Radius
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 1, false)
	RiderCheckCombo(caster, keys.ability)
	caster:EmitSound("Rider.NailSwing")
	
	-- Create Particle
	local pullFxIndex = ParticleManager:CreateParticle( "particles/custom/rider/rider_nail_swing.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pullFxIndex, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( pullFxIndex, 1, Vector( radius, radius, radius ) )
	-- Destroy particle
	Timers:CreateTimer( 1.5, function()
			ParticleManager:DestroyParticle( pullFxIndex, false )
			ParticleManager:ReleaseParticleIndex( pullFxIndex )
		end
	)

	for k,v in pairs(targets) do
		print(v:GetName())
		if v:GetName() == "npc_dota_ward_base" then goto excludetarget end
		DoDamage(caster, v, keys.Damage , DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
		if not IsKnockbackImmune(v) then
			v:AddNewModifier(caster, v, "modifier_stunned", { Duration = 0.033 })
			--giveUnitDataDrivenModifier(caster, v, "stunned", 0.033)
			giveUnitDataDrivenModifier(caster, v, "dragged", 0.5)
			
			local pullTarget = Physics:Unit(v)
			v:PreventDI()
			v:SetPhysicsFriction(0)
			v:SetPhysicsVelocity((caster:GetAbsOrigin() - v:GetAbsOrigin()):Normalized() * 1000)
			v:SetNavCollisionType(PHYSICS_NAV_NOTHING)
			v:FollowNavMesh(false)

			Timers:CreateTimer(0.5, function()
				v:PreventDI(false)
				v:SetPhysicsVelocity(Vector(0,0,0))
				v:OnPhysicsFrame(nil)
				FindClearSpaceForUnit(v, v:GetAbsOrigin(), true)
			end)

			v:OnPhysicsFrame(function(unit)
				local diff = caster:GetAbsOrigin() - unit:GetAbsOrigin()
				local dir = diff:Normalized()
				unit:SetPhysicsVelocity(unit:GetPhysicsVelocity():Length() * dir)
				if diff:Length() < 50 then
					unit:PreventDI(false)
					unit:SetPhysicsVelocity(Vector(0,0,0))
					unit:OnPhysicsFrame(nil)
				end
			end)
		end
		::excludetarget::
	end
end

function OnBGStart(keys)
	RiderCheckCombo(keys.caster, keys.ability)
	local caster = keys.caster
	local ability = keys.ability
	local ply = keys.caster:GetPlayerOwner()
	local targetPoint = keys.target_points[1]

	caster:EmitSound("Medusa_Skill1")
    local pcGlyph = ParticleManager:CreateParticle("particles/custom/rider/rider_breaker_gorgon_mark.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pcGlyph, 0, targetPoint) 
    ParticleManager:ReleaseParticleIndex(pcGlyph)

    if caster.IsSealAcquired then
        local pcLight = ParticleManager:CreateParticle("particles/custom/rider/rider_breaker_gorgon_mark_attr.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(pcLight, 0, targetPoint) 
        ParticleManager:ReleaseParticleIndex(pcLight)
    end

	local targets = FindUnitsInRadius(caster:GetTeam(), targetPoint, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	for k,v in pairs(targets) do
		if not IsImmuneToSlow(v) then 
			ability:ApplyDataDrivenModifier(caster, v, "modifier_breaker_gorgon", {Duration = keys.duration}) 
			if caster.IsSealAcquired then  				
				ability:ApplyDataDrivenModifier(caster, v, "modifier_breaker_gorgon_turnrate", {})
			end
		end
	end
end

-- Show particle on start
function OnBloodfortCast( keys )
	local sparkFxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp_charge.vpcf", PATTACH_ABSORIGIN, keys.caster )
	ParticleManager:SetParticleControl( sparkFxIndex, 0, keys.caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( sparkFxIndex, 1, keys.caster:GetAbsOrigin() )
	Timers:CreateTimer( 2.5, function()
			ParticleManager:DestroyParticle( sparkFxIndex, false )
			ParticleManager:ReleaseParticleIndex( sparkFxIndex )
		end
	)
end

function OnBloodfortStart(keys)

	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local initCasterPoint = caster:GetAbsOrigin() 
	local duration = keys.Duration
	local radius = keys.Radius
	local ability = keys.ability
	local bloodfortCount = 0
	caster:EmitSound("Medusa_Skill2") 

	--[[local dummy = CreateUnitByName("dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
	local dummy_ability = dummy:FindAbilityByName("dummy_unit_passive")
	dummy_ability:SetLevel(1)
	dummy:AddNewModifier(caster, nil, "modifier_phased", {duration=5.0})

	local enemy = PickRandomEnemy(caster)
	if enemy ~= nil then
		SpawnVisionDummy(enemy, caster:GetAbsOrigin(), 50, 5, false)
	end	

	Timers:CreateTimer( duration, function()  DummyEnd(dummy) return end )]]

	local forcemove = {
		UnitIndex = nil,
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION ,
		Position = initCasterPoint
	}

	Timers:CreateTimer(function()
		if bloodfortCount >= duration then return end
		
		local targets = FindUnitsInRadius(caster:GetTeam(), initCasterPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for k,v in pairs(targets) do
			if v:GetName() ~= "npc_dota_ward_base" and not v:IsMagicImmune() then
				if not IsImmuneToSlow(v) then ability:ApplyDataDrivenModifier(caster,v, "modifier_bloodfort_slow", {}) end

		        DoDamage(caster, v, keys.Damage * 0.5, DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
		        v:SetMana(v:GetMana() - (keys.Damage * 0.25)) 
		        caster:ApplyHeal(keys.AbsorbAmount * 0.5, caster)
		        caster:GiveMana(keys.AbsorbAmount * 0.25)

				if caster.IsSealAcquired and (bloodfortCount % 1 == 0) then  
					forcemove.UnitIndex = v:entindex()
					ExecuteOrderFromTable(forcemove) 
					Timers:CreateTimer(0.1, function()
						v:Stop()
					end)
					ability:ApplyDataDrivenModifier(caster,v, "modifier_bloodfort_seal", {})
				end
			end
	    end
		bloodfortCount = bloodfortCount + 0.5
		return 0.5
		end
	)
	
	-- Create Particle
	local sphereFxIndex = ParticleManager:CreateParticle( "particles/custom/rider/rider_spirit.vpcf", PATTACH_CUSTOMORIGIN, dummy )
	ParticleManager:SetParticleControl( sphereFxIndex, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( sphereFxIndex, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( sphereFxIndex, 6, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( sphereFxIndex, 10, Vector( radius, radius, radius ) )
	
	Timers:CreateTimer( duration, function()
			ParticleManager:DestroyParticle( sphereFxIndex, false )
			ParticleManager:ReleaseParticleIndex( sphereFxIndex )
			return nil
		end
	)
end

-- Particle for starting to cast belle2
function OnBelle2Cast( keys )
	local caster = keys.caster
	local chargeFxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp_charge.vpcf", PATTACH_ABSORIGIN, caster )
	local eyeFxIndex = ParticleManager:CreateParticle( "particles/items_fx/dust_of_appearance_true_sight.vpcf", PATTACH_ABSORIGIN, caster )
	
	Timers:CreateTimer( 2.5, function()
			ParticleManager:DestroyParticle( chargeFxIndex, false )
			ParticleManager:DestroyParticle( eyeFxIndex, false )
			ParticleManager:ReleaseParticleIndex( chargeFxIndex )
			ParticleManager:ReleaseParticleIndex( eyeFxIndex )
		end
	)
end

function OnBelle2Start(keys)
	local caster = keys.caster
	local ability = keys.ability

	local bloodfortAbility = caster:FindAbilityByName("rider_5th_bloodfort_andromeda")
	local bloodfortCooldown = bloodfortAbility:GetCooldown(bloodfortAbility:GetLevel())
	bloodfortAbility:StartCooldown(bloodfortCooldown)

	-- Set master's combo cooldown
	local masterCombo = caster.MasterUnit2:FindAbilityByName(keys.ability:GetAbilityName())
	masterCombo:EndCooldown()
	masterCombo:StartCooldown(keys.ability:GetCooldown(1))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bellerophon_2_cooldown", {duration = ability:GetCooldown(ability:GetLevel())})
	
	local belle2 = 
	{
		Ability = keys.ability,
        EffectName = "",
        iMoveSpeed = 99999,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = keys.Range,
        fStartRadius = keys.Width,
        fEndRadius = keys.Width,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
        fExpireTime = GameRules:GetGameTime() + 1.0,
		bDeleteOnHit = false,
		vVelocity = caster:GetForwardVector() * 99999
	}
	ParticleManager:CreateParticle("particles/custom/screen_lightblue_splash.vpcf", PATTACH_EYES_FOLLOW, caster)
	EmitGlobalSound("medusa_bellerophon_alt") 
	local projectile = ProjectileManager:CreateLinearProjectile(belle2)
	
	-- Create Particle for projectile
	local belle2FxIndex = ParticleManager:CreateParticle( "particles/custom/rider/rider_bellerophon_2_beam_charge.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( belle2FxIndex, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( belle2FxIndex, 1, Vector( keys.Width, keys.Width, keys.Width ) )
	ParticleManager:SetParticleControl( belle2FxIndex, 2, caster:GetForwardVector() * 5000 )
	ParticleManager:SetParticleControl( belle2FxIndex, 6, Vector( 2, 0, 0 ) )
			
	Timers:CreateTimer( 0.5, function()
		ParticleManager:DestroyParticle( belle2FxIndex, false )
		ParticleManager:ReleaseParticleIndex( belle2FxIndex )
	end)

	locationDelta = caster:GetForwardVector() * keys.Range
	newLocation = caster:GetAbsOrigin() + locationDelta
	for i=1, 20 do
		if GridNav:IsBlocked(newLocation) or not GridNav:IsTraversable(newLocation) then
			--locationDelta =  caster:GetForwardVector() * (keys.Range - 100)
			newLocation = caster:GetAbsOrigin() + caster:GetForwardVector() * (20 - i) * 100
			if not IsInSameRealm(caster:GetAbsOrigin(), newLocation) then
				newLocation.y = caster:GetAbsOrigin().y
			end
		else
			break
		end
	end 
	caster:SetAbsOrigin(newLocation) 
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
end

function OnBelle2Hit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ply = caster:GetPlayerOwner()
	if caster.IsRidingAcquired then 
		keys.Damage = keys.Damage + 450 + (caster:GetAgility() * 10)
	end 
	DoDamage(keys.caster, keys.target, keys.Damage , DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)

	target:AddNewModifier(caster, ability, "modifier_stunned", { Duration = 2 })
end

LinkLuaModifier("modifier_belle_hit", "abilities/medusa/modifiers/modifier_belle_hit", LUA_MODIFIER_MOTION_NONE)

function OnBelleStart(keys)
	local caster = keys.caster
	local targetPoint = keys.target_points[1]
	local radius = keys.Radius
	local ply = caster:GetPlayerOwner()
	local origin = caster:GetAbsOrigin()
	local initialPosition = origin
	local ascendCount = 0
	local descendCount = 0
	local ability = keys.ability
	if (origin - targetPoint):Length2D() > 2500 or not IsInSameRealm(origin, targetPoint) then 
		caster:SetMana(caster:GetMana()+keys.ability:GetManaCost(keys.ability:GetLevel()-1)) 
		keys.ability:EndCooldown()
		FireGameEvent( 'custom_error_show', { player_ID = caster:GetPlayerOwnerID(), _error = "Invalid Target Location" } ) 
		return
	end
	local dist = (origin - targetPoint):Length2D() 
	local dmgdelay = dist * 0.000416
	
	-- Attach particle
	--if caster.AltPart.r == 1 then
	local belleFxIndex = ParticleManager:CreateParticle( "particles/custom/rider/rider_bellerophon_1_alternate.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( belleFxIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", origin, true )
	ParticleManager:SetParticleControlEnt( belleFxIndex, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", origin, true )
	Timers:CreateTimer(1.3+dmgdelay, function()
		ParticleManager:DestroyParticle( belleFxIndex, false )
		ParticleManager:ReleaseParticleIndex( belleFxIndex )
	end)
	--[[else
		local belleFxIndex = ParticleManager:CreateParticle( "particles/custom/rider/rider_bellerophon_1.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControlEnt( belleFxIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", origin, true )
		ParticleManager:SetParticleControlEnt( belleFxIndex, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", origin, true )
		Timers:CreateTimer(1.3+dmgdelay, function()
			ParticleManager:DestroyParticle( belleFxIndex, false )
			ParticleManager:ReleaseParticleIndex( belleFxIndex )
		end)
	end]]
	
	if caster.IsRidingAcquired then 
		keys.Damage = keys.Damage + 250 + (caster:GetAgility() * 7)
	end 
	giveUnitDataDrivenModifier(keys.caster, keys.caster, "jump_pause", 1.3)
	Timers:CreateTimer(0.5, function()
		EmitGlobalSound("Medusa_Bellerophon") 
	end)

	local descendVec = Vector(0,0,0)
	descendVec = (targetPoint - Vector(origin.x, origin.y, 1150)):Normalized()
	Timers:CreateTimer(function()
		if ascendCount == 23 then 
		 	return
		end
		local origin = caster:GetAbsOrigin()
		caster:SetAbsOrigin(Vector(origin.x, origin.y, origin.z + 50))
		ascendCount = ascendCount + 1
		return 0.033
	end)


	Timers:CreateTimer(1.0, function()
		local origin = caster:GetAbsOrigin()
		if (origin - targetPoint):Length2D() > 2000 then return end
		if descendCount == 9 then return end

		caster:SetAbsOrigin(Vector(origin.x + descendVec.x * dist/6 ,
									origin.y + descendVec.y * dist/6,
									origin.z - 127))
		descendCount = descendCount + 1
		return 0.033
	end)

	-- this is when Rider makes a landing 
	Timers:CreateTimer(1.3, function() 
		local origin = caster:GetAbsOrigin()
		if (origin - targetPoint):Length2D() < 2000 then 
			-- set unit's final position first before checking if IsInSameRealm
			-- to allow Belle across river etc
			-- only if it is across realms do we try to adjust position
			caster:SetAbsOrigin(targetPoint)
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
			local currentPosition = caster:GetAbsOrigin()
			if not IsInSameRealm(currentPosition, initialPosition) then
				local diffVector = currentPosition - initialPosition
				local normalisedVector = diffVector:Normalized()
				local length = diffVector:Length2D()
				local newPosition = currentPosition
				while length >= 0
					and (not IsInSameRealm(currentPosition, initialPosition)
						or GridNav:IsBlocked(currentPosition)
						or not GridNav:IsTraversable(currentPosition)
					)
				do
					currentPosition = currentPosition - normalisedVector * 10
					length = length - 10
				end
				caster:SetAbsOrigin(currentPosition)
				FindClearSpaceForUnit(caster, currentPosition, true)
			end
		else
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		end
		caster:EmitSound("Misc.Crash")
		giveUnitDataDrivenModifier(caster, caster, "jump_pause_postlock", dmgdelay + 0.3)
	end)

	-- this is when the damage actually applies(Put slam effect here)
	Timers:CreateTimer(1.35, function()		
		-- Crete particle
		local belleImpactFxIndex = ParticleManager:CreateParticle( "particles/custom/rider/rider_bellerophon_1_impact.vpcf", PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( belleImpactFxIndex, 0, targetPoint)
		ParticleManager:SetParticleControl( belleImpactFxIndex, 1, Vector( keys.Radius, keys.Radius, keys.Radius ) )
		
		Timers:CreateTimer( 1, function()
			ParticleManager:DestroyParticle( belleImpactFxIndex, false )
			ParticleManager:ReleaseParticleIndex( belleImpactFxIndex )
		end)

		local targets1 = FindUnitsInRadius(caster:GetTeam(), targetPoint, nil, keys.Radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		for p,q in pairs(targets1) do
			if not q:HasModifier("modifier_belle_hit") then
				DoDamage(caster, q, keys.Damage , DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
		    	q:AddNewModifier(caster, q, "modifier_stunned", {Duration = keys.StunDuration})
		    	q:AddNewModifier(caster, ability, "modifier_belle_hit", { Duration = 0.11 })
			end
	    end

		local damage_counter = 0

		Timers:CreateTimer(function()
            if damage_counter == 3 or not caster:IsAlive() then return end
            
			local targets = FindUnitsInRadius(caster:GetTeam(), targetPoint, nil, keys.Radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for k,v in pairs(targets) do
				if not v:HasModifier("modifier_belle_hit") then
			    	DoDamage(caster, v, keys.Damage , DAMAGE_TYPE_MAGICAL, 0, keys.ability, false)
			    	v:AddNewModifier(caster, v, "modifier_stunned", {Duration = keys.StunDuration})
			    	v:AddNewModifier(caster, ability, "modifier_belle_hit", { Duration = 0.11 })
				end
		    end
		    damage_counter = damage_counter + 1

            return 0.03
        end)

	    ScreenShake(caster:GetOrigin(), 7, 1.0, 2, 2000, 0, true)
	end)
end

function RiderCheckCombo(caster, ability)
	if caster:GetStrength() >= 29.1 and caster:GetAgility() >= 29.1 and caster:GetIntellect() >= 29.1 then
		if ability == caster:FindAbilityByName("rider_5th_nail_swing") then
			nailUsed = true
			nailTime = GameRules:GetGameTime()
			Timers:CreateTimer({
				endTime = 7,
				callback = function()
				nailUsed = false
			end
			})
		elseif ability == caster:FindAbilityByName("rider_5th_breaker_gorgon") and caster:FindAbilityByName("rider_5th_bloodfort_andromeda"):IsCooldownReady() and caster:FindAbilityByName("rider_5th_bellerophon_2"):IsCooldownReady() then
			if nailUsed == true then 
				caster:SwapAbilities("rider_5th_bloodfort_andromeda", "rider_5th_bellerophon_2", false, true)
				local newTime =  GameRules:GetGameTime()
				Timers:CreateTimer({
					endTime = 7 - (newTime - nailTime),
					callback = function()
					caster:SwapAbilities("rider_5th_bloodfort_andromeda", "rider_5th_bellerophon_2", true, false)
					nailUsed = false
				end
				})
			end
		end
	end
end

function OnImproveMysticEyesAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero.IsMysticEyeImproved = true
	hero:FindAbilityByName("rider_5th_mystic_eye"):SetLevel(2)

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnRidingAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	hero:FindAbilityByName("medusa_riding_passive"):SetLevel(1)

	--hero:SetBaseMoveSpeed(hero:GetBaseMoveSpeed() + 50) 
	--hero.BaseMS = hero.BaseMS+50
	hero.IsRidingAcquired = true

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnSealAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero.IsSealAcquired = true

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end

function OnMonstrousStrengthAcquired(keys)
	local caster = keys.caster
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	hero:SetBaseMagicalResistanceValue(15)
	hero:SetBaseStrength(hero:GetBaseStrength()+10) 
	hero:FindAbilityByName("rider_5th_monstrous_strength_passive"):SetLevel(1)
	hero.IsMonstrousStrengthAcquired = true

	-- Set master 1's mana 
	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - keys.ability:GetManaCost(keys.ability:GetLevel()))
end
