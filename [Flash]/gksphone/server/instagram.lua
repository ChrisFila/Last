--====================================================================================
-- #XenKnighT : GÜRKAN SELİM ALBAYRAK
--====================================================================================


function instoGetinstas (accountId, cb)
  if accountId == nil then
    MySQL.Async.fetchAll([===[
      SELECT gksphone_insto_instas.*,
	    gksphone_insto_accounts.forename,
		gksphone_insto_accounts.surname,
        gksphone_insto_accounts.username as author,
        gksphone_insto_accounts.avatar_url as authorIcon
      FROM gksphone_insto_instas
        LEFT JOIN gksphone_insto_accounts
        ON gksphone_insto_instas.authorId = gksphone_insto_accounts.id
      ORDER BY time DESC LIMIT 130
      ]===], {}, cb)
  else
    MySQL.Async.fetchAll([===[
      SELECT gksphone_insto_instas.*,
	  	gksphone_insto_accounts.forename,
		gksphone_insto_accounts.surname,
        gksphone_insto_accounts.username as author,
        gksphone_insto_accounts.avatar_url as authorIcon,
        gksphone_insto_likes.id AS isLikes
      FROM gksphone_insto_instas
        LEFT JOIN gksphone_insto_accounts
          ON gksphone_insto_instas.authorId = gksphone_insto_accounts.id
        LEFT JOIN gksphone_insto_likes 
          ON gksphone_insto_instas.id = gksphone_insto_likes.inapId AND gksphone_insto_likes.authorId = @accountId
      ORDER BY time DESC LIMIT 130
    ]===], { ['@accountId'] = accountId }, cb)
  end
end

function instoGetFavotireinstas (accountId, cb)
  if accountId == nil then
    MySQL.Async.fetchAll([===[
      SELECT gksphone_insto_instas.*,
	    gksphone_insto_accounts.forename,
		gksphone_insto_accounts.surname,
        gksphone_insto_accounts.username as author,
        gksphone_insto_accounts.avatar_url as authorIcon
      FROM gksphone_insto_instas
        LEFT JOIN gksphone_insto_accounts
          ON gksphone_insto_instas.authorId = gksphone_insto_accounts.id
      WHERE gksphone_insto_instas.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
      ORDER BY likes DESC, TIME DESC LIMIT 30
    ]===], {}, cb)
  else
    MySQL.Async.fetchAll([===[
      SELECT gksphone_insto_instas.*,
	    gksphone_insto_accounts.forename,
		gksphone_insto_accounts.surname,
        gksphone_insto_accounts.username as author,
        gksphone_insto_accounts.avatar_url as authorIcon,
        gksphone_insto_likes.id AS isLikes
      FROM gksphone_insto_instas
        LEFT JOIN gksphone_insto_accounts
          ON gksphone_insto_instas.authorId = gksphone_insto_accounts.id
        LEFT JOIN gksphone_insto_likes 
          ON gksphone_insto_instas.id = gksphone_insto_likes.inapId AND gksphone_insto_likes.authorId = @accountId
      WHERE gksphone_insto_instas.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
      ORDER BY likes DESC, TIME DESC LIMIT 30
    ]===], { ['@accountId'] = accountId }, cb)
  end
end

function getaUserIns(username, password, cb)
  MySQL.Async.fetchAll("SELECT id, forename, surname, username as author, avatar_url as authorIcon FROM gksphone_insto_accounts WHERE gksphone_insto_accounts.username = @username AND gksphone_insto_accounts.password = @password", {
    ['@username'] = username,
    ['@password'] = password
  }, function (data)

      cb(data[1])
  end)
end

