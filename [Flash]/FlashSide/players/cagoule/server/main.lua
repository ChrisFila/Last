ESX.RegisterUsableItem('cagoule', function(source)
	TriggerClientEvent('FlashSide:cagoule', source)
end)

RegisterNetEvent('FlashSide:CagouletSet')
AddEventHandler('FlashSide:CagouletSet', function(player)
	if player == -1 then return end
	local xPlayer = ESX.GetPlayerFromId(player)
	local Player = ESX.GetPlayerFromId(source)
	if Player.getInventoryItem('cagoule').count == 0 then 
		DropPlayer(source, 'lol ta cru jsuis un fdp')
	else
		if (xPlayer) then
			if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(player))) > 50 then
				DropPlayer(source, 'lol ta cru jsuis un fdp')
			else
				TriggerClientEvent('FlashSide:CagouleSet', xPlayer.source)
			end
		end
	end
end)

RegisterCommand('cagoule', function(source,args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() ~= 'user' then
		if args[1] == -1 then return end
		if args[1] == '-1' then return end 
		TriggerClientEvent('FlashSide:CagouleSet', args[1])
	end
end)