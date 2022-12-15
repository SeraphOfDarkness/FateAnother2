//////////////////////////////////////////////////////////////////////////////
/////////////////// Made by ZeFiRoFT /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

var globalContext = $.GetContextPanel();
//globalContext.visible = false;
//globalContext.FindChildTraverse("DraftSelection").visible = false;


var heroes = [
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_spectre",
	"npc_dota_hero_phantom_lancer",
	"npc_dota_hero_ember_spirit",
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_bounty_hunter",
	"npc_dota_hero_doom_bringer",
	"npc_dota_hero_skywrath_mage",
	"npc_dota_hero_vengefulspirit",
	"npc_dota_hero_huskar",
	"npc_dota_hero_sven",
	"npc_dota_hero_shadow_shaman",
	"npc_dota_hero_chen",
	"npc_dota_hero_lina",
	"npc_dota_hero_omniknight",
	"npc_dota_hero_enchantress",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_mirana",
	"npc_dota_hero_queenofpain",
	"npc_dota_hero_windrunner",
	"npc_dota_hero_drow_ranger",
	"npc_dota_hero_tidehunter",
	"npc_dota_hero_beastmaster",
	"npc_dota_hero_riki",
	"npc_dota_hero_naga_siren",
	"npc_dota_hero_dark_willow",
	"npc_dota_hero_troll_warlord",
	"npc_dota_hero_monkey_king",
	"npc_dota_hero_tusk",
    "npc_dota_hero_zuus",
    "npc_dota_hero_axe",
    "npc_dota_hero_death_prophet",
    "npc_dota_hero_enigma",
    "npc_dota_hero_night_stalker",
    "npc_dota_hero_disruptor",
	"random",
    "ban",
    "error"
]

var sopkq = {
    120166692: "120166692",
	919069943: "919069943",
    113435706: "113435706",
    141762471: "141762471",
}

var names = [
	"Artoria Pendragon",
	"Artoria Alter",
	"Cu Chulainn",
	"Emiya",
	"Medusa",
	"Medea",
	"Sasaki Kojiro",
	"Hassan-i-Sabbah",
	"Heracles",
	"Gilgamesh",
	"Angra Mainyu",
	"Diarmuid",
	"Lancelot",
	"Gilles de Rais",
	"Iskandar",
	"Nero Claudius",
	"Gawain",
	"Tamamo no Mae",
	"Li Shuwen",
	"Jeanne d'Arc",
	"Astolfo",
	"Nursery Rhyme",
	"Atalanta",
	"Vlad III",
	"Karna",
	"Jack The Ripper",
	"Chloe von Einzbern",
	"Okita Souji",
	"Francis Drake",
	"Scathach",
	"Mordred",
    "Frankenstein",
    "Lu Bu",
    "Elizabeth Bathory",
    "Amakusa Shirou Tokisada",
    "Edmond Dantes",
    "Zhuge Liang",
	"Random",
    "Ban",
    "Error"
]

function GetIndex(array, object)
{
	for (i=0; i<array.length; i++)
	{
		if (array[i] == object) 
		{
			return i
			
		}
	}
	return -1
}

var vokgTviN = "An" + "o" + 'th' + 'er '

function BindOnPick(panel, hero)
{
	panel.SetPanelEvent(
		"onmouseactivate",
		function() {
			if (!!DS.pickedplayer[DS.playerId] || DS.availableHeroes[hero] === null || !!DS.picked[DS.playerID]) {
				return;
			};
			/*if (Players.GetTeam(DS.playerId) == 2 && !!DS.UnselectedRed[hero]) {
				$.Msg('Not enough Mana');
				return;
			} else if (Players.GetTeam(DS.playerId) == 3 && !!DS.UnselectedBlack[hero]) {
				$.Msg('Not enough Mana');
				return;
			};*/

			if (hero == "random") {
				GameEvents.SendCustomGameEventToServer("draft_hero_random", {
					playerId: DS.playerId,
					teamNum: DS.PickOrder["teamNum"],
				});
			} else {
				$.Msg(DS.PickOrder["teamNum"]);
				GameEvents.SendCustomGameEventToServer("draft_hero_pick", {
					playerId: DS.playerId,
					hero: hero,
					teamNum: DS.PickOrder["teamNum"],
				});
			};
		}
	);
}

var gam = "F" + "a" + 't' + 'e'

function BindOnBan(panel, hero)
{
	panel.SetPanelEvent(
		"onmouseactivate",
		function() {
			if (!!DS.banned[hero] || DS.availableHeroes[hero] === null) {
				return;
			};

			if (hero == "random") {
				return;
			} else {
				GameEvents.SendCustomGameEventToServer("draft_hero_ban", {
					playerId: DS.playerId,
					hero: hero,
				});
			};
		}
	);
}

