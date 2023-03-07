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
function musashi_dai_go_sei.prototype.OnSpellStart(self)
    self.Caster = self:GetCaster()
    local Victim = self:GetCursorTarget()
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    local StunDuration = self:GetSpecialValueFor("StunDuration")
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_dai_go_sei.name, {duration = BuffDuration})
    self.Caster:SetAbsOrigin(Victim and Victim:GetAbsOrigin())
    FindClearSpaceForUnit(
        self.Caster,
        self.Caster:GetAbsOrigin(),
        true
    )
    Victim:AddNewModifier(self.Caster, self, "modifier_stunned", {duration = StunDuration})
    self:PlaySound()
end
function musashi_dai_go_sei.prototype.PlaySound(self)
    local ____opt_2 = self.Caster
    if ____opt_2 ~= nil then
        ____opt_2:EmitSound(self.SoundVoiceline)
    end
    local ____opt_4 = self.Caster
    if ____opt_4 ~= nil then
        ____opt_4:EmitSound(self.SoundSfx)
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
    local ____opt_6 = self.Ability
    self.BonusDmg = ____opt_6 and ____opt_6:GetSpecialValueFor("BonusDmg")
    local ____opt_8 = self.Ability
    self.BonusAtkSpeed = ____opt_8 and ____opt_8:GetSpecialValueFor("BonusAtkSpeed")
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
    local ____temp_12 = event.attacker == self.Caster and event.target:IsRealHero()
    if ____temp_12 then
        local ____opt_10 = self.Caster
        ____temp_12 = ____opt_10 and ____opt_10:HasModifier(____exports.musashi_modifier_tengan.name)
    end
    if ____temp_12 then
        self:IncrementStackCount()
        local ____opt_13 = self.Ability
        local HitsRequired = ____opt_13 and ____opt_13:GetSpecialValueFor("HitsRequired")
        if self:GetStackCount() == HitsRequired then
            self:SetStackCount(0)
            local ____ApplyDamage_20 = ApplyDamage
            local ____event_target_18 = event.target
            local ____self_Caster_19 = self.Caster
            local ____event_damage_17 = event.damage
            local ____opt_15 = self.Ability
            ____ApplyDamage_20({
                victim = ____event_target_18,
                attacker = ____self_Caster_19,
                damage = ____event_damage_17 * (____opt_15 and ____opt_15:GetSpecialValueFor("CriticalDmg")),
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
    local ____opt_21 = self.Caster
    if ____opt_21 and ____opt_21:HasModifier("modifier_ascended") then
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
    local ____opt_23 = self.Caster
    if ____opt_23 ~= nil then
        ____opt_23:EmitSound(self.SoundVoiceline)
    end
    local ____opt_25 = self.Caster
    if ____opt_25 ~= nil then
        ____opt_25:EmitSound(self.SoundSfx)
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
    local ____opt_27 = self.Caster
    self.Direction = ____opt_27 and ____opt_27:GetForwardVector():__unm()
    local ____opt_29 = self.Caster
    self.StartPosition = ____opt_29 and ____opt_29:GetAbsOrigin()
    local ____opt_31 = self.Ability
    self.DashRange = ____opt_31 and ____opt_31:GetSpecialValueFor("DashRange")
    self:CreateParticle()
    self:StartIntervalThink(0.03)
end
function musashi_modifier_accel_turn.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_33 = self.Caster
    if ____opt_33 ~= nil then
        ____opt_33:SetForwardVector(self.Direction)
    end
    local ____opt_35 = self.Caster
    local CurrentOrigin = ____opt_35 and ____opt_35:GetAbsOrigin()
    local ____opt_37 = self.Ability
    local DashSpeed = ____opt_37 and ____opt_37:GetSpecialValueFor("DashSpeed")
    local ____opt_39 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_39 and ____opt_39:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_41 = self.Caster
    if ____opt_41 ~= nil then
        ____opt_41:SetAbsOrigin(NewPosition)
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
    local ____opt_43 = self.Caster
    if ____opt_43 ~= nil then
        ____opt_43:SetForwardVector(self.Caster:GetAbsOrigin():Normalized())
    end
    local ____FindClearSpaceForUnit_48 = FindClearSpaceForUnit
    local ____self_Caster_47 = self.Caster
    local ____opt_45 = self.Caster
    ____FindClearSpaceForUnit_48(
        ____self_Caster_47,
        ____opt_45 and ____opt_45:GetAbsOrigin(),
        true
    )
end
function musashi_modifier_accel_turn.prototype.DoDamage(self)
    local ____opt_49 = self.Ability
    local DashWidth = ____opt_49 and ____opt_49:GetSpecialValueFor("DashWidth")
    local ____FindUnitsInLine_62 = FindUnitsInLine
    local ____opt_51 = self.Caster
    local ____array_61 = __TS__SparseArrayNew(
        ____opt_51 and ____opt_51:GetTeam(),
        self.StartPosition
    )
    local ____opt_53 = self.Caster
    __TS__SparseArrayPush(
        ____array_61,
        ____opt_53 and ____opt_53:GetAbsOrigin(),
        nil,
        DashWidth
    )
    local ____opt_55 = self.Ability
    __TS__SparseArrayPush(
        ____array_61,
        ____opt_55 and ____opt_55:GetAbilityTargetTeam()
    )
    local ____opt_57 = self.Ability
    __TS__SparseArrayPush(
        ____array_61,
        ____opt_57 and ____opt_57:GetAbilityTargetType()
    )
    local ____opt_59 = self.Ability
    __TS__SparseArrayPush(
        ____array_61,
        ____opt_59 and ____opt_59:GetAbilityTargetFlags()
    )
    local Targets = ____FindUnitsInLine_62(__TS__SparseArraySpread(____array_61))
    for ____, Iterator in ipairs(Targets) do
        local ____ApplyDamage_69 = ApplyDamage
        local ____self_Caster_67 = self.Caster
        local ____opt_63 = self.Ability
        local ____temp_68 = ____opt_63 and ____opt_63:GetSpecialValueFor("Damage")
        local ____opt_65 = self.Ability
        ____ApplyDamage_69({
            victim = Iterator,
            attacker = ____self_Caster_67,
            damage = ____temp_68,
            damage_type = ____opt_65 and ____opt_65:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = self.Ability
        })
    end
end
function musashi_modifier_accel_turn.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_accel_turn_basic.vpcf"
    local ____opt_70 = self.Caster
    if ____opt_70 and ____opt_70:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_accel_turn_unique.vpcf"
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ParticleSpeed = self.Direction * 2000
    local ____ParticleManager_SetParticleControl_74 = ParticleManager.SetParticleControl
    local ____opt_72 = self.Caster
    ____ParticleManager_SetParticleControl_74(
        ParticleManager,
        Particle,
        0,
        ____opt_72 and ____opt_72:GetAbsOrigin()
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
    local ____opt_75 = self.Niou
    if ____opt_75 ~= nil then
        ____opt_75:FaceTowards(self.TargetAoe)
    end
    return true
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseInterrupted(self)
    local ____opt_77 = self.NiouSkill
    if ____opt_77 ~= nil then
        ____opt_77:DestroyNiou(0)
    end
end
function musashi_niou_kurikara.prototype.OnSpellStart(self)
    local ____opt_79 = self.Niou
    if ____opt_79 ~= nil then
        ____opt_79:StartGestureWithPlaybackRate(ACT_DOTA_CHANNEL_ABILITY_1, 1.1)
    end
    self.SlashCount = self.SlashCount + 1
    self.Interval = 0.5
    local ____opt_81 = self.Caster
    self.DmgReducBuff = ____opt_81 and ____opt_81:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_niou_kurikara_channeling_buff.name, {undefined = undefined})
    local ____opt_83 = self.Caster
    if not (____opt_83 and ____opt_83:HasModifier(____exports.musashi_modifier_ishana_daitenshou.name)) then
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
    local ____opt_85 = self.DmgReducBuff
    if ____opt_85 ~= nil then
        ____opt_85:Destroy()
    end
    if interrupted then
        local ____opt_87 = self.NiouSkill
        if ____opt_87 ~= nil then
            ____opt_87:DestroyNiou(0)
        end
    else
        local ____opt_89 = self.NiouSkill
        if ____opt_89 ~= nil then
            ____opt_89:DestroyNiou(1)
        end
        local BuffDuration = self:GetSpecialValueFor("BuffDuration")
        local ____opt_91 = self.Caster
        if ____opt_91 ~= nil then
            ____opt_91:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_niou_kurikara_postchannel_buff.name, {duration = BuffDuration})
        end
    end
end
function musashi_niou_kurikara.prototype.DoDamage(self)
    local DmgType = self:GetAbilityDamageType()
    local TargetFlags = self:GetAbilityTargetFlags()
    local DmgFlag = DOTA_DAMAGE_FLAG_NONE
    local Targets
    local ____opt_93 = self.Caster
    local ____temp_97 = ____opt_93 and ____opt_93:HasModifier(____exports.musashi_modifier_tenma_gogan.name)
    if not ____temp_97 then
        local ____opt_95 = self.Caster
        ____temp_97 = ____opt_95 and ____opt_95:HasModifier(____exports.musashi_modifier_ishana_daitenshou.name)
    end
    if ____temp_97 then
        DmgType = DAMAGE_TYPE_PURE
        DmgFlag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS
        TargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    end
    local ____FindUnitsInRadius_100 = FindUnitsInRadius
    local ____opt_98 = self.Caster
    Targets = ____FindUnitsInRadius_100(
        ____opt_98 and ____opt_98:GetTeam(),
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
    local ____opt_101 = self.Caster
    local ModifierTengan = ____opt_101 and ____opt_101:FindModifierByName(____exports.musashi_modifier_tengan.name)
    if self.SlashCount == 5 and ModifierTengan then
        DmgType = DAMAGE_TYPE_PURE
        DmgFlag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS
        TargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
        local ____FindUnitsInRadius_105 = FindUnitsInRadius
        local ____opt_103 = self.Caster
        Targets = ____FindUnitsInRadius_105(
            ____opt_103 and ____opt_103:GetTeam(),
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
        local ____opt_106 = self.Caster
        local ModifierTenmaGogan = ____opt_106 and ____opt_106:FindModifierByName(____exports.musashi_modifier_tenma_gogan.name)
        if ModifierTenmaGogan ~= nil then
            ModifierTenmaGogan:Destroy()
        end
        ModifierTengan:Destroy()
    end
end
function musashi_niou_kurikara.prototype.ApplyElementalDebuffs(self, Target)
    local ____opt_110 = self.Caster
    local GorinNoSho = ____opt_110 and ____opt_110:FindModifierByName("musashi_attribute_gorin_no_sho")
    if not GorinNoSho then
        return
    end
    local AttributeAbility = GorinNoSho:GetAbility()
    repeat
        local ____switch62 = self.SlashCount
        local ____cond62 = ____switch62 == 1
        if ____cond62 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("DebuffDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_earth_debuff.name, {duration = DebuffDuration})
                break
            end
        end
        ____cond62 = ____cond62 or ____switch62 == 2
        if ____cond62 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("DebuffDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_water_debuff.name, {duration = DebuffDuration})
                break
            end
        end
        ____cond62 = ____cond62 or ____switch62 == 3
        if ____cond62 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("FireBurnDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_fire_debuff.name, {duration = DebuffDuration})
                break
            end
        end
        ____cond62 = ____cond62 or ____switch62 == 4
        if ____cond62 then
            do
                local DebuffDuration = AttributeAbility and AttributeAbility:GetSpecialValueFor("WindDuration")
                Target:AddNewModifier(self.Caster, AttributeAbility, ____exports.musashi_modifier_wind_debuff.name, {duration = DebuffDuration})
                break
            end
        end
    until true
end
function musashi_niou_kurikara.prototype.CreateParticle(self)
    local ____opt_120 = self.Caster
    if ____opt_120 and ____opt_120:HasModifier("modifier_ascended") then
        local AoeParticleStr = ""
        local CrackParticleStr = ""
        repeat
            local ____switch69 = self.SlashCount
            local ____cond69 = ____switch69 == 1
            if ____cond69 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond69 = ____cond69 or ____switch69 == 2
            if ____cond69 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water_crack.vpcf"
                    break
                end
            end
            ____cond69 = ____cond69 or ____switch69 == 3
            if ____cond69 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire_crack.vpcf"
                    break
                end
            end
            ____cond69 = ____cond69 or ____switch69 == 4
            if ____cond69 then
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
    local ____opt_122 = self.NiouSkill
    if ____opt_122 ~= nil then
        ____opt_122:SetLevel(self:GetLevel())
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
    local ____opt_124 = self:GetAbility()
    return ____opt_124 and ____opt_124:GetSpecialValueFor("EarthSlow")
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
    local ____opt_128 = self.Ability
    local TargetPoint = ____opt_128 and ____opt_128:GetCursorPosition()
    local ____opt_130 = self.Victim
    local CurrentOrigin = ____opt_130 and ____opt_130:GetAbsOrigin()
    local PushSpeed = Ability and Ability:GetSpecialValueFor("PushSpeed")
    local ForwardVector = (TargetPoint - CurrentOrigin):Normalized()
    local ____opt_134 = self.Victim
    if ____opt_134 ~= nil then
        ____opt_134:SetForwardVector(ForwardVector)
    end
    local ____opt_136 = self.Victim
    local NewPosition = CurrentOrigin + (____opt_136 and ____opt_136:GetForwardVector()) * PushSpeed
    local ____opt_138 = self.Victim
    if ____opt_138 ~= nil then
        ____opt_138:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_142 = Entities.FindByNameWithin
    local ____opt_140 = self.Victim
    local VictimEntity = ____Entities_FindByNameWithin_142(
        Entities,
        nil,
        ____opt_140 and ____opt_140:GetName(),
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
    local ____opt_143 = self.Victim
    if ____opt_143 ~= nil then
        ____opt_143:SetForwardVector(self.Victim:GetAbsOrigin():Normalized())
    end
    local ____FindClearSpaceForUnit_148 = FindClearSpaceForUnit
    local ____self_Victim_147 = self.Victim
    local ____opt_145 = self.Victim
    ____FindClearSpaceForUnit_148(
        ____self_Victim_147,
        ____opt_145 and ____opt_145:GetAbsOrigin(),
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
    local ____opt_149 = self.Ability
    local DebuffDuration = ____opt_149 and ____opt_149:GetSpecialValueFor("DebuffDuration")
    self.Victim:AddNewModifier(self.Caster, self.Ability, "modifier_stunned", {duration = DebuffDuration})
    self:StartIntervalThink(DebuffDuration)
end
function musashi_modifier_fire_debuff.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____ApplyDamage_155 = ApplyDamage
    local ____self_Victim_153 = self.Victim
    local ____self_Caster_154 = self.Caster
    local ____opt_151 = self.Ability
    ____ApplyDamage_155({
        victim = ____self_Victim_153,
        attacker = ____self_Caster_154,
        damage = ____opt_151 and ____opt_151:GetSpecialValueFor("FireBurnDmgPerSec"),
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
    local ____opt_156 = self:GetAbility()
    return ____opt_156 and ____opt_156:GetSpecialValueFor("DmgReducWhileChannel")
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
    local ____opt_158 = self:GetAbility()
    return ____opt_158 and ____opt_158:GetSpecialValueFor("DmgReducFinishChannel")
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
            local ComboStatsFulfilled = CheckComboStatsFulfilled(self.Caster)
            if ComboStatsFulfilled and not self.Caster:HasModifier(____exports.musashi_modifier_ishana_daitenshou_cooldown.name) then
                local SkillsSequence = {____exports.musashi_tengan.name, ____exports.musashi_dai_go_sei.name}
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
    end
    return false
end
function musashi_tengan.prototype.OnSpellStart(self)
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    local RechargeTime = self:GetSpecialValueFor("RechargeTime")
    local ____opt_160 = self.Caster
    if ____opt_160 ~= nil then
        ____opt_160:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_tengan.name, {duration = BuffDuration})
    end
    local ____opt_162 = self.ChargeCounter
    if ____opt_162 ~= nil then
        local ____opt_163 = self.ChargeCounter
        local ____temp_165 = ____opt_163 and ____opt_163.RechargeTimer
        ____temp_165[#____temp_165 + 1] = RechargeTime
    end
    local ____opt_167 = self.ChargeCounter
    local ____temp_171 = (____opt_167 and ____opt_167:GetStackCount()) == self:GetSpecialValueFor("MaxCharges")
    if ____temp_171 then
        local ____opt_169 = self.Caster
        ____temp_171 = ____opt_169 and ____opt_169:HasModifier("musashi_attribute_improve_tengan")
    end
    if ____temp_171 then
        InitSkillSlotChecker(self.Caster, ____exports.musashi_tengan.name, ____exports.musashi_tenma_gogan.name, 5)
    end
    local ____opt_172 = self.ChargeCounter
    if ____opt_172 ~= nil then
        ____opt_172:DecrementStackCount()
    end
    self:PlaySound()
end
function musashi_tengan.prototype.PlaySound(self)
    local ____opt_174 = self.Caster
    if ____opt_174 ~= nil then
        ____opt_174:EmitSound(self.SoundVoiceline)
    end
    local ____opt_176 = self.Caster
    if ____opt_176 ~= nil then
        ____opt_176:EmitSound(self.SoundSfx)
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
    local ____opt_178 = self.Ability
    local MaxCharges = ____opt_178 and ____opt_178:GetSpecialValueFor("MaxCharges")
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
        local ____opt_180 = self.Ability
        if ____opt_180 ~= nil then
            ____opt_180:StartCooldown(self.RechargeTimer[1] or 0)
        end
    else
        local ____opt_182 = self.Ability
        if ____opt_182 ~= nil then
            ____opt_182:EndCooldown()
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
            local ____self_RechargeTimer_184, ____temp_185 = self.RechargeTimer, i + 1
            ____self_RechargeTimer_184[____temp_185] = ____self_RechargeTimer_184[____temp_185] - 1
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
    local ____opt_190 = self.Caster
    if ____opt_190 and ____opt_190:HasModifier("modifier_ascended") then
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
    local ____opt_192 = self.Caster
    if ____opt_192 ~= nil then
        ____opt_192:EmitSound(self.SoundVoiceline)
    end
    local ____opt_194 = self.Caster
    if ____opt_194 ~= nil then
        ____opt_194:EmitSound(self.SoundSfx)
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
    local ____opt_196 = self.Caster
    if ____opt_196 and ____opt_196:HasModifier("modifier_ascended") then
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
        local ____switch164 = stackCount
        local ____cond164 = ____switch164 == 0
        if ____cond164 then
            do
                Position = self.DashPosition
                local ____opt_198 = self.Caster
                local DashBuff = ____opt_198 and ____opt_198:AddNewModifier(self.Caster, self.GanryuuJima, ____exports.musashi_modifier_ganryuu_jima_dash.name, {undefined = undefined})
                DashBuff.TargetPoint = Position
                local ____DashBuff_TargetPoint_202 = DashBuff.TargetPoint
                local ____opt_200 = self.Caster
                ____DashBuff_TargetPoint_202.z = ____opt_200 and ____opt_200:GetAbsOrigin().z
                local ____DashBuff_TargetPoint_205 = DashBuff.TargetPoint
                local ____opt_203 = self.Caster
                DashBuff.NormalizedTargetPoint = (____DashBuff_TargetPoint_205 - (____opt_203 and ____opt_203:GetAbsOrigin())):Normalized()
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
        local ____opt_206 = self.Caster
        local SlashBuff = ____opt_206 and ____opt_206:AddNewModifier(self.Caster, self.GanryuuJima, ____exports.musashi_modifier_ganryuu_jima_slash.name, {undefined = undefined})
        SlashBuff.TargetPoint = Position
        SlashBuff:StartIntervalThink(0.03)
    end
end
function musashi_modifier_ganryuu_jima.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_208 = self.Caster
    if ____opt_208 ~= nil then
        ____opt_208:SetForwardVector(self.Caster:GetAbsOrigin():Normalized())
    end
    local ____opt_210 = self.Caster
    if ____opt_210 ~= nil then
        ____opt_210:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    local ____FindClearSpaceForUnit_215 = FindClearSpaceForUnit
    local ____self_Caster_214 = self.Caster
    local ____opt_212 = self.Caster
    ____FindClearSpaceForUnit_215(
        ____self_Caster_214,
        ____opt_212 and ____opt_212:GetAbsOrigin(),
        true
    )
    local ____opt_216 = self.Caster
    local ModifierTengan = ____opt_216 and ____opt_216:FindModifierByName(____exports.musashi_modifier_tengan.name)
    if ModifierTengan ~= nil then
        ModifierTengan:Destroy()
    end
    local ____opt_220 = self.Caster
    local ModifierTenmaGogan = ____opt_220 and ____opt_220:FindModifierByName(____exports.musashi_modifier_tenma_gogan.name)
    if ModifierTenmaGogan then
        local ____opt_222 = self.GanryuuJima
        if ____opt_222 ~= nil then
            ____opt_222:EndCooldown()
        end
        local ____opt_224 = self.Caster
        if ____opt_224 ~= nil then
            local ____opt_224_GiveMana_227 = ____opt_224.GiveMana
            local ____opt_225 = self.GanryuuJima
            ____opt_224_GiveMana_227(
                ____opt_224,
                ____opt_225 and ____opt_225:GetManaCost(-1)
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
    local ____opt_231 = self.Ability
    self.SlashRange = ____opt_231 and ____opt_231:GetSpecialValueFor("SlashRange")
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_233 = self.Caster
    if ____opt_233 ~= nil then
        ____opt_233:SetForwardVector(self.NormalizedTargetPoint)
    end
    local ____opt_235 = self.Caster
    local CurrentOrigin = ____opt_235 and ____opt_235:GetAbsOrigin()
    local ____opt_237 = self.Ability
    local DashSpeed = ____opt_237 and ____opt_237:GetSpecialValueFor("DashSpeed")
    local ____opt_239 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_239 and ____opt_239:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_241 = self.Caster
    if ____opt_241 ~= nil then
        ____opt_241:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_245 = Entities.FindByNameWithin
    local ____opt_243 = self.Caster
    local Musashi = ____Entities_FindByNameWithin_245(
        Entities,
        nil,
        ____opt_243 and ____opt_243:GetName(),
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
    local ____opt_246 = self.Caster
    local ModifierGanryuuJima = ____opt_246 and ____opt_246:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
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
    local ____opt_250 = self.Caster
    self.StartPosition = ____opt_250 and ____opt_250:GetAbsOrigin()
    local ____opt_252 = self.Ability
    self.SlashRange = ____opt_252 and ____opt_252:GetSpecialValueFor("SlashRange")
    local ____opt_254 = self.Caster
    if ____opt_254 ~= nil then
        ____opt_254:EmitSound(self.SoundSfx)
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_256 = self.Caster
    if ____opt_256 ~= nil then
        ____opt_256:SetForwardVector(self.TargetPoint)
    end
    local ____opt_258 = self.Caster
    local CurrentOrigin = ____opt_258 and ____opt_258:GetAbsOrigin()
    local ____opt_260 = self.Ability
    local DashSpeed = ____opt_260 and ____opt_260:GetSpecialValueFor("DashSpeed")
    local ____opt_262 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_262 and ____opt_262:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_264 = self.Caster
    if ____opt_264 ~= nil then
        ____opt_264:SetAbsOrigin(NewPosition)
    end
    if self.UnitsTravelled >= self.SlashRange then
        self:Destroy()
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_266 = self.Caster
    self.EndPosition = ____opt_266 and ____opt_266:GetAbsOrigin()
    self:DoDamage()
    self:CreateParticle()
    local ____opt_268 = self.Caster
    local ModifierGanryuuJima = ____opt_268 and ____opt_268:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
    if ModifierGanryuuJima ~= nil then
        ModifierGanryuuJima:IncrementStackCount()
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.DoDamage(self)
    local ____opt_272 = self.Ability
    local BaseDmg = ____opt_272 and ____opt_272:GetSpecialValueFor("DmgPerSlash")
    local ____opt_274 = self.Ability
    local BonusDmgPerAgi = ____opt_274 and ____opt_274:GetSpecialValueFor("BonusDmgPerAgi")
    local Damage = BaseDmg + self.Caster:GetAgility() * BonusDmgPerAgi
    local ____FindUnitsInLine_287 = FindUnitsInLine
    local ____opt_276 = self.Caster
    local ____array_286 = __TS__SparseArrayNew(
        ____opt_276 and ____opt_276:GetTeam(),
        self.StartPosition,
        self.EndPosition,
        nil
    )
    local ____opt_278 = self.Ability
    __TS__SparseArrayPush(
        ____array_286,
        ____opt_278 and ____opt_278:GetSpecialValueFor("SlashRadius")
    )
    local ____opt_280 = self.Ability
    __TS__SparseArrayPush(
        ____array_286,
        ____opt_280 and ____opt_280:GetAbilityTargetTeam()
    )
    local ____opt_282 = self.Ability
    __TS__SparseArrayPush(
        ____array_286,
        ____opt_282 and ____opt_282:GetAbilityTargetType()
    )
    local ____opt_284 = self.Ability
    __TS__SparseArrayPush(
        ____array_286,
        ____opt_284 and ____opt_284:GetAbilityTargetFlags()
    )
    local Targets = ____FindUnitsInLine_287(__TS__SparseArraySpread(____array_286))
    for ____, Iterator in ipairs(Targets) do
        local ____ApplyDamage_291 = ApplyDamage
        local ____self_Caster_290 = self.Caster
        local ____opt_288 = self.Ability
        ____ApplyDamage_291({
            victim = Iterator,
            attacker = ____self_Caster_290,
            damage = Damage,
            damage_type = ____opt_288 and ____opt_288:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = self.Ability
        })
    end
    local ____opt_292 = self.Caster
    local ModifierTenganChargeCounter = ____opt_292 and ____opt_292:FindModifierByName(____exports.musashi_modifier_tengan_chargecounter.name)
    local ____opt_294 = self.Caster
    if ____opt_294 and ____opt_294:HasModifier(____exports.musashi_modifier_tengan.name) then
        local TargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
        local ____FindUnitsInLine_303 = FindUnitsInLine
        local ____array_302 = __TS__SparseArrayNew(
            self.Caster:GetTeam(),
            self.StartPosition,
            self.EndPosition,
            nil
        )
        local ____opt_296 = self.Ability
        __TS__SparseArrayPush(
            ____array_302,
            ____opt_296 and ____opt_296:GetSpecialValueFor("SlashRadius")
        )
        local ____opt_298 = self.Ability
        __TS__SparseArrayPush(
            ____array_302,
            ____opt_298 and ____opt_298:GetAbilityTargetTeam()
        )
        local ____opt_300 = self.Ability
        __TS__SparseArrayPush(
            ____array_302,
            ____opt_300 and ____opt_300:GetAbilityTargetType(),
            TargetFlags
        )
        local Targets = ____FindUnitsInLine_303(__TS__SparseArraySpread(____array_302))
        for ____, Iterator in ipairs(Targets) do
            local ____opt_304 = self.Ability
            local DmgDelay = ____opt_304 and ____opt_304:GetSpecialValueFor("DebuffDmgDelay")
            Iterator:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ganryuu_jima_debuff.name, {duration = DmgDelay})
        end
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_basic.vpcf"
    local ____opt_306 = self.Caster
    if ____opt_306 and ____opt_306:HasModifier("modifier_ascended") then
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
    local ____opt_308 = self.Caster
    local ModifierTengan = ____opt_308 and ____opt_308:FindModifierByName(____exports.musashi_modifier_tengan.name)
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
    local ____opt_310 = self.Caster
    if ____opt_310 and ____opt_310:HasModifier("modifier_ascended") then
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
    local ____opt_312 = self.Caster
    if ____opt_312 ~= nil then
        ____opt_312:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_tenma_gogan.name, {duration = BuffDuration})
    end
    self:PlaySound()
end
function musashi_tenma_gogan.prototype.PlaySound(self)
    EmitGlobalSound(self.SoundVoiceline)
    local ____opt_314 = self.Caster
    if ____opt_314 ~= nil then
        ____opt_314:EmitSound(self.SoundSfx)
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
    local ____opt_316 = self.Caster
    local ChargeCounter = ____opt_316 and ____opt_316:FindModifierByName(____exports.musashi_modifier_tengan_chargecounter.name)
    local ____opt_318 = self.Caster
    local Tengan = ____opt_318 and ____opt_318:FindAbilityByName(____exports.musashi_tengan.name)
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
        local ____switch226 = stackCount
        local ____cond226 = ____switch226 == 1
        if ____cond226 then
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
    local ____opt_328 = self.Caster
    if ____opt_328 ~= nil then
        ____opt_328:AddNewModifier(self.Caster, Ability, ____exports.musashi_modifier_tenma_gogan_debuff.name, {duration = DebuffDuration})
    end
end
function musashi_modifier_tenma_gogan.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_tenma_gogan_basic.vpcf"
    local BodyParticleStr = "particles/custom/musashi/musashi_tenma_gogan_body.vpcf"
    local ____opt_330 = self.Caster
    if ____opt_330 and ____opt_330:HasModifier("modifier_ascended") then
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
    local ____opt_332 = self.Ability
    self.Radius = ____opt_332 and ____opt_332:GetSpecialValueFor("Radius")
    self:CreateParticle()
    local ____opt_334 = self.Caster
    if ____opt_334 ~= nil then
        ____opt_334:EmitSound(self.SoundSfx)
    end
    local ____opt_336 = self.Ability
    local RampUpInterval = ____opt_336 and ____opt_336:GetSpecialValueFor("RampUpInterval")
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
        local ____switch248 = stackCount
        local ____cond248 = ____switch248 == 0
        if ____cond248 then
            do
                local ____opt_338 = self.Ability
                self.Damage = ____opt_338 and ____opt_338:GetSpecialValueFor("Damage1")
                break
            end
        end
        ____cond248 = ____cond248 or ____switch248 == 1
        if ____cond248 then
            do
                local ____opt_340 = self.Ability
                self.Damage = ____opt_340 and ____opt_340:GetSpecialValueFor("Damage2")
                break
            end
        end
        ____cond248 = ____cond248 or ____switch248 == 2
        if ____cond248 then
            do
                local ____opt_342 = self.Ability
                self.Damage = ____opt_342 and ____opt_342:GetSpecialValueFor("FullDamage")
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
    local ____opt_344 = self.Caster
    if ____opt_344 ~= nil then
        ____opt_344:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    self:DoDamage()
    self:CreateAoeParticle()
    local ____opt_346 = self.Caster
    if ____opt_346 ~= nil then
        ____opt_346:EmitSound(self.SoundVoiceline)
    end
    local ____opt_348 = self.Ability
    if ____opt_348 ~= nil then
        ____opt_348:SetHidden(true)
    end
end
function musashi_modifier_tengen_no_hana.prototype.DoDamage(self)
    local ____FindUnitsInRadius_361 = FindUnitsInRadius
    local ____opt_350 = self.Caster
    local ____array_360 = __TS__SparseArrayNew(____opt_350 and ____opt_350:GetTeam())
    local ____opt_352 = self.Caster
    __TS__SparseArrayPush(
        ____array_360,
        ____opt_352 and ____opt_352:GetAbsOrigin(),
        nil,
        self.Radius
    )
    local ____opt_354 = self.Ability
    __TS__SparseArrayPush(
        ____array_360,
        ____opt_354 and ____opt_354:GetAbilityTargetTeam()
    )
    local ____opt_356 = self.Ability
    __TS__SparseArrayPush(
        ____array_360,
        ____opt_356 and ____opt_356:GetAbilityTargetType()
    )
    local ____opt_358 = self.Ability
    __TS__SparseArrayPush(
        ____array_360,
        ____opt_358 and ____opt_358:GetAbilityTargetFlags(),
        FIND_ANY_ORDER,
        false
    )
    local Targets = ____FindUnitsInRadius_361(__TS__SparseArraySpread(____array_360))
    for ____, Iterator in ipairs(Targets) do
        local ____ApplyDamage_366 = ApplyDamage
        local ____self_Caster_364 = self.Caster
        local ____self_Damage_365 = self.Damage
        local ____opt_362 = self.Ability
        ____ApplyDamage_366({
            victim = Iterator,
            attacker = ____self_Caster_364,
            damage = ____self_Damage_365,
            damage_type = ____opt_362 and ____opt_362:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            ability = self.Ability
        })
        local ____opt_367 = self.Ability
        local StunDuration = ____opt_367 and ____opt_367:GetSpecialValueFor("StunDuration")
        Iterator:AddNewModifier(self.Caster, self.Ability, "modifier_stunned", {duration = StunDuration})
    end
end
function musashi_modifier_tengen_no_hana.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_basic.vpcf"
    local ____opt_369 = self.Caster
    if ____opt_369 and ____opt_369:HasModifier("modifier_ascended") then
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
    local ____opt_371 = self.Caster
    if ____opt_371 and ____opt_371:HasModifier("modifier_ascended") then
        ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique1.vpcf"
        MarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique1.vpcf"
        if self.Caster:HasModifier(____exports.musashi_modifier_battle_continuation_active.name) then
            ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique2.vpcf"
            MarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique2.vpcf"
        end
    end
    local Particle = ParticleManager:CreateParticle(ParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local MarkerParticle = ParticleManager:CreateParticle(MarkerParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ____ParticleManager_SetParticleControl_375 = ParticleManager.SetParticleControl
    local ____opt_373 = self.Caster
    ____ParticleManager_SetParticleControl_375(
        ParticleManager,
        Particle,
        0,
        ____opt_373 and ____opt_373:GetAbsOrigin()
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
    local ____opt_382 = self.Caster
    local TengenNoHana = ____opt_382 and ____opt_382:FindAbilityByName(____exports.musashi_tengen_no_hana.name)
    local ____opt_384 = self.Caster
    if ____opt_384 ~= nil then
        ____opt_384:CastAbilityImmediately(
            TengenNoHana,
            self.Caster:GetEntityIndex()
        )
    end
    TengenNoHana:SetHidden(false)
    ProjectileManager:ProjectileDodge(self.Caster)
    local ____opt_386 = self.Caster
    if ____opt_386 ~= nil then
        ____opt_386:Purge(
            false,
            true,
            false,
            true,
            true
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
    local ____opt_390 = self.Caster
    if ____opt_390 ~= nil then
        ____opt_390:Heal(Heal, Ability)
    end
end
function musashi_modifier_battle_continuation_active.prototype.PlaySound(self)
    local ____opt_392 = self.Caster
    if ____opt_392 ~= nil then
        ____opt_392:EmitSound(self.SoundVoiceline)
    end
    local ____opt_394 = self.Caster
    if ____opt_394 ~= nil then
        ____opt_394:EmitSound(self.SoundSfx)
    end
end
function musashi_modifier_battle_continuation_active.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_battle_continuation_basic.vpcf"
    local ____opt_396 = self.Caster
    if ____opt_396 and ____opt_396:HasModifier("modifier_ascended") then
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
    local ____opt_402 = self.Ability
    self.Victim = ____opt_402 and ____opt_402:GetCursorTarget()
    local ____opt_404 = self.Caster
    self.StartPosition = ____opt_404 and ____opt_404:GetAbsOrigin()
    local ____opt_406 = self.Victim
    self.MarkerPosition = ____opt_406 and ____opt_406:GetAbsOrigin()
    local ____opt_408 = self.Caster
    local NiouKurikara = ____opt_408 and ____opt_408:FindAbilityByName(____exports.musashi_niou_kurikara.name)
    local ____opt_410 = self.Caster
    if ____opt_410 ~= nil then
        ____opt_410:CastAbilityOnPosition(
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
    local ____opt_412 = self.Caster
    if ____opt_412 and ____opt_412:IsChanneling() then
        self.CastedNiouKurikara = true
    end
    local ____self_CastedNiouKurikara_416 = self.CastedNiouKurikara
    if ____self_CastedNiouKurikara_416 then
        local ____opt_414 = self.Caster
        ____self_CastedNiouKurikara_416 = not (____opt_414 and ____opt_414:IsChanneling())
    end
    if ____self_CastedNiouKurikara_416 then
        local ____opt_417 = self.Ability
        local SearchRadius = ____opt_417 and ____opt_417:GetSpecialValueFor("SearchRadius")
        local ____Entities_FindByNameWithin_421 = Entities.FindByNameWithin
        local ____opt_419 = self.Victim
        local VictimEntity = ____Entities_FindByNameWithin_421(
            Entities,
            nil,
            ____opt_419 and ____opt_419:GetName(),
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
        local ____switch303 = stackCount
        local ____cond303 = ____switch303 == 0
        if ____cond303 then
            do
                local ____opt_422 = self.Caster
                if ____opt_422 ~= nil then
                    ____opt_422:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_dash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond303 = ____cond303 or ____switch303 == 1
        if ____cond303 then
            do
                local ____opt_424 = self.Caster
                if ____opt_424 ~= nil then
                    ____opt_424:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_slash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond303 = ____cond303 or ____switch303 == 2
        if ____cond303 then
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
    local ____opt_426 = self.Caster
    if ____opt_426 and ____opt_426:HasModifier("modifier_ascended") then
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
    local ____opt_428 = self.Caster
    self.ModifierIshanaDaitenshou = ____opt_428 and ____opt_428:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.ModifierIshanaDaitenshou.Victim
    self:StartIntervalThink(0.03)
end
function musashi_modifier_ishana_daitenshou_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_430 = self.Caster
    local CasterAbsOrigin = ____opt_430 and ____opt_430:GetAbsOrigin()
    local ____opt_432 = self.Victim
    local VictimAbsOrigin = ____opt_432 and ____opt_432:GetAbsOrigin()
    local ____opt_434 = self:GetAbility()
    local DashSpeed = ____opt_434 and ____opt_434:GetSpecialValueFor("DashSpeed")
    local Direction = (VictimAbsOrigin - CasterAbsOrigin):Normalized()
    local ____opt_436 = self.Caster
    if ____opt_436 ~= nil then
        ____opt_436:SetForwardVector(Direction)
    end
    local ____opt_438 = self.Caster
    local NewPosition = CasterAbsOrigin + (____opt_438 and ____opt_438:GetForwardVector()) * DashSpeed
    local ____opt_440 = self.Caster
    if ____opt_440 ~= nil then
        ____opt_440:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_444 = Entities.FindByNameWithin
    local ____opt_442 = self.Caster
    local Musashi = ____Entities_FindByNameWithin_444(
        Entities,
        nil,
        ____opt_442 and ____opt_442:GetName(),
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
    local ____opt_445 = self.ModifierIshanaDaitenshou
    if ____opt_445 ~= nil then
        ____opt_445:IncrementStackCount()
    end
    local ____opt_447 = self.Caster
    if ____opt_447 ~= nil then
        ____opt_447:SetForwardVector(self.Caster:GetAbsOrigin():Normalized())
    end
    local ____FindClearSpaceForUnit_452 = FindClearSpaceForUnit
    local ____self_Caster_451 = self.Caster
    local ____opt_449 = self.Caster
    ____FindClearSpaceForUnit_452(
        ____self_Caster_451,
        ____opt_449 and ____opt_449:GetAbsOrigin(),
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
    local ____opt_453 = self.Caster
    self.ModifierIshanaDaitenshou = ____opt_453 and ____opt_453:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.ModifierIshanaDaitenshou.Victim
    local ____opt_455 = self.Ability
    local NormalSlashInterval = ____opt_455 and ____opt_455:GetSpecialValueFor("NormalSlashInterval")
    self:StartIntervalThink(NormalSlashInterval)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_457 = self.Ability
    local NormalSlashCount = ____opt_457 and ____opt_457:GetSpecialValueFor("NormalSlashCount")
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
    local ____opt_459 = self.ModifierIshanaDaitenshou
    if ____opt_459 ~= nil then
        ____opt_459:IncrementStackCount()
    end
end
function musashi_modifier_ishana_daitenshou_slash.prototype.DoDamage(self)
    local ____opt_461 = self.Ability
    local NormalSlashMaxHpPercent = (____opt_461 and ____opt_461:GetSpecialValueFor("NormalSlashMaxHpPercent")) / 100
    local ____opt_463 = self.Victim
    local Damage = (____opt_463 and ____opt_463:GetMaxHealth()) * NormalSlashMaxHpPercent
    local ____ApplyDamage_469 = ApplyDamage
    local ____self_Victim_467 = self.Victim
    local ____self_Caster_468 = self.Caster
    local ____opt_465 = self.Ability
    ____ApplyDamage_469({
        victim = ____self_Victim_467,
        attacker = ____self_Caster_468,
        damage = Damage,
        damage_type = ____opt_465 and ____opt_465:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS,
        ability = self.Ability
    })
end
function musashi_modifier_ishana_daitenshou_slash.prototype.PerformFinalSlash(self)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____opt_470 = self.Ability
        local FinalSlashDmgDelay = ____opt_470 and ____opt_470:GetSpecialValueFor("FinalSlashDmgDelay")
        self:CreateParticle()
        __TS__Await(Sleep(nil, FinalSlashDmgDelay))
        local ____opt_472 = self.Ability
        local FinalSlashMaxHpPercent = (____opt_472 and ____opt_472:GetSpecialValueFor("FinalSlashMaxHpPercent")) / 100
        local ____opt_474 = self.Ability
        local ExecuteThresholdPercent = ____opt_474 and ____opt_474:GetSpecialValueFor("ExecuteThresholdPercent")
        local ____ApplyDamage_480 = ApplyDamage
        local ____self_Victim_478 = self.Victim
        local ____self_Caster_479 = self.Caster
        local ____opt_476 = self.Ability
        ____ApplyDamage_480({
            victim = ____self_Victim_478,
            attacker = ____self_Caster_479,
            damage = FinalSlashMaxHpPercent,
            damage_type = ____opt_476 and ____opt_476:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS,
            ability = self.Ability
        })
        local ____opt_481 = self.Victim
        local CurrentHealth = ____opt_481 and ____opt_481:GetHealthPercent()
        if CurrentHealth <= ExecuteThresholdPercent then
            local ____opt_483 = self.Victim
            if ____opt_483 ~= nil then
                ____opt_483:Kill(self.Ability, self.Caster)
            end
        else
            local ____opt_485 = self.Ability
            local DebuffDuration = ____opt_485 and ____opt_485:GetSpecialValueFor("DebuffDuration")
            local ____opt_487 = self.Victim
            local CurrentHealthPercent = (____opt_487 and ____opt_487:GetHealthPercent()) / 100
            local ____opt_489 = self.Victim
            if ____opt_489 ~= nil then
                ____opt_489:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_debuff.name, {duration = DebuffDuration})
            end
            local ____opt_491 = self.Victim
            local NewHealth = (____opt_491 and ____opt_491:GetMaxHealth()) * CurrentHealthPercent
            local ____opt_493 = self.Victim
            if ____opt_493 ~= nil then
                ____opt_493:SetHealth(NewHealth)
            end
        end
    end)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_slash_basic.vpcf"
    local ____opt_495 = self.ModifierIshanaDaitenshou
    local StartPosition = ____opt_495 and ____opt_495.StartPosition
    local ____opt_497 = self.Caster
    local EndPosition = ____opt_497 and ____opt_497:GetAbsOrigin()
    local ____opt_499 = self.Caster
    if ____opt_499 and ____opt_499:HasModifier("modifier_ascended") then
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
    local ____opt_501 = self:GetAbility()
    return ____opt_501 and ____opt_501:GetSpecialValueFor("MaxHpReductionPercent")
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_503 = self:GetAbility()
    return ____opt_503 and ____opt_503:GetSpecialValueFor("ExtraIncomingDmgPercent")
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
        local ____opt_505 = self.Niou
        if ____opt_505 ~= nil then
            ____opt_505:ForceKill(false)
        end
        __TS__Await(Sleep(nil, delay))
        local ____opt_507 = self.Niou
        if ____opt_507 ~= nil then
            ____opt_507:Destroy()
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
