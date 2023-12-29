ESX = nil
TriggerEvent(mSocietyCFG.ESX, function(obj) ESX = obj end)
mSociety = {}
mSociety.Trad = mSocietyTranslation[mSocietyCFG.Language]

AddEventHandler('onResourceStart', function(resourceName) if (GetCurrentResourceName() ~= resourceName) then return end                                                                                                                                                                                   RconPrint("^2["..GetCurrentResourceName().."] ^0: Society ^3Initialized ^5By 𝕸𝖔𝖜𝖌𝖑𝖎#1658^0\n") end)  

local RegisteredSocieties = {}

mSociety.GetSociety = function(name)
	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end

mSociety.getMaximumGrade = function(jobname)
	local queryDone, queryResult = false, nil

	MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @jobname ORDER BY `grade` DESC ;', {
		['@jobname'] = jobname
	}, function(result)
		queryDone, queryResult = true, result
	end)

	while not queryDone do
		Citizen.Wait(10)
	end

	if queryResult[1] then
		return queryResult[1].grade
	end

	return nil
end

AddEventHandler('mSociety:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('mSociety:getSociety', function(name, cb)
	cb(mSociety.GetSociety(name))
end)

RegisterServerEvent('mSociety:registerSociety')
AddEventHandler('mSociety:registerSociety', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name      = name,
		label     = label,
		account   = account,
		datastore = datastore,
		inventory = inventory,
		data      = data
	}

	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found = true
			RegisteredSocieties[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end

    --RconPrint("^3["..GetCurrentResourceName().."] ^0: "..label.." ^2has been registered^0\n")
end)

