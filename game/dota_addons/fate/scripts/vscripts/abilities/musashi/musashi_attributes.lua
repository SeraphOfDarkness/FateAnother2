local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local ____exports = {}
local ____dota_ts_adapter = require("libs.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerAbility = ____dota_ts_adapter.registerAbility
local registerModifier = ____dota_ts_adapter.registerModifier
____exports.musashi_attributes_battle_continuation = __TS__Class()
local musashi_attributes_battle_continuation = ____exports.musashi_attributes_battle_continuation
musashi_attributes_battle_continuation.name = "musashi_attributes_battle_continuation"
__TS__ClassExtends(musashi_attributes_battle_continuation, BaseAbility)
function musashi_attributes_battle_continuation.prototype.OnSpellStart(self)
    local Master = self:GetCaster()
    local Hero = Master:GetPlayerOwner():GetAssignedHero()
    local TengenNoHana = Hero:FindAbilityByName("musashi_tengen_no_hana")
    if TengenNoHana ~= nil then
        TengenNoHana:SetHidden(false)
    end
    Hero:AddNewModifier(Master, self, ____exports.musashi_attribute_battle_continuation.name, {undefined = undefined})
    self:SetFrozenCooldown(true)
end
musashi_attributes_battle_continuation = __TS__Decorate(
    {registerAbility(nil)},
    musashi_attributes_battle_continuation
)
____exports.musashi_attributes_battle_continuation = musashi_attributes_battle_continuation
____exports.musashi_attribute_battle_continuation = __TS__Class()
local musashi_attribute_battle_continuation = ____exports.musashi_attribute_battle_continuation
musashi_attribute_battle_continuation.name = "musashi_attribute_battle_continuation"
__TS__ClassExtends(musashi_attribute_battle_continuation, BaseModifier)
function musashi_attribute_battle_continuation.prototype.IsPurgable(self)
    return false
end
function musashi_attribute_battle_continuation.prototype.IsPurgeException(self)
    return false
end
function musashi_attribute_battle_continuation.prototype.IsPermanent(self)
    return true
end
function musashi_attribute_battle_continuation.prototype.RemoveOnDeath(self)
    return false
end
function musashi_attribute_battle_continuation.prototype.IsHidden(self)
    return true
end
musashi_attribute_battle_continuation = __TS__Decorate(
    {registerModifier(nil)},
    musashi_attribute_battle_continuation
)
____exports.musashi_attribute_battle_continuation = musashi_attribute_battle_continuation
____exports.musashi_attributes_tenma_gogan = __TS__Class()
local musashi_attributes_tenma_gogan = ____exports.musashi_attributes_tenma_gogan
musashi_attributes_tenma_gogan.name = "musashi_attributes_tenma_gogan"
__TS__ClassExtends(musashi_attributes_tenma_gogan, BaseAbility)
function musashi_attributes_tenma_gogan.prototype.OnSpellStart(self)
    local Master = self:GetCaster()
    local Hero = Master:GetPlayerOwner():GetAssignedHero()
    local TenmaGogan = Hero:FindAbilityByName("musashi_tenma_gogan")
    if TenmaGogan ~= nil then
        TenmaGogan:SetHidden(false)
    end
    Hero:AddNewModifier(Master, self, ____exports.musashi_attribute_tenma_gogan.name, {undefined = undefined})
    self:SetFrozenCooldown(true)
end
musashi_attributes_tenma_gogan = __TS__Decorate(
    {registerAbility(nil)},
    musashi_attributes_tenma_gogan
)
____exports.musashi_attributes_tenma_gogan = musashi_attributes_tenma_gogan
____exports.musashi_attribute_tenma_gogan = __TS__Class()
local musashi_attribute_tenma_gogan = ____exports.musashi_attribute_tenma_gogan
musashi_attribute_tenma_gogan.name = "musashi_attribute_tenma_gogan"
__TS__ClassExtends(musashi_attribute_tenma_gogan, BaseModifier)
function musashi_attribute_tenma_gogan.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    local Caster = self:GetParent()
    local TenganChargeCounter = Caster:FindModifierByName("musashi_modifier_tengan_charge_counter")
    self.Tengan = Caster:FindAbilityByName("musashi_tengan")
    if TenganChargeCounter ~= nil then
        TenganChargeCounter:ForceRefresh()
    end
end
function musashi_attribute_tenma_gogan.prototype.GetModifierOverrideAbilitySpecial(self, event)
    if event.ability == self.Tengan then
        return 1
    end
    return 0
end
function musashi_attribute_tenma_gogan.prototype.GetModifierOverrideAbilitySpecialValue(self, event)
    if event.ability_special_value == "MaxCharges" then
        return 3
    end
    if event.ability_special_value == "RechargeTime" then
        local ____opt_6 = self.Tengan
        return (____opt_6 and ____opt_6:GetLevelSpecialValueNoOverride(
            "RechargeTime",
            self.Tengan:GetLevel() - 1
        )) * 0.5
    end
    return 0
end
function musashi_attribute_tenma_gogan.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL, MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE}
end
function musashi_attribute_tenma_gogan.prototype.IsPurgable(self)
    return false
