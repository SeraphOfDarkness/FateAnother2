local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____dota_ts_adapter = require("tslib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerAbility = ____dota_ts_adapter.registerAbility
local registerModifier = ____dota_ts_adapter.registerModifier
local ____sleep_timer = require("tslib.sleep_timer")
local Sleep = ____sleep_timer.Sleep
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
    self.NiouSkill:CastAbility()
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
    EmitGlobalSound(self.SoundVoiceline)
end
function musashi_niou_kurikara.prototype.OnChannelThink(self, interval)
    if self.Interval >= 0.5 and self.SlashCount < 5 then
        self:DoDamage()
        self:CreateParticle()
        EmitSoundOnLocationWithCaster(self.TargetAoe, self.SoundSfx, self.Caster)
        self.Interval = 0
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
            damage = self.DmgPerSlash,
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
            local ____switch44 = self.SlashCount
            local ____cond44 = ____switch44 == 1
            if ____cond44 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond44 = ____cond44 or ____switch44 == 2
            if ____cond44 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond44 = ____cond44 or ____switch44 == 3
            if ____cond44 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire_crack.vpcf"
                    break
                end
            end
            ____cond44 = ____cond44 or ____switch44 == 4
            if ____cond44 then
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
        local ____opt_39 = self.Niou
        if ____opt_39 ~= nil then
            ____opt_39:ForceKill(false)
        end
        __TS__Await(Sleep(nil, delay))
        local ____opt_41 = self.Niou
        if ____opt_41 ~= nil then
            ____opt_41:Destroy()
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
        local ____switch77 = stackCount
        local ____cond77 = ____switch77 == 0
        if ____cond77 then
            do
                Position = self.DashPosition
                local ____opt_43 = self.Caster
                local DashBuff = ____opt_43 and ____opt_43:AddNewModifier(self.Caster, self.Ganryuu_Jima, ____exports.musashi_modifier_ganryuu_jima_dash.name, {undefined = undefined})
                DashBuff.TargetPoint = Position
                local ____DashBuff_TargetPoint_47 = DashBuff.TargetPoint
                local ____opt_45 = self.Caster
                ____DashBuff_TargetPoint_47.z = ____opt_45 and ____opt_45:GetAbsOrigin().z
                local ____DashBuff_TargetPoint_50 = DashBuff.TargetPoint
                local ____opt_48 = self.Caster
                DashBuff.NormalizedTargetPoint = (____DashBuff_TargetPoint_50 - (____opt_48 and ____opt_48:GetAbsOrigin())):Normalized()
                local ____opt_51 = self.Caster
                if ____opt_51 ~= nil then
                    ____opt_51:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 2)
                end
                DashBuff:StartIntervalThink(0.03)
                break
            end
        end
        ____cond77 = ____cond77 or ____switch77 == 1
        if ____cond77 then
            do
                Position = self.SlashPosition
                break
            end
        end
        ____cond77 = ____cond77 or ____switch77 == 2
        if ____cond77 then
            do
                Position = self.SecondSlashPosition
                break
            end
        end
        ____cond77 = ____cond77 or ____switch77 == 3
        if ____cond77 then
            do
                self:Destroy()
                break
            end
        end
    until true
    if stackCount == 1 or stackCount == 2 then
        local ____opt_53 = self.Caster
        local SlashBuff = ____opt_53 and ____opt_53:AddNewModifier(self.Caster, self.Ganryuu_Jima, ____exports.musashi_modifier_ganryuu_jima_slash.name, {undefined = undefined})
        SlashBuff.TargetPoint = Position
        local ____opt_55 = self.Caster
        if ____opt_55 ~= nil then
            ____opt_55:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 2)
        end
        SlashBuff:StartIntervalThink(0.03)
    end
