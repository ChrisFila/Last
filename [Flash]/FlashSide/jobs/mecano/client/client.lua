ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

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

 Citizen.CreateThread(function()
    while true do 
       Citizen.Wait(500)
       if VarColor == "~r~" then VarColor = "~s~" else VarColor = "~r~" end 
   end 
end)


 
 -- MENU
 local mainMenu = RageUI.CreateMenu("", "MENU MECANO") 
 local MenuVehicule = RageUI.CreateSubMenu(mainMenu, "", "MENU") 
 local annoncemenu = RageUI.CreateSubMenu(mainMenu, "", "MENU")


 local open = false
 
 mainMenu.X = 0 
 mainMenu.Y = 0
 
 mainMenu.Closed = function() 
     open = false 
 end 
 
 function menumecano()
     if open then 
         open = false 
             RageUI.Visible(mainMenu, false) 
             return 
     else 
         open = true 
             RageUI.Visible(mainMenu, true)
         Citizen.CreateThread(function()
             while open do 
                 RageUI.IsVisible(mainMenu, function()
                    RageUI.Checkbox("Prendre son service Mécano", nil, serviceMecano, {}, {
                        onChecked = function(index, items)
                            serviceMecano = true
                            TriggerServerEvent('benny:prisedeservice')
                            ESX.ShowNotification("~r~Vous avez pris votre service !")
                        end,
                        onUnChecked = function(index, items)
                            serviceMecano = false
                            TriggerServerEvent('benny:prisedeservice')
                            ESX.ShowNotification("~r~Vous avez quitter votre service !")
                        end
                    })

                 if serviceMecano then

                    RageUI.Separator(VarColor.."↓ Option ↓") 

                       RageUI.Button("Intéraction Véhicule", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                        end
                       }, MenuVehicule)

                       RageUI.Button("Facture", nil, {RightLabel = "→→"}, true, {
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
													TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_mecano', ('mecano'), montant)
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
                       RageUI.Button("Annonce", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                        end
                       }, annoncemenu)
                    end       
            end)

            RageUI.IsVisible(MenuVehicule, function()

                RageUI.Separator(VarColor.."↓ Intéraction Véhicule ↓") 
                RageUI.Button("Faire une réparation", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Vous ne pouvez pas faire cette action depuis un véhicule", 'CHAR_CARSITE3', 7)
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(20000)

					SetVehicleFixed(vehicle)
					SetVehicleDeformationFixed(vehicle)
					SetVehicleUndriveable(vehicle, false)
					SetVehicleEngineOn(vehicle, true, true)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Réparation ~h~~r~Terminer", 'CHAR_CARSITE3', 7)
					isBusy = false
				end)
			else
				ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Aucun véhicule à proximité", 'CHAR_CARSITE3', 7)
			end
                    end
                   })

                RageUI.Button("Nettoyer le véhicule", nil, {RightLabel = "→→"}, true, {
                 onSelected = function()
                    local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Vous ne pouvez pas faire cette action depuis un véhicule", 'CHAR_CARSITE3', 7)
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)

					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Nettoyage ~h~~r~Terminer ", 'CHAR_CARSITE3', 7)
					isBusy = false
				end)
			else
				ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Aucun véhicule à proximité", 'CHAR_CARSITE3', 7)
			end
                  end
                })

                RageUI.Button("Procédure de mise en fourrière", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        local playerPed = PlayerPedId()


			if IsPedSittingInAnyVehicle(playerPed) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)

				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
                Citizen.Wait(6500)
                ClearPedTasks(playerPed)
                Citizen.Wait(2500)
                ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Mise en fourrière ~h~~r~Terminer", 'CHAR_CARSITE3', 7)
                ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Vous devez être sur la place conducteur !", 'CHAR_CARSITE3', 7)
				end
			else
				local vehicle = ESX.Game.GetVehicleInDirection()

				if DoesEntityExist(vehicle) then
                    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
                    Citizen.Wait(6500)
                    ClearPedTasks(playerPed)
                    Citizen.Wait(4000)
                    ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Mise en fourrière ~h~~r~Terminer", 'CHAR_CARSITE3', 7)
					ESX.Game.DeleteVehicle(vehicle)
				else
					ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Vous devez être prêt d'un véhicule pour commencer la mise en fourrière", 'CHAR_CARSITE3', 7)
				end
			end
                    end 
                })

                RageUI.Button("Crocheter le véhicule", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        local playerPed = PlayerPedId()
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Vous ne pouvez pas faire cette action depuis un véhicule", 'CHAR_CARSITE3', 7)
				return
			end

			if DoesEntityExist(vehicle) then
				isBusy = true
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)

					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)

					ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Crochetage ~h~~r~Terminer", 'CHAR_CARSITE3', 7)
					isBusy = false
				end)
			else
				ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Aucun véhicule à proximité", 'CHAR_CARSITE3', 7)
			end
                    end
                })

                RageUI.Separator(VarColor.."↓ Intération dépanneuse ↓") 

                RageUI.Button("Mettre / enlever le véhicule du plateau", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        local playerPed = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(playerPed, true)
	
				local towmodel = GetHashKey('flatbed')
				local isVehicleTow = IsVehicleModel(vehicle, towmodel)
	
				if isVehicleTow then
					local targetVehicle = ESX.Game.GetVehicleInDirection()
	
					if CurrentlyTowedVehicle == nil then
						if targetVehicle ~= 0 then
							if not IsPedInAnyVehicle(playerPed, true) then
								if vehicle ~= targetVehicle then
                                    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                                    Citizen.Wait(10000)
                                    ClearPedTasksImmediately(playerPed)
									AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
									CurrentlyTowedVehicle = targetVehicle
									ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Vous venez d'attacher le véhicule avec ~h~~r~succés !", 'CHAR_CARSITE3', 7)
	
									if NPCOnJob then
										if NPCTargetTowable == targetVehicle then
											ESX.ShowNotification(_U('please_drop_off'))
											cfg_mecano.Zones.VehicleDelivery.Type = 1
	
											if Blips['NPCTargetTowableZone'] then
												RemoveBlip(Blips['NPCTargetTowableZone'])
												Blips['NPCTargetTowableZone'] = nil
											end
	
											Blips['NPCDelivery'] = AddBlipForCoord(cfg_mecano.Zones.VehicleDelivery.Pos.x, cfg_mecano.Zones.VehicleDelivery.Pos.y, cfg_mecano.Zones.VehicleDelivery.Pos.z)
											SetBlipRoute(Blips['NPCDelivery'], true)
										end
									end
								else
									ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Vous ne pouvez pas attacher votre ~h~~r~propre véhicule de dépannage !", 'CHAR_CARSITE3', 7)
								end
							end
						else
							ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Il n'y a pas de véhicule ~h~~r~attacher !", 'CHAR_CARSITE3', 7)
						end
					else
						AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
						DetachEntity(CurrentlyTowedVehicle, true, true)
                        
						if NPCOnJob then
							if NPCTargetDeleterZone then
	
								if CurrentlyTowedVehicle == NPCTargetTowable then
									ESX.Game.DeleteVehicle(NPCTargetTowable)
									TriggerServerEvent('esx_mecanojob:onNPCJobMissionCompleted')
									StopNPCJob()
									NPCTargetDeleterZone = false
								else
									ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Ce n'est pas le bon ~h~~r~véhicule !", 'CHAR_CARSITE3', 7)
								end
	
							else
								ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Vous n'etes pas au bon endroit ~h~~r~pour faire cela !", 'CHAR_CARSITE3', 7)
							end
						end
	
						CurrentlyTowedVehicle = nil
						ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Véhicule détacher avec ~r~~h~succès !", 'CHAR_CARSITE3', 7)
					end
				else
					ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Vous devez avoir une ~r~~h~dépanneuse à plateau pour faire cela !", 'CHAR_CARSITE3', 7)
				end
                    end
                })
            end)

                RageUI.IsVisible(annoncemenu, function()
                    ESX.PlayerData = ESX.GetPlayerData()
                    RageUI.Separator(VarColor.."↓ Annonce ↓")
                    RageUI.Button("Annonce [~r~OUVERTURE~s~]", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            TriggerServerEvent('Ouvre:benny')
                        end
                       })

                       RageUI.Button("Annonce [~r~FERMETURE~s~]", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            TriggerServerEvent('Ferme:benny')  
                        end
                       })

                       RageUI.Button("Annonce [~r~RECRUTEMENT~s~]", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            TriggerServerEvent('Recru:benny') 
                        end
                       })

                       RageUI.Button("Annonce [~r~Personnalisé~s~]",  "Cooldown de 10secondes entre chaque nouvelle annonce.", {RightLabel = "→→"}, not codesCooldown4 , {
                        onSelected = function()
                            codesCooldown4 = true 
                            local message = KeyboardInput('', '','', 100)
                            ExecuteCommand("meca " ..message)
                            Citizen.SetTimeout(10000, function() codesCooldown4 = false end)
                        end
                    })
                    RageUI.Separator(VarColor.."↓ Message Employer ↓")
                    
                    RageUI.Button("Message [~r~Employer~s~]",  nil, {RightLabel = "→→"}, true , {
                        onSelected = function()
                            local message = KeyboardInput('', '','', 100)
                            TriggerServerEvent('message:benny', message)
                    end
                    })
                end)

        
             Wait(0)
             end
         end)
     end
 end
 
 -- MARKERS
 
 Keys.Register('F6', 'mécano', 'Ouvrir le menu mécano', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano' then
        menumecano()
	end
end)

