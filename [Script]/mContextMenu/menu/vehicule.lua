function _Vehicule()
    Action_Config = {
        Vehicule = {
            {
                Type = "buttom",
                Label = ("Nom du véhicule : %s"):format(GetDisplayNameFromVehicleModel(GetEntityModel(LastEntityHit))),
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                OnClick = function() 
                end,
            },
            {
                Type = "buttom",
                Label = ("ID du véhicule : %s"):format(LastEntityHit),
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                OnClick = function() 
                end,
            },
            {
                Type = "buttom",
                Label = ("Plaque du véhicule : %s"):format(GetVehicleNumberPlateText(LastEntityHit)),
                IsRestricted = false,
                CloseOnClick = true,
                Blocked = false,
                OnClick = function() 
                end,
            },
            {
                Type = "buttom-submenu",
                Label = "Porte",
                IsRestricted = false,
                CloseOnClick = false,
                Blocked = false,
                Action = {
                    {
                        'Avant Gauche',
                        function()
                            dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(LastEntityHit))
                            if dist < 3 then
                                if GetVehicleDoorAngleRatio(LastEntityHit, 0) == 0 then
                                    SetVehicleDoorOpen(LastEntityHit, 0, false, false)
                                else
                                    SetVehicleDoorShut(LastEntityHit, 0, false)
                                end
                            end
                        end
                    },
                    {
                        'Avant Droite',
                        function()
                            dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(LastEntityHit))
                            if dist < 3 then
                                if GetVehicleDoorAngleRatio(LastEntityHit, 1) == 0 then
                                    SetVehicleDoorOpen(LastEntityHit, 1, false, false)
                                else
                                    SetVehicleDoorShut(LastEntityHit, 1, false)
                                end
                            end
                        end
                    },
                    {
                        'Arrière Gauche',
                        function()
                            dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(LastEntityHit))
                            if dist < 3 then
                                if GetVehicleDoorAngleRatio(LastEntityHit, 2) == 0 then
                                    SetVehicleDoorOpen(LastEntityHit, 2, false, false)
                                else
                                    SetVehicleDoorShut(LastEntityHit, 2, false)
                                end
                            end
                        end
                    },
                    {
                        'Arrière Droite',
                        function()
                            dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(LastEntityHit))
                            if dist < 3 then
                                if GetVehicleDoorAngleRatio(LastEntityHit, 3) == 0 then
                                    SetVehicleDoorOpen(LastEntityHit, 3, false, false)
                                else
                                    SetVehicleDoorShut(LastEntityHit, 3, false)
                                end
                            end
                        end
                    },
                    {
                        'Capot',
                        function()
                            dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(LastEntityHit))
                            if dist < 3 then
                                if GetVehicleDoorAngleRatio(LastEntityHit, 4) == 0 then
                                    SetVehicleDoorOpen(LastEntityHit, 4, false, false)
                                else
                                    SetVehicleDoorShut(LastEntityHit, 4, false)
                                end
                            end
                        end
                    },
                    {
                        'Coffre',
                        function()
                            dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(LastEntityHit))
                            if dist < 3 then
                                if GetVehicleDoorAngleRatio(LastEntityHit, 5) == 0 then
                                    SetVehicleDoorOpen(LastEntityHit, 5, false, false)
                                else
                                    SetVehicleDoorShut(LastEntityHit, 5, false)
                                end
                            end
                        end
                    },
                },
            },             
            {
                Type = "buttom",
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                OnClick = function()
                    Target:MouveEntity(LastEntityHit)
                end,
                Label = "Déplacé",
            },
            {
                Type = "buttom",
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                OnClick = function()
                    DeleteEntity(LastEntityHit)
                end,
                Label = "Supprimé",
            },
            {
                Type = "buttom",
                IsRestricted = true,
                CloseOnClick = false,
                Blocked = false,
                Label = "Réparer",
                OnClick = function()
                    SetVehicleFixed(LastEntityHit)
                end,   
            },
            {
                Type = "buttom",
                IsRestricted = true,
                CloseOnClick = false,
                Blocked = false,
                Label = "Nettoyer",
                OnClick = function()
                    SetVehicleDirtLevel(LastEntityHit, 0.0)
                end,   
            },
            {
                Type = "buttom",
                IsRestricted = true,
                CloseOnClick = false,
                Blocked = false,
                Label = "Custom",
                OnClick = function()
                    OnCustom(LastEntityHit)
                end,
            },
            {
                Type = "buttom",
                IsRestricted = true,
                CloseOnClick = false,
                Blocked = false,
                Label = "Rendre immobile",
                OnClick = function()
                    FreezeEntityPosition(LastEntityHit, true)
                end,
            },
            {
                Type = "buttom",
                IsRestricted = true,
                Blocked = false,
                CloseOnClick = false,
                Label = "Rendre mobile",
                OnClick = function()
                    FreezeEntityPosition(LastEntityHit, false)
                end,
            },
            {
                Type = "buttom",
                IsRestricted = true,
                Blocked = false,
                CloseOnClick = false,
                Label = "Retourner le véhicule 180°",
                OnClick = function()
                    SetEntityHeading(LastEntityHit, GetEntityHeading(LastEntityHit) + 180)
                end,
            },

        }, 
    }
end


