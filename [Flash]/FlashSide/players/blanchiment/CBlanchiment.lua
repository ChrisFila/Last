ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

RMenu.Add('razzblanchi', 'menublanchi', FlashSideUI.CreateMenu("", "~r~Blanchiment"))

CreateThread(function()
    while true do
        Wait(1)
        local playerPed = GetPlayerPed(-1)
        local Distance = Vdist2(GetEntityCoords(GetPlayerPed(-1)), 1393.2, 1159.65, 114.33)
        if Distance < 500.0 then
            if Distance < 5 then
                AddTextEntry("BLANCHI", "Appuyer sur ~INPUT_PICKUP~ pour parler avec le blanchisseur.")
                DrawMarker(22, 1393.2, 1159.65, 114.33,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 69, 112, 246, 180, true, true, p19, true)
                DisplayHelpTextThisFrame("BLANCHI", false)
                if IsControlJustPressed(1, 38) then
                    FlashSideUI.Visible(RMenu:Get('razzblanchi', 'menublanchi'), true)
                    local IsBlanchiMenuOpen = true
                    while IsBlanchiMenuOpen do
                        Wait(1)
                        if not FlashSideUI.Visible(RMenu:Get('razzblanchi', 'menublanchi')) then
                            IsBlanchiMenuOpen = false
                        end
                        FreezeEntityPosition(playerPed, true)
                        FlashSideUI.IsVisible(RMenu:Get('razzblanchi', 'menublanchi'), true, true, true, function()

                            FlashSideUI.ButtonWithStyle("Blanchir de l'argent", nil, { RightLabel = "~r~→" }, true, function(h, a, s)
                                if s then
                                    local argent = KeyboardInput("Combien d'agent as-tu ?", '' , '', 8)
                                    TriggerServerEvent('rz-core:blanchiement', argent)
                                end
                            end)

                        end, function()end, 1)
                        FreezeEntityPosition(playerPed, false)
                    end
                end
            end
        else
            Wait(5000)
        end
    end
end)