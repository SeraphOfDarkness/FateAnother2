cu_chulain_gae_bolg_combo = class({})
cu_chulain_gae_bolg_combo_upgrade = class({})
modifier_cu_wesen_anim = class({})
modifier_wesen_cooldown = class({})

LinkLuaModifier("modifier_cu_wesen_anim", "abilities/cu_chulain/cu_chulain_gae_bolg_combo", LUA_MODIFIER_MOTION_HORIZONTAL)
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
		self.target = self:GetCursorTarget()

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
		--StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.5})
		Timers:CreateTimer(1.6, function()
			if hCaster:IsAlive() then
				if hCaster:HasModifier("modifier_alternate_02") then 
					StartAnimation(hCaster, {duration=3, activity=ACT_DOTA_ATTACK_EVENT, rate=1})
				elseif hCaster:HasModifier("modifier_alternate_04") or hCaster:HasModifier("modifier_alternate_05") then 
					StartAnimation(hCaster, {duration=3, activity=ACT_DOTA_CAST_ABILITY_5, rate=1})
				else
					StartAnimation(hCaster, {duration=3, activity=ACT_DOTA_ATTACK, rate=3})
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
			if (hCaster.IsHeartSeekerAcquired or hCaster:IsAlive()) and hCaster:IsAlive() then

				if not IsValidEntity(hTarget) or hTarget:IsNull() then return end

				hCaster:AddNewModifier(hCaster, self, "modifier_cu_wesen_anim", { Duration = 3 ,
																					Damage = self:GetSpecialValueFor("damage"),
																					HB = self:GetSpecialValueFor("hb_threshold"),
																					Stun = self:GetSpecialValueFor("stun")})
			end
		end)
	end
end

wesenwrapper(cu_chulain_gae_bolg_combo)
wesenwrapper(cu_chulain_gae_bolg_combo_upgrade)
	
---------------------------------

function modifier_cu_wesen_anim:IsHidden() return true end
function modifier_cu_wesen_anim:IsDebuff() return false end
function modifier_cu_wesen_anim:IsPurgable() return false end
function modifier_cu_wesen_anim:RemoveOnDeath() return true end
function modifier_cu_wesen_anim:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_cu_wesen_anim:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION, 
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE }
end
function modifier_cu_wesen_anim:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end
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
function modifier_cu_wesen_anim:GetOverrideAnimation()
	return 1.0
end

function modifier_cu_wesen_anim:OnCreated(args)
	self.caster = self:GetParent()
	self.ability = self:GetAbility()
	self.target = self.ability.target
	self.damage = args.Damage 
	self.stun = args.Stun 
	self.HB = args.HB

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

    self:Dash(me, dt)
end

function modifier_cu_wesen_anim:Dash(me, dt)
	local pos = self.caster:GetOrigin()
    local targetpos = self.target:GetOrigin()

    local direction = targetpos - pos
    direction.z = 0     
    local target = pos + direction:Normalized() * (self.speed * dt)

    self.caster:SetOrigin(target)
    self.caster:FaceTowards(targetpos)
end

function modifier_cu_wesen_anim:WesenHit()
	self.caster:RemoveModifierByName("pause_sealdisabled")

	local RedScreenFx = ParticleManager:CreateParticle("particles/custom/screen_red_splash.vpcf", PATTACH_EYES_FOLLOW, self.caster)
	Timers:CreateTimer( 3.0, function()
		ParticleManager:DestroyParticle( RedScreenFx, false )
	end)
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

	if IsValidEntity(target) and not target:IsNull() and target:IsAlive() then
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
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end