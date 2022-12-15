var g_GameConfig = FindCustomUIRoot($.GetContextPanel());
var transport = null;
var bIsMounted = false;
var bRenderCamera = false;
var MasterUnit; 

function OnFateConfigButtonPressed()
{
    var configPanel = $("#FateConfigBoard");
    if (!configPanel)
        return;
    configPanel.visible = !configPanel.visible;

    var buffBar = GameUI.CustomUIConfig().buffBar;
    configPanel.FindChildTraverse("option6").enabled = buffBar.visible;
    if (buffBar.visible) {
        configPanel.FindChildTraverse("option6").checked = buffBar.enabled;
    }
}


function OnCameraDistSubmitted()
{
    var panel = $("#ConfigCameraValue");
    var number = parseFloat(panel.text);
    if (number > 1900)
    {
        number = 1900;
    }
    GameUI.SetCameraDistance(number);
    panel.text = number.toString();
}

function RenderCamera(){
    var oSlider = $("#ConfigCameraSlider");
    var fMin = 1600;
    var fMax = 1900;
    var fDistance = fMin + oSlider.value * (fMax - fMin);

    if (fDistance > fMax){
        fDistance = fMax;
    };

    GameUI.SetCameraDistance(fDistance);
    
    if (Game.GetMapInfo().map_display_name == 'fate_tutorial'){
        if(questID == 16 && fDistance == 1900){
            var playerId = Players.GetLocalPlayer();
            var hero = Players.GetPlayerHeroEntityIndex(playerId);
            var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
            GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
        };
    };
    if(bRenderCamera === true){
        $.Schedule(0.016, RenderCamera);
    };
};

function OnCamSliderIn(){
    bRenderCamera = true;
    RenderCamera();
};

function OnCamSliderOut(){
    bRenderCamera = false;
};

function SkillZoomOut(data){
    GameUI.SetCameraDistance(data.camera);
}

function OnConfig1Toggle()
{
    g_GameConfig.bIsConfig1On = !g_GameConfig.bIsConfig1On;
    GameEvents.SendCustomGameEventToServer("config_option_1_checked", {player: Players.GetLocalPlayer(), bOption: g_GameConfig.bIsConfig1On})
}

function OnConfig2Toggle()
{
    g_GameConfig.bIsConfig2On = !g_GameConfig.bIsConfig2On;
    GameEvents.SendCustomGameEventToServer("config_option_2_checked", {player: Players.GetLocalPlayer(), bOption: g_GameConfig.bIsConfig2On})
}


function OnConfig3Toggle()
{
    g_GameConfig.bIsConfig3On = !g_GameConfig.bIsConfig3On;
}


function OnConfig4Toggle()
{
    g_GameConfig.bIsConfig4On = !g_GameConfig.bIsConfig4On;
    GameEvents.SendCustomGameEventToServer("config_option_4_checked", {player: Players.GetLocalPlayer(), bOption: g_GameConfig.bIsConfig4On})
}

function OnConfig5Toggle()
{
    var panel = GetHUDRootUI().FindChildTraverse("MasterStatusPanel");
    panel.ToggleClass("Hidden");
}

function OnConfig6Toggle() {
    var configPanel = $.GetContextPanel();
    var option6 = configPanel.FindChildTraverse("option6");
    var buffBar = GameUI.CustomUIConfig().buffBar;
    if (option6.checked) {
        buffBar.Enable();
    } else {
        buffBar.Disable();
    }
}

function OnConfig7Toggle(){
    var panel = GetHUDRootUI().FindChildTraverse("MasterBar");
    panel.ToggleClass("Hidden");
    //if (panel.visible == true) {
        //$.Msg('show master');
    //    Game.CreateCustomKeyBind( "2", "+ACT_COMMAND_SEAL_2" );
    //    Game.CreateCustomKeyBind( "3", "+ACT_COMMAND_SEAL_3" );
    //    Game.CreateCustomKeyBind( "4", "+ACT_COMMAND_SEAL_4" );
    //    Game.CreateCustomKeyBind( "5", "+ACT_COMMAND_SEAL_5" );
    //} else {
        //$.Msg('hide master');
    //    Game.CreateCustomKeyBind( "2", DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP2 );
    //    Game.CreateCustomKeyBind( "3", "DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP3" );
    //    Game.CreateCustomKeyBind( "4", DOTAKeybindCommand_t.DOTA_KEYBIND_NONE );
    //    Game.CreateCustomKeyBind( "5", DOTAKeybindCommand_t.DOTA_KEYBIND_NONE );
    //};
}

