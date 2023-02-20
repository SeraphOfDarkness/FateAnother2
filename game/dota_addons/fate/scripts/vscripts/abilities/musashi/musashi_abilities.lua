local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
local ____dota_ts_adapter = require("libs.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerAbility = ____dota_ts_adapter.registerAbility
local registerModifier = ____dota_ts_adapter.registerModifier
local ____sleep_timer = require("libs.sleep_timer")
local Sleep = ____sleep_timer.Sleep
local musashi_attributes = require("abilities.musashi.musashi_attributes")
____exports.musashi_tenma_gogan = __TS__Class()
local musashi_tenma_gogan = ____exports.musashi_tenma_gogan
musashi_tenma_gogan.name = "musashi_tenma_gogan"
__TS__ClassExtends(musashi_tenma_gogan, BaseAbility)
function musashi_tenma_gogan.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_ability_manavoid_05"
    self.SoundSfx = "musashi_tengan_sfx"
end
function musashi_tenma_gogan.prototype.OnAbilityPhaseStart(self)
    self.Caster = self:GetCaster()
    local Tengan = self.Caster:FindAbilityByName("musashi_tengan")
    local MaxCharges = Tengan and Tengan:GetSpecialValueFor("MaxCharges")
    local ____opt_2 = self.Caster:FindModifierByName("musashi_modifier_tengan_charge_counter")
    local TenganChargeCounter = ____opt_2 and ____opt_2:GetStackCount()
    if TenganChargeCounter >= MaxCharges - 1 then
        return true
    else
        return false
    end
end
function musashi_tenma_gogan.prototype.OnSpellStart(self)
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    local ____opt_4 = self.Caster
    if ____opt_4 ~= nil then
        ____opt_4:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_tenma_gogan.name, {duration = BuffDuration})
    end
    self:PlaySound()
end
function musashi_tenma_gogan.prototype.PlaySound(self)
    local ____opt_6 = self.Caster
    if ____opt_6 ~= nil then
        ____opt_6:EmitSound(self.SoundVoiceline)
    end
    local ____opt_8 = self.Caster
    if ____opt_8 ~= nil then
        ____opt_8:EmitSound(self.SoundSfx)
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
    self:CreateParticle()
end
function musashi_modifier_tenma_gogan.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local Ability = self:GetAbility()
    local DebuffDuration = Ability and Ability:GetSpecialValueFor("DebuffDuration")
    local ____opt_12 = self.Caster
    if ____opt_12 ~= nil then
        ____opt_12:AddNewModifier(self.Caster, Ability, ____exports.musashi_modifier_tenma_gogan_debuff.name, {duration = DebuffDuration})
    end
end
function musashi_modifier_tenma_gogan.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_tenma_gogan_basic.vpcf"
    local BodyParticleStr = "particles/custom/musashi/musashi_tenma_gogan_body.vpcf"
    local ____opt_14 = self.Caster
    if ____opt_14 and ____opt_14:HasModifier("modifier_ascended") then
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
    return true
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
    giveUnitDataDrivenModifier(Caster, Caster, "pause_sealdisabled", 2)
end
function musashi_modifier_tenma_gogan_debuff.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_tenma_gogan_debuff.prototype.IsPurgeException(self)
    return false
end
function musashi_modifier_tenma_gogan_debuff.prototype.IsStunDebuff(self)
    return true
