TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'gouvernement', 'Gouvernement', 'society_gouvernement', 'society_gouvernement', 'society_gouvernement', {type = 'public'})

RegisterServerEvent('gouv:handcuff')
AddEventHandler('gouv:handcuff', function(target)
  TriggerClientEvent('gouv:handcuff', target)
end)

RegisterServerEvent('gouv:drag')
AddEventHandler('gouv:drag', function(target)
  local _source = source
  TriggerClientEvent('gouv:drag', target, _source)
end)

RegisterServerEvent('gouv:putInVehicle')
AddEventHandler('gouv:putInVehicle', function(target)
  TriggerClientEvent('gouv:putInVehicle', target)
end)

RegisterServerEvent('gouv:OutVehicle')
AddEventHandler('gouv:OutVehicle', function(target)
    TriggerClientEvent('gouv:OutVehicle', target)
end)


--[[RegisterNetEvent('gouv:confiscatePlayerItem')
AddEventHandler('gouv:confiscatePlayerItem', function(target, itemType, itemName, amount)
    local _source = source
    local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

	if xPlayer.job.name == 'gouvernement' then
		if itemType == 'item_standard' then
			local targetItem = targetXPlayer.getInventoryItem(itemName)
			local sourceItem = sourceXPlayer.getInventoryItem(itemName)
			
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem(itemName, amount)
				TriggerClientEvent("esx:showNotification", source, "Vous avez volé ~r~"..amount..' '..sourceItem.label.."~s~.")
				TriggerClientEvent("esx:showNotification", target, "Il t'a été volé ~r~"..amount..' '..sourceItem.label.."~s~.")
			else
				--TriggerClientEvent("esx:showNotification", source, "~r~quantité invalide")
			end
			
		if itemType == 'item_account' then
			targetXPlayer.removeAccountMoney(itemName, amount)
			sourceXPlayer.addAccountMoney   (itemName, amount)
			
			TriggerClientEvent("esx:showNotification", source, "Vous avez volé ~r~"..amount.."€ ~s~Argent sale~s~.")
			TriggerClientEvent("esx:showNotification", target, "Il t'a été volé ~r~"..amount.."€ ~s~Argent sale~s~.")
			
		elseif itemType == 'item_weapon' then
			if amount == nil then amount = 0 end
			targetXPlayer.removeWeapon(itemName, amount)
			sourceXPlayer.addWeapon   (itemName, amount)

			TriggerClientEvent("esx:showNotification", source, "Vous avez volé ~r~"..ESX.GetWeaponLabel(itemName).."~s~ avec ~r~"..amount.."~s~ munitions.")
			TriggerClientEvent("esx:showNotification", target, "Il t'a été volé ~r~"..ESX.GetWeaponLabel(itemName).."~s~ avec ~r~"..amount.."~s~ munitions.")
		end
	end
end)]]


ESX.RegisterServerCallback('gouv:getOtherPlayerData', function(source, cb, target, notify)
    local xPlayer = ESX.GetPlayerFromId(target)

    TriggerClientEvent("esx:showNotification", target, "~r~Tu es fouillé...")

    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
            grade = xPlayer.job.grade_label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
            weapons = xPlayer.getLoadout()
        }

        cb(data)
    end
end)

RegisterServerEvent('Ouvre:gouvernement')
AddEventHandler('Ouvre:gouvernement', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	if xPlayer.job.name == 'gouvernement' then
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Gouvernement', '~r~Annonce', 'Le Gouvernement est désormais ~r~Ouvert~s~!', 'CHAR_ABIGAIL', 8)
		end
	end
end)

RegisterServerEvent('Ferme:gouvernement')
AddEventHandler('Ferme:gouvernement', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	if xPlayer.job.name == 'gouvernement' then
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Gouvernement', '~r~Annonce', 'Le Gouvernement est désormais ~r~Fermer~s~!', 'CHAR_ABIGAIL', 8)
		end
	end
end)

