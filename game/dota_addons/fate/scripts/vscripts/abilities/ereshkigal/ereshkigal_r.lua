
ereshkigal_r = class({})
ereshkigal_r_upgrade_1 = class({})
ereshkigal_r_upgrade_2 = class({})
ereshkigal_r_upgrade_3 = class({})
modifier_ereshkigal_marble_aura_enemies = class({})
modifier_ereshkigal_marble_aura_allies = class({})
modifier_ereshkigal_marble_aura_debuff = class({})
modifier_ereshkigal_marble_aura_buff = class({})
modifier_ereshkigal_ghost_form = class({})
modifier_ereshkigal_marble_checker = class({})
modifier_ereshkigal_self = class({})

LinkLuaModifier("modifier_ereshkigal_marble_aura_enemies", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_marble_aura_allies", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_marble_aura_debuff", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_marble_aura_buff", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_ghost_form", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_self_checker", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_self", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)

function ereshkigal_r_wrapper(ability)
	function ability:GetAbilityTextureName()
		if self:GetCaster():HasModifier("modifier_ereshkigal_authority") then 
			return "custom/jeanne/jeanne_luminosite_eternelle_saint"
		else
			return "custom/jeanne/jeanne_luminosite_eternelle"
		end
	end

	function ability:OnSpellStart()
		self.caster = self:GetCaster()
		self.target_loc = self:GetCursorPosition()

		self.radius = self:GetSpecialValueFor("radius")
		self.width = self:GetSpecialValueFor("width")
		self.speed = self:GetSpecialValueFor("speed")
		self.root = self:GetSpecialValueFor("root_dur")
		self.hell_dur = self:GetSpecialValueFor("hell_dur")
		self.heal_red = self:GetSpecialValueFor("heal_red")
		self.origin = self.caster:GetAbsOrigin()
		self.damage = self:GetSpecialValueFor("damage")
		if self.caster.IsProtectionAcquired then 
			local bonus_int = self:GetSpecialValueFor("bonus_int") * self.caster:GetIntellect()
			self.damage = self.damage + bonus_int
		end
		if self.caster:HasModifier("modifier_ereshkigal_authority") then 

		end
		self.outer_dmg = self.damage * self:GetSpecialValueFor("outer_dmg")/100

		local projectile = {
			Source = self.caster,
			EffectName = "",
			Ability = self,
			vSpawnOrigin = self.origin,
			fDistance = self.radius,
			fStartRadius = self.width,
			fEndRadius = self.width,
			bHasFrontalCone = false,
			fExpireTime = GameRules:GetGameTime() + (self.radius/self.speed),
			vVelocity = self.caster:GetForwardVector() * self.speed,
			fMaxSpeed = 2000,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			bProvidesVision = true, 
			iVisionRadius = self.width,
			iVisionTeamNumber = self.caster:GetTeamNumber(),
			bDrawsOnMinimap = false,
			bVisibleToEnemies = true,
			ExtraData = {Damage = self.damage, OutDamage = self.outer_dmg, OutRadius = self.radius, InRadius = self.width, Root = self.root}
		}

		self.pillar_projectile = ProjectileManager:CreateLinearProjectile(projectile)
	end

	function ability:OnProjectileThinkHandle(iProjectileHandle)
		if (ProjectileManager:GetLinearProjectileLocation(iProjectileHandle) - self.origin):Length2D() >= self.radius - 50 then 
			self:CreatePseudoMarble(ProjectileManager:GetLinearProjectileLocation(iProjectileHandle))
			ProjectileManager:DestroyLinearProjectile(iProjectileHandle)
		end
	end

	function ability:OnProjectileHit_ExtraData(hTarget, vLocation, tExtra)
		if hTarget == nil then return false end 

		DoDamage(self.caster, hTarget, tExtra.Damage, DAMAGE_TYPE_MAGICAL, 0, self, false)	

		if not hTarget:IsRealHero() then return false end

		local tEnemies = FindUnitsInRadius(self.caster:GetTeam(), vLocation, nil, tExtra.OutRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		for _,enemy in pairs (tEnemies) do
			if enemy ~= hTarget then
				local distance = (vLocation - enemy:GetAbsOrigin()):Length2D()
				if distance <= tExtra.InRadius then 
					enemy:AddNewModifier(self.caster, self, "modifier_rooted", {Duration = tExtra.Root})
					DoDamage(self.caster, enemy, tExtra.Damage, DAMAGE_TYPE_MAGICAL, 0, self, false)	
				else
					DoDamage(self.caster, enemy, tExtra.OutDamage, DAMAGE_TYPE_MAGICAL, 0, self, false)	
				end
			end
		end

		self.hell_dummy = self:CreatePseudoMarble(vLocation)

		return true	
	end

	function ability:CreatePseudoMarble(vLocation) 
		local zone = CreateUnitByName("sight_dummy_unit", vLocation, true, self.caster, self.caster, self.caster:GetTeamNumber())
		zone:AddNewModifier(self.caster, nil, "modifier_kill", {duration = self.hell_dur})
		local slow = 0
		local debuff = 0
		if self.caster.IsProtectionAcquired then 
			slow = self:GetSpecialValueFor("slow")
			debuff = self:GetSpecialValueFor("def_debuff")
		end

		self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_self_checker", {Duration = self.hell_dur,
																							Radius = self.radius,})

		zone:AddNewModifier(self.caster, self, "modifier_ereshkigal_marble_aura_enemies", {Duration = self.hell_dur, 
																							Radius = self.radius, 
																							HealReduction = self.heal_red,
																							Slow = slow,
																							Debuff = debuff})
		if self.caster.IsTerritoryAcquired then 
			zone:AddNewModifier(self.caster, self, "modifier_ereshkigal_marble_aura_allies", {Duration = self.hell_dur, 
																								Radius = self.radius, 
																								Buff = self:GetSpecialValueFor("team_buff")})
		end

		return zone -- hZoneDummy
	end

	function ability:DestroyMarble(hDummy)
		if self:IsHellZoneExist(hDummy) then
			hDummy:RemoveSelf()
		end
		self:RemoveZoneFx()
	end

	function ability:IsHellZoneExist(hDummy)
		if hDummy ~= nil and not hDummy:IsNull() and IsValidEntity(hDummy) then
			return true 
		end
		return false 
	end

	function ability:CreateZoneFx(vLocation)
		self.caster.HellZoneFx = ParticleManager:CreateParticle("", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(self.caster.HellZoneFx, 0, vLocation)
	end

	function ability:RemoveZoneFx()
		if self.caster.HellZoneFx ~= nil then
			ParticleManager:DestroyParticle(self.caster.HellZoneFx, true)
			ParticleManager:ReleaseParticleIndex(self.caster.HellZoneFx)
		end
	end
end

ereshkigal_r_wrapper(ereshkigal_r)
ereshkigal_r_wrapper(ereshkigal_r_upgrade_1)
ereshkigal_r_wrapper(ereshkigal_r_upgrade_2)
ereshkigal_r_wrapper(ereshkigal_r_upgrade_3)

---------------------------------------------

function modifier_ereshkigal_marble_aura_enemies:IsHidden() return false end
function modifier_ereshkigal_marble_aura_enemies:IsDebuff() return false end
function modifier_ereshkigal_marble_aura_enemies:IsPurgable() return false end
function modifier_ereshkigal_marble_aura_enemies:RemoveOnDeath() return true end
function modifier_ereshkigal_marble_aura_enemies:IsAura() return true end
function modifier_ereshkigal_marble_aura_enemies:IsAuraActiveOnDeath() return false end
function modifier_ereshkigal_marble_aura_enemies:GetAuraRadius()
	return self.radius
end
function modifier_ereshkigal_marble_aura_enemies:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_ereshkigal_marble_aura_enemies:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end
function modifier_ereshkigal_marble_aura_enemies:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end
function modifier_ereshkigal_marble_aura_enemies:GetModifierAura()
	return "modifier_ereshkigal_marble_aura_debuff"
end
function modifier_ereshkigal_marble_aura_enemies:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if IsServer() then
	function modifier_ereshkigal_marble_aura_enemies:OnCreated(args)
		self.caster = self:GetCaster()
		self.zone_dummy = self:GetParent()
		self.radius = args.Radius
		self.heal_reduction = args.HealReduction
		self.slow = args.Slow
		self.debuff = args.Debuff 
		CustomNetTables:SetTableValue("sync","ereshkigal_marble_debuff", {slow = self.slow, debuff = self.debuff, heal_reduction = self.heal_reduction})
		self:StartIntervalThink(FrameTime())
	end

	function modifier_ereshkigal_marble_aura_enemies:OnIntervalThink()
		if not self.caster:IsAlive() or (self.zone_dummy:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() > self.radius then 
			self.caster:RemoveModifierByName("modifier_ereshkigal_ghost_form")
			self:GetAbility():DestroyMarble(self.zone_dummy)
		end
	end

	function modifier_ereshkigal_marble_aura_enemies:OnDestroy()

	end
end

--------------------------

function modifier_ereshkigal_marble_aura_debuff:IsHidden() return false end
function modifier_ereshkigal_marble_aura_debuff:IsDebuff() return true end
function modifier_ereshkigal_marble_aura_debuff:IsPurgable() return false end
function modifier_ereshkigal_marble_aura_debuff:RemoveOnDeath() return true end
function modifier_ereshkigal_marble_aura_debuff:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_ereshkigal_marble_aura_debuff:GetTexture()
	return "custom/jeanne/jeanne_luminosite_eternelle"
end

function modifier_ereshkigal_marble_aura_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end

function modifier_ereshkigal_marble_aura_debuff:GetEffectName()
	return "particles/econ/events/ti5/radiant_fountain_regen_lvl2_ti5.vpcf"
end

function modifier_ereshkigal_marble_aura_debuff:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_ereshkigal_marble_aura_debuff:OnCreated(args)
	self.parent = self:GetParent() 
	self.debuff = CustomNetTables:GetTableValue("sync","ereshkigal_marble_debuff")
	self:SetStackCount(-self.debuff.heal_reduction)
end

function modifier_ereshkigal_marble_aura_debuff:OnRefresh(args)

end

function modifier_ereshkigal_marble_aura_debuff:OnDestroy()

end

function modifier_ereshkigal_marble_aura_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.debuff.slow 
end

function modifier_ereshkigal_marble_aura_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.debuff.slow 
end

function modifier_ereshkigal_marble_aura_debuff:GetModifierPhysicalArmorBonus()
	return self.debuff.debuff
end

function modifier_ereshkigal_marble_aura_debuff:GetModifierMagicalResistanceBonus()
	return self.debuff.debuff
end

-----------------------------------

function modifier_ereshkigal_marble_aura_allies:IsHidden() return false end
function modifier_ereshkigal_marble_aura_allies:IsDebuff() return false end
function modifier_ereshkigal_marble_aura_allies:IsPurgable() return false end
function modifier_ereshkigal_marble_aura_allies:RemoveOnDeath() return true end
function modifier_ereshkigal_marble_aura_allies:IsAura() return true end
function modifier_ereshkigal_marble_aura_allies:IsAuraActiveOnDeath() return false end
function modifier_ereshkigal_marble_aura_allies:GetAuraRadius()
	return self.radius
end
function modifier_ereshkigal_marble_aura_allies:GetAuraEntityReject(hEntity)
	if hEntity == self:GetCaster() then 
		return false 
	else
		return true 
	end
end
function modifier_ereshkigal_marble_aura_allies:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_ereshkigal_marble_aura_allies:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end
function modifier_ereshkigal_marble_aura_allies:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end
function modifier_ereshkigal_marble_aura_allies:GetModifierAura()
	return "modifier_ereshkigal_marble_aura_buff"
end
function modifier_ereshkigal_marble_aura_allies:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if IsServer() then
	function modifier_ereshkigal_marble_aura_allies:OnCreated(args)
		self.caster = self:GetCaster()
		self.zone_dummy = self:GetParent()
		self.radius = args.Radius
		self.buff = args.Buff 
		CustomNetTables:SetTableValue("sync","ereshkigal_marble_buff", {buff = self.buff})
	end

	function modifier_ereshkigal_marble_aura_allies:OnDestroy()

	end
end

--------------------------

function modifier_ereshkigal_marble_aura_buff:IsHidden() return false end
function modifier_ereshkigal_marble_aura_buff:IsDebuff() return true end
function modifier_ereshkigal_marble_aura_buff:IsPurgable() return false end
function modifier_ereshkigal_marble_aura_buff:RemoveOnDeath() return true end
function modifier_ereshkigal_marble_aura_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_ereshkigal_marble_aura_buff:GetTexture()
	return "custom/jeanne/jeanne_luminosite_eternelle"
end

function modifier_ereshkigal_marble_aura_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end

function modifier_ereshkigal_marble_aura_buff:GetEffectName()
	return "particles/econ/events/ti5/radiant_fountain_regen_lvl2_ti5.vpcf"
end

function modifier_ereshkigal_marble_aura_buff:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_ereshkigal_marble_aura_buff:OnCreated(args)
	self.parent = self:GetParent() 
	self.buff = CustomNetTables:GetTableValue("sync","ereshkigal_marble_buff")
end

function modifier_ereshkigal_marble_aura_buff:OnRefresh(args)

end

function modifier_ereshkigal_marble_aura_buff:OnDestroy()

end

function modifier_ereshkigal_marble_aura_buff:GetModifierPhysicalArmorBonus()
	return self.buff.buff 
end

function modifier_ereshkigal_marble_aura_buff:GetModifierMagicalResistanceBonus()
	return self.buff.buff 
end

------------------------------------

function modifier_ereshkigal_ghost_form:IsHidden() return false end
function modifier_ereshkigal_ghost_form:IsDebuff() return false end
function modifier_ereshkigal_ghost_form:IsPurgable() return false end
function modifier_ereshkigal_ghost_form:RemoveOnDeath() return true end
function modifier_ereshkigal_ghost_form:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_ereshkigal_ghost_form:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE}
end

function modifier_ereshkigal_ghost_form:GetModifierIncomingPhysicalDamage_Percentage()
	return self.buff
end

function modifier_ereshkigal_ghost_form:OnCreated(args)
	self.caster = self:GetCaster()
	self.buff = args.PhysicalDamage 
end

-----------------------

function modifier_ereshkigal_self_checker:IsHidden() return false end
function modifier_ereshkigal_self_checker:IsDebuff() return false end
function modifier_ereshkigal_self_checker:IsPurgable() return false end
function modifier_ereshkigal_self_checker:RemoveOnDeath() return true end
function modifier_ereshkigal_self_checker:IsAura() return true end
function modifier_ereshkigal_self_checker:IsAuraActiveOnDeath() return false end
function modifier_ereshkigal_self_checker:GetAuraRadius()
	return self.radius
end
function modifier_ereshkigal_self_checker:GetAuraEntityReject(hEntity)
	if hEntity == self:GetCaster() then 
		return true 
	else
		return false 
	end
end
function modifier_ereshkigal_self_checker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_ereshkigal_self_checker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end
function modifier_ereshkigal_self_checker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end
function modifier_ereshkigal_self_checker:GetModifierAura()
	return "modifier_ereshkigal_self"
end
function modifier_ereshkigal_self_checker:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if IsServer() then
	function modifier_ereshkigal_self_checker:OnCreated(args)
		self.caster = self:GetCaster()
		self.zone_dummy = self:GetParent()
		self.radius = args.Radius
	end

	function modifier_ereshkigal_self_checker:OnDestroy()

	end
end

------------------------------------

function modifier_ereshkigal_self:IsHidden() return true end
function modifier_ereshkigal_self:IsDebuff() return false end
function modifier_ereshkigal_self:IsPurgable() return false end
function modifier_ereshkigal_self:RemoveOnDeath() return true end
function modifier_ereshkigal_self:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_ereshkigal_self:OnCreated(args)
	self.caster = self:GetCaster()

end

function modifier_ereshkigal_self:OnDestroy()

end
