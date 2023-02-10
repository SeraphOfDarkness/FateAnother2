require('abilities/ascension/ascension_skill')
Ascension = {}

Ascension.AscendablePlayers = 
{
	"301222766"
}

function Ascension:Ascend(keys)
	local player = keys.playerid
	local steamid = tostring(PlayerResource:GetSteamAccountID(player))
	local caster = PlayerResource:GetSelectedHeroEntity(player)
	
	for i, playerid in pairs(Ascension.AscendablePlayers) do
		if (steamid == playerid) then
			caster:AddAbility("ascension_skill")
			local ascension = caster:FindAbilityByName("ascension_skill")
			if ascension then 
				ascension:CastAbility()
			end
			GameRules:SendCustomMessage("<b><font color='SlateBlue'>"..FindName(caster:GetName()).."</b></font>".."<font color='Gold'> HAS ASCENDED</font>", 0, 0)
		end
		break
	end
end

function Ascension:UndoAscension(keys)
	local player = keys.playerid
	local steamid = tostring(PlayerResource:GetSteamAccountID(player))
	local caster = PlayerResource:GetSelectedHeroEntity(player)
	
	for i, playerid in pairs(Ascension.AscendablePlayers) do
		if (steamid == playerid) then
			caster:AddAbility("undoascension_skill")
			local undoascension = caster:FindAbilityByName("ascension_skill")
			if undoascension then 
				undoascension:CastAbility()
			end
			GameRules:SendCustomMessage("<b><font color='SlateBlue'>"..FindName(caster:GetName()).."</b></font>".."<font color='Gold'> HAS ASCENDED</font>", 0, 0)
		end
		break
	end
end