function OnConfig8Toggle()
{
    g_GameConfig.bIsConfig8On = !g_GameConfig.bIsConfig8On;
    GameEvents.SendCustomGameEventToServer("config_option_8_checked", {player: Players.GetLocalPlayer(), bOption: g_GameConfig.bIsConfig8On})
}

function OnConfig9Toggle()
{
    g_GameConfig.bIsConfig9On = !g_GameConfig.bIsConfig9On;
    GameEvents.SendCustomGameEventToServer("config_option_9_checked", {player: Players.GetLocalPlayer(), bOption: g_GameConfig.bIsConfig9On})
}

function OnConfig11Toggle()
{
    g_GameConfig.bIsConfig11On = !g_GameConfig.bIsConfig11On;
    GameEvents.SendCustomGameEventToServer("config_option_11_checked", {player: Players.GetLocalPlayer(), bOption: g_GameConfig.bIsConfig11On})
}

function OnConfig10Toggle()
{
    const iRandomNumberCringe = Math.floor(Math.random() * 99999) * 5;
    for (var i = 0; i < 5; i++) {
        var hk = i + 1;
        var seal = i;
        if (i == 3) {
            seal = 5;
        } else if (i == 4) {
            seal = 3;
        };
        var num = iRandomNumberCringe + hk;
        Game.AddCommand("+ACT_CMD_" + num, SealHotkeys(seal), "" + num, 512);
        Game.AddCommand("-ACT_CMD_" + num, Null, "" + num, 512);
        Game.CreateCustomKeyBind( hk, "+ACT_CMD_" + num );
    //Game.CreateCustomKeyBind( "2", "+ACT_CMD_2" );
    //Game.CreateCustomKeyBind( "3", "+ACT_CMD_3" );
    //Game.CreateCustomKeyBind( "4", "+ACT_CMD_4" );
    //Game.CreateCustomKeyBind( "5", "+ACT_CMD_5" );
        AddHotkey("cmd_seal_" + hk, hk);
    };
    //AddHotkey("cmd_seal_2", 2);
    //AddHotkey("cmd_seal_3", 3);
    //AddHotkey("cmd_seal_4", 4);
    //AddHotkey("cmd_seal_5", 5);
}

function OnConfig12Toggle()
{
    g_GameConfig.bIsConfig12On = !g_GameConfig.bIsConfig12On;
    var eventBar = GetHUDRootUI().FindChildTraverse("EventsBar");

    if (g_GameConfig.bIsConfig12On == false) {
        eventBar.visible = false;
    } else {
        eventBar.visible = true;
    };
}

function OnConfig13Toggle()
{
    g_GameConfig.bIsConfig13On = !g_GameConfig.bIsConfig13On;
    GameEvents.SendCustomGameEventToServer("config_option_13_checked", {player: Players.GetLocalPlayer(), bOption: g_GameConfig.bIsConfig13On})
}

function AddHotkey(Seal, Hotkey)
{
    var panel = GetHUDRootUI().FindChildTraverse("MasterBar").FindChildTraverse("MasterBarSeals");
    var button = panel.FindChildTraverse(Seal);
    button.FindChildTraverse("HotkeyContainer").visible = true;
    button.FindChildTraverse("HotkeyContainer").FindChildTraverse("HotkeyText").text = Hotkey;
}

function PlayerChat(event)
{
    var txt = event.text;
    var id = event.playerid;
    var playerID = Players.GetLocalPlayer();
    $.Msg(txt);
    if (playerID == id)
    {
        if (txt == "-bgmoff" && g_GameConfig.bIsBGMOn) {
            StopBGM();
            g_GameConfig.bIsBGMOn = false;
            $.Msg("BGM off by " + playerID)
        }
        if (txt == "-bgmon" && !g_GameConfig.bIsBGMOn) {
            PlayBGM();
            g_GameConfig.bIsBGMOn = true;
            $.Msg("BGM on by " + playerID)
        }
    }
    //GameEvents.SendCustomGameEventToServer("player_chat_panorama", {pID: playerID, text: txt})
}

