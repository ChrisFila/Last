FlashSide.Ambulance = {}
IsInServiceEMS = false
FlashSide.Ambulance.OpenGetItemSoins = function()
    local menu = RageUI.CreateMenu('', "Prends les objets que tu souhaites")

    RageUI.Visible(menu, not RageUI.Visible(menu))
    while menu do
        Citizen.Wait(0)
        RageUI.IsVisible(menu, function()
            RageUI.Button('Trousse de soin', nil, {RightLabel = '>'}, true, {
                onSelected = function() 
                    TriggerServerEvent('EMS:GetItemSoins', 'medikit')
                end
            })
            RageUI.Button('Bandage', nil, {RightLabel = '>'}, true, {
                onSelected = function()
                    TriggerServerEvent('EMS:GetItemSoins', 'bandage')
                end
            })
        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

FlashSide.Ambulance.OpenAmbulanceMenu = function()
    local menu = RageUI.CreateMenu('', "Voici les appeles disponibles")
    local OpenInteractAmbulanceMenu = RageUI.CreateSubMenu(menu, "E", 'Actions disponible')
    local OpenPubMenuAmbulance = RageUI.CreateSubMenu(menu, "", 'Actions disponible')
    RageUI.Visible(menu, not RageUI.Visible(menu))
    while menu do
        Citizen.Wait(0)
        RageUI.IsVisible(menu, function()
            RageUI.Button('Menu Intéraction', nil, {RightLabel = '>'}, true, {
                onSelected = function() 
                end
            }, OpenInteractAmbulanceMenu)
            RageUI.Button('Menu Publicitaire', nil, {RightLabel = '>'}, true, {
                onSelected = function() 
                end
            }, OpenPubMenuAmbulance)
        end, function()
        end)

        RageUI.IsVisible(OpenInteractAmbulanceMenu, function()
            RageUI.Button('Réanimer', nil, {RightLabel = '>'}, true, {
                onSelected = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('FlashSide~w~ ~n~Aucun joueur au alentours.')
                    else
                        TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                        Citizen.Wait(10000)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent('EMS:RevivePlayer', GetPlayerServerId(closestPlayer))
                    end
                end
            })
            RageUI.Button('Mettre une Facture', nil, {RightLabel = '>'}, true, {
                onSelected = function() 
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('~r~Erreur ~w~~n~Il n\'y a aucun joueur au alentours')
                    else
                        local string = KeyboardInput('Montant de la facture', ('Montant de la facture'), '', 999)
                        if string ~= "" then
                            Montant = tonumber(string)
                        end
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_ambulance', ('Ambulance'), montant)
                    end
                end
            })
            RageUI.Button('Faire un bandage', nil, {RightLabel = '>'}, true, {
                onSelected = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('FlashSide~w~ ~n~Aucun joueur au alentours.')
                    else
                        TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                        Citizen.Wait(10000)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent('EMS:HealPlayer', GetPlayerServerId(closestPlayer))
                    end
                end
            })
        end)

        RageUI.IsVisible(OpenPubMenuAmbulance, function()
            RageUI.Button('EMS Disponible', nil, {RightLabel = '>'}, true, {
                onSelected = function()
                    TriggerServerEvent('EMS:Annonce', 'open')
                end
            })
            RageUI.Button('EMS Indisponible', nil, {RightLabel = '>'}, true, {
                onSelected = function()
                    TriggerServerEvent('EMS:Annonce', 'close')
                end
            })
        end)

        if not RageUI.Visible(menu) and not RageUI.Visible(OpenInteractAmbulanceMenu) and not RageUI.Visible(OpenPubMenuAmbulance) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

FlashSide.Ambulance.OpenVestiaire = function()
    local menu = RageUI.CreateMenu('', "Vous êtes dans le coma")
    RageUI.Visible(menu, not RageUI.Visible(menu))
    while menu do
        Citizen.Wait(0)
        RageUI.IsVisible(menu, function()
            RageUI.Button('Prise de Service', nil, {RightLabel = '>'}, true, {
                onSelected = function()
                    IsInServiceEMS = true
                    TriggerServerEvent('EMS:Service', true)
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadClothes', skin, cfg_ems.Uniforms.male)
                        else
                            TriggerEvent('skinchanger:loadClothes', skin, cfg_ems.Uniforms.female)
                        end
                    end)
                end
            })
            RageUI.Button('Fin de Service', nil, {RightLabel = '>'}, true, {
                onSelected = function()
                    IsInServiceEMS = false
                    TriggerServerEvent('EMS:Service', false)
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                        TriggerEvent('skinchanger:loadSkin', skin)
                    end)
                end
            })
        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

