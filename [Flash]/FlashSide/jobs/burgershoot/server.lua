ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--TriggerEvent('esx_phone:registerNumber', 'burger', 'alerte Burger', true, true)

TriggerEvent('esx_society:registerSociety', 'burger', 'burger', 'society_Burger', 'society_Burger', 'society_Burger', 'society_Burger_black', {type = 'public'})

ESX.RegisterServerCallback('fBurger:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_Burger', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('fBurger:getStockItem')
AddEventHandler('fBurger:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

  if xPlayer.job.name == 'burger' then
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_Burger', function(inventory)
      local inventoryItem = inventory.getItem(itemName)

      -- is there enough in the society?
      if count > 0 and inventoryItem.count >= count then
          inventory.removeItem(itemName, count)
          xPlayer.addInventoryItem(itemName, count)
          TriggerClientEvent('esx:showNotification', _source, 'Objet retiré', count, inventoryItem.label)
      else
        TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
      end
    end)
  end
end)

ESX.RegisterServerCallback('fBurger:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('fBurger:putStockItems')
AddEventHandler('fBurger:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

  if xPlayer.job.name == 'burger' then
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_Burger', function(inventory)
      local inventoryItem = inventory.getItem(itemName)

      -- does the player have enough of the item?
      if sourceItem.count >= count and count > 0 then
        xPlayer.removeInventoryItem(itemName, count)
        inventory.addItem(itemName, count)
        xPlayer.showNotification(_U('have_deposited', count, inventoryItem.name))
      else
        TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
      end
    end)
  end
end)




RegisterNetEvent('fBurger:bar')
AddEventHandler('fBurger:bar', function(item,price)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'burger' then
      xPlayer.addInventoryItem(item, 1)
      TriggerClientEvent('esx:showNotification', source, "~r~Achats~w~ effectué !")
    end
end)


RegisterServerEvent('fBurger:Ouvert')
AddEventHandler('fBurger:Ouvert', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
  if xPlayer.job.name == 'burger' then
    for i=1, #xPlayers, 1 do
      local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
      TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'burger', '~r~Informations', 'Le Burger est ouvert', 'CHAR_STRIPPER_NIKKI', 2)
    end
  end
end)

RegisterServerEvent('fBurger:Fermer')
AddEventHandler('fBurger:Fermer', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
  if xPlayer.job.name == 'burger' then
    for i=1, #xPlayers, 1 do
      local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
      TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'burger', '~r~Informations', 'Le Burger est fermé', 'CHAR_STRIPPER_NIKKI', 2)
    end
  end
end)

RegisterServerEvent('fBurger:Perso')
AddEventHandler('fBurger:Perso', function(msg)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    if xPlayer.job.name == 'burger' then
      for i=1, #xPlayers, 1 do
          local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
          TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'burger', '~r~Annonce', msg, 'CHAR_STRIPPER_NIKKI', 8)
      end
    end
end)

ESX.RegisterServerCallback('Burger:getPlayerInventoryBlack', function(source, cb)
	local _source = source
	local xPlayer    = ESX.GetPlayerFromId(_source)
	local blackMoney = xPlayer.getAccount('black_money').money
  
	cb({
	  blackMoney = blackMoney
	})
  end)

RegisterServerEvent('Burger:putblackmoney')
AddEventHandler('Burger:putblackmoney', function(type, item, count)

  local _source      = source
  local xPlayer      = ESX.GetPlayerFromId(_source)

  if xPlayer.job.name == 'burger' then
    if type == 'item_account' then
      local playerAccountMoney = xPlayer.getAccount(item).money

      if playerAccountMoney >= count then

        xPlayer.removeAccountMoney(item, count)
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_Burger_black', function(account)
          account.addMoney(count)
        end)
      else
        TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
      end
    end
  end
end)


  ESX.RegisterServerCallback('Burger:getBlackMoneySociety', function(source, cb)
    local _source = source
    local xPlayer    = ESX.GetPlayerFromId(_source)
    local blackMoney = 0
  
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_Burger_black', function(account)
      blackMoney = account.money
    end)
  
    cb({
      blackMoney = blackMoney
    })
  
  end)

  RegisterServerEvent('Burger:getItem')
  AddEventHandler('Burger:getItem', function(type, item, count)
  
    local _source      = source
    local xPlayer      = ESX.GetPlayerFromId(_source)
  
    if xPlayer.job.name == 'burger' then
      if type == 'item_account' then
    
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_Burger_black', function(account)
    
          local roomAccountMoney = account.money
    
          if roomAccountMoney >= count then
            account.removeMoney(count)
            xPlayer.addAccountMoney(item, count)
          else
            TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
          end
    
        end)
      end
    end
end)