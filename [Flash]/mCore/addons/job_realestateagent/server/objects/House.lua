--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class House
---@field public houseId number
---@field public ownerLicense string
---@field public info table
---@field public exitMarker number
---@field public managerMarker number
---@field public laundryMarker number
---@field public ownerInfo string
---@field public inventory table
---@field public allowedPlayers table
---@field public street string
---@field public public boolean
---@field public blips table
---@field protected saved boolean
House = {}
House.__index = House

setmetatable(House, {
    __call = function(_, houseId, ownerLicense, info, ownerInfo, inventory, street)
        local self = setmetatable({}, House)
        self.houseId = houseId
        self.ownerLicense = ownerLicense
        self.instance = FlashSideSHousesManager.instanceRange + houseId
        self.players = {}
        self.info = info
        self.ownerInfo = ownerInfo
        self.inventory = inventory
        self.allowedPlayers = {}
        self.street = street
        self.public = false
        self.blips = {
            exit = nil,
            laundry = nil,
            manager = nil
        }
        -- Zones
        SetRoutingBucketPopulationEnabled(self.instance, false)
        return self
    end
})

---getInstance
---@public
---@return number
function House:getInstance()
    return self.instance or -1
end

---getPlayers
---@public
---@return table
function House:getPlayers()
    return self.players
end

---isOwner
---@public
---@return boolean
function House:isOwner(source)
    local license = FlashSideServerUtils.getLicense(source)
    return license == self.ownerLicense
end

---getPlayersCount
---@public
---@return number
function House:getPlayersCount()
    return #self.players
end

---enter
---@public
---@return void
function House:enter(source)
    print(FlashSide.prefix(FlashSidePrefixes.house, ("Le joueur ^2%s ^7est entrée dans la maison ^3%s ^7(^3%s^7)"):format(GetPlayerName(source),self.houseId,self.info.name)))
    FlashSideSZonesManager.addAllowed(self.exitMarker, source)
    FlashSideSZonesManager.addAllowed(self.laundryMarker, source)
    FlashSideSBlipsManager.addAllowed(self.blips.exit, source)
    FlashSideSBlipsManager.addAllowed(self.blips.laundry, source)
    if self:isOwner(source) then
        FlashSideSZonesManager.addAllowed(self.managerMarker, source)
        FlashSideSBlipsManager.addAllowed(self.blips.manager, source)
    end
    SetPlayerRoutingBucket(source, self.instance)
    local interiorInfos = FlashSideInteriors[self.info.selectedInterior]
    FlashSideServerUtils.toClient("enterHouse", source, interiorInfos.interiorEntry)
    local isGuest = false
    local license = FlashSideServerUtils.getLicense(source)
    if license ~= self.ownerLicense then isGuest = true end
    if isGuest then
        local players = ESX.GetPlayers()
        for _,id in pairs(players) do
            if FlashSideServerUtils.getLicense(id) == self.ownerLicense then
                TriggerClientEvent("esx:showNotification", id, ("[~r~Invité~s~] ~r~%s ~s~est entré dans votre maison à ~o~%s"):format(GetPlayerName(source),self.street))
            end
        end
    end
end

---exit
---@public
---@return void
function House:exit(source)
    print(FlashSide.prefix(FlashSidePrefixes.house, ("Le joueur ^2%s ^7est sorti(e) de la maison ^3%s ^7(^3%s^7)"):format(GetPlayerName(source),self.houseId,self.info.name)))
    FlashSideSZonesManager.removeAllowed(self.exitMarker, source)
    FlashSideSZonesManager.removeAllowed(self.laundryMarker, source)
    FlashSideSBlipsManager.removeAllowed(self.blips.exit, source)
    FlashSideSBlipsManager.removeAllowed(self.blips.laundry, source)
    if self:isOwner(source) then
        FlashSideSZonesManager.removeAllowed(self.managerMarker, source)
        FlashSideSBlipsManager.removeAllowed(self.blips.manager, source)
    end
    SetPlayerRoutingBucket(source, 0)
    FlashSideServerUtils.toClient("exitHouse", source, self.info.entry)
    local isGuest = false
    local license = FlashSideServerUtils.getLicense(source)
    if license ~= self.ownerLicense then isGuest = true end
    if isGuest then
        local players = ESX.GetPlayers()
        for _,id in pairs(players) do
            if FlashSideServerUtils.getLicense(id) == self.ownerLicense then
                TriggerClientEvent("esx:showNotification", id, ("[~r~Invité~s~] ~r~%s ~s~est sorti(e) de votre maison à ~o~%s"):format(GetPlayerName(source),self.street))
            end
        end
    end
end

