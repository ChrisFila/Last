local ActivityKarting = false
local KartingVehicle = nil

Citizen.CreateThread(function()
    while true do
        local isProche = false
        local dist = Vdist2(GetEntityCoords(PlayerPedId(), false), vector3(-181.63566589355,-2158.2509765625,16.705102920532))
        local dist2 = Vdist2(GetEntityCoords(PlayerPedId(), false), vector3(-176.42628479004,-2139.0146484375,18.828392028809))
        
        if dist < 150 then
            if IsPedSittingInVehicle(PlayerPedId(), KartingVehicle) then
                ForceDeleteEntity(KartingVehicle)
                ActivityKarting = false
                ESX.ShowNotification('FlashSide ~w~~n~Vous avez quitté la zone du karting, Votre véhicule à été saisie')
            end
        end
        if dist2 < 50 then
            if IsPedSittingInVehicle(PlayerPedId(), KartingVehicle) then
                ForceDeleteEntity(KartingVehicle)
                ActivityKarting = false
                ESX.ShowNotification('FlashSide ~w~~n~Vous avez quitté la zone du karting, Votre véhicule à été saisie')
            end
        end
		Wait(750)
	end
end)

function OpenMenuPlayerKarting()
    local menu = RageUI.CreateMenu("", "Activité Karting")

    RageUI.Visible(menu, not RageUI.Visible(menu))

    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()
        FreezeEntityPosition(PlayerPedId(), true)
        if not ActivityKarting then
            RageUI.Separator('FlashSide ~w~Activité - Karting')
            RageUI.Separator('Un kart vous sera fourni')
            RageUI.Button('Commencer l\'activité', nil, {RightLabel = '>'}, true, {
                onSelected = function()
                    ActivityKarting = true
                    ESX.Game.SpawnVehicle("luigiskart7", vector3(-153.08323669434,-2147.4096679688,16.705001831055), nil, function(vehicle)
                        TaskWarpPedIntoVehicle(GetPlayerPed(PlayerId()), vehicle, -1)
                        SetVehicleNumberPlateText(vehicle, 'KARTING')
                        KartingVehicle = vehicle
                    end)
                    RageUI.CloseAll()
                end
            })
        else
            RageUI.Separator('FlashSide Activité - Karting')
            RageUI.Separator('Arrêtez l\'activité supprimera le Kart.')
            RageUI.Button('Arrêtez l\'activité', nil, {}, true, {
                onSelected = function()
                    ActivityKarting = false
                    ForceDeleteEntity(KartingVehicle)
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

function ForceDeleteEntity(entity)
	if DoesEntityExist(entity) then
		NetworkRequestControlOfEntity(entity)
		local gameTime = GetGameTimer()

		while DoesEntityExist(entity) and (not NetworkHasControlOfEntity(entity) or ((GetGameTimer() - gameTime) < 1000)) do
			Citizen.Wait(10)
		end

		if DoesEntityExist(entity) then
			DetachEntity(entity, false, false)
			SetEntityAsMissionEntity(entity, false, false)
			SetEntityCollision(entity, false, false)
			SetEntityAlpha(entity, 0, true)
			SetEntityAsNoLongerNeeded(entity)

			if IsAnEntity(entity) then
				DeleteEntity(entity)
			elseif IsEntityAPed(entity) then
				DeletePed(entity)
			elseif IsEntityAVehicle(entity) then
				DeleteVehicle(entity)
			elseif IsEntityAnObject(entity) then
				DeleteObject(entity)
			end

			gameTime = GetGameTimer()

			while DoesEntityExist(entity) and ((GetGameTimer() - gameTime) < 2000) do
				Citizen.Wait(10)
			end

			if DoesEntityExist(entity) then
				SetEntityCoords(entity, vector3(10000.0, -1000.0, 10000.0), vector3(0.0, 0.0, 0.0), false)
			end
		end
	end
end