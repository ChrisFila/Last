RegisterNetEvent('police:handcuff')
  AddEventHandler('police:handcuff', function()
  
    IsHandcuffed    = not IsHandcuffed;
    local playerPed = GetPlayerPed(-1)
  
    Citizen.CreateThread(function()
  
      if IsHandcuffed then
  
          RequestAnimDict('mp_arresting')
          while not HasAnimDictLoaded('mp_arresting') do
              Citizen.Wait(100)
          end
  
        TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
        DisableControlAction(2, 37, true)
        SetEnableHandcuffs(playerPed, true)
        SetPedCanPlayGestureAnims(playerPed, false)
        FreezeEntityPosition(playerPed,  true)
        DisableControlAction(0, 24, true) -- Attack
        DisableControlAction(0, 257, true) -- Attack 2
        DisableControlAction(0, 25, true) -- Aim
        DisableControlAction(0, 263, true) -- Melee Attack 1
        DisableControlAction(0, 37, true) -- Select Weapon
        DisableControlAction(0, 47, true)  -- Disable weapon
        
  
      else
  
        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed,  true)
        FreezeEntityPosition(playerPed, false)
  
      end
  
    end)
  end)
  
  
  RegisterNetEvent('police:putInVehicle')
  AddEventHandler('police:putInVehicle', function()
  
    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)
  
    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
  
      local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)
  
      if DoesEntityExist(vehicle) then
  
        local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
        local freeSeat = nil
  
        for i=maxSeats - 1, 0, -1 do
          if IsVehicleSeatFree(vehicle,  i) then
            freeSeat = i
            break
          end
        end
  
        if freeSeat ~= nil then
          TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
        end
  
      end
  
    end
  
  end)
  
  
RegisterNetEvent("police:OutVehicle")
AddEventHandler("police:OutVehicle", function()
    TaskLeaveAnyVehicle(GetPlayerPed(-1), 0, 0)
end)



RegisterNetEvent('police:drag')
AddEventHandler('police:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      if IsDragged then
        local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
        local myped = GetPlayerPed(-1)
        AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      else
        DetachEntity(GetPlayerPed(-1), true, false)
      end
    end
  end
end)

function GetClosestPlayer()
    local pPed = GetPlayerPed(-1)
    local players = GetActivePlayers()
    local coords = GetEntityCoords(pPed)
    local pCloset = nil
    local pClosetPos = nil
    local pClosetDst = nil
    for k,v in pairs(players) do
        if GetPlayerPed(v) ~= pPed then
            local oPed = GetPlayerPed(v)
            local oCoords = GetEntityCoords(oPed)
            local dst = GetDistanceBetweenCoords(oCoords, coords, true)
            if pCloset == nil then
                pCloset = v
                pClosetPos = oCoords
                pClosetDst = dst
            else
                if dst < pClosetDst then
                    pCloset = v
                    pClosetPos = oCoords
                    pClosetDst = dst
                end
            end
        end
    end

    return pCloset, pClosetDst
end