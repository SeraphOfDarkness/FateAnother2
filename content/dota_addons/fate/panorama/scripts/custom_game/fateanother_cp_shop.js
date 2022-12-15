
function ToggleShopsPanel(panel){
    var pContext = $.GetContextPanel();
    pShopContainer = pContext.FindChildTraverse("ShopMainContainer");
    pShopContainer.bHidden = !pShopContainer.bHidden;
    pShopContainer.SetHasClass("ShopContainerHidden", pShopContainer.bHidden);

    var pShopBackground = pContext.FindChildTraverse("ShopBackground");

    if(!pShopContainer.bHidden){
        pShopContainer.visible = true;
        panel.Activate();
        Game.EmitSound("ui_generic_button_click");
    }
    else{
        pShopContainer.visible = false;
        Game.EmitSound("ui_settings_slide_out");
    }
};

function UpdateCP(data){
    var currentCP = data.CP;
    var currentSQ = data.SQ;
    var pContext = $.GetContextPanel();
    var currentCPLabel = pContext.FindChildTraverse("ShopCP");
    currentCPLabel.text = currentCP + " CP";
};

function ShopClose(){
    var pContext = $.GetContextPanel();
    pShopContainer = pContext.FindChildTraverse("ShopMainContainer");
    pShopContainer.bHidden = !pShopContainer.bHidden;
    pShopContainer.SetHasClass("ShopContainerHidden", pShopContainer.bHidden);
    pShopContainer.visible = false;
    Game.EmitSound("ui_settings_slide_out");
};

function Tab(sName, url, bSep){
    this.sName = sName;
    this.url = url;
    this.bSep = bSep;
    this.ConstructPanel();
};

Tab.prototype.ConstructPanel = function(){
    var that = this;
    var pContext = $.GetContextPanel();
    pNavBar = pContext.FindChildTraverse("ShopLeftPanel");
    pMain = pContext.FindChildTraverse("ShopRightPanel");

    var activate = function(){ return that.Activate(); };
    var hover = function(){ return that.Hover(); };

    var pNavContainer = $.CreatePanel("Panel", pNavBar, "");
    pNavContainer.SetHasClass("ShopCatButton", true);
    pNavContainer.bHover = false;
    that.pNavContainer = pNavContainer;

    pNavContainer.SetPanelEvent("onmouseactivate", activate);
    pNavContainer.SetPanelEvent("onmouseover", hover);
    pNavContainer.SetPanelEvent("onmouseout", hover);

    var lName = $.CreatePanel("Label", pNavContainer, "");
    lName.SetHasClass("ShopNavBarLabel", true);
    lName.text = that.sName;
    that.lName = lName;

    var pContainer = $.CreatePanel("Panel", pMain, "");
    pContainer.BLoadLayout(that.url, false, false);
    pContainer.SetHasClass("Hidden", true);
    that.pContainer = pContainer;

    if (that.bSep) {
        var lSeperator = $.CreatePanel("Label", pNavBar, "");
        //lSeperator.text = " / ";
        lSeperator.SetHasClass("ShopNavBarLabel", true);
        lSeperator.SetHasClass("ShopNavBarSeperator", true);
    }
};

Tab.prototype.Activate = function(){
    var that = this;
    var pNavContainer = that.pNavContainer;
    var pContext = $.GetContextPanel();
    var cActiveTab = pContext.cActiveTab;

    if (cActiveTab && cActiveTab != that) {
        cActiveTab.pNavContainer.SetHasClass("ShopNavBarActive", false);
        cActiveTab.pNavContainer.SetHasClass("ShopNavBarHover", false);
        cActiveTab.pNavContainer.bHover = false;
        cActiveTab.pContainer.SetHasClass("Hidden", true);
    }

    pNavContainer.bHover = false;
    pNavContainer.SetHasClass("ShopNavBarHover", false);
    pNavContainer.SetHasClass("ShopNavBarActive", true);
    pContext.cActiveTab = that;
    that.pContainer.SetHasClass("Hidden", false);
};

Tab.prototype.Hover = function(){
    var that = this;
    if (that.pNavContainer.bActivated) { return };
    that.pNavContainer.bHover = !that.pNavContainer.bHover;
    that.pNavContainer.SetHasClass("ShopNavBarHover", that.pNavContainer.bHover);
};

(function() {
    GameEvents.Subscribe( "fate_player_cp", UpdateCP);
    var pContext = $.GetContextPanel();
    var bShopButton = pContext.FindChildTraverse("ShopButton");
    var pShopContainer = pContext.FindChildTraverse("ShopMainContainer");
    var pShopBackground = pContext.FindChildTraverse("ShopBackground");
    var pPopup = pShopContainer.FindChildTraverse("PopupContainer");
    pShopContainer.visible = false;
    pShopContainer.bHidden = true;
    pContext.cActiveTab = null;
    pShopBackground.visible = false;
    pPopup.visible = false;

    bShopButton.SetPanelEvent("onmouseover", function(){
        $.DispatchEvent("DOTAShowTextTooltip", bShopButton, "#FA_Shop_Tooltip");
        bShopButton.style.opacity = "1.0";
    });

    bShopButton.SetPanelEvent("onmouseout", function(){
        $.DispatchEvent("DOTAHideTextTooltip", bShopButton);
        bShopButton.style.opacity = "0.5";
    });

    var skin = new Tab("Skin", "file://{resources}/layout/custom_game/fateanother_shop_skin.xml", true);
    //var master = new Tab("Fatepedia", "file://{resources}/layout/custom_game/fateanother_fatepedia.xml", true);
    //var effect = new Tab("About", "file://{resources}/layout/custom_game/fateanother_about.xml", false);

    bShopButton.SetPanelEvent("onactivate", function(){
        ToggleShopsPanel(skin);
    });

    skin.Activate();
    $.Msg('CP Shop Build')
})();