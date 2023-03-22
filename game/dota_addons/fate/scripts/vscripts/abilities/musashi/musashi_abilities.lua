local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
local ____dota_ts_adapter = require("libs.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerAbility = ____dota_ts_adapter.registerAbility
local registerModifier = ____dota_ts_adapter.registerModifier
local ____skill_utils = require("libs.skill_utils")
local CheckComboStatsFulfilled = ____skill_utils.CheckComboStatsFulfilled
local InitComboSequenceChecker = ____skill_utils.InitComboSequenceChecker
local InitSkillSlotChecker = ____skill_utils.InitSkillSlotChecker
local ____sleep_timer = require("libs.sleep_timer")
local Sleep = ____sleep_timer.Sleep
____exports.musashi_accel_turn = __TS__Class()
local musashi_accel_turn = ____exports.musashi_accel_turn
musashi_accel_turn.name = "musashi_accel_turn"
__TS__ClassExtends(musashi_accel_turn, BaseAbility)
function musashi_accel_turn.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_ability_manavoid_07"
    self.SoundSfx = "musashi_accel_turn_sfx"
end
function musashi_accel_turn.prototype.OnSpellStart(self)
    self.Caster = self:GetCaster()
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_accel_turn.name, {undefined = undefined})
    self:CreateProjectile()
    self:PlaySound()
end
function musashi_accel_turn.prototype.CreateProjectile(self)
    local ParticleStr = "particles/custom/musashi/musashi_accel_turn_basic.vpcf"
    local ____opt_0 = self.Caster
    if ____opt_0 and ____opt_0:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_accel_turn_unique.vpcf"
    end
    local ____opt_2 = self.Caster
    local Direction = ____opt_2 and ____opt_2:GetForwardVector():__unm()
    local ____ProjectileManager_CreateLinearProjectile_8 = ProjectileManager.CreateLinearProjectile
    local ____ParticleStr_6 = ParticleStr
    local ____self_Caster_7 = self.Caster
    local ____opt_4 = self.Caster
    ____ProjectileManager_CreateLinearProjectile_8(
        ProjectileManager,
        {
            EffectName = ____ParticleStr_6,
            Ability = self,
            Source = ____self_Caster_7,
            vSpawnOrigin = ____opt_4 and ____opt_4:GetAbsOrigin(),
            vVelocity = Direction * self:GetSpecialValueFor("ProjectileSpeed"),
            fDistance = self:GetSpecialValueFor("Range"),
            fStartRadius = self:GetSpecialValueFor("ProjectileRadius"),
            fEndRadius = self:GetSpecialValueFor("ProjectileRadius"),
            iUnitTargetTeam = self:GetAbilityTargetTeam(),
            iUnitTargetFlags = self:GetAbilityTargetFlags(),
            iUnitTargetType = self:GetAbilityTargetType()
        }
    )
end
function musashi_accel_turn.prototype.OnProjectileHit(self, target)
    if not IsServer() then
        return
    end
    local Damage = self:GetSpecialValueFor("Damage")
    local DmgType = self:GetAbilityDamageType()
    local DmgFlag = DOTA_DAMAGE_FLAG_NONE
    DoDamage(
        self.Caster,
        target,
        Damage,
        DmgType,
        DmgFlag,
        self,
        false
    )
end
function musashi_accel_turn.prototype.PlaySound(self)
    local ____opt_9 = self.Caster
    if ____opt_9 ~= nil then
        ____opt_9:EmitSound(self.SoundVoiceline)
    end
    local ____opt_11 = self.Caster
    if ____opt_11 ~= nil then
        ____opt_11:EmitSound(self.SoundSfx)
    end
end
function musashi_accel_turn.prototype.GetCastRange(self)
    if IsServer() then
        return 0
    else
        return self:GetSpecialValueFor("DashRange")
    end
end
musashi_accel_turn = __TS__Decorate(
    {registerAbility(nil)},
    musashi_accel_turn
)
____exports.musashi_accel_turn = musashi_accel_turn
____exports.musashi_modifier_accel_turn = __TS__Class()
local musashi_modifier_accel_turn = ____exports.musashi_modifier_accel_turn
musashi_modifier_accel_turn.name = "musashi_modifier_accel_turn"
__TS__ClassExtends(musashi_modifier_accel_turn, BaseModifier)
function musashi_modifier_accel_turn.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.Direction = Vector(0, 0, 0)
    self.UnitsTravelled = 0
    self.DashRange = 0
    self.DashSpeed = 0
end
function musashi_modifier_accel_turn.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_13 = self.Ability
    self.Direction = ____opt_13 and ____opt_13:GetForwardVector():__unm()
    local ____opt_15 = self.Ability
    self.DashRange = ____opt_15 and ____opt_15:GetSpecialValueFor("Range")
    local ____opt_17 = self.Ability
    self.DashSpeed = ____opt_17 and ____opt_17:GetSpecialValueFor("DashSpeed")
    ProjectileManager:ProjectileDodge(self.Caster)
    self:StartIntervalThink(0.03)
end
function musashi_modifier_accel_turn.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_19 = self.Caster
    if ____opt_19 ~= nil then
        ____opt_19:SetForwardVector(self.Direction)
    end
    local ____opt_21 = self.Caster
    local CurrentOrigin = ____opt_21 and ____opt_21:GetAbsOrigin()
    local ____opt_23 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_23 and ____opt_23:GetForwardVector()) * self.DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_25 = self.Caster
    if ____opt_25 ~= nil then
        ____opt_25:SetAbsOrigin(NewPosition)
    end
    if self.UnitsTravelled >= self.DashRange then
        self:Destroy()
    end
end
function musashi_modifier_accel_turn.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_27 = self.Caster
    if ____opt_27 ~= nil then
        ____opt_27:SetForwardVector(self.Caster:GetAbsOrigin():Normalized())
    end
    local ____FindClearSpaceForUnit_32 = FindClearSpaceForUnit
    local ____self_Caster_31 = self.Caster
    local ____opt_29 = self.Caster
    ____FindClearSpaceForUnit_32(
        ____self_Caster_31,
        ____opt_29 and ____opt_29:GetAbsOrigin(),
        true
    )
    local ____opt_33 = self.Caster
    if ____opt_33 ~= nil then
        ____opt_33:AddNewModifier(self.Caster, self.Ability, "modifier_phased", {duration = 1})
    end
end
function musashi_modifier_accel_turn.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE}
end
function musashi_modifier_accel_turn.prototype.GetOverrideAnimation(self)
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function musashi_modifier_accel_turn.prototype.GetOverrideAnimationRate(self)
    return 2
end
function musashi_modifier_accel_turn.prototype.CheckState(self)
    local ModifierTable = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
    }
    return ModifierTable
end
function musashi_modifier_accel_turn.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_accel_turn.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_accel_turn = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_accel_turn
)
____exports.musashi_modifier_accel_turn = musashi_modifier_accel_turn
____exports.musashi_dai_go_sei = __TS__Class()
local musashi_dai_go_sei = ____exports.musashi_dai_go_sei
musashi_dai_go_sei.name = "musashi_dai_go_sei"
__TS__ClassExtends(musashi_dai_go_sei, BaseAbility)
function musashi_dai_go_sei.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_cast_01"
    self.SoundSfx = "musashi_dai_go_sei_sfx"
end
function musashi_dai_go_sei.prototype.OnAbilityPhaseStart(self)
    self.Caster = self:GetCaster()
    local Victim = self:GetCursorTarget()
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    local StunDuration = self:GetSpecialValueFor("StunDuration")
    local Damage = self:GetSpecialValueFor("Damage")
    local ____opt_35 = self.Caster
    if ____opt_35 ~= nil then
        ____opt_35:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_dai_go_sei.name, {duration = BuffDuration})
    end
    local ____opt_37 = self.Caster
    if ____opt_37 ~= nil then
        ____opt_37:SetAbsOrigin(Victim and Victim:GetAbsOrigin())
    end
    local ____FindClearSpaceForUnit_44 = FindClearSpaceForUnit
    local ____self_Caster_43 = self.Caster
    local ____opt_41 = self.Caster
    ____FindClearSpaceForUnit_44(
        ____self_Caster_43,
        ____opt_41 and ____opt_41:GetAbsOrigin(),
        true
    )
    Victim:AddNewModifier(self.Caster, self, "modifier_stunned", {duration = StunDuration})
    DoDamage(
        self.Caster,
        Victim,
        Damage,
        self:GetAbilityDamageType(),
        DOTA_DAMAGE_FLAG_NONE,
        self,
        false
    )
    self:PlaySound()
end
function musashi_dai_go_sei.prototype.PlaySound(self)
    local ____opt_45 = self.Caster
    if ____opt_45 ~= nil then
        ____opt_45:EmitSound(self.SoundVoiceline)
    end
    local ____opt_47 = self.Caster
    if ____opt_47 ~= nil then
        ____opt_47:EmitSound(self.SoundSfx)
    end
end
musashi_dai_go_sei = __TS__Decorate(
    {registerAbility(nil)},
    musashi_dai_go_sei
)
____exports.musashi_dai_go_sei = musashi_dai_go_sei
____exports.musashi_modifier_dai_go_sei = __TS__Class()
local musashi_modifier_dai_go_sei = ____exports.musashi_modifier_dai_go_sei
musashi_modifier_dai_go_sei.name = "musashi_modifier_dai_go_sei"
__TS__ClassExtends(musashi_modifier_dai_go_sei, BaseModifier)
function musashi_modifier_dai_go_sei.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.HitsRequired = 0
end
function musashi_modifier_dai_go_sei.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_49 = self.Ability
    self.BonusDmg = ____opt_49 and ____opt_49:GetSpecialValueFor("BonusDmg")
    local ____opt_51 = self.Ability
    self.BonusAtkSpeed = ____opt_51 and ____opt_51:GetSpecialValueFor("BonusAtkSpeed")
    local ____opt_53 = self.Ability
    self.HitsRequired = ____opt_53 and ____opt_53:GetSpecialValueFor("HitsRequired")
    local ____opt_55 = self.Caster
    if ____opt_55 and ____opt_55:HasModifier(____exports.musashi_modifier_tengan.name) then
        local ____opt_57 = self.Ability
        local TenganBonusRatio = ____opt_57 and ____opt_57:GetSpecialValueFor("TenganBonusRatio")
        self.BonusDmg = self.BonusDmg * TenganBonusRatio
        self.BonusAtkSpeed = self.BonusAtkSpeed * TenganBonusRatio
    end
    self:SetHasCustomTransmitterData(true)
    self:CreateParticle()
end
function musashi_modifier_dai_go_sei.prototype.OnRefresh(self)
    if not IsServer() then
        return
    end
    self:OnCreated()
end
function musashi_modifier_dai_go_sei.prototype.AddCustomTransmitterData(self)
    local data = {BonusDmg = self.BonusDmg, BonusAtkSpeed = self.BonusAtkSpeed}
    return data
end
function musashi_modifier_dai_go_sei.prototype.HandleCustomTransmitterData(self, data)
    self.BonusDmg = data.BonusDmg
    self.BonusAtkSpeed = data.BonusAtkSpeed
end
function musashi_modifier_dai_go_sei.prototype.OnAttackLanded(self, event)
    if not IsServer() then
        return
    end
    if event.attacker == self.Caster and event.target:IsRealHero() then
        if self:GetStackCount() < self.HitsRequired then
            self:IncrementStackCount()
        end
    end
end
function musashi_modifier_dai_go_sei.prototype.OnStackCountChanged(self, stackCount)
    if not IsServer() then
        return
    end
    if stackCount == self.HitsRequired - 1 then
        print("hairo")
    end
