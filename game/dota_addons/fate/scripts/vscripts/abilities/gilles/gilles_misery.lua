gilles_misery = class({})
modifier_gilles_misery = class({})

LinkLuaModifier("modifier_gilles_misery", "abilities/gilles/gilles_misery", LUA_MODIFIER_MOTION_NONE)

--[[function gilles_misery:GetManaCost(iLevel)
	return (self:GetCaster():GetMaxMana() * self:GetSpecialValueFor("mana_cost") / 100)
end]]

function gilles_misery:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function gilles_misery:IsHiddenAbilityCastable()
	return true
end

function gilles_misery:OnSpellStart()
	local hCaster = self:GetCaster()
	local vTargetLocation = self:GetCursorPosition()
	
	EmitSoundOnLocationWithCaster(vTargetLocation, "Gilles_Misery_Cast", hCaster)

	local tEnemies = FindUnitsInRadius(hCaster:GetTeam(), vTargetLocation, nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		
	for _,v in pairs(tEnemies) do
		
		if IsValidEntity(v) and not v:IsNull() and not v:IsMagicImmune() then
			v:AddNewModifier(hCaster, self, "modifier_gilles_misery", { Duration =  self:GetSpecialValueFor("duration") + 0.033})
		end
	end
end

function modifier_gilles_misery:DeclareFunctions()
	return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end

if IsServer() then 
	function modifier_gilles_misery:OnCreated(args)
		self.target = self:GetParent()
		if self.target.ParticleIndex == nil then
			self.target.ParticleIndex = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_staff_hellborn/warlock_upheaval_hellborn_debuff", PATTACH_ABSORIGIN_FOLLOW, self.target)
	 		ParticleManager:SetParticleControl(self.target.ParticleIndex, 0, self.target:GetAbsOrigin())
	 	end
 		self:SetStackCount(1)
	end

	function modifier_gilles_misery:OnRefresh(args)
		self:SetStackCount(1)
	end

	function modifier_gilles_misery:OnDestroy()
		if self.target.ParticleIndex ~= nil then
			ParticleManager:DestroyParticle( self.target.ParticleIndex, false )
	        ParticleManager:ReleaseParticleIndex( self.target.ParticleIndex )
		end
	end

	function modifier_gilles_misery:OnTakeDamage(args)
		if args.unit ~= self.target then return end

		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()

		if not IsValidEntity(self.target) or self.target:IsNull() or not self.target:IsAlive() then return end
		
		self.target:AddNewModifier(hCaster, hAbility, "modifier_stunned", { Duration = 0.033 * self:GetStackCount()})
	end
end

function modifier_gilles_misery:IsDebuff()
	return true
end

function modifier_gilles_misery:IsHidden() 
	return false 
end

function modifier_gilles_misery:GetTexture()
	return "custom/gilles/gilles_misery"
end