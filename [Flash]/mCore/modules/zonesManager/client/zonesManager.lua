--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local zones = {}
zones.cooldown = false
zones.list = {}

FlashSide.netHandle("esxloaded", function()
    FlashSideClientUtils.toServer("requestPredefinedZones")
    while true do
        local interval = 500
        local pos = GetEntityCoords(PlayerPedId())
        local closeToMarker = false
        for zoneId, zone in pairs(zones.list) do
            local zoneCoords = zone.position
            local dist = #(pos - zoneCoords)
            if dist <= zone.distances[1] then
                closeToMarker = true
                DrawMarker(zone.type, zoneCoords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, zone.color.r, zone.color.g, zone.color.b, zone.color.a, 55555, false, true, 2, false, false, false, false)
                if dist <= zone.distances[2] then
                    AddTextEntry("ZONES", "~r~Description~s~: "..(zone.help or "Appuyez sur ~INPUT_CONTEXT~ pour intéragir"))
                    DisplayHelpTextThisFrame("ZONES", false)
                    if IsControlJustPressed(0, 51) then
                        if not zones.cooldown then
                            zones.cooldown = true
                            FlashSideClientUtils.toServer("interactWithZone", zone.id)
                            FlashSide.newWaitingThread(450, function()
                                zones.cooldown = false
                            end)
                        end
                    end
                end
            end
        end
        if closeToMarker then
            interval = 0
        end
        Wait(interval)
    end
end)


FlashSide.netRegisterAndHandle("newMarker", function(zone)
    zones.list[zone.id] = zone
end)

FlashSide.netRegisterAndHandle("delMarker", function(zoneID)
    zones.list[zoneID] = nil
end)

FlashSide.netRegisterAndHandle("cbZones", function(zoneInfos)
    zones.list = zoneInfos
end)