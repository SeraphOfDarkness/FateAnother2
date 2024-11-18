cu_chulain_gae_bolg = class({})
cu_chulain_gae_bolg_upgrade = class({})
modifier_cu_gae_effect = class({})
modifier_cu_gae_anim = class({})

LinkLuaModifier("modifier_cu_wesen_sfx", "abilities/cu_chulain/cu_chulain_gae_bolg_combo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cu_gae_effect", "abilities/cu_chulain/cu_chulain_gae_bolg", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cu_gae_anim", "abilities/cu_chulain/cu_chulain_gae_bolg", LUA_MODIFIER_MOTION_NONE)

function gaebolgwrapper(abil)
	function abil:GetAbilityTextureName()
		if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
			return "custom/yukina/yukina_gae_bolg"
		else
			return "custom/cu_chulain/cu_chulain_gae_bolg"
		end
	end

	function abil:OnUpgrade()
		if self:GetCaster().IsCelticRuneAcquired then 
			self:GetCaster():FindAbilityByName("cu_chulain_claw_upgrade"):SetLevel(self:GetLevel())
		else
			self:GetCaster():FindAbilityByName("cu_chulain_claw"):SetLevel(self:GetLevel())
		end
	end

	function abil:CastFilterResultTarget(hTarget)
		local caster = self:GetCaster()
		local filter = UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, caster:GetTeamNumber())

		if(filter == UF_SUCCESS) then
			if hTarget:GetName() == "npc_dota_ward_base" then 
				return UF_FAIL_BUILDING
			elseif caster:HasModifier("modifier_self_disarm") then 
				return UF_FAIL_CUSTOM
			else
				return UF_SUCCESS
			end
		else
			return filter
		end
	end

	function abil:GetCustomCastErrorTarget(hTarget)
		return "NO GAE BOLG."
	end

	function abil:OnAbilityPhaseStart()
		self.caster = self:GetCaster()

		self.caster:AddNewModifier(self.caster, self, "modifier_cu_gae_effect", {Duration = 1.5})
		self.caster:AddNewModifier(self.caster, self, "modifier_cu_wesen_sfx", { Duration = 1.5})

		if self.caster:HasModifier("modifier_alternate_02") or self.caster:HasModifier("modifier_alternate_03") then 
			EmitGlobalSound("Rin-Lancer.Gae")
		elseif self.caster:HasModifier("modifier_alternate_04") or self.caster:HasModifier("modifier_alternate_05") then 
			EmitGlobalSound("Yukina_E")
		else
			EmitGlobalSound("Lancer.GaeBolg")
		end

		return true
	end

	function abil:OnAbilityPhaseInterrupted()
		self.caster = self:GetCaster()
		self.caster:RemoveModifierByName("modifier_cu_gae_effect")
		self.caster:RemoveModifierByName("modifier_cu_wesen_sfx")
		if self.caster:HasModifier("modifier_alternate_02") or self.caster:HasModifier("modifier_alternate_03") then 
			StopGlobalSound("Rin-Lancer.Gae")
		elseif self.caster:HasModifier("modifier_alternate_04") or self.caster:HasModifier("modifier_alternate_05") then 
			StopGlobalSound("Yukina_E")
		else
			StopGlobalSound("Lancer.GaeBolg")
		end

		return true
	end

	function abil:OnSpellStart()
		self.caster = self:GetCaster()
		self.target = self:GetCursorTarget()
		self.HBThreshold = self:GetSpecialValueFor("heart_break")
		self.Damage = self:GetSpecialValueFor("damage")
		self.stun = self:GetSpecialValueFor("stun")

		local flashIndex = ParticleManager:CreateParticle( "particles/custom/diarmuid/gae_dearg_slash.vpcf", PATTACH_CUSTOMORIGIN, self.caster )
	    ParticleManager:SetParticleControl( flashIndex, 2, self.caster:GetAbsOrigin() )
	    ParticleManager:SetParticleControl( flashIndex, 3, self.caster:GetAbsOrigin() )

	    self.caster:AddNewModifier(self.caster, self, "modifier_cu_gae_anim", {Duration = 0.3})

		-- Add dagon particle
		local dagon_particle = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf",  PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControlEnt(dagon_particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_lance", self.caster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(dagon_particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), false)
		local particle_effect_intensity = 500
		ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity,0,0))
		self.target:EmitSound("Hero_Lion.Impale")
		
		Timers:CreateTimer( 3.0, function()
			ParticleManager:DestroyParticle( dagon_particle, false )
			ParticleManager:DestroyParticle( flashIndex, false )
		end)

		if IsSpellBlocked(self.target) then -- no damage but play the effect
		else
			giveUnitDataDrivenModifier(self.caster, self.target, "can_be_executed", 0.033)

			-- Blood splat
			local splat = ParticleManager:CreateParticle("particles/generic_gameplay/screen_blood_splatter.vpcf", PATTACH_EYES_FOLLOW, self.target)	
			local culling_kill_particle = ParticleManager:CreateParticle("particles/custom/lancer/lancer_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN, self.target)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(culling_kill_particle, 8, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)	

			if not IsImmuneToCC(self.target) then
				self.target:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self.stun})
			end

			DoDamage(self.caster, self.target, self.Damage, DAMAGE_TYPE_MAGICAL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self, false)
			
			if IsValidEntity(self.target) and not self.target:IsNull() and self.target:IsAlive() then 
				if self.target:GetHealthPercent() < self.HBThreshold and not self.target:IsMagicImmune() and not IsUnExecute(self.target) then
					local hb = ParticleManager:CreateParticle("particles/custom/lancer/lancer_heart_break_txt.vpcf", PATTACH_CUSTOMORIGIN, self.target)
					ParticleManager:SetParticleControl( hb, 0, self.target:GetAbsOrigin())
					
					self.target:Execute(self, self.caster, { bExecution = true })
					
					Timers:CreateTimer( 3.0, function()
						ParticleManager:DestroyParticle( hb, false )
						ParticleManager:ReleaseParticleIndex(hb)
					end)
				end  -- check for HB
			end

			Timers:CreateTimer( 3.0, function()
				ParticleManager:DestroyParticle( splat, false )
				ParticleManager:DestroyParticle( culling_kill_particle, false )
				ParticleManager:ReleaseParticleIndex(culling_kill_particle)	
			end)
		end
	end
