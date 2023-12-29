--====================================================================================
-- #Author: Jonathan D @ Gannon
--====================================================================================



function TwitterGetTweets (accountId, cb)
  if accountId == nil then
    MySQL.Async.fetchAll([===[
      SELECT gksphone_twitter_tweets.*,
        gksphone_twitter_accounts.username as author,
        gksphone_twitter_accounts.avatar_url as authorIcon
      FROM gksphone_twitter_tweets
        LEFT JOIN gksphone_twitter_accounts
        ON gksphone_twitter_tweets.authorId = gksphone_twitter_accounts.id
      ORDER BY time DESC LIMIT 130
      ]===], {}, cb)
  else
    MySQL.Async.fetchAll([===[
      SELECT gksphone_twitter_tweets.*,
        gksphone_twitter_accounts.username as author,
        gksphone_twitter_accounts.avatar_url as authorIcon,
        gksphone_twitter_likes.id AS isLikes
      FROM gksphone_twitter_tweets
        LEFT JOIN gksphone_twitter_accounts
          ON gksphone_twitter_tweets.authorId = gksphone_twitter_accounts.id
        LEFT JOIN gksphone_twitter_likes 
          ON gksphone_twitter_tweets.id = gksphone_twitter_likes.tweetId AND gksphone_twitter_likes.authorId = @accountId
      ORDER BY time DESC LIMIT 130
    ]===], { ['@accountId'] = accountId }, cb)
  end
end

function TwitterGetFavotireTweets (accountId, cb)
  if accountId == nil then
    MySQL.Async.fetchAll([===[
      SELECT gksphone_twitter_tweets.*,
        gksphone_twitter_accounts.username as author,
        gksphone_twitter_accounts.avatar_url as authorIcon
      FROM gksphone_twitter_tweets
        LEFT JOIN gksphone_twitter_accounts
          ON gksphone_twitter_tweets.authorId = gksphone_twitter_accounts.id
      WHERE gksphone_twitter_tweets.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
      ORDER BY likes DESC, TIME DESC LIMIT 30
    ]===], {}, cb)
  else
    MySQL.Async.fetchAll([===[
      SELECT gksphone_twitter_tweets.*,
        gksphone_twitter_accounts.username as author,
        gksphone_twitter_accounts.avatar_url as authorIcon,
        gksphone_twitter_likes.id AS isLikes
      FROM gksphone_twitter_tweets
        LEFT JOIN gksphone_twitter_accounts
          ON gksphone_twitter_tweets.authorId = gksphone_twitter_accounts.id
        LEFT JOIN gksphone_twitter_likes 
          ON gksphone_twitter_tweets.id = gksphone_twitter_likes.tweetId AND gksphone_twitter_likes.authorId = @accountId
      WHERE gksphone_twitter_tweets.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
      ORDER BY likes DESC, TIME DESC LIMIT 30
    ]===], { ['@accountId'] = accountId }, cb)
  end
end

function TwitterUsersTweets (accountId, cb)
  if accountId == nil then
    MySQL.Async.fetchAll([===[
      SELECT gksphone_twitter_tweets.*,
        gksphone_twitter_accounts.username as author,
        gksphone_twitter_accounts.avatar_url as authorIcon
      FROM gksphone_twitter_tweets
        LEFT JOIN gksphone_twitter_accounts
        ON gksphone_twitter_tweets.authorId = gksphone_twitter_accounts.id
        WHERE gksphone_twitter_tweets.authorId = @accountId
      ORDER BY time DESC LIMIT 130
      ]===], {['@accountId'] = accountId}, cb)
  else
    MySQL.Async.fetchAll([===[
       SELECT gksphone_twitter_tweets.*,
        gksphone_twitter_accounts.username as author,
        gksphone_twitter_accounts.avatar_url as authorIcon,
		gksphone_twitter_likes.id AS isLikes
      FROM gksphone_twitter_tweets
        LEFT JOIN gksphone_twitter_accounts
          ON gksphone_twitter_accounts.id = @accountId
		LEFT JOIN gksphone_twitter_likes 
          ON gksphone_twitter_tweets.id = gksphone_twitter_likes.tweetId AND gksphone_twitter_likes.authorId = @accountId
      WHERE gksphone_twitter_tweets.authorId = @accountId ORDER BY TIME DESC LIMIT 30
    ]===], { ['@accountId'] = accountId }, cb)
  end
