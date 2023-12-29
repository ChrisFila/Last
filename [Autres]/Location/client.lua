local display = false
local NumberCharset = {}
for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end

ESX = nil 
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("rentVehicle", function(data)
    local player = PlayerId()
	local plyId = GetPlayerServerId(PlayerId())
    ESX.TriggerServerCallback("starsLocation:rentvehicle", function(hasEnoughMoney)
        if hasEnoughMoney then
            local newPlate = GeneratePlate()
            ESX.Game.SpawnVehicle(data.vehicle, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), function(vehicle)
                SetVehicleNumberPlateText(vehicle, newPlate)
                TriggerServerEvent('esx_vehiclelock:givekey', 'no', newPlate)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end)
            SetDisplay(false)
            TriggerServerEvent("starsLocation:logs", GetPlayerName(player), tostring(plyId), data.vehicle, tostring(newPlate))
        else
            ESX.ShowNotification('Vous n\'avez pas assez d\'argent sur vous.')
            SetDisplay(false)
        end
    end, data.price)
end)

Citizen.CreateThread(function()
    while true do 
        Wait(0)
        local pedCoords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Config.Locations) do
            local dist = Vdist(pedCoords.x, pedCoords.y, pedCoords.z, v)
            if dist < Config.MarkerDistance then 
                DrawMarker(Config.MarkerType, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.4, 0.50, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, Config.MarkerColor.a, false, true, 2, true, nil, nil, false)
                if dist < 1.5 then 
                    ESX.ShowHelpNotification('Appuyez sur ~INPUT_TALK~ pour louer un véhicule')
                    if IsControlJustPressed(0, 38) then 
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then 
                            ESX.ShowNotification("~r~Veuillez quitter votre véhicule.~s~")
                        else
                            SetDisplay(true)
                        end
                    end
                end
            end
        end
    end
end)

-- Création des blips sur la map
Citizen.CreateThread(function()
    for k,v in pairs(Config.Locations) do
        blip = AddBlipForCoord(v)
        SetBlipSprite(blip, Config.BlipSprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, Config.BlipColor)
        SetBlipAsShortRange(blip, true)
	    BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.BlipName)
        EndTextCommandSetBlipName(blip)
    end
end)



function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    if Config.Blur then 
        if bool == true then 
            TriggerScreenblurFadeIn(15)
        else 
            TriggerScreenblurFadeOut(10)
        end
    end
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

function GeneratePlate()
	local generatedPlate = "LOCA"..GetRandomNumber(4)
	return generatedPlate
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end