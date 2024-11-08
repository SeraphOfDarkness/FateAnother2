cu_chulain_piercing_spear = class({})
cu_chulain_piercing_spear_upgrade = class({})
modifier_piercing_spear_charge = class({})
modifier_piercing_spear = class({})
modifier_rune_of_acceleration = class({})
modifier_relentless_window = class({})
modifier_cu_q_use = class({})

LinkLuaModifier("modifier_piercing_spear_charge", "abilities/cu_chulain/cu_chulain_piercing_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_piercing_spear", "abilities/cu_chulain/cu_chulain_piercing_spear", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_rune_of_acceleration", "abilities/cu_chulain/cu_chulain_piercing_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_relentless_window", "abilities/cu_chulain/cu_chulain_piercing_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cu_q_use", "abilities/cu_chulain/cu_chulain_piercing_spear", LUA_MODIFIER_MOTION_NONE)

function piercingspearwrapper(abil)
	function abil:GetAbilityTextureName()
		if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
			return "custom/yukina/yukina_piercing_spear"
		else
			return "custom/cu_chulain/cu_chulain_piercing_spear"
		end
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

	function abil:OnUpgrade()
		if self:GetCaster().IsCelticRuneAcquired then 
			self:GetCaster():FindAbilityByName("cu_chulain_relentless_spear_upgrade"):SetLevel(self:GetLevel())
		else
			self:GetCaster():FindAbilityByName("cu_chulain_relentless_spear"):SetLevel(self:GetLevel())
		end
	end

	function abil:OnSpellStart()
		self.caster = self:GetCaster()
		self.charge = self:GetSpecialValueFor("charge")
		self.target_loc = self:GetCursorPosition()
		if self.target_loc == self.caster:GetAbsOrigin() then 
			self.target_loc = self.caster:GetAbsOrigin() + Vector(1,1,0)
		end
    	self.caster:FaceTowards(self.target_loc)
		self.duration = 2.0
		self.direction = (self.target_loc - self.caster:GetAbsOrigin()):Normalized()
		self.direction.z = 0
		self.caster:SetForwardVector(self.direction)

		if self.caster:HasModifier("modifier_alternate_04") or self.caster:HasModifier("modifier_alternate_05") then 
			self.caster:EmitSound("Yukina_W") 
		else
			self.caster:EmitSound("cu_skill_" .. math.random(1,4))
		end
		self.caster:AddNewModifier(self.caster, self, "modifier_piercing_spear_charge", { Duration = self.charge})
		Timers:CreateTimer(self.charge, function()
			if self.caster:IsAlive() then 
				self:SetDashParticle()
				self.caster:AddNewModifier(self.caster, self, "modifier_piercing_spear", { Duration = self.duration - self.charge})
			end
		end)
		self:CheckCombo()
	end

	function abil:CheckCombo()
		local caster = self:GetCaster()

		if math.ceil(caster:GetStrength()) >= 25 and math.ceil(caster:GetAgility()) >= 25 and math.ceil(caster:GetIntellect()) >= 25 then
			if caster:FindAbilityByName(caster.ESkill):IsCooldownReady() 
			and not caster:HasModifier("modifier_wesen_cooldown")
			and caster:FindAbilityByName(caster.ComboSkill):IsCooldownReady() then
				caster:AddNewModifier(caster, self, "modifier_cu_q_use", { Duration = 4 })
			end
		end
	end

	function abil:ApplyRuneAccel(dur)
		local caster = self:GetCaster()
		caster:AddNewModifier(caster, self, "modifier_rune_of_acceleration", { Duration = dur })
	end

	function abil:SetDashParticle()
		local caster = self:GetCaster()
		if duration == nil then 
			duration = 2
		end
		local dummy = CreateUnitByName("visible_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
	    dummy:FindAbilityByName("dummy_visible_unit_passive"):SetLevel(1)
	    dummy:SetDayTimeVisionRange(0)
	    dummy:SetNightTimeVisionRange(0)
	    dummy:SetOrigin(caster:GetAbsOrigin())
	    dummy:SetForwardVector(-self.direction)

		local particle1 = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_anim_run_rare.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	    ParticleManager:SetParticleControlEnt(particle1, 1, dummy, PATTACH_ABSORIGIN_FOLLOW, nil, dummy:GetAbsOrigin(), false)
	    ParticleManager:ReleaseParticleIndex(particle1)

	    Timers:CreateTimer(0.5, function()
	    	local particle2 = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_anim_run_rare.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
		    ParticleManager:SetParticleControlEnt(particle2, 1, dummy, PATTACH_ABSORIGIN_FOLLOW, nil, dummy:GetAbsOrigin(), false)
		    ParticleManager:ReleaseParticleIndex(particle2)
	    end)

	    Timers:CreateTimer(duration, function()
			if IsValidEntity(dummy) then
	        	dummy:RemoveSelf()
	        end
	    end)
	end
end

piercingspearwrapper(cu_chulain_piercing_spear)
piercingspearwrapper(cu_chulain_piercing_spear_upgrade)

---------------------------------------

function modifier_piercing_spear_charge:IsHidden() return true end
function modifier_piercing_spear_charge:IsDebuff() return false end
function modifier_piercing_spear_charge:IsPurgable() return false end
function modifier_piercing_spear_charge:RemoveOnDeath() return true end
function modifier_piercing_spear_charge:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_piercing_spear_charge:CheckState()
    local state = { [MODIFIER_STATE_MUTED] = true,
                    [MODIFIER_STATE_DISARMED] = true,
                    [MODIFIER_STATE_SILENCED] = true,
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                }
    return state
end
function modifier_piercing_spear_charge:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, 
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE}
end
function modifier_piercing_spear_charge:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end
---------------------------------------

function modifier_piercing_spear:IsHidden() return false end
function modifier_piercing_spear:IsDebuff() return false end
function modifier_piercing_spear:IsPurgable() return false end
function modifier_piercing_spear:RemoveOnDeath() return true end
function modifier_piercing_spear:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_piercing_spear:CheckState()
    local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                    [MODIFIER_STATE_MUTED] = true,
                    [MODIFIER_STATE_DISARMED] = true,
                    [MODIFIER_STATE_SILENCED] = true,
                    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                }
    return state
