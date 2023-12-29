function _Object()
    Action_Config = {
        Object = {
            {
                Type = "buttom",
                IsRestricted = true,
                Blocked = false,
                CloseOnClick = true,
                Label = ("Utilisé"),
                OnClick = function()
                    UseContextmenu(GetEntityModel(LastEntityHit))
                end,
            },
           ---{
           ---    Type = "buttom",
           ---    IsRestricted = true,
           ---    Blocked = IsHackableAtm(GetEntityModel(LastEntityHit)),
           ---    CloseOnClick = true,
           ---    Label = ("Hack"),
           ---    OnClick = function()
           ---        ExecuteCommand("hack")
           ---    end,
           ---},
            {
                Type = "buttom",
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                Label = ("ID de l'objet : %s"):format(LastEntityHit),
                OnClick = function()

                end,
            },
            {
                Type = "buttom",
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                Label = ("Model de l'objet : %s"):format(GetEntityModel(LastEntityHit)),
                OnClick = function()
                    SendNUIMessage({type = "copy", text = GetEntityModel(LastEntityHit)})
                end,
            },
            {
                Type = "buttom",
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                Label = ("Owner de l'objet : %s"):format(NetworkGetEntityOwner(LastEntityHit)),
                OnClick = function()
                end,
            },

            {
                Type = "buttom",
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                Label = ("Position : %s"):format(GetEntityCoords(LastEntityHit)),
                OnClick = function()
                end,
            },
            {
                Type = "buttom",
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                Label = ("Rotation : %s"):format(GetEntityRotation(LastEntityHit)),
                OnClick = function()
                end,
            },
            {
                Type = "buttom",
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                Label = ("Type : %s"):format(GetEntityType(LastEntityHit)),
                OnClick = function()
                end,
            },
            {
                Type = "buttom",
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                OnClick = function()
                    Target:MouveEntity(LastEntityHit)
                end,
                Label = "Déplacé l'objet",
            },
            {
                Type = "buttom",
                Label = "Dupliqué",
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                OnClick = function()
                    local new = Target:DuplicateEntity(LastEntityHit)
                    Target:MouveEntity(new)
                end,
            },
            {
                Type = "buttom",
                Label = "Suprimé",
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                OnClick = function()
                    SetEntityAsMissionEntity(LastEntityHit, false, false)
                    DeleteObject(LastEntityHit)
                end,
            },
        },
    }
end
