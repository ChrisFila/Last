-- REMOVE COPS PEDS
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local playerLocalisation = GetEntityCoords(playerPed)
        ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)
    end
end)

-- NO DROP PNJ 
function SetWeaponDrops()
    local handle, ped = FindFirstPed()
    local finished = false

    repeat
        if not IsEntityDead(ped) then
            SetPedDropsWeaponsWhenDead(ped, false)
        end
        finished, ped = FindNextPed(handle)
    until not finished

    EndFindPed(handle)
end

Citizen.CreateThread(function()
    while true do
        SetWeaponDrops()
        Citizen.Wait(10000)
    end
end)

--Disable all dispatches, such as medics arriving to death scenes
Citizen.CreateThread(function()
	while true do
		Wait(0)
		for i = 1, 12 do
			EnableDispatchService(i, false)
		end
		SetPlayerWantedLevel(PlayerId(), 0, false)
		SetPlayerWantedLevelNow(PlayerId(), false)
		SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
	end
end)

--makes sure that no cops are being spawned in scenarios, meaning that all npc police cars etc are no more
Citizen.CreateThread(function()
    SetCreateRandomCops(false) -- disable random cops walking/driving around
    SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning
    SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning
end)



Citizen.CreateThread(function()
    while true do
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.2) -- Dégat Cout de poing
    Wait(0)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"), 0.3) -- Dégat Matraque
    Wait(0)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SNOWBALL"), 0.3) -- Dégat Matraque
    Wait(0)
    N_0x4757f00bc6323cfe(-1553120962, 0.5) -- Dégat Véhicule
	Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        DisablePlayerVehicleRewards(PlayerId())
    end
end)

Citizen.CreateThread( function()
	local resetCounter = 0
	local jumpDisabled = false
  	
  	while true do
        Citizen.Wait(100)

		if jumpDisabled and resetCounter > 0 and IsPedJumping(PlayerPedId()) and not (GetPedParachuteState(PlayerPedId()) == 1)then
			SetPedToRagdoll(PlayerPedId(), 500, 500, 3, 0, 0, 0)
			ESX.ShowNotification("Tu t'es pris pour un kangouru à sauter comme ca?")
			resetCounter = 0
		end

		if not jumpDisabled and IsPedJumping(PlayerPedId()) then
			jumpDisabled = true
			resetCounter = 10
			Citizen.Wait(1200)
		end

		if resetCounter > 0 then
			resetCounter = resetCounter - 1
		else
			if jumpDisabled then
				resetCounter = 0
				jumpDisabled = false
			end
		end
	end
end)

