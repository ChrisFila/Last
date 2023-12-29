---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by iTexZ.
--- DateTime: 05/11/2020 02:17
---

local TextPanels = {
    Background = { Dictionary = "OnestlaFilsDePuteGrr", Texture = "gradient_bgd", Y = 38, Width = 431, Height = 42 },
}

---@type Panel
function FlashSideUI.RenderSprite2(Dictionary, Texture)
    local CurrentMenu = FlashSideUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            RenderSprite(Dictionary, Texture, CurrentMenu.X, CurrentMenu.Y + TextPanels.Background.Y + CurrentMenu.SubtitleHeight + FlashSideUI.ItemOffset + (FlashSideUI.StatisticPanelCount * 42), TextPanels.Background.Width + CurrentMenu.WidthOffset, TextPanels.Background.Height + 200, 0, 255, 255, 255, 255);
            FlashSideUI.StatisticPanelCount = FlashSideUI.StatisticPanelCount + 1
        end
    end
end

function FlashSideUI.RenderSprite(Dictionary,Texture)
    local CurrentMenu = FlashSideUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then

            RenderSprite(Dictionary, Texture, CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + FlashSideUI.ItemOffset, 431 + (CurrentMenu.WidthOffset / 1), 228)
            

            FlashSideUI.ItemOffset = FlashSideUI.ItemOffset + 228
        end
    end
end

local TextPanelVehicle = {
    Background = { Dictionary = "OnestlaFilsDePuteGrr", Texture = "gradient_bgd", Y = 0.25, Width = 431, Height = 42 },
}

---@type Panel
function FlashSideUI.RenderWeapon(Dictionary, Texture)
    local CurrentMenu = FlashSideUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            RenderSprite(Dictionary, Texture, CurrentMenu.X, 560.25, TextPanelVehicle.Background.Width + CurrentMenu.WidthOffset, TextPanelVehicle.Background.Height + 200, 0, 255, 255, 255, 255);
            FlashSideUI.StatisticPanelCount = FlashSideUI.StatisticPanelCount + 1
        end
    end
end

---@type Panel
function FlashSideUI.RenderVehicle(Dictionary, Texture)
    local CurrentMenu = FlashSideUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            RenderSprite(Dictionary, Texture, CurrentMenu.X, 560.25, TextPanelVehicle.Background.Width + CurrentMenu.WidthOffset, TextPanelVehicle.Background.Height + 200, 0, 255, 255, 255, 255);
            FlashSideUI.StatisticPanelCount = FlashSideUI.StatisticPanelCount + 1
        end
    end
end

---@type Panel
function FlashSideUI.RenderCaisse(Dictionary, Texture)
    local CurrentMenu = FlashSideUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            RenderSprite(Dictionary, Texture, CurrentMenu.X, 258, TextPanelVehicle.Background.Width + CurrentMenu.WidthOffset, TextPanelVehicle.Background.Height + 200, 0, 255, 255, 255, 255);
            FlashSideUI.StatisticPanelCount = FlashSideUI.StatisticPanelCount + 1
        end
    end
end

---@type Panel
function FlashSideUI.RenderPackEntreprise(Dictionary, Texture)
    local CurrentMenu = FlashSideUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            RenderSprite(Dictionary, Texture, CurrentMenu.X, 345, TextPanelVehicle.Background.Width + CurrentMenu.WidthOffset, TextPanelVehicle.Background.Height + 200, 0, 255, 255, 255, 255);
            FlashSideUI.StatisticPanelCount = FlashSideUI.StatisticPanelCount + 1
        end
    end
end

function FlashSideUI.RenderPackIllegal(Dictionary, Texture)
    local CurrentMenu = FlashSideUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            RenderSprite(Dictionary, Texture, CurrentMenu.X, 285, TextPanelVehicle.Background.Width + CurrentMenu.WidthOffset, TextPanelVehicle.Background.Height + 200, 0, 255, 255, 255, 255);
            FlashSideUI.StatisticPanelCount = FlashSideUI.StatisticPanelCount + 1
        end
    end
end