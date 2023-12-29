---@type table
FlashSideUI.LastControl = false

---IsMouseInBounds
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@return number
---@public
function FlashSideUI.IsMouseInBounds(X, Y, Width, Height)
    local MX, MY = math.round(GetControlNormal(0, 239) * 1920) / 1920, math.round(GetControlNormal(0, 240) * 1080) / 1080
    X, Y = X / 1920, Y / 1080
    Width, Height = Width / 1920, Height / 1080
    return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
end

---GetSafeZoneBounds
---@return table
---@public
function FlashSideUI.GetSafeZoneBounds()
    local SafeSize = GetSafeZoneSize()
    SafeSize = math.round(SafeSize, 2)
    SafeSize = (SafeSize * 100) - 90
    SafeSize = 10 - SafeSize

    local W, H = 1920, 1080

    return { X = math.round(SafeSize * ((W / H) * 5.4)), Y = math.round(SafeSize * 5.4) }
end
---GoUp
---@param Options number
---@return nil
---@public
function FlashSideUI.GoUp(Options)
    if FlashSideUI.CurrentMenu ~= nil then
        Options = FlashSideUI.CurrentMenu.Options
        if FlashSideUI.CurrentMenu() then
            if (Options ~= 0) then
                if Options > FlashSideUI.CurrentMenu.Pagination.Total then
                    if FlashSideUI.CurrentMenu.Index <= FlashSideUI.CurrentMenu.Pagination.Minimum then
                        if FlashSideUI.CurrentMenu.Index == 1 then
                            FlashSideUI.CurrentMenu.Pagination.Minimum = Options - (FlashSideUI.CurrentMenu.Pagination.Total - 1)
                            FlashSideUI.CurrentMenu.Pagination.Maximum = Options
                            FlashSideUI.CurrentMenu.Index = Options
                        else
                            FlashSideUI.CurrentMenu.Pagination.Minimum = (FlashSideUI.CurrentMenu.Pagination.Minimum - 1)
                            FlashSideUI.CurrentMenu.Pagination.Maximum = (FlashSideUI.CurrentMenu.Pagination.Maximum - 1)
                            FlashSideUI.CurrentMenu.Index = FlashSideUI.CurrentMenu.Index - 1
                        end
                    else
                        FlashSideUI.CurrentMenu.Index = FlashSideUI.CurrentMenu.Index - 1
                    end
                else
                    if FlashSideUI.CurrentMenu.Index == 1 then
                        FlashSideUI.CurrentMenu.Pagination.Minimum = Options - (FlashSideUI.CurrentMenu.Pagination.Total - 1)
                        FlashSideUI.CurrentMenu.Pagination.Maximum = Options
                        FlashSideUI.CurrentMenu.Index = Options
                    else
                        FlashSideUI.CurrentMenu.Index = FlashSideUI.CurrentMenu.Index - 1
                    end
                end

                local Audio = FlashSideUI.Settings.Audio
                FlashSideUI.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                FlashSideUI.LastControl = true
            else
                local Audio = FlashSideUI.Settings.Audio
                FlashSideUI.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

