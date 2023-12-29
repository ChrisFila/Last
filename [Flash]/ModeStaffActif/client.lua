RegisterNetEvent("ui:staffinfo")
AddEventHandler("ui:staffinfo", function(info)
    SendNUIMessage({
        type = "staffinfo",
        toggle = info.toggle,
        players = info.players,
        staffs = info.staffs,
        staffsService = info.staffsService,
        reports = info.reports,
        reportsWait = info.reportsWait
    })
end)

RegisterCommand("staffOff", function()
    TriggerEvent("ui:staffinfo", {
        toggle = false
    })
end)

RegisterNetEvent("ui:hideAll")
AddEventHandler("ui:hideAll", function()
    SendNUIMessage({
        type = "hideAll"
    })
end)

RegisterNetEvent("ui:showAll")
AddEventHandler("ui:showAll", function()
    SendNUIMessage({
        type = "showAll"
    })
end)