end
function musashi_modifier_tenma_gogan_debuff.prototype.IsDebuff(self)
    return true
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
end
function musashi_modifier_battle_continuation.prototype.OnTakeDamage(self)
    local Caster = self:GetCaster()
    local Ability = self:GetAbility()
    if not IsServer() or not (Caster and Caster:HasModifier(musashi_attributes.musashi_attribute_battle_continuation.name)) then
        return
    end
    if Caster:GetHealth() <= 0 and (Ability and Ability:IsFullyCastable()) and not Caster:HasModifier("musashi_modifier_tenma_gogan_debuff.name") then
        local BuffDuration = Ability:GetSpecialValueFor("BuffDuration")
        Caster:SetHealth(1)
        Caster:AddNewModifier(Caster, Ability, ____exports.musashi_modifier_battle_continuation_active.name, {duration = BuffDuration})
        Caster:AddNewModifier(
            Caster,
            Ability,
            ____exports.musashi_modifier_battle_continuation_cooldown.name,
            {duration = Ability:GetCooldown(1)}
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
end
function musashi_modifier_battle_continuation_active.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    local ____opt_20 = self.Caster
    if ____opt_20 ~= nil then
        ____opt_20:Purge(
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
    local Ability = self:GetAbility()
    local Heal = Ability and Ability:GetSpecialValueFor("Heal")
    local ____opt_24 = self.Caster
    if ____opt_24 ~= nil then
        ____opt_24:Heal(Heal, Ability)
    end
end
function musashi_modifier_battle_continuation_active.prototype.CreateParticle(self)
    local ParticleStr = "particles/custom/musashi/musashi_battle_continuation_basic.vpcf"
    local ____opt_26 = self.Caster
    if ____opt_26 and ____opt_26:HasModifier("modifier_ascended") then
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
function musashi_modifier_battle_continuation_active.prototype.PlaySound(self)
    local ____opt_28 = self.Caster
    if ____opt_28 ~= nil then
        ____opt_28:EmitSound(self.SoundVoiceline)
    end
    local ____opt_30 = self.Caster
    if ____opt_30 ~= nil then
        ____opt_30:EmitSound(self.SoundSfx)
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
    local Caster = self:GetCaster()
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
    local ____opt_32 = self.Ability
    self.Victim = ____opt_32 and ____opt_32:GetCursorTarget()
    local ____opt_34 = self.Victim
    self.MarkerPosition = ____opt_34 and ____opt_34:GetAbsOrigin()
    local ____opt_36 = self.Caster
    self.StartPosition = ____opt_36 and ____opt_36:GetAbsOrigin()
    local ____opt_38 = self.Caster
    local NiouKurikara = ____opt_38 and ____opt_38:FindAbilityByName("musashi_niou_kurikara.name")
    local ____opt_40 = self.Caster
    if ____opt_40 ~= nil then
        ____opt_40:CastAbilityOnPosition(
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
    local ____opt_42 = self.Caster
    if ____opt_42 and ____opt_42:IsChanneling() then
        self.CastedNiouKurikara = true
    end
    local ____self_CastedNiouKurikara_46 = self.CastedNiouKurikara
    if ____self_CastedNiouKurikara_46 then
        local ____opt_44 = self.Caster
        ____self_CastedNiouKurikara_46 = not (____opt_44 and ____opt_44:IsChanneling())
    end
    if ____self_CastedNiouKurikara_46 then
        local ____opt_47 = self.Ability
        local Radius = ____opt_47 and ____opt_47:GetSpecialValueFor("Radius")
        local ____Entities_FindByNameWithin_51 = Entities.FindByNameWithin
        local ____opt_49 = self.Victim
        local VictimInRadius = ____Entities_FindByNameWithin_51(
            Entities,
            nil,
            ____opt_49 and ____opt_49:GetName(),
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
        local ____switch59 = stackCount
        local ____cond59 = ____switch59 == 0
        if ____cond59 then
            do
                local ____opt_52 = self.Caster
                if ____opt_52 ~= nil then
                    ____opt_52:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_dash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond59 = ____cond59 or ____switch59 == 1
        if ____cond59 then
            do
                local ____opt_54 = self.Caster
                if ____opt_54 ~= nil then
                    ____opt_54:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_slash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond59 = ____cond59 or ____switch59 == 2
        if ____cond59 then
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
    local ____FindClearSpaceForUnit_59 = FindClearSpaceForUnit
    local ____self_Caster_58 = self.Caster
    local ____opt_56 = self.Caster
    ____FindClearSpaceForUnit_59(
        ____self_Caster_58,
        ____opt_56 and ____opt_56:GetAbsOrigin(),
        true
    )
    local ____opt_60 = self.Caster
    if ____opt_60 ~= nil then
        ____opt_60:SetForwardVector(self.Caster:GetAbsOrigin():Normalized() * 10)
    end
    local ____opt_62 = self.Caster
    if ____opt_62 ~= nil then
        ____opt_62:AddNewModifier(self.Caster, self.Ability, "modifier_phased", {duration = 1})
    end
end
function musashi_modifier_ishana_daitenshou.prototype.CreateParticle(self)
    local MarkerParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_marker_basic.vpcf"
    local SwordParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_sword_basic.vpcf"
    local BodyParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_body_basic.vpcf"
    local ____opt_64 = self.Caster
    if ____opt_64 and ____opt_64:HasModifier("modifier_ascended") then
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
    local ____opt_66 = self.Caster
    self.IshanaBuff = ____opt_66 and ____opt_66:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
    self:StartIntervalThink(0.03)
end
function musashi_modifier_ishana_daitenshou_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_68 = self:GetAbility()
    local DashSpeed = ____opt_68 and ____opt_68:GetSpecialValueFor("DashSpeed")
    local ____opt_70 = self.Victim
    local ____temp_74 = ____opt_70 and ____opt_70:GetAbsOrigin()
    local ____opt_72 = self.Caster
    local Direction = (____temp_74 - (____opt_72 and ____opt_72:GetAbsOrigin())):Normalized()
    local ____opt_75 = self.Caster
    if ____opt_75 ~= nil then
        ____opt_75:SetForwardVector(Direction)
    end
    local ____opt_77 = self.Caster
    local ____temp_81 = ____opt_77 and ____opt_77:GetAbsOrigin()
    local ____opt_79 = self.Caster
    local NewPosition = ____temp_81 + (____opt_79 and ____opt_79:GetForwardVector()) * DashSpeed
    local ____opt_82 = self.Caster
    if ____opt_82 ~= nil then
        ____opt_82:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_89 = Entities.FindByNameWithin
    local ____opt_84 = self.Caster
    local ____temp_88 = ____opt_84 and ____opt_84:GetName()
    local ____opt_86 = self.Victim
    local Musashi = ____Entities_FindByNameWithin_89(
        Entities,
        nil,
        ____temp_88,
        ____opt_86 and ____opt_86:GetAbsOrigin(),
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
    local ____opt_90 = self.IshanaBuff
    if ____opt_90 ~= nil then
        ____opt_90:IncrementStackCount()
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
    self.NormalSlashCount = 0
end
function musashi_modifier_ishana_daitenshou_slash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_92 = self.Caster
    self.IshanaBuff = ____opt_92 and ____opt_92:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
    local ____opt_94 = self.Ability
    local NormalSlashInterval = ____opt_94 and ____opt_94:GetSpecialValueFor("NormalSlashInterval")
    local ____opt_96 = self.Ability
    self.NormalSlashCount = ____opt_96 and ____opt_96:GetSpecialValueFor("NormalSlashCount")
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
    local ____opt_98 = self.Caster
    if ____opt_98 ~= nil then
        ____opt_98:StartGesture(ACT_DOTA_CAST_ABILITY_2)
    end
    self:CreateParticle()
    self:PerformFinalSlash()
    local ____opt_100 = self.IshanaBuff
    if ____opt_100 ~= nil then
        ____opt_100:IncrementStackCount()
    end
end
function musashi_modifier_ishana_daitenshou_slash.prototype.PerformFinalSlash(self)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____opt_102 = self.Ability
        local FinalSlashDmgDelay = ____opt_102 and ____opt_102:GetSpecialValueFor("FinalSlashDmgDelay")
        Sleep(nil, FinalSlashDmgDelay)
        local ____opt_104 = self.Ability
        local FinalSlashMaxHpPercent = ____opt_104 and ____opt_104:GetSpecialValueFor("FinalSlashMaxHpPercent")
        local ____opt_106 = self.Ability
        local ExecuteThresholdPercent = ____opt_106 and ____opt_106:GetSpecialValueFor("ExecuteThresholdPercent")
        local ____opt_108 = self.Victim
        local Damage = (____opt_108 and ____opt_108:GetMaxHealth()) * FinalSlashMaxHpPercent / 100
        local ____ApplyDamage_114 = ApplyDamage
        local ____self_Victim_112 = self.Victim
        local ____self_Caster_113 = self.Caster
        local ____opt_110 = self.Ability
        ____ApplyDamage_114({
            victim = ____self_Victim_112,
            attacker = ____self_Caster_113,
            damage = Damage,
            damage_type = ____opt_110 and ____opt_110:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            ability = self.Ability
        })
        local ____opt_115 = self.Victim
        local CurrentHpPercentage = ____opt_115 and ____opt_115:GetHealthPercent()
        if CurrentHpPercentage <= ExecuteThresholdPercent then
            local ____opt_117 = self.Victim
            if ____opt_117 ~= nil then
                ____opt_117:Kill(self.Ability, self.Caster)
            end
        else
            local ____opt_119 = self.Ability
            local DebuffDuration = ____opt_119 and ____opt_119:GetSpecialValueFor("DebuffDuration")
            local ____opt_121 = self.Victim
            if ____opt_121 ~= nil then
                ____opt_121:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_debuff.name, {duration = DebuffDuration})
            end
        end
    end)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.DoDamage(self)
    local ____opt_123 = self.Ability
    local NormalSlashMaxHpPercent = ____opt_123 and ____opt_123:GetSpecialValueFor("NormalSlashMaxHpPercent")
    local ____opt_125 = self.Victim
    local Damage = (____opt_125 and ____opt_125:GetMaxHealth()) * NormalSlashMaxHpPercent / 100
    local ____ApplyDamage_131 = ApplyDamage
    local ____self_Victim_129 = self.Victim
    local ____self_Caster_130 = self.Caster
    local ____opt_127 = self.Ability
    ____ApplyDamage_131({
        victim = ____self_Victim_129,
        attacker = ____self_Caster_130,
        damage = Damage,
        damage_type = ____opt_127 and ____opt_127:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self.Ability
    })
end
function musashi_modifier_ishana_daitenshou_slash.prototype.CreateParticle(self)
    local SlashParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_slash_basic.vpcf"
    local ____opt_132 = self.Caster
    if ____opt_132 and ____opt_132:HasModifier("modifier_ascended") then
        SlashParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_slash_unique.vpcf"
        local PetalsParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_petals_unique.vpcf"
        local PetalsParticle = ParticleManager:CreateParticle(PetalsParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        local ____ParticleManager_SetParticleControl_136 = ParticleManager.SetParticleControl
        local ____opt_134 = self.Victim
        ____ParticleManager_SetParticleControl_136(
            ParticleManager,
            PetalsParticle,
            0,
            ____opt_134 and ____opt_134:GetAbsOrigin()
        )
        local ____ParticleManager_SetParticleControl_139 = ParticleManager.SetParticleControl
        local ____opt_137 = self.Victim
        ____ParticleManager_SetParticleControl_139(
            ParticleManager,
            PetalsParticle,
            2,
            ____opt_137 and ____opt_137:GetAbsOrigin()
        )
        ParticleManager:SetParticleControl(
            PetalsParticle,
            3,
            self.Caster:GetAbsOrigin()
        )
    end
    local SlashParticle = ParticleManager:CreateParticle(SlashParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ____ParticleManager_SetParticleControl_142 = ParticleManager.SetParticleControl
    local ____opt_140 = self.IshanaBuff
    ____ParticleManager_SetParticleControl_142(ParticleManager, SlashParticle, 0, ____opt_140 and ____opt_140.StartPosition)
    local ____ParticleManager_SetParticleControl_145 = ParticleManager.SetParticleControl
    local ____opt_143 = self.Victim
    ____ParticleManager_SetParticleControl_145(
        ParticleManager,
        SlashParticle,
        1,
        ____opt_143 and ____opt_143:GetAbsOrigin()
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
function musashi_modifier_ishana_daitenshou_debuff.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierExtraHealthPercentage(self)
    local ____opt_146 = self:GetAbility()
    return ____opt_146 and ____opt_146:GetSpecialValueFor("MaxHpReductionPercent")
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_148 = self:GetAbility()
    return ____opt_148 and ____opt_148:GetSpecialValueFor("ExtraIncomingDmgPercent")
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
    self.Niou:SetModelScale(ModelScale)
    self.Niou:AddNewModifier(self.Niou, self, ____exports.musashi_modifier_niou.name, {undefined = undefined})
end
function musashi_niou.prototype.DestroyNiou(self, delay)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____opt_150 = self.Niou
        if ____opt_150 ~= nil then
            ____opt_150:ForceKill(false)
        end
        Sleep(nil, delay)
        local ____opt_152 = self.Niou
        if ____opt_152 ~= nil then
            ____opt_152:Destroy()
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
