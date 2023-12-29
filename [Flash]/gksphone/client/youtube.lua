
xSound = exports.xsound

RegisterNUICallback('youtplay', function(data)
    xSound:Cal(data.link, false)
end)

RegisterNUICallback('youtstop', function() 
    xSound:Durdur()
end)

RegisterNUICallback('musicDevamet', function()
    xSound:Devamet()
end)

RegisterNUICallback('musicDuraklat', function() 
    xSound:Duraklat()
end)

RegisterNUICallback('streamerMod', function(data) 
    xSound:Streamer(data)
end)

RegisterNUICallback('musicvolume', function(volume) 
    local serverId = GetPlayerServerId(PlayerId())
    local muzikAdi = tostring(serverId)
    TriggerServerEvent("gksphone:ChangeVolume", muzikAdi, volume)
end)

RegisterNetEvent("gksphone:ChangeVolume")
AddEventHandler("gksphone:ChangeVolume", function(muzikAdi, volume)
    xSound:setVolumeMax(muzikAdi, volume.volume)
end)