RegisterNetEvent("gksphone:twitter_getTweets")
AddEventHandler("gksphone:twitter_getTweets", function(tweets)
  SendNUIMessage({event = 'twitter_tweets', tweets = tweets})
end)

RegisterNetEvent("gksphone:twitter_getFavoriteTweets")
AddEventHandler("gksphone:twitter_getFavoriteTweets", function(tweets)
  SendNUIMessage({event = 'twitter_favoritetweets', tweets = tweets})
end)

RegisterNetEvent("gksphone:twitter_getUserTweets")
AddEventHandler("gksphone:twitter_getUserTweets", function(tweets)
  SendNUIMessage({event = 'twitter_UserTweets', tweets = tweets})
end)

RegisterNetEvent("gksphone:twitter_newTweets")
AddEventHandler("gksphone:twitter_newTweets", function(tweet)
  ESX.TriggerServerCallback('gksphone:phone-check', function(durum)
    if durum ~= nil then
      SendNUIMessage({event = 'twitter_newTweet', tweet = tweet})
    end
  end)
end)

RegisterNetEvent("gksphone:twitter_updateTweetLikes")
AddEventHandler("gksphone:twitter_updateTweetLikes", function(tweetId, likes)
  SendNUIMessage({event = 'twitter_updateTweetLikes', tweetId = tweetId, likes = likes})
end)

RegisterNetEvent("gksphone:twitter_setAccount")
AddEventHandler("gksphone:twitter_setAccount", function(username, password, avatarUrl, profilavatar)
  SendNUIMessage({event = 'twitter_setAccount', username = username, password = password, avatarUrl = avatarUrl, profilavatar = profilavatar})
end)

RegisterNetEvent("gksphone:twitter_createAccount")
AddEventHandler("gksphone:twitter_createAccount", function(account)
  SendNUIMessage({event = 'twitter_createAccount', account = account})
end)

RegisterNetEvent("gksphone:twitter_showError")
AddEventHandler("gksphone:twitter_showError", function(title, message, image)
  SendNUIMessage({event = 'twitter_showError', message = message, image = image, title = title})
end)

RegisterNetEvent("gksphone:twitter_showSuccess")
AddEventHandler("gksphone:twitter_showSuccess", function(title, message, image)
  SendNUIMessage({event = 'twitter_showSuccess', message = message, image = image, title = title})
end)

RegisterNetEvent("gksphone:twitter_setTweetLikes")
AddEventHandler("gksphone:twitter_setTweetLikes", function(tweetId, isLikes)
  SendNUIMessage({event = 'twitter_setTweetLikes', tweetId = tweetId, isLikes = isLikes})
end)





RegisterNUICallback('twitter_userssDeleteTweet', function(data, cb) 
  TriggerServerEvent('gksphone:twitter_usersDeleteTweet', data.username or '', data.password or '', data.tweetId)
end)

RegisterNUICallback('twitter_login', function(data, cb)
  TriggerServerEvent('gksphone:twitter_login', data.username, data.password)
end)
RegisterNUICallback('twitter_changePassword', function(data, cb)
  TriggerServerEvent('gksphone:twitter_changePassword', data.username, data.password, data.newPassword)
end)


RegisterNUICallback('twitter_createAccount', function(data, cb)
  TriggerServerEvent('gksphone:twitter_createAccount', data.username, data.password, data.avatarUrl, data.profilavatar)
end)

RegisterNUICallback('twitter_getTweets', function(data, cb)
  TriggerServerEvent('gksphone:twitter_getTweets', data.username, data.password)
end)

RegisterNUICallback('twitter_getFavoriteTweets', function(data, cb)
  TriggerServerEvent('gksphone:twitter_getFavoriteTweets', data.username, data.password)
end)



RegisterNUICallback('twitter_postTweet', function(data, cb)
  TriggerServerEvent('gksphone:twitter_postTweets', data.username or '', data.password or '', data.message or '', data.image or '')
end)

RegisterNUICallback('twitter_toggleLikeTweet', function(data, cb)
  TriggerServerEvent('gksphone:twitter_toogleLikeTweet', data.username or '', data.password or '', data.tweetId)
end)

RegisterNUICallback('twitter_setAvatarUrl', function(data, cb)
  TriggerServerEvent('gksphone:twitter_setAvatarUrl', data.username or '', data.password or '', data.avatarUrl)
end)

RegisterNUICallback('twitter_setProfilURL', function(data, cb)

  TriggerServerEvent('gksphone:twitter_setProfilUrl', data.username or '', data.password or '', data.avatarUrl or '', data.profilavatar)
end)

RegisterNUICallback('twitter_getUserTweets', function(data, cb)
  ESX.TriggerServerCallback('gksphone:getTwitterUsers', function(usersTweets)
    UpdateTwiiter(usersTweets)
  end, data.username, data.password)
end)

function UpdateTwiiter(usersTweets)
  SendNUIMessage({event = 'twitter_UserTweets', usersTweets = usersTweets})
end

RegisterNetEvent('DeleteTwitter')
AddEventHandler('DeleteTwitter', function(username, password)
    ESX.TriggerServerCallback('gksphone:getTwitterUsers', function(data)
      UpdateTwiiter(data)
    end, username, password)
end)




RegisterNUICallback('twitter_getSearchUsers', function(data, cb)
  ESX.TriggerServerCallback('gksphone:getsearchusers', function(SearchUserTwitter)

    SendNUIMessage({event = 'twitter_SearchTwitter', searchusertwitter = SearchUserTwitter})

  end, data.username)
end)


RegisterNUICallback('twitter_getusertwitterr', function(data, cb)
  ESX.TriggerServerCallback('gksphone:getuserveri', function(twitteruser)

    SendNUIMessage({event = 'twitter_twittsuser', twitteruser = twitteruser})

  end, data.id)
end)