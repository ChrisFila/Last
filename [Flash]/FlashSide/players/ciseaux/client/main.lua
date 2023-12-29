RegisterNetEvent('altix:useciseaux', function()
    if not GetSafeZone() then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        local Ply = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
        local prop_name = "p_cs_scissors_s"

        if closestPlayer ~= -1 and closestDistance <= 3.0 then

            ExecuteCommand('me utilise des ciseaux')
            ciseau = CreateObject(GetHashKey("p_cs_scissors_s"), x, y, z,  true,  true, true)
            AttachEntityToEntity(ciseau, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 28422), -0.0, 0.03, 0.03, 0, -270.0, -20.0, true, true, false, true, 1, true)
            ESX.Streaming.RequestAnimDict('misshair_shop@barbers', function()
                TaskPlayAnim(Ply, 'misshair_shop@barbers', 'keeper_idle_b', 2.0, 2.0, 10000, 48, 0, false, false, false)
            end)
            Wait(10000)
            DeleteObject(ciseau)
            TriggerServerEvent('altix:haircut', GetPlayerServerId(closestPlayer))
        else
            ESX.ShowNotification('~r~Impossible~s~~n~personne a proximité de vous.')
        end
    else
        ESX.ShowNotification('FlashSide ~w~~n~Vous ne pouvez pas couper les cheveux de quelqu\'un en Zone Safe')
    end
end)

RegisterNetEvent('altix:haircut', function()
    TriggerEvent('skinchanger:change', 'hair_1', 0)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
end)