end
function musashi_modifier_dai_go_sei.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_basic.vpcf"
    local BlueOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_basic.vpcf"
    local RedOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_redorb_basic.vpcf"
    local ____opt_59 = self.Caster
    if ____opt_59 and ____opt_59:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_unique.vpcf"
        BlueOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_unique.vpcf"
        RedOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_redorb_unique.vpcf"
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
    local BlueOrbParticle = ParticleManager:CreateParticle(BlueOrbParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    local RedOrbParticle = ParticleManager:CreateParticle(RedOrbParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    ParticleManager:SetParticleControlEnt(
        BlueOrbParticle,
        1,
        self.Caster,
        PATTACH_POINT_FOLLOW,
        "attach_attack2",
        Vector(0, 0, 0),
        false
    )
    ParticleManager:SetParticleControlEnt(
        RedOrbParticle,
        1,
        self.Caster,
        PATTACH_POINT_FOLLOW,
        "attach_attack1",
        Vector(0, 0, 0),
        false
    )
    self:AddParticle(
        Particle,
        false,
        false,
        -1,
        false,
        false
    )
    self:AddParticle(
        BlueOrbParticle,
        false,
        false,
        -1,
        false,
        false
    )
    self:AddParticle(
        RedOrbParticle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_dai_go_sei.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_EVENT_ON_ATTACK_LANDED}
end
function musashi_modifier_dai_go_sei.prototype.GetModifierPreAttack_BonusDamage(self)
    return self.BonusDmg
end
function musashi_modifier_dai_go_sei.prototype.GetModifierAttackSpeedBonus_Constant(self)
    return self.BonusAtkSpeed
end
function musashi_modifier_dai_go_sei.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_dai_go_sei.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_dai_go_sei = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_dai_go_sei
)
____exports.musashi_modifier_dai_go_sei = musashi_modifier_dai_go_sei
____exports.musashi_niou_kurikara = __TS__Class()
local musashi_niou_kurikara = ____exports.musashi_niou_kurikara
musashi_niou_kurikara.name = "musashi_niou_kurikara"
__TS__ClassExtends(musashi_niou_kurikara, BaseAbility)
function musashi_niou_kurikara.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_cast_03"
    self.Interval = 0
    self.SlashCount = 0
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseStart(self)
    self.Caster = self:GetCaster()
    self.NiouSkill = self.Caster:FindAbilityByName(____exports.musashi_niou.name)
    self.Caster:CastAbilityImmediately(
        self.NiouSkill,
        self.Caster:GetEntityIndex()
    )
    self.Niou = self.NiouSkill.Niou
    local ____opt_61 = self.Niou
    if ____opt_61 ~= nil then
        ____opt_61:FaceTowards(self:GetCursorPosition())
    end
    return true
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseInterrupted(self)
    local ____opt_63 = self.NiouSkill
    if ____opt_63 ~= nil then
        ____opt_63:DestroyNiou(0)
    end
end
function musashi_niou_kurikara.prototype.OnSpellStart(self)
    local ____opt_65 = self.Caster
    if ____opt_65 ~= nil then
        ____opt_65:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_niou_kurikara_channeling.name, {duration = 1.5})
    end
    local ____opt_67 = self.Niou
    if ____opt_67 ~= nil then
        ____opt_67:StartGestureWithPlaybackRate(ACT_DOTA_CHANNEL_ABILITY_1, 1.1)
    end
    local ____opt_69 = self.Caster
    if not (____opt_69 and ____opt_69:HasModifier(____exports.musashi_modifier_ishana_daitenshou.name)) then
        EmitGlobalSound(self.SoundVoiceline)
    end
end
function musashi_niou_kurikara.prototype.OnUpgrade(self)
    local ____opt_71 = self.NiouSkill
    if ____opt_71 ~= nil then
        ____opt_71:SetLevel(self:GetLevel())
    end
end
function musashi_niou_kurikara.prototype.GetAOERadius(self)
    return self:GetSpecialValueFor("Radius")
end
musashi_niou_kurikara = __TS__Decorate(
    {registerAbility(nil)},
    musashi_niou_kurikara
)
____exports.musashi_niou_kurikara = musashi_niou_kurikara
____exports.musashi_modifier_niou_kurikara_channeling = __TS__Class()
local musashi_modifier_niou_kurikara_channeling = ____exports.musashi_modifier_niou_kurikara_channeling
musashi_modifier_niou_kurikara_channeling.name = "musashi_modifier_niou_kurikara_channeling"
__TS__ClassExtends(musashi_modifier_niou_kurikara_channeling, BaseModifier)
function musashi_modifier_niou_kurikara_channeling.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.SoundSfx = "musashi_niou_kurikara_sfx"
    self.TargetPoint = Vector(0, 0, 0)
    self.SlashCount = 0
end
function musashi_modifier_niou_kurikara_channeling.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_73 = self.Ability
    self.TargetPoint = ____opt_73 and ____opt_73:GetCursorPosition()
    giveUnitDataDrivenModifier(self.Caster, self.Caster, "pause_sealdisabled", 1.5)
    self:IncrementStackCount()
    self:StartIntervalThink(0.5)
end
function musashi_modifier_niou_kurikara_channeling.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    self:IncrementStackCount()
end
function musashi_modifier_niou_kurikara_channeling.prototype.OnStackCountChanged(self)
    if not IsServer() then
        return
    end
    self:DealDamage()
    self:CreateParticle()
    EmitSoundOnLocationWithCaster(self.TargetPoint, self.SoundSfx, self.Caster)
end
function musashi_modifier_niou_kurikara_channeling.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_75 = self.Caster
    local NiouSkill = ____opt_75 and ____opt_75:FindAbilityByName(____exports.musashi_niou.name)
    NiouSkill:DestroyNiou(1)
    local ____opt_77 = self.Ability
    local BuffDuration = ____opt_77 and ____opt_77:GetSpecialValueFor("BuffDuration")
    local ____opt_79 = self.Caster
    if ____opt_79 ~= nil then
        ____opt_79:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_niou_kurikara_postchannel_buff.name, {duration = BuffDuration})
    end
    local ____opt_81 = self.Caster
    local ModifierIshanaDaitenshou = ____opt_81 and ____opt_81:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    if ModifierIshanaDaitenshou ~= nil then
        ModifierIshanaDaitenshou:IncrementStackCount()
    end
end
function musashi_modifier_niou_kurikara_channeling.prototype.DealDamage(self)
    self.SlashCount = self.SlashCount + 1
    local ____opt_85 = self.Ability
    local Damage = ____opt_85 and ____opt_85:GetSpecialValueFor("DmgPerSlash")
    local ____opt_87 = self.Ability
    local DmgType = ____opt_87 and ____opt_87:GetAbilityDamageType()
    local ____opt_89 = self.Ability
    local TargetFlags = ____opt_89 and ____opt_89:GetAbilityTargetFlags()
    local DmgFlag = DOTA_DAMAGE_FLAG_NONE
    local Targets
    local ____opt_91 = self.Caster
    local ____temp_95 = ____opt_91 and ____opt_91:HasModifier(____exports.musashi_modifier_tenma_gogan.name)
    if not ____temp_95 then
        local ____opt_93 = self.Caster
        ____temp_95 = ____opt_93 and ____opt_93:HasModifier(____exports.musashi_modifier_ishana_daitenshou.name)
    end
    if ____temp_95 then
        DmgType = DAMAGE_TYPE_PURE
        DmgFlag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS
        TargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    end
    local ____FindUnitsInRadius_105 = FindUnitsInRadius
    local ____opt_96 = self.Caster
    local ____array_104 = __TS__SparseArrayNew(
        ____opt_96 and ____opt_96:GetTeam(),
        self.TargetPoint,
        nil
    )
    local ____opt_98 = self.Ability
    __TS__SparseArrayPush(
        ____array_104,
        ____opt_98 and ____opt_98:GetAOERadius()
    )
    local ____opt_100 = self.Ability
    __TS__SparseArrayPush(
        ____array_104,
        ____opt_100 and ____opt_100:GetAbilityTargetTeam()
    )
    local ____opt_102 = self.Ability
    __TS__SparseArrayPush(
        ____array_104,
        ____opt_102 and ____opt_102:GetAbilityTargetType(),
        TargetFlags,
        FIND_ANY_ORDER,
        false
    )
    Targets = ____FindUnitsInRadius_105(__TS__SparseArraySpread(____array_104))
    for ____, Iterator in ipairs(Targets) do
        local ____opt_106 = self.Caster
        if ____opt_106 and ____opt_106:HasModifier("musashi_attribute_gorin_no_sho") then
            self:ApplyElementalDebuffs(Iterator)
        end
        DoDamage(
            self.Caster,
            Iterator,
            Damage,
            DmgType,
            DmgFlag,
            self.Ability,
            false
        )
    end
    local ____opt_108 = self.Caster
    local ModifierTengan = ____opt_108 and ____opt_108:FindModifierByName(____exports.musashi_modifier_tengan.name)
    if self.SlashCount == 4 and ModifierTengan then
        DmgType = DAMAGE_TYPE_PURE
        DmgFlag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
        TargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
        local ____FindUnitsInRadius_119 = FindUnitsInRadius
        local ____opt_110 = self.Caster
        local ____array_118 = __TS__SparseArrayNew(
            ____opt_110 and ____opt_110:GetTeam(),
            self.TargetPoint,
            nil
        )
        local ____opt_112 = self.Ability
        __TS__SparseArrayPush(
            ____array_118,
            ____opt_112 and ____opt_112:GetAOERadius()
        )
        local ____opt_114 = self.Ability
        __TS__SparseArrayPush(
            ____array_118,
            ____opt_114 and ____opt_114:GetAbilityTargetTeam()
        )
        local ____opt_116 = self.Ability
        __TS__SparseArrayPush(
            ____array_118,
            ____opt_116 and ____opt_116:GetAbilityTargetType(),
            TargetFlags,
            FIND_ANY_ORDER,
            false
        )
        Targets = ____FindUnitsInRadius_119(__TS__SparseArraySpread(____array_118))
        for ____, Iterator in ipairs(Targets) do
            DoDamage(
                self.Caster,
                Iterator,
                ModifierTengan.BonusDmg,
                DmgType,
                DmgFlag,
                self.Ability,
                false
            )
        end
        local ____opt_120 = self.Caster
        local ModifierTenmaGogan = ____opt_120 and ____opt_120:FindModifierByName(____exports.musashi_modifier_tenma_gogan.name)
        ModifierTengan:Destroy()
        if ModifierTenmaGogan ~= nil then
            ModifierTenmaGogan:Destroy()
        end
    end
