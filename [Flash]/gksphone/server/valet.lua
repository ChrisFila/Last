ESX.RegisterServerCallback('gksphone:getCars', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return; end
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE `owner` = @cid and type = @type",{
	    ["@cid"] = xPlayer.identifier,
        ["@type"] = "car"
		},function(result)
		local valcik = {}
		for i=1, #result, 1 do
			table.insert(valcik, {plate = result[i].plate, garage = result[i].garage, props = json.decode(result[i].vehicle), carseller = result[i].carseller}) 
		end
		cb(valcik)
	end)
end)

ESX.RegisterServerCallback('gksphone:checkMoney2', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getAccount('bank').money >= 50 then
		cb(true)
	else
		cb(false)
	end

end)



ESX.RegisterServerCallback('gksphone:loadVehicle', function(source, cb, plate)
	local s = source
	local x = ESX.GetPlayerFromId(s)
	
	
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `plate` = @plate', {['@plate'] = plate}, function(vehicle)

		
		cb(vehicle)
	end)
end)

RegisterServerEvent('gksphone:finish')
AddEventHandler('gksphone:finish', function(plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('gksphone:notifi', _source, {title = 'Vale', message = _U('vale_get'), img= '/html/static/img/icons/vale.png' }) 
	xPlayer.removeAccountMoney('bank', Config.ValePrice)

	MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
		["@type"] = 1,
		["@identifier"] = xPlayer.identifier,
		["@price"] = Config.ValePrice,
		["@name"] = _U('vale_fee')
	})
end)

--[[RegisterServerEvent('gksphone:valet-car-set-outside')
AddEventHandler('gksphone:valet-car-set-outside', function(plate)
	MySQL.Async.execute('UPDATE owned_vehicles SET `garage` = @garage, `state` = @state WHERE `plate` = @plate', {
		['@plate'] = plate,
		['@state'] = 0,
		['@garage'] = "OUT",
	})
end)]]

