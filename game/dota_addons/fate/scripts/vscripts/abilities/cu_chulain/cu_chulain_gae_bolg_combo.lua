cu_chulain_gae_bolg_combo = class({})
cu_chulain_gae_bolg_combo_upgrade = class({})
modifier_cu_wesen_anim = class({})
modifier_cu_wesen_sfx = class({})
modifier_wesen_cooldown = class({})
modifier_cu_wesen_anim_hibernate = class({})

LinkLuaModifier("modifier_cu_wesen_sfx", "abilities/cu_chulain/cu_chulain_gae_bolg_combo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cu_wesen_anim", "abilities/cu_chulain/cu_chulain_gae_bolg_combo", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_cu_wesen_anim_hibernate", "abilities/cu_chulain/cu_chulain_gae_bolg_combo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wesen_cooldown", "abilities/cu_chulain/cu_chulain_gae_bolg_combo", LUA_MODIFIER_MOTION_NONE)

function wesenwrapper(abil)
	function abil:GetAbilityTextureName()
		if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
			return "custom/yukina/yukina_wesen"
		else
			return "custom/cu_chulain/cu_chulain_wesen_gae_bolg"
		end
	end

	function abil:GetBehavior()
		if self:GetCaster():IsRealHero() then
			return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_HIDDEN		
		else
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
	end

	function abil:GetManaCost(iLevel)
		if self:GetCaster():IsRealHero() then
			return 400
		else
			return 0
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

	function abil:OnSpellStart()
		local hCaster = self:GetCaster()
		local hTarget = self:GetCursorTarget()
		self.dash_speed = 3000

		if not hCaster.HeartSeekerImproved and IsSpellBlocked(hTarget) then
			return
		end

		-- Set master's combo cooldown
		local masterCombo = hCaster.MasterUnit2:FindAbilityByName("cu_chulain_gae_bolg_combo")
		masterCombo:EndCooldown()
		masterCombo:StartCooldown(self:GetCooldown(1))
		hCaster:AddNewModifier(hCaster, self, "modifier_wesen_cooldown", { Duration = self:GetCooldown(1) })
		if hCaster:HasModifier("modifier_wesen_window") then 
			hCaster:RemoveModifierByName("modifier_wesen_window")
		end

		giveUnitDataDrivenModifier(hCaster, hCaster, "pause_sealdisabled", 3.0)

		hCaster:AddNewModifier(hCaster, self, "modifier_cu_wesen_sfx", { Duration = 10})
		--hCaster:AddNewModifier(hCaster, self, "modifier_cu_wesen_anim_hibernate", { Duration = 15 })
		Timers:CreateTimer(1.6, function()
			if hCaster:IsAlive() then
				if hCaster:HasModifier("modifier_alternate_01") then 
					StartAnimation(hCaster, {duration=5, activity=ACT_DOTA_ATTACK, rate=1})
				elseif hCaster:HasModifier("modifier_alternate_04") or hCaster:HasModifier("modifier_alternate_05") then 
					StartAnimation(hCaster, {duration=5, activity=ACT_DOTA_CAST_ABILITY_5, rate=1})
				else
					StartAnimation(hCaster, {duration=5, activity=ACT_DOTA_CAST_ABILITY_5, rate=1})
				end
			end
		end)
		local soundQueue = math.random(1,4)

		if hCaster:HasModifier("modifier_alternate_04") or hCaster:HasModifier("modifier_alternate_05") then 
			hCaster:EmitSound("Yukina_Combo")
			hTarget:EmitSound("Yukina_Combo")
			EmitGlobalSound("Yukina_BGM")
		else
			if soundQueue ~= 4 then
				hCaster:EmitSound("Cu_Combo_" .. soundQueue)
				hTarget:EmitSound("Cu_Combo_" .. soundQueue)
			else
				hCaster:EmitSound("Lancer.Heartbreak")
				hTarget:EmitSound("Lancer.Heartbreak")
			end
		end
		hCaster:FindAbilityByName(hCaster.ESkill):StartCooldown(hCaster:FindAbilityByName(hCaster.ESkill):GetCooldown(hCaster:FindAbilityByName(hCaster.ESkill):GetLevel()))

		Timers:CreateTimer(1.8, function() 
			if (hCaster.IsHeartSeekerAcquired or hCaster:IsAlive()) and hTarget:IsAlive() then

				if not IsValidEntity(hTarget) or hTarget:IsNull() then return end

				local lancer = Physics:Unit(hCaster)

			    hCaster:OnHibernate(function(unit)
			    	hCaster:SetPhysicsVelocity((hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized() * self.dash_speed)
			    	hCaster:PreventDI()
			    	hCaster:SetPhysicsFriction(0)
			    	hCaster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
			    	hCaster:FollowNavMesh(false)	
			    	hCaster:SetAutoUnstuck(false)
			    	hCaster:OnPhysicsFrame(function(unit)
						local diff = hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()
						local dir = diff:Normalized()
						if IsInSameRealm(hCaster:GetAbsOrigin(), hTarget:GetAbsOrigin()) then
							unit:SetPhysicsVelocity(dir * self.dash_speed)
						else
							unit:SetPhysicsVelocity(dir * self.dash_speed * 10)
						end
						local forward_vec = (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
						forward_vec.z = 0
						hCaster:SetForwardVector(forward_vec)
						hCaster:RemoveModifierByName("modifier_zhuge_liang_array_enemy")
						hCaster:RemoveModifierByName("modifier_aestus_domus_aurea_enemy")

						if diff:Length() < 100 then
							unit:PreventDI(false)
							unit:SetPhysicsVelocity(Vector(0,0,0))
							unit:OnPhysicsFrame(nil)
							unit:OnHibernate(nil)
							unit:SetAutoUnstuck(true)
				        	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
				        	self.damage = self:GetSpecialValueFor("damage")
							self.HB = self:GetSpecialValueFor("hb_threshold")
							self.stun = self:GetSpecialValueFor("stun")
				        	self:WesenHit(hCaster, hTarget, self.damage, self.HB, self.stun)
						end
					end)
				end)

			end
		end)
	end

	function abil:WesenHit(hCaster, hTarget, iDamage, HB, fStun)
		
		hCaster:RemoveModifierByName("pause_sealdisabled")

		local RedScreenFx = ParticleManager:CreateParticle("particles/custom/screen_red_splash.vpcf", PATTACH_EYES_FOLLOW, hCaster)
		Timers:CreateTimer( 3.0, function()
			ParticleManager:DestroyParticle( RedScreenFx, false )
		end)

		--[[if self.caster:HasModifier("modifier_alternate_04") or self.caster:HasModifier("modifier_alternate_05") then 
			ParticleManager:DestroyParticle(self.shadowfx, true)
			ParticleManager:ReleaseParticleIndex(self.shadowfx)
		end]]

		hTarget:EmitSound("Hero_Lion.Impale")
		if hCaster:HasModifier("modifier_alternate_02") then 
			StartAnimation(hCaster, {duration=0.3, activity=ACT_DOTA_ATTACK_EVENT_BASH, rate=1})
		elseif hCaster:HasModifier("modifier_alternate_04") or hCaster:HasModifier("modifier_alternate_05") then 
			StartAnimation(hCaster, {duration=0.3, activity=ACT_DOTA_ATTACK_EVENT, rate=1})
		else
			StartAnimation(hCaster, {duration=0.3, activity=ACT_DOTA_ATTACK, rate=2})
		end

		ApplyStrongDispel(hTarget)

		giveUnitDataDrivenModifier(hCaster, hTarget, "can_be_executed", 0.033)

		hTarget:AddNewModifier(hCaster, hTarget, "modifier_stunned", {duration = fStun})

		DoDamage(hCaster, hTarget, iDamage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY, self, false)

		if IsValidEntity(hTarget) and not hTarget:IsNull() and hTarget:IsAlive() then
			if hTarget:GetHealthPercent() <= HB and not hTarget:IsMagicImmune() and not IsUnExecute(hTarget) then
				local hb = ParticleManager:CreateParticle("particles/custom/lancer/lancer_heart_break_txt.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
				ParticleManager:SetParticleControl( hb, 0, hTarget:GetAbsOrigin())
				hTarget:Execute(self, hCaster, { bExecution = true })
									
				Timers:CreateTimer( 3.0, function()
					ParticleManager:DestroyParticle( hb, false )
					ParticleManager:ReleaseParticleIndex(hb)
				end)
			end  -- check for HB
		end

							-- Blood splat
		local splat = ParticleManager:CreateParticle("particles/generic_gameplay/screen_blood_splatter.vpcf", PATTACH_EYES_FOLLOW, hTarget)	
		local culling_kill_particle = ParticleManager:CreateParticle("particles/custom/lancer/lancer_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(culling_kill_particle, 8, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)	

							-- Add dagon particle
		local dagon_particle = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf",  PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:SetParticleControlEnt(dagon_particle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		local particle_effect_intensity = 800
		ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity,0,0))
					
		hCaster:RemoveModifierByName("modifier_cu_wesen_sfx")

		Timers:CreateTimer( 3.0, function()
			ParticleManager:DestroyParticle( dagon_particle, false )
								--ParticleManager:DestroyParticle( flashIndex, false )
			ParticleManager:DestroyParticle( splat, false )
			ParticleManager:DestroyParticle( culling_kill_particle, false )
			ParticleManager:ReleaseParticleIndex(culling_kill_particle)	
		end)
	end
end

wesenwrapper(cu_chulain_gae_bolg_combo)
wesenwrapper(cu_chulain_gae_bolg_combo_upgrade)
	
---------------------------------

function modifier_cu_wesen_sfx:IsHidden() return true end
function modifier_cu_wesen_sfx:IsDebuff() return false end
function modifier_cu_wesen_sfx:IsPurgable() return false end
function modifier_cu_wesen_sfx:RemoveOnDeath() return false end
function modifier_cu_wesen_sfx:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_cu_wesen_sfx:OnCreated(args)
	self.caster = self:GetParent()
	self:AttachSFX()
end

function modifier_cu_wesen_sfx:OnRefresh(args)
	self:DetachSFX()
	self.OnCreated(args)
end

function modifier_cu_wesen_sfx:OnRemoved()
	self:DetachSFX()
end

function modifier_cu_wesen_sfx:AttachSFX()
	local particle = "particles/custom/lancer/lancer_spear_glow_red.vpcf"
	if self.caster:HasModifier("modifier_alternate_04") then
		particle = "particles/custom/lancer/lancer_spear_glow_white.vpcf"
	end
	self.spear_sfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, self.caster)
	ParticleManager:SetParticleControlEnt(self.spear_sfx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_weapon", self.caster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(self.spear_sfx, 7, self.caster, PATTACH_POINT_FOLLOW, "attach_weapon", self.caster:GetAbsOrigin(), false)
end

function modifier_cu_wesen_sfx:DetachSFX()
	ParticleManager:DestroyParticle(self.spear_sfx, true)
	ParticleManager:ReleaseParticleIndex(self.spear_sfx)
end

----------------------------------

function modifier_cu_wesen_anim:IsHidden() return true end
function modifier_cu_wesen_anim:IsDebuff() return false end
function modifier_cu_wesen_anim:IsPurgable() return false end
function modifier_cu_wesen_anim:RemoveOnDeath() return false end
function modifier_cu_wesen_anim:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
--[[function modifier_cu_wesen_anim:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION, 
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE }
end
function modifier_cu_wesen_anim:GetOverrideAnimation()
	if not self:GetParent():HasModifier("modifier_cu_wesen_anim_hibernate") then
		return ACT_DOTA_CAST_ABILITY_5
	else
		return nil 
	end
end]]
function modifier_cu_wesen_anim:CheckState()
    local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                    [MODIFIER_STATE_MUTED] = true,
                    [MODIFIER_STATE_DISARMED] = true,
                    [MODIFIER_STATE_SILENCED] = true,
                    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                }
    return state
end
--[[function modifier_cu_wesen_anim:GetOverrideAnimation()
	return 1.0
end]]

function modifier_cu_wesen_anim:OnCreated(args)
	self.caster = self:GetParent()
	self.ability = self:GetAbility()
	self.target = self.ability.target
	self.damage = args.Damage 
	self.stun = args.Stun 
	self.HB = args.HB

	--[[if self.caster:HasModifier("modifier_alternate_04") or self.caster:HasModifier("modifier_alternate_05") then 
		self.shadowfx = ParticleManager:CreateParticle( "particles/custom/lancer/yukina_combo_shadow.vpcf", PATTACH_ABSORIGIN, self.caster )
		ParticleManager:SetParticleControlEnt(self.shadowfx, 0, self.caster, PATTACH_ABSORIGIN, "attach_origin", self.caster:GetAbsOrigin(), false)
	end]]

	if IsServer() then 
		self.dash_duration = self:GetRemainingTime()
		self.speed = 3000
		self.targetpos = self.target:GetAbsOrigin()

		if self:ApplyHorizontalMotionController() == false then
            self.caster:RemoveModifierByName("modifier_cu_wesen_anim")
        end
	end
end

function modifier_cu_wesen_anim:UpdateHorizontalMotion(me, dt)

	if self.caster:HasModifier("modifier_cu_wesen_anim_hibernate") then 
		return nil 
	end

    if IsInSameRealm(self.caster:GetAbsOrigin(), self.target:GetAbsOrigin()) then 
        self.speed = 3000
    else
    	self.speed = 30000
    end

    self.targetpos = self.target:GetAbsOrigin() 

    if (self.target:GetOrigin() - self.caster:GetOrigin()):Length2D() < 100 then
        self:WesenHit()
        self.caster:RemoveModifierByName("modifier_cu_wesen_anim")
        return nil
    end

    --[[if self.caster:HasModifier("modifier_alternate_04") or self.caster:HasModifier("modifier_alternate_05") then 
		ParticleManager:SetParticleControlEnt(self.shadowfx, 0, self.caster, PATTACH_ABSORIGIN, "attach_origin", self.caster:GetAbsOrigin(), false)
	end]]

    self:Dash(me, dt)
end

function modifier_cu_wesen_anim:Dash(me, dt)
	local pos = self.caster:GetOrigin()
    local targetpos = self.target:GetOrigin()

    local direction = targetpos - pos
    direction.z = 0     
    local target = pos + direction:Normalized() * (self.speed * dt)

    self.caster:SetOrigin(target)
    --self.caster:SetForwardVector(direction:Normalized())
    self.caster:FaceTowards(targetpos)
end

function modifier_cu_wesen_anim:WesenHit()
	self.caster:RemoveModifierByName("pause_sealdisabled")

	local RedScreenFx = ParticleManager:CreateParticle("particles/custom/screen_red_splash.vpcf", PATTACH_EYES_FOLLOW, self.caster)
	Timers:CreateTimer( 3.0, function()
		ParticleManager:DestroyParticle( RedScreenFx, false )
	end)

	--[[if self.caster:HasModifier("modifier_alternate_04") or self.caster:HasModifier("modifier_alternate_05") then 
		ParticleManager:DestroyParticle(self.shadowfx, true)
		ParticleManager:ReleaseParticleIndex(self.shadowfx)
	end]]

	self.target:EmitSound("Hero_Lion.Impale")
	if self.caster:HasModifier("modifier_alternate_02") then 
		StartAnimation(self.caster, {duration=0.3, activity=ACT_DOTA_ATTACK_EVENT_BASH, rate=1})
	elseif self.caster:HasModifier("modifier_alternate_04") or self.caster:HasModifier("modifier_alternate_05") then 
		StartAnimation(self.caster, {duration=0.3, activity=ACT_DOTA_ATTACK_EVENT, rate=1})
	else
		StartAnimation(self.caster, {duration=0.3, activity=ACT_DOTA_ATTACK, rate=2})
	end

	ApplyStrongDispel(self.target)

	giveUnitDataDrivenModifier(self.caster, self.target, "can_be_executed", 0.033)

	self.target:AddNewModifier(self.caster, self.target, "modifier_stunned", {duration = self.stun})

	DoDamage(self.caster, self.target, self.damage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY, self.ability, false)

	if IsValidEntity(self.target) and not self.target:IsNull() and self.target:IsAlive() then
		if self.target:GetHealthPercent() <= self.HB and not self.target:IsMagicImmune() and not IsUnExecute(self.target) then
			local hb = ParticleManager:CreateParticle("particles/custom/lancer/lancer_heart_break_txt.vpcf", PATTACH_CUSTOMORIGIN, self.target)
			ParticleManager:SetParticleControl( hb, 0, self.target:GetAbsOrigin())
			self.target:Execute(self.ability, self.caster, { bExecution = true })
								
			Timers:CreateTimer( 3.0, function()
				ParticleManager:DestroyParticle( hb, false )
				ParticleManager:ReleaseParticleIndex(hb)
			end)
		end  -- check for HB
	end

						-- Blood splat
	local splat = ParticleManager:CreateParticle("particles/generic_gameplay/screen_blood_splatter.vpcf", PATTACH_EYES_FOLLOW, self.target)	
	local culling_kill_particle = ParticleManager:CreateParticle("particles/custom/lancer/lancer_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN, self.target)
	ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(culling_kill_particle, 8, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)	

						-- Add dagon particle
	local dagon_particle = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf",  PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControlEnt(dagon_particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), false)
	local particle_effect_intensity = 800
	ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity,0,0))
						
	Timers:CreateTimer( 3.0, function()
		ParticleManager:DestroyParticle( dagon_particle, false )
							--ParticleManager:DestroyParticle( flashIndex, false )
		ParticleManager:DestroyParticle( splat, false )
		ParticleManager:DestroyParticle( culling_kill_particle, false )
		ParticleManager:ReleaseParticleIndex(culling_kill_particle)	
	end)
end

function modifier_cu_wesen_anim:OnHorizontalMotionInterrupted()
    if IsServer() then
        self.caster:RemoveModifierByName("modifier_cu_wesen_anim")
    end
end

-------------------

function modifier_wesen_cooldown:IsHidden() return false end
function modifier_wesen_cooldown:IsDebuff() return true end
function modifier_wesen_cooldown:IsPurgable() return false end
function modifier_wesen_cooldown:RemoveOnDeath() return false end
function modifier_wesen_cooldown:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

---------------------

function modifier_cu_wesen_anim_hibernate:IsHidden() return true end
function modifier_cu_wesen_anim_hibernate:IsDebuff() return false end
function modifier_cu_wesen_anim_hibernate:IsPurgable() return false end
function modifier_cu_wesen_anim_hibernate:RemoveOnDeath() return false end
function modifier_cu_wesen_anim_hibernate:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end