end

ESX.RegisterServerCallback('gksphone:getTwitterUsers', function(source, cb, username, password)
  local e = getUsers(username, password)
  MySQL.Async.fetchAll('SELECT gksphone_twitter_tweets.*, gksphone_twitter_accounts.username as author, gksphone_twitter_accounts.avatar_url as authorIcon, gksphone_twitter_likes.id AS isLikes FROM gksphone_twitter_tweets LEFT JOIN gksphone_twitter_accounts ON gksphone_twitter_accounts.id = @accountId LEFT JOIN gksphone_twitter_likes  ON gksphone_twitter_tweets.id = gksphone_twitter_likes.tweetId AND gksphone_twitter_likes.authorId = @accountId WHERE gksphone_twitter_tweets.authorId = @accountId ORDER BY TIME DESC LIMIT 30',{["@accountId"]=e.id},function(result)
    local usersTweets = {}
    for i=1, #result, 1 do
      table.insert(usersTweets, {id = result[i].id,	realUser=result[i].realUser, message=result[i].message, image=result[i].image, time=result[i].time, likes=result[i].likes, authorIcon=result[i].authorIcon, author=result[i].author  }) 
    end
    cb(usersTweets)
  end)
end)

function getUsers(username, password)
	local result = MySQL.Sync.fetchAll("SELECT * FROM gksphone_twitter_accounts WHERE gksphone_twitter_accounts.username = @username AND gksphone_twitter_accounts.password = @password", {['@username'] = username, ['@password'] = password})
  if result[1] ~= nil then
    local identity = result[1]
		return {
			id = identity['id']
		}
	else
		return nil
	end
end


RegisterServerEvent('gksphone:twitter_getUserTweets')
AddEventHandler('gksphone:twitter_getUserTweets', function(username, password)
  local sourcePlayer = tonumber(source)
  if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
    getUser(username, password, function (user)
      local accountId = user and user.id
      TwitterUsersTweets(accountId, function (tweets)
        TriggerClientEvent('gksphone:twitter_getUserTweets', sourcePlayer, tweets)
      end)
    end)
  else
    TwitterUsersTweets(nil, function (tweets)
      TriggerClientEvent('gksphone:twitter_getUserTweets', sourcePlayer, tweets)
    end)
  end
end)



function getUser(username, password, cb)
  MySQL.Async.fetchAll("SELECT id, username as author, avatar_url as authorIcon, profilavatar FROM gksphone_twitter_accounts WHERE gksphone_twitter_accounts.username = @username AND gksphone_twitter_accounts.password = @password", {
    ['@username'] = username,
    ['@password'] = password
  }, function (data)

    cb(data[1])
  end)
end

function TwitterPostTweet (username, password, message, image, sourcePlayer, realUser, cb)
  getUser(username, password, function (user)
    if user == nil then
      if sourcePlayer ~= nil then
        TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
      end
      return
    end
    MySQL.Async.insert("INSERT INTO gksphone_twitter_tweets (`authorId`, `message`, `image`, `realUser`) VALUES(@authorId, @message, @image, @realUser);", {
      ['@authorId'] = user.id,
      ['@message'] = message,
	  ['@image'] = image,
      ['@realUser'] = realUser
    }, 
	function (id)
      MySQL.Async.fetchAll('SELECT * from gksphone_twitter_tweets WHERE id = @id', {
        ['@id'] = id
      }, function (tweets)
        tweet = tweets[1]
        tweet['author'] = user.author
        tweet['authorIcon'] = user.authorIcon
        TriggerClientEvent('gksphone:twitter_newTweets', -1, tweet)
        TriggerEvent('gksphone:twitter_newTweets', tweet)
        TriggerClientEvent('DeleteTwitter', sourcePlayer, username, password)
      end)
    end)
  end)
end

