local hasBeenFlashedRecently = false
local blips = {}
local playerCoords = vector3(0, 0, 0)

function GetCurrentKMHSpeed()
	return GetEntitySpeed(PlayerPedId()) * 3.6
end

RegisterNetEvent('xr_speedradar:toggleRadars')
AddEventHandler('xr_speedradar:toggleRadars', function()
	if #blips == 0 then
		TriggerEvent('xr_speedradar:displayRadars')
	else
		TriggerEvent('xr_speedradar:hideRadars')
	end
end)

RegisterNetEvent('xr_speedradar:displayRadars')
AddEventHandler('xr_speedradar:displayRadars', function()
	if #blips > 0 then return end

	for RadarId,Radar in pairs(Radars.Radars) do
		local blipRadar = AddBlipForCoord(Radar.Pos)
		SetBlipAlpha(blipRadar, 120)
		SetBlipAsShortRange(blipRadar, true)
		SetBlipDisplay(blipRadar, 2)
		SetBlipSprite(blipRadar, 163)
		SetBlipColour(blipRadar, 17)
		SetBlipScale(blipRadar, 1.6)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Radar')
		EndTextCommandSetBlipName(blipRadar)
		table.insert(blips, blipRadar)
	end
end)

RegisterNetEvent('xr_speedradar:hideRadars')
AddEventHandler('xr_speedradar:hideRadars', function()
	for _, blip in pairs(blips) do
		RemoveBlip(blip)
	end
	blips = {}
end)

RegisterNetEvent('xr_speedradar:syncRadars')
AddEventHandler('xr_speedradar:syncRadars', function(destroyedRadars)
	for radarId, destroyed in pairs(destroyedRadars) do
		Radars.Radars[radarId].Destroyed = destroyed
	end
end)

Citizen.CreateThread(function()
	TriggerServerEvent('xr_speedradar:requestSyncRadars')
	while true do
		for RadarId,Radar in pairs(Radars.Radars) do
			if Radar.PropPos and #(playerCoords - Radar.PropPos) < 40 then
				if not Radar.Destroyed then
					DrawMarker(42, Radar.PropPos.x, Radar.PropPos.y, Radar.PropPos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 230, 72, 72, 150, false, false, 2, true, nil, nil, false)

					if Radar.PropPos and HasBulletImpactedInArea(Radar.PropPos.x, Radar.PropPos.y, Radar.PropPos.z - 1.0, 1.0, 1, 1) then
						TriggerServerEvent('xr_speedradar:destroyedRadar', RadarId)
					end
				else
					Draw3DText(Radar.PropPos - vector3(0, 0, 0.3), '~r~Radar détruit !', 1.0)
				end
			end
		end

		Citizen.Wait(0)
	end
end)
-- Radar System
Citizen.CreateThread(function()
	while true do
		playerCoords = GetEntityCoords(PlayerPedId(), true)

		if IsPedInAnyVehicle(PlayerPedId()) then
			for RadarId,Radar in pairs(Radars.Radars) do
				if not Radar.Destroyed and #(playerCoords - Radar.Pos) < Radar.Range then
					if GetCurrentKMHSpeed() > Radar.MinSpeed then
						if not hasBeenFlashedRecently then
							StartScreenEffect('SwitchShortMichaelIn',  400,  false)
							local Vehicle = GetVehiclePedIsIn(PlayerPedId(), true)

							if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
								local VehiclePlate = GetVehicleNumberPlateText(Vehicle)
								local VehicleModel = GetEntityModel(Vehicle)
								local VehicleModelName = GetDisplayNameFromVehicleModel(VehicleModel)

								local IsEmergencyVehicle = false

								for _,AnyModel in pairs(Radars.WhiteListedModels) do
									if AnyModel == VehicleModel then IsEmergencyVehicle = true end
								end

								if not IsEmergencyVehicle then
									hasBeenFlashedRecently = true

									ESX.TriggerServerCallback('Core:requestPlayerCars', function(gotKey)
										if gotKey then
											TriggerServerEvent('xr_speedradar:flashed', VehiclePlate, GetCurrentKMHSpeed(), VehicleModelName, RadarId)
										end
									end, VehiclePlate)

									Citizen.SetTimeout(20 * 1000, function()
										hasBeenFlashedRecently = false
									end)
								end
							end
						end
					end
				elseif #(playerCoords - Radar.Pos) < Radar.Range * 2 and #blips > 0 and GetCurrentKMHSpeed() > Radar.MinSpeed then
					ESX.ShowNotification('~r~Attention zone de radar (' .. Radar.MinSpeed .. 'km/h) !')
				end
			end
		else
			Citizen.Wait(3000)
		end

		Citizen.Wait(500)
	end
end)