---GoDown
---@param Options number
---@return nil
---@public
function FlashSideUI.GoDown(Options)
    if FlashSideUI.CurrentMenu ~= nil then
        Options = FlashSideUI.CurrentMenu.Options
        if FlashSideUI.CurrentMenu() then
            if (Options ~= 0) then
                if Options > FlashSideUI.CurrentMenu.Pagination.Total then
                    if FlashSideUI.CurrentMenu.Index >= FlashSideUI.CurrentMenu.Pagination.Maximum then
                        if FlashSideUI.CurrentMenu.Index == Options then
                            FlashSideUI.CurrentMenu.Pagination.Minimum = 1
                            FlashSideUI.CurrentMenu.Pagination.Maximum = FlashSideUI.CurrentMenu.Pagination.Total
                            FlashSideUI.CurrentMenu.Index = 1
                        else
                            FlashSideUI.CurrentMenu.Pagination.Maximum = (FlashSideUI.CurrentMenu.Pagination.Maximum + 1)
                            FlashSideUI.CurrentMenu.Pagination.Minimum = FlashSideUI.CurrentMenu.Pagination.Maximum - (FlashSideUI.CurrentMenu.Pagination.Total - 1)
                            FlashSideUI.CurrentMenu.Index = FlashSideUI.CurrentMenu.Index + 1
                        end
                    else
                        FlashSideUI.CurrentMenu.Index = FlashSideUI.CurrentMenu.Index + 1
                    end
                else
                    if FlashSideUI.CurrentMenu.Index == Options then
                        FlashSideUI.CurrentMenu.Pagination.Minimum = 1
                        FlashSideUI.CurrentMenu.Pagination.Maximum = FlashSideUI.CurrentMenu.Pagination.Total
                        FlashSideUI.CurrentMenu.Index = 1
                    else
                        FlashSideUI.CurrentMenu.Index = FlashSideUI.CurrentMenu.Index + 1
                    end
                end
                local Audio = FlashSideUI.Settings.Audio
                FlashSideUI.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                FlashSideUI.LastControl = false
            else
                local Audio = FlashSideUI.Settings.Audio
                FlashSideUI.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

function FlashSideUI.GoLeft(Controls)
    if Controls.Left.Enabled then
        for Index = 1, #Controls.Left.Keys do
            if not Controls.Left.Pressed then
                if IsDisabledControlJustPressed(Controls.Left.Keys[Index][1], Controls.Left.Keys[Index][2]) then
                    Controls.Left.Pressed = true

                    Citizen.CreateThread(function()
                        Controls.Left.Active = true

                        Citizen.Wait(0.01)

                        Controls.Left.Active = false

                        Citizen.Wait(174.99)

                        while Controls.Left.Enabled and IsDisabledControlPressed(Controls.Left.Keys[Index][1], Controls.Left.Keys[Index][2]) do
                            Controls.Left.Active = true

                            Citizen.Wait(0.01)

                            Controls.Left.Active = false

                            Citizen.Wait(124.99)
                        end

                        Controls.Left.Pressed = false
                        Wait(10)
                    end)

                    break
                end
            end
        end
    end
end

function FlashSideUI.GoRight(Controls)
    if Controls.Right.Enabled then
        for Index = 1, #Controls.Right.Keys do
            if not Controls.Right.Pressed then
                if IsDisabledControlJustPressed(Controls.Right.Keys[Index][1], Controls.Right.Keys[Index][2]) then
                    Controls.Right.Pressed = true

                    Citizen.CreateThread(function()
                        Controls.Right.Active = true

                        Citizen.Wait(0.01)

                        Controls.Right.Active = false

                        Citizen.Wait(174.99)

                        while Controls.Right.Enabled and IsDisabledControlPressed(Controls.Right.Keys[Index][1], Controls.Right.Keys[Index][2]) do
                            Controls.Right.Active = true

                            Citizen.Wait(1)

                            Controls.Right.Active = false

                            Citizen.Wait(124.99)
                        end

                        Controls.Right.Pressed = false
                        Wait(10)
                    end)

                    break
                end
            end
        end
    end
end

function FlashSideUI.GoSliderLeft(Controls)
    if Controls.SliderLeft.Enabled then
        for Index = 1, #Controls.SliderLeft.Keys do
            if not Controls.SliderLeft.Pressed then
                if IsDisabledControlJustPressed(Controls.SliderLeft.Keys[Index][1], Controls.SliderLeft.Keys[Index][2]) then
                    Controls.SliderLeft.Pressed = true
                    Citizen.CreateThread(function()
                        Controls.SliderLeft.Active = true
                        Citizen.Wait(1)
                        Controls.SliderLeft.Active = false
                        while Controls.SliderLeft.Enabled and IsDisabledControlPressed(Controls.SliderLeft.Keys[Index][1], Controls.SliderLeft.Keys[Index][2]) do
                            Controls.SliderLeft.Active = true
                            Citizen.Wait(1)
                            Controls.SliderLeft.Active = false
                        end
                        Controls.SliderLeft.Pressed = false
                    end)
                    break
                end
            end
        end
    end
