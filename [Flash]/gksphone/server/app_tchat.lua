function TchatGetMessageChannel (channel, cb)
    MySQL.Async.fetchAll("SELECT * FROM gksphone_app_chat WHERE channel = @channel ORDER BY time DESC LIMIT 100", { 
        ['@channel'] = channel
    }, cb)
end

function TchatAddMessage (channel, message)
  local Query = "INSERT INTO gksphone_app_chat (`channel`, `message`) VALUES(@channel, @message);"
  local Query2 = 'SELECT * from gksphone_app_chat WHERE `id` = @id;'
  local Parameters = {
    ['@channel'] = channel,
    ['@message'] = message
  }
  MySQL.Async.insert(Query, Parameters, function (id)
    MySQL.Async.fetchAll(Query2, { ['@id'] = id }, function (reponse)
      TriggerClientEvent('gksphone:darkreceive', -1, reponse[1])
    end)
  end)
end


RegisterServerEvent('gksphone:darkchannel')
AddEventHandler('gksphone:darkchannel', function(channel)
  local sourcePlayer = tonumber(source)
  if sourcePlayer ~= nil then
    TchatGetMessageChannel(channel, function (messages)
      TriggerClientEvent('gksphone:darkchannel', sourcePlayer, channel, messages)
    end)
  end
end)

RegisterServerEvent('gksphone:darkaddMessage')
AddEventHandler('gksphone:darkaddMessage', function(channel, message)
  local sourcePlayer = tonumber(source)
  if sourcePlayer ~= nil then
    TchatAddMessage(channel, message)
  end
end)


