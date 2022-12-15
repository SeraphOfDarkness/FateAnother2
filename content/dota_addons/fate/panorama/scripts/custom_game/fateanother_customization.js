// Set up global variables
var g_GameConfig = FindCustomUIRoot($.GetContextPanel());
var globalContext = $.GetContextPanel();
var ping_strike_air_start = null;
var ping_str_start = null; 
var ping_agi_start = null; 
var ping_int_start = null;
g_GameConfig.customize_open = false;

function GetTalentButton()
{
	var root = GetHUDRootUI();
	var talentButton = root.FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block").FindChildTraverse("AbilitiesAndStatBranch").FindChildTraverse("StatBranch");
	return talentButton;
}

function OnCustomizeButtonclose()
{
    var customizePanel = $("#CustomizationBoard");
	var customizePanelLabel = $("#CustomizationBoardLabel");
    if (!customizePanel)
        return;

    customizePanel.visible = !customizePanel.visible;
	customizePanelLabel.visible = customizePanel.visible;
	//ping quest here
}

function OnCustomizeButtonPressed()
{
    //var customizePanel = $("#CustomizationBoard");
	//var customizePanelLabel = $("#CustomizationBoardLabel");
    //if (!customizePanel)
    //    return;

    //customizePanel.visible = !customizePanel.visible;
	//customizePanelLabel.visible = customizePanel.visible;
	//ping quest here
	g_GameConfig.customize_open = !g_GameConfig.customize_open
}

function CreateFateTalentButton(){
	var fateButton = GetTalentButton()
	
	fateButton.SetPanelEvent("onmouseover", OnCustomizeButtonShowNewbie);
	fateButton.SetPanelEvent("onmouseout", OnCustomizeButtonHideNewbie);
	fateButton.SetPanelEvent("onactivate", OnCustomizeButtonPressed);
	
	var statBranchGraphics = fateButton.FindChildTraverse("StatBranchGraphics")
	statBranchGraphics.style.visibility = "collapse";
	
	var statBranchBG = fateButton.FindChildTraverse("StatBranchBG")
	statBranchBG.style.visibility = "collapse";
	
    fateButton.style.backgroundImage = "url(\"file://{images}/misc/customize.png\")";
    
    var fateButtonOverlay = $.CreatePanel("Panel", fateButton, "FateTalentButtonOverlay");
    fateButtonOverlay.style.width = "100%";
    fateButtonOverlay.style.height = "100%";
    fateButtonOverlay.style.backgroundImage = "url(\"file://{images}/misc/customize_active.png\")";
    fateButtonOverlay.style.opacity = "0";
    fateButtonOverlay.style.transition = "opacity 0.3s ease-in-out 0.0s";
}

function RemoveChilds(panel)
{
	for (i=0;i<panel.GetChildCount(); i++)
	{
		panel.GetChild(i).RemoveAndDeleteChildren();
	}
}

function UpdateAttributeList(data)
{
	//$.Msg("updating attribute list")
	var attributePanel = $("#CustomizationAttributeLayout");
	var statPanel = $("#CustomizationStatLayout");
	var cooldownPanel = $("#CustomizationCooldownLayout");
	var shardPanel = $("#CustomizationShardLayout");
	if (!attributePanel || !statPanel || !shardPanel)
		return;

	//$.Msg("panels present. linking abilities...")
	var queryUnit = data.masterUnit; //Players.GetLocalPlayerPortraitUnit();
	var queryUnit2 = data.shardUnit;

	for(i=0; i<5; i++) {
		CreateAbilityPanel(attributePanel, queryUnit, i, true);
	};
	CreateAbilityPanel(cooldownPanel, queryUnit, 5, true);
	for(i=6; i<15; i++) {
		CreateAbilityPanel(statPanel, queryUnit, i, true);
	};

	for(i=6; i<10; i++) {
		CreateAbilityPanel(shardPanel, queryUnit2, i, true);
	};
}

