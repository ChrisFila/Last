TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(target, sharedAccountName, label, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(target)
	amount = ESX.Math.Round(amount)

	if xPlayer.getJob().name ~= "unemployed" then
		TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
			if amount < 0 then
				print(('esx_billing: %s attempted to send a negative bill!'):format(xPlayer.identifier))
			elseif account == nil then
				if xTarget ~= nil then
					MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
						['@identifier'] = xTarget.identifier,
						['@sender'] = xPlayer.identifier,
						['@target_type'] = 'player',
						['@target'] = xPlayer.identifier,
						['@label'] = label,
						['@amount'] = amount
					}, function(rowsChanged)
						TriggerClientEvent('esx:showNotification', target, _U('received_invoice'))
						TriggerClientEvent('esx_billing:newBill', target)
					end)
				end
			else
				if xTarget ~= nil then
					MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
						['@identifier'] = xTarget.identifier,
						['@sender'] = xPlayer.identifier,
						['@target_type'] = 'society',
						['@target'] = sharedAccountName,
						['@label'] = label,
						['@amount'] = amount
					}, function(rowsChanged)
						TriggerClientEvent('esx:showNotification', target, _U('received_invoice'))
						TriggerClientEvent('esx_billing:newBill', target)
						sendToDiscord('FlashSide - LOGS', '[FACTURE] ' ..xPlayer.getName().. ' viens de donner une facture à l\'ID : ' ..target.. ' montant : ' ..amount.. '', 3145658)

					end)
				end
			end
		end)
	else
		DropPlayer(source, "Bouffon :)")
	end
end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}

		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				identifier = result[i].identifier,
				sender = result[i].sender,
				targetType = result[i].target_type,
				target = result[i].target,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}

		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				identifier = result[i].identifier,
				sender = result[i].sender,
				targetType = result[i].target_type,
				target = result[i].target,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, id)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE id = @id', {
		['@id'] = id
	}, function(result)
		local sender = result[1].sender
		local targetType = result[1].target_type
		local target = result[1].target
		local amount = result[1].amount
		local xTarget = ESX.GetPlayerFromIdentifier(sender)

		if targetType == 'player' then
			if xTarget ~= nil then
				if xPlayer.getAccount('bank').money >= amount then
					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						xTarget.addAccountMoney('bank', amount)
						TriggerClientEvent('esx:showNotification', source, _U('paid_invoice', ESX.Math.GroupDigits(amount)))
						if xTarget ~= nil then TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_payment', ESX.Math.GroupDigits(amount))) end
						cb()
					end)
				else
					TriggerClientEvent('esx:showNotification', source, _U('no_money'))
					if xTarget ~= nil then TriggerClientEvent('esx:showNotification', xTarget.source, _U('target_no_money')) end
					cb()
				end
			else
				TriggerClientEvent('esx:showNotification', source, _U('player_not_online'))
				cb()
			end
		else
			TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)
				if xPlayer.getAccount('bank').money >= amount then
					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						account.addMoney(amount)
						TriggerClientEvent('esx:showNotification', source, _U('paid_invoice', ESX.Math.GroupDigits(amount)))
						if xTarget ~= nil then TriggerClientEvent('esx:showNotification', xTarget.source, _U('received_payment', ESX.Math.GroupDigits(amount))) end
						cb()
					end)
				else
					TriggerClientEvent('esx:showNotification', source, _U('no_money'))
					if xTarget ~= nil then TriggerClientEvent('esx:showNotification', xTarget.source, _U('target_no_money')) end
					cb()
				end
			end)
		end
	end)
end)

function sendToDiscord (name,message,color)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local DiscordWebHook = "https://discord.com/api/webhooks/861683319305797677/2imhqWy250RXHMlEL_0gCpBhRWEyuvZKEarPq5lpJdRTvkHwwX5oj1SF2f0f8mdQ3hOV"
	-- Modify here your discordWebHook username = name, content = message,embeds = embeds

local embeds = {
	{
		["title"]=message,
		["type"]="rich",
		["color"] =color,
		["footer"]=  {
			["text"]= "Heure: " ..date_local.. "",
		},
	}
}

	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 