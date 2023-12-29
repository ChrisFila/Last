RegisterNetEvent('ewen:createGang', function(namegang, labelgang, positonCoffre, KitArme)
	local posCoffre = json.encode(positonCoffre)
    local xPlayer = ESX.GetPlayerFromId(source)
	if KitArme then
		KitArme = 1 
	else 
		KitArme = 0
	end
    if xPlayer.getGroup() == '_dev' or xPlayer.getGroup() == 'responsable' or xPlayer.getGroup() == 'superadmin' then
		--local webhook = ''
		--SeaLogs(webhook, 'FlashSide', '\nNouveau Gang crée \nLe joueur qui crée le gang : __' .. GetPlayerName(xPlayer.source) .. '__\nNom du gang : '..namegang.. '\nLabel du Gang : '..labelgang..'\nPosition :'.. positonCoffre, 56108)
		MySQL.Async.execute("INSERT INTO `gangs` (`gangname`, `posCoffre`, `KitArme`) VALUES (@gangname, @posCoffre, @KitArme) ", {
            ['@gangname'] = namegang,
            ['@posCoffre'] = posCoffre,
			['@KitArme'] = KitArme,
        })
		MySQL.Async.execute("INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES (@name, @label, @whitelisted) ", {
            ['@name'] = namegang,
            ['@label'] = labelgang,
            ['@whitelisted'] = 1
        })
        MySQL.Async.execute("INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)", {
            ['@job_name'] = namegang,
            ['@grade'] = 3,
            ['@name'] = "boss",
            ['@label'] = "Boss",
            ['@salary'] = 0,
            ['@skin_male'] = "{}",
            ['@skin_female'] = "{}"
        })
        MySQL.Async.execute("INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)", {
            ['@job_name'] = namegang,
            ['@grade'] = 2,
            ['@name'] = "gerant",
            ['@label'] = "Gérant",
            ['@salary'] = 0,
            ['@skin_male'] = "{}",
            ['@skin_female'] = "{}"
        })
        MySQL.Async.execute("INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)", {
            ['@job_name'] = namegang,
            ['@grade'] = 1,
            ['@name'] = "membre",
            ['@label'] = "Membre",
            ['@salary'] = 0,
            ['@skin_male'] = "{}",
            ['@skin_female'] = "{}"
        })
        MySQL.Async.execute("INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)", {
            ['@job_name'] = namegang,
            ['@grade'] = 0,
            ['@name'] = "recrue",
            ['@label'] = "Recrue",
            ['@salary'] = 0,
            ['@skin_male'] = "{}",
            ['@skin_female'] = "{}"
        })
        MySQL.Async.execute("INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES (@name, @label, @shared) ", {
            ['@name'] = 'society_'..name,
            ['@label'] = label,
            ['@shared'] = 1
        })
        MySQL.Async.execute("INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES (@name, @label, @shared) ", {
            ['@name'] = 'society_'..name,
            ['@label'] = label,
            ['@shared'] = 1
        })
        MySQL.Async.execute("INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES (@name, @label, @shared) ", {
            ['@name'] = 'society_'..name,
            ['@label'] = label,
            ['@shared'] = 1
        })
    end
end)

local GangsList = {}

Citizen.CreateThread(function()
    MySQL.Async.fetchAll('SELECT * FROM gangs', {}, function(Gangs)
        for i=1, #Gangs, 1 do
            GangsList[Gangs[i].gangname] = {}
            GangsList[Gangs[i].gangname].name = Gangs[i].gangname 
            GangsList[Gangs[i].gangname].posCoffre = json.decode(Gangs[i].posCoffre)
			GangsList[Gangs[i].gangname].KitArme = Gangs[i].KitArme
        end
		print('[^5LOAD^0] Le gang : [^5'..#Gangs..'^0] ont été load avec succès')
    end)
end)

RegisterNetEvent('ewen:initGangs', function()
    TriggerClientEvent('ewen:SendGangListToClient', source, GangsList)
end)

ESX.RegisterServerCallback('GangsBuilder:addArmoryWeapon', function(source, cb, weaponName, weaponAmmo)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.hasWeapon(weaponName) then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..xPlayer.job2.name, function(store)
			--if PermanantWeapon[weaponName] == nil then
				local weapons = store.get('weapons') or {}
				weaponName = string.upper(weaponName)
	
				table.insert(weapons, {
					name = weaponName,
					ammo = weaponAmmo
				})
	
				xPlayer.removeWeapon(weaponName)
				store.set('weapons', weapons)
				cb()
				--local webhook = ''
				--SeaLogs(webhook, 'FlashSide', '\nLe joueur : __' .. GetPlayerName(xPlayer.source) .. ' à déposer dans __\nNom du gang : '..xPlayer.job2.name.. '\nLabel du Gang : '..xPlayer.job2.label..'\nArme déposer :'.. weaponName, 56108)
			--else
				--xPlayer.showNotification('FlashSide ~w~~n~Vous ne pouvez pas déposer les armes permanentes')
				--cb()
			--end
		end)
	else
		xPlayer.showNotification('Vous ne possédez pas cette arme !')
		cb()
	end
end)

