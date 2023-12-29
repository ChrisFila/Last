
  
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

SocietyCache = {}

function InitSociety()
    MySQL.Async.fetchAll('SELECT * FROM society', {}, function(data)
        for k,v in pairs(data) do
            SocietyCache[v.name] = {}
            SocietyCache[v.name].name = v.name
            SocietyCache[v.name].data = json.decode(v.data)
            SocietyCache[v.name].money = v.money
            SocietyCache[v.name].moneysale = v.moneysale
        end
        InitSaveSocietyCache()
    end)
end

function InitSaveSocietyCache()
    while true do 
        SaveSocietyCache()
        Wait(1*60000)
    end
end

function SaveSocietyCache()
    for k,v in pairs(SocietyCache) do 
        MySQL.Sync.execute("UPDATE society SET data=@data, money=@money, moneysale=@moneysale WHERE name=@name", {
            ["@name"] = k,
            ["@money"] = v.money,
            ["@moneysale"] = v.moneysale,
            ["@data"] = json.encode(v.data)
        })
    end
    print('^4Toutes les sociétes ont été sauvegardé.')
end

function GetItemExisteSociety(society, item)
    for k,v in pairs(SocietyCache[society].data) do 
        if k == item then
            return true
        end
    end
    return false
end

RegisterNetEvent("Core:AddInventoryToSocietyCache")
AddEventHandler("Core:AddInventoryToSocietyCache", function(position, society, item, label, qty)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job

    if xJob.name == society then
        if #(GetEntityCoords(GetPlayerPed(source)) - position) < 8 then
            if xPlayer.getInventoryItem(item).count >= qty then
                local itemExiste = GetItemExisteSociety(society, item)

                if itemExiste then 
                    SocietyCache[society].data[item].count = SocietyCache[society].data[item].count + qty
                    xPlayer.removeInventoryItem(item, qty)
                    TriggerClientEvent("SunriseESX:showNotification", xPlayer.source, "~r~Information~s~\nVous avez déposer ~r~x"..qty.." "..label.."~s~.")
                else
                    SocietyCache[society].data[item] = {}
                    SocietyCache[society].data[item].item = item
                    SocietyCache[society].data[item].label = label
                    SocietyCache[society].data[item].count = qty 
                    xPlayer.removeInventoryItem(item, qty)
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Information~s~\nVous avez déposer ~r~x"..qty.." "..label.."~s~.")
                end
                --local webhook = "https://discord.com/api/webhooks/834787175026655312/f1hhgGxYbJ09rI55KJ-vlpyDJiutvDARz5cpuzkV3m-ve3akp4x_IRCo6QZWjfK_fhC7"
	            --FantasiaLogs(webhook, "Fantasia", "\nJoueur : "..GetPlayerName(source).."\nA deposer "..label.."\nQuantité : "..qty.."\nDans la society : "..society, blue)
            else
                TriggerClientEvent("esx:showNotification", xPlayer.source, "Information\n~r~Vous n'avez pas cette quantité")
            end
        else
            --TriggerEvent('FlashSidelpb_fantadmin:ban', source, source, 'Tricher est interdit (ajout d\'un item dans une societer)', 0)
        end
    else
        --TriggerEvent('FlashSidelpb_fantadmin:ban', source, source, 'Tricher est interdit (ajout d\'un item dans une societer)', 0)
    end
end)

RegisterNetEvent("Core:RemoveInventoryToSocietyCache")
AddEventHandler("Core:RemoveInventoryToSocietyCache", function(position, society, item, label, qty)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job

    if xJob.name == society then
        if #(GetEntityCoords(GetPlayerPed(source)) - position) < 8 then
            local itemExiste = GetItemExisteSociety(society, item)

            if itemExiste then 
                if SocietyCache[society].data[item].count - qty < 0 then
                    SocietyCache[society].data[item] = nil
                    xPlayer.addInventoryItem(item, qty)
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Information~s~\nVous avez pris ~r~x"..qty.." "..label.."~s~.")
                else
                    SocietyCache[society].data[item].count = SocietyCache[society].data[item].count - qty
                    xPlayer.addInventoryItem(item, qty)
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Information~s~\nVous avez pris ~r~x"..qty.." "..label.."~s~.")
                end
                --local webhook = "https://discord.com/api/webhooks/834787175026655312/f1hhgGxYbJ09rI55KJ-vlpyDJiutvDARz5cpuzkV3m-ve3akp4x_IRCo6QZWjfK_fhC7"
	            --FantasiaLogs(webhook, "Fantasia", "\nJoueur : "..GetPlayerName(source).."\nA pris "..label.."\nQuantité : "..qty.."\nDe la society : "..society, red)
            else
                Error(1) 
            end
        else
            --TriggerEvent('FlashSidelpb_fantadmin:ban', source, source, 'Tricher est interdit (remove d\'un item dans une societer)', 0)
        end
    else
        --TriggerEvent('FlashSidelpb_fantadmin:ban', source, source, 'Tricher est interdit (remove d\'un item dans une societer)', 0)
    end
end)

