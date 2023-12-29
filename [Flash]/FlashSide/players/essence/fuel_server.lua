ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("fuel:pay")
AddEventHandler("fuel:pay", function(amount)
    local xPlayer = ESX.GetPlayerFromId(source);
    xPlayer.removeAccountMoney('cash', amount);
    TriggerClientEvent("esx:showNotification", source, "Vous venez de faire un plein pour " .. amount .." €")
end)
