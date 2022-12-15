//////////////////////////////////////////////////////////////////////////////
/////////////////// Made by ZeFiRoFT /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

var globalContext = $.GetContextPanel();
globalContext.visible = false;
globalContext.FindChildTraverse("DraftSelection").visible = false;


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
	"random",
    "ban",
    "error"
]

var nomercy = {
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

function DraftSelection() {
	var that = this;
	this.playerId = Game.GetLocalPlayerID();
	this.container = $.GetContextPanel().FindChild("DraftSelection");

	//this.UIListener = CustomNetTables.GetTableValue("draft", "draftmode") || {};
    this.UIListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "draftmode") {
            $.Msg(data);
            that.draft = data["draft"];
        }
    });
	this.timeListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "time") {
        	$.Msg(data);
            that.time = data.time;
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
        	$.Msg(data);
            that.banned = data;
        }
    });

    this.allListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "all") {
        	$.Msg(data);
            that.allHeroes = data;
        }
    });

    this.PickOrderListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "pickorder") {
            that.PickOrder1 = data["playerID1"];
            that.PickOrder2 = data["playerID2"];
            //this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/random_png.vtex')"
        };
    });

    this.BanOrderListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "banorder") {
            that.BanOrder = data['playerId'];
        };
    });

    this.BlackUnselectedListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "black_unselected") {
        	$.Msg(data);
            that.UnSelectedBlack = data;
        }
    });

    this.RedUnselectedListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "red_unselected") {
        	$.Msg(data);
            that.UnSelectedRed = data;
        }
    });

    this.pickedListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "picked") {
        	$.Msg(data);
            that.picked = data;
        }
    });

    var timeTable = CustomNetTables.GetTableValue("draft", "time");
    this.time = timeTable && timeTable.time;

    this.statusLabel = this.container.FindChildTraverse("status");
    this.timeLabel = this.container.FindChildTraverse("time");
    this.twentyPanel = this.container.FindChildTraverse("twentyheroes");
    this.tenPanel = this.container.FindChildTraverse("tenheroes");
    this.PlayersRedPanel = this.container.FindChildTraverse("LeftBar");
    this.PlayersBlackPanel = this.container.FindChildTraverse("RightBar");
	this.SelectedHeroPanel = this.container.FindChildTraverse("SelectedPanel2");
	this.SelectedHeroPanel1 = this.container.FindChildTraverse("Selected1");
	this.RedManaGuage = this.container.FindChildTraverse("TopBar").FindChild("RedMana").FindChild("RedManaGuage");
	this.BlackManaGuage = this.container.FindChildTraverse("TopBar").FindChild("BlackMana").FindChild("BlackManaGuage");
	this.selectedbar = this.container.FindChildTraverse("selectedbar");
    this.selectedleft = this.container.FindChildTraverse("SelectedLeft");
    this.selectedright = this.container.FindChildTraverse("SelectedRight");
	this.selectedbarPlayerName1 = this.SelectedHeroPanel1.FindChildTraverse("SelectedPlayerNameLabel");
	this.selectedbarPlayerName2 = this.SelectedHeroPanel.FindChild("Selected2").FindChildTraverse("SelectedPlayerNameLabel");
	this.selectedbarPlayerName3 = this.SelectedHeroPanel.FindChild("Selected3").FindChildTraverse("SelectedPlayerNameLabel");
	this.SelectedHeroPanel.visible = false;	
	this.SelectedHeroPanel1.visible = false;
	this.selectedbar.visible = false;	
    this.selectedright.visible = false;   
    this.selectedleft.visible = false;   
}

function AddPlayerRed(panel,parent,child,team)
{
    panel = $.CreatePanel("Panel", parent, child);
    var playername = Players.GetPlayerName(team[child]);
    panel.BLoadLayoutSnippet('PlayerbarRed');
    panel.FindChildTraverse('playerNameLabel').text = playername;
}

