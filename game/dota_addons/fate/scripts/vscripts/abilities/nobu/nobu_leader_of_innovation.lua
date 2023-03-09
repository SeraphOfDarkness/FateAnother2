LinkLuaModifier("modifier_nobu_innovation_aura", "abilities/nobu/nobu_leader_of_innovation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nobu_innovation", "abilities/nobu/nobu_leader_of_innovation", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_nobu_innovation_ms", "abilities/nobu/nobu_leader_of_innovation", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_nobu_innovation_cd", "abilities/nobu/nobu_leader_of_innovation", LUA_MODIFIER_MOTION_NONE)

nobu_leader_of_innovation = class({})

function nobu_leader_of_innovation:OnSpellStart()
    local hCaster = self:GetCaster()
	hCaster:EmitSound("nobu_innovation_cast")
    hCaster:AddNewModifier(hCaster, self, "modifier_nobu_innovation_aura", {duration = self:GetSpecialValueFor("duration")} ) 
    hCaster:AddNewModifier(hCaster, self, "modifier_nobu_innovation_cd", {duration = self:GetCooldown(1)} )
end
 
 

modifier_nobu_innovation_aura = class({})

function modifier_nobu_innovation_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end


function modifier_nobu_innovation_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_nobu_innovation_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_nobu_innovation_aura:GetAuraRadius()
 
		return self:GetAbility():GetSpecialValueFor("aura_radius")  
 
end

function modifier_nobu_innovation_aura:GetModifierAura()
	return "modifier_nobu_innovation"
end

function modifier_nobu_innovation_aura:IsHidden()
	return false
end

function modifier_nobu_innovation_aura:RemoveOnDeath()
	return true
end

function modifier_nobu_innovation_aura:IsDebuff()
	return false 
end

function modifier_nobu_innovation_aura:IsAura()
 		return true
end

function modifier_nobu_innovation_aura:GetAttributes()
    return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
 

modifier_nobu_innovation = class({})
 
function modifier_nobu_innovation:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_nobu_innovation:OnCreated()
	if(self:GetParent() == self:GetCaster()) then
		self:GetCaster().IsReadyToHeal = true  
	end
end

function modifier_nobu_innovation:IsHidden() return true end
function modifier_nobu_innovation:IsDebuff() return false end

function modifier_nobu_innovation:OnTakeDamage(args)
    local parent =self:GetParent()
    local caster = self:GetCaster()
    if(args.attacker == caster)then
		local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("aura_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		for k,v in pairs(targets) do
			v:AddNewModifier(caster, self:GetAbility(), "modifier_nobu_innovation_ms", { duration = self:GetAbility():GetSpecialValueFor("ms_duration") })
			v:FateHeal(self:GetAbility():GetSpecialValueFor("health_base") + (caster:GetStrength() * self:GetAbility():GetSpecialValueFor("bonus_str_heal")),caster,true)
		end
		return 
	end

	if(  args.attacker:GetTeamNumber() == caster:GetTeamNumber() and caster.IsReadyToHeal)then
		caster.IsReadyToHeal = false
		caster:SetHealth(caster:GetHealth() + self:GetAbility():GetSpecialValueFor("health_base") + (caster:GetStrength() * self:GetAbility():GetSpecialValueFor("bonus_str_heal")))
		Timers:CreateTimer(self:GetAbility():GetSpecialValueFor("cooldown"), function()
		caster.IsReadyToHeal = true
		end)

	end
end


modifier_nobu_innovation_ms = class({})
 
function modifier_nobu_innovation_ms:IsHidden() return false end
function modifier_nobu_innovation_ms:IsDebuff() return false end
 
function modifier_nobu_innovation_ms:DeclareFunctions()
	return { 
				MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
				}
end
function modifier_nobu_innovation_ms:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("ms_bonus")
end

modifier_nobu_innovation_cd = class({})


function modifier_nobu_innovation_cd:IsHidden()
    return false 
end

function modifier_nobu_innovation_cd:RemoveOnDeath()
    return false
end

function modifier_nobu_innovation_cd:IsDebuff()
    return true 
end

function modifier_nobu_innovation_cd:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end