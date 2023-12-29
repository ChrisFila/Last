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

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

function Menuf6Bahamas()
    local fBahamasf6 = FlashSideUI.CreateMenu("", "Interactions")
    fBahamasf6:SetRectangleBanner(153, 50, 204)
    FlashSideUI.Visible(fBahamasf6, not FlashSideUI.Visible(fBahamasf6))
    while fBahamasf6 do
        Citizen.Wait(0)
            FlashSideUI.IsVisible(fBahamasf6, true, true, true, function()

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
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_bahamas', ('Bahamas'), montant)
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
                        TriggerServerEvent('fBahamas:Ouvert')
                    end
                end)
        
                FlashSideUI.ButtonWithStyle("Annonces de fermeture",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then      
                        TriggerServerEvent('fBahamas:Fermer')
                    end
                end)
        
                FlashSideUI.ButtonWithStyle("Personnalisé", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        local msg = KeyboardInput("Message", "", "", 100)
                        TriggerServerEvent('fBahamas:Perso', msg)
                    end
                end)
                end, function() 
                end)
    
                if not FlashSideUI.Visible(fBahamasf6) then
                    fBahamasf6 = RMenu:DeleteType("Bahamas", true)
        end
    end
end

Keys.Register('F6', 'Bahamas', 'Ouvrir le menu Bahamas', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bahamas' then
    	Menuf6Bahamas()
	end
end)

function OpenPrendreMenu()
    local PrendreMenu = FlashSideUI.CreateMenu("", "Nos produits")
    PrendreMenu:SetRectangleBanner(153, 50, 204)
        FlashSideUI.Visible(PrendreMenu, not FlashSideUI.Visible(PrendreMenu))
    while PrendreMenu do
        Citizen.Wait(0)
            FlashSideUI.IsVisible(PrendreMenu, true, true, true, function()
            for k,v in pairs(BahamasBar.item) do
            FlashSideUI.ButtonWithStyle(v.Label.. ' Prix: ' .. v.Price .. '€', nil, { }, true, function(Hovered, Active, Selected)
              if (Selected) then
                  TriggerServerEvent('fBahamas:bar', v.Name, v.Price)
                end
            end)
        end
                end, function() 
                end)
    
                if not FlashSideUI.Visible(PrendreMenu) then
                    PrendreMenu = RMenu:DeleteType("Bahamas", true)
        end
    end
end


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bahamas' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Bahamas.pos.MenuPrendre.position.x, Bahamas.pos.MenuPrendre.position.y, Bahamas.pos.MenuPrendre.position.z)
        if dist3 <= 7.0 and Bahamas.jeveuxmarker then
            Timer = 0
            DrawMarker(20, Bahamas.pos.MenuPrendre.position.x, Bahamas.pos.MenuPrendre.position.y, Bahamas.pos.MenuPrendre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 153, 50, 204, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        FlashSideUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour accéder au bar", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            OpenPrendreMenu()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)



function Coffrebahamas()
    local Cbahamas = FlashSideUI.CreateMenu("", "Bahamas")
    Cbahamas:SetRectangleBanner(153, 50, 204)
        FlashSideUI.Visible(Cbahamas, not FlashSideUI.Visible(Cbahamas))
            while Cbahamas do
            Citizen.Wait(0)
            FlashSideUI.IsVisible(Cbahamas, true, true, true, function()

                FlashSideUI.Separator("↓ Objet / Arme ↓")

                    FlashSideUI.ButtonWithStyle("Retirer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            BahamasRetirerobjet()
                            FlashSideUI.CloseAll()
                        end
                    end)
                    
                    FlashSideUI.ButtonWithStyle("Déposer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            BahamasDeposerobjet()
                            FlashSideUI.CloseAll()
                        end
                    end)
                end, function()
                end)
            if not FlashSideUI.Visible(Cbahamas) then
            Cbahamas = RMenu:DeleteType("Cbahamas", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bahamas' then
            local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Bahamas.pos.coffre.position.x, Bahamas.pos.coffre.position.y, Bahamas.pos.coffre.position.z)
            if jobdist <= 10.0 and Bahamas.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Bahamas.pos.coffre.position.x, Bahamas.pos.coffre.position.y, Bahamas.pos.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 153, 50, 204, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        FlashSideUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        Coffrebahamas()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)