end
function musashi_modifier_ganryuu_jima.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_57 = self.Caster
    if ____opt_57 ~= nil then
        ____opt_57:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    local ____opt_59 = self.Caster
    if ____opt_59 ~= nil then
        ____opt_59:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
    end
    local ____opt_61 = self.Caster
    if ____opt_61 ~= nil then
        ____opt_61:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
    end
    local ____opt_63 = self.Caster
    if ____opt_63 ~= nil then
        ____opt_63:SetForwardVector(self.Caster:GetForwardVector() * 10)
    end
    local ____FindClearSpaceForUnit_68 = FindClearSpaceForUnit
    local ____self_Caster_67 = self.Caster
    local ____opt_65 = self.Caster
    ____FindClearSpaceForUnit_68(
        ____self_Caster_67,
        ____opt_65 and ____opt_65:GetAbsOrigin(),
        true
    )
    local ____opt_69 = self.Caster
    if ____opt_69 ~= nil then
        ____opt_69:AddNewModifier(self.Caster, self.Ganryuu_Jima, "modifier_phase", {duration = 1.5})
    end
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
    local ____opt_71 = self.Ability
    self.SlashRange = ____opt_71 and ____opt_71:GetSpecialValueFor("SlashRange")
    self.Caster:EmitSound(self.SoundSfx)
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_73 = self.Caster
    if ____opt_73 ~= nil then
        ____opt_73:SetForwardVector(self.TargetPoint)
    end
    local ____opt_75 = self.Caster
    local CurrentOrigin = ____opt_75 and ____opt_75:GetAbsOrigin()
    local ____opt_77 = self.Ability
    local DashSpeed = ____opt_77 and ____opt_77:GetSpecialValueFor("DashSpeed")
    local ____opt_79 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_79 and ____opt_79:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_81 = self.Caster
    if ____opt_81 ~= nil then
        ____opt_81:SetAbsOrigin(NewPosition)
    end
    if self.UnitsTravelled >= self.SlashRange then
        self:Destroy()
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_83 = self.Caster
    self.EndPosition = ____opt_83 and ____opt_83:GetAbsOrigin()
    self:DoDamage()
    self:CreateParticle()
    local ____opt_85 = self.Caster
    local DashCounter = ____opt_85 and ____opt_85:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
    DashCounter:IncrementStackCount()
end
function musashi_modifier_ganryuu_jima_slash.prototype.DoDamage(self)
    local ____FindUnitsInLine_98 = FindUnitsInLine
    local ____opt_87 = self.Caster
    local ____array_97 = __TS__SparseArrayNew(
        ____opt_87 and ____opt_87:GetTeam(),
        self.StartPosition,
        self.EndPosition,
        nil
    )
    local ____opt_89 = self.Ability
    __TS__SparseArrayPush(
        ____array_97,
        ____opt_89 and ____opt_89:GetSpecialValueFor("SlashRadius")
    )
    local ____opt_91 = self.Ability
    __TS__SparseArrayPush(
        ____array_97,
        ____opt_91 and ____opt_91:GetAbilityTargetTeam()
    )
    local ____opt_93 = self.Ability
    __TS__SparseArrayPush(
        ____array_97,
        ____opt_93 and ____opt_93:GetAbilityTargetType()
    )
    local ____opt_95 = self.Ability
    __TS__SparseArrayPush(
        ____array_97,
        ____opt_95 and ____opt_95:GetAbilityTargetFlags()
    )
    local Targets = ____FindUnitsInLine_98(__TS__SparseArraySpread(____array_97))
    for ____, Iterator in ipairs(Targets) do
        local ____ApplyDamage_102 = ApplyDamage
        local ____self_Caster_101 = self.Caster
        local ____opt_99 = self.Ability
        ____ApplyDamage_102({
            victim = Iterator,
            attacker = ____self_Caster_101,
            damage = ____opt_99 and ____opt_99:GetSpecialValueFor("DmgPerSlash"),
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = self.Ability
        })
        local ____opt_103 = self.Caster
        if ____opt_103 and ____opt_103:HasModifier(____exports.musashi_modifier_tengan.name) then
            local ____Iterator_AddNewModifier_108 = Iterator.AddNewModifier
            local ____array_107 = __TS__SparseArrayNew(self.Caster, self.Ability, ____exports.musashi_modifier_ganryuu_jima_debuff.name)
            local ____opt_105 = self.Ability
            __TS__SparseArrayPush(
                ____array_107,
                {duration = ____opt_105 and ____opt_105:GetSpecialValueFor("DmgDelay")}
            )
            ____Iterator_AddNewModifier_108(
                Iterator,
                __TS__SparseArraySpread(____array_107)
            )
        end
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.CreateParticle(self)
    local ____opt_109 = self.Caster
    if ____opt_109 and ____opt_109:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_unique.vpcf"
    end
    local ParticleId = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    ParticleManager:SetParticleControl(ParticleId, 0, self.StartPosition)
    ParticleManager:SetParticleControl(ParticleId, 1, self.EndPosition)
