function FindCustomUIRoot(panel)
{
	var targetPanel = panel;
	while (targetPanel.id != "CustomUIRoot")
	{
		//$.Msg(targetPanel.id)
		targetPanel = targetPanel.GetParent();
	}
	return targetPanel;
}

function GetHUDRootUI(){
	var rootUI = $.GetContextPanel();
	while(rootUI.id != "Hud" && rootUI.GetParent() != null){
		rootUI = rootUI.GetParent();
	}
	return rootUI;
}

// create an ability button
function CreateAbilityPanel(panel, unit, abilityIndex, bIsAttribute)
{
	var ability = Entities.GetAbility(unit, abilityIndex); 
	var abilityname = Abilities.GetAbilityName(ability)
	var abilityPanel = $.CreatePanel("Panel", panel, abilityname);
	abilityPanel.BLoadLayout("file://{resources}/layout/custom_game/fateanother_ability.xml", false, false );
	abilityPanel.SetAbility(ability, unit, Game.IsInAbilityLearnMode(), bIsAttribute);
}

function CreateAbilityPanelByName(panel, unit, abilityName, bIsAttribute)
{
	var ability = Entities.GetAbilityByName(unit, abilityName); 
	var abilityPanel = $.CreatePanel("Panel", panel, "");
	abilityPanel.BLoadLayout("file://{resources}/layout/custom_game/fateanother_ability.xml", false, false );
	abilityPanel.SetAbility(ability, unit, Game.IsInAbilityLearnMode(), bIsAttribute);
	var buttonPanel = abilityPanel.FindChildTraverse("AbilityButton")
	buttonPanel.style["width"] = "45px";
	buttonPanel.style["height"] = "45px";
	var hotkeyPanel = abilityPanel.FindChildTraverse("HotkeyText");
	if (abilityName == "caster_5th_wall_of_flame")
	{
		hotkeyPanel.text = "Q";
	}
	else if (abilityName == "caster_5th_silence")
	{
		hotkeyPanel.text = "W";
	}
	else if (abilityName == "caster_5th_divine_words")
	{
		hotkeyPanel.text = "E";
	}
	else if (abilityName == "caster_5th_mana_transfer")
	{
		hotkeyPanel.text = "D";
	}
	else if (abilityName == "caster_5th_close_spellbook")
	{
		hotkeyPanel.text = "F";
	}
	else if (abilityName == "caster_5th_sacrifice")
	{
		hotkeyPanel.text = "R";
	}
}

function asikL(data)
{
	var msg = '';
	$.Msg(data);
	var t = '';
	var r = ' ';
	if (data.s1 == 1) {
		t = 'Loading Player Data';
	} else if (data.s1 == 2) {
		t = 'Loading Server Data';
	} else if (data.s1 == 3) {
		t = 'Sending Player Data';
	};

	if (data.s2 == 1) {
		r = 'Load Success';
	} else if (data.s2 == 0) {
		r = 'Load Failed - Could not find any data';
	} else if (data.s2 == -1) {
		r = 'Load Failed - Unable to contact server';
	};

	var p = '';
	if (data.s3 >= 0) {
		p = 'Player Id ' + data.s3;
		msg = t + ' ' + p + ' ' + r;
	} else {
		msg = t + ' ' + r;
	};

	$.Msg(msg);
}

function wetup(data)
{

	$.Msg(data);
}

(function()
{
	GameEvents.Subscribe( "asklklk", asikL);
	GameEvents.Subscribe( "ayiopiuwioer", wetup);
})();
