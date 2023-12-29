function getMaximumGrade(jobname)
    local queryDone, queryResult = false, nil

    MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @jobname ORDER BY `grade` DESC ;', {
        ['@jobname'] = jobname
    }, function(result)
        queryDone, queryResult = true, result
    end)

    while not queryDone do
        Wait(10)
    end

    if queryResult[1] then
        return queryResult[1].grade
    end

    return nil
end

function getAdminCommand(name)
    for i = 1, #Config.Admin, 1 do
        if Config.Admin[i].name == name then
            return i
        end
    end

    return false
end

function isAuthorized(index, group)
    for i = 1, #Config.Admin[index].groups, 1 do
        if Config.Admin[index].groups[i] == group then
            return true
        end
    end

    return false
end

function isEmployed(jobName)
    return (jobName ~= "unemployed" and jobName ~= "unemployed2")
end


ESX.RegisterServerCallback('KorioZ-PersonalMenu:Admin_getUsergroup', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plyGroup = xPlayer.getGroup()

    if plyGroup ~= nil then
        cb(plyGroup)
    else
        cb('user')
    end
end)

ESX.RegisterServerCallback('ewen:getFactures', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)

local canSpawnBMX = true
local lastSpawnTime = 0

RegisterServerEvent('GiveBMX')
AddEventHandler('GiveBMX', function()
    local _source = source

    local currentTime = os.time()

    if canSpawnBMX then
        canSpawnBMX = false

        -- Utilisez ESX pour faire spawn le BMX (ou votre propre logique pour faire spawn un BMX)
        TriggerClientEvent('esx:spawnVehicle', _source, 'bmx')

        lastSpawnTime = currentTime

        Citizen.CreateThread(function()
            Citizen.Wait(300000)  -- Délai de 5 minutes (300,000 millisecondes)
            canSpawnBMX = true
        end)
    end
end)





RegisterNetEvent('KorioZ-PersonalMenu:Boss_promouvoirplayer', function(target)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_promouvoirplayer sur " .. target)

    if (targetXPlayer.job.grade == tonumber(getMaximumGrade(sourceXPlayer.job.name)) - 1) then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation du ~r~Gouvernement~w~.')
    else
        if source ~= target and sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
            targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) + 1)

            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~p~promu ' .. targetXPlayer.name .. '~w~.')
            TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~p~promu par ' .. sourceXPlayer.name .. '~w~.')
        else
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        end
    end
end)

RegisterNetEvent('KorioZ-PersonalMenu:Boss_destituerplayer', function(target)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_destituerplayer sur " .. target)

    if (targetXPlayer.job.grade == 0) then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~w~ davantage.')
    else
        if source ~= target and sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
            targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) - 1)

            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~rétrogradé ' .. targetXPlayer.name .. '~w~.')
            TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~r~rétrogradé par ' .. sourceXPlayer.name .. '~w~.')
        else
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        end
    end
end)

RegisterNetEvent('KorioZ-PersonalMenu:Boss_recruterplayer', function(target, job)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_recruterplayer sur " .. target)

    if source ~= target and sourceXPlayer.job.grade_name == 'boss' then
        if not isEmployed(targetXPlayer.job.name) then
            targetXPlayer.setJob(job, 0)
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~p~recruté ' .. targetXPlayer.name .. '~w~.')
            TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~p~embauché par ' .. sourceXPlayer.name .. '~w~.')
        else
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas recruter quelqu\'un déjà embauché.')
        end
    end
end)

RegisterNetEvent('KorioZ-PersonalMenu:Boss_virerplayer', function(target)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_virerplayer sur " .. target)

    if source ~= target and sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
        targetXPlayer.setJob('unemployed', 0)
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~w~.')
        TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~p~viré par ' .. sourceXPlayer.name .. '~w~.')
    else
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
    end
end)

RegisterNetEvent('KorioZ-PersonalMenu:Boss_promouvoirplayer2', function(target)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_promouvoirplayer2 sur " .. target)

    if (targetXPlayer.job2.grade == tonumber(getMaximumGrade(sourceXPlayer.job2.name)) - 1) then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation du ~r~Gouvernement~w~.')
    else
        if source ~= target and sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
            targetXPlayer.setJob2(targetXPlayer.job2.name, tonumber(targetXPlayer.job2.grade) + 1)

            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~p~promu ' .. targetXPlayer.name .. '~w~.')
            TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~p~promu par ' .. sourceXPlayer.name .. '~w~.')
        else
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        end
    end
end)

RegisterNetEvent('KorioZ-PersonalMenu:Boss_destituerplayer2', function(target)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_destituerplayer2 sur " .. target)

    if (targetXPlayer.job2.grade == 0) then
        TriggerClientEvent('esx:showNotification', _source, 'Vous ne pouvez pas ~r~rétrograder~w~ davantage.')
    else
        if ssource ~= target and sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
            targetXPlayer.setJob2(targetXPlayer.job2.name, tonumber(targetXPlayer.job2.grade) - 1)

            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~rétrogradé ' .. targetXPlayer.name .. '~w~.')
            TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~r~rétrogradé par ' .. sourceXPlayer.name .. '~w~.')
        else
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        end
    end
end)

