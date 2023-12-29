ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--- UTILISER L'ITEM 
ESX.RegisterUsableItem('lockpick', function(source)
	TriggerClientEvent('KCarjack:startlockpicking', source)
end)

--- FAIL lockpick
RegisterNetEvent('fail_kaitolock')
AddEventHandler('fail_kaitolock', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local lockpick = xPlayer.getInventoryItem('lockpick').count
    xPlayer.removeInventoryItem('lockpick', Config.CombienDeLockPick_Retire)  
end)

--- ALERTE LSPD 
RegisterServerEvent('lockpick_kaitooo')

AddEventHandler('lockpick_kaitooo', function(coords, raison)

	local _source = source

	local _raison = raison

	local xPlayer = ESX.GetPlayerFromId(_source)

	local xPlayers = ESX.GetPlayers()

	local name = xPlayer.getName(_source)



	for i = 1, #xPlayers, 1 do

		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])

		if thePlayer.job.name == 'police' then

			TriggerClientEvent('lockpick_kaitooo:setBlip', xPlayers[i], coords, _raison, name)

		end

	end

end)

--- LOGS 
RegisterServerEvent('logs_crochetage')
AddEventHandler('logs_crochetage', function ()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
	local name = GetPlayerName(source)
	sendToDiscordoff(255, "LockPick", name .. " a crocheté un véhicule")
    end)



    function sendToDiscordoff(color, name, message, footer)
		local embed = {
			  {
				  ["color"] = color,
				  ["title"] = "**".. name .."**",
				  ["description"] = message,
				  ["footer"] = {
					  ["text"] = footer,
				  },
			  }
		  }
		PerformHttpRequest('https://discord.com/api/webhooks/980426758954287114/Auqy61gj3mrtWyYdVTJZz6NqdNo5WleHyx3vphayQ4VzdfvX-KYqPOkHLboxUa1hzDAs', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
	  end