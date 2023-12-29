Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- MENU FUNCTION --

local open = false 
local mainMenu6 = RageUI.CreateMenu('', '~r~Interaction')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
  open = false
end

function OpenGarageVigne()
     if open then 
         open = false
         RageUI.Visible(mainMenu6, false)
         return
     else
         open = true 
         RageUI.Visible(mainMenu6, true)
         CreateThread(function()
         while open do 
            RageUI.IsVisible(mainMenu6,function() 
              
              RageUI.Button("Ranger votre véhicule", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                  local playerPed = PlayerPedId()
      
                  if IsPedSittingInAnyVehicle(playerPed) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
            
                    if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                      ESX.ShowNotification('La voiture a été mis dans le garage')
                      ESX.Game.DeleteVehicle(vehicle)
                       
                    else
                      ESX.ShowNotification('Mais toi place conducteur, ou sortez de la voiture.')
                    end
                  else
                    local vehicle = ESX.Game.GetVehicleInDirection()
            
                    if DoesEntityExist(vehicle) then
                      ESX.ShowNotification('La voiture à été placer dans le garage.')
                      ESX.Game.DeleteVehicle(vehicle)
            
                    else
                      ESX.ShowNotification('Aucune voitures autours')
                    end
                  end
              end,})
              
              RageUI.Button("Pick-Up", nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                      local model = GetHashKey("bison3")
                      RequestModel(model)
                      while not HasModelLoaded(model) do Citizen.Wait(10) end
                      local pos = GetEntityCoords(PlayerPedId())
                      local vehicle = CreateVehicle(model, -1918.58, 2056.9, 140.74, 253.810, true, true)
                      SetVehicleCustomPrimaryColour(vehicle, 136, 14, 79)
                      SetVehicleCustomSecondaryColour(vehicle, 136, 14, 79)
                      TriggerEvent("esx:showAdvancedNotification", '~r~Vigneron', '~r~Votre véhicule de service a été sorti.', '~r~Voici la plaque : ~r~'..GetVehicleNumberPlateText(vehicle).. '\n~r~Vous avez aussi reçu les clés !', 'CHAR_LEST_MIKE_CONF', 'spawn', 8)
                      local newPlate = GenerateSocietyPlate('VIGNE')
                      SetVehicleNumberPlateText(vehicle, newPlate)
                      TriggerServerEvent('garage:RegisterNewKey', 'no', newPlate)
                      RageUI.CloseAll()
                    end
                })

                RageUI.Button("Van", nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                      local model = GetHashKey("burrito3")
                      RequestModel(model)
                      while not HasModelLoaded(model) do Citizen.Wait(10) end
                      local pos = GetEntityCoords(PlayerPedId())
                      local vehicle = CreateVehicle(model, -1918.58, 2056.9, 140.74, 253.810, true, true)
                      SetVehicleCustomPrimaryColour(vehicle, 136, 14, 79)
                      SetVehicleCustomSecondaryColour(vehicle, 136, 14, 79)
                      TriggerEvent("esx:showAdvancedNotification", '~r~Vigneron', '~r~Votre véhicule de service a été sorti.', '~r~Voici la plaque : ~r~'..GetVehicleNumberPlateText(vehicle).. '\n~r~Vous avez aussi reçu les clés !', 'CHAR_LEST_MIKE_CONF', 'spawn', 8)
                      local newPlate = GenerateSocietyPlate('VIGNE')
                      SetVehicleNumberPlateText(vehicle, newPlate)
                      TriggerServerEvent('garage:RegisterNewKey', 'no', newPlate)
                      RageUI.CloseAll()
                    end
                })

            end)
          Wait(0)
         end
      end)
   end
end

----OUVRIR LE MENU------------

local VigenPosGarage = {
	{x = -1919.97, y = 2052.96, z = 140.74}  
}

Citizen.CreateThread(function()
    while true do

      local wait = 750

        for k in pairs(VigenPosGarage) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, VigenPosGarage[k].x, VigenPosGarage[k].y, VigenPosGarage[k].z)

            if dist <= 4.0 then
            wait = 0
            DrawMarker(22, -1919.97, 2052.96, 140.74, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 136, 14, 79, 255, true, true, p19, true)  

        
            if dist <= 5.0 then
               wait = 0
                Visual.Subtitle("Appuyez sur [~r~E~w~] pour accéder au garage", 1) 
                if IsControlJustPressed(1,51) then
                  OpenGarageVigne()
            end
        end
    end
    end
    Citizen.Wait(wait)
    end
end
end)





