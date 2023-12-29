ESX = nil

TriggerEvent("esx:getSharedObject", function(obj)
	ESX = obj
end)

local Type = {
    { Name = "Voiture", Value = "car"},
    { Name = "Avion", Value = "aircraft" },
    { Name = "Bateau", Value = "boat" }
}

RegisterCommand("garage:addvehicle", function(source, args, rawCommand)
    if ESX.GetPlayerData()["group"] == "_dev" then
        PatronMenu()
    else
        ESX.ShowNotification("Vous n'avez pas les permissions nécessaire a l'ouverture de ce menu !")
    end
end)

function defineorNot(str) 
    if str == nil then
        return "Non Défini"
    else
        return "Défini"
    end
end

function PatronMenu()
    local patronicMenu = RageUI.CreateMenu("", "DE VEHICULES SUR JOUEURS")
    patronicMenu.TitleFont = 2;
    local put = false
    local put2 = false
    local put3 = false
    local string1 = nil
    local string2 = nil
    local select_type = "car";
    local INDEXFDP = 1;

    RageUI.Visible(patronicMenu, not RageUI.Visible(patronicMenu))
    
    while patronicMenu do
        Citizen.Wait(0)
        RageUI.IsVisible(patronicMenu, function()
            RageUI.Button("Joueur seléctionné", "Votre réponse doit être un ~HUD_COLOUR_NET_PLAYER22~ID", { RightLabel = defineorNot(string1) }, put, {
                onSelected = function()
                    string1 = KeyboardInput('Réponse', ('Réponse (ex: 1, 2)'), '', 999)
                    put = false
                    --print(string1)
                end
            })
            RageUI.Button("~r~Redéfinir", nil, {}, true, {
                onSelected = function()
                    put = true
                end
            })
            RageUI.Button("Voiture seléctionné", "Votre réponse doit être un ~HUD_COLOUR_NET_PLAYER22~Model de voiture telle que rmodrs6, adder", { RightLabel = defineorNot(string2) }, put2, {
                onSelected = function()
                    string2 = KeyboardInput('Réponse', ('Réponse (ex: rmodrs6, adder)'), '', 999)
                    if string2 ~= nil then
                        put2 = false
                    else
                        ESX.ShowHelpNotification("Votre réponse est ~r~incorrect")
                    end
                end
            })
            RageUI.Button("~r~Redéfinir", nil, {}, true, {
                onSelected = function()
                    put2 = true
                end
            })
            RageUI.Button("Plaque", nil, { RightLabel = defineorNot(string3) }, put3, {
                onSelected = function()
                    string3 = KeyboardInput('Réponse', ('Réponse (ex: XXXXXXX)'), '', 999)
                    if string3 ~= nil then
                        put3 = false
                    else
                        ESX.ShowHelpNotification("Votre réponse est ~r~incorrect")
                    end
                end
            })
            RageUI.Button("~r~Redéfinir", nil, {}, true, {
                onSelected = function()
                    put3 = true
                end
            })
            if not put and not put2 and not put3 then
                RageUI.List("Type de véhicule", Type, INDEXFDP, nil, {}, true, {
                    onListChange = function(Index, Item)
                        INDEXFDP = Index;
                        if Item.Value == "car" then
                            select_type = "car"
                            ESX.ShowNotification("Voiture ~r~seléctionné !")
                        elseif Item.Value == "aircraft" then
                            select_type = "aircraft"
                            ESX.ShowNotification("Avion ~r~seléctionné !")
                        elseif Item.Value == "boat" then
                            select_type = "boat"
                            ESX.ShowNotification("Bateau ~r~seléctionné !")
                        end
                    end,
                    onSelected = function()

                    end
                })
            end
            if not put and not put2 and not put3 and select_type then
                RageUI.Button("~r~Confirmer", nil, {}, true, {
                    onSelected = function()
                        put = true
                        put2 = true
                        put3 = true
                        TriggerServerEvent("Kayce:AddVehToClient", string1, string2, string3, select_type)
                        RageUI.CloseAll()
                        string1 = nil
                        string2 = nil
                        string3 = nil
                    end
                })
            end
        end)
        if not RageUI.Visible(patronicMenu) then
            patronicMenu = RMenu:DeleteType('patronicMenu', true)
        end
    end
end