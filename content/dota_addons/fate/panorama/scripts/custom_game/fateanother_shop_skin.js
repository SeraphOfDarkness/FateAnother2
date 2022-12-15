//////////////////////////////////////////////////////////////////////////////
/////////////////// Made by ZeFiRoFT /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

var globalContext = $.GetContextPanel();
//globalContext.visible = false;
//globalContext.FindChildTraverse("SkinShopContainer").visible = false;


function SkinShop() {
	var that = this;
	this.playerId = Game.GetLocalPlayerID();
	this.container = globalContext;
	this.SkinsCard = this.container.FindChildTraverse("SkinShopBot");
	this.heroclass = "all";
	this.sorttype = "default";

	//this.AllSkinListener = CustomNetTables.SubscribeNetTableListener("skinshops", function(table, tableKey, data) {
	//	$.Msg('get nettable data');
    //    if (tableKey == "build") {
     //   	$.Msg('get Skin shop signal');
    //    	this.Construct();
    //    	this.shop_construct = true;
    //    } else if (tableKey == "list") {
    //    	this.allSkins = data;
    //    	$.Msg(this.allSkins);
    //    } else if (tableKey == "cost") {
    //    	this.SkinsCost = data;
    //    	$.Msg(this.SkinsCost);
    //    }
    //});
	this.allSkins = CustomNetTables.GetTableValue("skinshops", "list");
	this.SkinsCost = CustomNetTables.GetTableValue("skinshops", "cost");
	this.UnAvaiSkin = CustomNetTables.GetTableValue("skinshops", "unavai");
	//$.Msg(this.UnAvaiSkin);
	this.Construct();
	GameEvents.Subscribe( "fate_skin_not_own", UpdateData);
	GameEvents.Subscribe( "fate_skin_own", UpdateOwn);
	GameEvents.Subscribe( "fate_player_cp", UpdateCP);
}

function UpdateData(data) {
	SS.NotOwnedSkin = data;
	//$.Msg(SS.NotOwnedSkin);
	var new_sort = SS.RearrangeData();
	//$.Msg(new_sort);
	var i = 0
	for (var SkinID in SS.allSkins) {
		//$.Msg(SkinID);
		var SkinCard = SS.SkinsCard.FindChild(SkinID);
		var bOwn = false;
		if (SS.OwnedSkin[SS.GetSID(new_sort[i])]) {
			//$.Msg(new_sort[i] + ' owned');
			bOwn = true;
		};
		SS.SetSkinCard(SkinCard, SS.GetSID(new_sort[i]), bOwn);
		i = i + 1;
	};
}

function UpdateCP(data) {
	SS.currentCP = data.CP;
	SS.currentSQ = data.SQ;
}

SkinShop.prototype.GetSID = function(skin) {
	for (var SkinID in this.allSkins) {
		if (this.allSkins[SkinID] == skin) {
			return SkinID;
		};
	};
}

function UpdateOwn(data) {
	SS.OwnedSkin = data;
}

SkinShop.prototype.RearrangeData = function() {
	var sort_data = {};
	var i = 0
	if (this.heroclass == "all") {
		for (var SkinID in this.NotOwnedSkin) {
			if (this.UnAvaiSkin[SkinID] !== this.NotOwnedSkin[SkinID]) {
				sort_data[i] = this.NotOwnedSkin[SkinID];
				//sort_data[SkinID] = this.NotOwnedSkin[SkinID];
				i = i + 1;
			};
		};
		for (var SkinID in this.UnAvaiSkin) {
			if (this.OwnedSkin[SkinID] !== this.UnAvaiSkin[SkinID]) {
				//sort_data[SkinID] = this.allSkins[SkinID];
				sort_data[i] = this.UnAvaiSkin[SkinID];
				i = i + 1;
			};
		};
		for (var SkinID in this.OwnedSkin) {
			//if (!sort_data[SkinID]) {
				//sort_data[SkinID] = this.allSkins[SkinID];
				sort_data[i] = this.OwnedSkin[SkinID];
				i = i + 1;
			//};
		};
		return sort_data;
	};
}

SkinShop.prototype.Construct = function() {
	var that = this;
	//$.Msg('start building skin shop');
	this.allSkins = CustomNetTables.GetTableValue("skinshops", "list");
	//$.Msg(this.allSkins);
	this.SkinsCost = CustomNetTables.GetTableValue("skinshops", "cost");
	this.UnAvaiSkin = CustomNetTables.GetTableValue("skinshops", "unavai");
	//$.Msg(this.SkinsCost);
	for (var SkinID in this.allSkins) {
		//$.Msg(SkinID);
		var SkinCard = this.SkinsCard.FindChild(SkinID);
        if (SkinCard == null) {
        	SkinCard = $.CreatePanel("Panel", this.SkinsCard, SkinID);
        	SkinCard.AddClass('SkinMainContainer');
        	var SkinPortrait = $.CreatePanel("Panel", SkinCard, "SkinPortrait");
        	SkinPortrait.AddClass('SkinPortrait');
        	var SkinCostButton = $.CreatePanel("Panel", SkinCard, "SkinCostButton");
        	SkinCostButton.AddClass('SkinCostButton');
        	var SkinCostLabel = $.CreatePanel("Label", SkinCostButton, "SkinCostLabel");
        	SkinCostLabel.AddClass('SkinCostLabel');
        	var SkinDetailPanels = $.CreatePanel("Panel", SkinCard, "SkinDetailPanels");
        	SkinDetailPanels.AddClass('SkinDetailPanels');
        	var SkinDetailName = $.CreatePanel("Panel", SkinDetailPanels, "SkinDetailPanel");
        	SkinDetailName.AddClass('SkinDetailPanel');
        	var SkinDetailTier = $.CreatePanel("Panel", SkinDetailPanels, "SkinDetailPanel");
        	SkinDetailTier.AddClass('SkinDetailPanel');
        	var SkinPortraitNameLabel = $.CreatePanel("Label", SkinDetailName, "SkinPortraitNameLabel");
        	SkinPortraitNameLabel.AddClass('SkinPortraitNameLabel');
        	var SkinPortraitTierLabel = $.CreatePanel("Label", SkinDetailTier, "SkinPortraitNameLabel");
        	SkinPortraitTierLabel.AddClass('SkinPortraitNameLabel');

        	//SkinCard.BLoadLayoutSnippet("SkinInShop");
        	this.SetSkinCard(SkinCard, SkinID);
        };
    };
}

