function _Player()
    Action_Config = {
        Player = {
            {
                Type = "buttom",
                IsRestricted = false,
                Blocked = false,
                CloseOnClick = false,
                Label = "ID : "..GetPlayerIdFromPed(LastEntityHit) or "Inconnu",
                OnClick = function()
                end,
            },
            {
                Type = "buttom",
                IsRestricted = false,
                Blocked = false,
                CloseOnClick = false,
                Label = "Nom : "..GetPlayerName(GetPlayerIdFromPed(LastEntityHit)) or "Inconnu",
                OnClick = function()
                end,
            },
            
        }
    }
end