function RecieveMessage(data)
{

	var localPlayerId = Game.GetLocalPlayerID();
	var hero = data.hero; 
	var combo = data.combo; 
	var msg = $.Localize( "#" + hero + "_enable_combo");
	GameEvents.SendCustomGameEventToServer("player_say_to_team", {playerId: localPlayerId, message: msg});
}

function RecieveMessage2(data)
{

	var localPlayerId = Game.GetLocalPlayerID();
	var avarice = data.avarice; 
	var msg = $.Localize( "#Player_Take_Avarice" + avarice);
	GameEvents.SendCustomGameEventToServer("player_say_to_team", {playerId: localPlayerId, message: msg});
}

// create an ability context button, which does not reference existing ability of unit
function CreateContextAbilityPanel(panel)
{
	var abilityPanel = $.CreatePanel("Panel", panel, "");
	abilityPanel.BLoadLayout("file://{resources}/layout/custom_game/fateanother_context_ability.xml", false, false );
}

function UpdateStatPanel(data)
{
	$("#STRAmount").text = (data.STR || 0) + " / 50";
	$("#AGIAmount").text = (data.AGI || 0) +  " / 50";
	$("#INTAmount").text = (data.INT || 0) +  " / 50";
	$("#DMGAmount").text = (data.DMG || 0) +  " / 50";
	$("#ARMORAmount").text = (data.ARMOR || 0) +  " / 50";
	$("#HPREGAmount").text = (data.HPREG || 0) +  " / 50";
	$("#MPREGAmount").text = (data.MPREG || 0) +  " / 50";
	$("#MSAmount").text = (data.MS || 0) +  " / 50";
	$("#GoldAmount").text = (data.Gold || 0) +  " / 10";
	$("#CustomizationShardNumber").text = (data.ShardAmount || 0);
}

function OnCustomizeButtonShowNewbie()
{
    var panel = GetTalentButton();
    var overlay = panel.FindChildTraverse("FateTalentButtonOverlay");
    overlay.style.opacity = "1.0";
    var customizePanel = $("#CustomizationBoard");
    if (customizePanel.visible == false) {
		$.DispatchEvent('DOTAShowTextTooltip', panel, "#Fateanother_Customize_Button");
	};
	var customizePanel = $("#CustomizationBoard");
	var customizePanelLabel = $("#CustomizationBoardLabel");
    if (!customizePanel)
        return;

    

    customizePanel.visible = true;
	customizePanelLabel.visible = true;
}

function OnCustomizeButtonHideNewbie()
{
    var panel = GetTalentButton();
    var overlay = panel.FindChildTraverse("FateTalentButtonOverlay");
    overlay.style.opacity = "0.0";
	$.DispatchEvent( 'DOTAHideTextTooltip', panel ); 

	var customizePanel = $("#CustomizationBoard");
	var customizePanelLabel = $("#CustomizationBoardLabel");
    if (!customizePanel)
        return;

    if (g_GameConfig.customize_open == true) {
    	return;
    };

    customizePanel.visible = false;
	customizePanelLabel.visible = false;
}

function OnCustomizeButtonShowTooltip()
{
    var panel = GetTalentButton();
    var overlay = panel.FindChildTraverse("FateTalentButtonOverlay");
    overlay.style.opacity = "1.0";
    var customizePanel = $("#CustomizationBoard");
    if (customizePanel.visible == false) {
		$.DispatchEvent('DOTAShowTextTooltip', panel, "#Fateanother_Customize_Button");
	};
}

function OnCustomizeButtonHideTooltip(panel)
{
    var panel = GetTalentButton();
    var overlay = panel.FindChildTraverse("FateTalentButtonOverlay");
    overlay.style.opacity = "0.0";
	$.DispatchEvent( 'DOTAHideTextTooltip', panel );
}


function AttributeShowTooltip()
{
	var attrText = $("#CustomizationAttributeText");
	$.DispatchEvent('DOTAShowTextTooltip', attrText, "#Fateanother_Customize_Attributes_Tooltip");
}

function AttributeHideTooltip()
{
	var attrText = $("#CustomizationAttributeText"); 
	$.DispatchEvent( 'DOTAHideTextTooltip', attrText );
}

