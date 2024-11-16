
ereshkigal_r = class({})
ereshkigal_r_upgrade_1 = class({})
ereshkigal_r_upgrade_2 = class({})
ereshkigal_r_upgrade_3 = class({})
modifier_ereshkigal_marble_aura_enemies = class({})
modifier_ereshkigal_marble_aura_allies = class({})
modifier_ereshkigal_marble_aura_debuff = class({})
modifier_ereshkigal_marble_aura_buff = class({})
modifier_ereshkigal_ghost_form = class({})
modifier_ereshkigal_self_checker = class({})
modifier_ereshkigal_self = class({})
modifier_ereshkigal_anim_sfx = class({})

LinkLuaModifier("modifier_ereshkigal_marble_aura_enemies", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_marble_aura_allies", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_marble_aura_debuff", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_marble_aura_buff", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_ghost_form", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_self_checker", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_self", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_anim_sfx", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)

function ereshkigal_r_wrapper(ability)

	--[[function ability:GetAbilityTextureName()
		if self:GetCaster():HasModifier("modifier_ereshkigal_authority") then 
			return "custom/jeanne/jeanne_luminosite_eternelle_saint"
		else
			return "custom/jeanne/jeanne_luminosite_eternelle"
		end
	end]]

	function ability:GetAOERadius()
		if self:GetCaster():HasModifier("modifier_ereshkigal_authority") then 
			return self:GetSpecialValueFor("hell_aoe")
		else
			return self:GetSpecialValueFor("width")
		end
	end

	function ability:GetCastPoint()
		return 0
	end

	function ability:GetCastAnimation()
		return nil 
	end

	function ability:GetPlaybackRateOverride()
		return 1.0
	end
	
	function ability:OnSpellStart()
		self.caster = self:GetCaster()
		self.target_loc = self:GetCursorPosition()
		self.marble_origin = self.marble_origin or {}
		self.radius = self:GetSpecialValueFor("radius")
		self.width = self:GetSpecialValueFor("width")
		self.speed = self:GetSpecialValueFor("speed")
		self.root = self:GetSpecialValueFor("root_dur")
		self.hell_dur = self:GetSpecialValueFor("hell_dur")
		self.heal_red = self:GetSpecialValueFor("heal_red")
		self.origin = self.caster:GetAbsOrigin()
		self.damage = self:GetSpecialValueFor("damage")
		self.cast_time = self:GetSpecialValueFor("cast_time")
		if self.caster.IsUnderworldAcquired then 
			local bonus_int = self:GetSpecialValueFor("bonus_int") * self.caster:GetIntellect()
			self.damage = self.damage + bonus_int
		end
		if self.caster:HasModifier("modifier_ereshkigal_authority") then 

		end
		self.outer_dmg = self.damage * self:GetSpecialValueFor("outer_dmg")/100

		if self:IsCastInsideMarble(self.target_loc) then
			self.cast_time = self:GetSpecialValueFor("hell_cast")
			self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_anim_sfx", {Duration = self.cast_time})
			StartAnimation(self.caster, {duration = self.cast_time, activity = ACT_DOTA_CAST_ABILITY_4, rate = 2})
			self:GenerateSFX()
			Timers:CreateTimer(self.cast_time * 0.8, function()
				self:DestroySFX()
			end)
			Timers:CreateTimer(self.cast_time, function()
				if self.caster:IsAlive() then
					self:HellPillar()	
				end
			end)
		else
			self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_anim_sfx", {Duration = self.cast_time + 0.2})
			StartAnimation(self.caster, {duration = self.cast_time+0.2, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1})
			self:GenerateSFX()
			Timers:CreateTimer(self.cast_time * 0.8, function()
				self:DestroySFX()
			end)
			Timers:CreateTimer(self.cast_time, function()
				
				if self.caster:IsAlive() then
					self.LightningSFX1 = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
					ParticleManager:SetParticleControl(self.LightningSFX1, 0, self.caster:GetAbsOrigin() + Vector(0,0,1500))
					ParticleManager:SetParticleControl(self.LightningSFX1, 1, self.caster:GetAbsOrigin())
					ParticleManager:SetParticleControl(self.LightningSFX1, 2, self.caster:GetAbsOrigin()) 
					
					self.LightningSFX2 = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt_aoe.vpcf", PATTACH_WORLDORIGIN, self.caster)
					ParticleManager:SetParticleControl(self.LightningSFX2, 0, self.caster:GetAbsOrigin())
					ParticleManager:SetParticleControl(self.LightningSFX2, 1, Vector(180,0,0))
					local projectile = {
						Source = self.caster,
						EffectName = "particles/custom/ereshkigal/ereshkigal_red_light.vpcf",
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
			end)
		end

	end

	function ability:OnProjectileThinkHandle(iProjectileHandle)
		if (ProjectileManager:GetLinearProjectileLocation(iProjectileHandle) - self.origin):Length2D() >= self.radius - 50 then 
			print('projectile reach end')
			self:CreatePseudoMarble(ProjectileManager:GetLinearProjectileLocation(iProjectileHandle))
			ProjectileManager:DestroyLinearProjectile(iProjectileHandle)
		end
	end

	function ability:OnProjectileHit_ExtraData(hTarget, vLocation, tExtra)
		if hTarget == nil then return false end 

		DoDamage(self.caster, hTarget, tExtra.Damage, DAMAGE_TYPE_MAGICAL, 0, self, false)	
		hTarget:AddNewModifier(self.caster, self, "modifier_rooted", {Duration = tExtra.Root})

		if not hTarget:IsRealHero() then return false end

		local RockRootFX = ParticleManager:CreateParticle("particles/econ/items/earthshaker/deep_magma/deep_magma_cyan/deep_magma_cyan_fissure.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
		ParticleManager:SetParticleControl(RockRootFX, 0, hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControl(RockRootFX, 1, hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControl(RockRootFX, 2, Vector(tExtra.Root,0,0))

		Timers:CreateTimer(tExtra.root, function()
			ParticleManager:DestroyParticle(RockRootFX, true)
			ParticleManager:ReleaseParticleIndex(RockRootFX)
		end)

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

		self:CreatePseudoMarble(vLocation)

		return true	
	end

	function ability:GenerateSFX()
		self.SpinFx = ParticleManager:CreateParticle("particles/custom/ereshkigal/ereshkigal_blue_spin.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(self.SpinFx, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.SpinFx, 1,  self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(self.SpinFx, 3,  self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin(), false)
	end

	function ability:DestroySFX()
		ParticleManager:DestroyParticle(self.SpinFx, true)
		ParticleManager:ReleaseParticleIndex(self.SpinFx)
	end
	function ability:HellPillar()

		local tEnemies = FindUnitsInRadius(self.caster:GetTeam(), self.target_loc, nil, self:GetSpecialValueFor("hell_aoe"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		for _,enemy in pairs (tEnemies) do
			enemy:AddNewModifier(self.caster, self, "modifier_rooted", {Duration = self.root})
			local RockRootFX = ParticleManager:CreateParticle("particles/econ/items/earthshaker/deep_magma/deep_magma_cyan/deep_magma_cyan_fissure.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
			ParticleManager:SetParticleControl(RockRootFX, 0, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(RockRootFX, 1, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(RockRootFX, 2, Vector(self.root,0,0))
			DoDamage(self.caster, enemy, self.damage, DAMAGE_TYPE_MAGICAL, 0, self, false)	

			Timers:CreateTimer(self.root, function()
				ParticleManager:DestroyParticle(RockRootFX, true)
				ParticleManager:ReleaseParticleIndex(RockRootFX)
			end)
		end
	end

	function ability:UseSoul()
		if not self.caster:HasModifier("modifier_ereshkigal_authority") then return end

		if not self.caster.IsCrownAcquired then return end

		local ereshkigal_d = self.caster:FindAbilityByName(self.caster.DSkill)

		self.r_consume = ereshkigal_d:GetSpecialValueFor("r_consume")
		local soul_stack = self.caster:GetModifierStackCount("modifier_ereshkigal_soul", self.caster) or 0 

		if soul_stack >= self.r_consume then 
			ereshkigal_d:CollectSoul(-self.r_consume)
			self:EndCooldown()
		end
	end

	function ability:IsCastInsideMarble(vLocation)
		--print('check cast inside marble')
		self.caster = self:GetCaster()
		if not self.caster:HasModifier("modifier_ereshkigal_authority") then 
			print('not in marble')
			return false 
		end
		--[[for k,v in pairs(self.marble_origin) do 
			print(k,v)
		end]]

		for marble, center in pairs(self.marble_origin) do 
			if (center - vLocation):Length2D() <= self:GetSpecialValueFor("radius") then 
				print('cast inside marble')
				return true 
			end
		end

		return false
	end

	function ability:CreatePseudoMarble(vLocation) 
		self.caster = self:GetCaster()
		local zone = CreateUnitByName("sight_dummy_unit", vLocation, true, self.caster, self.caster, self.caster:GetTeamNumber())
		zone:AddNewModifier(self.caster, nil, "modifier_kill", {duration = self.hell_dur + 1})
		self.marble_origin.zone = vLocation
		local unseen = zone:FindAbilityByName("dummy_unit_passive")
    	unseen:SetLevel(1)
		local slow = 0
		local debuff = 0
		if self.caster.IsUnderworldAcquired then 
			slow = self:GetSpecialValueFor("slow")
			debuff = self:GetSpecialValueFor("def_debuff")
		end

		zone:AddNewModifier(self.caster, self, "modifier_ereshkigal_self_checker", {Duration = self.hell_dur,
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
		self.caster:RemoveModifierByName("modifier_ereshkigal_anim_sfx")
		return zone -- hZoneDummy
	end

	function ability:DestroyMarble(hDummy)
		if self:IsHellZoneExist(hDummy) then
			self.marble_origin.hDummy = nil
			hDummy:RemoveSelf()
		end
	end

	function ability:IsHellZoneExist(hDummy)
		if hDummy ~= nil and not hDummy:IsNull() and IsValidEntity(hDummy) then
			return true 
		end
		return false 
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
		self.ability = self:GetAbility()
		self.radius = args.Radius
		self.heal_reduction = args.HealReduction
		self.slow = args.Slow
		self.debuff = args.Debuff 
		CustomNetTables:SetTableValue("sync","ereshkigal_marble_debuff", {slow = self.slow, debuff = self.debuff, heal_reduction = self.heal_reduction})
		self:CreateZoneFx()
		self:StartIntervalThink(FrameTime())
	end

	function modifier_ereshkigal_marble_aura_enemies:OnIntervalThink()
		if not self.caster:IsAlive() or not self.caster:HasModifier("modifier_ereshkigal_authority") then 
			self.caster:RemoveModifierByName("modifier_ereshkigal_ghost_form")
			if self.ability == nil then 
				self.ability = self.caster:FindAbilityByName(self.caster.RSkill)
			end
			self.ability:DestroyMarble(self.zone_dummy)
		end
	end

	function modifier_ereshkigal_marble_aura_enemies:OnDestroy()
		self:RemoveZoneFx()
	end
end

function modifier_ereshkigal_marble_aura_enemies:CreateZoneFx()
	self.HellZoneFx = ParticleManager:CreateParticle("particles/custom/ereshkigal/ereshkigal_marble.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.HellZoneFx, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.HellZoneFx, 1, Vector(self.radius,self.radius,self.radius))
end

function modifier_ereshkigal_marble_aura_enemies:RemoveZoneFx()
	ParticleManager:DestroyParticle(self.HellZoneFx, true)
	ParticleManager:ReleaseParticleIndex(self.HellZoneFx)
end

--------------------------

function modifier_ereshkigal_marble_aura_debuff:IsHidden() return false end
function modifier_ereshkigal_marble_aura_debuff:IsDebuff() return true end
function modifier_ereshkigal_marble_aura_debuff:IsPurgable() return false end
function modifier_ereshkigal_marble_aura_debuff:RemoveOnDeath() return true end
function modifier_ereshkigal_marble_aura_debuff:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_ereshkigal_marble_aura_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end

function modifier_ereshkigal_marble_aura_debuff:GetEffectName()
	return "particles/units/heroes/hero_spectre/spectre_desolate_debuff.vpcf"
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
		return true 
	else
		return false 
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

function modifier_ereshkigal_ghost_form:GetTexture()
	return "custom/ereshkigal/ereshkigal_ghost_form"
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
		return false 
	else
		return true 
	end
end
function modifier_ereshkigal_self_checker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_ereshkigal_self_checker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end
function modifier_ereshkigal_self_checker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
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

if IsServer() then
	function modifier_ereshkigal_self:OnCreated(args)
		self.caster = self:GetCaster()
		self.caster:FindAbilityByName(self.caster.DSkill):ApplyDeathAuthority()
		self:GetAbility():UseSoul()
	end

	function modifier_ereshkigal_self:OnRemoved()
		self.caster:FindAbilityByName(self.caster.DSkill):LossDeathAuthority()
	end
end

-------------------- 

function modifier_ereshkigal_anim_sfx:IsHidden() return true end
function modifier_ereshkigal_anim_sfx:IsDebuff() return false end
function modifier_ereshkigal_anim_sfx:IsPurgable() return false end
function modifier_ereshkigal_anim_sfx:RemoveOnDeath() return true end
function modifier_ereshkigal_anim_sfx:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_ereshkigal_anim_sfx:CheckState()
    local state = { [MODIFIER_STATE_MUTED] = true,
                    [MODIFIER_STATE_DISARMED] = true,
                    [MODIFIER_STATE_SILENCED] = true,
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                }
    return state
end
if IsServer() then
	function modifier_ereshkigal_anim_sfx:OnCreated(args)
		self.caster = self:GetCaster()
		--self:CreateFx()
		--self:StartIntervalThink(0.19)
	end

	function modifier_ereshkigal_anim_sfx:OnRefresh(args)
		self:OnCreated(args)
	end

	function modifier_ereshkigal_anim_sfx:OnIntervalThink()
		--self.lightning = ParticleManager:CreateParticle("particles/custom/ereshkigal/ereshkigal_blue_spin_lightning_b.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
		--ParticleManager:SetParticleControl(self.lightning, 0, self:GetParent():GetAbsOrigin() + Vector(RandomInt(-256, 256), RandomInt(-256, 256),500))
		--ParticleManager:SetParticleControlEnt(self.lightning, 1,  self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), false)
	end

	function modifier_ereshkigal_anim_sfx:OnRemoved()
		--self:RemoveFx()
	end
end

function modifier_ereshkigal_anim_sfx:CreateFx()
	self.SpinFx = ParticleManager:CreateParticle("particles/custom/ereshkigal/ereshkigal_blue_spin.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.SpinFx, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(self.SpinFx, 1,  self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(self.SpinFx, 3,  self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), false)
end

function modifier_ereshkigal_anim_sfx:RemoveFx()
	ParticleManager:DestroyParticle(self.SpinFx, true)
	ParticleManager:ReleaseParticleIndex(self.SpinFx)
end