function DraftSelection() {
	var that = this;
	this.playerId = Game.GetLocalPlayerID();
	this.container = $.GetContextPanel().FindChild("DraftSelection");

    this.NormalUIListener = CustomNetTables.SubscribeNetTableListener("nselection", function(table, tableKey, data) {
        if (tableKey == "hs") {
            $.Msg(data);
            if (!!data["reconnect"] && data["playerId"] == Players.GetLocalPlayer() ) {
                $.Msg('ok?');
                that.normal_mode = data["reconnect"];
            } else {
                $.Msg('mode?');
                that.normal_mode = data["mode"];
            }
        }
    });

    this.UIListener = CustomNetTables.SubscribeNetTableListener("nselection", function(table, tableKey, data) {
        if (tableKey == "hs") {
            $.Msg(data);
            if (!!data["reconnect"] && data["playerId"] == Players.GetLocalPlayer() ) {
                $.Msg('ok?');
                that.mode = data["reconnect"];
            } else {
                $.Msg('mode?');
                that.mode = data["mode"];
            }
            globalContext.visible = false;
            globalContext.FindChildTraverse("DraftSelection").visible = false;
        }
    });

    /*this.UIListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "draftmode") {
        	$.Msg(data);
            if (!!data["reconnect"] && data["playerId"] == Players.GetLocalPlayer() ) {
            	$.Msg('ok?');
            	that.mode = data["reconnect"];
            } else {
            	$.Msg('mode?');
            	that.mode = data["draft"];
            }
        }
    });*/
	this.timeListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "time") {
        	$.Msg(data);
            that.time = data.time;
        }
    });

    this.allListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "all") {
        	$.Msg(data);
            that.allHeroes = data;
        }
    });

    this.availableListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "available") {
        	$.Msg(data);
            that.availableHeroes = data;
        }
    });

    this.banListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "banned") {
        	$.Msg('Ban Servants: ');
        	$.Msg(data);
            that.banned = data;
        }
    });

    this.PickOrderListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "pickorder") {
        	$.Msg('Pick Order: ');
        	$.Msg(data);
            that.PickOrder1 = data["playerId1"];
            that.PickOrder2 = data["playerId2"];
        };
    });

    this.BanOrderListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "banorder") {
        	$.Msg('Ban Order: ');
        	$.Msg(data);
            that.BanOrder = data['playerId'];
        };
    });

    /*this.BlackUnselectedListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "black_unselected") {
        	$.Msg('Unselected Black Team: ');
        	$.Msg(data);
            that.UnSelectedBlack = data;
        }
    });

    this.RedUnselectedListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "red_unselected") {
        	$.Msg('Unselected Red Team: ');
        	$.Msg(data);
            that.UnSelectedRed = data;
        }
    });*/


    var timeTable = CustomNetTables.GetTableValue("draft", "time");
    this.time = timeTable && timeTable.time;
    //var chatBoxPanel = $.CreatePanel("Panel", this.container, "");
    //chatBoxPanel.AddClass('ChatPosition');
    //chatBoxPanel.BLoadLayout("file://{resources}/layout/custom_game/fateanother_chat_box.xml", false, false );

    this.statusLabel = this.container.FindChildTraverse("status");
    this.timeLabel = this.container.FindChildTraverse("time");
    this.heroes = this.container.FindChildTraverse("heroes");
    /*this.tenPanel = this.container.FindChildTraverse("tenheroes");*/
    this.PlayersRedPanel = this.container.FindChildTraverse("LeftBar");
    this.PlayersBlackPanel = this.container.FindChildTraverse("RightBar");
	this.SelectedHeroPanel = this.container.FindChildTraverse("SelectedPanel2");
	this.SelectedHeroPanel1 = this.container.FindChildTraverse("Selected1");
	this.SelectedHeroPanel2 = this.container.FindChildTraverse("SelectedPanel2").FindChild("Selected2");
	this.SelectedHeroPanel3 = this.container.FindChildTraverse("SelectedPanel2").FindChild("Selected3");
	//this.RedManaGuage = this.container.FindChildTraverse("TopBar").FindChild("RedMana").FindChild("RedManaGuage");
	//this.BlackManaGuage = this.container.FindChildTraverse("TopBar").FindChild("BlackMana").FindChild("BlackManaGuage");
	this.selectedbar = this.container.FindChildTraverse("selectedbar");
	this.selectedbart = this.selectedbar.FindChildTraverse("selectedbartext");
    this.selectedleft = this.container.FindChildTraverse("SelectedLeft");
    this.selectedright = this.container.FindChildTraverse("SelectedRight");
    this.SkinNamePanel = this.container.FindChildTraverse("SkinNamePanel");
	this.selectedbarPlayerName1 = this.SelectedHeroPanel1.FindChildTraverse("SelectedPlayerNameLabel");
	this.selectedbarPlayerName2 = this.SelectedHeroPanel2.FindChildTraverse("SelectedPlayerNameLabel");
	this.selectedbarPlayerName3 = this.SelectedHeroPanel3.FindChildTraverse("SelectedPlayerNameLabel");
	this.SelectedHeroPanel.visible = false;	
	this.SelectedHeroPanel1.visible = false;
	this.selectedbar.visible = false;	
    this.selectedright.visible = false;   
    this.selectedleft.visible = false;   
    this.SkinNamePanel.visible = false;
    this.ban_signal = null;
    this.summon_signal = null;
    this.random_signal = false;
    this.random_signal_2 = false;
}