function TwitterToogleLike (username, password, tweetId, sourcePlayer)
  getUser(username, password, function (user)
    if user == nil then
      if sourcePlayer ~= nil then
        TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
      end
      return
    end
    MySQL.Async.fetchAll('SELECT * FROM gksphone_twitter_tweets WHERE id = @id', {
      ['@id'] = tweetId
    }, function (tweets)
      if (tweets[1] == nil) then return end
      local tweet = tweets[1]
      MySQL.Async.fetchAll('SELECT * FROM gksphone_twitter_likes WHERE authorId = @authorId AND tweetId = @tweetId', {
        ['authorId'] = user.id,
        ['tweetId'] = tweetId
      }, function (row) 
        if (row[1] == nil) then
          MySQL.Async.insert('INSERT INTO gksphone_twitter_likes (`authorId`, `tweetId`) VALUES(@authorId, @tweetId)', {
            ['authorId'] = user.id,
            ['tweetId'] = tweetId
          }, function (newrow)
            MySQL.Async.execute('UPDATE `gksphone_twitter_tweets` SET `likes`= likes + 1 WHERE id = @id', {
              ['@id'] = tweet.id
            }, function ()
              TriggerClientEvent('gksphone:twitter_updateTweetLikes', -1, tweet.id, tweet.likes + 1)
              TriggerClientEvent('gksphone:twitter_setTweetLikes', sourcePlayer, tweet.id, true)
              TriggerEvent('gksphone:twitter_updateTweetLikes', tweet.id, tweet.likes + 1)
            end)    
          end)
        else
          MySQL.Async.execute('DELETE FROM gksphone_twitter_likes WHERE id = @id', {
            ['@id'] = row[1].id,
          }, function (newrow)
            MySQL.Async.execute('UPDATE `gksphone_twitter_tweets` SET `likes`= likes - 1 WHERE id = @id', {
              ['@id'] = tweet.id
            }, function ()
              TriggerClientEvent('gksphone:twitter_updateTweetLikes', -1, tweet.id, tweet.likes - 1)
              TriggerClientEvent('gksphone:twitter_setTweetLikes', sourcePlayer, tweet.id, false)
              TriggerEvent('gksphone:twitter_updateTweetLikes', tweet.id, tweet.likes - 1)
            end)
          end)
        end
      end)
    end)
  end)
end


function TwitteUsersDelete (username, password, tweetId, sourcePlayer)
  getUser(username, password, function (user)
    if user == nil then
      if sourcePlayer ~= nil then
        TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
      end
      return
    end
    MySQL.Async.execute('DELETE FROM gksphone_twitter_tweets WHERE id = @id', {
      ['@id'] = tweetId,
    }, function (result)
 
      TriggerClientEvent('DeleteTwitter', sourcePlayer, username, password)
	end)
  end)
end

function TwitterCreateAccount(source, username, password, avatarUrl, profilavatar, cb)
  local Player = ESX.GetPlayerFromId(source)
  MySQL.Async.insert('INSERT IGNORE INTO gksphone_twitter_accounts (`username`, `password`, `avatar_url`, `profilavatar`) VALUES(@username, @password, @avatarUrl, @profilavatar)', {
    ['username'] = username,
    ['password'] = password,
    ['avatarUrl'] = avatarUrl,
    ['profilavatar'] = profilavatar,
    ['@identifierrr'] = Player.identifier,
  }, cb)
end
-- ALTER TABLE `gksphone_twitter_accounts`	CHANGE COLUMN `username` `username` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci';

function TwitterShowError (sourcePlayer, title, message, image)
  TriggerClientEvent('gksphone:twitter_showError', sourcePlayer, message, image)
end
function TwitterShowSuccess (sourcePlayer, title, message, image)
  TriggerClientEvent('gksphone:twitter_showSuccess', sourcePlayer, title, message, image)
end

RegisterServerEvent('gksphone:twitter_login')
AddEventHandler('gksphone:twitter_login', function(username, password)
  local sourcePlayer = tonumber(source)
  getUser(username, password, function (user)
    if user == nil then
      TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
    else
      TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_SUCCESS')
      TriggerClientEvent('gksphone:twitter_setAccount', sourcePlayer, username, password, user.authorIcon, user.profilavatar)
    end
  end)
end)

