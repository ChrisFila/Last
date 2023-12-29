--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

FlashSideGameUtils = {}

--[[FlashSideGameUtils.advancedNotification = function(sender, subject, msg, textureDict, iconType)
    AddTextEntry('AutoEventAdvNotif', msg)
    BeginTextCommandThefeedPost('AutoEventAdvNotif')
    EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
end]]

FlashSideGameUtils.advancedNotification = function(sender, subject, msg, textureDict, iconType)
	exports.iNotificationV3:Send(msg, nil, nil, true, nil, 'FlashSide', 'Logo', 'message')
end

FlashSideGameUtils.playAnim = function(dict, anim, flag, blendin, blendout, playbackRate, duration)
	if blendin == nil then blendin = 1.0 end
	if blendout == nil then blendout = 1.0 end
	if playbackRate == nil then playbackRate = 1.0 end
	if duration == nil then duration = -1 end
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Wait(1) print("Waiting for "..dict) end
	TaskPlayAnim(GetPlayerPed(-1), dict, anim, blendin, blendout, duration, flag, playbackRate, 0, 0, 0)
	RemoveAnimDict(dict)
end	

FlashSideGameUtils.tp = function(x,y,z)
	SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false)
end

FlashSideGameUtils.warnVariator = "~r~"
FlashSideGameUtils.dangerVariator = "~r~"

FlashSide.newRepeatingTask(function()
	if FlashSideGameUtils.warnVariator == "~r~" then FlashSideGameUtils.warnVariator = "~s~" else FlashSideGameUtils.warnVariator = "~r~" end
	if FlashSideGameUtils.dangerVariator == "~r~" then FlashSideGameUtils.dangerVariator = "~o~" else FlashSideGameUtils.dangerVariator = "~r~" end
end, nil, 0,650)

local NumberCharset = {}
local Charset = {}

for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end
for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

FlashSideGameUtils.GetRandomNumber = function(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

FlashSideGameUtils.GetRandomLetter = function(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

FlashSideGameUtils.GeneratePlate = function()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))

		ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

FlashSide.netRegisterAndHandle("teleport", FlashSideGameUtils.tp)

FlashSide.netRegisterAndHandle("advancedNotif", FlashSideGameUtils.advancedNotification)