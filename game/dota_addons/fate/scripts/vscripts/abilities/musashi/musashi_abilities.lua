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
local ____dota_ts_adapter = require("tslib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerAbility = ____dota_ts_adapter.registerAbility
local registerModifier = ____dota_ts_adapter.registerModifier
local ____sleep_timer = require("tslib.sleep_timer")
local Sleep = ____sleep_timer.Sleep
local ____skillslot_checker = require("tslib.skillslot_checker")
local SkillSlotChecker = ____skillslot_checker.SkillSlotChecker
require("libraries.util")
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
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_dai_go_sei.name, {duration = BuffDuration})
    self:PlaySound()
end
function musashi_dai_go_sei.prototype.PlaySound(self)
    local ____opt_0 = self.Caster
    if ____opt_0 ~= nil then
        ____opt_0:EmitSound(self.SoundVoiceline)
    end
    local ____opt_2 = self.Caster
    if ____opt_2 ~= nil then
        ____opt_2:EmitSound(self.SoundSfx)
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
    self.ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_basic.vpcf"
    self.BlueOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_basic.vpcf"
    self.RedOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_redorb_basic.vpcf"
end
function musashi_modifier_dai_go_sei.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_4 = self.Ability
    self.BonusDmg = ____opt_4 and ____opt_4:GetSpecialValueFor("BonusDmg")
    local ____opt_6 = self.Ability
    self.BonusAtkSpeed = ____opt_6 and ____opt_6:GetSpecialValueFor("BonusAtkSpeed")
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
function musashi_modifier_dai_go_sei.prototype.CreateParticle(self)
    local ____opt_8 = self.Caster
    if ____opt_8 and ____opt_8:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_unique.vpcf"
        self.BlueOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_unique.vpcf"
        self.RedOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_redorb_unique.vpcf"
    end
    local BuffParticle = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
    local BlueOrbParticle = ParticleManager:CreateParticle(self.BlueOrbParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    local RedOrbParticle = ParticleManager:CreateParticle(self.RedOrbParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
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
        BuffParticle,
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
    return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
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
____exports.musashi_tengan = __TS__Class()
local musashi_tengan = ____exports.musashi_tengan
musashi_tengan.name = "musashi_tengan"
__TS__ClassExtends(musashi_tengan, BaseAbility)
function musashi_tengan.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_cast_02"
    self.SoundSfx = "musashi_tengan_sfx"
end
function musashi_tengan.prototype.OnSpellStart(self)
    self.Caster = self:GetCaster()
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    local ____opt_10 = self.Caster
    if ____opt_10 ~= nil then
        ____opt_10:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_tengan.name, {duration = BuffDuration})
    end
    self:CanCastTenmaGogan()
    self:PlaySound()
end
function musashi_tengan.prototype.PlaySound(self)
    local ____opt_12 = self.Caster
    if ____opt_12 ~= nil then
        ____opt_12:EmitSound(self.SoundVoiceline)
    end
    local ____opt_14 = self.Caster
    if ____opt_14 ~= nil then
        ____opt_14:EmitSound(self.SoundSfx)
    end
end
function musashi_tengan.prototype.CanCastTenmaGogan(self)
    do
        if self:GetCurrentAbilityCharges() >= self:GetMaxAbilityCharges(1) - 1 then
            SkillSlotChecker(
                nil,
                self.Caster,
                self:GetName(),
                ____exports.musashi_tenma_gogan.name,
                5
            )
        end
    end
end
musashi_tengan = __TS__Decorate(
    {registerAbility(nil)},
    musashi_tengan
)
____exports.musashi_tengan = musashi_tengan
____exports.musashi_modifier_tengan = __TS__Class()
local musashi_modifier_tengan = ____exports.musashi_modifier_tengan
musashi_modifier_tengan.name = "musashi_modifier_tengan"
__TS__ClassExtends(musashi_modifier_tengan, BaseModifier)
function musashi_modifier_tengan.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.ParticleStr = "particles/custom/musashi/musashi_tengan_basic.vpcf"
    self.OverheadParticleStr = "particles/custom/musashi/musashi_tengan_overhead_basic.vpcf"
    self.BonusDmg = 0
end
function musashi_modifier_tengan.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_16 = self.Ability
    self.BonusDmg = ____opt_16 and ____opt_16:GetSpecialValueFor("BonusDmg")
    self:CreateParticle()
end
function musashi_modifier_tengan.prototype.OnRefresh(self)
    if not IsServer() then
        return
    end
    self:OnCreated()
end
function musashi_modifier_tengan.prototype.CreateParticle(self)
    local ____opt_18 = self.Caster
    if ____opt_18 and ____opt_18:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_tengan_unique.vpcf"
        self.OverheadParticleStr = "particles/custom/musashi/musashi_tengan_overhead_unique.vpcf"
        local OverheadParticle = ParticleManager:CreateParticle(self.OverheadParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
        self:AddParticle(
            OverheadParticle,
            false,
            false,
            -1,
            false,
            false
        )
    else
        local OverheadParticle = ParticleManager:CreateParticle(self.OverheadParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
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
            OverheadParticle,
            false,
            false,
            -1,
            false,
            false
        )
    end
    local BuffParticle = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    self:AddParticle(
        BuffParticle,
        false,
        false,
        -1,
        false,
        false
    )
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
____exports.musashi_niou_kurikara = __TS__Class()
local musashi_niou_kurikara = ____exports.musashi_niou_kurikara
musashi_niou_kurikara.name = "musashi_niou_kurikara"
__TS__ClassExtends(musashi_niou_kurikara, BaseAbility)
function musashi_niou_kurikara.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_cast_03"
    self.SoundSfx = "musashi_niou_kurikara_sfx"
    self.BasicAoeParticle = "particles/custom/musashi/musashi_niou_kurikara_basic.vpcf"
    self.TargetAoe = Vector(0, 0, 0)
    self.Interval = 0
    self.SlashCount = 0
    self.DmgPerSlash = 0
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
    local ____opt_20 = self.Niou
    if ____opt_20 ~= nil then
        ____opt_20:FaceTowards(self.TargetAoe)
    end
    return true
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseInterrupted(self)
    local ____opt_22 = self.NiouSkill
    if ____opt_22 ~= nil then
        ____opt_22:DestroyNiou(0)
    end
end
function musashi_niou_kurikara.prototype.OnSpellStart(self)
    self.DmgPerSlash = self:GetSpecialValueFor("DmgPerSlash")
    local ____opt_24 = self.Niou
    if ____opt_24 ~= nil then
        ____opt_24:StartGestureWithPlaybackRate(ACT_DOTA_CHANNEL_ABILITY_1, 1.1)
    end
    self.Interval = 0.5
    self.SlashCount = self.SlashCount + 1
end
function musashi_niou_kurikara.prototype.OnChannelThink(self, interval)
    if self.Interval >= 0.5 and self.SlashCount < 5 then
        self.Interval = 0
        self:DoDamage()
        self:CreateParticle()
    end
    self.Interval = self.Interval + interval
end
function musashi_niou_kurikara.prototype.OnChannelFinish(self, interrupted)
    self.SlashCount = 0
    self.Interval = 0
    if interrupted then
        local ____opt_26 = self.NiouSkill
        if ____opt_26 ~= nil then
            ____opt_26:DestroyNiou(0)
        end
    else
        local ____opt_28 = self.NiouSkill
        if ____opt_28 ~= nil then
            ____opt_28:DestroyNiou(1)
        end
    end
end
function musashi_niou_kurikara.prototype.DoDamage(self)
    local ____FindUnitsInRadius_32 = FindUnitsInRadius
    local ____opt_30 = self.Caster
    local Targets = ____FindUnitsInRadius_32(
        ____opt_30 and ____opt_30:GetTeam(),
        self.TargetAoe,
        nil,
        self:GetAOERadius(),
        self:GetAbilityTargetTeam(),
        self:GetAbilityTargetType(),
        self:GetAbilityTargetFlags(),
        FIND_ANY_ORDER,
        false
    )
    for ____, Iterator in ipairs(Targets) do
        ApplyDamage({
            victim = Iterator,
            attacker = self.Caster,
            damage = 0,
            damage_type = self:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = self
        })
    end
    self.SlashCount = self.SlashCount + 1
    local ____opt_33 = self.Caster
    local ModifierTengan = ____opt_33 and ____opt_33:FindModifierByName(____exports.musashi_modifier_tengan.name)
    if self.SlashCount == 5 and ModifierTengan then
        for ____, Iterator in ipairs(Targets) do
            ApplyDamage({
                victim = Iterator,
                attacker = self.Caster,
                damage = ModifierTengan.BonusDmg,
                damage_type = DAMAGE_TYPE_PURE,
                damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                ability = self
            })
        end
        ModifierTengan:Destroy()
    end
end
function musashi_niou_kurikara.prototype.CreateParticle(self)
    local ____opt_35 = self.Caster
    if ____opt_35 and ____opt_35:HasModifier("modifier_ascended") then
        local AoeParticleStr = ""
        local CrackParticleStr = ""
        repeat
            local ____switch47 = self.SlashCount
            local ____cond47 = ____switch47 == 1
            if ____cond47 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond47 = ____cond47 or ____switch47 == 2
            if ____cond47 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond47 = ____cond47 or ____switch47 == 3
            if ____cond47 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire_crack.vpcf"
                    break
                end
            end
            ____cond47 = ____cond47 or ____switch47 == 4
            if ____cond47 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind_crack.vpcf"
                    break
                end
            end
        until true
        local AoeParticle = ParticleManager:CreateParticle(AoeParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        local CrackParticle = ParticleManager:CreateParticle(CrackParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        ParticleManager:SetParticleControl(AoeParticle, 0, self.TargetAoe)
        ParticleManager:SetParticleControl(
            AoeParticle,
            1,
            Vector(0, 0, 0)
        )
        ParticleManager:SetParticleControl(
            AoeParticle,
            12,
            Vector(400, 0, 0)
        )
        ParticleManager:SetParticleControl(CrackParticle, 0, self.TargetAoe)
    else
        local AoeParticle = ParticleManager:CreateParticle(self.BasicAoeParticle, PATTACH_WORLDORIGIN, self.Caster)
        ParticleManager:SetParticleControl(AoeParticle, 0, self.TargetAoe)
        ParticleManager:SetParticleControl(
            AoeParticle,
            1,
            Vector(1.5, 0, 0)
        )
        ParticleManager:SetParticleControl(
            AoeParticle,
            2,
            Vector(400, 0, 0)
        )
    end
end
function musashi_niou_kurikara.prototype.OnUpgrade(self)
    local ____opt_37 = self.NiouSkill
    if ____opt_37 ~= nil then
        ____opt_37:SetLevel(self:GetLevel())
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
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    self.Caster = self:GetCaster()
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_mukyuu.name, {duration = BuffDuration})
    self:PlaySound()
end
function musashi_mukyuu.prototype.PlaySound(self)
    local ____opt_39 = self.Caster
    if ____opt_39 ~= nil then
        ____opt_39:EmitSound(self.SoundVoiceline)
    end
    local ____opt_41 = self.Caster
    if ____opt_41 ~= nil then
        ____opt_41:EmitSound(self.SoundSfx)
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
function musashi_modifier_mukyuu.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.ParticleStr = "particles/custom/musashi/musashi_mukyuu_basic.vpcf"
end
function musashi_modifier_mukyuu.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    self:CreateParticle()
end
function musashi_modifier_mukyuu.prototype.CreateParticle(self)
    local ____opt_43 = self.Caster
    if ____opt_43 and ____opt_43:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_mukyuu_unique.vpcf"
        local ParticleId = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
        ParticleManager:SetParticleControlEnt(
            ParticleId,
            1,
            self.Caster,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0),
            false
        )
        self:AddParticle(
            ParticleId,
            false,
            false,
            -1,
            false,
            false
        )
    else
        local ParticleId = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
        ParticleManager:SetParticleControlEnt(
            ParticleId,
            0,
            self.Caster,
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0),
            false
        )
        ParticleManager:SetParticleControl(
            ParticleId,
            1,
            Vector(150, 0, 0)
        )
        self:AddParticle(
            ParticleId,
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
function musashi_modifier_mukyuu.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE}
end
function musashi_modifier_mukyuu.prototype.GetAbsoluteNoDamagePure(self)
    return 1
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
____exports.musashi_tengen_no_hana = __TS__Class()
local musashi_tengen_no_hana = ____exports.musashi_tengen_no_hana
musashi_tengen_no_hana.name = "musashi_tengen_no_hana"
__TS__ClassExtends(musashi_tengen_no_hana, BaseAbility)
function musashi_tengen_no_hana.prototype.OnSpellStart(self)
    local ____opt_45 = self:GetCaster()
    local ModifierTengenNoHana = ____opt_45 and ____opt_45:FindModifierByName(____exports.musashi_modifier_tengen_no_hana.name)
    if ModifierTengenNoHana then
        ModifierTengenNoHana:Destroy()
        return
    end
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    local ____opt_47 = self:GetCaster()
    if ____opt_47 ~= nil then
        ____opt_47:AddNewModifier(
            self:GetCaster(),
            self,
            ____exports.musashi_modifier_tengen_no_hana.name,
            {duration = BuffDuration}
        )
    end
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
    self.OverheadParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_basic.vpcf"
    self.AoeParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_basic.vpcf"
    self.AoeMarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_basic.vpcf"
    self.Damage = 0
    self.Radius = 0
end
function musashi_modifier_tengen_no_hana.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_49 = self.Ability
    self.Radius = ____opt_49 and ____opt_49:GetSpecialValueFor("Radius")
    local ____opt_51 = self.Ability
    local RampUpInterval = ____opt_51 and ____opt_51:GetSpecialValueFor("RampUpInterval")
    self:CreateParticle()
    local ____opt_53 = self.Caster
    if ____opt_53 ~= nil then
        ____opt_53:EmitSound(self.SoundSfx)
    end
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
        local ____switch75 = stackCount
        local ____cond75 = ____switch75 == 0
        if ____cond75 then
            do
                local ____opt_55 = self.Ability
                self.Damage = ____opt_55 and ____opt_55:GetSpecialValueFor("Damage1")
                break
            end
        end
        ____cond75 = ____cond75 or ____switch75 == 1
        if ____cond75 then
            do
                local ____opt_57 = self.Ability
                self.Damage = ____opt_57 and ____opt_57:GetSpecialValueFor("Damage2")
                break
            end
        end
        ____cond75 = ____cond75 or ____switch75 == 2
        if ____cond75 then
            do
                local ____opt_59 = self.Ability
                self.Damage = ____opt_59 and ____opt_59:GetSpecialValueFor("Damage3")
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
    local ____opt_61 = self.Caster
    if ____opt_61 ~= nil then
        ____opt_61:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    self:DoDamage()
    self:CreateAoeParticle()
    EmitGlobalSound(self.SoundVoiceline)
end
function musashi_modifier_tengen_no_hana.prototype.DoDamage(self)
    local ____FindUnitsInRadius_74 = FindUnitsInRadius
    local ____opt_63 = self.Caster
    local ____array_73 = __TS__SparseArrayNew(____opt_63 and ____opt_63:GetTeam())
    local ____opt_65 = self.Caster
    __TS__SparseArrayPush(
        ____array_73,
        ____opt_65 and ____opt_65:GetAbsOrigin(),
        nil,
        self.Radius
    )
    local ____opt_67 = self.Ability
    __TS__SparseArrayPush(
        ____array_73,
        ____opt_67 and ____opt_67:GetAbilityTargetTeam()
    )
    local ____opt_69 = self.Ability
    __TS__SparseArrayPush(
        ____array_73,
        ____opt_69 and ____opt_69:GetAbilityTargetType()
    )
    local ____opt_71 = self.Ability
    __TS__SparseArrayPush(
        ____array_73,
        ____opt_71 and ____opt_71:GetAbilityTargetFlags(),
        FIND_ANY_ORDER,
        false
    )
    local Targets = ____FindUnitsInRadius_74(__TS__SparseArraySpread(____array_73))
    for ____, Iterator in ipairs(Targets) do
        ApplyDamage({
            victim = Iterator,
            attacker = self.Caster,
            damage = self.Damage,
            damage_type = DAMAGE_TYPE_PURE,
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            ability = self.Ability
        })
    end
end
function musashi_modifier_tengen_no_hana.prototype.CreateParticle(self)
    local ____opt_75 = self.Caster
    if ____opt_75 and ____opt_75:HasModifier("modifier_ascended") then
        self.OverheadParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_unique1.vpcf"
        if self.Caster:HasModifier(____exports.musashi_modifier_battle_continuation_active.name) then
            self.OverheadParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_unique2.vpcf"
        end
    end
    local OverheadParticle = ParticleManager:CreateParticle(self.OverheadParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
    self:AddParticle(
        OverheadParticle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_tengen_no_hana.prototype.CreateAoeParticle(self)
    local ____opt_77 = self.Caster
    if ____opt_77 and ____opt_77:HasModifier("modifier_ascended") then
        self.AoeParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique1.vpcf"
        self.AoeMarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique1.vpcf"
        if self.Caster:HasModifier(____exports.musashi_modifier_battle_continuation_active.name) then
            self.AoeParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique2.vpcf"
            self.AoeMarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique1.vpcf"
        end
    end
    local AoeParticle = ParticleManager:CreateParticle(self.AoeParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local AoeMarkerParticle = ParticleManager:CreateParticle(self.AoeMarkerParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ____ParticleManager_SetParticleControl_81 = ParticleManager.SetParticleControl
    local ____opt_79 = self.Caster
    ____ParticleManager_SetParticleControl_81(
        ParticleManager,
        AoeParticle,
        0,
        ____opt_79 and ____opt_79:GetAbsOrigin()
    )
    ParticleManager:SetParticleControl(
        AoeParticle,
        2,
        Vector(self.Radius, self.Radius, self.Radius)
    )
    ParticleManager:SetParticleControl(
        AoeMarkerParticle,
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
    local DashCounter = self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_ganryuu_jima.name, {undefined = undefined})
    DashCounter:IncrementStackCount()
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
        return self:GetSpecialValueFor("SlashRange")
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
    return self.SlashPosition
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
    self.Ganryuu_Jima = self:GetAbility()
    self.DashPosition = self.Ganryuu_Jima.DashPosition
    self.SlashPosition = self.Ganryuu_Jima.SlashPosition
    self.SecondSlashPosition = self.Ganryuu_Jima.SecondSlashPosition
    giveUnitDataDrivenModifier(self.Caster, self.Caster, "pause_sealdisabled", 1.5)
end
function musashi_modifier_ganryuu_jima.prototype.OnStackCountChanged(self, stackCount)
    if not IsServer() then
        return
    end
    local Position = Vector(0, 0, 0)
    repeat
        local ____switch110 = stackCount
        local ____cond110 = ____switch110 == 0
        if ____cond110 then
            do
                Position = self.DashPosition
                local ____opt_82 = self.Caster
                local DashBuff = ____opt_82 and ____opt_82:AddNewModifier(self.Caster, self.Ganryuu_Jima, ____exports.musashi_modifier_ganryuu_jima_dash.name, {undefined = undefined})
                DashBuff.TargetPoint = Position
                local ____DashBuff_TargetPoint_86 = DashBuff.TargetPoint
                local ____opt_84 = self.Caster
                ____DashBuff_TargetPoint_86.z = ____opt_84 and ____opt_84:GetAbsOrigin().z
                local ____DashBuff_TargetPoint_89 = DashBuff.TargetPoint
                local ____opt_87 = self.Caster
                DashBuff.NormalizedTargetPoint = (____DashBuff_TargetPoint_89 - (____opt_87 and ____opt_87:GetAbsOrigin())):Normalized()
                DashBuff:StartIntervalThink(0.03)
                break
            end
        end
        ____cond110 = ____cond110 or ____switch110 == 1
        if ____cond110 then
            do
                Position = self.SlashPosition
                break
            end
        end
        ____cond110 = ____cond110 or ____switch110 == 2
        if ____cond110 then
            do
                Position = self.SecondSlashPosition
                break
            end
        end
        ____cond110 = ____cond110 or ____switch110 == 3
        if ____cond110 then
            do
                self:Destroy()
                break
            end
        end
    until true
    if stackCount == 1 or stackCount == 2 then
        local ____opt_90 = self.Caster
        local SlashBuff = ____opt_90 and ____opt_90:AddNewModifier(self.Caster, self.Ganryuu_Jima, ____exports.musashi_modifier_ganryuu_jima_slash.name, {undefined = undefined})
        SlashBuff.TargetPoint = Position
        SlashBuff:StartIntervalThink(0.03)
    end
end
function musashi_modifier_ganryuu_jima.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_92 = self.Caster
    if ____opt_92 ~= nil then
        ____opt_92:SetForwardVector(self.SecondSlashPosition)
    end
    local ____opt_94 = self.Caster
    if ____opt_94 ~= nil then
        ____opt_94:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    local ____FindClearSpaceForUnit_99 = FindClearSpaceForUnit
    local ____self_Caster_98 = self.Caster
    local ____opt_96 = self.Caster
    ____FindClearSpaceForUnit_99(
        ____self_Caster_98,
        ____opt_96 and ____opt_96:GetAbsOrigin(),
        true
    )
    local ____opt_100 = self.Caster
    if ____opt_100 ~= nil then
        ____opt_100:AddNewModifier(self.Caster, self.Ganryuu_Jima, "modifier_phase", {duration = 1})
    end
end
function musashi_modifier_ganryuu_jima.prototype.CheckState(self)
    local ModifierTable = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
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
____exports.musashi_modifier_ganryuu_jima_slash = __TS__Class()
local musashi_modifier_ganryuu_jima_slash = ____exports.musashi_modifier_ganryuu_jima_slash
musashi_modifier_ganryuu_jima_slash.name = "musashi_modifier_ganryuu_jima_slash"
__TS__ClassExtends(musashi_modifier_ganryuu_jima_slash, BaseModifier)
function musashi_modifier_ganryuu_jima_slash.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.SoundSfx = "musashi_ganryuu_jima_sfx"
    self.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_basic.vpcf"
    self.StartPosition = Vector(0, 0, 0)
    self.EndPosition = Vector(0, 0, 0)
    self.TargetPoint = Vector(0, 0, 0)
    self.SlashRange = 0
    self.UnitsTravelled = 0
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    self.StartPosition = self.Caster:GetAbsOrigin()
    local ____opt_102 = self.Ability
    self.SlashRange = ____opt_102 and ____opt_102:GetSpecialValueFor("SlashRange")
    self.Caster:EmitSound(self.SoundSfx)
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_104 = self.Caster
    if ____opt_104 ~= nil then
        ____opt_104:SetForwardVector(self.TargetPoint)
    end
    local ____opt_106 = self.Caster
    local CurrentOrigin = ____opt_106 and ____opt_106:GetAbsOrigin()
    local ____opt_108 = self.Ability
    local DashSpeed = ____opt_108 and ____opt_108:GetSpecialValueFor("DashSpeed")
    local ____opt_110 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_110 and ____opt_110:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_112 = self.Caster
    if ____opt_112 ~= nil then
        ____opt_112:SetAbsOrigin(NewPosition)
    end
    if self.UnitsTravelled >= self.SlashRange then
        self:Destroy()
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_114 = self.Caster
    self.EndPosition = ____opt_114 and ____opt_114:GetAbsOrigin()
    self:DoDamage()
    self:CreateParticle()
    local ____opt_116 = self.Caster
    local DashCounter = ____opt_116 and ____opt_116:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
    DashCounter:IncrementStackCount()
end
function musashi_modifier_ganryuu_jima_slash.prototype.DoDamage(self)
    local ____FindUnitsInLine_129 = FindUnitsInLine
    local ____opt_118 = self.Caster
    local ____array_128 = __TS__SparseArrayNew(
        ____opt_118 and ____opt_118:GetTeam(),
        self.StartPosition,
        self.EndPosition,
        nil
    )
    local ____opt_120 = self.Ability
    __TS__SparseArrayPush(
        ____array_128,
        ____opt_120 and ____opt_120:GetSpecialValueFor("SlashRadius")
    )
    local ____opt_122 = self.Ability
    __TS__SparseArrayPush(
        ____array_128,
        ____opt_122 and ____opt_122:GetAbilityTargetTeam()
    )
    local ____opt_124 = self.Ability
    __TS__SparseArrayPush(
        ____array_128,
        ____opt_124 and ____opt_124:GetAbilityTargetType()
    )
    local ____opt_126 = self.Ability
    __TS__SparseArrayPush(
        ____array_128,
        ____opt_126 and ____opt_126:GetAbilityTargetFlags()
    )
    local Targets = ____FindUnitsInLine_129(__TS__SparseArraySpread(____array_128))
    for ____, Iterator in ipairs(Targets) do
        local ____ApplyDamage_133 = ApplyDamage
        local ____self_Caster_132 = self.Caster
        local ____opt_130 = self.Ability
        ____ApplyDamage_133({
            victim = Iterator,
            attacker = ____self_Caster_132,
            damage = ____opt_130 and ____opt_130:GetSpecialValueFor("DmgPerSlash"),
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = self.Ability
        })
        local ____opt_134 = self.Caster
        if ____opt_134 and ____opt_134:HasModifier(____exports.musashi_modifier_tengan.name) then
            local ____Iterator_AddNewModifier_139 = Iterator.AddNewModifier
            local ____array_138 = __TS__SparseArrayNew(self.Caster, self.Ability, ____exports.musashi_modifier_ganryuu_jima_debuff.name)
            local ____opt_136 = self.Ability
            __TS__SparseArrayPush(
                ____array_138,
                {duration = ____opt_136 and ____opt_136:GetSpecialValueFor("DmgDelay")}
            )
            ____Iterator_AddNewModifier_139(
                Iterator,
                __TS__SparseArraySpread(____array_138)
            )
        end
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.CreateParticle(self)
    local ____opt_140 = self.Caster
    if ____opt_140 and ____opt_140:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_unique.vpcf"
    end
    local ParticleId = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    ParticleManager:SetParticleControl(ParticleId, 0, self.StartPosition)
    ParticleManager:SetParticleControl(ParticleId, 1, self.EndPosition)
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
function musashi_modifier_ganryuu_jima_slash.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE}
end
function musashi_modifier_ganryuu_jima_slash.prototype.GetOverrideAnimation(self)
    return ACT_DOTA_OVERRIDE_ABILITY_2
end
function musashi_modifier_ganryuu_jima_slash.prototype.GetOverrideAnimationRate(self)
    return 2
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
    self.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_debuff_basic.vpcf"
end
function musashi_modifier_ganryuu_jima_debuff.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Victim = self:GetParent()
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
    self:DoDamage()
end
function musashi_modifier_ganryuu_jima_debuff.prototype.DoDamage(self)
    local ____opt_142 = self.Caster
    local ModifierTengan = ____opt_142 and ____opt_142:FindModifierByName(____exports.musashi_modifier_tengan.name)
    ApplyDamage({
        victim = self.Victim,
        attacker = self.Caster,
        damage = ModifierTengan.BonusDmg,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self.Ability
    })
end
function musashi_modifier_ganryuu_jima_debuff.prototype.CreateParticle(self)
    local ____opt_144 = self.Caster
    if ____opt_144 and ____opt_144:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_debuff_unique.vpcf"
    end
    local DebuffParticle = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Victim)
    self:AddParticle(
        DebuffParticle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_ganryuu_jima_debuff.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ganryuu_jima_debuff.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_ganryuu_jima_debuff.prototype.IsDebuff(self)
    return true
end
musashi_modifier_ganryuu_jima_debuff = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima_debuff
)
____exports.musashi_modifier_ganryuu_jima_debuff = musashi_modifier_ganryuu_jima_debuff
____exports.musashi_modifier_ganryuu_jima_dash = __TS__Class()
local musashi_modifier_ganryuu_jima_dash = ____exports.musashi_modifier_ganryuu_jima_dash
musashi_modifier_ganryuu_jima_dash.name = "musashi_modifier_ganryuu_jima_dash"
__TS__ClassExtends(musashi_modifier_ganryuu_jima_dash, BaseModifier)
function musashi_modifier_ganryuu_jima_dash.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.StartPosition = Vector(0, 0, 0)
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
    local ____opt_146 = self.Caster
    self.StartPosition = ____opt_146 and ____opt_146:GetAbsOrigin()
    local ____opt_148 = self.Ability
    self.SlashRange = ____opt_148 and ____opt_148:GetSpecialValueFor("SlashRange")
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_150 = self.Caster
    if ____opt_150 ~= nil then
        ____opt_150:SetForwardVector(self.NormalizedTargetPoint)
    end
    local ____opt_152 = self.Caster
    local CurrentOrigin = ____opt_152 and ____opt_152:GetAbsOrigin()
    local ____opt_154 = self.Ability
    local DashSpeed = ____opt_154 and ____opt_154:GetSpecialValueFor("DashSpeed")
    local ____opt_156 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_156 and ____opt_156:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_158 = self.Caster
    if ____opt_158 ~= nil then
        ____opt_158:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_162 = Entities.FindByNameWithin
    local ____opt_160 = self.Caster
    local Musashi = ____Entities_FindByNameWithin_162(
        Entities,
        nil,
        ____opt_160 and ____opt_160:GetName(),
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
    local ____opt_163 = self.Caster
    local DashCounter = ____opt_163 and ____opt_163:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
    if DashCounter ~= nil then
        DashCounter:IncrementStackCount()
    end
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
function musashi_modifier_ganryuu_jima_dash.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE}
end
function musashi_modifier_ganryuu_jima_dash.prototype.GetOverrideAnimation(self)
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function musashi_modifier_ganryuu_jima_dash.prototype.GetOverrideAnimationRate(self)
    return 2
end
musashi_modifier_ganryuu_jima_dash = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima_dash
)
____exports.musashi_modifier_ganryuu_jima_dash = musashi_modifier_ganryuu_jima_dash
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
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_tenma_gogan.name, {duration = BuffDuration})
    self:PlaySound()
end
function musashi_tenma_gogan.prototype.PlaySound(self)
    local ____opt_167 = self.Caster
    if ____opt_167 ~= nil then
        ____opt_167:EmitSound(self.SoundVoiceline)
    end
    local ____opt_169 = self.Caster
    if ____opt_169 ~= nil then
        ____opt_169:EmitSound(self.SoundSfx)
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
function musashi_modifier_tenma_gogan.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.ParticleStr = "particles/custom/musashi/musashi_tenma_gogan_basic.vpcf"
    self.BodyParticleStr = "particles/custom/musashi/musashi_tenma_gogan_body.vpcf"
end
function musashi_modifier_tenma_gogan.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    self:CreateParticle()
end
function musashi_modifier_tenma_gogan.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_171 = self.Ability
    local DebuffDuration = ____opt_171 and ____opt_171:GetSpecialValueFor("DebuffDuration")
    local ____opt_173 = self.Caster
    if ____opt_173 ~= nil then
        ____opt_173:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_tenma_gogan_debuff.name, {duration = DebuffDuration})
    end
