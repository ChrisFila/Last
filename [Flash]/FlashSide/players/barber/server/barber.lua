ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("barber:getmoney", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount('cash').money >= 100 then 
        xPlayer.removeAccountMoney('cash', 100)
        cb(true)
    else
        cb(false)
    end
end)