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
    local ComboStatsFulfilled = CheckComboStatsFulfilled(self.Caster)
    if ComboStatsFulfilled and not self.Caster:HasModifier(____exports.musashi_modifier_ishana_daitenshou_cooldown.name) then
        local SkillsSequence = {____exports.musashi_dai_go_sei.name, ____exports.musashi_tengan.name}
        InitComboSequenceChecker(
            self.Caster,
            SkillsSequence,
            ____exports.musashi_ganryuu_jima.name,
            ____exports.musashi_ishana_daitenshou.name,
            4
        )
    end
    return true
end
function musashi_dai_go_sei.prototype.OnSpellStart(self)
    local Victim = self:GetCursorTarget()
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    local StunDuration = self:GetSpecialValueFor("StunDuration")
    local ____opt_0 = self.Caster
    if ____opt_0 ~= nil then
        ____opt_0:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_dai_go_sei.name, {duration = BuffDuration})
    end
    local ____opt_2 = self.Caster
    if ____opt_2 ~= nil then
        ____opt_2:SetAbsOrigin(Victim:GetAbsOrigin())
    end
    local ____FindClearSpaceForUnit_7 = FindClearSpaceForUnit
    local ____self_Caster_6 = self.Caster
    local ____opt_4 = self.Caster
    ____FindClearSpaceForUnit_7(
        ____self_Caster_6,
        ____opt_4 and ____opt_4:GetAbsOrigin(),
        true
    )
    Victim:AddNewModifier(self.Caster, self, "modifier_stunned", {duration = StunDuration})
    self:PlaySound()
end
function musashi_dai_go_sei.prototype.PlaySound(self)
    local ____opt_8 = self.Caster
    if ____opt_8 ~= nil then
        ____opt_8:EmitSound(self.SoundVoiceline)
    end
    local ____opt_10 = self.Caster
    if ____opt_10 ~= nil then
        ____opt_10:EmitSound(self.SoundSfx)
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
    local ____opt_12 = self.Ability
    self.BonusDmg = ____opt_12 and ____opt_12:GetSpecialValueFor("BonusDmg")
    local ____opt_14 = self.Ability
    self.BonusAtkSpeed = ____opt_14 and ____opt_14:GetSpecialValueFor("BonusAtkSpeed")
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
    local ____temp_18 = event.attacker == self.Caster and event.target:IsRealHero()
    if ____temp_18 then
        local ____opt_16 = self.Caster
        ____temp_18 = ____opt_16 and ____opt_16:HasModifier(____exports.musashi_modifier_tengan.name)
    end
    if ____temp_18 then
        self:IncrementStackCount()
        local ____opt_19 = self.Ability
        local HitsRequired = ____opt_19 and ____opt_19:GetSpecialValueFor("HitsRequired")
        if self:GetStackCount() == HitsRequired then
            self:SetStackCount(0)
            
            local ____ApplyDamage_26 = ApplyDamage
            local ____event_target_24 = event.target
            local ____self_Caster_25 = self.Caster
            local ____event_damage_23 = event.damage
            local ____opt_21 = self.Ability
            ____ApplyDamage_26({
                victim = ____event_target_24,
                attacker = ____self_Caster_25,
                damage = ____event_damage_23 * (____opt_21 and ____opt_21:GetSpecialValueFor("CriticalDmg")),
                damage_type = DAMAGE_TYPE_PHYSICAL,
                damage_flags = DOTA_DAMAGE_FLAG_NONE,
                ability = self.Ability
            })
        end
    end
end
function musashi_modifier_dai_go_sei.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_basic.vpcf"
    local BlueOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_basic.vpcf"
    local RedOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_redorb_basic.vpcf"
    local ____opt_27 = self.Caster
    if ____opt_27 and ____opt_27:HasModifier("modifier_ascended") then
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
    local ____opt_29 = self.Caster
    if ____opt_29 ~= nil then
        ____opt_29:EmitSound(self.SoundVoiceline)
    end
    local ____opt_31 = self.Caster
    if ____opt_31 ~= nil then
        ____opt_31:EmitSound(self.SoundSfx)
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
end
function musashi_modifier_accel_turn.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_33 = self.Caster
    self.Direction = ____opt_33 and ____opt_33:GetForwardVector():__unm()
    local ____opt_35 = self.Caster
    self.StartPosition = ____opt_35 and ____opt_35:GetAbsOrigin()
    local ____opt_37 = self.Ability
    self.DashRange = ____opt_37 and ____opt_37:GetSpecialValueFor("DashRange")
    self:CreateParticle()
    self:StartIntervalThink(0.03)
end
function musashi_modifier_accel_turn.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_39 = self.Caster
    if ____opt_39 ~= nil then
        ____opt_39:SetForwardVector(self.Direction)
    end
    local ____opt_41 = self.Caster
    local CurrentOrigin = ____opt_41 and ____opt_41:GetAbsOrigin()
    local ____opt_43 = self.Ability
    local DashSpeed = ____opt_43 and ____opt_43:GetSpecialValueFor("DashSpeed")
    local ____opt_45 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_45 and ____opt_45:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_47 = self.Caster
    if ____opt_47 ~= nil then
        ____opt_47:SetAbsOrigin(NewPosition)
    end
    if self.UnitsTravelled >= self.DashRange then
        self:Destroy()
    end
end
function musashi_modifier_accel_turn.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    self:DoDamage()
    local ____opt_49 = self.Caster
    if ____opt_49 ~= nil then
        ____opt_49:SetForwardVector(self.Caster:GetAbsOrigin():Normalized())
    end
    local ____FindClearSpaceForUnit_54 = FindClearSpaceForUnit
    local ____self_Caster_53 = self.Caster
    local ____opt_51 = self.Caster
    ____FindClearSpaceForUnit_54(
        ____self_Caster_53,
        ____opt_51 and ____opt_51:GetAbsOrigin(),
        true
    )
end
function musashi_modifier_accel_turn.prototype.DoDamage(self)
    local ____opt_55 = self.Ability
    local DashWidth = ____opt_55 and ____opt_55:GetSpecialValueFor("DashWidth")
    local ____FindUnitsInLine_68 = FindUnitsInLine
    local ____opt_57 = self.Caster
    local ____array_67 = __TS__SparseArrayNew(
        ____opt_57 and ____opt_57:GetTeam(),
        self.StartPosition
    )
    local ____opt_59 = self.Caster
    __TS__SparseArrayPush(
        ____array_67,
        ____opt_59 and ____opt_59:GetAbsOrigin(),
        nil,
        DashWidth
    )
    local ____opt_61 = self.Ability
    __TS__SparseArrayPush(
        ____array_67,
        ____opt_61 and ____opt_61:GetAbilityTargetTeam()
    )
    local ____opt_63 = self.Ability
    __TS__SparseArrayPush(
        ____array_67,
        ____opt_63 and ____opt_63:GetAbilityTargetType()
    )
    local ____opt_65 = self.Ability
    __TS__SparseArrayPush(
        ____array_67,
        ____opt_65 and ____opt_65:GetAbilityTargetFlags()
    )
    local Targets = ____FindUnitsInLine_68(__TS__SparseArraySpread(____array_67))
    for ____, Iterator in ipairs(Targets) do
        local ____ApplyDamage_75 = ApplyDamage
        local ____self_Caster_73 = self.Caster
        local ____opt_69 = self.Ability
        local ____temp_74 = ____opt_69 and ____opt_69:GetSpecialValueFor("Damage")
        local ____opt_71 = self.Ability
        ____ApplyDamage_75({
            victim = Iterator,
            attacker = ____self_Caster_73,
            damage = ____temp_74,
            damage_type = ____opt_71 and ____opt_71:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = self.Ability
        })
    end
