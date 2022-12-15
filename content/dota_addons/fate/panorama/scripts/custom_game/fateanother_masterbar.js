"use strict";
var ping_seal_4_start = null;
var ping_seal_3_start = null;
var ping_seal_2_start = null;
var ping_seal_1_start = null;
var ALT_HOLD = false;
var MastarUnit; 
var right_side;
var hide;
var MasterBar = (function () {
    function MasterBar(panel) {
        var _this = this;
        this.panel = panel;

        //Game.AddCommand("+ACT_CMD_1", SealHotkeys(1), "", 0);
        //Game.AddCommand("-ACT_CMD_1", Null, "", 0);
        //Game.AddCommand("+ACT_CMD_2", SealHotkeys(2), "", 0);
        //Game.AddCommand("-ACT_CMD_2", Null, "", 0);
        //Game.AddCommand("+ACT_CMD_3", SealHotkeys(3), "", 0);
        //Game.AddCommand("-ACT_CMD_3", Null, "", 0);
        //Game.AddCommand("+ACT_CMD_4", SealHotkeys(4), "", 0);
        //Game.AddCommand("-ACT_CMD_4", Null, "", 0);
        //Game.AddCommand("+ACT_CMD_5", SealHotkeys(5), "", 0);
        //Game.AddCommand("-ACT_CMD_5", Null, "", 0);//

        GameEvents.Subscribe("player_selected_hero", function (data) {
            _this.CreateAbilities(data);

            MastarUnit = data.shardUnit;
            //var unit = data.shardUnit;

            //Game.AddCommand("+ACT_CMD_1", SealHotkey(unit, 0), "", 0);
            //Game.AddCommand("-ACT_CMD_1", Null, "", 0);
            //Game.AddCommand("+ACT_CMD_2", SealHotkey(unit, 1), "Command Seal 2", 0);
            //Game.AddCommand("-ACT_CMD_2", Null, "", 0);
            //Game.AddCommand("+ACT_CMD_3", SealHotkey(unit, 2), "Command Seal 3", 0);
            //Game.AddCommand("-ACT_CMD_3", Null, "", 0);
            //Game.AddCommand("+ACT_CMD_4", SealHotkey(unit, 5), "Command Seal 4", 0);
            //Game.AddCommand("-ACT_CMD_4", Null, "", 0);
            //Game.AddCommand("+ACT_CMD_5", SealHotkey(unit, 3), "Command Seal 5", 0);
            //Game.AddCommand("-ACT_CMD_5", Null, "", 0);
            
            //if (Game.GetKeybindForInventorySlot( 0 ) !== "1") {
            //    Game.CreateCustomKeyBind( "1", "+ACT_COMMAND_SEAL_1" );
            //};
            //$.RegisterKeyBind($.GetContextPanel(),'KEY_F1')
            //var panel = GetHUDRootUI().FindChildTraverse("MasterBar");
            //if (panel.visible == true) {
            //    if (Game.GetKeybindForInventorySlot( 1 ) !== "2") {
            //        Game.CreateCustomKeyBind( "2", "+ACT_COMMAND_SEAL_2" );
            //    };
            //    if (Game.GetKeybindForInventorySlot( 2 ) !== "3") {
            //        Game.CreateCustomKeyBind( "3", "+ACT_COMMAND_SEAL_3" );
            //    };
            //    if (Game.GetKeybindForInventorySlot( 3 ) !== "4") {
            //        Game.CreateCustomKeyBind( "4", "+ACT_COMMAND_SEAL_4" );
            //    };
            //    if (Game.GetKeybindForInventorySlot( 4 ) !== "5") {
            //        Game.CreateCustomKeyBind( "5", "+ACT_COMMAND_SEAL_5" );
            //    };
            //};
            
            //$.Msg('Add keybind Command')
        });
        
        this.QuestListener = CustomNetTables.SubscribeNetTableListener("tutorial", function(table, tableKey, data) {
            if (tableKey == "subquest")  {
                if (data["quest7a"] == false) {
                    ping_seal_4_start = true ;
                    //$.Msg('quest seal 4 ping')
                } else if (data["quest7a"] == true) {
                    ping_seal_4_start = false; 
                    this.seal_4_ping.visible = false;
                };
                if (data["quest8a"] == false) {
                    ping_seal_3_start = true ;
                    $.Msg('quest seal 3 ping')
                } else if (data["quest8a"] == true) {
                    ping_seal_3_start = false; 
                    this.seal_3_ping.visible = false;
                };
                if (data["quest9a"] == false) {
                    ping_seal_2_start = true ;
                    //$.Msg('quest seal 2 ping')
                } else if (data["quest9a"] == true) {
                    ping_seal_2_start = false; 
                    this.seal_2_ping.visible = false;
                };
                if (data["quest10a"] == false) {
                    ping_seal_1_start = true ;
                   // $.Msg('quest seal 1 ping')
                } else if (data["quest10a"] == true) {
                    ping_seal_1_start = false; 
                    this.seal_1_ping.visible = false;
                };
                if (data["quest10b"] == false) {
                    ping_seal_2_start = true ;
                    //$.Msg('quest seal 2 ping')
                } else if (data["quest10b"] == true) {
                    ping_seal_2_start = false; 
                    this.seal_2_ping.visible = false;
                };
                if (data["quest10c"] == false) {
                    ping_seal_4_start = true ;
                    $.Msg('quest seal 4 ping')
                } else if (data["quest10c"] == true) {
                    ping_seal_4_start = false; 
                    this.seal_4_ping.visible = false;
                };
            };
        });
        this.UpdatePing();
    }

    MasterBar.prototype.UpdatePing = function() {
        var that = this

        if (Game.GetMapInfo().map_display_name == "fate_tutorial") {
            if (ping_seal_4_start == true) {
                this.seal_4_ping = $.GetContextPanel().FindChildTraverse("MasterBarQuest").FindChildTraverse("cmd_seal_4")

                if (!!this.seal_4_ping) {
                    this.seal_4_ping.SetHasClass("AbilityBorder",true);
                    this.seal_4_ping.SetHasClass("AbilityBorderLoopPing",true);
                    this.seal_4_ping.style.marginLeft = '240px' ;
                    $.Schedule(1.0, function() {    
                        this.seal_4_ping = $.GetContextPanel().FindChildTraverse("MasterBarQuest").FindChildTraverse("cmd_seal_4")
                        this.seal_4_ping.SetHasClass("AbilityBorder",false);
                        this.seal_4_ping.SetHasClass("AbilityBorderLoopPing",false);
                    }); 
                };
            };

            if (ping_seal_3_start == true) {
                this.seal_3_ping = $.GetContextPanel().FindChildTraverse("MasterBarQuest").FindChildTraverse("cmd_seal_3")
                if (!!this.seal_3_ping) {
                    this.seal_3_ping.SetHasClass("AbilityBorder",true);
                    this.seal_3_ping.SetHasClass("AbilityBorderLoopPing",true);
                    this.seal_3_ping.style.marginLeft = '105px' ;
                    $.Schedule(1.0, function() {    
                        this.seal_3_ping = $.GetContextPanel().FindChildTraverse("MasterBarQuest").FindChildTraverse("cmd_seal_3")
                        this.seal_3_ping.SetHasClass("AbilityBorder",false);
                        this.seal_3_ping.SetHasClass("AbilityBorderLoopPing",false);
                    }); 
                };
            };

            if (ping_seal_2_start == true) {
                this.seal_2_ping = $.GetContextPanel().FindChildTraverse("MasterBarQuest").FindChildTraverse("cmd_seal_2")
                if (!!this.seal_2_ping) {
                    this.seal_2_ping.SetHasClass("AbilityBorder",true);
                    this.seal_2_ping.SetHasClass("AbilityBorderLoopPing",true);
                    this.seal_2_ping.style.marginLeft = '50px' ;
                    $.Schedule(1.0, function() {    
                        this.seal_2_ping = $.GetContextPanel().FindChildTraverse("MasterBarQuest").FindChildTraverse("cmd_seal_2")
                        this.seal_2_ping.SetHasClass("AbilityBorder",false);
                        this.seal_2_ping.SetHasClass("AbilityBorderLoopPing",false);
                    }); 
                };
            };
            if (ping_seal_1_start == true) {
                this.seal_1_ping = $.GetContextPanel().FindChildTraverse("MasterBarQuest").FindChildTraverse("cmd_seal_1")
                if (!!this.seal_1_ping) {
                    this.seal_1_ping.SetHasClass("AbilityBorder",true);
                    this.seal_1_ping.SetHasClass("AbilityBorderLoopPing",true);
                    this.seal_1_ping.style.marginLeft = '-20px' ;
                    $.Schedule(1.0, function() {    
                        this.seal_1_ping = $.GetContextPanel().FindChildTraverse("MasterBarQuest").FindChildTraverse("cmd_seal_1")
                        this.seal_1_ping.SetHasClass("AbilityBorder",false);
                        this.seal_1_ping.SetHasClass("AbilityBorderLoopPing",false);
                    }); 
                };
            };
            
            $.Schedule(1.0, function() {        
                that.UpdatePing();
            });
        };
    };

    MasterBar.prototype.CreateAbilities = function (data) {
        var _this = this;
        for (var i = 0; i < Entities.GetAbilityCount(data.shardUnit); i++) {
            var ability = Entities.GetAbility(data.shardUnit, i);
            var abilityName = Abilities.GetAbilityName(ability);
            var str = "cmd_seal";
            if (abilityName.match(str) != null) {
                var panel = $.CreatePanel("DOTAAbilityPanel", this.panel.FindChildTraverse("MasterBarSeals"), abilityName);
                new SealButton(panel, ability, abilityName, data.shardUnit, abilityName.substring(9));
                var ping = $.CreatePanel("Panel", $("#MasterBarQuest"), abilityName);
                //panel.overridedisplaykeybind 
                //var hotkey = $.CreatePanel("Panel", panel, "");
                //hotkey.AddClass("AbilityHotkey");
                //var hotkeytext = $.CreatePanel("Label", hotkey, "");
                //hotkeytext.AddClass("AbilityHotkeyText");
                //hotkeytext.text = i + 1;
                //ping.visible = false;
            }
        }
        this.Toggle();
        var button = this.panel.FindChildTraverse("MasterBarButton");
        button.SetPanelEvent("onmouseactivate", function () {
            _this.Toggle();
        });
    };
    MasterBar.prototype.Toggle = function () {
        if (right_side == true) {
            hide = "closedr";
        } else {
            hide = "closed";
        }
        var b = this.panel.BHasClass(hide);
        this.panel.SetHasClass(hide, !b);
        var string = b ? "#MasterBar_close" : "#MasterBar_open";
        string = $.Localize(string).toUpperCase();
        var label = this.panel.FindChildTraverse("MasterBarButtonLabel");
        label.text = string;
    };
    return MasterBar;
}());

