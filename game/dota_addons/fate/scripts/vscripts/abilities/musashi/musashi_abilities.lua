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
    local ____opt_0 = self.Caster
    if ____opt_0 ~= nil then
        ____opt_0:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_dai_go_sei.name, {duration = BuffDuration})
    end
    local ____opt_2 = self.Caster
    if ____opt_2 ~= nil then
        ____opt_2:SetAbsOrigin(Victim and Victim:GetAbsOrigin())
    end
    local ____FindClearSpaceForUnit_9 = FindClearSpaceForUnit
    local ____self_Caster_8 = self.Caster
    local ____opt_6 = self.Caster
    ____FindClearSpaceForUnit_9(
        ____self_Caster_8,
        ____opt_6 and ____opt_6:GetAbsOrigin(),
        true
    )
    Victim:AddNewModifier(self.Caster, self, "modifier_stunned", {duration = StunDuration})
    self:PlaySound()
end
function musashi_dai_go_sei.prototype.PlaySound(self)
    local ____opt_10 = self.Caster
    if ____opt_10 ~= nil then
        ____opt_10:EmitSound(self.SoundVoiceline)
    end
    local ____opt_12 = self.Caster
    if ____opt_12 ~= nil then
        ____opt_12:EmitSound(self.SoundSfx)
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
function musashi_modifier_dai_go_sei.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_14 = self.Ability
    self.BonusDmg = ____opt_14 and ____opt_14:GetSpecialValueFor("BonusDmg")
    local ____opt_16 = self.Ability
    self.BonusAtkSpeed = ____opt_16 and ____opt_16:GetSpecialValueFor("BonusAtkSpeed")
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
    local ____temp_20 = event.attacker == self.Caster and event.target:IsRealHero()
    if ____temp_20 then
        local ____opt_18 = self.Caster
        ____temp_20 = ____opt_18 and ____opt_18:HasModifier(____exports.musashi_modifier_tengan.name)
    end
    if ____temp_20 then
        self:IncrementStackCount()
        local ____opt_21 = self.Ability
        local HitsRequired = ____opt_21 and ____opt_21:GetSpecialValueFor("HitsRequired")
        if self:GetStackCount() == HitsRequired then
            self:SetStackCount(0)
            local ____event_damage_25 = event.damage
            local ____opt_23 = self.Ability
            local Damage = ____event_damage_25 * (____opt_23 and ____opt_23:GetSpecialValueFor("CriticalDmg"))
            local DmgType = DAMAGE_TYPE_PHYSICAL
            local DmgFlag = DOTA_DAMAGE_FLAG_NONE
            DoDamage(
                self.Caster,
                event.target,
                Damage,
                DmgType,
                DmgFlag,
                self.Ability,
                false
            )
        end
    end
end
function musashi_modifier_dai_go_sei.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_basic.vpcf"
    local BlueOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_basic.vpcf"
    local RedOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_redorb_basic.vpcf"
    local ____opt_26 = self.Caster
    if ____opt_26 and ____opt_26:HasModifier("modifier_ascended") then
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
    self:PlaySound()
end
function musashi_accel_turn.prototype.PlaySound(self)
    local ____opt_28 = self.Caster
    if ____opt_28 ~= nil then
        ____opt_28:EmitSound(self.SoundVoiceline)
    end
    local ____opt_30 = self.Caster
    if ____opt_30 ~= nil then
        ____opt_30:EmitSound(self.SoundSfx)
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
    self.StartPosition = Vector(0, 0, 0)
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
    local ____opt_32 = self.Ability
    self.Direction = ____opt_32 and ____opt_32:GetForwardVector():__unm()
    local ____opt_34 = self.Caster
    self.StartPosition = ____opt_34 and ____opt_34:GetAbsOrigin()
    local ____opt_36 = self.Ability
    self.DashRange = ____opt_36 and ____opt_36:GetSpecialValueFor("DashRange")
    local ____opt_38 = self.Ability
    self.DashSpeed = ____opt_38 and ____opt_38:GetSpecialValueFor("DashSpeed")
    self:CreateParticle()
    self:StartIntervalThink(0.03)
end
function musashi_modifier_accel_turn.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_40 = self.Caster
    if ____opt_40 ~= nil then
        ____opt_40:SetForwardVector(self.Direction)
    end
    local ____opt_42 = self.Caster
    local CurrentOrigin = ____opt_42 and ____opt_42:GetAbsOrigin()
    local ____opt_44 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_44 and ____opt_44:GetForwardVector()) * self.DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_46 = self.Caster
    if ____opt_46 ~= nil then
        ____opt_46:SetAbsOrigin(NewPosition)
    end
    if self.UnitsTravelled >= self.DashRange then
        self:Destroy()
    end
end
function musashi_modifier_accel_turn.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    self:DealDamage()
    local ____opt_48 = self.Caster
    if ____opt_48 ~= nil then
        ____opt_48:SetForwardVector(self.Caster:GetAbsOrigin():Normalized())
    end
    local ____FindClearSpaceForUnit_53 = FindClearSpaceForUnit
    local ____self_Caster_52 = self.Caster
    local ____opt_50 = self.Caster
    ____FindClearSpaceForUnit_53(
        ____self_Caster_52,
        ____opt_50 and ____opt_50:GetAbsOrigin(),
        true
    )
    local ____opt_54 = self.Caster
    if ____opt_54 ~= nil then
        ____opt_54:AddNewModifier(self.Caster, self.Ability, "modifier_phased", {duration = 1})
    end
