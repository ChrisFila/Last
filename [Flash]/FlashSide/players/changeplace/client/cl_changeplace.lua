local buttonSeat = { [157] = -1, [158] = 0, [160] = 1, [164] = 2, [165] = 3, [159] = 4, [161] = 5, [162] = 6, [163] = 7 }
local blockShuffle = true

Citizen.CreateThread(function()

    while true do
        local attente = 1500

        local Player = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(Player, false)
        local speed = GetEntitySpeed(veh)*3.6
    
        if IsPedInAnyVehicle(Player, false) then
            attente = 1
            for key, seat in pairs(buttonSeat) do
                if IsDisabledControlJustPressed(1, key) and IsVehicleSeatFree(veh, seat) then
                    if speed > 15 then 
                        ESX.ShowNotification("FlashSide~s~~n~Vous ne pouvez pas changer de place, ralentissez !")
                    else
                        SetPedIntoVehicle(Player, veh, seat)
                        blockShuffle = seat == 0
                        Citizen.Wait(2000)
                    end
                end
            end
        end
        Wait(attente)
    end
end)