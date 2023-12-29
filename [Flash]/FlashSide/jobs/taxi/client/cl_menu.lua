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


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


-- MENU FUNCTION --

local open = false 
local mainMenu8 = RageUI.CreateMenu('', '~r~Interaction')
local subMenu8 = RageUI.CreateSubMenu(mainMenu8, "", "~r~Interaction")
mainMenu8.Display.Header = true 
mainMenu8.Closed = function()
  open = false
end

function OpenMenuTaxi()
	if open then 
		open = false
		RageUI.Visible(mainMenu8, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu8, true)
		CreateThread(function()
		while open do 
		   RageUI.IsVisible(mainMenu8,function() 

			RageUI.Separator("~r~↓ Annonces ↓				 ")
			RageUI.Button("Annonces", nil, {RightLabel = "→→"}, true , {
				onSelected = function()
				end
			}, subMenu8)

			
			RageUI.Separator("~r~↓ Factures ↓")
			RageUI.Button("Faire une Facture", nil, {RightLabel = "→→"}, true , {
				onSelected = function()
					local player, distance = ESX.Game.GetClosestPlayer()
						local raison = ""
						local montant = 0
						AddTextEntry("FMMC_MPM_NA", "Raison de la facture")
						DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez une raison de la facture:", "", "", "", "", 30)
						while (UpdateOnscreenKeyboard() == 0) do
							DisableAllControlActions(0)
							Wait(0)
						end
						if (GetOnscreenKeyboardResult()) then
							local result = GetOnscreenKeyboardResult()
							if result then
								raison = result
								result = nil
								AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
								DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le montant de la facture:", "", "", "", "", 30)
								while (UpdateOnscreenKeyboard() == 0) do
									DisableAllControlActions(0)
									Wait(0)
								end
								if (GetOnscreenKeyboardResult()) then
									result = GetOnscreenKeyboardResult()
									if result then
										montant = result
										result = nil
										if player ~= -1 and distance <= 3.0 then
											TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_taxi', ('taxi'), montant)
											TriggerEvent('esx:showAdvancedNotification', 'Fl~r~ee~s~ca ~r~Banque', 'Facture envoyée : ', 'Vous avez envoyé une facture de : ~r~'..montant.. ' $ ~s~pour : ~r~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
										else
											ESX.ShowNotification("~r~Problèmes~s~: Aucun joueur à proximitée")
										end
									end
								end
								
						  --  end
						end
						end
				end
			})

			RageUI.Separator("~r~↓ Mission ↓")
			RageUI.Button("Commencer une mission PNJ", nil, {RightLabel = "→→"}, true , {
				onSelected = function()
				StartTaxiMission()
				end
			})

			end)



			RageUI.IsVisible(subMenu8,function() 

			 RageUI.Button("Annonce Ouvertures", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					TriggerServerEvent('Ouvre:taxi')
				end
			})

			RageUI.Button("Annonce Fermetures", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					TriggerServerEvent('Ferme:taxi')
				end
			})

		   end)
		 Wait(0)
		end
	 end)
  end
end

-- OUVERTURE DU MENU --

Keys.Register('F6', 'taxi', 'Ouvrir le menu taxi', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
    	OpenMenuTaxi()
	end
end)


-- Mission 

