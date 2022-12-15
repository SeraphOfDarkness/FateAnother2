//////////////////////////////////////////////////////////////////////////////
/////////////////// Made by ZeFiRoFT /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

var globalContext = $.GetContextPanel();
//globalContext.visible = false;
//globalContext.FindChildTraverse("container").visible = false;


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
    "Emiya Shirou",
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
	"Random",
    "Ban",
    "Error"
]

var ga = "F" + "a" + 't' + 'e'

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

function CreateContextAbilityPanel(panel, abilityname)
{
	var abilityPanel = $.CreatePanel("Panel", panel, "");
	abilityPanel.SetAttributeString("ability_name", abilityname);
	abilityPanel.BLoadLayout("file://{resources}/layout/custom_game/fateanother_context_ability.xml", false, false );
}

var sopkq = {
	120166692: "120166692",
	919069943: "919069943",
    113435706: "113435706",
    141762471: "141762471",
}

function BindOnPick(panel, hero)
{
	panel.SetPanelEvent(
		"onmouseactivate",
		function() {
			if (!!HS.pickedplayer[HS.playerId] || HS.availableHeroes[hero] === null || !!HS.picked[HS.playerID] || HS.UnavailableHeroes[hero] === null) {
				return;
			};

            if (!!HS.UnavailableHeroes[hero] && HS.PAuthority[HS.playerId] == 0) {
                return;
            };

            //if (HS.time <= 80 && HS.time > 20) {
    			if (hero == "random") {
    				GameEvents.SendCustomGameEventToServer("nselection_hero_random", {
    					playerId: HS.playerId,
    				});
    			} else {
    				GameEvents.SendCustomGameEventToServer("nselection_hero_pick", {
    					playerId: HS.playerId,
    					hero: hero,
    				});
    			};
            //};
		}
	);
}

function BindOnBan(panel, hero)
{
    panel.SetPanelEvent(
        "onmouseactivate",
        function() {
            if (!!HS.BanVotedPlayer[HS.playerId] || !!HS.UnavailableHeroes[hero]) {
                $.Msg('already vote ban')
                return;
            };

            //if (HS.time <= 80 && HS.time > 20) {
                GameEvents.SendCustomGameEventToServer("nselection_hero_ban", {
                    playerId: HS.playerId,
                    hero: hero,
                });
            //};

            HS.selectedbar.visible = false;
            HS.SelectedLeftPanel.visible = false;
            HS.SelectedRightPanel.visible = false;
            //HS.SelectedHero.RemoveClass("greyscale");
            HS.SelectedHeroPanel.FindChildTraverse("SelectedHeroName").visible = false;
            HeroInfo('Delete');
            HS.SelectedHero.style["background-image"] = "url('file://{images}/custom_game/draft/other/defaultselect_png.vtex')";
        }
    );
}