-- Coffre

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local mainMenu = RageUI.CreateMenu("", "Action :")
local PutMenu = RageUI.CreateSubMenu(mainMenu,"", "Contenue :")
local GetMenu = RageUI.CreateSubMenu(mainMenu,"", "Contenue :")

local open = false

mainMenu:DisplayGlare(false)
mainMenu.Closed = function()
    open = false
end

all_items = {}

    
function CoffreBenny() 
    if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
        RageUI.IsVisible(mainMenu, function()
            RageUI.Button("Prendre un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                getStockMecano()
            end},GetMenu);

            RageUI.Button("Déposer un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                getInventoryMecano()
            end},PutMenu);
            

        end)

        RageUI.IsVisible(GetMenu, function()
            
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, nil, {RightLabel = "x"..VarColor..""..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput('', '','', 100)
                    count = tonumber(count)
                    if count <= v.nb then
                        TriggerServerEvent("benny:takeStockItems",v.item, count)
                    else
                        ESX.ShowNotification("~r~Vous n'en avez pas assez sur vous")
                    end
                    getStockMecano()
                end});
            end

        end)

        RageUI.IsVisible(PutMenu, function()
            
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, nil, {RightLabel = "x"..VarColor..""..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput('', '','', 100)
                    count = tonumber(count)
                    TriggerServerEvent("benny:putStockItems",v.item, count)
                    getInventoryMecano()
                end});
            end
            

       end)


        Wait(0)
    end
 end)
 end
 end



