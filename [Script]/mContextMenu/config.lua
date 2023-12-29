

MyLicence = ""

TriggerServerEvent("contextmenu:checkLicence")
RegisterNetEvent("contextmenu:checkLicence:send")
AddEventHandler("contextmenu:checkLicence:send", function(licence)
    MyLicence = licence
end)

LastEntityHit = nil
LastCoordsHit = nil

function IsAllowed()
    local allowed = false
    for k,v in pairs(staff_licence) do
        if v == MyLicence then
            allowed = true
        end
    end
    return allowed
end