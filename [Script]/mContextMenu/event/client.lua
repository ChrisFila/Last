

RegisterNetEvent("contextmenu:NetworkOverrideClockTime_response")
AddEventHandler("contextmenu:NetworkOverrideClockTime_response", function(time)
    NetworkOverrideClockTime(time, 0, 0)
end)

RegisterNetEvent("contextmenu:SetWeatherType_response")
AddEventHandler("contextmenu:SetWeatherType_response", function(type)
    SetWeatherTypePersist(type)
    SetWeatherTypeNow(type)
    SetWeatherTypeNowPersist(type)
end)
