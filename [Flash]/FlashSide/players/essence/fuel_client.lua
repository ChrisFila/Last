ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(500)
	end
end)

local isNearPump = false
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local currentCash = 1000
local fuelSynced = false
local inBlacklisted = false

function GetFuel(vehicle)
	return DecorGetFloat(vehicle, FuelDecorFuel)
end

function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, FuelDecorFuel, GetVehicleFuelLevel(vehicle))
	end
end

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

local GasStations = {
	{x = 49.4187, y = 2778.793, z = 58.043},
	{x = 263.894, y = 2606.463, z = 44.983},
	{x = 1039.958, y = 2671.134, z = 39.550},
	{x = 1207.260, y = 2660.175, z = 37.899},
	{x = 2539.685, y = 2594.192, z = 37.944},
	{x = 2679.858, y = 3263.946, z = 55.240},
	{x = 2005.055, y = 3773.887, z = 32.403},
	{x = 1687.156, y = 4929.392, z = 42.078},
	{x = 1701.314, y = 6416.028, z = 32.763},
	{x = 179.857, y = 6602.839, z = 31.868},
	{x = -94.4619, y = 6419.594, z = 31.489},
	{x = -2554.996, y = 2334.40, z = 33.078},
	{x = -1800.375, y = 803.661, z = 138.651},
	{x = -1437.622, y = -276.747, z = 46.207},
	{x = -2096.243, y = -320.286, z = 13.168},
	{x = -724.619, y = -935.1631, z = 19.213},
	{x = -526.019, y = -1211.003, z = 18.184},
	{x = -70.2148, y = -1761.792, z = 29.534},
	{x = 265.648, y = -1261.309, z = 29.292},
	{x = 819.653, y = -1028.846, z = 26.403},
	{x = 1208.951, y = -1402.567,z = 35.224},
	{x = 1181.381, y = -330.847, z = 69.316},
	{x = 620.843, y = 269.100, z = 103.089},
	{x = 2581.321, y = 362.039, z = 108.468},
	{x = 176.631, y = -1562.025, z = 29.263},
	{x = 176.631, y = -1562.025, z = 29.263},
	{x = -319.292, y = -1471.715, z = 30.549},
	{x = 1784.324, y = 3330.55, z = 41.253}
}

Citizen.CreateThread(function()
    for k in pairs(GasStations) do
       local GasStationsBlips = AddBlipForCoord(GasStations[k].x, GasStations[k].y, GasStations[k].z)
       SetBlipSprite(GasStationsBlips, 415)
       SetBlipColour(GasStationsBlips, 1)
       SetBlipScale(GasStationsBlips, 0.6)
       SetBlipAsShortRange(GasStationsBlips, true)

       BeginTextCommandSetBlipName('STRING')
       AddTextComponentString("Station Essence")
       EndTextCommandSetBlipName(GasStationsBlips)
   end
end)

function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function FindNearestFuelPump()
	local coords = GetEntityCoords(PlayerPedId())
	local fuelPumps = {}
	local handle, object = FindFirstObject()
	local success
	repeat
		if PumpModelsFuel[GetEntityModel(object)] then
			table.insert(fuelPumps, object)
		end
	success, object = FindNextObject(handle, object)
	until not success
	EndFindObject(handle)
	local pumpObject = 0
	local pumpDistance = 1000

	for _, fuelPumpObject in pairs(fuelPumps) do
		local dstcheck = GetDistanceBetweenCoords(coords, GetEntityCoords(fuelPumpObject))

		if dstcheck < pumpDistance then
			pumpDistance = dstcheck
			pumpObject = fuelPumpObject
		end
	end

	return pumpObject, pumpDistance
end

function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, FuelDecorFuel) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))

		fuelSynced = true
	end
	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (ClassesVeh[GetVehicleClass(vehicle)] or 1.0) / 10)
	end
end