function OnALTToggle()
{
    $.Msg('ALT is Press or Release');
    ALT_HOLD = !ALT_HOLD;
}

function Null() 
{

}

function SealHotkeys(Hotkey)
{
    $.Msg('Set is Press or Release');
    $.Msg( Hotkey + ' is Press');
    var panel = GetHUDRootUI().FindChildTraverse("MasterBar");
    var iPID = Game.GetLocalPlayerID();

    if (Players.IsSpectator(iPID)) {
        return;
    };

    if (panel.visible == true && Players.GetSelectedEntities( iPID ) == Players.GetPlayerHeroEntityIndex( iPID )) {
        var hero = Players.GetPlayerHeroEntityIndex( iPID );
        var name = Entities.GetUnitName( hero);
        if (name !== "npc_dota_hero_wisp") {
            var ability = Entities.GetAbility(MastarUnit, Hotkey);
            GameEvents.SendCustomGameEventToServer("player_cast_seal", {iUnit: MastarUnit, iAbility: ability});
        };
    };
    //return function()
    //{
        
    //}
}

function CustomMasterBar(data)
{
    right_side = data.bOption;
    var panel = $.GetContextPanel();

    if (right_side == true) {
        panel.style.horizontalAlign = "right";
        panel.FindChildTraverse("MasterBarBG").style.horizontalAlign = "right";
        panel.FindChildTraverse("MasterBarSeals").style.horizontalAlign = "right";
        panel.FindChildTraverse("MasterBarButton").style.horizontalAlign = "left";
        panel.FindChildTraverse("MasterBarButton").style['border-top-right-radius'] = "0px 0px";
        panel.FindChildTraverse("MasterBarButton").style['border-bottom-right-radius'] = "0px 0px";
        panel.FindChildTraverse("MasterBarButton").style['border-top-left-radius'] = "16px 16px";
        panel.FindChildTraverse("MasterBarButton").style['border-bottom-left-radius'] = "16px 16px";
        panel.FindChildTraverse("MasterBarButtonLabel").style.horizontalAlign = "left";
        panel.FindChildTraverse("MasterBarButtonLabel").style['vertical-align'] = "top";
        panel.FindChildTraverse("MasterBarButtonLabel").style['pre-transform-rotate2d'] = "270deg";
    } else {
        panel.style.horizontalAlign = "left";
        panel.FindChildTraverse("MasterBarBG").style.horizontalAlign = "left";
        panel.FindChildTraverse("MasterBarSeals").style.horizontalAlign = "left";
        panel.FindChildTraverse("MasterBarButton").style.horizontalAlign = "right";
        panel.FindChildTraverse("MasterBarButton").style['border-top-right-radius'] = "16px 16px";
        panel.FindChildTraverse("MasterBarButton").style['border-bottom-right-radius'] = "16px 16px";
        panel.FindChildTraverse("MasterBarButton").style['border-top-left-radius'] = "0px 0px";
        panel.FindChildTraverse("MasterBarButton").style['border-bottom-left-radius'] = "0px 0px";
        panel.FindChildTraverse("MasterBarButtonLabel").style.horizontalAlign = "right";
        panel.FindChildTraverse("MasterBarButtonLabel").style['vertical-align'] = "bottom";
        panel.FindChildTraverse("MasterBarButtonLabel").style['pre-transform-rotate2d'] = "90deg";
    }
}

