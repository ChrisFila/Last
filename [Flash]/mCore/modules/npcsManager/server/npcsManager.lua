--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

FlashSideSNpcsManager = {}
FlashSideSNpcsManager.list = {}

FlashSideSNpcsManager.createPublic = function(model, ai, frozen, position, animation, onCreate)
    local npc = Npc(model, ai, frozen, position, animation, false)
    npc:setOnCreate(onCreate or function() end)
    FlashSideServerUtils.toAll("newNpc", npc)
    return npc
end

FlashSideSNpcsManager.createPrivate = function(model, ai, frozen, position, animation, baseAllowed, onCreate)
    local npc = Npc(model, ai, frozen, position, animation, true, baseAllowed)
    local players = ESX.GetPlayers()
    for k, v in pairs(players) do
        if npc:isAllowed(v) then
            FlashSideServerUtils.toClient("newNpc", v, npc)
        end
    end
    return npc
end

FlashSideSNpcsManager.addAllowed = function(npcId, playerId)
    if not FlashSideSNpcsManager.list[npcId] then
        return
    end
    ---@type Npc
    local npc = FlashSideSNpcsManager.list[npcId]
    if npc:isAllowed(playerId) then
        print(FlashSide.prefix(FlashSidePrefixes.npcs,("Tentative d'ajouter l'ID %s au npc %s alors qu'il est déjà autorisé"):format(playerId, npcId)))
        return
    end
    npc:addAllowed(playerId)
    FlashSideServerUtils.toClient("newNpc", playerId, npc)
    FlashSideSNpcsManager.list[npcId] = npc
end

FlashSideSNpcsManager.removeAllowed = function(npcId, playerId)
    if not FlashSideSNpcsManager.list[npcId] then
        return
    end
    ---@type Npc
    local npc = FlashSideSNpcsManager.list[npcId]
    if not npc:isAllowed(playerId) then
        print(FlashSide.prefix(FlashSidePrefixes.npcs,("Tentative de supprimer l'ID %s au blip %s alors qu'il n'est déjà pas autorisé"):format(playerId, npcId)))
        return
    end
    npc:removeAllowed(playerId)
    FlashSideServerUtils.toClient("delNpc", playerId, npcId)
    FlashSideSNpcsManager.list[npcId] = npc
end

FlashSideSNpcsManager.updateOne = function(source)
    local npcs = {}
    ---@param npc Npc
    for npcId, npc in pairs(FlashSideSNpcsManager.list) do
        if npc:isRestricted() then
            if npc:isAllowed(source) then
                npcs[npcId] = npc
            end
        else
            npcs[npcId] = npc
        end
    end
    FlashSideServerUtils.toClient("cbNpcs", source, npcs)
end

FlashSide.netRegisterAndHandle("requestPredefinedNpcs", function()
    local source = source
    FlashSideSNpcsManager.updateOne(source)
end)

