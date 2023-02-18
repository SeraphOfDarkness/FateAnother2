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
    self.CastedNiouKurikara = false
end
function musashi_modifier_ishana_daitenshou.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_0 = self.Ability
    self.Victim = ____opt_0 and ____opt_0:GetCursorTarget()
    local ____opt_2 = self.Victim
    self.MarkerPosition = ____opt_2 and ____opt_2:GetAbsOrigin()
    local ____opt_4 = self.Caster
    local NiouKurikara = ____opt_4 and ____opt_4:FindAbilityByName("musashi_niou_kurikara.name")
    local ____opt_6 = self.Caster
    if ____opt_6 ~= nil then
        ____opt_6:CastAbilityOnPosition(
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
    local ____opt_8 = self.Caster
    if ____opt_8 and ____opt_8:IsChanneling() then
        self.CastedNiouKurikara = true
    end
    local ____self_CastedNiouKurikara_12 = self.CastedNiouKurikara
    if ____self_CastedNiouKurikara_12 then
        local ____opt_10 = self.Caster
        ____self_CastedNiouKurikara_12 = not (____opt_10 and ____opt_10:IsChanneling())
    end
    if ____self_CastedNiouKurikara_12 then
        local ____opt_13 = self.Ability
        local Radius = ____opt_13 and ____opt_13:GetSpecialValueFor("Radius")
        local ____Entities_FindByNameWithin_17 = Entities.FindByNameWithin
        local ____opt_15 = self.Victim
        local VictimInRadius = ____Entities_FindByNameWithin_17(
            Entities,
            nil,
            ____opt_15 and ____opt_15:GetName(),
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
        local ____switch14 = stackCount
        local ____cond14 = ____switch14 == 0
        if ____cond14 then
            do
                local ____opt_18 = self.Caster
                if ____opt_18 ~= nil then
                    ____opt_18:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_dash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond14 = ____cond14 or ____switch14 == 1
        if ____cond14 then
            do
                local ____opt_20 = self.Caster
                if ____opt_20 ~= nil then
                    ____opt_20:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_slash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond14 = ____cond14 or ____switch14 == 2
        if ____cond14 then
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
    local ____FindClearSpaceForUnit_25 = FindClearSpaceForUnit
    local ____self_Caster_24 = self.Caster
    local ____opt_22 = self.Caster
    ____FindClearSpaceForUnit_25(
        ____self_Caster_24,
        ____opt_22 and ____opt_22:GetAbsOrigin(),
        true
    )
    local ____opt_26 = self.Caster
    if ____opt_26 ~= nil then
        ____opt_26:AddNewModifier(self.Caster, self.Ability, "modifier_phased", {duration = 1})
    end
end
function musashi_modifier_ishana_daitenshou.prototype.CreateParticle(self)
    local ____opt_28 = self.Caster
    if ____opt_28 and ____opt_28:HasModifier("modifier_ascended") then
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
    local ____opt_30 = self.Caster
    self.IshanaBuff = ____opt_30 and ____opt_30:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
    self:StartIntervalThink(0.03)
end
function musashi_modifier_ishana_daitenshou_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_32 = self.Ability
    local DashSpeed = ____opt_32 and ____opt_32:GetSpecialValueFor("DashSpeed")
    local ____opt_34 = self.Victim
    local ____temp_38 = ____opt_34 and ____opt_34:GetAbsOrigin()
    local ____opt_36 = self.Caster
    local Direction = (____temp_38 - (____opt_36 and ____opt_36:GetAbsOrigin())):Normalized()
    local ____opt_39 = self.Caster
    if ____opt_39 ~= nil then
        ____opt_39:SetForwardVector(Direction)
    end
    local ____opt_41 = self.Caster
    local ____temp_45 = ____opt_41 and ____opt_41:GetAbsOrigin()
    local ____opt_43 = self.Caster
    local NewPosition = ____temp_45 + (____opt_43 and ____opt_43:GetForwardVector()) * DashSpeed
    local ____opt_46 = self.Caster
    if ____opt_46 ~= nil then
        ____opt_46:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_53 = Entities.FindByNameWithin
    local ____opt_48 = self.Caster
    local ____temp_52 = ____opt_48 and ____opt_48:GetName()
    local ____opt_50 = self.Victim
    local Musashi = ____Entities_FindByNameWithin_53(
        Entities,
        nil,
        ____temp_52,
        ____opt_50 and ____opt_50:GetAbsOrigin(),
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
    local ____opt_54 = self.IshanaBuff
    if ____opt_54 ~= nil then
        ____opt_54:IncrementStackCount()
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
    self.NormalSlashCount = 0
end
function musashi_modifier_ishana_daitenshou_slash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_56 = self.Caster
    self.IshanaBuff = ____opt_56 and ____opt_56:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
    local ____opt_58 = self.Ability
    self.NormalSlashCount = ____opt_58 and ____opt_58:GetSpecialValueFor("NormalSlashCount")
    local ____opt_60 = self.Ability
    local NormalSlashInterval = ____opt_60 and ____opt_60:GetSpecialValueFor("NormalSlashInterval")
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
    local ____opt_62 = self.Caster
    if ____opt_62 ~= nil then
        ____opt_62:StartGesture(ACT_DOTA_CAST_ABILITY_2)
    end
    self:PerformFinalSlash()
    local ____opt_64 = self.IshanaBuff
    if ____opt_64 ~= nil then
        ____opt_64:IncrementStackCount()
    end
end
function musashi_modifier_ishana_daitenshou_slash.prototype.PerformFinalSlash(self)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____Sleep_68 = Sleep
        local ____opt_66 = self.Ability
        ____Sleep_68(
            nil,
            ____opt_66 and ____opt_66:GetSpecialValueFor("FinalSlashDmgDelay")
        )
        local ____opt_69 = self.Ability
        local FinalSlashMaxHpPercent = ____opt_69 and ____opt_69:GetSpecialValueFor("FinalSlashMaxHpPercent")
        local ____opt_71 = self.Ability
        local ExecuteThresholdPercent = ____opt_71 and ____opt_71:GetSpecialValueFor("ExecuteThresholdPercent")
        local ____opt_73 = self.Victim
        local Damage = (____opt_73 and ____opt_73:GetMaxHealth()) * FinalSlashMaxHpPercent / 100
        local ____ApplyDamage_79 = ApplyDamage
        local ____self_Victim_77 = self.Victim
        local ____self_Caster_78 = self.Caster
        local ____opt_75 = self.Ability
        ____ApplyDamage_79({
            victim = ____self_Victim_77,
            attacker = ____self_Caster_78,
            damage = Damage,
            damage_type = ____opt_75 and ____opt_75:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            ability = self.Ability
        })
        local ____opt_80 = self.Caster
        local CurrentHpPercentage = ____opt_80 and ____opt_80:GetHealthPercent()
        if CurrentHpPercentage <= ExecuteThresholdPercent then
            local ____opt_82 = self.Victim
            if ____opt_82 ~= nil then
                ____opt_82:ForceKill(false)
            end
        else
            local ____opt_84 = self.Ability
            local DebuffDuration = ____opt_84 and ____opt_84:GetSpecialValueFor("DebuffDuration")
            local ____opt_86 = self.Victim
            if ____opt_86 ~= nil then
                ____opt_86:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_debuff.name, {duration = DebuffDuration})
            end
        end
    end)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.DoDamage(self)
    local ____opt_88 = self.Ability
    local NormalSlashMaxHpPercent = ____opt_88 and ____opt_88:GetSpecialValueFor("NormalSlashMaxHpPercent")
    local ____opt_90 = self.Victim
    local Damage = (____opt_90 and ____opt_90:GetMaxHealth()) * NormalSlashMaxHpPercent / 100
    local ____ApplyDamage_96 = ApplyDamage
    local ____self_Victim_94 = self.Victim
    local ____self_Caster_95 = self.Caster
    local ____opt_92 = self.Ability
    ____ApplyDamage_96({
        victim = ____self_Victim_94,
        attacker = ____self_Caster_95,
        damage = Damage,
        damage_type = ____opt_92 and ____opt_92:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self.Ability
    })
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
    local ____opt_97 = self.Caster
    self.IshanaBuff = ____opt_97 and ____opt_97:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierExtraHealthPercentage(self)
    local ____opt_99 = self.Ability
    return ____opt_99 and ____opt_99:GetSpecialValueFor("MaxHpReductionPercent")
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_101 = self.Ability
    return ____opt_101 and ____opt_101:GetSpecialValueFor("ExtraIncomingDmgPercent")
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
        local ____opt_103 = self.Niou
        if ____opt_103 ~= nil then
            ____opt_103:ForceKill(false)
        end
        Sleep(nil, delay)
        local ____opt_105 = self.Niou
        if ____opt_105 ~= nil then
            ____opt_105:Destroy()
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