-- Garage

function GarageBahamas()
  local GBahamas = FlashSideUI.CreateMenu("", "Bahamas")
  GBahamas:SetRectangleBanner(153, 50, 204)
    FlashSideUI.Visible(GBahamas, not FlashSideUI.Visible(GBahamas))
        while GBahamas do
            Citizen.Wait(0)
                FlashSideUI.IsVisible(GBahamas, true, true, true, function()
                    FlashSideUI.ButtonWithStyle("Ranger la voiture", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then   
                        local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                        if dist4 < 4 then
                            DeleteEntity(veh)
                            FlashSideUI.CloseAll()
                            end 
                        end
                    end) 

                    for k,v in pairs(GBahamasvoiture) do
                    FlashSideUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                        Citizen.Wait(1)  
                            spawnuniCarBahamas(v.modele)
                            FlashSideUI.CloseAll()
                            end
                        end)
                    end
                end, function()
                end)
            if not FlashSideUI.Visible(GBahamas) then
            GBahamas = RMenu:DeleteType("Garage", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bahamas' then
            local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Bahamas.pos.garage.position.x, Bahamas.pos.garage.position.y, Bahamas.pos.garage.position.z)
            if dist3 <= 10.0 and Bahamas.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Bahamas.pos.garage.position.x, Bahamas.pos.garage.position.y, Bahamas.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 153, 50, 204, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist3 <= 3.0 then
                Timer = 0   
                    FlashSideUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour accéder au garage", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
                        GarageBahamas()
                    end   
                end
            end 
        Citizen.Wait(Timer)
     end
end)

function spawnuniCarBahamas(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Bahamas.pos.spawnvoiture.position.x, Bahamas.pos.spawnvoiture.position.y, Bahamas.pos.spawnvoiture.position.z, Bahamas.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local newPlate = GenerateSocietyPlate('BAHAMAS')
    SetVehicleNumberPlateText(vehicle, newPlate)
    TriggerServerEvent('garage:RegisterNewKey', 'no', newPlate)
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
end



itemstock = {}
function BahamasRetirerobjet()
    local Stockbahamas = FlashSideUI.CreateMenu("", "Bahamas")
    Stockbahamas:SetRectangleBanner(153, 50, 204)
    ESX.TriggerServerCallback('fbahamas:getStockItems', function(items) 
    itemstock = items
   
    FlashSideUI.Visible(Stockbahamas, not FlashSideUI.Visible(Stockbahamas))
        while Stockbahamas do
            Citizen.Wait(0)
                FlashSideUI.IsVisible(Stockbahamas, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count > 0 then
                            FlashSideUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", "", "", 2)
                                    TriggerServerEvent('fbahamas:getStockItem', v.name, tonumber(count))
                                    BahamasRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not FlashSideUI.Visible(Stockbahamas) then
            Stockbahamas = RMenu:DeleteType("Coffre", true)
        end
    end
     end)
end

local PlayersItem = {}
function BahamasDeposerobjet()
    local StockPlayer = FlashSideUI.CreateMenu("", "Bahamas")
    StockPlayer:SetRectangleBanner(153, 50, 204)
    ESX.TriggerServerCallback('fbahamas:getPlayerInventory', function(inventory)
        FlashSideUI.Visible(StockPlayer, not FlashSideUI.Visible(StockPlayer))
    while StockPlayer do
        Citizen.Wait(0)
            FlashSideUI.IsVisible(StockPlayer, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        FlashSideUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' ,'', 8)
                                            TriggerServerEvent('fbahamas:putStockItems', item.name, tonumber(count))
                                            BahamasDeposerobjet()
                                        end
                                    end)
                                end
                            else
                                FlashSideUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not FlashSideUI.Visible(StockPlayer) then
                StockPlayer = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end