ESX = nil

TriggerEvent("esx:getSharedObject", function(obj)
	ESX = obj
end)


RegisterNetEvent('garage:creategarage')
AddEventHandler('garage:creategarage', function(Table)
    openCreateGarage()
end)

local GarageLoaded = false
local localCarsOwned = {}
local localCarsJobsOwned = {}
local localCarsOrgOwned = {}
local localFourriereVeh = 0

local Button = 1
local index = {
    list = 1
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
        Wait(1)
    end
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.PlayerData = ESX.GetPlayerData()
end)


function getByName(str)
    if str == "NULL" then
        return "Ce véhicule n'a pas de nom depuis son modèle."
    else
        return str
    end
end

Garage = {}

function Garage.isSpawnPointClea(pos, dst)
    local clear = true
    local vehicles = ESX.Game.GetVehicles()
    for k,v in pairs(vehicles) do
        if GetDistanceBetweenCoords(GetEntityCoords(v), pos, true) <= dst then
            clear = false
            break
        end
    end
    return clear
end

function openMenuGarage(SpawnPoint, TypeGarage, Heading)
    ESX.TriggerServerCallback('garage:getOwnedCars', function(ownedCars, ownedCarsJobs, OwnedCarsOrg)
        localCarsOwned = ownedCars
        localCarsJobsOwned = ownedCarsJobs
        localCarsOrgOwned = OwnedCarsOrg
        localFourriereTemporaire = ownedCars
        for k,v in pairs(localFourriereTemporaire) do 
            if not v.state and v.type == 'car' then
                localFourriereVeh = localFourriereVeh+1
            end
        end
        GarageLoaded = true
    end)
    local coords = GetEntityCoords(PlayerPedId());
    local zone = GetNameOfZone(coords.x, coords.y, coords.z);
    local zoneLabel = GetLabelText(zone);
    local menu = RageUI.CreateMenu("", zoneLabel)
    menu.TitleFont = 2
    menu:AddInstructionButton({
        [1] = GetControlInstructionalButton(1, 49, 0),
        [2] = "Renommer votre véhicule",
    })
    menu:AddInstructionButton({
        [1] = GetControlInstructionalButton(1, 246, 0),
        [2] = "Payer la fourière"
    })
    local Action = {
        'Aucun',
        'Entreprise',
        'Gang/Organisation',
        'Boutique'
    }
    RageUI.Visible(menu, not RageUI.Visible(menu))
    while not GarageLoaded do 
        Wait(1)
    end
    while menu do
        Citizen.Wait(0)
        FreezeEntityPosition(PlayerPedId(), true)
        RageUI.IsVisible(menu, function()
            RageUI.List('Filtre :', Action, index.list, nil, {}, true, {
                onListChange = function(Index, Item)
                    index.list = Index;
                    Button = Index;
                end,
            })
            if tostring(TypeGarage) == 'car' then
                if Button == 1 then
                RageUI.Separator('Vos véhicule(s).')
                    for k,v in pairs(localCarsOwned) do
                        if v.type == 'car' then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, (v.state == true and "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."" or "~r~Se véhicule se trouve à la Fourière !"), {RightBadge = RageUI.BadgeStyle.Tick}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        if ESX.GetPlayerData().job.name ~= 'unemployed' and ESX.GetPlayerData().job2.name ~= 'unemployed2' then
                                            openSelectedVehicle(v, SpawnPoint, false, TypeGarage, false, Heading)
                                        elseif ESX.GetPlayerData().job.name ~= 'unemployed' then
                                            openSelectedVehicle(v, SpawnPoint, false, TypeGarage, true, Heading)
                                        elseif ESX.GetPlayerData().job2.name ~= 'unemployed2' then
                                            openSelectedVehicle(v, SpawnPoint, true, TypeGarage, false, Heading)
                                        else
                                            openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                        end
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), (v.state == true and "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."" or "~r~Se véhicule se trouve à la Fourière !"), {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        if ESX.GetPlayerData().job.name ~= 'unemployed' and ESX.GetPlayerData().job2.name ~= 'unemployed2' then
                                            openSelectedVehicle(v, SpawnPoint, false, TypeGarage, false, Heading)
                                        elseif ESX.GetPlayerData().job.name ~= 'unemployed' then
                                            openSelectedVehicle(v, SpawnPoint, false, TypeGarage, true, Heading)
                                        elseif ESX.GetPlayerData().job2.name ~= 'unemployed2' then
                                            openSelectedVehicle(v, SpawnPoint, true, TypeGarage, false, Heading)
                                        else
                                            openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                        end
                                    end
                                })
                            end
                        end
                    end
                    if localFourriereVeh > 0 then
                        RageUI.Separator('↓ Véhicule(s) en fourière ↓')
                    for k,v in pairs(localCarsOwned) do
                        if v.type == 'car' and not v.state then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            end
                        end
                    end
                end
                elseif Button == 2 then
                    RageUI.Separator('Véhicule(s) de fonction.')
                    for k,v in pairs(localCarsJobsOwned) do
                        if v.type == 'car' and v.state and v.job ~= 'unemployed' then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            end
                        end
                    end
                    if localFourriereVeh > 0 then
                        RageUI.Separator('↓ Véhicule(s) en fourière ↓')
                    end
                    for k,v in pairs(localCarsJobsOwned) do
                        if v.type == 'car' and not v.state and v.job ~= 'unemployed' then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            end
                        end
                    end
                elseif Button == 3 then
                    RageUI.Separator('Véhicule(s) de Gang/Orga.')
                    for k,v in pairs(localCarsOrgOwned) do
                        if v.type == 'car' and v.state and v.job ~= 'unemployed2' then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            end
                        end
                    end
                    if localFourriereVeh > 0 then
                        RageUI.Separator('↓ Véhicule(s) en fourière ↓')
                    end
                    for k,v in pairs(localCarsOrgOwned) do
                        if v.type == 'car' and not v.state and v.job ~= 'unemployed' then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            end
                        end
                    end
                elseif Button == 4 then
                    RageUI.Separator('Vos véhicule(s) boutique.')
                    for k,v in pairs(localCarsOwned) do
                        if v.type == 'car' and v.state and v.boutique then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            end
                        end
                    end
                    if localFourriereVeh > 0 then
                        RageUI.Separator('↓ Véhicule(s) en fourière ↓')
                    end
                    for k,v in pairs(localCarsOwned) do
                        if v.type == 'car' and not v.state and v.boutique then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            end
                        end
                    end
                end
            elseif tostring(TypeGarage) == 'boat' then
                if Button == 1 then
                RageUI.Separator('Vos Bateaux.')