DraftSelection.prototype.Construct = function() {
	//$.Msg('draft start construct');
    var that = this;

    var hero = Players.GetPlayerHeroEntityIndex(this.playerId);
    var name = Entities.GetUnitName(hero);
    var playerHasPicked = !!this.picked[this.playerId];


    for (var RedPlayers in this.RedTeam) {
    	var redTeamPanel = this.PlayersRedPanel.FindChild(RedPlayers);
    	if (redTeamPanel == null) {
    		$.Msg('Player Id: ' + RedPlayers)
    		redTeamPanel = $.CreatePanel("Panel", this.PlayersRedPanel, RedPlayers);
    		var playername = Players.GetPlayerName(this.RedTeam[RedPlayers]);
    		redTeamPanel.AddClass("PlayerBarRed")
    		redTeamPortrait = $.CreatePanel("Panel", redTeamPanel, "portraitRed");
    		redTeamPortrait.AddClass("portraitRed")
    		redTeamPlayername = $.CreatePanel("Panel", redTeamPanel, "playerNameRed");
    		redTeamPlayername.AddClass("playerNameRed")
    		redTeamPlayernameText = $.CreatePanel("Label", redTeamPlayername, "playerNameLabel");
    		redTeamPlayernameText.AddClass("playerNameLabel")
    		redTeamHeroname = $.CreatePanel("Panel", redTeamPanel, "heroNameRed");
    		redTeamHeroname.AddClass("heroNameRed")
    		redTeamHeronameText = $.CreatePanel("Label", redTeamHeroname, "heroNameLabel");
    		redTeamHeronameText.AddClass("heroNameLabel")
    		redTeamPlayernameText.text = playername;
        };	
        this.PortraitChange(redTeamPanel, redTeamPanel.FindChildTraverse('portraitRed'), this.RedTeam[RedPlayers])
    };

    for (var BlackPlayers in this.BlackTeam) {
    	var blackTeamPanel = this.PlayersBlackPanel.FindChild(BlackPlayers);
    	if (blackTeamPanel == null) {
    		blackTeamPanel = $.CreatePanel("Panel", this.PlayersBlackPanel, BlackPlayers);
    		var playername = Players.GetPlayerName(this.BlackTeam[BlackPlayers]);
    		blackTeamPanel.AddClass("PlayerBarBlack")
    		blackTeamPortrait = $.CreatePanel("Panel", blackTeamPanel, "portraitBlack");
    		blackTeamPortrait.AddClass("portraitBlack")
    		blackTeamPlayername = $.CreatePanel("Panel", blackTeamPanel, "playerNameBlack");
    		blackTeamPlayername.AddClass("playerNameBlack")
    		blackTeamPlayernameText = $.CreatePanel("Label", blackTeamPlayername, "playerNameLabel");
    		blackTeamPlayernameText.AddClass("playerNameLabel")
    		blackTeamHeroname = $.CreatePanel("Panel", blackTeamPanel, "heroNameBlack");
    		blackTeamHeroname.AddClass("heroNameBlack")
    		blackTeamHeronameText = $.CreatePanel("Label", blackTeamHeroname, "heroNameLabel");
    		blackTeamHeronameText.AddClass("heroNameLabel")
    		blackTeamPlayernameText.text = playername;
        };
        this.PortraitChange(blackTeamPanel, blackTeamPanel.FindChildTraverse('portraitBlack'),this.BlackTeam[BlackPlayers])
    };

    for (var heroName in this.allHeroes) {
        var heroPanel = this.heroes.FindChild(heroName);
        if (heroPanel == null) {
            heroPanel = $.CreatePanel("Image", this.heroes, heroName);
            heroPanel.SetImage("s2r://panorama/images/custom_game/draft/" + heroName + "_png.vtex");
            heroPanel.AddClass("hero");
            this.BindOnActivate(heroPanel, heroName);
        };

        if (!!!this.availableHeroes[heroName]) {
        	if (!!this.banned[heroName]) {
        		heroPanel.SetHasClass("redscale", !this.availableHeroes[heroName]);
        	} else {
        		heroPanel.SetHasClass("grayscale", !this.availableHeroes[heroName]);
        	};
        	heroPanel.ClearPanelEvent("onmouseactivate");
        } else {
        	/*if (Players.GetTeam(this.playerId) == 2 && !!this.UnselectedRed[heroName]) {
	    		heroPanel.SetHasClass("grayscale", true);
	    		heroPanel.ClearPanelEvent("onmouseactivate");
	    	} else if (Players.GetTeam(this.playerId) == 3 && !!this.UnselectedBlack[heroName]) {
	    		heroPanel.SetHasClass("grayscale", true);
	    		heroPanel.ClearPanelEvent("onmouseactivate");
	    	} else {*/
        	this.BindOnActivate(heroPanel, heroName);
        	//};
        }
    };

    /*for (var heroName in this.tenCost) {
        var herotenPanel = this.tenPanel.FindChild(heroName);
        if (herotenPanel == null) {
            herotenPanel = $.CreatePanel("Image", this.tenPanel, heroName);
            herotenPanel.SetImage("s2r://panorama/images/custom_game/draft/" + heroName + "_png.vtex");
            herotenPanel.AddClass("hero");
            this.BindOnActivate(herotenPanel, heroName);
        };

       if (Game.GetScreenWidth() / Game.GetScreenHeight() == 4/3) {
	    	herotenPanel.style['ui-scale'] = 80 + "%";
	    } else {
	    	herotenPanel.style['ui-scale'] = 100 + "%";
	    };

        if (!!!this.availableHeroes[heroName]) {
        	if (!!this.banned[heroName]) {
        		herotenPanel.SetHasClass("redscale", !this.availableHeroes[heroName]);
        	} else {
        		herotenPanel.SetHasClass("grayscale", !this.availableHeroes[heroName]);
        	};
        	herotenPanel.ClearPanelEvent("onmouseactivate");
        } else {
        	this.BindOnActivate(herotenPanel, heroName);
        }
    };*/

    /*var randomPanel = this.tenPanel.FindChild("random");
    if (randomPanel == null && this.Start["game"] == "start") {
        randomPanel = $.CreatePanel("Image", this.tenPanel, "random");
        randomPanel.SetImage("s2r://panorama/images/custom_game/draft/random_png.vtex");
        randomPanel.AddClass("hero");
        this.BindOnActivate(randomPanel, "random");
    };
    if (randomPanel !== null) {
    	if (!!!this.picked[this.playerId]) {
    		this.BindOnActivate(randomPanel, "random");
    	};
    	if (Game.GetScreenWidth() / Game.GetScreenHeight() == 4/3) {
	    	randomPanel.style['ui-scale'] = 80 + "%";
	    } else {
	    	randomPanel.style['ui-scale'] = 100 + "%";
	    };
    };*/
}

