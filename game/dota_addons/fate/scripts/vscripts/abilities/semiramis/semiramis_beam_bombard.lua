semiramis_beam_bombard = class({})

function semiramis_beam_bombard:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("cast_range")
end

function semiramis_beam_bombard:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function semiramis_beam_bombard:OnSpellStart()
	local caster = self:GetCaster()
	local targetPoint = self:GetCursorPosition()
	local beam_numbers = self:GetSpecialValueFor("beam_numbers")
	local beamAoE = self:GetSpecialValueFor("beam_aoe")
	local damage = self:GetSpecialValueFor("damage")
	local cast_delay = self:GetSpecialValueFor("cast_delay")
	local curBeam = 1

   	caster:EmitSound("Semi.CasterE")

	Timers:CreateTimer(cast_delay,function()
		local cast_spot = caster:GetAbsOrigin()
		local magic_circle_loc = cast_spot + Vector(RandomInt(-230,230), RandomInt(-230,230), RandomInt(80,220))
		

		self.Dummy = CreateUnitByName("dummy_unit", targetPoint, false, caster, caster, caster:GetTeamNumber())
		self.Dummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1)

		Timers:CreateTimer(function()
			if curBeam <= beam_numbers then
				curBeam = curBeam + 1

				local beamLoc = RandomPointInCircle(targetPoint, self:GetAOERadius())

				self:DropBeam(magic_circle_loc, beamLoc, beamAoE, damage)
				local groundFx = ParticleManager:CreateParticle("particles/econ/items/lion/lion_ti8/lion_spell_finger_ti8_crystals.vpcf", PATTACH_CUSTOMORIGIN, self.Dummy)
				ParticleManager:SetParticleControl(groundFx, 0, magic_circle_loc)
				ParticleManager:SetParticleControl(groundFx, 5, magic_circle_loc)
				ParticleManager:SetParticleControl(groundFx, 6, magic_circle_loc)
				
   				caster:EmitSound("Semi.CasterESFX")

				magic_circle_loc = cast_spot + Vector(RandomInt(-230,230), RandomInt(-230,230), RandomInt(80,220))
				
				return 0.1
			else
				self.Dummy:RemoveSelf()
				
				return
			end			
		end)
	end)
end

function semiramis_beam_bombard:DropBeam(magic_circle_loc,vLoc, fAoE, fDamage)

	Timers:CreateTimer(RandomFloat(0.17, 0.24), function()
		local caster = self:GetCaster()

		local targets = FindUnitsInRadius(caster:GetTeam(), vLoc, nil, fAoE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false) 

		for i = 1, #targets do
			DoDamage(caster, targets[i], fDamage, DAMAGE_TYPE_MAGICAL, 0, self, false)
		end

		magic_circle_loc = magic_circle_loc + RandomVector(40)

		local beamFx = ParticleManager:CreateParticle("particles/semiramis/beam_barrage.vpcf", PATTACH_CUSTOMORIGIN, self.Dummy)
		ParticleManager:SetParticleControl(beamFx, 9, magic_circle_loc)
		ParticleManager:SetParticleControl(beamFx, 1, vLoc)
	end)
end