end
function musashi_modifier_niou_kurikara_channeling.prototype.ApplyElementalDebuffs(self, Target)
    local ____opt_124 = self.Caster
    local GorinNoSho = ____opt_124 and ____opt_124:FindModifierByName("musashi_attribute_gorin_no_sho")
    local AttributeAbility = GorinNoSho and GorinNoSho:GetAbility()
    repeat
        local ____switch70 = self.SlashCount
        local ____cond70 = ____switch70 == 1
        if ____cond70 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("DebuffDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_earth_debuff.name, {duration = DebuffDuration})
                break
            end
        end
        ____cond70 = ____cond70 or ____switch70 == 2
        if ____cond70 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("DebuffDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_water_debuff.name, {duration = DebuffDuration})
                break
            end
        end
        ____cond70 = ____cond70 or ____switch70 == 3
        if ____cond70 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("FireBurnDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_fire_debuff.name, {duration = DebuffDuration})
                break
            end
        end
        ____cond70 = ____cond70 or ____switch70 == 4
        if ____cond70 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("WindDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_wind_debuff.name, {duration = DebuffDuration})
                break
            end
        end
    until true
end
function musashi_modifier_niou_kurikara_channeling.prototype.CreateParticle(self)
    local ____opt_136 = self.Caster
    if ____opt_136 and ____opt_136:HasModifier("modifier_ascended") then
        local AoeParticleStr = ""
        local CrackParticleStr = ""
        repeat
            local ____switch77 = self.SlashCount
            local ____cond77 = ____switch77 == 1
            if ____cond77 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond77 = ____cond77 or ____switch77 == 2
            if ____cond77 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water_crack.vpcf"
                    break
                end
            end
            ____cond77 = ____cond77 or ____switch77 == 3
            if ____cond77 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire_crack.vpcf"
                    break
                end
            end
            ____cond77 = ____cond77 or ____switch77 == 4
            if ____cond77 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind_crack.vpcf"
                    break
                end
            end
        until true
        local AoeParticle = ParticleManager:CreateParticle(AoeParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        local CrackParticle = ParticleManager:CreateParticle(CrackParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        ParticleManager:SetParticleControl(CrackParticle, 0, self.TargetPoint)
        ParticleManager:SetParticleControl(AoeParticle, 0, self.TargetPoint)
        ParticleManager:SetParticleControl(
            AoeParticle,
            1,
            Vector(1.5, 0, 0)
        )
        local ____ParticleManager_SetParticleControl_140 = ParticleManager.SetParticleControl
        local ____opt_138 = self.Ability
        ____ParticleManager_SetParticleControl_140(
            ParticleManager,
            AoeParticle,
            12,
            Vector(
                ____opt_138 and ____opt_138:GetAOERadius(),
                0,
                0
            )
        )
    else
        local AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_basic.vpcf"
        local AoeParticle = ParticleManager:CreateParticle(AoeParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        ParticleManager:SetParticleControl(AoeParticle, 0, self.TargetPoint)
        ParticleManager:SetParticleControl(
            AoeParticle,
            1,
            Vector(1.5, 0, 0)
        )
        local ____ParticleManager_SetParticleControl_143 = ParticleManager.SetParticleControl
        local ____opt_141 = self.Ability
        ____ParticleManager_SetParticleControl_143(
            ParticleManager,
            AoeParticle,
            2,
            Vector(
                ____opt_141 and ____opt_141:GetAOERadius(),
                0,
                0
            )
        )
    end
end
function musashi_modifier_niou_kurikara_channeling.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_144 = self:GetAbility()
    return ____opt_144 and ____opt_144:GetSpecialValueFor("DmgReducWhileChannel")
end
function musashi_modifier_niou_kurikara_channeling.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE}
end
function musashi_modifier_niou_kurikara_channeling.prototype.GetOverrideAnimation(self)
    return ACT_DOTA_CHANNEL_ABILITY_1
end
function musashi_modifier_niou_kurikara_channeling.prototype.GetOverrideAnimationRate(self)
    return 0.5
end
function musashi_modifier_niou_kurikara_channeling.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_niou_kurikara_channeling.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_niou_kurikara_channeling = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_niou_kurikara_channeling
)
____exports.musashi_modifier_niou_kurikara_channeling = musashi_modifier_niou_kurikara_channeling
____exports.musashi_modifier_earth_debuff = __TS__Class()
local musashi_modifier_earth_debuff = ____exports.musashi_modifier_earth_debuff
musashi_modifier_earth_debuff.name = "musashi_modifier_earth_debuff"
__TS__ClassExtends(musashi_modifier_earth_debuff, BaseModifier)
function musashi_modifier_earth_debuff.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end
function musashi_modifier_earth_debuff.prototype.GetModifierMoveSpeedBonus_Percentage(self)
    local ____opt_146 = self:GetAbility()
    return ____opt_146 and ____opt_146:GetSpecialValueFor("EarthSlow")
end
musashi_modifier_earth_debuff = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_earth_debuff
)
____exports.musashi_modifier_earth_debuff = musashi_modifier_earth_debuff
____exports.musashi_modifier_water_debuff = __TS__Class()
local musashi_modifier_water_debuff = ____exports.musashi_modifier_water_debuff
musashi_modifier_water_debuff.name = "musashi_modifier_water_debuff"
__TS__ClassExtends(musashi_modifier_water_debuff, BaseModifier)
function musashi_modifier_water_debuff.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.TargetPoint = Vector(0, 0, 0)
    self.PushSpeed = 0
end
function musashi_modifier_water_debuff.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Victim = self:GetParent()
    self.Attribute = self:GetAbility()
    local ____opt_148 = self.Caster
    local ModifierNiouKurikara = ____opt_148 and ____opt_148:FindModifierByName(____exports.musashi_modifier_niou_kurikara_channeling.name)
    self.TargetPoint = ModifierNiouKurikara.TargetPoint
    local ____opt_150 = self.Attribute
    self.PushSpeed = ____opt_150 and ____opt_150:GetSpecialValueFor("PushSpeed")
    local ____opt_152 = self.Victim
    if ____opt_152 ~= nil then
        ____opt_152:AddNewModifier(self.Caster, self.Attribute, "modifier_rooted", {duration = 1})
    end
    giveUnitDataDrivenModifier(
        self.Caster,
        self.Victim,
        "locked",
        self:GetDuration()
    )
    self:StartIntervalThink(0.03)
end
function musashi_modifier_water_debuff.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_154 = self.Victim
    local CurrentOrigin = ____opt_154 and ____opt_154:GetAbsOrigin()
    local ForwardVector = (self.TargetPoint - CurrentOrigin):Normalized()
    local ____opt_156 = self.Victim
    if ____opt_156 ~= nil then
        ____opt_156:SetForwardVector(ForwardVector)
    end
    local ____opt_158 = self.Victim
    local NewPosition = CurrentOrigin + (____opt_158 and ____opt_158:GetForwardVector()) * self.PushSpeed
    local ____opt_160 = self.Victim
    if ____opt_160 ~= nil then
        ____opt_160:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_164 = Entities.FindByNameWithin
    local ____opt_162 = self.Victim
    local VictimEntity = ____Entities_FindByNameWithin_164(
        Entities,
        nil,
        ____opt_162 and ____opt_162:GetName(),
        self.TargetPoint,
        self.PushSpeed
    )
    if VictimEntity then
        self:Destroy()
    end
end
function musashi_modifier_water_debuff.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_165 = self.Victim
    if ____opt_165 ~= nil then
        ____opt_165:SetForwardVector(self.Victim:GetAbsOrigin():Normalized())
    end
    local ____FindClearSpaceForUnit_170 = FindClearSpaceForUnit
    local ____self_Victim_169 = self.Victim
    local ____opt_167 = self.Victim
    ____FindClearSpaceForUnit_170(
        ____self_Victim_169,
        ____opt_167 and ____opt_167:GetAbsOrigin(),
        true
    )
    local ____opt_171 = self.Victim
    if ____opt_171 ~= nil then
        ____opt_171:AddNewModifier(self.Victim, self.Attribute, "modifier_phased", {duration = 1})
    end
end
musashi_modifier_water_debuff = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_water_debuff
)
____exports.musashi_modifier_water_debuff = musashi_modifier_water_debuff
____exports.musashi_modifier_fire_debuff = __TS__Class()
local musashi_modifier_fire_debuff = ____exports.musashi_modifier_fire_debuff
musashi_modifier_fire_debuff.name = "musashi_modifier_fire_debuff"
__TS__ClassExtends(musashi_modifier_fire_debuff, BaseModifier)
function musashi_modifier_fire_debuff.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.Damage = 0
end
function musashi_modifier_fire_debuff.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Victim = self:GetParent()
    self.Ability = self:GetAbility()
    local ____opt_173 = self.Ability
    local DebuffDuration = ____opt_173 and ____opt_173:GetSpecialValueFor("DebuffDuration")
    local ____opt_175 = self.Ability
    self.Damage = ____opt_175 and ____opt_175:GetSpecialValueFor("FireBurnDmgPerSec")
    self:StartIntervalThink(DebuffDuration)
    self:CreateParticle()
end
function musashi_modifier_fire_debuff.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local DmgType = DAMAGE_TYPE_MAGICAL
    local DmgFlag = DOTA_DAMAGE_FLAG_NONE
    DoDamage(
        self.Caster,
        self.Victim,
        self.Damage,
        DmgType,
        DmgFlag,
        self.Ability,
        false
    )
end
function musashi_modifier_fire_debuff.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_niou_kurikara_fire_debuff_basic.vpcf"
    local ____opt_177 = self.Caster
    if ____opt_177 and ____opt_177:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_niou_kurikara_fire_debuff_unique.vpcf"
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_POINT_FOLLOW, self.Victim)
    self:AddParticle(
        Particle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_fire_debuff.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_179 = self.Ability
    return ____opt_179 and ____opt_179:GetSpecialValueFor("FireIncreaseDmgTaken")
end
function musashi_modifier_fire_debuff.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
musashi_modifier_fire_debuff = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_fire_debuff
)
____exports.musashi_modifier_fire_debuff = musashi_modifier_fire_debuff
____exports.musashi_modifier_wind_debuff = __TS__Class()
local musashi_modifier_wind_debuff = ____exports.musashi_modifier_wind_debuff
musashi_modifier_wind_debuff.name = "musashi_modifier_wind_debuff"
__TS__ClassExtends(musashi_modifier_wind_debuff, BaseModifier)
function musashi_modifier_wind_debuff.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    local Caster = self:GetCaster()
    local Victim = self:GetParent()
    local DebuffDuration = self:GetDuration()
    giveUnitDataDrivenModifier(Caster, Victim, "pause_sealdisabled", DebuffDuration)
end
function musashi_modifier_wind_debuff.prototype.IsStunDebuff(self)
    return true
end
musashi_modifier_wind_debuff = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_wind_debuff
)
____exports.musashi_modifier_wind_debuff = musashi_modifier_wind_debuff
____exports.musashi_modifier_niou_kurikara_postchannel_buff = __TS__Class()
local musashi_modifier_niou_kurikara_postchannel_buff = ____exports.musashi_modifier_niou_kurikara_postchannel_buff
musashi_modifier_niou_kurikara_postchannel_buff.name = "musashi_modifier_niou_kurikara_postchannel_buff"
__TS__ClassExtends(musashi_modifier_niou_kurikara_postchannel_buff, BaseModifier)
function musashi_modifier_niou_kurikara_postchannel_buff.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_181 = self:GetAbility()
    return ____opt_181 and ____opt_181:GetSpecialValueFor("DmgReducFinishChannel")
end
function musashi_modifier_niou_kurikara_postchannel_buff.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
function musashi_modifier_niou_kurikara_postchannel_buff.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_niou_kurikara_postchannel_buff.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_niou_kurikara_postchannel_buff = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_niou_kurikara_postchannel_buff
)
____exports.musashi_modifier_niou_kurikara_postchannel_buff = musashi_modifier_niou_kurikara_postchannel_buff
____exports.musashi_tengan = __TS__Class()
local musashi_tengan = ____exports.musashi_tengan
musashi_tengan.name = "musashi_tengan"
__TS__ClassExtends(musashi_tengan, BaseAbility)
function musashi_tengan.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_cast_02"
    self.SoundSfx = "musashi_tengan_sfx"
end
function musashi_tengan.prototype.OnAbilityPhaseStart(self)
    if IsServer() then
        self.Caster = self:GetCaster()
        self.ChargeCounter = self.Caster:FindModifierByName(____exports.musashi_modifier_tengan_chargecounter.name)
        if CheckComboStatsFulfilled(self.Caster) and not self.Caster:HasModifier(____exports.musashi_modifier_ishana_daitenshou_cooldown.name) then
            local SkillsSequence = {____exports.musashi_tengan.name, ____exports.musashi_dai_go_sei.name}
            InitComboSequenceChecker(
                self.Caster,
                SkillsSequence,
                ____exports.musashi_ganryuu_jima.name,
                ____exports.musashi_ishana_daitenshou.name,
                5
            )
        end
        if self.ChargeCounter:GetStackCount() > 0 then
            return true
        end
    end
    return false
end
function musashi_tengan.prototype.OnSpellStart(self)
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    local RechargeTime = self:GetSpecialValueFor("RechargeTime")
    local ____opt_183 = self.Caster
    if ____opt_183 ~= nil then
        ____opt_183:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_tengan.name, {duration = BuffDuration})
    end
    local ____opt_185 = self.ChargeCounter
    if ____opt_185 ~= nil then
        local ____opt_186 = self.ChargeCounter
        local ____temp_188 = ____opt_186 and ____opt_186.RechargeTimer
        ____temp_188[#____temp_188 + 1] = RechargeTime
    end
    local ____opt_190 = self.ChargeCounter
    local ____temp_194 = (____opt_190 and ____opt_190:GetStackCount()) == self:GetSpecialValueFor("MaxCharges")
    if ____temp_194 then
        local ____opt_192 = self.Caster
        ____temp_194 = ____opt_192 and ____opt_192:HasModifier("musashi_attribute_improve_tengan")
    end
    if ____temp_194 then
        InitSkillSlotChecker(self.Caster, ____exports.musashi_tengan.name, ____exports.musashi_tenma_gogan.name, 5)
    end
    local ____opt_195 = self.ChargeCounter
    if ____opt_195 ~= nil then
        ____opt_195:DecrementStackCount()
    end
    self:PlaySound()
end
function musashi_tengan.prototype.PlaySound(self)
    local ____opt_197 = self.Caster
    if ____opt_197 ~= nil then
        ____opt_197:EmitSound(self.SoundVoiceline)
    end
    local ____opt_199 = self.Caster
    if ____opt_199 ~= nil then
        ____opt_199:EmitSound(self.SoundSfx)
    end
end
function musashi_tengan.prototype.GetIntrinsicModifierName(self)
    return ____exports.musashi_modifier_tengan_chargecounter.name
end
musashi_tengan = __TS__Decorate(
    {registerAbility(nil)},
    musashi_tengan
)
____exports.musashi_tengan = musashi_tengan
____exports.musashi_modifier_tengan_chargecounter = __TS__Class()
local musashi_modifier_tengan_chargecounter = ____exports.musashi_modifier_tengan_chargecounter
musashi_modifier_tengan_chargecounter.name = "musashi_modifier_tengan_chargecounter"
__TS__ClassExtends(musashi_modifier_tengan_chargecounter, BaseModifier)
function musashi_modifier_tengan_chargecounter.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.RechargeTimer = {}
end
function musashi_modifier_tengan_chargecounter.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Ability = self:GetAbility()
    local ____opt_201 = self.Ability
    local MaxCharges = ____opt_201 and ____opt_201:GetSpecialValueFor("MaxCharges")
    self:SetStackCount(MaxCharges)
    self:StartIntervalThink(1)
end
function musashi_modifier_tengan_chargecounter.prototype.OnRefresh(self)
    if not IsServer() then
        return
    end
    self:OnCreated()
end
function musashi_modifier_tengan_chargecounter.prototype.OnStackCountChanged(self)
    if not IsServer() then
        return
    end
    if self:GetStackCount() == 0 then
        local ____opt_203 = self.Ability
        if ____opt_203 ~= nil then
            ____opt_203:StartCooldown(self.RechargeTimer[1] or 0)
        end
    else
        local ____opt_205 = self.Ability
        if ____opt_205 ~= nil then
            ____opt_205:EndCooldown()
        end
    end
end
function musashi_modifier_tengan_chargecounter.prototype.OnIntervalThink(self)
    if not IsServer() or #self.RechargeTimer == 0 then
        return
    end
    do
        local i = 0
        while i < #self.RechargeTimer do
            local ____self_RechargeTimer_207, ____temp_208 = self.RechargeTimer, i + 1
            ____self_RechargeTimer_207[____temp_208] = ____self_RechargeTimer_207[____temp_208] - 1
            i = i + 1
        end
    end
    if self.RechargeTimer[1] == 0 then
        table.remove(self.RechargeTimer, 1)
        self:IncrementStackCount()
    end
end
function musashi_modifier_tengan_chargecounter.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_tengan_chargecounter.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_tengan_chargecounter.prototype.IsPermanent(self)
    return true
end
musashi_modifier_tengan_chargecounter = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_tengan_chargecounter
)
____exports.musashi_modifier_tengan_chargecounter = musashi_modifier_tengan_chargecounter
____exports.musashi_modifier_tengan = __TS__Class()
local musashi_modifier_tengan = ____exports.musashi_modifier_tengan
musashi_modifier_tengan.name = "musashi_modifier_tengan"
__TS__ClassExtends(musashi_modifier_tengan, BaseModifier)
function musashi_modifier_tengan.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.BonusDmg = 0
end
function musashi_modifier_tengan.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    local Ability = self:GetAbility()
    local BaseDmg = Ability and Ability:GetSpecialValueFor("BonusDmg")
    local BonusPureDmgPerAgi = Ability and Ability:GetSpecialValueFor("BonusPureDmgPerAgi")
    self.BonusDmg = BaseDmg + self.Caster:GetAgility() * BonusPureDmgPerAgi
    self:CreateParticle()
