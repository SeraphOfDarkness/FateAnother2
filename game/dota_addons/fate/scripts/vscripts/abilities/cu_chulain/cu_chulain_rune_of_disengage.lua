cu_chulain_disengage = class({})
cu_chulain_disengage_upgrade = class({})

function disengage_wrapper(abil)
	function abil:GetAbilityTextureName()
		if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
			return "custom/yukina/yukina_disengage"
		else
			return "custom/cu_chulain/cu_chulain_disengage"
		end
	end

	function abil:CastFilterResult()
		if self:GetCaster():HasModifier("modifier_cu_ath_ngabla") then 
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end

	function abil:GetCustomCastError()
	  	return "Can not retreat while Ath nGabla is activating."
	end

	function abil:OnSpellStart()
		self.caster = self:GetCaster()
		local backward = self.caster:GetForwardVector() * self:GetSpecialValueFor("distance")
		local newLoc = self.caster:GetAbsOrigin() - backward
		local diff = newLoc - self.caster:GetAbsOrigin()

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(particle, 0, self.caster:GetAbsOrigin())

		HardCleanse(self.caster)
		self.caster:EmitSound("Hero_PhantomLancer.Doppelwalk")

		if self.caster:HasModifier("modifier_alternate_04") or self.caster:HasModifier("modifier_alternate_05") then 
			self.caster:EmitSound("Yukina_Q")
		end
		local i = 1
		while GridNav:IsBlocked(newLoc) or not GridNav:IsTraversable(newLoc) or i == 100 do
			i = i+1
			newLoc = self.caster:GetAbsOrigin() + diff:Normalized() * (self:GetSpecialValueFor("distance") - i*10)
		end
		Timers:CreateTimer(0.033, function() 
			self.caster:SetAbsOrigin(newLoc)
			ProjectileManager:ProjectileDodge(self.caster) 
			FindClearSpaceForUnit(self.caster, self.caster:GetAbsOrigin(), true)

			if self.caster.IsCelticRuneAcquired then
				local heal = self:GetSpecialValueFor("heal")
				self.caster:FateHeal(heal, self.caster, true)	
				self.caster:EmitSound("Hero_Omniknight.Purification")
				local heal_sfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.caster)
				ParticleManager:SetParticleControl(heal_sfx1, 0, self.caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(heal_sfx1, 1, Vector(100,100,100))
				local heal_sfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.caster)
				ParticleManager:SetParticleControl(heal_sfx2, 0, self.caster:GetAbsOrigin())
				local heal_sfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.caster)
				ParticleManager:SetParticleControl(heal_sfx3, 0, self.caster:GetAbsOrigin())
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(heal_sfx1, false)
					ParticleManager:DestroyParticle(heal_sfx2, false)
					ParticleManager:DestroyParticle(heal_sfx3, false)
					ParticleManager:ReleaseParticleIndex(heal_sfx1)
					ParticleManager:ReleaseParticleIndex(heal_sfx2)
					ParticleManager:ReleaseParticleIndex(heal_sfx3)
				end) 
			end
		end)

		

		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(particle, false)
			ParticleManager:ReleaseParticleIndex(particle)
		end) 
	end
end

disengage_wrapper(cu_chulain_disengage)
disengage_wrapper(cu_chulain_disengage_upgrade)