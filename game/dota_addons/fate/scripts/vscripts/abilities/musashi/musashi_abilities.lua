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
    local ____temp_19 = not IsServer()
    if not ____temp_19 then
        local ____opt_17 = self.Caster
        ____temp_19 = not (____opt_17 and ____opt_17:HasModifier(musashi_attributes.musashi_attribute_battle_continuation.name))
    end
    if ____temp_19 then
        return
    end
    local ____temp_22 = self.Caster:GetHealth() <= 0
    if ____temp_22 then
        local ____opt_20 = self.Ability
        ____temp_22 = ____opt_20 and ____opt_20:IsFullyCastable()
    end
    if ____temp_22 and not self.Caster:HasModifier("musashi_modifier_tenma_gogan_debuff.name") then
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
    local ____opt_23 = self.Caster
    if ____opt_23 ~= nil then
        ____opt_23:Purge(
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
    local ____opt_25 = self.Ability
    local Heal = ____opt_25 and ____opt_25:GetSpecialValueFor("Heal")
    local ____opt_27 = self.Caster
    if ____opt_27 ~= nil then
        ____opt_27:Heal(Heal, self.Ability)
    end
end
function musashi_modifier_battle_continuation_active.prototype.CreateParticle(self)
    local ____opt_29 = self.Caster
    if ____opt_29 and ____opt_29:HasModifier("modifier_ascended") then
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
    local ____opt_31 = self.Caster
    if ____opt_31 ~= nil then
        ____opt_31:EmitSound(self.SoundVoiceline)
    end
    local ____opt_33 = self.Caster
    if ____opt_33 ~= nil then
        ____opt_33:EmitSound(self.SoundSfx)
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
    local ____opt_35 = self.Ability
    self.Victim = ____opt_35 and ____opt_35:GetCursorTarget()
    local ____opt_37 = self.Victim
    self.MarkerPosition = ____opt_37 and ____opt_37:GetAbsOrigin()
    local ____opt_39 = self.Caster
    self.StartPosition = ____opt_39 and ____opt_39:GetAbsOrigin()
    local ____opt_41 = self.Caster
    local NiouKurikara = ____opt_41 and ____opt_41:FindAbilityByName(____exports.musashi_niou_kurikara.name)
    local ____opt_43 = self.Caster
    if ____opt_43 ~= nil then
        ____opt_43:CastAbilityOnPosition(
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
    local ____opt_45 = self.Caster
    if ____opt_45 and ____opt_45:IsChanneling() then
        self.CastedNiouKurikara = true
    end
    local ____self_CastedNiouKurikara_49 = self.CastedNiouKurikara
    if ____self_CastedNiouKurikara_49 then
        local ____opt_47 = self.Caster
        ____self_CastedNiouKurikara_49 = not (____opt_47 and ____opt_47:IsChanneling())
    end
    if ____self_CastedNiouKurikara_49 then
        local ____opt_50 = self.Ability
        local Radius = ____opt_50 and ____opt_50:GetSpecialValueFor("Radius")
        local ____Entities_FindByNameWithin_54 = Entities.FindByNameWithin
        local ____opt_52 = self.Victim
        local VictimInRadius = ____Entities_FindByNameWithin_54(
            Entities,
            nil,
            ____opt_52 and ____opt_52:GetName(),
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
        local ____switch61 = stackCount
        local ____cond61 = ____switch61 == 0
        if ____cond61 then
            do
                local ____opt_55 = self.Caster
                if ____opt_55 ~= nil then
                    ____opt_55:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_dash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond61 = ____cond61 or ____switch61 == 1
        if ____cond61 then
            do
                local ____opt_57 = self.Caster
                if ____opt_57 ~= nil then
                    ____opt_57:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_slash.name, {undefined = undefined})
                end
                break
            end
        end
        ____cond61 = ____cond61 or ____switch61 == 2
        if ____cond61 then
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
    local ____FindClearSpaceForUnit_62 = FindClearSpaceForUnit
    local ____self_Caster_61 = self.Caster
    local ____opt_59 = self.Caster
    ____FindClearSpaceForUnit_62(
        ____self_Caster_61,
        ____opt_59 and ____opt_59:GetAbsOrigin(),
        true
    )
    local ____opt_63 = self.Caster
    if ____opt_63 ~= nil then
        ____opt_63:SetForwardVector(self.Caster:GetAbsOrigin():Normalized() * 10)
    end
    local ____opt_65 = self.Caster
    if ____opt_65 ~= nil then
        ____opt_65:AddNewModifier(self.Caster, self.Ability, "modifier_phased", {duration = 1})
    end
end
function musashi_modifier_ishana_daitenshou.prototype.CreateParticle(self)
    local ____opt_67 = self.Caster
    if ____opt_67 and ____opt_67:HasModifier("modifier_ascended") then
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
    local ____opt_69 = self.Caster
    self.IshanaBuff = ____opt_69 and ____opt_69:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
    self:StartIntervalThink(0.03)
end
function musashi_modifier_ishana_daitenshou_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_71 = self.Ability
    local DashSpeed = ____opt_71 and ____opt_71:GetSpecialValueFor("DashSpeed")
    local ____opt_73 = self.Victim
    local ____temp_77 = ____opt_73 and ____opt_73:GetAbsOrigin()
    local ____opt_75 = self.Caster
    local Direction = (____temp_77 - (____opt_75 and ____opt_75:GetAbsOrigin())):Normalized()
    local ____opt_78 = self.Caster
    if ____opt_78 ~= nil then
        ____opt_78:SetForwardVector(Direction)
    end
    local ____opt_80 = self.Caster
    local ____temp_84 = ____opt_80 and ____opt_80:GetAbsOrigin()
    local ____opt_82 = self.Caster
    local NewPosition = ____temp_84 + (____opt_82 and ____opt_82:GetForwardVector()) * DashSpeed
    local ____opt_85 = self.Caster
    if ____opt_85 ~= nil then
        ____opt_85:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_92 = Entities.FindByNameWithin
    local ____opt_87 = self.Caster
    local ____temp_91 = ____opt_87 and ____opt_87:GetName()
    local ____opt_89 = self.Victim
    local Musashi = ____Entities_FindByNameWithin_92(
        Entities,
        nil,
        ____temp_91,
        ____opt_89 and ____opt_89:GetAbsOrigin(),
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
    local ____opt_93 = self.IshanaBuff
    if ____opt_93 ~= nil then
        ____opt_93:IncrementStackCount()
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
    local ____opt_95 = self.Caster
    self.IshanaBuff = ____opt_95 and ____opt_95:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
    local ____opt_97 = self.Ability
    local NormalSlashInterval = ____opt_97 and ____opt_97:GetSpecialValueFor("NormalSlashInterval")
    local ____opt_99 = self.Ability
    self.NormalSlashCount = ____opt_99 and ____opt_99:GetSpecialValueFor("NormalSlashCount")
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
    local ____opt_101 = self.Caster
    if ____opt_101 ~= nil then
        ____opt_101:StartGesture(ACT_DOTA_CAST_ABILITY_2)
    end
    self:CreateParticle()
    self:PerformFinalSlash()
    local ____opt_103 = self.IshanaBuff
    if ____opt_103 ~= nil then
        ____opt_103:IncrementStackCount()
    end
end
function musashi_modifier_ishana_daitenshou_slash.prototype.PerformFinalSlash(self)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____opt_105 = self.Ability
        local FinalSlashDmgDelay = ____opt_105 and ____opt_105:GetSpecialValueFor("FinalSlashDmgDelay")
        Sleep(nil, FinalSlashDmgDelay)
        local ____opt_107 = self.Ability
        local FinalSlashMaxHpPercent = ____opt_107 and ____opt_107:GetSpecialValueFor("FinalSlashMaxHpPercent")
        local ____opt_109 = self.Ability
        local ExecuteThresholdPercent = ____opt_109 and ____opt_109:GetSpecialValueFor("ExecuteThresholdPercent")
        local ____opt_111 = self.Victim
        local Damage = (____opt_111 and ____opt_111:GetMaxHealth()) * FinalSlashMaxHpPercent / 100
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
        local ____opt_118 = self.Victim
        local CurrentHpPercentage = ____opt_118 and ____opt_118:GetHealthPercent()
        if CurrentHpPercentage <= ExecuteThresholdPercent then
            local ____opt_120 = self.Victim
            if ____opt_120 ~= nil then
                ____opt_120:Kill(self.Ability, self.Caster)
            end
        else
            local ____opt_122 = self.Ability
            local DebuffDuration = ____opt_122 and ____opt_122:GetSpecialValueFor("DebuffDuration")
            local ____opt_124 = self.Victim
            if ____opt_124 ~= nil then
                ____opt_124:AddNewModifier(self.Caster, self.Ability, ____exports.musashi_modifier_ishana_daitenshou_debuff.name, {duration = DebuffDuration})
            end
        end
    end)
end
function musashi_modifier_ishana_daitenshou_slash.prototype.DoDamage(self)
    local ____opt_126 = self.Ability
    local NormalSlashMaxHpPercent = ____opt_126 and ____opt_126:GetSpecialValueFor("NormalSlashMaxHpPercent")
    local ____opt_128 = self.Victim
    local Damage = (____opt_128 and ____opt_128:GetMaxHealth()) * NormalSlashMaxHpPercent / 100
    local ____ApplyDamage_134 = ApplyDamage
    local ____self_Victim_132 = self.Victim
    local ____self_Caster_133 = self.Caster
    local ____opt_130 = self.Ability
    ____ApplyDamage_134({
        victim = ____self_Victim_132,
        attacker = ____self_Caster_133,
        damage = Damage,
        damage_type = ____opt_130 and ____opt_130:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self.Ability
    })
end
function musashi_modifier_ishana_daitenshou_slash.prototype.CreateParticle(self)
    local ____opt_135 = self.Caster
    if ____opt_135 and ____opt_135:HasModifier("modifier_ascended") then
        self.SlashParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_slash_unique.vpcf"
        local PetalsParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_petals_unique.vpcf"
        local PetalsParticle = ParticleManager:CreateParticle(PetalsParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        local ____ParticleManager_SetParticleControl_139 = ParticleManager.SetParticleControl
        local ____opt_137 = self.Victim
        ____ParticleManager_SetParticleControl_139(
            ParticleManager,
            PetalsParticle,
            0,
            ____opt_137 and ____opt_137:GetAbsOrigin()
        )
        local ____ParticleManager_SetParticleControl_142 = ParticleManager.SetParticleControl
        local ____opt_140 = self.Victim
        ____ParticleManager_SetParticleControl_142(
            ParticleManager,
            PetalsParticle,
            2,
            ____opt_140 and ____opt_140:GetAbsOrigin()
        )
        ParticleManager:SetParticleControl(
            PetalsParticle,
            3,
            self.Caster:GetAbsOrigin()
        )
    end
    local SlashParticle = ParticleManager:CreateParticle(self.SlashParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    local ____ParticleManager_SetParticleControl_145 = ParticleManager.SetParticleControl
    local ____opt_143 = self.IshanaBuff
    ____ParticleManager_SetParticleControl_145(ParticleManager, SlashParticle, 0, ____opt_143 and ____opt_143.StartPosition)
    local ____ParticleManager_SetParticleControl_148 = ParticleManager.SetParticleControl
    local ____opt_146 = self.Victim
    ____ParticleManager_SetParticleControl_148(
        ParticleManager,
        SlashParticle,
        1,
        ____opt_146 and ____opt_146:GetAbsOrigin()
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
    local ____opt_149 = self.Caster
    self.IshanaBuff = ____opt_149 and ____opt_149:FindModifierByName(____exports.musashi_modifier_ishana_daitenshou.name)
    self.Victim = self.IshanaBuff.Victim
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierExtraHealthPercentage(self)
    local ____opt_151 = self.Ability
    return ____opt_151 and ____opt_151:GetSpecialValueFor("MaxHpReductionPercent")
end
function musashi_modifier_ishana_daitenshou_debuff.prototype.GetModifierIncomingDamage_Percentage(self)
    local ____opt_153 = self.Ability
    return ____opt_153 and ____opt_153:GetSpecialValueFor("ExtraIncomingDmgPercent")
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
        local ____opt_155 = self.Niou
        if ____opt_155 ~= nil then
            ____opt_155:ForceKill(false)
        end
        Sleep(nil, delay)
        local ____opt_157 = self.Niou
        if ____opt_157 ~= nil then
            ____opt_157:Destroy()
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