RegisterNetEvent('EMS:HealClientPlayer')
AddEventHandler('EMS:HealClientPlayer', function()
    local healt = GetEntityHealth(PlayerPedId())
    if healt >= 175 then
        HealtMax = 200
    else
        HealtMax = healt + 25
    end
    SetEntityHealth(PlayerPedId(), HealtMax)
end)

Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local pos = cfg_ems.Position.GarageVehicule
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, 306.7531, -601.819, 43.284)
  
            if dist <= 5.0 then 
                wait = 0
                DrawMarker(cfg_ems.MarkerType, 306.7531, -601.819, 43.284, 0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_ems.MarkerSizeLargeur, cfg_ems.MarkerSizeEpaisseur, cfg_ems.MarkerSizeHauteur, cfg_ems.MarkerColorR, cfg_ems.MarkerColorG, cfg_ems.MarkerColorB, cfg_ems.MarkerOpacite, cfg_ems.MarkerSaute, true, p19, cfg_ems.MarkerTourne)  
            end
  
            if dist <= 2.0 then 
                wait = 0
                Visual.Subtitle('Accédé a la phamacie', 1)
                if IsControlJustPressed(1,51) then
                    FlashSide.Ambulance.OpenGetItemSoins()
                end
            end
        end
    Citizen.Wait(wait)
    end
end)

Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local pos = cfg_ems.Position.GarageVehicule
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, 299.1196, -598.35, 43.284)
  
            if dist <= 5.0 then 
                wait = 0
                DrawMarker(cfg_ems.MarkerType, 299.1196, -598.35, 43.284, 0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_ems.MarkerSizeLargeur, cfg_ems.MarkerSizeEpaisseur, cfg_ems.MarkerSizeHauteur, cfg_ems.MarkerColorR, cfg_ems.MarkerColorG, cfg_ems.MarkerColorB, cfg_ems.MarkerOpacite, cfg_ems.MarkerSaute, true, p19, cfg_ems.MarkerTourne)  
            end
  
            if dist <= 2.0 then 
                wait = 0
                Visual.Subtitle(cfg_ems.TextVestaire, 1)
                if IsControlJustPressed(1,51) then
                    FlashSide.Ambulance.OpenVestiaire()
                end
            end
        end
    Citizen.Wait(wait)
    end
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

function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine = 5,
		modBrakes = 5,
		modTransmission = 5,
		modSuspension = 5,
		modTurbo = true,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
end

