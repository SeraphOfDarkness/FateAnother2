

if FateGameMode == nil then
    FateGameMode = class({})
end

function FateGameMode:InitGameMode()
    FateGameMode = self
    self.coreParameter = LoadKeyValues("scripts/npc/core/fate_core.txt")
    self.Fate_Game_Mode = LoadKeyValues("scripts/npc/core/fate_game_mode.txt")
    --print('Init Game Mode')

    -- Find out which map we are using
    _G.GameMap = GetMapName()
    if _G.GameMap == "fate_elim_6v6" then
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 6)
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 6)
        GameRules:SetHeroRespawnEnabled(false)
        GameRules:SetGoldPerTick(1)
        GameRules:SetGoldTickTime(1.0)
        GameRules:SetStartingGold(0)  
        GameRules:SetPreGameTime(370) 
        ServerTables:CreateTable("MaxPlayers", {total_player = 12})
    elseif _G.GameMap == "fate_elim_7v7" then
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, self.Fate_Game_Mode[_G.GameMap].PLAYER_NUM)
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, self.Fate_Game_Mode[_G.GameMap].PLAYER_NUM)
        GameRules:SetHeroRespawnEnabled(false)
        GameRules:SetGoldPerTick(self.Fate_Game_Mode[_G.GameMap].GOLD_TICK)
        GameRules:SetGoldTickTime(self.Fate_Game_Mode[_G.GameMap].GOLD_TIME)
        GameRules:SetStartingGold(self.Fate_Game_Mode[_G.GameMap].GOLD_SPAWN)  
        GameRules:SetPreGameTime(self.Fate_Game_Mode[_G.GameMap].PREGAME_TIME) 

    elseif _G.GameMap == "fate_trio_rumble_3v3v3v3" then
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 3)
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 3)
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 3)
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 3)
        GameRules:SetGoldPerTick(7.5)
        GameRules:SetGoldTickTime(1.0)
        GameRules:SetStartingGold(0)  
        GameRules:SetPreGameTime(105)
        ServerTables:CreateTable("MaxPlayers", {total_player = 12})
    elseif _G.GameMap == "fate_trio" then
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 3)
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 3)
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 3)
        GameRules:SetGoldPerTick(7.5)
        GameRules:SetGoldTickTime(1.0)
        GameRules:SetStartingGold(0)  
        GameRules:SetPreGameTime(105)
        ServerTables:CreateTable("MaxPlayers", {total_player = 9})
    elseif _G.GameMap == "fate_ffa" then
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 1 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 1 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 1 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_3, 1 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_4, 1 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_5, 1 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_6, 1 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_7, 1 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_8, 1 )
        GameRules:SetGoldPerTick(7.5)
        GameRules:SetGoldTickTime(1.0)
        GameRules:SetStartingGold(0)
        GameRules:SetPreGameTime(105)
        ServerTables:CreateTable("MaxPlayers", {total_player = 10})
    elseif _G.GameMap == "fate_tutorial" then
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 1)
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0)
        GameRules:SetHeroRespawnEnabled(false)
        GameRules:SetGoldPerTick(0)
        GameRules:SetGoldTickTime(0.0)
        GameRules:SetStartingGold(0)    
        GameRules:SetPreGameTime(5)
        ServerTables:CreateTable("MaxPlayers", {total_player = 1})
    end

    -- Set game rules
    -- team selection
    GameRules:SetIgnoreLobbyTeamsInCustomGame( self.coreParameter.IGNORE_LOBBY_TEAM )
    -- hero selection
    GameRules:SetCustomGameSetupTimeout(self.coreParameter.SETUP_TIMEOUT)
    GameRules:SetHeroSelectionTime(self.coreParameter.HERO_SELECTION_TIME)
    GameRules:SetShowcaseTime(self.coreParameter.SHOWCASE_TIME)
    GameRules:SetStrategyTime(self.coreParameter.STRATEGY_TIME)
    GameRules:SetSameHeroSelectionEnabled(self.coreParameter.SAME_HERO)
    if self.coreParameter.SAME_HERO == true then
    	GameRules:GetGameModeEntity():SetCustomGameForceHero(self.coreParameter.FORCE_HERO)
    end
    -- sound + announcement
    GameRules:SetFirstBloodActive(self.coreParameter.FIRST_BLOOD_TRIGGERED)
    GameRules:GetGameModeEntity():SetAnnouncerDisabled( self.coreParameter.ANNOUNCEMENT_DISABLE )
    GameRules:SetCustomGameAllowBattleMusic(self.coreParameter.BATTLE_MUSIC)
    GameRules:SetCustomGameAllowHeroPickMusic(self.coreParameter.HERO_PICK_MUSIC)
    GameRules:GetGameModeEntity():SetGoldSoundDisabled( self.coreParameter.DISABLE_GOLD_SOUNDS )
    SendToServerConsole("dota_music_battle_enable 0")
    SendToConsole("dota_music_battle_enable 0")  
    -- shop + stash
    GameRules:SetUseUniversalShopMode(self.coreParameter.UNIVERSAL_SHOP_MODE)
    GameRules:GetGameModeEntity():SetStashPurchasingDisabled ( self.coreParameter.STASH_PURCHASE )
    GameRules:GetGameModeEntity():SetCustomBackpackSwapCooldown(self.coreParameter.CUSTOM_BACKPACK_SWAP_COOLDOWN)
    Convars:SetInt("dota_max_physical_items_purchase_limit", self.coreParameter.LIMIT_ITEM)
    -- terrain 
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(self.coreParameter.DISABLE_FOG_OF_WAR_ENTIRELY)
    GameRules:SetTimeOfDay(10.30)
    -- UI 
    GameRules:GetGameModeEntity():SetAlwaysShowPlayerNames(self.coreParameter.SHOW_PLAYER_NAME)
    GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride ( self.coreParameter.USE_CUSTOM_TOP_BAR_VALUES )
    GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( self.coreParameter.TOP_BAR_VISIBLE )
    -- hero 
    GameRules:SetUseCustomHeroXPValues(self.coreParameter.USE_CUSTOM_HERO_XP)
    GameRules:GetGameModeEntity():SetUseCustomHeroLevels ( self.coreParameter.USE_CUSTOM_HERO_LEVELS )
    GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_TABLE )
    GameRules:SetUseBaseGoldBountyOnHeroes(self.coreParameter.DEFAULT_BOUNTY)
    GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( self.coreParameter.REMOVE_ILLUSION_ON_DEAD )
    GameRules:GetGameModeEntity():SetCustomBuybackCostEnabled( self.coreParameter.CUSTOM_BUYBACK_COST_ENABLED )
    GameRules:GetGameModeEntity():SetCustomBuybackCooldownEnabled( self.coreParameter.CUSTOM_BUYBACK_COOLDOWN_ENABLED )
    GameRules:GetGameModeEntity():SetBuybackEnabled( self.coreParameter.BUYBACK_ENABLED )
    GameRules:GetGameModeEntity():SetLoseGoldOnDeath( self.coreParameter.LOSE_GOLD_ON_DEAD )
    -- attribute 
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP, self.coreParameter.FATE_STR_HP)
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP_REGEN, self.coreParameter.FATE_STR_HP_REGEN)
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA, self.coreParameter.FATE_INT_MANA)
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN, self.coreParameter.FATE_INT_MANA_REGEN)
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED, self.coreParameter.FATE_AGI_ASPD)
    GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR, self.coreParameter.FATE_AGI_ARMOR)
    -- end game
    GameRules:SetCustomGameEndDelay(self.coreParameter.END_DELAY)
    GameRules:SetCustomVictoryMessageDuration(self.coreParameter.VICTORY_MESSAGE)
    GameRules:SetPostGameTime(self.coreParameter.POST_GAME_TIME) 
    -- filter 
    GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( FateGameMode, "ExecuteOrderFilter" ), FateGameMode )
    GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(FateGameMode, "ModifyGoldFilter"), FateGameMode)
    GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(FateGameMode, "TakeDamageFilter"), FateGameMode)
    GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(FateGameMode, "ModifyExperienceFilter"), FateGameMode)



    
    
end

