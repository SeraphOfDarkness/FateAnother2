var globalContext = $.GetContextPanel();
globalContext.chattype = 1;

function GetChatButton()
{
	var ChatButton = globalContext.FindChildTraverse("FateChatButton");
	return ChatButton;
}

function OnChatBoxCreate()
{
	var chatButton = GetChatButton();
	chatButton.style["background-image"] = "url('file://{images}/misc/fate_chatbox.png')";

	var chatButtonOverlay = $.CreatePanel("Panel", chatButton, "FateChatButtonOverlay");
    chatButtonOverlay.style.width = "100%";
    chatButtonOverlay.style.height = "100%";
    chatButtonOverlay.style["background-image"] = "url('file://{images}/misc/chatbox_notify.png')";
    chatButtonOverlay.style.opacity = "0";
    chatButtonOverlay.style.transition = "opacity 0.3s ease-in-out 0.0s";

    var chatPanel = globalContext.FindChildTraverse("FateChatPanel");
    //chatPanel.visible = false;
}

function OnChatButtonPressed()
{
    var chatPanel = globalContext.FindChildTraverse("FateChatPanel");
    if (!chatPanel)
        return;

    chatPanel.visible = !chatPanel.visible;
    var chatButton = GetChatButton();
    var overlay = chatButton.FindChildTraverse("FateChatButtonOverlay");
    overlay.style.opacity = "0.0";
}

function OnChatButtonNotify()
{
	var chatButton = GetChatButton();
	var chatPanel = globalContext.FindChildTraverse("FateChatPanel");
    var overlay = chatButton.FindChildTraverse("FateChatButtonOverlay");
    if (chatPanel.visible == true) {
    	overlay.style.opacity = "0.0";
    } else {
    	overlay.style.opacity = "1.0";
    };
}

function OnDropDownChanged()
{
	var selection = $("#FateChatList").GetSelected();
	globalContext.chattype = parseInt(selection.id);
}

function OnSubmitted()
{
	var text = $("#FateEntry").text;
	$.Msg(text);
	var playerId =Game.GetLocalPlayerID();

	if (text == "" || text == " ") {
		return;
	};

	if (Players.IsSpectator(playerId)) {
        return;
    };

	GameEvents.SendCustomGameEventToServer("fate_chat_send", {
        playerId: playerId,
        text: text,
        type: globalContext.chattype,
    });
    $("#FateEntry").text = " ";
}

function OnChatPanelDisplay(arg)
{
	$.Msg('recieve text');
	var chatPanel = globalContext.FindChildTraverse("FateChatBox");
	
	var text = arg.text;
	var chat_type = arg.chattype;

	var team = null; 
	var text_display = null;

	if (chat_type == 1) {
		team = $.Localize( "#Allies");
	} else if (chat_type == 2) {
		team = $.Localize( "#FAll");
	} else if (chat_type == 0) {
		team = $.Localize( "#System");
	};

	if (chat_type == 0) {
		text_display = '(SYSTEM): ' + $.Localize(text);
	} else {
		//var playerId = arg.playerId;
		//var playerName = Players.GetPlayerName(playerId);
		text_display = '(' + team + ')' + Players.GetPlayerName(arg.playerId) + ': ' + text;
	};

	var popup_line = $.CreatePanel('Panel', chatPanel, '');
	popup_line.hittest = false;
	popup_line.AddClass('textarea');
	var textpopup = $.CreatePanel('Label', popup_line, '');
	textpopup.AddClass('message-text');
	textpopup.text = text_display;

	if (chat_type == 0) {
		textpopup.style["color"] = "yellow";
	};

	chatPanel.ScrollToBottom();
	chatPanel.ScrollToBottom();
}


(function()
{
	OnChatBoxCreate();
	GameEvents.Subscribe( "fate_chat_notify", OnChatButtonNotify);
	GameEvents.Subscribe( "fate_chat_display", OnChatPanelDisplay );

})();