end
function musashi_modifier_ganryuu_jima_slash.prototype.CheckState(self)
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
    local ____opt_111 = self.Caster
    local ModifierTengan = ____opt_111 and ____opt_111:FindModifierByName(____exports.musashi_modifier_tengan.name)
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
    local ____opt_113 = self.Caster
    if ____opt_113 and ____opt_113:HasModifier("modifier_ascended") then
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
    local ____opt_115 = self.Caster
    self.StartPosition = ____opt_115 and ____opt_115:GetAbsOrigin()
    local ____opt_117 = self.Ability
    self.SlashRange = ____opt_117 and ____opt_117:GetSpecialValueFor("SlashRange")
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_119 = self.Caster
    if ____opt_119 ~= nil then
        ____opt_119:SetForwardVector(self.NormalizedTargetPoint)
    end
    local ____opt_121 = self.Caster
    local CurrentOrigin = ____opt_121 and ____opt_121:GetAbsOrigin()
    local ____opt_123 = self.Ability
    local DashSpeed = ____opt_123 and ____opt_123:GetSpecialValueFor("DashSpeed")
    local ____opt_125 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_125 and ____opt_125:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_127 = self.Caster
    if ____opt_127 ~= nil then
        ____opt_127:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_131 = Entities.FindByNameWithin
    local ____opt_129 = self.Caster
    local Musashi = ____Entities_FindByNameWithin_131(
        Entities,
        nil,
        ____opt_129 and ____opt_129:GetName(),
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
    local ____opt_132 = self.Caster
    local DashCounter = ____opt_132 and ____opt_132:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
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
    local ____opt_136 = self.Caster
    if ____opt_136 ~= nil then
        ____opt_136:EmitSound(self.SoundVoiceline)
    end
    local ____opt_138 = self.Caster
    if ____opt_138 ~= nil then
        ____opt_138:EmitSound(self.SoundSfx)
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
    local ____opt_140 = self.Ability
    local DebuffDuration = ____opt_140 and ____opt_140:GetSpecialValueFor("DebuffDuration")
    local ____opt_142 = self.Caster
    if ____opt_142 ~= nil then
        ____opt_142:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_tenma_gogan_debuff.name, {duration = DebuffDuration})
    end
end
function musashi_modifier_tenma_gogan.prototype.CreateParticle(self)
    local ____opt_144 = self.Caster
    if ____opt_144 and ____opt_144:HasModifier("modifier_ascended") then
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
    local ____opt_146 = self.Caster
    if ____opt_146 ~= nil then
        ____opt_146:SwapAbilities(____exports.musashi_mukyuu.name, ____exports.musashi_tengen_no_hana.name, false, true)
    end
    self:PlaySound()
