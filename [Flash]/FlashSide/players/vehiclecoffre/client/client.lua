RegisterCommand("openclosecoffre", function()
	local plyPed = PlayerPedId()
	local vehicle = VehicleInFront(plyPed)
	
	if vehicle ~= nil and IsPedOnFoot(plyPed) then
		if DoesVehicleHaveDoor(vehicle, 5) or VehicleCoffre.NoTrunkVehicles[GetEntityModel(vehicle)] ~= nil then
			if GetVehicleDoorLockStatus(vehicle) == 1 then
                ExecuteCommand('me ouvre le coffre du véhicule')
				OpenNewCoffre(vehicle)
			else
				ESX.ShowNotification('Ce coffre est ~r~fermé')
			end
		else
			ESX.ShowNotification('Ce ~r~véhicule~w~ ne possède pas de coffre.')
		end

		ESX.ShowNotification('Pas de ~r~coffre~w~ à proximité')
	end
end, false)

RegisterKeyMapping('openclosecoffre', 'Ouvrir/Fermer le coffre', 'keyboard', 'L')

function VehicleInFront(ped)
	local entCoords = GetEntityCoords(ped, false)
	local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 4.0, 0.0)
	local ray = StartShapeTestRay(entCoords, offset, 2, ped, 0)
	local _, _, _, _, result = GetShapeTestResult(ray)

	return result
end

function OpenNewCoffre(vehicle)
    local menu = RageUI.CreateMenu("", "Actions disponible")
	SetVehicleDoorOpen(vehicle, 5, false, false)
    RageUI.Visible(menu, not RageUI.Visible(menu))

    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()

        RageUI.Button('Retirer Objet', nil, {}, true, {
            onSelected = function()
                OpenCoffreVehicle(vehicle)
            end
        })
        RageUI.Button('Déposer Objet', nil, {}, true, {
            onSelected = function()
                RageUI.CloseAll()
                OpenPlayerCoffre(vehicle)
            end
        })
        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

function OpenPlayerCoffre(vehicle)
    local loaded = false
    local data
    local name
    local money
    local blackmoney
   
    ESX.TriggerServerCallback('Ewen:GetPlayerData', function(result)
        data = result
        name = result.name
        money = result.money
        blackmoney = result.blackmoney
        loaded = true
    end, GetPlayerServerId(PlayerId()))
    while not loaded do 
        Wait(1)
    end
    local inventaireplayer = RageUI.CreateMenu('', "Inventaire")
    RageUI.Visible(inventaireplayer, not RageUI.Visible(inventaireplayer))
	while inventaireplayer do
		Citizen.Wait(0)
        RageUI.IsVisible(inventaireplayer, function()
            RageUI.Separator('↓ ~r~Objets~s~ ↓')
            for k,v in pairs(data.inventory) do
                RageUI.Button(v.label, nil, { RightLabel = "Quantité(e)s : ~r~"..v.count }, true, {
                    onSelected = function()
                        quantity = KeyboardInput('Combien voulez vous déposer ?', ('Combien voulez vous déposer ?'), '', 30)
						FlashSideClientUtils.toServer('esx_truck_inventory:putItem', v.name, 'item_standard', tonumber(quantity), GetVehicleNumberPlateText(vehicle))
                        RageUI.CloseAll()
                    end
                })
            end
            RageUI.Separator('↓ ~r~Armes~s~ ↓')
            for k,v in pairs(data.weapons) do
                RageUI.Button(v.label, nil, { RightLabel = "Munitions : ~r~"..v.ammo }, true, {
                    onSelected = function()
                        FlashSideClientUtils.toServer('esx_truck_inventory:putItem', v.name, 'item_weapon', v.ammo, GetVehicleNumberPlateText(vehicle))
                        RageUI.CloseAll()
                    end
                })
            end
        end)
        if not RageUI.Visible(inventaireplayer) then
            inventaireplayer = RMenu:DeleteType('inventaireplayer', true)
        end
    end
end

function OpenCoffreVehicle(vehicle)
    local loaded = false
    local data2
   
    ESX.TriggerServerCallback('esx_truck_inventory:getTrunkInventory', function(inventory)
        data2 = inventory
        loaded = true
    end, GetVehicleNumberPlateText(vehicle))
    while not loaded do 
        Wait(1)
    end
    local inventaireplayer = RageUI.CreateMenu('', "Inventaire")
    RageUI.Visible(inventaireplayer, not RageUI.Visible(inventaireplayer))
	while inventaireplayer do
		Citizen.Wait(0)
        RageUI.IsVisible(inventaireplayer, function()
            RageUI.Separator('↓ ~r~Objets~s~ ↓')
            for k,v in pairs(data2.items) do 
                if v.count ~= 0 then
                    RageUI.Button(v.label, nil, { RightLabel = "Quantité(e)s : ~r~"..v.count }, true, {
                        onSelected = function()
                            quantity = KeyboardInput('Combien voulez vous prendre ?', ('Combien voulez vous prendre ?'), '', 30)
                            FlashSideClientUtils.toServer('esx_truck_inventory:getItem', v.name, 'item_standard', tonumber(quantity), GetVehicleNumberPlateText(vehicle))
                            RageUI.CloseAll()
                        end
                    })
                end
            end
            RageUI.Separator('↓ ~r~Armes~s~ ↓')
            for k,v in pairs(data2.weapons) do
                RageUI.Button(ESX.GetWeaponLabel(v.name), nil, { RightLabel = "Munitions : ~r~"..v.ammo }, true, {
                    onSelected = function()
						FlashSideClientUtils.toServer('esx_truck_inventory:getItem', v.name, 'item_weapon', v.ammo, GetVehicleNumberPlateText(vehicle))
                        RageUI.CloseAll()
                    end
                })
            end
        end)
        if not RageUI.Visible(inventaireplayer) then
            inventaireplayer = RMenu:DeleteType('inventaireplayer', true)
        end
    end
end