function HeroInfo(hero)
{
    if (hero == 'Delete') {
        HS.basicpanel.RemoveAndDeleteChildren();
        HS.innatepanel.RemoveAndDeleteChildren();
        HS.cpanel.RemoveAndDeleteChildren();
        HS.attpanel.RemoveAndDeleteChildren();
        return;
    };

    if (HS.old_hero == hero) {
        if (HS.picked[HS.playerId]) {
            if (HS.hero_select == false) {
                HS.hero_select = true;
                if (HS.SkinSelect[HS.picked[HS.playerId]] > 0) {
                    HS.SelectedHero.style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_" + HS.SkinSelect[HS.picked[HS.playerId]] + "_png.vtex')";
                    if (HS.SkinTier[HS.picked[HS.playerId]] == 1) {
                        HS.SkinNamePanel.FindChild("SelectedHeroNameLabel").style['color'] = "#82DB56";
                    } else if (HS.SkinTier[HS.picked[HS.playerId]] == 2) {
                        HS.SkinNamePanel.FindChild("SelectedHeroNameLabel").style['color'] = "#83F2F2";
                    } else if (HS.SkinTier[HS.picked[HS.playerId]] == 3) {
                        HS.SkinNamePanel.FindChild("SelectedHeroNameLabel").style['color'] = "#E3C852";
                    };
                };
            };
        }
        return;
    };

    HS.old_hero = hero;
    var curIndex = GetIndex(heroes, hero);
    $.Msg(curIndex);
	HS.SelectedLeftPanel.visible = true;
	HS.SelectedRightPanel.visible = true;
	HS.SelectedHeroPanel.visible = true;
	HS.SelectedHero.style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_png.vtex')";
	
	HS.selectedbarHeroName.text = $.Localize( "#" + hero );
    if (HS.SkinSelect[HS.picked[HS.playerId]] > 0) {
        HS.SelectedHero.style["background-image"] = "url('file://{images}/custom_game/draft/selection/" + hero + "_" + HS.SkinSelect[HS.picked[HS.playerId]] + "_png.vtex')";
        if (HS.SkinTier[HS.picked[HS.playerId]] == 1) {
            HS.SkinNamePanel.FindChild("SelectedHeroNameLabel").style['color'] = "#82DB56";
        } else if (HS.SkinTier[HS.picked[HS.playerId]] == 2) {
            HS.SkinNamePanel.FindChild("SelectedHeroNameLabel").style['color'] = "#83F2F2";
        } else if (HS.SkinTier[HS.picked[HS.playerId]] == 3) {
            HS.SkinNamePanel.FindChild("SelectedHeroNameLabel").style['color'] = "#E3C852";
        };
    };

	if (hero == "random") {
		HS.SelectedLeftPanel.visible = false;
		HS.SelectedRightPanel.visible = false;
		return;
	};
	if (!!!HS.mode['mode'] && HS.wvfu[HS.playerId] !== sopkq[HS.wvfu[HS.playerId]] && (!!!HS.Game["AN"] || !!!HS.Game["AI"] || HS.Game["AI"] !== ga + '/' + vokgTv + "II")) {
		HS.SelectedLeftPanel.visible = false;
		HS.SelectedRightPanel.visible = false;		
		var aidoflPanel = $.CreatePanel("Label", HS.container.FindChildTraverse("BottomBar"), "");
		aidoflPanel.AddClass("Headtext");
		aidoflPanel.style["font-size"] = "50px";
		aidoflPanel.style["color"] = "red";
		aidoflPanel.text = "Pl" + "ease su" + "pport t" + "he o" + "rig" + 'inal a' + 't ' + ga + '/' + vokgTv + "II";
		return;
	};
	HS.basicpanel.RemoveAndDeleteChildren();
	HS.innatepanel.RemoveAndDeleteChildren();
	HS.cpanel.RemoveAndDeleteChildren();
	HS.attpanel.RemoveAndDeleteChildren();

	if (!HS.heroinfo[hero]) {
		HS.SelectedLeftPanel.visible = false;
		HS.SelectedRightPanel.visible = false;
		return;
	};

    $.Msg(hero)

    CreateContextAbilityPanel(HS.basicpanel, GetHeroAbility(hero, 0));
    CreateContextAbilityPanel(HS.basicpanel, GetHeroAbility(hero, 1));
    CreateContextAbilityPanel(HS.basicpanel, GetHeroAbility(hero, 2));
    CreateContextAbilityPanel(HS.basicpanel, GetHeroAbility(hero, 5));
    CreateContextAbilityPanel(HS.innatepanel, GetHeroAbility(hero, 3));
    CreateContextAbilityPanel(HS.innatepanel, GetHeroAbility(hero, 4));
    CreateContextAbilityPanel(HS.cpanel, GetHeroCombo(hero));
    CreateContextAbilityPanel(HS.attpanel, GetHeroAttribute(hero, 0));
    CreateContextAbilityPanel(HS.attpanel, GetHeroAttribute(hero, 1));
    CreateContextAbilityPanel(HS.attpanel, GetHeroAttribute(hero, 2));
    CreateContextAbilityPanel(HS.attpanel, GetHeroAttribute(hero, 3));

	//CreateContextAbilityPanel(HS.basicpanel, HS.heroinfo[hero]["S1"]);
    //CreateContextAbilityPanel(HS.basicpanel, HS.heroinfo[hero]["S2"]);
    //CreateContextAbilityPanel(HS.basicpanel, HS.heroinfo[hero]["S3"]);
    //CreateContextAbilityPanel(HS.basicpanel, HS.heroinfo[hero]["S6"]);
    //CreateContextAbilityPanel(HS.innatepanel, HS.heroinfo[hero]["S4"]);
    //CreateContextAbilityPanel(HS.innatepanel, HS.heroinfo[hero]["S5"]);
    //CreateContextAbilityPanel(HS.cpanel, HS.heroinfo[hero]["C"]);
    //CreateContextAbilityPanel(HS.attpanel, HS.heroinfo[hero]["A1"]);
    //CreateContextAbilityPanel(HS.attpanel, HS.heroinfo[hero]["A2"]);
    //CreateContextAbilityPanel(HS.attpanel, HS.heroinfo[hero]["A3"]);
    //CreateContextAbilityPanel(HS.attpanel, HS.heroinfo[hero]["A4"]);
    if (HS.heroinfo[hero]["A"] == 5) {
    	CreateContextAbilityPanel(HS.attpanel, GetHeroAttribute(hero, 4));
    };

	HS.classn.text = $.Localize( "#" + HS.heroinfo[hero]["Class"] );
	var typetext = "" ;
	var type = HS.heroinfo[hero]["Ty"];
	var typeList = type.split(",");
	for(var n=0 ; n < typeList.length; n++)
	{
		if (n === 0) {
			typetext = typetext + $.Localize( "#" + typeList[n] );
		} else {
			typetext = typetext + ", " + $.Localize( "#" + typeList[n] );
		}
	};
    HS.typen.text = typetext;
    var traittext = $.Localize( "#" + HS.heroinfo[hero]["Sex"] ) ;
    if (HS.heroinfo[hero]["Tr"] !== "" && HS.heroinfo[hero]["Tr"] !== "undefined") {
    	var trait = HS.heroinfo[hero]["Tr"];
    	var traitList = trait.split(",");
    	for(var t=0 ; t < traitList.length; t++)
		{
			traittext = traittext + ", " + $.Localize( "#" + traitList[t] );
		};   	
    };
    HS.traitn.text = traittext;
    HS.hpn.text = HS.heroinfo[hero]["HP"];
    HS.mrn.text = HS.heroinfo[hero]["MR"] + "%";
    HS.strn.text = HS.heroinfo[hero]["STR"];
    HS.agin.text = HS.heroinfo[hero]["AGI"];
    HS.intn.text = HS.heroinfo[hero]["INT"];
    var nptext = "" ;
    var diftext = "";
    for (var i = 0; i < HS.heroinfo[hero]["NP"]; i++) {
    	nptext = nptext + "★"
    };
    if (HS.heroinfo[hero]["NP"] < 5) {
    	for (var j = 0; j < 5 - HS.heroinfo[hero]["NP"]; j++) {
	    	nptext = nptext + "☆"
	    };
    };
    for (var k = 0; k < HS.heroinfo[hero]["DIF"]; k++) {
    	diftext = diftext + "★"
    };
    if (HS.heroinfo[hero]["DIF"] < 5) {
    	for (var l = 0; l < 5 - HS.heroinfo[hero]["DIF"]; l++) {
	    	diftext = diftext + "☆"
	    };
    };
    HS.npn.text = nptext;
    if (HS.heroinfo[hero]["NP"] == 5) {
    	HS.npn.style["color"] = "red";
    } else if (HS.heroinfo[hero]["NP"] == 4) {
    	HS.npn.style["color"] = "orange";
    } else if (HS.heroinfo[hero]["NP"] == 3) {
    	HS.npn.style["color"] = "yellow";
    } else if (HS.heroinfo[hero]["NP"] == 2) {
    	HS.npn.style["color"] = "green";
    } else if (HS.heroinfo[hero]["NP"] == 1) {
    	HS.npn.style["color"] = "white";
    };
    HS.difn.text = diftext ;
    if (HS.heroinfo[hero]["DIF"] == 5) {
    	HS.difn.style["color"] = "red";
    } else if (HS.heroinfo[hero]["DIF"] == 4) {
    	HS.difn.style["color"] = "orange";
    } else if (HS.heroinfo[hero]["DIF"] == 3) {
    	HS.difn.style["color"] = "yellow";
    } else if (HS.heroinfo[hero]["DIF"] == 2) {
    	HS.difn.style["color"] = "green";
    } else if (HS.heroinfo[hero]["DIF"] == 1) {
    	HS.difn.style["color"] = "white";
    };
}


