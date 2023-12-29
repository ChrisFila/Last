--================================================================================================
--==                                                XenKnighT                                  ==
--================================================================================================


if Config.ESXVersion == '1.2' then

  RegisterServerEvent('gksphone:transferPhoneNumber')
  AddEventHandler('gksphone:transferPhoneNumber', function(to, totaltt, tfee)
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
      local zPlayerIden = getIdentifierByPhoneNumber(to)
      local zPlayer = ESX.GetPlayerFromIdentifier(zPlayerIden)
      local TotalMoney = tonumber(tfee) + tonumber(totaltt)


      local balance = 0
      if zPlayer ~= nil then
          balance = xPlayer.getAccount('bank').money
          zbalance = zPlayer.getAccount('bank').money
          if xPlayer.identifier == zPlayerIden then
              -- advanced notification with bank icon

              TriggerClientEvent('gksphone:notifi', _source, {title = 'Bank', message = _U('bank_yourself'), img= '/html/static/img/icons/wallet.png' })

          else
              if balance <= 0 or balance < tonumber(TotalMoney) or tonumber(TotalMoney) <= 0 then
                  -- advanced notification with bank icon

                  TriggerClientEvent('gksphone:notifi', _source, {title = 'Bank', message = _U('bank_nomoney'), img= '/html/static/img/icons/wallet.png' })


              else
                  xPlayer.removeAccountMoney('bank', tonumber(TotalMoney))
                  zPlayer.addAccountMoney('bank', tonumber(tfee))
                  -- advanced notification with bank icon

                  local name = getFirstname(xPlayer.identifier)  .. " " .. getLastname(xPlayer.identifier)
                  local name2 = getFirstname(zPlayerIden)  .. " " .. getLastname(zPlayerIden)
          
                  TriggerClientEvent('gksphone:notifi', _source, {title = 'Bank', message = name2 .. _U('bank_transfer'), img= '/html/static/img/icons/wallet.png' })
                  TriggerClientEvent('gksphone:notifi', zPlayer.source, {title = 'Bank', message = _U('bank_playertransfer') ..name, img= '/html/static/img/icons/wallet.png' })
          
                  MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
                    ["@type"] = 1,
                    ["@identifier"] = xPlayer.identifier,
                    ["@price"] = TotalMoney,
                    ["@name"] = name2
                    }, function(results)
                  end)
          
                  MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
                    ["@type"] = 2,
                    ["@identifier"] = zPlayerIden,
                    ["@price"] = tfee,
                    ["@name"] = name
                    }, function(resultss)
                  end)

                  if  tonumber(TotalMoney) >= Config.BankLimit then
                    BankTrasnfer(name, xPlayer.identifier, tonumber(TotalMoney), name2, zPlayerIden)
                  end
                  BankGetBilling(_source, function (bankkkkk)
                    TriggerClientEvent('gksphone:bank_getBilling', _source, bankkkkk)
                  end)

          
              end
            
          end
      else


        if (zPlayerIden ~= nil) then
          balance = xPlayer.getAccount('bank').money

          if balance <= 0 or balance < tonumber(TotalMoney) or tonumber(TotalMoney) <= 0 then
        

            TriggerClientEvent('gksphone:notifi', _source, {title = 'Bank', message = _U('bank_nomoney'), img= '/html/static/img/icons/wallet.png' })


        else

        MySQL.Async.fetchAll("SELECT accounts FROM users WHERE identifier = @identifier", {
          ['@identifier'] = zPlayerIden,
      }, function(result)

          g=json.decode(result[1].accounts)

      
          g['bank']=g['bank']+(tonumber(tfee));

          xPlayer.removeAccountMoney('bank', tonumber(TotalMoney))

          MySQL.Async.execute('UPDATE users SET `accounts` = @bank WHERE `identifier` = @identifier', {
            ['@identifier'] = zPlayerIden,
            ['@bank'] = json.encode(g),
          })

        end)
          local name = getFirstname(xPlayer.identifier)  .. " " .. getLastname(xPlayer.identifier)
          local name2 = getFirstname(zPlayerIden)  .. " " .. getLastname(zPlayerIden)

          TriggerClientEvent('gksphone:notifi', _source, {title = 'Bank', message = name2 .. _U('bank_transfer'), img= '/html/static/img/icons/wallet.png' })

          MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
            ["@type"] = 1,
            ["@identifier"] = xPlayer.identifier,
            ["@price"] = TotalMoney,
            ["@name"] = name2
            }, function(results)
          end)

          MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
            ["@type"] = 2,
            ["@identifier"] = zPlayerIden,
            ["@price"] = tfee,
            ["@name"] = name
            }, function(resultss)
          end)

          if  tonumber(TotalMoney) >= Config.BankLimit then
            BankTrasnfer(name, xPlayer.identifier, tonumber(TotalMoney), name2, zPlayerIden)
          end
          BankGetBilling(_source, function (bankkkkk)
            TriggerClientEvent('gksphone:bank_getBilling', _source, bankkkkk)
          end)
        end
        else

          TriggerClientEvent('gksphone:notifi', _source, {title = 'Bank', message = _U('bank_systemnophone'), img= '/html/static/img/icons/wallet.png' })
      
        end
      end
  end)


  RegisterServerEvent('gksphone:aracisatt')
  AddEventHandler('gksphone:aracisatt', function(a, b, c)
  
  local src = source
  local satici = ESX.GetPlayerFromId(src)
  local bidentifier = satici.identifier
  local zPlayer = ESX.GetPlayerFromIdentifier(a)
  
  if zPlayer ~= nil then
    balance = satici.getAccount('bank').money
    zbalance = zPlayer.getAccount('bank').money
    if bidentifier == zPlayer.identifier then
      TriggerClientEvent('gksphone:notifi', src, {title = 'Car Sallers', message = _U('carseller_ownbuy'), img= '/html/static/img/icons/carsales.png' })
    else
      
      if balance < tonumber(c) then
  
        TriggerClientEvent('gksphone:notifi', src, {title = 'Car Sallers', message = _U('carseller_nobank'), img= '/html/static/img/icons/carsales.png' })
      else
  
  
  
          TriggerClientEvent('gksphone:cardel', -1, b)
          satici.removeAccountMoney('bank', tonumber(c))
          zPlayer.addAccountMoney('bank', tonumber(c))
  
          TriggerClientEvent('gksphone:notifi', src, {title = 'Car Sallers', message = _U('carseller_buyvehicle'), img= '/html/static/img/icons/carsales.png' })
          TriggerClientEvent('gksphone:notifi', zPlayer.source, {title = 'Car Sallers', message = _U('carseller_soldvehicle'), img= '/html/static/img/icons/carsales.png' })
      
          MySQL.Async.execute('UPDATE owned_vehicles SET `owner` = @owneryeni, `carseller` = @carseller WHERE `owner` = @owner AND `plate` = @plate', {
            ['@owner'] = a,
            ['@plate'] = b,
            ['@owneryeni'] = bidentifier,
            ['@carseller'] = 0,
          })
  
              MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
                ["@type"] = 1,
                ["@identifier"] = bidentifier,
                ["@price"] = tonumber(c),
                ["@name"] = b .._U('car_purchase')
              })
  
              MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
                ["@type"] = 2,
                ["@identifier"] = zPlayer.identifier,
                ["@price"] = tonumber(c),
                ["@name"] = b .._U('car_sale')
              })
  
          MySQL.Async.execute('DELETE FROM gksphone_vehicle_sales WHERE owner = @owner AND plate = @plate', {
            ['@owner'] = a,
            ['@plate'] = b,
          }, function ()
            MySQL.Async.fetchAll('SELECT * from gksphone_vehicle_sales ORDER BY TIME DESC LIMIT 30', {}, function (tweets)
  
              TriggerClientEvent('gksphone:vehiclearac', -1, tweets)
      
            end)
          end)
  
          local name = getFirstname(bidentifier)  .. " " .. getLastname(bidentifier)
  
          local name2 = getFirstname(a)  .. " " .. getLastname(a)
  
          TriggerEvent('gksphone:carsellernew', a, name2, bidentifier, name, b, c)
  
  
  
  
  
      end
  
  
    end
  
  else
    balance = satici.getAccount('bank').money
  
    if balance < tonumber(c) then
  
      TriggerClientEvent('gksphone:notifi', src, {title = 'Car Sallers', message = _U('carseller_nobank'), img= '/html/static/img/icons/carsales.png' })
    else 
  
  
        MySQL.Async.fetchAll("SELECT accounts FROM users WHERE identifier = @identifier", {
          ['@identifier'] = a,
      }, function(result)
  
      g=json.decode(result[1].accounts)
  
    
      g['bank']=g['bank']+(c);
      
      TriggerClientEvent('gksphone:cardel', -1, b)
          satici.removeAccountMoney('bank', tonumber(c))
  
      
  
      MySQL.Async.execute('UPDATE owned_vehicles SET `owner` = @owneryeni, `carseller` = @carseller WHERE `owner` = @owner AND `plate` = @plate', {
        ['@owner'] = a,
        ['@plate'] = b,
        ['@owneryeni'] = bidentifier,
        ['@carseller'] = 0,
      })
  
          MySQL.Async.execute('UPDATE users SET `accounts` = @bank WHERE `identifier` = @identifier', {
            ['@identifier'] = a,
            ['@bank'] = json.encode(g),
          })
  
      end)
  
  
  
            local name = getFirstname(bidentifier)  .. " " .. getLastname(bidentifier)
  
  
                      MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
                        ["@type"] = 1,
                        ["@identifier"] = bidentifier,
                        ["@price"] = c,
                        ["@name"] = b .._U('car_purchase')
                        }, function(results)
                      end)
  
            local name2 = getFirstname(a)  .. " " .. getLastname(a)
  
  
            MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
                ["@type"] = 2,
                ["@identifier"] = a,
                ["@price"] = c,
                ["@name"] = b .._U('car_sale')
              }, function(resultss)
            end)
  
  
      TriggerEvent('gksphone:carsellernew', a, name2, bidentifier, name, b, c)
  
  
          TriggerClientEvent('gksphone:notifi', src, {title = 'Car Sallers', message = _U('carseller_buyvehicle'), img= '/html/static/img/icons/carsales.png' })
  
      MySQL.Async.execute('DELETE FROM gksphone_vehicle_sales WHERE owner = @owner AND plate = @plate', {
        ['@owner'] = a,
        ['@plate'] = b,
        }, function ()
        MySQL.Async.fetchAll('SELECT * from gksphone_vehicle_sales ORDER BY TIME DESC LIMIT 30', {}, function (tweets)
  
          TriggerClientEvent('gksphone:vehiclearac', -1, tweets)
  
          end)
        end) 
      end
    end
  end)

