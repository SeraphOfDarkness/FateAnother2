"use strict";

function DismissMenu()
{
	$.DispatchEvent( "DismissAllContextMenus" )
}

function OnSell()
{
	Items.LocalPlayerSellItem( $.GetContextPanel().Item );
	DismissMenu();
}

function OnDisassemble()
{
	Items.LocalPlayerDisassembleItem( $.GetContextPanel().Item );
	DismissMenu();
}

function OnShowInShop()
{
	var itemName = Abilities.GetAbilityName( $.GetContextPanel().Item );
	
	var itemClickedEvent = {
		"link": ( "dota.item." + itemName ),
		"shop": 0,
		"recipe": 0
	};
	GameEvents.SendEventClientSide( "dota_link_clicked", itemClickedEvent );
	DismissMenu();
}

function OnDropFromStash()
{
	var item = $.GetContextPanel().Item;
	var itemName = Items.GetName(item);

	if(itemName != "item_shard_of_replenishment" && itemName != "item_shard_of_anti_magic"){
		Items.LocalPlayerDropItemFromStash( $.GetContextPanel().Item );
	}
	
	DismissMenu();
}

function OnMoveToStash()
{
	Items.LocalPlayerMoveItemToStash( $.GetContextPanel().Item );
	DismissMenu();
}

function OnAlert()
{
	Items.LocalPlayerItemAlertAllies( $.GetContextPanel().Item );
	DismissMenu();
}
