--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local availableHouses = {}
local ownedHouses = {}

FlashSide.netRegisterAndHandle("cbAvailableHouses", function(available, owned)
    for _, blip in pairs(availableHouses) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    for _, blip in pairs(ownedHouses) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    for houseID, coordinates in pairs(available) do
        local blip = AddBlipForCoord(coordinates.x, coordinates.y, coordinates.z)
        SetBlipSprite(blip, 374)
        SetBlipColour(blip, 69)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Propriétée à vendre")
        EndTextCommandSetBlipName(blip)
        availableHouses[houseID] = blip
    end
    for houseID, coordinates in pairs(owned) do
        local blip = AddBlipForCoord(coordinates.x, coordinates.y, coordinates.z)
        SetBlipSprite(blip, 492)
        SetBlipColour(blip, 11)
        SetBlipAsShortRange(blip, false)
        SetBlipScale(blip, 0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Propriétée acquise")
        EndTextCommandSetBlipName(blip)
        ownedHouses[houseID] = blip
    end
end)

FlashSide.netRegisterAndHandle("addAvailableHouse", function(available)
    if availableHouses[available.id] then
        return
    end
    local blip = AddBlipForCoord(available.coords.x, available.coords.y, available.coords.z)
    SetBlipSprite(blip, 374)
    SetBlipColour(blip, 69)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Propriétée à vendre")
    EndTextCommandSetBlipName(blip)
    availableHouses[available.id] = blip
end)

FlashSide.netRegisterAndHandle("addOwnedHouse", function(owned)
    if ownedHouses[owned.id] then
        return
    end
    local blip = AddBlipForCoord(owned.coords.x, owned.coords.y, owned.coords.z)
    SetBlipSprite(blip, 492)
    SetBlipColour(blip, 11)
    SetBlipAsShortRange(blip, false)
    SetBlipScale(blip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Propriétée acquise")
    EndTextCommandSetBlipName(blip)
    ownedHouses[owned.id] = blip
end)

FlashSide.netRegisterAndHandle("houseNoLongerAvailable", function(houseID)
    if not availableHouses[houseID] or not DoesBlipExist(availableHouses[houseID]) then
        return
    end
    RemoveBlip(availableHouses[houseID])
    availableHouses[houseID] = nil
end)

FlashSide.netRegisterAndHandle("houseNoLongerAllowed", function(houseID)
    if not accessHouses[houseID] or not DoesBlipExist(availableHouses[houseID]) then
        return
    end
    RemoveBlip(accessHouses[houseID])
    accessHouses[houseID] = nil
end)

FlashSide.netHandle("esxloaded", function()
    FlashSideClientUtils.toServer("requestAvailableHouses")
end)