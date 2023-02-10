LinkLuaModifier("modifier_ascended", LUA_MODIFIER_MOTION_NONE)

ascension_skill = class ({})
function ascension_skill:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_ascended", {})
end

undoascension_skill = class ({})

function undoascension_skill:OnSpellStart()
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_ascended")
end

modifier_ascended = class({})

function modifier_ascended:IsHidden()
	return false
end

function modifier_ascended:IsDebuff()
	return false
end

function modifier_ascended:IsPermanent()
	return true
end

function modifier_ascended:IsPurgable()
	return false
end

function modifier_ascended:IsPurgeException()
	return false
end