end
function musashi_modifier_tenma_gogan.prototype.CreateParticle(self)
    local ____opt_175 = self.Caster
    if ____opt_175 and ____opt_175:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_tenma_gogan_unique.vpcf"
    end
    local ParticleId = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    local BodyParticleId = ParticleManager:CreateParticle(self.BodyParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    self:AddParticle(
        ParticleId,
        false,
        false,
        -1,
        false,
        false
    )
    self:AddParticle(
        BodyParticleId,
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
    self.Caster = self:GetCaster()
    giveUnitDataDrivenModifier(self.Caster, self.Caster, "pause_sealdisabled", 2)
end
function musashi_modifier_tenma_gogan_debuff.prototype.IsDebuff(self)
    return true
end
function musashi_modifier_tenma_gogan_debuff.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_tenma_gogan_debuff.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_tenma_gogan_debuff = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_tenma_gogan_debuff
)
____exports.musashi_modifier_tenma_gogan_debuff = musashi_modifier_tenma_gogan_debuff
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
function musashi_modifier_battle_continuation.prototype.OnTakeDamage(self)
    if not IsServer() then
        return
    end
    local ____opt_177 = self.Caster
    local ____temp_181 = (____opt_177 and ____opt_177:GetHealth()) <= 0
    if ____temp_181 then
        local ____opt_179 = self.Ability
        ____temp_181 = ____opt_179 and ____opt_179:IsCooldownReady()
    end
    local ____temp_181_184 = ____temp_181
    if ____temp_181_184 then
        local ____opt_182 = self.Caster
        ____temp_181_184 = not (____opt_182 and ____opt_182:HasModifier(____exports.musashi_modifier_tenma_gogan_debuff.name))
    end
    if ____temp_181_184 then
        local BuffDuration = self.Ability:GetSpecialValueFor("BuffDuration")
        local ____opt_185 = self.Caster
        if ____opt_185 ~= nil then
            ____opt_185:SetHealth(1)
        end
        local ____opt_187 = self.Caster
        if ____opt_187 ~= nil then
            ____opt_187:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_battle_continuation_active.name, {duration = BuffDuration})
        end
        local ____opt_189 = self.Caster
        if ____opt_189 ~= nil then
            ____opt_189:AddNewModifier(
                self.Caster,
                self.Ability,
                ____exports.musashi_modifier_battle_continuation_cooldown.name,
                {duration = self.Ability:GetCooldown(1)}
            )
        end
        self.Ability:UseResources(true, false, true)
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
function musashi_modifier_battle_continuation.prototype.IsHidden(self)
    return true
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
    self.ParticleStr = "particles/custom/musashi/musashi_battle_continuation_basic.vpcf"
