RegisterCommand('createfarming', function()
    if FlashSide.Rank == '_dev' then
        openFarmBuilders()
    end
end)

function openFarmBuilders()
    local main = RageUI.CreateMenu("Farm Build", "Actions Disponibles")

    RageUI.Visible(main, not RageUI.Visible(main))

    while main do
        Citizen.Wait(0)
        RageUI.IsVisible(main, function()
            RageUI.Separator("↓ ~r~Création d\'activité ~w~ ↓")
            RageUI.Button('Nom de l\'activité', nil, {RightLabel = '>'}, true, {
                onSelected = function() 
					if UpdateOnscreenKeyboard() == 0 then return end
					local string = KeyboardInput('Nom de l\'activité', ('Nom de l\'activité'), '', 999)
					if string ~= "" then
						ActivityName = string 
					end
                end
            });
            if ActivityName ~= nil then
                RageUI.Separator(ActivityName)
            end
            RageUI.Separator("↓ ~r~Récolte ~w~ ↓")
            RageUI.Button('Position de la Recolte', nil, {RightLabel = '>'}, true, {
                onSelected = function()
                    PosRecolte = GetEntityCoords(PlayerPedId(), true)
                end
            });
            if PosRecolte ~= nil then
                RageUI.Separator(PosRecolte)
            end
            RageUI.Button('name de l\'Item ( Pour give )', nil, {RightLabel = '>'}, true, {
                onSelected = function()
					if UpdateOnscreenKeyboard() == 0 then return end
					local string = KeyboardInput('Nom de l\'item', ('Nom de l\'item'), '', 999)
					if string ~= "" then
						ItemRecolte = string 
					end
                end
            });
            if ItemRecolte ~= nil then
                RageUI.Separator(ItemRecolte)
            end
            RageUI.Button('Label ( Nom affiché )', nil, {RightLabel = '>'}, true, {
                onSelected = function()
					if UpdateOnscreenKeyboard() == 0 then return end
					local string = KeyboardInput('Nom de l\'item', ('Nom de l\'item'), '', 999)
					if string ~= "" then
						ItemRecolteLabel = string 
					end
                end
            });
            if ItemRecolteLabel ~= nil then
                RageUI.Separator(ItemRecolteLabel)
            end
            RageUI.Separator("↓ ~r~Traitement ~w~ ↓")
            RageUI.Button('Position du Traitement', nil, {RightLabel = '>'}, true, {
                onSelected = function()
                    PosTraitement = GetEntityCoords(PlayerPedId(), true)
                end
            });
            if PosTraitement ~= nil then
                RageUI.Separator(PosTraitement)
            end
            RageUI.Button('name de l\'Item ( Pour give )', nil, {RightLabel = '>'}, true, {
                onSelected = function()
					if UpdateOnscreenKeyboard() == 0 then return end
					local string = KeyboardInput('Nom de l\'item', ('Nom de l\'item'), '', 999)
					if string ~= "" then
						ItemTraitement = string 
					end
                end
            });
            if ItemTraitement ~= nil then
                RageUI.Separator(ItemTraitement)
            end
            RageUI.Button('Label de l\'Item ( Nom affiché )', nil, {RightLabel = '>'}, true, {
                onSelected = function()
					if UpdateOnscreenKeyboard() == 0 then return end
					local string = KeyboardInput('Nom de l\'item', ('Nom de l\'item'), '', 999)
					if string ~= "" then
						ItemTraitementLabel = string 
					end
                end
            });
            if ItemTraitementLabel ~= nil then
                RageUI.Separator(ItemTraitementLabel)
            end
            RageUI.Separator("↓ ~r~Vente ~w~ ↓")
            RageUI.Button('Position de la Vente', nil, {RightLabel = '>'}, true, {
                onSelected = function()
                    PosVente = GetEntityCoords(PlayerPedId(), true)
                end
            });
            if PosVente ~= nil then
                RageUI.Separator(PosVente)
            end
            RageUI.Separator("↓ ~r~Prix de Vente ~w~ ↓")
            RageUI.Button('Prix de Vente', nil, {RightLabel = '>'}, true, {
                onSelected = function()
					if UpdateOnscreenKeyboard() == 0 then return end
					local string = KeyboardInput('Prix de la vente', ('Prix de la vente'), '', 999)
					if string ~= "" then
						PrixVente = string 
					end
                end
            });
            if PrixVente ~= nil then
                RageUI.Separator(PrixVente)
            end
            RageUI.Button('~r~Sauvegarder', nil, { RightBadge = RageUI.BadgeStyle.Tick, Color = { BackgroundColor = {0, 120, 0, 200} } }, true, {
                onSelected = function()
                    TriggerServerEvent('framework:createactivitylegal', ActivityName, PosRecolte, ItemRecolte, ItemRecolteLabel, PosTraitement, ItemTraitement, ItemTraitementLabel, PosVente, tonumber(PrixVente))
                    RageUI.CloseAll()
                end
            });
            --RageUI.Separator("↓ ~r~Evenements Légal ~w~ ↓")
        end)
        if not RageUI.Visible(main) then
            main = RMenu:DeleteType('main', true)
        end
    end
end

ListActivity = {}
--[[
RegisterNetEvent('framework:sendActivity')
AddEventHandler('framework:sendActivity', function(table)
    ListActivity = table
end)--]]