RegisterServerEvent('gksphone:twitter_changePassword')
AddEventHandler('gksphone:twitter_changePassword', function(username, password, newPassword)
  local sourcePlayer = tonumber(source)
  getUser(username, password, function (user)
    if user == nil then
      TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_NEW_PASSWORD_ERROR')
    else
      MySQL.Async.execute("UPDATE `gksphone_twitter_accounts` SET `password`= @newPassword WHERE gksphone_twitter_accounts.username = @username AND gksphone_twitter_accounts.password = @password", {
        ['@username'] = username,
        ['@password'] = password,
        ['@newPassword'] = newPassword
      }, function (result)
        if (result == 1) then
          TriggerClientEvent('gksphone:twitter_setAccount', sourcePlayer, username, newPassword, user.authorIcon, user.profilavatar)
          TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_NEW_PASSWORD_SUCCESS')
        else
          TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_NEW_PASSWORD_ERROR')
        end
      end)
    end
  end)
end)


RegisterServerEvent('gksphone:twitter_createAccount')
AddEventHandler('gksphone:twitter_createAccount', function(username, password, avatarUrl, profilavatar)
  local sourcePlayer = tonumber(source)
  TwitterCreateAccount(sourcePlayer, username, password, avatarUrl, profilavatar, function (id)
    if (id ~= 0) then
      TriggerClientEvent('gksphone:twitter_setAccount', sourcePlayer, username, password, avatarUrl, profilavatar)
      TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_ACCOUNT_CREATE_SUCCESS')
    else
      TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_ACCOUNT_CREATE_ERROR')
    end
  end)
end)

RegisterServerEvent('gksphone:twitter_getTweets')
AddEventHandler('gksphone:twitter_getTweets', function(username, password)
  local sourcePlayer = tonumber(source)
  if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
    getUser(username, password, function (user)
      local accountId = user and user.id
      TwitterGetTweets(accountId, function (tweets)
        TriggerClientEvent('gksphone:twitter_getTweets', sourcePlayer, tweets)
      end)
    end)
  else
    TwitterGetTweets(nil, function (tweets)
      TriggerClientEvent('gksphone:twitter_getTweets', sourcePlayer, tweets)
    end)
  end
end)

RegisterServerEvent('gksphone:twitter_getFavoriteTweets')
AddEventHandler('gksphone:twitter_getFavoriteTweets', function(username, password)
  local sourcePlayer = tonumber(source)
  if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
    getUser(username, password, function (user)
      local accountId = user and user.id
      TwitterGetFavotireTweets(accountId, function (tweets)
        TriggerClientEvent('gksphone:twitter_getFavoriteTweets', sourcePlayer, tweets)
      end)
    end)
  else
    TwitterGetFavotireTweets(nil, function (tweets)
      TriggerClientEvent('gksphone:twitter_getFavoriteTweets', sourcePlayer, tweets)
    end)
  end
end)



RegisterServerEvent('gksphone:twitter_postTweets')
AddEventHandler('gksphone:twitter_postTweets', function(username, password, message, image)
  local _source = source
  local sourcePlayer = tonumber(_source)
  local srcIdentifier = ESX.GetPlayerFromId(_source).identifier
  if sourcePlayer ~= nil then
    TwitterPostTweet(username, password, message, image, sourcePlayer, srcIdentifier)
  end
end)

RegisterServerEvent('gksphone:twitter_toogleLikeTweet')
AddEventHandler('gksphone:twitter_toogleLikeTweet', function(username, password, tweetId)
  local sourcePlayer = tonumber(source)
  TwitterToogleLike(username, password, tweetId, sourcePlayer)
end)

RegisterServerEvent('gksphone:twitter_usersDeleteTweet')
AddEventHandler('gksphone:twitter_usersDeleteTweet', function(username, password, tweetId)
  local sourcePlayer = tonumber(source)
  TwitteUsersDelete(username, password, tweetId, sourcePlayer)
end)