function HeroSelectioN() {
	var that = this;
	this.playerId = Game.GetLocalPlayerID();
	this.container = $.GetContextPanel().FindChild("container");

    this.UIListener = CustomNetTables.SubscribeNetTableListener("draft", function(table, tableKey, data) {
        if (tableKey == "draftmode") {
            $.Msg(data);
            if (!!data["reconnect"] && data["playerId"] == Players.GetLocalPlayer() ) {
                $.Msg('ok?');
                that.mode = data["reconnect"];
            } else {
                $.Msg('mode?');
                that.mode = data["draft"];
            }
            //globalContext.visible = false;
            globalContext.FindChildTraverse("container").visible = false;
        }
    });

	/*this.UIListener = CustomNetTables.SubscribeNetTableListener("nselection", function(table, tableKey, data) {
        if (tableKey == "hs") {
            $.Msg(data);
            if (!!data["reconnect"] && data["playerId"] == Players.GetLocalPlayer() ) {
            	$.Msg('ok?');
            	that.mode = data["reconnect"];
            } else {
            	$.Msg('mode?');
            	that.mode = data["mode"];
            }
        }
    });*/

    this.allListener = CustomNetTables.SubscribeNetTableListener("nselection", function(table, tableKey, data) {
        if (tableKey == "all") {
        	$.Msg(data);
            that.allHeroes = data;
        }
    });

    this.availableListener = CustomNetTables.SubscribeNetTableListener("nselection", function(table, tableKey, data) {
        if (tableKey == "available") {
        	$.Msg(data);
            that.availableHeroes = data;
        }
    });

    this.timeListener = CustomNetTables.SubscribeNetTableListener("nselection", function(table, tableKey, data) {
        if (tableKey == "time") {
        	$.Msg(data);
            that.time = data.time;
        }
    });

    var timeTable = CustomNetTables.GetTableValue("nselection", "time");
    this.chatBoxPanel = $.CreatePanel("Panel", globalContext, "");
    this.chatBoxPanel.AddClass('ChatPosition');
    this.chatBoxPanel.BLoadLayout("file://{resources}/layout/custom_game/fateanother_chat_box.xml", false, false );
    
    this.time = timeTable && timeTable.time;
    this.statusLabel = this.container.FindChildTraverse("status");
    this.timeLabel = this.container.FindChildTraverse("time");
    this.timePanel = this.container.FindChildTraverse("timePanel");
    this.heroesPanel = this.container.FindChildTraverse("heroes");
    this.SelectedHeroPanel = this.container.FindChildTraverse("Selected1");
    this.SkinNamePanel = this.container.FindChildTraverse("SkinNamePanel");
    this.SelectedHero = this.SelectedHeroPanel.FindChildTraverse("SelectedHero");
    this.selectedbar = this.container.FindChildTraverse("selectedbar");
    this.selectedbartext = this.selectedbar.FindChildTraverse("selectedbartext");
    this.selectedbarHeroName = this.SelectedHeroPanel.FindChildTraverse("SelectedHeroNameLabel");
    this.SelectedLeftPanel = this.container.FindChildTraverse("SelectedLeftPanel");
    this.classn = this.SelectedLeftPanel.FindChildTraverse("classn");
    this.typen = this.SelectedLeftPanel.FindChildTraverse("typen");
    this.traitn = this.SelectedLeftPanel.FindChildTraverse("traitn");
    this.hpn = this.SelectedLeftPanel.FindChildTraverse("hpn");
    this.mrn = this.SelectedLeftPanel.FindChildTraverse("mrn");
    this.strn = this.SelectedLeftPanel.FindChildTraverse("strn");
    this.agin = this.SelectedLeftPanel.FindChildTraverse("agin");
    this.intn = this.SelectedLeftPanel.FindChildTraverse("intn");
    this.npn = this.SelectedLeftPanel.FindChildTraverse("npn");
    this.difn = this.SelectedLeftPanel.FindChildTraverse("difn");
    this.SelectedRightPanel = this.container.FindChildTraverse("SelectedRightPanel");
    this.basicpanel = this.SelectedRightPanel.FindChildTraverse("basicpanel");
    this.innatepanel = this.SelectedRightPanel.FindChildTraverse("innatepanel");
    this.attpanel = this.SelectedRightPanel.FindChildTraverse("attpanel");
    this.cpanel = this.SelectedRightPanel.FindChildTraverse("cpanel");
    this.selectedleft = this.container.FindChildTraverse("SelectedLeft");
    this.selectedright = this.container.FindChildTraverse("SelectedRight");
    //this.SelectedHeroPanel.visible = false;	
	this.SelectedLeftPanel.visible = false;
	this.SelectedRightPanel.visible = false;
	this.selectedbar.visible = false;	
    this.selectedright.visible = false;   
    this.selectedleft.visible = false;  
    this.SkinNamePanel.visible = false;
    this.old_hero = null;
    this.hero_select = false;
    this.old_skin = null;
    this.delete_left_right = null;
    this.summon_signal = null;
}

