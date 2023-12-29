NorthZones = {
    [1] = vector3(790.01647949219,4183.9404296875,41.563827514648),
    [2] = vector3(2641.68359375,4235.400390625,45.492984771729),
    [3] = vector3(1861.9290771484,3857.1918945313,36.271461486816),
    [4] = vector3(906.37213134766,3655.1616210938,32.560276031494),
    [5] = vector3(790.01647949219,4183.9404296875,41.563827514648),
}

SouthZones = {
    [1] = vector3(752.99786376953,-3192.0202636719,6.0731544494629),
    [2] = vector3(3.9195139408112,-200.81262207031,52.741859436035),
    [3] = vector3(-1375.5947265625,-336.29382324219,38.898422241211),
    [4] = vector3(-1349.3492431641,-945.53314208984,9.7058153152466),
    [5] = vector3(1099.3575439453,-345.83197021484,67.18342590332),
}

local ZoneInfoNorth = NorthZones[math.random(1,5)]
local ZoneInfoSud = SouthZones[math.random(1,5)]

RegisterNetEvent('illegalshop:GetPoints')
AddEventHandler('illegalshop:GetPoints', function()
    TriggerClientEvent('illegalshop:ReceivePoints', source, ZoneInfoNorth, ZoneInfoSud)
end)

RegisterNetEvent('IllegalShop:buyItem')
AddEventHandler('IllegalShop:buyItem', function(item, type)
    if BlackMarket.ListObjetsSecurity[item] == nil then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    if BlackMarket.ListObjetsSecurity[item].type == 'item' then
        if xPlayer.canCarryItem(item, 1) then
            if xPlayer.getAccount('cash').money >= BlackMarket.ListObjetsSecurity[item].price then
                xPlayer.removeAccountMoney('cash', BlackMarket.ListObjetsSecurity[item].price)
                xPlayer.addInventoryItem(item, 1)
                xPlayer.showNotification('Vous avez acheté '..BlackMarket.ListObjetsSecurity[item].label.. ' pour '.. BlackMarket.ListObjetsSecurity[item].price.. '$')
            else
                xPlayer.showNotification('Vous n\'avez pas l\'argent nécéssaire')
            end
        else
            xPlayer.showNotification('Vous avez trop d\'objets sur vous.')
        end
    elseif BlackMarket.ListObjetsSecurity[item].type == 'weapon' then 
        if xPlayer.getAccount('cash').money >= BlackMarket.ListObjetsSecurity[item].price then
            xPlayer.removeAccountMoney('cash', BlackMarket.ListObjetsSecurity[item].price)
            xPlayer.addWeapon(item, 250)
            xPlayer.showNotification('Vous avez acheté '..BlackMarket.ListObjetsSecurity[item].label.. ' pour '.. BlackMarket.ListObjetsSecurity[item].price.. '$')
        else
            xPlayer.showNotification('Vous n\'avez pas l\'argent nécéssaire')
        end
    end
end)

Citizen.CreateThread(function()
    Wait(2000)
    print('POSITION BLACKMARKET NORD : '..ZoneInfoNorth)
    print('POSITION BLACKMARKET SUD : '..ZoneInfoSud)
end)