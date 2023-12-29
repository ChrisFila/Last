local foodPeds = {
	-- ToolsMag
	{model = 'mp_m_shopkeep_01', voice = 'GENERIC_HI', pos = vector4(2740.23, 3462.11, 54.67, 339.76)},
	{model = 'mp_m_shopkeep_01', voice = 'GENERIC_HI', pos = vector4(2749.99, 3483.89, 54.67, 60.05)},
	-- AeroMag
	{model = 'mp_m_shopkeep_01', voice = 'GENERIC_HI', pos = vector4(-1005.1, -2764.55, 12.75, 327.63)},
	--Pute 1
	{model = 's_f_y_hooker_01', voice = 'HOOKER_OFFER_SERVICE', pos = vector4(160.84, -1304.28, 28.5, 63.72)},
	--Pute 2
	{model = 'csb_stripper_01', voice = 'HOOKER_OFFER_SERVICE', pos = vector4(163.26, -1301.13, 28.5, 61.16)},
	--Pute 3
	{model = 'csb_stripper_02', voice = 'HOOKER_OFFER_SERVICE', pos = vector4(164.44, -1297.31, 28.5, 95.82)},
	--Pute 4
	{model = 'mp_f_stripperlite', voice = 'HOOKER_OFFER_SERVICE', pos = vector4(161.19, -1304.48, 31.5, 68.48)},
	--Pute 5
	{model = 'a_m_y_musclbeac_01', voice = 'HOOKER_OFFER_SERVICE', pos = vector4(165.05, -1293.86, 28.5, 67.71)},
	--Pute 6
	{model = 'a_m_y_musclbeac_02', voice = 'HOOKER_OFFER_SERVICE', pos = vector4(165.23, -1294.28, 31.5, 67.71)},
}

local createdPeds = {}

Citizen.CreateThread(
	function()
		for k, v in ipairs(foodPeds) do
			ESX.Streaming.RequestModel(GetHashKey(v.model))

			local storePed = CreatePed(4, GetHashKey(v.model), v.pos.x, v.pos.y, v.pos.z, v.pos.w, false, false)
			SetPedRandomComponentVariation(storePed)
			SetPedRandomProps(storePed)
			SetBlockingOfNonTemporaryEvents(storePed, false)
			FreezeEntityPosition(storePed, true)
			DisablePedPainAudio(storePed, true)
			SetPedSeeingRange(storePed, 0)
			SetPedFleeAttributes(storePed, 0, 0)
			SetPedArmour(storePed, 200)
			SetPedSuffersCriticalHits(storePed, false)
			SetPedMaxHealth(storePed, 200)
			SetPedDiesWhenInjured(storePed, true)
			SetEntityInvincible(storePed, true)
			SetAmbientVoiceName(storePed, v.voice)
			TaskStartScenarioInPlace(storePed, 'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT', 0, 0)

			SetModelAsNoLongerNeeded(GetHashKey(v.model))
			table.insert(createdPeds, storePed)
		end
	end
)

-- LSPD
local lspdPeds = {
	-- lspd armurerie
	{model = 's_m_m_armoured_01', voice = 'GENERIC_HI', pos = vector4(-578.58, -114.93, 33.88 - 1, 294.95)},
	-- lspd entrée
	{model = 's_m_y_cop_01', voice = 'GENERIC_HI', pos = vector4(433.43, -985.62, 29.7, 67.64)},
	{model = 's_f_y_cop_01', voice = 'GENERIC_HI', pos = vector4(433.8, -978.41, 29.7, 67.64)}
}

Citizen.CreateThread(
	function()
		if NetworkIsHost() then
			if (not generalLoaded) then
				for k, v in ipairs(lspdPeds) do
					ESX.Streaming.RequestModel(GetHashKey(v.model))

					local lspdPed = CreatePed(7, GetHashKey(v.model), v.pos.x, v.pos.y, v.pos.z, v.pos.w, false, false)
					table.insert(createdPeds, lspdPed)
					SetPedRandomComponentVariation(lspdPed)
					SetPedRandomProps(lspdPed)
					SetEntityAsMissionEntity(lspdPed, true, true)
					FreezeEntityPosition(lspdPed, true)
					SetBlockingOfNonTemporaryEvents(lspdPed, false)
					SetPedArmour(lspdPed, 100)
					SetPedSuffersCriticalHits(lspdPed, false)
					SetPedMaxHealth(lspdPed, 100)
					SetPedDiesWhenInjured(lspdPed, false)
					SetAmbientVoiceName(lspdPed, v.voice)
					TaskStartScenarioInPlace(lspdPed, 'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT', 0, 0)
					SetPedSeeingRange(lspdPed, 15.0)

					SetModelAsNoLongerNeeded(GetHashKey(v.model))
					generalLoaded = true
				end
			end
		end
	end
)

Citizen.CreateThread(
	function()
		while true do
			Citizen.Wait(100)
			for _, ped in pairs(createdPeds) do
				if IsPedFleeing(ped) then
					ClearPedTasks(ped)
					TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT', 0, 0)
				end
			end
		end
	end
)