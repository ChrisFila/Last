RegisterNetEvent("Sunrise:pay")
AddEventHandler("Sunrise:pay", function(price,playerTatoos)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
    local xMoney = xPlayer.getAccount('cash').money
    
    if xMoney >= price then
        xPlayer.removeAccountMoney('cash', price)
        TriggerClientEvent("Sunrise:buyCallback", _src, true)
        performDbUpdate(playerTatoos,_src)

    else
        TriggerClientEvent("Sunrise:buyCallback", _src, false)
    end
end)

function getAllLicense(source)
    for k,v in pairs(GetPlayerIdentifiers(source))do
    end
end

function getPlayerLicense(source)
    getAllLicense(source)
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
        end
    end
end


RegisterNetEvent("Sunrise:payClean")
AddEventHandler("Sunrise:payClean", function(price)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xMoney = xPlayer.getAccount('cash').money
    if xMoney >= price then
        xPlayer.removeAccountMoney('cash', price)
        performDbClear(_src)

        TriggerClientEvent("Sunrise:clean", _src, 1)

    else
        TriggerClientEvent("Sunrise:clean", _src, 0)
    end
end)

RegisterNetEvent("Sunrise:requestPlayerTatoos")
AddEventHandler("Sunrise:requestPlayerTatoos", function()
    local _src = source
    local license = getPlayerLicense(_src)
    local result = nil
    MySQL.Async.fetchAll("SELECT * FROM `playerstattoos` WHERE identifier = @identifier", {['@identifier'] = license}, function(rslt)
        if rslt[1] ~= nil then
            result = rslt[1].tattoos
        else
            result = nil
        end
    end)
    Citizen.Wait(150)
    TriggerClientEvent("Sunrise:tatoesCallback", _src, result)

end)

function performDbUpdate(playerTatoos,_src)
    local license = getPlayerLicense(_src)
    local tattoos = json.encode(playerTatoos)
    MySQL.Async.fetchAll("SELECT * FROM `playerstattoos` WHERE identifier = @identifier", {['@identifier'] = license}, function(rslt)
        if rslt[1] ~= nil then
            MySQL.Async.execute("UPDATE `playerstattoos` SET tattoos = @tat WHERE identifier = @identifier",
            {['@identifier'] = license,['@tat'] = tattoos},
            function(insertId)
            end
        )
        else
            MySQL.Async.insert("INSERT INTO `playerstattoos` (`identifier`, `tattoos`) VALUES (@license, @tat)",
                {['@license'] = license,['@tat'] = tattoos},
                function(insertId)
                end
            )
        end
    end)
end

function performDbClear(_src)
    local license = getPlayerLicense(_src)
    MySQL.Async.fetchAll("SELECT * FROM `playerstattoos` WHERE identifier = @identifier", {['@identifier'] = license}, function(rslt)
        if rslt[1] ~= nil then
            MySQL.Async.execute("DELETE FROM `playerstattoos` WHERE identifier = @identifier",
            {['@identifier'] = license},
            function(insertId)
                
            end
        )
        end
    end)
end