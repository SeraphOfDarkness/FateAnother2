
ishtar_q = class({})
ishtar_q_upgrade = class({})
modifier_ishtar_q_slow = class({})
LinkLuaModifier("modifier_ishtar_q_slow", "abilities/ishtar/ishtar_q", LUA_MODIFIER_MOTION_NONE)

function ishtar_q_wrapper(abil)
	function abil:GetBehavior()
		if self:GetCaster():HasModifier("modifier_ishtar_w_dash") then
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL + DOTA_ABILITY_BEHAVIOR_UNRESTRICTED + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
		else
			return DOTA_ABILITY_BEHAVIOR_POINT
		end
	end

	function abil:GetManaCost(iLevel)
		return 100
	end

	function abil:GetAbilityTextureName()
		return "custom/ishtar/ishtar_q"
	end

	function abil:GetGemConsume(iMaxGemUse)
		local caster = self:GetCaster()
		local gem_consume = 0
		if caster:HasModifier("modifier_ishtar_gem_consume") then 
			local gem = caster:GetModifierStackCount("modifier_ishtar_gem", caster) or 0
			gem_consume = math.min(iMaxGemUse, gem)
			caster:FindAbilityByName(caster.DSkill):AddGem(-gem_consume)
		end
		return gem_consume
	end

	function abil:OnSpellStart()
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		self.arrow = self:GetSpecialValueFor("arrow")
		self.distance = self:GetSpecialValueFor("distance")
		self.speed = self:GetSpecialValueFor("speed")
		self.width = self:GetSpecialValueFor("width")
		local angle = 120
		self.gem_consume = 0
		if caster:HasModifier("modifier_ishtar_gem_consume") then
			self.gem_consume = self:GetGemConsume(self:GetSpecialValueFor("gem_consume"))
		end
		self.arrow = self.arrow + (self.gem_consume * self:GetSpecialValueFor("gem_arrow"))
		local forwardvec = (Vector(target_loc.x, target_loc.y, 0) - Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, 0)):Normalized()
		local caster_angle = VectorToAngles(forwardvec).y 
		local new_angle = caster_angle - angle/2
		for i = 0, self.arrow - 1 do 
			local endLoc = GetRotationPoint(caster:GetAbsOrigin(), self.distance, new_angle + (angle * i / (self.arrow - 1)))
			local new_forwardvec = (Vector(endLoc.x,endLoc.y,0) - Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,0)):Normalized()
			self:CreateArrowProjectile(caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_bow")), new_forwardvec)
		end
	end

	function abil:CreateArrowProjectile(vOrigin, vForward)

		local arrow = {
			Ability = self,
			EffectName = "particles/econ/items/drow/drow_arcana/drow_arcana_multishot_linear_proj_frost_v2.vpcf",
			vSpawnOrigin = vOrigin,
			fDistance = self.distance ,
			Source = self:GetCaster(),
			fStartRadius = self.width,
	        fEndRadius = self.width,
			bHasFrontialCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_ALL,
			fExpireTime = GameRules:GetGameTime() + 2,
			bDeleteOnHit = false,
			vVelocity = vForward * self.speed,		
		}

		ProjectileManager:CreateLinearProjectile(arrow)
	end

	function abil:OnProjectileHit(hTarget, vLocation)
		if hTarget == nil then return end

		local caster = self:GetCaster()
		local damage = self:GetSpecialValueFor("damage")
		local bonus_damage = 0
		if caster.IsVenusAcquired then 
			bonus_damage = self:GetSpecialValueFor("bonus_agi") * caster:GetAgility()
		end
		DoDamage(caster, hTarget, damage + bonus_damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE, self, false)
		if caster.IsManaBurstGemAcquired then 
			caster:FindAbilityByName(caster.FSkill):AddManaBurstDebuff(hTarget)
		end
	end
end

ishtar_q_wrapper(ishtar_q)
ishtar_q_wrapper(ishtar_q_upgrade)

--------------------------

function modifier_ishtar_q_slow:IsHidden()
	return false 
end

function modifier_ishtar_q_slow:IsDebuff()
	return true 
end

function modifier_ishtar_q_slow:IsPassive() 
	return false 
end

function modifier_ishtar_q_slow:DeclareFunctions()
	local func = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
	return func 
end

function modifier_ishtar_q_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end