var vokgTv = "An" + "o" + 'th' + 'er '

HeroSelectioN.prototype.Construct = function() {
	//$.Msg('draft start construct');
    var that = this;

    var hero = Players.GetPlayerHeroEntityIndex(this.playerId);
    var name = Entities.GetUnitName(hero);
    var playerHasPicked = !!this.picked[this.playerId];
    var time_ban = 100; 

    if (this.Ban.ban == false) {
        time_ban = 80;
    };

    for (var heroName in this.allHeroes) {
        var heroPanel = this.heroesPanel.FindChild(heroName);
        if (heroPanel == null) {
            heroPanel = $.CreatePanel("Image", this.heroesPanel, heroName);
            heroPanel.SetImage("s2r://panorama/images/custom_game/draft/" + heroName + "_png.vtex");
            heroPanel.AddClass("hero");
            //this.LinkHeroTooltip(heroPanel, heroName);
            if (this.availableSkins[heroName] > 0) {
                var skin_symb = heroPanel.FindChild('skin');
                if (skin_symb == null) {
                    skin_symb = $.CreatePanel("Image", heroPanel, 'skin');
                    skin_symb.SetImage("s2r://panorama/images/custom_game/skin_available_png.vtex");
                    skin_symb.AddClass("SkinSymb");
                    skin_symb.SetPanelEvent("onmouseover", 
                        function() {
                            $.DispatchEvent('DOTAShowTextTooltip', skin_symb, "#skin_ava");
                        }
                    );
                    skin_symb.SetPanelEvent("onmouseout", function() {
                            $.DispatchEvent('DOTAHideTextTooltip', skin_symb);
                        }
                    );
                };
            };
            if (this.heroinfo[heroName]["DIF"] < 2) {
                var star_symb = heroPanel.FindChild('star');
                if (star_symb == null) {
                    star_symb = $.CreatePanel("Image", heroPanel, 'star');
                    star_symb.SetImage("s2r://panorama/images/custom_game/recomment_star_png.vtex");
                    star_symb.AddClass("RecStar");
                    star_symb.SetPanelEvent("onmouseover", 
                        function() {
                            $.DispatchEvent('DOTAShowTextTooltip', star_symb, "#new_rec");
                        }
                    );
                    star_symb.SetPanelEvent("onmouseout", function() {
                            $.DispatchEvent('DOTAHideTextTooltip', star_symb);
                        }
                    );
                };
            };
        }

        if (this.time > time_ban) {
        	heroPanel.SetHasClass("grayscale", this.time > 80);
        } else if (this.time <= time_ban) { 
            if (!!this.UnavailableHeroes[heroName] && this.PAuthority[this.playerId] > 0) {
                heroPanel.RemoveClass("grayscale");
                heroPanel.SetHasClass("grayscale", false);
            } else if (!!this.BanHero[heroName]) {
                //$.Msg('ban hero ' + heroName)
                heroPanel.RemoveClass("grayscale");
                heroPanel.SetHasClass("redscale", true);
            } else if (!!this.SpecBanPlayer[this.playerId]) {
                //$.Msg('player has ban list')
                if (!!this.SpecBanPlayer[this.playerId][heroName]) {
                    //$.Msg('player has hero ban list ' + heroName)
                    heroPanel.SetHasClass("grayscale", true);
                } else {
                    heroPanel.RemoveClass("grayscale");
                    heroPanel.SetHasClass("grayscale", false);
                };
            } else if (!!this.NewbieBanPlayer[this.playerId]) {
                if (!!this.NewbieBanPlayer[this.playerId][heroName]) {
                    heroPanel.SetHasClass("grayscale", true);
                } else {
                    heroPanel.RemoveClass("grayscale");
                    heroPanel.SetHasClass("grayscale", false);
                };
            } else if (this.availableHeroes[heroName] == null || (!!this.UnavailableHeroes[heroName] && this.PAuthority[this.playerId] == 0)) {
        		heroPanel.SetHasClass("grayscale", true);//!this.availableHeroes[heroName] || !!this.UnavailableHeroes[heroName]);
        	
            } else {
        		heroPanel.RemoveClass("grayscale");
        		heroPanel.SetHasClass("grayscale", false);
        	};
        };

        if (Game.GetScreenWidth() / Game.GetScreenHeight() == 4/3) {
	    	heroPanel.style['ui-scale'] = 80 + "%";
	    } else {
	    	heroPanel.style['ui-scale'] = 100 + "%";
	    };
        this.BindOnActivate(heroPanel, heroName);
    }

    var randomPanel = this.heroesPanel.FindChild("random");
    if (randomPanel == null && this.Start["game"] == "start") {
        randomPanel = $.CreatePanel("Image", this.heroesPanel, "random");
        randomPanel.SetImage("s2r://panorama/images/custom_game/draft/random_png.vtex");
        randomPanel.AddClass("hero");        
    }

    if (randomPanel !== null) {
    	if (this.time > 80) {
        	randomPanel.SetHasClass("grayscale", this.time > 80);
        } else if (this.time <= 80) { 
        	randomPanel.RemoveClass("grayscale");
        	randomPanel.SetHasClass("grayscale", false);
        }; 
    	if (!!!this.picked[this.playerId]) {
    		this.BindOnActivate(randomPanel, "random");
    	};
    	if (Game.GetScreenWidth() / Game.GetScreenHeight() == 4/3) {
	    	randomPanel.style['ui-scale'] = 80 + "%";
	    } else {
	    	randomPanel.style['ui-scale'] = 100 + "%";
	    };
    };
}

