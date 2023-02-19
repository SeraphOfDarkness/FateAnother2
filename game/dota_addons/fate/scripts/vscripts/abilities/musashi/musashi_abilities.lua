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
    local ____temp_2 = not IsServer()
    if not ____temp_2 then
        local ____opt_0 = self.Caster
        ____temp_2 = not (____opt_0 and ____opt_0:HasModifier("musashi_attribute_battle_continuation.name"))
    end
    if ____temp_2 then
        return
    end
    local ____temp_5 = self.Caster:GetHealth() <= 0
    if ____temp_5 then
        local ____opt_3 = self.Ability
        ____temp_5 = ____opt_3 and ____opt_3:IsCooldownReady()
    end
    if ____temp_5 and self.Caster:HasModifier("musashi_modifier_tenma_gogan_debuff.name") then
        local BuffDuration = self.Ability:GetSpecialValueFor("BuffDuration")
        self.Caster:SetHealth(1)
        self.Caster:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_battle_continuation_active.name, {duration = BuffDuration})
        self.Caster:AddNewModifier(
            self.Caster,
            self.Ability,
            ____exports.musashi_modifier_battle_continuation_cooldown.name,
            {duration = self.Ability:GetCooldown(1)}
        )
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
    local ____opt_6 = self.Caster
    if ____opt_6 ~= nil then
        ____opt_6:Purge(
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
    local ____opt_8 = self.Ability
    local Heal = ____opt_8 and ____opt_8:GetSpecialValueFor("Heal")
    local ____opt_10 = self.Caster
    if ____opt_10 ~= nil then
        ____opt_10:Heal(Heal, self.Ability)
    end
end
function musashi_modifier_battle_continuation_active.prototype.CreateParticle(self)
    local ____opt_12 = self.Caster
    if ____opt_12 and ____opt_12:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_battle_continuation_unique.vpcf"
    end
    local Particle = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
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
function musashi_modifier_battle_continuation_active.prototype.PlaySound(self)
    local ____opt_14 = self.Caster
    if ____opt_14 ~= nil then
        ____opt_14:EmitSound(self.SoundVoiceline)
    end
    local ____opt_16 = self.Caster
    if ____opt_16 ~= nil then
        ____opt_16:EmitSound(self.SoundSfx)
    end
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
    self.Caster = self:GetCaster()
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_ishana_daitenshou.name, {undefined = undefined})
    self.Caster:AddNewModifier(
        self.Caster,
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
    local ____opt_18 = self.Ability
    self.Victim = ____opt_18 and ____opt_18:GetCursorTarget()
    local ____opt_20 = self.Victim
    self.MarkerPosition = ____opt_20 and ____opt_20:GetAbsOrigin()
    local ____opt_22 = self.Caster
    self.StartPosition = ____opt_22 and ____opt_22:GetAbsOrigin()
    local ____opt_24 = self.Caster
    local NiouKurikara = ____opt_24 and ____opt_24:FindAbilityByName("musashi_niou_kurikara.name")
    local ____opt_26 = self.Caster
    if ____opt_26 ~= nil then
        ____opt_26:CastAbilityOnPosition(
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
    local ____opt_28 = self.Caster
    if ____opt_28 and ____opt_28:IsChanneling() then
        self.CastedNiouKurikara = true
    end
    local ____self_CastedNiouKurikara_32 = self.CastedNiouKurikara
    if ____self_CastedNiouKurikara_32 then
        local ____opt_30 = self.Caster
        ____self_CastedNiouKurikara_32 = not (____opt_30 and ____opt_30:IsChanneling())
    end
    if ____self_CastedNiouKurikara_32 then
        local ____opt_33 = self.Ability
        local Radius = ____opt_33 and ____opt_33:GetSpecialValueFor("Radius")
        local ____Entities_FindByNameWithin_37 = Entities.FindByNameWithin
        local ____opt_35 = self.Victim
        local VictimInRadius = ____Entities_FindByNameWithin_37(
            Entities,
            nil,
            ____opt_35 and ____opt_35:GetName(),
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
        local ____switch40 = stackCount
        local ____cond40 = ____switch40 == 0
        if ____cond40 then
            do
                local ____opt_38 = self.Caster
                if ____opt_38 ~= nil then
                    ____opt_38:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_dash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond40 = ____cond40 or ____switch40 == 1
        if ____cond40 then
            do
                local ____opt_40 = self.Caster
                if ____opt_40 ~= nil then
                    ____opt_40:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_slash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond40 = ____cond40 or ____switch40 == 2
        if ____cond40 then
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
    local ____FindClearSpaceForUnit_45 = FindClearSpaceForUnit
    local ____self_Caster_44 = self.Caster
    local ____opt_42 = self.Caster
    ____FindClearSpaceForUnit_45(
        ____self_Caster_44,
        ____opt_42 and ____opt_42:GetAbsOrigin(),
        true
    )
    local ____opt_46 = self.Caster
    if ____opt_46 ~= nil then
        ____opt_46:SetForwardVector(self.Caster:GetAbsOrigin():Normalized() * 10)
    end
    local ____opt_48 = self.Caster
    if ____opt_48 ~= nil then
        ____opt_48:AddNewModifier(self.Caster, self.Ability, "modifier_phased", {duration = 1})
    end
end
function musashi_modifier_ishana_daitenshou.prototype.CreateParticle(self)
    local ____opt_50 = self.Caster
    if ____opt_50 and ____opt_50:HasModifier("modifier_ascended") then
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
    self.Ability = self:GetAbility()
    local ____opt_52 = self.Caster
    self.IshanaBuff = ____opt_52 and ____opt_52:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
    self:StartIntervalThink(0.03)
end
function musashi_modifier_ishana_daitenshou_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_54 = self.Ability
    local DashSpeed = ____opt_54 and ____opt_54:GetSpecialValueFor("DashSpeed")
    local ____opt_56 = self.Victim
    local ____temp_60 = ____opt_56 and ____opt_56:GetAbsOrigin()
    local ____opt_58 = self.Caster
    local Direction = (____temp_60 - (____opt_58 and ____opt_58:GetAbsOrigin())):Normalized()
    local ____opt_61 = self.Caster
    if ____opt_61 ~= nil then
        ____opt_61:SetForwardVector(Direction)
    end
    local ____opt_63 = self.Caster
    local ____temp_67 = ____opt_63 and ____opt_63:GetAbsOrigin()
    local ____opt_65 = self.Caster
    local NewPosition = ____temp_67 + (____opt_65 and ____opt_65:GetForwardVector()) * DashSpeed
    local ____opt_68 = self.Caster
    if ____opt_68 ~= nil then
        ____opt_68:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_75 = Entities.FindByNameWithin
    local ____opt_70 = self.Caster
    local ____temp_74 = ____opt_70 and ____opt_70:GetName()
    local ____opt_72 = self.Victim
    local Musashi = ____Entities_FindByNameWithin_75(
        Entities,
        nil,
        ____temp_74,
        ____opt_72 and ____opt_72:GetAbsOrigin(),
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
    local ____opt_76 = self.IshanaBuff
    if ____opt_76 ~= nil then
        ____opt_76:IncrementStackCount()
    end
end
function musashi_modifier_ishana_daitenshou_dash.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ishana_daitenshou_dash.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_ishana_daitenshou_dash.prototype.IsHidden(self)
    return true
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
    local ____opt_78 = self.Caster
    self.IshanaBuff = ____opt_78 and ____opt_78:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
    local ____opt_80 = self.Ability
    local NormalSlashInterval = ____opt_80 and ____opt_80:GetSpecialValueFor("NormalSlashInterval")
    local ____opt_82 = self.Ability
    self.NormalSlashCount = ____opt_82 and ____opt_82:GetSpecialValueFor("NormalSlashCount")
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
    local ____opt_84 = self.Caster
    if ____opt_84 ~= nil then
        ____opt_84:StartGesture(ACT_DOTA_CAST_ABILITY_2)
    end
    self:CreateParticle()
    self:PerformFinalSlash()
    local ____opt_86 = self.IshanaBuff
    if ____opt_86 ~= nil then
        ____opt_86:IncrementStackCount()
    end
end
function musashi_modifier_ishana_daitenshou_slash.prototype.PerformFinalSlash(self)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____opt_88 = self.Ability
        local FinalSlashDmgDelay = ____opt_88 and ____opt_88:GetSpecialValueFor("FinalSlashDmgDelay")
        Sleep(nil, FinalSlashDmgDelay)
        local ____opt_90 = self.Ability
        local FinalSlashMaxHpPercent = ____opt_90 and ____opt_90:GetSpecialValueFor("FinalSlashMaxHpPercent")
        local ____opt_92 = self.Ability
        local ExecuteThresholdPercent = ____opt_92 and ____opt_92:GetSpecialValueFor("ExecuteThresholdPercent")
        local ____opt_94 = self.Victim
        local Damage = (____opt_94 and ____opt_94:GetMaxHealth()) * FinalSlashMaxHpPercent / 100
        local ____ApplyDamage_100 = ApplyDamage
        local ____self_Victim_98 = self.Victim
        local ____self_Caster_99 = self.Caster
        local ____opt_96 = self.Ability
        ____ApplyDamage_100({
            victim = ____self_Victim_98,
            attacker = ____self_Caster_99,
            damage = Damage,
            damage_type = ____opt_96 and ____opt_96:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            ability = self.Ability
        })
        local ____opt_101 = self.Caster
        local CurrentHpPercentage = ____opt_101 and ____opt_101:GetHealthPercent()
        if CurrentHpPercentage <= ExecuteThresholdPercent then
            local ____opt_103 = self.Victim
            if ____opt_103 ~= nil then
                ____opt_103:ForceKill(false)
            end
        else
            local ____opt_105 = self.Ability
            local DebuffDuration = ____opt_105 and ____opt_105:GetSpecialValueFor("DebuffDuration")
            local ____opt_107 = self.Victim
            if ____opt_107 ~= nil then
                ____opt_107:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_debuff.name, {duration = DebuffDuration})
            end
        end
    end)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.DoDamage(self)
    local ____opt_109 = self.Ability
    local NormalSlashMaxHpPercent = ____opt_109 and ____opt_109:GetSpecialValueFor("NormalSlashMaxHpPercent")
    local ____opt_111 = self.Victim
    local Damage = (____opt_111 and ____opt_111:GetMaxHealth()) * NormalSlashMaxHpPercent / 100
    local ____ApplyDamage_117 = ApplyDamage
    local ____self_Victim_115 = self.Victim
    local ____self_Caster_116 = self.Caster
    local ____opt_113 = self.Ability
    ____ApplyDamage_117({
        victim = ____self_Victim_115,
        attacker = ____self_Caster_116,
        damage = Damage,
        damage_type = ____opt_113 and ____opt_113:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self.Ability
    })
end
function musashi_modifier_ishana_daitenshou_slash.prototype.CreateParticle(self)
    local ____opt_118 = self.Caster
    if ____opt_118 and ____opt_118:HasModifier("modifier_ascended") then
        self.SlashParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_slash_unique.vpcf"
        local PetalsParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_petals_unique.vpcf"
        local PetalsParticle = ParticleManager:CreateParticle(PetalsParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        local ____ParticleManager_SetParticleControl_122 = ParticleManager.SetParticleControl
        local ____opt_120 = self.Victim
        ____ParticleManager_SetParticleControl_122(
            ParticleManager,
            PetalsParticle,
            0,
            ____opt_120 and ____opt_120:GetAbsOrigin()
        )
        local ____ParticleManager_SetParticleControl_125 = ParticleManager.SetParticleControl
        local ____opt_123 = self.Victim
        ____ParticleManager_SetParticleControl_125(
            ParticleManager,
            PetalsParticle,
            2,
            ____opt_123 and ____opt_123:GetAbsOrigin()
        )
        ParticleManager:SetParticleControl(
            PetalsParticle,
            3,
            self.Caster:GetAbsOrigin()
        )
    end
    local SlashParticle = ParticleManager:CreateParticle(self.SlashParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ____ParticleManager_SetParticleControl_128 = ParticleManager.SetParticleControl
    local ____opt_126 = self.IshanaBuff
    ____ParticleManager_SetParticleControl_128(ParticleManager, SlashParticle, 0, ____opt_126 and ____opt_126.StartPosition)
    local ____ParticleManager_SetParticleControl_131 = ParticleManager.SetParticleControl
    local ____opt_129 = self.Victim
    ____ParticleManager_SetParticleControl_131(
        ParticleManager,
        SlashParticle,
        1,
        ____opt_129 and ____opt_129:GetAbsOrigin()
    )
end
function musashi_modifier_ishana_daitenshou_slash.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ishana_daitenshou_slash.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_ishana_daitenshou_slash.prototype.IsHidden(self)
    return true
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
    local ____opt_132 = self.Caster
    self.IshanaBuff = ____opt_132 and ____opt_132:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierExtraHealthPercentage(self)
    local ____opt_134 = self.Ability
    return ____opt_134 and ____opt_134:GetSpecialValueFor("MaxHpReductionPercent")
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_136 = self.Ability
    return ____opt_136 and ____opt_136:GetSpecialValueFor("ExtraIncomingDmgPercent")
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.IsDebuff(self)
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
        local ____opt_138 = self.Niou
        if ____opt_138 ~= nil then
            ____opt_138:ForceKill(false)
        end
        Sleep(nil, delay)
        local ____opt_140 = self.Niou
        if ____opt_140 ~= nil then
            ____opt_140:Destroy()
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
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
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