function StatShowTooltip()
{
	var statText = $("#CustomizationStatText"); 
	$.DispatchEvent( 'DOTAShowTextTooltip', statText, "#Fateanother_Customize_Stats_Tooltip");
}

function StatHideTooltip()
{
	var statText = $("#CustomizationStatText"); 
	$.DispatchEvent( 'DOTAHideTextTooltip', statText );
}

function ComboShowTooltip()
{
	var comboText = $("#CustomizationComboText"); 
	$.DispatchEvent( 'DOTAShowTextTooltip', comboText, "#Fateanother_Customize_Special_Cooldowns_Tooltip");
}

function ComboHideTooltip()
{
	var comboText = $("#CustomizationComboText"); 
	$.DispatchEvent( 'DOTAHideTextTooltip', comboText );
}

function ShardShowTooltip()
{
	var shardText = $("#CustomizationShardText"); 
	$.DispatchEvent( 'DOTAShowTextTooltip', shardText, "#Fateanother_Customize_Special_Shards_Tooltip");
}
function ShardHideTooltip()
{
	var shardText = $("#CustomizationShardText"); 
	$.DispatchEvent( 'DOTAHideTextTooltip', shardText );
}
function PrintToClient(data)
{
	$.Msg(data.text);
}

function CreateErrorMessage(msg){
    var reason = msg.reason || 80;
    if (msg.message){
        GameEvents.SendEventClientSide("dota_hud_error_message", {"splitscreenplayer":0,"reason":reason ,"message":msg.message} );
    }
    else{
        GameEvents.SendEventClientSide("dota_hud_error_message", {"splitscreenplayer":0,"reason":reason} );
    }
}

function UpdatePing()
{

	//$.Msg(Game.GetMapInfo());
	if (Game.GetMapInfo().map_display_name == "fate_tutorial") {
		var CustomizePanel = globalContext.FindChildTraverse("CustomizationBoard");
		if (ping_strike_air_start !== null) {
			if (ping_strike_air_start == true) {
				if (strike_air_ping == null) {
					var strike_air_ping = $.CreatePanel("Panel", $("#CustomizationAttributePanel"), "ping_strike_air");
					strike_air_ping.SetHasClass("AbilityBorder",true);
					strike_air_ping.SetHasClass("AbilityBorderLoopPing",true);
					strike_air_ping.style.marginLeft = '120px' ;
					//local.actualxoffset = strike_air.actualxoffset - strike_air.contentswidth/2 ;
					//local.actualyoffset = strike_air.actualyoffset - strike_air.contentsheight/2 ;
					$.Schedule(1.0, function() {    
						strike_air_ping.SetHasClass("AbilityBorder",false);
						strike_air_ping.SetHasClass("AbilityBorderLoopPing",false);
					});
				};
			};
		};
		if (ping_str_start !== null) {
			if (ping_str_start == true) {
				if (str_ping == null) {
					var str_ping = $.CreatePanel("Panel", $("#CustomizationStatPanel"), "str_ping");
					str_ping.SetHasClass("AbilityBorder",true);
					str_ping.SetHasClass("AbilityBorderLoopPing",true);
					str_ping.style.marginLeft = '-12px' ;
					//local.actualxoffset = strike_air.actualxoffset - strike_air.contentswidth/2 ;
					//local.actualyoffset = strike_air.actualyoffset - strike_air.contentsheight/2 ;
					$.Schedule(1.0, function() {    
						str_ping.SetHasClass("AbilityBorder",false);
						str_ping.SetHasClass("AbilityBorderLoopPing",false);
					});
				};
			};
		};
		if (ping_agi_start !== null ) {
			if (ping_agi_start == true) {
				if (agi_ping == null) {
					var agi_ping = $.CreatePanel("Panel", $("#CustomizationStatPanel"), "agi_ping");
					agi_ping.SetHasClass("AbilityBorder",true);
					agi_ping.SetHasClass("AbilityBorderLoopPing",true);
					agi_ping.style.marginLeft = '57px' ;
					//local.actualxoffset = strike_air.actualxoffset - strike_air.contentswidth/2 ;
					//local.actualyoffset = strike_air.actualyoffset - strike_air.contentsheight/2 ;
					$.Schedule(1.0, function() {    
						agi_ping.SetHasClass("AbilityBorder",false);
						agi_ping.SetHasClass("AbilityBorderLoopPing",false);
					});
				};
			};
		};
		if (ping_int_start !== null ) {
			if (ping_int_start == true) {
				if (int_ping == null) {
					var int_ping = $.CreatePanel("Panel", $("#CustomizationStatPanel"), "int_ping");
					int_ping.SetHasClass("AbilityBorder",true);
					int_ping.SetHasClass("AbilityBorderLoopPing",true);
					int_ping.style.marginLeft = (120) + 'px' ;
					//local.actualxoffset = strike_air.actualxoffset - strike_air.contentswidth/2 ;
				//local.actualyoffset = strike_air.actualyoffset - strike_air.contentsheight/2 ;
					$.Schedule(1.0, function() {    
						int_ping.SetHasClass("AbilityBorder",false);
						int_ping.SetHasClass("AbilityBorderLoopPing",false);
					});
				};
			};
		};
	};

	$.Schedule(1.0, function() {    	
       	UpdatePing();
    });
}

