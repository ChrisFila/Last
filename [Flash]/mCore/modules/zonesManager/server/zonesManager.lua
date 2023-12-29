--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

FlashSideSZonesManager = {}
FlashSideSZonesManager.list = {}

FlashSideSZonesManager.createPublic = function(location, type, color, onInteract, helpText, drawDist, itrDist)
    local zone = Zone(location, type, color, onInteract, helpText, drawDist, itrDist, false)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    FlashSideServerUtils.toAll("newMarker", marker)
    return zone.zoneID
end

FlashSideSZonesManager.createPrivate = function(location, type, color, onInteract, helpText, drawDist, itrDist, baseAllowed)
    local zone = Zone(location, type, color, onInteract, helpText, drawDist, itrDist, true, baseAllowed)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    local players = ESX.GetPlayers()
    for k, v in pairs(players) do
        if zone:isAllowed(v) then
            FlashSideServerUtils.toClient("newMarker", v, marker)
        end
    end
    return zone.zoneID
end

FlashSideSZonesManager.addAllowed = function(zoneID, playerId)
    if not FlashSideSZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = FlashSideSZonesManager.list[zoneID]
    if zone:isAllowed(playerId) then
        print(FlashSide.prefix(FlashSidePrefixes.zones,("Tentative d'ajouter l'ID %s à la zone %s alors qu'il est déjà autorisé"):format(playerId,zoneID)))
        return
    end
    zone:addAllowed(playerId)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    FlashSideServerUtils.toClient("newMarker", playerId, marker)
    FlashSideSZonesManager.list[zoneID] = zone
end

FlashSideSZonesManager.removeAllowed = function(zoneID, playerId)
    if not FlashSideSZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = FlashSideSZonesManager.list[zoneID]
    if not zone:isAllowed(playerId) then
        print(FlashSide.prefix(FlashSidePrefixes.zones,("Tentative de supprimer l'ID %s à la zone %s alors qu'il n'est déjà pas autorisé"):format(playerId,zoneID)))
        return
    end
    zone:removeAllowed(playerId)
    FlashSideServerUtils.toClient("delMarker", playerId, zoneID)
    FlashSideSZonesManager.list[zoneID] = zone
end

FlashSideSZonesManager.updatePrivacy = function(zoneID, newPrivacy)
    if not FlashSideSZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = FlashSideSZonesManager.list[zoneID]
    local wereAllowed = {}
    local wasRestricted = zone:isRestricted()
    if zone:isRestricted() then
        wereAllowed = zone.allowed
    end
    zone.allowed = {}
    zone:setRestriction(newPrivacy)
    if zone:isRestricted() then
        local players = ESX.GetPlayers()
        if not wasRestricted then
            for _, playerId in pairs(players) do
                local isAllowedtoSee = false
                for _, allowed in pairs(wereAllowed) do
                    if allowed == playerId then
                        isAllowedtoSee = true
                    end
                end
                if not isAllowedtoSee then
                    FlashSideServerUtils.toClient("delMarker", playerId, zone.zoneID)
                end
            end
        end
    else
        if wasRestricted then
            for _, playerId in pairs(players) do
                local isAllowedtoSee = false
                for _, allowed in pairs(wereAllowed) do
                    if allowed == playerId then
                        isAllowedtoSee = true
                    end
                end
                if isAllowedtoSee then
                    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
                    FlashSideServerUtils.toClient("newMarker", playerId, marker)
                end
            end
        end
    end
    FlashSideSZonesManager.list[zoneID] = zone
end

FlashSideSZonesManager.delete = function(zoneID)
    if not FlashSideSZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = FlashSideSZonesManager.list[zoneID]
    if zone:isRestricted() then
        local players = ESX.GetPlayers()
        for k, playerId in pairs(players) do
            if zone:isAllowed(playerId) then
                FlashSideServerUtils.toClient("delMarker", playerId, zoneID)
            end
        end
    else
        FlashSideServerUtils.toAll("delMarker", zoneID)
    end
end

FlashSideSZonesManager.updateOne = function(source)
    local markers = {}
    ---@param zone Zone
    for zoneID, zone in pairs(FlashSideSZonesManager.list) do
        if zone:isRestricted() then
            if zone:isAllowed(source) then
                markers[zoneID] = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
            end
        else
            markers[zoneID] = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
        end
    end
    FlashSideServerUtils.toClient("cbZones", source, markers)
end

FlashSide.netRegisterAndHandle("requestPredefinedZones", function()
    local source = source
    FlashSideSZonesManager.updateOne(source)
end)

FlashSide.netRegisterAndHandle("interactWithZone", function(zoneID)
    local source = source
    if not FlashSideSZonesManager.list[zoneID] then
        DropPlayer("[FlashSide] Tentative d'intéragir avec une zone inéxistante.")
        return
    end
    ---@type Zone
    local zone = FlashSideSZonesManager.list[zoneID]
    zone:interact(source)
end)