DraftSelection.prototype.Render = function() {
    var that = this;
    if (this.time !== "undefined") {
    	if (this.GamePhase["gamephase"] == "load") {
    		this.timeLabel.text = this.time;
    		this.timeLabel.style["color"] = "#CCCCCC";
        	this.statusLabel.text = "LOADING";
        	this.statusLabel.style["color"] = "#CCCCCC";
    	} else if (this.GamePhase["gamephase"] == "ban") {
    		this.timeLabel.text = this.time;
        	this.statusLabel.text = "BAN PHASE";
        	this.statusLabel.style["color"] = "#CCCCCC";
        	if (this.time > 0 && this.time <= 5) {
	            this.timeLabel.style["color"] = "red";
	        } else {
	            this.timeLabel.style["color"] = "#CCCCCC";
	        };
	    } else if (this.GamePhase["gamephase"] == "blank") {
	    	this.timeLabel.text = " ";
    	} else if (this.GamePhase["gamephase"] == "pick") {
    		this.timeLabel.text = this.time;
        	this.statusLabel.text = "PICK PHASE";
        	this.statusLabel.style["color"] = "#CCCCCC";
        	if (this.time > 0 && this.time <= 5) {
	            this.timeLabel.style["color"] = "red";
	        } else {
	            this.timeLabel.style["color"] = "#CCCCCC";
	        };
    	} else if (this.GamePhase["gamephase"] == "strategy") {
    		this.timeLabel.text = (this.time > 10) ? (this.time - 10) : this.time;
    		this.timeLabel.style["color"] = "#CCCCCC";
        	this.statusLabel.text = (this.time > 10) ? "STRATEGY" :"GAME START";
        	this.statusLabel.style["color"] = "#CCCCCC";
    	};
    } else if (this.time == "undefined") {
    	this.timeLabel.text = " ";
    	//this.statusLabel.text = " ";
    };
    /*if (this.BlackMana["mana"] == null && this.RedMana["mana"] == null) {} else {
	    this.BlackManaGuage.style.width = this.BlackMana["mana"] + "%";
	    this.container.FindChildTraverse("TopBar").FindChild("BlackMana").FindChildTraverse("BlackManaLabel").text = this.BlackMana["mana"];
	    this.RedManaGuage.style.width = this.RedMana["mana"] + "%";
	    this.container.FindChildTraverse("TopBar").FindChild("RedMana").FindChildTraverse("RedManaLabel").text = this.RedMana["mana"];
	};*/
    
   	if (this.GamePhase["gamephase"] == "ban") {
   		if (this.BanOrder["teamNum"] == "1") {
   			this.PlayersRedPanel.FindChild(this.BanOrder['playerId']).SetHasClass("turn", this.GamePhase["gamephase"] == "ban" && !!!this.pickedplayer[this.BanOrder['playerId']]);
   		} else if (this.BanOrder["teamNum"] == "2") {
   			this.PlayersBlackPanel.FindChild(this.BanOrder['playerId']).SetHasClass("turn", this.GamePhase["gamephase"] == "ban" && !!!this.pickedplayer[this.BanOrder['playerId']]);
   		};
	} else if (this.GamePhase["gamephase"] == "blank") {
   		for (var RedPlayers in this.RedTeam) { 
   			this.PlayersRedPanel.FindChild(RedPlayers).SetHasClass("turn", false);
   		};
   		for (var BlackPlayers in this.BlackTeam) { 
   			this.PlayersBlackPanel.FindChild(BlackPlayers).SetHasClass("turn", false);
   		};
   	};

   	if (!!this.PickOrder["teamNum"]) {
   		if (this.PickOrder["teamNum"] == "1") {
   			if (this.PickOrder['playerId1'] !== null) {
   				if (this.HiLight['playerId1'] == this.PickOrder['playerId1']) {
   					this.PlayersRedPanel.FindChild(this.PickOrder['playerId1']).SetHasClass("turn", this.GamePhase["gamephase"] == "pick" && this.HiLight['playerId1'] !== null);
   				} else if (this.HiLight['playerId1'] == null) {
   					this.PlayersRedPanel.FindChild(this.PickOrder['playerId1']).SetHasClass("turn", false);
   				};
   			};
   			if (!!this.PickOrder['playerId2'] && this.PickOrder['playerId2'] !== null) {
   				if (this.HiLight['playerId2'] == this.PickOrder['playerId2']) {
   					this.PlayersRedPanel.FindChild(this.PickOrder['playerId2']).SetHasClass("turn", this.GamePhase["gamephase"] == "pick" && this.HiLight['playerId2'] !== null);
   				} else if (this.HiLight['playerId2'] == null) {
   					this.PlayersRedPanel.FindChild(this.PickOrder['playerId2']).SetHasClass("turn", false);
   				};
   			};
   		} else if (this.PickOrder["teamNum"] == "2") {
   			if (this.PickOrder['playerId1'] !== null) {
   				if (this.HiLight['playerId1'] == this.PickOrder['playerId1']) {
   					this.PlayersBlackPanel.FindChild(this.PickOrder['playerId1']).SetHasClass("turn", this.GamePhase["gamephase"] == "pick" && this.HiLight['playerId1'] !== null);
   				} else if (this.HiLight['playerId1'] == null) {
   					this.PlayersBlackPanel.FindChild(this.PickOrder['playerId1']).SetHasClass("turn", false);
   				};
   			};
   			if (!!this.PickOrder['playerId2'] && this.PickOrder['playerId2'] !== null) {
   				if (this.HiLight['playerId2'] == this.PickOrder['playerId2']) {
   					this.PlayersBlackPanel.FindChild(this.PickOrder['playerId2']).SetHasClass("turn", this.GamePhase["gamephase"] == "pick" && this.HiLight['playerId2'] !== null);
   				} else if (this.HiLight['playerId2'] == null) {
   					this.PlayersBlackPanel.FindChild(this.PickOrder['playerId2']).SetHasClass("turn", false);
   				};
   			};
   		};
   	};
}