--                RageUI.Separator('~r~Véhicule dans votre garage')
                for k,v in pairs(localCarsOwned) do
                    if v.type == 'boat' and v.state then
                        if v.label ~= nil then 
                            RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                onActive = function()
                                    if (IsControlJustPressed(1, 49)) then
                                        local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                        if (input ~= nil) and (#input < 0) and (#input > 20) then
                                            return
                                        end
                                        TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                        RageUI.CloseAll()
                                        Wait(150)
                                        openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                    end
                                end,
                                onSelected = function()
                                    if ESX.GetPlayerData().job.name ~= 'unemployed' and ESX.GetPlayerData().job2.name ~= 'unemployed2' then
                                        openSelectedVehicle(v, SpawnPoint, false, TypeGarage, false, Heading)
                                    elseif ESX.GetPlayerData().job.name ~= 'unemployed' then
                                        openSelectedVehicle(v, SpawnPoint, false, TypeGarage, true, Heading)
                                    elseif ESX.GetPlayerData().job2.name ~= 'unemployed2' then
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, false, Heading)
                                    else
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                end
                            })
                        else
                            RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                onActive = function()
                                    if (IsControlJustPressed(1, 49)) then
                                        local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                        if (input ~= nil) and (#input < 0) and (#input > 20) then
                                            return
                                        end
                                        TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                        RageUI.CloseAll()
                                        Wait(150)
                                        openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                    end
                                end,
                                onSelected = function()
                                    if ESX.GetPlayerData().job.name ~= 'unemployed' and ESX.GetPlayerData().job2.name ~= 'unemployed2' then
                                        openSelectedVehicle(v, SpawnPoint, false, TypeGarage, false, Heading)
                                    elseif ESX.GetPlayerData().job.name ~= 'unemployed' then
                                        openSelectedVehicle(v, SpawnPoint, false, TypeGarage, true, Heading)
                                    elseif ESX.GetPlayerData().job2.name ~= 'unemployed2' then
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, false, Heading)
                                    else
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                end
                            })
                        end
                    end
                end
                if localFourriereVeh > 0 then
                    RageUI.Separator('↓ Véhicule(s) en fourière ↓')
                end
                for k,v in pairs(localCarsOwned) do
                    if v.type == 'boat' and not v.state then
                        if v.label ~= nil then 
                            RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                onActive = function()
                                    if (IsControlJustPressed(1, 246)) then
                                        ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                            if valid then
                                                RageUI.CloseAll()
                                                TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                RageUI.CloseAll()
                                                Wait(150)
                                                openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                            else
                                                ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                            end
                                        end, v.vehicle)
                                    end
                                end,
                                onSelected = function()
                                    Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                end
                            })
                        else
                            RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                onActive = function()
                                    if (IsControlJustPressed(1, 246)) then
                                        ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                            if valid then
                                                RageUI.CloseAll()
                                                TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                RageUI.CloseAll()
                                                Wait(150)
                                                openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                            else
                                                ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                            end
                                        end, v.vehicle)
                                    end
                                end,
                                onSelected = function()
                                    Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                end
                            })
                        end
                    end
                end
                elseif Button == 2 then
                    RageUI.Separator('Véhicule(s) de fonction.')
                    for k,v in pairs(localCarsJobsOwned) do
                        if v.type == 'boat' and v.state and v.job ~= 'unemployed' then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            end
                        end
                    end
                    RageUI.Separator('↓ Véhicule(s) en fourière ↓')
                    for k,v in pairs(localCarsJobsOwned) do
                        if v.type == 'boat' and not v.state and v.job ~= 'unemployed' then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            end
                        end
                    end
                elseif Button == 3 then
                    RageUI.Separator('Véhicule(s) de Gang/Orga.')
                    for k,v in pairs(localCarsOrgOwned) do
                        if v.type == 'boat' and v.state and v.job ~= 'unemployed2' then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            end
                        end
                    end
                    if localFourriereVeh > 0 then
                        RageUI.Separator('↓ Véhicule(s) en fourière ↓')
                    end
                    for k,v in pairs(localCarsOrgOwned) do
                        if v.type == 'boat' and not v.state and v.job ~= 'unemployed' then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            end
                        end
                    end
                elseif Button == 4 then
                    RageUI.Separator('Vos véhicule(s) boutique.')
                    for k,v in pairs(localCarsOwned) do
                        if v.type == 'boat' and v.state and v.boutique then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            end
                        end
                    end
                    if localFourriereVeh > 0 then
                        RageUI.Separator('↓ Véhicule(s) en fourière ↓')
                    end
                    RageUI.Separator('Vos véhicule(s) boutique.')
                    for k,v in pairs(localCarsOwned) do
                        if v.type == 'boat' and not v.state and v.boutique then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            end
                        end
                    end
                end
            elseif tostring(TypeGarage) == 'aircraft' then
                if Button == 1 then
                RageUI.Separator('Vos Avions.')
