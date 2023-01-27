local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["7"] = 117,["8"] = 117,["9"] = 118,["10"] = 119,["11"] = 120,["12"] = 121,["13"] = 122,["14"] = 122,["15"] = 122,["16"] = 122,["18"] = 125,["21"] = 129,["22"] = 130,["23"] = 130,["24"] = 131,["25"] = 132,["26"] = 135,["27"] = 136,["30"] = 140,["33"] = 2,["34"] = 2,["35"] = 2,["37"] = 2,["38"] = 5,["39"] = 5,["40"] = 5,["42"] = 5,["43"] = 8,["44"] = 8,["45"] = 8,["47"] = 8,["48"] = 9,["49"] = 16,["50"] = 9,["51"] = 21,["52"] = 21,["53"] = 21,["54"] = 21,["55"] = 24,["56"] = 24,["57"] = 24,["58"] = 24,["59"] = 27,["60"] = 27,["61"] = 27,["62"] = 27,["63"] = 30,["64"] = 31,["65"] = 32,["66"] = 34,["67"] = 35,["68"] = 37,["70"] = 39,["72"] = 42,["73"] = 44,["74"] = 46,["75"] = 48,["76"] = 49,["77"] = 50,["78"] = 51,["79"] = 52,["81"] = 49,["82"] = 34,["83"] = 57,["84"] = 58,["85"] = 60,["87"] = 62,["89"] = 65,["90"] = 66,["91"] = 68,["92"] = 70,["93"] = 72,["94"] = 73,["95"] = 74,["96"] = 75,["97"] = 76,["99"] = 73,["100"] = 80,["101"] = 81,["102"] = 82,["103"] = 83,["104"] = 84,["106"] = 86,["107"] = 87,["109"] = 89,["110"] = 90,["113"] = 94,["115"] = 97,["116"] = 57,["119"] = 104,["120"] = 105,["121"] = 106,["122"] = 107,["123"] = 106,["124"] = 104});
local ____exports = {}
local getFileScope, toDotaClassInstance
function getFileScope(self)
    local level = 1
    while true do
        local info = debug.getinfo(level, "S")
        if info and info.what == "main" then
            return {
                getfenv(level),
                info.source
            }
        end
        level = level + 1
    end
end
function toDotaClassInstance(self, instance, ____table)
    local ____table_0 = ____table
    local prototype = ____table_0.prototype
    while prototype do
        for key in pairs(prototype) do
            if not (rawget(instance, key) ~= nil) then
                instance[key] = prototype[key]
            end
        end
        prototype = getmetatable(prototype)
    end
end
____exports.BaseAbility = __TS__Class()
local BaseAbility = ____exports.BaseAbility
BaseAbility.name = "BaseAbility"
function BaseAbility.prototype.____constructor(self)
end
____exports.BaseItem = __TS__Class()
local BaseItem = ____exports.BaseItem
BaseItem.name = "BaseItem"
function BaseItem.prototype.____constructor(self)
end
____exports.BaseModifier = __TS__Class()
local BaseModifier = ____exports.BaseModifier
BaseModifier.name = "BaseModifier"
function BaseModifier.prototype.____constructor(self)
end
function BaseModifier.apply(self, target, caster, ability, modifierTable)
    return target:AddNewModifier(caster, ability, self.name, modifierTable)
end
____exports.BaseModifierMotionHorizontal = __TS__Class()
local BaseModifierMotionHorizontal = ____exports.BaseModifierMotionHorizontal
BaseModifierMotionHorizontal.name = "BaseModifierMotionHorizontal"
__TS__ClassExtends(BaseModifierMotionHorizontal, ____exports.BaseModifier)
____exports.BaseModifierMotionVertical = __TS__Class()
local BaseModifierMotionVertical = ____exports.BaseModifierMotionVertical
BaseModifierMotionVertical.name = "BaseModifierMotionVertical"
__TS__ClassExtends(BaseModifierMotionVertical, ____exports.BaseModifier)
____exports.BaseModifierMotionBoth = __TS__Class()
local BaseModifierMotionBoth = ____exports.BaseModifierMotionBoth
BaseModifierMotionBoth.name = "BaseModifierMotionBoth"
__TS__ClassExtends(BaseModifierMotionBoth, ____exports.BaseModifier)
setmetatable(____exports.BaseAbility.prototype, {__index = CDOTA_Ability_Lua or C_DOTA_Ability_Lua})
setmetatable(____exports.BaseItem.prototype, {__index = CDOTA_Item_Lua or C_DOTA_Item_Lua})
setmetatable(____exports.BaseModifier.prototype, {__index = CDOTA_Modifier_Lua or C_DOTA_Modifier_Lua})
____exports.registerAbility = function(____, name) return function(____, ability)
    if name ~= nil then
        ability.name = name
    else
        name = ability.name
    end
    local env = unpack(getFileScope(nil))
    env[name] = {}
    toDotaClassInstance(nil, env[name], ability)
    local originalSpawn = env[name].Spawn
    env[name].Spawn = function(self)
        self:____constructor()
        if originalSpawn then
            originalSpawn(self)
        end
    end
end end
____exports.registerModifier = function(____, name) return function(____, modifier)
    if name ~= nil then
        modifier.name = name
    else
        name = modifier.name
    end
    local env, source = unpack(getFileScope(nil))
    local fileName = string.gsub(source, ".*scripts[\\/]vscripts[\\/]", "")
    env[name] = {}
    toDotaClassInstance(nil, env[name], modifier)
    local originalOnCreated = env[name].OnCreated
    env[name].OnCreated = function(self, parameters)
        self:____constructor()
        if originalOnCreated ~= nil then
            originalOnCreated(self, parameters)
        end
    end
    local ____type = LUA_MODIFIER_MOTION_NONE
    local base = modifier.____super
    while base do
        if base == ____exports.BaseModifierMotionBoth then
            ____type = LUA_MODIFIER_MOTION_BOTH
            break
        elseif base == ____exports.BaseModifierMotionHorizontal then
            ____type = LUA_MODIFIER_MOTION_HORIZONTAL
            break
        elseif base == ____exports.BaseModifierMotionVertical then
            ____type = LUA_MODIFIER_MOTION_VERTICAL
            break
        end
        base = base.____super
    end
    LinkLuaModifier(name, fileName, ____type)
end end
--- Use to expose top-level functions in entity scripts.
-- Usage: registerEntityFunction("OnStartTouch", (trigger: TriggerStartTouchEvent) => { <your code here> });
function ____exports.registerEntityFunction(self, name, f)
    local env = unpack(getFileScope(nil))
    env[name] = function(...)
        f(nil, ...)
    end
end
return ____exports
