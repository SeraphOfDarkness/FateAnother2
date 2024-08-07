
ishtar_r = class({})
ishtar_r_upgrade = class({})


function ishtar_r_wrapper(abil)
	function abil:GetBehavior()
		if self:GetCaster():HasModifier("modifier_ishtar_gem_consume") then
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
		else
			return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
		end
	end

	function abil:GetManaCost(iLevel)
		return 800
	end

	function abil:GetChannelTime()
		return self:GetSpecialValueFor("max_channel")
	end

	function abil:GetAOERadius()
		if self:GetCaster():HasModifier("modifier_ishtar_gem_consume") then
			return self:GetSpecialValueFor("gem_aoe")
		else
			return 0
		end
	end

	function abil:GetAbilityTextureName()
		return "custom/ishtar/ishtar_r"
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
		self.caster = self:GetCaster()
		if self.caster:IsChanneling() then 
			self.chargetick = 0
			self:EndCooldown()
			self.caster:RefundManaCost()
		else
			local target_loc = self:GetCursorPosition()
			self.gem_delay = self:GetSpecialValueFor("gem_delay")
			self.gem_range = self:GetSpecialValueFor("gem_range")
			self.gem_aoe = self:GetSpecialValueFor("gem_aoe")
			self.gem_burst_damage = self:GetSpecialValueFor("gem_burst_damage")
			self.gem_consume = self:GetGemConsume(self:GetSpecialValueFor("gem_consume"))
			self.gem_bonus_arrow = self.gem_consume * self:GetSpecialValueFor("gem_bonus_arrow")
			self.gem_arrow_damage = self:GetSpecialValueFor("gem_arrow_damage")
			self.gem_arrow_aoe = self:GetSpecialValueFor("gem_arrow_aoe")
			local ascendCount = 0
			local descendCount = 0
			self.target_arrow = {}
			self.origin_arrow = {}

			giveUnitDataDrivenModifier(caster, caster, "jump_pause",self.gem_delay + 0.8)

			Timers:CreateTimer('ishtar_r_ascend' .. self.caster:GetPlayerOwnerID(), {
				endTime = 0,
				callback = function()
			   	if ascendCount == 15 then 
			   		for i = 1, self.gem_bonus_arrow do 
						local spawn_loc = 
						self.origin_arrow[i] = spawn_loc
					end
			   		return 
			   	end
				self.caster:SetAbsOrigin(self.caster:GetAbsOrigin() + Vector(0,0,50))
				ascendCount = ascendCount + 1;
				return 0.033
			end})

			Timers:CreateTimer("ishtar_r_descend" .. self.caster:GetPlayerOwnerID(), {
			    endTime = 0.33 + self.gem_delay + 0.3,
			    callback = function()
			    if descendCount == 15 then 
			    	local ground = GetGroundPosition(self.caster:GetAbsOrigin(), self.caster)
			    	self.caster:SetAbsOrigin(ground)
			    	return 
			    end
				self.caster:SetAbsOrigin(self.caster:GetAbsOrigin() + Vector(0,0,-50))
				descendCount = descendCount + 1;
			    return 0.033
			end})

			Timers:CreateTimer("ishtar_r_fire" .. self.caster:GetPlayerOwnerID(), {
				endTime = 0.33 + self.gem_delay,
			    callback = function()
			    local projectileOrigin = caster:GetAbsOrigin()

				local travelTime = (target_loc - projectileOrigin):Length() / self:GetSpecialValueFor("speed")
				Timers:CreateTimer(travelTime, function()
					
					self:OnArrowLand(target_loc, 1)
				end)
				for i = 1, self.gem_bonus_arrow do 
					local random_loc = target_loc + RandomVector(self:GetAOERadius() - 100)
					local distance = (self.origin_arrow[i] - random_loc):Length2D()

					Timers:CreateTimer(distance/self:GetSpecialValueFor("speed"), function()
						self:OnArrowLand(random_loc, 2)
					end)
				end
			end})    
		end
	end

	function abil:OnArrowLand(vLocation, iArrow)
		if iArrow == 1 then -- main one
			local main_aoe = FindUnitsInRadius(self.caster:GetTeam(), vLocation, nil, self.gem_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for k,v in pairs (main_aoe) do
				if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
					DoDamage(self.caster, v, self.gem_burst_damage, DAMAGE_TYPE_MAGICAL, 0, self, false)
					if self.caster.IsManaBurstGemAcquired then 
						self.caster:FindAbilityByName(self.caster.FSkill):AddManaBurstDebuff(v)
					end
				end	       	
			end
		else
			local bonus_aoe = FindUnitsInRadius(self.caster:GetTeam(), vLocation, nil, self.gem_arrow_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for k,v in pairs (main_aoe) do
				if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
					DoDamage(self.caster, v, self.gem_arrow_damage, DAMAGE_TYPE_MAGICAL, 0, self, false)
					if self.caster.IsManaBurstGemAcquired then 
						self.caster:FindAbilityByName(self.caster.FSkill):AddManaBurstDebuff(v)
					end
				end	       	
			end
		end
	end

	function abil:OnChannelThink(flInterval)
		self.chargetick = self.chargetick + flInterval
	end

	function abil:OnChannelFinish(bInterrupted)
		if self.chargetick < self:GetSpecialValueFor("min_channel") then 
			self:StartCooldown(self:GetCooldown(self:GetLevel()) * 0.25)
			self:GetCaster():SpendMana(self:GetManaCost(self:GetLevel()) * 0.25, self)
		else
			local charge_duration = self.chargetick - self:GetSpecialValueFor("min_channel")
			self:StartCooldown(self:GetCooldown(self:GetLevel()))
			self:GetCaster():SpendMana(self:GetManaCost(self:GetLevel()), self)
			print('ishtar charge duration = ' .. charge_duration)
			local Arrow =
			{
				Ability = self,
		        EffectName = "particles/ishtar/ishtar-r/ishtar_r_projectile_model2.vpcf",
		        vSpawnOrigin = self:GetCaster():GetOrigin() + Vector(0,0,60),
		        fDistance = self:GetSpecialValueFor("range") + (self:GetSpecialValueFor("range") * charge_duration),
		        fStartRadius = self:GetSpecialValueFor("width"),
		        fEndRadius = self:GetSpecialValueFor("width") + (10 * charge_duration),
		        Source = self:GetCaster(),
		        bHasFrontalCone = true,
		        bReplaceExisting = false,
		        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		        iUnitTargetType = DOTA_UNIT_TARGET_ALL,
		        fExpireTime = GameRules:GetGameTime() + 3.0,
				bDeleteOnHit = false,
				vVelocity = self:GetCaster():GetForwardVector() * (self:GetSpecialValueFor("speed") + (self:GetSpecialValueFor("speed_bonus_channel") * charge_duration)),		
			}
			self.channel_arrow = ProjectileManager:CreateLinearProjectile(Arrow)
		end
	end

	function abil:OnProjectileHit(hTarget, vLocation)
		if hTarget == nil then return end

		DoDamage(self:GetCaster(), hTarget, self:GetSpecialValueFor("damage"), DAMAGE_TYPE_MAGICAL, 0, self, false)

		if hTarget:IsRealHero() then 
			ProjectileManager:DestroyLinearProjectile(self.channel_arrow)
			local targets = FindUnitsInRadius(self:GetCaster():GetTeam(), vLocation, nil, self:GetSpecialValueFor("impact_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for k,v in pairs(targets) do
				if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
			       	DoDamage(self:GetCaster(), v, self:GetSpecialValueFor("damage_impact") + (self:GetSpecialValueFor("damage_bonus_channel") * charge_duration), DAMAGE_TYPE_MAGICAL, 0, self, false)	       	
		       		if self.caster.IsManaBurstGemAcquired then 
						self.caster:FindAbilityByName(self.caster.FSkill):AddManaBurstDebuff(hTarget)
					end
		       	end
		    end
		end
	end
end
