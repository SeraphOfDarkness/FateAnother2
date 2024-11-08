cu_chulain_relentless_spear = class({})
cu_chulain_relentless_spear_upgrade = class({})
modifier_relentless_spear = class({})
modifier_rune_of_ferocity = class({})
modifier_wesen_window = class({})

LinkLuaModifier("modifier_relentless_spear", "abilities/cu_chulain/cu_chulain_relentless_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wesen_window", "abilities/cu_chulain/cu_chulain_relentless_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rune_of_ferocity", "abilities/cu_chulain/cu_chulain_relentless_spear", LUA_MODIFIER_MOTION_NONE)

function relentlesswrapper(abil)
	function abil:GetAbilityTextureName()
		if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
			return "custom/yukina/yukina_relentless_spear"
		else
			return "custom/cu_chulain/cu_chulain_relentless_spear"
		end
	end

	function abil:GetCastRange(vLocation, hTarget)
		return self:GetSpecialValueFor("cast_range")
	end

	function abil:CastFilterResultTarget(hTarget)
		local caster = self:GetCaster()
		local filter = UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, caster:GetTeamNumber())

		if(filter == UF_SUCCESS) then
			if hTarget:GetName() == "npc_dota_ward_base" then 
				return UF_FAIL_BUILDING
			elseif caster:HasModifier("modifier_self_disarm") then 
				return UF_FAIL_CUSTOM
			else
				return UF_SUCCESS
			end
		else
			return filter
		end
	end

	function abil:GetCustomCastError()
	  	return "NO GAE BOLG."
	end


	function abil:OnSpellStart()
		self.caster = self:GetCaster()
		self.target = self:GetCursorTarget()

		if self.caster:HasModifier("modifier_alternate_04") or self.caster:HasModifier("modifier_alternate_05") then 
			self.caster:EmitSound("Yukina_W") 
			--StartAnimation(caster, {duration=1.05, activity=ACT_DOTA_CAST_ABILITY_2 , rate=1.0})
		else
			self.caster:EmitSound("cu_skill_" .. math.random(1,4))
		end

		self.target:AddNewModifier(self.caster, self, "modifier_stunned", { Duration = 0.15})
		self.caster:AddNewModifier(self.caster, self, "modifier_relentless_spear", { Duration = self:GetSpecialValueFor("duration") + 0.1,
																		   DamagePct = self:GetSpecialValueFor("damage_tooltips") })

		self.caster:RemoveModifierByName("modifier_relentless_window")
		self:CheckCombo()
	end

	function abil:OnChannelThink(flInterval)
		local distance = (self.caster:GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D()

		if not self.caster:IsAlive() or not self.target:IsAlive() or distance > self:GetSpecialValueFor("cast_range") + 150 then
			local stopOrder = {
		 		UnitIndex = self.caster:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_STOP
		 	}

		 	ExecuteOrderFromTable(stopOrder) 
			self:EndChannel(true)
		end
	end

	function abil:OnChannelFinish(bInterrupted)
		local caster = self:GetCaster()
		caster:RemoveModifierByName("modifier_relentless_spear")
		if caster.IsCelticRuneAcquired then 
			if bInterrupted == false then 
				self:ApplyRuneFerocity(self:GetSpecialValueFor("bonus_aspd_dur"))
			end
		end
	end

	function abil:CheckCombo()
		local caster = self:GetCaster()

		if math.ceil(caster:GetStrength()) >= 25 and math.ceil(caster:GetAgility()) >= 25 and math.ceil(caster:GetIntellect()) >= 25 then
			if caster:HasModifier("modifier_cu_q_use")
			and caster:FindAbilityByName(caster.ESkill):IsCooldownReady() 
			and not caster:HasModifier("modifier_wesen_cooldown")
			and caster:FindAbilityByName(caster.ComboSkill):IsCooldownReady() then
				local remain_dur = caster:FindModifierByName("modifier_cu_q_use"):GetRemainingTime()
				caster:AddNewModifier(caster, self, "modifier_wesen_window", { Duration = remain_dur })
			end
		end
	end

	function abil:ApplyRuneFerocity(dur)
		local caster = self:GetCaster()
		caster:AddNewModifier(caster, self, "modifier_rune_of_ferocity", { Duration = dur })
	end

	function abil:EndChannel(bInterrupted)
		local caster = self:GetCaster()
		caster:RemoveModifierByName("modifier_relentless_spear")
	end
end

relentlesswrapper(cu_chulain_relentless_spear)
relentlesswrapper(cu_chulain_relentless_spear_upgrade)

-------------------------

function modifier_relentless_spear:IsHidden() return true end
function modifier_relentless_spear:IsDebuff() return false end
function modifier_relentless_spear:IsPurgable() return false end
function modifier_relentless_spear:RemoveOnDeath() return true end
function modifier_relentless_spear:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if IsServer() then
	function modifier_relentless_spear:OnCreated(args)
		self.caster = self:GetParent()
		self.target = self:GetAbility().target
		self.DamagePct = args.DamagePct

		self.particles = ParticleManager:CreateParticle("particles/custom/lancer/lancer_relentless_spear/lancer_relentless_spear.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControlEnt(self.particles, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_weapon", self.caster:GetOrigin(), true)	

		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
	end

	function modifier_relentless_spear:OnRefresh(args)
		self:OnDestroy()
		self:OnCreated(args)
	end

	function modifier_relentless_spear:OnIntervalThink()
		if self.target:IsAlive() then
			local caster = self:GetParent()
			local damage = caster:GetAverageTrueAttackDamage(self.target) * self.DamagePct / 100

			DoDamage(caster, self.target, damage, DAMAGE_TYPE_PHYSICAL, 0, self:GetAbility(), false)
			--caster:PerformAttack(self.target, true, true, true, true, false, true, true)
			self.target:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", { Duration = 0.15})
			self.target:EmitSound("Hero_PhantomLancer.Attack")

			--StartAnimation(caster, {duration=0.35, activity=ACT_DOTA_ATTACK , rate=2.5})			
		else
			self:Destroy()
		end
	end

	function modifier_relentless_spear:OnDestroy()
		ParticleManager:DestroyParticle(self.particles, true)
		ParticleManager:ReleaseParticleIndex(self.particles)
	end
end

function modifier_relentless_spear:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE}
end

