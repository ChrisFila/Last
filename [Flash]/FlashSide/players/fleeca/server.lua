Fleeca = Fleeca or {}

Fleeca.BanksRobbed = {}

RegisterServerEvent('cFleeca:OpenDoor')
AddEventHandler('cFleeca:OpenDoor', function(getObjdoor, doorpos)
    local _src = source
    TriggerEvent("ratelimit", _src, "cFleeca:OpenDoor")
    TriggerClientEvent("cFleeca:OpenDoor", -1, getObjdoor, doorpos)
end)

RegisterServerEvent('cFleeca:CloseDoor')
AddEventHandler('cFleeca:CloseDoor', function(getObjdoor, doorpos)
    local _src = source
    TriggerEvent("ratelimit", _src, "cFleeca:CloseDoor")
    TriggerClientEvent("cFleeca:CloseDoor", -1, getObjdoor, doorpos)
end)

RegisterServerEvent('cFleeca:SetCooldown')
AddEventHandler('cFleeca:SetCooldown', function(id)
    local _src = source
    TriggerEvent("ratelimit", _src, "cFleeca:SetCooldown")
    Fleeca.BanksRobbed[id]= os.time()
end)

RegisterServerEvent("cFleeca:GetCoolDown")
AddEventHandler("cFleeca:GetCoolDown", function(id)
    local _src = source
    TriggerEvent("ratelimit", _src, "cFleeca:GetCoolDown")
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    if Fleeca.BanksRobbed[id] then 
        if (os.time() - Fleeca.CoolDown) > Fleeca.BanksRobbed[id] then 
            xPlayer.removeInventoryItem("bankcard", 1)
            TriggerClientEvent("cFleeca:BinginDrill", _source)
        else
            xPlayer.showNotification('FlashSide~s~Cette banque à déjà été braquée, veuillez patienter avant de refaire une banque !')
        end
    else
        xPlayer.removeInventoryItem("bankcard", 1)
        TriggerClientEvent("cFleeca:BinginDrill", _source)
    end
end)

local braquage = {}

RegisterServerEvent('cFleeca:GiveMoney')
AddEventHandler('cFleeca:GiveMoney', function(token, money)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if token ~= nil or money ~= nil then 
        DropPlayer(source, 'Désynchronisation avec les braquages de banques')
        return
    end

    if braquage[xPlayer.source].type == 1 then
        local givemoney = math.random(225000, 250000)
        xPlayer.addAccountMoney('dirtycash', givemoney)
        xPlayer.showNotification('FlashSide~s~Félicitation vous avez gagné : ~r~'.. givemoney .. '$')
    else
        DropPlayer(source, 'Désynchronisation avec les braquages de banques')
    end
end)

ESX.RegisterUsableItem("bankcard", function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local Players = ESX.GetPlayers()
	local copsOnDuty = 5

    for i = 1, #Players do
        local xPlayer = ESX.GetPlayerFromId(Players[i])
        if xPlayer.job.name == "police" or xPlayer.job.name == "lssd" then
            copsOnDuty = copsOnDuty + 1
        end
    end

    if copsOnDuty == 1 then 
        TriggerClientEvent("cFleeca:StartDrill", xPlayer.source)
        braquage[xPlayer.source] = {}
        braquage[xPlayer.source].type = 1
    else
        xPlayer.showNotification('FlashSide~s~Il n\'y a pas assez de policier en ville')
    end
end)