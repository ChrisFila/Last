ClothesPlayer = {}

Citizen.CreateThread(function()
    MySQL.Async.fetchAll("SELECT * FROM clothes_player ", {}, function(result)
        for k, v in pairs(result) do
            if not ClothesPlayer[v.identifier] then 
                ClothesPlayer[v.identifier] = {}
            end
            if not ClothesPlayer[v.identifier][v.id] then
                ClothesPlayer[v.identifier][v.id] = {}
            end 
            ClothesPlayer[v.identifier][v.id].identifier = v.identifier
            ClothesPlayer[v.identifier][v.id].label = v.label 
            ClothesPlayer[v.identifier][v.id].skin = v.skin
            ClothesPlayer[v.identifier][v.id].type = v.type
            ClothesPlayer[v.identifier][v.id].equip = v.equip
            ClothesPlayer[v.identifier][v.id].id = v.id
        end
        print('[^4LOAD^0] [^4'..#result..'^0] Tenues ont été load avec succès')
    end)
end)


RegisterNetEvent("ronflex:addtenueitem", function(label, skin)
    local NumberCount = 0
    local xPlayer = ESX.GetPlayerFromId(source)
    local NumberTenueAutorized = 9999
    if not ClothesPlayer[xPlayer.identifier] then
        NumberCount = 0
    else
        NumberCount = 0
    end

    if NumberCount+1 > NumberTenueAutorized then 
        xPlayer.showNotification('FlashSide~w~ Vous avez déjà trop de tenue.')
    else
        local Account = xPlayer.getAccount('cash').money >= 750 and 'money' or xPlayer.getAccount('bank').money >= 750 and 'bank' or 'nomoney'
        if Account == 'nomoney' then
            xPlayer.showNotification('FlashSide ~w~~n~Vous n\'avez pas assez d\'argent sur vous')
        else
            xPlayer.removeAccountMoney('cash', 750)
            local IdTenue = math.random(11111,99999)
            local IdTenue2 = math.random(11111,99999)
            local ValidateID = IdTenue+IdTenue2

            if not ClothesPlayer[xPlayer.identifier][ValidateID] then
                ClothesPlayer[xPlayer.identifier][ValidateID] = {}
                ClothesPlayer[xPlayer.identifier][ValidateID].identifier = xPlayer.identifier
                ClothesPlayer[xPlayer.identifier][ValidateID].label = label
                ClothesPlayer[xPlayer.identifier][ValidateID].type = "vetement"
                ClothesPlayer[xPlayer.identifier][ValidateID].equip = "n"
                ClothesPlayer[xPlayer.identifier][ValidateID].skin = json.encode(skin)
                ClothesPlayer[xPlayer.identifier][ValidateID].id = ValidateID
            end
            MySQL.Async.execute("INSERT INTO clothes_player (label, skin, type, identifier) VALUES (@label, @skin, @type, @identifier)", {
                ["@label"] = tostring(label),
                ["@skin"] = json.encode(skin),
                ["@type"] = "vetement",
                ["@identifier"] = xPlayer.identifier 
            })
            xPlayer.showNotification('FlashSide~w~ Vous avez crée une tenue (~r~'..label..'~w~)')
            TriggerClientEvent("ronflex:recieveclientsidevetement", xPlayer.source, ClothesPlayer[xPlayer.identifier])
        end
    end
end)

RegisterNetEvent("ronflex:paidaccesoires", function(type, name, skin)
    local xPlayer = ESX.GetPlayerFromId(source)
    local IdTenue = math.random(11111,99999)
    local IdTenue2 = math.random(11111,99999)
    local ValidateID = IdTenue+IdTenue2

    if xPlayer.getAccount('cash').money >= 300 then 
        xPlayer.removeAccountMoney('cash', 300)
        if not ClothesPlayer[xPlayer.identifier][ValidateID] then
            ClothesPlayer[xPlayer.identifier][ValidateID] = {}
            ClothesPlayer[xPlayer.identifier][ValidateID].identifier = xPlayer.identifier
            ClothesPlayer[xPlayer.identifier][ValidateID].label = name
            ClothesPlayer[xPlayer.identifier][ValidateID].type = type
            ClothesPlayer[xPlayer.identifier][ValidateID].skin = json.encode(skin)
            ClothesPlayer[xPlayer.identifier][ValidateID].id = ValidateID
        end
        MySQL.Async.execute("INSERT INTO clothes_player (label, skin, type, identifier) VALUES (@label, @skin, @type, @identifier)", {
            ["@label"] = tostring(name),
            ["@skin"] = json.encode(skin),
            ["@type"] = type,
            ["@identifier"] = xPlayer.identifier 
        })
        
        TriggerClientEvent("ronflex:recieveclientsidevetement", xPlayer.source, ClothesPlayer[xPlayer.identifier])
        xPlayer.showNotification("FlashSide~s~~n~Vous venez d'acheter un "..type.."")
    else
        xPlayer.showNotification("FlashSide~s~~n~Vous n'avez pas les fonds nécéssaires")
    end
end)

RegisterNetEvent('ronflex:donnertenue', function(player, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(player)

    if tPlayer ~= nil then
        if ClothesPlayer[xPlayer.identifier][id] then
            ClothesPlayer[tPlayer.identifier][id] = {}
            ClothesPlayer[tPlayer.identifier][id] = ClothesPlayer[xPlayer.identifier][id]
            ClothesPlayer[xPlayer.identifier][id] = nil
            TriggerClientEvent("ronflex:recieveclientsidevetement", xPlayer.source, ClothesPlayer[xPlayer.identifier])
            TriggerClientEvent("ronflex:recieveclientsidevetement", tPlayer.source, ClothesPlayer[tPlayer.identifier])
            xPlayer.showNotification("FlashSide~s~~n~ Vous avez donné votre tenue ")
            tPlayer.showNotification("FlashSide~s~~n~ Vous avez reçu une tenue ")
            MySQL.Async.execute("UPDATE clothes_player set identifier = @identifier WHERE id = @id", {
                ["@identifier"] = tPlayer.identifier,
                ["@id"] = id
            })
            MySQL.Async.execute("DELETE FROM clothes_player WHERE id = @id and identifier = @identifier", {
                ["@identifier"] = xPlayer.identifier,
                ["@id"] = id
            })
        end
    end
end)

RegisterNetEvent('ewen:RenameTenue', function(id, NewLabel)
    local xPlayer = ESX.GetPlayerFromId(source)
    if ClothesPlayer[xPlayer.identifier][id] then
        if ClothesPlayer[xPlayer.identifier][id].identifier == xPlayer.identifier then
            xPlayer.showNotification('FlashSide~w~ Vous avez renommer votre tenue (~r~'..ClothesPlayer[xPlayer.identifier][id].label..'~w~)')
            ClothesPlayer[xPlayer.identifier][id].label = NewLabel
            TriggerClientEvent("ronflex:recieveclientsidevetement", xPlayer.source, ClothesPlayer[xPlayer.identifier])
            MySQL.Async.execute("UPDATE clothes_player set label = @label WHERE id = @id", {
                ["@label"] = tostring(NewLabel),
                ["@id"] = id
            })
        else
            DropPlayer(source, 'Mhh c\'est chaud c\'que t\'essaie de faire')
        end
    end
end)

RegisterNetEvent('ronflex:deletetenue', function(id, NewLabel)
    local xPlayer = ESX.GetPlayerFromId(source)
    if ClothesPlayer[xPlayer.identifier][id] then
        if ClothesPlayer[xPlayer.identifier][id].identifier == xPlayer.identifier then
            xPlayer.showNotification('FlashSide~w~ Vous avez supprimer votre tenue (~r~'..ClothesPlayer[xPlayer.identifier][id].label..'~w~)')
            ClothesPlayer[xPlayer.identifier][id] = nil
            TriggerClientEvent("ronflex:recieveclientsidevetement", xPlayer.source, ClothesPlayer[xPlayer.identifier])
            MySQL.Async.execute("DELETE FROM clothes_player WHERE id = @id", {
                ["@id"] = id
            })
        else
            DropPlayer(source, 'Mhh c\'est chaud c\'que t\'essaie de faire')
        end
    end
end)

RegisterNetEvent("ronflex:tenuegarderobe", function(typee, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if ClothesPlayer[xPlayer.identifier][id] then
        if ClothesPlayer[xPlayer.identifier][id].identifier == xPlayer.identifier then
            if typee == "equip" then 
                ClothesPlayer[xPlayer.identifier][id].equip = "y"
                xPlayer.showNotification('FlashSide~w~ Vous avez équiper votre tenue (~r~'..ClothesPlayer[xPlayer.identifier][id].label..'~w~)')
                TriggerClientEvent("ronflex:recieveclientsidevetement", xPlayer.source, ClothesPlayer[xPlayer.identifier])
                MySQL.Async.execute("UPDATE clothes_player set equip = @equip WHERE id = @id", {
                    ["@id"] = id,
                    ["@equip"] = tostring("y")
                })
            elseif typee == "deposit" then 
                ClothesPlayer[xPlayer.identifier][id].equip = "n"
                MySQL.Async.execute("UPDATE clothes_player set equip = @equip WHERE id = @id", {
                    ["@id"] = id,
                    ["@equip"] = "n"
                })
                xPlayer.showNotification('FlashSide~w~ Vous avez déposer votre tenue (~r~'..ClothesPlayer[xPlayer.identifier][id].label..'~w~)')
                TriggerClientEvent("ronflex:recieveclientsidevetement", xPlayer.source, ClothesPlayer[xPlayer.identifier])
            end
        else
            DropPlayer(source, 'Mhh c\'est chaud c\'que t\'essaie de faire')
        end
    end
end)

RegisterNetEvent("RecieveVetement", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not ClothesPlayer[xPlayer.identifier] then 
        ClothesPlayer[xPlayer.identifier] = {}
        TriggerClientEvent("ronflex:recieveclientsidevetement", xPlayer.source, nil)
    else
        TriggerClientEvent("ronflex:recieveclientsidevetement", xPlayer.source, ClothesPlayer[xPlayer.identifier])
    end
end)

ESX.RegisterServerCallback("ronflex:cbmoneytenue", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Account = xPlayer.getAccount('cash').money >= 750 and 'money' or xPlayer.getAccount('bank').money >= 750 and 'bank' or 'nomoney'
    if Account == "nomoney" then 
        cb(false)
    else
        cb(true)
        xPlayer.removeAccountMoney('cash', 500)
    end
end)