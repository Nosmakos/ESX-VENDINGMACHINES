ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("esx_tgo_vendingmachines:buyVendingItem")
AddEventHandler("esx_tgo_vendingmachines:buyVendingItem", function(totalBuyPrice,itemName)
	local xPlayer = ESX.GetPlayerFromId(source)

	local selectedItem = xPlayer.getInventoryItem(itemName)

	if xPlayer.getMoney() >= totalBuyPrice then

		if selectedItem.name == itemName and selectedItem ~= nil and selectedItem.limit ~= -1 and selectedItem.count >= selectedItem.limit then
			TriggerClientEvent('esx:showNotification', xPlayer.source, "You cannot purchase more than the permitted amount.")
		return
		end
		xPlayer.removeMoney(totalBuyPrice)
		xPlayer.addInventoryItem(itemName, 1)

		TriggerClientEvent('esx:showNotification', xPlayer.source, "Successfully bought x1".. selectedItem.label)

	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, "You don't have enough money.")
	end
end)