end
function musashi_modifier_accel_turn.prototype.DealDamage(self)
    local ____opt_56 = self.Ability
    local DashWidth = ____opt_56 and ____opt_56:GetSpecialValueFor("DashWidth")
    local ____opt_58 = self.Ability
    local Damage = ____opt_58 and ____opt_58:GetSpecialValueFor("Damage")
    local ____opt_60 = self.Ability
    local DmgType = ____opt_60 and ____opt_60:GetAbilityDamageType()
    local DmgFlag = DOTA_DAMAGE_FLAG_NONE
    local ____FindUnitsInLine_73 = FindUnitsInLine
    local ____opt_62 = self.Caster
    local ____array_72 = __TS__SparseArrayNew(
        ____opt_62 and ____opt_62:GetTeam(),
        self.StartPosition
    )
    local ____opt_64 = self.Caster
    __TS__SparseArrayPush(
        ____array_72,
        ____opt_64 and ____opt_64:GetAbsOrigin(),
        nil,
        DashWidth
    )
    local ____opt_66 = self.Ability
    __TS__SparseArrayPush(
        ____array_72,
        ____opt_66 and ____opt_66:GetAbilityTargetTeam()
    )
    local ____opt_68 = self.Ability
    __TS__SparseArrayPush(
        ____array_72,
        ____opt_68 and ____opt_68:GetAbilityTargetType()
    )
    local ____opt_70 = self.Ability
    __TS__SparseArrayPush(
        ____array_72,
        ____opt_70 and ____opt_70:GetAbilityTargetFlags()
    )
    local Targets = ____FindUnitsInLine_73(__TS__SparseArraySpread(____array_72))
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
end
function musashi_modifier_accel_turn.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_accel_turn_basic.vpcf"
    local ____opt_74 = self.Caster
    if ____opt_74 and ____opt_74:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_accel_turn_unique.vpcf"
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ParticleSpeed = self.Direction * 2000
    local ____ParticleManager_SetParticleControl_78 = ParticleManager.SetParticleControl
    local ____opt_76 = self.Caster
    ____ParticleManager_SetParticleControl_78(
        ParticleManager,
        Particle,
        0,
        ____opt_76 and ____opt_76:GetAbsOrigin()
    )
    ParticleManager:SetParticleControl(Particle, 1, ParticleSpeed)
    self:AddParticle(
        Particle,
        false,
        false,
        -1,
        false,
        false
    )
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
    local ____opt_79 = self.Niou
    if ____opt_79 ~= nil then
        ____opt_79:FaceTowards(self:GetCursorPosition())
    end
    return true
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseInterrupted(self)
    local ____opt_81 = self.NiouSkill
    if ____opt_81 ~= nil then
        ____opt_81:DestroyNiou(0)
    end
end
function musashi_niou_kurikara.prototype.OnSpellStart(self)
    local ____opt_83 = self.Caster
    if ____opt_83 ~= nil then
        ____opt_83:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_niou_kurikara_channeling.name, {duration = 1.5})
    end
    local ____opt_85 = self.Niou
    if ____opt_85 ~= nil then
        ____opt_85:StartGestureWithPlaybackRate(ACT_DOTA_CHANNEL_ABILITY_1, 1.1)
    end
    local ____opt_87 = self.Caster
    if not (____opt_87 and ____opt_87:HasModifier(____exports.musashi_modifier_ishana_daitenshou.name)) then
        EmitGlobalSound(self.SoundVoiceline)
    end
end
function musashi_niou_kurikara.prototype.OnUpgrade(self)
    local ____opt_89 = self.NiouSkill
    if ____opt_89 ~= nil then
        ____opt_89:SetLevel(self:GetLevel())
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
    local ____opt_91 = self.Ability
    self.TargetPoint = ____opt_91 and ____opt_91:GetCursorPosition()
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
    print("slashcount", self.SlashCount)
    local ____opt_93 = self.Caster
    local NiouSkill = ____opt_93 and ____opt_93:FindAbilityByName(____exports.musashi_niou.name)
    NiouSkill:DestroyNiou(1)
    local ____opt_95 = self.Ability
    local BuffDuration = ____opt_95 and ____opt_95:GetSpecialValueFor("BuffDuration")
    local ____opt_97 = self.Caster
    if ____opt_97 ~= nil then
        ____opt_97:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_niou_kurikara_postchannel_buff.name, {duration = BuffDuration})
    end
    local ____opt_99 = self.Caster
    local ModifierIshanaDaitenshou = ____opt_99 and ____opt_99:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    if ModifierIshanaDaitenshou ~= nil then
        ModifierIshanaDaitenshou:IncrementStackCount()
    end
end
function musashi_modifier_niou_kurikara_channeling.prototype.DealDamage(self)
    self.SlashCount = self.SlashCount + 1
    local ____opt_103 = self.Ability
    local Damage = ____opt_103 and ____opt_103:GetSpecialValueFor("DmgPerSlash")
    local ____opt_105 = self.Ability
    local DmgType = ____opt_105 and ____opt_105:GetAbilityDamageType()
    local ____opt_107 = self.Ability
    local TargetFlags = ____opt_107 and ____opt_107:GetAbilityTargetFlags()
    local DmgFlag = DOTA_DAMAGE_FLAG_NONE
    local Targets
    local ____opt_109 = self.Caster
    local ____temp_113 = ____opt_109 and ____opt_109:HasModifier(____exports.musashi_modifier_tenma_gogan.name)
    if not ____temp_113 then
        local ____opt_111 = self.Caster
        ____temp_113 = ____opt_111 and ____opt_111:HasModifier(____exports.musashi_modifier_ishana_daitenshou.name)
    end
    if ____temp_113 then
        DmgType = DAMAGE_TYPE_PURE
        DmgFlag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS
        TargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    end
    local ____FindUnitsInRadius_123 = FindUnitsInRadius
    local ____opt_114 = self.Caster
    local ____array_122 = __TS__SparseArrayNew(
        ____opt_114 and ____opt_114:GetTeam(),
        self.TargetPoint,
        nil
    )
    local ____opt_116 = self.Ability
    __TS__SparseArrayPush(
        ____array_122,
        ____opt_116 and ____opt_116:GetAOERadius()
    )
    local ____opt_118 = self.Ability
    __TS__SparseArrayPush(
        ____array_122,
        ____opt_118 and ____opt_118:GetAbilityTargetTeam()
    )
    local ____opt_120 = self.Ability
    __TS__SparseArrayPush(
        ____array_122,
        ____opt_120 and ____opt_120:GetAbilityTargetType(),
        TargetFlags,
        FIND_ANY_ORDER,
        false
    )
    Targets = ____FindUnitsInRadius_123(__TS__SparseArraySpread(____array_122))
    for ____, Iterator in ipairs(Targets) do
        local ____opt_124 = self.Caster
        if ____opt_124 and ____opt_124:HasModifier("musashi_attribute_gorin_no_sho") then
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
    local ____opt_126 = self.Caster
    local ModifierTengan = ____opt_126 and ____opt_126:FindModifierByName(____exports.musashi_modifier_tengan.name)
    if self.SlashCount == 4 and ModifierTengan then
        DmgType = DAMAGE_TYPE_PURE
        DmgFlag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
        TargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
        local ____FindUnitsInRadius_137 = FindUnitsInRadius
        local ____opt_128 = self.Caster
        local ____array_136 = __TS__SparseArrayNew(
            ____opt_128 and ____opt_128:GetTeam(),
            self.TargetPoint,
            nil
        )
        local ____opt_130 = self.Ability
        __TS__SparseArrayPush(
            ____array_136,
            ____opt_130 and ____opt_130:GetAOERadius()
        )
        local ____opt_132 = self.Ability
        __TS__SparseArrayPush(
            ____array_136,
            ____opt_132 and ____opt_132:GetAbilityTargetTeam()
        )
        local ____opt_134 = self.Ability
        __TS__SparseArrayPush(
            ____array_136,
            ____opt_134 and ____opt_134:GetAbilityTargetType(),
            TargetFlags,
            FIND_ANY_ORDER,
            false
        )
        Targets = ____FindUnitsInRadius_137(__TS__SparseArraySpread(____array_136))
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
        local ____opt_138 = self.Caster
        local ModifierTenmaGogan = ____opt_138 and ____opt_138:FindModifierByName(____exports.musashi_modifier_tenma_gogan.name)
        ModifierTengan:Destroy()
        if ModifierTenmaGogan ~= nil then
            ModifierTenmaGogan:Destroy()
        end
    end