SkinShop.prototype.SetSkinCard = function(panel, skinId, bOwn) {
	var directory = "url('s2r://panorama/images/custom_game/draft/selection/";

	panel.FindChildTraverse("SkinPortrait").style["background-image"] = directory + this.allSkins[skinId] + "_png.vtex')";
	panel.FindChildTraverse("SkinPortraitNameLabel").text =  $.Localize( "#" + this.allSkins[skinId]);
	if ((this.SkinsCost[skinId] !== "limit" && this.UnAvaiSkin[skinId] == null) && (bOwn == null || bOwn == false)) {
		panel.FindChildTraverse("SkinCostLabel").text = this.SkinsCost[skinId];
		panel.FindChildTraverse("SkinCostButton").style["background-color"] = "yellow";
		this.SetSkinCardButton(panel.FindChildTraverse("SkinCostButton"), this.SkinsCost[skinId], skinId);
	} else {
		if (this.SkinsCost[skinId] == "limit" || this.UnAvaiSkin[skinId] !== null) {
			if (bOwn == true) {
				panel.FindChildTraverse("SkinCostLabel").text = $.Localize("#fate_owned");
			} else {
				panel.FindChildTraverse("SkinCostLabel").text = $.Localize("#fate_limit");
			};
		} else {
			panel.FindChildTraverse("SkinCostLabel").text = $.Localize("#fate_owned");
		};
		panel.FindChildTraverse("SkinCostButton").style["background-color"] = "grey";
		panel.FindChildTraverse("SkinCostButton").ClearPanelEvent("onmouseactivate");
	};
}

SkinShop.prototype.SetSkinCardButton = function(panel, cost, skinid) {
	if (Players.IsSpectator(this.playerId)) {
    	//$.Msg('spectator');
        return;
    };

    panel.SetPanelEvent("onmouseactivate",
		function() {
			var popupContainer = SS.GetPopupContainer();
			var directory = "url('s2r://panorama/images/custom_game/draft/selection/";
			if (popupContainer.visible == true) {
				$.Msg('Popup panel already open')
				return
			};
			popupContainer.visible = true; 
			var portrait = popupContainer.FindChildTraverse("PopupSkinPortrait");
			portrait.style["background-image"] = directory + SS.allSkins[skinid] + "_png.vtex')";
			var popupDescribe = popupContainer.FindChildTraverse("PopupDescribeLabel");
			popupDescribe.text = $.Localize("#buy_skin") + " " + $.Localize("#" + SS.allSkins[skinid]);
			var popupCost = popupContainer.FindChildTraverse("PopupCostLabel");
			popupCost.text = cost + " CP";
			var yes_button = popupContainer.FindChildTraverse("PopupButtonYes");
			var no_button = popupContainer.FindChildTraverse("PopupButtonNo");
			no_button["background-color"] = "yellow";
			if (SS.currentCP >= cost) {
				yes_button.style["background-color"] = "yellow";
				popupCost.style["color"] = "white";
				SS.SetSkinCardButtonBuy(yes_button, cost, skinid);
				SS.SetSkinCardButtonCancel(no_button, cost, skinid);
			} else {
				yes_button.style["background-color"] = "grey";
				popupCost.style["color"] = "red";
				yes_button.ClearPanelEvent("onmouseactivate");
				SS.SetSkinCardButtonCancel(no_button, cost, skinid);
			};
		}
	);
}

SkinShop.prototype.SetSkinCardButtonBuy = function(panel, cost, skinid) {

	panel.SetPanelEvent("onmouseactivate",
		function() {
			GameEvents.SendCustomGameEventToServer("skinshop_cpbuy", {
				playerId: SS.playerId,
				skinId: skinid,
				skin: SS.allSkins[skinid],
			});
			var popupContainer = SS.GetPopupContainer();
			popupContainer.visible = false; 
		}
	);
}

SkinShop.prototype.SetSkinCardButtonCancel = function(panel, cost, skinid) {

	panel.SetPanelEvent("onmouseactivate",
		function() {
			var popupContainer = SS.GetPopupContainer();
			popupContainer.visible = false; 
		}
	);
}

SkinShop.prototype.GetPopupContainer = function() {
	var mainContainer = $.GetContextPanel().FindAncestor("ShopMainContainer");
	var popupContainer = mainContainer.FindChildTraverse("PopupContainer");
	return popupContainer;
}

var SS = new SkinShop();
