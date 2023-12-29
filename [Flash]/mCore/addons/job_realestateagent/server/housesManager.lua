--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

FlashSideSHousesManager = {}

FlashSideSHousesManager.instanceRange = 1000
FlashSideSHousesManager.list = {}

local function addHouse(info, needDecode)
    ---@type House
    local house
    if needDecode then
        house = House(info.id, info.owner, json.decode(info.infos), info.ownerInfo, json.decode(info.inventory), info.street)
    else
        house = House(info.id, info.owner, info.infos, info.ownerInfo, info.inventory, info.street)
    end
    house:initMarker()
    house:initBlips()
    FlashSideSHousesManager.list[house.houseId] = house
end

local function loadHouses()
    MySQL.Async.fetchAll("SELECT * FROM alkia_houses", {}, function(houses)
        local tot = 0
        for id, info in pairs(houses) do
            tot = tot + 1
            addHouse(info, true)
        end
        print(FlashSide.prefix(FlashSidePrefixes.house, ("%i maisons importées depuis la db"):format(tot)))
    end)
end

local function createHouse(data, author, street, announce)
    MySQL.Async.insert("INSERT INTO alkia_houses (owner, ownerInfo, infos, inventory, createdAt, createdBy, street) VALUES(@a, @b, @c, @d, @e, @f, @g)", {
        ['a'] = "none",
        ['b'] = "none",
        ['c'] = json.encode(data),
        ['d'] = json.encode({}),
        ['e'] = os.time(),
        ['f'] = FlashSideServerUtils.getLicense(author),
        ['g'] = street
    }, function(insertId)
        addHouse({ id = insertId, owner = "none", infos = data, ownerInfo = "none", inventory = {}, street }, false)
        FlashSideServerUtils.toClient("addAvailableHouse", -1, { id = insertId, coords = data.entry })
        TriggerClientEvent("esx:showNotification", author, "~r~Création de la propriétée effectuée !")
        if announce then FlashSideServerUtils.toAll("advancedNotif", "~r~Agence immobilière", "~r~Nouvelle propriétée", ("Une nouvelle propriétée ~s~(~o~%s~s~) est disponible à ~r~%s ~s~pour la somme de ~r~%s$"):format(FlashSideInteriors[data.selectedInterior].label, street, ESX.Math.GroupDigits(tonumber(data.price))), "CHAR_MINOTAUR", 1) end
    end)
end

FlashSide.netHandle("esxloaded", function()
    loadHouses()
end)

FlashSide.netHandle("openPropertyMenu", function(source, propertyID)
    -- TODO -> (AntiCheat) Check la distance
    ---@type House
    local identifier = ESX.GetIdentifierFromId(source)
    local isAllowed = false
    local house = FlashSideSHousesManager.list[propertyID]
    for _,v in pairs(house.allowedPlayers) do 
        if v == identifier then
            isAllowed = true
        end
    end
    FlashSideServerUtils.toClient("openClientPropertyMenu", source, house.ownerLicense, { house.info.selectedInterior, house.info.price, propertyID, house.ownerInfo }, FlashSideServerUtils.getLicense(source), isAllowed, house.public)
end)

FlashSide.netRegisterAndHandle("saveProperty", function(info, street, announce)
    -- TODO -> (AntiCheat) Check le job de la source
    local source = source
    createHouse(info, source, street, announce)
end)

