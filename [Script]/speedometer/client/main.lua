



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local Ped = PlayerPedId()
        local ui = IsPedInAnyVehicle(Ped, false)
        local sleep = true
        

        if ui then
            Citizen.Wait(30)
            local vehicle = GetVehiclePedIsIn(Ped, false)
            local fuel = GetVehicleFuelLevel(vehicle)
            local carspeed = GetEntitySpeed(vehicle) * 3.6
            --local carspeed = GetEntitySpeed(vehicle)*2.236936
            SendNUIMessage({
                ui = ui;
                speed = carspeed;
                fuel = fuel;
            });
            Citizen.Wait(0)
            sleep = false
        else
            SendNUIMessage({
                ui = false;
            });
            if sleep then Citizen.Wait(2200) end
        end
    end
end)