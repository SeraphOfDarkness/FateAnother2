var globalContext = $.GetContextPanel();

function OnFateEventButtonCreate(data)
{
	$.Msg('recieve data');
	$.Msg(data);
    var eventBar = globalContext.FindChildTraverse("EventsBar")
    eventBar.visible = true;
    var right_margin = 180;
    var button_count = 0;
    var eventButton = eventBar.FindChild(data.EventName + data.EventID);
    if (eventButton == null) {       
    	eventButton = $.CreatePanel("Panel", eventBar, data.EventName + data.EventID);
    	eventButton.AddClass("EventsButton");
    	eventButton.style["background-image"] = "url('file://{images}/custom_game/event/" + data.EventName + ".png')";
        eventButton.style["margin-right"] = right_margin * button_count + "px";
        button_count = button_count + 1;
        eventBar.style["width"] = 200 * button_count + "px";
    	$.Msg('create event button');
    };
	eventButton.SetPanelEvent("onmouseactivate",
    	function() {
            if (data.EventType == 2) {
    	        OnFateEventClick(data);
            } else if (data.EventType == 4) {
                OnFateTourClick(data);
            } else if (data.EventType == 5) {
                OnFateTourClick(data);
            };
    	}
	);
}

function OnFateTourClick(data)
{
    $.Msg('event open');
    var playerId = Game.GetLocalPlayerID();
    if (Players.IsSpectator(playerId)) {
        //$.Msg('spectator');
        return;
    };
    var TourPanel = globalContext.FindChildTraverse("BoardMainContainer");
    TourPanel.AddClass("BoardMainContainer");
    TourPanel.visible = true;
    var TourName = TourPanel.FindChildTraverse("EventNameLabel");
    var EventDate = TourPanel.FindChildTraverse("EventDateLabel");
    var BoardImage = TourPanel.FindChildTraverse("BoardImage");
    var BoardDetail = TourPanel.FindChildTraverse("BoardDetail");
    var TourJoinPanel = TourPanel.FindChildTraverse("TourJoinPanel");

    TourName.text = $.Localize( "#" + data.EventName );
    EventDate.text = data.StartDate + " - " +  data.EndDate;
    BoardImage.style["background-image"] = "url('s2r://panorama/images/custom_game/event/" + data.EventName + ".png')";
    BoardDetail.FindChildTraverse("TourDetailLabel").text = $.Localize( "#" + data.EventDetail );

    // <a href="https://www.w3schools.com/">Visit W3Schools.com!</a>
    if (data.EventName == "waifu_tour") {
        TourJoinPanel.visible = true;
        TourJoinPanel.FindChildInLayoutFile("JoinSolo").FindChildInLayoutFile("EventNameLabel").text = '<a href="https://forms.gle/qz9LBRWJaEzYBgWL9/">Join as Solo</a>';
        TourJoinPanel.FindChildTraverse("JoinTeam").FindChildTraverse("EventNameLabel").text = '<a href="https://forms.gle/hY1xMPrh1j4XU5gh7/">Join as Team</a>';
    } else if (data.EventName == "Xmas") {
        TourJoinPanel.visible = false;
    } else {
        TourJoinPanel.visible = true;
        TourJoinPanel.FindChildTraverse("JoinTeam").visible = false;
        TourJoinPanel.FindChildTraverse("JoinSolo").FindChildInLayoutFile("EventNameLabel").text = "<a href='https://forms.gle/uUXcAcMLxTTJcKKh9'>Guess</a>";
        BoardDetail.style["height"] = "500px";
    };
}

function OnFateTourClose()
{
    var TourPanel = $("#BoardMainContainer");
    TourPanel.visible = false; 
}

function OnFateEventClick(data)
{
	$.Msg('event open');
	var playerId = Game.GetLocalPlayerID();
	if (Players.IsSpectator(playerId)) {
    	//$.Msg('spectator');
        return;
    };
	var EventPanel = globalContext.FindChildTraverse("EventMainContainer");
	EventPanel.AddClass("EventMainContainer");
    EventPanel.visible = true;
    var EventName = EventPanel.FindChildTraverse("EventNameLabel");
    var EventDate = EventPanel.FindChildTraverse("EventDateLabel");
    var SkinPortrait = EventPanel.FindChildTraverse("SkinPortrait");
    var SkinName = EventPanel.FindChildTraverse("SkinPortraitNameLabel");
    var StatusButton = EventPanel.FindChildTraverse("EventPanelStatus");
    var Status = EventPanel.FindChildTraverse("EventPanelStatusLabel");

    EventName.text = $.Localize( "#" + data.EventName );
    EventDate.text = data.StartDate + " - " +  data.EndDate;
    SkinName.text = $.Localize( "#" + data.EventSkin );
    SkinPortrait.style["background-image"] = "url('s2r://panorama/images/custom_game/draft/selection/" + data.EventSkin + "_png.vtex')";
    if (data.Status == true) {
    	Status.text = $.Localize( "#fate_owned");
    } else {
    	Status.text = $.Localize( "#fate_claim");
    	StatusButton.SetPanelEvent("onmouseactivate",
    		function() {
	    		GameEvents.SendCustomGameEventToServer("event_claim", {
                    playerId: playerId,
                    event: data.EventSkin,
                    id: data.EventID,
                });
                Status.text = $.Localize( "#fate_owned");
                StatusButton.ClearPanelEvent("onmouseactivate");
	    	}
	    );
    };
}

function OnFateEventClose()
{
	var EventPanel = $("#EventMainContainer");
	EventPanel.visible = false; 
}

(function()
{
    GameEvents.Subscribe( "fate_event", OnFateEventButtonCreate);
    var pEventBar = globalContext.FindChildTraverse("EventsBar");
	var pEventContainer = globalContext.FindChildTraverse("EventMainContainer");
    var pBoardContainer = globalContext.FindChildTraverse("BoardMainContainer");
    pEventBar.visible = false;
	pEventContainer.visible = false;
    pBoardContainer.visible = false;
	$.Msg('fate panorama regist');
    
})();