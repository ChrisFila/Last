Citizen.CreateThread(function()
    TriggerServerEvent('FlashSide:GetVIP')
end)
IsVip = false

function GetVIP()
    return IsVip
end

RegisterNetEvent('ewen:updateVIP')
AddEventHandler('ewen:updateVIP',function(vip)
    IsVip = vip
end)