ESX = nil

TriggerEvent("esx:getSharedObject", function(obj)
	ESX = obj
end)

RegisterNetEvent("Kayce:AddVehToClient")
AddEventHandler("Kayce:AddVehToClient", function(id, name, plate, type)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xLeJ = ESX.GetPlayerFromId(id)
    local typeByName = {
        ["car"] = "véhicule",
        ["aircraft"] = "avion",
        ["boat"] = "Bateau"
    }
    print(id, name, type)
    if xPlayer.getGroup() == "_dev" then
        if xLeJ ~= nil then
            LiteMySQL:Insert('owned_vehicles', {
                owner = xLeJ.identifier,
                plate = plate,
                vehicle = json.encode({ model = name, plate = plate }),
                type = type,
                state = 1,
            })
            LiteMySQL:Insert('open_car', {
                owner = xLeJ.identifier,
                plate = plate
            });
            xLeJ.showNotification("~r~Félicitation, il semblerait que "..xPlayer.name.." vous est ajouté un "..typeByName[type].." du nom de : "..name)
            xPlayer.showNotification("~r~Vous avez envoyé a "..xLeJ.name..", une "..typeByName[type].." du nom de : "..name)
            webhook("[Administrateur] "..xPlayer.name..": a ajouté le véhicule (model:"..name..",plate:"..plate..",type:"..type..") à ("..xLeJ.name..") !", 15277667)
        else
            xPlayer.showNotification("Une erreur est survenu lors de l'ajout du véhicule (CODE:ID) !")
        end
    else
        DropPlayer(source, 'ntm c Kayce le dev tu crois quoi toi')
    end
end)

RegisterCommand("garage:clearGarage", function(source, args, rawCommand)
    if source == 0 then
        return print("Impossible de faire ceci par le biais de la console !")
    end
    local selectedPlayer = args[1]
    local xPlayer = ESX.GetPlayerFromId(source)
    local xSelected = ESX.GetPlayerFromId(selectedPlayer)
    if (selectedPlayer) then
        if (xSelected) then
            if xPlayer.getGroup() == "_dev" then
                MySQL.Async.execute([[
		            DELETE FROM open_car WHERE owner = @owner;
		            DELETE FROM owned_vehicles WHERE owner = @owner;	]], {
                    ['@owner'] = xSelected.identifier,
                }, function(result)
                    if (result == 0) then
                        xPlayer.showNotification("Une erreur est ~r~survenue~s~ il semblerait que l'utilisateur seléctionné n'est pas ~r~valide~s~ ou ~r~inexistante")
                    else
                        xPlayer.showNotification("Action réussi, tous les véhicule de ~r~"..xSelected.name.."~s~ on été supprimé !")
                        webhook("[Staff] "..xPlayer.name..": a supprimer tout les véhicules du garage de ("..xSelected.name..") !", 15277667)
                    end
                end)
            else
                xPlayer.showNotification("Vous n'avez pas les permissions nécessaire !")
            end
        else
            xPlayer.showNotification("Une erreur est ~r~survenue~s~ il semblerait que l'utilisateur seléctionné n'est pas ~r~valide~s~ ou ~r~inexistante")
        end
    else
        xPlayer.showNotification("Arguments[1] undefined !")
    end
end, false)

RegisterCommand("garage:deleteVehicle", function(source, args, rawCommand)
    if source == 0 then
        return print("Impossible de faire ceci par le biais de la console !")
    end
    local selectedPlate = args[1]
    local xPlayer = ESX.GetPlayerFromId(source)
    local xSelected = ESX.GetPlayerFromId(selectedPlayer)
    if (selectedPlate) then
            if xPlayer.getGroup() == "_dev" then
                    MySQL.Async.execute([[
		                    DELETE FROM open_car WHERE plate = @plate;
		                    DELETE FROM owned_vehicles WHERE plate = @plate;	]], {
                        ['@plate'] = selectedPlate,
                    }, function(result)
                        if (result == 0) then
                            xPlayer.showNotification("Une erreur est ~r~survenue~s~ il semblerait que l'utilisateur seléctionné n'est pas ~r~valide~s~ ou ~r~inexistante")
                        else
                            xPlayer.showNotification("Action réussi, tous le véhicule sous la plaque ~r~"..selectedPlate.."~s~ a été supprimé de l'utilisateur détenteur !")
                            webhook("[Staff] "..xPlayer.name..": a supprimer le véhicule avec la plaque ("..selectedPlate..") du garage de ("..xSelected.name..") !", 15277667)
                        end
                    end)
             else
                 xPlayer.showNotification("Vous n'avez pas les permissions nécessaire !")
            end
    else
        xPlayer.showNotification("Arguments[1] undefined !")
    end
end, false)

function webhook(message, color)
	date_local1 = os.date('%H', os.time())
	local date_local = date_local1 + 2
    local date_lolo = os.date('%M', os.time())
	local DiscordWebHook = ""
    local embeds = {
	    {
          ["title"] = "Garage - by Kayce",
		  ["description"] = "```"..message.."```",
		  ["type"] = "rich",
		  ["color"] = color,
          ["thumbnail"] = {
            ["url"] = "",
          },
		  ["footer"] =  {
			  ["text"] = date_local..":"..date_lolo,
		  },
	    }
    }

	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = "Garage - by Kayce",embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 