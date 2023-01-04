hanging_gardens_bombard = class({})

function hanging_gardens_bombard:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function hanging_gardens_bombard:OnSpellStart()
	local caster = self:GetCaster()
	local targetPoint = self:GetCursorPosition()
	local beamAoE = self:GetSpecialValueFor("beam_aoe")
	local damage = self:GetSpecialValueFor("damage")

	EmitSoundOnLocationWithCaster(targetPoint, "Semi.GardenBeamSFX", {})
	EmitSoundOnLocationWithCaster(targetPoint, "Semi.GardenBeamSFX2", {})
	self:DropBeam(targetPoint, beamAoE, damage)
end

function hanging_gardens_bombard:DropBeam(vLoc, fAoE, fDamage)
	local caster = self:GetCaster()

	local targets = FindUnitsInRadius(caster:GetTeam(), vLoc, nil, fAoE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false) 

	for i = 1, #targets do
		DoDamage(caster, targets[i], fDamage, DAMAGE_TYPE_MAGICAL, 0, self, false)
		ApplyDataDrivenModifier(caster, targets[i], "modifier_stunned", {Duration = 0.4})
	end

	local beamFx = ParticleManager:CreateParticle("particles/custom/semiramis/laser_beam.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(beamFx, 0, vLoc)
	ParticleManager:SetParticleControl(beamFx, 1, vLoc)
	ParticleManager:SetParticleControl(beamFx, 5, vLoc)
end