end
function modifier_piercing_spear:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, 
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE}
end
function modifier_piercing_spear:GetOverrideAnimation()
	if self:GetParent():HasModifier("modifier_alternate_04") or self:GetParent():HasModifier("modifier_alternate_05") then 
		return ACT_DOTA_CAST_ABILITY_5
	elseif self:GetParent():HasModifier("modifier_alternate_01") then 
		return ACT_DOTA_ATTACK
	else
		return ACT_DOTA_CAST_ABILITY_3_END
	end
end

function modifier_piercing_spear:GetOverrideAnimationRate()
	if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
		return 1.0
	else
		return 2.5
	end
end

function modifier_piercing_spear:OnCreated()
    self.caster = self:GetParent()
    self.ability = self:GetAbility()
    if IsServer() then
		self.damage = self.ability:GetSpecialValueFor("damage")
		self.speed = self.ability:GetSpecialValueFor("speed")
		self.width = self.ability:GetSpecialValueFor("width")
		self.distance = self.ability:GetSpecialValueFor("distance")
		self.direction = self.ability.direction

    	self.original_loc = self.caster:GetAbsOrigin()
    	self.accu_distance = 0

        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_piercing_spear:GetPriority() return MODIFIER_PRIORITY_HIGH end

function modifier_piercing_spear:UpdateHorizontalMotion(me, dt)

	if self.accu_distance >= self.distance then 
		self:Destroy()
		return nil 
	end

    local FindHeroTarget = FindUnitsInRadius(self.caster:GetTeam(), self.caster:GetAbsOrigin(), nil, self.width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	if FindHeroTarget[1] ~= nil then 
		self:DashHit(FindHeroTarget[1])
	end

    self:Dash(me, dt)
end

function modifier_piercing_spear:Dash(me, dt)
	local pos = self.caster:GetAbsOrigin()
   	if self.direction == nil then 
   		self.direction = self.caster:GetForwardVector()
   	end
    local target = pos + self.direction * (self.speed * dt)
    self.accu_distance = self.accu_distance + (self.speed * dt)
    self.caster:SetAbsOrigin(target)
end

function modifier_piercing_spear:DashHit(hTarget)

	self.hit_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_caster.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControlEnt(self.hit_fx, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin() + Vector(0,0,50), false)

	DoDamage(self.caster, hTarget, self.damage, DAMAGE_TYPE_PHYSICAL, 0, self.ability, false)
	hTarget:AddNewModifier(self.caster, self.ability, "modifier_stunned", { Duration = 0.1})

	if not hTarget:IsRealHero() then 
		return  
	end

	self.caster:AddNewModifier(self.caster, self.ability, "modifier_relentless_window", { Duration = 3})
	self:Destroy()
end

if IsServer() then

	function modifier_piercing_spear:OnDestroy()
		if self.caster.IsCelticRuneAcquired then 
			self.ability:ApplyRuneAccel(self.ability:GetSpecialValueFor("bonus_ms_dur"))
		end
	end
end

function modifier_piercing_spear:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end

--------------------------

function modifier_cu_q_use:IsHidden() return true end
function modifier_cu_q_use:IsDebuff() return false end
function modifier_cu_q_use:IsPurgable() return false end
function modifier_cu_q_use:RemoveOnDeath() return true end
function modifier_cu_q_use:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

----------------------------

function modifier_relentless_window:IsHidden() return true end
function modifier_relentless_window:IsDebuff() return false end
function modifier_relentless_window:IsPurgable() return false end
function modifier_relentless_window:RemoveOnDeath() return true end
function modifier_relentless_window:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if IsServer() then 
    function modifier_relentless_window:OnCreated(args)
        self.caster = self:GetParent()
        if self.caster.IsCelticRuneAcquired then 
        	self.caster:SwapAbilities(self.caster.WSkill, "cu_chulain_relentless_spear_upgrade", false, true)
        else
        	self.caster:SwapAbilities(self.caster.WSkill, "cu_chulain_relentless_spear", false, true)
        end
    end

    function modifier_relentless_window:OnDestroy()
    	if self.caster.IsCelticRuneAcquired then 
        	self.caster:SwapAbilities(self.caster.WSkill, "cu_chulain_relentless_spear_upgrade", true, false)
        else
        	self.caster:SwapAbilities(self.caster.WSkill, "cu_chulain_relentless_spear", true, false)
        end
    end
end

--------------------------

function modifier_rune_of_acceleration:IsHidden() 
	if self:GetCaster():HasModifier("modifier_cu_ath_ngabla") then 
		return true 
	else
		return false 
	end
end
function modifier_rune_of_acceleration:IsDebuff() return false end
function modifier_rune_of_acceleration:IsPurgable() return false end
function modifier_rune_of_acceleration:RemoveOnDeath() return true end
function modifier_rune_of_acceleration:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_rune_of_acceleration:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_rune_of_acceleration:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_ms")
end
function modifier_rune_of_acceleration:GetTexture()
	return "custom/cu_chulain/cu_chulain_rune_speed"
end
function modifier_rune_of_acceleration:GetEffectName()
	return "particles/custom/lancer/lancer_rune_green_glow.vpcf"
end
function modifier_rune_of_acceleration:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end




