RegisterNetEvent('framework:createactivitylegal')
AddEventHandler('framework:createactivitylegal', function(ActivityName, PosRecolte, ItemRecolte, ItemRecolteLabel, PosTraitement, ItemTraitement, ItemTraitementLabel, PosVente, PrixVente)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() == '_dev' then
		MySQL.Async.execute("INSERT INTO `activity` (`name`, `recolte`, `itemrecolte`, `traitement`, `itemtraitement`, `vente`, `PrixVente`) VALUES (@name, @recolte, @itemrecolte, @traitement, @itemtraitement, @vente, @PrixVente) ", {
			['@name'] = ActivityName,
			['@recolte'] = json.encode(PosRecolte),
			['@itemrecolte'] = ItemRecolte,
			['@traitement'] = json.encode(PosTraitement),
			['@itemtraitement'] = ItemTraitement,
			['@vente'] = json.encode(PosVente),
			['@PrixVente'] = PrixVente,
		})
		MySQL.Async.execute("INSERT INTO `items` (`name`, `label`, `weight`) VALUES (@name, @label, @weight) ", {
			['@name'] = ItemRecolte,
			['@label'] = ItemRecolteLabel,
			['@weight'] = 1
		})
		MySQL.Async.execute("INSERT INTO `items` (`name`, `label`, `weight`) VALUES (@name, @label, @weight) ", {
			['@name'] = ItemTraitement,
			['@label'] = ItemTraitementLabel,
			['@weight'] = 1
		})
		xPlayer.showNotification('~r~Sea~w~Life ~w~~n~Vous avez crée une nouvelle activité de Farm.')
	else
		DropPlayer(source, 'Désynchronisation avec les activité farm')
	end
end)

ListeActivity = {}
ListeItemRecolt = {}
ListeItemTraitement = {}
function LoadActivity()
	MySQL.Async.fetchAll('SELECT * FROM activity', {}, function(Activity)
        for i=1, #Activity, 1 do
            table.insert(ListeActivity, {
                name = Activity[i].name,
                recolte = json.decode(Activity[i].recolte), 
                ItemRecolte = Activity[i].itemrecolte,
                traitement = json.decode(Activity[i].traitement),
                ItemTraitement = Activity[i].itemtraitement,
				vente = json.decode(Activity[i].vente),
			})
			-- SECURITE RECOLTE
			if not ListeItemRecolt[Activity[i].itemrecolte] then ListeItemRecolt[Activity[i].itemrecolte] = {} end
			ListeItemRecolt[Activity[i].itemrecolte].name = Activity[i].itemrecolte
			-- SECURITE TRAITEMENT
			if not ListeItemTraitement[Activity[i].itemtraitement] then ListeItemTraitement[Activity[i].itemtraitement] = {} end
			ListeItemTraitement[Activity[i].itemtraitement].name = Activity[i].itemtraitement
			ListeItemTraitement[Activity[i].itemtraitement].price = Activity[i].PrixVente
			print(ListeItemTraitement[Activity[i].itemtraitement].price)
		end
		print(#Activity.. ' Activitées on été chargées avec succès')
    end)
end

MySQL.ready(function()
    LoadActivity()
end)

ESX.RegisterServerCallback('framework:LoadActivity', function(source, cb)
	cb(ListeActivity)
end)

local Players = {}

local function Activity(source, itemRecolte, type, ItemTraitement)
	if Players[source] then
		local xPlayer  = ESX.GetPlayerFromId(source)
		if type == 1 then -- Recolte
			if ListeItemRecolt[itemRecolte] == nil then
                DropPlayer(source, 'Désynchronisation avec les activité farm')
			else
				if ListeItemRecolt[itemRecolte].name == itemRecolte then
					local Quantity = xPlayer.getInventoryItem(itemRecolte).count
					if Quantity >= 70 then
						xPlayer.showNotification(source, '~r~Erreur ~w~~n~Vous êtes trop lourd pour faire ceci')
					else
						TriggerClientEvent('framework:farmanimation', source)
						Citizen.Wait(1500)
						xPlayer.addInventoryItem(itemRecolte, 1)
						Activity(source, itemRecolte, type, ItemTraitement)
					end
				else
                    DropPlayer(source, 'Désynchronisation avec les activité farm')
				end
			end
		elseif type == 2 then -- Traitement
			if ListeItemRecolt[itemRecolte] == nil or ListeItemTraitement[ItemTraitement] == nil then
                DropPlayer(source, 'Désynchronisation avec les activité farm')
			else
				if ListeItemRecolt[itemRecolte] == itemRecolte or ListeItemTraitement[itemTraitement] == itemTraitement then
					local Quantity = xPlayer.getInventoryItem(itemRecolte).count
					local Quantity2 = xPlayer.getInventoryItem(ItemTraitement).count
					if Quantity <= 0 then
						xPlayer.showNotification(source, '~r~Erreur ~w~~n~Vous n\'avez rien à traiter')
					elseif Quantity2 >= 70 then
						xPlayer.showNotification(source, '~r~Erreur ~w~~n~Vous êtes trop lourd pour faire ceci')
					else					
						TriggerClientEvent('framework:farmanimation', source)
						Citizen.Wait(1500)
						xPlayer.removeInventoryItem(itemRecolte, 1)
						xPlayer.addInventoryItem(ItemTraitement, 1)
						Activity(source, itemRecolte, type, ItemTraitement)
					end
				else
                    DropPlayer(source, 'Désynchronisation avec les activité farm')
				end
			end
		elseif type == 3 then -- Vente
			if ListeItemTraitement[ItemTraitement] == nil then
                DropPlayer(source, 'Désynchronisation avec les activité farm')
			else
				if ListeItemTraitement[itemTraitement] == itemTraitement then
					local Quantity = xPlayer.getInventoryItem(ItemTraitement).count
					if Quantity <= 0 then
						xPlayer.showNotification(source, '~r~Erreur ~w~~n~Vous n\'avez rien à traiter')
					else					
						TriggerClientEvent('framework:farmanimation', source)
						Citizen.Wait(1500)
						xPlayer.removeInventoryItem(ItemTraitement, 1)
						xPlayer.addAccountMoney('cash', ListeItemTraitement[ItemTraitement].price)
						xPlayer.showNotification('FlashSide~s~Vous avez gagné : '.. ListeItemTraitement[ItemTraitement].price)
						Activity(source, itemRecolte, type, ItemTraitement)
					end
				else
                    DropPlayer(source, 'Désynchronisation avec les activité farm')
				end
			end
		else
            DropPlayer(source, 'Désynchronisation avec les activité farm')
		end
	end
end

RegisterServerEvent('framework:startActivityBuild')
AddEventHandler('framework:startActivityBuild', function(position, itemRecolte, type, ItemTraitement)
	if #(GetEntityCoords(GetPlayerPed(source)) - vector3(position.x, position.y, position.z)) < 100 then
		Players[source] = true
		Activity(source, itemRecolte, type, ItemTraitement)
	else
		DropPlayer(source, 'Désynchronisation avec les activité farm')
	end
end)

RegisterServerEvent('framework:stopActivityBuild')
AddEventHandler('framework:stopActivityBuild', function()
	Players[source] = false
end)