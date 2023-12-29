---@author Pablo Z.
---@version 1.0
--[[
  This file is part of FlashSide RolePlay.
  
  File [main] created at [11/05/2021 20:34]

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

FlashSideSRobberiesManager = {}
FlashSideSRobberiesManager.list = {}
FlashSideSRobberiesManager.players = {}

FlashSide.netHandle("esxloaded", function()
    for id, robberyInfos in pairs(FlashSideSharedRobberies) do
        ---@type Robbery
        local robbery = Robbery(id,robberyInfos)
        FlashSideSRobberiesManager.list[id] = robbery
    end
end)

FlashSide.netRegisterAndHandle("robberiesStart", function(id, xPlayers)
    local _src = source
	local xPlayer  = ESX.GetPlayerFromId(_src)
	local xPlayers = ESX.GetPlayers()
    ---@type Robbery
    local cops = 0
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end

    if not rob then
        if cops >= 1 then
            rob = true

            --[[for i=1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if xPlayer.job.name == 'police' then
                    --TriggerClientEvent('esx:showNotification', xPlayers[i], 'Robberie')
                    --TriggerClientEvent('robberies:setBlip', xPlayers[i], FlashSideSharedRobberies.entry)
                end
            end]]

                local robbery = FlashSideSRobberiesManager.list[id]
                robbery:handleStart(_src)
        else
			TriggerClientEvent('esx:showNotification', _src, 'Pas de policier !')
        end
    end
end)

FlashSide.netRegisterAndHandle("robberiesDiedDuring", function()
    local _src = source
    local xPlayers = ESX.GetPlayers()
	rob = false

	--for i=1, #xPlayers, 1 do
		--local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

            local robbery = FlashSideSRobberiesManager.list[FlashSideSRobberiesManager.players[_src].id]
            robbery:exitRobbery(_src, true)
            --TriggerClientEvent('robberies:killBlip', xPlayers[i])
    --end
end)

FlashSide.netRegisterAndHandle("robberiesAddItem", function(itemTable)
    local _src = source
    if not FlashSideSRobberiesManager.players[_src] then
        --@TODO -> Faire une liste d'error
        DropPlayer(_src, "Une erreur est survenue, contactez un staff, Erreur: 16489")
        return
    end
    table.insert(FlashSideSRobberiesManager.players[_src].bag, itemTable)
end)