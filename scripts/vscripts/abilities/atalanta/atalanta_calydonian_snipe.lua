atalanta_calydonian_snipe = class({})
modifier_zero_armor = class({})

LinkLuaModifier("modifier_zero_armor", "abilities/atalanta/atalanta_calydonian_snipe", LUA_MODIFIER_MOTION_NONE)

function atalanta_calydonian_snipe:CastFilterResultTarget(hTarget)
	if not hTarget:HasModifier("modifier_calydonian_hunt_sight") or not self:GetCaster():HasArrow() then 
		return UF_FAIL_CUSTOM
	else
		return UF_SUCCESS
	end
end

function atalanta_calydonian_snipe:GetCustomCastErrorTarget(hTarget)
	if not hTarget:HasModifier("modifier_calydonian_hunt_sight") then 
		return "Invalid Target"
	elseif not self:GetCaster():HasArrow() then
		return "#Not_enough_arrows"
	end
end

function atalanta_calydonian_snipe:GetCastPoint()
	if self:GetCaster():HasModifier("modifier_tauropolos") then
		return self:GetSpecialValueFor("reduced_cast_delay")
	else
		return self:GetSpecialValueFor("cast_delay")
	end
end

function atalanta_calydonian_snipe:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	hCaster:EmitSound("Ability.Powershot.Alt")
	hCaster:UseArrow(1)

	local projectile = {
    	Target = hTarget,
		Source = hCaster,
		Ability = self,	
        EffectName = "particles/custom/atalanta/rainbow_arrow.vpcf",
        iMoveSpeed = 2500,
		vSourceLoc= hCaster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
        bDodgeable = true,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 7,
		bProvidesVision = false,
    }
    ProjectileManager:CreateTrackingProjectile(projectile)
end

function atalanta_calydonian_snipe:OnProjectileHit_ExtraData(hTarget, vLocation, tData)
	if hTarget == nil then return end

	local hCaster = self:GetCaster()
	local fDamage = hCaster:GetAverageTrueAttackDamage(hCaster) * self:GetSpecialValueFor("damage") / 100

	if hTarget:HasModifier("modifier_protection_from_arrows") then
		fDamage = fDamage * 0.65
	end

	hTarget:EmitSound("Hero_Enchantress.ImpetusDamage")
	hTarget:AddNewModifier(hCaster, self, "modifier_zero_armor", { Duration = 0.033 })
	DoDamage(hCaster, hTarget, fDamage, DAMAGE_TYPE_PHYSICAL, 0, self, false)
end

function modifier_zero_armor:DeclareFunctions()
	return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

if IsServer() then
	function modifier_zero_armor:OnCreated(args)
		self.ArmorReduction = (self:GetParent():GetPhysicalArmorValue(false) - self:GetParent():GetPhysicalArmorValue(true)) * -1
	end
end

function modifier_zero_armor:GetModifierPhysicalArmorBonus()
	return self.ArmorReduction
end

function modifier_zero_armor:IsHidden()
	return true 
end