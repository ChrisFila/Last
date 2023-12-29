-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local PlayerData = {}

local displayText = _U('unlocked')

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('lockedDoors:getDoorInfo', function(doorInfo, doorCount)
		for localID = 1, doorCount do
			if doorInfo[localID] ~= nil then
				cfg_door.DoorList[doorInfo[localID].doorID].locked = doorInfo[localID].state
			end
		end
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)

Citizen.CreateThread(function()
	PinInteriorInMemory(GetInteriorAtCoords(440.84, -983.14, 30.69))

	while true do
		local relance = 500
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local instaclose  = false

		for i = 1, #cfg_door.DoorList do
			local theDoor = cfg_door.DoorList[i]

			if GetDistanceBetweenCoords(plyCoords, theDoor.objCoords, true) < theDoor.distance then
				instaclose  = true
				if PlayerData.job ~= nil or PlayerData.job2 ~= nil then
					if theDoor.locked then
						displayText = _U('locked')
					else
						displayText = _U('unlocked')
					end

					if (PlayerData.job.name == theDoor.job) or (PlayerData.job2.name == theDoor.job) then
						ESX.Game.Utils.DrawText3D(theDoor.textCoords, _U('press_button') .. displayText, theDoor.size)
					else
						ESX.Game.Utils.DrawText3D(theDoor.textCoords, displayText, theDoor.size)
					end

					if IsControlJustReleased(0, 38) then
						if (PlayerData.job.name == theDoor.job) or (PlayerData.job2.name == theDoor.job) then
							theDoor.locked = not theDoor.locked
							_TriggerServerEvent('lockedDoors:updateState', i, theDoor.locked, theDoor.job)
						else
							ESX.ShowAdvancedNotification('FlashSide', '~r~Clefs', "Vous n'avez pas les clés de cette porte.", 'CHAR_SEALIFE', 7)
						end
					end
				end

				FreezeEntityPosition(GetClosestObjectOfType(theDoor.objCoords, 1.0, theDoor.objName, false, false, false), theDoor.locked)
			end
		end
		if instaclose  then
            relance = 0
        end
        Wait(relance)
	end
end)

RegisterNetEvent('lockedDoors:setState')
AddEventHandler('lockedDoors:setState', function(doorID, state)
	if type(cfg_door.DoorList[id]) ~= nil then
		cfg_door.DoorList[doorID].locked = state
	end
end)