end

function FlashSideUI.GoSliderRight(Controls)
    if Controls.SliderRight.Enabled then
        for Index = 1, #Controls.SliderRight.Keys do
            if not Controls.SliderRight.Pressed then
                if IsDisabledControlJustPressed(Controls.SliderRight.Keys[Index][1], Controls.SliderRight.Keys[Index][2]) then
                    Controls.SliderRight.Pressed = true
                    Citizen.CreateThread(function()
                        Controls.SliderRight.Active = true
                        Citizen.Wait(1)
                        Controls.SliderRight.Active = false
                        while Controls.SliderRight.Enabled and IsDisabledControlPressed(Controls.SliderRight.Keys[Index][1], Controls.SliderRight.Keys[Index][2]) do
                            Controls.SliderRight.Active = true
                            Citizen.Wait(1)
                            Controls.SliderRight.Active = false
                        end
                        Controls.SliderRight.Pressed = false
                    end)
                    break
                end
            end
        end
    end
end

---Controls
---@return nil
---@public
function FlashSideUI.Controls()
    if FlashSideUI.CurrentMenu ~= nil then
        if FlashSideUI.CurrentMenu() then
            if FlashSideUI.CurrentMenu.Open then

                local Controls = FlashSideUI.CurrentMenu.Controls;
                ---@type number
                local Options = FlashSideUI.CurrentMenu.Options
                FlashSideUI.Options = FlashSideUI.CurrentMenu.Options
                if FlashSideUI.CurrentMenu.EnableMouse then
                    DisableAllControlActions(2)
                end

                if not IsInputDisabled(2) then
                    for Index = 1, #Controls.Enabled.Controller do
                        EnableControlAction(Controls.Enabled.Controller[Index][1], Controls.Enabled.Controller[Index][2], true)
                    end
                else
                    for Index = 1, #Controls.Enabled.Keyboard do
                        EnableControlAction(Controls.Enabled.Keyboard[Index][1], Controls.Enabled.Keyboard[Index][2], true)
                    end
                end

                if Controls.Up.Enabled then
                    for Index = 1, #Controls.Up.Keys do
                        if not Controls.Up.Pressed then
                            if IsDisabledControlJustPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) then
                                Controls.Up.Pressed = true

                                Citizen.CreateThread(function()
                                    FlashSideUI.GoUp(Options)

                                    Citizen.Wait(175)

                                    while Controls.Up.Enabled and IsDisabledControlPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) do
                                        FlashSideUI.GoUp(Options)

                                        Citizen.Wait(50)
                                    end

                                    Controls.Up.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end

                if Controls.Down.Enabled then
                    for Index = 1, #Controls.Down.Keys do
                        if not Controls.Down.Pressed then
                            if IsDisabledControlJustPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) then
                                Controls.Down.Pressed = true

                                Citizen.CreateThread(function()
                                    FlashSideUI.GoDown(Options)

                                    Citizen.Wait(175)

                                    while Controls.Down.Enabled and IsDisabledControlPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) do
                                        FlashSideUI.GoDown(Options)

                                        Citizen.Wait(50)
                                    end

                                    Controls.Down.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end

                FlashSideUI.GoLeft(Controls)
                --- Default Left navigation
                FlashSideUI.GoRight(Controls) --- Default Right navigation

                FlashSideUI.GoSliderLeft(Controls)
                FlashSideUI.GoSliderRight(Controls)

                if Controls.Select.Enabled then
                    for Index = 1, #Controls.Select.Keys do
                        if not Controls.Select.Pressed then
                            if IsDisabledControlJustPressed(Controls.Select.Keys[Index][1], Controls.Select.Keys[Index][2]) then
                                Controls.Select.Pressed = true

                                Citizen.CreateThread(function()
                                    Controls.Select.Active = true

                                    Citizen.Wait(0.01)

                                    Controls.Select.Active = false

                                    Citizen.Wait(174.99)

                                    while Controls.Select.Enabled and IsDisabledControlPressed(Controls.Select.Keys[Index][1], Controls.Select.Keys[Index][2]) do
                                        Controls.Select.Active = true

                                        Citizen.Wait(0.01)

                                        Controls.Select.Active = false

                                        Citizen.Wait(124.99)
                                    end

                                    Controls.Select.Pressed = false

                                end)

                                break
                            end
                        end
                    end
                end

                if Controls.Click.Enabled then
                    for Index = 1, #Controls.Click.Keys do
                        if not Controls.Click.Pressed then
                            if IsDisabledControlJustPressed(Controls.Click.Keys[Index][1], Controls.Click.Keys[Index][2]) then
                                Controls.Click.Pressed = true

                                Citizen.CreateThread(function()
                                    Controls.Click.Active = true

                                    Citizen.Wait(0.01)

                                    Controls.Click.Active = false

                                    Citizen.Wait(174.99)

                                    while Controls.Click.Enabled and IsDisabledControlPressed(Controls.Click.Keys[Index][1], Controls.Click.Keys[Index][2]) do
                                        Controls.Click.Active = true

                                        Citizen.Wait(0.01)

                                        Controls.Click.Active = false

                                        Citizen.Wait(124.99)
                                    end

                                    Controls.Click.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end
                if Controls.Back.Enabled then
                    for Index = 1, #Controls.Back.Keys do
                        if not Controls.Back.Pressed then
                            if IsDisabledControlJustPressed(Controls.Back.Keys[Index][1], Controls.Back.Keys[Index][2]) then
                                Controls.Back.Pressed = true
                                Wait(10)
                                break
                            end
                        end
                    end
                end

            end
        end
    end
end

---Navigation
---@return nil
---@public
function FlashSideUI.Navigation()
    if FlashSideUI.CurrentMenu ~= nil then
        if FlashSideUI.CurrentMenu() then
            if FlashSideUI.CurrentMenu.EnableMouse   then
                SetMouseCursorActiveThisFrame()
            end
            if FlashSideUI.Options > FlashSideUI.CurrentMenu.Pagination.Total then

                ---@type boolean
                local UpHovered = false

                ---@type boolean
                local DownHovered = false

                if not FlashSideUI.CurrentMenu.SafeZoneSize then
                    FlashSideUI.CurrentMenu.SafeZoneSize = { X = 0, Y = 0 }

                    if FlashSideUI.CurrentMenu.Safezone then
                        FlashSideUI.CurrentMenu.SafeZoneSize = FlashSideUI.GetSafeZoneBounds()

                        SetScriptGfxAlign(76, 84)
                        SetScriptGfxAlignParams(0, 0, 0, 0)
                    end
                end

                UpHovered = FlashSideUI.IsMouseInBounds(FlashSideUI.CurrentMenu.X + FlashSideUI.CurrentMenu.SafeZoneSize.X, FlashSideUI.CurrentMenu.Y + FlashSideUI.CurrentMenu.SafeZoneSize.Y + FlashSideUI.CurrentMenu.SubtitleHeight + FlashSideUI.ItemOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Width + FlashSideUI.CurrentMenu.WidthOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Height)
                DownHovered = FlashSideUI.IsMouseInBounds(FlashSideUI.CurrentMenu.X + FlashSideUI.CurrentMenu.SafeZoneSize.X, FlashSideUI.CurrentMenu.Y + FlashSideUI.Settings.Items.Navigation.Rectangle.Height + FlashSideUI.CurrentMenu.SafeZoneSize.Y + FlashSideUI.CurrentMenu.SubtitleHeight + FlashSideUI.ItemOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Width + FlashSideUI.CurrentMenu.WidthOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Height)

                if FlashSideUI.CurrentMenu.EnableMouse   then


                    if FlashSideUI.CurrentMenu.Controls.Click.Active then
                        if UpHovered then
                            FlashSideUI.GoUp(FlashSideUI.Options)
                        elseif DownHovered then
                            FlashSideUI.GoDown(FlashSideUI.Options)
                        end
                    end

                    if UpHovered then
                        RenderRectangle(FlashSideUI.CurrentMenu.X, FlashSideUI.CurrentMenu.Y + FlashSideUI.CurrentMenu.SubtitleHeight + FlashSideUI.ItemOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Width + FlashSideUI.CurrentMenu.WidthOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        RenderRectangle(FlashSideUI.CurrentMenu.X, FlashSideUI.CurrentMenu.Y + FlashSideUI.CurrentMenu.SubtitleHeight + FlashSideUI.ItemOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Width + FlashSideUI.CurrentMenu.WidthOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end

                    if DownHovered then
                        RenderRectangle(FlashSideUI.CurrentMenu.X, FlashSideUI.CurrentMenu.Y + FlashSideUI.Settings.Items.Navigation.Rectangle.Height + FlashSideUI.CurrentMenu.SubtitleHeight + FlashSideUI.ItemOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Width + FlashSideUI.CurrentMenu.WidthOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        RenderRectangle(FlashSideUI.CurrentMenu.X, FlashSideUI.CurrentMenu.Y + FlashSideUI.Settings.Items.Navigation.Rectangle.Height + FlashSideUI.CurrentMenu.SubtitleHeight + FlashSideUI.ItemOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Width + FlashSideUI.CurrentMenu.WidthOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end
                else
                    RenderRectangle(FlashSideUI.CurrentMenu.X, FlashSideUI.CurrentMenu.Y + FlashSideUI.CurrentMenu.SubtitleHeight + FlashSideUI.ItemOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Width + FlashSideUI.CurrentMenu.WidthOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    RenderRectangle(FlashSideUI.CurrentMenu.X, FlashSideUI.CurrentMenu.Y + FlashSideUI.Settings.Items.Navigation.Rectangle.Height + FlashSideUI.CurrentMenu.SubtitleHeight + FlashSideUI.ItemOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Width + FlashSideUI.CurrentMenu.WidthOffset, FlashSideUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                end
                RenderSprite(FlashSideUI.Settings.Items.Navigation.Arrows.Dictionary, FlashSideUI.Settings.Items.Navigation.Arrows.Texture, FlashSideUI.CurrentMenu.X + FlashSideUI.Settings.Items.Navigation.Arrows.X + (FlashSideUI.CurrentMenu.WidthOffset / 2), FlashSideUI.CurrentMenu.Y + FlashSideUI.Settings.Items.Navigation.Arrows.Y + FlashSideUI.CurrentMenu.SubtitleHeight + FlashSideUI.ItemOffset, FlashSideUI.Settings.Items.Navigation.Arrows.Width, FlashSideUI.Settings.Items.Navigation.Arrows.Height)

                FlashSideUI.ItemOffset = FlashSideUI.ItemOffset + (FlashSideUI.Settings.Items.Navigation.Rectangle.Height * 2)

            end
        end
    end
end

---GoBack
---@return nil
---@public
function FlashSideUI.GoBack()
    if FlashSideUI.CurrentMenu ~= nil then
        local Audio = FlashSideUI.Settings.Audio
        FlashSideUI.PlaySound(Audio[Audio.Use].Back.audioName, Audio[Audio.Use].Back.audioRef)
        if FlashSideUI.CurrentMenu.Parent ~= nil then
            if FlashSideUI.CurrentMenu.Parent() then
                FlashSideUI.NextMenu = FlashSideUI.CurrentMenu.Parent
            else
                FlashSideUI.NextMenu = nil
                FlashSideUI.Visible(FlashSideUI.CurrentMenu, false)
            end
        else
            FlashSideUI.NextMenu = nil
            FlashSideUI.Visible(FlashSideUI.CurrentMenu, false)
        end
    end
end
