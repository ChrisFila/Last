function _Ground()
    Action_Config = {
        Ground = {
            {
                Type = "buttom",
                IsRestricted = true,
                Blocked = false,
                CloseOnClick = false,
                Label = "Vous téléporter ici",
                OnClick = function()
                    SetEntityCoords(PlayerPedId(), LastCoordsHit)
                end,
            },
            {
                Type = "buttom",
                IsRestricted = true,
                Blocked = false,
                CloseOnClick = false,
                Label = "Déposer un objet",
                OnClick = function()
                    obj_model = exports["cfx-target"]:ShowSync('model', false, 320, "small_text")
                    if IsModelValid(obj_model) then
                        RequestModel(obj_model)
                        while not HasModelLoaded(obj_model) do
                            Wait(0)
                        end
                        obj = CreateObject(obj_model, LastCoordsHit, true, true, true)
                        SetEntityAsMissionEntity(obj, true, true)
                        SetModelAsNoLongerNeeded(obj_model)
                    end
                end,
            },
            {
                Type = "buttom",
                IsRestricted = true,
                Blocked = false,
                CloseOnClick = false,
                Label = "Posé un véhicule",
                OnClick = function()
                    veh_model = exports["cfx-target"]:ShowSync('model', false, 320, "small_text")
                    if IsModelValid(veh_model) then
                        RequestModel(veh_model)
                        while not HasModelLoaded(veh_model) do
                            Wait(0)
                        end
                        veh = CreateVehicle(veh_model, LastCoordsHit, GetEntityHeading(PlayerPedId()), true, true)
                        SetEntityAsMissionEntity(veh, true, true)
                        SetVehicleOnGroundProperly(veh)
                        SetModelAsNoLongerNeeded(veh_model)
                    end
                end,
            },
            {
                Type = "buttom",
                IsRestricted = true,
                Blocked = true,
                CloseOnClick = false,
                Label = "Posé un peds",
                OnClick = function()
                    ped_model = ShowSync('Peds', false, 320., "small_text")
                    if IsModelValid(ped_model) then
                        RequestModel(ped_model)
                        while not HasModelLoaded(ped_model) do
                            Wait(0)
                        end
                        ped = CreatePed(4, ped_model, LastCoordsHit, GetEntityHeading(PlayerPedId()), true, true)
                        SetEntityAsMissionEntity(ped, true, true)
                        SetModelAsNoLongerNeeded(ped_model)
                    end
                end,
            },
        },
    }
end