function AddPlayerBlack(panel,parent,child,team)
{
    panel = $.CreatePanel("Panel", parent, child);
    var playername = Players.GetPlayerName(team[child]);
    panel.BLoadLayoutSnippet('PlayerBarBlack');
    panel.FindChildTraverse('playerNameLabel').text = playername;
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
        if (!!!this.picked[RedPlayers] && !!this.SelectedPortrait[RedPlayers] && (this.PickOrder['playerID1'] == RedPlayers || this.PickOrder['playerID2'] == RedPlayers)) {
        	$.Msg('select portrait = ' + this.SelectedPortrait[RedPlayers])
        	this.PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").RemoveClass("greyscale");
        	this.PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.SelectedPortrait[RedPlayers] + "_png.vtex')";
        	
        	var curIndex = GetIndex(heroes, this.SelectedPortrait[RedPlayers]);
        	this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("heroNameLabel").text = names[curIndex];
        	if (this.PickOrder["playerID2"] == null) {
				//$.Msg(this.pickedplayer[this.PickOrder['playerID1']])
				if (this.PickOrder['playerID1'] == RedPlayers) {
	    			this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.SelectedPortrait[RedPlayers] + "_png.vtex')";
	    		};
	    	} else {
	    		if (this.PickOrder['playerID1'] == RedPlayers) {
	    			this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.SelectedPortrait[RedPlayers] + "_png.vtex')";
	    		};
	    		if (this.PickOrder['playerID2'] == RedPlayers) {
	    			this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.SelectedPortrait[RedPlayers] + "_png.vtex')";
	    		};
	    	}
        } else if (!!!this.picked[RedPlayers] && !!this.PreSelected[RedPlayers] && !!!this.banned[this.PreSelected[RedPlayers]] && this.PickOrder['playerID1'] !== RedPlayers && this.PickOrder['playerID2'] !== RedPlayers) {
        	if (Players.GetTeam(this.RedTeam[RedPlayers]) == Players.GetTeam(this.playerId)) {
        		this.PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.PreSelected[RedPlayers] + "_png.vtex')";
        		this.PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").SetHasClass("greyscale", true);
        		var curIndex = GetIndex(heroes, this.PreSelected[RedPlayers]);
        		this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("heroNameLabel").text = names[curIndex];
        	};
        };

        if (!!this.picked[RedPlayers] ) {
            if (this.SkinSelect[this.picked[RedPlayers]] == 0) {
        	    this.PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.picked[RedPlayers] + "_png.vtex')";
        	} else {
                this.PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.picked[RedPlayers] + "_" + this.SkinSelect[this.picked[RedPlayers]] + "_png.vtex')";
            };
            this.PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").RemoveClass("greyscale");
        	var curIndex = GetIndex(heroes, this.picked[RedPlayers]);
        	this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("heroNameLabel").text = names[curIndex];
        };
        if (!!this.picked[RedPlayers] && (this.PickOrder['playerID1'] == RedPlayers || this.PickOrder['playerID2'] == RedPlayers)) {
        	$.Msg('random = ' + this.picked[RedPlayers])
        	if (this.PickOrder["playerID2"] == null) {
				//$.Msg(this.pickedplayer[this.PickOrder['playerID1']])
				if (this.PickOrder['playerID1'] == RedPlayers) {
	    			this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[RedPlayers] + "_png.vtex')";
	    		};
	    	} else {
	    		if (this.PickOrder['playerID1'] == RedPlayers) {
	    			this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[RedPlayers] + "_png.vtex')";
	    		};
	    		if (this.PickOrder['playerID2'] == RedPlayers) {
	    			this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[RedPlayers] + "_png.vtex')";
	    		};
	    	}
        };
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
        if (!!!this.picked[BlackPlayers] && !!this.PreSelected[BlackPlayers] && !!!this.banned[this.PreSelected[BlackPlayers]] && (this.PickOrder['playerID1'] || this.PickOrder['playerID2']) !== BlackPlayers) {
        	if (Players.GetTeam(this.BlackTeam[BlackPlayers]) == Players.GetTeam(this.playerId)) {
        		this.PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.PreSelected[BlackPlayers] + "_png.vtex')";
        		this.PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").SetHasClass("greyscale", true);
        		var curIndex = GetIndex(heroes, this.PreSelected[BlackPlayers]);
        		this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("heroNameLabel").text = names[curIndex];
        	};
        };
        if (!!!this.picked[BlackPlayers] && !!this.SelectedPortrait[BlackPlayers] && (this.PickOrder['playerID1'] == BlackPlayers || this.PickOrder['playerID2'] == BlackPlayers)) {
        	this.PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.SelectedPortrait[BlackPlayers] + "_png.vtex')";
        	this.PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").RemoveClass("greyscale");
        	var curIndex = GetIndex(heroes, this.SelectedPortrait[BlackPlayers]);
        	this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("heroNameLabel").text = names[curIndex];
        	if (this.PickOrder["playerID2"] == null) {
				//$.Msg(this.pickedplayer[this.PickOrder['playerID1']])
				if (this.PickOrder['playerID1'] == BlackPlayers) {
	    			this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.SelectedPortrait[BlackPlayers] + "_png.vtex')";
	    		};
	    	} else {
	    		if (this.PickOrder['playerID1'] == BlackPlayers) {
	    			this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.SelectedPortrait[BlackPlayers] + "_png.vtex')";
	    		};
	    		if (this.PickOrder['playerID2'] == BlackPlayers) {
	    			this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.SelectedPortrait[BlackPlayers] + "_png.vtex')";
	    		};
	    	}
        };

        if (!!this.picked[BlackPlayers]) {
            if (this.SkinSelect[this.picked[BlackPlayers]] == 0) {
        	   this.PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.picked[BlackPlayers] + "_png.vtex')";
        	} else {
               this.PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.picked[BlackPlayers] + "_" + this.SkinSelect[this.picked[BlackPlayers]] + "_png.vtex')"; 
            };
            this.PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").RemoveClass("greyscale");
        	var curIndex = GetIndex(heroes, this.picked[BlackPlayers]);
        	this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("heroNameLabel").text = names[curIndex];
        };

        if (!!this.picked[BlackPlayers] && (this.PickOrder['playerID1'] == BlackPlayers || this.PickOrder['playerID2'] == BlackPlayers)) {
        	if (this.PickOrder["playerID2"] == null) {
				//$.Msg(this.pickedplayer[this.PickOrder['playerID1']])
				if (this.PickOrder['playerID1'] == BlackPlayers) {
	    			this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[BlackPlayers] + "_png.vtex')";
	    		};
	    	} else {
	    		if (this.PickOrder['playerID1'] == BlackPlayers) {
	    			this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[BlackPlayers] + "_png.vtex')";
	    		};
	    		if (this.PickOrder['playerID2'] == BlackPlayers) {
	    			this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[BlackPlayers] + "_png.vtex')";
	    		};
	    	}
        };
        
    };

    for (var heroName in this.twentyCost) {
        var herotwentyPanel = this.twentyPanel.FindChild(heroName);
        if (herotwentyPanel == null) {
            herotwentyPanel = $.CreatePanel("Image", this.twentyPanel, heroName);
            herotwentyPanel.SetImage("s2r://panorama/images/custom_game/draft/" + heroName + "_png.vtex");
            herotwentyPanel.AddClass("hero");
            this.LinkHeroTooltip(herotwentyPanel, heroName);
            this.BindOnActivate(herotwentyPanel, heroName);
        };

        this.SelectBarChange(heroName);
    	
    	if (!!!this.availableHeroes[heroName] && this.banned[heroName]) {
    		herotwentyPanel.SetHasClass("redscale", !this.availableHeroes[heroName]);
    		herotwentyPanel.ClearPanelEvent("onmouseactivate");
    	} else if (!!!this.availableHeroes[heroName] && this.picked[this.playerId]) {
    		herotwentyPanel.SetHasClass("grayscale", !this.availableHeroes[heroName]);
    		herotwentyPanel.ClearPanelEvent("onmouseactivate");
    	} else if (!!this.availableHeroes[heroName] && !!!this.banned[heroName] && !!!this.picked[this.playerId]) {
    		this.BindOnActivate(herotwentyPanel, heroName);
    	};
    };

    for (var heroName in this.tenCost) {
        var herotenPanel = this.tenPanel.FindChild(heroName);
        if (herotenPanel == null) {
            herotenPanel = $.CreatePanel("Image", this.tenPanel, heroName);
            herotenPanel.SetImage("s2r://panorama/images/custom_game/draft/" + heroName + "_png.vtex");
            herotenPanel.AddClass("hero");
            this.LinkHeroTooltip(herotenPanel, heroName);
            this.BindOnActivate(herotenPanel, heroName);
        };

        this.SelectBarChange(heroName);

    	if (!!!this.availableHeroes[heroName] && this.banned[heroName]) {
    		herotenPanel.SetHasClass("redscale", !this.availableHeroes[heroName]);
    		herotenPanel.ClearPanelEvent("onmouseactivate");
    	} else if (!!!this.availableHeroes[heroName] && this.picked[this.playerId]) {
    		herotenPanel.SetHasClass("grayscale", !this.availableHeroes[heroName]);
    		herotenPanel.ClearPanelEvent("onmouseactivate");
    	} else if (!!this.availableHeroes[heroName] && !!!this.banned[heroName] && !!!this.picked[this.playerId]) {
    		this.BindOnActivate(herotenPanel, heroName);
    	};
    };

    for (var UnselectedheroBlack in this.UnselectedBlack) {
    	if (Players.GetTeam(this.playerId) == 3 ) {
    		if (this.UnselectedBlack[UnselectedheroBlack] !== null) {
    			if (this.thirtyPanel.FindChild(UnselectedheroBlack) !== null) {
    				this.thirtyPanel.FindChild(UnselectedheroBlack).SetHasClass("grayscale", true);
    			};
    			if (this.twentyPanel.FindChild(UnselectedheroBlack) !== null) {
    				this.twentyPanel.FindChild(UnselectedheroBlack).SetHasClass("grayscale", true);
    			};
    		};
    	};
    };

    for (var UnselectedheroRed in this.UnselectedRed) {
    	if (Players.GetTeam(this.playerId) == 2 ) {
    		if (this.UnselectedRed[UnselectedheroRed] !== null) {
    			if (this.thirtyPanel.FindChild(UnselectedheroRed) !== null) {
    				this.thirtyPanel.FindChild(UnselectedheroRed).SetHasClass("grayscale", true);
    			};
    			if (this.twentyPanel.FindChild(UnselectedheroRed) !== null) {
    				this.twentyPanel.FindChild(UnselectedheroRed).SetHasClass("grayscale", true);
    			};
    		};
    	};
    };

    var randomPanel = this.tenPanel.FindChild("random");
    if (randomPanel == null && this.Start["game"] == "start") {
        randomPanel = $.CreatePanel("Image", this.tenPanel, "random");
        randomPanel.SetImage("s2r://panorama/images/custom_game/draft/random_png.vtex");
        randomPanel.AddClass("hero");
        this.LinkHeroTooltip(randomPanel, "random");
        this.BindOnActivate(randomPanel, "random");
    };
    if (!!!this.picked[this.playerId] && randomPanel !== null) {
    	this.BindOnActivate(randomPanel, "random");
    };
}

DraftSelection.prototype.Render = function() {
    var that = this;
    if (this.time !== "undefined") {
    	if (this.GamePhrase["gamephrase"] == "load") {
    		this.timeLabel.text = this.time;
        	this.statusLabel.text = "GAME START";
    	};
    	if (this.GamePhrase["gamephrase"] == "ban") {
    		this.timeLabel.text = this.time;
        	this.statusLabel.text = "BAN";
    	};
        if (this.GamePhrase["gamephrase"] == "pick") {
    		this.timeLabel.text = this.time;
        	this.statusLabel.text = "PICK";
    	};
    	if (this.GamePhrase["gamephrase"] == "strategy") {
    		this.timeLabel.text = this.time;
        	this.statusLabel.text = "STRATEGY";
    	};
    } else if (this.time == "undefined") {
    	this.timeLabel.text = " ";
    	this.statusLabel.text = " ";
    };
    if (this.BlackMana["mana"] == null && this.RedMana["mana"] == null) {} else {
	    this.BlackManaGuage.style.width = this.BlackMana["mana"] + "%";
	    this.container.FindChildTraverse("TopBar").FindChild("BlackMana").FindChildTraverse("BlackManaLabel").text = this.BlackMana["mana"];
	    this.RedManaGuage.style.width = this.RedMana["mana"] + "%";
	    this.container.FindChildTraverse("TopBar").FindChild("RedMana").FindChildTraverse("RedManaLabel").text = this.RedMana["mana"];
	};
    
   	if (this.GamePhrase["gamephrase"] == "ban") {
   		if (this.TeamQueue["team"] == "1") {
   			this.PlayersRedPanel.FindChild(this.BanOrder['playerId']).SetHasClass("turn", this.GamePhrase["gamephrase"] == "ban" && !!!this.pickedplayer[this.BanOrder['playerId']]);
   		} else if (this.TeamQueue["team"] == "2") {
   			this.PlayersBlackPanel.FindChild(this.BanOrder['playerId']).SetHasClass("turn", this.GamePhrase["gamephrase"] == "ban" && !!!this.pickedplayer[this.BanOrder['playerId']]);
   		};
	} else if (this.GamePhrase["gamephrase"] == "blank") {
   		for (var RedPlayers in this.RedTeam) { 
   			this.PlayersRedPanel.FindChild(RedPlayers).SetHasClass("turn", false);
   		};
   		for (var BlackPlayers in this.BlackTeam) { 
   			this.PlayersBlackPanel.FindChild(BlackPlayers).SetHasClass("turn", false);
   		};
   	} else if (this.GamePhrase["gamephrase"] == "pick") {
		if (this.TeamQueue["team"] == "1") {
   			this.PlayersRedPanel.FindChild(this.HiLight['playerID1']).SetHasClass("turn", this.GamePhrase["gamephrase"] == "pick" && !!!this.pickedplayer[this.HiLight['playerID1']]);
   			if (!!this.HiLight['playerID2']) {
   				this.PlayersRedPanel.FindChild(this.HiLight['playerID2']).SetHasClass("turn", this.GamePhrase["gamephrase"] == "pick" && !!!this.pickedplayer[this.HiLight['playerID2']]);
   			};
   		} else if (this.TeamQueue["team"] == "2") {
   			this.PlayersBlackPanel.FindChild(this.HiLight['playerID1']).SetHasClass("turn", this.GamePhrase["gamephrase"] == "pick" && !!!this.pickedplayer[this.HiLight['playerID1']]);
   			if (!!this.HiLight['playerID2']) {
   				this.PlayersBlackPanel.FindChild(this.HiLight['playerID2']).SetHasClass("turn", this.GamePhrase["gamephrase"] == "pick" && !!!this.pickedplayer[this.HiLight['playerID2']]);
   			};
   		};
	};

}