HeroSelectioN.prototype.Render = function() {
    var that = this;

    this.timePanel.actuallayoutwidth = this.timePanel.actuallayoutheight;
    if (this.time !== "undefined") {
        if (this.Ban.ban == true) {
        	this.timeLabel.text = (this.time > 100) ? (this.time - 100) : (this.time <= 100 && this.time > 80) ? (this.time - 80) : (this.time <= 80 && this.time > 20) ? (this.time - 20) : (this.time <= 20 && this.time > 10) ? (this.time - 10) : this.time;
        	this.statusLabel.text = (this.time > 100) ? "LOADING" : (this.time <= 100 && this.time > 80) ? "BAN PHASE" : (this.time <= 80 && this.time > 20) ? "PICK PHASE" : (this.time <= 20 && this.time > 10) ? "STRATEGY" : "START IN";
        } else {
            this.timeLabel.text = (this.time > 80) ? (this.time - 80) : (this.time <= 80 && this.time > 20) ? (this.time - 20) : (this.time <= 20 && this.time > 10) ? (this.time - 10) : this.time;
            this.statusLabel.text = (this.time > 80) ? "LOADING" : (this.time <= 80 && this.time > 20) ? "PICK PHASE" : (this.time <= 20 && this.time > 10) ? "STRATEGY" : "START IN";
        }
        if (this.time > 20 && this.time <= 30) {
            this.timeLabel.style["color"] = "red";
        } else {
            this.timeLabel.style["color"] = "#CCCCCC";
        }
    } else if (this.time == "undefined") {
    	this.timeLabel.text = " ";
    	this.statusLabel.text = " ";
    };
}