end
function musashi_mukyuu.prototype.PlaySound(self)
    local ____opt_148 = self.Caster
    if ____opt_148 ~= nil then
        ____opt_148:EmitSound(self.SoundVoiceline)
    end
    local ____opt_150 = self.Caster
    if ____opt_150 ~= nil then
        ____opt_150:EmitSound(self.SoundSfx)
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
function musashi_modifier_mukyuu.prototype.OnDestroy(self)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        if not IsServer() then
            return ____awaiter_resolve(nil)
        end
        __TS__Await(Sleep(nil, 5))
        local ____opt_152 = self.Caster
        if ____opt_152 ~= nil then
            ____opt_152:SwapAbilities(____exports.musashi_mukyuu.name, ____exports.musashi_tengen_no_hana.name, true, false)
        end
    end)
end
function musashi_modifier_mukyuu.prototype.CreateParticle(self)
    local ____opt_154 = self.Caster
    if ____opt_154 and ____opt_154:HasModifier("modifier_ascended") then
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
____exports.musashi_modifier_tengen_slot_checker = __TS__Class()
local musashi_modifier_tengen_slot_checker = ____exports.musashi_modifier_tengen_slot_checker
musashi_modifier_tengen_slot_checker.name = "musashi_modifier_tengen_slot_checker"
__TS__ClassExtends(musashi_modifier_tengen_slot_checker, BaseModifier)
function musashi_modifier_tengen_slot_checker.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.CallerName = ""
    self.TengenIndex = 0
end
function musashi_modifier_tengen_slot_checker.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    local ____opt_156 = self:GetAbility()
    self.CallerName = ____opt_156 and ____opt_156:GetName()
    local ____opt_160 = self.Caster
    local ____opt_158 = ____opt_160 and ____opt_160:FindAbilityByName(____exports.musashi_tengen_no_hana.name)
    self.TengenIndex = ____opt_158 and ____opt_158:GetAbilityIndex()
    local ____opt_164 = self.Caster
    local ____opt_162 = ____opt_164 and ____opt_164:FindAbilityByName(____exports.musashi_tengen_no_hana.name)
    if ____opt_162 ~= nil then
        ____opt_162:CastAbility()
    end
    local ____opt_166 = self.Caster
    if ____opt_166 ~= nil then
        ____opt_166:SwapAbilities(self.CallerName, ____exports.musashi_tengen_no_hana.name, false, true)
    end
end
function musashi_modifier_tengen_slot_checker.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local TengenCurrentIndex = self.Caster:FindAbilityByName(____exports.musashi_tengen_no_hana.name):GetAbilityIndex()
    if TengenCurrentIndex ~= self.TengenIndex then
        local ____opt_168 = self.Caster
        if ____opt_168 ~= nil then
            ____opt_168:SwapAbilities(self.CallerName, ____exports.musashi_tengen_no_hana.name, true, false)
        end
    end
end
function musashi_modifier_tengen_slot_checker.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_tengen_slot_checker.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_tengen_slot_checker.prototype.IsHidden(self)
    return true
