INFOPLAYER = {}
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
    Citizen.CreateThread(function()
        Wait(1000)
        local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
            ["@identifier"] = xPlayer.identifier 
        }, function(result)
            for k, v in pairs(result) do 
                if not INFOPLAYER[v.identifier] then 
                    INFOPLAYER[v.identifier] = {}
                    INFOPLAYER[v.identifier].identifier = v.identifier 
                    INFOPLAYER[v.identifier].firstname = v.firstname 
                    INFOPLAYER[v.identifier].lastname = v.lastname 
                    INFOPLAYER[v.identifier].sex = v.sex 
                    INFOPLAYER[v.identifier].height = v.height
                end
            end
        end)
    end)
end)

RegisterNetEvent('ronflex:bucket')
AddEventHandler('ronflex:bucket', function(active)
    local _source = source
    if active then 
        SetPlayerRoutingBucket(_source, _source)
    elseif not active then 
        SetPlayerRoutingBucket(_source, 0)
    else
        print('AntiCheat \nTentative de Cheat')
    end
end)

RegisterNetEvent("ronflex:identity")
AddEventHandler("ronflex:identity", function(ident)
    local xPlayer = ESX.GetPlayerFromId(source)
    local license = xPlayer.identifier 
    MySQL.Async.execute("UPDATE users set firstname = @firstname, lastname = @lastname, height = @height, sex = @sex, dateofbirth = @dateofbirth WHERE identifier = @identifier", {
        ["@identifier"] = license,
        ['@firstname'] = ident.firstname,
        ['@lastname'] = ident.lastname,
        ['@height'] = ident.taille,
        ['@sex'] = ident.sex,
        ['@dateofbirth'] = ident.age
    })
end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.AddGroupCommand('register', 'admin', function(source, args, user)
	if args[1] == nil then
		TriggerClientEvent('ronflex:creator', source)
	else
		TriggerClientEvent('ronflex:creator', args[1])
	end
end, {help = ''})