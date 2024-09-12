WingsCode = WingsCode or class({})

--===============================================================--
function string.splitQuoted(sString)
    local t = {}
    local spat, epat, buf, quoted = [=[^(['"])]=], [=[(['"])$]=]
    for str in sString:gmatch("%S+") do
        local squoted = str:match(spat)
        local equoted = str:match(epat)
        local escaped = str:match([=[(\*)['"]$]=])
        if squoted and not quoted and not equoted then
            buf, quoted = str, squoted
        elseif buf and equoted == quoted and #escaped % 2 == 0 then
            str, buf, quoted = buf .. ' ' .. str, nil, nil
        elseif buf then
            buf = buf .. ' ' .. str
        end
        if not buf then
            local newString = str:gsub(spat,""):gsub(epat,"")
            table.insert(t, newString)
        end
    end
    if buf then
        error("There is no matching quote for "..buf)
    end
    return t
end
--===============================================================--
function WingsCode:Init()
    self.___tWingsKV = LoadKeyValues("scripts/npc/wings_code.txt")

    --DeepPrintTable(string.splitQuoted("ascension random custom' KEK"))

    self.___tFunctionsCommandList =
    {
        ["-wings"] =
        {
            ascension = function(hUnit)
                self:RemoveWings(hUnit)
                self:ApplyWings(hUnit, "particles/heroes/saito/wings/clown_wings/clown_wings.vpcf", nil)
            end,

            random = function(hUnit)
                self:RemoveWings(hUnit)
                self:ApplyWings(hUnit, "particles/heroes/saito/wings/one_color_wings/one_color_wings.vpcf", Vector(RandomInt(0, 255), RandomInt(0, 255), RandomInt(0, 255)))
            end,

            pepe = function(hUnit)
                self:RemoveWings(hUnit)
                self:ApplyWings(hUnit, "particles/heroes/saito/wings/one_color_wings/one_color_wings.vpcf", Vector(0, 255, 0))
            end,

            custom = function(hUnit, nR, nG, nB)
                self:RemoveWings(hUnit)
                self:ApplyWings(hUnit, "particles/heroes/saito/wings/one_color_wings/one_color_wings.vpcf", Vector(nR, nG, nB))
            end,

            remove = function(hUnit)
                self:RemoveWings(hUnit)
            end
        }
    }

    if type(self._nChatEventListener) == "number" then
        StopListeningToGameEvent(self._nChatEventListener)
        self._nChatEventListener = nil
    end

    self._nChatEventListener = ListenToGameEvent("player_chat", Dynamic_Wrap(self, "OnPlayerChat"), self)
end
--===============================================================--
function WingsCode:Contains(t, value)
    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end
--===============================================================--
function WingsCode:OnPlayerChat(tEventTable)
    local nPlayerID  = tEventTable.playerid
    local sText      = string.lower(tEventTable.text)
    local hHero      = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    local nSteamID32 = tostring(PlayerResource:GetSteamAccountID(nPlayerID))

    if not self.___tWingsKV.players or not self.___tWingsKV.players[nSteamID32] then
        return nil
    end

    local tPossible = string.splitQuoted(self.___tWingsKV.players[nSteamID32])

    for k, v in pairs(self.___tFunctionsCommandList or {}) do
        --local sKey, nR, nG, nB = string.match(sText, "^"..k.."%s+(%w+)%s-((%d+%s+%d+%s+%d+)?)")
        local sKey, nR, nG, nB = string.match(sText, "^"..k.."%s+(%w+)%s-(%d+)%s-(%d+)%s-(%d+)")
        if type(sKey) == "nil" then
            sKey = string.match(sText, "^"..k.."%s+(%w+)%s-")
        end
        if self:Contains(tPossible, sKey) then
            if type(sKey) ~= "nil" and type(v) == "table" and type(self.___tFunctionsCommandList[k][sKey]) == "function" then
                self.___tFunctionsCommandList[k][sKey](hHero, nR or 0, nG or 0, nB or 0)
                break
            end
        end
    end
end
--===============================================================--
function WingsCode:ApplyWings(hUnit, sParticleID, vColor)
    local ___tWingsCodeSettings = {}
          ___tWingsCodeSettings.sParticleID = sParticleID or ""
          ___tWingsCodeSettings.vColor = vColor or Vector(0, 0, 0)

    hUnit.___tWingsCodeSettings = ___tWingsCodeSettings

    local hModifierWings = hUnit:AddNewModifier(hUnit, nil, "modifier_wings_code_particle", {})

    return hModifierWings
end
--===============================================================--
function WingsCode:RemoveWings(hUnit)
    local bReturn = hUnit:HasModifier("modifier_wings_code_particle")
    hUnit:RemoveModifierByNameAndCaster("modifier_wings_code_particle", hUnit)
    return bReturn
end
--===============================================================--
--===============================================================--
--===============================================================--
LinkLuaModifier("modifier_wings_code_particle", "wings_code", LUA_MODIFIER_MOTION_NONE)

modifier_wings_code_particle = modifier_wings_code_particle or class({})

function modifier_wings_code_particle:IsHidden()                                                                    return true end
function modifier_wings_code_particle:IsDebuff()                                                                    return false end
function modifier_wings_code_particle:IsPurgable()                                                                  return false end
function modifier_wings_code_particle:IsPurgeException()                                                            return false end
function modifier_wings_code_particle:RemoveOnDeath()                                                               return false end
function modifier_wings_code_particle:AllowIllusionDuplicate()                                                      return true end
function modifier_wings_code_particle:GetPriority()                                                                 return MODIFIER_PRIORITY_ULTRA end
function modifier_wings_code_particle:OnCreated(tTable)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()

    --NOTE: This code can't be copied to illusions at the moment, so DO NOT try to use AllowIllusionsDublicate, it won't work properly. Or because of GabeN and illusions are still broken now...
    if IsServer() then
        self.___tWingsCodeSettings = self.hParent.___tWingsCodeSettings

        if type(self.___nWingsPFX) ~= "number" then
            self.___nWingsPFX = ParticleManager:CreateParticle(self.___tWingsCodeSettings.sParticleID, PATTACH_ABSORIGIN_FOLLOW, self.hParent)
                                ParticleManager:SetParticleControlEnt(self.___nWingsPFX, 0, self.hParent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.hParent:GetAbsOrigin(), true)
                                ParticleManager:SetParticleControl(self.___nWingsPFX, 2, Vector(255, 255, 255))
                                ParticleManager:SetParticleControl(self.___nWingsPFX, 15, self.___tWingsCodeSettings.vColor)
                                ParticleManager:SetParticleControl(self.___nWingsPFX, 16, Vector(1, 0, 0))
            self:AddParticle(self.___nWingsPFX, false, false, -1, false, false)
        end
    end
end
function modifier_wings_code_particle:OnRefresh(tTable)
    self:OnCreated(tTable)
end
function modifier_wings_code_particle:OnDestroy()
    if IsServer() then
        self.hParent.___tWingsCodeSettings = nil
    end
end
--===============================================================--
--===============================================================--
--===============================================================--
if IsServer() then
    WingsCode:Init()
end