function getInventoryMecano()
    ESX.TriggerServerCallback('benny:playerinventory', function(inventory)               
                
        all_items = inventory
        
    end)
end

function getStockMecano()
    ESX.TriggerServerCallback('benny:getStockItems', function(inventory)               
                
        all_items = inventory
        
    end)
end

Citizen.CreateThread(function()
    while true do
		local wait = 750
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano' then
				for k in pairs(cfg_mecano.Position.Coffre) do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				local pos = cfg_mecano.Position.Coffre
				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

				if dist <= cfg_mecano.MarkerDistance then
					wait = 0
					DrawMarker(cfg_mecano.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_mecano.MarkerSizeLargeur, cfg_mecano.MarkerSizeEpaisseur, cfg_mecano.MarkerSizeHauteur, cfg_mecano.MarkerColorR, cfg_mecano.MarkerColorG, cfg_mecano.MarkerColorB, cfg_mecano.MarkerOpacite, cfg_mecano.MarkerSaute, true, p19, cfg_mecano.MarkerTourne)  
				end

				if dist <= 1.0 then
					wait = 0
					ESX.ShowHelpNotification(cfg_mecano.TextCoffre) 
					if IsControlJustPressed(1,51) then
						CoffreBenny()
					end
				end
			end
		end
    Citizen.Wait(wait)
    end
end)