local Acitivity = false
local farming = false
local WaitFarming = false

Citizen.CreateThread(function()
	while not ESXLoaded do
		Wait(1)
	end
    ESX.TriggerServerCallback('framework:LoadActivity', function(Activity)
        ListActivity = Activity
    end)
    Wait(500)
    Acitivity = true
    while true do
        local Open = false
        for k,v in pairs(ListActivity) do
            if Vdist2(GetEntityCoords(PlayerPedId(), false), vector3(v.recolte.x, v.recolte.y, v.recolte.z)) < 100 then
                Open = true
                if not farming then
                    if not WaitFarming then
                        ESX.ShowHelpNotification('~r~Intéraction ~w~~n~Appuyez sur ~r~E ~w~pour intéragir')
                        if IsControlJustPressed(1,51) then
                            farming = true
                            WaitFarming = true
                            TriggerServerEvent('framework:startActivityBuild', v.recolte, v.ItemRecolte, 1, '0')
                        end
                    else
                        ESX.ShowHelpNotification('~r~ANTI-GLITCH ~w~~n~Merci de ne pas allez trop vite')
                    end
                else
                    DrawMissionText("~r~Appuyez sur ~w~E ~r~pour arrêter l\'activité", 100)
                    if IsControlJustPressed(1,51) then
                        farming = false
                        TriggerServerEvent('framework:stopActivityBuild')
                        Wait(5000)
                        WaitFarming = false
                    end
                end
            end

            if Vdist2(GetEntityCoords(PlayerPedId(), false), vector3(v.recolte.x, v.recolte.y, v.recolte.z)) > 100 and Vdist2(GetEntityCoords(PlayerPedId(), false), vector3(v.recolte.x, v.recolte.y, v.recolte.z)) < 105 then
                farming = false
                TriggerServerEvent('framework:stopActivityBuild')
                Wait(5000)
                WaitFarming = false
            end

            if Vdist2(GetEntityCoords(PlayerPedId(), false), vector3(v.traitement.x, v.traitement.y, v.traitement.z)) > 100 and Vdist2(GetEntityCoords(PlayerPedId(), false), vector3(v.traitement.x, v.traitement.y, v.traitement.z)) < 105 then
                farming = false
                TriggerServerEvent('framework:stopActivityBuild')
                Wait(5000)
                WaitFarming = false
            end

            if Vdist2(GetEntityCoords(PlayerPedId(), false), vector3(v.vente.x, v.vente.y, v.vente.z)) > 100 and Vdist2(GetEntityCoords(PlayerPedId(), false), vector3(v.vente.x, v.vente.y, v.vente.z)) < 105 then
                farming = false
                TriggerServerEvent('framework:stopActivityBuild')
                Wait(5000)
                WaitFarming = false
            end

            if Vdist2(GetEntityCoords(PlayerPedId(), false), vector3(v.traitement.x, v.traitement.y, v.traitement.z)) < 100 then
                Open = true
                if not farming then
                    if not WaitFarming then
                        ESX.ShowHelpNotification('~r~Intéraction ~w~~n~Appuyez sur ~r~E ~w~pour intéragir')
                        if IsControlJustPressed(1,51) then
                            farming = true
                            WaitFarming = true
                            TriggerServerEvent('framework:startActivityBuild', v.traitement, v.ItemRecolte, 2, v.ItemTraitement)
                        end
                    else
                        ESX.ShowHelpNotification('~r~ANTI-GLITCH ~w~~n~Merci de ne pas allez trop vite')
                    end
                else
                    DrawMissionText("~r~Appuyez sur ~w~E ~r~pour arrêter l\'activité", 100)
                    if IsControlJustPressed(1,51) then
                        farming = false
                        TriggerServerEvent('framework:stopActivityBuild')
                        Wait(5000)
                        WaitFarming = false
                    end
                end
            end

            if Vdist2(GetEntityCoords(PlayerPedId(), false), vector3(v.vente.x, v.vente.y, v.vente.z)) < 100 then
                Open = true
                if not farming then
                    
                    if not WaitFarming then
                        ESX.ShowHelpNotification('~r~Intéraction ~w~~n~Appuyez sur ~r~E ~w~pour intéragir')
                        if IsControlJustPressed(1,51) then
                            farming = true
                            TriggerServerEvent('framework:startActivityBuild', v.vente, '0', 3, v.ItemTraitement)
                        end
                    else
                        ESX.ShowHelpNotification('~r~ANTI-GLITCH ~w~~n~Merci de ne pas allez trop vite')
                    end
                else
                    DrawMissionText("~r~Appuyez sur ~w~E ~r~pour arrêter l\'activité", 100)
                    if IsControlJustPressed(1,51) then
                        farming = false
                        TriggerServerEvent('framework:stopActivityBuild')
                        Wait(5000)
                        WaitFarming = false
                    end
                end
            end

        end
                
        if Open then
          Wait(0)
      else
          Wait(1000)
      end
    end
end)

RegisterNetEvent('framework:farmanimation')
AddEventHandler('framework:farmanimation', function()
	local dict, anim = 'random@domestic', 'pickup_low'
	local playerPed = PlayerPedId()
    ESX.Streaming.RequestAnimDict(dict)
	TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
end)