local PointNord = nil
local PointSud = nil
InitIllegalShop = false
Citizen.CreateThread(function()
    while not ESXLoaded do Wait(1) end 
    TriggerServerEvent('illegalshop:GetPoints')
    while not InitIllegalShop do 
        Wait(10)
    end
    while true do
        local isProche = false
        local dist = Vdist2(GetEntityCoords(PlayerPedId(), false), PointNord)
        if dist < 250 then
            isProche = true
            DrawMarker(25, PointNord.x, PointNord.y, PointNord.z-0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.55, 0.55, 0.55, 248,165,10, 255, false, false, 2, false, false, false, false)
        end
        if dist < 10 then
            ESX.ShowHelpNotification("~w~Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
            if IsControlJustPressed(1,51) then
                OpenIllegalShop()
            end
        end
        
		if isProche then
			Wait(0)
		else
			Wait(750)
		end
    end
end)

Citizen.CreateThread(function()
    while not ESXLoaded do Wait(1) end 
    while not InitIllegalShop do 
        Wait(10)
    end
    while true do
        local isProche = false
        local dist = Vdist2(GetEntityCoords(PlayerPedId(), false), PointSud)

        if dist < 250 then
            isProche = true
            DrawMarker(25, PointSud.x, PointSud.y, PointSud.z-0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.55, 0.55, 0.55, 248,165,10, 255, false, false, 2, false, false, false, false)
        end
        if dist < 10 then
            ESX.ShowHelpNotification("~w~Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
            if IsControlJustPressed(1,51) then
                OpenIllegalShop()
            end
        end
        
		if isProche then
			Wait(0)
		else
			Wait(750)
		end
    end
end)

RegisterNetEvent('illegalshop:ReceivePoints')
AddEventHandler('illegalshop:ReceivePoints', function(nord,sud)
    InitIllegalShop = true
    PointNord = nord
    PointSud = sud
end)

function OpenIllegalShop()
    local menu = RageUI.CreateMenu('', "Voici nos articles disponibles")
    RageUI.Visible(menu, not RageUI.Visible(menu))
    while menu do
        Citizen.Wait(0)
        RageUI.IsVisible(menu, function()
            for k,v in pairs(BlackMarket.ListObjetsMenu) do
                RageUI.Button(v.label, 'Nom de l\'article : '..v.label..'\nPrix de l\'article : '..v.price..' $\nDescription : '..v.description, {RightLabel = v.price..' $'}, true, {
                    onSelected = function() 
                        TriggerServerEvent('IllegalShop:buyItem', v.name, v.type)
                    end
                })
            end
        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end