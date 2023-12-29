local menuPool = MenuPool()
local selectedWorldPosition = nil

local currentEntity = nil

EnableEditorRuntime()

menuPool.OnOpenMenu = function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
    local entityType = GetEntityType(hitEntity)
    CreateMenu(screenPosition, worldPosition, entityType, hitEntity, materialHash)
end

menuPool.CustomProcess = function()
    if selectedWorldPosition then
        DrawMarker(28, selectedWorldPosition.x, selectedWorldPosition.y, selectedWorldPosition.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 100, false, true, 2, nil, nil, true)
    end
    if SelectedEntity then
        local entityType = GetEntityType(SelectedEntity)
        DrawMarker(0, GetPedBoneCoords(SelectedEntity, 31086, 0.7, 0.0, 0.0), 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 0, 0, 255, 20, 0, 0, 0, 0, 0, 0, 0)
    end
    if currentEntity then
        local entityType = GetEntityType(currentEntity)
        if entityType == 1 then
            DrawMarker(0, GetPedBoneCoords(currentEntity, 31086, 0.7, 0.0, 0.0), 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 255, 255, 255, 20, 0, 0, 0, 0, 0, 0, 0)
        end
    end
end

menuPool.OnCloseMenu = function()
    if not EditWithGizmo then
        EditEntity = nil
    end
    menuPool.buttonPressed = false
end


