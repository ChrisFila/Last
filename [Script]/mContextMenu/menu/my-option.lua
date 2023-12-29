function _My()
    Action_Config = {
        My = {
            {
                Type = "buttom",
                IsRestricted = false,
                Blocked = false,
                CloseOnClick = false,
                Label = ("Mon ID : %s"):format(GetPlayerServerId(PlayerId())),
                OnClick = function()
                end,
            },
            {
                Type = "buttom",
                IsRestricted = false,
                Blocked = false,
                CloseOnClick = false,
                Label = ("Mon nom : %s"):format(GetPlayerName(PlayerId())),
                OnClick = function()
                end,
            },
            {
                Type = "buttom",
                IsRestricted = false,
                Blocked = false,
                CloseOnClick = true,
                Label = "Me (...)",
                OnClick = function()
                    local imput = exports["cfx-target"]:ShowSync('Entrez un nom', false, 320., "small_text")
                    TriggerServerEvent("contextmenu:me", imput, PlayerPedId())
                end,
            }
        },
    }
end