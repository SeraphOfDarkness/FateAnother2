ereshkigal_e = class({})
ereshkigal_e_upgrade_1 = class({})
ereshkigal_e_upgrade_2 = class({})
ereshkigal_e_upgrade_3 = class({})
modifier_ereshkigal_cage = class({})
modifier_ereshkigal_cage_debuff = class({})

LinkLuaModifier("modifier_ereshkigal_cage", "abilities/ereshkigal/ereshkigal_e", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_cage_debuff", "abilities/ereshkigal/ereshkigal_e", LUA_MODIFIER_MOTION_NONE)

function EreshkigalEWrapper(abil)

	function abil:GetAOERadius()
		return self:GetSpecialValueFor("aoe")
	end

	function abil:OnSpellStart()
		self.caster = self:GetCaster()
		self.target_loc = self:GetCursorPosition()
		self.delay = self:GetSpecialValueFor("delay")
		self.aoe = self:GetAOERadius()
		self.damage = self:GetSpecialValueFor("damage")
		self.cage_dur = self:GetSpecialValueFor("cage_dur")
		self.hp_drain = self:GetSpecialValueFor("hp_drain")
		self.revoke = self:GetSpecialValueFor("revoke")
		self.IsHell = false
		local eresh_r = self.caster:FindAbilityByName(self.caster.RSkill)
		if eresh_r:IsCastInsideMarble(self.target_loc)  then 
			self.IsHell = true 
		end

		if self.caster.IsManaBurstAcquired then 
			local bonus_int = self:GetSpecialValueFor("bonus_int")
			self.damage = self.damage + (bonus_int * self.caster:GetIntellect())
		end

		--self:UseSoul() 

		local CageDropFx = ParticleManager:CreateParticle("particles/custom/ereshkigal/ereshkigal_cage.vpcf", PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(CageDropFx, 0, self.target_loc + Vector(0,0,-600)) 
		ParticleManager:SetParticleControl(CageDropFx, 1, self.target_loc) 
		ParticleManager:SetParticleControl(CageDropFx, 2, Vector(self.delay,0,0)) 
		Timers:CreateTimer(self.delay, function()
			ParticleManager:DestroyParticle(CageDropFx, true)
			ParticleManager:ReleaseParticleIndex(CageDropFx)
		end)

		Timers:CreateTimer(self.delay, function()
			if self.caster:IsAlive() then 

				local cage_target = FindUnitsInRadius(self.caster:GetTeam(), self.target_loc, nil, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)
				for k,v in pairs(cage_target) do
					if not v:IsMagicImmune() then 
						if v:IsRealHero() then 
							DoDamage(self.caster, v, self.damage, DAMAGE_TYPE_MAGICAL, 0, self, false)

							if IsImmuneToCC(v) then 
								self.cage_dur = self.cage_dur * 0.5 
							end
							v:AddNewModifier(self.caster, self, "modifier_ereshkigal_cage", {Duration = self.cage_dur, HPDrain = self.hp_drain})
							
							if self.IsHell == true then 
								giveUnitDataDrivenModifier(self.caster, v, "revoked", self.revoke)
							end

							v:SetAbsOrigin(self.target_loc)

							local CageFx = ParticleManager:CreateParticle("particles/custom/ereshkigal/ereshkigal_cage.vpcf", PATTACH_WORLDORIGIN, self.caster)
							ParticleManager:SetParticleControl(CageFx, 0, self.target_loc) 
							ParticleManager:SetParticleControl(CageFx, 1, self.target_loc) 
							ParticleManager:SetParticleControl(CageFx, 2, Vector(self.cage_dur,0,0)) 
							Timers:CreateTimer(self.cage_dur, function()
								ParticleManager:DestroyParticle(CageFx, true)
								ParticleManager:ReleaseParticleIndex(CageFx)
							end)

							if self.caster.IsUnderworldAcquired then 
								self.damage_debuff = self:GetSpecialValueFor("damage_debuff")
								self.debuff_dur = self:GetSpecialValueFor("debuff_dur")
								v:AddNewModifier(self.caster, self, "modifier_ereshkigal_cage_debuff", {Duration = self.debuff_dur, Debuff = self.damage_debuff})
							end

							break 
						end
					end
				end
			end

		end)
	end

	function abil:UseSoul()
		if not self.caster:HasModifier("modifier_ereshkigal_authority") then return end

		if not self.caster.IsCrownAcquired then return end

		local ereshkigal_d = self.caster:FindAbilityByName(self.caster.DSkill)

		self.e_consume = ereshkigal_d:GetSpecialValueFor("e_consume")
		local soul_stack = self.caster:GetModifierStackCount("modifier_ereshkigal_soul", self.caster) or 0 

		if soul_stack >= self.e_consume then 
			ereshkigal_d:CollectSoul(self.e_consume)
			self:EndCooldown()
		end
	end
end

EreshkigalEWrapper(ereshkigal_e)
EreshkigalEWrapper(ereshkigal_e_upgrade_1)
EreshkigalEWrapper(ereshkigal_e_upgrade_2)
EreshkigalEWrapper(ereshkigal_e_upgrade_3)

---------------------

function modifier_ereshkigal_cage:IsHidden() return false end
function modifier_ereshkigal_cage:IsDebuff() return true end
function modifier_ereshkigal_cage:IsPurgable() return true end
function modifier_ereshkigal_cage:RemoveOnDeath() return true end
function modifier_ereshkigal_cage:GetAttributes()
    return MODIFIER_ATTRIBUTE_NONE
end 
function modifier_ereshkigal_cage:CheckState()
    local state = { [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    [MODIFIER_STATE_ROOTED] = true,
                    [MODIFIER_STATE_SILENCED] = true,
                    [MODIFIER_STATE_MUTED] = true,
                }
    return state
end

function modifier_ereshkigal_cage:OnCreated(args)
	self.caster = self:GetCaster()
	self.target = self:GetParent()
	self.ability = self:GetAbility()

	self.hp_drain = args.HPDrain 
	if self.hp_drain == nil then 
		self.hp_drain = self.ability:GetSpecialValueFor("hp_drain")
	end
	self:StartIntervalThink(0.33)
end

function modifier_ereshkigal_cage:OnRefresh(args)
	self:OnCreated(args)
end

function modifier_ereshkigal_cage:OnIntervalThink()
	if self.ability == nil then 
		self.ability = self.caster:FindAbilityByName(self.caster.ESkill)
	end
	DoDamage(self.caster, self.target, self.hp_drain * 0.33, DAMAGE_TYPE_MAGICAL, 0, self.ability, false)
	self.caster:FateHeal(self.hp_drain*0.33, self.caster, true)
end

function modifier_ereshkigal_cage:OnDestroy()

end

--------------------------

function modifier_ereshkigal_cage_debuff:IsHidden() return false end
function modifier_ereshkigal_cage_debuff:IsDebuff() return true end
function modifier_ereshkigal_cage_debuff:IsPurgable() return true end
function modifier_ereshkigal_cage_debuff:RemoveOnDeath() return true end
function modifier_ereshkigal_cage_debuff:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_ereshkigal_cage_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE}
end
function modifier_ereshkigal_cage_debuff:OnCreated(args)
	self.debuff = args.Debuff

end

function modifier_ereshkigal_cage_debuff:OnRefresh(args)
	self:OnCreated(args)
end
function modifier_ereshkigal_cage_debuff:OnDestroy()

end
function modifier_ereshkigal_cage_debuff:GetModifierTotalDamageOutgoing_Percentage()
	return self.debuff
end
function modifier_ereshkigal_cage_debuff:GetEffectName()
	return "particles/items3_fx/nemesis_curse_debuff.vpcf"
end
function modifier_ereshkigal_cage_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


