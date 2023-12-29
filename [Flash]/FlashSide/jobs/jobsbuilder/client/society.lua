Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(5000)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)


local List = {
    Actions = {
        "Déposer",
        "Prendre"
    },
    ActionIndex = 1,
    ActionButton = 1
}

--[[local List2 = {
    Actions = {
        "Déposer",
        "Prendre"
    },
    ActionIndex = 1,
    ActionButton = 1
}]]

FlashSide.Job ={
    OpenSocietyMenu = function(society, position)
        local menu = RageUI.CreateMenu("", "Actions disponibles :")
        local data 
        local money
        local moneysale
        local load = false
    
        ESX.TriggerServerCallback("Core:GetSocietyInfo", function(result) 
            data = result.data
            money = result.money
            moneysale = result.moneysale
            load = true
        end, society.name)
    
        while not load do 
            Wait(1)
        end
    
        RageUI.Visible(menu, not RageUI.Visible(menu))
    
        while menu do
            Wait(0)
            RageUI.IsVisible(menu, function()
    
                RageUI.Separator("~r~Société : ~s~"..society.label)
                if FlashSide.jobgrade == 'boss' then
                    RageUI.Separator("~r~Argent Liquide : ~s~"..money.."$")
                    --RageUI.Separator("~r~Argent Sale : ~s~"..moneysale.."$")
                    RageUI.Separator("")
                    RageUI.List("Actions sur l'argent ", List.Actions, List.ActionIndex, nil, {}, true, {
                        onListChange = function(Index, Item)
                            List.ActionIndex = Index;
                            List.ActionButton = Index;
                        end,
                        onSelected = function()
                            if List.ActionButton == 1 then 
                                if UpdateOnscreenKeyboard() == 0 then return end
                                local string = KeyboardInput('Combien voulez vous déposer ?', '', '', 100)
                                if string ~= "" then
                                    deposit = tonumber(string) 
                                    TriggerServerEvent("Core:ActionMoneyToSocietyCache", society.name, "deposit", deposit)
                                    FlashSide.Job.OpenSocietyMenu({label = FlashSide.joblabel, name = FlashSide.job }, ActionPatron)
                                end
                            elseif List.ActionButton == 2 then
                                if UpdateOnscreenKeyboard() == 0 then return end
                                local string = KeyboardInput('Combien voulez vous prendre ?', '', '', 100)
                                if string ~= "" then
                                    deposit = tonumber(string) 
                                    TriggerServerEvent("Core:ActionMoneyToSocietyCache", society.name, "take", deposit)
                                    FlashSide.Job.OpenSocietyMenu({label = FlashSide.joblabel, name = FlashSide.job }, ActionPatron)
                                end
                            end
                        end
                    })
                    --[[RageUI.List("Actions sur l'argent Sale ", List2.Actions, List2.ActionIndex, nil, {}, true, {
                        onListChange = function(Index, Item)
                            List2.ActionIndex = Index;
                            List2.ActionButton = Index;
                        end,
                        onSelected = function()    
                            if List2.ActionButton == 1 then 
                                if UpdateOnscreenKeyboard() == 0 then return end
                                local string = KeyboardInput('Combien voulez vous déposer ?', '', '', 100)
                                if string ~= "" then
                                    deposit = tonumber(string) 
                                    TriggerServerEvent("Core:ActionMoneysaleToSocietyCache", society.name, "deposit", deposit)
                                    FlashSide.Job.OpenSocietyMenu({label = FlashSide.joblabel, name = FlashSide.job }, ActionPatron)
                                end
                            elseif List2.ActionButton == 2 then
                                if UpdateOnscreenKeyboard() == 0 then return end
                                local string = KeyboardInput('Combien voulez vous prendre ?', '', '', 100)
                                if string ~= "" then
                                    deposit = tonumber(string) 
                                    TriggerServerEvent("Core:ActionMoneysaleToSocietyCache", society.name, "take", deposit)
                                    FlashSide.Job.OpenSocietyMenu({label = FlashSide.joblabel, name = FlashSide.job }, ActionPatron)
                                end
                            end
                        end
                    })]]
                end
                RageUI.Button("Désposer dans le coffre", nil, {}, true, {
                    onSelected = function()
                        Wait(150)
                        OpenSocietyPlayerInventoryMenu(society, position)
                    end
                })
                RageUI.Button("Prendre dans le coffre", nil, {}, true, {
                    onSelected = function()
                        Wait(150)
                        OpenSocietyInventoryMenu(society, position, data)
                    end
                })
    
            end, function()
            end)
    
            if not RageUI.Visible(menu) then
                menu = RMenu:DeleteType('menu', true)
            end
        end
    end,
    BossMenu = function(entreprise)
        local main = RageUI.CreateMenu("", "~r~Gestion "..FlashSide.joblabel)
    
        RageUI.Visible(main, not RageUI.Visible(main))
    
        while main do 
            Citizen.Wait(0)
            RageUI.IsVisible(main, function()
                RageUI.Separator('Argent de la société : ~r~'.. FlashSide.societymoney)
                RageUI.Separator('')
                RageUI.Button('Retirer de l\'argent', nil, {}, true, {
                    onSelected = function() 
                        local string = KeyboardInput('Combien ?', ('Combien ?'), '', 999)
                        if string ~= "" then
                            Montant = tonumber(string)
                        end
                        TriggerServerEvent('ewensociety:withdrawMoney', FlashSide.job, tonumber(Montant))
                    end
                });
                RageUI.Button('Deposer de l\'argent', nil, {}, true, {
                    onSelected = function() 
                        local string = KeyboardInput('Combien ?', ('Combien ?'), '', 999)
                        if string ~= "" then
                            Montant = tonumber(string)
                        end
                        TriggerServerEvent('ewensociety:depositMoney', FlashSide.job, tonumber(Montant))
                    end
                });
            end)
            if not RageUI.Visible(main) then
                main = RMenu:DeleteType('main', true)
            end
        end
    end
}

