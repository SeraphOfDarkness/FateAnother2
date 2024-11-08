modifier_master_invis = class({})

-- Classification --
function modifier_master_invis:IsHidden()
    return true
end

function modifier_master_invis:IsDebuff()
    return true
end

function modifier_master_invis:IsStunDebuff()
    return false
end

function modifier_master_invis:IsPurgable()
    return false
end

function modifier_master_invis:CheckState()
    return { [MODIFIER_STATE_UNSELECTABLE] = true }
end

function modifier_master_invis:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end