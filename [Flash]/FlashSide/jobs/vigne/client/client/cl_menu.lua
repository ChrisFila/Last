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
local subMenu10 = RageUI.CreateSubMenu(mainMenu8, "", "~r~Interaction")
mainMenu8.Display.Header = true 
mainMenu8.Closed = function()
  open = false
end

function OpenMenuVigne()
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

			RageUI.Separator("~r~↓ Annonce ↓")

			RageUI.Button("Annonces Vigneron", nil, {RightLabel = "→"}, true , {
				onSelected = function()
				end
			}, subMenu8)

			RageUI.Separator("~r~↓ Facture ↓")

			RageUI.Button("Faire une Facture", nil, {RightLabel = "→"}, true , {
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
										TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_vigne', ('vigne'), montant)
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
			

			RageUI.Separator("~r~↓ Farm ↓")

			RageUI.Button("Pour accéder au farms", nil, {RightLabel = "→"}, true , {
				onSelected = function()
				end
			}, subMenu10)

			end)

			RageUI.IsVisible(subMenu8,function() 

			 RageUI.Button("Annonce Ouvertures", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					TriggerServerEvent('Ouvre:vigne')
				end
			})

			RageUI.Button("Annonce Fermetures", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					TriggerServerEvent('Ferme:vigne')
				end
			})

			RageUI.Button("Annonce Recrutement", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					TriggerServerEvent('Recru:vigne')
				end
			})

		   end)

		   RageUI.IsVisible(subMenu10,function() 

			RageUI.Button("Obtenir le point de récolte", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					SetNewWaypoint(-1803.69, 2214.42, 91.43)  
				end
			})

			RageUI.Button("Obtenir le point de traitement", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					SetNewWaypoint(-51.86, 1911.27, 195.36) 
				end 
			})

			RageUI.Button("Obtenir le point de vente", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					SetNewWaypoint(359.38, -1109.02, 29.41)
				end
			})


			end)

		 Wait(0)
		end
	 end)
  end
end

-- OUVERTURE DU MENU --

Keys.Register('F6', 'vigne', 'Ouvrir le menu vigne', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then
    	OpenMenuVigne()
	end
end)

