CDOTA_BaseNPC = IsServer() and CDOTA_BaseNPC or C_DOTA_BaseNPC
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
Say = IsServer() and Say
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]

CBaseEntity = IsServer() and CBaseEntity or C_BaseEntity
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
CDOTABaseAbility = IsServer() and CDOTABaseAbility or C_DOTABaseAbility
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
CDOTA_Ability_Lua = IsServer() and CDOTA_Ability_Lua or C_DOTA_Ability_Lua
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
CDOTA_Item_Lua = IsServer() and CDOTA_Item_Lua or C_DOTA_Item_Lua

local VALVE_Say = Say
Say = function(hEntity, StringMessage, bteamOnly)
    if hEntity == nil then 
    --    print('Say: no player')
        return nil
    else
        return VALVE_Say(hEntity, StringMessage, bteamOnly)
    end
end

local VALVE_AddNewModifier = CDOTA_BaseNPC.AddNewModifier
CDOTA_BaseNPC.AddNewModifier = function(self, hCaster, hAbility, pszScriptName, hModifierTable)
    if self:IsNull() or self == nil then
    	print('add new modifier error: no target')
    	return nil
    else
        if IsImmuneToCC(self) and pszScriptName == "modifier_stunned" then 
            for k,v in pairs(hModifierTable) do
                if string.match(k, "uration") then 
                    hModifierTable[k] = v * 0.5
                end
            end
        end
        return VALVE_AddNewModifier(self, hCaster, hAbility, pszScriptName, hModifierTable)
    end
end

local VALVE_SetModifierStackCount = CDOTA_BaseNPC.SetModifierStackCount
CDOTA_BaseNPC.SetModifierStackCount = function(self, pszScriptName, hCaster, nStackCount)
    if self:IsNull() or self == nil then
    	print('set modifier stack count error: no target')
    	return nil
    else
        return VALVE_SetModifierStackCount(self, pszScriptName, hCaster, nStackCount)
    end
end

local VALVE_GetModifierStackCount = CDOTA_BaseNPC.GetModifierStackCount
CDOTA_BaseNPC.GetModifierStackCount = function(self, pszScriptName, hCaster)
    if self:IsNull() or self == nil then
        print('get modifier stack count error: no target')
        return nil
    else
        return VALVE_GetModifierStackCount(self, pszScriptName, hCaster)
    end
end

local VALVE_HasModifier = CDOTA_BaseNPC.HasModifier
CDOTA_BaseNPC.HasModifier = function(self, pszScriptName)
    if self:IsNull() or self == nil then
        print('has modifier error: no target')
        return false
    else
        return VALVE_HasModifier(self, pszScriptName)
    end
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_EmitSound = CBaseEntity.EmitSound
CBaseEntity.EmitSound = function(self, soundname)
    if self:IsNull() or self == nil then
    	print('emit sound: no target')
    	return nil
    else
        return VALVE_EmitSound(self, soundname)
    end
end

--!!----------------------------------------------------------------------------------------------------------------------------------------------------------

local VALVE_ApplyDataDrivenModifier = CDOTABaseAbility.ApplyDataDrivenModifier
CDOTABaseAbility.ApplyDataDrivenModifier = function(self, hCaster, hTarget, pszModifierName, hModifierTable)
    if hTarget:IsNull() or hTarget == nil then
    	print('apply data driven modifier error: no target')
    	return nil
    else
        return VALVE_ApplyDataDrivenModifier(self, hCaster, hTarget, pszModifierName, hModifierTable)
    end
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--[[CDOTABaseAbility.GetCastRangeBonus = function(self, hTarget) --Crashes normal addons, because gaben released new patch with error in 24.02.2022 pizdec, only for LUA ABILITY, For items i think all fne.... cringe
    return self:GetCaster():GetCastRangeBonus()
end
local VALVE_CDOTA_Ability_Lua_GetCastRangeBonus = CDOTA_Ability_Lua.GetCastRangeBonus
CDOTA_Ability_Lua.GetCastRangeBonus = function(self, hTarget) --I DID IT FOR ALL BECASUE NOT WANNA RECIEVE ERRORS IN FUTURE
    return VALVE_CDOTA_Ability_Lua_GetCastRangeBonus(self, hTarget)
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_Item_Lua.GetCastRangeBonus = function(self, hTarget) --Predict Crash???
    return self:GetCaster():GetCastRangeBonus()
end]]

