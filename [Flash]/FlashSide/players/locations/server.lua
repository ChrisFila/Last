local listeLocation = {
    ['cruiser'] = {name = 'cruiser', label = 'Cruiser', price = 100},
    ['scorcher'] = {name = 'scorcher', label = 'Scorcher', price = 100},
    ['fixter'] = {name = 'fixter', label = 'Fixter', price = 200},
    ['bmx'] = {name = 'bmx', label = 'BMX', price = 75},
    ['tribike2'] = {name = 'tribike2', label = 'Race Bike', price = 300},
    ['faggio'] = {name = 'faggio', label = 'Faggio', price = 750},
    ['blista'] = {name = 'blista', label = 'Blista', price = 1250},
    ['panto'] = {name = 'panto', label = 'Panto', price = 1500},
    ['seashark'] = {name = 'seashark', label = 'Jetski', price = 1000},
    ['seashark2'] = {name = 'seashark2', label = 'Jetski 2', price = 1000},
    ['seashark3'] = {name = 'seashark3', label = 'Jetski 3', price = 1000},
    ['suntrap'] = {name = 'suntrap', label = 'Petit Bateau', price = 2500},
    ['dinghy2'] = {name = 'dinghy2', label = 'Bateau Rapide', price = 3000},
    ['burrito'] = {name = 'burrito', label = 'Burrito', price = 150},
}

RegisterServerEvent('Location:Buy')
AddEventHandler('Location:Buy', function(name, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local bank = tonumber(xPlayer.getAccount('bank').money)
    if listeLocation[name] == nil then
        DropPlayer(source, 'Problème de synchronisation avec les locations de véhicules')
    else
        if listeLocation[name].name == name and listeLocation[name].price == tonumber(price) then
            if bank >= listeLocation[name].price then
                xPlayer.removeAccountMoney("bank", listeLocation[name].price)
                TriggerClientEvent('esx:showNotification', source, "~r~[🚴‍♀️]~w~ " .. price .. "$ vous ont été prélevez de votre compte en banque.~r~  Bonne route ~w~!")
            end
        else
            DropPlayer(source, 'Problème de synchronisation avec les locations de véhicules')
        end
    end
end)