DraftSelection.prototype.PortraitChange = function(panel, portrait, player) {
	if (!!this.picked[player]) {
		if (!!!this.mode['mode'] && this.wvfu[this.playerId] !== sopkq[this.wvfu[this.playerId]] && (!!!this.Game["AN"] || !!!this.Game["AI"] || this.Game["AI"] !== gam + '/' + vokgTviN + "II")) {
			panel.FindChildTraverse("heroNameLabel").text = $.Localize( "#" + "E" + "rr" + "or" );
			portrait.style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait.png')";
			return;  
		};
	    if (this.SkinSelect[this.picked[player]] == 0) {
	        portrait.style["background-image"] = "url('file://{images}/custom_game/draft/" + this.picked[player] + "_png.vtex')";
	     	
	    } else {
	        portrait.style["background-image"] = "url('file://{images}/custom_game/draft/" + this.picked[player] + "_" + this.SkinSelect[this.picked[player]] + "_png.vtex')";
	     	//panel.FindChild(player).FindChildTraverse("heroNameLabel").text = $.Localize( "#" + this.picked[player] + '_' +  this.SkinSelect[this.picked[player]]);
	    };
	    panel.FindChildTraverse("heroNameLabel").text = $.Localize( "#" + this.picked[player] );
	    if (portrait.BHasClass("greyscale")) {
	    	portrait.RemoveClass("greyscale");
	    };
    } else {
        if (this.PickOrder['playerId1'] == player || this.PickOrder['playerId2'] == player) {
        	if (!!this.availableHeroes[this.SelectedPortrait[player]] && !!!this.banned[this.SelectedPortrait[player]]) {
        		portrait.style["background-image"] = "url('file://{images}/custom_game/draft/" + this.SelectedPortrait[player] + "_png.vtex')";
	       		panel.FindChildTraverse("heroNameLabel").text = $.Localize( "#" + this.SelectedPortrait[player] );
	       		if (portrait.BHasClass("greyscale")) {
			    	portrait.RemoveClass("greyscale");
			    };
        	} else if (!!this.availableHeroes[this.PreSelected[player]] && !!!this.banned[this.PreSelected[player]]) {
        		portrait.style["background-image"] = "url('file://{images}/custom_game/draft/" + this.PreSelected[player] + "_png.vtex')";
	       		panel.FindChildTraverse("heroNameLabel").text = $.Localize( "#" + this.PreSelected[player] );
	       		if (portrait.BHasClass("greyscale")) {
			    	portrait.RemoveClass("greyscale");
			    };
        	} else {
        		portrait.style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait.png')";
	       		panel.FindChildTraverse("heroNameLabel").text = " ";
	       		if (portrait.BHasClass("greyscale")) {
			    	portrait.RemoveClass("greyscale");
			    };
        	}
        } else {
        	if (Players.GetTeam(player) == Players.GetTeam(this.playerId)) {
        		if (!!this.PreSelected[player] && !!!this.banned[this.PreSelected[player]] && !!this.availableHeroes[this.PreSelected[player]]) {	
		       		portrait.style["background-image"] = "url('file://{images}/custom_game/draft/" + this.PreSelected[player] + "_png.vtex')";
		       		portrait.SetHasClass("greyscale", true);
		       		panel.FindChildTraverse("heroNameLabel").text = $.Localize( "#" + this.PreSelected[player] );
		       	} else {
		       		portrait.style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait.png')";
		       		panel.FindChildTraverse("heroNameLabel").text = " ";
		       		if (portrait.BHasClass("greyscale")) {
				    	portrait.RemoveClass("greyscale");
				    };
		       	};
        	};
        };
    };
}

DraftSelection.prototype.BindOnActivate = function(panel, hero) {
    //var that = this;
    if (this.playerId == null) {
    	//$.Msg('this.playerId cannot found');
    	this.playerId = Game.GetLocalPlayerID();
    };
    if (Players.IsSpectator(this.playerId)) {
    	//$.Msg('spectator');
        return;
    };

    if (!!this.picked[this.playerId]) {
    	return;
    };

    panel.SetPanelEvent("onmouseactivate",
		function() {
			if (DS.playerId !== DS.PickOrder["playerId1"] && DS.playerId !== DS.PickOrder["playerId2"] && DS.playerId !== DS.BanOrder["playerId"]) {
				if (!!DS.pickedplayer[DS.playerId] || !!!DS.availableHeroes[hero] || !!DS.banned[hero] || !!DS.picked[DS.playerId]) {
					$.Msg('Cannot pre select 1');
					return;
				};

				GameEvents.SendCustomGameEventToServer("draft_hero_preselect", {
					playerId: DS.playerId,
					hero: hero,
				});
				$.Msg('Pre Select: ' + $.Localize( "#" + hero));
			};
			if (DS.GamePhase["gamephase"] == "pick") {
				$.Msg('Pick Phase');
				$.Msg(DS.PickOrder["playerId1"]);
				$.Msg(DS.playerId);
			};
			if (DS.playerId == (DS.PickOrder["playerId1"] || DS.PickOrder["playerId2"]) ) {
				$.Msg('Pick Order is Me');
			};
		    if (DS.GamePhase["gamephase"] == "ban" && DS.BanOrder['playerId'] == DS.playerId) {		    	
				if (!!DS.banned[hero] && !!!DS.availableHeroes[hero]) {
					$.Msg($.Localize( "#" + hero) + ' is already banned.');
					return;
				} else if (hero == "random") {
					$.Msg('Cannot ban random.');
					return;
				};
				GameEvents.SendCustomGameEventToServer("draft_hero_preban", {
					playerId: DS.playerId,
					hero: hero,
				});
				$.Msg('Pre Ban: ' + $.Localize( "#" + hero));
			} else if (DS.GamePhase["gamephase"] == "pick" && (DS.playerId == DS.PickOrder["playerId1"] || DS.playerId == DS.PickOrder["playerId2"])) {		 
				$.Msg('pick click on' + $.Localize( "#" + hero));
				if (!!DS.banned[hero] || !!!DS.availableHeroes[hero]) {
					$.Msg($.Localize( "#" + hero) + ' is already banned.');
					return;
				} else {
					GameEvents.SendCustomGameEventToServer("draft_hero_changeportrait", {
						playerId: DS.playerId,
						hero: hero,
					});
					$.Msg('Pre Pick: ' + $.Localize( "#" + hero));
				};
			}; 
		}
	);
}