--                RageUI.Separator('~r~Véhicule dans votre garage')
                for k,v in pairs(localCarsOwned) do
                    if v.type == 'aircraft' and v.state then
                        if v.label ~= nil then 
                            RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                onActive = function()
                                    if (IsControlJustPressed(1, 49)) then
                                        local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                        if (input ~= nil) and (#input < 0) and (#input > 20) then
                                            return
                                        end
                                        TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                        RageUI.CloseAll()
                                        Wait(150)
                                        openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                    end
                                end,
                                onSelected = function()
                                    if ESX.GetPlayerData().job.name ~= 'unemployed' and ESX.GetPlayerData().job2.name ~= 'unemployed2' then
                                        openSelectedVehicle(v, SpawnPoint, false, TypeGarage, false, Heading)
                                    elseif ESX.GetPlayerData().job.name ~= 'unemployed' then
                                        openSelectedVehicle(v, SpawnPoint, false, TypeGarage, true, Heading)
                                    elseif ESX.GetPlayerData().job2.name ~= 'unemployed2' then
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, false, Heading)
                                    else
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                end
                            })
                        else
                            RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                onActive = function()
                                    if (IsControlJustPressed(1, 49)) then
                                        local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                        if (input ~= nil) and (#input < 0) and (#input > 20) then
                                            return
                                        end
                                        TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                        RageUI.CloseAll()
                                        Wait(150)
                                        openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                    end
                                end,
                                onSelected = function()
                                    if ESX.GetPlayerData().job.name ~= 'unemployed' and ESX.GetPlayerData().job2.name ~= 'unemployed2' then
                                        openSelectedVehicle(v, SpawnPoint, false, TypeGarage, false, Heading)
                                    elseif ESX.GetPlayerData().job.name ~= 'unemployed' then
                                        openSelectedVehicle(v, SpawnPoint, false, TypeGarage, true, Heading)
                                    elseif ESX.GetPlayerData().job2.name ~= 'unemployed2' then
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, false, Heading)
                                    else
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                end
                            })
                        end
                    end
                end
                if localFourriereVeh > 0 then
                    RageUI.Separator('↓ Véhicule(s) en fourière ↓')
                end
                for k,v in pairs(localCarsOwned) do
                    if v.type == 'aircraft' and not v.state then
                        if v.label ~= nil then 
                            RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                onActive = function()
                                    if (IsControlJustPressed(1, 246)) then
                                        ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                            if valid then
                                                RageUI.CloseAll()
                                                TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                RageUI.CloseAll()
                                                Wait(150)
                                                openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                            else
                                                ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                            end
                                        end, v.vehicle)
                                    end
                                end,
                                onSelected = function()
                                    Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                end
                            })
                        else
                            RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                onActive = function()
                                    if (IsControlJustPressed(1, 246)) then
                                        ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                            if valid then
                                                RageUI.CloseAll()
                                                TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                RageUI.CloseAll()
                                                Wait(150)
                                                openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                            else
                                                ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                            end
                                        end, v.vehicle)
                                    end
                                end,
                                onSelected = function()
                                    Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                end
                            })
                        end
                    end
                end
                elseif Button == 2 then
                    RageUI.Separator('Véhicule(s) de fonction.')
                    for k,v in pairs(localCarsJobsOwned) do
                        if v.type == 'aircraft' and v.state and v.job ~= 'unemployed' then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            end
                        end
                    end
                    if localFourriereVeh > 0 then
                        RageUI.Separator('↓ Véhicule(s) en fourière ↓')
                    end
                    for k,v in pairs(localCarsJobsOwned) do
                        if v.type == 'aircraft' and not v.state and v.job ~= 'unemployed' then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            end
                        end
                    end
                elseif Button == 3 then
                    RageUI.Separator('Véhicule(s) de Gang/Orga.')
                    for k,v in pairs(localCarsOrgOwned) do
                        if v.type == 'aircraft' and v.state and v.job ~= 'unemployed2' then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            end
                        end
                    end
                    if localFourriereVeh > 0 then
                        RageUI.Separator('↓ Véhicule(s) en fourière ↓')
                    end
                    for k,v in pairs(localCarsOrgOwned) do
                        if v.type == 'aircraft' and not v.state and v.job ~= 'unemployed' then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            end
                        end
                    end
                elseif Button == 4 then
                    RageUI.Separator('Vos véhicule(s) boutique.')
                    for k,v in pairs(localCarsOwned) do
                        if v.type == 'aircraft' and v.state and v.boutique then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 49)) then
                                            local input = KeyboardInput('Renommer votre véhicule', ('Renommer votre véhicule'), v.label, 20);
                                            if (input ~= nil) and (#input < 0) and (#input > 20) then
                                                return
                                            end
                                            TriggerServerEvent('garage:renameVehicle', v.owner, v.vehicle, input)
                                            RageUI.CloseAll()
                                            Wait(150)
                                            openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                        end
                                    end,
                                    onSelected = function()
                                        openSelectedVehicle(v, SpawnPoint, true, TypeGarage, true, Heading)
                                    end
                                })
                            end
                        end
                    end
                    if localFourriereVeh > 0 then
                        RageUI.Separator('↓ Véhicule(s) en fourière ↓')
                    end
                    for k,v in pairs(localCarsOwned) do
                        if v.type == 'aircraft' and not v.state and v.boutique then
                            if v.label ~= nil then 
                                RageUI.Button('['..GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))..'] - '..v.label, "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            else
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model)), "Informations sur votre véhicule\n\nPlaque : "..v.plate.."\n\nModel : "..getByName(GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))).."", {}, not v.state, {
                                    onActive = function()
                                        if (IsControlJustPressed(1, 246)) then
                                            ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                                                if valid then
                                                    RageUI.CloseAll()
                                                    TriggerServerEvent('garage:setstatevehicle', v.plate, true)
                                                    ESX.ShowNotification('Vous avez payé ~r~500$~s~ la fourrière de '..v.label or "Votre Voiture")
                                                    RageUI.CloseAll()
                                                    Wait(150)
                                                    openMenuGarage(SpawnPoint, TypeGarage, Heading)
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                                                end
                                            end, v.vehicle)
                                        end
                                    end,
                                    onSelected = function()
                                        Visual.Subtitle("~r~Facture :~s~ Appuyer sur ~r~Y~s~ pour payer la fourière de ~r~"..v.label or "Votre Voiture", 2000)
                                    end
                                })
                            end
                        end
                    end
                end
            end
        end, function()
        end)

        if not RageUI.Visible(menu) then
            localCarsOwned = {}
            localFourriereVeh = 0
            FreezeEntityPosition(PlayerPedId(), false)
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