end

if Config.ESXVersion == '1.1' then

  RegisterServerEvent('gksphone:transferPhoneNumber')
  AddEventHandler('gksphone:transferPhoneNumber', function(to, totaltt, tfee)
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
      local zPlayerIden = getIdentifierByPhoneNumber(to)
      local zPlayer = ESX.GetPlayerFromIdentifier(zPlayerIden)
      local TotalMoney = tonumber(tfee) + tonumber(totaltt)
  
  
      local balance = 0
      if zPlayer ~= nil then
          balance = xPlayer.getAccount('bank').money
          zbalance = zPlayer.getAccount('bank').money
          if xPlayer.identifier == zPlayerIden then
              -- advanced notification with bank icon
  
              TriggerClientEvent('gksphone:notifi', _source, {title = 'Bank', message = _U('bank_yourself'), img= '/html/static/img/icons/wallet.png' })
  
          else
              if balance <= 0 or balance < tonumber(TotalMoney) or tonumber(TotalMoney) <= 0 then
                  -- advanced notification with bank icon
  
                  TriggerClientEvent('gksphone:notifi', _source, {title = 'Bank', message = _U('bank_nomoney'), img= '/html/static/img/icons/wallet.png' })
  
  
              else
                  xPlayer.removeAccountMoney('bank', tonumber(TotalMoney))
                  zPlayer.addAccountMoney('bank', tonumber(tfee))
                  -- advanced notification with bank icon
  
                  local name = getFirstname(xPlayer.identifier)  .. " " .. getLastname(xPlayer.identifier)
                  local name2 = getFirstname(zPlayerIden)  .. " " .. getLastname(zPlayerIden)
          
                  TriggerClientEvent('gksphone:notifi', _source, {title = 'Bank', message = name2 .. _U('bank_transfer'), img= '/html/static/img/icons/wallet.png' })
                  TriggerClientEvent('gksphone:notifi', zPlayer.source, {title = 'Bank', message = _U('bank_playertransfer') ..name, img= '/html/static/img/icons/wallet.png' })
          
                  MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
                    ["@type"] = 1,
                    ["@identifier"] = xPlayer.identifier,
                    ["@price"] = TotalMoney,
                    ["@name"] = name2
                    }, function(results)
                  end)
          
                  MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
                    ["@type"] = 2,
                    ["@identifier"] = zPlayerIden,
                    ["@price"] = tfee,
                    ["@name"] = name
                    }, function(resultss)
                  end)
  
                  if  tonumber(TotalMoney) >= Config.BankLimit then
                    BankTrasnfer(name, xPlayer.identifier, tonumber(TotalMoney), name2, zPlayerIden)
                  end
                  BankGetBilling(_source, function (bankkkkk)
                    TriggerClientEvent('gksphone:bank_getBilling', _source, bankkkkk)
                  end)
  
           
              end
             
          end
      else
  
  
        if (zPlayerIden ~= nil) then
          balance = xPlayer.getAccount('bank').money
  
          if balance <= 0 or balance < tonumber(TotalMoney) or tonumber(TotalMoney) <= 0 then
        
  
            TriggerClientEvent('gksphone:notifi', _source, {title = 'Bank', message = _U('bank_nomoney'), img= '/html/static/img/icons/wallet.png' })
  
  
        else
  
        MySQL.Async.fetchAll("SELECT bank FROM users WHERE identifier = @identifier", {
          ['@identifier'] = zPlayerIden,
      }, function(result)
  
          local offbankamount = result[1].bank
  
          local total = offbankamount + tonumber(tfee)
  
          xPlayer.removeAccountMoney('bank', tonumber(TotalMoney))
  
          MySQL.Async.execute('UPDATE users SET `bank` = @bank WHERE `identifier` = @identifier', {
            ['@identifier'] = zPlayerIden,
            ['@bank'] = total,
          })
  
        end)
          local name = getFirstname(xPlayer.identifier)  .. " " .. getLastname(xPlayer.identifier)
          local name2 = getFirstname(zPlayerIden)  .. " " .. getLastname(zPlayerIden)
  
          TriggerClientEvent('gksphone:notifi', _source, {title = 'Bank', message = name2 .. _U('bank_transfer'), img= '/html/static/img/icons/wallet.png' })
  
          MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
            ["@type"] = 1,
            ["@identifier"] = xPlayer.identifier,
            ["@price"] = TotalMoney,
            ["@name"] = name2
            }, function(results)
          end)
  
          MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
            ["@type"] = 2,
            ["@identifier"] = zPlayerIden,
            ["@price"] = tfee,
            ["@name"] = name
            }, function(resultss)
          end)
  
          if  tonumber(TotalMoney) >= Config.BankLimit then
            BankTrasnfer(name, xPlayer.identifier, tonumber(TotalMoney), name2, zPlayerIden)
          end
          BankGetBilling(_source, function (bankkkkk)
            TriggerClientEvent('gksphone:bank_getBilling', _source, bankkkkk)
          end)
        end
        else
  
          TriggerClientEvent('gksphone:notifi', _source, {title = 'Bank', message = _U('bank_systemnophone'), img= '/html/static/img/icons/wallet.png' })
      
        end
      end
  end)


  RegisterServerEvent('gksphone:aracisatt')
  AddEventHandler('gksphone:aracisatt', function(a, b, c)
  
  local src = source
  local satici = ESX.GetPlayerFromId(src)
  local bidentifier = satici.identifier
  local zPlayer = ESX.GetPlayerFromIdentifier(a)
  
  if zPlayer ~= nil then
    balance = satici.getAccount('bank').money
    zbalance = zPlayer.getAccount('bank').money
    if bidentifier == zPlayer.identifier then
      TriggerClientEvent('gksphone:notifi', src, {title = 'Car Sallers', message = _U('carseller_ownbuy'), img= '/html/static/img/icons/carsales.png' })
    else
      
      if balance < tonumber(c) then
  
        TriggerClientEvent('gksphone:notifi', src, {title = 'Car Sallers', message = _U('carseller_nobank'), img= '/html/static/img/icons/carsales.png' })
      else
  
  
  
          TriggerClientEvent('gksphone:cardel', -1, b)
          satici.removeAccountMoney('bank', tonumber(c))
          zPlayer.addAccountMoney('bank', tonumber(c))
  
          TriggerClientEvent('gksphone:notifi', src, {title = 'Car Sallers', message = _U('carseller_buyvehicle'), img= '/html/static/img/icons/carsales.png' })
          TriggerClientEvent('gksphone:notifi', zPlayer.source, {title = 'Car Sallers', message = _U('carseller_soldvehicle'), img= '/html/static/img/icons/carsales.png' })
      
          MySQL.Async.execute('UPDATE owned_vehicles SET `owner` = @owneryeni, `carseller` = @carseller WHERE `owner` = @owner AND `plate` = @plate', {
            ['@owner'] = a,
            ['@plate'] = b,
            ['@owneryeni'] = bidentifier,
            ['@carseller'] = 0,
          })
  
              MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
                ["@type"] = 1,
                ["@identifier"] = bidentifier,
                ["@price"] = tonumber(c),
                ["@name"] = b .._U('car_purchase')
              })
  
              MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
                ["@type"] = 2,
                ["@identifier"] = zPlayer.identifier,
                ["@price"] = tonumber(c),
                ["@name"] = b .._U('car_sale')
              })
  
          MySQL.Async.execute('DELETE FROM gksphone_vehicle_sales WHERE owner = @owner AND plate = @plate', {
            ['@owner'] = a,
            ['@plate'] = b,
          }, function ()
            MySQL.Async.fetchAll('SELECT * from gksphone_vehicle_sales ORDER BY TIME DESC LIMIT 30', {}, function (tweets)
  
              TriggerClientEvent('gksphone:vehiclearac', -1, tweets)
      
            end)
          end)
  
          local name = getFirstname(bidentifier)  .. " " .. getLastname(bidentifier)
  
          local name2 = getFirstname(a)  .. " " .. getLastname(a)
  
          TriggerEvent('gksphone:carsellernew', a, name2, bidentifier, name, b, c)
  
  
  
  
  
      end
  
  
    end
  
  else
    balance = satici.getAccount('bank').money
  
    if balance < tonumber(c) then
  
      TriggerClientEvent('gksphone:notifi', src, {title = 'Car Sallers', message = _U('carseller_nobank'), img= '/html/static/img/icons/carsales.png' })
    else 
  
  
        MySQL.Async.fetchAll("SELECT bank FROM users WHERE identifier = @identifier", {
          ['@identifier'] = a,
      }, function(result)
  
  
      local offbankamount = result[1].bank
  
          local total = offbankamount + tonumber(c)
  
  
      
      TriggerClientEvent('gksphone:cardel', -1, b)
          satici.removeAccountMoney('bank', tonumber(c))
  
      
  
      MySQL.Async.execute('UPDATE owned_vehicles SET `owner` = @owneryeni, `carseller` = @carseller WHERE `owner` = @owner AND `plate` = @plate', {
        ['@owner'] = a,
        ['@plate'] = b,
        ['@owneryeni'] = bidentifier,
        ['@carseller'] = 0,
      })
  
          MySQL.Async.execute('UPDATE users SET `bank` = @bank WHERE `identifier` = @identifier', {
            ['@identifier'] = a,
            ['@bank'] = total,
          })
  
      end)
  
  
  
            local name = getFirstname(bidentifier)  .. " " .. getLastname(bidentifier)
  
  
                      MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
                        ["@type"] = 1,
                        ["@identifier"] = bidentifier,
                        ["@price"] = c,
                        ["@name"] = b .._U('car_purchase')
                        }, function(results)
                      end)
  
            local name2 = getFirstname(a)  .. " " .. getLastname(a)
  
  
            MySQL.Async.insert("INSERT INTO gksphone_bank_transfer (type, identifier, price, name) VALUES (@type, @identifier, @price, @name)", {
                ["@type"] = 2,
                ["@identifier"] = a,
                ["@price"] = c,
                ["@name"] = b .._U('car_sale')
              }, function(resultss)
            end)
  
  
      TriggerEvent('gksphone:carsellernew', a, name2, bidentifier, name, b, c)
  
  
          TriggerClientEvent('gksphone:notifi', src, {title = 'Car Sallers', message = _U('carseller_buyvehicle'), img= '/html/static/img/icons/carsales.png' })
  
      MySQL.Async.execute('DELETE FROM gksphone_vehicle_sales WHERE owner = @owner AND plate = @plate', {
        ['@owner'] = a,
        ['@plate'] = b,
        }, function ()
        MySQL.Async.fetchAll('SELECT * from gksphone_vehicle_sales ORDER BY TIME DESC LIMIT 30', {}, function (tweets)
  
          TriggerClientEvent('gksphone:vehiclearac', -1, tweets)
  
          end)
        end) 
      end
    end
  end)


