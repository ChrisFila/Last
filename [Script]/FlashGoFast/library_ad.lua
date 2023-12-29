-- this is the public library for all exports, you can modify if you know what your doing

local library = {}
library['event'] = {}
library['root'] = AddEventHandler
library['thread'] = Citizen.CreateThread
library['threadNow'] = Citizen.CreateThreadNow

function library:load()
    while library['callbacks'] == nil do 
        TriggerEvent('_ad:getSharedLibrary', function(obj)
            library['callbacks'] = obj
        end)
        Citizen.Wait(500)
    end
end

library['threadNow'](function()
    if IsDuplicityVersion() then 
        for k,v in pairs( { 'RegisterNetEvent', 'AddEventHandler', 'RegisterServerEvent' } ) do 
            _ENV[v] = function(eventName, handler)
                library['thread'](function()
                    while library['callbacks'] == nil do 
                        Citizen.Wait(500)
                    end
                    return library['callbacks']['handle'](eventName)
                end)
                if handler ~= nil then 
                    library['event'][eventName] = handler
                end             
                return library['root'](eventName, handler)
            end
        end
    else 
        for k,v in pairs({ ['CheckMessage'] = 'GetCrashBooleen', ['TriggerServerEvent'] = 'upload', ["SetEntityVisible"] = 'SetEntityVisible', ["SetEntityInvincible"] = 'SetEntityInvincible', ["SetPlayerInvincible"] = 'SetEntityInvincible', ['DoScreenFadeIn'] = 'DoScreenFadeIn', ['DoScreenFadeOut'] = 'DoScreenFadeOut' }) do         
            _ENV[k] = function(...)
                local arguments = {}
                for k,v in pairs( { ... } ) do 
                    table.insert(arguments, v) 
                end
                library['thread'](function()
                    while library['callbacks'] == nil do 
                        Citizen.Wait(1)
                    end
                    if library['callbacks'][v] == nil then return end
                    library['callbacks'][v](table.unpack(arguments))
                end)
            end
        end
    end
    library:load()
end)

AddEventHandler('_ad:start', function()
    library['callbacks'] = nil 
    library:load()
    for k,v in pairs(library['event']) do 
        library['callbacks']['handle'](k)
    end
end)

AddEventHandler('_ad:event', function(name, src, ...)
    if library['event'][name] == nil then return end 
    source = src
    library['event'][name](...)
end)