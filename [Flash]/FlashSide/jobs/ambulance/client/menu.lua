RegisterCommand("ambulance_menu", function()
    if ESX.PlayerData.job.name == 'ambulance' then
        if IsInServiceEMS then
            FlashSide.Ambulance.OpenAmbulanceMenu()
        else
            ESX.ShowNotification('FlashSide~w~ Vous n\'êtes pas en service')
        end
    end
end, false)
RegisterKeyMapping('ambulance_menu', 'Menu Ambulance', 'keyboard', 'F6')

RegisterCommand("ambulance_appel", function()
    if ESX.PlayerData.job.name == 'ambulance' then
        if IsInServiceEMS then
            OpenReportListEms()
        else
            ESX.ShowNotification('FlashSide~w~ Vous n\'êtes pas en service')
        end
    end
end, false)
RegisterKeyMapping('ambulance_appel', 'Menu Appel EMS', 'keyboard', 'F3')