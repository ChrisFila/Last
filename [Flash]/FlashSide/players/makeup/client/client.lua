MakeUp = {
    Index = 1,
    IndexLipstick = 1,
    List = {},
    LisptickList = {},
    Pourcent = 0,
    PourcentLisptick = 0,

    Colormakeup = {
        primary = {1, 1},
        secondary = {1, 1},
    },

    Colorlipstick = {
        primary = {1, 1},
        secondary = {1, 1},
    }
}

CreateThread(function()
    for i=1, 71 do
        table.insert(MakeUp.List, i)
    end
    for i=1, 9 do
        table.insert(MakeUp.LisptickList, i)
    end
end)

openmakeup = function()
    local mainmakeup = RageUI.CreateMenu("", "Bienvenue")
    mainmakeup.EnableMouse = true
    mainmakeup.Closed = function()
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin) 
        end)
        SetPlayerControl(PlayerId(), true, 12)
    end

    RageUI.Visible(mainmakeup, not RageUI.Visible(mainmakeup))
    SetPlayerControl(PlayerId(), false, 12)

    while mainmakeup do 
        Wait(0)
        RageUI.IsVisible(mainmakeup, function()
        
            RageUI.List("Maquillage", MakeUp.List, MakeUp.Index, nil, {}, true,{
                
                onListChange = function(index)
                    MakeUp.Index = index 
                    TriggerEvent("skinchanger:change", "makeup_1", index)
                end
            })

            RageUI.List("Rouge à lèvre", MakeUp.LisptickList, MakeUp.IndexLipstick, nil, {}, true, {
                onListChange = function(index)
                    MakeUp.IndexLipstick = index 
                    TriggerEvent("skinchanger:change", "lipstick_1", MakeUp.IndexLipstick)
                end
            })

            RageUI.Button("Valider votre maquillage", nil, {RightLabel = "100$"}, true, {
                onSelected = function()
                    ESX.TriggerServerCallback("barber:getmoney", function(cb)
                        if cb == true then 
                            ESX.ShowAdvancedNotification("FlashSide Information", "Salon de Maquillage", "Vous avez payé votre maquillage avec succès !\nA bientôt", "CHAR_SEALIFE", 8)
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                TriggerServerEvent('esx_skin:save', skin)
                            end)
                            SetPlayerControl(PlayerId(), true, 12)
                            RageUI.CloseAll()
                        else
                            ESX.ShowAdvancedNotification("FlashSide Information", "Salon de Maquillage", "Vous ne disposez pas des fonds nécéssaires !", "CHAR_SEALIFE", 8)
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end) 
                            SetPlayerControl(PlayerId(), true, 12)
                            RageUI.CloseAll()
                        end
                    end)
                end
            })

            RageUI.PercentagePanel(MakeUp.Pourcent, "Oppacité", "0%", "100%", {
                onProgressChange = function(Percentage)
                    MakeUp.Pourcent = Percentage
                    TriggerEvent("skinchanger:change", "makeup_2", Percentage*100)
                end
            }, 1)

            RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, MakeUp.Colormakeup.primary[1], MakeUp.Colormakeup.primary[2], {
                onColorChange = function(MinimumIndex, CurrentIndex)
                    MakeUp.Colormakeup.primary[1] = MinimumIndex
                    MakeUp.Colormakeup.primary[2] = CurrentIndex
                    TriggerEvent("skinchanger:change", "makeup_3", MakeUp.Colormakeup.primary[2])
                end
            }, 1)

            RageUI.ColourPanel("Couleur Secondaire", RageUI.PanelColour.HairCut, MakeUp.Colormakeup.secondary[1], MakeUp.Colormakeup.secondary[2], {
                onColorChange = function(MinimumIndex, CurrentIndex)
                    MakeUp.Colormakeup.secondary[1] = MinimumIndex
                    MakeUp.Colormakeup.secondary[2] = CurrentIndex
                    TriggerEvent("skinchanger:change", "makeup_4", MakeUp.Colormakeup.secondary[2])
                end
            }, 1)

            RageUI.PercentagePanel(MakeUp.PourcentLisptick, "Oppacité", "0%", "100%", {
                onProgressChange = function(Percentage)
                    MakeUp.PourcentLisptick = Percentage
                    TriggerEvent("skinchanger:change", "lipstick_2", Percentage*100)

                end
            }, 2)

            RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, MakeUp.Colorlipstick.primary[1], MakeUp.Colorlipstick.primary[2], {
                onColorChange = function(MinimumIndex, CurrentIndex)
                    MakeUp.Colorlipstick.primary[1] = MinimumIndex
                    MakeUp.Colorlipstick.primary[2] = CurrentIndex
                    TriggerEvent("skinchanger:change", "lipstick_3", MakeUp.Colorlipstick.primary[2])
                end
            }, 2)

            RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, MakeUp.Colorlipstick.secondary[1], MakeUp.Colorlipstick.secondary[2], {
                onColorChange = function(MinimumIndex, CurrentIndex)
                    MakeUp.Colorlipstick.secondary[1] = MinimumIndex
                    MakeUp.Colorlipstick.secondary[2] = CurrentIndex
                    TriggerEvent("skinchanger:change", "lipstick_4", MakeUp.Colorlipstick.secondary[2])
                end
            }, 2)
        end, function()
        end)
        if not RageUI.Visible(mainmakeup) then
            mainmakeup = RMenu:DeleteType('mainmakeup', true)
        end
    end
end