end
function musashi_modifier_accel_turn.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_accel_turn_basic.vpcf"
    local ____opt_76 = self.Caster
    if ____opt_76 and ____opt_76:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_accel_turn_unique.vpcf"
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ParticleSpeed = self.Direction * 2000
    local ____ParticleManager_SetParticleControl_80 = ParticleManager.SetParticleControl
    local ____opt_78 = self.Caster
    ____ParticleManager_SetParticleControl_80(
        ParticleManager,
        Particle,
        0,
        ____opt_78 and ____opt_78:GetAbsOrigin()
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
    self.SoundSfx = "musashi_niou_kurikara_sfx"
    self.TargetAoe = Vector(0, 0, 0)
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
    self.TargetAoe = self:GetCursorPosition()
    local ____opt_81 = self.Niou
    if ____opt_81 ~= nil then
        ____opt_81:FaceTowards(self.TargetAoe)
    end
    return true
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseInterrupted(self)
    local ____opt_83 = self.NiouSkill
    if ____opt_83 ~= nil then
        ____opt_83:DestroyNiou(0)
    end
end
function musashi_niou_kurikara.prototype.OnSpellStart(self)
    local ____opt_85 = self.Niou
    if ____opt_85 ~= nil then
        ____opt_85:StartGestureWithPlaybackRate(ACT_DOTA_CHANNEL_ABILITY_1, 1.1)
    end
    self.SlashCount = self.SlashCount + 1
    self.Interval = 0.5
    local ____opt_87 = self.Caster
    self.DmgReducBuff = ____opt_87 and ____opt_87:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_niou_kurikara_channeling_buff.name, {undefined = undefined})
    local ____opt_89 = self.Caster
    if not (____opt_89 and ____opt_89:HasModifier(____exports.musashi_modifier_ishana_daitenshou.name)) then
        EmitGlobalSound(self.SoundVoiceline)
    end
end
function musashi_niou_kurikara.prototype.OnChannelThink(self, interval)
    local SlashCount = self:GetSpecialValueFor("SlashCount")
    if self.Interval >= 0.5 and self.SlashCount <= SlashCount then
        self.Interval = 0
        self:CreateParticle()
        self:DoDamage()
        EmitSoundOnLocationWithCaster(self.TargetAoe, self.SoundSfx, self.Caster)
    end
    self.Interval = self.Interval + interval
end
function musashi_niou_kurikara.prototype.OnChannelFinish(self, interrupted)
    self.SlashCount = 0
    self.Interval = 0
    local ____opt_91 = self.DmgReducBuff
    if ____opt_91 ~= nil then
        ____opt_91:Destroy()
    end
    if interrupted then
        local ____opt_93 = self.NiouSkill
        if ____opt_93 ~= nil then
            ____opt_93:DestroyNiou(0)
        end
    else
        local ____opt_95 = self.NiouSkill
        if ____opt_95 ~= nil then
            ____opt_95:DestroyNiou(1)
        end
        local BuffDuration = self:GetSpecialValueFor("BuffDuration")
        local ____opt_97 = self.Caster
        if ____opt_97 ~= nil then
            ____opt_97:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_niou_kurikara_postchannel_buff.name, {duration = BuffDuration})
        end
    end
end
function musashi_niou_kurikara.prototype.DoDamage(self)
    local DmgType = self:GetAbilityDamageType()
    local TargetFlags = self:GetAbilityTargetFlags()
    local DmgFlag = DOTA_DAMAGE_FLAG_NONE
    local Targets
    local ____opt_99 = self.Caster
    local ____temp_103 = ____opt_99 and ____opt_99:HasModifier(____exports.musashi_modifier_tenma_gogan.name)
    if not ____temp_103 then
        local ____opt_101 = self.Caster
        ____temp_103 = ____opt_101 and ____opt_101:HasModifier(____exports.musashi_modifier_ishana_daitenshou.name)
    end
    if ____temp_103 then
        DmgType = DAMAGE_TYPE_PURE
        DmgFlag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS
        TargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    end
    local ____FindUnitsInRadius_106 = FindUnitsInRadius
    local ____opt_104 = self.Caster
    Targets = ____FindUnitsInRadius_106(
        ____opt_104 and ____opt_104:GetTeam(),
        self.TargetAoe,
        nil,
        self:GetAOERadius(),
        self:GetAbilityTargetTeam(),
        self:GetAbilityTargetType(),
        TargetFlags,
        FIND_ANY_ORDER,
        false
    )
    for ____, Iterator in ipairs(Targets) do
        ApplyDamage({
            victim = Iterator,
            attacker = self.Caster,
            damage = self:GetSpecialValueFor("DmgPerSlash"),
            damage_type = DmgType,
            damage_flags = DmgFlag,
            ability = self
        })
        self:ApplyElementalDebuffs(Iterator)
    end
    self.SlashCount = self.SlashCount + 1
    local ____opt_107 = self.Caster
    local ModifierTengan = ____opt_107 and ____opt_107:FindModifierByName(____exports.musashi_modifier_tengan.name)
    if self.SlashCount == 5 and ModifierTengan then
        DmgType = DAMAGE_TYPE_PURE
        DmgFlag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS
        TargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
        local ____FindUnitsInRadius_111 = FindUnitsInRadius
        local ____opt_109 = self.Caster
        Targets = ____FindUnitsInRadius_111(
            ____opt_109 and ____opt_109:GetTeam(),
            self.TargetAoe,
            nil,
            self:GetAOERadius(),
            self:GetAbilityTargetTeam(),
            self:GetAbilityTargetType(),
            TargetFlags,
            FIND_ANY_ORDER,
            false
        )
        for ____, Iterator in ipairs(Targets) do
            ApplyDamage({
                victim = Iterator,
                attacker = self.Caster,
                damage = ModifierTengan.BonusDmg,
                damage_type = DmgType,
                damage_flags = DmgFlag,
                ability = self
            })
        end
        local ____opt_112 = self.Caster
        local ModifierTenmaGogan = ____opt_112 and ____opt_112:FindModifierByName(____exports.musashi_modifier_tenma_gogan.name)
        if ModifierTenmaGogan ~= nil then
            ModifierTenmaGogan:Destroy()
        end
        ModifierTengan:Destroy()
    end