-- Garage

local open = false 
local mainMenu6 = RageUI.CreateMenu('', 'Faites votre choix ?')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
  open = false
end

function GarageBenny()
     if open then 
         open = false
         RageUI.Visible(mainMenu6, false)
         return
     else
         open = true 
         RageUI.Visible(mainMenu6, true)
         CreateThread(function()
         while open do 
            RageUI.IsVisible(mainMenu6,function() 

              RageUI.Separator(VarColor.."↓ Véhicules ↓")

                for k,v in pairs(cfg_mecano.VehiculeBenny) do
                RageUI.Button(v.buttoname, nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                        if not ESX.Game.IsSpawnPointClear(vector3(v.spawnzone.x, v.spawnzone.y, v.spawnzone.z), 10.0) then
                        ESX.ShowNotification("~r~Benny's\n~r~Point de spawn bloquée")
                        else
                        local model = GetHashKey(v.spawnname)
                        RequestModel(model)
                        while not HasModelLoaded(model) do Wait(10) end
                        local mecanoveh = CreateVehicle(model, v.spawnzone.x, v.spawnzone.y, v.spawnzone.z, v.headingspawn, true, false)
                        local newPlate = GenerateSocietyPlate('BENNYS')
                        SetVehicleNumberPlateText(mecanoveh, newPlate)
                        TriggerServerEvent('garage:RegisterNewKey', 'no', newPlate)
                        SetVehicleFixed(mecanoveh)
                        SetVehRadioStation(mecanoveh, 0)
                        RageUI.CloseAll()
                        end
                    end
                })


              end
            end)
          Wait(0)
         end
      end)
   end
end

Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano' then
            for k in pairs(cfg_mecano.Position.GarageVehicule) do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = cfg_mecano.Position.GarageVehicule
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
  
                if dist <= 5.0 then 
                    wait = 0
                    DrawMarker(cfg_mecano.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_mecano.MarkerSizeLargeur, cfg_mecano.MarkerSizeEpaisseur, cfg_mecano.MarkerSizeHauteur, cfg_mecano.MarkerColorR, cfg_mecano.MarkerColorG, cfg_mecano.MarkerColorB, cfg_mecano.MarkerOpacite, cfg_mecano.MarkerSaute, true, p19, cfg_mecano.MarkerTourne)  
                end
  
                if dist <= 2.0 then 
                    wait = 0
                    ESX.ShowHelpNotification(cfg_mecano.TextGarage) 
                    if IsControlJustPressed(1,51) then
                        GarageBenny()
                    end
                end
            end
        end
    Citizen.Wait(wait)
    end
  end)
 
  --Ranger voiture

  local open = false 
local mainMenuRanger = RageUI.CreateMenu('', 'Faites votre choix ?')
mainMenuRanger.Display.Header = true 
mainMenuRanger.Closed = function()
  open = false
end

function RangerVoiture()
     if open then 
         open = false
         RageUI.Visible(mainMenuRanger, false)
         return
     else
         open = true 
         RageUI.Visible(mainMenuRanger, true)
         CreateThread(function()
         while open do 
            RageUI.IsVisible(mainMenuRanger,function() 


              RageUI.Separator(VarColor.."↓ Option ↓")

              RageUI.Button("Ranger votre véhicule", 'Vous devez ranger uniquement :\n- les véhicules de service ~r~Benny\'s', {RightLabel = "→→"}, true , {
                onSelected = function()
                  local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                  if dist4 < 1 then
                      DeleteEntity(veh)
                      ESX.ShowNotification('~r~Garage \n~r~- Véhicule ranger !~s~')
                      RageUI.CloseAll()
                  end
                 end
             })



              end)
          Wait(0)
         end
      end)
   end