function BindOnBanBlack (panel, hero) {
	var container = $.GetContextPanel();
	var SelectedHeroPanel1 = container.FindChildTraverse("Selected1");
	var BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
	var selectedbar = container.FindChildTraverse("selectedbar");
	var playerID = Game.GetLocalPlayerID();
	var player = Players.GetLocalPlayer();
	var availableHeroes = CustomNetTables.GetTableValue("draft", "available") || {};
	var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
	var pickedplayer = CustomNetTables.GetTableValue("draft", "pickedplayer") || {};
	var banned = CustomNetTables.GetTableValue("draft", "banned") || {};
	var GamePhrase = CustomNetTables.GetTableValue("draft", "gamephrase") || {};
	if (!!pickedplayer[playerID] || availableHeroes[hero] === null || banned[hero] == 1 || !!picked[playerID] ) {
	    $.Msg('Can not click');
	    $.Msg('ban red');
	    return;
	};
	if (Players.IsSpectator(player) || Players.GetTeam(playerID) == 3 || Players.GetTeam(playerID) == 2) {
		SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";
	};
	selectedbar.SetPanelEvent("onmouseactivate",
		function() {
			//$.Msg(hero);
			//$.Msg(panel);
			var container = $.GetContextPanel();
			var SelectedHeroPanel1 = container.FindChildTraverse("Selected1");
			var playerID = Game.GetLocalPlayerID()
			var PlayersRedPanel = container.FindChildTraverse("LeftBar");
			var RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
			var PlayersBlackPanel = container.FindChildTraverse("RightBar");
			var BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
			var banned = CustomNetTables.GetTableValue("draft", "banned") || {};
			var availableHeroes = CustomNetTables.GetTableValue("draft", "available") || {};
			var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
			var pickedplayer = CustomNetTables.GetTableValue("draft", "pickedplayer") || {};
			var BanOrder = CustomNetTables.GetTableValue("draft", "banorder") || {};
			if (!!pickedplayer[playerID] || availableHeroes[hero] === null || banned[hero] == 1 || !!picked[playerID]) {
				$.Msg('Can not click');
				return;
			};
			panel.SetHasClass("redscale", true);
			PlayersBlackPanel.FindChild(BanOrder['playerId']).SetHasClass("turn", false);		
			SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";
			if (Players.GetTeam(playerID) == 3) {
				for (var BlackPlayers in BlackTeam) { 
					if (PlayersBlackPanel.FindChild(playerID).FindChild("portraitBlack").style["background-image"] === "url( file://{images}/custom_game/draft/" + hero + "_png.vtex )  / none none unset unset") {
						PlayersBlackPanel.FindChild(playerID).FindChild("portraitBlack").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/other/defaultportrait_png.vtex')";
						PlayersBlackPanel.FindChild(playerID).FindChild("portraitBlack").SetHasClass("greyscale", false);
						PlayersBlackPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = "";
					};
				};
			};
			if (Players.GetTeam(playerID) == 2) {
				for (var RedPlayers in RedTeam) { 
					if (PlayersRedPanel.FindChild(playerID).FindChild("portraitRed").style["background-image"] === "url( file://{images}/custom_game/draft/" + hero + "_png.vtex )  / none none unset unset") {
						PlayersRedPanel.FindChild(playerID).FindChild("portraitRed").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/other/defaultportrait_png.vtex')";
						PlayersRedPanel.FindChild(playerID).FindChild("portraitRed").SetHasClass("greyscale", false);
						PlayersRedPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = "";
					};
				};
			};
			GameEvents.SendCustomGameEventToServer("draft_hero_ban", {
				playerId: playerID,
				hero: hero,
			});
		 }
	);
}