end
function musashi_modifier_battle_continuation_active.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_191 = self.Caster
    if ____opt_191 ~= nil then
        ____opt_191:Purge(
            false,
            true,
            false,
            true,
            false
        )
    end
    ProjectileManager:ProjectileDodge(self.Caster)
    self:CreateParticle()
    self:PlaySound()
end
function musashi_modifier_battle_continuation_active.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_193 = self.Caster
    if ____opt_193 ~= nil then
        local ____opt_193_Heal_196 = ____opt_193.Heal
        local ____opt_194 = self.Ability
        ____opt_193_Heal_196(
            ____opt_193,
            ____opt_194 and ____opt_194:GetSpecialValueFor("Heal"),
            self.Ability
        )
    end
end
function musashi_modifier_battle_continuation_active.prototype.PlaySound(self)
    local ____opt_198 = self.Caster
    if ____opt_198 ~= nil then
        ____opt_198:EmitSound(self.SoundVoiceline)
    end
    local ____opt_200 = self.Caster
    if ____opt_200 ~= nil then
        ____opt_200:EmitSound(self.SoundSfx)
    end
end
function musashi_modifier_battle_continuation_active.prototype.CreateParticle(self)
    local ____opt_202 = self.Caster
    if ____opt_202 and ____opt_202:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_battle_continuation_unique.vpcf"
    end
    local ParticleId = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    ParticleManager:SetParticleControlEnt(
        ParticleId,
        5,
        self.Caster,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0, 0, 0),
        false
    )
    self:AddParticle(
        ParticleId,
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
function musashi_modifier_battle_continuation_active.prototype.GetDisableHealing(self)
    return 1
end
function musashi_modifier_battle_continuation_active.prototype.GetMinHealth(self)
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
function musashi_modifier_battle_continuation_cooldown.prototype.IsDebuff(self)
    return true
end
function musashi_modifier_battle_continuation_cooldown.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_battle_continuation_cooldown.prototype.IsPurgeException(self)
    return false
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
    self.Caster = self:GetCaster()
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_ishana_daitenshou.name, {duration = 10})
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
    self.MarkerParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_marker_basic.vpcf"
    self.SwordParticle = "particles/custom/musashi/musashi_ishana_daitenshou_sword_basic.vpcf"
    self.BodyParticle = "particles/custom/musashi/musashi_ishana_daitenshou_body_basic.vpcf"
    self.CastedNiouKurikara = false
    self.MarkerPosition = Vector(0, 0, 0)
