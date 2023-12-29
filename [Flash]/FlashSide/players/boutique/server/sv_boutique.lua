ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

---@class sBoutique
sBoutique = sBoutique or {};

---@class sBoutique.Cache
sBoutique.Cache = sBoutique.Cache or {}

---@class sBoutique.Cache.Case
sBoutique.Cache.Case = sBoutique.Cache.Case or {}

function sBoutique:HasValue(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            return true
        end
    end
    return false
end

local characters = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }

Server = {};

function Server:GetIdentifiers(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers[_]
        end
        return identifiers
    else
        error("source is nil")
    end
end

function Server:CreateRandomPlateText()
    local plate = ""
    math.randomseed(GetGameTimer())
    for i = 1, 3 do
        plate = plate .. characters[math.random(1, #characters)]
    end
    plate = plate .. ""
    for i = 1, 3 do
        plate = plate .. math.random(1, 9)
    end
    return plate
end

Citizen.CreateThread(function()
    while true do
        Wait(600000)
        --Wait(10000)
        local allPlayers = GetPlayers()

        for i=1, #allPlayers, 1 do
            local license = nil
            for _,v in pairs(GetPlayerIdentifiers(allPlayers[i])) do
                if string.find(v, "license:") then
                    license = v
                    break
                end
            end
            TriggerClientEvent('esx:showAdvancedNotification', allPlayers[i], 'FlashSide', '~r~Boutique', 'N\'hésitez pas a faire un tour sur notre magnifique boutique ( F1 ).', 'CHAR_FlashSide', 7)
        end
    end
end)

function Server:OnProcessCheckout(source, price, transaction, onAccepted, onRefused)
    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
        MySQL.Async.fetchAll("SELECT SUM(points) FROM tebex_players_wallet WHERE identifiers = @identifiers", {
            ['@identifiers'] = after
        }, function(result)
            local current = tonumber(result[1]["SUM(points)"]);
            if (current ~= nil) then
                if (current >= price) then
                    LiteMySQL:Insert('tebex_players_wallet', {
                        identifiers = after,
                        transaction = transaction,
                        price = '0',
                        currency = 'Points',
                        points = -price,
                    });
                    onAccepted();
                else
                    onRefused();
                    xPlayer.showNotification('Vous ne procédez pas les points nécessaires pour votre achat visité notre boutique.')
                end
            else
                onRefused();
                print('[Info] retrieve points nil')
            end
        end);
    else
        onRefused();
        --print('[Error] Failed to retrieve fivem identifier')
    end
end

function Server:Giving(xPlayer, identifier, item)
    local content = json.decode(item.action);

    if (content.vehicles) then
        for key, value in pairs(content.vehicles) do
        end
    end

    if (content.items) then
        for key, value in pairs(content.items) do
            xPlayer.addInventoryItem(value.name, value.count)
        end
    end
 
    if (content.roue) then
        for key, value in pairs(content.roue) do

        end
    end

    if (content.items) then
        for key, value in pairs(content.items) do
            xPlayer.addInventoryItem(value.name, value.count)
        end
    end

    if (content.bank) then
        for key, value in pairs(content.bank) do
            xPlayer.addAccountMoney('bank', value.count)
        end
    end
end
function SunriseLogs(webhook, name, message, color)
	-- Modify here your discordWebHook username = name, content = message,embeds = embeds
    local date = os.date('*t')
  
  if date.day < 10 then date.day = '0' .. tostring(date.day) end
  if date.month < 10 then date.month = '0' .. tostring(date.month) end
  if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
  if date.min < 10 then date.min = '0' .. tostring(date.min) end
  if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end

  local time = '\nDate: **`' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. (date.hour) .. ':' .. date.min .. ':' .. date.sec .. '`**'

  local embeds = {
	  {
          ["title"]= message .. time,
		  ["type"]="rich",
		  ["color"] =color,
		  ["footer"]=  {
			  ["text"]= "Sunrise Logs",
		 },
	  }
  }
  
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest('https://discord.com/api/webhooks/952366592057024542/U4qaj4VJiP6iNoRY_0Rx5_mW-SXrzj_did63SOwxyb8zgHTZMslbae6UPZ2kNyzlAlkF', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('SunRise:process_checkout')
AddEventHandler('SunRise:process_checkout', function(itemId)
    local _src = source
    TriggerEvent("ratelimit", _src, "SunRise:process_checkout")
    local source = source;
    if (source) then
        local identifier = Server:GetIdentifiers(source);
        local xPlayer = ESX.GetPlayerFromId(source)
        if (xPlayer) then
            local count, content = LiteMySQL:Select('tebex_boutique'):Where('id', '=', itemId):Get();
            local item = content[1];
            if (item) then
                Server:OnProcessCheckout(source, item.price, string.format("Achat package %s", item.name), function()
                    Server:Giving(xPlayer, identifier, item);
                    SunriseLogs('https://discord.com/api/webhooks/952366592057024542/U4qaj4VJiP6iNoRY_0Rx5_mW-SXrzj_did63SOwxyb8zgHTZMslbae6UPZ2kNyzlAlkF', "Boutique - Achat","**"..GetPlayerName(source).."** vient d'acheter une ***"..item.name.."***\n**License** : "..xPlayer.identifier.. '\nPrix de l\'achat : '.. item.price .. ' SunCoins', 56108)
                end, function()
                    xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
                end)
            else
                print('[[Error] Failed to retrieve boutique item')
            end
        else
            print('[Error] Failed to retrieve ESX player')
        end
    else
        print('[Error] Failed to retrieve source')
    end
end)

local function random(x, y)
    local u = 0;
    u = u + 1
    if x ~= nil and y ~= nil then
        return math.floor(x + (math.random(math.randomseed(os.time() + u)) * 999999 % y))
    else
        return math.floor((math.random(math.randomseed(os.time() + u)) * 100))
    end
end

local function GenerateLootbox(source, box, list)
    local chance = random(1, 100)
    local gift = { category = 1, item = 1 }
    local minimalChance = 4

    local identifier = Server:GetIdentifiers(source);
    minimalChance = 3
    if (sBoutique.Cache.Case[source] == nil) then
        sBoutique.Cache.Case[source] = {};
        if (sBoutique.Cache.Case[source][box] == nil) then
            sBoutique.Cache.Case[source][box] = {};
        end
    end
    if chance <= minimalChance then
        local rand = random(1, #list[3])
        sBoutique.Cache.Case[source][box][3] = list[3][rand]
        gift.category = 3
        gift.item = list[3][rand]
    elseif (chance > minimalChance and chance <= 30) or (chance > 80 and chance <= 100) then
        local rand = random(1, #list[2])
        sBoutique.Cache.Case[source][box][2] = list[2][rand]
        gift.category = 2
        gift.item = list[2][rand]
    else
        local rand = random(1, #list[1])
        sBoutique.Cache.Case[source][box][1] = list[1][rand]
        gift.category = 1
        gift.item = list[1][rand]
    end
    local finalList = {}
    for _, category in pairs(list) do
        for _, item in pairs(category) do
            local result = { name = item, time = 150 }
            table.insert(finalList, result)
        end
    end
    table.insert(finalList, { name = gift.item, time = 5000 })
    return finalList, gift.item
end

local reward = {
    -- Caisse gold
    ["money_60000"] = { type = "money", message = "Félicitation, vous avez gagner 60000$." },
    ["money_250000"] = { type = "money", message = "Félicitation, vous avez gagner 250000$." },
    ["weapon_pistol"] = { type = "weapon", message = "Félicitation, vous avez gagner un Pistoler." },
    ["FlashSideCoins_1200"] = { type = "FlashSideCoins", message = "Félicitation, vous avez gagner 1200 FlashSideCoins." },
    ["tmaxdx"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Tmax." },

    -- Caisse Diamond
    ["money_60000"] = { type = "money", message = "Félicitation, vous avez gagner 60000$." },
    ["money_250000"] = { type = "money", message = "Félicitation, vous avez gagner 250000$." },
    ["FlashSideCoins_1200"] = { type = "FlashSideCoins", message = "Félicitation, vous avez gagner 1200 FlashSideCoins." },
    ["weapon_microsmg"] = { type = "weapon", message = "Félicitation, vous avez gagner un Pistoler." },
    ["tmaxdx"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Tmax." },
    ["x6m"] = { type = "vehicle", message = "Félicitation, vous avez gagner un BMW X6." },

    -- Caisse Ruby
    ["money_60000"] = { type = "money", message = "Félicitation, vous avez gagner 60000$." },
    ["money_250000"] = { type = "money", message = "Félicitation, vous avez gagner 250000$." },
    ["FlashSideCoins_1200"] = { type = "FlashSideCoins", message = "Félicitation, vous avez gagner 1200 FlashSideCoins." },
    ["weapon_microsmg"] = { type = "weapon", message = "Félicitation, vous avez gagner un Micro SMG." },
    ["weapon_compactrifle"] = { type = "weapon", message = "Félicitation, vous avez gagner une Mini AK." },
    ["tmaxdx"] = { type = "vehicle", message = "Félicitation, vous avez gagner un Tmax." },
    ["x6m"] = { type = "vehicle", message = "Félicitation, vous avez gagner un BMW X6." },
    ["aperta"] = { type = "vehicle", message = "Félicitation, vous avez gagner une Ferrari." },
}

local box = {
    [1] = {
        [4] = {
            "money_60000"
        },
        [3] = {
            "money_250000",
            "FlashSideCoins_1200",
        },
        [2] = {
            "weapon_pistol"
        },
        [1] = {
           "tmaxdx"
        },
    }
}

local box2 = {
    [1] = {
        [5] = {
            "money_60000",
            "money_250000"
        },
        [4] = {
            "FlashSideCoins_1200"
        },
        [3] = {
            "weapon_microsmg"
        },
        [2] = {
            "tmaxdx"
        },
        [1] = {
            "x6m"
        },
    }
}

local box3 = {
    [1] = {
        [3] = {
            "money_60000",
            "money_250000"
        },
        [2] = {
            "FlashSideCoins_1200",
            "weapon_microsmg"
        },
        [1] = {
            "weapon_compactrifle",
            "tmaxdx",
            "x6m",
            "aperta"
        },
    }
}
local labeltype = nil
RegisterServerEvent('SunRise:process_checkout_case')
AddEventHandler('SunRise:process_checkout_case', function(type)
    local _src = source
    TriggerEvent("ratelimit", _src, "SunRise:process_checkout_case")
    local source = source;
    if (source) then
        local identifier = Server:GetIdentifiers(source);
        local xPlayer = ESX.GetPlayerFromId(source)
        if type == "case_2" then
            labeltype = "Caisse gold"
        elseif type == "case_3" then
            labeltype = "Caisse diamond"
        elseif type == "case_4" then
            labeltype = "Caisse Ruby"
        end
        --SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient d'acheter une ***"..labeltype.."***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851712677353095189/qIgZGkHBp0LoJFgkvCPn3qvk7Sage_mvF8zTso6E6hLpA3_N-832_6rOCoHjxjjDxZjy")
        if (xPlayer) then
            if type == "case_2" then
                    Server:OnProcessCheckout(source, 1000, "Achat d'une caisse (FlashSide - Gold)", function()
    
                        local boxId = 1;
                        local lists, result = GenerateLootbox(source, boxId, box[boxId])
                        local giveReward = {
                            ["FlashSideCoins"] = function(_s, license, player)
                                local before, after = result:match("([^_]+)_([^_]+)")
                                local quantity = tonumber(after)
                                if (identifier['fivem']) then
                                    local _, fivemid = identifier['fivem']:match("([^:]+):([^:]+)")
                                    LiteMySQL:Insert('tebex_players_wallet', {
                                        identifiers = fivemid,
                                        transaction = "Gain dans la boîte FlashSideCoins",
                                        price = '0',
                                        currency = 'Points',
                                        points = quantity,
                                    });
                                end
                            end,
                            ["weapon"] = function(_s, license, player)
                                xPlayer.addWeapon(result, 150)
                            end,
                            ["vehicle"] = function(_s, license, player)
                                local plate = CreateRandomPlateText()
                                LiteMySQL:Insert('owned_vehicles', {
                                    owner = xPlayer.identifier,
                                    plate = plate,
                                    vehicle = json.encode({ model = result, plate = plate }),
                                    type = 'car',
                                    state = 1,
                                    boutique = 1
                                })
                            end,
                            ["none"] = function(_s, license, player)
    
                            end,
                            ["money"] = function(_s, license, player)
                                local before, after = result:match("([^_]+)_([^_]+)")
                                local quantity = tonumber(after)
                                player.addAccountMoney('bank', quantity)
                            end,
                        }
    
                        local r = reward[result];
                        if (r ~= nil) then
                            if (giveReward[r.type]) then
                                giveReward[r.type](source, identifier['license'], xPlayer);
                            end
                        end
                        if (identifier['fivem']) then
                            local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                            LiteMySQL:Insert('tebex_players_wallet', {
                                identifiers = after,
                                transaction = r.message,
                                price = '0',
                                currency = 'Box',
                                points = 0,
                            });
                        end
                        print(result)
                        --SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient de gagner : ***"..result.."***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851712677353095189/qIgZGkHBp0LoJFgkvCPn3qvk7Sage_mvF8zTso6E6hLpA3_N-832_6rOCoHjxjjDxZjy")
                        TriggerClientEvent('tebex:on-open-case', source, lists, result, r.message)
                        end, function()
                        xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
                    end)
            elseif type == "case_3" then
                Server:OnProcessCheckout(source, 800, "Achat d'une caisse (FlashSide - Diamond)", function()

                    local boxId = 1;
                    local lists, result = GenerateLootbox(source, boxId, box2[boxId])
                    local giveReward = {
                        ["FlashSideCoins"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            if (identifier['fivem']) then
                                local _, fivemid = identifier['fivem']:match("([^:]+):([^:]+)")
                                LiteMySQL:Insert('tebex_players_wallet', {
                                    identifiers = fivemid,
                                    transaction = "Gain dans la boîte FlashSideCoins",
                                    price = '0',
                                    currency = 'Points',
                                    points = quantity,
                                });
                            end
                        end,
                        ["vehicle"] = function(_s, license, player)
                            local plate = CreateRandomPlateText()
                            print(result)
                            LiteMySQL:Insert('owned_vehicles', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                vehicle = json.encode({ model = result, plate = plate }),
                                type = 'car',
                                state = 1,
                                boutique = 1
                            })
                        end,
                        ["weapon"] = function(_s, license, player)
                            xPlayer.addWeapon(result, 150)
                        end,
                        ["money"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            player.addAccountMoney('bank', quantity)
                        end,
                    }
                    local r = reward[result];
                    if (r ~= nil) then
                        if (giveReward[r.type]) then
                            giveReward[r.type](source, identifier['license'], xPlayer);
                        end
                    end
                    if (identifier['fivem']) then
                        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = after,
                            transaction = r.message,
                            price = '0',
                            currency = 'Box',
                            points = 0,
                        });
                    end
                    print(result)
                    --SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient de gagner : ***"..result.."***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851712677353095189/qIgZGkHBp0LoJFgkvCPn3qvk7Sage_mvF8zTso6E6hLpA3_N-832_6rOCoHjxjjDxZjy")
                    TriggerClientEvent('tebex:on-open-case', source, lists, result, r.message)
                    end, function()
                    xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
                end)
            elseif type == "case_4" then
                Server:OnProcessCheckout(source, 3000, "Achat d'une caisse (FlashSide - Race)", function()

                    local boxId = 1;
                    local lists, result = GenerateLootbox(source, boxId, box3[boxId])
                    local giveReward = {
                        ["FlashSideCoins"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            if (identifier['fivem']) then
                                local _, fivemid = identifier['fivem']:match("([^:]+):([^:]+)")
                                LiteMySQL:Insert('tebex_players_wallet', {
                                    identifiers = fivemid,
                                    transaction = "Gain dans la boîte FlashSideCoins",
                                    price = '0',
                                    currency = 'Points',
                                    points = quantity,
                                });
                            end
                        end,
                        ["weapon"] = function(_s, license, player)
                            xPlayer.addWeapon(result, 150)
                        end,
                        ["vehicle"] = function(_s, license, player)
                            local plate = CreateRandomPlateText()
                            print(result)
                            LiteMySQL:Insert('owned_vehicles', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                vehicle = json.encode({ model = result, plate = plate }),
                                type = 'car',
                                state = 1,
                                boutique = 1
                            })
                        end,
                        ["money"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            player.addAccountMoney('bank', quantity)
                        end,
                    }
                    local r = reward[result];
                    if (r ~= nil) then
                        if (giveReward[r.type]) then
                            giveReward[r.type](source, identifier['license'], xPlayer);
                        end
                    end
                    if (identifier['fivem']) then
                        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = after,
                            transaction = r.message,
                            price = '0',
                            currency = 'Box',
                            points = 0,
                        });
                    end
                    print(result)
                    --SendLogs(15105570,"Boutique - Achat","**"..GetPlayerName(source).."** vient de gagner : ***"..result.."***\n **License** : "..xPlayer.identifier,"https://canary.discord.com/api/webhooks/851712677353095189/qIgZGkHBp0LoJFgkvCPn3qvk7Sage_mvF8zTso6E6hLpA3_N-832_6rOCoHjxjjDxZjy")
                    TriggerClientEvent('tebex:on-open-case', source, lists, result, r.message)
                    end, function()
                    xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
                end)
            end
        else
            print('[Error] Failed to retrieve ESX player')
        end
    else
        print('[Error] Failed to retrieve source')
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-category', function(source, callback)
    local count, result = LiteMySQL:Select('tebex_boutique_category'):Where('is_enabled', '=', true):Get();
    if (result ~= nil) then
        callback(result)
    else
        print('[Error] retrieve category is nil')
        callback({ })
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-items', function(source, callback, category)
    local count, result = LiteMySQL:Select('tebex_boutique'):Wheres({
        { column = 'is_enabled', operator = '=', value = true },
        { column = 'category', operator = '=', value = category },
    })                             :Get();
    if (result ~= nil) then
        callback(result)
    else
        print('[Error] retrieve category is nil')
        callback({ })
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-history', function(source, callback)
    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
        local count, result = LiteMySQL:Select('tebex_players_wallet'):Where('identifiers', '=', after):Get();
        if (result ~= nil) then
            callback(result)
        else
            print('[Error] retrieve category is nil')
            callback({ })
        end
    end
end)

ESX.RegisterServerCallback('tebex:retrieve-points', function(source, callback)

    local identifier = Server:GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")

        MySQL.Async.fetchAll("SELECT SUM(points) FROM tebex_players_wallet WHERE identifiers = @identifiers", {
            ['@identifiers'] = after
        }, function(result)
            if (result[1]["SUM(points)"] ~= nil) then
                callback(result[1]["SUM(points)"])
            else
                print('[Info] retrieve points nil')
                callback(0)
            end
        end);
    else
        callback(0)
    end

end)

AddEventHandler('playerSpawned', function()
    local source = source;
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local fivem = Server:GetIdentifiers(source)['fivem'];
        if (fivem) then
            local license = Server:GetIdentifiers(source)['license'];
            if (license) then
                TriggerClientEvent("esx:showNotification",source,'~r~Vous pouvez faire des achats dans notre boutique pour nous soutenir. Votre compte FiveM attaché à votre jeux a été mis à jour.')
            end
        else
            TriggerClientEvent("esx:showNotification",source,'~r~Vous n\'avez pas d\'identifiant FiveM associé à votre compte, reliez votre profil à partir de votre jeux pour recevoir vos achats potentiel sur notre boutique.')
        end
    end 
end)

ESX.RegisterServerCallback('tebex:retrieve-id', function(source, callback)
    local source = source;
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local identifier = Server:GetIdentifiers(source);
        if (identifier['fivem']) then
            local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
            if after ~= nil then
                local license = identifier['license']
                if (license) then
                    callback(after)
                else
                    callback(0)
                end
            else
                callback(0)
            end
        else
            callback(0)
        end
    end 
end)

RegisterCommand("fivemid", function(source)
    local source = source;
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer) then
        local fivem = Server:GetIdentifiers(source)['fivem'];
        if (fivem) then
            local license = Server:GetIdentifiers(source)['license'];
            if (license) then
				xPlayer.showNotification("Votre ID est : ~r~"..source)
                xPlayer.showNotification('Votre FiveM ID est : ~r~'..fivem)
            else
				xPlayer.showNotification("~r~Erreur~s~ vous n'avez pas d'identifiant")
            end
        else
            xPlayer.showNotification('~r~Vous n\'avez pas d\'identifiant FiveM associé à votre compte, reliez votre profil à partir de votre jeux pour recevoir vos achats potentiel sur notre boutique.')
        end
    else
        print('[Error] ESX Get players form ID not found.')
    end 
end)

RegisterCommand("givecoins", function(source, args) 
    if source ~= 0 then return end
    local id = args[1]
    local coins = args[2]
    if id then
        local tPlayer = ESX.GetPlayerFromId(id)
        if tPlayer then
            local _, fivemid = Server:GetIdentifiers(id)['fivem']:match("([^:]+):([^:]+)")
            if (fivemid) then
                local license = Server:GetIdentifiers(id)['license'];
                if (license) then
                    tPlayer.showNotification('Chargement de la requête...')
                    if tonumber(coins) then
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = fivemid,
                            transaction = "Give point(s) : "..coins,
                            price = '0',
                            currency = 'Points',
                            points = coins,
                        }, function()
                            print("Coins envoyé à "..tPlayer.getName().." !")
                        end);    
                        tPlayer.showNotification('Coins reçu : ~r~'..coins)                  
                    end
                end
            end
        end
    end
end) 

local characters = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
function CreateRandomPlateText()
    local plate = ""
    math.randomseed(GetGameTimer())
    for i = 1, 4 do
        plate = plate .. characters[math.random(1, #characters)]
    end
    plate = plate .. ""
    for i = 1, 3 do
        plate = plate .. math.random(1, 9)
    end
    return plate
end

RegisterServerEvent('sunrise:buyentreprise')
AddEventHandler('sunrise:buyentreprise', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    Server:OnProcessCheckout(source, 5000, string.format("Achat package %s", 'Pack Entreprise de Farm'), function()
    
    end, function()
        xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
        return
    end)
    SunriseLogs('https://discord.com/api/webhooks/952366592057024542/U4qaj4VJiP6iNoRY_0Rx5_mW-SXrzj_did63SOwxyb8zgHTZMslbae6UPZ2kNyzlAlkF', "Boutique - Achat","**"..GetPlayerName(source).."** vient d'acheter une ***Entreprise de Farm***\n**License** : "..xPlayer.identifier.. '\nPrix de l\'achat : [5000] FlashSideCoins', 56108)
end)

RegisterServerEvent('sunrise:buygang')
AddEventHandler('sunrise:buygang', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    Server:OnProcessCheckout(source, 5000, string.format("Achat package %s", 'Pack Groupe Illégal'), function()
    
    end, function()
        xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
        return
    end)
    SunriseLogs('https://discord.com/api/webhooks/952366592057024542/U4qaj4VJiP6iNoRY_0Rx5_mW-SXrzj_did63SOwxyb8zgHTZMslbae6UPZ2kNyzlAlkF', "Boutique - Achat","**"..GetPlayerName(source).."** vient d'acheter une ***Pack Groupe Illégal***\n**License** : "..xPlayer.identifier.. '\nPrix de l\'achat : [5000] FlashSideCoins', 56108)
end)

RegisterServerEvent('boutique:buyWeapon')
AddEventHandler('boutique:buyWeapon', function(weapon, price, name)
    xPlayer = ESX.GetPlayerFromId(source)

    Server:OnProcessCheckout(source, price, string.format("Achat package %s", name), function()
    
    end, function()
        xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
        return
    end)
    xPlayer.addWeapon(weapon, 250)
end)

RegisterNetEvent("kalyps:ONAJOUTELENOUVEAU")
AddEventHandler("kalyps:ONAJOUTELENOUVEAU", function(LERESULTAT1FDP, LERESULTAT2FDP, LERESULTAT3FDP)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plate = CreateRandomPlateText()
    Server:OnProcessCheckout(source, LERESULTAT2FDP, string.format("Achat package %s", LERESULTAT3FDP), function()
        LiteMySQL:Insert('owned_vehicles', {
            owner = xPlayer.identifier,
            plate = plate,
            vehicle = json.encode({ model = LERESULTAT1FDP, plate = plate }),
            type = 'car',
            state = 1,
            boutique = 1
        })
    end, function()
        xPlayer.showNotification("~r~Vous ne posséder pas les points nécessaires")
        return
    end)
end)

RegisterServerEvent("tebex:on-process-checkout-fullcustom")
AddEventHandler("tebex:on-process-checkout-fullcustom", function()
    Server:OnProcessCheckout(source, 500, "Full Custom vehicule", function()
    end)
end)