function TurnBGMOff(event)
{
    StopBGM();
    g_GameConfig.bIsBGMOn = false;
}

function TurnBGMOn(event)
{
    PlayBGM();
    g_GameConfig.bIsBGMOn = true;
}

function CheckTransportSelection(data)
{
    if (g_GameConfig.bIsConfig3On) { return 0; }
    var playerID = Players.GetLocalPlayer();
    var mainSelected = Players.GetLocalPlayerPortraitUnit();
    var hero = Players.GetPlayerHeroEntityIndex( playerID )

    if (mainSelected == hero && transport && bIsMounted == true)
    {
        // check if transport is currently carrying Caster inside
        if (Entities.IsAlive( transport ))
        {
            GameUI.SelectUnit(transport, false);
        }
    }

}
function RegisterTransport(data)
{
    transport = data.transport;
}
function UpdateMountStatus(data)
{
    bIsMounted = data.bIsMounted;
    $.Msg('Mount');
    $.Msg(bIsMounted);
}

function RegisterMasterUnit(data) {
    var config = GameUI.CustomUIConfig()
    var hero = data.hero;
    var masterUnit = data.shardUnit;
    config.masterUnits[hero] = masterUnit;
}

function RegisterAllMasterUnits(data) {
    var config = GameUI.CustomUIConfig()
    config.masterUnits = data;
}

function Null() 
{

}

function SealHotkeys(Seal)
{
    return function () 
    {
        //$.Msg('Set is Press or Release');
        //$.Msg( Hotkey + ' is Press');
        var panel = GetHUDRootUI().FindChildTraverse("MasterBar");
        var iPID = Game.GetLocalPlayerID();

        if (Players.IsSpectator(iPID)) {
            return;
        };

        if (panel.visible == true && Players.GetSelectedEntities( iPID ) == Players.GetPlayerHeroEntityIndex( iPID )) {
            var hero = Players.GetPlayerHeroEntityIndex( iPID );
            var name = Entities.GetUnitName( hero);
            if (name !== "npc_dota_hero_wisp") {
                $.Msg('master ' + MasterUnit);
                $.Msg('hotkey ' + Seal);
                var ability = Entities.GetAbility(MasterUnit, Seal);
                GameEvents.SendCustomGameEventToServer("player_cast_seal", {iUnit: MasterUnit, iAbility: ability});
            };
        };
    }
}

(function()
{
   // $("#FateConfigBoard").visible = false;
    //$("#FateConfigBGMList").SetSelected(1);
    //GameEvents.Subscribe( "player_chat", PlayerChat);
    GameEvents.Subscribe( "player_bgm_on", TurnBGMOn);
    GameEvents.Subscribe( "player_bgm_off", TurnBGMOff);
    GameEvents.Subscribe( "dota_player_update_selected_unit", CheckTransportSelection );
    GameEvents.Subscribe( "player_summoned_transport", RegisterTransport);
    GameEvents.Subscribe( "player_mount_status_changed", UpdateMountStatus);
    GameEvents.Subscribe( "cam_distance", SkillZoomOut);

    var config = GameUI.CustomUIConfig()
    if (!config.masterUnits) {
        config.masterUnits = {}
    }

    GameEvents.Subscribe( "player_register_master_unit", RegisterMasterUnit);
    GameEvents.Subscribe( "player_register_all_master_units", RegisterAllMasterUnits);
    GameEvents.Subscribe("player_selected_hero2", function (data) {
        MasterUnit = data.shardUnit;
    });

    //var questListener = CustomNetTables.SubscribeNetTableListener("tutorial", function(table, tableKey, data) {
    //    if (tableKey == "questID")  {
    //        $.Msg(data);
    //        questID = data["questID"] + 2;    
    //    };
    //});
})();
