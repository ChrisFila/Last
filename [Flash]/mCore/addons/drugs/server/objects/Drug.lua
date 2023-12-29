---@author Pablo Z.
---@version 1.0
--[[
  This file is part of FlashSide RolePlay.
  
  File [Drug] created at [26/04/2021 18:18]

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Drug
---@field public id number
---@field public harvestCoords table
---@field public treatmentCoords table
---@field public sellCoords table
---@field public harvestZone number
---@field public treatmentZone number
---@field public sellZone number
---@field public sellNpc Npc
---@field public drugInfos table
Drug = {}
Drug.__index = Drug

local markersRGBA, markersDRAW = { r = 0, g = 0, b = 0, a = 255 }, 1.50

setmetatable(Drug, {
    __call = function(_, harvestCoords, treatmentCoords, sellCoords, drugInfos)
        local self = setmetatable({}, Drug);
        self.id = (#FlashSideSDrugsManager.list + 1)
        self.drugInfos = drugInfos
        self.harvestZone = FlashSideSZonesManager.createPublic(harvestCoords.coords, 22, markersRGBA, function(source)
            self:harvest(source)
        end, ("Appuyez sur ~INPUT_CONTEXT~ pour récolter~n~~r~Action~s~: %ss~n~~o~Récompense~s~: %s"):format(drugInfos.harvest.interval, ESX.GetItem(drugInfos.harvest.reward.item).label), markersDRAW, 1.0)

        self.treatmentZone = FlashSideSZonesManager.createPublic(treatmentCoords.coords, 22, markersRGBA, function(source)
            self:treat(source)
        end, ("Appuyez sur ~INPUT_CONTEXT~ pour traiter~n~~r~Action~s~: %ss~n~~o~Récompense~s~: %s"):format(drugInfos.treatment.interval, ESX.GetItem(drugInfos.treatment.reward.item).label), markersDRAW, 1.0)

        self.sellZone = FlashSideSZonesManager.createPublic(sellCoords.coords, 22, markersRGBA, function(source)
            self:sell(source)
        end, ("Appuyez sur ~INPUT_CONTEXT~ pour vendre~n~~r~Action~s~: %ss~n~~o~Récompense~s~: %s"):format(drugInfos.sell.interval, "~r~?"), markersDRAW, 1.0)

        self.sellNpc = FlashSideSNpcsManager.createPublic(drugInfos.sell.npc.model, false, true, drugInfos.sell.npc.position, "WORLD_HUMAN_DRUG_DEALER_HARD", nil)
        self.sellNpc:setInvincible(true)
        self.sellNpc:setFloatingText(("Pssst, viens ici pour vendre: ~r~%s"):format(ESX.GetItem(self.drugInfos.sell.requiered.item).label), 5.5)
        FlashSideSDrugsManager[self.id] = self
        return self;
    end
})

function Drug.setOnCoolDown(source, ms, onFinished)
    FlashSideSDrugsManager.onCooldown[source] = true
    FlashSide.newWaitingThread(ms, function()
        FlashSideSDrugsManager.onCooldown[source] = nil
        if onFinished then
            onFinished()
        end
    end)
end

---harvest
---@public
---@return void
function Drug:harvest(source)
    if FlashSideSDrugsManager.onCooldown[source] then
        return
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    FlashSideServerUtils.toClient("playScenario", source, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", FlashSide.second(self.drugInfos.harvest.interval), true)
    self.setOnCoolDown(source, FlashSide.second(self.drugInfos.harvest.interval), function()
        xPlayer.addInventoryItem(self.drugInfos.harvest.reward.item, self.drugInfos.harvest.reward.count)
        TriggerClientEvent("esx:showNotification", source, ("~r~Récolte effectuée: +%i %s"):format(self.drugInfos.harvest.reward.count, ESX.GetItem(self.drugInfos.harvest.reward.item).label))
    end)
end

---treat
---@public
---@return void
function Drug:treat(source)
    if FlashSideSDrugsManager.onCooldown[source] then
        return
    end
    local requieredItem, requieredCount, rewardItem, rewardCount = self.drugInfos.treatment.requiered.item, self.drugInfos.treatment.requiered.count, self.drugInfos.treatment.reward.item, self.drugInfos.treatment.reward.count
    local xPlayer = ESX.GetPlayerFromId(source)
    local actualCount = xPlayer.getInventoryItem(requieredItem).count
    if actualCount < requieredCount then
        TriggerClientEvent("esx:showNotification", source, ("~r~Vous n'avez pas assez de %s (%i requis)"):format(ESX.GetItem(requieredItem).label, requieredCount))
        return
    end
    FlashSideServerUtils.toClient("playScenario", source, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", FlashSide.second(self.drugInfos.harvest.interval), true)
    xPlayer.removeInventoryItem(requieredItem, requieredCount)
    self.setOnCoolDown(source, FlashSide.second(self.drugInfos.treatment.interval), function()
        xPlayer.addInventoryItem(rewardItem, rewardCount)
        TriggerClientEvent("esx:showNotification", source, ("~r~Transformation effectuée: +%i %s"):format(rewardCount, ESX.GetItem(rewardItem).label))
    end)
end

---sell
---@public
---@return void
function Drug:sell(source)
    if FlashSideSDrugsManager.onCooldown[source] then
        return
    end
    local requieredItem, requieredCount = self.drugInfos.sell.requiered.item, self.drugInfos.sell.requiered.count
    local xPlayer = ESX.GetPlayerFromId(source)
    local actualCount = xPlayer.getInventoryItem(requieredItem).count
    local reward = self.drugInfos.sell.reward.genReward()
    if actualCount < requieredCount then
        self.sellNpc:playSpeechForPlayer("GENERIC_INSULT_HIGH", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", source)
        TriggerClientEvent("esx:showNotification", source, ("~r~Vous n'avez pas assez de %s (%i requis)"):format(ESX.GetItem(requieredItem).label, requieredCount))
        return
    end
    FlashSideServerUtils.toClient("playScenario", source, "WORLD_HUMAN_CLIPBOARD_FACILITY", FlashSide.second(self.drugInfos.sell.interval), true)
    self.setOnCoolDown(source, FlashSide.second(self.drugInfos.sell.interval), function()
        xPlayer.removeInventoryItem(requieredItem, requieredCount)
        xPlayer.addAccountMoney(self.drugInfos.sell.reward.account, reward)
        self.sellNpc:playSpeechForPlayer("GENERIC_THANKS", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", source)
        TriggerClientEvent("esx:showNotification", source, ("~r~Vente effectuée: +%i$"):format(reward))
    end)
end