end
function musashi_modifier_tengan.prototype.OnRefresh(self)
    if not IsServer() then
        return
    end
    self:OnCreated()
end
function musashi_modifier_tengan.prototype.CreateParticle(self)
    local ____opt_213 = self.Caster
    if ____opt_213 and ____opt_213:HasModifier("modifier_ascended") then
        local ParticleStr = "particles/custom/musashi/musashi_tengan_unique.vpcf"
        local OverheadParticleStr = "particles/custom/musashi/musashi_tengan_overhead_unique.vpcf"
        local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
        local OverheadParticle = ParticleManager:CreateParticle(OverheadParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
        self:AddParticle(
            Particle,
            false,
            false,
            -1,
            false,
            false
        )
        self:AddParticle(
            OverheadParticle,
            false,
            false,
            -1,
            false,
            false
        )
    else
        local ParticleStr = "particles/custom/musashi/musashi_tengan_basic.vpcf"
        local OverheadParticleStr = "particles/custom/musashi/musashi_tengan_overhead_basic.vpcf"
        local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
        local OverheadParticle = ParticleManager:CreateParticle(OverheadParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
        ParticleManager:SetParticleControlEnt(
            OverheadParticle,
            10,
            self.Caster,
            PATTACH_OVERHEAD_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0),
            false
        )
        self:AddParticle(
            Particle,
            false,
            false,
            -1,
            false,
            false
        )
        self:AddParticle(
            OverheadParticle,
            false,
            false,
            -1,
            false,
            false
        )
    end
end
function musashi_modifier_tengan.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_tengan.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_tengan = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_tengan
)
____exports.musashi_modifier_tengan = musashi_modifier_tengan
____exports.musashi_ganryuu_jima = __TS__Class()
local musashi_ganryuu_jima = ____exports.musashi_ganryuu_jima
musashi_ganryuu_jima.name = "musashi_ganryuu_jima"
__TS__ClassExtends(musashi_ganryuu_jima, BaseAbility)
function musashi_ganryuu_jima.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_ability_manavoid_01"
    self.DashPosition = Vector(0, 0, 0)
    self.SlashPosition = Vector(0, 0, 0)
    self.SecondSlashPosition = Vector(0, 0, 0)
end
function musashi_ganryuu_jima.prototype.OnAbilityPhaseStart(self)
    if IsServer() then
        self.Caster = self:GetCaster()
        local ModifierTengenNoHana = self.Caster:FindModifierByName(____exports.musashi_modifier_tengen_no_hana.name)
        if ModifierTengenNoHana ~= nil then
            ModifierTengenNoHana:Destroy()
        end
    end
    return true
end
function musashi_ganryuu_jima.prototype.OnVectorCastStart(self, vStartLocation, vDirection)
    self:SetVector(vStartLocation, vDirection)
    local ____opt_217 = self.Caster
    local ModifierGanryuuJima = ____opt_217 and ____opt_217:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_ganryuu_jima.name, {undefined = undefined})
    if ModifierGanryuuJima ~= nil then
        ModifierGanryuuJima:IncrementStackCount()
    end
    EmitGlobalSound(self.SoundVoiceline)
end
function musashi_ganryuu_jima.prototype.SetVector(self, vStartLocation, vDirection)
    self.DashPosition = vStartLocation
    self.SlashPosition = vDirection
    self.SecondSlashPosition = vDirection:__unm()
end
function musashi_ganryuu_jima.prototype.GetCastRange(self)
    if IsServer() then
        return 0
    else
        local ____opt_221 = self.Caster
        if ____opt_221 and ____opt_221:HasModifier("musashi_attribute_niten_ichiryuu") then
            return 1000
        else
            return self:GetSpecialValueFor("SlashRange")
        end
    end
end
function musashi_ganryuu_jima.prototype.GetVectorTargetRange(self)
    return self:GetSpecialValueFor("SlashRange")
end
function musashi_ganryuu_jima.prototype.GetVectorTargetStartRadius(self)
    return self:GetSpecialValueFor("SlashRadius")
end
function musashi_ganryuu_jima.prototype.GetVectorTargetEndRadius(self)
    return self:GetSpecialValueFor("SlashRadius")
end
function musashi_ganryuu_jima.prototype.GetVectorPosition(self)
    return self.DashPosition
end
function musashi_ganryuu_jima.prototype.GetVectorDirection(self)
    return self.SlashPosition
end
function musashi_ganryuu_jima.prototype.GetVector2Position(self)
    return self.SecondSlashPosition
end
function musashi_ganryuu_jima.prototype.UpdateVectorValues(self)
end
function musashi_ganryuu_jima.prototype.IsDualVectorDirection(self)
    return false
end
function musashi_ganryuu_jima.prototype.IgnoreVectorArrowWidth(self)
    return false
end
musashi_ganryuu_jima = __TS__Decorate(
    {registerAbility(nil)},
    musashi_ganryuu_jima
)
____exports.musashi_ganryuu_jima = musashi_ganryuu_jima
____exports.musashi_modifier_ganryuu_jima = __TS__Class()
local musashi_modifier_ganryuu_jima = ____exports.musashi_modifier_ganryuu_jima
musashi_modifier_ganryuu_jima.name = "musashi_modifier_ganryuu_jima"
__TS__ClassExtends(musashi_modifier_ganryuu_jima, BaseModifier)
function musashi_modifier_ganryuu_jima.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.DashPosition = Vector(0, 0, 0)
    self.SlashPosition = Vector(0, 0, 0)
    self.SecondSlashPosition = Vector(0, 0, 0)
end
function musashi_modifier_ganryuu_jima.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.GanryuuJima = self:GetAbility()
    self.DashPosition = self.GanryuuJima.DashPosition
    self.SlashPosition = self.GanryuuJima.SlashPosition
    self.SecondSlashPosition = self.GanryuuJima.SecondSlashPosition
    giveUnitDataDrivenModifier(self.Caster, self.Caster, "pause_sealdisabled", 1.5)
end
function musashi_modifier_ganryuu_jima.prototype.OnStackCountChanged(self, stackCount)
    if not IsServer() then
        return
    end
    local Position = Vector(0, 0, 0)
    repeat
        local ____switch167 = stackCount
        local ____cond167 = ____switch167 == 0
        if ____cond167 then
            do
                Position = self.DashPosition
                local ____opt_223 = self.Caster
                local DashBuff = ____opt_223 and ____opt_223:AddNewModifier(self.Caster, self.GanryuuJima, ____exports.musashi_modifier_ganryuu_jima_dash.name, {undefined = undefined})
                DashBuff.TargetPoint = Position
                local ____DashBuff_TargetPoint_227 = DashBuff.TargetPoint
                local ____opt_225 = self.Caster
                ____DashBuff_TargetPoint_227.z = ____opt_225 and ____opt_225:GetAbsOrigin().z
                local ____DashBuff_TargetPoint_230 = DashBuff.TargetPoint
                local ____opt_228 = self.Caster
                DashBuff.NormalizedTargetPoint = (____DashBuff_TargetPoint_230 - (____opt_228 and ____opt_228:GetAbsOrigin())):Normalized()
                DashBuff:StartIntervalThink(0.03)
                break
            end
        end
        ____cond167 = ____cond167 or ____switch167 == 1
        if ____cond167 then
            do
                Position = self.SlashPosition
                break
            end
        end
        ____cond167 = ____cond167 or ____switch167 == 2
        if ____cond167 then
            do
                Position = self.SecondSlashPosition
                break
            end
        end
        ____cond167 = ____cond167 or ____switch167 == 3
        if ____cond167 then
            do
                self:Destroy()
                break
            end
        end
    until true
    if stackCount == 1 or stackCount == 2 then
        local ____opt_231 = self.Caster
        local SlashBuff = ____opt_231 and ____opt_231:AddNewModifier(self.Caster, self.GanryuuJima, ____exports.musashi_modifier_ganryuu_jima_slash.name, {undefined = undefined})
        SlashBuff.TargetPoint = Position
        SlashBuff:StartIntervalThink(0.03)
    end
end
function musashi_modifier_ganryuu_jima.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_233 = self.Caster
    if ____opt_233 ~= nil then
        ____opt_233:SetForwardVector(self.Caster:GetAbsOrigin():Normalized())
    end
    local ____opt_235 = self.Caster
    if ____opt_235 ~= nil then
        ____opt_235:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    local ____FindClearSpaceForUnit_240 = FindClearSpaceForUnit
    local ____self_Caster_239 = self.Caster
    local ____opt_237 = self.Caster
    ____FindClearSpaceForUnit_240(
        ____self_Caster_239,
        ____opt_237 and ____opt_237:GetAbsOrigin(),
        true
    )
    local ____opt_241 = self.Caster
    if ____opt_241 ~= nil then
        ____opt_241:AddNewModifier(self.Caster, self.GanryuuJima, "modifier_phased", {duration = 1})
    end
    local ____opt_243 = self.Caster
    local ModifierTengan = ____opt_243 and ____opt_243:FindModifierByName(____exports.musashi_modifier_tengan.name)
    if ModifierTengan ~= nil then
        ModifierTengan:Destroy()
    end
    local ____opt_247 = self.Caster
    local ModifierTenmaGogan = ____opt_247 and ____opt_247:FindModifierByName(____exports.musashi_modifier_tenma_gogan.name)
    if ModifierTenmaGogan then
        local ____opt_249 = self.GanryuuJima
        if ____opt_249 ~= nil then
            ____opt_249:EndCooldown()
        end
        local ____opt_251 = self.Caster
        if ____opt_251 ~= nil then
            local ____opt_251_GiveMana_254 = ____opt_251.GiveMana
            local ____opt_252 = self.GanryuuJima
            ____opt_251_GiveMana_254(
                ____opt_251,
                ____opt_252 and ____opt_252:GetManaCost(-1)
            )
        end
        if ModifierTenmaGogan ~= nil then
            ModifierTenmaGogan:IncrementStackCount()
        end
    end
end
function musashi_modifier_ganryuu_jima.prototype.CheckState(self)
    local ModifierTable = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
    }
    return ModifierTable
