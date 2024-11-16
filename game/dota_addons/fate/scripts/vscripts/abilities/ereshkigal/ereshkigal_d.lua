
ereshkigal_d = class({})
ereshkigal_d_upgrade_1 = class({})
ereshkigal_d_upgrade_2 = class({})
ereshkigal_d_upgrade_3 = class({})
modifier_goddess_of_death_passive = class({})
modifier_ereshkigal_authority = class({})
modifier_ereshkigal_authority_buff = class({})
modifier_ereshkigal_soul = class({})
modifier_ereshkigal_soul_search = class({})
modifier_ereshkigal_soul_search_self = class({})
modifier_ereshkigal_combo_window = class({})

LinkLuaModifier("modifier_goddess_of_death_passive", "abilities/ereshkigal/ereshkigal_d", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_authority", "abilities/ereshkigal/ereshkigal_d", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_authority_buff", "abilities/ereshkigal/ereshkigal_d", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_soul", "abilities/ereshkigal/ereshkigal_d", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_soul_search", "abilities/ereshkigal/ereshkigal_d", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_soul_search_self", "abilities/ereshkigal/ereshkigal_d", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_combo_window", "abilities/ereshkigal/ereshkigal_d", LUA_MODIFIER_MOTION_NONE)

function EreshkigalDWrapper(abil)
	function abil:GetBehavior()
		if self:GetCaster():HasModifier("modifier_ereshkigal_q_use") then 
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET
		else
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
	end

	function abil:GetIntrinsicModifierName()
		return "modifier_goddess_of_death_passive"
	end

	function abil:OnSpellStart()
		self.caster = self:GetCaster()
		if math.ceil(self.caster:GetStrength()) >= 25 and math.ceil(self.caster:GetAgility()) >= 25 and math.ceil(self.caster:GetIntellect()) >= 25 and self.caster:HasModifier("modifier_ereshkigal_q_use") then       
            if self.caster:FindAbilityByName(self.caster.RSkill):IsCooldownReady() and not self.caster:HasModifier("modifier_ereshkigal_combo_cooldown") then
                if string.match(GetMapName(), "fate_elim") then 
					if GameRules:GetGameTime() <= 30 + _G.RoundStartTime or GameRules:GetGameTime() > 115 + _G.RoundStartTime then
						return 
					end
				end
                local remain_time = self.caster:FindModifierByName("modifier_ereshkigal_q_use"):GetRemainingTime()
                self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_combo_window", {Duration = remain_time})
            	self.caster:RemoveModifierByName("modifier_ereshkigal_q_use")
            end
        end
	end

	function abil:CollectSoul(iAmount)
		self.caster = self:GetCaster()
		self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_soul", {})

		local current_stack = self.caster:GetModifierStackCount("modifier_ereshkigal_soul", self.caster) or 0

		if current_stack + iAmount <= 0 then 
			self.caster:RemoveModifierByName("modifier_ereshkigal_soul")
		else
			self.caster:SetModifierStackCount("modifier_ereshkigal_soul", self.caster, current_stack + iAmount)
		end
	end

	function abil:GetCurrentSoul()
		local current_stack = self.caster:GetModifierStackCount("modifier_ereshkigal_soul", self.caster) or 0

		return current_stack
	end

	function abil:ApplyDeathAuthority()
		self.caster = self:GetCaster()
		self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_authority", {})
		if self.caster.IsDivineAcquired then 
			self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_authority_buff", {})
		end
	end

	function abil:LossDeathAuthority()
		self.caster:RemoveModifierByName("modifier_ereshkigal_authority")
		self.caster:RemoveModifierByName("modifier_ereshkigal_authority_buff")
	end

	function abil:SpawnSoul(vLocation)
		self.caster = self:GetCaster()
		local soul_dummy = CreateUnitByName("dummy_unit", vLocation, true, self.caster, self.caster, self.caster:GetTeamNumber())
		local unseen = soul_dummy:FindAbilityByName("dummy_unit_passive")
	    unseen:SetLevel(1)
	    soul_dummy:SetAbsOrigin(vLocation)
		--zone:AddNewModifier(self.caster, nil, "modifier_kill", {duration = self:GetSpecialValueFor("soul_duration")})
		soul_dummy:AddNewModifier(self.caster, self, "modifier_ereshkigal_soul_search", {Duration = self:GetSpecialValueFor("soul_duration"),
																					Radius = self:GetSpecialValueFor("soul_search")})	
	end
