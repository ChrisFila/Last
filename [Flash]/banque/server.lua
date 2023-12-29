ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("depot")--DEPOSER
AddEventHandler("depot", function(money)
	local xPlayer = ESX.GetPlayerFromId(source)
     local total = money
     local xMoney = xPlayer.getAccount('cash').money
	 local xMoneyBank = xPlayer.getAccount('bank').money
	amount = tonumber(amount)

	if xMoney >= total then
		if total <= 0 then
			TriggerClientEvent('esx:showAdvancedNotification', source, 'Le Banquier', '', "Je ne prend pas l'~g~argent~s~ ~r~négatif~s~, désolé !", 'BILLING', 10)
			Tentabug('tentabug', '' .. GetPlayerName(source) .. ' a tenté de glitch avec le depot de banque (chiffre négatif ou 0) Chiffre : ' ..total)
		else
			xPlayer.removeAccountMoney('cash', total)
			xPlayer.addAccountMoney('bank', total)
        	TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque', 'Banque', "Vous avez deposé ~g~"..total.."$~s~ à la banque !", 'BILLING', 10)
			if total >= 1000000 then
				Important('Dépot important', '__Dépot supérieur à 1M__\n' .. GetPlayerName(source) .. ' [' .. source .. '] a déposé '..total..' Dollars\nInfo Joueur : Cash : '..xMoney..' | Banque :'..xMoneyBank)
				TriggerClientEvent('esx:showAdvancedNotification', source, 'Le Banquier un peu vendu', '', "Dis donc.. T'as beaucoup d'~g~argent~s~ toi... on peut s\'~r~arranger~s~ si tu veux...", 'BILLING', 10)
			else
				Depot('LogsBanque', '__Argent déposé__\n' .. GetPlayerName(source) .. ' [' .. source .. '] a déposé '..total..' Dollars\nInfo Joueur : Cash : '..xMoney..' | Banque : '..xMoneyBank)
			end
		end
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez ~r~d\'argent~s~ !")
	end
end)

RegisterServerEvent("retrait")
AddEventHandler("retrait", function(money)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xMoneyBank = xPlayer.getAccount('bank').money
	local xMoney = xPlayer.getAccount('cash').money
	local total = money
	amount = tonumber(amount)

	if xMoneyBank >= total then
		if total <= 0 then
			TriggerClientEvent('esx:showAdvancedNotification', source, 'Le Banquier', '', "Je ne donne pas d'~g~argent~s~ ~r~négatif~s~, désolé !", 'BILLING', 10)
			Tentabug('tentabug', '' .. GetPlayerName(source) .. ' [' .. source .. '] a tenté de glitch avec le retirement dargent banque (chiffre négatif ou 0) Chiffre : ' ..total)
		else
			xPlayer.removeAccountMoney('bank', total)
			xPlayer.addAccountMoney('cash', total)
			TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque', 'Banque', "Vous avez retiré ~g~"..total.."$~s~ de la banque !", 'BILLING', 10)
			if total >= 1000000 then
				Important('Retrait important', '__Retrait supérieur à 1M__\n' .. GetPlayerName(source) .. ' [' .. source .. '] a retiré '..total..' Dollars\nInfo Joueur : Cash : '..xMoney..' | Banque : '..xMoneyBank)
				TriggerClientEvent('esx:showAdvancedNotification', source, 'Le Banquier un peu vendu', '', "Dis donc.. T'as beaucoup d'~g~argent~s~ toi... on peut s\'~r~arranger~s~ si tu veux...", 'BILLING', 10)
			else
				RetireLogs('LogsBanque', '__Argent retiré__\n' .. GetPlayerName(source) .. ' [' .. source .. '] a retiré '..total..' Dollars\nInfo Joueur : Cash : '..xMoney..' | Banque :'..xMoneyBank)
			end
		end
	else
		TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez ~r~d\'argent~s~ !")
	end
end)

