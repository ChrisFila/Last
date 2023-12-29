CreateThread(function()
    while true do
    local pCoords = GetEntityCoords(PlayerPedId())
    local spam = false
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'gouvernement' then  
    for _,v in pairs(cfg_gouv.Coffre) do
        if servicegouv then
        if #(pCoords - v.pos) < cfg_gouv.MarkerDistance then
            spam = true
            Visual.Subtitle("Appuyer sur [~r~E~s~] pour accéder au ~r~Menu Coffre")
            DrawMarker(cfg_gouv.MarkerType, v.pos,  0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_gouv.MarkerSizeLargeur, cfg_gouv.MarkerSizeEpaisseur, cfg_gouv.MarkerSizeHauteur, cfg_gouv.MarkerColorR, cfg_gouv.MarkerColorG, cfg_gouv.MarkerColorB, cfg_gouv.MarkerOpacite, cfg_gouv.MarkerSaute, true, p19, cfg_gouv.MarkerTourne)               
            if IsControlJustReleased(0, 38) then
                OpenChestGouv()
            end                
        elseif #(pCoords - v.pos) < cfg_gouv.MarkerDistance then
            spam = false 
            RageUI.CloseAll()
        end
        end
           end
        end
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'gouvernement' then  
        for _,v in pairs(cfg_gouv.Garage) do
            if servicegouv then
            if #(pCoords - v.pos) < cfg_gouv.MarkerDistance then
                spam = true
                Visual.Subtitle("Appuyer sur [~r~E~s~] pour accéder au ~r~Menu Garage")
                DrawMarker(cfg_gouv.MarkerType, v.pos,  0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_gouv.MarkerSizeLargeur, cfg_gouv.MarkerSizeEpaisseur, cfg_gouv.MarkerSizeHauteur, cfg_gouv.MarkerColorR, cfg_gouv.MarkerColorG, cfg_gouv.MarkerColorB, cfg_gouv.MarkerOpacite, cfg_gouv.MarkerSaute, true, p19, cfg_gouv.MarkerTourne)               
                if IsControlJustReleased(0, 38) then
                    OpenMenuGarageGouv()
                    local playerPed = GetPlayerPed(-1)
                end                
            elseif #(pCoords - v.pos) < cfg_gouv.MarkerDistance then
                spam = false 
                RageUI.CloseAll()
            end
            end
               end
            end
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'gouvernement' then  
            for _,v in pairs(cfg_gouv.Ranger) do
                if servicegouv then
                if #(pCoords - v.pos) < cfg_gouv.MarkerDistance then
                    spam = true
                    Visual.Subtitle("Appuyer sur [~r~E~s~] pour accéder au ~r~Menu Ranger")
                    DrawMarker(cfg_gouv.MarkerType, v.pos,  0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_gouv.MarkerSizeLargeur, cfg_gouv.MarkerSizeEpaisseur, cfg_gouv.MarkerSizeHauteur, cfg_gouv.MarkerColorR, cfg_gouv.MarkerColorG, cfg_gouv.MarkerColorB, cfg_gouv.MarkerOpacite, cfg_gouv.MarkerSaute, true, p19, cfg_gouv.MarkerTourne)               
                    if IsPedSittingInAnyVehicle(PlayerPedId()) then
                    if IsControlJustReleased(0, 38) then
                     DoScreenFadeOut(1500)
                     Wait(1500)
                     local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                      if dist4 < 4 then
                      DeleteEntity(veh)
                      DoScreenFadeIn(1500)
                     Wait(1500)
                      end
                    end
                    end
                    end                
                elseif #(pCoords - v.pos) < cfg_gouv.MarkerDistance then
                    spam = false 
                    RageUI.CloseAll()
                end
                   end
                end
             if ESX.PlayerData.job and ESX.PlayerData.job.name == 'gouvernement' then  
            for _,v in pairs(cfg_gouv.Vestiaire) do
                if servicegouv then
                if #(pCoords - v.pos) < cfg_gouv.MarkerDistance then
                    spam = true
                    Visual.Subtitle("Appuyer sur [~r~E~s~] pour accéder au ~r~Menu Vestiaire")
                    DrawMarker(cfg_gouv.MarkerType, v.pos,  0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_gouv.MarkerSizeLargeur, cfg_gouv.MarkerSizeEpaisseur, cfg_gouv.MarkerSizeHauteur, cfg_gouv.MarkerColorR, cfg_gouv.MarkerColorG, cfg_gouv.MarkerColorB, cfg_gouv.MarkerOpacite, cfg_gouv.MarkerSaute, true, p19, cfg_gouv.MarkerTourne)               
                    if IsControlJustReleased(0, 38) then
                        VestiaireGouv()
                        local playerPed = GetPlayerPed(-1)
                    end                
                elseif #(pCoords - v.pos) < cfg_gouv.MarkerDistance then
                    spam = false 
                    RageUI.CloseAll()
                end
                end
                   end
                end
        if spam then
            Wait(1)
        else
            Wait(500)
        end
    end
end)