end
function musashi_modifier_ishana_daitenshou.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_204 = self.Ability
    self.Victim = ____opt_204 and ____opt_204:GetCursorTarget()
    local ____opt_206 = self.Victim
    self.MarkerPosition = ____opt_206 and ____opt_206:GetAbsOrigin()
    local ____opt_208 = self.Caster
    local NiouKurikara = ____opt_208 and ____opt_208:FindAbilityByName(____exports.musashi_niou_kurikara.name)
    local ____opt_210 = self.Caster
    if ____opt_210 ~= nil then
        ____opt_210:CastAbilityOnPosition(
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
    local ____opt_212 = self.Caster
    if ____opt_212 and ____opt_212:IsChanneling() then
        self.CastedNiouKurikara = true
    end
    local ____self_CastedNiouKurikara_216 = self.CastedNiouKurikara
    if ____self_CastedNiouKurikara_216 then
        local ____opt_214 = self.Caster
        ____self_CastedNiouKurikara_216 = not (____opt_214 and ____opt_214:IsChanneling())
    end
    if ____self_CastedNiouKurikara_216 then
        local ____Entities_FindByNameWithin_219 = Entities.FindByNameWithin
        local ____opt_217 = self.Victim
        local VictimInRadius = ____Entities_FindByNameWithin_219(
            Entities,
            nil,
            ____opt_217 and ____opt_217:GetName(),
            self.MarkerPosition,
            self.Ability:GetSpecialValueFor("Radius")
        )
        if VictimInRadius then
            self:IncrementStackCount()
            self:StartIntervalThink(-1)
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
        local ____switch217 = stackCount
        local ____cond217 = ____switch217 == 0
        if ____cond217 then
            do
                local ____opt_220 = self.Caster
                if ____opt_220 ~= nil then
                    ____opt_220:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_dash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond217 = ____cond217 or ____switch217 == 1
        if ____cond217 then
            do
            end
            break
        end
    until true
end
function musashi_modifier_ishana_daitenshou.prototype.CreateParticle(self)
    local ____opt_222 = self.Caster
    if ____opt_222 and ____opt_222:HasModifier("modifier_ascended") then
        self.MarkerParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_marker_unique.vpcf"
        self.SwordParticle = "particles/custom/musashi/musashi_ishana_daitenshou_sword_unique.vpcf"
        self.BodyParticle = "particles/custom/musashi/musashi_ishana_daitenshou_body_unique.vpcf"
    end
    local MarkerParticleId = ParticleManager:CreateParticle(self.MarkerParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local SwordParticleId = ParticleManager:CreateParticle(self.SwordParticle, PATTACH_POINT_FOLLOW, self.Caster)
    local BodyParticleId = ParticleManager:CreateParticle(self.BodyParticle, PATTACH_POINT_FOLLOW, self.Caster)
    ParticleManager:SetParticleControl(MarkerParticleId, 0, self.MarkerPosition)
    ParticleManager:SetParticleControlEnt(
        SwordParticleId,
        0,
        self.Caster,
        PATTACH_POINT_FOLLOW,
        "attach_attack1",
        Vector(0, 0, 0),
        false
    )
    self:AddParticle(
        MarkerParticleId,
        false,
        false,
        -1,
        false,
        false
    )
    self:AddParticle(
        SwordParticleId,
        false,
        false,
        -1,
        false,
        false
    )
    self:AddParticle(
        BodyParticleId,
        false,
        false,
        -1,
        false,
        false
    )
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
    local ____opt_224 = self.Caster
    self.IshanaBuff = ____opt_224 and ____opt_224:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
    self:StartIntervalThink(0.03)
end
function musashi_modifier_ishana_daitenshou_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_226 = self:GetAbility()
    local DashSpeed = ____opt_226 and ____opt_226:GetSpecialValueFor("DashSpeed")
    local ____opt_228 = self.Victim
    local ____temp_232 = ____opt_228 and ____opt_228:GetAbsOrigin()
    local ____opt_230 = self.Caster
    local Direction = (____temp_232 - (____opt_230 and ____opt_230:GetAbsOrigin())):Normalized()
    local ____opt_233 = self.Caster
    if ____opt_233 ~= nil then
        ____opt_233:SetForwardVector(Direction)
    end
    local ____opt_235 = self.Caster
    local ____temp_239 = ____opt_235 and ____opt_235:GetAbsOrigin()
    local ____opt_237 = self.Caster
    local NewPosition = ____temp_239 + (____opt_237 and ____opt_237:GetForwardVector()) * DashSpeed
    local ____opt_240 = self.Caster
    if ____opt_240 ~= nil then
        ____opt_240:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_247 = Entities.FindByNameWithin
    local ____opt_242 = self.Caster
    local ____temp_246 = ____opt_242 and ____opt_242:GetName()
    local ____opt_244 = self.Victim
    local Musashi = ____Entities_FindByNameWithin_247(
        Entities,
        nil,
        ____temp_246,
        ____opt_244 and ____opt_244:GetAbsOrigin(),
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
    local ____opt_248 = self.Caster
    local IshanaBuff = ____opt_248 and ____opt_248:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    if IshanaBuff ~= nil then
        IshanaBuff:IncrementStackCount()
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
    self.SlashCount = 0
end
function musashi_modifier_ishana_daitenshou_slash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_252 = self.Ability
    self.Victim = ____opt_252 and ____opt_252:GetCursorTarget()
    local ____opt_254 = self.Ability
    self.SlashCount = ____opt_254 and ____opt_254:GetSpecialValueFor("NormalSlashCount")
    local ____opt_256 = self.Ability
    local SlashInterval = ____opt_256 and ____opt_256:GetSpecialValueFor("NormalSlashInterval")
    self:StartIntervalThink(SlashInterval)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    if self.SlashCount <= 5 then
        self:DoDamage()
        self.SlashCount = self.SlashCount + 1
    else
        self:Destroy()
    end
end
function musashi_modifier_ishana_daitenshou_slash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    self:PerformFinalSlash()
end
function musashi_modifier_ishana_daitenshou_slash.prototype.PerformFinalSlash(self)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____Sleep_260 = Sleep
        local ____opt_258 = self:GetAbility()
        ____Sleep_260(
            nil,
            ____opt_258 and ____opt_258:GetSpecialValueFor("FinalSlashDmgDelay")
        )
        local ____opt_261 = self.Ability
        local MaxHpFinalSlashDmgPercent = ____opt_261 and ____opt_261:GetSpecialValueFor("MaxHpFinalSlashDmgPercent")
        local ____opt_263 = self.Victim
        local Damage = (____opt_263 and ____opt_263:GetMaxHealth()) * MaxHpFinalSlashDmgPercent / 100
        ApplyDamage({
            victim = self.Victim,
            attacker = self.Caster,
            damage = Damage,
            damage_type = DAMAGE_TYPE_PURE,
            damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_HPLOSS,
            ability = self.Ability
        })
    end)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.DoDamage(self)
    local ____opt_265 = self.Ability
    local MaxHpSlashDmgPercent = ____opt_265 and ____opt_265:GetSpecialValueFor("MaxHpSlashDmgPercent")
    local ____opt_267 = self.Victim
    local Damage = (____opt_267 and ____opt_267:GetMaxHealth()) * MaxHpSlashDmgPercent / 100
    ApplyDamage({
        victim = self.Victim,
        attacker = self.Caster,
        damage = Damage,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_HPLOSS,
        ability = self.Ability
    })
end
musashi_modifier_ishana_daitenshou_slash = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ishana_daitenshou_slash
)
____exports.musashi_modifier_ishana_daitenshou_slash = musashi_modifier_ishana_daitenshou_slash
____exports.musashi_niou = __TS__Class()
local musashi_niou = ____exports.musashi_niou
musashi_niou.name = "musashi_niou"
__TS__ClassExtends(musashi_niou, BaseAbility)
function musashi_niou.prototype.OnSpellStart(self)
    self.Caster = self:GetCaster()
    self.Niou = CreateUnitByName(
        "musashi_niou",
        self.Caster:GetAbsOrigin(),
        false,
        self.Caster,
        self.Caster,
        self.Caster:GetTeam()
    )
    local ModelScale = self:GetSpecialValueFor("ModelScale")
    self.Niou:SetModelScale(ModelScale)
    self.Niou:AddNewModifier(self.Niou, self, ____exports.musashi_modifier_niou.name, {undefined = undefined})
end
function musashi_niou.prototype.DestroyNiou(self, delay)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____opt_269 = self.Niou
        if ____opt_269 ~= nil then
            ____opt_269:ForceKill(false)
        end
        __TS__Await(Sleep(nil, delay))
        local ____opt_271 = self.Niou
        if ____opt_271 ~= nil then
            ____opt_271:Destroy()
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
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true
    }
    return ModifierTable
end
function musashi_modifier_niou.prototype.IsHidden(self)
    return true
end
function musashi_modifier_niou.prototype.IsPermanent(self)
    return true
end
function musashi_modifier_niou.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_niou.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_niou = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_niou
)
____exports.musashi_modifier_niou = musashi_modifier_niou
return ____exports
