MenuPool = {}
MenuPool.__index = MenuPool

setmetatable(MenuPool, {
    __call = function(cls, ...)
        return cls.CreateNew(...)
    end
})

function MenuPool.CreateNew(holdKey, clickKey, altFunctionKey, activateItemKey)
    local self = setmetatable({}, MenuPool)

    self.menus = {}

    self.keys = {
        keyboard = {
            holdForCursor   = holdKey or 19,
            openMenu        = clickKey or 25,
            altFunction     = altFunctionKey or 24,
            activateItem    = activateItemKey or 24
        },
    }

    self.settings = {
        screenEdgeScroll = false
    }

    self.resolution = vector2(0, 0)

    self.OnOpenMenu     = nil
    self.OnCloseMenu     = nil
    self.OnAltFunction  = nil
    self.OnMouseOver    = nil
    self.CustomProcess    = nil

    RegisterCommand('+interaction', function()
        SetCursorLocation(0.5, 0.5)

        local resX, resY = GetActiveScreenResolution()
        self.resolution = vector2(resX, resY)
        self.buttonPressed = true
    end)

    CreateThread(function()
        while (true) do
            Wait(0)
            self:Process()
        end
    end)

    return self
end

function MenuPool:AddMenu()
    table.insert(self.menus, Menu(self))

    return self.menus[#self.menus]
end

function MenuPool:AddSubmenu(parentMenu, title)
    table.insert(self.menus, Menu(self))

    local item = parentMenu:AddSubmenu(title, self.menus[#self.menus])

    return self.menus[#self.menus], item
end

function MenuPool:Reset()
    self.menus = {}

    collectgarbage()
end

function MenuPool:Process()
    if IsNuiFocused() then return end

    if self.CustomProcess then
        self.CustomProcess()
    end
    if self.buttonPressed then
        SetMouseCursorActiveThisFrame()

        local cursorPos = vector2(GetControlNormal(0, 239), GetControlNormal(0, 240))

        for i = 1, #self.menus, 1 do
            if (self.menus[i]:Visible()) then
                self.menus[i]:Process(cursorPos)
            end
        end

        DisableControlAction(0, 1, true)
        DisableControlAction(0, 2, true)
        DisableControlAction(0, self.keys.keyboard.activateItem, true)
        DisableControlAction(0, self.keys.keyboard.openMenu, true)
        DisableControlAction(0, 68, true)
        DisableControlAction(0, 69, true)
        DisableControlAction(0, 70, true)
        DisableControlAction(0, 91, true)
        DisableControlAction(0, 92, true)
        DisableControlAction(0, 330, true)
        DisableControlAction(0, 331, true)
        DisableControlAction(0, 347, true)
        DisableControlAction(0, 257, true)
        
        local screenPosition = nil
        local hitSomething, worldPosition, normalDirection, hitEntityHandle = nil, nil, nil, nil

        if (self.OnMouseOver) then
            screenPosition = vector2(GetControlNormal(0, 239), GetControlNormal(0, 240))
            hitSomething, worldPosition, normalDirection, hitEntityHandle, materialHash = _Target:TargetCoords(screenPosition, 10000.0)
            self.OnMouseOver(screenPosition, hitSomething, worldPosition, hitEntityHandle, normalDirection, materialHash)
        end

        if (self.OnOpenMenu and IsDisabledControlJustPressed(0, self.keys.keyboard.openMenu)) then
            if (screenPosition == nil) then
                screenPosition = vector2(GetControlNormal(0, 239), GetControlNormal(0, 240))
                hitSomething, worldPosition, normalDirection, hitEntityHandle, materialHash = _Target:TargetCoords(screenPosition, 10000.0)
            end

            CreateThread(function()
                self.OnOpenMenu(screenPosition, hitSomething, worldPosition, hitEntityHandle, normalDirection)
            end)
        end

        if (self.OnAltFunction and IsDisabledControlJustPressed(0, self.keys.keyboard.altFunction)) then
            if (screenPosition == nil) then
                screenPosition = vector2(GetControlNormal(0, 239), GetControlNormal(0, 240))
                hitSomething, worldPosition, normalDirection, hitEntityHandle, materialHash = _Target:TargetCoords(screenPosition, 10000.0)
            end

            CreateThread(function()
                self.OnAltFunction(screenPosition, hitSomething, worldPosition, hitEntityHandle, normalDirection)
            end)
        end

        if (IsDisabledControlJustPressed(0, self.keys.keyboard.activateItem)) then
			self._cursorPosPressed = cursorPos
            local clickedMenu = false

            for i = #self.menus, 1, -1 do
                if (self.menus[i]:Visible() and self.menus[i]:InBounds(cursorPos)) then
                    local item = self.menus[i]:Clicked(cursorPos)

                    clickedMenu = true
                    break
                end
            end

            if (not clickedMenu) then
                self:CloseAllMenus()
            end
        elseif (IsDisabledControlJustReleased(0, self.keys.keyboard.activateItem)) then
            for i = #self.menus, 1, -1 do
                if (self.menus[i]:Visible() and self.menus[i]:InBounds(self._cursorPosPressed)) then
                    local item = self.menus[i]:Released(self._cursorPosPressed)
                    break
                end
            end
			self._cursorPosPressed = nil
        end

        if self.settings.screenEdgeScroll then
            if screenPosition == nil then
                screenPosition = vector2(GetControlNormal(0, 239), GetControlNormal(0, 240))
            end

            SetMouseCursorSprite(1)

            local frameTime = GetFrameTime()

            if (screenPosition.x > (self.resolution.x - 10.0) / self.resolution.x) then
                SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() - 60.0 * frameTime)
                SetMouseCursorSprite(7)
            elseif (screenPosition.x < 10.0 / self.resolution.x) then
                SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() + 60.0 * frameTime)
                SetMouseCursorSprite(6)
            end
        end
    end
end

function MenuPool:IsAnyMenuOpen()
    for i = 1, #self.menus, 1 do
        if (self.menus[i]:Visible()) then
            return true
        end
    end

    return false
end

function MenuPool:CloseAllMenus()
    for i = 1, #self.menus, 1 do
        self.menus[i]:Visible(false)
    end

    if self.OnCloseMenu then
        self.OnCloseMenu()
    end

    collectgarbage()
end