FlashSide.netRegisterAndHandle("enterHouse", function(houseId, isGuest, from)
    if not FlashSideSHousesManager.list[houseId] then
        return
    end
    local source = source
    local identifier = ESX.GetIdentifierFromId(source)
    ---@type House
    local house = FlashSideSHousesManager.list[houseId]
    -- TODO -> Faire le système de clés (autoriser d'autres joueurs)
    if not house.public then
        if not isGuest then
            if identifier ~= house.ownerLicense then
                return
            end
        else
            local isAllowed = false
            for _,v in pairs(house.allowedPlayers) do
                if v == identifier then
                    isAllowed = true
                end
            end 
            if not isAllowed then
                return
            end
        end
    end
    house:enter(source, identifier ~= house.ownerLicense, from)
end)

FlashSide.netRegisterAndHandle("buyProperty", function(houseId)
    if not FlashSideSHousesManager.list[houseId] then
        return
    end
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local bank = xPlayer.getAccount("bank").money
    ---@type House
    local house = FlashSideSHousesManager.list[houseId]
    if house.ownerLicense ~= "none" then
        TriggerClientEvent("esx:showNotification", source, "~r~Cette maison a déjà été achetée !")
        return
    end
    local price = tonumber(house.info.price)
    if bank >= price then
        xPlayer.removeAccountMoney("bank", price)
        --local license = FlashSideServerUtils.getLicense(source)
        local identifier = ESX.GetIdentifierFromId(source)
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @a", {
            ['a'] = identifier
        }, function(res)
            if res[1] then
                MySQL.Async.execute("UPDATE alkia_houses SET owner = @a, ownerInfo = @b WHERE id = @c", {
                    ['a'] = identifier,
                    ['b'] = res[1].firstname.." "..res[1].lastname,
                    ['c'] = houseId
                }, function(done)
                    FlashSideSHousesManager.list[houseId].ownerLicense = identifier
                    FlashSideSHousesManager.list[houseId].ownerInfo = res[1].firstname.." "..res[1].lastname
                    FlashSideServerUtils.toClient("addOwnedHouse", source, {id = houseId, coords = house.info.entry})
                    FlashSideServerUtils.toClient("advancedNotif", source, "~r~Agence immobilière", "~r~Achat de propriétée", "~r~Félicitations ~s~! Cette propriétée est désormais la votre ! Profitez-en bien.", "CHAR_MINOTAUR", 1)
                    FlashSideServerUtils.toAll("houseNoLongerAvailable", houseId)
                end)
            end
        end)

    else
        FlashSideServerUtils.toClient("advancedNotif", source, "~r~Agence immobilière", "~r~Achat de propriétée", "Vous n'avez pas assez d'argent en banque pour acheter cette propriétée !", "CHAR_MINOTAUR", 1)
    end
end)

FlashSide.netRegisterAndHandle("requestAvailableHouses", function()
    local source = source
    local identifier = FlashSideServerUtils.getLicense(source)
    local allowed = {}
    local available = {}
    local owned = {}
    ---@param house House
    for houseID, house in pairs(FlashSideSHousesManager.list) do
        if house.ownerLicense == "none" then
            available[houseID] = house.info.entry
        else
            if house.ownerLicense == identifier then
                owned[houseID] = house.info.entry
            else
                for _,allowedLicense in pairs(house.allowedPlayers) do
                    if identifier == allowedLicense then
                        allowed[houseID] = {coords = house.info.entry, name = house.ownerInfo}
                    end
                end
            end
        end
    end
    FlashSideServerUtils.toClient("cbAvailableHouses", source, available, owned, allowed)
end)

FlashSide.netRegisterAndHandle("setHouseAlloweds", function(houseId, allowedTable, isPublic)
    if not FlashSideSHousesManager.list[houseId] then
        return
    end
    local newHouseAllowedTable = {}
    local source = source
    local license = FlashSideServerUtils.getLicense(source)
    ---@type House
    local house = FlashSideSHousesManager.list[houseId]
    if not house:isOwner(source) then 
        return
    end
    house.allowedPlayers = {}
    for k,v in pairs(allowedTable) do
        if v.can == true then
            table.insert(newHouseAllowedTable, k)
        end
    end
    house.public = isPublic
    house.allowedPlayers = newHouseAllowedTable
    FlashSideSHousesManager.list[houseId] = house
    TriggerClientEvent("esx:showNotification", source, "~r~Modification appliquées")
end)

FlashSide.netRegisterAndHandle("FlashSide:Ouvert", function()
    TriggerClientEvent("esx:showNotification", -1, "~s~Votre ~r~Agent Imo ~s~est désormais ~r~ouvert ~s~!")
end)

FlashSide.netRegisterAndHandle("FlashSide:Fermée", function()
    TriggerClientEvent("esx:showNotification", -1, "~s~Votre ~r~Agent Imo ~s~est désormais ~r~fermé ~s~!")
end)