cfg_ems = {

    MarkerType = 22, -- Pour voir les différents type de marker: https://docs.fivem.net/docs/game-references/markers/
    MarkerSizeLargeur = 0.3, -- Largeur du marker
    MarkerSizeEpaisseur = 0.3, -- Épaisseur du marker
    MarkerSizeHauteur = 0.3, -- Hauteur du marker
    MarkerDistance = 6.0, -- Distane de visibiliter du marker (1.0 = 1 mètre)
    MarkerColorR = 69, -- Voir pour les couleurs RGB: https://www.google.com/search?q=html+color+picker&rlz=1C1GCEA_enFR965FR965&oq=html+color+&aqs=chrome.2.69i59j0i131i433i512j0i512l5j69i60.3367j0j7&sourceid=chrome&ie=UTF-8
    MarkerColorG = 112, -- Voir pour les couleurs RGB: https://www.google.com/search?q=html+color+picker&rlz=1C1GCEA_enFR965FR965&oq=html+color+&aqs=chrome.2.69i59j0i131i433i512j0i512l5j69i60.3367j0j7&sourceid=chrome&ie=UTF-8
    MarkerColorB = 246, -- Voir pour les couleurs RGB: https://www.google.com/search?q=html+color+picker&rlz=1C1GCEA_enFR965FR965&oq=html+color+&aqs=chrome.2.69i59j0i131i433i512j0i512l5j69i60.3367j0j7&sourceid=chrome&ie=UTF-8
    MarkerOpacite = 180, -- Opacité du marker (min: 0, max: 255)
    MarkerSaute = true, -- Si le marker saute (true = oui, false = non)
    MarkerTourne = true, -- Si le marker tourne (true = oui, false = non)

    TextVestaire = "Appuyez sur ~r~[E] ~s~pour pour accèder au ~r~vestaire ~s~!", -- Text Menu Vestaire
    TextGarageVehicule = "Appuyez sur ~r~[E] ~s~pour accèder au ~r~garage ~s~!",  -- Text Garage Voiture
    TextRentreVehicule = "Appuyez sur ~r~[E] ~s~pour renger le ~r~véhicule ~s~!",  -- Text Rentré Voiture
    TextGarageHeli = "Appuyez sur ~r~[E] ~s~pour accèder au ~r~garage ~s~!",  -- Text Garage Hélico

    Vehiculesambulance = { 
        {buttoname = "Ambulance", rightlabel = "→→", spawnname = "ambulance", spawnzone = vector3(293.1553, -613.0522, 43.39647), headingspawn = 70.7010},
        {buttoname = "Dodge", rightlabel = "→→", spawnname = "dodgeems", spawnzone = vector3(293.1553, -613.0522, 43.39647), headingspawn = 70.7010},
        {buttoname = "SUV", rightlabel = "→→", spawnname = "emssuv", spawnzone = vector3(293.1553, -613.0522, 43.39647), headingspawn = 70.7010},
        {buttoname = "Maserati", rightlabel = "→→", spawnname = "ghispo3", spawnzone = vector3(293.1553, -613.0522, 43.39647), headingspawn = 70.7010},
    },

    Helicoambulance = { 
        {buttoname = "Hélicopter", rightlabel = "→→", spawnname = "polmav", spawnzone = vector3(351.0606, -587.7145, 74.16441), headingspawn = 70.7010},
    },

    Uniforms = {
        male = {
            ['tshirt_1'] = 54, ['tshirt_2'] = 0,
            ['torso_1'] = 482, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 86,
            ['pants_1'] = 91, ['pants_2'] = 5,
            ['shoes_1'] = 40, ['shoes_2'] = 0,
            ['chain_1'] = 20, ['chain_2'] = 2,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 0,     ['bags_2'] = 0
        },
        female = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 27, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 96,
            ['pants_1'] = 67, ['pants_2'] = 3,
            ['shoes_1'] = 1, ['shoes_2'] = 9,
            ['chain_1'] = 15, ['chain_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 0,     ['bags_2'] = 0
        }
    },

    Position = {
        GarageVehicule = {vector3(296.297, -600.7081, 43.3042)}, -- Menu Garage Vehicule
        RentreVehicule = {vector3(292.1031, -613.3286, 43.40641)}, -- Menu Garage Vehicule
        GarageHeli = {vector3(340.2419, -581.3244, 74.16441)}, -- Menu Garage Helico
   }
}

-- MENU FUNCTION --

local open = false 
local mainMenu6 = RageUI.CreateMenu('', '~r~Véhicule')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
  open = false
end