function modifier_relentless_spear:GetOverrideAnimation()
	if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
		return ACT_DOTA_CAST_ABILITY_2
	elseif self:GetParent():HasModifier("modifier_alternate_01") then 
		return ACT_DOTA_ATTACK
	else
		return ACT_DOTA_ATTACK_EVENT_BASH
	end
end

function modifier_relentless_spear:GetOverrideAnimationRate()
	if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
		return 1.0
	elseif self:GetParent():HasModifier("modifier_alternate_01") then 
		return 2.5
	else
		return 2.5
	end
end

------------------------------------------------ 

function modifier_rune_of_ferocity:IsHidden() 
	if self:GetCaster():HasModifier("modifier_cu_ath_ngabla") then 
		return true 
	else
		return false 
	end
end
function modifier_rune_of_ferocity:IsDebuff() return false end
function modifier_rune_of_ferocity:IsPurgable() return false end
function modifier_rune_of_ferocity:RemoveOnDeath() return true end
function modifier_rune_of_ferocity:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_rune_of_ferocity:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_rune_of_ferocity:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_aspd")
end
function modifier_rune_of_ferocity:GetTexture()
	return "custom/cu_chulain/cu_chulain_rune_ferocity"
end
function modifier_rune_of_ferocity:GetEffectName()
	return "particles/custom/lancer/lancer_rune_blue_glow.vpcf"
end
function modifier_rune_of_ferocity:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

----------------------------------------------- 

function modifier_wesen_window:IsHidden() return true end
function modifier_wesen_window:IsDebuff() return false end
function modifier_wesen_window:IsPurgable() return false end
function modifier_wesen_window:RemoveOnDeath() return true end
function modifier_wesen_window:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if IsServer() then 
    function modifier_wesen_window:OnCreated(args)
        self.caster = self:GetParent()
        self.caster:SwapAbilities(self.caster.ESkill, self.caster.ComboSkill, false, true)
    end

    function modifier_wesen_window:OnDestroy()
        self.caster:SwapAbilities(self.caster.ESkill, self.caster.ComboSkill, true, false)
    end
end