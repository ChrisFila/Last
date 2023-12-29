ESX = nil
local Vehicles

local VehiclesInShop = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('fpwn_customs:refreshOwnedVehicle')
AddEventHandler('fpwn_customs:refreshOwnedVehicle', function(vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = vehicleProps.plate
	}, function(result)
		if result[1] then
			local vehicle = json.decode(result[1].vehicle)

			if vehicleProps.model == vehicle.model then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
					['@plate'] = vehicleProps.plate,
					['@vehicle'] = json.encode(vehicleProps)
				})
			else
				print(('fpwn_customs: %s attempted to upgrade vehicle with mismatching vehicle model!'):format(xPlayer.identifier))
			end
		end
	end)
end)

ESX.RegisterServerCallback('fpwn_customs:getVehiclesPrices', function(source, cb)
	if not Vehicles then
		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)

RegisterServerEvent('fpwn_customs:checkVehicle')
AddEventHandler('fpwn_customs:checkVehicle', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	--print("plate: " .. plate)
	for k, v in pairs(VehiclesInShop) do 
		--print("k: " .. k)
		--print("v['plate']: " .. v['plate'])
		if v.plate == plate and _source ~= k then
			--print("found it")
			TriggerClientEvent('fpwn_customs:resetVehicle', source, v)
			VehiclesInShop[xPlayer.identifier] = nil
			break
		end
	end
end)

RegisterServerEvent('fpwn_customs:saveVehicle')
AddEventHandler('fpwn_customs:saveVehicle', function(oldVehProps)
	local xPlayer = ESX.GetPlayerFromId(source)
	--print("oldVehProps['plate']: " .. oldVehProps['plate'])
	if oldVehProps then
		VehiclesInShop[xPlayer.identifier] = oldVehProps
		--print("VehiclesInShop[_source][plate]: " .. VehiclesInShop[_source]['plate'])
	end
end)

function calcFinalPrice(shopCart, shopProfit, shopReduction)
	local shopProfitValue = 0
	local totalCartValue = 0

	for k, v in pairs(shopCart) do
		--print("k: " .. k)
		--print("v['price']: " .. v['price'])
		totalCartValue = totalCartValue + v['price']
	end
	shopCosts = 100 - shopProfit
	shopReductionValue = totalCartValue * (shopReduction / 100)
	totalWithReduction = totalCartValue - shopReductionValue
	shopProfitValue = totalWithReduction * (shopProfit / 100)
	shopCostValue = totalWithReduction * (shopCosts / 100)
	
	return shopCostValue, totalWithReduction
end

RegisterServerEvent('fpwn_customs:finishPurchase')
AddEventHandler('fpwn_customs:finishPurchase', function(society, newVehProps, shopCart, playerId, shopProfit, shopReduction, autoInvoice)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	local isFinished = false

	local shopCostValue, totalWithReduction = calcFinalPrice(shopCart, shopProfit, shopReduction)
	if shopCostValue <= 0 or totalWithReduction <= 0 then
		TriggerClientEvent('fpwn_customs:cantBill', source)
		TriggerClientEvent('fpwn_customs:resetVehicle', source, VehiclesInShop[xPlayer.identifier])
		VehiclesInShop[xPlayer.identifier] = nil
		return
	end

	local societyAccount

	--protecao contra merdices do lado do cliente
	if society ~= 'society_mecano' and society ~= 'society_lscustom' then
		return
	end
	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
		societyAccount = account
	end)

	--if shopCostValue <= societyAccount.money then
		if autoInvoice then
			local playerMoney = xPlayer.getAccount('bank')
			if playerMoney.money >= totalWithReduction and autoInvoice then
				TriggerClientEvent('esx:showNotification', source, _U('success'), _U('purchased'))
				TriggerClientEvent('fpwn_customs:canBill', source, totalWithReduction, playerId)
				societyAccount.addMoney(totalWithReduction - shopCostValue)
				xPlayer.removeAccountMoney('bank', totalWithReduction)

				newVehProps['extras'] = { [1] = 12, [2] = '12' }
				TriggerEvent('fpwn_customs:refreshOwnedVehicle', newVehProps)
				isFinished = true
			end
		else
			local targetMoney = xTarget.getAccount('bank')
			if targetMoney.money >= totalWithReduction and not autoInvoice then
				TriggerClientEvent('esx:showNotification', source, _U('success'), _U('purchased'))
				TriggerClientEvent('esx:showNotification', playerId, _U('success'), _U('purchased'))
				TriggerClientEvent('fpwn_customs:canBill', source, totalWithReduction, playerId)
				societyAccount.addMoney(totalWithReduction - shopCostValue)
				xTarget.removeAccountMoney('bank', totalWithReduction)
				TriggerEvent('fpwn_customs:refreshOwnedVehicle', newVehProps)
				isFinished = true
			else
				TriggerClientEvent('esx:showNotification', source, 'La personne n\'a pas assez d\'argent (Banque)', _U('not_enough_money'))
				isFinished = false
			end
		end
	--else
	--	TriggerClientEvent('esx:showNotification', source, 'Pas assez d\'argent dans la société', _U('not_enough_money'))
	--	isFinished = false
	--end

	if not isFinished then
		TriggerClientEvent('fpwn_customs:cantBill', source)
		TriggerClientEvent('fpwn_customs:resetVehicle', source, VehiclesInShop[xPlayer.identifier])
	end

	if VehiclesInShop[xPlayer.identifier] then VehiclesInShop[xPlayer.identifier] = nil end
end)