function CreateMenu(screenPosition, worldPosition, entityType, hitEntity, materialHash)
    _G.LastEntityHit = hitEntity
    _G.LastCoordsHit = worldPosition
    local playerPed = PlayerPedId()
    local isInAnyVehicle = IsPedInAnyVehicle(playerPed, true)
    local currentVehicle = 0
    menuPool:Reset()
    local contextMenu = menuPool:AddMenu()
    currentEntity = hitEntity
    contextMenu.OnClosed = function()
        currentEntity = nil
    end
    contextMenu.alpha = 150
    contextMenu.colors.border = Color(0, 0, 0, 0)
    if hitEntity ~= nil and DoesEntityExist(hitEntity) then
        _My()
        if playerPed == hitEntity then
            for k,v in pairs(Action_Config.My) do 
                if not v.Blocked then 
                    if v.IsRestricted then 
                        if not IsAllowed() then 
                            goto pass
                        end
                    end
                    if v.Type == "buttom" then 
                        local item = contextMenu:AddItem(v.Label)
                        v.EntityHit = hitEntity
                        item.OnRelease = v.OnClick
                        item.closeMenuOnRelease = v.CloseOnClick
                    elseif v.Type == "buttom-submenu" then
                        local subMenu = menuPool:AddSubmenu(contextMenu, v.Label)
                        for _, action in pairs(v.Action) do
                            local subItem = subMenu:AddItem(action[1])
                            subItem.OnRelease = action[2]
                            subItem.closeMenuOnRelease = v.CloseOnClick
                        end
                    end
                end
                :: pass ::
            end
        elseif IsEntityAVehicle(hitEntity) then
            _Vehicule()
            for k,v in pairs(Action_Config.Vehicule) do 
                if not v.Blocked then 
                    if v.IsRestricted then 
                        if not IsAllowed() then 
                            goto pass
                        end
                    end
                    if v.Type == "buttom" then 
                        local item = contextMenu:AddItem(v.Label)
                        v.EntityHit = hitEntity
                        item.OnRelease = v.OnClick
                        item.closeMenuOnRelease = v.CloseOnClick
                    elseif v.Type == "buttom-submenu" then
                        local subMenu = menuPool:AddSubmenu(contextMenu, v.Label)
                        for _, action in pairs(v.Action) do
                            local subItem = subMenu:AddItem(action[1])
                            subItem.OnRelease = action[2]
                            subItem.closeMenuOnRelease = v.CloseOnClick
                        end
                    end
                end
                :: pass ::
            end
        elseif IsEntityAPed(hitEntity) and IsPedAPlayer(hitEntity) then
            _Player()
            for k,v in pairs(Action_Config.Player) do 
                if not v.Blocked then 
                    if v.IsRestricted then 
                        if not IsAllowed() then 
                            goto pass
                        end
                    end
                    if v.Type == "buttom" then 
                        local item = contextMenu:AddItem(v.Label)
                        v.EntityHit = hitEntity
                        item.OnRelease = v.OnClick
                        item.closeMenuOnRelease = v.CloseOnClick
                    elseif v.Type == "buttom-submenu" then
                        local subMenu = menuPool:AddSubmenu(contextMenu, v.Label)
                        for _, action in pairs(v.Action) do
                            local subItem = subMenu:AddItem(action[1])
                            subItem.OnRelease = action[2]
                            subItem.closeMenuOnRelease = v.CloseOnClick
                        end
                    end
                end
                :: pass ::
            end
        elseif IsEntityAPed(hitEntity) then
            _Peds()
            for k,v in pairs(Action_Config.Peds) do 
                if not v.Blocked then 
                    if v.IsRestricted then 
                        if not IsAllowed() then 
                            goto pass
                        end
                    end
                    if v.Type == "buttom" then 
                        local item = contextMenu:AddItem(v.Label)
                        v.EntityHit = hitEntity
                        item.OnRelease = v.OnClick
                        item.closeMenuOnRelease = v.CloseOnClick
                    elseif v.Type == "buttom-submenu" then
                        local subMenu = menuPool:AddSubmenu(contextMenu, v.Label)
                        for _, action in pairs(v.Action) do
                            local subItem = subMenu:AddItem(action[1])
                            subItem.OnRelease = action[2]
                            subItem.closeMenuOnRelease = v.CloseOnClick
                        end
                    end
                end
                :: pass ::
            end
        elseif IsEntityAnObject(hitEntity) then
            _Object()
            for k,v in pairs(Action_Config.Object) do 
                if not v.Blocked then 
                    if v.IsRestricted then 
                        if not IsAllowed() then 
                            goto pass
                        end
                    end
                    if v.Type == "buttom" then 
                        local item = contextMenu:AddItem(v.Label)
                        v.EntityHit = hitEntity
                        item.OnRelease = v.OnClick
                        item.closeMenuOnRelease = v.CloseOnClick
                    elseif v.Type == "buttom-submenu" then
                        local subMenu = menuPool:AddSubmenu(contextMenu, v.Label)
                        for _, action in pairs(v.Action) do
                            local subItem = subMenu:AddItem(action[1])
                            subItem.OnRelease = action[2]
                            subItem.closeMenuOnRelease = v.CloseOnClick
                        end
                    end
                end
                :: pass ::
            end
        else
            _Ground()
            for k,v in pairs(Action_Config.Ground) do 
                if not v.Blocked then 
                    if v.IsRestricted then 
                        if not IsAllowed() then 
                            goto pass
                        end
                    end
                    if v.Type == "buttom" then 
                        local item = contextMenu:AddItem(v.Label)
                        v.EntityHit = hitEntity
                        item.OnRelease = v.OnClick
                        item.closeMenuOnRelease = v.CloseOnClick
                    elseif v.Type == "buttom-submenu" then
                        local subMenu = menuPool:AddSubmenu(contextMenu, v.Label)
                        for _, action in pairs(v.Action) do
                            local subItem = subMenu:AddItem(action[1])
                            subItem.OnRelease = action[2]
                            subItem.closeMenuOnRelease = v.CloseOnClick
                        end
                    end
                end
                :: pass ::
            end
        end
    else
        _sky()
        for k,v in pairs(Action_Config.Sky) do 
            if not v.Blocked then 
                if v.IsRestricted then 
                    if not IsAllowed() then 
                        goto pass
                    end
                end
                if v.Type == "buttom" then 
                    local item = contextMenu:AddItem(v.Label)
                    v.EntityHit = hitEntity
                    item.OnRelease = v.OnClick
                    item.closeMenuOnRelease = v.CloseOnClick
                elseif v.Type == "buttom-submenu" then
                    local subMenu = menuPool:AddSubmenu(contextMenu, v.Label)
                    for _, action in pairs(v.Action) do
                        local subItem = subMenu:AddItem(action[1])
                        subItem.OnRelease = action[2]
                        subItem.closeMenuOnRelease = v.CloseOnClick
                    end
                end
            end
            :: pass ::
        end
    end
    contextMenu:SetPosition(screenPosition)
    contextMenu:Visible(true)
end