end

--================================================================================================
--==                                           Ad ve Soyad                                      ==
--================================================================================================


function getFirstname(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.firstname FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].firstname
    end
    return nil
end

function getLastname(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.lastname FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].lastname
    end
    return nil
end


function BankGetBilling (accountId, cb)
  local xPlayer = ESX.GetPlayerFromId(accountId)
    MySQL.Async.fetchAll([===[
      SELECT * FROM gksphone_bank_transfer WHERE identifier = @identifier ORDER BY time DESC LIMIT 10
      ]===], { ['@identifier'] = xPlayer.identifier }, cb)
  end 
  
  

RegisterServerEvent('gksphone:bank_getBilling')
AddEventHandler('gksphone:bank_getBilling', function()
  local src = source
    BankGetBilling(src, function (bankkkkk)
      TriggerClientEvent('gksphone:bank_getBilling', src, bankkkkk)
    end)
end)


ESX.RegisterServerCallback('gksphone:isparasicek', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return; end
    local society = "society_"..xPlayer.getJob().name  
    MySQL.Async.fetchAll("SELECT account_name, money FROM addon_account_data WHERE addon_account_data.account_name = @society", {
        ['@society'] = society
      }, function (data)
        if (data[1] ~= nil) then
          cb(data[1].money)
        end
    end) 
end)


function BankTrasnfer (name, identifier1, amount, name2, identifier2)
  local discord_webhook = Config.BankTrasnfer
  if discord_webhook == '' then
    return
  end

  local headers = {
    ['Content-Type'] = 'application/json'
  }
  local data = {
    ["username"] = 'Bank Transfer',
    ["avatar_url"] = 'https://www.futurebrand.com/uploads/case-studies/_heroImage/3-NatWest-New-Logo.jpg',
    ["embeds"] = {{
      ["color"] = color
    }}
  }

  data['embeds'][1]['title'] = "[**" .. name .."**] has transferred [**£" .. amount .. "**] to [**" .. name2 .. "**]."
  data['embeds'][1]['description'] = "[**" .. name .. "**]" .. "**[" .. identifier1 .. "**]" .. "\n" .. "[**" .. name2 .. "**]" .."[**" .. identifier2 .."**]"

  PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end