Citizen.CreateThread(function()
	while true do
		local _, _, _, hour, minute = GetUtcTime()
		NetworkOverrideClockTime(hour, minute, 0)
		Citizen.Wait(60000)
	end
end)

local safeZones = {
	vector3(-821.2, -127.65, 28.18),
	vector3(218.76, -802.87, 30.09),
	vector3(429.54, -981.86, 30.71),
	vector3(233.12, -419.19, -118.2), 
	vector3(245.5, -324.2, -118.77),
	vector3(-38.22, -1100.84, 26.42),
	vector3(238.25, -406.03, 47.92), 
	vector3(295.68, -586.45, 43.14),
	vector3(-211.34, -1322.06, 30.89),
	vector3(1642.58, 2569.52, 45.56), 
	vector3(207.88, -190.37, 54.6),
	vector3(-1384.82, -591.79, 30.32), 
	vector3(482.998, 4812.112, -58.384),
	vector3(-1418.713, -447.427, 35.909),
}

local disabledSafeZonesKeys = {
	{group = 2, key = 37, message = '~r~Vous ne pouvez pas sortir d\'arme en SafeZone'},
	{group = 0, key = 24, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'},
	{group = 0, key = 69, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'},
	{group = 0, key = 92, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'},
	{group = 0, key = 106, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'},
	{group = 0, key = 168, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'},
	{group = 0, key = 160, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'},
	{group = 0, key = 160, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'},

}

local notifIn, notifOut = false, false
local closestZone = 1

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	while true do
		local plyPed = PlayerPedId()
		local plyCoords = GetEntityCoords(plyPed, false)
		local minDistance = 100000

		for i = 1, #safeZones, 1 do
			local dist = #(safeZones[i] - plyCoords)

			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end

		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	while true do
		local plyPed = PlayerPedId()
		local plyCoords = GetEntityCoords(plyPed, false)
		local dist = #(safeZones[closestZone] - plyCoords)

		if dist <= 100 then
			Wait(0)
		else
			Wait(750)
		end

		if dist <= 100 and ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'gouvernement' and ESX.PlayerData.job.name ~= 'ambulance' then
			if not notifIn then
				NetworkSetFriendlyFireOption(false)
				SetCurrentPedWeapon(plyPed, `WEAPON_UNARMED`, true)
				ESX.ShowAdvancedNotification("FlashSide", "~r~ZoneSafe", "~s~Vous êtes en ~g~SafeZone", 'CHAR_SEALIFE', 7)

				notifIn = true
				notifOut = false
			end
		else
			if not notifOut then
				NetworkSetFriendlyFireOption(true)
				ESX.ShowAdvancedNotification("FlashSide", "~r~ZoneSafe", "~s~Vous n\'êtes plus en ~r~SafeZone", 'CHAR_SEALIFE', 7)

				notifOut = true
				notifIn = false
			end
		end

		if notifIn then

			DisablePlayerFiring(player, true)

			for i = 1, #disabledSafeZonesKeys, 1 do
				DisableControlAction(disabledSafeZonesKeys[i].group, disabledSafeZonesKeys[i].key, true)

				if IsDisabledControlJustPressed(disabledSafeZonesKeys[i].group, disabledSafeZonesKeys[i].key) then
					SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)

					if disabledSafeZonesKeys[i].message then
						ESX.ShowAdvancedNotification("FlashSide", "~r~ZoneSafe", disabledSafeZonesKeys[i].message, 'CHAR_SEALIFE', 7)
					end
				end
			end
		end
	end
end)

function GetSafeZone()
	return notifIn
end