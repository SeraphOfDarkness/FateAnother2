local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
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
    local ____opt_0 = self.Niou
    if ____opt_0 ~= nil then
        ____opt_0:FaceTowards(self.TargetAoe)
    end
    return true
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseInterrupted(self)
    local ____opt_2 = self.NiouSkill
    if ____opt_2 ~= nil then
        ____opt_2:DestroyNiou(0)
    end
end
function musashi_niou_kurikara.prototype.OnSpellStart(self)
    self.DmgPerSlash = self:GetSpecialValueFor("DmgPerSlash")
    local ____opt_4 = self.Niou
    if ____opt_4 ~= nil then
        ____opt_4:StartGestureWithPlaybackRate(ACT_DOTA_CHANNEL_ABILITY_1, 1.1)
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
        local ____opt_6 = self.NiouSkill
        if ____opt_6 ~= nil then
            ____opt_6:DestroyNiou(0)
        end
    else
        local ____opt_8 = self.NiouSkill
        if ____opt_8 ~= nil then
            ____opt_8:DestroyNiou(1)
        end
    end
end
function musashi_niou_kurikara.prototype.DoDamage(self)
    local ____FindUnitsInRadius_12 = FindUnitsInRadius
    local ____opt_10 = self.Caster
    local Targets = ____FindUnitsInRadius_12(
        ____opt_10 and ____opt_10:GetTeam(),
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
end
function musashi_niou_kurikara.prototype.CreateParticle(self)
    local ____opt_13 = self.Caster
    if ____opt_13 and ____opt_13:HasModifier("modifier_ascended") then
        local AoeParticleStr = ""
        local CrackParticleStr = ""
        repeat
            local ____switch15 = self.SlashCount
            local ____cond15 = ____switch15 == 1
            if ____cond15 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond15 = ____cond15 or ____switch15 == 2
            if ____cond15 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond15 = ____cond15 or ____switch15 == 3
            if ____cond15 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire_crack.vpcf"
                    break
                end
            end
            ____cond15 = ____cond15 or ____switch15 == 4
            if ____cond15 then
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
    local ____opt_15 = self.NiouSkill
    if ____opt_15 ~= nil then
        ____opt_15:SetLevel(self:GetLevel())
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
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_ishana_daitenshou.name, {undefined = undefined})
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
    self.SwordParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_sword_basic.vpcf"
    self.BodyParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_body_basic.vpcf"
    self.MarkerPosition = Vector(0, 0, 0)
    self.StartPosition = Vector(0, 0, 0)
    self.CastedNiouKurikara = false