ESX.RegisterServerCallback('GangsBuilder:getArmoryWeapons', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. xPlayer.job2.name, function(store)
		local weapons = store.get('weapons') or {}
		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('GangsBuilder:removeArmoryWeapon', function(source, cb, weaponName, weaponAmmo)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not xPlayer.hasWeapon(weaponName) then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. xPlayer.job2.name, function(store)
			--if PermanantWeapon[weaponName] == nil then
				local weapons = store.get('weapons') or {}
				weaponName = string.upper(weaponName)

				for i = 1, #weapons, 1 do
					if weapons[i].name == weaponName and weapons[i].ammo == weaponAmmo then
						table.remove(weapons, i)

						store.set('weapons', weapons)
						xPlayer.addWeapon(weaponName, weaponAmmo)
						--local webhook = ''
						--SeaLogs(webhook, 'FlashSide', '\nLe joueur : __' .. GetPlayerName(xPlayer.source) .. ' à retirer de __\nNom du gang : '..xPlayer.job2.name.. '\nLabel du Gang : '..xPlayer.job2.label..'\nArme retirer :'.. weaponName, 56108)
						break
					end
				end

				cb()
			--else
				--xPlayer.showNotification('FlashSide ~w~~n~Vous ne pouvez pas déposer les armes permanentes')
				--cb()
			--end
		end)
	else
		xPlayer.showNotification('Vous possédez déjà cette arme !')
		cb()
	end
end)

RegisterNetEvent('GangsBuilder:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. xPlayer.job2.name, function(inventory)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification('FlashSide ~w~~n~Vous avez déposer ~r~x'..count.. ' ~r~'.. ESX.GetItem(itemName).label)
			--local webhook = ''
			--SeaLogs(webhook, 'FlashSide', '\nLe joueur : __' .. GetPlayerName(xPlayer.source) .. ' à déposer dans __\nNom du gang : '..xPlayer.job2.name.. '\nLabel du Gang : '..xPlayer.job2.label..'\nItem déposer :'.. itemName..'\nQuantités : '.. count, 56108)
		else
			xPlayer.showNotification('FlashSide ~w~~n~Vous n\'avez pas la quantité nécéssaire pour déposer dans le coffre')
		end
	end)
end)

ESX.RegisterServerCallback('GangsBuilder:getStockItems', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. xPlayer.job2.name, function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('GangsBuilder:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. xPlayer.job2.name, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if inventoryItem.count >= count and inventoryItem.count > 0 then
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				--local webhook = ''
				--SeaLogs(webhook, 'FlashSide', '\nLe joueur : __' .. GetPlayerName(xPlayer.source) .. ' à retirer dans __\nNom du gang : '..xPlayer.job2.name.. '\nLabel du Gang : '..xPlayer.job2.label..'\nItem retirer :'.. itemName..'\nQuantités : '.. count, 56108)
				xPlayer.showNotification('FlashSide ~w~~n~Vous avez retirer ~r~x'.. count.. ' ~r~' ..inventoryItem.label)
			else
				xPlayer.showNotification('FlashSide ~w~~n~Vous ne pouvez pas prendre autant d\'objets sur vous')
			end
		else
			xPlayer.showNotification('FlashSide ~w~~n~Le coffre ne contient pas la quantité que vous souhaitez prendre')
		end
	end)
end)

RegisterNetEvent('GangsBuilder:putInVehicle', function(target)
	local xPlayerTarget = ESX.GetPlayerFromId(target)

	if xPlayerTarget ~= nil then
		local cuffState = xPlayerTarget.get('cuffState')

		if cuffState.isCuffed then
			TriggerClientEvent('GangsBuilder:putInVehicle', target)
		end
	end
end)

RegisterNetEvent('GangsBuilder:OutVehicle', function(target)
	local xPlayerTarget = ESX.GetPlayerFromId(target)

	if xPlayerTarget ~= nil then
		local cuffState = xPlayerTarget.get('cuffState')

		if cuffState.isCuffed then
			TriggerClientEvent('GangsBuilder:OutVehicle', target)
		end
	end
end)

ESX.RegisterServerCallback('GangsBuilder:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		cb({
			foundPlayer = true,
			inventory = xPlayer.inventory,
			weapons = xPlayer.loadout,
			accounts = xPlayer.accounts
		})
	else
		cb({foundPlayer = false})
	end
