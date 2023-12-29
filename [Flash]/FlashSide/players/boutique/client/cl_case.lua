ESX = {};


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(10)
    end
end)

local picture;
local openedVisualCase = false
RMenu.Add('case', 'main', FlashSideUI.CreateMenu("", ""))
RMenu:Get('case', 'main'):SetSubtitle("Caisse de FlashSide")
RMenu:Get('case', 'main').Closed = function()
    openedVisualCase = false
    picture = nil
end

RegisterNetEvent('tebex:on-open-case')
AddEventHandler('tebex:on-open-case', function(animations, name, message)
    openVisualCase()
    Citizen.CreateThread(function()
        Citizen.Wait(250)
        for k, v in pairs(animations) do
            picture = v.name
            FlashSideUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
            if v.time == 5000 then
                FlashSideUI.PlaySound("HUD_AWARDS", "FLIGHT_SCHOOL_LESSON_PASSED")
                ESX.ShowAdvancedNotification('Boutique', 'Informations', message, 'CHAR_SEALIFE', 6, 2)
                Wait(4000)
            end
            Citizen.Wait(v.time)
        end
    end)
   --if name == "tribike" or name == "weevil" or name == "blazer" or name == "patriot2" or name == "tmax" or name == "bodhi2" or name == "sanchez2" or name == "ratloader2" or name == "peyote2" or name == "pounder" or name == "avisa" or name == "longfin" or name == "openwheel1" or name == "rrst" or name == "2f2fgtr34" or name == "2f2fgts" or name == "2f2fmk4" or name == "2f2fmle7" or name == "ff4wrx" or name == "fnf4r34" or name == "fnflan" or name == "fnfmits" or name == "fnfrx7" then
   --    TriggerEvent("core:RequestGivecar",name)
   --end
end)
function openVisualCase()
    if openedVisualCase then
        FlashSideUI.Visible(RMenu:Get('case', 'main'), false)
        openedVisualCase = false
        return
    else
        openedVisualCase = true
        FlashSideUI.Visible(RMenu:Get('case', 'main'), true)
        Citizen.CreateThread(function()
            while openedVisualCase do
                Citizen.Wait(1.0)
                FlashSideUI.IsVisible(RMenu:Get('case', 'main'), true, false, true, function()
                    if (picture) then
                        FlashSideUI.RenderCaisse("case", picture)
                    end
                end)
            end
        end)
    end
end

local NumberCharset = {}
local Charset = {}
local PlateLetters  = 3
local PlateNumbers  = 3
local PlateUseSpace = true

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		if PlateUseSpace then
			generatedPlate = string.upper(GetRandomNumber(2) .. GetRandomLetter(3) .. GetRandomNumber(3))
			--generatedPlate = string.upper(GetRandomLetter(PlateLetters) .. ' ' .. GetRandomNumber(PlateNumbers))
		else
			generatedPlate = string.upper(GetRandomNumber(2) .. GetRandomLetter(3) .. GetRandomNumber(3))
		end

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

-- mixing async with sync tasks
function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end
RegisterNetEvent("core:RequestGivecar")
AddEventHandler("core:RequestGivecar", function(model)
    ESX.Game.SpawnVehicle(model, vector3(0, 0, 0), nil, function(vehicle)
        local newPlate = GeneratePlate()
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        vehicleProps.plate = newPlate
        SetVehicleNumberPlateText(vehicle, newPlate)
        TriggerServerEvent("esx_vehicleshop:setVehicleOwned", vehicleProps)
    end)
end)