end
function musashi_modifier_ishana_daitenshou.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_17 = self.Ability
    self.Victim = ____opt_17 and ____opt_17:GetCursorTarget()
    local ____opt_19 = self.Victim
    self.MarkerPosition = ____opt_19 and ____opt_19:GetAbsOrigin()
    local ____opt_21 = self.Caster
    self.StartPosition = ____opt_21 and ____opt_21:GetAbsOrigin()
    local ____opt_23 = self.Caster
    local NiouKurikara = ____opt_23 and ____opt_23:FindAbilityByName(____exports.musashi_niou_kurikara.name)
    local ____opt_25 = self.Caster
    if ____opt_25 ~= nil then
        ____opt_25:CastAbilityOnPosition(
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
    local ____opt_27 = self.Caster
    if ____opt_27 and ____opt_27:IsChanneling() then
        self.CastedNiouKurikara = true
    end
    local ____self_CastedNiouKurikara_31 = self.CastedNiouKurikara
    if ____self_CastedNiouKurikara_31 then
        local ____opt_29 = self.Caster
        ____self_CastedNiouKurikara_31 = not (____opt_29 and ____opt_29:IsChanneling())
    end
    if ____self_CastedNiouKurikara_31 then
        local ____opt_32 = self.Ability
        local Radius = ____opt_32 and ____opt_32:GetSpecialValueFor("Radius")
        local ____Entities_FindByNameWithin_36 = Entities.FindByNameWithin
        local ____opt_34 = self.Victim
        local VictimInRadius = ____Entities_FindByNameWithin_36(
            Entities,
            nil,
            ____opt_34 and ____opt_34:GetName(),
            self.MarkerPosition,
            Radius
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
        local ____switch35 = stackCount
        local ____cond35 = ____switch35 == 0
        if ____cond35 then
            do
                local ____opt_37 = self.Caster
                if ____opt_37 ~= nil then
                    ____opt_37:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_dash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond35 = ____cond35 or ____switch35 == 1
        if ____cond35 then
            do
                local ____opt_39 = self.Caster
                if ____opt_39 ~= nil then
                    ____opt_39:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_slash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond35 = ____cond35 or ____switch35 == 2
        if ____cond35 then
            do
                self:Destroy()
                break
            end
        end
    until true
end
function musashi_modifier_ishana_daitenshou.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____FindClearSpaceForUnit_44 = FindClearSpaceForUnit
    local ____self_Caster_43 = self.Caster
    local ____opt_41 = self.Caster
    ____FindClearSpaceForUnit_44(
        ____self_Caster_43,
        ____opt_41 and ____opt_41:GetAbsOrigin(),
        true
    )
    local ____opt_45 = self.Caster
    if ____opt_45 ~= nil then
        ____opt_45:AddNewModifier(self.Caster, self.Ability, "modifier_phased", {duration = 1})
    end
end
function musashi_modifier_ishana_daitenshou.prototype.CreateParticle(self)
    local ____opt_47 = self.Caster
    if ____opt_47 and ____opt_47:HasModifier("modifier_ascended") then
        self.MarkerParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_marker_unique.vpcf"
        self.SwordParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_sword_unique.vpcf"
        self.BodyParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_body_unique.vpcf"
    end
    local MarkerParticle = ParticleManager:CreateParticle(self.MarkerParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local SwordParticle = ParticleManager:CreateParticle(self.SwordParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    local BodyParticle = ParticleManager:CreateParticle(self.BodyParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
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
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
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
    self.Ability = self:GetAbility()
    local ____opt_49 = self.Caster
    self.IshanaBuff = ____opt_49 and ____opt_49:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
    self:StartIntervalThink(0.03)
end
function musashi_modifier_ishana_daitenshou_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_51 = self.Ability
    local DashSpeed = ____opt_51 and ____opt_51:GetSpecialValueFor("DashSpeed")
    local ____opt_53 = self.Victim
    local ____temp_57 = ____opt_53 and ____opt_53:GetAbsOrigin()
    local ____opt_55 = self.Caster
    local Direction = (____temp_57 - (____opt_55 and ____opt_55:GetAbsOrigin())):Normalized()
    local ____opt_58 = self.Caster
    if ____opt_58 ~= nil then
        ____opt_58:SetForwardVector(Direction)
    end
    local ____opt_60 = self.Caster
    local ____temp_64 = ____opt_60 and ____opt_60:GetAbsOrigin()
    local ____opt_62 = self.Caster
    local NewPosition = ____temp_64 + (____opt_62 and ____opt_62:GetForwardVector()) * DashSpeed
    local ____opt_65 = self.Caster
    if ____opt_65 ~= nil then
        ____opt_65:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_72 = Entities.FindByNameWithin
    local ____opt_67 = self.Caster
    local ____temp_71 = ____opt_67 and ____opt_67:GetName()
    local ____opt_69 = self.Victim
    local Musashi = ____Entities_FindByNameWithin_72(
        Entities,
        nil,
        ____temp_71,
        ____opt_69 and ____opt_69:GetAbsOrigin(),
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
    local ____opt_73 = self.IshanaBuff
    if ____opt_73 ~= nil then
        ____opt_73:IncrementStackCount()
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
    self.SlashParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_slash_basic.vpcf"
    self.NormalSlashCount = 0
end
function musashi_modifier_ishana_daitenshou_slash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_75 = self.Caster
    self.IshanaBuff = ____opt_75 and ____opt_75:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
    local ____opt_77 = self.Ability
    self.NormalSlashCount = ____opt_77 and ____opt_77:GetSpecialValueFor("NormalSlashCount")
    local ____opt_79 = self.Ability
    local NormalSlashInterval = ____opt_79 and ____opt_79:GetSpecialValueFor("NormalSlashInterval")
    self:StartIntervalThink(NormalSlashInterval)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    if self.NormalSlashCount <= 5 then
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
    local ____opt_81 = self.Caster
    if ____opt_81 ~= nil then
        ____opt_81:StartGesture(ACT_DOTA_CAST_ABILITY_2)
    end
    self:CreateParticle()
    self:PerformFinalSlash()
    local ____opt_83 = self.IshanaBuff
    if ____opt_83 ~= nil then
        ____opt_83:IncrementStackCount()
    end
end
function musashi_modifier_ishana_daitenshou_slash.prototype.PerformFinalSlash(self)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____Sleep_87 = Sleep
        local ____opt_85 = self.Ability
        ____Sleep_87(
            nil,
            ____opt_85 and ____opt_85:GetSpecialValueFor("FinalSlashDmgDelay")
        )
        local ____opt_88 = self.Ability
        local FinalSlashMaxHpPercent = ____opt_88 and ____opt_88:GetSpecialValueFor("FinalSlashMaxHpPercent")
        local ____opt_90 = self.Ability
        local ExecuteThresholdPercent = ____opt_90 and ____opt_90:GetSpecialValueFor("ExecuteThresholdPercent")
        local ____opt_92 = self.Victim
        local Damage = (____opt_92 and ____opt_92:GetMaxHealth()) * FinalSlashMaxHpPercent / 100
        local ____ApplyDamage_98 = ApplyDamage
        local ____self_Victim_96 = self.Victim
        local ____self_Caster_97 = self.Caster
        local ____opt_94 = self.Ability
        ____ApplyDamage_98({
            victim = ____self_Victim_96,
            attacker = ____self_Caster_97,
            damage = Damage,
            damage_type = ____opt_94 and ____opt_94:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            ability = self.Ability
        })
        local ____opt_99 = self.Caster
        local CurrentHpPercentage = ____opt_99 and ____opt_99:GetHealthPercent()
        if CurrentHpPercentage <= ExecuteThresholdPercent then
            local ____opt_101 = self.Victim
            if ____opt_101 ~= nil then
                ____opt_101:ForceKill(false)
            end
        else
            local ____opt_103 = self.Ability
            local DebuffDuration = ____opt_103 and ____opt_103:GetSpecialValueFor("DebuffDuration")
            local ____opt_105 = self.Victim
            if ____opt_105 ~= nil then
                ____opt_105:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_debuff.name, {duration = DebuffDuration})
            end
        end
    end)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.DoDamage(self)
    local ____opt_107 = self.Ability
    local NormalSlashMaxHpPercent = ____opt_107 and ____opt_107:GetSpecialValueFor("NormalSlashMaxHpPercent")
    local ____opt_109 = self.Victim
    local Damage = (____opt_109 and ____opt_109:GetMaxHealth()) * NormalSlashMaxHpPercent / 100
    local ____ApplyDamage_115 = ApplyDamage
    local ____self_Victim_113 = self.Victim
    local ____self_Caster_114 = self.Caster
    local ____opt_111 = self.Ability
    ____ApplyDamage_115({
        victim = ____self_Victim_113,
        attacker = ____self_Caster_114,
        damage = Damage,
        damage_type = ____opt_111 and ____opt_111:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self.Ability
    })
end
function musashi_modifier_ishana_daitenshou_slash.prototype.CreateParticle(self)
    local ____opt_116 = self.Caster
    if ____opt_116 and ____opt_116:HasModifier("modifier_ascended") then
        self.SlashParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_slash_unique.vpcf"
        local PetalsParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_petals_unique.vpcf"
        local PetalsParticle = ParticleManager:CreateParticle(PetalsParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        local ____ParticleManager_SetParticleControl_120 = ParticleManager.SetParticleControl
        local ____opt_118 = self.Victim
        ____ParticleManager_SetParticleControl_120(
            ParticleManager,
            PetalsParticle,
            0,
            ____opt_118 and ____opt_118:GetAbsOrigin()
        )
        local ____ParticleManager_SetParticleControl_123 = ParticleManager.SetParticleControl
        local ____opt_121 = self.Victim
        ____ParticleManager_SetParticleControl_123(
            ParticleManager,
            PetalsParticle,
            2,
            ____opt_121 and ____opt_121:GetAbsOrigin()
        )
        ParticleManager:SetParticleControl(
            PetalsParticle,
            3,
            self.Caster:GetAbsOrigin()
        )
    end
    local SlashParticle = ParticleManager:CreateParticle(self.SlashParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ____ParticleManager_SetParticleControl_126 = ParticleManager.SetParticleControl
    local ____opt_124 = self.IshanaBuff
    ____ParticleManager_SetParticleControl_126(ParticleManager, SlashParticle, 0, ____opt_124 and ____opt_124.StartPosition)
    local ____ParticleManager_SetParticleControl_129 = ParticleManager.SetParticleControl
    local ____opt_127 = self.Victim
    ____ParticleManager_SetParticleControl_129(
        ParticleManager,
        SlashParticle,
        1,
        ____opt_127 and ____opt_127:GetAbsOrigin()
    )
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
function musashi_modifier_ishana_daitenshou_debuff.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_130 = self.Caster
    self.IshanaBuff = ____opt_130 and ____opt_130:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierExtraHealthPercentage(self)
    local ____opt_132 = self.Ability
    return ____opt_132 and ____opt_132:GetSpecialValueFor("MaxHpReductionPercent")
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_134 = self.Ability
    return ____opt_134 and ____opt_134:GetSpecialValueFor("ExtraIncomingDmgPercent")
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
        local ____opt_136 = self.Niou
        if ____opt_136 ~= nil then
            ____opt_136:ForceKill(false)
        end
        Sleep(nil, delay)
        local ____opt_138 = self.Niou
        if ____opt_138 ~= nil then
            ____opt_138:Destroy()
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
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
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