RegisterNetEvent("Core:ActionMoneyToSocietyCache")
AddEventHandler("Core:ActionMoneyToSocietyCache", function(society, action, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job

    if xJob.name == society then
        if action == "deposit" then
            if xPlayer.getAccount('cash').money >= money then
                SocietyCache[society].money = math.floor(SocietyCache[society].money + money)
                xPlayer.removeAccountMoney('cash', money)
                TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Information~s~\nVous avez déposer ~r~"..money.."$~s~ dans votre coffre.")
            else
                TriggerClientEvent("esx:showNotification", xPlayer.source, "Information\n~r~Vous n'avez pas cette quantité")
            end
            --local webhook = "https://discord.com/api/webhooks/834787175026655312/f1hhgGxYbJ09rI55KJ-vlpyDJiutvDARz5cpuzkV3m-ve3akp4x_IRCo6QZWjfK_fhC7"
	        --FantasiaLogs(webhook, "Fantasia", "\nJoueur : "..GetPlayerName(source).."\nA deposer "..money.."$\nDans la society : "..society, green)
        end
        if action == "take" then 
            if SocietyCache[society].money - money < 0 then
                TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Information~s~\n~r~Il n'y a pas cette somme de présente dans le coffre.")
            else
                SocietyCache[society].money = math.floor(SocietyCache[society].money - money)
                xPlayer.addAccountMoney('cash', money)
                TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Information~s~\nVous avez pris ~r~"..money.."$~s~ de votre coffre.")
            end
            --local webhook = "https://discord.com/api/webhooks/834787175026655312/f1hhgGxYbJ09rI55KJ-vlpyDJiutvDARz5cpuzkV3m-ve3akp4x_IRCo6QZWjfK_fhC7"
	        --FantasiaLogs(webhook, "Fantasia", "\nJoueur : "..GetPlayerName(source).."\nA pris "..money.."$\nDe la society : "..society, orange)
        end
    else
        --TriggerEvent('ewenlpb_fantadmin:ban', source, source, 'Tricher est interdit (action d\'argent dans une societer)', 0)
    end
end)

--[[RegisterNetEvent("Core:ActionMoneysaleToSocietyCache")
AddEventHandler("Core:ActionMoneysaleToSocietyCache", function(society, action, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job

    if xJob.name == society then
        if action == "deposit" then
            if xPlayer.getAccount('dirtycash').money >= money then
                SocietyCache[society].moneysale = math.floor(SocietyCache[society].moneysale + money)
                xPlayer.removeAccountMoney('dirtycash', money)
                TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Information~s~\nVous avez déposer ~r~"..money.."$~s~ dans votre coffre.")
            else
                TriggerClientEvent("esx:showNotification", xPlayer.source, "Information\n~r~Vous n'avez pas cette quantité")
            end
            --local webhook = "https://discord.com/api/webhooks/834787175026655312/f1hhgGxYbJ09rI55KJ-vlpyDJiutvDARz5cpuzkV3m-ve3akp4x_IRCo6QZWjfK_fhC7"
	        --FantasiaLogs(webhook, "Fantasia", "\nJoueur : "..GetPlayerName(source).."\nA deposer "..money.."$\nDans la society : "..society, green)
        end
        if action == "take" then 
            if SocietyCache[society].moneysale - money < 0 then
                TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Information~s~\n~r~Il n'y a pas cette somme de présente dans le coffre.")
            else
                SocietyCache[society].moneysale = math.floor(SocietyCache[society].moneysale - money)
                xPlayer.addAccountMoney('dirtycash', money)
                TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Information~s~\nVous avez pris ~r~"..money.."$~s~ de votre coffre.")
            end
            --local webhook = "https://discord.com/api/webhooks/834787175026655312/f1hhgGxYbJ09rI55KJ-vlpyDJiutvDARz5cpuzkV3m-ve3akp4x_IRCo6QZWjfK_fhC7"
	        --FantasiaLogs(webhook, "Fantasia", "\nJoueur : "..GetPlayerName(source).."\nA pris "..money.."$\nDe la society : "..society, orange)
        end
    else
        --TriggerEvent('ewenlpb_fantadmin:ban', source, source, 'Tricher est interdit (action d\'argent dans une societer)', 0)
    end
end)]]

Citizen.CreateThread(function()
    InitSociety()
end)    

ESX.RegisterServerCallback("Core:GetSocietyInfo", function(source, cb, society)
    cb(SocietyCache[society])
end)