end

EreshkigalDWrapper(ereshkigal_d)
EreshkigalDWrapper(ereshkigal_d_upgrade_1)
EreshkigalDWrapper(ereshkigal_d_upgrade_2)
EreshkigalDWrapper(ereshkigal_d_upgrade_3)

--------------------------------------

function modifier_goddess_of_death_passive:IsHidden() return false end
function modifier_goddess_of_death_passive:IsDebuff()
	if self:GetParent():HasModifier("modifier_ereshkigal_authority") then 
		return false 
	else
		return true 
	end
end
function modifier_goddess_of_death_passive:IsPassive() return true end
function modifier_goddess_of_death_passive:IsPurgable() return false end
function modifier_goddess_of_death_passive:RemoveOnDeath() return false end
function modifier_goddess_of_death_passive:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_goddess_of_death_passive:DeclareFunctions()
	return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE}
end
function modifier_goddess_of_death_passive:GetModifierTotalDamageOutgoing_Percentage()
	if self:GetParent():HasModifier("modifier_ereshkigal_authority") then 
		return self:GetAbility():GetSpecialValueFor("hell_bonus_dmg")
	else
		return self:GetAbility():GetSpecialValueFor("non_hell_dmg")
	end
end

-------------------------------------- เพิ่ม STR AGI INT ตาม Soul stacks

function modifier_ereshkigal_soul:IsHidden() return false end
function modifier_ereshkigal_soul:IsDebuff() return false end
function modifier_ereshkigal_soul:IsPurgable() return false end
function modifier_ereshkigal_soul:RemoveOnDeath() return false end
function modifier_ereshkigal_soul:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_ereshkigal_soul:GetTexture()
	return "custom/ereshkigal/ereshkigal_soul"
end
function modifier_ereshkigal_soul:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_EVENT_ON_DEATH,
			MODIFIER_EVENT_ON_ABILITY_EXECUTED,}
end

function modifier_ereshkigal_soul:GetModifierBonusStats_Strength()
	if self:GetParent():HasModifier("modifier_ereshkigal_authority") then 
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("hell_bonus_stat")
	else
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("non_hell_bonus_stat")
	end
end

function modifier_ereshkigal_soul:GetModifierBonusStats_Agility()
	if self:GetParent():HasModifier("modifier_ereshkigal_authority") then 
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("hell_bonus_stat")
	else
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("non_hell_bonus_stat")
	end
end

function modifier_ereshkigal_soul:GetModifierBonusStats_Intellect()
	if self:GetParent():HasModifier("modifier_ereshkigal_authority") then 
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("hell_bonus_stat")
	else
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("non_hell_bonus_stat")
	end
end

function modifier_ereshkigal_soul:OnDeath(args)
	if args.unit ~= self:GetParent() then return end

	local caster = self:GetParent()

	local current_soul = self:GetStackCount()
	self:GetAbility():CollectSoul( -math.ceil(self:GetAbility():GetSpecialValueFor("soul_loss")/100 * current_soul))
end 