RegisterServerEvent('Recru:gouvernement')
AddEventHandler('Recru:gouvernement', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	if xPlayer.job.name == 'gouvernement' then
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Gouvernement', '~r~Annonce', '~r~Recrutement en cours, rendez-vous au Gouvernement!', 'CHAR_ABIGAIL', 8)
		end
	end
end)

RegisterCommand('gouv', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == "gouvernement" then
        local src = source
        local msg = rawCommand:sub(5)
        local args = msg
        if player ~= false then
            local name = GetPlayerName(source)
            local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Gouvernement', '~r~Annonce', ''..msg..'', 'CHAR_ABIGAIL', 0)
        end
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '~r~Erreur' , '~r~Tu n\'es pas membre de cette entreprise pour faire cette commande', 'CHAR_ABIGAIL', 0)
    end
else
    TriggerClientEvent('esx:showAdvancedNotification', _source, 'Avertisement', '~r~Erreur' , '~r~Tu n\'es pas membre de cette entreprise pour faire cette commande', 'CHAR_ABIGAIL', 0)
end
end, false)

ESX.RegisterServerCallback('gouv:playerinventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory
	local all_items = {}
	
	for k,v in pairs(items) do
		if v.count > 0 then
			table.insert(all_items, {label = v.label, item = v.name,nb = v.count})
		end
	end

	cb(all_items)

	
end)


ESX.RegisterServerCallback('gouv:getStockItems', function(source, cb)
	local all_items = {}
	if xPlayer.job.name == 'gouvernement' then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_gouvernement', function(inventory)
			for k,v in pairs(inventory.items) do
				if v.count > 0 then
					table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
				end
			end

		end)
		cb(all_items)
	end
end)

RegisterServerEvent('gouv:putStockItems')
AddEventHandler('gouv:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item_in_inventory = xPlayer.getInventoryItem(itemName).count

	if xPlayer.job.name == 'gouvernement' then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_gouvernement', function(inventory)
			if item_in_inventory >= count and count > 0 then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, "- ~r~Dépot\n~s~- ~r~Item ~s~: "..itemName.."\n~s~- ~o~Quantitée ~s~: "..count.."")
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous n'en avez pas assez sur vous")
			end
		end)
	end
end)

RegisterServerEvent('gouv:takeStockItems')
AddEventHandler('gouv:takeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'gouvernement' then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_gouvernement', function(inventory)
				xPlayer.addInventoryItem(itemName, count)
				inventory.removeItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, "- ~r~Retrait\n~s~- ~r~Item ~s~: "..itemName.."\n~s~- ~o~Quantitée ~s~: "..count.."")
		end)
	end
end)

RegisterServerEvent('gouv:depositMoney')
AddEventHandler('gouv:depositMoney', function(society, amount)

	local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getMoney()
	local src = source
  
	if xPlayer.job.name == 'gouvernement' then
		TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
		if money >= tonumber(amount) then
			xPlayer.removeAccountMoney('cash', amount)
			account.addMoney(amount)
			TriggerClientEvent("esx:showNotification", src, "- ~o~Déposé \n~s~- ~r~Somme : "..amount.."$")
		else
			TriggerClientEvent("esx:showNotification", src, "- ~r~Erreur \n~s~- ~r~Pas assez d'argent")
		end
		end)
	end
end)


RegisterNetEvent('vestaiaire:déposer')
AddEventHandler('vestaiaire:déposer', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'gouvernement' then
		for k,v in pairs(cfg_gouv.serviceWeapons) do
			xPlayer.removeWeapon(v.Name)
		end
		TriggerClientEvent('esx:showNotification', source, "Vous avez posé tous vos armes")
	end
end)

RegisterNetEvent('vestaiaire:equipement')
AddEventHandler('vestaiaire:equipement', function(item,price)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'gouvernement' then
		for k,v in pairs(cfg_gouv.serviceWeapons) do
			xPlayer.addWeapon(v.Name, cfg_gouv.Nombredeballe)
		--xPlayer.addInventoryItem(v.Name, 1)
		end
	end
end)