RegisterServerEvent('gksphone:twitter_setAvatarUrl')
AddEventHandler('gksphone:twitter_setAvatarUrl', function(username, password, avatarUrl)
  local sourcePlayer = tonumber(source)
  MySQL.Async.execute("UPDATE `gksphone_twitter_accounts` SET `avatar_url`= @avatarUrl WHERE gksphone_twitter_accounts.username = @username AND gksphone_twitter_accounts.password = @password", {
    ['@username'] = username,
    ['@password'] = password,
    ['@avatarUrl'] = avatarUrl
  }, function (result)
    if (result == 1) then
      TriggerClientEvent('gksphone:twitter_setAccount', sourcePlayer, username, password, avatarUrl)
      TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_AVATAR_SUCCESS')
    else
      TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
    end
  end)
end)

RegisterServerEvent('gksphone:twitter_setProfilUrl')
AddEventHandler('gksphone:twitter_setProfilUrl', function(username, password, avatarUrl, profilavatar)
  local sourcePlayer = tonumber(source)

  MySQL.Async.execute("UPDATE `gksphone_twitter_accounts` SET `profilavatar`= @profilavatar WHERE gksphone_twitter_accounts.username = @username AND gksphone_twitter_accounts.password = @password AND gksphone_twitter_accounts.avatar_url = @avatarUrl", {
    ['@username'] = username,
    ['@password'] = password,
    ['@avatarUrl'] = avatarUrl,
    ['@profilavatar'] = profilavatar
  }, function (result)
    if (result == 1) then
      TriggerClientEvent('gksphone:twitter_setAccount', sourcePlayer, username, password, avatarUrl, profilavatar)
      TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_AVATAR_SUCCESS')
    else
      TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
    end
  end)
end)

ESX.RegisterServerCallback('gksphone:getuserveri', function(source, cb, authorId)
  MySQL.Async.fetchAll('SELECT gksphone_twitter_tweets.*, gksphone_twitter_accounts.username as author, gksphone_twitter_accounts.avatar_url as authorIcon, gksphone_twitter_accounts.profilavatar as bannerIcon FROM gksphone_twitter_tweets LEFT JOIN gksphone_twitter_accounts ON gksphone_twitter_tweets.authorId = gksphone_twitter_accounts.id WHERE gksphone_twitter_tweets.authorId = @authorId ORDER BY time DESC LIMIT 130',{['@authorId'] = authorId.id},function(twitteruser)
    if (json.encode(twitteruser) == '[]') then
      MySQL.Async.fetchAll('SELECT gksphone_twitter_accounts.username as author, gksphone_twitter_accounts.avatar_url as authorIcon, gksphone_twitter_accounts.profilavatar as bannerIcon FROM gksphone_twitter_accounts WHERE gksphone_twitter_accounts.id = @id',{['@id'] = authorId.id},function(bunedir)
        cb(bunedir)
      end)
    else
      cb(twitteruser)
    end
  end)
end)

ESX.RegisterServerCallback('gksphone:getsearchusers', function(source, cb, username)
  MySQL.Async.fetchAll('SELECT * FROM gksphone_twitter_accounts WHERE gksphone_twitter_accounts.username = @username',{['@username'] = username},function(result)
    local SearchUserTwitter = {}
    for i=1, #result, 1 do
      table.insert(SearchUserTwitter, {id = result[i].id,	username=result[i].username, avatar_url=result[i].avatar_url }) 
    end
    cb(SearchUserTwitter)
  end)
end)


--[[
  Discord WebHook
  set discord_webhook 'https//....' in config.cfg
--]]
AddEventHandler('gksphone:twitter_newTweets', function (tweet)

  local discord_webhook = Config.TwitterWeb
  if discord_webhook == '' then
    return
  end
  local headers = {
    ['Content-Type'] = 'application/json'
  }
  local data = {
    ["username"] = tweet.author,
	["avatar_url"] = tweet.authorIcon,
    ["embeds"] = {{
      ["color"] = 1942002
    }}
  }
  local isHttp = string.sub(tweet.message, 0, 7) == 'http://' or string.sub(tweet.message, 0, 8) == 'https://'
  local ext = string.sub(tweet.message, -4)
  local isImg = ext == '.png' or ext == '.jpg' or ext == '.gif' or string.sub(tweet.message, -5) == '.jpeg'

    data['embeds'][1]['title'] = tweet.author .. " The user posted a new post!"
    data['embeds'][1]['image'] = { ['url'] = tweet.image }
	data['embeds'][1]['description'] = tweet.message

  PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end)