---openManger
---@public
---@return void
function House:openManger(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerInventory = {}
    local propertyInventory = {}
    for _,v in pairs(xPlayer.getInventory()) do
        if v.count > 0 then
            playerInventory[v.name] = {count = v.count, label = v.label}
        end
    end
    for name,count in pairs(self.inventory) do
        if count > 0 then
            propertyInventory[name] = {count = count, label = ESX.GetItemLabel(name)}
        end
    end
    local license = FlashSideServerUtils.getLicense(source)
    if self:isOwner(source) then
        local interiorInfos = FlashSideInteriors[self.info.selectedInterior]
        local capacity = interiorInfos.capacity
        local allPlayers = {}
        local players = ESX.GetPlayers()
        for _,id in pairs(players) do
            allPlayers[id] = {license = FlashSideServerUtils.getLicense(id), name = GetPlayerName(id)}
        end
        FlashSideServerUtils.toClient("openManagerPropertyMenu", source, allPlayers, self.allowedPlayers, license, self.houseId, self.public, {propertyInventory, playerInventory}, capacity)
    end
end

---saveInventory
---@public
---@return void
function House:saveInventory()
    for itemName, count in pairs(self.inventory) do
        if count == 0 then
            self.inventory[itemName] = nil
        end
    end
    MySQL.Async.execute("UPDATE alkia_houses SET inventory = @a WHERE id = @b", {
        ['a'] = json.encode(self.inventory),
        ['b'] = self.houseId
    }, function()
        FlashSideServerUtils.trace(("Saved inventory of house ^3%i"):format(self.houseId), FlashSidePrefixes.house)
        return 1
    end)
end

---addItem
---@public
---@return boolean
function House:addItem(itemName, count, source)
    if not self.inventory[itemName] then
        self.inventory[itemName] = 0
    end
    local totalItems = 0
    for _,count in pairs(self.inventory) do
        totalItems = totalItems + count
    end
    local interiorInfos = FlashSideInteriors[self.info.selectedInterior]
    local capacity = interiorInfos.capacity
    local fakeFinalCount = totalItems + count
    if fakeFinalCount > capacity then
        return false
    end
    self.inventory[itemName] = self.inventory[itemName] + count
    if source ~= nil then FlashSideServerUtils.webhook(("Le joueur %s a déposé %i %s dans la propriétée %i"):format(GetPlayerName(source), count, ESX.GetItemLabel(itemName), self.houseId), "green", "https://discord.com/api/webhooks/827480675073654824/Q3DU_lRfpwPbZQaZ6hoBK16dQYBvwUeCbcRRhyBM2Kk6IKASx4m-R3NLLMmext_JQwfy") end
    self:saveInventory()
    return true
end

---removeItem
---@public
---@return boolean
function House:removeItem(itemName, count, source)
    if (self.inventory[itemName] - count) <= 0 then
        self.inventory[itemName] = nil
    else
        self.inventory[itemName] = (self.inventory[itemName] - count)
    end
    if source ~= nil then FlashSideServerUtils.webhook(("Le joueur %s a retiré %i %s de la propriétée %i"):format(GetPlayerName(source), count, ESX.GetItemLabel(itemName), self.houseId), "red", "https://discord.com/api/webhooks/827480675073654824/Q3DU_lRfpwPbZQaZ6hoBK16dQYBvwUeCbcRRhyBM2Kk6IKASx4m-R3NLLMmext_JQwfy") end
    self:saveInventory()
end
---openLaundry
---@public
---@return void
function House:openLaundry(source)
    local license = FlashSideServerUtils.getLicense(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        FlashSideServerUtils.toClient("openLaundryPropertyMenu", source, store.get('dressing'))
    end)
end

---initMarker
---@public
---@return void
function House:initMarker()
    FlashSideSZonesManager.createPublic(vector3(self.info.entry.x, self.info.entry.y, self.info.entry.z), 22, {r = 52, g = 235, b = 201, a = 255}, function(source)
        FlashSide.toInternal("openPropertyMenu", source, self.houseId)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour intéragir avec la propriétée", 15.0, 1.0)

    local interiorInfos = FlashSideInteriors[self.info.selectedInterior]
    self.exitMarker = FlashSideSZonesManager.createPrivate(vector3(interiorInfos.interiorExit.x, interiorInfos.interiorExit.y, interiorInfos.interiorExit.z), 22, {r = 255, g = 0, b = 0, a = 255}, function(source)
        self:exit(source)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour sortir de la propriétée", 50.0, 1.0)

    self.managerMarker = FlashSideSZonesManager.createPrivate(vector3(interiorInfos.managerLocation.x, interiorInfos.managerLocation.y, interiorInfos.managerLocation.z), 22, {r = 62, g = 154, b = 194, a = 255}, function(source)
        self:openManger(source)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le gestionnaire de propriétée", 20.0, 1.0)

    self.laundryMarker = FlashSideSZonesManager.createPrivate(vector3(interiorInfos.laundryLocation.x, interiorInfos.laundryLocation.y, interiorInfos.laundryLocation.z), 22, {r = 174, g = 62, b = 194, a = 255}, function(source)
        self:openLaundry(source)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le dressing", 20.0, 1.0)
end

---initBlips
---@public
---@return void
function House:initBlips()
    local interiorInfos = FlashSideInteriors[self.info.selectedInterior]
    self.blips.exit = FlashSideSBlipsManager.createPrivate(vector3(interiorInfos.interiorExit.x, interiorInfos.interiorExit.y, interiorInfos.interiorExit.z), 126, 59, 0.8, "Sortie de la propriétée", false)
    self.blips.laundry = FlashSideSBlipsManager.createPrivate(vector3(interiorInfos.laundryLocation.x, interiorInfos.laundryLocation.y, interiorInfos.laundryLocation.z), 73, 68, 0.8, "Dressing de la propriétée", false)
    self.blips.manager = FlashSideSBlipsManager.createPrivate(vector3(interiorInfos.managerLocation.x, interiorInfos.managerLocation.y, interiorInfos.managerLocation.z), 521, 81, 0.8, "Gestion de la propriétée", false)
end