end

Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano' then
            for k in pairs(cfg_mecano.Position.RangerVehicule) do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = cfg_mecano.Position.RangerVehicule
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
  
                if dist <= 5.0 then 
                    wait = 0
                    DrawMarker(cfg_mecano.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_mecano.MarkerSizeLargeur, cfg_mecano.MarkerSizeEpaisseur, cfg_mecano.MarkerSizeHauteur, cfg_mecano.MarkerColorR, cfg_mecano.MarkerColorG, cfg_mecano.MarkerColorB, cfg_mecano.MarkerOpacite, cfg_mecano.MarkerSaute, true, p19, cfg_mecano.MarkerTourne)  
                end
  
                if dist <= 2.0 then 
                    wait = 0
                    ESX.ShowHelpNotification(cfg_mecano.TextRangerGarage) 
                    if IsControlJustPressed(1,51) then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            RangerVoiture()
                      else
                        ESX.ShowNotification('Vous devez être dans un ~r~Véhicule !~s~')
                       end
            end
            end
            end
        end
    Citizen.Wait(wait)
    end
  end)

    --Fabrication kit

    local open = false 
    local mainMenuFrabrication = RageUI.CreateMenu('', 'Faites votre choix ?')
    mainMenuFrabrication.Display.Header = true 
    mainMenuFrabrication.Closed = function()
      open = false
    end
    
    function fabrication()
         if open then 
             open = false
             RageUI.Visible(mainMenuFrabrication, false)
             return
         else
             open = true 
             RageUI.Visible(mainMenuFrabrication, true)
             CreateThread(function()
             while open do 
                RageUI.IsVisible(mainMenuFrabrication,function() 
    
    
                  RageUI.Separator(""..VarColor.."↓ Fabrication de kit ↓")
    
                  RageUI.Button("Fabriquer un kit de réparation", 'Prix du matériel néceissaire : ~r~10$', {RightLabel = "→→"}, true , {
                    onSelected = function()
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
                        Citizen.CreateThread(function()
                        ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Fabrication ~r~~h~en cours...", 'CHAR_CARSITE3', 7)
                        Citizen.Wait(7500)
                        ClearPedTasksImmediately(playerPed)
                        Citizen.Wait(100)
                        TriggerServerEvent('benny:creationkitrepa', 10, 'fixkit', 1)
                    end)
                end
                 })

                 RageUI.Button("Fabriquer un kit carroserie", 'Prix du matériel néceissaire : ~r~15$', {RightLabel = "→→"}, true , {
                    onSelected = function()
                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
                        Citizen.CreateThread(function()
                        ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Fabrication ~r~~h~en cours...", 'CHAR_CARSITE3', 7)
                        Citizen.Wait(7500)
                        ClearPedTasksImmediately(playerPed)
                        Citizen.Wait(100)
                        TriggerServerEvent('benny:creationkitcaro', 15, 'carokit', 1)
                    end)
                end
                 })
    
    
    
                  end)
              Wait(0)
             end
          end)
       end
    end
    
    Citizen.CreateThread(function()
        while true do  
            local wait = 750
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano' then
                for k in pairs(cfg_mecano.Position.FabricationKit) do 
                    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                    local pos = cfg_mecano.Position.FabricationKit
                    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
      
                    if dist <= 5.0 then 
                        wait = 0
                        DrawMarker(cfg_mecano.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_mecano.MarkerSizeLargeur, cfg_mecano.MarkerSizeEpaisseur, cfg_mecano.MarkerSizeHauteur, cfg_mecano.MarkerColorR, cfg_mecano.MarkerColorG, cfg_mecano.MarkerColorB, cfg_mecano.MarkerOpacite, cfg_mecano.MarkerSaute, true, p19, cfg_mecano.MarkerTourne)  
                    end
      
                    if dist <= 2.0 then 
                        wait = 0
                        ESX.ShowHelpNotification(cfg_mecano.TextFabricationKit) 
                        if IsControlJustPressed(1,51) then
                            fabrication()
                           end
                     end
                    end
                end
        Citizen.Wait(wait)
        end
      end)

