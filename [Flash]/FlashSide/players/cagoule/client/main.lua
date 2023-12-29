local needDisplayBag = false

RegisterNetEvent('FlashSide:cagoule')
AddEventHandler('FlashSide:cagoule', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer == -1 or closestDistance > 3.0 then
        ESX.ShowNotification('~r~Erreur ~w~~n~Aucun joueurs au alentours')
    else
        if IsPedInAnyVehicle(GetPlayerPed(closestPlayer), false) then
            ESX.ShowNotification('Vous ne pouvez pas mettre de cagoule en étant dans un véhicule')
        else
            TriggerServerEvent('FlashSide:CagouletSet', GetPlayerServerId(closestPlayer))
        end
    end
end)

RegisterNetEvent('FlashSide:CagouleSet')
AddEventHandler('FlashSide:CagouleSet', function()
    needDisplayBag = not needDisplayBag
    if needDisplayBag then 
        TriggerEvent('skinchanger:change', 'mask_1', 244)
        TriggerEvent('skinchanger:change', 'mask_2', 0)
    end
    while needDisplayBag do
        if not HasStreamedTextureDictLoaded('revolutionbag') then
            RequestStreamedTextureDict('revolutionbag')
            while not HasStreamedTextureDictLoaded('revolutionbag') do
                Citizen.Wait(50)
            end
        end

        DrawSprite('revolutionbag', 'headbag', 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
        Citizen.Wait(0)
    end
    SetStreamedTextureDictAsNoLongerNeeded('revolutionbag')
    TriggerEvent('skinchanger:change', 'mask_1', 0)
    TriggerEvent('skinchanger:change', 'mask_2', 0)
end)