DraftSelection.prototype.SkinChangeRight = function(panel, hero) {
    panel.SetPanelEvent(
        "onmouseactivate",
        function() {
            if (DS.SkinSelect[hero] >= DS.availableSkins[hero]) {
                GameEvents.SendCustomGameEventToServer("draft_hero_skin", {
                    playerId: DS.playerId,
                    hero: hero,
                    skin: 0,
                });
            } else {
                GameEvents.SendCustomGameEventToServer("draft_hero_skin", {
                    playerId: DS.playerId,
                    hero: hero,
                    skin: DS.SkinSelect[hero] + 1,
                });
            }
        }
    );    	
}

DraftSelection.prototype.SkinChangeLeft = function(panel, hero) {
    panel.SetPanelEvent(
        "onmouseactivate",
        function() {
            if (DS.SkinSelect[hero] <= 0) {
                GameEvents.SendCustomGameEventToServer("draft_hero_skin", {
                    playerId: DS.playerId,
                    hero: hero,
                    skin: DS.availableSkins[hero],
                });
            } else {
                GameEvents.SendCustomGameEventToServer("draft_hero_skin", {
                    playerId: DS.playerId,
                    hero: hero,
                    skin: DS.SkinSelect[hero] - 1,
                });
            }
        }
    );      
}

