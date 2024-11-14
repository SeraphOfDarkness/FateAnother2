cu_chulain_claw = class({})
cu_chulain_claw_upgrade = class({})
modifier_rune_of_combat = class({})

LinkLuaModifier("modifier_rune_of_combat", "abilities/cu_chulain/cu_chulain_claw", LUA_MODIFIER_MOTION_NONE)

function clawwrapper(abil)
	function abil:GetAbilityTextureName()
		if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
			return "custom/yukina/yukina_claw"
		else
			return "custom/cu_chulain/cu_chulain_claw"
		end
	end

	function abil:CastFilterResultLocation(vLocation)
		if self:GetCaster():HasModifier("modifier_self_disarm") then 
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end

	function abil:GetCustomCastErrorLocation(vLocation)
	  	return "NO GAE BOLG."
	end

	function abil:GetAOERadius()
		return self:GetSpecialValueFor("aoe")
	end

	function abil:GetCastAnimation()
		if self:GetCaster():HasModifier("modifier_alternate_01") or self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
			return ACT_DOTA_CAST_ABILITY_4
		elseif self:GetCaster():HasModifier("modifier_alternate_02") or self:GetCaster():HasModifier("modifier_alternate_03") then 
			return ACT_DOTA_ATTACK
		else
			return ACT_DOTA_CAST_ABILITY_1
		end
	end

	function abil:GetPlaybackRateOverride()
		if self:GetCaster():HasModifier("modifier_alternate_01") or self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
			return 4
		elseif self:GetCaster():HasModifier("modifier_alternate_02") or self:GetCaster():HasModifier("modifier_alternate_03") then 
			return 2
		else
			return 5
		end
	end

	function abil:OnAbilityPhaseStart()
		local distance = (self:GetCaster():GetAbsOrigin() - self:GetCursorPosition()):Length2D()
		self.strike = ParticleManager:CreateParticle("particles/custom/lancer/lancer_claw_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.strike, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(self.strike, 1, Vector(distance,0,0))
	end

	function abil:OnAbilityPhaseInterrupted()
		ParticleManager:DestroyParticle(self.strike, true)
		ParticleManager:ReleaseParticleIndex(self.strike)
	end


	function abil:OnSpellStart()
		self.caster = self:GetCaster()
		self.target_loc = self:GetCursorPosition()
		self.damage = self:GetSpecialValueFor("damage")
		self.stun = self:GetSpecialValueFor("stun")
		self.aoe = self:GetSpecialValueFor("aoe")
		self.cast = self:GetSpecialValueFor("cast")

		giveUnitDataDrivenModifier(self.caster, self.caster, "pause_sealenabled", self.cast)

		if self.caster:HasModifier("modifier_alternate_04") or self.caster:HasModifier("modifier_alternate_05") then 
			self.caster:EmitSound("Yukina_F")
		end

		Timers:CreateTimer(self.cast, function()

			EmitSoundOnLocationWithCaster(self.target_loc, "Hero_MonkeyKing.Strike.Impact", self.caster)

			local targets = FindUnitsInRadius(self.caster:GetTeam(), self.target_loc, nil, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for k,v in pairs(targets) do
				if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
					if not IsImmuneToCC(v) then 
						v:AddNewModifier(self.caster, self, "modifier_stunned", {Duration = self.stun})
					end
					DoDamage(self.caster, v, self.damage, DAMAGE_TYPE_MAGICAL, 0, self, false)
				end
			end

			self.strike_ground = ParticleManager:CreateParticle("particles/custom/lancer/lancer_claw_strike_ground.vpcf", PATTACH_WORLDORIGIN, self.caster)
			ParticleManager:SetParticleControl(self.strike_ground, 0, self.target_loc)
			ParticleManager:SetParticleControl(self.strike_ground, 1, self.target_loc)
			ParticleManager:SetParticleControl(self.strike_ground, 2, self.target_loc)

			Timers:CreateTimer(0.6, function()
				ParticleManager:DestroyParticle(self.strike_ground, false)
				ParticleManager:ReleaseParticleIndex(self.strike_ground)
			end)
		end)

		if self.caster.IsCelticRuneAcquired then 
			self:ApplyRuneCombat(self:GetSpecialValueFor("bonus_atk_dur"))
		end
	end

	function abil:ApplyRuneCombat(dur)
		local caster = self:GetCaster()
		caster:AddNewModifier(caster, self, "modifier_rune_of_combat", { Duration = dur })
	end
end

clawwrapper(cu_chulain_claw)
clawwrapper(cu_chulain_claw_upgrade)

-------------------------

function modifier_rune_of_combat:IsHidden() 
	if self:GetCaster():HasModifier("modifier_cu_ath_ngabla") then 
		return true 
	else
		return false 
	end
end
function modifier_rune_of_combat:IsDebuff() return false end
function modifier_rune_of_combat:IsPurgable() return false end
function modifier_rune_of_combat:RemoveOnDeath() return true end
function modifier_rune_of_combat:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_rune_of_combat:DeclareFunctions()
	return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE}
end

function modifier_rune_of_combat:GetModifierDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_atk")
end
function modifier_rune_of_combat:GetTexture()
	return "custom/cu_chulain/cu_chulain_rune_combat"
end
function modifier_rune_of_combat:GetEffectName()
	return "particles/custom/lancer/lancer_rune_red_glow.vpcf"
end
function modifier_rune_of_combat:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end










