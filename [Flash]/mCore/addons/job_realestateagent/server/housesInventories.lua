--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

FlashSide.netRegisterAndHandle("depositHouse", function(houseId, itemName, depositCount)
    if not FlashSideSHousesManager.list[houseId] then
        return
    end
    local source = source
    local license = FlashSideServerUtils.getLicense(source)
    ---@type House
    local house = FlashSideSHousesManager.list[houseId]
    if not house:isOwner(source) then
        return
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemCount = xPlayer.getInventoryItem(itemName).count
    if itemCount < depositCount then
        FlashSideServerUtils.toClient("houseDepositFailed", source, "Erreur: Une erreur est survenue")
        return
    end
    local itemsAddedInHouse = house:addItem(itemName, depositCount, source)
    if not itemsAddedInHouse then
        FlashSideServerUtils.toClient("houseDepositFailed", source, "Erreur: Capacité maximale dépassée")
        return
    end
    xPlayer.removeInventoryItem(itemName, depositCount)
    itemCount = xPlayer.getInventoryItem(itemName).count
    FlashSideServerUtils.toClient("houseDepositSucceed", source, itemName, itemCount, depositCount)
end)

FlashSide.netRegisterAndHandle("removeFromHouse", function(houseId, itemName, removalCount)
    if not FlashSideSHousesManager.list[houseId] then
        return
    end
    local source = source
    local license = FlashSideServerUtils.getLicense(source)
    ---@type House
    local house = FlashSideSHousesManager.list[houseId]
    if not house:isOwner(source) then
        FlashSideServerUtils.toClient("houseDepositFailed", source, "Erreur: Une erreur est survenue")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    if house.inventory[itemName] == nil then
        return
    end
    local avaibleCount = house.inventory[itemName]
    if removalCount > avaibleCount then
        FlashSideServerUtils.toClient("houseDepositFailed", source, "Erreur: Une erreur est survenue")
        return
    end
    house:removeItem(itemName, removalCount, source)
    xPlayer.addInventoryItem(itemName, removalCount)
    itemCount = xPlayer.getInventoryItem(itemName).count
    FlashSideServerUtils.toClient("houseRemovalSucceed", source, itemName, itemCount, removalCount)
end)