﻿HeroSelection = HeroSelection or class({})

function HeroSelection:constructor()

    _G.GameMap = GetMapName()

    if _G.GameMap == "fate_tutorial" then 
        print("Tutorial Start!")

        local heroList = LoadKeyValues("scripts/npc/herolist.txt")
        heroList["npc_dota_hero_wisp"] = nil
        self.AllHeroes = heroList
        self.AvailableHeroes = {npc_dota_hero_legion_commander = 1}
        --table.insert(self.AvailableHeroes, "npc_dota_hero_legion_commander", 1)
        
        self.Picked = {}

        self.HoveredHeroes = {}

        self.HoverListener = CustomGameEventManager:RegisterListener("selection_hero_hover", function(id, ...)
            Dynamic_Wrap(self, "OnHover")(self, ...) 
        end)
        self.ClickListener = CustomGameEventManager:RegisterListener("selection_hero_click", function(id, ...)
            Dynamic_Wrap(self, "OnSelect")(self, ...) 
        end)
        self.RandomListener = CustomGameEventManager:RegisterListener("selection_hero_random", function(id, ...)
            Dynamic_Wrap(self, "OnRandom")(self, ...) 
        end)

        self.Time = 5 
        if IsInToolsMode() then self.Time = 5 end

        CustomNetTables:SetTableValue("selection", "all", self.AllHeroes)
        CustomNetTables:SetTableValue("selection", "available", self.AvailableHeroes)
        CustomNetTables:SetTableValue("selection", "hovered", self.HoveredHeroes)
        CustomNetTables:SetTableValue("selection", "picked", self.Picked)
        CustomNetTables:SetTableValue("selection", "time", {time = self.Time})
    else
        self.Picked = {}

        local heroList = LoadKeyValues("scripts/npc/herolist.txt")
        heroList["npc_dota_hero_wisp"] = nil
        self.AvailableHeroes = heroList

        self.HoveredHeroes = {}

        self.HoverListener = CustomGameEventManager:RegisterListener("selection_hero_hover", function(id, ...)
            Dynamic_Wrap(self, "OnHover")(self, ...) 
        end)
        self.ClickListener = CustomGameEventManager:RegisterListener("selection_hero_click", function(id, ...)
            Dynamic_Wrap(self, "OnSelect")(self, ...) 
        end)
        self.RandomListener = CustomGameEventManager:RegisterListener("selection_hero_random", function(id, ...)
            Dynamic_Wrap(self, "OnRandom")(self, ...) 
        end)

        self.Time = 65 
	    if IsInToolsMode() then self.Time = 5 end

        CustomNetTables:SetTableValue("selection", "all", self.AvailableHeroes)
        CustomNetTables:SetTableValue("selection", "available", self.AvailableHeroes)
        CustomNetTables:SetTableValue("selection", "hovered", self.HoveredHeroes)
        CustomNetTables:SetTableValue("selection", "picked", self.Picked)
        CustomNetTables:SetTableValue("selection", "time", {time = self.Time})
    end
end

function HeroSelection:UpdateTime()
    self.Time = math.max(self.Time - 1, 0)
    CustomNetTables:SetTableValue("selection", "time", {time = self.Time})

    if self.Time > 0 then
        Timers:CreateTimer(1.0, function()
            self:UpdateTime()
        end)
    end
end

function HeroSelection:CanPick(playerId)
    local player = PlayerResource:GetPlayer(playerId)
    local currentHero = player:GetAssignedHero()

    return self.Time <= 60 and currentHero ~= nil and currentHero:GetName() == "npc_dota_hero_wisp" and  not self.Picked[playerId]
end

function HeroSelection:OnHover(args)
    local playerId = args.playerId
    local hero = args.hero

    self.HoveredHeroes[playerId] = hero

    CustomNetTables:SetTableValue("selection", "hovered", self.HoveredHeroes)
end

function HeroSelection:OnSelect(args)
    local playerId = args.playerId
    local hero = args.hero

    if not self:CanPick(playerId) or not self.AvailableHeroes[hero] then
        return
    end

    self.HoveredHeroes[playerId] = nil
    self.Picked[playerId] = hero

    self:AssignHero(playerId, hero, false)
    --print(playerId)
    --print(hero)

    CustomNetTables:SetTableValue("selection", "hovered", self.HoveredHeroes)
end

function HeroSelection:OnRandom(args)
    local playerId = args.playerId

    if not self:CanPick(playerId) then
        return
    end

    local availableHeroesNumber = 0
    for _,_ in pairs(self.AvailableHeroes) do
        availableHeroesNumber = availableHeroesNumber + 1
    end

    local randomIndex = RandomInt(1, availableHeroesNumber)

    local index = 1
    for hero,_ in pairs(self.AvailableHeroes) do
        if index == randomIndex then

            self.Picked[playerId] = hero
            self.HoveredHeroes[playerId] = nil

            self:AssignHero(playerId, hero, true)

            CustomNetTables:SetTableValue("selection", "hovered", self.HoveredHeroes)

	    return
	end
	index = index + 1
    end
end

function HeroSelection:AssignHero(playerId, hero)
    PrecacheUnitByNameAsync(hero, function()
        Timers:CreateTimer(function()
            local conn_state = PlayerResource:GetConnectionState(playerId)

            --0 = No connection
            --1 = Bot
            --2 = Player
            --3 = Disconnected

            if conn_state == 3 or conn_state == 0 then 
                return 1
            else
                local oldHero = PlayerResource:GetSelectedHeroEntity(playerId)
                oldHero:SetRespawnsDisabled(true)
                PlayerResource:ReplaceHeroWith(playerId, hero, 3000, 0)
                UTIL_Remove(oldHero)
                return nil
            end
        end)        
    end)

    self.AvailableHeroes[hero] = nil
    CustomNetTables:SetTableValue("selection", "available", self.AvailableHeroes)
    CustomNetTables:SetTableValue("selection", "picked", self.Picked)
end

function HeroSelection:RemoveHero(hero)
    self.AvailableHeroes[hero] = nil

    CustomNetTables:SetTableValue("selection", "available", self.AvailableHeroes)
end