-- SOCIETYMENU

function OpenSocietyPlayerInventoryMenu(society, position)
    local menu = RageUI.CreateMenu("", "Contenu de vos poches :")

    RageUI.Visible(menu, not RageUI.Visible(menu))

    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()

            RageUI.Separator("~r~Que voulez-vous déposer ?")
            ESX.PlayerData = ESX.GetPlayerData()
            for i = 1, #ESX.PlayerData.inventory do
                if ESX.PlayerData.inventory[i].count > 0 then
                    RageUI.Button("• "..ESX.PlayerData.inventory[i].label, nil, { RightLabel = "Quantité(s) : ~r~x"..ESX.PlayerData.inventory[i].count }, true, {
                        onSelected = function()
                            if UpdateOnscreenKeyboard() == 0 then return end
                            local string = KeyboardInput('Combien voulez vous déposer ?', '', '', 100)
                            if string ~= "" then
                                deposit = tonumber(string)
                                if ESX.PlayerData.inventory[i].count >= deposit then
                                    TriggerServerEvent("Core:AddInventoryToSocietyCache", position, society.name, ESX.PlayerData.inventory[i].name, ESX.PlayerData.inventory[i].label, deposit)
                                else
                                    print('t')
                                    ESX.ShowNotification('~r~Erreur ~w~~n~Tu n\'as pas assez d\'objets sur toi')
                                end
                            end
                        end
                    })
                end
            end

        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
            FlashSide.Job.OpenSocietyMenu({label = FlashSide.joblabel, name = FlashSide.job }, position)
        end
    end
end

function OpenSocietyInventoryMenu(society, position, data)
    local menu = RageUI.CreateMenu("", "Contenu du coffre :")

    RageUI.Visible(menu, not RageUI.Visible(menu))

    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()
            RageUI.Separator("~r~Que voulez-vous prendre ?")
            for k,v in pairs(data) do
                RageUI.Button(v.label, nil, {RightLabel = "Quantité(s) : ~r~x"..v.count}, true, {
                    onSelected = function()
                        if UpdateOnscreenKeyboard() == 0 then return end
                        local string = KeyboardInput('Combien voulez vous prendre ?', '', '', 100)
                        if string ~= "" then
                            deposit = tonumber(string) 
                            if v.count >= deposit then
                                TriggerServerEvent("Core:RemoveInventoryToSocietyCache", position, society.name, v.item, v.label, deposit)
                                FlashSide.Job.OpenSocietyMenu({label = FlashSide.joblabel, name = FlashSide.job }, position)
                            else
                                ESX.ShowNotification('~r~Erreur ~w~~n~Il n\'y a pas assez d\'objets dans le coffre')
                            end
                        end
                    end
                })
            end

        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
            FlashSide.Job.OpenSocietyMenu({label = FlashSide.joblabel, name = FlashSide.job }, position)
        end
    end
end