CreateThread(function()
	DecorRegister(FuelDecorFuel, 1)

	for index = 1, #BlacklistVehiculeFuel do
		if type(BlacklistVehiculeFuel[index]) == 'string' then
			BlacklistVehiculeFuel[GetHashKey(BlacklistVehiculeFuel[index])] = true
		else
			BlacklistVehiculeFuel[BlacklistVehiculeFuel[index]] = true
		end
	end

	for index = #BlacklistVehiculeFuel, 1, -1 do
		table.remove(BlacklistVehiculeFuel, index)
	end

	while true do
		Wait(1000)
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)

			if BlacklistVehiculeFuel[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end

			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end
			if inBlacklisted then
				inBlacklisted = false
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(250)
		local pumpObject, pumpDistance = FindNearestFuelPump()
		if pumpDistance < 2.5 then
			isNearPump = pumpObject
			if UseESXFuelll then
				currentCash = ESX.GetPlayerData().money
			end
		else
			isNearPump = false
			Wait(math.ceil(pumpDistance * 20))
		end
	end
end)

AddEventHandler('fuel:startFuelUpTick', function(pumpObject, ped, vehicle)
	currentFuel = GetVehicleFuelLevel(vehicle)

	while isFueling do
		Citizen.Wait(500)

		local oldFuel = DecorGetFloat(vehicle, FuelDecorFuel)
		local fuelToAdd = math.random(10, 20) / 10.0
		local extraCost = fuelToAdd / 1.5 * CostMultiplierFuel

		if not pumpObject then
			if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100 >= 0 then
				currentFuel = oldFuel + fuelToAdd

				SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100))
			else
				isFueling = false
			end
		else
			currentFuel = oldFuel + fuelToAdd
		end

		if currentFuel > 100.0 then
			currentFuel = 100.0
			isFueling = false
		end

		currentCost = currentCost + extraCost

		if currentCash >= currentCost then
			SetFuel(vehicle, currentFuel)
		else
			isFueling = false
		end
	end
	if pumpObject then
		TriggerServerEvent('fuel:pay', currentCost)
	end
	currentCost = 0.0
end)

RegisterCommand('setfuel', function(src, args, raw)
	getUserGroup()
	if tostring(PlyGroup) == "admin" or tostring(PlyGroup) == "superadmin" then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), -1)
		if tonumber(args[1]) ~= nil then
			SetFuel(vehicle, tonumber(args[1]))
			Notif("Tu as mis " ..tostring(args[1]).. " d'essence")
		end
	else
		print("tu n'a pas les permissions nécéssaires")
	end
end)

AddEventHandler('fuel:refuelFromPump', function(pumpObject, ped, vehicle)
	local coordsPump = GetEntityCoords(pumpObject)
	local pumpHeading = GetEntityHeading(pumpObject)
	local posNPC = GetOffsetFromEntityInWorldCoords(ped, 0.0, -4.5, 0.0)
	local vehicleHeading = GetEntityHeading(ped)
	local pedNpc = nil
	if DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
		local modelped = GetHashKey('a_m_m_hillbilly_01')
		RequestModel(modelped)
		while not HasModelLoaded(modelped) do
			Citizen.Wait(100)
		end
		pedNpc = CreatePed(5, modelped, (coordsPump.x + posNPC.x) / 2, (coordsPump.y + posNPC.y) / 2, (coordsPump.z + posNPC.z) / 2, vehicleHeading, true, false)
		ped = pedNpc
		RequestAnimDict("mp_character_creation@lineup@male_a")
		Citizen.Wait(100)
		TaskPlayAnim(ped, "mp_character_creation@lineup@male_a", "intro", 1.0, 1.0, 5900, 0, 1, 0, 0, 0)
		Citizen.Wait(3000)
		RequestAnimDict("mp_character_creation@customise@male_a")
		Citizen.Wait(100)
		TaskPlayAnim(ped, "mp_character_creation@customise@male_a", "loop", 1.0, 1.0, -1, 0, 1, 0, 0, 0)
	end
		TaskTurnPedToFaceEntity(ped, vehicle, 2000)
		Wait(2000)
		SetCurrentPedWeapon(ped, -1569615261, true)
		LoadAnimDict("timetable@gardener@filling_can")
		TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		TriggerEvent('fuel:startFuelUpTick', pumpObject, ped, vehicle)
	while isFueling do
		for _, controlIndex in pairs(DisableKeysFuells) do
			DisableControlAction(0, controlIndex)
		end
		local vehicleCoords = GetEntityCoords(vehicle)

		if pumpObject then
			local stringCoords = GetEntityCoords(pumpObject)
			local extraString = ""

			if UseESXFuelll then
				extraString = "\n" .. StringsLocalFuel.TotalCost .. ": ~r~$" .. Round(currentCost, 1)
			end

			DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, StringsLocalFuel.CancelFuelingPump .. extraString)
			DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, Round(currentFuel, 1) .. "%")
		else
			DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, StringsLocalFuel.CancelFuelingJerryCan .. "\nBidon d'essence: ~r~" .. Round(GetAmmoInPedWeapon(ped, 883325847) / 4500 * 100, 1) .. "% | Véhicule: " .. Round(currentFuel, 1) .. "%")
		end

		if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		end

		if IsControlJustReleased(0, 38) or (isNearPump and GetEntityHealth(pumpObject) <= 0) then
			isFueling = false
		end
		Wait(0)
	end

	ClearPedTasks(ped)
	RemoveAnimDict("timetable@gardener@filling_can")
	Wait(2000)
	if pedNpc ~= nil then
		DeleteEntity(ped)
	end
