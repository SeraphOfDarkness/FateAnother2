LinkLuaModifier("modifier_nobu_charisma_aura", "abilities/nobu/nobu_charisma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nobu_charisma", "abilities/nobu/nobu_charisma", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_nobu_strategy_attribute", "abilities/nobu/nobu_charisma", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_nobu_strategy_attribute_cooldown", "abilities/nobu/nobu_charisma", LUA_MODIFIER_MOTION_NONE) 
nobu_charisma = class({})
nobu_strat = class({})

function nobu_charisma:GetIntrinsicModifierName()
	return "modifier_nobu_charisma_aura"
end

function nobu_strat:ApplyStrategy()
	local caster = self:GetCaster()
	local cooldown = self:GetSpecialValueFor("cooldown_time")
	local duration = self:GetSpecialValueFor("duration")
	local bonus_ms = self:GetSpecialValueFor("bonus_ms")
	local bonus_attack = self:GetSpecialValueFor("bonus_attack")

	caster.IsStrategyReady = false
	caster:AddNewModifier(caster, self, "modifier_nobu_strategy_attribute", {Attack= bonus_attack, MS= bonus_ms, Duration = duration} )

	caster:AddNewModifier(caster, self, "modifier_nobu_strategy_attribute_cooldown", {duration = cooldown} )
	Timers:CreateTimer("nobu_strategy", {
		endTime = cooldown,
		callback = function()
			caster.IsStrategyReady = true
	return end
	})
end


modifier_nobu_charisma_aura = class({})

function modifier_nobu_charisma_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_nobu_charisma_aura:DeclareFunctions()
	return {	MODIFIER_EVENT_ON_RESPAWN   }
end

function modifier_nobu_charisma_aura:OnRespawn(args)
 local caster = self:GetCaster()
 if(caster ~= args.unit) then return end
 caster.ISDOW = false
 caster.isCharisma = false
 local ind5abilityname = caster:GetAbilityByIndex(4):GetName()
 caster:GetAbilityByIndex(1):RefreshCharges()
 if(ind5abilityname ~= "nobu_demon_king_close" and ind5abilityname ~= caster.FSkill ) then 
 
	 caster:SwapAbilities(ind5abilityname, caster.FSkill, false, true)   
 end
end


function modifier_nobu_charisma_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_nobu_charisma_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_nobu_charisma_aura:GetAuraRadius()
 
		return self:GetAbility():GetSpecialValueFor("aura_radius")  
 
end

function modifier_nobu_charisma_aura:GetModifierAura()
	return "modifier_nobu_charisma"
end

function modifier_nobu_charisma_aura:IsHidden()
	return true
end

function modifier_nobu_charisma_aura:RemoveOnDeath()
	return false
end

function modifier_nobu_charisma_aura:IsDebuff()
	return false 
end

function modifier_nobu_charisma_aura:IsAura()
	if(self:GetCaster().isCharisma) then 
		return true
	else
		return false
	end
end

function modifier_nobu_charisma_aura:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--

modifier_nobu_charisma = class({})

function modifier_nobu_charisma:IsHidden() return false end
function modifier_nobu_charisma:IsDebuff() return false end
function modifier_nobu_charisma:DeclareFunctions()
	return {	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
 	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,   }
end

function modifier_nobu_charisma:GetModifierMoveSpeedBonus_Percentage()
	return  self:GetAbility():GetSpecialValueFor("ms_bonus"); 
end
function modifier_nobu_charisma:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_bonus");  
end
 

modifier_nobu_strategy_attribute = class({})

function modifier_nobu_strategy_attribute:IsHidden() return false end
function modifier_nobu_strategy_attribute:IsDebuff() return false end
function modifier_nobu_strategy_attribute:OnCreated(args)
	self.MS = args.MS
	self.ATK = args.Attack
end
function modifier_nobu_strategy_attribute:DeclareFunctions()
	return {	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
  }
end

function modifier_nobu_strategy_attribute:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_ms");  
end

function modifier_nobu_strategy_attribute:GetModifierPreAttack_BonusDamage()
	return  self:GetAbility():GetSpecialValueFor("bonus_attack");  
end

--[[function modifier_nobu_strategy_attribute:GetDuration()
	return  4  
end]]
 

function modifier_nobu_strategy_attribute:GetTexture()
	return  "custom/nobu/nobu_strategy_attribute"
end



modifier_nobu_strategy_attribute_cooldown = class({})

function modifier_nobu_strategy_attribute_cooldown:IsHidden() return false end
function modifier_nobu_strategy_attribute_cooldown:IsDebuff() return true end
 
function modifier_nobu_strategy_attribute_cooldown :GetTexture()
	return  "custom/nobu/nobu_strategy_attribute"
end

 
 