ereshkigal_q = class({})
ereshkigal_q_upgrade = class({})
modifier_ereshkigal_q_slow = class({})
modifier_ereshkigal_q_use = class({})
modifier_ereshkigal_q_anim = class({})

LinkLuaModifier("modifier_ereshkigal_q_slow", "abilities/ereshkigal/ereshkigal_q", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_q_use", "abilities/ereshkigal/ereshkigal_q", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_q_anim", "abilities/ereshkigal/ereshkigal_q", LUA_MODIFIER_MOTION_NONE)

function EreshkigalQWrapper(abil)
	function abil:GetManaCost(iLevel)
		return 100 
	end

	function abil:OnSpellStart()
		self.caster = self:GetCaster()
		self.total_arrow = self:GetSpecialValueFor("total_arrow")
		self.distance = self:GetSpecialValueFor("distance")
		self.width = self:GetSpecialValueFor("width")
		self.damage = self:GetSpecialValueFor("damage")
		self.slow_dur = self:GetSpecialValueFor("slow_dur")
		self.slow = self:GetSpecialValueFor("slow")
		self.silence = 0
		if self.caster:HasModifier("modifier_ereshkigal_authority") then
			self.silence = self:GetSpecialValueFor("silence")
		end
		self.forward = self.caster:GetForwardVector()
		self.right_vec = self.caster:GetRightVector()
		if self.caster.IsManaBurstAcquired then 
			local bonus_int = self:GetSpecialValueFor("bonus_int")
			self.damage = self.damage + (bonus_int * self.caster:GetIntellect())
		end
		self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_q_anim", {Duration = 0.25})
		self.arrow_spawn_loc = {}
		self.side = self.right_vec
		for i = 0, self.total_arrow - 1 do 
			if i % 2 == 1 then 
				self.side = self.right_vec
			else
				self.side = -self.right_vec
			end
			self.arrow_spawn_loc[i] = self.caster:GetAbsOrigin() + (self.side * (self.width/2) * math.ceil(i/2))
			Timers:CreateTimer(i * 0.04, function()
				local Arrow = {
					Ability = self,
			        EffectName = "particles/custom/ereshkigal/ereshkigal_spear_arrow.vpcf",
			        vSpawnOrigin = self.arrow_spawn_loc[i] + Vector(0,0,40),
			        fDistance = self.distance,
			        fStartRadius = self.width,
			        fEndRadius = self.width,
			        Source = self:GetCaster(),
			        bHasFrontalCone = true,
			        bReplaceExisting = false,
			        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
			        fExpireTime = GameRules:GetGameTime() + 1.5,
			        bProvidesVision = true,
			        iVisionRadius = self.width,
					bDeleteOnHit = true,
					vVelocity = self.forward * self.distance * 1.5,	
					ExtraData = {Damage = self.damage, Silence = self.silence, Slow = self.slow, SlowDuration = self.slow_dur},	
				}
				self.channel_arrow = ProjectileManager:CreateLinearProjectile(Arrow)
			end)
		end
		--self:UseSoul()
		self:CheckCombo()
	end

	function abil:OnProjectileHit_ExtraData(hTarget, vLocation, tExtra)
		if hTarget == nil then return false end 

		if not IsImmuneToCC(hTarget) and not IsImmuneToSlow(hTarget) then
			hTarget:AddNewModifier(self.caster, self, "modifier_ereshkigal_q_slow", {Duration = tExtra.SlowDuration, Slow = tExtra.Slow})
		end

		if tExtra.Silence > 0 and hTarget:HasModifier("modifier_ereshkigal_marble_aura_debuff") then 
			hTarget:AddNewModifier(self.caster, self, "modifier_silence", {Duration = tExtra.Silence})
		end

		DoDamage(self.caster, hTarget, tExtra.Damage, DAMAGE_TYPE_MAGICAL, 0, self, false)

		return true	
	end

	function abil:UseSoul()
		if not self.caster:HasModifier("modifier_ereshkigal_authority") then return end

		if not self.caster.IsCrownAcquired then return end

		local ereshkigal_d = self.caster:FindAbilityByName(self.caster.DSkill)

		self.q_consume = ereshkigal_d:GetSpecialValueFor("q_consume")
		local soul_stack = self.caster:GetModifierStackCount("modifier_ereshkigal_soul", self.caster) or 0 

		if soul_stack >= self.q_consume then 
			ereshkigal_d:CollectSoul(self.q_consume)
			self:EndCooldown()
		end
	end

	function abil:CheckCombo()
		if math.ceil(self.caster:GetStrength()) >= 25 and math.ceil(self.caster:GetAgility()) >= 25 and math.ceil(self.caster:GetIntellect()) >= 25 then		
			local soul = self.caster:FindModifierByName("modifier_ereshkigal_soul")
			local soul_bonus = 0
			if soul then 
				soul_bonus = soul:GetModifierBonusStats_Agility()
				if math.ceil(self.caster:GetAgility() - soul_bonus) < 25 then return end
			end

			if self.caster:FindAbilityByName(self.caster.RSkill):IsCooldownReady() and not self.caster:HasModifier("modifier_ereshkigal_combo_cooldown") then
				if string.match(GetMapName(), "fate_elim") then 
					if GameRules:GetGameTime() <= 30 + _G.RoundStartTime or GameRules:GetGameTime() > 115 + _G.RoundStartTime then
						return 
					end
				end
				self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_q_use", {Duration = 4})
			end
		end
	end
end

EreshkigalQWrapper(ereshkigal_q)
EreshkigalQWrapper(ereshkigal_q_upgrade)

------------------------

function modifier_ereshkigal_q_slow:IsHidden() return false end
function modifier_ereshkigal_q_slow:IsDebuff() return true end
function modifier_ereshkigal_q_slow:IsPurgable() return true end
function modifier_ereshkigal_q_slow:RemoveOnDeath() return true end
function modifier_ereshkigal_q_slow:GetAttributes()
    return MODIFIER_ATTRIBUTE_NONE
end
function modifier_ereshkigal_q_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end
function modifier_ereshkigal_q_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow 
end

function modifier_ereshkigal_q_slow:OnCreated(args)
	self.slow = args.Slow 
end

function modifier_ereshkigal_q_slow:OnRefresh(args)
	self:OnCreated(args)
end

function modifier_ereshkigal_q_slow:OnDestroy()

end

-------------------------

function modifier_ereshkigal_q_use:IsHidden() return true end
function modifier_ereshkigal_q_use:IsDebuff() return false end
function modifier_ereshkigal_q_use:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

------------------------

function modifier_ereshkigal_q_anim:IsHidden() return true end
function modifier_ereshkigal_q_anim:IsDebuff() return false end
function modifier_ereshkigal_q_anim:IsPurgable() return false end
function modifier_ereshkigal_q_anim:RemoveOnDeath() return true end
function modifier_ereshkigal_q_anim:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_ereshkigal_q_anim:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true,}
end