local possible_mission = {
	vector3(293.5, -590.2, 42.7),
	vector3(253.4, -375.9, 44.1),
	vector3(120.8, -300.4, 45.1),
	vector3(-38.4, -381.6, 38.3),
	vector3(-107.4, -614.4, 35.7),
	vector3(-252.3, -856.5, 30.6),
	vector3(-236.1, -988.4, 28.8),
	vector3(-277.0, -1061.2, 25.7),
	vector3(-576.5, -999.0, 21.8),
	vector3(-602.8, -952.6, 21.6),
	vector3(-790.7, -961.9, 14.9),
	vector3(-912.6, -864.8, 15.0),
	vector3(-1069.8, -792.5, 18.8),
	vector3(-1306.9, -854.1, 15.1),
	vector3(-1468.5, -681.4, 26.2),
	vector3(-1380.9, -452.7, 34.1),
	vector3(-1326.3, -394.8, 36.1),
	vector3(-1383.7, -270.0, 42.5),
	vector3(-1679.6, -457.3, 39.4),
	vector3(-1812.5, -416.9, 43.7),
	vector3(-2043.6, -268.3, 23.0),
	vector3(-2186.4, -421.6, 12.7),
	vector3(-1862.1, -586.5, 11.2),
	vector3(-1859.5, -617.6, 10.9),
	vector3(-1635.0, -988.3, 12.6),
	vector3(-1284.0, -1154.2, 5.3),
	vector3(-1126.5, -1338.1, 4.6),
	vector3(-867.9, -1159.7, 5.0),
	vector3(-847.5, -1141.4, 6.3),
	vector3(-722.6, -1144.6, 10.2),
	vector3(-575.5, -318.4, 34.5),
	vector3(-592.3, -224.9, 36.1),
	vector3(-559.6, -162.9, 37.8),
	vector3(-535.0, -65.7, 40.6),
	vector3(-758.2, -36.7, 37.3),
	vector3(-1375.9, 21.0, 53.2),
	vector3(-1320.3, -128.0, 48.1),
	vector3(-1285.7, 294.3, 64.5),
	vector3(-1245.7, 386.5, 75.1),
	vector3(-760.4, 285.0, 85.1),
	vector3(-626.8, 254.1, 81.1),
	vector3(-563.6, 268.0, 82.5),
	vector3(-486.8, 272.0, 82.8),
	vector3(88.3, 250.9, 108.2),
	vector3(234.1, 344.7, 105.0),
	vector3(435.0, 96.7, 99.2),
	vector3(482.6, -142.5, 58.2),
	vector3(762.7, -786.5, 25.9),
	vector3(809.1, -1290.8, 25.8),
	vector3(490.8, -1751.4, 28.1),
	vector3(432.4, -1856.1, 27.0),
	vector3(164.3, -1734.5, 28.9),
	vector3(-57.7, -1501.4, 31.1),
	vector3(52.2, -1566.7, 29.0),
	vector3(310.2, -1376.8, 31.4),
	vector3(182.0, -1332.8, 28.9),
	vector3(-74.6, -1100.6, 25.7),
	vector3(-887.0, -2187.5, 8.1),
	vector3(-749.6, -2296.6, 12.5),
	vector3(-1064.8, -2560.7, 19.7),
	vector3(-1033.4, -2730.2, 19.7),
	vector3(-1018.7, -2732.0, 13.3),
	vector3(797.4, -174.4, 72.7),
	vector3(508.2, -117.9, 60.8),
	vector3(159.5, -27.6, 67.4),
	vector3(-36.4, -106.9, 57.0),
	vector3(-355.8, -270.4, 33.0),
	vector3(-831.2, -76.9, 37.3),
	vector3(-1038.7, -214.6, 37.0),
	vector3(1918.4, 3691.4, 32.3),
	vector3(1820.2, 3697.1, 33.5),
	vector3(1619.3, 3827.2, 34.5),
	vector3(1418.6, 3602.2, 34.5),
	vector3(1944.9, 3856.3, 31.7),
	vector3(2285.3, 3839.4, 34.0),
	vector3(2760.9, 3387.8, 55.7),
	vector3(1952.8, 2627.7, 45.4),
	vector3(1051.4, 474.8, 93.7),
	vector3(866.4, 17.6, 78.7),
	vector3(319.0, 167.4, 103.3),
	vector3(88.8, 254.1, 108.2),
	vector3(-44.9, 70.4, 72.4),
	vector3(-115.5, 84.3, 70.8),
	vector3(-384.8, 226.9, 83.5),
	vector3(-578.7, 139.1, 61.3),
	vector3(-651.3, -584.9, 34.1),
	vector3(-571.8, -1195.6, 17.9),
	vector3(-1513.3, -670.0, 28.4),
	vector3(-1297.5, -654.9, 26.1),
	vector3(-1645.5, 144.6, 61.7),
	vector3(-1160.6, 744.4, 154.6),
	vector3(-798.1, 831.7, 204.4)
}

