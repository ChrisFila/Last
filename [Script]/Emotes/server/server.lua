TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('animations:syncAccepted')
AddEventHandler('animations:syncAccepted', function(requester, id)
    local accepted = source
    TriggerClientEvent('animations:playSynced', accepted, requester, id, 'Accepter')
    TriggerClientEvent('animations:playSynced', requester, accepted, id, 'Requester')
end)

RegisterServerEvent('animations:requestSynced')
AddEventHandler('animations:requestSynced', function(target, id)
    print('animations:syncAccepted')
    local requester = source
    local xPlayer = ESX['GetPlayerFromId'](requester)
    MySQL['Async']['fetchScalar']("SELECT firstname FROM users WHERE identifier=@identifier", {['@identifier'] = xPlayer['identifier']}, function(firstname)
        TriggerClientEvent('animations:syncRequest', target, requester, id, firstname)
    end)
end)


ESX.RegisterServerCallback('animations:getAnimations', function(source, cb)
    local xPlayer = ESX['GetPlayerFromId'](source)
    animlist = {}
    MySQL['Async']['fetchAll']("SELECT * FROM fav_emote WHERE licence=@licence", {['@licence'] = xPlayer['identifier']}, function(animations)
        for k,v in pairs(animations) do
            print(v['name'])
            table.insert(animlist, {['id'] = v['id'], ['name'] = v['name'], ['dict'] = v['dict'], ['anim'] = v['anim'], ['param'] = v['param']})
        end
        cb(animlist)
    end)
end)
        
RegisterServerEvent('animation:saveemote')
AddEventHandler('animation:saveemote', function(dict, anim,name, param)
    local xPlayer = ESX['GetPlayerFromId'](source)
    MySQL['Async']['execute']("INSERT INTO fav_emote (licence, dict, anim, param, name) VALUES (@licence, @dict, @anim, @param, @name)", {['@licence'] = xPlayer['identifier'], ['@dict'] = dict, ['@anim'] = anim, ['@param'] = json.encode(param), ['@name'] = name})
end)


RegisterServerEvent('animations:removeAnimation')
AddEventHandler('animations:removeAnimation', function(id)
    local xPlayer = ESX['GetPlayerFromId'](source)
    MySQL['Async']['execute']("DELETE FROM fav_emote WHERE id=@id", {['@id'] = id})
    TriggerClientEvent('esx:showNotification', xPlayer.source,'Emote supprimée !')
end)

RegisterServerEvent('animations:renameAnimation')
AddEventHandler('animations:renameAnimation', function(id, name)
    local xPlayer = ESX['GetPlayerFromId'](source)
    MySQL['Async']['execute']("UPDATE fav_emote SET name=@name WHERE id=@id", {['@id'] = id, ['@name'] = name})
    TriggerClientEvent('esx:showNotification', xPlayer.source,'Emote renommée !')
end)

