modifier_attributes_hp = class({})


function modifier_attributes_hp:GetAttributes()
  return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_attributes_hp:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_HEALTH_BONUS,
  }
  return funcs
end

function modifier_attributes_hp:GetModifierHealthBonus()
--strength * Attributes.hp_adjustment
  --[[if IsServer() then
    local parent = self:GetParent()
    self:SetStackCount(math.abs(math.floor(parent:GetStrength() + 0.5) * parent.hp_adjustment))
  end
  return self:GetStackCount()]]

  if IsServer() then
    local parent = self:GetParent()
    local str = math.ceil(parent:GetStrength())
    --if parent:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
    --  self:SetStackCount(-15.5 * parent:GetStrength())
    --else max 20 hp per str
    if IsValidEntity(parent) and not parent:IsNull() then
      self:SetStackCount(-7 * str)
    end    
  end
  return self:GetStackCount()
end


function modifier_attributes_hp:IsHidden()
  return true
end

function modifier_attributes_hp:IsDebuff()
  return false
end

function modifier_attributes_hp:RemoveOnDeath()
  return false
end