local possible_ped = {
	"a_f_m_skidrow_01",
	"a_f_m_tramp_01",
	"a_f_m_soucent_01",
	"a_f_y_femaleagent",
	"a_f_y_eastsa_03",
	"a_f_y_genhot_01",
	"a_f_y_vinewood_03",
	"a_f_y_vinewood_04",
	"a_f_y_yoga_01",
	"a_m_m_business_01",
	"a_m_m_bevhills_02",
	"a_m_m_golfer_01",
	"a_m_m_eastsa_02",
	"a_m_m_soucent_04",
	"a_m_m_socenlat_01",
	"a_m_y_bevhills_02",
	"a_m_y_bevhills_01",
	"a_m_y_beachvesp_02",
	"a_m_y_business_02",
	"a_m_y_busicas_01",
	"a_m_y_business_01",
	"a_m_y_clubcust_01"
}

local blips = {}
local inMission = false
local npc_mission = {}

function GetRandomPos()
	return possible_mission[math.random(1, #possible_mission)]
end

function GetRandomPed()
	return possible_ped[math.random(1, #possible_ped)]
end

function FinishMission()
	for k, v in pairs(blips) do
		RemoveBlip(v)
	end

	for k, v in pairs(npc_mission) do
		DeleteEntity(v)
	end
	npc_mission = {}
	blips = {}
	inMission = false
end

function StartTaxiMission()
	if inMission then
		inMission = false
		return
	else
		Citizen.CreateThread(
			function()
				inMission = true
				local pPed = GetPlayerPed(-1)
				local pCoords = GetEntityCoords(pPed)

				local pos = GetRandomPos()
				local ped = GetRandomPed()

				local dst = GetDistanceBetweenCoords(pCoords, pos, true)

				PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)
				TriggerEvent(
					"esx:showNotification",
					"~o~Demande de transport.",
					"Une mission vous à été attribué! Regarder votre GPS!",
					"CHAR_CHAT_CALL",
					5000,
					"danger"
				)

				local blip = AddBlipForCoord(pos)
				table.insert(blips, blip)
				SetBlipScale(blip, 1.2)
				SetBlipRoute(blip, true)

				while dst > 60.0 and inMission do
					pCoords = GetEntityCoords(pPed)
					dst = GetDistanceBetweenCoords(pCoords, pos, true)
					Visual.Subtitle("Allez sur la zone GPS", 500)
					Wait(500)
				end

				if not inMission then
					FinishMission()
					return
				end

				local model = GetHashKey(ped)
				RequestModel(model)
				while not HasModelLoaded(model) do
					Wait(1)
				end

				local ped = CreatePed(1, model, pos, 50.0, 0, 1)
				table.insert(npc_mission, ped)
				TaskSetBlockingOfNonTemporaryEvents(ped, true)

				while dst > 10.0 and inMission do
					pCoords = GetEntityCoords(pPed)
					dst = GetDistanceBetweenCoords(pCoords, pos, true)
					Visual.Subtitle("Approchez vous du client", 500)
					Wait(500)
				end

				if not inMission then
					FinishMission()
					return
				end

				TaskEnterVehicle(ped, GetVehiclePedIsIn(pPed, false), 10000, 2, 2.0, 1, 0)
				while not IsPedInAnyVehicle(ped, false) and inMission do
					Wait(1)
					Visual.Subtitle("Attendre le client", 500)
					Wait(500)
				end

				if not inMission then
					FinishMission()
					return
				end

				local posToGo = GetRandomPos()
				while posToGo == pos do
					posToGo = GetRandomPos()
					Wait(1)
				end

				local bonus = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), posToGo, true) / 10

				SetBlipCoords(blip, posToGo)
				SetBlipRoute(blip, true)

				local dst = GetDistanceBetweenCoords(pCoords, posToGo, true)
				while dst > 10.0 and inMission do
					pCoords = GetEntityCoords(pPed)
					dst = GetDistanceBetweenCoords(pCoords, posToGo, true)
					Visual.Subtitle("Allez-la ou le client vous à demandé", 500)
					Wait(500)
				end

				while GetEntitySpeed(pPed) > 3 do
					Wait(500)
					Visual.Subtitle("Stopper le véhicule", 500)
				end

				TaskLeaveAnyVehicle(ped, 1, 1)
				while IsPedInAnyVehicle(ped, false) do
					Wait(500)
				end
				TaskWanderStandard(ped, 99999999.0, 10)

				if not inMission then
					FinishMission()
					return
				end
				TriggerServerEvent("taxi:FinishMission", Round(bonus, 1))

				Wait(5000)
				FinishMission()
			end
		)
	end
end