end
function musashi_attribute_tenma_gogan.prototype.IsPurgeException(self)
    return false
end
function musashi_attribute_tenma_gogan.prototype.IsPermanent(self)
    return true
end
function musashi_attribute_tenma_gogan.prototype.RemoveOnDeath(self)
    return false
end
function musashi_attribute_tenma_gogan.prototype.IsHidden(self)
    return true
end
musashi_attribute_tenma_gogan = __TS__Decorate(
    {registerModifier(nil)},
    musashi_attribute_tenma_gogan
)
____exports.musashi_attribute_tenma_gogan = musashi_attribute_tenma_gogan
____exports.musashi_attributes_gorin_no_sho = __TS__Class()
local musashi_attributes_gorin_no_sho = ____exports.musashi_attributes_gorin_no_sho
musashi_attributes_gorin_no_sho.name = "musashi_attributes_gorin_no_sho"
__TS__ClassExtends(musashi_attributes_gorin_no_sho, BaseAbility)
function musashi_attributes_gorin_no_sho.prototype.OnSpellStart(self)
    local Master = self:GetCaster()
    local Hero = Master:GetPlayerOwner():GetAssignedHero()
    Hero:AddNewModifier(Master, self, ____exports.musashi_attribute_gorin_no_sho.name, {undefined = undefined})
    self:SetFrozenCooldown(true)
end
musashi_attributes_gorin_no_sho = __TS__Decorate(
    {registerAbility(nil)},
    musashi_attributes_gorin_no_sho
)
____exports.musashi_attributes_gorin_no_sho = musashi_attributes_gorin_no_sho
____exports.musashi_attribute_gorin_no_sho = __TS__Class()
local musashi_attribute_gorin_no_sho = ____exports.musashi_attribute_gorin_no_sho
musashi_attribute_gorin_no_sho.name = "musashi_attribute_gorin_no_sho"
__TS__ClassExtends(musashi_attribute_gorin_no_sho, BaseModifier)
function musashi_attribute_gorin_no_sho.prototype.IsPurgable(self)
    return false
end
function musashi_attribute_gorin_no_sho.prototype.IsPurgeException(self)
    return false
end
function musashi_attribute_gorin_no_sho.prototype.IsPermanent(self)
    return true
end
function musashi_attribute_gorin_no_sho.prototype.RemoveOnDeath(self)
    return false
end
function musashi_attribute_gorin_no_sho.prototype.IsHidden(self)
    return true
end
musashi_attribute_gorin_no_sho = __TS__Decorate(
    {registerModifier(nil)},
    musashi_attribute_gorin_no_sho
)
____exports.musashi_attribute_gorin_no_sho = musashi_attribute_gorin_no_sho
____exports.musashi_attributes_mukyuu = __TS__Class()
local musashi_attributes_mukyuu = ____exports.musashi_attributes_mukyuu
musashi_attributes_mukyuu.name = "musashi_attributes_mukyuu"
__TS__ClassExtends(musashi_attributes_mukyuu, BaseAbility)
function musashi_attributes_mukyuu.prototype.OnSpellStart(self)
    local Master = self:GetCaster()
    local Hero = Master:GetPlayerOwner():GetAssignedHero()
    local Mukyuu = Hero:FindAbilityByName("musashi_mukyuu")
    if Mukyuu ~= nil then
        Mukyuu:SetHidden(false)
    end
    Hero:AddNewModifier(Master, self, ____exports.musashi_attribute_mukyuu.name, {undefined = undefined})
    self:SetFrozenCooldown(true)
