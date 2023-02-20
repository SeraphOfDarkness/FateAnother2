local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local ____exports = {}
local ____dota_ts_adapter = require("tslib.dota_ts_adapter")
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
musashi_attributes_tenma_gogan = __TS__Decorate(
    {registerAbility(nil)},
    musashi_attributes_tenma_gogan
)
____exports.musashi_attributes_tenma_gogan = musashi_attributes_tenma_gogan
____exports.musashi_attributes_gorin_no_sho = __TS__Class()
local musashi_attributes_gorin_no_sho = ____exports.musashi_attributes_gorin_no_sho
musashi_attributes_gorin_no_sho.name = "musashi_attributes_gorin_no_sho"
__TS__ClassExtends(musashi_attributes_gorin_no_sho, BaseAbility)
musashi_attributes_gorin_no_sho = __TS__Decorate(
    {registerAbility(nil)},
    musashi_attributes_gorin_no_sho
)
____exports.musashi_attributes_gorin_no_sho = musashi_attributes_gorin_no_sho
____exports.musashi_attributes_mukyuu = __TS__Class()
local musashi_attributes_mukyuu = ____exports.musashi_attributes_mukyuu
musashi_attributes_mukyuu.name = "musashi_attributes_mukyuu"
__TS__ClassExtends(musashi_attributes_mukyuu, BaseAbility)
musashi_attributes_mukyuu = __TS__Decorate(
    {registerAbility(nil)},
    musashi_attributes_mukyuu
)
____exports.musashi_attributes_mukyuu = musashi_attributes_mukyuu
return ____exports
