
ishtar_e = class({})
ishtar_e_upgrade = class({})

function ishtar_e_wrapper(abil)
	function abil:GetBehavior()
		if self:GetCaster():HasModifier("modifier_ishtar_w_dash") then
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL + DOTA_ABILITY_BEHAVIOR_UNRESTRICTED + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
		else
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
		end
	end

	function abil:GetAOERadius()
		return self:GetSpecialValueFor("aoe")
	end

	function abil:GetManaCost(iLevel)
		return 400
	end

	function abil:GetAbilityTextureName()
		return "custom/ishtar/ishtar_e"
	end

	function abil:GetGemConsume(iMaxGemUse)
		local caster = self:GetCaster()
		local gem_consume = 0
		if caster:HasModifier("modifier_ishtar_gem_consume") then 
			local gem = caster:GetModifierStackCount("modifier_ishtar_gem", caster) or 0
			gem_consume = math.min(iMaxGemUse, gem)
			caster:FindAbilityByName(caster.DSkill):AddGem(-gem_consume)
		end
		return gem_consume
	end

	function abil:OnSpellStart()
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		self.delay = self:GetSpecialValueFor("delay")
		self.damage = self:GetSpecialValueFor("damage")
		self.bonus_damage = 0
		if caster.IsVenusAcquired then 
			self.bonus_damage = self:GetSpecialValueFor("bonus_agi") * caster:GetAgility()
		end
		self.max_range = self:GetSpecialValueFor("max_range")
		self.arrow = self:GetSpecialValueFor("arrow")
		self.max_arrow = self:GetSpecialValueFor("max_arrow")
		self.target_arrow = {}
		self.origin_arrow = {}
		self.gem_consume = 0
		self.arrow_count = 0
		if caster:HasModifier("modifier_ishtar_gem_consume") then
			self.gem_consume = self:GetGemConsume(self:GetSpecialValueFor("gem_consume"))
		end
		self.arrow = self.arrow + (self.gem_consume * self:GetSpecialValueFor("gem_arrow"))
		local enemies_detect = FindUnitsInRadius(caster.GetTeam(), target_loc, nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		Timers:CreateTimer(self.delay/2, function()
			for i = 1, self.arrow do 
				local spawn_loc = 
				self.origin_arrow[i] = spawn_loc
			end
		end)
		Timers:CreateTimer(self.delay, function()
			if caster:IsAlive() then 
				i = 1
				while i <= #enemies_detect do
					if IsValidEntity(enemies_detect[i]) and not enemies_detect[i]:IsNull() then
						if (target_loc - enemy:GetAbsOrigin()) > self.max_range or not enemies_detect[i]:IsAlive() then 
							table.remove(aotkTargets, i)
							i = i - 1
						end
					end
					i = i + 1
				end
				if #enemies_detect >= 1 then
					for j = 1, self.arrow do 
						local random = RandomInt(1, #enemies_detect)
						if not enemies_detect[random]:IsAlive() then 
							table.remove(enemies_detect, random)
							random = RandomInt(1, #enemies_detect)
						end
						self:CreateTrackingProjectile(self.origin_arrow[j], enemies_detect[random])
						if self.target_arrow.enemies_detect[random] == nil then
							self.target_arrow.enemies_detect[random] = 1
						else
							self.target_arrow.enemies_detect[random] = self.target_arrow.enemies_detect[random] + 1
						end

						if self.target_arrow.enemies_detect[random] >= self.max_arrow then 
							table.remove(enemies_detect, random)
						end
						self.arrow_count = self.arrow_count + 1
					end
				end
				if self.arrow_count < self.arrow then 
					for k = self.arrow_count + 1, self.arrow do 
						local random_loc = target_loc + RandomVector(self:GetAOERadius() - 100)
						local distance = (self.origin_arrow[k] - random_loc):Length2D()

						Timers:CreateTimer(distance/self:GetSpecialValueFor("speed"), function()
							local random_target = FindUnitsInRadius(caster:GetTeam(), random_loc, nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
							for k,v in pairs(random_target) do 
								DoDamage(caster, v, self.damage + self.bonus_damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE, self, false)
								if caster.IsManaBurstGemAcquired then 
									caster:FindAbilityByName(caster.FSkill):AddManaBurstDebuff(v)
								end
							end
						end)
					end
				end
			end
		end)
	end

	function abil:CreateTrackingProjectile(vSpawnLoc ,hTarget)

		local arrow = {
			Target = hTarget,
			Source = self:GetCaster(),
			Ability = self,	
			EffectName = "particles/ishtar/ishtar_proj_track.vpcf",
			iMoveSpeed = self:GetSpecialValueFor("speed"),
			vSourceLoc= vSpawnLoc,
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = false,
			flExpireTime = GameRules:GetGameTime() + 3,	
		}

		ProjectileManager:CreateTrackingProjectile(arrow)
	end

	function abil:OnProjectileHit(hTarget, vLocation)
		if hTarget == nil then return end

		local caster = self:GetCaster()
		local damage = self:GetSpecialValueFor("damage")
		local bonus_damage = 0
		if caster.IsVenusAcquired then 
			bonus_damage = self:GetSpecialValueFor("bonus_agi") * caster:GetAgility()
		end
		DoDamage(caster, hTarget, damage + bonus_damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE, self, false)
		if caster.IsManaBurstGemAcquired then 
			caster:FindAbilityByName(caster.FSkill):AddManaBurstDebuff(hTarget)
		end
	end
end

ishtar_e_wrapper(ishtar_e)
ishtar_e_wrapper(ishtar_e_upgrade)