--Vestiaire

    local open = false 
    local mainMenuvestiaire = RageUI.CreateMenu('', 'Faites votre choix ?')
    mainMenuvestiaire.Display.Header = true 
    mainMenuvestiaire.Closed = function()
      open = false
    end
    
    function vestiaire()
         if open then 
             open = false
             RageUI.Visible(mainMenuvestiaire, false)
             return
         else
             open = true 
             RageUI.Visible(mainMenuvestiaire, true)
             CreateThread(function()
             while open do 
                RageUI.IsVisible(mainMenuvestiaire,function() 
    
    
                  RageUI.Separator(VarColor.."↓ Vestiaire ↓")
    

                  RageUI.Checkbox("Prendre sa tenue Mécano", nil, service, {}, {
                    onChecked = function(index, items)
                        service = true
                        serviceon()
                        ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Vous venez de prendre votre ~r~tenue", 'CHAR_CARSITE3', 7)
                    end,
                    onUnChecked = function(index, items)
                        service = false
                        serviceoff()
                        ESX.ShowAdvancedNotification('Mecano', '~r~Notification', "Vous venez de ~r~ranger votre tenue", 'CHAR_CARSITE3', 7)
                    end
                })
    
    
    
                  end)
              Wait(0)
             end
          end)
       end
    end
    
    Citizen.CreateThread(function()
        while true do  
            local wait = 750
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mecano' then
                for k in pairs(cfg_mecano.Position.Vestiaire) do 
                    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                    local pos = cfg_mecano.Position.Vestiaire
                    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)
      
                    if dist <= 5.0 then 
                        wait = 0
                        DrawMarker(cfg_mecano.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_mecano.MarkerSizeLargeur, cfg_mecano.MarkerSizeEpaisseur, cfg_mecano.MarkerSizeHauteur, cfg_mecano.MarkerColorR, cfg_mecano.MarkerColorG, cfg_mecano.MarkerColorB, cfg_mecano.MarkerOpacite, cfg_mecano.MarkerSaute, true, p19, cfg_mecano.MarkerTourne)  
                    end
      
                    if dist <= 2.0 then 
                        wait = 0
                        ESX.ShowHelpNotification(cfg_mecano.TextVestiaire) 
                        if IsControlJustPressed(1,51) then
                            vestiaire()
                           end
                     end
                    end
                end
        Citizen.Wait(wait)
        end
      end)

      function  serviceon()
        local model = GetEntityModel(GetPlayerPed(-1))
        TriggerEvent('skinchanger:getSkin', function(skin)
            if model == GetHashKey("mp_m_freemode_01") then
                clothesSkin = {
                  ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                  ['torso_1'] = 241,   ['torso_2'] = 0,
                  ['arms'] = 19,
                  ['pants_1'] = 98,   ['pants_2'] = 0,
                  ['shoes_1'] = 25,   ['shoes_2'] = 0,
                  ['helmet_1'] = -1,  ['helmet_2'] = 0,
                  ['chain_1'] = 0,    ['chain_2'] = 0,
                  ['ears_1'] = -1,     ['ears_2'] = 0
                }
            else
                clothesSkin = {
                  ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                  ['torso_1'] = 249,   ['torso_2'] = 0, 
                  ['arms'] = 31,
                  ['pants_1'] = 101,   ['pants_2'] = 0,
                  ['shoes_1'] = 6,   ['shoes_2'] = 0,  
                  ['helmet_1'] = -1,  ['helmet_2'] = 0,
                  ['chain_1'] = 0,    ['chain_2'] = 0,
                  ['ears_1'] = -1,     ['ears_2'] = 0
                }
            end
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
        end)
    end
    
    function serviceoff()
      ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          TriggerEvent('skinchanger:loadSkin', skin)
         end)
      end

RegisterNetEvent('message:benny')
AddEventHandler('message:benny', function(message, nom)
		ESX.ShowAdvancedNotification('Notification Benny\'s', '~r~Message', '~s~De: ~r~'..nom..'\n~w~Message: ~r~'..message..'', 'CHAR_CARSITE3', 1)
end)