function modifier_ereshkigal_soul:OnAbilityExecuted(args)
	if args.unit ~= self:GetParent() then return end

	if args.ability:IsItem() then return end

	self.caster = self:GetParent()

	if not self.caster:HasModifier("modifier_ereshkigal_authority") then return end

	if not self.caster.IsCrownAcquired then return end

	local soul_consume = 0

	if string.match(args.ability:GetAbilityName(), "ereshkigal_q") then 
		soul_consume = self:GetAbility():GetSpecialValueFor("q_consume")
	elseif string.match(args.ability:GetAbilityName(), "ereshkigal_w") then 
		soul_consume = self:GetAbility():GetSpecialValueFor("w_consume")
	elseif string.match(args.ability:GetAbilityName(), "ereshkigal_e") then 
		soul_consume = self:GetAbility():GetSpecialValueFor("e_consume")
	elseif string.match(args.ability:GetAbilityName(), "ereshkigal_r") then 
		soul_consume = self:GetAbility():GetSpecialValueFor("r_consume")
	end

	if self:GetStackCount() >= soul_consume then 
		Timers:CreateTimer(0.066, function()
			args.ability:EndCooldown()
			self:GetAbility():CollectSoul(-soul_consume)
		end)
	end
end

------------------------------------

function modifier_ereshkigal_authority:IsHidden() return false end
function modifier_ereshkigal_authority:IsDebuff() return false end
function modifier_ereshkigal_authority:IsPurgable() return false end
function modifier_ereshkigal_authority:RemoveOnDeath() return true end
function modifier_ereshkigal_authority:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_ereshkigal_authority:DeclareFunctions()
	return {MODIFIER_PROPERTY_MANACOST_REDUCTION_CONSTANT,}
end
function modifier_ereshkigal_authority:GetTexture()
	return "custom/ereshkigal/ereshkigal_authority"
end
function modifier_ereshkigal_authority:GetEffectName()
	return ""
end
function modifier_ereshkigal_authority:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
if IsServer() then
	function modifier_ereshkigal_authority:OnCreated(args)
		self.caster = self:GetParent()
	end

	function modifier_ereshkigal_authority:OnRefresh(args)
		self:OnCreated(args)
	end

	function modifier_ereshkigal_authority:OnDestroy()
	end
end

function modifier_ereshkigal_authority:GetModifierManacostReduction_Constant(event)

	if string.match(event.ability:GetAbilityName(), "ereshkigal_w") or string.match(event.ability:GetAbilityName(), "ereshkigal_e") or string.match(event.ability:GetAbilityName(), "ereshkigal_r") then 
		return event.ability:GetManaCost(1) * self:GetAbility():GetSpecialValueFor("hell_mana_cost") / 100 
	end
end

------------------------------- 

function modifier_ereshkigal_authority_buff:IsHidden() return true end
function modifier_ereshkigal_authority_buff:IsDebuff() return false end
function modifier_ereshkigal_authority_buff:IsPurgable() return false end
function modifier_ereshkigal_authority_buff:RemoveOnDeath() return true end
function modifier_ereshkigal_authority_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_ereshkigal_authority_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,}
end
function modifier_ereshkigal_authority_buff:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("hell_bonus_regen")
end
function modifier_ereshkigal_authority_buff:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("hell_bonus_regen")
end
function modifier_ereshkigal_authority_buff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("hell_bonus_def")
end
function modifier_ereshkigal_authority_buff:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("hell_bonus_def")
end
function modifier_ereshkigal_authority_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("hell_bonus_ms")
end


------------------------- 

function modifier_ereshkigal_soul_search:IsHidden() return false end
function modifier_ereshkigal_soul_search:IsDebuff() return false end
function modifier_ereshkigal_soul_search:IsPurgable() return false end
function modifier_ereshkigal_soul_search:RemoveOnDeath() return true end
function modifier_ereshkigal_soul_search:IsAura() return true end
function modifier_ereshkigal_soul_search:IsAuraActiveOnDeath() return false end
function modifier_ereshkigal_soul_search:GetAuraRadius()
	return self.radius
end
function modifier_ereshkigal_soul_search:GetAuraEntityReject(hEntity)
	if hEntity == self:GetCaster() then 
		return false 
	else
		return true 
	end
