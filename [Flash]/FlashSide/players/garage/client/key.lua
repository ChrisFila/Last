ESX = nil 

TriggerEvent("esx:getSharedObject", function(obj)
	ESX = obj
end)

--local KeyFobHash = `p_car_keys_01`

function OpenCloseVehicle()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, false)
	local vehicle, inveh = nil, false

	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
		inveh = true
	else
		vehicle = GetClosestVehicle(coords, 7.0, 0, 71)
	end

	ESX.TriggerServerCallback('Core:requestPlayerCars', function(gotkey)
		if gotkey then
			local locked = GetVehicleDoorLockStatus(vehicle)

			--if not inveh then
				--local plyPed = PlayerPedId()

				--ESX.Streaming.RequestAnimDict("anim@mp_player_intmenu@key_fob@")

				--[[ESX.Game.SpawnObject(KeyFobHash, vector3(0.0, 0.0, 0.0), function(object)
					SetEntityCollision(object, false, false)
					AttachEntityToEntity(object, plyPed, GetPedBoneIndex(plyPed, 57005), 0.09, 0.03, -0.02, -76.0, 13.0, 28.0, false, true, true, true, 0, true)

					SetCurrentPedWeapon(plyPed, `WEAPON_UNARMED`, true)
					ClearPedTasks(plyPed)
					TaskTurnPedToFaceEntity(plyPed, vehicle, 500)

					TaskPlayAnim(plyPed, "anim@mp_player_intmenu@key_fob@", "fob_click", 3.0, 3.0, 1000, 16)
					RemoveAnimDict("anim@mp_player_intmenu@key_fob@")
					PlaySoundFromEntity(-1, "Remote_Control_Fob", vehicle, "PI_Menu_Sounds", true, 0)
					Citizen.Wait(1250)

					DetachEntity(object, false, false)
					DeleteObject(object)
				end)]]
			--end

			if locked == 1 or locked == 0 then
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				ESX.ShowAdvancedNotification('FlashSide', '~r~Clés', "Vous avez ~r~fermé~s~ le véhicule.", 'CHAR_SEALIFE', 7)
			elseif locked == 2 then
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				ESX.ShowAdvancedNotification('FlashSide', '~r~Clés', "Vous avez ~r~ouvert~s~ le véhicule.", 'CHAR_SEALIFE', 7)
			end
		else
			ESX.ShowAdvancedNotification('FlashSide', '~r~Clés', "~r~Vous n'avez pas les clés de ce véhicule.", 'CHAR_SEALIFE', 7)
		end
	end, GetVehicleNumberPlateText(vehicle))
end

RegisterCommand("vehicule_lock", function()
    OpenCloseVehicle()
end, false)
RegisterKeyMapping("vehicule_lock", "Ouvrir/Fermer Véhicule", "keyboard", 'U')