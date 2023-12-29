
inVehicle = false
valeOn = false
left = false
local fizzPed = nil
spawnRadius = 10.0




function setCars(cars)
    SendNUIMessage({event = 'updateCars', cars = cars})
end



RegisterNUICallback('getCars', function(data)
    ESX.TriggerServerCallback('gksphone:getCars', function(data)
        for i = 1, #data do
            model = GetDisplayNameFromVehicleModel(data[i]["props"].model)
            data[i]["props"].model = model
        end
        setCars(data)
    end)
end)


RegisterNUICallback('getCarsValet', function(data)

	
    
    ESX.TriggerServerCallback('gksphone:loadVehicle', function(vehicle)

    local props = json.decode(vehicle[1].vehicle)

    if enroute then
		TriggerEvent('gksphone:notifi', {title = 'Vale', message = _U('vale_gete'), img= '/html/static/img/icons/vale.png' })
        return
    end

	local gameVehicles = ESX.Game.GetVehicles()

	for i = 1, #gameVehicles do
		local vehicle = gameVehicles[i]

        if DoesEntityExist(vehicle) then
            if ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)) == ESX.Math.Trim(props.plate) then
                local vehicleCoords = GetEntityCoords(vehicle)
                SetNewWaypoint(vehicleCoords.x, vehicleCoords.y)
				TriggerEvent('gksphone:notifi', {title = 'Vale', message = _U('vale_getr'), img= '/html/static/img/icons/vale.png' })
				return
			end

		end
		
	end

	ESX.TriggerServerCallback('gksphone:checkMoney2', function(hasEnoughMoney)
		if hasEnoughMoney == true then
			SpawnVehicle(props, props.plate)
			TriggerServerEvent('gksphone:finish')
		else

			TriggerEvent('gksphone:notifi', {title = 'Vale', message = _U('vale_checmoney'), img= '/html/static/img/icons/vale.png' })
	
		end
	end)

    end, data.plate)
    
end)



function SpawnVehicle(vehicle, plate)
	local coords = GetEntityCoords(PlayerPedId())
  	local found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(coords.x + math.random(-spawnRadius, spawnRadius), coords.y + math.random(-spawnRadius, spawnRadius), coords.z, 0, 3, 0)

    local driverhash = 999748158
    local vehhash = vehicle.model

    while not HasModelLoaded(driverhash) and RequestModel(driverhash) or not HasModelLoaded(vehhash) and RequestModel(vehhash) do
        RequestModel(driverhash)
        RequestModel(vehhash)
        Citizen.Wait(0)
    end

  	if found and HasModelLoaded(driverhash) then
		ESX.Game.SpawnVehicle(vehicle.model, {
			x = spawnPos.x,
			y = spawnPos.y,
			z = spawnPos.z + 1
		}, 180.0, function(callback_vehicle)
			fizz_veh = callback_vehicle
			ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
			SetVehRadioStation(callback_vehicle, "OFF")			
			--fizzPed = CreatePedInsideVehicle(callback_vehicle, 26, driverhash, -1, true, false) 
			mechBlip = AddBlipForEntity(callback_vehicle)
			SetBlipSprite(mechBlip, 225)                                                      	--Blip Spawning.
			SetBlipFlashes(mechBlip, true) 
			SetBlipColour(mechBlip, 0) 
			Citizen.Wait(5000)
			SetBlipFlashes(mechBlip, false)  
			ClearAreaOfVehicles(GetEntityCoords(callback_vehicle), 5000, false, false, false, false, false);  
			SetVehicleOnGroundProperly(callback_vehicle)
			inVehicle = true
			--TriggerServerEvent('garage:addKeys', plate)
			TaskVehicle(callback_vehicle)
		end)
		
		--TriggerServerEvent('gksphone:valet-car-set-outside', plate)
		valeOn = true
		
		while valeOn do
			Citizen.Wait(500)
			if IsPedInVehicle(PlayerPedId(), fizz_veh, true) then
				RemoveBlip(mechBlip)
				valeOn = false
			end
		end
  	end
end

function TaskVehicle(vehicle)
	while inVehicle do
		Citizen.Wait(750)
		local pedcoords = GetEntityCoords(PlayerPedId())
		local plycoords = GetEntityCoords(fizzPed)
		local dist = GetDistanceBetweenCoords(plycoords, pedcoords.x,pedcoords.y,pedcoords.z, false)
		
		if dist <= 25.0 then
			TaskVehicleDriveToCoord(fizzPed, vehicle, pedcoords.x, pedcoords.y, pedcoords.z, 10.0, 1, vehhash, 786603, 5.0, 1)
			SetVehicleFixed(vehicle)
			if dist <= 7.5 then
				LeaveIt(vehicle)
			else
				Citizen.Wait(500)
			end
		else
			TaskVehicleDriveToCoord(fizzPed, vehicle, pedcoords.x, pedcoords.y, pedcoords.z, 15.0, 1, vehhash, 786603, 5.0, 1)
			Citizen.Wait(500)
		end
	end
end

function LeaveIt(vehicle)
	TaskLeaveVehicle(fizzPed, vehicle, 14)
	inVehicle = false
	while IsPedInAnyVehicle(fizzPed, false) do
		Citizen.Wait(0)
	end 
	
	Citizen.Wait(500)
	TaskWanderStandard(fizzPed, 10.0, 10)
end


