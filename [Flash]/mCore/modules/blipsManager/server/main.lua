--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

FlashSideSBlipsManager = {}
FlashSideSBlipsManager.list = {}

FlashSideSBlipsManager.createPublic = function(position, sprite, color, scale, text, shortRange)
    local blip = Blip(position, sprite, color, scale, text, shortRange, false)
    FlashSideServerUtils.toAll("newBlip", blip)
    return blip.blipId
end

FlashSideSBlipsManager.createPrivate = function(position, sprite, color, scale, text, shortRange, baseAllowed)
    local blip = Blip(position, sprite, color, scale, text, shortRange, true, baseAllowed)
    local players = ESX.GetPlayers()
    for k, v in pairs(players) do
        if blip:isAllowed(v) then
            FlashSideServerUtils.toClient("newBlip", v, blip)
        end
    end
    return blip.blipId
end

FlashSideSBlipsManager.addAllowed = function(blipID, playerId)
    if not FlashSideSBlipsManager.list[blipID] then
        return
    end
    ---@type Blip
    local blip = FlashSideSBlipsManager.list[blipID]
    if blip:isAllowed(playerId) then
        print(FlashSide.prefix(FlashSidePrefixes.blips,("Tentative d'ajouter l'ID %s au blip %s alors qu'il est déjà autorisé"):format(playerId,blipID)))
        return
    end
    blip:addAllowed(playerId)
    FlashSideServerUtils.toClient("newBlip", playerId, blip)
    FlashSideSBlipsManager.list[blipID] = blip
end

FlashSideSBlipsManager.removeAllowed = function(blipID, playerId)
    if not FlashSideSBlipsManager.list[blipID] then
        return
    end
    ---@type Blip
    local blip = FlashSideSBlipsManager.list[blipID]
    if not blip:isAllowed(playerId) then
        print(FlashSide.prefix(FlashSidePrefixes.blips,("Tentative de supprimer l'ID %s au blip %s alors qu'il n'est déjà pas autorisé"):format(playerId,blipID)))
        return
    end
    blip:removeAllowed(playerId)
    FlashSideServerUtils.toClient("delBlip", playerId, blipID)
    FlashSideSBlipsManager.list[blipID] = blip
end

FlashSideSBlipsManager.updateOne = function(source)
    local blips = {}
    ---@param blip Blip
    for blipID, blip in pairs(FlashSideSBlipsManager.list) do
        if blip:isRestricted() then
            if blip:isAllowed(source) then
                blips[blipID] = blip
            end
        else
            blips[blipID] = blip
        end
    end
    FlashSideServerUtils.toClient("cbBlips", source, blips)
end

FlashSideSBlipsManager.delete = function(blipID)
    if not FlashSideSBlipsManager.list[blipID] then
        return
    end
    ---@type Zone
    local blip = FlashSideSBlipsManager.list[blipID]
    if blip:isRestricted() then
        local players = ESX.GetPlayers()
        for k, playerId in pairs(players) do
            if blip:isAllowed(playerId) then
                FlashSideServerUtils.toClient("delBlip", playerId, blipID)
            end
        end
    else
        FlashSideServerUtils.toAll("delBlip", blipID)
    end
end

FlashSide.netRegisterAndHandle("requestPredefinedBlips", function()
    local source = source
    FlashSideSBlipsManager.updateOne(source)
end)