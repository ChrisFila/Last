ESX = nil

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


RegisterNetEvent('esx:setjob')
AddEventHandler('esx:setjob', function(job)
    ESX.PlayerData.job = job
end)


local open = false 
local mainMenu6 = RageUI.CreateMenu("", 'Véhicule')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
  open = false
end

function OpenMenuGarageGouv()
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

              RageUI.Separator("~h~↓ Véhicules ↓")

                for k,v in pairs(cfg_gouv.VehiculesBanchisseur) do
                RageUI.Button(v.buttoname, nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                        if not ESX.Game.IsSpawnPointClear(vector3(v.spawnzone.x, v.spawnzone.y, v.spawnzone.z), 10.0) then
                        ESX.ShowNotification("~r~Gouvernement\n~r~Point de spawn bloquée")
                        else
                            DoScreenFadeOut(1500)
                            Wait(1500)
                        local model = GetHashKey(v.spawnname)
                        RequestModel(model)
                        while not HasModelLoaded(model) do Wait(10) end
                        local gouviveh = CreateVehicle(model, v.spawnzone.x, v.spawnzone.y, v.spawnzone.z, v.headingspawn, true, false)
                        local newPlate = GenerateSocietyPlate('GOUV')
                        SetVehicleNumberPlateText(gouviveh, newPlate)
                        TriggerServerEvent('garage:RegisterNewKey', 'no', newPlate)
                        SetVehicleFixed(gouviveh)
                        TaskWarpPedIntoVehicle(PlayerPedId(),  gouviveh,  -1)
                        SetVehRadioStation(gouviveh, 0)
                        DoScreenFadeIn(1500)
                        Wait(1500)
                        end
                    end
                })


              end
            end)
          Wait(0)
         end
      end)
   end
end

