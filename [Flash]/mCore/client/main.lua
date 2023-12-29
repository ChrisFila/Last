--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

ESX = nil
menuIsOpened = false

FlashSide.newThread(function()
    Wait(1500)
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
        Wait(1)
    end
    ESX.PlayerData = ESX.GetPlayerData()
    while ESX.GetPlayerData().job == nil do
        Wait(1)
    end
    Job = ESX.PlayerData.job
    if Jobs.list[Job.name] ~= nil and Jobs.list[Job.name].onChange ~= nil then
        Jobs.list[Job.name].onChange()
    end
    FlashSide.toInternal("esxloaded")
    FlashSideClientUtils.toServer("jobInitiated", Job)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.PlayerData = ESX.GetPlayerData()
    Job = ESX.PlayerData.job
    FlashSideClientUtils.toServer("jobUpdated", job)
end)

local antispam = false
RegisterCommand("co", function()
    if antispam then return end
    FlashSideClientUtils.toServer("coords", GetEntityCoords(PlayerPedId()))
    antispam = true
    FlashSide.newWaitingThread(500, function()
        antispam = false
    end)
end)