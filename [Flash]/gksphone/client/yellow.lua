--====================================================================================
-- #Author: Jonathan D @ Gannon
--====================================================================================

RegisterNetEvent("gksphone:yellow_getPagess")
AddEventHandler("gksphone:yellow_getPagess", function(pagess)
  SendNUIMessage({event = 'yellow_pagess', pagess = pagess})
end)

RegisterNetEvent("gksphone:yellow_newPagess")
AddEventHandler("gksphone:yellow_newPagess", function(pages)
  ESX.TriggerServerCallback('gksphone:phone-check', function(durum)
    if durum ~= nil then
        SendNUIMessage({event = 'yellow_newPages', pages = pages})
    end
  end)
end)



RegisterNetEvent("gksphone:yellow_showError")
AddEventHandler("gksphone:yellow_showError", function(title, message)
  SendNUIMessage({event = 'yellow_showError', message = message, title = title})
end)

RegisterNetEvent("gksphone:yellow_showSuccess")
AddEventHandler("gksphone:yellow_showSuccess", function(title, message)
  SendNUIMessage({event = 'yellow_showSuccess', message = message, title = title})
end)

RegisterNUICallback('yellow_getPagess', function(data, cb)
  TriggerServerEvent('gksphone:yellow_getPagess', data.firstname, data.phone_number)
end)

RegisterNUICallback('yellow_postPages', function(data, cb)
  TriggerServerEvent('gksphone:yellow_postPagess', data.firstname, data.phone_number, data.lastname, data.message, data.image)
end)






RegisterNUICallback('yellow_userssDeleteTweet', function(data, cb) 
  TriggerServerEvent('gksphone:yellow_usersDeleteTweet', data.yellowId, data.phone_number)
end)



RegisterNUICallback('yellow_getUserTweets', function(data, cb)

  ESX.TriggerServerCallback('gksphone:GetYellowUsers', function(usersyellow)
    UpdateYellow(usersyellow)
  end, data.phone_number)
end)

function UpdateYellow(usersyellow)
  SendNUIMessage({event = 'yellow_UserTweets', usersyellow = usersyellow})
end

RegisterNetEvent('DeleteYellow')
AddEventHandler('DeleteYellow', function(usersyellow)
    ESX.TriggerServerCallback('gksphone:GetYellowUsers', function(data)
      UpdateYellow(data)
    end, usersyellow)
end)