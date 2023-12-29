AccessoriesPlayer = {}
Accessories = {
	Masque = {},
	Masque2 = {},
	Lunettes = {},
	Lunettes2 = {},
	Chapeau = {},
	Chapeau2 = {},
	Sac = {},
	Sac2 = {},
	Chaine = {},
	Chaine2 = {},
	Oreille = {},
	Oreille2 = {},
	MasqueIndex = 1,
	MasqueIndex2 = 1,
	LunetteIndex = 1,
	LunetteIndex2 = 1,
	ChapeauIndex = 1,
	ChapeauIndex2 = 1,
	SacIndex = 1,
	SacIndex2 = 1,
	ChaineIndex = 1,
	ChaineIndex2 = 1,
	OreilleIndex = 1,
	OreilleIndex2 = 1
}

Citizen.CreateThread(function()
	Wait(5000)
    -- Masque
    for i = 0, 244 do
        table.insert(Accessories.Masque, i)
    end
	for i = 0, 50 do
        table.insert(Accessories.Lunettes, i)
    end
	for i = 0, 	216 do
        table.insert(Accessories.Chapeau, i)
    end
	for i = 0, 179 do
        table.insert(Accessories.Sac, i)
    end
	for i = 0, 240 do
        table.insert(Accessories.Chaine, i)
    end
	for i = 0, 33 do
        table.insert(Accessories.Oreille, i)
    end	
end)


camacces = nil