end)

ESX.RegisterServerCallback('Ewen:GetPlayerData', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
            grade = xPlayer.job.grade_label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout(),
            money = xPlayer.getAccount('cash').money,
            blackmoney = xPlayer.getAccount('dirtycash').money,
            weapons = xPlayer.getLoadout()
        }
        cb(data)
    end
end)

local function HaveWeaponInLoadout(xPlayer, weapon)
    for i, v in pairs(xPlayer.loadout) do
        if (GetHashKey(v.name) == weapon) then
            return true;
        end
    end
    return false;
end

local SecurityWeaponGangsBuilder = {
    ['WEAPON_SNSPISTOL'] = {price = 200000, hash = 'WEAPON_SNSPISTOL', label = 'PÃ©toire'},
    ['WEAPON_PISTOL'] = {price = 480000, hash = 'WEAPON_PISTOL', label = 'Pisolet'},
    ['WEAPON_PISTOL50'] = {price = 760000, hash = 'WEAPON_PISTOL50', label = 'Calibre 50'},
    ['WEAPON_HEAVYPISTOL'] = {price = 775000, hash = 'WEAPON_HEAVYPISTOL', label = 'Pistolet Lourd'},
    ['WEAPON_MACHINEPISTOL'] = {price = 1000000, hash = 'WEAPON_MACHINEPISTOL', label = 'Tec-9'},
    ['WEAPON_MICROSMG'] = {price = 1200000, hash = 'WEAPON_MICROSMG', label = 'Micro Uzi'},
    ['WEAPON_MINISMG'] = {price = 1400000, hash = 'WEAPON_MINISMG', label = 'Scorpion'},
    ['WEAPON_ASSAULTRIFLE'] = {price = 4000000, hash = 'WEAPON_ASSAULTRIFLE', label = 'AK 47'},
}

RegisterNetEvent('Gangsbuilder:BuyWeapon', function(weapon, label)
	local xPlayer = ESX.GetPlayerFromId(source)
	if SecurityWeaponGangsBuilder[weapon] == nil then DropPlayer(source, 'euh t srx maik') return end

	if xPlayer.getAccount('dirtycash').money >= SecurityWeaponGangsBuilder[weapon].price then
        if not (HaveWeaponInLoadout(xPlayer, SecurityWeaponGangsBuilder[weapon].hash)) then
			xPlayer.removeAccountMoney('dirtycash', SecurityWeaponGangsBuilder[weapon].price) 
			xPlayer.addWeapon(SecurityWeaponGangsBuilder[weapon].hash, 250)
			xPlayer.showNotification('FlashSide~w~ Vous avez acheter ~r~'..label)
		else
			xPlayer.showNotification('FlashSide ~w~~n~Vous avez déjà cette arme sur vous !')
		end
	else
		xPlayer.showNotification('FlashSide ~w~~n~Vous n\'avez pas l\'argent nécéssaire.')
	end
end)

RegisterCommand('gangs', function(source,args)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getGroup() == '_dev' or xPlayer.getGroup() == 'responsable' or xPlayer.getGroup() == 'superadmin' then
		TriggerClientEvent('Open:GangMenuAdmin', source)
	end
end)

RegisterNetEvent('ewen:UpdateGangs', function(value)
	local xPlayer = ESX.GetPlayerFromId(source)
	local NewCoffrePos = json.encode(value.CoffrePos)
	if xPlayer.getGroup() == '_dev' or xPlayer.getGroup() == 'responsable' or xPlayer.getGroup() == 'superadmin' then
		if GangsList[value.name] then
			GangsList[value.name].posCoffre = json.decode(NewCoffrePos)
			GangsList[value.name].KitArme = value.KitArme
			TriggerClientEvent('ewen:SendGangListToClient', -1, GangsList)
			MySQL.Async.execute('UPDATE gangs SET posCoffre = @posCoffre, KitArme = @KitArme WHERE gangname = @gangname',{
				['@gangname'] = value.name,
				['@posCoffre'] = NewCoffrePos,
				['@KitArme'] = value.KitArme,
			})
		end
	end
end)

RegisterNetEvent('ewen:DeleteGangs', function(value)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() == '_dev' or xPlayer.getGroup() == 'responsable' or xPlayer.getGroup() == 'superadmin' then
		if GangsList[value] then
			GangsList[value] = nil
			TriggerClientEvent('ewen:SendGangListToClient', -1, GangsList)
			MySQL.Async.execute('DELETE FROM gangs WHERE `gangname` = @gangname', {
				['@gangname'] = value
			})
		end
	end
end)