function SealHotkey(Master, Seal) 
{
    $.Msg('5 is Press or Release');
    $.Msg( Seal + ' is Press');

    return function () 
    {
        //if (ALT_HOLD == false) {
        //    return;
        //};

        $.Msg( Seal + ' is Press');
        var panel = GetHUDRootUI().FindChildTraverse("MasterBar");
        var iPID = Game.GetLocalPlayerID();



        if (Players.IsSpectator(iPID)) {
            return;
        };

        if (panel.visible == true && Players.GetSelectedEntities( iPID ) == Players.GetPlayerHeroEntityIndex( iPID )) {      
            var hero = Players.GetPlayerHeroEntityIndex( iPID );
            var name = Entities.GetUnitName( hero);
            var ability = Entities.GetAbility(Master, Seal);
            if (name !== "npc_dota_hero_wisp") {
                $.Msg('Seal hotkey use');
                GameEvents.SendCustomGameEventToServer("player_cast_seal", {iUnit: Master, iAbility: ability});
            };
        };
        
   }
}

var SealButton = (function () {
    function SealButton(panel, ability, name, unit, hotkey) {
        var _this = this;
        this.panel = panel;
        this.ability = ability;
        this.name = name;
        this.unit = unit;
        this.panel.overrideentityindex = this.ability;
        //this.panel.FindChildTraverse("HotkeyContainer").style.visibility = "collapse";
        //if (hotkey == "1") {
            this.panel.FindChildTraverse("HotkeyContainer").style.visibility = "collapse";
        //} else {
        //    this.panel.FindChildTraverse("HotkeyContainer").FindChildTraverse("HotkeyText").text = hotkey;
        //};
        this.panel.SetPanelEvent("onactivate", function () {
            _this.OnClick();
        });
        this.panel.SetPanelEvent("onmouseover", function () {
            _this.OnHover(true);
        });
        this.panel.SetPanelEvent("onmouseout", function () {
            _this.OnHover(false);
        });
    }

    SealButton.prototype.OnClick = function () {
        GameEvents.SendCustomGameEventToServer("player_cast_seal", {iUnit: this.unit, iAbility: this.ability});
    };
    SealButton.prototype.OnHover = function (b) {
        if (b) {
            $.DispatchEvent("DOTAShowAbilityTooltip", this.panel, this.name);
        }
        else {
            $.DispatchEvent("DOTAHideAbilityTooltip", this.panel);
        }
    };
    return SealButton;
}());

var masterBar = new MasterBar($.GetContextPanel());

(function()
{
   // $("#FateConfigBoard").visible = false;
    //$("#FateConfigBGMList").SetSelected(1);
    //GameEvents.Subscribe( "player_chat", PlayerChat);
    GameEvents.Subscribe( "custom_master_bar", CustomMasterBar);
})();

//Game.AddCommand("+ACT_CMD_1", SealHotkeys(0), "", 0);
//Game.AddCommand("+ACT_CMD_2", SealHotkeys(1), "", 0);
//Game.AddCommand("+ACT_CMD_3", SealHotkeys(2), "", 0);
//Game.AddCommand("+ACT_CMD_4", SealHotkeys(5), "", 0);
//Game.AddCommand("+ACT_CMD_5", SealHotkeys(3), "", 0);

