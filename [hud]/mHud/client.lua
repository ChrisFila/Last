local uiFaded = false
local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

	local xPlayer = ESX.GetPlayerData()
	local money, black_money, bank = 0, 0, 0

	for i = 1, #xPlayer.accounts, 1 do
		if xPlayer.accounts[i].name == 'money' then
			money = ESX.Math.GroupDigits(xPlayer.accounts[i].money)
		elseif xPlayer.accounts[i].name == 'black_money' then
			black_money = ESX.Math.GroupDigits(xPlayer.accounts[i].money)
		elseif xPlayer.accounts[i].name == 'bank' then
			bank = ESX.Math.GroupDigits(xPlayer.accounts[i].money)
		end
	end
	while not FirstActivate do 
		Wait(2000)
		SendNUIMessage({
			action = 'setInfos',
			infos = {
				{
					name = 'money',
					value = money
				},
				{
					name = 'black_money',
					value = black_money
				},
				{
					name = 'bank',
					value = bank
				}
			}
		})

		local playerIdHUD = GetPlayerServerId(PlayerId())

		SendNUIMessage({
			action = 'setId',
			value = playerIdHUD
		})
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	local money, black_money, bank = 0, 0, 0

	for i = 1, #xPlayer.accounts, 1 do
		if xPlayer.accounts[i].name == 'money' then
			money = ESX.Math.GroupDigits(xPlayer.accounts[i].money)
		elseif xPlayer.accounts[i].name == 'black_money' then
			black_money = ESX.Math.GroupDigits(xPlayer.accounts[i].money)
		elseif xPlayer.accounts[i].name == 'bank' then
			bank = ESX.Math.GroupDigits(xPlayer.accounts[i].money)
		end
	end

	SendNUIMessage({
		action = 'setInfos',
		infos = {
			{
				name = 'money',
				value = money
			},
			{
				name = 'black_money',
				value = black_money
			},
			{
				name = 'bank',
				value = bank
			}
		}
	})

	local playerIdHUD = GetPlayerServerId(PlayerId())

	SendNUIMessage({
		action = 'setId',
		value = playerIdHUD
	})
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)

	if account.name == 'black_money' then
		SendNUIMessage({
			action = 'setInfos',
			infos = {
				{
					name = 'black_money',
					value = ESX.Math.GroupDigits(account.money)
				}
			}
		})
	elseif account.name == 'bank' then
		SendNUIMessage({
			action = 'setInfos',
			infos = {
				{
					name = 'bank',
					value = ESX.Math.GroupDigits(account.money)
				}
			}
		})
	elseif account.name == 'money' then
		SendNUIMessage({
			action = 'setInfos',
			infos = {
				{
					name = 'money',
					value = ESX.Math.GroupDigits(account.money)
				}
			}
		})
	end
end)

nbPlayerTotal = 0
RegisterNetEvent("ui:update")
AddEventHandler("ui:update", function(nbPlayerTotal)
	SendNUIMessage({
		type = "online-count",
		onlineCount = nbPlayerTotal
	})
end)

AddEventHandler('tempui:toggleUi', function(value)
	uiFaded = value

	if uiFaded then
		SendNUIMessage({action = 'fadeUi', value = true})
	else
		SendNUIMessage({action = 'fadeUi', value = false})
	end
end)

RegisterNUICallback('firstactivate', function()
	FirstActivate = true
end)

Citizen.CreateThread(function()
	local uiComponents = {'infos', 'statuts'}
	local inFrontend = false

	SendNUIMessage({action = 'hideUi', value = false})

	for i = 1, #uiComponents, 1 do
		SendNUIMessage({action = 'hideComponent', component = uiComponents[i], value = false})
	end

	while true do
		Citizen.Wait(250)

		if not uiFaded then
			if IsPauseMenuActive() or IsPlayerSwitchInProgress() then
				if not inFrontend then
					inFrontend = true
					SendNUIMessage({action = 'hideUi', value = true})
				end
			else
				if inFrontend then
					inFrontend = false
					SendNUIMessage({action = 'hideUi', value = false})
				end
			end
		end
	end
end)


--Anti carkill


CreateThread(function()
    while true do 
        local timeToSleep = 200;
        local myCoord = GetEntityCoords(PlayerPedId())
        local closestVeh = GetClosestVehicle(myCoord.x, myCoord.y, myCoord.z, 4.0, 0, 71)
        if closestVeh ~= 0 and closestVeh > 1.0 then
            timeToSleep = 1;
            SetEntityNoCollisionEntity(closestVeh, PlayerPedId(), true)
        end
        Wait(timeToSleep)
    end
end)