end
function musashi_modifier_ganryuu_jima.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ganryuu_jima.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_ganryuu_jima = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima
)
____exports.musashi_modifier_ganryuu_jima = musashi_modifier_ganryuu_jima
____exports.musashi_modifier_ganryuu_jima_dash = __TS__Class()
local musashi_modifier_ganryuu_jima_dash = ____exports.musashi_modifier_ganryuu_jima_dash
musashi_modifier_ganryuu_jima_dash.name = "musashi_modifier_ganryuu_jima_dash"
__TS__ClassExtends(musashi_modifier_ganryuu_jima_dash, BaseModifier)
function musashi_modifier_ganryuu_jima_dash.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.TargetPoint = Vector(0, 0, 0)
    self.NormalizedTargetPoint = Vector(0, 0, 0)
    self.SlashRange = 0
    self.UnitsTravelled = 0
    self.DashSpeed = 0
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_258 = self.Ability
    self.SlashRange = ____opt_258 and ____opt_258:GetSpecialValueFor("SlashRange")
    local ____opt_260 = self.Ability
    self.DashSpeed = ____opt_260 and ____opt_260:GetSpecialValueFor("DashSpeed")
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_262 = self.Caster
    if ____opt_262 ~= nil then
        ____opt_262:SetForwardVector(self.NormalizedTargetPoint)
    end
    local ____opt_264 = self.Caster
    local CurrentOrigin = ____opt_264 and ____opt_264:GetAbsOrigin()
    local ____opt_266 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_266 and ____opt_266:GetForwardVector()) * self.DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_268 = self.Caster
    if ____opt_268 ~= nil then
        ____opt_268:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_272 = Entities.FindByNameWithin
    local ____opt_270 = self.Caster
    local Musashi = ____Entities_FindByNameWithin_272(
        Entities,
        nil,
        ____opt_270 and ____opt_270:GetName(),
        self.TargetPoint,
        self.DashSpeed
    )
    if Musashi or self.UnitsTravelled >= self.SlashRange then
        self:Destroy()
    end
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_273 = self.Caster
    local ModifierGanryuuJima = ____opt_273 and ____opt_273:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
    if ModifierGanryuuJima ~= nil then
        ModifierGanryuuJima:IncrementStackCount()
    end
end
function musashi_modifier_ganryuu_jima_dash.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE}
end
function musashi_modifier_ganryuu_jima_dash.prototype.GetOverrideAnimation(self)
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function musashi_modifier_ganryuu_jima_dash.prototype.GetOverrideAnimationRate(self)
    return 2
end
function musashi_modifier_ganryuu_jima_dash.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ganryuu_jima_dash.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_ganryuu_jima_dash.prototype.IsHidden(self)
    return true
end
musashi_modifier_ganryuu_jima_dash = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima_dash
)
____exports.musashi_modifier_ganryuu_jima_dash = musashi_modifier_ganryuu_jima_dash
____exports.musashi_modifier_ganryuu_jima_slash = __TS__Class()
local musashi_modifier_ganryuu_jima_slash = ____exports.musashi_modifier_ganryuu_jima_slash
musashi_modifier_ganryuu_jima_slash.name = "musashi_modifier_ganryuu_jima_slash"
__TS__ClassExtends(musashi_modifier_ganryuu_jima_slash, BaseModifier)
function musashi_modifier_ganryuu_jima_slash.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.SoundSfx = "musashi_ganryuu_jima_sfx"
    self.TargetPoint = Vector(0, 0, 0)
    self.StartPosition = Vector(0, 0, 0)
    self.EndPosition = Vector(0, 0, 0)
    self.SlashRange = 0
    self.UnitsTravelled = 0
    self.DashSpeed = 0
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_277 = self.Caster
    self.StartPosition = ____opt_277 and ____opt_277:GetAbsOrigin()
    local ____opt_279 = self.Ability
    self.SlashRange = ____opt_279 and ____opt_279:GetSpecialValueFor("SlashRange")
    local ____opt_281 = self.Ability
    self.DashSpeed = ____opt_281 and ____opt_281:GetSpecialValueFor("DashSpeed")
    local ____opt_283 = self.Caster
    if ____opt_283 ~= nil then
        ____opt_283:EmitSound(self.SoundSfx)
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_285 = self.Caster
    if ____opt_285 ~= nil then
        ____opt_285:SetForwardVector(self.TargetPoint)
    end
    local ____opt_287 = self.Caster
    local CurrentOrigin = ____opt_287 and ____opt_287:GetAbsOrigin()
    local ____opt_289 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_289 and ____opt_289:GetForwardVector()) * self.DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_291 = self.Caster
    if ____opt_291 ~= nil then
        ____opt_291:SetAbsOrigin(NewPosition)
    end
    if self.UnitsTravelled >= self.SlashRange then
        self:Destroy()
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_293 = self.Caster
    self.EndPosition = ____opt_293 and ____opt_293:GetAbsOrigin()
    self:DealDamage()
    self:CreateParticle()
    local ____opt_295 = self.Caster
    local ModifierGanryuuJima = ____opt_295 and ____opt_295:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
    if ModifierGanryuuJima ~= nil then
        ModifierGanryuuJima:IncrementStackCount()
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.DealDamage(self)
    local ____opt_299 = self.Ability
    local BaseDmg = ____opt_299 and ____opt_299:GetSpecialValueFor("DmgPerSlash")
    local ____opt_301 = self.Ability
    local BonusDmgPerAgi = ____opt_301 and ____opt_301:GetSpecialValueFor("BonusDmgPerAgi")
    local Damage = BaseDmg + self.Caster:GetAgility() * BonusDmgPerAgi
    local ____opt_303 = self.Ability
    local DmgType = ____opt_303 and ____opt_303:GetAbilityDamageType()
    local DmgFlag = DOTA_DAMAGE_FLAG_NONE
    local ____FindUnitsInLine_316 = FindUnitsInLine
    local ____opt_305 = self.Caster
    local ____array_315 = __TS__SparseArrayNew(
        ____opt_305 and ____opt_305:GetTeam(),
        self.StartPosition,
        self.EndPosition,
        nil
    )
    local ____opt_307 = self.Ability
    __TS__SparseArrayPush(
        ____array_315,
        ____opt_307 and ____opt_307:GetSpecialValueFor("SlashRadius")
    )
    local ____opt_309 = self.Ability
    __TS__SparseArrayPush(
        ____array_315,
        ____opt_309 and ____opt_309:GetAbilityTargetTeam()
    )
    local ____opt_311 = self.Ability
    __TS__SparseArrayPush(
        ____array_315,
        ____opt_311 and ____opt_311:GetAbilityTargetType()
    )
    local ____opt_313 = self.Ability
    __TS__SparseArrayPush(
        ____array_315,
        ____opt_313 and ____opt_313:GetAbilityTargetFlags()
    )
    local Targets = ____FindUnitsInLine_316(__TS__SparseArraySpread(____array_315))
    for ____, Iterator in ipairs(Targets) do
        DoDamage(
            self.Caster,
            Iterator,
            Damage,
            DmgType,
            DmgFlag,
            self.Ability,
            false
        )
    end
    local ____opt_317 = self.Caster
    if ____opt_317 and ____opt_317:HasModifier(____exports.musashi_modifier_tengan.name) then
        local TargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
        local ____FindUnitsInLine_326 = FindUnitsInLine
        local ____array_325 = __TS__SparseArrayNew(
            self.Caster:GetTeam(),
            self.StartPosition,
            self.EndPosition,
            nil
        )
        local ____opt_319 = self.Ability
        __TS__SparseArrayPush(
            ____array_325,
            ____opt_319 and ____opt_319:GetSpecialValueFor("SlashRadius")
        )
        local ____opt_321 = self.Ability
        __TS__SparseArrayPush(
            ____array_325,
            ____opt_321 and ____opt_321:GetAbilityTargetTeam()
        )
        local ____opt_323 = self.Ability
        __TS__SparseArrayPush(
            ____array_325,
            ____opt_323 and ____opt_323:GetAbilityTargetType(),
            TargetFlags
        )
        local Targets = ____FindUnitsInLine_326(__TS__SparseArraySpread(____array_325))
        for ____, Iterator in ipairs(Targets) do
            local ____opt_327 = self.Ability
            local DmgDelay = ____opt_327 and ____opt_327:GetSpecialValueFor("DebuffDmgDelay")
            Iterator:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ganryuu_jima_debuff.name, {duration = DmgDelay})
        end
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_basic.vpcf"
    local ____opt_329 = self.Caster
    if ____opt_329 and ____opt_329:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_unique.vpcf"
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    ParticleManager:SetParticleControl(Particle, 0, self.StartPosition)
    ParticleManager:SetParticleControl(Particle, 1, self.EndPosition)
end
function musashi_modifier_ganryuu_jima_slash.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE}
end
function musashi_modifier_ganryuu_jima_slash.prototype.GetOverrideAnimation(self)
    return ACT_DOTA_OVERRIDE_ABILITY_2
end
function musashi_modifier_ganryuu_jima_slash.prototype.GetOverrideAnimationRate(self)
    return 4
end
function musashi_modifier_ganryuu_jima_slash.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ganryuu_jima_slash.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_ganryuu_jima_slash.prototype.IsHidden(self)
    return true
end
musashi_modifier_ganryuu_jima_slash = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima_slash
)
____exports.musashi_modifier_ganryuu_jima_slash = musashi_modifier_ganryuu_jima_slash
____exports.musashi_modifier_ganryuu_jima_debuff = __TS__Class()
local musashi_modifier_ganryuu_jima_debuff = ____exports.musashi_modifier_ganryuu_jima_debuff
musashi_modifier_ganryuu_jima_debuff.name = "musashi_modifier_ganryuu_jima_debuff"
__TS__ClassExtends(musashi_modifier_ganryuu_jima_debuff, BaseModifier)
function musashi_modifier_ganryuu_jima_debuff.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.BonusDmg = 0
end
function musashi_modifier_ganryuu_jima_debuff.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    local ____opt_331 = self.Caster
    local ModifierTengan = ____opt_331 and ____opt_331:FindModifierByName(____exports.musashi_modifier_tengan.name)
    self.BonusDmg = ModifierTengan.BonusDmg
    self:CreateParticle()
end
function musashi_modifier_ganryuu_jima_debuff.prototype.OnRefresh(self)
    if not IsServer() then
        return
    end
    self:OnCreated()
end
function musashi_modifier_ganryuu_jima_debuff.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    self:DealDamage()
end
function musashi_modifier_ganryuu_jima_debuff.prototype.DealDamage(self)
    local Victim = self:GetParent()
    local DmgType = DAMAGE_TYPE_PURE
    local DmgFlag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
    DoDamage(
        self.Caster,
        Victim,
        self.BonusDmg,
        DmgType,
        DmgFlag,
        self:GetAbility(),
        false
    )
end
function musashi_modifier_ganryuu_jima_debuff.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_debuff_basic.vpcf"
    local ____opt_333 = self.Caster
    if ____opt_333 and ____opt_333:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_debuff_unique.vpcf"
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    self:AddParticle(
        Particle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_ganryuu_jima_debuff.prototype.IsDebuff(self)
    return true
end
function musashi_modifier_ganryuu_jima_debuff.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ganryuu_jima_debuff.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_ganryuu_jima_debuff = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima_debuff
)
____exports.musashi_modifier_ganryuu_jima_debuff = musashi_modifier_ganryuu_jima_debuff
____exports.musashi_mukyuu = __TS__Class()
local musashi_mukyuu = ____exports.musashi_mukyuu
musashi_mukyuu.name = "musashi_mukyuu"
__TS__ClassExtends(musashi_mukyuu, BaseAbility)
function musashi_mukyuu.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_ability_manavoid_03"
    self.SoundSfx = "musashi_mukyuu_sfx"
end
function musashi_mukyuu.prototype.OnSpellStart(self)
    self.Caster = self:GetCaster()
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_mukyuu.name, {duration = BuffDuration})
    InitSkillSlotChecker(
        self.Caster,
        ____exports.musashi_mukyuu.name,
        ____exports.musashi_tengen_no_hana.name,
        5,
        false
    )
    self:PlaySound()
end
function musashi_mukyuu.prototype.PlaySound(self)
    local ____opt_335 = self.Caster
    if ____opt_335 ~= nil then
        ____opt_335:EmitSound(self.SoundVoiceline)
    end
    local ____opt_337 = self.Caster
    if ____opt_337 ~= nil then
        ____opt_337:EmitSound(self.SoundSfx)
    end
end
musashi_mukyuu = __TS__Decorate(
    {registerAbility(nil)},
    musashi_mukyuu
)
____exports.musashi_mukyuu = musashi_mukyuu
____exports.musashi_modifier_mukyuu = __TS__Class()
local musashi_modifier_mukyuu = ____exports.musashi_modifier_mukyuu
musashi_modifier_mukyuu.name = "musashi_modifier_mukyuu"
__TS__ClassExtends(musashi_modifier_mukyuu, BaseModifier)
function musashi_modifier_mukyuu.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self:CreateParticle()
end
function musashi_modifier_mukyuu.prototype.CreateParticle(self)
    local ____opt_339 = self.Caster
    if ____opt_339 and ____opt_339:HasModifier("modifier_ascended") then
        local ParticleStr = "particles/custom/musashi/musashi_mukyuu_unique.vpcf"
        local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
        ParticleManager:SetParticleControlEnt(
            Particle,
            1,
            self.Caster,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0),
            false
        )
        self:AddParticle(
            Particle,
            false,
            false,
            -1,
            false,
            false
        )
    else
        local ParticleStr = "particles/custom/musashi/musashi_mukyuu_basic.vpcf"
        local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
        ParticleManager:SetParticleControlEnt(
            Particle,
            0,
            self.Caster,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0),
            false
        )
        ParticleManager:SetParticleControl(
            Particle,
            1,
            Vector(150, 0, 0)
        )
        self:AddParticle(
            Particle,
            false,
            false,
            -1,
            false,
            false
        )
    end
