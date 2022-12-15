modifier_courage_enemy_debuff = class({})

if IsServer() then
	function modifier_courage_enemy_debuff:OnCreated(args)	
		self:SetStackCount(args.Stacks or 1)		
	end

	function modifier_courage_enemy_debuff:OnRefresh(args)		
		self:OnCreated(args)
	end
end

function modifier_courage_enemy_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			 MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
end

function modifier_courage_enemy_debuff:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage_reduction")
end 

function modifier_courage_enemy_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_reduction") * self:GetStackCount()
end

function modifier_courage_enemy_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_courage_enemy_debuff:IsHidden()
	return false
end

function modifier_courage_enemy_debuff:IsDebuff()
	return true
end

function modifier_courage_enemy_debuff:RemoveOnDeath()
	return true
end

function modifier_courage_enemy_debuff:GetAttributes()
  return MODIFIER_ATTRIBUTE_NONE
end

function modifier_courage_enemy_debuff:GetTexture()
	return "custom/berserker_5th_courage"
end