end

gaebolgwrapper(cu_chulain_gae_bolg)
gaebolgwrapper(cu_chulain_gae_bolg_upgrade)

----------------------------------------

function modifier_cu_gae_effect:IsHidden() return true end
function modifier_cu_gae_effect:IsDebuff() return false end
function modifier_cu_gae_effect:IsPurgable() return false end
function modifier_cu_gae_effect:RemoveOnDeath() return true end
function modifier_cu_gae_effect:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_cu_gae_effect:OnCreated(args)
	self.caster = self:GetParent()

	self.GBCastFx = ParticleManager:CreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(self.GBCastFx, 1, self.caster:GetAbsOrigin()) -- target effect location
	ParticleManager:SetParticleControl(self.GBCastFx, 2, self.caster:GetAbsOrigin()) -- circle effect location
end

function modifier_cu_gae_effect:OnDestroy()
	ParticleManager:DestroyParticle( self.GBCastFx, false )
	ParticleManager:ReleaseParticleIndex(self.GBCastFx)
end

-------------------------------------

function modifier_cu_gae_anim:IsHidden() return true end
function modifier_cu_gae_anim:IsDebuff() return false end
function modifier_cu_gae_anim:IsPurgable() return false end
function modifier_cu_gae_anim:RemoveOnDeath() return true end
function modifier_cu_gae_anim:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_cu_gae_anim:CheckState()
    local state = { [MODIFIER_STATE_MUTED] = true,
                    [MODIFIER_STATE_DISARMED] = true,
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                }
    return state
end

function modifier_cu_gae_anim:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, 
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE}
end

function modifier_cu_gae_anim:GetOverrideAnimation()
	if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
		return ACT_DOTA_ATTACK_EVENT
	elseif self:GetCaster():HasModifier("modifier_alternate_02") then 
		return ACT_DOTA_ATTACK_EVENT_BASH
	else
		return ACT_DOTA_ATTACK
	end
end

function modifier_cu_gae_anim:GetOverrideAnimationRate()
	if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
		return 1.0
	elseif self:GetCaster():HasModifier("modifier_alternate_02") then 
		return 1.0
	else
		return 3
	end
end