HeroSelectioN.prototype.BindOnActivate = function(panel, hero) {
    var that = this;
    if (this.playerId == null) {
    	//$.Msg('this.playerId cannot found');
    	this.playerId = Game.GetLocalPlayerID();
    };
    if (Players.IsSpectator(this.playerId)) {
    	//$.Msg('spectator');
        return;
    };

    panel.SetPanelEvent("onmouseactivate",
		function() {
		    //if (HS.time <= 80 && HS.time > 20) {
		    	$.Msg('on click!!!');
				if (HS.pickedplayer[HS.playerId] == HS.playerId || !!HS.picked[HS.playerID]) {
					//$.Msg('bruh!');
					return;
				};
				//$.Msg('can select');
				if (!HS.availableHeroes[hero] || !!HS.UnavailableHeroes[hero]) {
					HS.SelectedHero.SetHasClass("grayscale", true);
				};
				GameEvents.SendCustomGameEventToServer("nselection_hero_changeportrait", {
					playerId: HS.playerId,
					hero: hero,
				});
			//};
		}
	);
}

HeroSelectioN.prototype.SkinChangeRight = function(panel, hero) {
    panel.SetPanelEvent(
        "onmouseactivate",
        function() {
            if (HS.SkinSelect[hero] == "undefined") {
                HS.SkinSelect[hero] = 0;
            };
            if (HS.SkinSelect[hero] >= HS.availableSkins[hero]) {
                GameEvents.SendCustomGameEventToServer("nselection_hero_skin", {
                    playerId: HS.playerId,
                    hero: hero,
                    skin: 0,
                });
            } else {
                GameEvents.SendCustomGameEventToServer("nselection_hero_skin", {
                    playerId: HS.playerId,
                    hero: hero,
                    skin: HS.SkinSelect[hero] + 1,
                });
            }
        }
    );    	
}

HeroSelectioN.prototype.SkinChangeLeft = function(panel, hero) {
    panel.SetPanelEvent(
        "onmouseactivate",
        function() {
            if (HS.SkinSelect[hero] == "undefined") {
                HS.SkinSelect[hero] = 0;
            };
            if (HS.SkinSelect[hero] <= 0) {
                GameEvents.SendCustomGameEventToServer("nselection_hero_skin", {
                    playerId: HS.playerId,
                    hero: hero,
                    skin: HS.availableSkins[hero],
                });
            } else {
                GameEvents.SendCustomGameEventToServer("nselection_hero_skin", {
                    playerId: HS.playerId,
                    hero: hero,
                    skin: HS.SkinSelect[hero] - 1,
                });
            }
        }
    );      
}

