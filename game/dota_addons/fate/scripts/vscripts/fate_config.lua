
function OnCameraDistance(index, keys)
    local playerId = EntIndexToHScript(keys.player)
    if PlayerTables:GetTableValue("database", "db", playerId) == true and iupoasldm.jyiowe[playerId].IFY ~= nil then 
    	iupoasldm.jyiowe[playerId].IFY.CFG.CAM = keys.iCamera
    end
end

function OnBGMVolume(index, keys)
    local playerId = EntIndexToHScript(keys.player)
    if PlayerTables:GetTableValue("database", "db", playerId) == true and iupoasldm.jyiowe[playerId].IFY ~= nil then 
    	iupoasldm.jyiowe[playerId].IFY.CFG.BGM = keys.iVolume
    end
end

function OnConfig1Checked(index, keys)
    local playerId = EntIndexToHScript(keys.player)
    local hero = PlayerResource:GetPlayer(keys.player):GetAssignedHero()
    local option
    if keys.bOption == 1 then 
    	option = true 
    else
    	option = false 
    end
    	
    hero.bIsAutoGoldRequestOn = option
    if PlayerTables:GetTableValue("database", "db", playerId) == true and iupoasldm.jyiowe[playerId].IFY ~= nil then 
    	iupoasldm.jyiowe[playerId].IFY.CFG.C01 = option
    end

end

function OnConfig2Checked(index, keys)
    local playerId = EntIndexToHScript(keys.player)
    local hero = PlayerResource:GetPlayer(keys.player):GetAssignedHero()
    local option
    if keys.bOption == 1 then 
    	option = true 
    else
    	option = false 
    end
    hero.bIsDmgPopupDisabled = option
    if PlayerTables:GetTableValue("database", "db", playerId) == true and iupoasldm.jyiowe[playerId].IFY ~= nil then 
    	iupoasldm.jyiowe[playerId].IFY.CFG.C02 = option
    end
end

function OnConfig3Checked(index, keys)
    local playerId = EntIndexToHScript(keys.player)
    local option
    if keys.bOption == 1 then 
    	option = true 
    else
    	option = false 
    end

    if PlayerTables:GetTableValue("database", "db", playerId) == true and iupoasldm.jyiowe[playerId].IFY ~= nil then 
    	iupoasldm.jyiowe[playerId].IFY.CFG.C03 = option
    end

end

function OnConfig4Checked(index, keys)
    local playerId = EntIndexToHScript(keys.player)
    local hero = PlayerResource:GetPlayer(keys.player):GetAssignedHero()
    local option
    if keys.bOption == 1 then 
    	option = true 
    else
    	option = false 
    end
    hero.bIsAlertSoundDisabled = option
    if PlayerTables:GetTableValue("database", "db", playerId) == true and iupoasldm.jyiowe[playerId].IFY ~= nil then 
    	iupoasldm.jyiowe[playerId].IFY.CFG.C04 = option
    end
end

function OnConfig8Checked(index, keys)
    local playerId = PlayerResource:GetPlayer(keys.player)
    if keys.bOption == 1 then playerId.bIsNewItemSystemDisabled = true else playerId.bIsNewItemSystemDisabled = false end
end

function OnConfig9Checked(index, keys)
    local playerId = PlayerResource:GetPlayer(keys.player)
    print(keys.bOption)
    if keys.bOption == 1 then playerId.bNotifyMasterManaDisabled = true else playerId.bNotifyMasterManaDisabled = false end
end

function OnConfig11Checked(index, keys)
    local player = PlayerResource:GetPlayer(keys.player)
    CustomGameEventManager:Send_ServerToPlayer( player, "custom_master_bar", {bOption= keys.bOption} )
end

function OnConfig13Checked(index, keys)
    local playerId = PlayerResource:GetPlayer(keys.player)
    if keys.bOption == 1 then playerId.bIsAutoCombineEnabled = true else playerId.bIsAutoCombineEnabled = false end
end

function OnConfig14Checked(index, keys)
    local playerId = PlayerResource:GetPlayer(keys.player)
    if keys.bOption == 1 then playerId.IsPadoruEnable = true else playerId.IsPadoruEnable = false end
end

LinkLuaModifier("modifier_master_invis", "abilities/general/modifiers/modifier_master_invis", LUA_MODIFIER_MOTION_NONE)

function OnConfig15Checked(index, keys)
    local playerId = EntIndexToHScript(keys.player)
    local hero = PlayerResource:GetPlayer(keys.player):GetAssignedHero()

    local master2 = hero.MasterUnit2

    if keys.bOption == 1 then 
        master2:AddNewModifier(master2, nil, "modifier_master_invis", {})
    else 
    	master2:RemoveModifierByName("modifier_master_invis")
    end
end


function OnHeroClicked(Index, keys)
    local playerId = EntIndexToHScript(keys.player)
    local hero = PlayerResource:GetPlayer(keys.player):GetAssignedHero()

    print(hero:GetName())
    if hero:GetName() == 'npc_dota_hero_troll_warlord' then 
        if hero.IsOnBoarded then 
            print('Drake On Golden Hind')
        end
    end
    if hero.IsIntegrated or hero.IsMounted or hero.IsOnBoarded then
        -- Find the transport
        local units = FindUnitsInRadius(hero:GetTeam(), hero:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, FIND_CLOSEST, false)
        for k,v in pairs(units) do
            local unitname = v:GetUnitName()
            print(v:GetUnitName())
            if hero:IsAlive() and v:IsAlive() and v:GetOwnerEntity() == hero then
                if string.match(v:GetUnitName(), "medea_ancient_dragon") or string.match(v:GetUnitName(), "gille_gigantic_horror") or string.match(v:GetUnitName(), "drake_golden_hind") then
                    local playerData = {
                        transport = v:entindex()
                    }
                    CustomGameEventManager:Send_ServerToPlayer( hero:GetPlayerOwner(), "player_selected_hero_in_transport", playerData )
                    break
                end
            end
        end
    end
end

CFG = {
		C02 = false,
		C03 = false,
		C04 = false,
		C05 = false,
		C06 = false,
		C07 = false,
		C08 = false,
		C09 = false,
		C10 = false,
		C11 = false,
		C12 = false,
		C13 = false,
		C14 = false,
		C15 = false,
	}