RegisterNetEvent('KorioZ-PersonalMenu:Boss_recruterplayer2', function(target, job2)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_recruterplayer2 sur " .. target)

    if source ~= target and sourceXPlayer.job2.grade_name == 'boss' then
        if not isEmployed(targetXPlayer.job2.name) then
            targetXPlayer.setJob2(job2, 0)
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~p~recruté ' .. targetXPlayer.name .. '~w~.')
            TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~p~embauché par ' .. sourceXPlayer.name .. '~w~.')
        else
            TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas recruter quelqu\'un déjà embauché.')
        end
    end
end)

RegisterNetEvent('KorioZ-PersonalMenu:Boss_virerplayer2', function(target)
    if target == -1 then return end
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)
			
	print("Le Joueur " .. GetPlayerName(source) .. " (" .. source .. ") a TriggerServerEvent Boss_virerplayer2 sur " .. target)

    if source ~= target and sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
        targetXPlayer.setJob2('unemployed2', 0)
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~w~.')
        TriggerClientEvent('esx:showNotification', target, 'Vous avez été ~p~viré par ' .. sourceXPlayer.name .. '~w~.')
    else
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
    end
end)




RegisterCommand('goto', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()
  
    if playerGroup ~= 'user' then
        if args[1] == nil then 
            TriggerClientEvent('esx:showNotification', source, 'Vous devez spécifier un joueur')
            return
        end
        local ped = GetPlayerPed(args[1])
        local playerCoords = GetEntityCoords(ped)
        TriggerClientEvent('framework:tp', source, playerCoords)
    end
end)
  
RegisterCommand('bring', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()

    if playerGroup ~= 'user' then
        if args[1] == nil then 
            TriggerClientEvent('esx:showNotification', source, 'Vous devez spécifier un joueur')
            return
        end
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)
        TriggerClientEvent('framework:tp', args[1], playerCoords)
    end
end)

RegisterNetEvent('Admin:ActionTeleport', function(action, id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.getGroup() ~= "user" then 
        if action == "teleportto" then 
            local ped = GetPlayerPed(id)
            local coord = GetEntityCoords(ped)
            TriggerClientEvent("Admin:ActionTeleport", _source, "teleportto", coord)
        elseif action == "teleportme" then 
            local ped = GetPlayerPed(_source)
            local coord = GetEntityCoords(ped)
            TriggerClientEvent("Admin:ActionTeleport", id, "teleportme", coord)
        elseif action == "teleportpc" then
            local coord = vector3(215.76, -810.12, 30.73)
            TriggerClientEvent("Admin:ActionTeleport", id, "teleportpc", coord)
        end
    else
        TriggerEvent("BanSql:ICheatServer", source, "Le Cheat n'est pas autorisé sur notre serveur [téléportation]")
    end
end)

ESX.RegisterServerCallback("ronflex:getradio", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem("radio").count >= 1 then 
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('ewen:ChangeWeightInventory',function(NewMaxWeight)
    local SECURITY = NewMaxWeight == 24 and true or NewMaxWeight == 40 and true or false

    if SECURITY then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.setMaxWeight(NewMaxWeight)
        --xPlayer.showNotification('FlashSide ~w~~n~Le poids de votre inventaire a été changé à ~p~'..NewMaxWeight..'~w~kg.')
    else
        DropPlayer(source, 'Désynchronisation avec le serveur ou Detection de Cheat')
    end
end)

local isHandsup = {}
RegisterNetEvent('ewen:handsup', function(value)
    if not isHandsup[source] then 
        isHandsup[source] = value
    else 
        isHandsup[source] = value
    end
end)

ESX.RegisterServerCallback('KorioZ-PersonalMenu:getHandsUp', function(source, cb, target)
    if isHandsup[target] then 
        cb(isHandsup[target])
    else
        isHandsup[target] = false
        cb(isHandsup[target])
    end
    print(isHandsup[target])
end)

RegisterServerEvent('Twt')
AddEventHandler('Twt', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''..name..'', ''.._raison..'', ''..message..'', 'CHAR_TWITTER')
	end
end)


RegisterServerEvent('Entreprise')
AddEventHandler('Entreprise', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.grade_name == "boss" then

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''..name..'', ''.._raison..'', ''..message..'', '')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''..name..'', ''.._raison..'', ''..message..'', '')
	end
end)

RegisterServerEvent('Police')
AddEventHandler('Police', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "police" then


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''..name..'', ''.._raison..'', ''..message..'', 'CHAR_LSPD')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''..name..'', ''.._raison..'', ''..message..'', 'CHAR_LSPD')
	end
end)

RegisterServerEvent('Gouvernement')
AddEventHandler('Gouvernement', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	if xPlayer.job.name == "gouvernement" then

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Twt:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''..name..'', ''.._raison..'', ''..message..'', 'CHAR_GOUV')
	end
else
	TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''..name..'', ''.._raison..'', ''..message..'', 'CHAR_GOUV')
	end
end)

RegisterServerEvent('Ano')
AddEventHandler('Ano', function(PriseOuFin, message)
	local _source = source
	--local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	--local name = xPlayer.getName(_source)


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('Ano:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], '', 'Ano', ''..message..'', '')
	end
end)


RegisterServerEvent('FaceBook')
AddEventHandler('FaceBook', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			--TriggerClientEvent('FaceBook:Info', xPlayers[i], _raison, name, message)
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], ''..name..'', ''.._raison..'', ''..message..'', 'CHAR_FACEBOOK')
	end
end)