TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'sheriff', 'alerte sheriff', true, true)

TriggerEvent('esx_society:registerSociety', 'sheriff', 'sheriff', 'society_sheriff', 'society_sheriff', 'society_sheriff', {type = 'public'})


-- Coffre

ESX.RegisterServerCallback('sheriff:playerinventory', function(source, cb)
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


ESX.RegisterServerCallback('sheriff:getStockItems', function(source, cb)
	local all_items = {}
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)
		for k,v in pairs(inventory.items) do
			if v.count > 0 then
				table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
			end
		end

	end)
	cb(all_items)
end)

RegisterServerEvent('sheriff:putStockItems')
AddEventHandler('sheriff:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item_in_inventory = xPlayer.getInventoryItem(itemName).count

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)
		if item_in_inventory >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "- ~r~Dépot\n~s~- ~r~Item ~s~: "..itemName.."\n~s~- ~o~Quantitée ~s~: "..count.."")
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous n'en avez pas assez sur vous")
		end
	end)
end)

RegisterServerEvent('sheriff:takeStockItems')
AddEventHandler('sheriff:takeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)
			xPlayer.addInventoryItem(itemName, count)
			inventory.removeItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "- ~r~Retrait\n~s~- ~r~Item ~s~: "..itemName.."\n~s~- ~o~Quantitée ~s~: "..count.."")
	end)
end)




-- Boss

RegisterServerEvent('sheriff:withdrawMoney')
AddEventHandler('sheriff:withdrawMoney', function(society, amount, money_soc)
	local xPlayer = ESX.GetPlayerFromId(source)
	local src = source
  
	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
	  if account.money >= tonumber(amount) then
		  xPlayer.addMoney(amount)
		  account.removeMoney(amount)
		  TriggerClientEvent("esx:showNotification", src, "- ~o~Retiré \n~s~- ~r~Somme : "..amount.."$")
	  else
		  TriggerClientEvent("esx:showNotification", src, "- ~r~L'entreprise \n~s~- ~r~Pas assez d'argent")
	  end
	end)
	  
  end)

RegisterServerEvent('sheriff:depositMoney')
AddEventHandler('sheriff:depositMoney', function(society, amount)

	local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getMoney()
	local src = source
  
	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
	  if money >= tonumber(amount) then
		xPlayer.removeAccountMoney('cash', amount)
		  account.addMoney(amount)
		  TriggerClientEvent("esx:showNotification", src, "- ~o~Déposé \n~s~- ~r~Somme : "..amount.."$")
	  else
		  TriggerClientEvent("esx:showNotification", src, "- ~r~Erreur \n~s~- ~r~Pas assez d'argent")
	  end
	end)
	
end)

ESX.RegisterServerCallback('sheriff:getSocietyMoney', function(source, cb, soc)
	local money = nil
		MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @society ', {
			['@society'] = soc,
		}, function(data)
			for _,v in pairs(data) do
				money = v.money
			end
			cb(money)
		end)
end)

--- Prise de service