(function()
{
    //$.RegisterForUnhandledEvent( "DOTAAbility_LearnModeToggled", OnAbilityLearnModeToggled);

	//GameEvents.Subscribe( "dota_portrait_ability_layout_changed", UpdateAbilityList );
	//GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateAbilityList );
	//GameEvents.Subscribe( "dota_player_update_query_unit", UpdateAbilityList );
	//GameEvents.Subscribe( "dota_ability_changed", UpdateAbilityList );
	//GameEvents.Subscribe( "dota_hero_ability_points_changed", UpdateAbilityList );
	GameUI.SetCameraDistance(1600);
	GameEvents.Subscribe( "combo_declare", RecieveMessage);
	GameEvents.Subscribe( "avarice_declare", RecieveMessage2);
	GameEvents.Subscribe( "player_selected_hero", UpdateAttributeList);
	GameEvents.Subscribe( "servant_stats_updated", UpdateStatPanel );
	GameEvents.Subscribe( "error_message_fired", CreateErrorMessage);
	GameEvents.Subscribe( "player_chat_lua", PrintToClient );
	GameEvents.Subscribe( "player_notify_master_mana", OnCustomizeButtonShowTooltip );
	OnCustomizeButtonclose();
	CreateFateTalentButton();
	
	var QuestListener = CustomNetTables.SubscribeNetTableListener("tutorial", function(table, tableKey, data) {
		if (tableKey == "subquest")  {
			UpdatePing();
			if (data["quest5a"] == false) {
				ping_strike_air_start = true ;
			} else if (data["quest5a"] == true) {
				ping_strike_air_start = false; 
				globalContext.FindChildTraverse("CustomizationBoard").FindChildTraverse("CustomizationAttributePanel").FindChildTraverse("ping_strike_air").visible = false;
			};
			if (data["quest6a"] == false) {
				ping_str_start = true ;
			} else if (data["quest6a"] == true) {
				ping_str_start = false; 
				globalContext.FindChildTraverse("CustomizationBoard").FindChildTraverse("CustomizationStatPanel").FindChildTraverse("str_ping").visible = false;
			};
			if (data["quest6b"] == false) {
				ping_agi_start = true ;
			} else if (data["quest6b"] == true) {
				ping_agi_start = false;
				globalContext.FindChildTraverse("CustomizationBoard").FindChildTraverse("CustomizationStatPanel").FindChildTraverse("agi_ping").visible = false; 
			};
			if (data["quest6c"] == false) {
				ping_int_start = true ;
			} else if (data["quest6c"] == true) {
				ping_int_start = false; 
				globalContext.FindChildTraverse("CustomizationBoard").FindChildTraverse("CustomizationStatPanel").FindChildTraverse("int_ping").visible = false;
			};
		};
	});
})();