end
musashi_attributes_mukyuu = __TS__Decorate(
    {registerAbility(nil)},
    musashi_attributes_mukyuu
)
____exports.musashi_attributes_mukyuu = musashi_attributes_mukyuu
____exports.musashi_attribute_mukyuu = __TS__Class()
local musashi_attribute_mukyuu = ____exports.musashi_attribute_mukyuu
musashi_attribute_mukyuu.name = "musashi_attribute_mukyuu"
__TS__ClassExtends(musashi_attribute_mukyuu, BaseModifier)
function musashi_attribute_mukyuu.prototype.IsPurgable(self)
    return false
end
function musashi_attribute_mukyuu.prototype.IsPurgeException(self)
    return false
end
function musashi_attribute_mukyuu.prototype.IsPermanent(self)
    return true
end
function musashi_attribute_mukyuu.prototype.RemoveOnDeath(self)
    return false
end
function musashi_attribute_mukyuu.prototype.IsHidden(self)
    return true
end
musashi_attribute_mukyuu = __TS__Decorate(
    {registerModifier(nil)},
    musashi_attribute_mukyuu
)
____exports.musashi_attribute_mukyuu = musashi_attribute_mukyuu
____exports.musashi_attributes_niten_ichiryuu = __TS__Class()
local musashi_attributes_niten_ichiryuu = ____exports.musashi_attributes_niten_ichiryuu
musashi_attributes_niten_ichiryuu.name = "musashi_attributes_niten_ichiryuu"
__TS__ClassExtends(musashi_attributes_niten_ichiryuu, BaseAbility)
function musashi_attributes_niten_ichiryuu.prototype.OnSpellStart(self)
    local Master = self:GetCaster()
    local Hero = Master:GetPlayerOwner():GetAssignedHero()
    Hero:AddNewModifier(Master, self, ____exports.musashi_attribute_niten_ichiryuu.name, {undefined = undefined})
    self:SetFrozenCooldown(true)
end
musashi_attributes_niten_ichiryuu = __TS__Decorate(
    {registerAbility(nil)},
    musashi_attributes_niten_ichiryuu
)
____exports.musashi_attributes_niten_ichiryuu = musashi_attributes_niten_ichiryuu
____exports.musashi_attribute_niten_ichiryuu = __TS__Class()
local musashi_attribute_niten_ichiryuu = ____exports.musashi_attribute_niten_ichiryuu
musashi_attribute_niten_ichiryuu.name = "musashi_attribute_niten_ichiryuu"
__TS__ClassExtends(musashi_attribute_niten_ichiryuu, BaseModifier)
function musashi_attribute_niten_ichiryuu.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    local Caster = self:GetParent()
    self.Tengan = Caster:FindAbilityByName("musashi_tengan")
    self.GanryuuJima = Caster:FindAbilityByName("musashi_ganryuu_jima")
end
function musashi_attribute_niten_ichiryuu.prototype.GetModifierOverrideAbilitySpecial(self, event)
    if event.ability == self.Tengan or event.ability == self.GanryuuJima or event.ability == self.DaiGoSei then
        return 1
    end
    return 0
end
function musashi_attribute_niten_ichiryuu.prototype.GetModifierOverrideAbilitySpecialValue(self, event)
    if event.ability == self.DaiGoSei then
        if event.ability_special_value == "HitsRequired" then
            return 4
        end
    end
    if event.ability == self.Tengan then
        if event.ability_special_value == "BonusPureDmgPerAgi" then
            return 3.5
        end
    end
    if event.ability == self.GanryuuJima then
        if event.ability_special_value == "BonusDmgPerAgi" then
            return 4
        end
        if event.ability_special_value == "BonusMaxHpDmg" then
            return 10
        end
    end
    return 0
end
musashi_attribute_niten_ichiryuu = __TS__Decorate(
    {registerModifier(nil)},
    musashi_attribute_niten_ichiryuu
)
____exports.musashi_attribute_niten_ichiryuu = musashi_attribute_niten_ichiryuu
return ____exports