function sendToDiscordWithSpecialURL(name,message,color,url)
    local DiscordWebHook = url
	local embeds = {
		{
			["title"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "Aurezia sheriff",
			},
		}
	}
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(cfg_sheriffWebhookRendezVoussheriff, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('sheriff:prisedeservice')
AddEventHandler('sheriff:prisedeservice', function()
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	sendToDiscordWithSpecialURL("Prise de service",xPlayer.getName().." à prise son service", 16744192, cfg_sheriffWebhookRendezVoussheriff)
end)

RegisterNetEvent('sheriff:quitteleservice')
AddEventHandler('sheriff:quitteleservice', function()
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	sendToDiscordWithSpecialURL("Fin de service",xPlayer.getName().." à quitter son service", 16744192, cfg_sheriffWebhookRendezVoussheriff)
end)

-- Infos sheriff
RegisterServerEvent('sheriff:PriseEtFinservice')
AddEventHandler('sheriff:PriseEtFinservice', function(PriseOuFin)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'sheriff' then
			TriggerClientEvent('sheriff:InfoService', xPlayers[i], _raison, name)
		end
	end
end)

-- Renfort

RegisterServerEvent('renfort')
AddEventHandler('renfort', function(coords, raison)
	local _source = source
	local _raison = raison
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'sheriff' then
			TriggerClientEvent('renfort:setBlip', xPlayers[i], coords, _raison)
		end
	end
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- FOUILLE ----
-----------------

RegisterNetEvent('sheriff:confiscatePlayerItem')
AddEventHandler('sheriff:confiscatePlayerItem', function(target, itemType, itemName, amount)
    local _source = source
    local sourceXPlayer = ESX.GetPlayerFromId(_source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

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
end)


ESX.RegisterServerCallback('sheriff:getOtherPlayerData', function(source, cb, target, notify)
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

--- Menotter

RegisterServerEvent('sheriff:handcuff')
AddEventHandler('sheriff:handcuff', function(target)
  TriggerClientEvent('sheriff:handcuff', target)
end)

RegisterServerEvent('sheriff:drag')
AddEventHandler('sheriff:drag', function(target)
  local _source = source
  TriggerClientEvent('sheriff:drag', target, _source)
end)

RegisterServerEvent('sheriff:putInVehicle')
AddEventHandler('sheriff:putInVehicle', function(target)
  TriggerClientEvent('sheriff:putInVehicle', target)
end)

RegisterServerEvent('sheriff:OutVehicle')
AddEventHandler('sheriff:OutVehicle', function(target)
    TriggerClientEvent('sheriff:OutVehicle', target)
end)

-- Ppa

RegisterNetEvent('donner:ppa')
AddEventHandler('donner:ppa', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 2500
    local xMoney = xPlayer.getMoney()
	local societyAccount

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_sheriff', function(account)
        societyAccount = account
	end)


            if price < societyAccount.money then

					societyAccount.removeMoney(price)

    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez assez ~r~d\'argent dans votre société")
end
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- FOUILLE ----
-----------------

ESX.RegisterServerCallback('sheriff:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent("esx:showAdvancedNotification", target, "Vous êtes en train de vous faire fouiller.", 5000, "danger")

	if xPlayer then
		local data = {
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}

		cb(data)
	end
end)


ESX.RegisterServerCallback('esx_sheriffjob:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local data = {
			name = GetPlayerName(target),
			job = xPlayer.job,
			job2 = xPlayer.job2,
			inventory = xPlayer.inventory,
			accounts = xPlayer.accounts,
			weapons = xPlayer.loadout,
			firstname = result[1]['firstname'],
			lastname = result[1]['lastname'],
			sex = result[1]['sex'],
			dob = result[1]['dateofbirth'],
			height = result[1]['height']
		}
	
		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			if licenses ~= nil then
				data.licenses = licenses
			end
		end)
	
		cb(data)
	end)
end)


RegisterNetEvent('sheriff:confiscatePlayerItem')
AddEventHandler('sheriff:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		if targetItem.count > 0 and targetItem.count <= amount then

			targetXPlayer.removeInventoryItem(itemName, amount)
			sourceXPlayer.addInventoryItem(itemName, amount)
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney(itemName, amount)

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon(itemName, amount)

	end
	--TriggerEvent('Logger:SendToDiscordIfPossible', 'sheriff-confiscate', false, 0, GetPlayerName(source), itemName, amount, GetPlayerName(target));

end)


-- Plaque

ESX.RegisterServerCallback('sheriff:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT owner, vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname

				retrivedInfo.vehicle = json.decode(result[1].vehicle)

				cb(retrivedInfo)

			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

-- Facture

RegisterNetEvent("sheriff:SendFacture")
AddEventHandler("sheriff:SendFacture", function(target, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_sheriff', function(account)
        if account ~= nil then
			societyAccount = account
			local xPlayer = ESX.GetPlayerFromId(target)
			xPlayer.removeAccountMoney('bank', price)
			societyAccount.addMoney(price)
			TriggerClientEvent("esx:showNotification", target, "Votre compte en banque à été réduit de ~r~"..price.."e~s~.", 5000, "danger")
			TriggerClientEvent("esx:showNotification", source, "Vous avez donné une amende de ~r~"..price.."~s~e", 5000, "danger")
		end
	end)
end)