function BindOnBanRed (panel, hero) {
	var container = $.GetContextPanel();
	var SelectedHeroPanel1 = container.FindChildTraverse("Selected1");
	var RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
	var selectedbar = container.FindChildTraverse("selectedbar");
	var playerID = Game.GetLocalPlayerID();
	var player = Players.GetLocalPlayer();
	var availableHeroes = CustomNetTables.GetTableValue("draft", "available") || {};
	var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
	var pickedplayer = CustomNetTables.GetTableValue("draft", "pickedplayer") || {};
	var banned = CustomNetTables.GetTableValue("draft", "banned") || {};
	var GamePhrase = CustomNetTables.GetTableValue("draft", "gamephrase") || {};
	if (!!pickedplayer[playerID] || availableHeroes[hero] === null || banned[hero] == 1 || !!picked[playerID] ) {
	    $.Msg('Can not click');
	    $.Msg('ban red');
	    return;
	};
	if (Players.IsSpectator(player) || Players.GetTeam(playerID) == 3 || Players.GetTeam(playerID) == 2) {
		SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";
	};
	selectedbar.SetPanelEvent("onmouseactivate",
		function() {
			var container = $.GetContextPanel();
			var SelectedHeroPanel1 = container.FindChildTraverse("Selected1");
			var playerID = Game.GetLocalPlayerID()
			var PlayersRedPanel = container.FindChildTraverse("LeftBar");
			var RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
			var PlayersBlackPanel = container.FindChildTraverse("RightBar");
			var BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
			var banned = CustomNetTables.GetTableValue("draft", "banned") || {};
			var availableHeroes = CustomNetTables.GetTableValue("draft", "available") || {};
			var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
			var pickedplayer = CustomNetTables.GetTableValue("draft", "pickedplayer") || {};
			var BanOrder = CustomNetTables.GetTableValue("draft", "banorder") || {};
			if (!!pickedplayer[playerID] || availableHeroes[hero] === null || banned[hero] == 1 || !!picked[playerID]) {
				$.Msg('Can not click');
				return;
			};
			panel.SetHasClass("redscale", true);
			PlayersRedPanel.FindChild(BanOrder['playerId']).SetHasClass("turn", false);			    	
			SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";
			
			if (Players.GetTeam(playerID) == 3) {
				for (var BlackPlayers in BlackTeam) { 
					if (PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").style["background-image"] === "url( file://{images}/custom_game/draft/" + hero + "_png.vtex )  / none none unset unset") {
						PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/other/defaultportrait_png.vtex')";
						if (PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").BHasClass("greyscale")) {
							PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").SetHasClass("greyscale", false);
						};
						PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("heroNameLabel").text = "";
					};
				};
			};
			if (Players.GetTeam(playerID) == 2) {
				for (var RedPlayers in RedTeam) { 
					if (PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").style["background-image"] === "url( file://{images}/custom_game/draft/" + hero + "_png.vtex )  / none none unset unset") {
						PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/other/defaultportrait_png.vtex')";
						if (PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").BHasClass("greyscale")) {
							PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").SetHasClass("greyscale", false);
						};
						PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("heroNameLabel").text = "";
					};
				};
			};
			GameEvents.SendCustomGameEventToServer("draft_hero_ban", {
				playerId: playerID,
				hero: hero,
			});
			$.Msg('send ban data')
		}
	);
}

function CheckingHero (hero) {
	var container = $.GetContextPanel();
	var PlayersRedPanel = container.FindChildTraverse("LeftBar");
	var RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
	var PlayersBlackPanel = container.FindChildTraverse("RightBar");
	var BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
	var playerID = Game.GetLocalPlayerID()
	if (Players.GetTeam(playerID) == 3) {
		for (var BlackPlayers in BlackTeam) { 
			if (BlackPlayers !== playerID) {
				if (PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").style["background-image"] === "url( file://{images}/custom_game/draft/" + hero + "_png.vtex )  / none none unset unset") {
					if (PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").BHasClass("greyscale")) {
						PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").SetHasClass("greyscale", false);
					};
					PlayersBlackPanel.FindChild(BlackPlayers).FindChild("portraitBlack").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/other/defaultportrait_png.vtex')";
					
					PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("heroNameLabel").text = "";
				};
			};
		};
	};
	if (Players.GetTeam(playerID) == 2) {
		for (var RedPlayers in RedTeam) { 
			if (RedPlayers !== playerID) {
				if (PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").style["background-image"] === "url( file://{images}/custom_game/draft/" + hero + "_png.vtex )  / none none unset unset") {
					if (PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").BHasClass("greyscale")) {
						PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").SetHasClass("greyscale", false);
					};
					PlayersRedPanel.FindChild(RedPlayers).FindChild("portraitRed").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/other/defaultportrait_png.vtex')";
					
					PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("heroNameLabel").text = "";
				};
			};
		};
	};
}

function OnChangingPortrait(hero,team,selectbar) {
	var playerID = Game.GetLocalPlayerID();
	var player = Players.GetLocalPlayer();
	var container = $.GetContextPanel();
	var PlayersRedPanel = container.FindChildTraverse("LeftBar");
	var RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
	var PlayersBlackPanel = container.FindChildTraverse("RightBar");
	var BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
	var SelectedHeroPanel1 = container.FindChildTraverse("Selected1");
	var SelectedHeroPanel = container.FindChildTraverse("SelectedPanel2");
	var curIndex = GetIndex(heroes, hero);
	var heroname = names[curIndex];
	GameEvents.SendCustomGameEventToServer("draft_hero_changeportrait", {
		playerId: playerID,
		hero: hero,
	});
	if (Players.IsSpectator(player) || Players.GetTeam(playerID) == 3 || Players.GetTeam(playerID) == 2) {
		if (selectbar == "1") {
			SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";		
		} else if (selectbar == "2") {
			SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";		
		} else if (selectbar == "3") {
			SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";		
		};
		if (team == "BlackTeam") {
	
			PlayersBlackPanel.FindChild(playerID).FindChild("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + hero + "_png.vtex')";
			PlayersBlackPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = heroname;
			PlayersBlackPanel.FindChild(playerID).FindChild("portraitBlack").SetHasClass("greyscale", false);
		} else if (team == "RedTeam") {
			
			PlayersRedPanel.FindChild(playerID).FindChild("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + hero + "_png.vtex')";
			PlayersRedPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = heroname;
			PlayersRedPanel.FindChild(playerID).FindChild("portraitRed").SetHasClass("greyscale", false);
		};
	};
}

function BindOnPick (panel, hero, team) {
	var playerID = Game.GetLocalPlayerID();
	var container = $.GetContextPanel(); 
	var PlayersBlackPanel = container.FindChildTraverse("RightBar");
	var SelectedHeroPanel1 = container.FindChildTraverse("Selected1");
	var BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
	var RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
	var selectedbar = container.FindChildTraverse("selectedbar");
	var curIndex = GetIndex(heroes, hero);
	var availableHeroes = CustomNetTables.GetTableValue("draft", "available") || {};
	var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
	var pickedplayer = CustomNetTables.GetTableValue("draft", "pickedplayer") || {};
	var banned = CustomNetTables.GetTableValue("draft", "banned") || {};
	if (pickedplayer[playerID] == playerID || availableHeroes[hero] === null || banned[hero] == 1 || !!picked[playerID]) {
		return;
	};
	if (team == "BlackTeam") {
		OnChangingPortrait(hero,team,"1");   	
	} else if (team == "RedTeam") {
		OnChangingPortrait(hero,team,"1");   	
	};
	selectedbar.SetPanelEvent("onmouseactivate",
		function() {
			var playerID = Game.GetLocalPlayerID();
			var container = $.GetContextPanel();
			var SelectedHeroPanel1 = container.FindChildTraverse("Selected1");
			var PlayersRedPanel = container.FindChildTraverse("LeftBar");
			var RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
			var PlayersBlackPanel = container.FindChildTraverse("RightBar");
			var BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
			var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
			var pickedplayer = CustomNetTables.GetTableValue("draft", "pickedplayer") || {};
			var ID = CustomNetTables.GetTableValue("draft", "id") || {};
            if (pickedplayer[playerID] == playerID) {
                return;
            };
            //$.Msg('my id :' + ID[playerID]);
            //$.Msg('ban id :' + nomercy[ID[playerID]]);
            if (ID[playerID] == nomercy[ID[playerID]]) {
                
                hero = "ban"
            } else if (ID[playerID] == null || ID[playerID] == "undefined") {
                hero = "error"
            };
			
			if (hero == "random") {
				GameEvents.SendCustomGameEventToServer("draft_hero_random", {
					playerId: playerID,
				});
				var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
				//$.Msg(picked);
				var heroed = picked[playerID];
				var curIndex = GetIndex(heroes, heroed);
				$.Msg('random =>' + heroed);
				$.Msg('random =>' + names[curIndex]);
				SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + heroed + "_png.vtex')";
				if (team == "BlackTeam") {
					PlayersBlackPanel.FindChild(playerID).FindChild("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + heroed + "_png.vtex')";
					PlayersBlackPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];
					PlayersBlackPanel.FindChild(playerID).RemoveClass("turn");
					
				} else if (team == "RedTeam") {
					PlayersRedPanel.FindChild(playerID).FindChild("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + picked[playerID] + "_png.vtex')";
					PlayersRedPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];
					PlayersRedPanel.FindChild(playerID).RemoveClass("turn");
				};
				CheckingHero (picked[playerID]);
			} else {
				panel.AddClass("greyscale");
				var curIndex = GetIndex(heroes, hero);
				if (team == "BlackTeam") {
					PlayersBlackPanel.FindChild(playerID).FindChild("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + hero + "_png.vtex')";
					PlayersBlackPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];
					PlayersBlackPanel.FindChild(playerID).RemoveClass("turn");
					SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";
				} else if (team == "RedTeam") {
					PlayersRedPanel.FindChild(playerID).FindChild("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + hero + "_png.vtex')";
					PlayersRedPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];
					PlayersRedPanel.FindChild(playerID).RemoveClass("turn");
					SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";
				};
				CheckingHero (hero);
				GameEvents.SendCustomGameEventToServer("draft_hero_click", {
					playerId: playerID,
					hero: hero,
				});
			}
		}
	)
}

function BindOnPick2 (panel, hero, team) {
	var playerID = Game.GetLocalPlayerID();
	var container = $.GetContextPanel(); 
	var PlayersBlackPanel = container.FindChildTraverse("RightBar");
	var SelectedHeroPanel = container.FindChildTraverse("SelectedPanel2");
	var BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
	var RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
	var selectedbar = container.FindChildTraverse("selectedbar");
	var curIndex = GetIndex(heroes, hero);
	var availableHeroes = CustomNetTables.GetTableValue("draft", "available") || {};
	var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
	var pickedplayer = CustomNetTables.GetTableValue("draft", "pickedplayer") || {};
	var banned = CustomNetTables.GetTableValue("draft", "banned") || {};
	if (pickedplayer[playerID] == playerID || availableHeroes[hero] === null || banned[hero] == 1 || !!picked[playerID]) {
		return;
	};
	if (team == "BlackTeam") {
		OnChangingPortrait(hero,team,"2");   	
	} else if (team == "RedTeam") {
		OnChangingPortrait(hero,team,"2");   	
	};
	selectedbar.SetPanelEvent("onmouseactivate",
		function() {
			var playerID = Game.GetLocalPlayerID();
			var container = $.GetContextPanel();
			var SelectedHeroPanel = container.FindChildTraverse("SelectedPanel2");
			var PlayersRedPanel = container.FindChildTraverse("LeftBar");
			var RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
			var PlayersBlackPanel = container.FindChildTraverse("RightBar");
			var BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
			var pickedplayer = CustomNetTables.GetTableValue("draft", "pickedplayer") || {};
			var ID = CustomNetTables.GetTableValue("draft", "id") || {};
            if (pickedplayer[playerID] == playerID) {
                return;
            };
            if (ID[playerID] == nomercy[ID[playerID]]) {
                hero = "ban"
            } else if (ID[playerID] == null || ID[playerID] == "undefined") {
                hero = "error"
            };
			
			if (hero == "random") {
				GameEvents.SendCustomGameEventToServer("draft_hero_random", {
					playerId: playerID,
				});
				var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
				var curIndex = GetIndex(heroes, picked[playerID]);
				if (team == "BlackTeam") {
					PlayersBlackPanel.FindChild(playerID).FindChild("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + picked[playerID] + "_png.vtex')";
					PlayersBlackPanel.FindChild(playerID).RemoveClass("turn");
					PlayersBlackPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];
				} else if (team == "RedTeam") {
					PlayersRedPanel.FindChild(playerID).FindChild("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + picked[playerID] + "_png.vtex')";
					PlayersRedPanel.FindChild(playerID).RemoveClass("turn");
					PlayersRedPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];
				};
				SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + picked[playerID] + "_png.vtex')";
				CheckingHero (picked[playerID]);
				if (SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] === "url( file://{images}/custom_game/draft/selection/" + picked[playerID] + "_png.vtex )  / none none unset unset") {
				    SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/other/defaultportrait_png.vtex')";
				};
			} else {
				panel.AddClass("greyscale");
				var curIndex = GetIndex(heroes, hero);
				if (team == "BlackTeam") {
					PlayersBlackPanel.FindChild(playerID).FindChild("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + hero + "_png.vtex')";
					PlayersBlackPanel.FindChild(playerID).RemoveClass("turn");
					PlayersBlackPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];	
				} else if (team == "RedTeam") {
					PlayersRedPanel.FindChild(playerID).FindChild("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + hero + "_png.vtex')";
					PlayersRedPanel.FindChild(playerID).RemoveClass("turn");
					PlayersRedPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];
				};
				SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";
				CheckingHero (hero);
				if (SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] === "url( file://{images}/custom_game/draft/selection/" + hero + "_png.vtex )  / none none unset unset") {
				    SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/other/defaultportrait_png.vtex')";
				};
				GameEvents.SendCustomGameEventToServer("draft_hero_click", {
					playerId: playerID,
					hero: hero,
				});
			}
		}
	)
}

function BindOnPick3 (panel, hero, team) {
	var playerID = Game.GetLocalPlayerID();
	var container = $.GetContextPanel(); 
	var PlayersBlackPanel = container.FindChildTraverse("RightBar");
	var SelectedHeroPanel = container.FindChildTraverse("SelectedPanel2");
	var BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
	var RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
	var selectedbar = container.FindChildTraverse("selectedbar");
	var curIndex = GetIndex(heroes, hero);
	var availableHeroes = CustomNetTables.GetTableValue("draft", "available") || {};
	var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
	var pickedplayer = CustomNetTables.GetTableValue("draft", "pickedplayer") || {};
	var banned = CustomNetTables.GetTableValue("draft", "banned") || {};
	if (pickedplayer[playerID] == playerID || availableHeroes[hero] === null || banned[hero] == 1 || !!picked[playerID]) {
		return;
	};
	if (team == "BlackTeam") {
		OnChangingPortrait(hero,team,"3");   	
	} else if (team == "RedTeam") {
		OnChangingPortrait(hero,team,"3");   	
	};
	selectedbar.SetPanelEvent("onmouseactivate",
		function() {
			var playerID = Game.GetLocalPlayerID();
			var container = $.GetContextPanel();
			var SelectedHeroPanel = container.FindChildTraverse("SelectedPanel2");
			var PlayersRedPanel = container.FindChildTraverse("LeftBar");
			var RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
			var PlayersBlackPanel = container.FindChildTraverse("RightBar");
			var BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
			var pickedplayer = CustomNetTables.GetTableValue("draft", "pickedplayer") || {};
            var ID = CustomNetTables.GetTableValue("draft", "id") || {};
			if (pickedplayer[playerID] == playerID) {
				return;
			};
            if (ID[playerID] == nomercy[ID[playerID]]) {
                hero = "ban"
            } else if (ID[playerID] == null || ID[playerID] == "undefined") {
                hero = "error"
            };
			
			if (hero == "random") {
				GameEvents.SendCustomGameEventToServer("draft_hero_random", {
					playerId: playerID,
				});
				var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
				var curIndex = GetIndex(heroes, picked[playerID]);
				if (team == "BlackTeam") {
					PlayersBlackPanel.FindChild(playerID).FindChild("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + picked[playerID] + "_png.vtex')";
					PlayersBlackPanel.FindChild(playerID).RemoveClass("turn");
					PlayersBlackPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];
				} else if (team == "RedTeam") {
					PlayersRedPanel.FindChild(playerID).FindChild("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + picked[playerID] + "_png.vtex')";
					PlayersRedPanel.FindChild(playerID).RemoveClass("turn");
					PlayersRedPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];
				};
				SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + picked[playerID] + "_png.vtex')";
				CheckingHero (picked[playerID]);
				if (SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] === "url( file://{images}/custom_game/draft/selection/" + picked[playerID] + "_png.vtex )  / none none unset unset") {
				    SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/other/defaultportrait_png.vtex')";
				};
			} else {
				panel.AddClass("greyscale");
				var curIndex = GetIndex(heroes, hero);
				if (team == "BlackTeam") {
					PlayersBlackPanel.FindChild(playerID).FindChild("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + hero + "_png.vtex')";
					PlayersBlackPanel.FindChild(playerID).RemoveClass("turn");
					PlayersBlackPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];	
				} else if (team == "RedTeam") {
					print("??????")
					PlayersRedPanel.FindChild(playerID).FindChild("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + hero + "_png.vtex')";
					PlayersRedPanel.FindChild(playerID).RemoveClass("turn");
					PlayersRedPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];
				};
				SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";
				CheckingHero (hero);
				if (SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] === "url( file://{images}/custom_game/draft/selection/" + hero + "_png.vtex )  / none none unset unset") {
				    SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/other/defaultportrait_png.vtex')";
				};
				GameEvents.SendCustomGameEventToServer("draft_hero_click", {
					playerId: playerID,
					hero: hero,
				});
			}
		}
	)
}

function PreSelect (panel, hero, team) {
	var container = $.GetContextPanel();
	var playerID = Game.GetLocalPlayerID();
	var PlayersRedPanel = container.FindChildTraverse("LeftBar");
	var RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
	var PlayersBlackPanel = container.FindChildTraverse("RightBar");
	var BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
	var curIndex = GetIndex(heroes, hero);
	var availableHeroes = CustomNetTables.GetTableValue("draft", "available") || {};
	var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
	var pickedplayer = CustomNetTables.GetTableValue("draft", "pickedplayer") || {};
	var banned = CustomNetTables.GetTableValue("draft", "banned") || {};
	if (!!pickedplayer[playerID] || availableHeroes[hero] === null || banned[hero] == 1 || !!picked[playerID]) {
		return;
	};
	if (team == "RedTeam") {
		for (var RedPlayers in RedTeam) {
			if (Players.GetTeam(playerID) == 2) {
				//PlayersRedPanel.FindChild(playerID).FindChild("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + hero + "_png.vtex')";
				//PlayersRedPanel.FindChild(playerID).FindChild("portraitRed").SetHasClass("greyscale", true);
				//PlayersRedPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];	
			}		    	
		}
	} else if (team == "BlackTeam") {
		for (var BlackPlayers in BlackTeam) {
			if (Players.GetTeam(playerID) == 3) {
				PlayersBlackPanel.FindChild(playerID).FindChild("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + hero + "_png.vtex')";
				PlayersBlackPanel.FindChild(playerID).FindChild("portraitBlack").SetHasClass("greyscale", true);
				PlayersBlackPanel.FindChild(playerID).FindChildTraverse("heroNameLabel").text = names[curIndex];		
			}
		}	    	
	};
	GameEvents.SendCustomGameEventToServer("draft_hero_preselect", {
		playerId: playerID,
		hero: hero,
	});
}

DraftSelection.prototype.SelectBarChange = function(hero) {
	if (this.GamePhrase["gamephrase"] == "pick" || this.GamePhrase["gamephrase"] == "blank") {
		if (this.PickOrder["playerID2"] == null) {
			//$.Msg(this.pickedplayer[this.PickOrder['playerID1']])
			if (this.pickedplayer[this.PickOrder['playerID1']] == hero) {
    			this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";
    		};
    	} else {
    		if (this.pickedplayer[this.PickOrder['playerID1']] == hero) {
    			this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";
    		};
    		if (this.pickedplayer[this.PickOrder['playerID2']] == hero) {
    			this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";
    		};
    	}
	};
}

DraftSelection.prototype.LinkHeroTooltip = function(panel, hero) {

    panel.SetAttributeString("hero_name", hero + "_draft");
    panel.BLoadLayout("file://{resources}/layout/custom_game/fateanother_context_hero_selection.xml", false, false );
}

DraftSelection.prototype.PreSelection = function(panel, hero) {
	if (!!!this.pickedplayer[this.playerId] && this.playerId !== this.BanOrder['playerId'] && this.playerId !== (this.PickOrder["playerID1"] || this.PickOrder["playerID2"])) {
	    //$.Msg('preselect is working');
	    if (this.RedTeam[this.playerId] == this.playerId) {
		    panel.SetPanelEvent( "onmouseactivate", 
	    		function() {
				    PreSelect (panel, hero, "RedTeam")
				}
			)
		} else if (this.BlackTeam[this.playerId] == this.playerId) {
	    	panel.SetPanelEvent( "onmouseactivate", 
	    		function() {
				    PreSelect (panel, hero, "BlackTeam")
				}
			)
		};
    };
}

DraftSelection.prototype.BindOnActivate = function(panel, hero) {
    var that = this;
    if (this.playerId == null) {
    	$.Msg('this.playerId cannot found');
    	this.playerId = Game.GetLocalPlayerID();
    };
    //$.Msg('playerId = ' + this.playerId);
    //$.Msg('local player = ' + Players.GetLocalPlayer());
    if (Players.IsSpectator(this.playerId) || this.pickedplayer[this.playerId] == this.playerId || this.availableHeroes[hero] === null || this.banned[hero] == 1 || this.picked[this.playerId] == hero) {
    	//$.Msg('spectator');
        $.Msg('Can not click');
        return;
    };

    if (this.RedTeam[this.playerId] == this.playerId && this.UnselectedRed[hero] == 1) {
    	$.Msg('Not enough Mana');
    	return;
    } else if (this.BlackTeam[this.playerId] == this.playerId && this.UnselectedBlack[hero] == 1) {
    	$.Msg('Not enough Mana');
    	return;
    };

    var curIndex = GetIndex(heroes, hero);

	this.PreSelection(panel,hero)    

    if (this.GamePhrase["gamephrase"] == "ban") {
    	if (hero == "random") {
    		return;
    	};
    	if (this.playerId == this.BanOrder['playerId'] ) {
    		if (this.BlackTeam[this.playerId] == this.BanOrder['playerId']) {
	    		panel.SetPanelEvent("onmouseactivate", 
	    			function() {
	    				var GamePhrase = CustomNetTables.GetTableValue("draft", "gamephrase") || {};
	    				if (GamePhrase["gamephrase"] == "ban") {
	    					BindOnBanBlack (panel, hero)
	    				};	
					}
				);
	    	}else if (this.RedTeam[this.playerId] == this.BanOrder['playerId']) {
	    		//$.Msg(this.BanOrder['playerId'])
	    		panel.SetPanelEvent(
	    			"onmouseactivate", 
	    			function() {
	    				var GamePhrase = CustomNetTables.GetTableValue("draft", "gamephrase") || {};
	    				if (GamePhrase["gamephrase"] == "ban") {
		    				BindOnBanRed (panel, hero)
		    			};
					}
				);
	    	};
    	};
    };

    if (this.GamePhrase["gamephrase"] == "pick") {
    	//panel.ClearPanelEvent("onmouseactivate");
    	if (this.PickOrder["playerID2"] == null) {
	    	if (this.BlackTeam[this.playerId] == this.PickOrder["playerID1"] && !!!this.pickedplayer[this.playerId]) {
		   		panel.SetPanelEvent(
			        "onmouseactivate",
			        function() {
			        	BindOnPick (panel, hero, "BlackTeam");
			        }
			    );
			} else if (this.RedTeam[this.playerId] == this.PickOrder["playerID1"] && !!!this.pickedplayer[this.playerId]) {
				//$.Msg('Red Team');
		    	panel.SetPanelEvent(
	    			"onmouseactivate", 
	    			function() {
	    				BindOnPick (panel, hero, "RedTeam");
			        }
				);
	    	};
	    } else {
	    	if (this.BlackTeam[this.playerId] == this.PickOrder["playerID1"] && !!!this.pickedplayer[this.playerId]) {
		   		panel.SetPanelEvent(
			        "onmouseactivate",
			        function() {
			        	BindOnPick2 (panel, hero, "BlackTeam")
			        }
			    );
			} else if (this.BlackTeam[this.playerId] == this.PickOrder["playerID2"] && !!!this.pickedplayer[this.playerId]) {
		   		panel.SetPanelEvent(
			        "onmouseactivate",
			        function() {
					    BindOnPick3 (panel, hero, "BlackTeam")
			        }
			    );
		   	} else if (this.RedTeam[this.playerId] == this.PickOrder["playerID1"] && !!!this.pickedplayer[this.playerId]) {
		   		panel.SetPanelEvent(
			        "onmouseactivate",
			        function() {
					    BindOnPick2 (panel, hero, "RedTeam")
			        }
			    );
		   	} else if (this.RedTeam[this.playerId] == this.PickOrder["playerID2"] && !!!this.pickedplayer[this.playerId]) {
		   		panel.SetPanelEvent(
			        "onmouseactivate",
			        function() {
					    BindOnPick3 (panel, hero, "RedTeam")
			        }
			    );
		   	};
	    }; 
    };	
}


DraftSelection.prototype.SkinChangeRight = function(panel, hero) {
    panel.SetPanelEvent(
        "onmouseactivate",
        function() {
            var container = $.GetContextPanel();
            var playerID = Game.GetLocalPlayerID();
            var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
            var SkinSelect = CustomNetTables.GetTableValue("draft", "skinselect") || {};
            var availableSkins = CustomNetTables.GetTableValue("draft", "skin") || {};
            $.Msg("skin =" + SkinSelect[hero])
            $.Msg("avai skin =" + availableSkins[hero])
            if (SkinSelect[hero] >= availableSkins[hero]) {
                GameEvents.SendCustomGameEventToServer("draft_hero_skin", {
                    playerId: playerID,
                    hero: hero,
                    skin: 0,
                });
            } else {
                GameEvents.SendCustomGameEventToServer("draft_hero_skin", {
                    playerId: playerID,
                    hero: hero,
                    skin: SkinSelect[hero] + 1,
                });
            }
        }
    );    	
}

DraftSelection.prototype.SkinChangeLeft = function(panel, hero) {
    panel.SetPanelEvent(
        "onmouseactivate",
        function() {
            var container = $.GetContextPanel();
            var playerID = Game.GetLocalPlayerID();
            var picked = CustomNetTables.GetTableValue("draft", "picked") || {};
            var SkinSelect = CustomNetTables.GetTableValue("draft", "skinselect") || {};
            var availableSkins = CustomNetTables.GetTableValue("draft", "skin") || {};
            if (SkinSelect[hero] <= 0) {
                GameEvents.SendCustomGameEventToServer("draft_hero_skin", {
                    playerId: playerID,
                    hero: hero,
                    skin: availableSkins[hero],
                });
            } else {
                GameEvents.SendCustomGameEventToServer("draft_hero_skin", {
                    playerId: playerID,
                    hero: hero,
                    skin: SkinSelect[hero] - 1,
                });
            }
        }
    );      
}

DraftSelection.prototype.Update = function() {
    var that = this;

    if (that.draft == "draft" ) {
    	globalContext.visible = true;
    	globalContext.FindChild("DraftSelection").visible = true;
    };

    this.allHeroes = CustomNetTables.GetTableValue("draft", "all") || {};
    this.availableHeroes = CustomNetTables.GetTableValue("draft", "available") || {};
    this.availableSkins = CustomNetTables.GetTableValue("draft", "skin") || {};
    this.tenCost = CustomNetTables.GetTableValue("draft", "ten") || {};
    this.twentyCost = CustomNetTables.GetTableValue("draft", "twenty") || {};
    this.thirtyCost = CustomNetTables.GetTableValue("draft", "thirty") || {};
    this.RedTeam = CustomNetTables.GetTableValue("draft", "redteam") || {};
    this.BlackTeam = CustomNetTables.GetTableValue("draft", "blackteam") || {};
    this.picked = CustomNetTables.GetTableValue("draft", "picked") || {};
    this.pickedplayer = CustomNetTables.GetTableValue("draft", "pickedplayer") || {};
    this.banned = CustomNetTables.GetTableValue("draft", "banned") || {};
    this.RedMana = CustomNetTables.GetTableValue("draft", "red_mana") || {};
    this.BlackMana = CustomNetTables.GetTableValue("draft", "black_mana") || {};
    this.TeamCount = CustomNetTables.GetTableValue("draft", "teamcount") || {};
    this.GamePhrase = CustomNetTables.GetTableValue("draft", "gamephrase") || {};
    this.BanOrder = CustomNetTables.GetTableValue("draft", "banorder") || {};
    this.PickOrder = CustomNetTables.GetTableValue("draft", "pickorder") || {};
    this.TeamQueue = CustomNetTables.GetTableValue("draft", "teamqueue") || {};
    this.UnselectedBlack = CustomNetTables.GetTableValue("draft", "black_unselected") || {};
    this.UnselectedRed = CustomNetTables.GetTableValue("draft", "red_unselected") || {};
    this.Start = CustomNetTables.GetTableValue("draft", "panel") || {};
    this.Revert = CustomNetTables.GetTableValue("draft", "revert") || {};
    this.PreSelected = CustomNetTables.GetTableValue("draft", "preselect") || {};
    this.SkinSelect = CustomNetTables.GetTableValue("draft", "skinselect") || {};
    this.SelectedPortrait = CustomNetTables.GetTableValue("draft", "select_bar") || {};
    this.ID = CustomNetTables.GetTableValue("draft", "id") || {};
    this.HiLight = CustomNetTables.GetTableValue("draft", "hilight") || {};

    if (Game.GetScreenWidth() / Game.GetScreenHeight() == 4/3) {
    	this.container.AddClass("Aspect4x3");
    } else if (Game.GetScreenWidth() / Game.GetScreenHeight() == 16/9) {
    	this.container.AddClass("Aspect16x9");
    } else if (Game.GetScreenWidth() / Game.GetScreenHeight() == 16/10) {
    	this.container.AddClass("Aspect16x10");
    };
    if (this.GamePhrase["gamephrase"] == "load") {
        this.SelectedHeroPanel.visible = false;
		this.SelectedHeroPanel1.visible = false;
		this.selectedbar.visible = false;
    };
    if (this.GamePhrase["gamephrase"] == "ban") {
        this.SelectedHeroPanel.visible = false;
		this.SelectedHeroPanel1.visible = true;
		if (this.BanOrder['playerId'] == Players.GetLocalPlayer()) {
			this.selectedbar.visible = true;
		} else {
			this.selectedbar.visible = false;
		};
		this.selectedbarPlayerName1.text = Players.GetPlayerName( this.BanOrder['playerId'] );
    };

    if (this.GamePhrase["gamephrase"] == "blank") {
		this.selectedbar.visible = false;
    };

    if (this.GamePhrase["gamephrase"] == "pick") {
    	if (this.PickOrder['playerID1'] == Players.GetLocalPlayer() || this.PickOrder['playerID2'] == Players.GetLocalPlayer()) {
    		if (!!!this.pickedplayer[this.playerId]) {
				this.selectedbar.visible = true;
				this.selectedbar.FindChildTraverse("selectedbartext").text = "SELECT";
			} else {
				this.selectedbar.visible = false;
			};
		} else {
			this.selectedbar.visible = false;
		};
		if (this.PickOrder["playerID2"] == null ) {
	        this.SelectedHeroPanel.visible = false;
			this.SelectedHeroPanel1.visible = true;
			this.selectedbarPlayerName1.text = Players.GetPlayerName( this.PickOrder["playerID1"]  )
		} else {
			this.SelectedHeroPanel.visible = true;
			this.SelectedHeroPanel1.visible = false;
			this.selectedbarPlayerName2.text = Players.GetPlayerName( this.PickOrder["playerID1"]  )
			this.selectedbarPlayerName3.text = Players.GetPlayerName( this.PickOrder["playerID2"]  )
		};
		
    };

    if (this.GamePhrase["gamephrase"] == "strategy" ) {
        this.SelectedHeroPanel.visible = false;
        if (Players.IsSpectator(this.playerId)) {
			this.SelectedHeroPanel1.visible = false;
		} else {
			this.SelectedHeroPanel1.visible = true;
            if (this.availableSkins[this.picked[this.playerId]] > 0){
                this.selectedright.visible = true;   
                this.selectedleft.visible = true; 
                this.SkinChangeLeft(this.selectedleft, this.picked[this.playerId])
                this.SkinChangeRight(this.selectedright, this.picked[this.playerId])
            };     
		};
		this.selectedbar.visible = false;
    };

   	if (this.Revert["time"] > 0 ) {
   		if (this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] !== "url( file://{images}/custom_game/draft/other/defaultselect_png.vtex )  / none none unset unset") {
    		this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultselect_png.vtex')";
    	};
    	if (this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] !== "url( file://{images}/custom_game/draft/other/defaultselect_png.vtex )  / none none unset unset") {
    		this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultselect_png.vtex')";
    	};
    	if (this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] !== "url( file://{images}/custom_game/draft/other/defaultselect_png.vtex )  / none none unset unset") {
    		this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultselect_png.vtex')";
    	};
    }; 

    if (this.time <= 0 && this.GamePhrase["gamephrase"] == "ban" && this.BanOrder['playerId'] == this.playerId) {
    	GameEvents.SendCustomGameEventToServer("draft_hero_ban", {
			playerId: this.playerId,
		});
    };

    if (this.time <= 30 && this.time >= 0 && this.GamePhrase["gamephrase"] == "pick" ) {
    	if (this.PickOrder["playerID2"] == null) {
    		if (!!this.pickedplayer[this.PickOrder['playerID1']]) {
    			this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.picked[this.PickOrder['playerID1']] + "_png.vtex')";
    		};
    	} else {
    		if (!!this.pickedplayer[this.PickOrder['playerID1']]) {
    			this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder['playerID1']] + "_png.vtex')";
    		};
    		if (!!this.pickedplayer[this.PickOrder['playerID2']]) {
    			this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder['playerID2']] + "_png.vtex')";
    		};
    	};
    } else if (this.GamePhrase["gamephrase"] == "blank") {
    	if (this.PickOrder["playerID2"] == null) {
    		if (!!this.pickedplayer[this.PickOrder['playerID1']]) {
    			$.Msg('random = > 2' + this.picked[this.PickOrder['playerID1']])
    			this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.picked[this.PickOrder['playerID1']] + "_png.vtex')";
    		};
    	} else {
    		$.Msg('random = > 3' + this.picked[this.PickOrder['playerID1']])
    		if (!!this.pickedplayer[this.PickOrder['playerID1']]) {
    			$.Msg('random = > 4' + this.picked[this.PickOrder['playerID1']])
    			this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder['playerID1']] + "_png.vtex')";
    		};
    		if (!!this.pickedplayer[this.PickOrder['playerID2']]) {
    			this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder['playerID2']] + "_png.vtex')";
    		};
    	}
    };	

    if (this.GamePhrase["gamephrase"] == "pick" && this.PickOrder['playerID1'] == null && this.PickOrder['playerID2'] == null) {
    	GameEvents.SendCustomGameEventToServer("draft_hero_strategy", { });
    };

    if (this.time <= 0 && that.GamePhrase["gamephrase"] == "pick" && !!!this.picked[this.playerId] && (this.playerId == that.PickOrder1 || this.playerId == that.PickOrder2)) {
    	//$.Msg('Random');
    	GameEvents.SendCustomGameEventToServer("draft_hero_random", {
			playerId: this.playerId,
		});
		
		if (this.playerId == this.PickOrder["playerID1"]  && this.PickOrder["playerID2"] == null ) {
    		if (this.BlackTeam[this.playerId] == this.PickOrder["playerID1"] ) {
				var curIndex = GetIndex(heroes, this.picked[this.playerId]);
				this.PlayersBlackPanel.FindChild(this.playerId).SetHasClass("turn", false);
				this.PlayersBlackPanel.FindChild(this.playerId).FindChildTraverse("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')";
				this.PlayersBlackPanel.FindChild(this.playerId).FindChildTraverse("heroNameLabel").text = names[curIndex];
				this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')";
			    for (var BlackPlayers in this.BlackTeam) {
				    if (this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").style["background-image"] === "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')") {
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait_png.vtex')";
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").RemoveClass("greyscale");
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("heroNameLabel").text = "";
				    };
			    };
			    for (var RedPlayers in this.RedTeam) {
					if (this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").style["background-image"] === "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')") {
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait_png.vtex')";
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").RemoveClass("greyscale");
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("heroNameLabel").text = "";
					};
				};
			} else if (this.RedTeam[this.playerId] == this.PickOrder["playerID1"] ) {
				var curIndex = GetIndex(heroes, this.picked[this.playerId]);
				this.PlayersRedPanel.FindChild(this.playerId).SetHasClass("turn", false);
				this.PlayersRedPanel.FindChild(this.playerId).FindChildTraverse("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')";
				this.PlayersRedPanel.FindChild(this.playerId).FindChildTraverse("heroNameLabel").text = names[curIndex];
				this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')";
			   	for (var BlackPlayers in this.BlackTeam) {
				    if (this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").style["background-image"] === "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')") {
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait_png.vtex')";
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").RemoveClass("greyscale");
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("heroNameLabel").text = "";
				    };
			    };
			    for (var RedPlayers in this.RedTeam) {
					if (this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").style["background-image"] === "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')") {
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait_png.vtex')";
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").RemoveClass("greyscale");
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("heroNameLabel").text = "";
					};
				};
	    	};
    	} else if (this.playerId == this.PickOrder["playerID1"]  && !!this.PickOrder["playerID2"]) {
    		if (this.BlackTeam[this.playerId] == this.PickOrder["playerID1"] ) {
				var curIndex = GetIndex(heroes, this.picked[this.playerId]);	
				this.PlayersBlackPanel.FindChild(this.playerId).SetHasClass("turn", false);			    	
				this.PlayersBlackPanel.FindChild(this.playerId).FindChildTraverse("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')";
				this.PlayersBlackPanel.FindChild(this.playerId).FindChildTraverse("heroNameLabel").text = names[curIndex];
				this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')";
			    if (this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] === "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')") {
			        this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultselect_png.vtex')";
			    };
			    for (var BlackPlayers in this.BlackTeam) {
				    if (this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").style["background-image"] === "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')") {
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait_png.vtex')";
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").RemoveClass("greyscale");
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("heroNameLabel").text = "";
				    };
			    };
			    for (var RedPlayers in this.RedTeam) {
					if (this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").style["background-image"] === "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')") {
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait_png.vtex')";
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").RemoveClass("greyscale");
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("heroNameLabel").text = "";
					};
				};
			} else if (this.RedTeam[this.playerId] == this.PickOrder["playerID1"] ) {
				var curIndex = GetIndex(heroes, this.picked[this.playerId]);	
				this.PlayersRedPanel.FindChild(this.playerId).SetHasClass("turn", false);				    	
				this.PlayersRedPanel.FindChild(this.playerId).FindChildTraverse("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')";
				this.PlayersRedPanel.FindChild(this.playerId).FindChildTraverse("heroNameLabel").text = names[curIndex];
				this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')";
			    if (this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] === "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')") {
			        this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultselect_png.vtex')";
			    };
			   for (var BlackPlayers in this.BlackTeam) {
				    if (this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").style["background-image"] === "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')") {
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait_png.vtex')";
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").RemoveClass("greyscale");
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("heroNameLabel").text = "";
				    };
			    };
			    for (var RedPlayers in this.RedTeam) {
					if (this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").style["background-image"] === "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID1"]] + "_png.vtex')") {
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait_png.vtex')";
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").RemoveClass("greyscale");
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("heroNameLabel").text = "";
					};
				};
	    	};
    	} else if (this.playerId == this.PickOrder["playerID2"] ) {
    		if (this.BlackTeam[this.playerId] == this.PickOrder["playerID2"] ) {
				var curIndex = GetIndex(heroes, this.picked[this.playerId]);
				this.PlayersBlackPanel.FindChild(this.playerId).SetHasClass("turn", false);	
				this.PlayersBlackPanel.FindChild(this.playerId).FindChildTraverse("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID2"]] + "_png.vtex')";
				this.PlayersBlackPanel.FindChild(this.playerId).FindChildTraverse("heroNameLabel").text = names[curIndex];
				this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder["playerID2"]] + "_png.vtex')";
			    if (this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] === "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder["playerID2"]] + "_png.vtex')") {
			        this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultselect_png.vtex')";
			    };
			    for (var BlackPlayers in this.BlackTeam) {
				    if (this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").style["background-image"] === "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID2"]] + "_png.vtex')") {
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait_png.vtex')";
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").RemoveClass("greyscale");
					    this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("heroNameLabel").text = "";
				    };
			    };
			    for (var RedPlayers in this.RedTeam) {
					if (this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").style["background-image"] === "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID2"]] + "_png.vtex')") {
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait_png.vtex')";
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").RemoveClass("greyscale");
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("heroNameLabel").text = "";
					};
				};
			} else if (this.RedTeam[this.playerId] == this.PickOrder["playerID2"] ) {
				var curIndex = GetIndex(heroes, this.picked[this.playerId]);
				this.PlayersRedPanel.FindChild(this.playerId).SetHasClass("turn", false);	
				this.PlayersRedPanel.FindChild(this.playerId).FindChildTraverse("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID2"]] + "_png.vtex')";
				this.PlayersRedPanel.FindChild(this.playerId).FindChildTraverse("heroNameLabel").text = names[curIndex];
				this.SelectedHeroPanel.FindChild("Selected3").FindChild("SelectedHero3").style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder["playerID2"]] + "_png.vtex')";
			    if (this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] === "url('file://{images}/custom_game/draft/selection/" + this.picked[this.PickOrder["playerID2"]] + "_png.vtex')") {
			        this.SelectedHeroPanel.FindChild("Selected2").FindChild("SelectedHero2").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultselect_png.vtex')";
			    };
			    for (var BlackPlayers in this.BlackTeam) {
					if (this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").style["background-image"] === "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID2"]] + "_png.vtex')") {
						this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait_png.vtex')";
						this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("portraitBlack").RemoveClass("greyscale");
						this.PlayersBlackPanel.FindChild(BlackPlayers).FindChildTraverse("heroNameLabel").text = "";
					};
			    };
			    for (var RedPlayers in this.RedTeam) {
					if (this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").style["background-image"] === "url('file://{images}/custom_game/draft/" + this.picked[this.PickOrder["playerID2"]] + "_png.vtex')") {
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultportrait_png.vtex')";
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("portraitRed").RemoveClass("greyscale");
					    this.PlayersRedPanel.FindChild(RedPlayers).FindChildTraverse("heroNameLabel").text = "";
					};
				};
	    	};
    	};
	};

	if (this.time <= 11 && this.time >= 0 && this.GamePhrase["gamephrase"] == "strategy" ) {
		//$.Msg('strategy phrase')
		if (Players.IsSpectator(this.playerId)) {
    		
    	} else {
    		//$.Msg('strategy phrase 1')
    		//$.Msg(this.picked[this.playerId])
            if (this.SkinSelect[this.picked[this.playerId]] == 0) {
    		    this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.picked[this.playerId] + "_png.vtex')";
    		} else {
                this.SelectedHeroPanel1.FindChild("SelectedHero1").style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.picked[this.playerId] + "_" + this.SkinSelect[this.picked[this.playerId]] + "_png.vtex')";
            }
            this.selectedbarPlayerName1.text = Players.GetPlayerName(this.playerId)
    	};
    }; 

	if (this.time <= 0 && this.GamePhrase["gamephrase"] == "strategy" ) {
		this.End();
        var skin = 0
        if (!!this.SkinSelect[this.picked[this.playerId]]) {
            skin = this.SkinSelect[this.picked[this.playerId]]
            $.Msg('skin =' + skin)
        };
		GameEvents.SendCustomGameEventToServer("draft_hero_summon", {
			playerId: this.playerId,
			//hero: this.picked[RedPlayers],
			skin: skin,
		});
        
		return;
    }
    this.Construct();
    this.Render();
    $.Schedule(0.1, function() {
    	
       	that.Update();
    })
}

DraftSelection.prototype.End = function() {
    CustomNetTables.UnsubscribeNetTableListener(this.timeListener);
    CustomNetTables.UnsubscribeNetTableListener(this.availableListener);
    CustomNetTables.UnsubscribeNetTableListener(this.allListener);
    CustomNetTables.UnsubscribeNetTableListener(this.pickedListener);
    CustomNetTables.UnsubscribeNetTableListener(this.banListener);
    CustomNetTables.UnsubscribeNetTableListener(this.PickOrderListener);
    CustomNetTables.UnsubscribeNetTableListener(this.BanOrderListener);
    CustomNetTables.UnsubscribeNetTableListener(this.TeamQueueListener);
    CustomNetTables.UnsubscribeNetTableListener(this.BlackUnselectedListener);
    CustomNetTables.UnsubscribeNetTableListener(this.RedUnselectedListener);

    this.SelectedHeroPanel.visible = false;
	this.SelectedHeroPanel1.visible = false;
	this.selectedbar.visible = false;
	globalContext.FindChild("DraftSelection").visible = false;
    globalContext.visible = false;
    globalContext.AddClass("Hidden")
}

var draft = new DraftSelection();
draft.Update();