function openSelectedVehicleFourriere(vehicle, SpawnPoint, TypeGarage)
    local menu = RageUI.CreateMenu("", "Votre choix")

    RageUI.Visible(menu, not RageUI.Visible(menu))
    while menu do
        Citizen.Wait(0)
        FreezeEntityPosition(PlayerPedId(), true)
        RageUI.IsVisible(menu, function()
            RageUI.Button('Payer la fourrière', 'Permet de recuperez votre véhicule', {RigthLabel = '500$'}, true, {
                onSelected = function()
                    ESX.TriggerServerCallback('garage:storeVehicleFourriere', function(valid)
                        if valid then
                            RageUI.CloseAll()
                            TriggerServerEvent('garage:setstatevehicle', vehicle.plate, true)
                            ESX.ShowNotification('Vous avez payé ~r~500$ la fourrière')
                        else
                            ESX.ShowNotification('~r~Vous n\'avez pas l\'argent nécéssaire')
                        end
                    end, vehicle.vehicle)
                end
            })
        end, function()
        end)

        if not RageUI.Visible(menu) then
            FreezeEntityPosition(PlayerPedId(), false)
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

function openSelectedVehicle(vehicle, SpawnPoint, entreprise, TypeGarage, gang, Heading)
    local coords = GetEntityCoords(PlayerPedId());
    local zone = GetNameOfZone(coords.x, coords.y, coords.z);
    local zoneLabel = GetLabelText(zone);
    local menu = RageUI.CreateMenu('', "Votre choix")

    RageUI.Visible(menu, not RageUI.Visible(menu))
    while menu do
        Citizen.Wait(0)
        FreezeEntityPosition(PlayerPedId(), true)
        RageUI.IsVisible(menu, function()
            RageUI.Button('Sortir le véhicule', nil, {}, true, {
                onSelected = function()
                    if not Garage.isSpawnPointClea(SpawnPoint, 2.5) then
                        ESX.ShowNotification("Il y a trop de véhicules dans la zone d'apparition.")
                        return
                    end
                    SpawnVehicle(vehicle.vehicle, vehicle.plate, SpawnPoint, Heading)
                    RageUI.CloseAll()
                    ESX.ShowNotification('Vous avez sorti ~r~'..vehicle.label.."~s~ du garage de "..zoneLabel)
                end
            })
            if not vehicle.boutique then
                RageUI.Button('Donner le véhicule', 'Permet de donner le véhicule au joueurs le plus proche de vous', {}, true, {
                    onActive = function()
                        local player, closestplayer = ESX.Game.GetClosestPlayer()
                        if player ~= -1 or closestplayer < 3.0 then
                            PlayerMakrer(player)
                        end
                    end,
                    onSelected = function()
                        local player, closestplayer = ESX.Game.GetClosestPlayer()
                        if player == -1 or closestplayer > 3.0 then
                            ESX.ShowNotification('~r~Aucun joueurs au alentours.')
                            return
                        else
                            TriggerServerEvent('garage:changevehicleowner', GetPlayerServerId(player), vehicle)
                            RageUI.CloseAll()
                        end
                    end
                })
            end
            if not entreprise then
                RageUI.Button('Attribuer le véhicule à son entreprise', 'Permet d\'attribuer le véhicule à votre entreprise\n\n~r~Avertissement ~s~: Vous ne pourrez en aucun cas le récupérer !', {}, true, {
                    onSelected = function()
                        RageUI.CloseAll()
                        if not vehicle.boutique then
                            TriggerServerEvent('garage:AttribuerVehicule', 'job', vehicle)
                        else
                            ESX.ShowNotification('~r~Avertissement~s~ : Vous ne pouvez pas attribuer un véhicule de la boutique a votre Entreprise.')
                        end
                    end
                })
            end
            if not gang then
                RageUI.Button('Attribuer le véhicule à son Gang/Organisation', 'Permet d\'attribuer le véhicule à votre Gang/Organisation\n\n~r~Avertissement ~s~: Vous ne pourrez en aucun cas le récupérer !', {}, true, {
                    onSelected = function()
                        RageUI.CloseAll()
                        if not vehicle.boutique then
                            TriggerServerEvent('garage:AttribuerVehicule', 'job2', vehicle)
                        else
                            ESX.ShowNotification('~r~Avertissement~s~ : Vous ne pouvez pas attribuer un véhicule de la boutique a votre Gang/Organisation.')
                        end
                    end
                })
            end
        end, function()
        end)

        if not RageUI.Visible(menu) then
            FreezeEntityPosition(PlayerPedId(), false)
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

