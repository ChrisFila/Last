ESX = nil

local playerCars = {}

fellow_conc = {
	catevehi = {},
	listecatevehi = {},
}

local derniervoituresorti = {}
local sortirvoitureacheter = {}
local CurrentAction, CurrentActionMsg, LastZone, currentDisplayVehicle, CurrentVehicleData
local CurrentActionData, Vehicles, Categories = {}, {}, {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function MenuF6Concess()
    local f6concess = FlashSideUI.CreateMenu("", "Interactions")
    FlashSideUI.Visible(f6concess, not FlashSideUI.Visible(f6concess))
    while f6concess do
        Citizen.Wait(0)
            FlashSideUI.IsVisible(f6concess, true, true, true, function()

                FlashSideUI.Separator("↓ Facture ↓")

                FlashSideUI.ButtonWithStyle("Facture",nil, {RightLabel = "→"}, true, function(_,_,s)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if s then
                        local raison = ""
                        local montant = 0
                        AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
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
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
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
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_carshop', ('Concessionnaire'), montant)
                                            TriggerEvent('esx:showAdvancedNotification', 'Fl~r~ee~s~ca ~r~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~r~'..montant.. '$ ~s~pour cette raison : ~r~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                        else
                                            ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)


                FlashSideUI.Separator("↓ Annonce ↓")



                FlashSideUI.ButtonWithStyle("Annonces d'ouverture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        TriggerServerEvent('fConcess:Ouvert')
                    end
                end)
        
                FlashSideUI.ButtonWithStyle("Annonces de fermeture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then      
                        TriggerServerEvent('fConcess:Fermer')
                    end
                end)

                end, function() 
                end)
    
                if not FlashSideUI.Visible(f6concess) then
                    f6concess = RMenu:DeleteType("Concessionnaire", true)
        end
    end
end


Keys.Register('F6', 'Concess', 'Ouvrir le menu Concessionnaire', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'carshop' then
    	MenuF6Concess()
	end
end)

function MenuConcess()
    local MConcess = FlashSideUI.CreateMenu("", "Concessionnaire")
    local MConcessSub = FlashSideUI.CreateSubMenu(MConcess, "", "Concessionnaire")
    local MConcessSub1 = FlashSideUI.CreateSubMenu(MConcess, "", "Concessionnaire")
    local MConcessSub2 = FlashSideUI.CreateSubMenu(MConcess, "", "Concessionnaire")
    MConcessSub2.Closed = function()
        supprimervehiculeconcess()
    end
    FlashSideUI.Visible(MConcess, not FlashSideUI.Visible(MConcess))
    while MConcess do
        Wait(0)
            FlashSideUI.IsVisible(MConcess, true, true, true, function()

                FlashSideUI.Separator("~r~"..ESX.PlayerData.job.grade_label.." - "..GetPlayerName(PlayerId()))


                FlashSideUI.Separator("↓ Actions véhicules ↓")

                FlashSideUI.ButtonWithStyle("Liste des véhicules", nil,  {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, MConcessSub)

			end, function()
			end)

            	FlashSideUI.IsVisible(MConcessSub, true, true, true, function()
                
					for i = 1, #fellow_conc.catevehi, 1 do
                        FlashSideUI.ButtonWithStyle("Catégorie - "..fellow_conc.catevehi[i].label, nil, {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                                nomcategorie = fellow_conc.catevehi[i].label
                                categorievehi = fellow_conc.catevehi[i].name
                                ESX.TriggerServerCallback('fellow_concess:recupererlistevehicule', function(listevehi)
                                        fellow_conc.listecatevehi = listevehi
                                end, categorievehi)
                            end
                        end, MConcessSub1)
                        end
                        end, function()
                        end)

                FlashSideUI.IsVisible(MConcessSub1, true, true, true, function()
			

                    FlashSideUI.Separator("↓ Catégorie : "..nomcategorie.." ↓")
            
                        for i2 = 1, #fellow_conc.listecatevehi, 1 do
                        FlashSideUI.ButtonWithStyle(fellow_conc.listecatevehi[i2].name, "Pour acheter ce véhicule", {RightLabel = fellow_conc.listecatevehi[i2].price.."$"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                                nomvoiture = fellow_conc.listecatevehi[i2].name
                                prixvoiture = fellow_conc.listecatevehi[i2].price
                                modelevoiture = fellow_conc.listecatevehi[i2].model
                                supprimervehiculeconcess()
                                chargementvoiture(modelevoiture)
            
                                ESX.Game.SpawnVehicle(modelevoiture, {x = -51.38, y = -1094.05, z = 26.42}, 251.959, function (vehicle)
                                table.insert(derniervoituresorti, vehicle)
                                FreezeEntityPosition(vehicle, true)
                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                SetModelAsNoLongerNeeded(modelevoiture)
                                end)
                            end
                        end, MConcessSub2)
                        
                        end
                        end, function()
                        end)

                        FlashSideUI.IsVisible(MConcessSub2, true, true, true, function()

                            FlashSideUI.Separator("~r~↓ Vendre le véhicule au joueur le plus proche ↓")

                            FlashSideUI.ButtonWithStyle("Vendre le véhicule", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                                if (Selected) then    
                                        ESX.TriggerServerCallback('fellow_concess:verifsousconcess', function(suffisantsous)
                                        if suffisantsous then
                        
                                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        
                                        if closestPlayer == -1 or closestDistance > 3.0 then
                                        ESX.ShowNotification('Personne autour')
                                        else
                                        supprimervehiculeconcess()
                                        chargementvoiture(modelevoiture)
                        
                                        ESX.Game.SpawnVehicle(modelevoiture, {x = -51.38, y = -1094.05, z = 26.42}, 251.959, function (vehicle)
                                        table.insert(sortirvoitureacheter, vehicle)
                                        FreezeEntityPosition(vehicle, true)
                                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                        SetModelAsNoLongerNeeded(modelevoiture)
                                        local plaque     = GeneratePlate()
                                        local vehicleProps = ESX.Game.GetVehicleProperties(sortirvoitureacheter[#sortirvoitureacheter])
                                        vehicleProps.plate = plaque
                                        SetVehicleNumberPlateText(sortirvoitureacheter[#sortirvoitureacheter], plaque)
                                        FreezeEntityPosition(sortirvoitureacheter[#sortirvoitureacheter], false)
                        
                                        TriggerServerEvent('fellow_concess:vendrevoiturejoueur', GetPlayerServerId(closestPlayer), vehicleProps, prixvoiture, nomvoiture)
                                        ESX.ShowNotification('Le véhicule '..nomvoiture..' avec la plaque '..vehicleProps.plate..' a été vendu à '..GetPlayerName(closestPlayer))
                                        --TriggerServerEvent('esx_vehiclelock:registerkey', vehicleProps.plate, GetPlayerServerId(closestPlayer))
                                        end)
                                        end
                                        else
                                            ESX.ShowNotification('La société n\'as pas assez d\'argent pour ce véhicule!')
                                        end
                        
                                    end, prixvoiture)
                                        end
                                    end)

                                    FlashSideUI.Separator("~r~↓ Acheter le véhicule avec l'argent de la societé ↓")

                                    FlashSideUI.ButtonWithStyle("Acheter le véhicule", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                                        if (Selected) then   
                                            ESX.TriggerServerCallback('fellow_concess:verifsousconcess', function(suffisantsous)
                                            if suffisantsous then
                                            supprimervehiculeconcess()
                                            chargementvoiture(modelevoiture)
                                            ESX.Game.SpawnVehicle(modelevoiture, {x = -51.38, y = -1094.05, z = 26.42}, 251.959, function (vehicle)
                                            table.insert(sortirvoitureacheter, vehicle)
                                            FreezeEntityPosition(vehicle, true)
                                            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                            SetModelAsNoLongerNeeded(modelevoiture)
                                            local plaque     = GeneratePlate()
                                            local vehicleProps = ESX.Game.GetVehicleProperties(sortirvoitureacheter[#sortirvoitureacheter])
                                            vehicleProps.plate = plaque
                                            SetVehicleNumberPlateText(sortirvoitureacheter[#sortirvoitureacheter], plaque)
                                            FreezeEntityPosition(sortirvoitureacheter[#sortirvoitureacheter], false)
                        
                                            TriggerServerEvent('shop:vehicule', vehicleProps, prixvoiture, nomvoiture)
                                            ESX.ShowNotification('Le véhicule '..nomvoiture..' avec la plaque '..vehicleProps.plate..' a été vendu à '..GetPlayerName(PlayerId()))
                                            --TriggerServerEvent('esx_vehiclelock:registerkey', vehicleProps.plate, GetPlayerServerId(closestPlayer))
                                            end)
                        
                                            else
                                                ESX.ShowNotification('La société n\'as pas assez d\'argent pour ce véhicule!')
                                            end
                            
                                        end, prixvoiture)
                                            end
                                        end)

                        end, function()
                        end)

              if not FlashSideUI.Visible(MConcess) and not FlashSideUI.Visible(MConcessSub) and not FlashSideUI.Visible(MConcessSub1) and not FlashSideUI.Visible(MConcessSub2) then
              MConcess = RMenu:DeleteType("MConcess", true)
        end
    end
end


Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'carshop' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'carshop' then  
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Concess.pos.menu.position.x, Concess.pos.menu.position.y, Concess.pos.menu.position.z)
            if jobdist <= 10.0 and Concess.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Concess.pos.menu.position.x, Concess.pos.menu.position.y, Concess.pos.menu.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        FlashSideUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour accéder au menu", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            ESX.TriggerServerCallback('fellow_concess:recuperercategorievehicule', function(catevehi)
                                fellow_conc.catevehi = catevehi
                            end)
                            MenuConcess()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)


function supprimervehiculeconcess()
	while #derniervoituresorti > 0 do
		local vehicle = derniervoituresorti[1]

		ESX.Game.DeleteVehicle(vehicle)
		table.remove(derniervoituresorti, 1)
	end
end

function chargementvoiture(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName('Chargement du véhicule')
		EndTextCommandBusyString(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
			DisableAllControlActions(0)
		end

		RemoveLoadingPrompt()
	end
end