end
function musashi_modifier_mukyuu.prototype.CheckState(self)
    local ModifierTable = {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_MAGIC_IMMUNE] = true}
    return ModifierTable
end
function musashi_modifier_mukyuu.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_mukyuu.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_mukyuu = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_mukyuu
)
____exports.musashi_modifier_mukyuu = musashi_modifier_mukyuu
____exports.musashi_tenma_gogan = __TS__Class()
local musashi_tenma_gogan = ____exports.musashi_tenma_gogan
musashi_tenma_gogan.name = "musashi_tenma_gogan"
__TS__ClassExtends(musashi_tenma_gogan, BaseAbility)
function musashi_tenma_gogan.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_ability_manavoid_05"
    self.SoundSfx = "musashi_tengan_sfx"
end
function musashi_tenma_gogan.prototype.OnSpellStart(self)
    self.Caster = self:GetCaster()
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    local ____opt_341 = self.Caster
    if ____opt_341 ~= nil then
        ____opt_341:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_tenma_gogan.name, {duration = BuffDuration})
    end
    self:PlaySound()
end
function musashi_tenma_gogan.prototype.PlaySound(self)
    EmitGlobalSound(self.SoundVoiceline)
    local ____opt_343 = self.Caster
    if ____opt_343 ~= nil then
        ____opt_343:EmitSound(self.SoundSfx)
    end
end
musashi_tenma_gogan = __TS__Decorate(
    {registerAbility(nil)},
    musashi_tenma_gogan
)
____exports.musashi_tenma_gogan = musashi_tenma_gogan
____exports.musashi_modifier_tenma_gogan = __TS__Class()
local musashi_modifier_tenma_gogan = ____exports.musashi_modifier_tenma_gogan
musashi_modifier_tenma_gogan.name = "musashi_modifier_tenma_gogan"
__TS__ClassExtends(musashi_modifier_tenma_gogan, BaseModifier)
function musashi_modifier_tenma_gogan.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    local ____opt_345 = self.Caster
    local ChargeCounter = ____opt_345 and ____opt_345:FindModifierByName(____exports.musashi_modifier_tengan_chargecounter.name)
    local ____opt_347 = self.Caster
    local Tengan = ____opt_347 and ____opt_347:FindAbilityByName(____exports.musashi_tengan.name)
    if ChargeCounter ~= nil then
        ChargeCounter:SetStackCount(0)
    end
    if ChargeCounter ~= nil then
        ChargeCounter:StartIntervalThink(-1)
    end
    if Tengan ~= nil then
        Tengan:StartCooldown(9999)
    end
    self:CreateParticle()
end
function musashi_modifier_tenma_gogan.prototype.OnStackCountChanged(self, stackCount)
    if not IsServer() then
        return
    end
    repeat
        local ____switch241 = stackCount
        local ____cond241 = ____switch241 == 1
        if ____cond241 then
            do
                self:Destroy()
            end
            break
        end
    until true
end
function musashi_modifier_tenma_gogan.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local Ability = self:GetAbility()
    local DebuffDuration = Ability and Ability:GetSpecialValueFor("DebuffDuration")
    local ____opt_357 = self.Caster
    if ____opt_357 ~= nil then
        ____opt_357:AddNewModifier(self.Caster, Ability, ____exports.musashi_modifier_tenma_gogan_debuff.name, {duration = DebuffDuration})
    end
end
function musashi_modifier_tenma_gogan.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_tenma_gogan_basic.vpcf"
    local BodyParticleStr = "particles/custom/musashi/musashi_tenma_gogan_body.vpcf"
    local ____opt_359 = self.Caster
    if ____opt_359 and ____opt_359:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_tenma_gogan_unique.vpcf"
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    local BodyParticle = ParticleManager:CreateParticle(BodyParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    self:AddParticle(
        Particle,
        false,
        false,
        -1,
        false,
        false
    )
    self:AddParticle(
        BodyParticle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_tenma_gogan.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_tenma_gogan.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_tenma_gogan = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_tenma_gogan
)
____exports.musashi_modifier_tenma_gogan = musashi_modifier_tenma_gogan
____exports.musashi_modifier_tenma_gogan_debuff = __TS__Class()
local musashi_modifier_tenma_gogan_debuff = ____exports.musashi_modifier_tenma_gogan_debuff
musashi_modifier_tenma_gogan_debuff.name = "musashi_modifier_tenma_gogan_debuff"
__TS__ClassExtends(musashi_modifier_tenma_gogan_debuff, BaseModifier)
function musashi_modifier_tenma_gogan_debuff.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    local Caster = self:GetCaster()
    local DebuffDuration = self:GetDuration()
    giveUnitDataDrivenModifier(Caster, Caster, "pause_sealdisabled", DebuffDuration)
end
function musashi_modifier_tenma_gogan_debuff.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_tenma_gogan_debuff.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_tenma_gogan_debuff.prototype.IsDebuff(self)
    return true
end
function musashi_modifier_tenma_gogan_debuff.prototype.IsStunDebuff(self)
    return true
end
musashi_modifier_tenma_gogan_debuff = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_tenma_gogan_debuff
)
____exports.musashi_modifier_tenma_gogan_debuff = musashi_modifier_tenma_gogan_debuff
____exports.musashi_tengen_no_hana = __TS__Class()
local musashi_tengen_no_hana = ____exports.musashi_tengen_no_hana
musashi_tengen_no_hana.name = "musashi_tengen_no_hana"
__TS__ClassExtends(musashi_tengen_no_hana, BaseAbility)
function musashi_tengen_no_hana.prototype.OnSpellStart(self)
    local Caster = self:GetCaster()
    local ModifierTengenNoHana = Caster:FindModifierByName(____exports.musashi_modifier_tengen_no_hana.name)
    if ModifierTengenNoHana then
        ModifierTengenNoHana:Destroy()
        return
    end
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    Caster:AddNewModifier(Caster, self, ____exports.musashi_modifier_tengen_no_hana.name, {duration = BuffDuration})
end
musashi_tengen_no_hana = __TS__Decorate(
    {registerAbility(nil)},
    musashi_tengen_no_hana
)
____exports.musashi_tengen_no_hana = musashi_tengen_no_hana
____exports.musashi_modifier_tengen_no_hana = __TS__Class()
local musashi_modifier_tengen_no_hana = ____exports.musashi_modifier_tengen_no_hana
musashi_modifier_tengen_no_hana.name = "musashi_modifier_tengen_no_hana"
__TS__ClassExtends(musashi_modifier_tengen_no_hana, BaseModifier)
function musashi_modifier_tengen_no_hana.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_ability_manavoid_02"
    self.SoundSfx = "musashi_tengen_no_hana_sfx"
    self.Percentage = 0
    self.Radius = 0
end
function musashi_modifier_tengen_no_hana.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_361 = self.Ability
    self.Radius = ____opt_361 and ____opt_361:GetSpecialValueFor("Radius")
    local ____opt_363 = self.Ability
    local RampUpInterval = ____opt_363 and ____opt_363:GetSpecialValueFor("RampUpInterval")
    self:StartIntervalThink(RampUpInterval)
    self:CreateParticle()
    local ____opt_365 = self.Caster
    if ____opt_365 ~= nil then
        ____opt_365:EmitSound(self.SoundSfx)
    end
end
function musashi_modifier_tengen_no_hana.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    self:IncrementStackCount()
end
function musashi_modifier_tengen_no_hana.prototype.OnStackCountChanged(self, stackCount)
    if not IsServer() then
        return
    end
    repeat
        local ____switch263 = stackCount
        local ____cond263 = ____switch263 == 0
        if ____cond263 then
            do
                local ____opt_367 = self.Ability
                self.Percentage = ____opt_367 and ____opt_367:GetSpecialValueFor("1SecPercentage")
                break
            end
        end
        ____cond263 = ____cond263 or ____switch263 == 1
        if ____cond263 then
            do
                local ____opt_369 = self.Ability
                self.Percentage = ____opt_369 and ____opt_369:GetSpecialValueFor("2SecPercentage")
                break
            end
        end
        ____cond263 = ____cond263 or ____switch263 == 2
        if ____cond263 then
            do
                local ____opt_371 = self.Ability
                self.Percentage = ____opt_371 and ____opt_371:GetSpecialValueFor("FullDamage")
                self:Destroy()
                break
            end
        end
    until true
end
function musashi_modifier_tengen_no_hana.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    self.Percentage = self.Percentage / 100
    local ____opt_373 = self.Caster
    if ____opt_373 ~= nil then
        ____opt_373:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    self:DealDamage()
    self:CreateAoeParticle()
    local ____opt_375 = self.Caster
    if ____opt_375 ~= nil then
        ____opt_375:EmitSound(self.SoundVoiceline)
    end
    local ____opt_377 = self.Ability
    if ____opt_377 ~= nil then
        ____opt_377:SetHidden(true)
    end
end
function musashi_modifier_tengen_no_hana.prototype.DealDamage(self)
    local Damage = self.Percentage * 1000
    local DmgType = DAMAGE_TYPE_PURE
    local DmgFlag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
    local ____FindUnitsInRadius_390 = FindUnitsInRadius
    local ____opt_379 = self.Caster
    local ____array_389 = __TS__SparseArrayNew(____opt_379 and ____opt_379:GetTeam())
    local ____opt_381 = self.Caster
    __TS__SparseArrayPush(
        ____array_389,
        ____opt_381 and ____opt_381:GetAbsOrigin(),
        nil,
        self.Radius
    )
    local ____opt_383 = self.Ability
    __TS__SparseArrayPush(
        ____array_389,
        ____opt_383 and ____opt_383:GetAbilityTargetTeam()
    )
    local ____opt_385 = self.Ability
    __TS__SparseArrayPush(
        ____array_389,
        ____opt_385 and ____opt_385:GetAbilityTargetType()
    )
    local ____opt_387 = self.Ability
    __TS__SparseArrayPush(
        ____array_389,
        ____opt_387 and ____opt_387:GetAbilityTargetFlags(),
        FIND_ANY_ORDER,
        false
    )
    local Targets = ____FindUnitsInRadius_390(__TS__SparseArraySpread(____array_389))
    for ____, Iterator in ipairs(Targets) do
        DoDamage(
            self.Caster,
            Iterator,
            Damage,
            DmgType,
            DmgFlag,
            self.Ability,
            false
        )
        local ____opt_391 = self.Ability
        local StunDuration = (____opt_391 and ____opt_391:GetSpecialValueFor("StunDuration")) * self.Percentage
        Iterator:AddNewModifier(self.Caster, self.Ability, "modifier_stunned", {duration = StunDuration})
    end