end
function modifier_ereshkigal_soul_search:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_ereshkigal_soul_search:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end
function modifier_ereshkigal_soul_search:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifier_ereshkigal_soul_search:GetModifierAura()
	return "modifier_ereshkigal_soul_search_self"
end
function modifier_ereshkigal_soul_search:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if IsServer() then
	function modifier_ereshkigal_soul_search:OnCreated(args)
		self.caster = self:GetCaster()
		self.soul_dummy = self:GetParent()
		self.radius = args.Radius
		self:GenerateSoulFX()
	end

	function modifier_ereshkigal_soul_search:OnDestroy()
		self:DestroySoulFX()
		if IsValidEntity(self.soul_dummy) then 
			self.soul_dummy:ForceKill(false)
		end
	end


	function modifier_ereshkigal_soul_search:GenerateSoulFX()
		self.soul_fx = ParticleManager:CreateParticleForPlayer("particles/custom/ereshkigal/ereshkigal_soul.vpcf", PATTACH_CUSTOMORIGIN, self.soul_dummy, self.caster:GetPlayerOwner())
		ParticleManager:SetParticleControl(self.soul_fx, 0, self.soul_dummy:GetAbsOrigin())
	end

	function modifier_ereshkigal_soul_search:DestroySoulFX()
		ParticleManager:DestroyParticle(self.soul_fx, true)
		ParticleManager:ReleaseParticleIndex(self.soul_fx)
	end
end

function modifier_ereshkigal_soul_search:PlayCollectSoulFX()
	local collect_fx = ParticleManager:CreateParticle("particles/custom/ereshkigal/ereshkigal_soul_collect.vpcf", PATTACH_CUSTOMORIGIN, target)    
	ParticleManager:SetParticleControlEnt(collect_fx, 0, self.soul_dummy, PATTACH_POINT_FOLLOW, "attach_hitloc", self.soul_dummy:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(collect_fx, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)    
	ParticleManager:SetParticleControl(collect_fx, 2, Vector(2000,0,0))
	Timers:CreateTimer(0.1, function()
		ParticleManager:DestroyParticle(collect_fx, true)
		ParticleManager:ReleaseParticleIndex(collect_fx)
	end)
	self:Destroy()
end

--------------------------------------- modifier_ereshkigal_soul_search_self

function modifier_ereshkigal_soul_search_self:IsHidden() return true end
function modifier_ereshkigal_soul_search_self:IsDebuff() return false end
function modifier_ereshkigal_soul_search_self:IsPurgable() return false end
function modifier_ereshkigal_soul_search_self:RemoveOnDeath() return true end
function modifier_ereshkigal_soul_search_self:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_ereshkigal_soul_search_self:OnCreated(args)
	self.caster = self:GetParent()
	if IsServer() then
		local soul_dummy = self:GetAuraOwner()
		local aura = soul_dummy:FindModifierByName("modifier_ereshkigal_soul_search")
		aura:PlayCollectSoulFX()
	end
	self:GetAbility():CollectSoul(1)
end

function modifier_ereshkigal_soul_search_self:OnDestroy()
	
end

------------- 

function modifier_ereshkigal_combo_window:IsHidden() return true end
function modifier_ereshkigal_combo_window:IsDebuff() return false end
function modifier_ereshkigal_combo_window:IsPurgable() return false end
function modifier_ereshkigal_combo_window:RemoveOnDeath() return true end
function modifier_ereshkigal_combo_window:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if IsServer() then 
    function modifier_ereshkigal_combo_window:OnCreated(args)
        self.caster = self:GetParent()
        self.caster:SwapAbilities(self.caster.RSkill, self.caster.ComboSkill, false, true)
    end

    function modifier_ereshkigal_combo_window:OnDestroy()
        self.caster:SwapAbilities(self.caster.RSkill, self.caster.ComboSkill, true, false)
    end
end













