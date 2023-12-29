ESX = nil

Citizen.CreateThread(function()
        while ESX == nil do
                TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
                Citizen.Wait(0)
        end
        TriggerEvent('es:setMoneyDisplay', 0.0)
        ESX.UI.HUD.SetDisplay(0.0)

        -- Updates the UI on start
        NetworkSetTalkerProximity(10.0)
end)


RegisterNetEvent('ui:toggle')
AddEventHandler('ui:toggle', function(show)
        SendNUIMessage({action = "toggle", show = show})
end)

RegisterNetEvent('esx_newui:updateBasicss')
AddEventHandler('esx_newui:updateBasicss', function(status)
        SendNUIMessage({action = "updateBasicss", status = status})
end)