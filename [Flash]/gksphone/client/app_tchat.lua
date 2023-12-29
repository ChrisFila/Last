RegisterNetEvent("gksphone:darkreceive")
AddEventHandler("gksphone:darkreceive", function(message)
  SendNUIMessage({event = 'darkreceive', message = message})
end)

RegisterNetEvent("gksphone:darkchannel")
AddEventHandler("gksphone:darkchannel", function(channel, messages)
  SendNUIMessage({event = 'darkchannel', messages = messages})
end)

RegisterNUICallback('darkaddMessage', function(data, cb)
  TriggerServerEvent('gksphone:darkaddMessage', data.channel, data.message)
end)

RegisterNUICallback('darkgetChannel', function(data, cb)
  TriggerServerEvent('gksphone:darkchannel', data.channel)
end)


RegisterNUICallback('darkreceive', function(data, cb)
  TriggerServerEvent('gksphone:darkreceive', data.channel, data.message)
end)
