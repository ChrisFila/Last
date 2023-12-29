function YellowGetPagess (accountId, cb)
  if accountId == nil then
    MySQL.Async.fetchAll([===[
      SELECT *
      FROM gksphone_yellow
      ORDER BY time DESC LIMIT 130
      ]===], {}, cb)
  end
end



ESX.RegisterServerCallback('gksphone:GetYellowUsers', function(source, cb, number)
  MySQL.Async.fetchAll('SELECT * FROM gksphone_yellow WHERE phone_number = @phone_number ORDER BY time DESC LIMIT 130',{["@phone_number"]=number},function(result)
    local usersyellow = {}
    for i=1, #result, 1 do
      table.insert(usersyellow, {id = result[i].id,	firstname=result[i].firstname, lastname=result[i].lastname, message=result[i].message, image=result[i].image, time=result[i].time }) 
    end
    cb(usersyellow)
  end)
end)




function YellowUsersDelete (yellowId, phone_number, sourcePlayer)
    MySQL.Async.execute('DELETE FROM gksphone_yellow WHERE id = @id AND phone_number = @phone_number', {
      ['@id'] = yellowId,
	  ['@phone_number'] = phone_number
    }, function (result)
      TriggerClientEvent('DeleteYellow', sourcePlayer, phone_number)
	end)
end

RegisterServerEvent('gksphone:yellow_usersDeleteTweet')
AddEventHandler('gksphone:yellow_usersDeleteTweet', function(yellowId, phone_number)
  local sourcePlayer = tonumber(source)
  YellowUsersDelete(yellowId, phone_number, sourcePlayer)
end)


function YellowShowError (sourcePlayer, title, message, image)
  TriggerClientEvent('gksphone:yellow_showError', sourcePlayer, message, image)
end
function YellowShowSuccess (sourcePlayer, title, message, image)
  TriggerClientEvent('gksphone:yellow_showSuccess', sourcePlayer, title, message, image)
end

RegisterServerEvent('gksphone:yellow_getPagess')
AddEventHandler('gksphone:yellow_getPagess', function(phone_number, firstname)
  local sourcePlayer = tonumber(source)
    YellowGetPagess(nil, function (pagess)
      TriggerClientEvent('gksphone:yellow_getPagess', sourcePlayer, pagess)
    end)
end)



RegisterServerEvent('gksphone:yellow_postPagess')
AddEventHandler('gksphone:yellow_postPagess', function(firstname, phone_number, lastname, message, image)
  local sourcePlayer = tonumber(source)
  MySQL.Async.insert("INSERT INTO gksphone_yellow (`phone_number`, `firstname`, `lastname`, `message`, `image`) VALUES(@phone_number, @firstname, @lastname, @message, @image);", {
    ['@phone_number'] = phone_number,
    ['@firstname'] = firstname,
    ['@lastname'] = lastname,
    ['@message'] = message,
    ['@image'] = image
    }, function (id)
      MySQL.Async.fetchAll('SELECT * from gksphone_yellow WHERE id = @id', {
        ['@id'] = id
      }, function (pagess)
        pages = pagess[1]
        TriggerClientEvent('gksphone:yellow_newPagess', -1, pages)
        TriggerEvent('gksphone:yellow_newPagess', pages)
        TriggerClientEvent('DeleteYellow', sourcePlayer, phone_number)
      end)
    end)

end)

--[[
  Discord WebHook
  set discord_webhook 'https//....' in config.cfg
--]]
AddEventHandler('gksphone:yellow_newPagess', function (pages)

  local discord_webhook = Config.YellowWeb
  if discord_webhook == '' then
    return
  end
  local headers = {
    ['Content-Type'] = 'application/json'
  }
  local data = {
    ["username"] = pages.firstname,
    ["embeds"] = {{
      ["color"] = 1942002
    }}
  }
  local isHttp = string.sub(pages.message, 0, 7) == 'http://' or string.sub(pages.message, 0, 8) == 'https://'
  local ext = string.sub(pages.message, -4)
  local isImg = ext == '.png' or ext == '.jpg' or ext == '.gif' or string.sub(pages.message, -5) == '.jpeg'

    data['embeds'][1]['title'] = pages.firstname .. pages.lastname .." The user posted a new post!"
    data['embeds'][1]['image'] = { ['url'] = pages.image }
	data['embeds'][1]['description'] = pages.message

  PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end)