end
musashi_modifier_tengen_slot_checker = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_tengen_slot_checker
)
____exports.musashi_modifier_tengen_slot_checker = musashi_modifier_tengen_slot_checker
____exports.musashi_tengen_no_hana = __TS__Class()
local musashi_tengen_no_hana = ____exports.musashi_tengen_no_hana
musashi_tengen_no_hana.name = "musashi_tengen_no_hana"
__TS__ClassExtends(musashi_tengen_no_hana, BaseAbility)
function musashi_tengen_no_hana.prototype.OnSpellStart(self)
    local ____opt_170 = self:GetCaster()
    local ModifierTengenNoHana = ____opt_170 and ____opt_170:FindModifierByName(____exports.musashi_modifier_tengen_no_hana.name)
    if ModifierTengenNoHana then
        ModifierTengenNoHana:Destroy()
        return
    end
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    local ____opt_172 = self:GetCaster()
    if ____opt_172 ~= nil then
        ____opt_172:AddNewModifier(
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
    local ____opt_174 = self.Ability
    self.Radius = ____opt_174 and ____opt_174:GetSpecialValueFor("Radius")
    self:StartIntervalThink(1)
    self:CreateParticle()
    local ____opt_176 = self.Caster
    if ____opt_176 ~= nil then
        ____opt_176:EmitSound(self.SoundSfx)
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
        local ____switch170 = stackCount
        local ____cond170 = ____switch170 == 0
        if ____cond170 then
            do
                local ____opt_178 = self.Ability
                self.Damage = ____opt_178 and ____opt_178:GetSpecialValueFor("Damage1")
                break
            end
        end
        ____cond170 = ____cond170 or ____switch170 == 1
        if ____cond170 then
            do
                local ____opt_180 = self.Ability
                self.Damage = ____opt_180 and ____opt_180:GetSpecialValueFor("Damage2")
                break
            end
        end
        ____cond170 = ____cond170 or ____switch170 == 2
        if ____cond170 then
            do
                local ____opt_182 = self.Ability
                self.Damage = ____opt_182 and ____opt_182:GetSpecialValueFor("Damage3")
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
    local ____opt_184 = self.Caster
    local ModifierTengenSlotChecker = ____opt_184 and ____opt_184:FindModifierByName(____exports.musashi_modifier_tengen_slot_checker.name)
    if ModifierTengenSlotChecker ~= nil then
        ModifierTengenSlotChecker:Destroy()
    end
    local ____opt_188 = self.Caster
    if ____opt_188 ~= nil then
        ____opt_188:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
    end
    self:DoDamage()
    self:CreateAoeParticle()
    EmitGlobalSound(self.SoundVoiceline)
end
function musashi_modifier_tengen_no_hana.prototype.DoDamage(self)
    local ____FindUnitsInRadius_201 = FindUnitsInRadius
    local ____opt_190 = self.Caster
    local ____array_200 = __TS__SparseArrayNew(____opt_190 and ____opt_190:GetTeam())
    local ____opt_192 = self.Caster
    __TS__SparseArrayPush(
        ____array_200,
        ____opt_192 and ____opt_192:GetAbsOrigin(),
        nil,
        self.Radius
    )
    local ____opt_194 = self.Ability
    __TS__SparseArrayPush(
        ____array_200,
        ____opt_194 and ____opt_194:GetAbilityTargetTeam()
    )
    local ____opt_196 = self.Ability
    __TS__SparseArrayPush(
        ____array_200,
        ____opt_196 and ____opt_196:GetAbilityTargetType()
    )
    local ____opt_198 = self.Ability
    __TS__SparseArrayPush(
        ____array_200,
        ____opt_198 and ____opt_198:GetAbilityTargetFlags(),
        FIND_ANY_ORDER,
        false
    )
    local Targets = ____FindUnitsInRadius_201(__TS__SparseArraySpread(____array_200))
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
    local ____opt_202 = self.Caster
    if ____opt_202 and ____opt_202:HasModifier("modifier_ascended") then
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
    local ____opt_204 = self.Caster
    if ____opt_204 and ____opt_204:HasModifier("modifier_ascended") then
        self.AoeParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique1.vpcf"
        self.AoeMarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique1.vpcf"
        if self.Caster:HasModifier(____exports.musashi_modifier_battle_continuation_active.name) then
            self.AoeParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique2.vpcf"
            self.AoeMarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique1.vpcf"
        end
    end
    local AoeParticle = ParticleManager:CreateParticle(self.AoeParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local AoeMarkerParticle = ParticleManager:CreateParticle(self.AoeMarkerParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ____ParticleManager_SetParticleControl_208 = ParticleManager.SetParticleControl
    local ____opt_206 = self.Caster
    ____ParticleManager_SetParticleControl_208(
        ParticleManager,
        AoeParticle,
        0,
        ____opt_206 and ____opt_206:GetAbsOrigin()
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
    local ____opt_209 = self.Caster
    local ____temp_213 = (____opt_209 and ____opt_209:GetHealth()) <= 0
    if ____temp_213 then
        local ____opt_211 = self.Ability
        ____temp_213 = ____opt_211 and ____opt_211:IsCooldownReady()
    end
    local ____temp_213_216 = ____temp_213
    if ____temp_213_216 then
        local ____opt_214 = self.Caster
        ____temp_213_216 = not (____opt_214 and ____opt_214:HasModifier(____exports.musashi_modifier_tenma_gogan_debuff.name))
    end
    if ____temp_213_216 then
        local BuffDuration = self.Ability:GetSpecialValueFor("BuffDuration")
        local ____opt_217 = self.Caster
        if ____opt_217 ~= nil then
            ____opt_217:SetHealth(1)
        end
        local ____opt_219 = self.Caster
        if ____opt_219 ~= nil then
            ____opt_219:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_battle_continuation_active.name, {duration = BuffDuration})
        end
        local ____opt_221 = self.Caster
        if ____opt_221 ~= nil then
            ____opt_221:AddNewModifier(
                self.Caster,
                self.Ability,
                ____exports.musashi_modifier_battle_continuation_cooldown.name,
                {duration = self.Ability:GetCooldown(1)}
            )
        end
        local ____opt_223 = self.Caster
        if ____opt_223 ~= nil then
            ____opt_223:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_tengen_slot_checker.name, {duration = 10})
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
    local ____opt_225 = self.Caster
    if ____opt_225 ~= nil then
        ____opt_225:Purge(
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
    local ____opt_227 = self.Caster
    if ____opt_227 ~= nil then
        local ____opt_227_Heal_230 = ____opt_227.Heal
        local ____opt_228 = self.Ability
        ____opt_227_Heal_230(
            ____opt_227,
            ____opt_228 and ____opt_228:GetSpecialValueFor("Heal"),
            self.Ability
        )
    end
end
function musashi_modifier_battle_continuation_active.prototype.PlaySound(self)
    local ____opt_232 = self.Caster
    if ____opt_232 ~= nil then
        ____opt_232:EmitSound(self.SoundVoiceline)
    end
    local ____opt_234 = self.Caster
    if ____opt_234 ~= nil then
        ____opt_234:EmitSound(self.SoundSfx)
    end
end
function musashi_modifier_battle_continuation_active.prototype.CreateParticle(self)
    local ____opt_236 = self.Caster
    if ____opt_236 and ____opt_236:HasModifier("modifier_ascended") then
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
    self.SoundSfx = "musashi_ishana_daitenshou_sfx"
    self.SoundBgm = "musashi_ishana_daitenshou_bgm"
end
function musashi_ishana_daitenshou.prototype.OnSpellStart(self)
    self.Caster = self:GetCaster()
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_ishana_daitenshou.name, {duration = 5})
    self:PlaySound()
end
function musashi_ishana_daitenshou.prototype.PlaySound(self)
    EmitGlobalSound(self.SoundVoiceline)
    EmitGlobalSound(self.SoundSfx)
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
    self.MarkerParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_marker_basic.vpcf"
    self.SwordParticle = "particles/custom/musashi/musashi_ishana_daitenshou_sword_basic.vpcf"
    self.BodyParticle = "particles/custom/musashi/musashi_ishana_daitenshou_body_basic.vpcf"
    self.MarkerPosition = Vector(0, 0, 0)
end
function musashi_modifier_ishana_daitenshou.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_238 = self.Ability
    self.Victim = ____opt_238 and ____opt_238:GetCursorTarget()
    local ____opt_240 = self.Victim
    self.MarkerPosition = ____opt_240 and ____opt_240:GetAbsOrigin()
    self:CreateParticle()
end
function musashi_modifier_ishana_daitenshou.prototype.CreateParticle(self)
    local ____opt_242 = self.Caster
    if ____opt_242 and ____opt_242:HasModifier("modifier_ascended") then
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
    ParticleManager:SetParticleControlEnt(
        BodyParticleId,
        0,
        self.Caster,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
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
return ____exports