function OpenMenuGarageambulance()
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

                for k,v in pairs(cfg_ems.Vehiculesambulance) do
                RageUI.Button(v.buttoname, nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                        if not ESX.Game.IsSpawnPointClear(vector3(v.spawnzone.x, v.spawnzone.y, v.spawnzone.z), 10.0) then
                            ESX.ShowNotification("~r~ambulance\n~r~Point de spawn bloquée")
                        else
                            local model = GetHashKey(v.spawnname)
                            RequestModel(model)
                            while not HasModelLoaded(model) do Wait(10) end
                            local ambulanceveh = CreateVehicle(model, v.spawnzone.x, v.spawnzone.y, v.spawnzone.z, v.headingspawn, true, false)
                            local newPlate = GenerateSocietyPlate('EMS')
                            SetVehicleNumberPlateText(ambulanceveh, newPlate)
                            TriggerServerEvent('garage:RegisterNewKey', 'no', newPlate)
                            SetVehicleFixed(ambulanceveh)
                            TaskWarpPedIntoVehicle(PlayerPedId(),  ambulanceveh,  -1)
                            SetVehRadioStation(ambulanceveh, 0)
                            SetVehicleMaxMods(ambulanceveh)
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
      if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
          for k in pairs(cfg_ems.Position.GarageVehicule) do 
              local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
              local pos = cfg_ems.Position.GarageVehicule
              local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

              if dist <= 5.0 then 
                  wait = 0
                  DrawMarker(cfg_ems.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_ems.MarkerSizeLargeur, cfg_ems.MarkerSizeEpaisseur, cfg_ems.MarkerSizeHauteur, cfg_ems.MarkerColorR, cfg_ems.MarkerColorG, cfg_ems.MarkerColorB, cfg_ems.MarkerOpacite, cfg_ems.MarkerSaute, true, p19, cfg_ems.MarkerTourne)  
              end

              if dist <= 2.0 then 
                  wait = 0
                  Visual.Subtitle(cfg_ems.TextGarageVehicule, 1)
                  if IsControlJustPressed(1,51) then
                    OpenMenuGarageambulance()
                  end
              end
          end
      end
  Citizen.Wait(wait)
  end
end)

Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
            for k in pairs(cfg_ems.Position.RentreVehicule) do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local playerPed = PlayerPedId()
                local pos = cfg_ems.Position.RentreVehicule
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 5.0 then 
                    wait = 0
                    DrawMarker(cfg_ems.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_ems.MarkerSizeLargeur, cfg_ems.MarkerSizeEpaisseur, cfg_ems.MarkerSizeHauteur, cfg_ems.MarkerColorR, cfg_ems.MarkerColorG, cfg_ems.MarkerColorB, cfg_ems.MarkerOpacite, cfg_ems.MarkerSaute, true, p19, cfg_ems.MarkerTourne)  
                end

                if dist <= 2.0 then 
                    wait = 0
                    Visual.Subtitle(cfg_ems.TextRentreVehicule, 1)
                    if IsControlJustPressed(1,51) then
                        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                        if veh ~= nil then 
                            DeleteEntity(veh) 
                        end
                    end
                end
            end
        end
        Citizen.Wait(wait)
    end
end)


-- Garage Helico

-- MENU FUNCTION --

local open = false 
local mainMenu6 = RageUI.CreateMenu('', '~r~Héhlico')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
  open = false
end

function OpenMenuGarageHeliambulance()
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

              RageUI.Button("Ranger votre véhicule", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                  local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                  if dist4 < 4 then
                      DeleteEntity(veh)
                      RageUI.CloseAll()
                  end
                    end
                  })

              RageUI.Separator("~h~↓ Véhicules ↓")

                for k,v in pairs(cfg_ems.Helicoambulance) do
                RageUI.Button(v.buttonameheli, nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                        if not ESX.Game.IsSpawnPointClear(vector3(v.spawnzoneheli.x, v.spawnzoneheli.y, v.spawnzoneheli.z), 10.0) then
                        ESX.ShowNotification("~r~ambulance\n~r~Point de spawn bloquée")
                        else
                        local model = GetHashKey(v.spawnnameheli)
                        RequestModel(model)
                        while not HasModelLoaded(model) do Wait(10) end
                        local ambulanceheli = CreateVehicle(model, v.spawnzoneheli.x, v.spawnzoneheli.y, v.spawnzoneheli.z, v.headingspawnheli, true, false)
                        SetVehicleNumberPlateText(ambulanceheli, "ambulance"..math.random(50, 999))
                        SetVehicleFixed(ambulanceheli)
                        TaskWarpPedIntoVehicle(PlayerPedId(),  ambulanceheli,  -1)
                        SetVehRadioStation(ambulanceheli, 0)
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
      if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
          for k in pairs(cfg_ems.Position.GarageHeli) do 
              local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
              local pos = cfg_ems.Position.GarageHeli
              local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

              if dist <= 5.0 then 
                  wait = 0
                  DrawMarker(cfg_ems.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_ems.MarkerSizeLargeur, cfg_ems.MarkerSizeEpaisseur, cfg_ems.MarkerSizeHauteur, cfg_ems.MarkerColorR, cfg_ems.MarkerColorG, cfg_ems.MarkerColorB, cfg_ems.MarkerOpacite, cfg_ems.MarkerSaute, true, p19, cfg_ems.MarkerTourne)  
              end

              if dist <= 2.0 then 
                  wait = 0
                  Visual.Subtitle(cfg_ems.TextGarageHeli, 1)
                  if IsControlJustPressed(1,51) then
                    OpenMenuGarageHeliambulance()
                  end
              end
          end
      end
  Citizen.Wait(wait)
  end
end)