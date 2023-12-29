ESX = nil 

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterServerEvent("kprigfd:GoFastFini")
AddEventHandler("kprigfd:GoFastFini", function()
    local _src = source 
    local xPlayer = ESX.GetPlayerFromId(_src)

    local randomCash = math.random(Config.MinReward, Config.MaxReward)
    xPlayer.addAccountMoney('black_money', randomCash)
    --xPlayer.addMoney(randomCash)
    TriggerClientEvent('esx:showAdvancedNotification', _src, "GoFast", "~b~Paye", "Ta fais du bon boulot voila ~r~"..randomCash.."$", "CHAR_MP_MEX_BOSS", 3)
end)

RegisterServerEvent("kprigfd:CallPolice")
AddEventHandler("kprigfd:CallPolice", function()
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == "police" then 
            Wait(30000)
            TriggerClientEvent("esx:showAdvancedNotification", xPlayers[i], "LSPD", "~r~Alert", "D'après nos info un GoFast à commencé", "CHAR_JOSEF", 3)
            print("Message envoyer")
        end
    end
end)