end)

CreateThread(function()
	while true do
		local ped = PlayerPedId()

		if not isFueling and ((isNearPump and GetEntityHealth(isNearPump) > 0) or (GetSelectedPedWeapon(ped) == 883325847 and not isNearPump)) then
			if false then
				local pumpCoords = GetEntityCoords(isNearPump)

				DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, StringsLocalFuel.ExitVehicle)
			else
				local vehicle = GetPlayersLastVehicle()
				local vehicleCoords = GetEntityCoords(vehicle)

				if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped), vehicleCoords) < 4.5 then
					if true then
						local stringCoords = GetEntityCoords(isNearPump)
						local canFuel = true

						if GetSelectedPedWeapon(ped) == 883325847 then
							stringCoords = vehicleCoords

							if GetAmmoInPedWeapon(ped, 883325847) < 100 then
								canFuel = false
							end
						end

						if GetVehicleFuelLevel(vehicle) < 95 and canFuel then
							if currentCash > 0 then
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, StringsLocalFuel.EToRefuel)

								if IsControlJustReleased(0, 38) then
									isFueling = true
									
									TriggerEvent('fuel:refuelFromPump', isNearPump, ped, vehicle)
									LoadAnimDict("timetable@gardener@filling_can")
								end
							else
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, StringsLocalFuel.NotEnoughCash)
							end
						elseif not canFuel then
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, StringsLocalFuel.JerryCanEmpty)
						else
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, StringsLocalFuel.FullTank)
						end
					end
				elseif isNearPump then
					local stringCoords = GetEntityCoords(isNearPump)

					if currentCash >= JerryCanCostFuel then
						if not HasPedGotWeapon(ped, 883325847) then
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, StringsLocalFuel.PurchaseJerryCan)

							if IsControlJustReleased(0, 38) then
								GiveWeaponToPed(ped, 883325847, 4500, false, true)

								TriggerServerEvent('fuel:pay', JerryCanCostFuel)

								currentCash = ESX.GetPlayerData().money
							end
						else
							if UseESXFuelll then
								local refillCost = Round(RefillCostFuell * (1 - GetAmmoInPedWeapon(ped, 883325847) / 4500))

								if refillCost > 0 then
									if currentCash >= refillCost then
										DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, StringsLocalFuel.RefillJerryCan .. refillCost)

										if IsControlJustReleased(0, 38) then
											TriggerServerEvent('fuel:pay', refillCost)

											SetPedAmmo(ped, 883325847, 4500)
										end
									else
										DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, StringsLocalFuel.NotEnoughCashJerryCan)
									end
								else
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, StringsLocalFuel.JerryCanFull)
								end
							else
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, StringsLocalFuel.RefillJerryCan)

								if IsControlJustReleased(0, 38) then
									SetPedAmmo(ped, 883325847, 4500)
								end
							end
						end
					else
						DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, StringsLocalFuel.NotEnoughCash)
					end
				else
					Wait(250)
				end
			end
		else
			Wait(250)
		end
		Wait(0)
	end
end)