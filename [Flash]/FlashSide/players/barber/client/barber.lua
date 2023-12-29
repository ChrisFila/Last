local buy = false
function OpenMenuBarberShop(caca)
    local menu = RageUI.CreateMenu("", "Changez votre coupe de cheveux")
    menu.EnableMouse = true 
    RageUI.Visible(menu, not RageUI.Visible(menu))
    SetPlayerControl(PlayerId(), false, 12)
	while menu do
		Citizen.Wait(0)
		RageUI.IsVisible(menu, function()
            RageUI.List("Cheveux", Creator.Hairlist, Creator.Hairindex, nil, {}, true, {
                onListChange = function(index)
                    Creator.Hairindex = index
                    TriggerEvent("skinchanger:change", "hair_1", index)
                end
            })

            RageUI.List("Barbe", Creator.BeardList, Creator.Beardindex, nil, {}, true, {
                onListChange = function(index)
                    Creator.Beardindex = index 
                    TriggerEvent("skinchanger:change", "beard_1", Creator.Beardindex)
                end
            })

            RageUI.List("Sourcil", Creator.EyebowList, Creator.Indexeyebow, nil, {}, true, {
                onListChange = function (index)
                    Creator.Indexeyebow = index 
                    TriggerEvent("skinchanger:change", "eyebrows_1", Creator.Indexeyebow)
                end
            })

            RageUI.Button("Payer la coupe", nil, {RightLabel = "~r~100 $"}, true, {
                onSelected = function()
                    ESX.TriggerServerCallback("barber:getmoney", function(cb)
                        if cb == true then
                            buy = true
                            ESX.ShowAdvancedNotification("FlashSide Information", "Barber Shop", "Vous avez payé votre coupe avec succès !\nA bientôt", "CHAR_SEALIFE", 8)
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                TriggerServerEvent('esx_skin:save', skin)
                            end)
                            SetPlayerControl(PlayerId(), true, 12)
                            RageUI.CloseAll()
                        else
                            ESX.ShowAdvancedNotification("FlashSide Information", "Barber Shop", "Vous ne disposez pas des fonds nécéssaires !", "CHAR_SEALIFE", 8)
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end) 
                            SetPlayerControl(PlayerId(), true, 12)
                            RageUI.CloseAll()
                        end
                    end)
                end
            })

        end, function()
            RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, Creator.ColorHair.primary[1], Creator.ColorHair.primary[2], {
                onColorChange = function(MinimumIndex, CurrentIndex)
                    Creator.ColorHair.primary[1] = MinimumIndex
                    Creator.ColorHair.primary[2] = CurrentIndex
                    TriggerEvent("skinchanger:change", "hair_color_1" ,Creator.ColorHair.primary[2])
                end
            }, 1)

            RageUI.ColourPanel("Couleur secondaire", RageUI.PanelColour.HairCut, Creator.ColorHair.secondary[1], Creator.ColorHair.secondary[2], {
                onColorChange = function(MinimumIndex, CurrentIndex)
                    Creator.ColorHair.secondary[1] = MinimumIndex
                    Creator.ColorHair.secondary[2] = CurrentIndex
                    TriggerEvent("skinchanger:change", "hair_color_2", Creator.ColorHair.secondary[2])
                end
            }, 1)


            RageUI.PercentagePanel(Creator.OpaPercent, 'Opacité', '0%', '100%', {
                onProgressChange = function(Percentage)
                    Creator.OpaPercent = Percentage
                    TriggerEvent('skinchanger:change', 'beard_2', Percentage*10)
                end
            }, 2) 

            RageUI.ColourPanel("Couleur de la barbe", RageUI.PanelColour.HairCut, Creator.ColorBeard.secondary[1], Creator.ColorBeard.secondary[2], {
                onColorChange = function(MinimumIndex, CurrentIndex)
                    Creator.ColorBeard.secondary[1] = MinimumIndex
                    Creator.ColorBeard.secondary[2] = CurrentIndex
                    TriggerEvent("skinchanger:change", "beard_3", Creator.ColorBeard.secondary[2])
                end
            }, 2)

            RageUI.PercentagePanel(Creator.OpePercentEyebow, 'Opacité', '0%', '100%', {
                onProgressChange = function(Percentage)
                    Creator.OpePercentEyebow = Percentage
                    TriggerEvent('skinchanger:change', 'eyebrows_2', Percentage*10)
                end
            }, 3) 

            RageUI.ColourPanel("Couleur des sourcils", RageUI.PanelColour.HairCut, Creator.ColorEyebow.secondary[1], Creator.ColorEyebow.secondary[2], {
                onColorChange = function(MinimumIndex, CurrentIndex)
                    Creator.ColorEyebow.secondary[1] = MinimumIndex
                    Creator.ColorEyebow.secondary[2] = CurrentIndex
                    TriggerEvent("skinchanger:change", "eyebrows_3", Creator.ColorEyebow.secondary[2])
                end
            }, 3)
        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
            if not buy then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin) 
                end)
            else
                buy = false
            end
            SetPlayerControl(PlayerId(), true, 12)
        end
    end
end