function instoPostinap (username, password, message, sourcePlayer, realUser, image, filters, cb)
  getaUserIns(username, password, function (user)
    if user == nil then
      if sourcePlayer ~= nil then
        instoShowError(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_LOGIN_ERROR')
      end
      return
    end
    MySQL.Async.insert("INSERT INTO gksphone_insto_instas (`authorId`, `message`, `realUser`, `image`, `filters`) VALUES(@authorId, @message, @realUser, @image, @filters);", {
      ['@authorId'] = user.id,
      ['@message'] = message,
      ['@realUser'] = realUser,
      ['@image'] = image,
      ['@filters'] = filters
    }, function (id)
      MySQL.Async.fetchAll('SELECT * from gksphone_insto_instas WHERE id = @id', {
        ['@id'] = id
      }, function (instas)
        inap = instas[1]
        inap['forename'] = user.forename
        inap['surname'] = user.surname
        inap['author'] = user.author
        inap['authorIcon'] = user.authorIcon
        TriggerClientEvent('gksphone:insto_newinstas', -1, inap)
        TriggerEvent('gksphone:insto_newinstas', inap)
      end)
    end)
  end)
end

function instoToogleLike (forename, surname, username, password, inapId, sourcePlayer)
  getaUserIns(username, password, function (user)
    if user == nil then
      if sourcePlayer ~= nil then
        instoShowError(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_LOGIN_ERROR')
      end
      return
    end
    MySQL.Async.fetchAll('SELECT * FROM gksphone_insto_instas WHERE id = @id', {
      ['@id'] = inapId
    }, function (instas)
      if (instas[1] == nil) then return end
      local inap = instas[1]
      MySQL.Async.fetchAll('SELECT * FROM gksphone_insto_likes WHERE authorId = @authorId AND inapId = @inapId', {
        ['authorId'] = user.id,
        ['inapId'] = inapId
      }, function (row) 
        if (row[1] == nil) then
          MySQL.Async.insert('INSERT INTO gksphone_insto_likes (`authorId`, `inapId`) VALUES(@authorId, @inapId)', {
            ['authorId'] = user.id,
            ['inapId'] = inapId
          }, function (newrow)
            MySQL.Async.execute('UPDATE `gksphone_insto_instas` SET `likes`= likes + 1 WHERE id = @id', {
              ['@id'] = inap.id
            }, function ()
              TriggerClientEvent('gksphone:insto_updateinapLikes', -1, inap.id, inap.likes + 1)
              TriggerClientEvent('gksphone:insto_setinapLikes', sourcePlayer, inap.id, true)
              TriggerEvent('gksphone:insto_updateinapLikes', inap.id, inap.likes + 1)
            end)    
          end)
        else
          MySQL.Async.execute('DELETE FROM gksphone_insto_likes WHERE id = @id', {
            ['@id'] = row[1].id,
          }, function (newrow)
            MySQL.Async.execute('UPDATE `gksphone_insto_instas` SET `likes`= likes - 1 WHERE id = @id', {
              ['@id'] = inap.id
            }, function ()
              TriggerClientEvent('gksphone:insto_updateinapLikes', -1, inap.id, inap.likes - 1)
              TriggerClientEvent('gksphone:insto_setinapLikes', sourcePlayer, inap.id, false)
              TriggerEvent('gksphone:insto_updateinapLikes', inap.id, inap.likes - 1)
            end)
          end)
        end
      end)
    end)
  end)
end

function instoCreateAccount(forename, surname, username, password, avatarUrl, cb)
  MySQL.Async.insert('INSERT IGNORE INTO gksphone_insto_accounts (`forename`, `surname`, `username`, `password`, `avatar_url`) VALUES(@forename, @surname, @username, @password, @avatarUrl)', {
    ['forename'] = forename,
	['surname'] = surname,
    ['username'] = username,
    ['password'] = password,
    ['avatarUrl'] = avatarUrl
  }, cb)
end
-- ALTER TABLE `gksphone_insto_accounts`	CHANGE COLUMN `username` `username` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci';

function instoShowError (sourcePlayer, title, message, image, filters)
  TriggerClientEvent('gksphone:insto_showError', sourcePlayer, message, image, filters)
end
function instoShowSuccess (sourcePlayer, title, message, image, filters)
  TriggerClientEvent('gksphone:insto_showSuccess', sourcePlayer, title, message, image, filters)
end

RegisterServerEvent('gksphone:insto_login')
AddEventHandler('gksphone:insto_login', function(username, password)
  local sourcePlayer = tonumber(source)
  getaUserIns(username, password, function (user)
    if user == nil then
      instoShowError(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_LOGIN_ERROR')
    else
      instoShowSuccess(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_LOGIN_SUCCESS')
      TriggerClientEvent('gksphone:insto_setAccount', sourcePlayer, user.forename, user.surname, username, password, user.authorIcon)
    end
  end)
end)

RegisterServerEvent('gksphone:insto_changePassword')
AddEventHandler('gksphone:insto_changePassword', function(forename, surname, username, password, newPassword)
  local sourcePlayer = tonumber(source)
  getaUserIns(username, password, function (user)
    if user == nil then
      instoShowError(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_NEW_PASSWORD_ERROR')
    else
      MySQL.Async.execute("UPDATE `gksphone_insto_accounts` SET `password`= @newPassword WHERE gksphone_insto_accounts.username = @username AND gksphone_insto_accounts.password = @password", {
        ['@username'] = username,
        ['@password'] = password,
        ['@newPassword'] = newPassword
      }, function (result)
        if (result == 1) then
          TriggerClientEvent('gksphone:insto_setAccount', sourcePlayer, forename, surname, username, newPassword, user.authorIcon)
          instoShowSuccess(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_NEW_PASSWORD_SUCCESS')
        else
          instoShowError(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_NEW_PASSWORD_ERROR')
        end
      end)
    end
  end)
end)


RegisterServerEvent('gksphone:insto_createAccount')
AddEventHandler('gksphone:insto_createAccount', function(forename, surname, username, password, avatarUrl)
  local sourcePlayer = tonumber(source)
  instoCreateAccount(forename, surname, username, password, avatarUrl, function (id)
    if (id ~= 0) then
      instoShowSuccess(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_ACCOUNT_CREATE_SUCCESS')
      TriggerClientEvent('gksphone:insto_setAccount', sourcePlayer, forename, surname, username, password, avatarUrl)
    else
      instoShowError(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_ACCOUNT_CREATE_ERROR')
    end
  end)
end)

RegisterServerEvent('gksphone:insto_getinstas')
AddEventHandler('gksphone:insto_getinstas', function(forename, surname, username, password)
  local sourcePlayer = tonumber(source)
  if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
    getaUserIns(username, password, function (user)
      local accountId = user and user.id
      instoGetinstas(accountId, function (instas)
        TriggerClientEvent('gksphone:insto_getinstas', sourcePlayer, instas)
      end)
    end)
  else
    instoGetinstas(nil, function (instas)
      TriggerClientEvent('gksphone:insto_getinstas', sourcePlayer, instas)
    end)
  end
end)

RegisterServerEvent('gksphone:insto_getFavoriteinstas')
AddEventHandler('gksphone:insto_getFavoriteinstas', function(forename, surname, username, password)
  local sourcePlayer = tonumber(source)
  if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
    getaUserIns(username, password, function (user)
      local accountId = user and user.id
      instoGetFavotireinstas(accountId, function (instas)
        TriggerClientEvent('gksphone:insto_getFavoriteinstas', sourcePlayer, instas)
      end)
    end)
  else
    instoGetFavotireinstas(nil, function (instas)
      TriggerClientEvent('gksphone:insto_getFavoriteinstas', sourcePlayer, instas)
    end)
  end
end)

RegisterServerEvent('gksphone:insto_postinstas')
AddEventHandler('gksphone:insto_postinstas', function(username, password, message, image, filters)
  local _source = source
  local sourcePlayer = tonumber(_source)
  local srcIdentifier = ESX.GetPlayerFromId(_source).identifier
  instoPostinap(username, password, message, sourcePlayer, srcIdentifier, image, filters)
end)

RegisterServerEvent('gksphone:insto_toogleLikeinap')
AddEventHandler('gksphone:insto_toogleLikeinap', function(forename, surname, username, password, inapId)
  local sourcePlayer = tonumber(source)
  instoToogleLike(forename, surname, username, password, inapId, sourcePlayer)
end)


RegisterServerEvent('gksphone:insto_setAvatarUrl')
AddEventHandler('gksphone:insto_setAvatarUrl', function(username, password, avatarUrl)
  local sourcePlayer = tonumber(source)
  MySQL.Async.execute("UPDATE `gksphone_insto_accounts` SET `avatar_url`= @avatarUrl WHERE gksphone_insto_accounts.username = @username AND gksphone_insto_accounts.password = @password", {
    ['@username'] = username,
    ['@password'] = password,
    ['@avatarUrl'] = avatarUrl
  }, function (result)
    if (result == 1) then
      TriggerClientEvent('gksphone:insto_setAccount', sourcePlayer, username, password, avatarUrl)
      instoShowSuccess(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_AVATAR_SUCCESS')
    else
      instoShowError(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_LOGIN_ERROR')
    end
  end)
end)


ESX.RegisterServerCallback("gksphone:getsStorys",function(a,b)
  MySQL.Async.fetchAll("SELECT gksphone_insto_story.*, gksphone_insto_accounts.forename, gksphone_insto_accounts.surname, gksphone_insto_accounts.username as author, gksphone_insto_accounts.avatar_url as authorIcon FROM gksphone_insto_story LEFT JOIN gksphone_insto_accounts ON gksphone_insto_story.authorId = gksphone_insto_accounts.id ORDER BY time DESC",{},function(e)
    local storie = {}
		for i=1, #e, 1 do
			table.insert(storie, {id = e[i].id, authorId=e[i].authorId, realUser = e[i].forename, avatar_url = e[i].authorIcon, isRead = e[i].isRead, stories=json.decode(e[i].stories)}) 
		end
		b(storie)  
  end)
end)

ESX.RegisterServerCallback("gksphone:getsBStorys",function(source, b)
  
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return; end
  MySQL.Async.fetchAll("SELECT gksphone_insto_story.*, gksphone_insto_accounts.forename, gksphone_insto_accounts.surname, gksphone_insto_accounts.username as author, gksphone_insto_accounts.avatar_url as authorIcon FROM gksphone_insto_story LEFT JOIN gksphone_insto_accounts ON gksphone_insto_story.authorId = gksphone_insto_accounts.id WHERE realUser = @realUser ORDER BY time DESC LIMIT 130",{['@realUser'] = xPlayer.identifier},function(e)
    local storieb = {}
		for i=1, #e, 1 do
			table.insert(storieb, {id = e[i].id, realUser = e[i].forename, avatar_url = e[i].authorIcon, isRead = e[i].isRead, stories=json.decode(e[i].stories)}) 
		end
		b(storieb)  
  end)
end)

RegisterServerEvent('gksphone:storysa')
AddEventHandler('gksphone:storysa', function(username, password, stories, time)
  local e=ESX.GetPlayerFromId(source)
  local sourcePlayer = tonumber(source)
  local srcIdentifier = ESX.GetPlayerFromId(source).identifier

  getaUserIns(username, password, function (user)
    if user == nil then
      if sourcePlayer ~= nil then
        instoShowError(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_LOGIN_ERROR')
      end
      return
    end
    local g={}

    MySQL.Async.fetchAll("SELECT * FROM gksphone_insto_story WHERE authorId = @authorId",{["@authorId"]=user.id},function(h)
     
      if h[1] ~= nil then
        
        g =  json.decode(h[1].stories)
        
        local deneme = {image = stories, isRead = false, time = time}

          table.insert(g, deneme) 

        TriggerClientEvent('gksphonee:getStorie', e.source, username)
        TriggerClientEvent('gksphonee:getBstory', e.source, username)

        MySQL.Async.fetchAll("UPDATE gksphone_insto_story SET stories = @stories WHERE authorId = @authorId",{["@authorId"]=user.id,["@stories"]=json.encode(g)})
      else

        local deneme = {image = stories, isRead = false, time = time}
        table.insert(g, deneme) 

        MySQL.Async.insert('INSERT INTO gksphone_insto_story (`authorId`, `realUser`, `stories`, `isRead`) VALUES(@authorId, @realUser, @stories, @isRead);', {
          ['@authorId'] = user.id,
          ['@realUser'] = srcIdentifier,
          ['@stories'] = json.encode(g),
          ['@isRead'] = 'false'
        }, function (result)
        
          TriggerClientEvent('gksphonee:getStorie', e.source, username)
          TriggerClientEvent('gksphonee:getBstory', e.source, username)

        end)

      end
    end)    
     
  end)

end)

ESX.RegisterServerCallback("gksphone:getInstoAacc",function(source, b)
  local srcIdentifier = ESX.GetPlayerFromId(source)
  local identifi = srcIdentifier.identifier

  if not identifi then return; end
  MySQL.Async.fetchAll("SELECT * FROM gksphone_insto_accounts",{},function(e)
    local storieb = {}
		for i=1, #e, 1 do
			table.insert(storieb, {id = e[i].id, forename = e[i].forename, surname = e[i].surname, username = e[i].username, password = e[i].password, avatar_url = e[i].avatar_url, takip=json.decode(e[i].takip)}) 
		end
		b(storieb)  
  end)
end)


RegisterServerEvent('gksphone:instofollow')
AddEventHandler('gksphone:instofollow', function(username, password, id)
  local src = source
  local srcIdentifier = ESX.GetPlayerFromId(src)
  local identifi = srcIdentifier.identifier

  getaUserIns(username, password, function (user)
    if user == nil then
      if sourcePlayer ~= nil then
        instoShowError(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_LOGIN_ERROR')
      end
      return
    end
    local g={}
    MySQL.Async.fetchAll("SELECT * FROM gksphone_insto_accounts WHERE username = @username",{["@username"]=username},function(h)
    
      if h[1] ~= nil then
        
        g =  json.decode(h[1].takip)

          table.insert(g, id)

          MySQL.Async.execute("UPDATE gksphone_insto_accounts SET takip = @takip WHERE username = @username",{["@username"]=username,["@takip"]=json.encode(g)})
       
          TriggerClientEvent('gksphonee:getInstoAcc', src)
      end
    end)    
     
  end)

end)


RegisterServerEvent('gksphone:instounfollow')
AddEventHandler('gksphone:instounfollow', function(username, password, id)
  local src = source
  local srcIdentifier = ESX.GetPlayerFromId(src)
  local identifi = srcIdentifier.identifier

  getaUserIns(username, password, function (user)
    if user == nil then
      if sourcePlayer ~= nil then
        instoShowError(sourcePlayer, 'Instagram', 'APP_INSTAGRAM_NOTIF_LOGIN_ERROR')
      end
      return
    end
    local g={}
    MySQL.Async.fetchAll("SELECT * FROM gksphone_insto_accounts WHERE username = @username",{["@username"]=username},function(h)
    
      if h[1] ~= nil then
        
        g =  json.decode(h[1].takip)
        test = {}

        for i=1, #g, 1 do
          if g[i] ~= id then
            table.insert(test, g[i])
          end
          
        end

        MySQL.Async.execute("UPDATE gksphone_insto_accounts SET takip = @takip WHERE username = @username",{["@username"]=username,["@takip"]=json.encode(test)})

        TriggerClientEvent('gksphonee:getInstoAcc', src)
     

      end
    end)    
     
  end)

end)

AddEventHandler('gksphone:insto_newinstas', function (inap)
  local discord_webhook = Config.InstagramWeb
  if discord_webhook == '' then
    return
  end
  local headers = {
    ['Content-Type'] = 'application/json'
  }
  local data = {
    ["username"] = inap.username,
	["avatar_url"] = inap.authorIcon,
    ["embeds"] = {{
      ["color"] = 1942002
    }}
  }
  local isHttp = string.sub(inap.message, 0, 7) == 'http://' or string.sub(inap.message, 0, 8) == 'https://'
  local ext = string.sub(inap.message, -4)
  local isImg = ext == '.png' or ext == '.jpg' or ext == '.gif' or string.sub(inap.message, -5) == '.jpeg'

    data['embeds'][1]['title'] = inap.forename .." The user posted a new post!"
    data['embeds'][1]['image'] = { ['url'] = inap.image }
	data['embeds'][1]['description'] = inap.message

  PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end)

--====================================================================================
-- #XenKnighT : GÜRKAN SELİM ALBAYRAK
--====================================================================================