RegisterServerEvent('transfer')
AddEventHandler('transfer', function(to, amountt)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer = ESX.GetPlayerFromId(to)
	local balance = 0

	if(zPlayer == nil or zPlayer == -1) then
		TriggerClientEvent('esx:showAdvancedNotification', _source, "Problème", 'Banque', "Ce destinataire n'existe pas.", 'BILLING', 10)
	else
		balance = xPlayer.getAccount('bank').money
		zbalance = zPlayer.getAccount('bank').money
		
		if tonumber(_source) == tonumber(to) then
			TriggerClientEvent('esx:showAdvancedNotification', _source, "Problème", 'Banque', "Vous ne pouvez pas transférer d'argent à vous-même.", 'BILLING', 10)
		else
			if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
				TriggerClientEvent('esx:showAdvancedNotification', _source, 'Banque', "Problème", "Vous n'avez pas assez d'argent en banque.", 'BILLING', 10)
			else
				xPlayer.removeAccountMoney('bank', tonumber(amountt))
				zPlayer.addAccountMoney('bank', tonumber(amountt))
				TriggerClientEvent('esx:showAdvancedNotification', _source, 'Banque', "Succès", "Transfert réussi.")
				TriggerClientEvent('esx:showAdvancedNotification', _source, 'Banque', "Problème", "- " .. amount .." $")
				TriggerClientEvent('esx:showAdvancedNotification', zPlayer, 'Banque', "Succès", "Vous recevez un virement de ".. amountt .." $", 'BILLING', 10)
			end
		end
	end
end)

RegisterServerEvent("bank:solde") 
AddEventHandler("bank:solde", function(action, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getAccount('bank').money
    TriggerClientEvent("solde:argent", source, playerMoney)
end)

function Tentabug (name,message,color)
	local DiscordWebHook = "https://discord.com/api/webhooks/1038110433955041380/8KwhGFEHZMPg0Lp5W5X22qg8vIuPX6n-WviL9ikXBPyVJ8xqZ_3mdDzJeqTZkmIrYetK" -- WEBHOOK POUR LES CLOWN QUI TENTENTS DE METTRE DES CHIFFRES NEGA. (sert pas à grand chose mais voilà)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local embeds = {
		{
			["title"]=message,
			["type"]="rich",
			["color"] ="3447173",
			["footer"]=  {
				["text"]= "Heure: " ..date_local.. "",
			},
		}
	}
	
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 
function Depot (name,message,color)
	local DiscordWebHook = "https://discord.com/api/webhooks/1038110107373940736/W2_VPk3D9KIzWgFwX7nm-SO75nv1t56dP2y41pQDD9gHDCQSqsuRjv3uTtmtELkSZsd1" -- WEBHOOK POUR LES DEPOTS
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local embeds = {
		{
			["title"]=message,
			["type"]="rich",
			["color"] ="64063",
			["footer"]=  {
				["text"]= "Heure: " ..date_local.. "",
			},
		}
	}
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 
function Important (name,message,color)
	local DiscordWebHook = "https://discord.com/api/webhooks/1038110304317476886/cOsx5YBVc9J9SJPQOvM8KFR3JOaFNkiMGcSxF8Ki9G5RZTlUmp-tXLjZMfhDyHrs5t2j" -- WEBHOOK POUR LES DEPOT/RETIR IMPORTANT (+1M)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local embeds = {
		{
			["title"]=message,
			["type"]="rich",
			["color"] ="15206196",
			["footer"]=  {
				["text"]= "Heure: " ..date_local.. "",
			},
		}
	}
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' }) 
end 
function RetireLogs (name,message,color)
	local DiscordWebHook = "https://discord.com/api/webhooks/1038110232137711647/KIw-iFC_gFC98KBZPhR8cVjq6mEBtDMXSn1wJq7E4RoIfE4uale2YMSZRkUe8uwnnqVW" -- WEBHOOK POUR LE RETIRAGE DARGENT
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local embeds = {
		{
			["title"]=message,
			["type"]="rich",
			["color"] ="7674",
			["footer"]=  {
				["text"]= "Heure: " ..date_local.. "",
			},
		}
	}
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 