ESX.RegisterServerCallback('mSociety:getSocietyMoney', function(source, cb, societyName)
	local society = mSociety.GetSociety(societyName)

	if society then
		TriggerEvent(mSocietyCFG.AddonAccount, society.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_society:getSocietyMoney', function(source, cb, societyName)
	local society = mSociety.GetSociety(societyName)

	if society then
		TriggerEvent(mSocietyCFG.AddonAccount, society.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

RegisterServerEvent('mSociety:withdrawMoney')
AddEventHandler('mSociety:withdrawMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = mSociety.GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))
	money = ESX.Math.GroupDigits(amount)..""..mSociety.Trad["money_symbol"]

	if xPlayer.job.name == society.name then
		TriggerEvent(mSocietyCFG.AddonAccount, society.account, function(account)
			if amount > 0 and account.money >= amount then
				account.removeMoney(amount)
				xPlayer.addAccountMoney('cash', amount)

				TriggerClientEvent("RageUI:Popup", source, {message= mSociety.Trad["withdrew"].." "..money})
				TriggerEvent("mSociety:SendLogs", source, mSociety.Trad["log_action"], mSociety.Trad["log_withdrew"].." "..money.." \n"..mSociety.Trad["log_company"].." "..society.label) 
			else
				TriggerClientEvent("RageUI:Popup", source, {message= mSociety.Trad["impossible_action"]})
			end
		end)
	else
		print(('mSociety: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('mSociety:depositMoney')
AddEventHandler('mSociety:depositMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = mSociety.GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))
	money = ESX.Math.GroupDigits(amount)..""..mSociety.Trad["money_symbol"]

	if xPlayer.job.name == society.name then
		if amount > 0 and xPlayer.getAccount('cash').money >= amount then
			TriggerEvent(mSocietyCFG.AddonAccount, society.account, function(account)
				xPlayer.removeAccountMoney('cash', amount)
				account.addMoney(amount)
			end)

			TriggerClientEvent("RageUI:Popup", source, {message= mSociety.Trad["deposed"].." "..money})
			TriggerEvent("mSociety:SendLogs", source, mSociety.Trad["log_action"], mSociety.Trad["log_deposed"].." "..money.." \n"..mSociety.Trad["log_company"].." "..society.label) 
		else
			TriggerClientEvent("RageUI:Popup", source, {message= mSociety.Trad["impossible_action"]})
		end
	else
		print(('mSociety: %s attempted to call depositMoney!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('mSociety:washMoney')
AddEventHandler('mSociety:washMoney', function(society, amount, tax)
	local xPlayer = ESX.GetPlayerFromId(source)
	local societyy = mSociety.GetSociety(society)
	local account = xPlayer.getAccount(mSocietyCFG.BlackMoney)
	amount = ESX.Math.Round(tonumber(amount))
	amount2 = ESX.Math.Round(tonumber(amount*tax))
	money = ESX.Math.GroupDigits(amount2)..""..mSociety.Trad["money_symbol"]

	if xPlayer.job.name == society then
		if amount and xPlayer.getAccount(mSocietyCFG.BlackMoney).money >= amount then
			TriggerEvent(mSocietyCFG.AddonAccount, societyy.account, function(sctyacc)
				xPlayer.removeAccountMoney(mSocietyCFG.BlackMoney, amount)
				sctyacc.addMoney(amount2)
				TriggerClientEvent("RageUI:Popup", source, {message= mSociety.Trad["washed"].." "..money})
				TriggerEvent("mSociety:SendLogs", source, mSociety.Trad["log_action"], mSociety.Trad["log_washed"].." "..money.." \n"..mSociety.Trad["log_company"].." "..societyy.label) 
			end)
		else
			TriggerClientEvent("RageUI:Popup", source, {message= mSociety.Trad["impossible_action"]})
		end
	else
		print(('mSociety: %s attempted to call washMoney!'):format(xPlayer.identifier))
	end
end)

local Jobs = {}

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result, 1 do
		Jobs[result[i].name]        = result[i]
		Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2, 1 do
		Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
	end
end)

ESX.RegisterServerCallback('mSociety:getEmployees', function(source, cb, society)

	MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
		['@job'] = society
	}, function (results)
		local employees = {}
		local lbl = nil

		for i=1, #results, 1 do
			if results[i].firstname == nil or results[i].lastname == nil then lbl = results[i].name else lbl = results[i].firstname .. ' ' .. results[i].lastname end
			table.insert(employees, {
				name       = lbl,
				identifier = results[i].identifier,
				job = {
					name        = results[i].job,
					label       = Jobs[results[i].job].label,
					grade       = results[i].job_grade,
					grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
					grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
				}
			})
		end

		cb(employees)
	end)
end)

ESX.RegisterServerCallback('mSociety:getJob', function(source, cb, society)
	local job    = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)

ESX.RegisterServerCallback('mSociety:setJob', function(source, cb, identifier, job, grade)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.job.grade_name == 'boss'

	if isBoss then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if grade ~= tonumber(mSociety.getMaximumGrade(job)) or job == "unemployed" then
			if xTarget then
				xTarget.setJob(job, grade)

				TriggerClientEvent("RageUI:Popup", xTarget, {message=mSociety.Trad["profession_evolved"]})
				TriggerClientEvent("RageUI:Popup", source, {message=mSociety.Trad["modified_profession"]})

				TriggerEvent("mSociety:SendLogs", source, mSociety.Trad["log_action"], mSociety.Trad["log_setjob"].." "..identifier.." --> "..job.." "..grade) 
				cb()
			else
				MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
					['@job']        = job,
					['@job_grade']  = grade,
					['@identifier'] = identifier
				}, function(rowsChanged)
					TriggerClientEvent("RageUI:Popup", source, {message= mSociety.Trad["modified_profession"]})
					TriggerEvent("mSociety:SendLogs", source, mSociety.Trad["log_action"], mSociety.Trad["log_setjob"].." "..identifier.."  -->  "..job.." "..grade) 
					cb()
				end)
			end
		else
			TriggerClientEvent("RageUI:Popup", source, {message=mSociety.Trad["cannot_assign_profession"]})
			cb(false)
		end
	else
		print(('mSociety: %s attempted to setJob'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('mSociety:setJobSalary', function(source, cb, job, grade, salary)
	local isBoss = mSociety.isPlayerBoss(source, job)
	local identifier = ESX.GetPlayerFromId(source).identifier

	if isBoss then
        MySQL.Async.execute('UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade', {
            ['@salary']   = salary,
            ['@job_name'] = job,
            ['@grade']    = grade
        }, function(rowsChanged)
            Jobs[job].grades[tostring(grade)].salary = salary
            local xPlayers = ESX.GetPlayers()

            for i=1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

                if xPlayer.job.name == job and xPlayer.job.grade == grade then
                    xPlayer.setJob(job, grade)
                end
            end

            cb()
        end)
	else
		print(('mSociety: %s attempted to setJobSalary'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('mSociety:isBoss', function(source, cb, job)
	cb(mSociety.isPlayerBoss(source, job))
end)

mSociety.isPlayerBoss = function(playerId, job)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
		return true
	else
		print(('mSociety: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

RegisterServerEvent("mSociety:RequestSetRecruit")
AddEventHandler("mSociety:RequestSetRecruit", function(target, job)
	local xPlayer = ESX.GetPlayerFromId(source)
	local Player = ESX.GetPlayerFromId(ply)
	local society = mSociety.GetSociety(job)

	if xPlayer.job.grade_name == 'boss' then
		TriggerClientEvent("mSociety:SendRequestRecruit", target, society.label, job, source)
		TriggerClientEvent("RageUI:Popup", source, {message=mSociety.Trad["request_sent"]})
	end
end)

RegisterServerEvent("mSociety:SendLogs")
AddEventHandler("mSociety:SendLogs", function(player, title, message)
	local idd = mSociety.GetPlayerDetails(player)

	local _embed = {
		{
			["color"] = mSocietyLOG.Color,
			["title"] = title,
			["description"] = message,
			["footer"] = {
				["text"] = mSocietyLOG.Footer,
				["icon_url"] = mSocietyLOG.Footer_URL,
			},
			["fields"] = {
				{
					["name"] = "**Player:** "..GetPlayerName(player),
					["value"] = idd,
					["inline"] = true
				},
			},
		}
	}

	PerformHttpRequest(mSocietyLOG.Webhooks, function(err, text, headers) end, 'POST', json.encode({
		username = "mSociety", 
		embeds = _embed,
		avatar_url = mSocietyLOG.Avatar
	}), { ['Content-Type'] = 'application/json' })
end)
mSociety.ExtractIdentifiers = function(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

RegisterServerEvent("mSociety:SetJob")
AddEventHandler("mSociety:SetJob", function(job, type, player)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(player)
	if xTarget.job.grade_name == 'boss' then
		xPlayer.setJob(job, 0)
		TriggerClientEvent("RageUI:Popup", source, {message=mSociety.Trad["profession_evolved"]})
		TriggerClientEvent("RageUI:Popup", source, {message= mSociety.Trad["log_recruit"].." "..job})
	end
end)

AddEventHandler('mSociety:getSociety', function(name, cb)
	cb(mSociety.GetSociety(name))
end)