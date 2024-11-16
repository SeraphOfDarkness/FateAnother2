
ereshkigal_w = class({})
ereshkigal_w_upgrade_1 = class({})
ereshkigal_w_upgrade_2 = class({})
ereshkigal_w_upgrade_3 = class({})
modifier_ereshkigal_steal = class({})
modifier_ereshkigal_steal_self = class({})

LinkLuaModifier("modifier_ereshkigal_steal", "abilities/ereshkigal/ereshkigal_w", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_steal_self", "abilities/ereshkigal/ereshkigal_w", LUA_MODIFIER_MOTION_NONE)

function EreshkigalWWrapper(abil)

	function abil:GetCastPoint()
		if self:GetCaster():HasModifier("modifier_ereshkigal_authority") then 
			return self:GetSpecialValueFor("hell_cast")
		else
			return self:GetSpecialValueFor("cast_time")
		end
	end

	function abil:GetAOERadius()
		return self:GetSpecialValueFor("aoe")
	end

	function abil:OnSpellStart()
		self.caster = self:GetCaster()
		self.target_loc = self:GetCursorPosition()
		self.cast_delay = self:GetSpecialValueFor("cast_delay")
		self.IsHell = false
		local eresh_r = self.caster:FindAbilityByName(self.caster.RSkill)
		if eresh_r:IsCastInsideMarble(self.target_loc)  then 
			self.cast_delay = self:GetSpecialValueFor("hell_delay")
			self.IsHell = true
		end
		self.aoe = self:GetAOERadius()
		self.damage = self:GetSpecialValueFor("damage")
		if self.caster.IsManaBurstAcquired then 
			local bonus_int = self:GetSpecialValueFor("bonus_int")
			self.damage = self.damage + (bonus_int * self.caster:GetIntellect())
		end
		self.stun = self:GetSpecialValueFor("stun")
		self.mana_burn = self:GetSpecialValueFor("mana_burn")
		local forward_vec = self.caster:GetForwardVector()

		local DevourerSFX1 = ParticleManager:CreateParticle("particles/custom/ereshkigal/ereshkigal_spirit_devourer.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
		ParticleManager:SetParticleControl(DevourerSFX1, 0, self.target_loc - (forward_vec * self:GetAOERadius())) --spawn
		ParticleManager:SetParticleControl(DevourerSFX1, 1, forward_vec * self:GetAOERadius()/self.cast_delay) -- direction

		Timers:CreateTimer(self.cast_delay, function()
			ParticleManager:DestroyParticle(DevourerSFX1, true)
			ParticleManager:ReleaseParticleIndex(DevourerSFX1)
			if self.caster:IsAlive() then 

				--self:UseSoul()

				local tEnemies = FindUnitsInRadius(self.caster:GetTeam(), self.target_loc, nil, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)
				for k,v in pairs(tEnemies) do

					DoDamage(self.caster, v, self.damage, DAMAGE_TYPE_MAGICAL, 0, self, false)
					if not v:IsMagicImmune() then 
						
						if v:IsRealHero() then 
						
							v:AddNewModifier(self.caster, self, "modifier_stunned", {Duration = self.stun})
							
							if self.caster.IsCrownAcquired then 
								self.steal_stat = self:GetSpecialValueFor("steal_stat")
								self.steal_dur = self:GetSpecialValueFor("steal_dur")
								v:AddNewModifier(self.caster, self, "modifier_ereshkigal_steal", {Duration = self.steal_dur, Stat = self.steal_stat})
								self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_steal_self", {Duration = self.steal_dur, Stat = self.steal_stat})
								self:SoulSteal()
							end

							if self.IsHell == true then 
								v:SpendMana(self.mana_burn, self)
								self.mana_restore = self:GetSpecialValueFor("mana_restore") / 100
								self.caster:GiveMana(self.mana_burn * self.mana_restore)
							end
						end

						break 
					end
				end
			end
		end)
	end

	function abil:UseSoul()
		if not self.caster:HasModifier("modifier_ereshkigal_authority") then return end

		if not self.caster.IsCrownAcquired then return end

		local ereshkigal_d = self.caster:FindAbilityByName(self.caster.DSkill)

		self.w_consume = ereshkigal_d:GetSpecialValueFor("w_consume")
		local soul_stack = self.caster:GetModifierStackCount("modifier_ereshkigal_soul", self.caster) or 0 

		if soul_stack >= self.w_consume then 
			ereshkigal_d:CollectSoul(self.w_consume)
			self:EndCooldown()
		end
	end

	function abil:SoulSteal()
		self.soul_gain = self:GetSpecialValueFor("soul_gain")

		local ereshkigal_d = self.caster:FindAbilityByName(self.caster.DSkill)
		ereshkigal_d:CollectSoul(self.soul_gain)
	end
end

EreshkigalWWrapper(ereshkigal_w)
EreshkigalWWrapper(ereshkigal_w_upgrade_1)
EreshkigalWWrapper(ereshkigal_w_upgrade_2)
EreshkigalWWrapper(ereshkigal_w_upgrade_3)

--------------------------

function modifier_ereshkigal_steal:IsHidden() return false end
function modifier_ereshkigal_steal:IsDebuff() return true end
function modifier_ereshkigal_steal:IsPurgable() return true end
function modifier_ereshkigal_steal:RemoveOnDeath() return true end
function modifier_ereshkigal_steal:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_ereshkigal_steal:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,}
end
function modifier_ereshkigal_steal:GetModifierBonusStats_Strength()
	return -self.Stat
end

function modifier_ereshkigal_steal:GetModifierBonusStats_Agility()
	return -self.Stat 
end

function modifier_ereshkigal_steal:GetModifierBonusStats_Intellect()
	return -self.Stat
end

function modifier_ereshkigal_steal:OnCreated(args)
	self.Stat = args.Stat 
end

function modifier_ereshkigal_steal:OnRefresh(args)
	self:OnCreated(args)
end

function modifier_ereshkigal_steal:OnDestroy()

end

function modifier_ereshkigal_steal:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_debuff.vpcf"
end
function modifier_ereshkigal_steal:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-----------------------------

function modifier_ereshkigal_steal_self:IsHidden() return false end
function modifier_ereshkigal_steal_self:IsDebuff() return false end
function modifier_ereshkigal_steal_self:IsPurgable() return true end
function modifier_ereshkigal_steal_self:RemoveOnDeath() return true end
function modifier_ereshkigal_steal_self:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_ereshkigal_steal_self:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,}
end
function modifier_ereshkigal_steal_self:GetModifierBonusStats_Strength()
	return self.Stat
end

function modifier_ereshkigal_steal_self:GetModifierBonusStats_Agility()
	return self.Stat 
end

function modifier_ereshkigal_steal_self:GetModifierBonusStats_Intellect()
	return self.Stat
end

function modifier_ereshkigal_steal_self:OnCreated(args)
	self.Stat = args.Stat 
end

function modifier_ereshkigal_steal_self:OnRefresh(args)
	self:OnCreated(args)
end

function modifier_ereshkigal_steal_self:OnDestroy()

end
function modifier_ereshkigal_steal_self:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_debuff.vpcf"
end
function modifier_ereshkigal_steal_self:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