end
function musashi_modifier_niou_kurikara_channeling.prototype.ApplyElementalDebuffs(self, Target)
    local ____opt_142 = self.Caster
    local GorinNoSho = ____opt_142 and ____opt_142:FindModifierByName("musashi_attribute_gorin_no_sho")
    local AttributeAbility = GorinNoSho and GorinNoSho:GetAbility()
    repeat
        local ____switch67 = self.SlashCount
        local ____cond67 = ____switch67 == 1
        if ____cond67 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("DebuffDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_earth_debuff.name, {duration = DebuffDuration})
                break
            end
        end
        ____cond67 = ____cond67 or ____switch67 == 2
        if ____cond67 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("DebuffDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_water_debuff.name, {duration = DebuffDuration})
                break
            end
        end
        ____cond67 = ____cond67 or ____switch67 == 3
        if ____cond67 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("FireBurnDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_fire_debuff.name, {duration = DebuffDuration})
                break
            end
        end
        ____cond67 = ____cond67 or ____switch67 == 4
        if ____cond67 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("WindDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_wind_debuff.name, {duration = DebuffDuration})
                break
            end
        end
    until true
end
function musashi_modifier_niou_kurikara_channeling.prototype.CreateParticle(self)
    local ____opt_154 = self.Caster
    if ____opt_154 and ____opt_154:HasModifier("modifier_ascended") then
        local AoeParticleStr = ""
        local CrackParticleStr = ""
        repeat
            local ____switch74 = self.SlashCount
            local ____cond74 = ____switch74 == 1
            if ____cond74 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond74 = ____cond74 or ____switch74 == 2
            if ____cond74 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water_crack.vpcf"
                    break
                end
            end
            ____cond74 = ____cond74 or ____switch74 == 3
            if ____cond74 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire_crack.vpcf"
                    break
                end
            end
            ____cond74 = ____cond74 or ____switch74 == 4
            if ____cond74 then
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
        local ____ParticleManager_SetParticleControl_158 = ParticleManager.SetParticleControl
        local ____opt_156 = self.Ability
        ____ParticleManager_SetParticleControl_158(
            ParticleManager,
            AoeParticle,
            12,
            Vector(
                ____opt_156 and ____opt_156:GetAOERadius(),
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
        local ____ParticleManager_SetParticleControl_161 = ParticleManager.SetParticleControl
        local ____opt_159 = self.Ability
        ____ParticleManager_SetParticleControl_161(
            ParticleManager,
            AoeParticle,
            2,
            Vector(
                ____opt_159 and ____opt_159:GetAOERadius(),
                0,
                0
            )
        )
    end
end
function musashi_modifier_niou_kurikara_channeling.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_162 = self:GetAbility()
    return ____opt_162 and ____opt_162:GetSpecialValueFor("DmgReducWhileChannel")
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
    local ____opt_164 = self:GetAbility()
    return ____opt_164 and ____opt_164:GetSpecialValueFor("EarthSlow")
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
    local ____opt_166 = self.Caster
    local ModifierNiouKurikara = ____opt_166 and ____opt_166:FindModifierByName(____exports.musashi_modifier_niou_kurikara_channeling.name)
    self.TargetPoint = ModifierNiouKurikara.TargetPoint
    local ____opt_168 = self.Attribute
    self.PushSpeed = ____opt_168 and ____opt_168:GetSpecialValueFor("PushSpeed")
    local ____opt_170 = self.Victim
    if ____opt_170 ~= nil then
        ____opt_170:AddNewModifier(self.Caster, self.Attribute, "modifier_rooted", {duration = 1})
    end
    self:StartIntervalThink(0.03)
end
function musashi_modifier_water_debuff.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_172 = self.Victim
    local CurrentOrigin = ____opt_172 and ____opt_172:GetAbsOrigin()
    local ForwardVector = (self.TargetPoint - CurrentOrigin):Normalized()
    local ____opt_174 = self.Victim
    if ____opt_174 ~= nil then
        ____opt_174:SetForwardVector(ForwardVector)
    end
    local ____opt_176 = self.Victim
    local NewPosition = CurrentOrigin + (____opt_176 and ____opt_176:GetForwardVector()) * self.PushSpeed
    local ____opt_178 = self.Victim
    if ____opt_178 ~= nil then
        ____opt_178:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_182 = Entities.FindByNameWithin
    local ____opt_180 = self.Victim
    local VictimEntity = ____Entities_FindByNameWithin_182(
        Entities,
        nil,
        ____opt_180 and ____opt_180:GetName(),
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
    local ____opt_183 = self.Victim
    if ____opt_183 ~= nil then
        ____opt_183:SetForwardVector(self.Victim:GetAbsOrigin():Normalized())
    end
    local ____FindClearSpaceForUnit_188 = FindClearSpaceForUnit
    local ____self_Victim_187 = self.Victim
    local ____opt_185 = self.Victim
    ____FindClearSpaceForUnit_188(
        ____self_Victim_187,
        ____opt_185 and ____opt_185:GetAbsOrigin(),
        true
    )
    local ____opt_189 = self.Victim
    if ____opt_189 ~= nil then
        ____opt_189:AddNewModifier(self.Victim, self.Attribute, "modifier_phased", {duration = 1})
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
    local ____opt_191 = self.Ability
    local DebuffDuration = ____opt_191 and ____opt_191:GetSpecialValueFor("DebuffDuration")
    local ____opt_193 = self.Ability
    self.Damage = ____opt_193 and ____opt_193:GetSpecialValueFor("FireBurnDmgPerSec")
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
    local ____opt_195 = self.Caster
    if ____opt_195 and ____opt_195:HasModifier("modifier_ascended") then
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
    local ____opt_197 = self.Ability
    return ____opt_197 and ____opt_197:GetSpecialValueFor("FireIncreaseDmgTaken")
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
    local ____opt_199 = self:GetAbility()
    return ____opt_199 and ____opt_199:GetSpecialValueFor("DmgReducFinishChannel")
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
    local ____opt_201 = self.Caster
    if ____opt_201 ~= nil then
        ____opt_201:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_tengan.name, {duration = BuffDuration})
    end
    local ____opt_203 = self.ChargeCounter
    if ____opt_203 ~= nil then
        local ____opt_204 = self.ChargeCounter
        local ____temp_206 = ____opt_204 and ____opt_204.RechargeTimer
        ____temp_206[#____temp_206 + 1] = RechargeTime
    end
    local ____opt_208 = self.ChargeCounter
    local ____temp_212 = (____opt_208 and ____opt_208:GetStackCount()) == self:GetSpecialValueFor("MaxCharges")
    if ____temp_212 then
        local ____opt_210 = self.Caster
        ____temp_212 = ____opt_210 and ____opt_210:HasModifier("musashi_attribute_improve_tengan")
    end
    if ____temp_212 then
        InitSkillSlotChecker(self.Caster, ____exports.musashi_tengan.name, ____exports.musashi_tenma_gogan.name, 5)
    end
    local ____opt_213 = self.ChargeCounter
    if ____opt_213 ~= nil then
        ____opt_213:DecrementStackCount()
    end
    self:PlaySound()
end
function musashi_tengan.prototype.PlaySound(self)
    local ____opt_215 = self.Caster
    if ____opt_215 ~= nil then
        ____opt_215:EmitSound(self.SoundVoiceline)
    end
    local ____opt_217 = self.Caster
    if ____opt_217 ~= nil then
        ____opt_217:EmitSound(self.SoundSfx)
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
    local ____opt_219 = self.Ability
    local MaxCharges = ____opt_219 and ____opt_219:GetSpecialValueFor("MaxCharges")
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
        local ____opt_221 = self.Ability
        if ____opt_221 ~= nil then
            ____opt_221:StartCooldown(self.RechargeTimer[1] or 0)
        end
    else
        local ____opt_223 = self.Ability
        if ____opt_223 ~= nil then
            ____opt_223:EndCooldown()
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
            local ____self_RechargeTimer_225, ____temp_226 = self.RechargeTimer, i + 1
            ____self_RechargeTimer_225[____temp_226] = ____self_RechargeTimer_225[____temp_226] - 1
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
    local ____opt_231 = self.Caster
    if ____opt_231 and ____opt_231:HasModifier("modifier_ascended") then
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
    local ____opt_235 = self.Caster
    local ModifierGanryuuJima = ____opt_235 and ____opt_235:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_ganryuu_jima.name, {undefined = undefined})
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
        local ____opt_239 = self.Caster
        if ____opt_239 and ____opt_239:HasModifier("musashi_attribute_niten_ichiryuu") then
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
        local ____switch164 = stackCount
        local ____cond164 = ____switch164 == 0
        if ____cond164 then
            do
                Position = self.DashPosition
                local ____opt_241 = self.Caster
                local DashBuff = ____opt_241 and ____opt_241:AddNewModifier(self.Caster, self.GanryuuJima, ____exports.musashi_modifier_ganryuu_jima_dash.name, {undefined = undefined})
                DashBuff.TargetPoint = Position
                local ____DashBuff_TargetPoint_245 = DashBuff.TargetPoint
                local ____opt_243 = self.Caster
                ____DashBuff_TargetPoint_245.z = ____opt_243 and ____opt_243:GetAbsOrigin().z
                local ____DashBuff_TargetPoint_248 = DashBuff.TargetPoint
                local ____opt_246 = self.Caster
                DashBuff.NormalizedTargetPoint = (____DashBuff_TargetPoint_248 - (____opt_246 and ____opt_246:GetAbsOrigin())):Normalized()
                DashBuff:StartIntervalThink(0.03)
                break
            end
        end
        ____cond164 = ____cond164 or ____switch164 == 1
        if ____cond164 then
            do
                Position = self.SlashPosition
                break
            end
        end
        ____cond164 = ____cond164 or ____switch164 == 2
        if ____cond164 then
            do
                Position = self.SecondSlashPosition
                break
            end
        end
        ____cond164 = ____cond164 or ____switch164 == 3
        if ____cond164 then
            do
                self:Destroy()
                break
            end
        end
    until true
    if stackCount == 1 or stackCount == 2 then
        local ____opt_249 = self.Caster
        local SlashBuff = ____opt_249 and ____opt_249:AddNewModifier(self.Caster, self.GanryuuJima, ____exports.musashi_modifier_ganryuu_jima_slash.name, {undefined = undefined})
        SlashBuff.TargetPoint = Position
        SlashBuff:StartIntervalThink(0.03)
    end
end
function musashi_modifier_ganryuu_jima.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_251 = self.Caster
    if ____opt_251 ~= nil then
        ____opt_251:SetForwardVector(self.Caster:GetAbsOrigin():Normalized())
    end
    local ____opt_253 = self.Caster
    if ____opt_253 ~= nil then
        ____opt_253:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    local ____FindClearSpaceForUnit_258 = FindClearSpaceForUnit
    local ____self_Caster_257 = self.Caster
    local ____opt_255 = self.Caster
    ____FindClearSpaceForUnit_258(
        ____self_Caster_257,
        ____opt_255 and ____opt_255:GetAbsOrigin(),
        true
    )
    local ____opt_259 = self.Caster
    if ____opt_259 ~= nil then
        ____opt_259:AddNewModifier(self.Caster, self.GanryuuJima, "modifier_phased", {duration = 1})
    end
    local ____opt_261 = self.Caster
    local ModifierTengan = ____opt_261 and ____opt_261:FindModifierByName(____exports.musashi_modifier_tengan.name)
    if ModifierTengan ~= nil then
        ModifierTengan:Destroy()
    end
    local ____opt_265 = self.Caster
    local ModifierTenmaGogan = ____opt_265 and ____opt_265:FindModifierByName(____exports.musashi_modifier_tenma_gogan.name)
    if ModifierTenmaGogan then
        local ____opt_267 = self.GanryuuJima
        if ____opt_267 ~= nil then
            ____opt_267:EndCooldown()
        end
        local ____opt_269 = self.Caster
        if ____opt_269 ~= nil then
            local ____opt_269_GiveMana_272 = ____opt_269.GiveMana
            local ____opt_270 = self.GanryuuJima
            ____opt_269_GiveMana_272(
                ____opt_269,
                ____opt_270 and ____opt_270:GetManaCost(-1)
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
    local ____opt_276 = self.Ability
    self.SlashRange = ____opt_276 and ____opt_276:GetSpecialValueFor("SlashRange")
    local ____opt_278 = self.Ability
    self.DashSpeed = ____opt_278 and ____opt_278:GetSpecialValueFor("DashSpeed")
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_280 = self.Caster
    if ____opt_280 ~= nil then
        ____opt_280:SetForwardVector(self.NormalizedTargetPoint)
    end
    local ____opt_282 = self.Caster
    local CurrentOrigin = ____opt_282 and ____opt_282:GetAbsOrigin()
    local ____opt_284 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_284 and ____opt_284:GetForwardVector()) * self.DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_286 = self.Caster
    if ____opt_286 ~= nil then
        ____opt_286:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_290 = Entities.FindByNameWithin
    local ____opt_288 = self.Caster
    local Musashi = ____Entities_FindByNameWithin_290(
        Entities,
        nil,
        ____opt_288 and ____opt_288:GetName(),
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
    local ____opt_291 = self.Caster
    local ModifierGanryuuJima = ____opt_291 and ____opt_291:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
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
    local ____opt_295 = self.Caster
    self.StartPosition = ____opt_295 and ____opt_295:GetAbsOrigin()
    local ____opt_297 = self.Ability
    self.SlashRange = ____opt_297 and ____opt_297:GetSpecialValueFor("SlashRange")
    local ____opt_299 = self.Ability
    self.DashSpeed = ____opt_299 and ____opt_299:GetSpecialValueFor("DashSpeed")
    local ____opt_301 = self.Caster
    if ____opt_301 ~= nil then
        ____opt_301:EmitSound(self.SoundSfx)
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_303 = self.Caster
    if ____opt_303 ~= nil then
        ____opt_303:SetForwardVector(self.TargetPoint)
    end
    local ____opt_305 = self.Caster
    local CurrentOrigin = ____opt_305 and ____opt_305:GetAbsOrigin()
    local ____opt_307 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_307 and ____opt_307:GetForwardVector()) * self.DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_309 = self.Caster
    if ____opt_309 ~= nil then
        ____opt_309:SetAbsOrigin(NewPosition)
    end
    if self.UnitsTravelled >= self.SlashRange then
        self:Destroy()
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_311 = self.Caster
    self.EndPosition = ____opt_311 and ____opt_311:GetAbsOrigin()
    self:DealDamage()
    self:CreateParticle()
    local ____opt_313 = self.Caster
    local ModifierGanryuuJima = ____opt_313 and ____opt_313:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
    if ModifierGanryuuJima ~= nil then
        ModifierGanryuuJima:IncrementStackCount()
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.DealDamage(self)
    local ____opt_317 = self.Ability
    local BaseDmg = ____opt_317 and ____opt_317:GetSpecialValueFor("DmgPerSlash")
    local ____opt_319 = self.Ability
    local BonusDmgPerAgi = ____opt_319 and ____opt_319:GetSpecialValueFor("BonusDmgPerAgi")
    local Damage = BaseDmg + self.Caster:GetAgility() * BonusDmgPerAgi
    local ____opt_321 = self.Ability
    local DmgType = ____opt_321 and ____opt_321:GetAbilityDamageType()
    local DmgFlag = DOTA_DAMAGE_FLAG_NONE
    local ____FindUnitsInLine_334 = FindUnitsInLine
    local ____opt_323 = self.Caster
    local ____array_333 = __TS__SparseArrayNew(
        ____opt_323 and ____opt_323:GetTeam(),
        self.StartPosition,
        self.EndPosition,
        nil
    )
    local ____opt_325 = self.Ability
    __TS__SparseArrayPush(
        ____array_333,
        ____opt_325 and ____opt_325:GetSpecialValueFor("SlashRadius")
    )
    local ____opt_327 = self.Ability
    __TS__SparseArrayPush(
        ____array_333,
        ____opt_327 and ____opt_327:GetAbilityTargetTeam()
    )
    local ____opt_329 = self.Ability
    __TS__SparseArrayPush(
        ____array_333,
        ____opt_329 and ____opt_329:GetAbilityTargetType()
    )
    local ____opt_331 = self.Ability
    __TS__SparseArrayPush(
        ____array_333,
        ____opt_331 and ____opt_331:GetAbilityTargetFlags()
    )
    local Targets = ____FindUnitsInLine_334(__TS__SparseArraySpread(____array_333))
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
    local ____opt_335 = self.Caster
    if ____opt_335 and ____opt_335:HasModifier(____exports.musashi_modifier_tengan.name) then
        local TargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
        local ____FindUnitsInLine_344 = FindUnitsInLine
        local ____array_343 = __TS__SparseArrayNew(
            self.Caster:GetTeam(),
            self.StartPosition,
            self.EndPosition,
            nil
        )
        local ____opt_337 = self.Ability
        __TS__SparseArrayPush(
            ____array_343,
            ____opt_337 and ____opt_337:GetSpecialValueFor("SlashRadius")
        )
        local ____opt_339 = self.Ability
        __TS__SparseArrayPush(
            ____array_343,
            ____opt_339 and ____opt_339:GetAbilityTargetTeam()
        )
        local ____opt_341 = self.Ability
        __TS__SparseArrayPush(
            ____array_343,
            ____opt_341 and ____opt_341:GetAbilityTargetType(),
            TargetFlags
        )
        local Targets = ____FindUnitsInLine_344(__TS__SparseArraySpread(____array_343))
        for ____, Iterator in ipairs(Targets) do
            local ____opt_345 = self.Ability
            local DmgDelay = ____opt_345 and ____opt_345:GetSpecialValueFor("DebuffDmgDelay")
            Iterator:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ganryuu_jima_debuff.name, {duration = DmgDelay})
        end
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_basic.vpcf"
    local ____opt_347 = self.Caster
    if ____opt_347 and ____opt_347:HasModifier("modifier_ascended") then
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
    local ____opt_349 = self.Caster
    local ModifierTengan = ____opt_349 and ____opt_349:FindModifierByName(____exports.musashi_modifier_tengan.name)
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
    local ____opt_351 = self.Caster
    if ____opt_351 and ____opt_351:HasModifier("modifier_ascended") then
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
    local ____opt_353 = self.Caster
    if ____opt_353 ~= nil then
        ____opt_353:EmitSound(self.SoundVoiceline)
    end
    local ____opt_355 = self.Caster
    if ____opt_355 ~= nil then
        ____opt_355:EmitSound(self.SoundSfx)
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
    local ____opt_357 = self.Caster
    if ____opt_357 and ____opt_357:HasModifier("modifier_ascended") then
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
    local ____opt_359 = self.Caster
    if ____opt_359 ~= nil then
        ____opt_359:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_tenma_gogan.name, {duration = BuffDuration})
    end
    self:PlaySound()
end
function musashi_tenma_gogan.prototype.PlaySound(self)
    EmitGlobalSound(self.SoundVoiceline)
    local ____opt_361 = self.Caster
    if ____opt_361 ~= nil then
        ____opt_361:EmitSound(self.SoundSfx)
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
    local ____opt_363 = self.Caster
    local ChargeCounter = ____opt_363 and ____opt_363:FindModifierByName(____exports.musashi_modifier_tengan_chargecounter.name)
    local ____opt_365 = self.Caster
    local Tengan = ____opt_365 and ____opt_365:FindAbilityByName(____exports.musashi_tengan.name)
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
        local ____switch238 = stackCount
        local ____cond238 = ____switch238 == 1
        if ____cond238 then
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
    local ____opt_375 = self.Caster
    if ____opt_375 ~= nil then
        ____opt_375:AddNewModifier(self.Caster, Ability, ____exports.musashi_modifier_tenma_gogan_debuff.name, {duration = DebuffDuration})
    end
end
function musashi_modifier_tenma_gogan.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_tenma_gogan_basic.vpcf"
    local BodyParticleStr = "particles/custom/musashi/musashi_tenma_gogan_body.vpcf"
    local ____opt_377 = self.Caster
    if ____opt_377 and ____opt_377:HasModifier("modifier_ascended") then
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
    local ____opt_379 = self.Ability
    self.Radius = ____opt_379 and ____opt_379:GetSpecialValueFor("Radius")
    local ____opt_381 = self.Ability
    local RampUpInterval = ____opt_381 and ____opt_381:GetSpecialValueFor("RampUpInterval")
    self:StartIntervalThink(RampUpInterval)
    self:CreateParticle()
    local ____opt_383 = self.Caster
    if ____opt_383 ~= nil then
        ____opt_383:EmitSound(self.SoundSfx)
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
        local ____switch260 = stackCount
        local ____cond260 = ____switch260 == 0
        if ____cond260 then
            do
                local ____opt_385 = self.Ability
                self.Percentage = ____opt_385 and ____opt_385:GetSpecialValueFor("1SecPercentage")
                break
            end
        end
        ____cond260 = ____cond260 or ____switch260 == 1
        if ____cond260 then
            do
                local ____opt_387 = self.Ability
                self.Percentage = ____opt_387 and ____opt_387:GetSpecialValueFor("2SecPercentage")
                break
            end
        end
        ____cond260 = ____cond260 or ____switch260 == 2
        if ____cond260 then
            do
                local ____opt_389 = self.Ability
                self.Percentage = ____opt_389 and ____opt_389:GetSpecialValueFor("FullDamage")
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
    local ____opt_391 = self.Caster
    if ____opt_391 ~= nil then
        ____opt_391:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    self:DealDamage()
    self:CreateAoeParticle()
    local ____opt_393 = self.Caster
    if ____opt_393 ~= nil then
        ____opt_393:EmitSound(self.SoundVoiceline)
    end
    local ____opt_395 = self.Ability
    if ____opt_395 ~= nil then
        ____opt_395:SetHidden(true)
    end
end
function musashi_modifier_tengen_no_hana.prototype.DealDamage(self)
    local Damage = self.Percentage * 1000
    local DmgType = DAMAGE_TYPE_PURE
    local DmgFlag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
    local ____FindUnitsInRadius_408 = FindUnitsInRadius
    local ____opt_397 = self.Caster
    local ____array_407 = __TS__SparseArrayNew(____opt_397 and ____opt_397:GetTeam())
    local ____opt_399 = self.Caster
    __TS__SparseArrayPush(
        ____array_407,
        ____opt_399 and ____opt_399:GetAbsOrigin(),
        nil,
        self.Radius
    )
    local ____opt_401 = self.Ability
    __TS__SparseArrayPush(
        ____array_407,
        ____opt_401 and ____opt_401:GetAbilityTargetTeam()
    )
    local ____opt_403 = self.Ability
    __TS__SparseArrayPush(
        ____array_407,
        ____opt_403 and ____opt_403:GetAbilityTargetType()
    )
    local ____opt_405 = self.Ability
    __TS__SparseArrayPush(
        ____array_407,
        ____opt_405 and ____opt_405:GetAbilityTargetFlags(),
        FIND_ANY_ORDER,
        false
    )
    local Targets = ____FindUnitsInRadius_408(__TS__SparseArraySpread(____array_407))
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
        local ____opt_409 = self.Ability
        local StunDuration = (____opt_409 and ____opt_409:GetSpecialValueFor("StunDuration")) * self.Percentage
        Iterator:AddNewModifier(self.Caster, self.Ability, "modifier_stunned", {duration = StunDuration})
    end
end
function musashi_modifier_tengen_no_hana.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_basic.vpcf"
    local ____opt_411 = self.Caster
    if ____opt_411 and ____opt_411:HasModifier("modifier_ascended") then
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
    local ____opt_413 = self.Caster
    if ____opt_413 and ____opt_413:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique1.vpcf"
        MarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique1.vpcf"
        if self.Caster:HasModifier(____exports.musashi_modifier_battle_continuation_active.name) then
            ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique2.vpcf"
            MarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique2.vpcf"
        end
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local MarkerParticle = ParticleManager:CreateParticle(MarkerParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ____ParticleManager_SetParticleControl_417 = ParticleManager.SetParticleControl
    local ____opt_415 = self.Caster
    ____ParticleManager_SetParticleControl_417(
        ParticleManager,
        Particle,
        0,
        ____opt_415 and ____opt_415:GetAbsOrigin()
    )
    ParticleManager:SetParticleControl(
        Particle,
        2,
        Vector(self.Radius, self.Radius, self.Radius)
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
function musashi_modifier_battle_continuation.prototype.OnTakeDamage(self, event)
    local Caster = self:GetCaster()
    if not IsServer() or event.unit ~= Caster or not Caster:HasModifier("musashi_attribute_battle_continuation") or Caster:HasModifier(____exports.musashi_modifier_battle_continuation_cooldown.name) then
        return
    end
    if Caster:GetHealth() <= 0 and not Caster:HasModifier(____exports.musashi_modifier_tenma_gogan_debuff.name) then
        local Ability = self:GetAbility()
        local BuffDuration = Ability and Ability:GetSpecialValueFor("BuffDuration")
        Caster:SetHealth(1)
        if Caster ~= nil then
            Caster:AddNewModifier(Caster, Ability, ____exports.musashi_modifier_battle_continuation_active.name, {duration = BuffDuration})
        end
        if Caster ~= nil then
            Caster:AddNewModifier(
                Caster,
                Ability,
                ____exports.musashi_modifier_battle_continuation_cooldown.name,
                {duration = Ability and Ability:GetCooldown(1)}
            )
        end
        if Ability ~= nil then
            Ability:UseResources(true, false, true)
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
    local ____opt_428 = self.Caster
    local TengenNoHana = ____opt_428 and ____opt_428:FindAbilityByName(____exports.musashi_tengen_no_hana.name)
    local ____opt_430 = self.Caster
    if ____opt_430 ~= nil then
        ____opt_430:CastAbilityImmediately(
            TengenNoHana,
            self.Caster:GetEntityIndex()
        )
    end
    ProjectileManager:ProjectileDodge(self.Caster)
    local ____opt_432 = self.Caster
    if ____opt_432 ~= nil then
        ____opt_432:Purge(
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
    local ____opt_436 = self.Caster
    if ____opt_436 ~= nil then
        ____opt_436:Heal(Heal, Ability)
    end
end
function musashi_modifier_battle_continuation_active.prototype.PlaySound(self)
    local ____opt_438 = self.Caster
    if ____opt_438 ~= nil then
        ____opt_438:EmitSound(self.SoundVoiceline)
    end
    local ____opt_440 = self.Caster
    if ____opt_440 ~= nil then
        ____opt_440:EmitSound(self.SoundSfx)
    end
end
function musashi_modifier_battle_continuation_active.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_battle_continuation_basic.vpcf"
    local ____opt_442 = self.Caster
    if ____opt_442 and ____opt_442:HasModifier("modifier_ascended") then
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
    local ____opt_448 = self.Ability
    self.Victim = ____opt_448 and ____opt_448:GetCursorTarget()
    local ____opt_450 = self.Caster
    self.StartPosition = ____opt_450 and ____opt_450:GetAbsOrigin()
    local ____opt_452 = self.Victim
    self.MarkerPosition = ____opt_452 and ____opt_452:GetAbsOrigin()
    local ____opt_454 = self.Caster
    local NiouKurikara = ____opt_454 and ____opt_454:FindAbilityByName(____exports.musashi_niou_kurikara.name)
    local ____opt_456 = self.Caster
    if ____opt_456 ~= nil then
        ____opt_456:CastAbilityOnPosition(
            self.MarkerPosition,
            NiouKurikara,
            self.Caster:GetEntityIndex()
        )
    end
    local ____opt_458 = self.Ability
    self.SearchRadius = ____opt_458 and ____opt_458:GetSpecialValueFor("SearchRadius")
    self:CreateParticle()
    self:StartIntervalThink(0.03)
end
function musashi_modifier_ishana_daitenshou.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____Entities_FindByNameWithin_462 = Entities.FindByNameWithin
    local ____opt_460 = self.Victim
    local VictimEntity = ____Entities_FindByNameWithin_462(
        Entities,
        nil,
        ____opt_460 and ____opt_460:GetName(),
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
        local ____switch312 = stackCount
        local ____cond312 = ____switch312 == 0
        if ____cond312 then
            do
                local ____opt_463 = self.Caster
                if ____opt_463 ~= nil then
                    ____opt_463:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_dash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond312 = ____cond312 or ____switch312 == 1
        if ____cond312 then
            do
                local ____opt_465 = self.Caster
                if ____opt_465 ~= nil then
                    ____opt_465:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_slash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond312 = ____cond312 or ____switch312 == 2
        if ____cond312 then
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
    local ____opt_467 = self.Caster
    if ____opt_467 and ____opt_467:HasModifier("modifier_ascended") then
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
    local ____opt_469 = self:GetAbility()
    self.DashSpeed = ____opt_469 and ____opt_469:GetSpecialValueFor("DashSpeed")
    local ____opt_471 = self.Caster
    self.ModifierIshanaDaitenshou = ____opt_471 and ____opt_471:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.ModifierIshanaDaitenshou.Victim
    self:StartIntervalThink(0.03)
end
function musashi_modifier_ishana_daitenshou_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_473 = self.Caster
    local CasterAbsOrigin = ____opt_473 and ____opt_473:GetAbsOrigin()
    local ____opt_475 = self.Victim
    local VictimAbsOrigin = ____opt_475 and ____opt_475:GetAbsOrigin()
    local Direction = (VictimAbsOrigin - CasterAbsOrigin):Normalized()
    local ____opt_477 = self.Caster
    if ____opt_477 ~= nil then
        ____opt_477:SetForwardVector(Direction)
    end
    local ____opt_479 = self.Caster
    local NewPosition = CasterAbsOrigin + (____opt_479 and ____opt_479:GetForwardVector()) * self.DashSpeed
    local ____opt_481 = self.Caster
    if ____opt_481 ~= nil then
        ____opt_481:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_485 = Entities.FindByNameWithin
    local ____opt_483 = self.Caster
    local Musashi = ____Entities_FindByNameWithin_485(
        Entities,
        nil,
        ____opt_483 and ____opt_483:GetName(),
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
    local ____opt_486 = self.ModifierIshanaDaitenshou
    if ____opt_486 ~= nil then
        ____opt_486:IncrementStackCount()
    end
    local ____opt_488 = self.Caster
    if ____opt_488 ~= nil then
        ____opt_488:SetForwardVector(self.Caster:GetAbsOrigin():Normalized())
    end
    local ____FindClearSpaceForUnit_493 = FindClearSpaceForUnit
    local ____self_Caster_492 = self.Caster
    local ____opt_490 = self.Caster
    ____FindClearSpaceForUnit_493(
        ____self_Caster_492,
        ____opt_490 and ____opt_490:GetAbsOrigin(),
        true
    )
    local ____opt_494 = self.Caster
    if ____opt_494 ~= nil then
        ____opt_494:AddNewModifier(
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
    local ____opt_496 = self.Caster
    self.ModifierIshanaDaitenshou = ____opt_496 and ____opt_496:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.ModifierIshanaDaitenshou.Victim
    local ____opt_498 = self.Ability
    local NormalSlashInterval = ____opt_498 and ____opt_498:GetSpecialValueFor("NormalSlashInterval")
    local ____opt_500 = self.Ability
    self.MaxNormalSlashCount = ____opt_500 and ____opt_500:GetSpecialValueFor("MaxNormalSlashCount")
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
    local ____opt_502 = self.ModifierIshanaDaitenshou
    if ____opt_502 ~= nil then
        ____opt_502:IncrementStackCount()
    end
end
function musashi_modifier_ishana_daitenshou_slash.prototype.DealDamage(self)
    local ____opt_504 = self.Ability
    local NormalSlashMaxHpPercent = (____opt_504 and ____opt_504:GetSpecialValueFor("NormalSlashMaxHpPercent")) / 100
    local ____opt_506 = self.Victim
    local Damage = (____opt_506 and ____opt_506:GetMaxHealth()) * NormalSlashMaxHpPercent
    local ____opt_508 = self.Ability
    local DmgType = ____opt_508 and ____opt_508:GetAbilityDamageType()
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
        local ____opt_510 = self.Ability
        local FinalSlashDmgDelay = ____opt_510 and ____opt_510:GetSpecialValueFor("FinalSlashDmgDelay")
        __TS__Await(Sleep(nil, FinalSlashDmgDelay))
        local ____opt_512 = self.Ability
        local FinalSlashMaxHpPercent = (____opt_512 and ____opt_512:GetSpecialValueFor("FinalSlashMaxHpPercent")) / 100
        local ____opt_514 = self.Ability
        local ExecuteThresholdPercent = ____opt_514 and ____opt_514:GetSpecialValueFor("ExecuteThresholdPercent")
        local ____opt_516 = self.Victim
        local Damage = (____opt_516 and ____opt_516:GetMaxHealth()) * FinalSlashMaxHpPercent
        local ____opt_518 = self.Ability
        local DmgType = ____opt_518 and ____opt_518:GetAbilityDamageType()
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
        local ____opt_520 = self.Victim
        local CurrentHealth = ____opt_520 and ____opt_520:GetHealthPercent()
        if CurrentHealth <= ExecuteThresholdPercent then
            local ____opt_522 = self.Victim
            if ____opt_522 ~= nil then
                ____opt_522:Kill(self.Ability, self.Caster)
            end
        else
            local ____opt_524 = self.Victim
            local CurrentHealthPercent = ____opt_524 and ____opt_524:GetHealthPercent()
            local ____opt_526 = self.Victim
            if ____opt_526 ~= nil then
                ____opt_526:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_debuff.name, {undefined = undefined})
            end
            local ____opt_528 = self.Victim
            local NewHealth = (____opt_528 and ____opt_528:GetMaxHealth()) * CurrentHealthPercent / 100
            local ____opt_530 = self.Victim
            if ____opt_530 ~= nil then
                ____opt_530:SetHealth(NewHealth)
            end
        end
    end)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_slash_basic.vpcf"
    local ____opt_532 = self.ModifierIshanaDaitenshou
    local StartPosition = ____opt_532 and ____opt_532.StartPosition
    local ____opt_534 = self.Caster
    local EndPosition = ____opt_534 and ____opt_534:GetAbsOrigin()
    local ____opt_536 = self.Caster
    if ____opt_536 and ____opt_536:HasModifier("modifier_ascended") then
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
    local ____opt_538 = self:GetAbility()
    return ____opt_538 and ____opt_538:GetSpecialValueFor("MaxHpReductionPercent")
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_540 = self:GetAbility()
    return ____opt_540 and ____opt_540:GetSpecialValueFor("ExtraIncomingDmgPercent")
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
        local ____opt_542 = self.Niou
        if ____opt_542 ~= nil then
            ____opt_542:ForceKill(false)
        end
        __TS__Await(Sleep(nil, delay))
        local ____opt_544 = self.Niou
        if ____opt_544 ~= nil then
            ____opt_544:Destroy()
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