HeroSelectioN.prototype.Update = function() {
    var that = this;

    if (Game.GameStateIsAfter( DOTA_GameState.DOTA_GAMERULES_STATE_PRE_GAME)) {
        if (Players.GetPlayerSelectedHero(this.playerId) == 'npc_dota_hero_wisp') {
            GameEvents.SendCustomGameEventToServer("nselection_hero_summon", {
                playerId: this.playerId,
            });
        };
        this.End();
        return;
    };

    /*if (that.mode == "selection" || that.mode > 0) {
    	globalContext.visible = true;
    	globalContext.FindChild("container").visible = true;
    	if (that.mode > 0) {
    		$.Msg('reconnect success!!')
    	}
    };*/

    this.allHeroes = CustomNetTables.GetTableValue("nselection", "all") || {};
    this.availableHeroes = CustomNetTables.GetTableValue("nselection", "available") || {};
    this.UnavailableHeroes = CustomNetTables.GetTableValue("nselection", "unavailable") || {};
    this.availableSkins = CustomNetTables.GetTableValue("nselection", "skin") || {};
    this.SkinAccess = CustomNetTables.GetTableValue("nselection", "skinaccess") || {};
    this.SkinTier = CustomNetTables.GetTableValue("nselection", "skintier") || {};
    this.heroinfo = CustomNetTables.GetTableValue("nhi", "info") || {};
    this.PAuthority = CustomNetTables.GetTableValue("nselection", "authority") || {};
    this.Start = CustomNetTables.GetTableValue("nselection", "panel") || {};
    this.Game = CustomNetTables.GetTableValue("nselection", "game") || {};
    this.mode = CustomNetTables.GetTableValue("nselection", "mode") || {};
    this.picked = CustomNetTables.GetTableValue("nselection", "picked") || {};
    this.wvfu = CustomNetTables.GetTableValue("nselection", "si") || {};
    this.pickedplayer = CustomNetTables.GetTableValue("nselection", "pickedplayer") || {};
    this.SelectedPortrait = CustomNetTables.GetTableValue("nselection", "select_bar") || {};
    this.SkinSelect = CustomNetTables.GetTableValue("nselection", "skinselect") || {};
    this.GamePhrase = CustomNetTables.GetTableValue("nselection", "gamephrase") || {};
    this.SpecBanPlayer = CustomNetTables.GetTableValue("nselection", "specban") || {};
    this.BanVotedPlayer = CustomNetTables.GetTableValue("nselection", "votebanplayer") || {};
    this.BanHero = CustomNetTables.GetTableValue("nselection", "banhero") || {};
    this.NewbieBanPlayer = CustomNetTables.GetTableValue("nselection", "newban") || {};
    this.Ban = CustomNetTables.GetTableValue("nselection", "ban") || {};
    //$.Msg(this.BanVotedPlayer);
    //$.Msg(this.BanHero);
    //$.Msg(this.mode);

    if (this.Ban.ban == true) {
        if (this.time > 100) {
            //this.SelectedHeroPanel.visible = false;
    		this.selectedbar.visible = false;
        } else if (this.time > 80 && this.time <= 100) {
            this.selectedbartext.text = $.Localize("#ban_button");
            if (this.BanVotedPlayer[this.playerId] == this.playerId) {
                //$.Msg('fck ban');
                this.selectedbar.visible = false;
                HeroInfo('Delete');
            } else if (!!this.SelectedPortrait[this.playerId] && !!!this.BanVotedPlayer[this.playerId]) {
                //$.Msg('pre ban');
                this.selectedbar.visible = true;
                BindOnBan(this.selectedbar, this.SelectedPortrait[this.playerId]);
                HeroInfo(this.SelectedPortrait[this.playerId]);
            } else {
                this.selectedbar.visible = false;
                HeroInfo('Delete');
            }
        }
    } else {
        if (this.time > 80) {
            this.selectedbar.visible = false;
        };
    };

    if (this.time > 20 && this.time <= 80) {
        this.selectedbartext.text = $.Localize("#pick_button");
    	if (!!this.SelectedPortrait[this.playerId] && !!!this.pickedplayer[this.playerId] && !!!this.picked[this.playerId] && !!!this.BanHero[this.SelectedPortrait[this.playerId]]) {
    		//$.Msg('show detail')
    		HeroInfo(this.SelectedPortrait[this.playerId]);
            if (!!this.SpecBanPlayer[this.playerId]) {
                if (!!this.SpecBanPlayer[this.playerId][this.SelectedPortrait[this.playerId]]) {
                    this.selectedbar.visible = false;
                    this.SelectedHero.RemoveClass("greyscale");
                    this.SelectedHero.SetHasClass("greyscale", true);
                } else {
                    this.selectedbar.visible = true;
                    this.SelectedHero.RemoveClass("greyscale");
                    BindOnPick(this.selectedbar, this.SelectedPortrait[this.playerId]);
                };
            } else if (!!this.NewbieBanPlayer[this.playerId]) {
                //$.Msg('newbie');
                if (!!this.NewbieBanPlayer[this.playerId][this.SelectedPortrait[this.playerId]]) {
                    //$.Msg('newbie hero ban');
                    this.selectedbar.visible = false;
                    this.SelectedHero.RemoveClass("greyscale");
                    this.SelectedHero.SetHasClass("greyscale", true);
                } else {
                    this.selectedbar.visible = true;
                    this.SelectedHero.RemoveClass("greyscale");
                    BindOnPick(this.selectedbar, this.SelectedPortrait[this.playerId]);
                };
    		} else if (!!!this.availableHeroes[this.SelectedPortrait[this.playerId]] || !!this.UnavailableHeroes[this.SelectedPortrait[this.playerId]]) {
    			//$.Msg('alr pick')
                if (this.SelectedPortrait[this.playerId] == "random") {
                    this.selectedbar.visible = true;
                    this.SelectedHero.RemoveClass("greyscale");
                    BindOnPick(this.selectedbar, this.SelectedPortrait[this.playerId]);
                } else {
                    if (this.PAuthority[this.playerId] > 0 && !!this.UnavailableHeroes[this.SelectedPortrait[this.playerId]] && this.UnavailableHeroes[this.SelectedPortrait[this.playerId]] !== null ) {
                        this.selectedbar.visible = true;
                        this.SelectedHero.RemoveClass("greyscale");
                        BindOnPick(this.selectedbar, this.SelectedPortrait[this.playerId]);
                    } else {
            			this.selectedbar.visible = false;
                        this.SelectedHero.RemoveClass("greyscale");
            			this.SelectedHero.SetHasClass("greyscale", true);
                    };
                };
    		} else {
    			//$.Msg('can be select')
    			this.selectedbar.visible = true;
    			this.SelectedHero.RemoveClass("greyscale");
    			//this.SelectedHero.SetHasClass("greyscale", false);
    			BindOnPick(this.selectedbar, this.SelectedPortrait[this.playerId]);
    		};   		
    	} else if (!!this.picked[this.playerId]) {
            if (this.picked[this.playerId] == this.SelectedPortrait[this.playerId]) {
                this.SelectedHero.RemoveClass("greyscale");
            } else {
                this.SelectedHero.RemoveClass("greyscale");
                this.SelectedHero.SetHasClass("greyscale", true);
            };
    		//$.Msg('alr select')
    		this.selectedbar.visible = false;
    		HeroInfo(this.picked[this.playerId]);
    	} else if (!!this.BanHero[this.SelectedPortrait[this.playerId]]) {
            //$.Msg('alr select')
            this.selectedbar.visible = false;
            this.SelectedHero.RemoveClass("greyscale");
            this.SelectedHero.SetHasClass("greyscale", true);
            HeroInfo(this.SelectedPortrait[this.playerId]);
        };
    };

    if (this.time > 10 && this.time <= 20) {
        this.SelectedHeroPanel.FindChildTraverse("SelectedHeroName").visible = false;
        this.SelectedHero.RemoveClass("greyscale");
        if (this.delete_left_right === null) {
            HeroInfo('Delete');
            this.delete_left_right = true;
        };

        this.SkinNamePanel.visible = true;

        if (Players.IsSpectator(this.playerId)) {
			
		} else {
            if (this.availableSkins[this.picked[this.playerId]] > 0){
                this.selectedright.visible = true;   
                this.selectedleft.visible = true; 
                this.SkinChangeLeft(this.selectedleft, this.picked[this.playerId])
                this.SkinChangeRight(this.selectedright, this.picked[this.playerId])
            };   
            if (this.SkinSelect[this.picked[this.playerId]] == 0) {
                if (this.old_skin !== this.SkinSelect[this.picked[this.playerId]]) {
                    this.old_skin = this.SkinSelect[this.picked[this.playerId]];
        		    this.SelectedHero.style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.picked[this.playerId] + "_png.vtex')";
        		    //this.SelectedHero.RemoveClass("grayscale");
                    if (!!this.RequirePanel) {
                        this.RequirePanel.visible = false;
                    }
                    this.SkinNamePanel.FindChild("SelectedHeroNameLabel").style['color'] = "white";
                    this.SkinNamePanel.FindChild("SelectedHeroNameLabel").text = $.Localize( "#" + this.picked[this.playerId] );
                };
            } else {
                if (this.old_skin !== this.SkinSelect[this.picked[this.playerId]]) {
                    this.old_skin = this.SkinSelect[this.picked[this.playerId]];
                    this.SelectedHero.style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + this.picked[this.playerId] + "_" + this.SkinSelect[this.picked[this.playerId]] + "_png.vtex')";
                    this.SkinNamePanel.FindChild("SelectedHeroNameLabel").text = $.Localize( "#" + this.picked[this.playerId] + '_' + this.SkinSelect[this.picked[this.playerId]]);
                    if (this.SkinTier[this.picked[this.playerId]] == 1) {
                        this.SkinNamePanel.FindChild("SelectedHeroNameLabel").style['color'] = "#82DB56";
                    } else if (this.SkinTier[this.picked[this.playerId]] == 2) {
                        this.SkinNamePanel.FindChild("SelectedHeroNameLabel").style['color'] = "#83F2F2";
                    } else if (this.SkinTier[this.picked[this.playerId]] == 3) {
                        this.SkinNamePanel.FindChild("SelectedHeroNameLabel").style['color'] = "#E3C852";
                    };
                    if (this.SkinAccess[this.playerId] == false) {
                        if (!this.RequirePanel) {
                            this.RequirePanel = $.CreatePanel("Label", this.container.FindChildTraverse("BottomBar"), "");
                            this.RequirePanel.AddClass("Headtext");
                            this.RequirePanel.AddClass("SelectedLeftPanel");
                            this.RequirePanel.style["font-size"] = "40px";
                            this.RequirePanel.style["color"] = "yellow";
                            this.RequirePanel.text = $.Localize( "#no_authority");
                        }                 
                        this.RequirePanel.visible = true;
                        if (this.PAuthority[this.playerId] == 0) {
                            this.RequirePanel.text = $.Localize( "#no_authority");
                        } else {
                            this.RequirePanel.text = $.Localize( "#not_enuf_authority");
                        }
                    } else if (this.SkinAccess[this.playerId] == true) {
                        if (!!this.RequirePanel) {
                            this.RequirePanel.visible = false;
                        }
                    };
                };
            };  
		};
		this.SelectedHeroPanel.visible = true;
		this.SelectedLeftPanel.visible = false;
		this.SelectedRightPanel.visible = false;
		this.selectedbar.visible = false;
    };

    if (this.time > 1 && this.time <= 10 ) {
    	this.selectedright.visible = false;   
        this.selectedleft.visible = false; 
	};

    if (this.time <= 0) {
        if (Players.GetPlayerSelectedHero(this.playerId) == 'npc_dota_hero_wisp') {
            GameEvents.SendCustomGameEventToServer("nselection_hero_summon", {
                playerId: this.playerId,
            });
        };
        this.End();
        return;
    };

    this.Construct();
    this.Render();

    $.Schedule(0.1, function() {   	
       	that.Update();
    });
}

HeroSelectioN.prototype.End = function() {
    CustomNetTables.UnsubscribeNetTableListener(this.UIListener);
    CustomNetTables.UnsubscribeNetTableListener(this.allListener);
    CustomNetTables.UnsubscribeNetTableListener(this.availableListener);
    CustomNetTables.UnsubscribeNetTableListener(this.timeListener);
    this.SelectedHeroPanel.visible = false;
	this.selectedbar.visible = false;
	globalContext.FindChild("container").visible = false;
    globalContext.visible = false;
    globalContext.AddClass("Hidden");
    this.chatBoxPanel.visible = false;
    this.allHeroes = null;
    this.availableHeroes = null;
    this.UnavailableHeroes = null;
    this.availableSkins = null;
    this.SkinAccess = null;
    this.heroinfo = null;
}

var HS = new HeroSelectioN();
HS.Update();