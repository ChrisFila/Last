--[[

  Made with love by Cheleber, you can join my RP Server here: www.grandtheftlusitan.com
  You can add this lines do your esx_rpchat.

--]]

ESX 						   = nil
local Group 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_chatforadmin:GetGroup', function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        Group = player.getGroup()
        if Group ~= nil then 
            cb(Group)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

RegisterCommand('staff', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	Group = xPlayer.getGroup()
	if Group ~= 'user' then
		TriggerClientEvent("sendMessageAdmin", -1, source,  xPlayer.getName(), table.concat(args, " "))
	end	
end, false)

-- Rcon commands
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'setlevel' then
		if (tonumber(args[1]) ~= nil and tonumber(args[1]) >= 0) and (tonumber(args[2]) ~= nil and tonumber(args[2]) >= 0) then
			local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))

			if xPlayer == nil then
				RconPrint("Player not ingame\n")
				CancelEvent()
				return
			end

			TriggerEvent('esx:customDiscordLog', "CONSOLE a modifié le niveau de permission de " .. xPlayer.name .. " [" .. xPlayer.source .. "] (" .. xPlayer.identifier .. ") - Ancien : " .. xPlayer.getLevel() .. " / Nouveau : " .. tostring(args[2]))
			xPlayer.setLevel(tonumber(args[2]))
		else
			RconPrint("Usage: setlevel [user-id] [level]\n")
			CancelEvent()
			return
		end

		CancelEvent()
	elseif commandName == 'setgroup' then
		if (tonumber(args[1]) ~= nil and tonumber(args[1]) >= 0) and (tostring(args[2]) ~= nil) then
			local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))

			if xPlayer == nil then
				RconPrint("Player not ingame\n")
				CancelEvent()
				return
			end

			TriggerEvent('esx:customDiscordLog', "CONSOLE a modifié le groupe de permission de " .. xPlayer.name .. " [" .. xPlayer.source .. "] (" .. xPlayer.identifier .. ") - Ancien : " .. xPlayer.getGroup() .. " / Nouveau : " .. tostring(args[2]))
			xPlayer.setGroup(tostring(args[2]))
		else
			RconPrint("Usage: setgroup [user-id] [group]\n")
			CancelEvent()
			return
		end

		CancelEvent()
	end
end)

-- Announce
ESX.AddGroupCommand('announce', "superadmin", function(source, args, user)
	TriggerClientEvent('chatMessage', -1, "ANNONCE SERVEUR", {255, 0, 0}, table.concat(args, " "))
end, {help = "Annoncer un message à tout le serveur", params = { {name = "announcement", help = "The message to announce"} }})
--kick
ESX.AddGroupCommand('kick', "admin", function(source, args, user)
	if args[1] then
		if GetPlayerName(tonumber(args[1])) then
			local target = tonumber(args[1])
			local reason = args
			table.remove(reason, 1)

            if #reason == 0 then
                reason = "[ 📡 Kick Serveur: Vous avez été exclu du serveur."
            else
                reason = "[ 📡 Kick Serveur : " .. table.concat(reason, " ")
            end

			TriggerClientEvent('chatMessage', source, "SYSTEME", {255, 0, 0}, "Player ^2" .. GetPlayerName(target) .. "^0 a été kick Du Serveur (^2" .. reason .. "^0)")
			DropPlayer(target, reason)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEME", {255, 0, 0}, "Incorrect player ID!")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEME", {255, 0, 0}, "Incorrect player ID!")
	end
end, {help = "Kick a user with the specified reason or no reason", params = { {name = "userid", help = "The ID of the player"}, {name = "reason", help = "The reason as to why you kick this player"} }})
  
---- Parking

ESX.AddGroupCommand('tpc', "admin", function(source, args, user)
	if args[1] then
		if GetPlayerName(tonumber(args[1])) then
			local target = tonumber(args[1])

			TriggerClientEvent('esx:teleport', args[1], vector3(264.14, -749.17, 30.82))
		else
			TriggerClientEvent('chatMessage', source, "SYSTEME", {255, 0, 0}, "Incorrect player ID!")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEME", {255, 0, 0}, "Incorrect player ID!")
	end
end, {help = "POUR TP LE JOUEURS AU PC", params = { {name = "userid", help = "The ID of the player"}}})