end
function musashi_niou_kurikara.prototype.ApplyElementalDebuffs(self, Target)
    local ____opt_116 = self.Caster
    local GorinNoSho = ____opt_116 and ____opt_116:FindModifierByName("musashi_attribute_gorin_no_sho")
    if not GorinNoSho then
        return
    end
    local AttributeAbility = GorinNoSho:GetAbility()
    repeat
        local ____switch64 = self.SlashCount
        local ____cond64 = ____switch64 == 1
        if ____cond64 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("DebuffDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_earth_debuff.name, {duration = DebuffDuration})
                break
            end
        end
        ____cond64 = ____cond64 or ____switch64 == 2
        if ____cond64 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("DebuffDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_water_debuff.name, {duration = DebuffDuration})
                break
            end
        end
        ____cond64 = ____cond64 or ____switch64 == 3
        if ____cond64 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("FireBurnDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_fire_debuff.name, {duration = DebuffDuration})
                break
            end
        end
        ____cond64 = ____cond64 or ____switch64 == 4
        if ____cond64 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("WindDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_wind_debuff.name, {duration = DebuffDuration})
                break
            end
        end
    until true
end
function musashi_niou_kurikara.prototype.CreateParticle(self)
    local ____opt_126 = self.Caster
    if ____opt_126 and ____opt_126:HasModifier("modifier_ascended") then
        local AoeParticleStr = ""
        local CrackParticleStr = ""
        repeat
            local ____switch71 = self.SlashCount
            local ____cond71 = ____switch71 == 1
            if ____cond71 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond71 = ____cond71 or ____switch71 == 2
            if ____cond71 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water_crack.vpcf"
                    break
                end
            end
            ____cond71 = ____cond71 or ____switch71 == 3
            if ____cond71 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire_crack.vpcf"
                    break
                end
            end
            ____cond71 = ____cond71 or ____switch71 == 4
            if ____cond71 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind_crack.vpcf"
                    break
                end
            end
        until true
        local AoeParticle = ParticleManager:CreateParticle(AoeParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        local CrackParticle = ParticleManager:CreateParticle(CrackParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        ParticleManager:SetParticleControl(CrackParticle, 0, self.TargetAoe)
        ParticleManager:SetParticleControl(AoeParticle, 0, self.TargetAoe)
        ParticleManager:SetParticleControl(
            AoeParticle,
            1,
            Vector(1.5, 0, 0)
        )
        ParticleManager:SetParticleControl(
            AoeParticle,
            12,
            Vector(
                self:GetAOERadius(),
                0,
                0
            )
        )
    else
        local AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_basic.vpcf"
        local AoeParticle = ParticleManager:CreateParticle(AoeParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        ParticleManager:SetParticleControl(AoeParticle, 0, self.TargetAoe)
        ParticleManager:SetParticleControl(
            AoeParticle,
            1,
            Vector(1.5, 0, 0)
        )
        ParticleManager:SetParticleControl(
            AoeParticle,
            2,
            Vector(
                self:GetAOERadius(),
                0,
                0
            )
        )
    end
end
function musashi_niou_kurikara.prototype.OnUpgrade(self)
    local ____opt_128 = self.NiouSkill
    if ____opt_128 ~= nil then
        ____opt_128:SetLevel(self:GetLevel())
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
____exports.musashi_modifier_earth_debuff = __TS__Class()
local musashi_modifier_earth_debuff = ____exports.musashi_modifier_earth_debuff
musashi_modifier_earth_debuff.name = "musashi_modifier_earth_debuff"
__TS__ClassExtends(musashi_modifier_earth_debuff, BaseModifier)
function musashi_modifier_earth_debuff.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end
function musashi_modifier_earth_debuff.prototype.GetModifierMoveSpeedBonus_Percentage(self)
    local ____opt_130 = self:GetAbility()
    return ____opt_130 and ____opt_130:GetSpecialValueFor("EarthSlow")
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
function musashi_modifier_water_debuff.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    local Caster = self:GetCaster()
    self.Victim = self:GetParent()
    self.Ability = Caster and Caster:FindAbilityByName(____exports.musashi_niou_kurikara.name)
    self:StartIntervalThink(0.03)
end
function musashi_modifier_water_debuff.prototype.OnIntervalThink(self)
    local Ability = self:GetAbility()
    local ____opt_134 = self.Ability
    local TargetPoint = ____opt_134 and ____opt_134:GetCursorPosition()
    local ____opt_136 = self.Victim
    local CurrentOrigin = ____opt_136 and ____opt_136:GetAbsOrigin()
    local PushSpeed = Ability and Ability:GetSpecialValueFor("PushSpeed")
    local ForwardVector = (TargetPoint - CurrentOrigin):Normalized()
    local ____opt_140 = self.Victim
    if ____opt_140 ~= nil then
        ____opt_140:SetForwardVector(ForwardVector)
    end
    local ____opt_142 = self.Victim
    local NewPosition = CurrentOrigin + (____opt_142 and ____opt_142:GetForwardVector()) * PushSpeed
    local ____opt_144 = self.Victim
    if ____opt_144 ~= nil then
        ____opt_144:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_148 = Entities.FindByNameWithin
    local ____opt_146 = self.Victim
    local VictimEntity = ____Entities_FindByNameWithin_148(
        Entities,
        nil,
        ____opt_146 and ____opt_146:GetName(),
        TargetPoint,
        PushSpeed
    )
    if VictimEntity then
        self:Destroy()
    end
end
function musashi_modifier_water_debuff.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_149 = self.Victim
    if ____opt_149 ~= nil then
        ____opt_149:SetForwardVector(self.Victim:GetAbsOrigin():Normalized())
    end
    local ____FindClearSpaceForUnit_154 = FindClearSpaceForUnit
    local ____self_Victim_153 = self.Victim
    local ____opt_151 = self.Victim
    ____FindClearSpaceForUnit_154(
        ____self_Victim_153,
        ____opt_151 and ____opt_151:GetAbsOrigin(),
        true
    )
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
function musashi_modifier_fire_debuff.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Victim = self:GetParent()
    self.Ability = self:GetAbility()
    local ____opt_155 = self.Ability
    local DebuffDuration = ____opt_155 and ____opt_155:GetSpecialValueFor("DebuffDuration")
    self.Victim:AddNewModifier(self.Caster, self.Ability, "modifier_stunned", {duration = DebuffDuration})
    self:StartIntervalThink(DebuffDuration)
end
function musashi_modifier_fire_debuff.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____ApplyDamage_161 = ApplyDamage
    local ____self_Victim_159 = self.Victim
    local ____self_Caster_160 = self.Caster
    local ____opt_157 = self.Ability
    ____ApplyDamage_161({
        victim = ____self_Victim_159,
        attacker = ____self_Caster_160,
        damage = ____opt_157 and ____opt_157:GetSpecialValueFor("FireBurnDmgPerSec"),
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        ability = self.Ability
    })
end
function musashi_modifier_fire_debuff.prototype.IsStunDebuff(self)
    return true
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
____exports.musashi_modifier_niou_kurikara_channeling_buff = __TS__Class()
local musashi_modifier_niou_kurikara_channeling_buff = ____exports.musashi_modifier_niou_kurikara_channeling_buff
musashi_modifier_niou_kurikara_channeling_buff.name = "musashi_modifier_niou_kurikara_channeling_buff"
__TS__ClassExtends(musashi_modifier_niou_kurikara_channeling_buff, BaseModifier)
function musashi_modifier_niou_kurikara_channeling_buff.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_162 = self:GetAbility()
    return ____opt_162 and ____opt_162:GetSpecialValueFor("DmgReducWhileChannel")
end
function musashi_modifier_niou_kurikara_channeling_buff.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
function musashi_modifier_niou_kurikara_channeling_buff.prototype.CheckState(self)
    local ModifierTable = {[MODIFIER_STATE_UNTARGETABLE] = true, [MODIFIER_STATE_UNSELECTABLE] = true, [MODIFIER_STATE_COMMAND_RESTRICTED] = true}
    return ModifierTable
end
function musashi_modifier_niou_kurikara_channeling_buff.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_niou_kurikara_channeling_buff.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_niou_kurikara_channeling_buff = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_niou_kurikara_channeling_buff
)
____exports.musashi_modifier_niou_kurikara_channeling_buff = musashi_modifier_niou_kurikara_channeling_buff
____exports.musashi_modifier_niou_kurikara_postchannel_buff = __TS__Class()
local musashi_modifier_niou_kurikara_postchannel_buff = ____exports.musashi_modifier_niou_kurikara_postchannel_buff
musashi_modifier_niou_kurikara_postchannel_buff.name = "musashi_modifier_niou_kurikara_postchannel_buff"
__TS__ClassExtends(musashi_modifier_niou_kurikara_postchannel_buff, BaseModifier)
function musashi_modifier_niou_kurikara_postchannel_buff.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_164 = self:GetAbility()
    return ____opt_164 and ____opt_164:GetSpecialValueFor("DmgReducFinishChannel")
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
        if self.ChargeCounter:GetStackCount() > 0 then
            return true
        end
    end
    return false
end
function musashi_tengan.prototype.OnSpellStart(self)
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    local RechargeTime = self:GetSpecialValueFor("RechargeTime")
    local ____opt_166 = self.Caster
    if ____opt_166 ~= nil then
        ____opt_166:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_tengan.name, {duration = BuffDuration})
    end
    local ____opt_168 = self.ChargeCounter
    if ____opt_168 ~= nil then
        local ____opt_169 = self.ChargeCounter
        local ____temp_171 = ____opt_169 and ____opt_169.RechargeTimer
        ____temp_171[#____temp_171 + 1] = RechargeTime
    end
    local ____opt_173 = self.ChargeCounter
    local ____temp_177 = (____opt_173 and ____opt_173:GetStackCount()) == self:GetSpecialValueFor("MaxCharges")
    if ____temp_177 then
        local ____opt_175 = self.Caster
        ____temp_177 = ____opt_175 and ____opt_175:HasModifier("musashi_attribute_improve_tengan")
    end
    if ____temp_177 then
        InitSkillSlotChecker(self.Caster, ____exports.musashi_tengan.name, ____exports.musashi_tenma_gogan.name, 5)
    end
    local ____opt_178 = self.ChargeCounter
    if ____opt_178 ~= nil then
        ____opt_178:DecrementStackCount()
    end
    self:PlaySound()
end
function musashi_tengan.prototype.PlaySound(self)
    local ____opt_180 = self.Caster
    if ____opt_180 ~= nil then
        ____opt_180:EmitSound(self.SoundVoiceline)
    end
    local ____opt_182 = self.Caster
    if ____opt_182 ~= nil then
        ____opt_182:EmitSound(self.SoundSfx)
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
    local ____opt_184 = self.Ability
    local MaxCharges = ____opt_184 and ____opt_184:GetSpecialValueFor("MaxCharges")
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
        local ____opt_186 = self.Ability
        if ____opt_186 ~= nil then
            ____opt_186:StartCooldown(self.RechargeTimer[1] or 0)
        end
    else
        local ____opt_188 = self.Ability
        if ____opt_188 ~= nil then
            ____opt_188:EndCooldown()
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
            local ____self_RechargeTimer_190, ____temp_191 = self.RechargeTimer, i + 1
            ____self_RechargeTimer_190[____temp_191] = ____self_RechargeTimer_190[____temp_191] - 1
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
    local ____opt_196 = self.Caster
    if ____opt_196 and ____opt_196:HasModifier("modifier_ascended") then
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
    local ____opt_198 = self.Caster
    if ____opt_198 ~= nil then
        ____opt_198:EmitSound(self.SoundVoiceline)
    end
    local ____opt_200 = self.Caster
    if ____opt_200 ~= nil then
        ____opt_200:EmitSound(self.SoundSfx)
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
    local ____opt_202 = self.Caster
    if ____opt_202 and ____opt_202:HasModifier("modifier_ascended") then
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
function musashi_ganryuu_jima.prototype.OnVectorCastStart(self, vStartLocation, vDirection)
    self.Caster = self:GetCaster()
    self:SetVector(vStartLocation, vDirection)
    local ModifierGanryuuJima = self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_ganryuu_jima.name, {undefined = undefined})
    ModifierGanryuuJima:IncrementStackCount()
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
        local Caster = self:GetCaster()
        if Caster:HasModifier("musashi_attribute_niten_ichiryuu") then
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
        local ____switch165 = stackCount
        local ____cond165 = ____switch165 == 0
        if ____cond165 then
            do
                Position = self.DashPosition
                local ____opt_204 = self.Caster
                local DashBuff = ____opt_204 and ____opt_204:AddNewModifier(self.Caster, self.GanryuuJima, ____exports.musashi_modifier_ganryuu_jima_dash.name, {undefined = undefined})
                DashBuff.TargetPoint = Position
                local ____DashBuff_TargetPoint_208 = DashBuff.TargetPoint
                local ____opt_206 = self.Caster
                ____DashBuff_TargetPoint_208.z = ____opt_206 and ____opt_206:GetAbsOrigin().z
                local ____DashBuff_TargetPoint_211 = DashBuff.TargetPoint
                local ____opt_209 = self.Caster
                DashBuff.NormalizedTargetPoint = (____DashBuff_TargetPoint_211 - (____opt_209 and ____opt_209:GetAbsOrigin())):Normalized()
                DashBuff:StartIntervalThink(0.03)
                break
            end
        end
        ____cond165 = ____cond165 or ____switch165 == 1
        if ____cond165 then
            do
                Position = self.SlashPosition
                break
            end
        end
        ____cond165 = ____cond165 or ____switch165 == 2
        if ____cond165 then
            do
                Position = self.SecondSlashPosition
                break
            end
        end
        ____cond165 = ____cond165 or ____switch165 == 3
        if ____cond165 then
            do
                self:Destroy()
                break
            end
        end
    until true
    if stackCount == 1 or stackCount == 2 then
        local ____opt_212 = self.Caster
        local SlashBuff = ____opt_212 and ____opt_212:AddNewModifier(self.Caster, self.GanryuuJima, ____exports.musashi_modifier_ganryuu_jima_slash.name, {undefined = undefined})
        SlashBuff.TargetPoint = Position
        SlashBuff:StartIntervalThink(0.03)
    end
end
function musashi_modifier_ganryuu_jima.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_214 = self.Caster
    if ____opt_214 ~= nil then
        ____opt_214:SetForwardVector(self.Caster:GetAbsOrigin():Normalized())
    end
    local ____opt_216 = self.Caster
    if ____opt_216 ~= nil then
        ____opt_216:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    local ____FindClearSpaceForUnit_221 = FindClearSpaceForUnit
    local ____self_Caster_220 = self.Caster
    local ____opt_218 = self.Caster
    ____FindClearSpaceForUnit_221(
        ____self_Caster_220,
        ____opt_218 and ____opt_218:GetAbsOrigin(),
        true
    )
    local ____opt_222 = self.Caster
    local ModifierTengan = ____opt_222 and ____opt_222:FindModifierByName(____exports.musashi_modifier_tengan.name)
    if ModifierTengan ~= nil then
        ModifierTengan:Destroy()
    end
    local ____opt_226 = self.Caster
    local ModifierTenmaGogan = ____opt_226 and ____opt_226:FindModifierByName(____exports.musashi_modifier_tenma_gogan.name)
    if ModifierTenmaGogan then
        local ____opt_228 = self.GanryuuJima
        if ____opt_228 ~= nil then
            ____opt_228:EndCooldown()
        end
        local ____opt_230 = self.Caster
        if ____opt_230 ~= nil then
            local ____opt_230_GiveMana_233 = ____opt_230.GiveMana
            local ____opt_231 = self.GanryuuJima
            ____opt_230_GiveMana_233(
                ____opt_230,
                ____opt_231 and ____opt_231:GetManaCost(-1)
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
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_237 = self.Ability
    self.SlashRange = ____opt_237 and ____opt_237:GetSpecialValueFor("SlashRange")
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_239 = self.Caster
    if ____opt_239 ~= nil then
        ____opt_239:SetForwardVector(self.NormalizedTargetPoint)
    end
    local ____opt_241 = self.Caster
    local CurrentOrigin = ____opt_241 and ____opt_241:GetAbsOrigin()
    local ____opt_243 = self.Ability
    local DashSpeed = ____opt_243 and ____opt_243:GetSpecialValueFor("DashSpeed")
    local ____opt_245 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_245 and ____opt_245:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_247 = self.Caster
    if ____opt_247 ~= nil then
        ____opt_247:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_251 = Entities.FindByNameWithin
    local ____opt_249 = self.Caster
    local Musashi = ____Entities_FindByNameWithin_251(
        Entities,
        nil,
        ____opt_249 and ____opt_249:GetName(),
        self.TargetPoint,
        DashSpeed
    )
    if Musashi or self.UnitsTravelled >= self.SlashRange then
        self:Destroy()
    end
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_252 = self.Caster
    local ModifierGanryuuJima = ____opt_252 and ____opt_252:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
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
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_256 = self.Caster
    self.StartPosition = ____opt_256 and ____opt_256:GetAbsOrigin()
    local ____opt_258 = self.Ability
    self.SlashRange = ____opt_258 and ____opt_258:GetSpecialValueFor("SlashRange")
    local ____opt_260 = self.Caster
    if ____opt_260 ~= nil then
        ____opt_260:EmitSound(self.SoundSfx)
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_262 = self.Caster
    if ____opt_262 ~= nil then
        ____opt_262:SetForwardVector(self.TargetPoint)
    end
    local ____opt_264 = self.Caster
    local CurrentOrigin = ____opt_264 and ____opt_264:GetAbsOrigin()
    local ____opt_266 = self.Ability
    local DashSpeed = ____opt_266 and ____opt_266:GetSpecialValueFor("DashSpeed")
    local ____opt_268 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_268 and ____opt_268:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_270 = self.Caster
    if ____opt_270 ~= nil then
        ____opt_270:SetAbsOrigin(NewPosition)
    end
    if self.UnitsTravelled >= self.SlashRange then
        self:Destroy()
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_272 = self.Caster
    self.EndPosition = ____opt_272 and ____opt_272:GetAbsOrigin()
    self:DoDamage()
    self:CreateParticle()
    local ____opt_274 = self.Caster
    local ModifierGanryuuJima = ____opt_274 and ____opt_274:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
    if ModifierGanryuuJima ~= nil then
        ModifierGanryuuJima:IncrementStackCount()
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.DoDamage(self)
    local ____opt_278 = self.Ability
    local BaseDmg = ____opt_278 and ____opt_278:GetSpecialValueFor("DmgPerSlash")
    local ____opt_280 = self.Ability
    local BonusDmgPerAgi = ____opt_280 and ____opt_280:GetSpecialValueFor("BonusDmgPerAgi")
    local Damage = BaseDmg + self.Caster:GetAgility() * BonusDmgPerAgi
    local ____FindUnitsInLine_293 = FindUnitsInLine
    local ____opt_282 = self.Caster
    local ____array_292 = __TS__SparseArrayNew(
        ____opt_282 and ____opt_282:GetTeam(),
        self.StartPosition,
        self.EndPosition,
        nil
    )
    local ____opt_284 = self.Ability
    __TS__SparseArrayPush(
        ____array_292,
        ____opt_284 and ____opt_284:GetSpecialValueFor("SlashRadius")
    )
    local ____opt_286 = self.Ability
    __TS__SparseArrayPush(
        ____array_292,
        ____opt_286 and ____opt_286:GetAbilityTargetTeam()
    )
    local ____opt_288 = self.Ability
    __TS__SparseArrayPush(
        ____array_292,
        ____opt_288 and ____opt_288:GetAbilityTargetType()
    )
    local ____opt_290 = self.Ability
    __TS__SparseArrayPush(
        ____array_292,
        ____opt_290 and ____opt_290:GetAbilityTargetFlags()
    )
    local Targets = ____FindUnitsInLine_293(__TS__SparseArraySpread(____array_292))
    for ____, Iterator in ipairs(Targets) do
        local ____ApplyDamage_297 = ApplyDamage
        local ____self_Caster_296 = self.Caster
        local ____opt_294 = self.Ability
        ____ApplyDamage_297({
            victim = Iterator,
            attacker = ____self_Caster_296,
            damage = Damage,
            damage_type = ____opt_294 and ____opt_294:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = self.Ability
        })
    end
    local ____opt_298 = self.Caster
    local ModifierTenganChargeCounter = ____opt_298 and ____opt_298:FindModifierByName(____exports.musashi_modifier_tengan_chargecounter.name)
    local ____opt_300 = self.Caster
    if ____opt_300 and ____opt_300:HasModifier(____exports.musashi_modifier_tengan.name) then
        local TargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
        local ____FindUnitsInLine_309 = FindUnitsInLine
        local ____array_308 = __TS__SparseArrayNew(
            self.Caster:GetTeam(),
            self.StartPosition,
            self.EndPosition,
            nil
        )
        local ____opt_302 = self.Ability
        __TS__SparseArrayPush(
            ____array_308,
            ____opt_302 and ____opt_302:GetSpecialValueFor("SlashRadius")
        )
        local ____opt_304 = self.Ability
        __TS__SparseArrayPush(
            ____array_308,
            ____opt_304 and ____opt_304:GetAbilityTargetTeam()
        )
        local ____opt_306 = self.Ability
        __TS__SparseArrayPush(
            ____array_308,
            ____opt_306 and ____opt_306:GetAbilityTargetType(),
            TargetFlags
        )
        local Targets = ____FindUnitsInLine_309(__TS__SparseArraySpread(____array_308))
        for ____, Iterator in ipairs(Targets) do
            local ____opt_310 = self.Ability
            local DmgDelay = ____opt_310 and ____opt_310:GetSpecialValueFor("DebuffDmgDelay")
            Iterator:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ganryuu_jima_debuff.name, {duration = DmgDelay})
        end
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_basic.vpcf"
    local ____opt_312 = self.Caster
    if ____opt_312 and ____opt_312:HasModifier("modifier_ascended") then
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
    local ____opt_314 = self.Caster
    local ModifierTengan = ____opt_314 and ____opt_314:FindModifierByName(____exports.musashi_modifier_tengan.name)
    self.BonusDmg = ModifierTengan.BonusDmg
    self:CreateParticle()
end
function musashi_modifier_ganryuu_jima_debuff.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    self:DoDamage()
end
function musashi_modifier_ganryuu_jima_debuff.prototype.DoDamage(self)
    local Victim = self:GetParent()
    ApplyDamage({
        victim = Victim,
        attacker = self.Caster,
        damage = self.BonusDmg,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS,
        ability = self:GetAbility()
    })
end
function musashi_modifier_ganryuu_jima_debuff.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_debuff_basic.vpcf"
    local ____opt_316 = self.Caster
    if ____opt_316 and ____opt_316:HasModifier("modifier_ascended") then
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
    local ____opt_318 = self.Caster
    if ____opt_318 ~= nil then
        ____opt_318:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_tenma_gogan.name, {duration = BuffDuration})
    end
    self:PlaySound()
end
function musashi_tenma_gogan.prototype.PlaySound(self)
    EmitGlobalSound(self.SoundVoiceline)
    local ____opt_320 = self.Caster
    if ____opt_320 ~= nil then
        ____opt_320:EmitSound(self.SoundSfx)
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
    local ____opt_322 = self.Caster
    local ChargeCounter = ____opt_322 and ____opt_322:FindModifierByName(____exports.musashi_modifier_tengan_chargecounter.name)
    local ____opt_324 = self.Caster
    local Tengan = ____opt_324 and ____opt_324:FindAbilityByName(____exports.musashi_tengan.name)
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
        local ____switch227 = stackCount
        local ____cond227 = ____switch227 == 1
        if ____cond227 then
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
    local ____opt_334 = self.Caster
    if ____opt_334 ~= nil then
        ____opt_334:AddNewModifier(self.Caster, Ability, ____exports.musashi_modifier_tenma_gogan_debuff.name, {duration = DebuffDuration})
    end
end
function musashi_modifier_tenma_gogan.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_tenma_gogan_basic.vpcf"
    local BodyParticleStr = "particles/custom/musashi/musashi_tenma_gogan_body.vpcf"
    local ____opt_336 = self.Caster
    if ____opt_336 and ____opt_336:HasModifier("modifier_ascended") then
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
    self.Damage = 0
    self.Radius = 0
end
function musashi_modifier_tengen_no_hana.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_338 = self.Ability
    self.Radius = ____opt_338 and ____opt_338:GetSpecialValueFor("Radius")
    self:CreateParticle()
    local ____opt_340 = self.Caster
    if ____opt_340 ~= nil then
        ____opt_340:EmitSound(self.SoundSfx)
    end
    local ____opt_342 = self.Ability
    local RampUpInterval = ____opt_342 and ____opt_342:GetSpecialValueFor("RampUpInterval")
    self:StartIntervalThink(RampUpInterval)
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
        local ____switch249 = stackCount
        local ____cond249 = ____switch249 == 0
        if ____cond249 then
            do
                local ____opt_344 = self.Ability
                self.Damage = ____opt_344 and ____opt_344:GetSpecialValueFor("Damage1")
                break
            end
        end
        ____cond249 = ____cond249 or ____switch249 == 1
        if ____cond249 then
            do
                local ____opt_346 = self.Ability
                self.Damage = ____opt_346 and ____opt_346:GetSpecialValueFor("Damage2")
                break
            end
        end
        ____cond249 = ____cond249 or ____switch249 == 2
        if ____cond249 then
            do
                local ____opt_348 = self.Ability
                self.Damage = ____opt_348 and ____opt_348:GetSpecialValueFor("FullDamage")
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
    local ____opt_350 = self.Caster
    if ____opt_350 ~= nil then
        ____opt_350:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    
    self:DoDamage()
    self:CreateAoeParticle()
    local ____opt_352 = self.Caster
    if ____opt_352 ~= nil then
        ____opt_352:EmitSound(self.SoundVoiceline)
    end
    local ____opt_354 = self.Ability
    if ____opt_354 ~= nil then
        ____opt_354:SetHidden(true)
    end
end
function musashi_modifier_tengen_no_hana.prototype.DoDamage(self)
    local ____FindUnitsInRadius_367 = FindUnitsInRadius
    local ____opt_356 = self.Caster
    local ____array_366 = __TS__SparseArrayNew(____opt_356 and ____opt_356:GetTeam())
    local ____opt_358 = self.Caster
    __TS__SparseArrayPush(
        ____array_366,
        ____opt_358 and ____opt_358:GetAbsOrigin(),
        nil,
        self.Radius
    )
    local ____opt_360 = self.Ability
    __TS__SparseArrayPush(
        ____array_366,
        ____opt_360 and ____opt_360:GetAbilityTargetTeam()
    )
    local ____opt_362 = self.Ability
    __TS__SparseArrayPush(
        ____array_366,
        ____opt_362 and ____opt_362:GetAbilityTargetType()
    )
    local ____opt_364 = self.Ability
    __TS__SparseArrayPush(
        ____array_366,
        ____opt_364 and ____opt_364:GetAbilityTargetFlags(),
        FIND_ANY_ORDER,
        false
    )
    local Targets = ____FindUnitsInRadius_367(__TS__SparseArraySpread(____array_366))
    for ____, Iterator in ipairs(Targets) do
        local ____ApplyDamage_372 = ApplyDamage
        local ____self_Caster_370 = self.Caster
        local ____self_Damage_371 = self.Damage
        local ____opt_368 = self.Ability
        ____ApplyDamage_372({
            victim = Iterator,
            attacker = ____self_Caster_370,
            damage = ____self_Damage_371,
            damage_type = ____opt_368 and ____opt_368:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            ability = self.Ability
        })
        local ____opt_373 = self.Ability
        local StunDuration = ____opt_373 and ____opt_373:GetSpecialValueFor("StunDuration")
        Iterator:AddNewModifier(self.Caster, self.Ability, "modifier_stunned", {duration = StunDuration})
    end
end
function musashi_modifier_tengen_no_hana.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_basic.vpcf"
    local ____opt_375 = self.Caster
    if ____opt_375 and ____opt_375:HasModifier("modifier_ascended") then
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
    local ____opt_377 = self.Caster
    if ____opt_377 and ____opt_377:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique1.vpcf"
        MarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique1.vpcf"
        if self.Caster:HasModifier(____exports.musashi_modifier_battle_continuation_active.name) then
            ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique2.vpcf"
            MarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique2.vpcf"
        end
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local MarkerParticle = ParticleManager:CreateParticle(MarkerParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ____ParticleManager_SetParticleControl_381 = ParticleManager.SetParticleControl
    local ____opt_379 = self.Caster
    ____ParticleManager_SetParticleControl_381(
        ParticleManager,
        Particle,
        0,
        ____opt_379 and ____opt_379:GetAbsOrigin()
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
        Caster:AddNewModifier(Caster, Ability, ____exports.musashi_modifier_battle_continuation_active.name, {duration = BuffDuration})
        Caster:AddNewModifier(
            Caster,
            Ability,
            ____exports.musashi_modifier_battle_continuation_cooldown.name,
            {duration = Ability and Ability:GetCooldown(1)}
        )
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
    local ____opt_388 = self.Caster
    local TengenNoHana = ____opt_388 and ____opt_388:FindAbilityByName(____exports.musashi_tengen_no_hana.name)
    local ____opt_390 = self.Caster
    --[[if ____opt_390 ~= nil then
        ____opt_390:CastAbilityImmediately(
            TengenNoHana,
            self.Caster:GetEntityIndex()
        )
    end]]
    local BuffDuration = TengenNoHana:GetSpecialValueFor("BuffDuration")
    self.Caster:AddNewModifier(self.Caster, TengenNoHana, ____exports.musashi_modifier_tengen_no_hana.name, {duration = BuffDuration})
    --TengenNoHana:SetHidden(false)
    ProjectileManager:ProjectileDodge(self.Caster)
    local ____opt_392 = self.Caster
    if ____opt_392 ~= nil then
        ____opt_392:Purge(
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
    local ____opt_396 = self.Caster
    if ____opt_396 ~= nil then
        ____opt_396:Heal(Heal, Ability)
    end
end
function musashi_modifier_battle_continuation_active.prototype.PlaySound(self)
    local ____opt_398 = self.Caster
    if ____opt_398 ~= nil then
        ____opt_398:EmitSound(self.SoundVoiceline)
    end
    local ____opt_400 = self.Caster
    if ____opt_400 ~= nil then
        ____opt_400:EmitSound(self.SoundSfx)
    end
end
function musashi_modifier_battle_continuation_active.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_battle_continuation_basic.vpcf"
    local ____opt_402 = self.Caster
    if ____opt_402 and ____opt_402:HasModifier("modifier_ascended") then
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
    self.SoundSfx = "musashi_ishana_daitenshou_sfx"
    self.CastedNiouKurikara = false
    self.MarkerPosition = Vector(0, 0, 0)
    self.StartPosition = Vector(0, 0, 0)
end
function musashi_modifier_ishana_daitenshou.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_408 = self.Ability
    self.Victim = ____opt_408 and ____opt_408:GetCursorTarget()
    local ____opt_410 = self.Caster
    self.StartPosition = ____opt_410 and ____opt_410:GetAbsOrigin()
    local ____opt_412 = self.Victim
    self.MarkerPosition = ____opt_412 and ____opt_412:GetAbsOrigin()
    local ____opt_414 = self.Caster
    local NiouKurikara = ____opt_414 and ____opt_414:FindAbilityByName(____exports.musashi_niou_kurikara.name)
    local ____opt_416 = self.Caster
    if ____opt_416 ~= nil then
        ____opt_416:CastAbilityOnPosition(
            self.MarkerPosition,
            NiouKurikara,
            self.Caster:GetEntityIndex()
        )
    end
    self:CreateParticle()
    self:StartIntervalThink(0.03)
end
function musashi_modifier_ishana_daitenshou.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_418 = self.Caster
    if ____opt_418 and ____opt_418:IsChanneling() then
        self.CastedNiouKurikara = true
    end
    local ____self_CastedNiouKurikara_422 = self.CastedNiouKurikara
    if ____self_CastedNiouKurikara_422 then
        local ____opt_420 = self.Caster
        ____self_CastedNiouKurikara_422 = not (____opt_420 and ____opt_420:IsChanneling())
    end
    if ____self_CastedNiouKurikara_422 then
        local ____opt_423 = self.Ability
        local SearchRadius = ____opt_423 and ____opt_423:GetSpecialValueFor("SearchRadius")
        local ____Entities_FindByNameWithin_427 = Entities.FindByNameWithin
        local ____opt_425 = self.Victim
        local VictimEntity = ____Entities_FindByNameWithin_427(
            Entities,
            nil,
            ____opt_425 and ____opt_425:GetName(),
            self.MarkerPosition,
            SearchRadius
        )
        if VictimEntity then
            self:StartIntervalThink(-1)
            self:IncrementStackCount()
            EmitGlobalSound(self.SoundSfx)
        else
            self:Destroy()
        end
    end
end
function musashi_modifier_ishana_daitenshou.prototype.OnStackCountChanged(self, stackCount)
    if not IsServer() then
        return
    end
    repeat
        local ____switch304 = stackCount
        local ____cond304 = ____switch304 == 0
        if ____cond304 then
            do
                local ____opt_428 = self.Caster
                if ____opt_428 ~= nil then
                    ____opt_428:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_dash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond304 = ____cond304 or ____switch304 == 1
        if ____cond304 then
            do
                local ____opt_430 = self.Caster
                if ____opt_430 ~= nil then
                    ____opt_430:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_slash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond304 = ____cond304 or ____switch304 == 2
        if ____cond304 then
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
    local ____opt_432 = self.Caster
    if ____opt_432 and ____opt_432:HasModifier("modifier_ascended") then
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
function musashi_modifier_ishana_daitenshou_dash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    local ____opt_434 = self.Caster
    self.ModifierIshanaDaitenshou = ____opt_434 and ____opt_434:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.ModifierIshanaDaitenshou.Victim
    self:StartIntervalThink(0.03)
end
function musashi_modifier_ishana_daitenshou_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_436 = self.Caster
    local CasterAbsOrigin = ____opt_436 and ____opt_436:GetAbsOrigin()
    local ____opt_438 = self.Victim
    local VictimAbsOrigin = ____opt_438 and ____opt_438:GetAbsOrigin()
    local ____opt_440 = self:GetAbility()
    local DashSpeed = ____opt_440 and ____opt_440:GetSpecialValueFor("DashSpeed")
    local Direction = (VictimAbsOrigin - CasterAbsOrigin):Normalized()
    local ____opt_442 = self.Caster
    if ____opt_442 ~= nil then
        ____opt_442:SetForwardVector(Direction)
    end
    local ____opt_444 = self.Caster
    local NewPosition = CasterAbsOrigin + (____opt_444 and ____opt_444:GetForwardVector()) * DashSpeed
    local ____opt_446 = self.Caster
    if ____opt_446 ~= nil then
        ____opt_446:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_450 = Entities.FindByNameWithin
    local ____opt_448 = self.Caster
    local Musashi = ____Entities_FindByNameWithin_450(
        Entities,
        nil,
        ____opt_448 and ____opt_448:GetName(),
        VictimAbsOrigin,
        DashSpeed
    )
    if Musashi then
        self:Destroy()
    end
end
function musashi_modifier_ishana_daitenshou_dash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_451 = self.ModifierIshanaDaitenshou
    if ____opt_451 ~= nil then
        ____opt_451:IncrementStackCount()
    end
    local ____opt_453 = self.Caster
    if ____opt_453 ~= nil then
        ____opt_453:SetForwardVector(self.Caster:GetAbsOrigin():Normalized())
    end
    local ____FindClearSpaceForUnit_458 = FindClearSpaceForUnit
    local ____self_Caster_457 = self.Caster
    local ____opt_455 = self.Caster
    ____FindClearSpaceForUnit_458(
        ____self_Caster_457,
        ____opt_455 and ____opt_455:GetAbsOrigin(),
        true
    )
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
    self.NormalSlashCount = 0
end
function musashi_modifier_ishana_daitenshou_slash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_459 = self.Caster
    self.ModifierIshanaDaitenshou = ____opt_459 and ____opt_459:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.ModifierIshanaDaitenshou.Victim
    local ____opt_461 = self.Ability
    local NormalSlashInterval = ____opt_461 and ____opt_461:GetSpecialValueFor("NormalSlashInterval")
    self:StartIntervalThink(NormalSlashInterval)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_463 = self.Ability
    local NormalSlashCount = ____opt_463 and ____opt_463:GetSpecialValueFor("NormalSlashCount")
    if self.NormalSlashCount <= NormalSlashCount then
        self:DoDamage()
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
    local ____opt_465 = self.ModifierIshanaDaitenshou
    if ____opt_465 ~= nil then
        ____opt_465:IncrementStackCount()
    end
end
function musashi_modifier_ishana_daitenshou_slash.prototype.DoDamage(self)
    local ____opt_467 = self.Ability
    local NormalSlashMaxHpPercent = (____opt_467 and ____opt_467:GetSpecialValueFor("NormalSlashMaxHpPercent")) / 100
    local ____opt_469 = self.Victim
    local Damage = (____opt_469 and ____opt_469:GetMaxHealth()) * NormalSlashMaxHpPercent
    local ____ApplyDamage_475 = ApplyDamage
    local ____self_Victim_473 = self.Victim
    local ____self_Caster_474 = self.Caster
    local ____opt_471 = self.Ability
    ____ApplyDamage_475({
        victim = ____self_Victim_473,
        attacker = ____self_Caster_474,
        damage = Damage,
        damage_type = ____opt_471 and ____opt_471:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS,
        ability = self.Ability
    })
end
function musashi_modifier_ishana_daitenshou_slash.prototype.PerformFinalSlash(self)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____opt_476 = self.Ability
        local FinalSlashDmgDelay = ____opt_476 and ____opt_476:GetSpecialValueFor("FinalSlashDmgDelay")
        self:CreateParticle()
        __TS__Await(Sleep(nil, FinalSlashDmgDelay))
        local ____opt_478 = self.Ability
        local FinalSlashMaxHpPercent = (____opt_478 and ____opt_478:GetSpecialValueFor("FinalSlashMaxHpPercent")) / 100
        local ____opt_480 = self.Ability
        local ExecuteThresholdPercent = ____opt_480 and ____opt_480:GetSpecialValueFor("ExecuteThresholdPercent")
        local ____ApplyDamage_486 = ApplyDamage
        local ____self_Victim_484 = self.Victim
        local ____self_Caster_485 = self.Caster
        local ____opt_482 = self.Ability
        ____ApplyDamage_486({
            victim = ____self_Victim_484,
            attacker = ____self_Caster_485,
            damage = FinalSlashMaxHpPercent,
            damage_type = ____opt_482 and ____opt_482:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS,
            ability = self.Ability
        })
        local ____opt_487 = self.Victim
        local CurrentHealth = ____opt_487 and ____opt_487:GetHealthPercent()
        if CurrentHealth <= ExecuteThresholdPercent then
            local ____opt_489 = self.Victim
            if ____opt_489 ~= nil then
                ____opt_489:Kill(self.Ability, self.Caster)
            end
        else
            local ____opt_491 = self.Ability
            local DebuffDuration = ____opt_491 and ____opt_491:GetSpecialValueFor("DebuffDuration")
            local ____opt_493 = self.Victim
            local CurrentHealthPercent = (____opt_493 and ____opt_493:GetHealthPercent()) / 100
            local ____opt_495 = self.Victim
            if ____opt_495 ~= nil then
                ____opt_495:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_debuff.name, {duration = DebuffDuration})
            end
            local ____opt_497 = self.Victim
            local NewHealth = (____opt_497 and ____opt_497:GetMaxHealth()) * CurrentHealthPercent
            local ____opt_499 = self.Victim
            if ____opt_499 ~= nil then
                ____opt_499:SetHealth(NewHealth)
            end
        end
    end)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_slash_basic.vpcf"
    local ____opt_501 = self.ModifierIshanaDaitenshou
    local StartPosition = ____opt_501 and ____opt_501.StartPosition
    local ____opt_503 = self.Caster
    local EndPosition = ____opt_503 and ____opt_503:GetAbsOrigin()
    local ____opt_505 = self.Caster
    if ____opt_505 and ____opt_505:HasModifier("modifier_ascended") then
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
    local ____opt_507 = self:GetAbility()
    return ____opt_507 and ____opt_507:GetSpecialValueFor("MaxHpReductionPercent")
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_509 = self:GetAbility()
    return ____opt_509 and ____opt_509:GetSpecialValueFor("ExtraIncomingDmgPercent")
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
        local ____opt_511 = self.Niou
        if ____opt_511 ~= nil then
            ____opt_511:ForceKill(false)
        end
        __TS__Await(Sleep(nil, delay))
        local ____opt_513 = self.Niou
        if ____opt_513 ~= nil then
            ____opt_513:Destroy()
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