openAccessShop = function()
	isFreecam = true
	local mainaccesories = RageUI.CreateMenu("", "Bienvenue dans notre magasin")
	local mask = RageUI.CreateSubMenu(mainaccesories, "", "Voici tout les masques disponibles")
	local lunette = RageUI.CreateSubMenu(mainaccesories, "", "Voici tout les paires de lunettes disponibles")
	local chapeau = RageUI.CreateSubMenu(mainaccesories, "", "Voici tout les chapeaux disponibles")
	local sac = RageUI.CreateSubMenu(mainaccesories, "", "Voici tout les sacs disponibles")
	local chaine = RageUI.CreateSubMenu(mainaccesories, "", "Voici toutes les chaines disponibles")
	local oreille = RageUI.CreateSubMenu(mainaccesories, "", "Voici toutes les accésoires d'oreille disponibles")

	local variationsmasque = RageUI.CreateSubMenu(mask, "", "Voici toutes les variations de masque disponibles")
	local variationslunette = RageUI.CreateSubMenu(lunette, "", "Voici toutes les variations de lunettes disponibles")
	local variationschapeau = RageUI.CreateSubMenu(chapeau, "", "Voici toutes les variations de chapeau disponibles")
	local variationssac = RageUI.CreateSubMenu(sac, "", "Voici toutes les variations de sacs disponibles")
	local variationschaine = RageUI.CreateSubMenu(chaine, "", "Voici toutes les variations de chaine disponibles")
	local variationsoreille = RageUI.CreateSubMenu(oreille, "", "Voici toutes les variations d'oreille disponibles")

	local paidmasque = RageUI.CreateSubMenu(variationsmasque, "", "Payer votre masque")
	local paidlunette = RageUI.CreateSubMenu(variationslunette, "", "Payer votre paire de lunette")
	local paidchapeau = RageUI.CreateSubMenu(variationschapeau, "", "Payer votre paire de lunette")
	local paidsac = RageUI.CreateSubMenu(variationssac, "", "Payer votre sac")
	local paidchaine = RageUI.CreateSubMenu(variationschaine, "", "Payer votre chaine")
	local paidoreille =  RageUI.CreateSubMenu(variationsoreille, "", "Payer votre accesoire d'oreille")

	mainaccesories.Closed = function()
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin) 
        end)
		SetPlayerControl(PlayerId(), false, 12)
		destorycam(camacces)
	end

	--DoScreenFadeOut(1000)
	--Wait(2000)
	SetEntityCoordsNoOffset(PlayerPedId(), -804.77, -600.00, 30.58)
	SetEntityHeading(PlayerPedId() , 331.0)
    SetPlayerControl(PlayerId(), false, 12)
	--DoScreenFadeIn(1500)

	camacces = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
	SetCamCoord(camacces, -803.47, -598.12, 30.27)
	SetCamActive(camacces, true)
	RenderScriptCams(true, true, 2000, true, false)
	PointCamAtEntity(camacces, PlayerPedId())
	SetCamParams(camacces, -803.47, -598.12, 30.77--[[ z float ]], 4.0 --[[ rotation x ]], 0.0 --[[ rotation y  float]], 0.215, 42.2442, 0, 1, 1, 2)

	RageUI.Visible(mainaccesories, not RageUI.Visible(mainaccesories))

	while mainaccesories do 
		Wait(0)

		RageUI.IsVisible(mainaccesories, function()

			RageUI.Button("> Masques", "Accéder à nos masques", {RightLabel = "→→→"}, true, {}, mask)
			RageUI.Button("> Lunettes", "Accéder à nos lunettes", {RightLabel = "→→→"}, true, {}, lunette)
			RageUI.Button("> Chapeaux", "Accéder à nos masques", {RightLabel = "→→→"}, true, {}, chapeau)
			RageUI.Button("> Sac", "Accéder à nos sacs", {RightLabel = "→→→"}, true, {
				onSelected = function()
					SetEntityHeading(PlayerPedId() , 155.0)
				end
			}, sac)
			RageUI.Button("> Chaînes", "Accéder à nos masques", {RightLabel = "→→→"}, true, {}, chaine)
			RageUI.Button("> Boucle d'oreille", "Accéder à nos boucle d'oreille", {RightLabel = "→→→"}, true, {
				onSelected = function()
					SetEntityHeading(PlayerPedId() , 70.0)
				end
			}, oreille)
		
		end, function()
		end)

		-- Masque
		RageUI.IsVisible(mask, function()
			RageUI.Button("Aucun Masque ", nil, {}, true, {
				onActive = function()
					Accessories.MasqueIndex = 0
					TriggerEvent('skinchanger:change', 'mask_1', 0)
					TriggerEvent('skinchanger:change', 'mask_2', 0)
					Accessories.Masque2 = {}
					for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 1, 0)-2 do
						table.insert(Accessories.Masque2, i)
					end
				end,
				onSelected = function()
					RageUI.Visible(mask, false)
					RageUI.Visible(lunette, true)
				end
			})

			for k, v in pairs(Accessories.Masque) do 
				RageUI.Button("Masque "..k, nil, {}, true, {
					onActive = function()
						Accessories.MasqueIndex = k
						TriggerEvent('skinchanger:change', 'mask_1', k)
						TriggerEvent('skinchanger:change', 'mask_2', 0)
						Accessories.Masque2 = {}
						for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 1, k)-2 do
							table.insert(Accessories.Masque2, i)
						end

					end,
					onSelected = function()
						RageUI.Visible(mask, false)
						RageUI.Visible(variationsmasque, true)
					end
				})
			end
		end)

		RageUI.IsVisible(variationsmasque, function()

			RageUI.Button("Variation Masque 0", nil, {}, true, {
				onActive = function()
					Accessories.MasqueIndex2 = 0
					TriggerEvent('skinchanger:change', 'mask_2', 0)
				end,
				onSelected = function()
					RageUI.Visible(variationsmasque, false)
					RageUI.Visible(paidmasque, true)
				end
			})
			for k, v in pairs(Accessories.Masque2) do 
				RageUI.Button("Variation Masque "..k, nil, {}, true, {
					onActive = function()
						Accessories.MasqueIndex2 = k
						TriggerEvent('skinchanger:change', 'mask_2', k)
					end,
					onSelected = function()
						RageUI.Visible(variationsmasque, false)
						RageUI.Visible(paidmasque, true)
					end
				})
			end

		end)

		RageUI.IsVisible(paidmasque, function()
			RageUI.Button("> Payer votre masque", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					local namemasque = KeyboardInput("Nom du masque", "Nom du masque", "", 15)
					if namemasque then 
						AccessoriesPlayer["mask_1"] = Accessories.MasqueIndex
						AccessoriesPlayer["mask_2"] = Accessories.MasqueIndex2
						TriggerServerEvent("ronflex:paidaccesoires", "accesoires", namemasque, AccessoriesPlayer)
						AccessoriesPlayer = {}
						RageUI.CloseAll()
					end
				end
			})
		end)

		-- Lunettes
		RageUI.IsVisible(lunette, function()

			RageUI.Button("Aucune Lunette ", nil, {}, true, {
				onActive = function()
					Accessories.LunetteIndex = 0
					TriggerEvent('skinchanger:change', 'glasses_1', 0)
					TriggerEvent('skinchanger:change', 'glasses_2', 0)
					Accessories.Lunettes2 = {}
					for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 1, 0)-2 do
						table.insert(Accessories.Lunettes2, i)
					end
				end,
				onSelected = function()
					RageUI.Visible(variationslunette, false)
					RageUI.Visible(lunette, false)
				end
			})
			for k, v in pairs(Accessories.Lunettes) do 
				RageUI.Button("Lunette "..k, nil, {}, true, {
					onActive = function()
						Accessories.LunetteIndex = k
						TriggerEvent('skinchanger:change', 'glasses_1', k)
						TriggerEvent('skinchanger:change', 'glasses_2', 0)
						Accessories.Lunettes2 = {}
						for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 1, k)-2 do
							table.insert(Accessories.Lunettes2, i)
						end

					end,
					onSelected = function()
						RageUI.Visible(lunette, false)
						RageUI.Visible(variationslunette, true)
					end
				})
			end

		end)

		RageUI.IsVisible(variationslunette, function()
		
			RageUI.Button("Variation Lunette 0", nil, {}, true, {
				onActive = function()
					Accessories.LunetteIndex2 = 0
					TriggerEvent('skinchanger:change', 'glasses_2', 0)
				end,
				onSelected = function()
					RageUI.Visible(variationslunette, false)
					RageUI.Visible(paidlunette, true)
				end
			})
			for k, v in pairs(Accessories.Lunettes2) do 
				RageUI.Button("Variation Masque "..k, nil, {}, true, {
					onActive = function()
						Accessories.LunetteIndex2 = k
						TriggerEvent('skinchanger:change', 'glasses_2', k)
					end,
					onSelected = function()
						RageUI.Visible(variationslunette, false)
						RageUI.Visible(paidlunette, true)
					end
				})
			end

		end)

		RageUI.IsVisible(paidlunette, function()

			RageUI.Button("> Payer votre paire de lunette", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					local namemasque = KeyboardInput("Nom de la lunette", "Nom de la lunette", "", 15)
					if namemasque then 
						AccessoriesPlayer["glasses_1"] = Accessories.LunetteIndex
						AccessoriesPlayer["glasses_2"] = Accessories.LunetteIndex2
						TriggerServerEvent("ronflex:paidaccesoires", "accesoires", namemasque, AccessoriesPlayer)
						AccessoriesPlayer = {}
						RageUI.CloseAll()
					end
				end
			})

		end)

		-- Chapeau 
		RageUI.IsVisible(chapeau, function()

			RageUI.Button("Aucun Chapeau ", nil, {}, true, {
				onActive = function()
					Accessories.ChapeauIndex = 0
					TriggerEvent('skinchanger:change', 'helmet_1', 0)
					TriggerEvent('skinchanger:change', 'helmet_2', 0)
					Accessories.Chapeau2 = {}
					for i = 0, GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, 0)- 1 do
						table.insert(Accessories.Chapeau2, i)
					end
				end,
				onSelected = function()
					RageUI.Visible(variationschapeau, true)
					RageUI.Visible(chapeau, false)
				end
			})
			for k, v in pairs(Accessories.Chapeau) do 
				RageUI.Button("Chapeau "..k, nil, {}, true, {
					onActive = function()
						Accessories.ChapeauIndex = k
						TriggerEvent('skinchanger:change', 'helmet_1', k)
						TriggerEvent('skinchanger:change', 'helmet_2', 0)
						Accessories.Chapeau2 = {}
						for i = 0, GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, k) - 1 do
							table.insert(Accessories.Chapeau2, i)
						end

					end,
					onSelected = function()
						RageUI.Visible(chapeau, false)
						RageUI.Visible(variationschapeau, true)
					end
				})
			end
		end)

		RageUI.IsVisible(variationschapeau, function()

			RageUI.Button("Variation Chapeau 0", nil, {}, true, {
				onActive = function()
					Accessories.ChapeauIndex2 = 0
					TriggerEvent('skinchanger:change', 'helmet_2', 0)
				end,
				onSelected = function()
					RageUI.Visible(variationschapeau, false)
					RageUI.Visible(paidchapeau, true)
				end
			})
			for k, v in pairs(Accessories.Chapeau2) do 
				RageUI.Button("Variation Chapeau "..k, nil, {}, true, {
					onActive = function()
						Accessories.ChapeauIndex2 = k
						TriggerEvent('skinchanger:change', 'helmet_2', k)
					end,
					onSelected = function()
						RageUI.Visible(variationschapeau, false)
						RageUI.Visible(paidchapeau, true)
					end
				})
			end
		end)

		RageUI.IsVisible(paidchapeau, function()
			RageUI.Button("> Payer votre chapeau", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					local namemasque = KeyboardInput("Nom du chapeau", "Nom  du chapeau", "", 15)
					if namemasque then 
						AccessoriesPlayer["helmet_1"] = Accessories.ChapeauIndex
						AccessoriesPlayer["helmet_2"] = Accessories.ChapeauIndex2
						TriggerServerEvent("ronflex:paidaccesoires", "accesoires", namemasque, AccessoriesPlayer)
						AccessoriesPlayer = {}
						RageUI.CloseAll()
					end
				end
			})
		end)

		-- Sac
		RageUI.IsVisible(sac, function()
			RageUI.Button("Aucun Sac ", nil, {}, true, {
				onActive = function()
					Accessories.SacIndex = 0
					TriggerEvent('skinchanger:change', 'bags_1', 0)
					TriggerEvent('skinchanger:change', 'bags_2', 0)
					Accessories.Sac2 = {}
					for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 5, 0) -1 do
						table.insert(Accessories.Sac2, i)
					end
				end,
				onSelected = function()
					RageUI.Visible(sac, false)
					RageUI.Visible(variationssac, true)
				end
			})
			for k, v in pairs(Accessories.Sac) do 
				RageUI.Button("Sac "..k, nil, {}, true, {
					onActive = function()
						Accessories.SacIndex = k
						TriggerEvent('skinchanger:change', 'bags_1', k)
						TriggerEvent('skinchanger:change', 'bags_2', 0)
						Accessories.Sac2 = {}
						for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 5, k) - 2 do
							table.insert(Accessories.Sac2, i)
						end

					end,
					onSelected = function()
						RageUI.Visible(sac, false)
						RageUI.Visible(variationssac, true)
					end
				})
			end
		
		end)

		RageUI.IsVisible(variationssac, function()
		
			RageUI.Button("Variation Sac 0", nil, {}, true, {
				onActive = function()
					Accessories.SacIndex2 = 0
					TriggerEvent('skinchanger:change', 'bags_2', 0)
				end,
				onSelected = function()
					RageUI.Visible(variationssac, false)
					RageUI.Visible(paidsac, true)
				end
			})
			for k, v in pairs(Accessories.Sac2) do 
				RageUI.Button("Variation Chapeau "..k, nil, {}, true, {
					onActive = function()
						Accessories.SacIndex2 = k
						TriggerEvent('skinchanger:change', 'bags_2', k)
					end,
					onSelected = function()
						RageUI.Visible(variationssac, false)
						RageUI.Visible(paidsac, true)
					end
				})
			end
		end)

		RageUI.IsVisible(paidsac, function()
			RageUI.Button("> Payer votre sac", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					local namemasque = KeyboardInput("Nom du sac", "Nom  du sac", "", 15)
					if namemasque then 
						AccessoriesPlayer["bags_1"] = Accessories.SacIndex
						AccessoriesPlayer["bags_2"] = Accessories.SacIndex2
						TriggerServerEvent("ronflex:paidaccesoires", "accesoires", namemasque, AccessoriesPlayer)
						AccessoriesPlayer = {}
						RageUI.CloseAll()
					end
				end
			})
		end)

		-- Chaîne 
		RageUI.IsVisible(chaine, function()
			RageUI.Button("Aucune Chaine ", nil, {}, true, {
				onActive = function()
					Accessories.ChaineIndex = 0
					TriggerEvent('skinchanger:change', 'chain_1', 0)
					TriggerEvent('skinchanger:change', 'chain_2', 0)
					Accessories.Chaine2 = {}
					for i = 0, GetNumberOfPedPropTextureVariations(PlayerPedId(), 7, 0)-2 do
						table.insert(Accessories.Chaine2, i)
					end
				end,
				onSelected = function()
					RageUI.Visible(chaine, false)
					RageUI.Visible(variationschaine, true)
				end
			})
			for k, v in pairs(Accessories.Chaine) do 
				RageUI.Button("Chaine "..k, nil, {}, true, {
					onActive = function()
						Accessories.ChaineIndex = k
						TriggerEvent('skinchanger:change', 'chain_1', k)
						TriggerEvent('skinchanger:change', 'chain_2', 0)
						Accessories.Chaine2 = {}
						for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 7, k)-2 do
							table.insert(Accessories.Chaine2, i)
						end

					end,
					onSelected = function()
						RageUI.Visible(chaine, false)
						RageUI.Visible(variationschaine, true)
					end
				})
			end
		
		end)

		RageUI.IsVisible(variationschaine, function()

			RageUI.Button("Variation Chaine 0", nil, {}, true, {
				onActive = function()
					Accessories.ChaineIndex2 = 0
					TriggerEvent('skinchanger:change', 'chain_2', 0)
				end,
				onSelected = function()
					RageUI.Visible(variationschaine, false)
					RageUI.Visible(paidchaine, true)
				end
			})
			for k, v in pairs(Accessories.Chaine2) do 
				RageUI.Button("Variation Chaine "..k, nil, {}, true, {
					onActive = function()
						Accessories.ChaineIndex2 = k
						TriggerEvent('skinchanger:change', 'chain_2', k)
					end,
					onSelected = function()
						RageUI.Visible(variationschaine, false)
						RageUI.Visible(paidchaine, true)
					end
				})
			end
		
		end)

		RageUI.IsVisible(paidchaine, function()
			RageUI.Button("> Payer votre Chaine", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					local namemasque = KeyboardInput("Nom de la chaine", "Nom de la chaine", "", 15)
					if namemasque then 
						AccessoriesPlayer["chain_1"] = Accessories.ChaineIndex
						AccessoriesPlayer["chain_2"] = Accessories.ChaineIndex2
						TriggerServerEvent("ronflex:paidaccesoires", "accesoires", namemasque, AccessoriesPlayer)
						AccessoriesPlayer = {}
						RageUI.CloseAll()
					end
				end
			})
		end)	
		
		-- Accesoires d'oreille
		RageUI.IsVisible(oreille, function()
			RageUI.Button("Aucune Accesoire d'oreille ", nil, {}, true, {
				onActive = function()
					Accessories.OreilleIndex = 0
					TriggerEvent('skinchanger:change', 'ears_1', 0)
					TriggerEvent('skinchanger:change', 'ears_2', 0)
					Accessories.Oreille2 = {}
					for i = 0, GetNumberOfPedPropTextureVariations(PlayerPedId(), 2, 0) -2 do
						table.insert(Accessories.Oreille2, i)
					end
				end,
				onSelected = function()
					RageUI.Visible(oreille, false)
					RageUI.Visible(variationsoreille, true)
				end
			})
			for k, v in pairs(Accessories.Oreille) do 
				RageUI.Button("Accesoire d'oreille "..k, nil, {}, true, {
					onActive = function()
						Accessories.OreilleIndex = k
						TriggerEvent('skinchanger:change', 'ears_1', k)
						TriggerEvent('skinchanger:change', 'ears_2', 0)
						Accessories.Oreille2 = {}
						for i = 0, GetNumberOfPedPropTextureVariations(PlayerPedId(), 2, k)-2 do
							table.insert(Accessories.Oreille2, i)
						end
					end,
					onSelected = function()
						RageUI.Visible(oreille, false)
						RageUI.Visible(variationsoreille, true)
					end
				})
			end
		end)

		RageUI.IsVisible(variationsoreille, function()

			RageUI.Button("Variation Accesoire d'oreille 0", nil, {}, true, {
				onActive = function()
					Accessories.OreilleIndex2 = 0
					TriggerEvent('skinchanger:change', 'ears_2', 0)
				end,
				onSelected = function()
					RageUI.Visible(variationsoreille, false)
					RageUI.Visible(paidoreille, true)
				end
			})
			for k, v in pairs(Accessories.Oreille2) do 
				RageUI.Button("Variation Chaine "..k, nil, {}, true, {
					onActive = function()
						Accessories.OreilleIndex2 = k
						TriggerEvent('skinchanger:change', 'ears_2', k)
					end,
					onSelected = function()
						RageUI.Visible(variationsoreille, false)
						RageUI.Visible(paidoreille, true)
					end
				})
			end
		
		end)

		RageUI.IsVisible(paidoreille, function()

			RageUI.Button("> Payer votre Accesoire d'oreille", nil, {RightLabel = "→→→"}, true, {
				onSelected = function()
					local namemasque = KeyboardInput("Nom de votre accesoire d'oreille", "Nom de votre accesoire d'oreille", "", 15)
					if namemasque then 
						AccessoriesPlayer["ears_1"] = Accessories.OreilleIndex
						AccessoriesPlayer["ears_1"] = Accessories.OreilleIndex2
						TriggerServerEvent("ronflex:paidaccesoires", "accesoires", namemasque, AccessoriesPlayer)
						AccessoriesPlayer = {}
						RageUI.CloseAll()
					end
				end
			})
		end)

		if not RageUI.Visible(mainaccesories) and
		not RageUI.Visible(mask) and 
		not RageUI.Visible(lunette) and
		not RageUI.Visible(chapeau) and 
		not RageUI.Visible(sac) and 
		not RageUI.Visible(chaine) and 
		not RageUI.Visible(oreille) and 

		not RageUI.Visible(variationsmasque) and 
		not RageUI.Visible(variationslunette) and 
		not RageUI.Visible(variationschapeau) and 
		not RageUI.Visible(variationssac) and 
		not RageUI.Visible(variationschaine) and 
		not RageUI.Visible(variationsoreille) and 

		
		not RageUI.Visible(paidlunette) and 
		not RageUI.Visible(paidchapeau) and 
		not RageUI.Visible(paidsac) and
		not RageUI.Visible(paidchaine) and 
		not RageUI.Visible(paidoreille) and  

		not RageUI.Visible(paidmasque) then 
			mainaccesories = RMenu:DeleteType("mainaccesories")
			destorycam(camacces)
			SetPlayerControl(PlayerId(), true, 12)
			FreezeEntityPosition(PlayerPedId(), false)
			isFreecam = false
		end
	end
end