cu_chulain_protection_from_arrows = class({})
modifier_protection_from_arrows = class({})
modifier_protection_from_arrows_active = class({})
modifier_protection_from_arrows_cooldown = class({})

LinkLuaModifier("modifier_protection_from_arrows", "abilities/cu_chulain/cu_chulain_protection_from_arrows", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_protection_from_arrows_active", "abilities/cu_chulain/cu_chulain_protection_from_arrows", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_protection_from_arrows_cooldown", "abilities/cu_chulain/cu_chulain_protection_from_arrows", LUA_MODIFIER_MOTION_NONE)

function cu_chulain_protection_from_arrows:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
		return "custom/yukina/yukina_arrow"
	else
		return "custom/cu_chulain/cu_chulain_protection_from_arrows"
	end
end

function cu_chulain_protection_from_arrows:OnSpellStart()
	local caster = self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_protection_from_arrows_active", { Duration = self:GetSpecialValueFor("duration") })
	caster:AddNewModifier(caster, self, "modifier_protection_from_arrows_cooldown", { Duration = self:GetCooldown(1) })

	if caster:HasModifier("modifier_alternate_04") or caster:HasModifier("modifier_alternate_05") then 
		caster:EmitSound("Yukina_D")
	else
		caster:EmitSound("Cu_Skill_" .. math.random(1,4))
	end
end

function cu_chulain_protection_from_arrows:GetIntrinsicModifierName()
	return "modifier_protection_from_arrows"
end

---------------------------

function modifier_protection_from_arrows:IsHidden() return false end
function modifier_protection_from_arrows:IsDebuff() return false end
function modifier_protection_from_arrows:IsPassive() return true end
function modifier_protection_from_arrows:IsPurgable() return false end
function modifier_protection_from_arrows:RemoveOnDeath() return false end
function modifier_protection_from_arrows:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_protection_from_arrows:DeclareFunctions()
	return { MODIFIER_PROPERTY_EVASION_CONSTANT,
			 MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK }
end
function modifier_protection_from_arrows:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor("evasion")
end
function modifier_protection_from_arrows:GetModifierPhysical_ConstantBlock()
	return self:GetAbility():GetSpecialValueFor("damage_reduc")
end

-----------------------------------

function modifier_protection_from_arrows_active:IsHidden() return false end
function modifier_protection_from_arrows_active:IsDebuff() return false end
function modifier_protection_from_arrows_active:IsPurgable() return false end
function modifier_protection_from_arrows_active:RemoveOnDeath() return true end
function modifier_protection_from_arrows_active:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_protection_from_arrows_active:DeclareFunctions()
	return { MODIFIER_PROPERTY_DODGE_PROJECTILE,
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE}
end
function modifier_protection_from_arrows_active:GetModifierDodgeProjectile()
	return 1 
end
function modifier_protection_from_arrows_active:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end
function modifier_protection_from_arrows_active:GetOverrideAnimationRate()
	return 0.45 
end
function modifier_protection_from_arrows_active:GetEffectName()
	if self:GetParent():HasModifier("modifier_alternate_05") then 
		return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_ambient_v2.vpcf"
	else
		return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_ambient.vpcf"
	end
end
function modifier_protection_from_arrows_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-----------------------

function modifier_protection_from_arrows_cooldown:IsHidden() return false end
function modifier_protection_from_arrows_cooldown:IsDebuff() return true end
function modifier_protection_from_arrows_cooldown:IsPurgable() return false end
function modifier_protection_from_arrows_cooldown:RemoveOnDeath() return false end
function modifier_protection_from_arrows_cooldown:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