function SpawnVehicle(vehicle, plate, SpawnPoint, Heading)
    local coords = SpawnPoint
	ESX.Game.SpawnVehicle(vehicle.model, coords, Heading, function(vehicleSpawn)
		ESX.Game.SetVehicleProperties(vehicleSpawn, vehicle)
		SetVehRadioStation(vehicleSpawn, 'OFF')
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicleSpawn, -1)
	end)
	
	TriggerServerEvent('garage:setstatevehicle', plate, false)
end

function PutVehicleInGarage(vehicle, vehicleProps)
	ESX.Game.DeleteVehicle(vehicle)
	TriggerServerEvent('garage:setstatevehicle', vehicleProps.plate, true)
	ESX.ShowNotification('Vous avez entreposé votre véhicule !')
end

function PlayerMakrer(player)
    local coordsPlayer = GetEntityCoords(player)
    DrawMarker(2, coordsPlayer.x, coordsPlayer.y, coordsPlayer.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 150, 255, 170, 0, 1, 2, 0, nil, nil, 0)
end

function openCreateGarage()
    local menu = RageUI.CreateMenu('', "Que souhaitez vous faire ?")
    local blip = false
    local BlipActive = false
    RageUI.Visible(menu, not RageUI.Visible(menu))
    while menu do
        Citizen.Wait(0)
        RageUI.IsVisible(menu, function()
            RageUI.Button('Nom du Garage', nil, {}, true, {
                onSelected = function()
                    NameGarage = KeyboardInput('Quelle nom voulez vous mettre?', ('Quelle nom voulez vous mettre?'), '', 999)
                end
            })
            if NameGarage ~= nil then
                RageUI.Separator(NameGarage)
            end
            RageUI.Button('Position du Garage', nil, {}, true, {
                onSelected = function()
                    PositionGarage = GetEntityCoords(PlayerPedId())
                end
            })
            if PositionGarage ~= nil then
                RageUI.Separator(PositionGarage)
            end
            RageUI.Button('Position du point de Spawn', nil, {}, true, {
                onSelected = function()
                    PositionPointSpawn = GetEntityCoords(PlayerPedId())
                end
            })
            if PositionPointSpawn ~= nil then
                RageUI.Separator(PositionPointSpawn)
            end
            RageUI.Button('Position du point de Delete', nil, {}, true, {
                onSelected = function()
                    PositionPointDelete = GetEntityCoords(PlayerPedId())
                end
            })
            if PositionPointDelete ~= nil then
                RageUI.Separator(PositionPointDelete)
            end
            RageUI.Button('Alignement du garage', nil, {}, true, {
                onSelected = function()
                    Heading = GetEntityHeading(PlayerPedId())
                end
            })
            if Heading ~= nil then
                RageUI.Separator(Heading)
            end
            RageUI.Button('Type de garage', 'car, aircraft ou boat', {}, true, {
                onSelected = function()
                    TypeGarage = KeyboardInput('Quelle nom voulez vous mettre?', ('Quelle nom voulez vous mettre?'), '', 999)
                end
            })
            if TypeGarage ~= nil then
                RageUI.Separator(TypeGarage)
            end
            RageUI.Checkbox('Blip sur la map', nil, blip, {}, {
                onChecked = function()
                    blip = true
                    BlipActive = true
                end,
                onUnChecked = function()
                    blip = false
                    BlipActive = false
                end,
            })
            RageUI.Button('~r~Valider le garage', nil, {}, true, {
                onSelected = function()
                    RageUI.CloseAll()
                    TriggerServerEvent('garage:createGarage', NameGarage, PositionGarage, PositionPointSpawn, PositionPointDelete, TypeGarage, Heading, BlipActive)
                    if BlipActive then
                        local blip = AddBlipForCoord(PositionGarage)
                        SetBlipSprite(blip, 357)
                        SetBlipDisplay(blip, 4)
                        SetBlipScale(blip, 0.6)
                        SetBlipColour(blip, 36)
                        SetBlipAsShortRange(blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        if tostring(TypeGarage) == 'car' then
                            AddTextComponentString('Garage Publique')
                        elseif tostring(TypeGarage) == 'boat' then
                            AddTextComponentString('Garage Bateaux')
                        elseif tostring(TypeGarage) == 'aircraft' then
                            AddTextComponentString('Garage Avions')
                        else
                            AddTextComponentString('Garage Publique')
                        end
                        EndTextCommandSetBlipName(blip)
                    end
                end
            })
        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

local Garage = {}
local GarageLoaded = false

RegisterNetEvent('garage:refreshGarage')
AddEventHandler('garage:refreshGarage', function(Table)
    Garage = Table
    GarageLoaded = true
end)

Citizen.CreateThread(function()
    Wait(1000)
    TriggerServerEvent('garage:InitGarage')
end)

RegisterCommand("garage:modify", function(source)
    modifyCreateGarage()
end, false)

local roo = false

local nice = true

Citizen.CreateThread(function()
    while true do
        if roo then
            Citizen.Wait(1000)
            if nice then nice = false end
            Citizen.Wait(1000)
            if not nice then nice = true end
        else
            Citizen.Wait(4000)
        end
    end
end)

function modifyCreateGarage()
    if ESX.GetPlayerData()["group"] ~= "_dev" then return end
    local modify = RageUI.CreateMenu('', "Que faire ?")

    RageUI.Visible(modify, not RageUI.Visible(modify))

    while modify do
        Wait(0)
        RageUI.IsVisible(modify, function()
            for _, data in pairs(Garage) do
                RageUI.Separator("↓ Garage ~q~n°"..data.id.."~s~ ↓")
                RageUI.Button("Nom : "..data.name, nil, {}, true, {
                    onActive = function()
                        roo = false
                    end,
                    onSelected = function()

                    end
                })
                RageUI.Button("Marker Garage", "X : "..data.position.x.."\nY : "..data.position.y.."\nZ : "..data.position.z, {}, true, {
                    onActive = function()
                        roo = true
                        if nice then
                            Visual.Subtitle("Appuyer sur ~r~E~s~ pour changer le point du garage !", 1)
                        else
                            Visual.Subtitle("Appuyer sur ~r~ENTRÉE~s~ pour vous téléporter au point de spawn !", 1)
                        end
                        
                        if (IsControlJustPressed(1, 86)) then
                            TriggerServerEvent("garage:modify", "pos", data.id, GetEntityCoords(PlayerPedId()))
                        end
                    end,
                    onSelected = function()
                        SetEntityCoords(PlayerPedId(), data.position.x, data.position.y, data.position.y)
                    end
                })
                RageUI.Button("Point de Spawn", "X : "..data.SpawnPoint.x.."\nY : "..data.SpawnPoint.y.."\nZ : "..data.SpawnPoint.z, {}, true, {
                    onActive = function()
                        roo = true
                        if nice then
                            Visual.Subtitle("Appuyer sur ~r~E~s~ pour changer le point de spawn !", 1)
                        else
                            Visual.Subtitle("Appuyer sur ~r~ENTRÉE~s~ pour vous téléporter au point de spawn !", 1)
                        end
                        
                        if (IsControlJustPressed(1, 86)) then
                            TriggerServerEvent("garage:modify", "SpawnPoint", data.id, GetEntityCoords(PlayerPedId()))
                        end
                    end,
                    onSelected = function()
                        SetEntityCoords(PlayerPedId(), data.SpawnPoint.x, data.SpawnPoint.y, data.SpawnPoint.y)
                        SetEntityHeading(PlayerPedId(), data.Heading)
                    end
                })
                RageUI.Button("Allignement du spawn", "Heading : "..data.Heading, {}, true, {
                    onActive = function()
                        roo = true
                        if nice then
                            Visual.Subtitle("Appuyer sur ~r~E~s~ pour changer l'alignement !", 1)
                        else
                            Visual.Subtitle("Appuyer sur ~r~ENTRÉE~s~ pour vous alligner au même niveau !", 1)
                        end
                        
                        if (IsControlJustPressed(1, 86)) then
                            TriggerServerEvent("garage:modify", "Heading", data.id, GetEntityHeading(PlayerPedId()))
                        end
                    end,
                    onSelected = function()
                        SetEntityHeading(PlayerPedId(), data.Heading)
                    end
                })
                RageUI.Button("Ranger le véhicule", "X : "..data.DeletePoint.x.."\nY : "..data.DeletePoint.y.."\nZ : "..data.DeletePoint.z, {}, true, {
                    onActive = function()
                        roo = true
                        if nice then
                            Visual.Subtitle("Appuyer sur ~r~E~s~ pour changer le point de suppression !", 1)
                        else
                            Visual.Subtitle("Appuyer sur ~r~ENTRÉE~s~ pour vous téléporter au point de suppression !", 1)
                        end
                        
                        if (IsControlJustPressed(1, 86)) then
                            TriggerServerEvent("garage:modify", "DeletePoint", data.id, GetEntityCoords(PlayerPedId()))
                        end
                    end,
                    onSelected = function()
                        SetEntityCoords(PlayerPedId(), data.DeletePoint.x, data.DeletePoint.y, data.DeletePoint.y)
                    end
                })
            end
        end)
        if not RageUI.Visible(modify) then
            modify = RMenu:DeleteType('modify', true)
            roo = false
        end
    end
end

Citizen.CreateThread(function()
    while not GarageLoaded do 
        Wait(1)
    end
    
    for k,v in pairs(Garage) do
        if v.blip == 1 or v.blip == true then
            if tostring(v.type) == 'car' then
                local blip = AddBlipForCoord(v.position.x, v.position.y, v.position.z)
                SetBlipSprite(blip, 357)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.5)
                SetBlipColour(blip, 36)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Garage Publique')
                EndTextCommandSetBlipName(blip)
            elseif tostring(v.type) == 'boat' then
                local blip = AddBlipForCoord(v.position.x, v.position.y, v.position.z)
                SetBlipSprite(blip, 357)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.5)
                SetBlipColour(blip, 36)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Garage Bateaux')
                EndTextCommandSetBlipName(blip)
            elseif tostring(v.type) == 'aircraft' then
                local blip = AddBlipForCoord(v.position.x, v.position.y, v.position.z)
                SetBlipSprite(blip, 357)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.5)
                SetBlipColour(blip, 36)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Garage Avions')
                EndTextCommandSetBlipName(blip)
            else
                local blip = AddBlipForCoord(v.position.x, v.position.y, v.position.z)
                SetBlipSprite(blip, 357)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.5)
                SetBlipColour(blip, 36)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Garage Publique')
                EndTextCommandSetBlipName(blip)
            end
        end
    end

    while true do 
        local isProche = false
        for k,v in pairs(Garage) do
            local PointGarage = vector3(v.position.x, v.position.y, v.position.z)

            local DistanceGarage = Vdist2(GetEntityCoords(PlayerPedId(), false), PointGarage)

            if DistanceGarage < 500 then
                isProche = true
                DrawMarker(36, vector3(v.position.x, v.position.y, v.position.z), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 207, 36, 93, 150, false, true, 2, true, false, false, false)
            end
            if DistanceGarage < 3 then
                ESX.ShowHelpNotification("~r~Descriptions~s~: Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                if IsControlJustPressed(1,51) then
                    openMenuGarage(vector3(v.SpawnPoint.x, v.SpawnPoint.y, v.SpawnPoint.z), v.type, v.Heading)
                end
            end

            -- DELETE POINT

            local DeletePoint = vector3(v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z)

            local DistanceDeletePoint = Vdist2(GetEntityCoords(PlayerPedId(), false), DeletePoint)

            if DistanceDeletePoint < 500 then
                isProche = true
                if v.type == 'boat' then
                    DrawMarker(36, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 36, 207, 93, 150, false, true, 2, true, false, false, false)
                else
                    DrawMarker(36, v.DeletePoint.x, v.DeletePoint.y, v.DeletePoint.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 36, 207, 93, 150, false, true, 2, true, false, false, false)
                end
            end
            if DistanceDeletePoint < 3 then
                ESX.ShowHelpNotification("~r~Descriptions~s~: Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                if IsControlJustPressed(1,51) then
                    if IsPedSittingInAnyVehicle(PlayerPedId()) then
                        openRangerVehicle(GetEntityCoords(PlayerPedId()))
                    else
                        ESX.ShowNotification('~r~Vous n\'êtes pas dans un véhicule')
                    end
                end
            end
        end
        
		if isProche then
			Wait(0)
		else
			Wait(750)
		end
    end
end)

function openRangerVehicle(position)
    local menu = RageUI.CreateMenu('', "Que souhaitez vous faire ?")
    RageUI.Visible(menu, not RageUI.Visible(menu))
    while menu do
        Citizen.Wait(0)
        RageUI.IsVisible(menu, function() 
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
            if GetEntityHealth(vehicle) == GetEntityMaxHealth(vehicle) then
                RageUI.Button('Ranger le véhicule', nil, {}, true, {
                    onSelected = function()
                        local NewPosition = Vdist2(GetEntityCoords(PlayerPedId(), false), position)
                        if NewPosition < 20 then
                            ESX.TriggerServerCallback('garage:storevehicle', function(valid)
                                if valid then
                                    RageUI.CloseAll()
                                    PutVehicleInGarage(vehicle, vehicleProps)
                                else
                                    ESX.ShowNotification('Ce véhicule ne vous appartient pas')
                                end
                            end, vehicleProps)
                        else
                            ESX.ShowNotification('Vous êtes trop loin du point')
                        end
                    end
                })
            else
                RageUI.Separator('↓ ~r~Votre véhicule est endomagé~s~ ↓')
                RageUI.Button('Payer la réparation et ranger le véhicule', nil, {}, true, {
                    onSelected = function()
                        ESX.TriggerServerCallback('garage:storevehiclewithmoney', function(valid)
                            if valid then
                                RageUI.CloseAll()
                                PutVehicleInGarage(vehicle, vehicleProps)
                            else
                                ESX.ShowNotification('Ce véhicule ne vous appartient pas')
                            end
                        end, vehicleProps)
                    end
                })
            end
        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end