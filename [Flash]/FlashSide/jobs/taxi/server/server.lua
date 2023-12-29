TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'taxi', 'alerte taxi', true, true)

TriggerEvent('esx_society:registerSociety', 'taxi', 'taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

RegisterServerEvent('Ouvre:taxi')
AddEventHandler('Ouvre:taxi', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
    if xPlayer.job.name == 'taxi' then
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Taxi', '~r~Annonce', 'Le taxi est désormais ~r~Ouvert~s~!', 'CHAR_FLOYD', 8)
        end
    end
end)

RegisterServerEvent('Ferme:taxi')
AddEventHandler('Ferme:taxi', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
    if xPlayer.job.name == 'taxi' then
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Taxi', '~r~Annonce', 'Le taxi est désormais ~r~Fermer~s~!', 'CHAR_FLOYD', 8)
        end
    end
end)


-- Mission 

RegisterNetEvent("taxi:FinishMission")
AddEventHandler("taxi:FinishMission", function(bonus)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name ~= "taxi" then
        TriggerEvent("AC:Violations", 24, "Event: taxi:FinishMission job: "..xPlayer.job.name, source)
        return
    end

    local gain = math.random(70,150) + bonus
    xPlayer.addAccountMoney('bank', gain)

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
        if account ~= nil then
            societyAccount = account
            societyAccount.addMoney(gain * 2)
        end
    end)

    TriggerClientEvent("esx:showNotification", source, "Vous avez terminé votre mission.\nGain: ~r~"..gain.."~s~€\nGain entreprise: ~r~".. tostring(gain * 2) .."~s~€", "CHAR_FLOYD", 5000, "danger")
end)