end
function musashi_modifier_tengen_no_hana.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_basic.vpcf"
    local ____opt_393 = self.Caster
    if ____opt_393 and ____opt_393:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_unique1.vpcf"
        if self.Caster:HasModifier(____exports.musashi_modifier_battle_continuation_active.name) then
            ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_unique2.vpcf"
        end
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
    self:AddParticle(
        Particle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_tengen_no_hana.prototype.CreateAoeParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_basic.vpcf"
    local MarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_basic.vpcf"
    local ____opt_395 = self.Caster
    if ____opt_395 and ____opt_395:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique1.vpcf"
        MarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique1.vpcf"
        if self.Caster:HasModifier(____exports.musashi_modifier_battle_continuation_active.name) then
            ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique2.vpcf"
            MarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique2.vpcf"
        end
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local MarkerParticle = ParticleManager:CreateParticle(MarkerParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ____ParticleManager_SetParticleControl_399 = ParticleManager.SetParticleControl
    local ____opt_397 = self.Caster
    ____ParticleManager_SetParticleControl_399(
        ParticleManager,
        Particle,
        0,
        ____opt_397 and ____opt_397:GetAbsOrigin()
    )
    ParticleManager:SetParticleControl(
        Particle,
        2,
        Vector(self.Radius, self.Radius, self.Radius)
    )
    local ____ParticleManager_SetParticleControl_402 = ParticleManager.SetParticleControl
    local ____opt_400 = self.Caster
    ____ParticleManager_SetParticleControl_402(
        ParticleManager,
        MarkerParticle,
        0,
        ____opt_400 and ____opt_400:GetAbsOrigin()
    )
    ParticleManager:SetParticleControl(
        MarkerParticle,
        2,
        Vector(self.Radius, self.Radius, self.Radius)
    )
end
function musashi_modifier_tengen_no_hana.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_tengen_no_hana.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_tengen_no_hana = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_tengen_no_hana
)
____exports.musashi_modifier_tengen_no_hana = musashi_modifier_tengen_no_hana
____exports.musashi_battle_continuation = __TS__Class()
local musashi_battle_continuation = ____exports.musashi_battle_continuation
musashi_battle_continuation.name = "musashi_battle_continuation"
__TS__ClassExtends(musashi_battle_continuation, BaseAbility)
function musashi_battle_continuation.prototype.GetIntrinsicModifierName(self)
    return ____exports.musashi_modifier_battle_continuation.name
end
musashi_battle_continuation = __TS__Decorate(
    {registerAbility(nil)},
    musashi_battle_continuation
)
____exports.musashi_battle_continuation = musashi_battle_continuation
____exports.musashi_modifier_battle_continuation = __TS__Class()
local musashi_modifier_battle_continuation = ____exports.musashi_modifier_battle_continuation
musashi_modifier_battle_continuation.name = "musashi_modifier_battle_continuation"
__TS__ClassExtends(musashi_modifier_battle_continuation, BaseModifier)
function musashi_modifier_battle_continuation.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
end
function musashi_modifier_battle_continuation.prototype.OnTakeDamage(self, event)
    if not IsServer() or event.unit ~= self.Caster then
        return
    end
    local ____opt_403 = self.Ability
    local DmgThreshold = ____opt_403 and ____opt_403:GetSpecialValueFor("DmgThreshold")
    if not self.Caster:HasModifier("musashi_attribute_battle_continuation") or self.Caster:HasModifier(____exports.musashi_modifier_battle_continuation_cooldown.name) or self.Caster:HasModifier(____exports.musashi_modifier_tenma_gogan_debuff.name) or event.damage >= DmgThreshold then
        return
    end
    if self.Caster:GetHealth() <= 0 then
        local ____opt_405 = self.Ability
        local BuffDuration = ____opt_405 and ____opt_405:GetSpecialValueFor("BuffDuration")
        self.Caster:SetHealth(1)
        self.Caster:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_battle_continuation_active.name, {duration = BuffDuration})
        local ____self_410 = self.Caster
        local ____self_410_AddNewModifier_411 = ____self_410.AddNewModifier
        local ____array_409 = __TS__SparseArrayNew(self.Caster, self.Ability, ____exports.musashi_modifier_battle_continuation_cooldown.name)
        local ____opt_407 = self.Ability
        __TS__SparseArrayPush(
            ____array_409,
            {duration = ____opt_407 and ____opt_407:GetCooldown(1)}
        )
        ____self_410_AddNewModifier_411(
            ____self_410,
            __TS__SparseArraySpread(____array_409)
        )
        local ____opt_412 = self.Ability
        if ____opt_412 ~= nil then
            ____opt_412:UseResources(true, false, true)
        end
    end
end
function musashi_modifier_battle_continuation.prototype.DeclareFunctions(self)
    return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end
function musashi_modifier_battle_continuation.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_battle_continuation.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_battle_continuation.prototype.IsPermanent(self)
    return true
end
function musashi_modifier_battle_continuation.prototype.IsHidden(self)
    return true
end
function musashi_modifier_battle_continuation.prototype.RemoveOnDeath(self)
    return false
end
musashi_modifier_battle_continuation = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_battle_continuation
)
____exports.musashi_modifier_battle_continuation = musashi_modifier_battle_continuation
____exports.musashi_modifier_battle_continuation_active = __TS__Class()
local musashi_modifier_battle_continuation_active = ____exports.musashi_modifier_battle_continuation_active
musashi_modifier_battle_continuation_active.name = "musashi_modifier_battle_continuation_active"
__TS__ClassExtends(musashi_modifier_battle_continuation_active, BaseModifier)
function musashi_modifier_battle_continuation_active.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_ability_manavoid_04"
    self.SoundSfx = "musashi_battle_continuation_sfx"
end
function musashi_modifier_battle_continuation_active.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    local ____opt_414 = self.Caster
    local TengenNoHana = ____opt_414 and ____opt_414:FindAbilityByName(____exports.musashi_tengen_no_hana.name)
    local ____opt_416 = self.Caster
    if ____opt_416 ~= nil then
        ____opt_416:CastAbilityImmediately(
            TengenNoHana,
            self.Caster:GetEntityIndex()
        )
    end
    ProjectileManager:ProjectileDodge(self.Caster)
    local ____opt_418 = self.Caster
    if ____opt_418 ~= nil then
        ____opt_418:Purge(
            false,
            true,
            false,
            false,
            false
        )
    end
    self:CreateParticle()
    self:PlaySound()
end
function musashi_modifier_battle_continuation_active.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local Ability = self:GetAbility()
    local Heal = Ability and Ability:GetSpecialValueFor("Heal")
    local ____opt_422 = self.Caster
    if ____opt_422 ~= nil then
        ____opt_422:Heal(Heal, Ability)
    end
end
function musashi_modifier_battle_continuation_active.prototype.PlaySound(self)
    local ____opt_424 = self.Caster
    if ____opt_424 ~= nil then
        ____opt_424:EmitSound(self.SoundVoiceline)
    end
    local ____opt_426 = self.Caster
    if ____opt_426 ~= nil then
        ____opt_426:EmitSound(self.SoundSfx)
    end
end
function musashi_modifier_battle_continuation_active.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_battle_continuation_basic.vpcf"
    local ____opt_428 = self.Caster
    if ____opt_428 and ____opt_428:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_battle_continuation_unique.vpcf"
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    ParticleManager:SetParticleControlEnt(
        Particle,
        5,
        self.Caster,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0, 0, 0),
        false
    )
    self:AddParticle(
        Particle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_battle_continuation_active.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_MIN_HEALTH, MODIFIER_PROPERTY_DISABLE_HEALING}
end
function musashi_modifier_battle_continuation_active.prototype.GetMinHealth(self)
    return 1
end
function musashi_modifier_battle_continuation_active.prototype.GetDisableHealing(self)
    return 1
end
function musashi_modifier_battle_continuation_active.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_battle_continuation_active.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_battle_continuation_active = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_battle_continuation_active
)
____exports.musashi_modifier_battle_continuation_active = musashi_modifier_battle_continuation_active
____exports.musashi_modifier_battle_continuation_cooldown = __TS__Class()
local musashi_modifier_battle_continuation_cooldown = ____exports.musashi_modifier_battle_continuation_cooldown
musashi_modifier_battle_continuation_cooldown.name = "musashi_modifier_battle_continuation_cooldown"
__TS__ClassExtends(musashi_modifier_battle_continuation_cooldown, BaseModifier)
function musashi_modifier_battle_continuation_cooldown.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_battle_continuation_cooldown.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_battle_continuation_cooldown.prototype.RemoveOnDeath(self)
    return false
end
function musashi_modifier_battle_continuation_cooldown.prototype.IsDebuff(self)
    return true
end
musashi_modifier_battle_continuation_cooldown = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_battle_continuation_cooldown
)
____exports.musashi_modifier_battle_continuation_cooldown = musashi_modifier_battle_continuation_cooldown
____exports.musashi_ishana_daitenshou = __TS__Class()
local musashi_ishana_daitenshou = ____exports.musashi_ishana_daitenshou
musashi_ishana_daitenshou.name = "musashi_ishana_daitenshou"
__TS__ClassExtends(musashi_ishana_daitenshou, BaseAbility)
function musashi_ishana_daitenshou.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_ability_manavoid_06"
    self.SoundBgm = "musashi_ishana_daitenshou_bgm"
end
function musashi_ishana_daitenshou.prototype.OnSpellStart(self)
    local Caster = self:GetCaster()
    local NiouKurikara = Caster:FindAbilityByName(____exports.musashi_niou_kurikara.name)
    if NiouKurikara ~= nil then
        NiouKurikara:EndCooldown()
    end
    Caster:GiveMana(NiouKurikara and NiouKurikara:GetManaCost(-1))
    Caster:AddNewModifier(Caster, self, ____exports.musashi_modifier_ishana_daitenshou.name, {undefined = undefined})
    Caster:AddNewModifier(
        Caster,
        self,
        ____exports.musashi_modifier_ishana_daitenshou_cooldown.name,
        {duration = self:GetCooldown(1)}
    )
    self:PlaySound()
end
function musashi_ishana_daitenshou.prototype.PlaySound(self)
    EmitGlobalSound(self.SoundVoiceline)
    EmitGlobalSound(self.SoundBgm)
end
musashi_ishana_daitenshou = __TS__Decorate(
    {registerAbility(nil)},
    musashi_ishana_daitenshou
)
____exports.musashi_ishana_daitenshou = musashi_ishana_daitenshou
____exports.musashi_modifier_ishana_daitenshou = __TS__Class()
local musashi_modifier_ishana_daitenshou = ____exports.musashi_modifier_ishana_daitenshou
musashi_modifier_ishana_daitenshou.name = "musashi_modifier_ishana_daitenshou"
__TS__ClassExtends(musashi_modifier_ishana_daitenshou, BaseModifier)
function musashi_modifier_ishana_daitenshou.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.MarkerPosition = Vector(0, 0, 0)
    self.StartPosition = Vector(0, 0, 0)
    self.SearchRadius = 0
end
function musashi_modifier_ishana_daitenshou.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_434 = self.Ability
    self.Victim = ____opt_434 and ____opt_434:GetCursorTarget()
    local ____opt_436 = self.Caster
    self.StartPosition = ____opt_436 and ____opt_436:GetAbsOrigin()
    local ____opt_438 = self.Victim
    self.MarkerPosition = ____opt_438 and ____opt_438:GetAbsOrigin()
    local ____opt_440 = self.Caster
    local NiouKurikara = ____opt_440 and ____opt_440:FindAbilityByName(____exports.musashi_niou_kurikara.name)
    local ____opt_442 = self.Caster
    if ____opt_442 ~= nil then
        ____opt_442:CastAbilityOnPosition(
            self.MarkerPosition,
            NiouKurikara,
            self.Caster:GetEntityIndex()
        )
    end
    local ____opt_444 = self.Ability
    self.SearchRadius = ____opt_444 and ____opt_444:GetSpecialValueFor("SearchRadius")
    self:CreateParticle()
    self:StartIntervalThink(0.03)
end
function musashi_modifier_ishana_daitenshou.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____Entities_FindByNameWithin_448 = Entities.FindByNameWithin
    local ____opt_446 = self.Victim
    local VictimEntity = ____Entities_FindByNameWithin_448(
        Entities,
        nil,
        ____opt_446 and ____opt_446:GetName(),
        self.MarkerPosition,
        self.SearchRadius
    )
    if not VictimEntity then
        self:Destroy()
    end
end
function musashi_modifier_ishana_daitenshou.prototype.OnStackCountChanged(self, stackCount)
    if not IsServer() then
        return
    end
    repeat
        local ____switch318 = stackCount
        local ____cond318 = ____switch318 == 0
        if ____cond318 then
            do
                local ____opt_449 = self.Caster
                if ____opt_449 ~= nil then
                    ____opt_449:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_dash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond318 = ____cond318 or ____switch318 == 1
        if ____cond318 then
            do
                local ____opt_451 = self.Caster
                if ____opt_451 ~= nil then
                    ____opt_451:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_slash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond318 = ____cond318 or ____switch318 == 2
        if ____cond318 then
            do
                self:Destroy()
                break
            end
        end
    until true