DraftSelection.prototype.Update = function() {
    var that = this;

    if (that.mode == "draft" || that.mode > 0) {
    	globalContext.visible = true;
    	globalContext.FindChild("DraftSelection").visible = true;
    	if (that.mode > 0) {
    		$.Msg('reconnect success!!')
    	}
    };

    this.allHeroes = CustomNetTables.GetTableValue("draft", "all") || {};
    this.availableHeroes = CustomNetTables.GetTableValue("draft", "available") || {};
    this.availableSkins = CustomNetTables.GetTableValue("draft", "skin") || {};
    //this.tenCost = CustomNetTables.GetTableValue("draft", "ten") || {};
    //this.twentyCost = CustomNetTables.GetTableValue("draft", "twenty") || {};
    this.RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
    this.BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
    this.picked = CustomNetTables.GetTableValue("draft", "picked") || {};
    this.pickedplayer = CustomNetTables.GetTableValue("draft", "pickedplayer") || {};
    this.bannedplayer = CustomNetTables.GetTableValue("draft", "bannedplayer") || {};
    this.banned = CustomNetTables.GetTableValue("draft", "banned") || {};
    //this.RedMana = CustomNetTables.GetTableValue("draft", "red_mana") || {};
    //this.BlackMana = CustomNetTables.GetTableValue("draft", "black_mana") || {};
    this.SkinAccess = CustomNetTables.GetTableValue("draft", "skinaccess") || {};
    this.SkinTier = CustomNetTables.GetTableValue("nselection", "skintier") || {};
    this.PAuthority = CustomNetTables.GetTableValue("draft", "authority") || {};
    this.GamePhase = CustomNetTables.GetTableValue("draft", "gamephase") || {};
    this.BanOrder = CustomNetTables.GetTableValue("draft", "banorder") || {};
    this.PickOrder = CustomNetTables.GetTableValue("draft", "pickorder") || {};
    this.Game = CustomNetTables.GetTableValue("draft", "game") || {};
    this.mode = CustomNetTables.GetTableValue("draft", "mode") || {};
    //this.UnselectedBlack = CustomNetTables.GetTableValue("draft", "black_unselected") || {};
    //this.UnselectedRed = CustomNetTables.GetTableValue("draft", "red_unselected") || {};
    this.Start = CustomNetTables.GetTableValue("draft", "panel") || {};
    this.PreSelected = CustomNetTables.GetTableValue("draft", "preselect") || {};
    this.SkinSelect = CustomNetTables.GetTableValue("draft", "skinselect") || {};
    this.SelectedPortrait = CustomNetTables.GetTableValue("draft", "select_bar") || {};
    this.BanPortrait = CustomNetTables.GetTableValue("draft", "ban_bar") || {};
    this.wvfu = CustomNetTables.GetTableValue("draft", "si") || {};
    this.HiLight = CustomNetTables.GetTableValue("draft", "hilight") || {};

    /*if (Game.GetScreenWidth() / Game.GetScreenHeight() == 4/3) {
    	this.container.AddClass("Aspect4x3");
    } else if (Game.GetScreenWidth() / Game.GetScreenHeight() == 16/9) {
    	this.container.AddClass("Aspect16x9");
    } else if (Game.GetScreenWidth() / Game.GetScreenHeight() == 16/10) {
    	this.container.AddClass("Aspect16x10");
    };*/

    if (this.GamePhase["gamephase"] == "load") {
        this.SelectedHeroPanel.visible = false;
		this.SelectedHeroPanel1.visible = false;
		this.selectedbar.visible = false;
    } else if (this.GamePhase["gamephase"] == "ban") {
    	if (this.time > 1) {
    		this.ban_signal = false;
    	};
        this.SelectedHeroPanel.visible = false;
		this.SelectedHeroPanel1.visible = true;
		if (this.BanOrder['playerId'] == this.playerId) {
			this.selectedbar.visible = true;
			this.selectedbart.text = $.Localize("#ban_button");
			if (!!this.BanPortrait[this.playerId] && !!!this.banned[this.BanOrder[this.playerId]]) {
				BindOnBan(this.selectedbar, this.BanPortrait[this.playerId]);
			};
		} else {
			this.selectedbar.visible = false;
			this.selectedbar.ClearPanelEvent("onmouseactivate");
			this.selectedbart.text = " ";
		};
		if (!!this.BanPortrait[this.BanOrder['playerId']]) {
			this.SelectedHeroPanel1.FindChildTraverse("SelectedHero1").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.BanPortrait[this.BanOrder['playerId']] + "_png.vtex')";
		} else if (!!this.banned[this.BanOrder['playerId']]) {
			this.SelectedHeroPanel1.FindChildTraverse("SelectedHero1").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.banned[this.BanOrder['playerId']] + "_png.vtex')";
		} else {
			this.SelectedHeroPanel1.FindChildTraverse("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultselect_png.vtex')";
		};
		
		this.SelectedHeroPanel1.FindChildTraverse("SelectedPlayerNameLabel").text = Players.GetPlayerName( this.BanOrder['playerId'] );
    	if (this.time <= 0) {
    		this.selectedbar.visible = false;
			this.selectedbar.ClearPanelEvent("onmouseactivate");
			this.selectedbart.text = " ";
    	};
    } else if (this.GamePhase["gamephase"] == "blank") {
		this.selectedbar.visible = false;
    } else if (this.GamePhase["gamephase"] == "pick") {
    	if (this.time >= 1) {
    		this.random_signal = false;
    		this.random_signal_2 = false;
    	};
    	if (!!this.PickOrder['playerId2']) {
    		this.SelectedHeroPanel.visible = true;
			this.SelectedHeroPanel1.visible = false;
			this.SelectedHeroPanel2.FindChildTraverse("SelectedPlayerNameLabel").text = Players.GetPlayerName( this.PickOrder['playerId1'] );
			this.SelectedHeroPanel3.FindChildTraverse("SelectedPlayerNameLabel").text = Players.GetPlayerName( this.PickOrder['playerId2'] );
			if (this.PickOrder['playerId1'] == this.playerId || this.PickOrder['playerId2'] == this.playerId) {
				this.selectedbar.visible = true;
				this.selectedbart.text = $.Localize("#pick_button");
				if (!!this.SelectedPortrait[this.playerId] && !!!this.picked[this.PickOrder[this.playerId]]) {
					BindOnPick(this.selectedbar, this.SelectedPortrait[this.playerId]);
				};
			} else {
				this.selectedbar.visible = false;
				this.selectedbar.ClearPanelEvent("onmouseactivate");
				this.selectedbart.text = " ";
			};

			if (!!this.picked[this.PickOrder['playerId1']]) {
				this.SelectedHeroPanel2.FindChildTraverse("SelectedHero2").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.picked[this.PickOrder['playerId1']] + "_png.vtex')";
			} else if (!!this.SelectedPortrait[this.PickOrder['playerId1']]) {
				this.SelectedHeroPanel2.FindChildTraverse("SelectedHero2").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.SelectedPortrait[this.PickOrder['playerId1']] + "_png.vtex')";
			} else {
				this.SelectedHeroPanel2.FindChildTraverse("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultselect_png.vtex')";
			};

			if (!!this.picked[this.PickOrder['playerId2']]) {
				this.SelectedHeroPanel3.FindChildTraverse("SelectedHero3").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.picked[this.PickOrder['playerId2']] + "_png.vtex')";
			} else if (!!this.SelectedPortrait[this.PickOrder['playerId2']]) {
				this.SelectedHeroPanel3.FindChildTraverse("SelectedHero3").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.SelectedPortrait[this.PickOrder['playerId2']] + "_png.vtex')";
			} else {
				this.SelectedHeroPanel3.FindChildTraverse("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultselect_png.vtex')";
			};
    	} else {
    		this.SelectedHeroPanel.visible = false;
			this.SelectedHeroPanel1.visible = true;
			this.SelectedHeroPanel1.FindChildTraverse("SelectedPlayerNameLabel").text = Players.GetPlayerName( this.PickOrder['playerId1'] );

			if (this.PickOrder['playerId1'] == this.playerId) {
				this.selectedbar.visible = true;
				this.selectedbart.text = $.Localize("#pick_button");
				if (!!this.SelectedPortrait[this.playerId] && !!!this.picked[this.PickOrder[this.playerId]]) {
					BindOnPick(this.selectedbar, this.SelectedPortrait[this.playerId]);
				};
			} else {
				this.selectedbar.visible = false;
				this.selectedbar.ClearPanelEvent("onmouseactivate");
				this.selectedbart.text = " ";
			};

			if (!!this.picked[this.PickOrder['playerId1']]) {
				this.SelectedHeroPanel1.FindChildTraverse("SelectedHero1").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.picked[this.PickOrder['playerId1']] + "_png.vtex')";
			} else if (!!this.SelectedPortrait[this.PickOrder['playerId1']]) {
				this.SelectedHeroPanel1.FindChildTraverse("SelectedHero1").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.SelectedPortrait[this.PickOrder['playerId1']] + "_png.vtex')";
			} else {
				this.SelectedHeroPanel1.FindChildTraverse("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultselect_png.vtex')";
			};
    	};
    	if (this.time <= 0) {
    		this.selectedbar.visible = false;
			this.selectedbar.ClearPanelEvent("onmouseactivate");
			this.selectedbart.text = " ";
    	};

    } else if (this.GamePhase["gamephase"] == "strategy") {
    	this.SelectedHeroPanel.visible = false;
		this.SelectedHeroPanel1.visible = true;
		this.selectedbar.visible = false;
		this.SelectedHeroPanel1.FindChildTraverse('SelectedPlayerName1').visible = false;
		this.SkinNamePanel.visible = true;
		this.selectedbar.ClearPanelEvent("onmouseactivate");
		this.selectedbar.text = " ";

		if (this.time > 10) {
	    	if (Players.IsSpectator(this.playerId)) {
				
			} else {
	            if (this.availableSkins[this.picked[this.playerId]] > 0){
	                this.selectedright.visible = true;   
	                this.selectedleft.visible = true; 
	                this.SkinChangeLeft(this.selectedleft, this.picked[this.playerId])
	                this.SkinChangeRight(this.selectedright, this.picked[this.playerId])
	            };   
	            if (this.SkinSelect[this.picked[this.playerId]] == 0) {
	    		    this.SelectedHeroPanel1.FindChildTraverse("SelectedHero1").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.picked[this.playerId] + "_png.vtex')";
	    		    this.SkinNamePanel.FindChildTraverse("SelectedPlayerNameLabel").text = $.Localize( "#" + this.picked[this.playerId] );
	    		    this.SkinNamePanel.FindChild("SelectedPlayerNameLabel").style['color'] = "white";
	    		    if (this.SelectedHeroPanel1.FindChildTraverse("SelectedHero1").BHasClass("greyscale")) {
				    	this.SelectedHeroPanel1.FindChildTraverse("SelectedHero1").RemoveClass("grayscale");
				    };
	                if (!!this.RequirePanel) {
	                    this.RequirePanel.visible = false;
	                }
	            } else {
	                this.SelectedHeroPanel1.FindChildTraverse("SelectedHero1").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.picked[this.playerId] + "_" + this.SkinSelect[this.picked[this.playerId]] + "_png.vtex')";
	                this.SkinNamePanel.FindChildTraverse("SelectedPlayerNameLabel").text = $.Localize( "#" + this.picked[this.playerId] + "_" + this.SkinSelect[this.picked[this.playerId]]);
	                if (this.SkinTier[this.picked[this.playerId]] == 1) {
	                    this.SkinNamePanel.FindChildTraverse("SelectedPlayerNameLabel").style['color'] = "#82DB56";
	                } else if (this.SkinTier[this.picked[this.playerId]] == 2) {
	                    this.SkinNamePanel.FindChildTraverse("SelectedPlayerNameLabel").style['color'] = "#83F2F2";
	                } else if (this.SkinTier[this.picked[this.playerId]] == 3) {
	                    this.SkinNamePanel.FindChildTraverse("SelectedPlayerNameLabel").style['color'] = "#E3C852";
	                };
	                if (this.SkinAccess[this.playerId] == false) {
	                    if (!this.RequirePanel) {
	                        this.RequirePanel = $.CreatePanel("Label", this.container.FindChildTraverse("BottomBar"), "");
	                        this.RequirePanel.AddClass("Headtext");
	                        this.RequirePanel.AddClass("SelectedLeftPanel");
	                        this.RequirePanel.style["font-size"] = "40px";
	                        this.RequirePanel.style["color"] = "yellow";
	                        this.RequirePanel.text = "Need CP";
	                    }                 
	                    this.RequirePanel.visible = true;
	                } else if (this.SkinAccess[this.playerId] == true) {
	                    if (!!this.RequirePanel) {
	                        this.RequirePanel.visible = false;
	                    }
	                };
	            };  
			};
		} else {
			this.selectedright.visible = false;   
	        this.selectedleft.visible = false; 
	        //if (this.summon_signal == null) {
	        //    var skin = 0
	        //    if (!!this.SkinSelect[this.picked[this.playerId]]) {
	        //        skin = this.SkinSelect[this.picked[this.playerId]];
	        //        $.Msg('skin =' + skin);
	        //    };

	        //    GameEvents.SendCustomGameEventToServer("draft_hero_summon", {
	        //        playerId: this.playerId,
	        //        skin: skin,
	        //    });
	        //    this.summon_signal = true;
	        //};
		   
		    if (this.time <= 0) {
                if (Players.GetPlayerSelectedHero(this.playerId) == 'npc_dota_hero_wisp') {
                    GameEvents.SendCustomGameEventToServer("draft_hero_summon", {
                        playerId: this.playerId,
                    });
                };
		        this.End();
				return;
		    };
    	};
    };

	this.Construct();
    this.Render();

    /*if (that.normal_mode == "selection" || that.normal_mode > 0) {
        this.End();
        return;
    };*/

    if (Game.GameStateIsAfter( DOTA_GameState.DOTA_GAMERULES_STATE_PRE_GAME)) {
        $.Msg('game phase')
        this.End();
        return;
    };

    $.Schedule(0.2, function() {
    	
       	that.Update();
    })
}

DraftSelection.prototype.End = function() {
    CustomNetTables.UnsubscribeNetTableListener(this.timeListener);
    CustomNetTables.UnsubscribeNetTableListener(this.availableListener);
    CustomNetTables.UnsubscribeNetTableListener(this.allListener);
    CustomNetTables.UnsubscribeNetTableListener(this.banListener);
    CustomNetTables.UnsubscribeNetTableListener(this.UIListener);
    CustomNetTables.UnsubscribeNetTableListener(this.PickOrderListener);
    CustomNetTables.UnsubscribeNetTableListener(this.BanOrderListener);
    /*CustomNetTables.UnsubscribeNetTableListener(this.BlackUnselectedListener);
    CustomNetTables.UnsubscribeNetTableListener(this.RedUnselectedListener);*/

    this.SelectedHeroPanel.visible = false;
	this.SelectedHeroPanel1.visible = false;
	this.selectedbar.visible = false;
	globalContext.FindChild("DraftSelection").visible = false;
    globalContext.visible = false;
    globalContext.AddClass("Hidden");
}

var DS = new DraftSelection();
DS.Update();