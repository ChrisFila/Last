---@author Pablo Z.
---@version 1.0
--[[
  This file is part of FlashSide RolePlay.
  
  File [main] created at [19/04/2021 23:51]

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

FlashSideSPlayersManager = {}
FlashSideSPlayersManager.eventOverrider = {}
FlashSideSPlayersManager.addonCache = {}
FlashSideSPlayersManager.list = {}

FlashSideSPlayersManager.registerAddonCache = function(index, onConnect, onDisconnect, onChange)
    FlashSideServerUtils.trace(("Enregistrement d'un cache joueur: ^3%s"):format(index), FlashSidePrefixes.dev)
    FlashSideSPlayersManager.addonCache[index] = { onConnect, onDisconnect, onChange }
end

FlashSideSPlayersManager.registerEventOverrider = function(type, func)
    FlashSideSPlayersManager.eventOverrider[(#FlashSideSPlayersManager.eventOverrider + 1)] = { on = type, handle = func }
end

FlashSideSPlayersManager.exists = function(source)
    return FlashSideSPlayersManager.list[source] ~= nil
end

FlashSideSPlayersManager.createPlayer = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local steam, license = xPlayer.identifier, FlashSideServerUtils.getLicense(source)
    FlashSideSPlayersManager.list[source] = Player(source, steam, license)
end

FlashSideSPlayersManager.getPlayer = function(source)
    return FlashSideSPlayersManager.list[source]
end

FlashSideSPlayersManager.removePlayer = function(source)
    FlashSideSPlayersManager.list[source] = nil
end

FlashSide.netHandleBasic("playerDropped", function(reason)
    local source = source
    if not FlashSideSPlayersManager.exists(source) then
        return
    end
    FlashSideServerUtils.trace(("Déconnexion de %s"):format(GetPlayerName(source)), FlashSidePrefixes.dev)
    for _, eventOverriderInfos in pairs(FlashSideSPlayersManager.eventOverrider) do
        if eventOverriderInfos.on == PLAYER_EVENT_TYPE.LEAVING then
            eventOverriderInfos.handle(source)
        end
    end
    for _, handlers in pairs(FlashSideSPlayersManager.addonCache) do
        handlers[2](FlashSideSPlayersManager.list[source])
    end
    FlashSideSPlayersManager.removePlayer(source)
end)

FlashSide.netHandleBasic('esx:playerLoaded', function(source, xPlayer)
    local source = source
    FlashSideServerUtils.trace(("Connexion de %s"):format(GetPlayerName(source)), FlashSidePrefixes.dev)
    FlashSideSPlayersManager.createPlayer(source)
    for _, eventOverriderInfos in pairs(FlashSideSPlayersManager.eventOverrider) do
        if eventOverriderInfos.on == PLAYER_EVENT_TYPE.CONNECTED then
            eventOverriderInfos.handle(source)
        end
    end
    for _, handlers in pairs(FlashSideSPlayersManager.addonCache) do
        handlers[1](FlashSideSPlayersManager.list[source])
    end
end)

FlashSide.newRepeatingTask(function()
    ---@param player Player
    for _, player in pairs(FlashSideSPlayersManager.list) do
        player:incrementSessionTimePlayed()
    end
end, nil, 0, FlashSide.second(60))