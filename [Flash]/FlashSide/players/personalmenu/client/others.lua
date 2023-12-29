
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	RefreshMoney()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
	RefreshMoney2()
end)

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		societymoney = ESX.Math.GroupDigits(money)
	end
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job2.name == society then
		societymoney2 = ESX.Math.GroupDigits(money)
    end
end)

function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			societymoney = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job.name)
	end
end

function RefreshMoney2()
	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			societymoney2 = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job2.name)
	end
end

--Fonctions des accesoires 
function setAccess(value, plyPed)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:getSkin', function(skina)
            if value == 'mask' then
                if skin.mask_1 ~= skina.mask_1 then
                    ExecuteCommand("me remet son Masque")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['mask_1'] = skin.mask_1, ['mask_2'] = skin.mask_2 })
                else
                    ExecuteCommand("me retire son Masque")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['mask_1'] = 0, ['mask_2'] = 0 })
                end
            elseif value == 'chain' then
                if skin.chain_1 ~= skina.chain_1 then
                    ExecuteCommand("me remet sa Chaine")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['chain_1'] = skin.chain_1, ['chain_2'] = skin.chain_2 })
                else
                    ExecuteCommand("me retire sa Chaine")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['chain_1'] = 0, ['chain_2'] = 0 })
                end
            elseif value == 'helmet' then
                if skin.helmet_1 ~= skina.helmet_1 then
                    ExecuteCommand("me remet son Casque")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['helmet_1'] = skin.helmet_1, ['helmet_2'] = skin.helmet_2 })
                else
                    ExecuteCommand("me retire son Casque")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['helmet_1'] = -1, ['helmet_2'] = 0 })
                end
            elseif value == 'glasses' then
                if skin.glasses_1 ~= skina.glasses_1 then
                    ExecuteCommand("me retire ses Lunette")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['glasses_1'] = skin.glasses_1, ['glasses_2'] = skin.glasses_2 })
                else
                    if skin.sex == 0 then
                        ExecuteCommand("me retire ses Lunette")
                        TriggerEvent('skinchanger:loadClothes', skina, { ['glasses_1'] = 0, ['glasses_2'] = 0 })
                    else
                        TriggerEvent('skinchanger:loadClothes', skina, { ['glasses_1'] = 5, ['glasses_2'] = 0 })
                    end
                end
            elseif value == 'ears' then
                if skin.ears_1 ~= skina.ears_1 then
                    ExecuteCommand("me retire ses Boucle d'oreilles")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['ears_1'] = skin.ears_1, ['ears_2'] = skin.ears_2 })
                else
                    ExecuteCommand("me retire ses Boucle d'oreilles")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['ears_1'] = 0, ['ears_2'] = 0 })
                end
            end
        end)
    end)
end

--Fonction poids
function GetCurrentWeight()
	local currentWeight = 0
	for i = 1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].count > 0 then
			currentWeight = currentWeight + (ESX.PlayerData.inventory[i].weight * ESX.PlayerData.inventory[i].count)
		end
	end
	return currentWeight
end

--Check Quantity 
function CheckQuantity(number)
    number = tonumber(number)

    if type(number) == "number" then
        number = ESX.Math.Round(number)

        if number > 0 then
            return true, number
        end
    end

    return false, number
end

--Player Marker
function PlayerMakrer(player)
    local ped = GetPlayerPed(player)
    local pos = GetEntityCoords(ped)
    DrawMarker(2, pos.x, pos.y, pos.z+1.0, 0.0, 0.0, 0.0, 179.0, 0.0, 0.0, 0.25, 0.25, 0.25, 81, 203, 231, 200, 0, 1, 2, 1, nil, nil, 0)
end

local noir = false
RegisterCommand('noir', function()
    noir = not noir
    if noir then 
        DisplayRadar(false) 
        TriggerEvent("tempui:toggleUi", true)
        TriggerEvent('hideSoifEtFaimFDP', false)
    end
    while noir do
        if not HasStreamedTextureDictLoaded('revolutionbag') then
            RequestStreamedTextureDict('revolutionbag')
            while not HasStreamedTextureDictLoaded('revolutionbag') do
                Citizen.Wait(50)
            end
        end

        DrawSprite('revolutionbag', 'cinema', 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
        Citizen.Wait(0)
    end
    DisplayRadar(true)
    TriggerEvent('hideSoifEtFaimFDP', true)
    TriggerEvent("tempui:toggleUi", false)
    SetStreamedTextureDictAsNoLongerNeeded('revolutionbag')
end)

RegisterNetEvent('framework:tp', function(coords)
    SetEntityCoords(PlayerPedId(), coords, false, false, false, false)
end)