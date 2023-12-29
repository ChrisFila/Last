TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'vigne', 'alerte vigne', true, true)

TriggerEvent('esx_society:registerSociety', 'vigne', 'vigne', 'society_vigne', 'society_vigne', 'society_vigne', {type = 'public'})

RegisterServerEvent('Ouvre:vigne')
AddEventHandler('Ouvre:vigne', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	if xPlayer.job.name == 'vigne' then
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Vigne', '~r~Annonce', '~r~Les vigne sont ouvert ! Venez achetez votre vin et jus de raisin !', 'CHAR_LEST_MIKE_CONF', 8)
		end
	end
end)

RegisterServerEvent('Ferme:vigne')
AddEventHandler('Ferme:vigne', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	if xPlayer.job.name == 'vigne' then
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Vigne', '~r~Annonce', '~r~Les vignes ferme pour le moment !', 'CHAR_LEST_MIKE_CONF', 8)
		end
	end
end)

RegisterServerEvent('Recru:vigne')
AddEventHandler('Recru:vigne', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	if xPlayer.job.name == 'vigne' then
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Vigne', '~r~Annonce', '~r~Recrutement en cours, rendez-vous au vigne !', 'CHAR_LEST_MIKE_CONF', 8)
		end
	end
end)


ESX.RegisterServerCallback('vigne:playerinventory', function(source, cb)
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

ESX.RegisterServerCallback('vigne:getStockItems', function(source, cb)
	local all_items = {}
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
		for k,v in pairs(inventory.items) do
			if v.count > 0 then
				table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
			end
		end

	end)
	cb(all_items)
end)

RegisterServerEvent('vigne:putStockItems')
AddEventHandler('vigne:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item_in_inventory = xPlayer.getInventoryItem(itemName).count

	if xPlayer.job.name == 'vigne' then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
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

RegisterServerEvent('vigne:takeStockItems')
AddEventHandler('vigne:takeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'vigne' then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
				xPlayer.addInventoryItem(itemName, count)
				inventory.removeItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, "- ~r~Retrait\n~s~- ~r~Item ~s~: "..itemName.."\n~s~- ~o~Quantitée ~s~: "..count.."")
		end)
	end
end)


-- Farm

RegisterNetEvent('recolteraisin')
AddEventHandler('recolteraisin', function()
    local item = "raisin"
    local limiteitem = 50
    local xPlayer = ESX.GetPlayerFromId(source)
    local nbitemdansinventaire = xPlayer.getInventoryItem(item).count

	local coords = GetEntityCoords(GetPlayerPed(source))
	local vigne = vector3(-1803.69, 2214.42, 91.43)
	local ZoneSize = 15.0

	if #(coords - vigne) < ZoneSize / 2 then
		if xPlayer.job.name == 'vigne' then
			if nbitemdansinventaire >= limiteitem then
				TriggerClientEvent('esx:showNotification', source, "Ta pas assez de place dans ton inventaire!")
				recoltepossible = false
			else
				xPlayer.addInventoryItem(item, 1)
				TriggerClientEvent('esx:showNotification', source, "Récolte en cours...")
				return
			end
		end
	else
		DropPlayer(source, 'Va la bas FDP')
	end
end)

RegisterNetEvent('traitementjusraisin')
AddEventHandler('traitementjusraisin', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local raisin = xPlayer.getInventoryItem('raisin').count
    local jus_raisin = xPlayer.getInventoryItem('jus_raisin').count
	local grand_cru = xPlayer.getInventoryItem('grand_cru').count

	local coords = GetEntityCoords(GetPlayerPed(source))
	local vigne = vector3(-51.86, 1911.27, 195.36)
	local ZoneSize = 15.0

	if #(coords - vigne) < ZoneSize / 2 then
		if xPlayer.job.name == 'vigne' then
			if jus_raisin > 250 then
				TriggerClientEvent('esx:showNotification', source, '~r~Il semble que tu ne puisses plus porter de jus de raisin...')
			elseif raisin < 5 then
				TriggerClientEvent('esx:showNotification', source, '~r~Pas assez de jus de raisin pour traiter...')
			else
				xPlayer.removeInventoryItem('raisin', 5)
				xPlayer.addInventoryItem('jus_raisin', 5)
				xPlayer.addInventoryItem('grand_cru', 1)
			end
		end
	else
		DropPlayer(source, 'Va la bas FDP')
	end
end)

RegisterServerEvent('selljusraisin')
AddEventHandler('selljusraisin', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local jus_raisin = 0

	local coords = GetEntityCoords(GetPlayerPed(source))
	local vigne = vector3(359.38, -1109.02, 29.41)
	local ZoneSize = 15.0

	if #(coords - vigne) < ZoneSize / 2 then
		if xPlayer.job.name == 'vigne' then
			for i=1, #xPlayer.inventory, 1 do
				local item = xPlayer.inventory[i]

				if item.name == "jus_raisin" then
					jus_raisin = item.count
				end
			end
			
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
				societyAccount = account
			end)
			
			if jus_raisin > 0 then
				xPlayer.removeInventoryItem('jus_raisin', 1)
				xPlayer.addAccountMoney('cash', 25)
				societyAccount.addMoney(25)
				TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous avez gagner ~r~10$~r~ pour chaque vente d'un jus de raisin")
				TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~La société gagne ~r~10$~r~ pour chaque vente d'un jus de raisin")
			else 
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez plus rien à vendre")
			end
		end
	else
		DropPlayer(source, 'Va la bas FDP')
	end
end)

RegisterServerEvent('sellgrandcru')
AddEventHandler('sellgrandcru', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local grand_cru = 0

	local coords = GetEntityCoords(GetPlayerPed(source))
	local vigne = vector3(359.38, -1109.02, 29.41)
	local ZoneSize = 15.0

	if #(coords - vigne) < ZoneSize / 2 then
		if xPlayer.job.name == 'vigne' then
			for i=1, #xPlayer.inventory, 1 do
				local item = xPlayer.inventory[i]

				if item.name == "grand_cru" then
					grand_cru = item.count
				end
			end
			
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
				societyAccount = account
			end)
			
			if grand_cru > 0 then
				xPlayer.removeInventoryItem('grand_cru', 1)
				xPlayer.addAccountMoney('cash', 30)
				societyAccount.addMoney(30)
				TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous avez gagner ~r~20$~r~ pour chaque vente d'un grand cru")
				TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~La société gagne ~r~20$~r~ pour chaque vente d'un grand cru")
			else 
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez plus rien à vendre")
			end
		end
	else
		DropPlayer(source, 'Va la bas FDP')
	end
end)

