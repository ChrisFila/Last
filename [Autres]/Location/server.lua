TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('starsLocation:rentvehicle', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getAccount('bank').money >= price then
		xPlayer.removeAccountMoney('bank', price)
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez payez ~b~' .. price .. '$~s~.')
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent("starsLocation:logs")
AddEventHandler("starsLocation:logs", function(playerName, playerId, veh, plateVeh)
	starsLocationLogs(playerName, playerId, veh, plateVeh)
end)

function starsLocationLogs(playerName, playerId, veh, plateVeh)
    local ids = ExtractIdentifiers(playerId)
	local discordId = string.sub(ids.discord,9,-1)
    local embeds = {
        {
			["title"] = "Location de véhicules",
            ["description"] = "**⮟ Joueur ⮟**\n\n**Pseudo ➜** `".. playerName .."`\n**Id Actuel ➜** `".. playerId .."`\n**License ➜** `".. ids.license .."`\n**Discord ➜** <@".. discordId .."> ( ".. discordId .. " )\n\n**⮟ Véhicule ⮟**\n\n**Véhicule ➜** `".. veh .. "`\n**Plaque ➜** `".. plateVeh .. "`\n\n<t:"..os.time(os.date("*t"))..":f> (<t:"..os.time(os.date("*t"))..":R>)",
            ["type"] = "rich",
            ["color"] = 0x5865F2,
            ["footer"] =  {
                ["text"] = "starsLocation",
				["icon_url"] = "https://i.imgur.com/xmRJmJh.png"
            },
        }
    }
    PerformHttpRequest(Config.LogsWebhook, function(err, text, headers) end, 'POST', json.encode({username = "starsLocation", embeds = embeds}), { ['Content-Type'] = 'application/json' })
end
function ExtractIdentifiers(source)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end
    return identifiers
end