end
function musashi_modifier_ishana_daitenshou.prototype.CreateParticle(self)
    local MarkerParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_marker_basic.vpcf"
    local SwordParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_sword_basic.vpcf"
    local BodyParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_body_basic.vpcf"
    local ____opt_453 = self.Caster
    if ____opt_453 and ____opt_453:HasModifier("modifier_ascended") then
        MarkerParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_marker_unique.vpcf"
        SwordParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_sword_unique.vpcf"
        BodyParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_body_unique.vpcf"
    end
    local MarkerParticle = ParticleManager:CreateParticle(MarkerParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local SwordParticle = ParticleManager:CreateParticle(SwordParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    local BodyParticle = ParticleManager:CreateParticle(BodyParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    ParticleManager:SetParticleControl(MarkerParticle, 0, self.MarkerPosition)
    ParticleManager:SetParticleControlEnt(
        SwordParticle,
        0,
        self.Caster,
        PATTACH_POINT_FOLLOW,
        "attach_attack1",
        Vector(0, 0, 0),
        false
    )
    self:AddParticle(
        MarkerParticle,
        false,
        false,
        -1,
        false,
        false
    )
    self:AddParticle(
        SwordParticle,
        false,
        false,
        -1,
        false,
        false
    )
    self:AddParticle(
        BodyParticle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_ishana_daitenshou.prototype.CheckState(self)
    local ModifierTable = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
    }
    return ModifierTable
end
function musashi_modifier_ishana_daitenshou.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ishana_daitenshou.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_ishana_daitenshou = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ishana_daitenshou
)
____exports.musashi_modifier_ishana_daitenshou = musashi_modifier_ishana_daitenshou
____exports.musashi_modifier_ishana_daitenshou_dash = __TS__Class()
local musashi_modifier_ishana_daitenshou_dash = ____exports.musashi_modifier_ishana_daitenshou_dash
musashi_modifier_ishana_daitenshou_dash.name = "musashi_modifier_ishana_daitenshou_dash"
__TS__ClassExtends(musashi_modifier_ishana_daitenshou_dash, BaseModifier)
function musashi_modifier_ishana_daitenshou_dash.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.DashSpeed = 0
end
function musashi_modifier_ishana_daitenshou_dash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    local ____opt_455 = self:GetAbility()
    self.DashSpeed = ____opt_455 and ____opt_455:GetSpecialValueFor("DashSpeed")
    local ____opt_457 = self.Caster
    self.ModifierIshanaDaitenshou = ____opt_457 and ____opt_457:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.ModifierIshanaDaitenshou.Victim
    self:StartIntervalThink(0.03)
end
function musashi_modifier_ishana_daitenshou_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_459 = self.Caster
    local CasterAbsOrigin = ____opt_459 and ____opt_459:GetAbsOrigin()
    local ____opt_461 = self.Victim
    local VictimAbsOrigin = ____opt_461 and ____opt_461:GetAbsOrigin()
    local Direction = (VictimAbsOrigin - CasterAbsOrigin):Normalized()
    local ____opt_463 = self.Caster
    if ____opt_463 ~= nil then
        ____opt_463:SetForwardVector(Direction)
    end
    local ____opt_465 = self.Caster
    local NewPosition = CasterAbsOrigin + (____opt_465 and ____opt_465:GetForwardVector()) * self.DashSpeed
    local ____opt_467 = self.Caster
    if ____opt_467 ~= nil then
        ____opt_467:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_471 = Entities.FindByNameWithin
    local ____opt_469 = self.Caster
    local Musashi = ____Entities_FindByNameWithin_471(
        Entities,
        nil,
        ____opt_469 and ____opt_469:GetName(),
        VictimAbsOrigin,
        self.DashSpeed
    )
    if Musashi then
        self:Destroy()
    end
end
function musashi_modifier_ishana_daitenshou_dash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_472 = self.ModifierIshanaDaitenshou
    if ____opt_472 ~= nil then
        ____opt_472:IncrementStackCount()
    end
    local ____opt_474 = self.Caster
    if ____opt_474 ~= nil then
        ____opt_474:SetForwardVector(self.Caster:GetAbsOrigin():Normalized())
    end
    local ____FindClearSpaceForUnit_479 = FindClearSpaceForUnit
    local ____self_Caster_478 = self.Caster
    local ____opt_476 = self.Caster
    ____FindClearSpaceForUnit_479(
        ____self_Caster_478,
        ____opt_476 and ____opt_476:GetAbsOrigin(),
        true
    )
    local ____opt_480 = self.Caster
    if ____opt_480 ~= nil then
        ____opt_480:AddNewModifier(
            self.Caster,
            self:GetAbility(),
            "modifier_phased",
            {duration = 1}
        )
    end
end
function musashi_modifier_ishana_daitenshou_dash.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ishana_daitenshou_dash.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_ishana_daitenshou_dash = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ishana_daitenshou_dash
)
____exports.musashi_modifier_ishana_daitenshou_dash = musashi_modifier_ishana_daitenshou_dash
____exports.musashi_modifier_ishana_daitenshou_slash = __TS__Class()
local musashi_modifier_ishana_daitenshou_slash = ____exports.musashi_modifier_ishana_daitenshou_slash
musashi_modifier_ishana_daitenshou_slash.name = "musashi_modifier_ishana_daitenshou_slash"
__TS__ClassExtends(musashi_modifier_ishana_daitenshou_slash, BaseModifier)
function musashi_modifier_ishana_daitenshou_slash.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.SoundSfx = "musashi_ishana_daitenshou_sfx"
    self.NormalSlashCount = 0
    self.MaxNormalSlashCount = 0
end
function musashi_modifier_ishana_daitenshou_slash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_482 = self.Caster
    self.ModifierIshanaDaitenshou = ____opt_482 and ____opt_482:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.ModifierIshanaDaitenshou.Victim
    local ____opt_484 = self.Ability
    local NormalSlashInterval = ____opt_484 and ____opt_484:GetSpecialValueFor("NormalSlashInterval")
    local ____opt_486 = self.Ability
    self.MaxNormalSlashCount = ____opt_486 and ____opt_486:GetSpecialValueFor("MaxNormalSlashCount")
    self:StartIntervalThink(NormalSlashInterval)
    EmitGlobalSound(self.SoundSfx)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    if self.NormalSlashCount <= self.MaxNormalSlashCount then
        self:DealDamage()
        self.NormalSlashCount = self.NormalSlashCount + 1
    else
        self:Destroy()
    end
end
function musashi_modifier_ishana_daitenshou_slash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    self:PerformFinalSlash()
    local ____opt_488 = self.ModifierIshanaDaitenshou
    if ____opt_488 ~= nil then
        ____opt_488:IncrementStackCount()
    end
end
function musashi_modifier_ishana_daitenshou_slash.prototype.DealDamage(self)
    local ____opt_490 = self.Ability
    local NormalSlashMaxHpPercent = (____opt_490 and ____opt_490:GetSpecialValueFor("NormalSlashMaxHpPercent")) / 100
    local ____opt_492 = self.Victim
    local Damage = (____opt_492 and ____opt_492:GetMaxHealth()) * NormalSlashMaxHpPercent
    local ____opt_494 = self.Ability
    local DmgType = ____opt_494 and ____opt_494:GetAbilityDamageType()
    local DmgFlag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS
    DoDamage(
        self.Caster,
        self.Victim,
        Damage,
        DmgType,
        DmgFlag,
        self.Ability,
        false
    )
end
function musashi_modifier_ishana_daitenshou_slash.prototype.PerformFinalSlash(self)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____opt_496 = self.Ability
        local FinalSlashDmgDelay = ____opt_496 and ____opt_496:GetSpecialValueFor("FinalSlashDmgDelay")
        __TS__Await(Sleep(nil, FinalSlashDmgDelay))
        local ____opt_498 = self.Ability
        local FinalSlashMaxHpPercent = (____opt_498 and ____opt_498:GetSpecialValueFor("FinalSlashMaxHpPercent")) / 100
        local ____opt_500 = self.Ability
        local ExecuteThresholdPercent = ____opt_500 and ____opt_500:GetSpecialValueFor("ExecuteThresholdPercent")
        local ____opt_502 = self.Victim
        local Damage = (____opt_502 and ____opt_502:GetMaxHealth()) * FinalSlashMaxHpPercent
        local ____opt_504 = self.Ability
        local DmgType = ____opt_504 and ____opt_504:GetAbilityDamageType()
        local DmgFlag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS
        DoDamage(
            self.Caster,
            self.Victim,
            Damage,
            DmgType,
            DmgFlag,
            self.Ability,
            false
        )
        self:CreateParticle()
        local ____opt_506 = self.Victim
        local CurrentHealth = ____opt_506 and ____opt_506:GetHealthPercent()
        if CurrentHealth <= ExecuteThresholdPercent then
            local ____opt_508 = self.Victim
            if ____opt_508 ~= nil then
                ____opt_508:Kill(self.Ability, self.Caster)
            end
        else
            local ____opt_510 = self.Victim
            local CurrentHealthPercent = ____opt_510 and ____opt_510:GetHealthPercent()
            local ____opt_512 = self.Victim
            if ____opt_512 ~= nil then
                ____opt_512:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_debuff.name, {undefined = undefined})
            end
            local ____opt_514 = self.Victim
            local NewHealth = (____opt_514 and ____opt_514:GetMaxHealth()) * CurrentHealthPercent / 100
            local ____opt_516 = self.Victim
            if ____opt_516 ~= nil then
                ____opt_516:SetHealth(NewHealth)
            end
        end
    end)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_slash_basic.vpcf"
    local ____opt_518 = self.ModifierIshanaDaitenshou
    local StartPosition = ____opt_518 and ____opt_518.StartPosition
    local ____opt_520 = self.Caster
    local EndPosition = ____opt_520 and ____opt_520:GetAbsOrigin()
    local ____opt_522 = self.Caster
    if ____opt_522 and ____opt_522:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_slash_unique.vpcf"
        local PetalsParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_petals_unique.vpcf"
        local PetalsParticle = ParticleManager:CreateParticle(PetalsParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        ParticleManager:SetParticleControl(PetalsParticle, 0, EndPosition)
        ParticleManager:SetParticleControl(PetalsParticle, 2, EndPosition)
        ParticleManager:SetParticleControl(PetalsParticle, 3, StartPosition)
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    ParticleManager:SetParticleControl(Particle, 0, StartPosition)
    ParticleManager:SetParticleControl(Particle, 1, EndPosition)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ishana_daitenshou_slash.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_ishana_daitenshou_slash = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ishana_daitenshou_slash
)
____exports.musashi_modifier_ishana_daitenshou_slash = musashi_modifier_ishana_daitenshou_slash
____exports.musashi_modifier_ishana_daitenshou_debuff = __TS__Class()
local musashi_modifier_ishana_daitenshou_debuff = ____exports.musashi_modifier_ishana_daitenshou_debuff
musashi_modifier_ishana_daitenshou_debuff.name = "musashi_modifier_ishana_daitenshou_debuff"
__TS__ClassExtends(musashi_modifier_ishana_daitenshou_debuff, BaseModifier)
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierExtraHealthPercentage(self)
    local ____opt_524 = self:GetAbility()
    return ____opt_524 and ____opt_524:GetSpecialValueFor("MaxHpReductionPercent")
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_526 = self:GetAbility()
    return ____opt_526 and ____opt_526:GetSpecialValueFor("ExtraIncomingDmgPercent")
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.RemoveOnDeath(self)
    return true
end
musashi_modifier_ishana_daitenshou_debuff = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ishana_daitenshou_debuff
)
____exports.musashi_modifier_ishana_daitenshou_debuff = musashi_modifier_ishana_daitenshou_debuff
____exports.musashi_modifier_ishana_daitenshou_cooldown = __TS__Class()
local musashi_modifier_ishana_daitenshou_cooldown = ____exports.musashi_modifier_ishana_daitenshou_cooldown
musashi_modifier_ishana_daitenshou_cooldown.name = "musashi_modifier_ishana_daitenshou_cooldown"
__TS__ClassExtends(musashi_modifier_ishana_daitenshou_cooldown, BaseModifier)
function musashi_modifier_ishana_daitenshou_cooldown.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ishana_daitenshou_cooldown.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_ishana_daitenshou_cooldown.prototype.IsDebuff(self)
    return true
end
function musashi_modifier_ishana_daitenshou_cooldown.prototype.RemoveOnDeath(self)
    return false
end
musashi_modifier_ishana_daitenshou_cooldown = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ishana_daitenshou_cooldown
)
____exports.musashi_modifier_ishana_daitenshou_cooldown = musashi_modifier_ishana_daitenshou_cooldown
____exports.musashi_niou = __TS__Class()
local musashi_niou = ____exports.musashi_niou
musashi_niou.name = "musashi_niou"
__TS__ClassExtends(musashi_niou, BaseAbility)
function musashi_niou.prototype.OnSpellStart(self)
    local Caster = self:GetCaster()
    self.Niou = CreateUnitByName(
        "musashi_niou",
        Caster:GetAbsOrigin(),
        false,
        Caster,
        Caster,
        Caster:GetTeam()
    )
    local ModelScale = self:GetSpecialValueFor("ModelScale")
    if Caster:HasModifier(____exports.musashi_modifier_ishana_daitenshou.name) then
        ModelScale = 6
    end
    self.Niou:SetModelScale(ModelScale)
    self.Niou:AddNewModifier(self.Niou, self, ____exports.musashi_modifier_niou.name, {undefined = undefined})
end
function musashi_niou.prototype.DestroyNiou(self, delay)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____opt_528 = self.Niou
        if ____opt_528 ~= nil then
            ____opt_528:ForceKill(false)
        end
        __TS__Await(Sleep(nil, delay))
        local ____opt_530 = self.Niou
        if ____opt_530 ~= nil then
            ____opt_530:Destroy()
        end
    end)
end
musashi_niou = __TS__Decorate(
    {registerAbility(nil)},
    musashi_niou
)
____exports.musashi_niou = musashi_niou
____exports.musashi_modifier_niou = __TS__Class()
local musashi_modifier_niou = ____exports.musashi_modifier_niou
musashi_modifier_niou.name = "musashi_modifier_niou"
__TS__ClassExtends(musashi_modifier_niou, BaseModifier)
function musashi_modifier_niou.prototype.CheckState(self)
    local ModifierTable = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
    }
    return ModifierTable
end
function musashi_modifier_niou.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_niou.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_niou.prototype.IsPermanent(self)
    return true
end
function musashi_modifier_niou.prototype.IsHidden(self)
    return true
end
musashi_modifier_niou = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_niou
)
____exports.musashi_modifier_niou = musashi_modifier_niou
return ____exports
