robin_parkour_shot = class({})

function robin_parkour_shot:GetVectorTargetRange()
	return 750
end

function robin_parkour_shot:OnVectorCastStart(vStartLocation, vDirection)

	Timers:CreateTimer(0.05, function()
		local caster = self:GetCaster()
		local speed = 3000

		local sin = Physics:Unit(caster)
		caster:SetPhysicsFriction(0)
		caster:SetPhysicsVelocity(caster:GetForwardVector()*3000)

		Timers:CreateTimer(0.2, function()
			caster:PreventDI(false)
			caster:SetPhysicsVelocity(Vector(0,0,0))
			--FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)

		local arrow = 
		{
			Ability = self,
			EffectName = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = self:GetVectorTargetRange(),
			fStartRadius = 64,
			fEndRadius = 64,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = true,
			vVelocity = self:GetVectorDirection() * speed,
			bProvidesVision = true,
			iVisionRadius = 200,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		projectile = ProjectileManager:CreateLinearProjectile(arrow)

		local arrow1 = 
		{
			Ability = self,
			EffectName = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = self:GetVectorTargetRange(),
			fStartRadius = 64,
			fEndRadius = 64,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = true,
			vVelocity = self:GetVectorDirection() + Vector(25,25) * speed,
			bProvidesVision = true,
			iVisionRadius = 200,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		projectile = ProjectileManager:CreateLinearProjectile(arrow1)

		local arrow2 = 
		{
			Ability = self,
			EffectName = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = self:GetVectorTargetRange(),
			fStartRadius = 64,
			fEndRadius = 64,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = true,
			vVelocity = self:GetVectorDirection() + Vector(-25,-25) * speed,
			bProvidesVision = true,
			iVisionRadius = 200,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		projectile = ProjectileManager:CreateLinearProjectile(arrow2)

		local arrow3 = 
		{
			Ability = self,
			EffectName = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = self:GetVectorTargetRange(),
			fStartRadius = 64,
			fEndRadius = 64,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = true,
			vVelocity = self:GetVectorDirection() + Vector(50,50) * speed,
			bProvidesVision = true,
			iVisionRadius = 200,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		projectile = ProjectileManager:CreateLinearProjectile(arrow3)

		local arrow4 = 
		{
			Ability = self,
			EffectName = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = self:GetVectorTargetRange(),
			fStartRadius = 64,
			fEndRadius = 64,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = true,
			vVelocity = self:GetVectorDirection() + Vector(-50,-50) * speed,
			bProvidesVision = true,
			iVisionRadius = 200,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		projectile = ProjectileManager:CreateLinearProjectile(arrow4)

		end)
	end)
end

function robin_parkour_shot:OnProjectileHitUnit(hTarget, vLocation)
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")

	DoDamage(caster, hTarget, damage , DAMAGE_TYPE_PHYSICAL, 0, ability, false)
end

