
ishtar_d = class({})
ishtar_d_upgrade = class({})
ishtar_f = class({})
ishtar_f_upgrade = class({})
modifier_ishtar_gem = class({})
modifier_ishtar_gem_consume = class({})
modifier_ishtar_mana_burst_gem = class({})
modifier_ishtar_mana_burst_debuff = class({})

LinkLuaModifier("modifier_ishtar_gem", "abilities/ishtar/ishtar_d", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ishtar_gem_consume", "abilities/ishtar/ishtar_d", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ishtar_mana_burst_gem", "abilities/ishtar/ishtar_d", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ishtar_mana_burst_debuff", "abilities/ishtar/ishtar_d", LUA_MODIFIER_MOTION_NONE)

function ishtar_d_wrapper(abil)
	function abil:GetBehavior()
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE
	end

	function abil:GetIntrinsicModifierName()
		return "modifier_ishtar_gem"
	end

	function abil:GetManaCost(iLevel)
		return 50
	end

	function abil:GetGoldCost(iLevel)
		return self:GetSpecialValueFor("gem_cost")
	end

	function abil:GetCastAnimation()
		return ACT_DOTA_ITEM_LOOK
	end

	function abil:CastFilterResult()
		local caster = self:GetCaster()

		if caster.IsGemsAcquired then 
			return UF_SUCCESS
		elseif caster:GetGold() < self:GetSpecialValueFor("gem_cost") then
			return UF_FAIL_CUSTOM	
		else
			if caster:GetModifierStackCount("modifier_ishtar_gem", caster) >= self:GetSpecialValueFor("max_gem") then 
				return UF_FAIL_CUSTOM
			else
				return UF_SUCCESS
			end
		end
	end

	function abil:GetCustomCastError()
		if self:IsMaxGem() then 
			return "Gems reach maximum stacks."
		else
			return "Not enough gold."
		end
	end

	function abil:GetIntrinsicModifierName()
		return "modifier_ishtar_gem"
	end

	function abil:OnSpellStart()
		local caster = self:GetCaster()
		caster:SpendGold(self:GetSpecialValueFor("gem_cost"), 0)
		self:AddGem(self:GetSpecialValueFor("gem_gain"))
	end

	if IsServer() then
		function abil:AddGem(iGemGain)
			local caster = self:GetCaster()
			
			if (iGemGain < 0) or (iGemGain > 0 and not self:IsMaxGem()) then
				local gem = caster:FindModifierByName("modifier_ishtar_gem")
				gem:SetStackCount(math.max(gem:GetStackCount() + iGemGain, 0))
				if gem:GetStackCount() <= 0 then 
					if caster:HasModifier("modifier_ishtar_gem_consume") then 
						caster:FindAbilityByName(caster.FSkill):ToggleAbility()
					end
				end
			end
		end

		function abil:GetCurrentGem()
			local caster = self:GetCaster()
			local stack = caster:FindModifierByName("modifier_ishtar_gem") and caster:FindModifierByName("modifier_ishtar_gem"):GetStackCount() or 0 
			return stack
		end

		function abil:IsMaxGem()
			local caster = self:GetCaster()

			if caster.IsGemsAcquired then 
				return false 
			else 
				local current_stack = caster:GetModifierStackCount("modifier_ishtar_gem", caster) or 0

				if current_stack >= self:GetSpecialValueFor("max_gem") then 
					return true 
				else
					return false 
				end
			end
		end
	end
end

ishtar_d_wrapper(ishtar_d)
ishtar_d_wrapper(ishtar_d_upgrade)

---------------------------------------

function modifier_ishtar_gem:IsPassive() return true end
function modifier_ishtar_gem:IsDebuff() return false end
function modifier_ishtar_gem:IsHidden() return false end
function modifier_ishtar_gem:RemoveOnDeath() return false end
function modifier_ishtar_gem:IsPurgable() return false end
function modifier_ishtar_gem:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_ishtar_gem:OnDeath()
	local current_gem = self:GetAbility():GetCurrentGem()
	self:GetAbility():AddGem( -math.floor(self:GetAbility():GetSpecialValueFor("gem_loss") * current_gem))
end

----------------------------------------

function ishtar_f_wrapper(abil)
	function abil:GetBehavior()
		return DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE
	end

	function abil:GetIntrinsicModifierName()
		if string.match(self:GetAbilityName(), "upgrade") then
			return "modifier_ishtar_mana_burst_gem"
		else
			return nil
		end
	end

	function abil:ResetToggleOnRespawn()
		return true 
	end

	function abil:GetCastAnimation()
		return ACT_DOTA_ITEM_LOOK 
	end

	function abil:CastFilterResult()
		local caster = self:GetCaster()

		if caster:GetModifierStackCount("modifier_ishtar_gem", caster) <= 0 then 
			return UF_FAIL_CUSTOM
		else
			return UF_SUCCESS
		end
	end

	function abil:GetCustomCastError()
		return "Not enough Gems."
	end

	function abil:OnToggle()
		local caster = self:GetCaster()

		if not self:GetToggleState() and caster:HasModifier("modifier_ishtar_gem_consume") then 
			caster:RemoveModifierByName("modifier_ishtar_gem_consume")
		else
			if caster:GetModifierStackCount("modifier_ishtar_gem", caster) > 0 then
				caster:AddNewModifier(caster, self, "modifier_ishtar_gem_consume", {})
			else
				self:ToggleAbility()
			end
		end
	end

	function abil:AddManaBurstDebuff(hTarget)
		if self:GetCaster().IsManaBurstGemAcquired then 
			local caster = self:GetCaster()
			local max_stack = self:GetSpecialValueFor("f_stack")

			hTarget:AddNewModifier(caster, self, "modifier_ishtar_mana_burst_debuff", {Duration = self:GetSpecialValueFor("f_duration")})

			local debuff = hTarget:FindModifierByName("modifier_ishtar_mana_burst_debuff")
			debuff:SetStackCount(debuff:GetStackCount() + 1)

			if debuff:GetStackCount() >= max_stack then 
				hTarget:RemoveModifierByName("modifier_ishtar_mana_burst_debuff")
				if not IsImmuneToCC(hTarget) then
					hTarget:AddNewModifier(caster, self, "modifier_stunned", {Duration = self:GetSpecialValueFor("f_stun")})
				end
				DoDamage(caster, hTarget, self:GetSpecialValueFor("f_damage"), DAMAGE_TYPE_MAGICAL, 0, self, false)
			end
		end
	end
end

ishtar_f_wrapper(ishtar_f)
ishtar_f_wrapper(ishtar_f_upgrade)

-----------------------------------------

function modifier_ishtar_gem_consume:IsPassive() return false end
function modifier_ishtar_gem_consume:IsDebuff() return false end
function modifier_ishtar_gem_consume:IsHidden() return false end
function modifier_ishtar_gem_consume:IsPurgable() return false end
function modifier_ishtar_gem_consume:RemoveOnDeath() return false end
function modifier_ishtar_gem_consume:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

-----------------------------------------

function modifier_ishtar_mana_burst_gem:IsPassive() return true end
function modifier_ishtar_mana_burst_gem:IsDebuff() return false end
function modifier_ishtar_mana_burst_gem:IsHidden() return false end
function modifier_ishtar_mana_burst_gem:IsPurgable() return false end
function modifier_ishtar_mana_burst_gem:RemoveOnDeath() return false end
function modifier_ishtar_mana_burst_gem:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_ishtar_mana_burst_gem:DeclareFunctions()
    return {MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL, MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE}
end
function modifier_ishtar_mana_burst_gem:GetModifierOverrideAbilitySpecial(event)
	local caster = self:GetParent()
    if event.ability == caster:FindAbilityByName(caster.QSkill) then
        if event.ability_special_value == "gem_arrow" then
            return 1
        end
    elseif event.ability == caster:FindAbilityByName(caster.WSkill) then
        if event.ability_special_value == "gem_reduction" then
            return 1
        end
   	elseif event.ability == caster:FindAbilityByName(caster.ESkill) then
        if event.ability_special_value == "gem_arrows" or event.ability_special_value == "max_arrow" then
            return 1
        end
    elseif event.ability == caster:FindAbilityByName(caster.RSkill) then
        if event.ability_special_value == "gem_arrow_damage" then
            return 1
        end
    elseif event.ability == caster:FindAbilityByName(caster.ComboSkill) then
        if event.ability_special_value == "gem_damage" then
            return 1
        end
    end
    return 0
end

function modifier_ishtar_mana_burst_gem:GetModifierOverrideAbilitySpecialValue(event)	
	local caster = self:GetParent()
	local Ability =self:GetAbility()
    if event.ability == caster:FindAbilityByName(caster.QSkill) and event.ability_special_value == "gem_arrow" then
        return Ability and Ability:GetSpecialValueFor("q_arrow")
    elseif event.ability == caster:FindAbilityByName(caster.WSkill) and event.ability_special_value == "gem_reduction" then
        return Ability and Ability:GetSpecialValueFor("w_bonus_block")
    elseif event.ability == caster:FindAbilityByName(caster.ESkill) and event.ability_special_value == "gem_arrows" then
        return Ability and Ability:GetSpecialValueFor("e_arrows")
    elseif event.ability == caster:FindAbilityByName(caster.ESkill) and event.ability_special_value == "max_arrow" then
        return Ability and Ability:GetSpecialValueFor("e_max")
    elseif event.ability == caster:FindAbilityByName(caster.RSkill) and event.ability_special_value == "gem_arrow_damage" then
        return Ability and Ability:GetSpecialValueFor("r_arrow_damage")
    elseif event.ability == caster:FindAbilityByName(caster.ComboSkill) and event.ability_special_value == "gem_damage" then
        return Ability and Ability:GetSpecialValueFor("c_damage")
    end
    return 0
end

-----------------------------------------

function modifier_ishtar_mana_burst_debuff:IsPassive() return false end
function modifier_ishtar_mana_burst_debuff:IsDebuff() return true end
function modifier_ishtar_mana_burst_debuff:IsHidden() return false end
function modifier_ishtar_mana_burst_debuff:IsPurgable() return false end
function modifier_ishtar_mana_burst_debuff:RemoveOnDeath() return true end
function modifier_ishtar_mana_burst_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end