cu_chulain_gae_bolg_jump = class({})
cu_chulain_gae_bolg_jump_upgrade = class({})
modifier_self_disarm = class({})

LinkLuaModifier("modifier_cu_wesen_sfx", "abilities/cu_chulain/cu_chulain_gae_bolg_combo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_self_disarm", "abilities/cu_chulain/cu_chulain_gae_bolg_jump", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cu_gae_effect", "abilities/cu_chulain/cu_chulain_gae_bolg", LUA_MODIFIER_MOTION_NONE)

function cugaebolgjump_wrapper(abil)
	function abil:GetAbilityTextureName()
		if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
			return "custom/yukina/yukina_gae_bolg_jump"
		else
			return "custom/cu_chulain/cu_chulain_gae_bolg_jump"
		end
	end

	function abil:GetAOERadius()
		return self:GetSpecialValueFor("radius")
	end

	function abil:CastFilterResultLocation(vLocation)
		if self:GetCaster():HasModifier("modifier_self_disarm") then 
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end

	function abil:GetCustomCastErrorLocation(vLocation)
	  	return "NO GAE BOLG."
	end

	function abil:OnAbilityPhaseStart()
		self.caster = self:GetCaster()

		self.caster:AddNewModifier(self.caster, self, "modifier_cu_gae_effect", {Duration = self:GetSpecialValueFor"cast_delay" + 1})
		self.caster:AddNewModifier(self.caster, self, "modifier_cu_wesen_sfx", { Duration = self:GetSpecialValueFor"cast_delay" + 1})
		return true
	end

	function abil:OnAbilityPhaseInterrupted()
		self.caster = self:GetCaster()
		self.caster:RemoveModifierByName("modifier_cu_gae_effect")
		self.caster:RemoveModifierByName("modifier_cu_wesen_sfx")
		return true
	end

	function abil:OnSpellStart()
		self.caster = self:GetCaster()
		self.targetPoint = self:GetCursorPosition()
		self.radius = self:GetSpecialValueFor("radius")
		self.damage = self:GetSpecialValueFor("damage")
		self.projectileSpeed = self:GetSpecialValueFor("speed")
		local ascendCount = 0
		local descendCount = 0

		if (self.caster:GetAbsOrigin() - self.targetPoint):Length2D() > 2500 then 
			self.caster:SetMana(self.caster:GetMana() + self:GetManaCost(self:GetLevel())) 
			self:EndCooldown() 
			return
		end

		if self.caster:HasModifier("modifier_alternate_02") or self.caster:HasModifier("modifier_alternate_03") then 
			EmitGlobalSound("Rin-Lancer.Gae")
		elseif self.caster:HasModifier("modifier_alternate_04") or self.caster:HasModifier("modifier_alternate_05") then 
			EmitGlobalSound("Yukina_R")
		else
			EmitGlobalSound("lancer_gae_bolg_2")
		end

		giveUnitDataDrivenModifier(self.caster, self.caster, "jump_pause", 0.8)
		Timers:CreateTimer(0.8, function()
			giveUnitDataDrivenModifier(self.caster, self.caster, "jump_pause_postdelay", 0.15)
		end)
		Timers:CreateTimer(0.95, function()
			giveUnitDataDrivenModifier(self.caster, self.caster, "jump_pause_postlock", 0.2)
		end)

		Timers:CreateTimer(0.65, function()
			if self.caster:HasModifier("modifier_alternate_04") or self.caster:HasModifier("modifier_alternate_05") then
				EmitGlobalSound("Yukina_Sekkaro")
			end 
		end)

		Timers:CreateTimer('gb_throw' .. self.caster:GetPlayerOwnerID(), {
			endTime = 0.35,
			callback = function()
			StartAnimation(self.caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=2})
			local projectileOrigin = self.caster:GetAbsOrigin() + Vector(0,0,300)

			local particle_name = "particles/custom/lancer/lancer_gae_bolg_projectile_new.vpcf"
			if self.caster:HasModifier("modifier_alternate_04") then 
				particle_name = "particles/custom/lancer/lancer_white_gae_bolg_projectile.vpcf"
			end
			local throw_particle = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, self.caster)
			ParticleManager:SetParticleControl(throw_particle, 0, projectileOrigin)
			ParticleManager:SetParticleControl(throw_particle, 1, (self.targetPoint - projectileOrigin):Normalized() * self.projectileSpeed)
			ParticleManager:SetParticleControl(throw_particle, 9, projectileOrigin)

			self.caster:AddNewModifier(self.caster, self, "modifier_self_disarm", {duration = self:GetSpecialValueFor("disarm")})

			local travelTime = (self.targetPoint - projectileOrigin):Length() / self.projectileSpeed
			Timers:CreateTimer(travelTime, function()
				ParticleManager:DestroyParticle(throw_particle, false)
				self:OnCuGBAOEHit()
			end)
		end})

		Timers:CreateTimer('gb_ascend' .. self.caster:GetPlayerOwnerID(), {
			endTime = 0,
			callback = function()
		   	if ascendCount == 15 then return end
			self.caster:SetAbsOrigin(self.caster:GetAbsOrigin() + Vector(0,0,50))
			ascendCount = ascendCount + 1;
			return 0.033
		end
		})

		Timers:CreateTimer("gb_descend" .. self.caster:GetPlayerOwnerID(), {
		    endTime = 0.3,
		    callback = function()
		    	if descendCount == 15 then return end
				self.caster:SetAbsOrigin(self.caster:GetAbsOrigin() + Vector(0,0,-50))
				descendCount = descendCount + 1;
		      	return 0.033
		    end
		})
	end

	function abil:OnCuGBAOEHit()
		if self.caster.IsDeathFlightAcquired then 
			local bonus_agi = self:GetSpecialValueFor("bonus_agi") 
			self.damage = self.damage + (bonus_agi * self.caster:GetAgility())
		end

		local knockback = { should_stun = true,
	                        knockback_duration = self:GetSpecialValueFor("knock_duration"),
	                        duration = self:GetSpecialValueFor("stun_duration"),
	                        knockback_distance = 0,
	                        knockback_height = 100,
	                        center_x = self.targetPoint .x,
	                        center_y = self.targetPoint .y,
	                        center_z = self.targetPoint .z }

		Timers:CreateTimer(0.15, function()
			local targets = FindUnitsInRadius(self.caster:GetTeam(), self.targetPoint, nil, self.radius
		            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for k,v in pairs(targets) do
				DoDamage(self.caster, v, self.damage, DAMAGE_TYPE_MAGICAL, 0, self, false)
				if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
			        if not IsImmuneToCC(v) then
			        	v:AddNewModifier(self.caster, self, "modifier_knockback", knockback)
			        end
			    end
		    end
		    
		    local fire = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rainofchaos_start_breakout_fallback_mid.vpcf", PATTACH_WORLDORIGIN, self.caster)
			local crack = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_cracks.vpcf", PATTACH_WORLDORIGIN, self.caster)
			local explodeFx1 = ParticleManager:CreateParticle("particles/custom/lancer/lancer_gae_bolg_hit.vpcf", PATTACH_WORLDORIGIN, self.caster )
			ParticleManager:SetParticleControl( fire, 0, self.targetPoint)
			ParticleManager:SetParticleControl( crack, 0, self.targetPoint)
			ParticleManager:SetParticleControl( explodeFx1, 0, self.targetPoint)
			ScreenShake(self.caster:GetOrigin(), 7, 1.0, 2, 2000, 0, true)
			EmitSoundOnLocationWithCaster(self.targetPoint, "Misc.Crash", self.caster)

		    Timers:CreateTimer( 3.0, function()
				ParticleManager:DestroyParticle( crack, false )
				ParticleManager:DestroyParticle( fire, false )
				ParticleManager:DestroyParticle( explodeFx1, false )
			end)
		end)

		Timers:CreateTimer(0.75, function()
		    local tProjectile = {
		       	Target = self.caster,
			    vSourceLoc = self.targetPoint,
			    Ability = self,
			    EffectName = "particles/custom/lancer/soaring/spear.vpcf",
			    iMoveSpeed = 3000,
	        	bDodgeable = false,
			    flExpireTime = GameRules:GetGameTime() + 10,
		   	}

		   	ProjectileManager:CreateTrackingProjectile(tProjectile)
		end)	
	end

	function abil:OnProjectileHit_ExtraData(hTarget, vLocation, table)
		hTarget:RemoveModifierByName("modifier_self_disarm")
	end
end

cugaebolgjump_wrapper(cu_chulain_gae_bolg_jump)
cugaebolgjump_wrapper(cu_chulain_gae_bolg_jump_upgrade)

--------------------------------

function modifier_self_disarm:IsHidden() return false end
function modifier_self_disarm:IsDebuff() return true end
function modifier_self_disarm:IsPurgable() return false end
function modifier_self_disarm:RemoveOnDeath() return true end
function modifier_self_disarm:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_self_disarm:CheckState()
    local state = { [MODIFIER_STATE_DISARMED] = true}
    return state
end

function modifier_self_disarm:DeclareFunctions()
	return {MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS}
end

function modifier_self_disarm:GetActivityTranslationModifiers()
	return "disarm"
end