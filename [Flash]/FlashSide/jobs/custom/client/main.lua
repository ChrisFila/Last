ESX = nil
--local rgbArray = {}
local Vehicles = {}
local PlayerData = {}
local lsMenuIsShowed = false
local isInLSMarker = false
local myCar = {}
local vehicleClass = nil
local vehiclePrice = 150000

local shopProfitValue = 0
local shopProfit = cfg_custom.shopProfit['mecano']
local shopCosts = 100 - shopProfit
local shopReductionValue = 0
local shopReduction = 0
local shopCart = {}
local totalCartValue = 0
local canClose = false
local society = ""
local stop = false
local deleting = false
local autoInvoice = false

local mainMenu = nil 
local bodyMenu = nil
local extrasMenu = nil
local colorMenu = nil
local neonMenu = nil
local upgradeMenu = nil
local cartMenu = nil

local tempBodyParts = nil
local tempExtras = nil
local tempColorParts = nil
local tempNeons = nil
local tempUpgrades = nil

local bodyPartIndex = {
	[1] = { modSpoilers = 1 },
	[2] = { modFrontBumper = 1 },
	[3] = { modRearBumper = 1 },
	[4] = { modSideSkirt = 1 },
	[5] = { modExhaust = 1 },
	[6] = { modGrille = 1 },
	[7] = { modHood = 1 },
	[8] = { modFender = 1 },
	[9] = { modRightFender = 1 },
	[10] = { modRoof = 1 },
	[11] = { modArmor = 1 },
	[12] = { wheels = 1 },
	[13] = { modFrontWheels = 1 },
}

local extrasIndex = {
	[1] = { modPlateHolder = 1 },
	[2] = { modVanityPlate = 1 },
	[3] = { modTrimA = 1 },
	[4] = { modOrnaments = 1 },
	[5] = { modDashboard = 1 },
	[6] = { modDial = 1 },
	[7] = { modDoorSpeaker = 1 },
	[8] = { modSeats = 1 },
	[9] = { modSteeringWheel = 1 },
	[10] = { modShifterLeavers = 1 },
	[11] = { modAPlate = 1 },
	[12] = { modSpeakers = 1 },
	[13] = { modTrunk = 1 },
	[14] = { modHydrolic = 1 },
	[15] = { modEngineBlock = 1 },
	[16] = { modAirFilter = 1 },
	[17] = { modStruts = 1 },
	[18] = { modArchCover = 1 },
	[19] = { modAerials = 1 },
	[20] = { modTrimB = 1 },
	[21] = { modTank = 1 },
	[22] = { modWindows = 1 },
	[23] = { modLivery = 1 },
	[24] = { modHorns = 1 },
}

local windowTintIndex = 1
local colorPartIndex = 1 
local colorTypeIndex = {
	[1] = 1,
	[2] = 1,
	[3] = 1,
	[5] = 1,	
}
local primaryColorIndex = 1
local newPrimaryColorIndex = 1
local newPrimaryColorDetailsIndex = 1
local newSecondaryColorIndex = 1
local newSecondaryColorDetailsIndex = 1
local newInteriorColorIndex = 1
local newInteriorColorDetailsIndex = 1
local newPearlescentColorIndex = 1
local newPearlescentColorDetailsIndex = 1
local newWheelColorIndex = 1
local newWheelColorDetailsIndex = 1
local secondaryColorIndex = 1
local interiorColorIndex = 1
local pearlColorIndex = 1
local newPlateIndex = 1
local plateIndex = 1
local primaryCustomColorIndex = { 
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}
local secondaryCustomColorIndex = { 
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}
local interiorCustomColorIndex = { 
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}
local primaryPaintFinishIndex = 1
local secondaryPaintFinishIndex = 1
local interiorPaintFinishIndex = 1
local wheelColorIndex = 1
local tyreSmokeActive = false
local smokeColorIndex = {
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}
local xenonActive = false
local xenonColorIndex = 1

local neonIndex = {
	[1] = { leftNeon = false },
	[2] = { frontNeon = false },
	[3] = { rightNeon = false },
	[4] = { backNeon = false },
	[5] = { r = 0, g = 0, b = 0 },
}
local neonIndex = { 
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}

local neon1 = false
local neon2 = false
local neon3 = false
local neon4 = false

local upgradeIndex = {
	[1] = { modArmor = 1 },
	[2] = { modEngine = 1 },
	[3] = { modTransmission = 1 },
	[4] = { modBrakes = 1 },
	[5] = { modSuspension = 1 },
	[6] = { modTurbo = false },
}

local vehPedIsIn = nil
local vehModsOld = nil
local vehModsNew = nil
local interiorColorOld = nil
local interiorColorNew = nil
local partsCart = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	resetMenu() --menu startup

	ESX.TriggerServerCallback('fpwn_customs:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	resetMenu() --trigger menu restart on job change

	ESX.TriggerServerCallback('fpwn_customs:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

function resetMenu()
	if not mainMenu and PlayerData.job then
		--local resW, resH = GetResolution()
		if PlayerData.job.name == 'mecano' then
			mainMenu = RageUI.CreateMenu("", "~r~Benny's")
			society = 'society_mecano'
		elseif PlayerData.job.name == 'lscustom' then
			mainMenu = RageUI.CreateMenu("", "~r~LS Custom")
			society = 'society_lscustom'
		end

		if not mainMenu then
			--print("ERROR CREATING JOB MENU!!")
		else
			mainMenu.EnableMouse = false
			mainMenu.Closed = function()
				print('closed lsmenu')
				lsMenuIsShowed = false
				SetVehicleDoorsShut(vehPedIsIn, false)
				if not canClose then
					TriggerEvent('fpwn_customs:resetVehicle', vehModsOld)
				end
			end
		end
	end
end

function CreateLSMenu()
	if not bodyMenu then
		bodyMenu = RageUI.CreateSubMenu(mainMenu, "", "Gestion de la carosserie")
		bodyMenu.EnableMouse = false
		bodyMenu.Closed = function()
			print('closed bodyMenu')
		end
	end
	if not extrasMenu then
		extrasMenu = RageUI.CreateSubMenu(mainMenu, "", "Gestion des extras")
		extrasMenu.EnableMouse = false
		extrasMenu.Closed = function()
			print('closed extrasMenu')
			SetVehicleDoorsShut(vehPedIsIn, false)
		end
	end
	if not colorMenu then
		colorMenu = RageUI.CreateSubMenu(mainMenu, "", "Gestion des couleurs")
		colorMenu.EnableMouse = false
		colorMenu.Closed = function()
			print('closed colorMenu')
		end
	end
	if not neonMenu then
		neonMenu = RageUI.CreateSubMenu(mainMenu, "", "Gestion des neons")
		neonMenu.EnableMouse = false
		neonMenu.Closed = function()
			print('closed neonMenu')
		end
	end
	if not upgradeMenu then
		upgradeMenu = RageUI.CreateSubMenu(mainMenu, "", "Gestion des ameliorations")
		upgradeMenu.EnableMouse = false
		upgradeMenu.Closed = function()
			print('closed neonMenu')
		end
	end
	if not cartMenu then
		cartMenu = RageUI.CreateSubMenu(mainMenu, "", "Liste des achats")
		cartMenu.EnableMouse = false
		cartMenu.Closed = function()
			print('closed cartMenu')
		end
	end
end

function getCarPrice()
	local onVehList = false
	if vehPedIsIn then
		for i = 1, #cfg_custom.Vehicles, 1 do
			if GetEntityModel(vehPedIsIn) == GetHashKey(cfg_custom.Vehicles[i].model) then
				onVehList = true
				vehiclePrice = cfg_custom.Vehicles[i].price
				break
			end
		end
		if not onVehList then
			vehiclePrice = 150000
		end
	end
end

--REFRESH INDEXES
function RefreshBodyPartIndex()
	for k, v in pairs(vehModsOld) do
		--print("k: " .. k)
		for i = 1, #tempBodyParts, 1 do
			if k == tempBodyParts[i]['mod'] then
				--print("cfg_custom: " .. tempBodyParts[i]['mod'])
				bodyPartIndex[i][k] = v + (tempBodyParts[i]['mod'] ~= 'wheels' and 2 or 1)
				break
			end
		end
	end
end

function RefreshExtrasIndex()
	for k, v in pairs(vehModsOld) do
		for i = 1, #tempExtras, 1 do
			if k == tempExtras[i]['mod'] then
				extrasIndex[i][k] = v + 2
				break
			end
		end
	end
end

function RefreshPaintIndex()
	windowTintIndex = vehModsOld['windowTint'] + 2
	--colorPartIndex = 1 
	for i = 1, #cfg_custom.colorPalette - 2, 1 do
		for k, v in pairs(cfg_custom.colorPalette[i]) do
			for x = 1, #v, 1 do
				if vehModsOld['color1'] == v[x] then
					colorTypeIndex[1] = vehModsOld['hasCustomColorPrimary'] == 1 and 7 or i
					primaryPaintFinishIndex = i
					primaryColorIndex = x
				end
				if vehModsOld['color2'] == v[x] then
					colorTypeIndex[2] = vehModsOld['hasCustomColorSecondary'] == 1 and 7 or i
					secondaryPaintFinishIndex = i
					secondaryColorIndex = x
				end
				if vehModsOld['pearlescentColor'] == v[x] then
					colorTypeIndex[3] = i
					pearlColorIndex = x
				end
				if interiorColorOld == v[x] then
					colorTypeIndex[5] = i
					interiorColorIndex = x
				end
				
				if vehModsOld['wheelColor'] == v[x] then
					wheelColorIndex = x
				end
			end
		end
	end
	if vehModsOld['hasCustomColorPrimary'] == 1 then
		primaryCustomColorIndex[1]['index'] = vehModsOld['customColorPrimary'][1]
		primaryCustomColorIndex[2]['index'] = vehModsOld['customColorPrimary'][2]
		primaryCustomColorIndex[3]['index'] = vehModsOld['customColorPrimary'][3]
	end
	if vehModsOld['hasCustomColorSecondary'] == 1 then
		secondaryCustomColorIndex[1]['index'] = vehModsOld['customColorSecondary'][1]
		secondaryCustomColorIndex[2]['index'] = vehModsOld['customColorSecondary'][2]
		secondaryCustomColorIndex[3]['index'] = vehModsOld['customColorSecondary'][3]
	end
	if vehModsOld['hasCustomColorInterior'] == 1 then
		interiorCustomColorIndex[1]['index'] = vehModsOld['customColorInterior'][1]
		interiorCustomColorIndex[2]['index'] = vehModsOld['customColorInterior'][2]
		interiorCustomColorIndex[3]['index'] = vehModsOld['customColorInterior'][3]
	end
	tyreSmokeActive = vehModsOld['modSmokeEnabled'] and true or false
	if tyreSmokeActive then
		smokeColorIndex[1]['index'] = vehModsOld['tyreSmokeColor'][1]
		smokeColorIndex[2]['index'] = vehModsOld['tyreSmokeColor'][2]
		smokeColorIndex[3]['index'] = vehModsOld['tyreSmokeColor'][3]
	end
	xenonActive = vehModsOld['modXenon'] and true or false
	--if xenonActive then
	--	xenonColorIndex = vehModsOld['xenonColor'] + 2
	--end
end

function RefreshNeonIndex()
	--[[
		0 = Left
		2 = Front
		1 = Right
		3 = Back
	--]]
	neon1 = vehModsOld['neonEnabled'][1] and true or false
	neon2 = vehModsOld['neonEnabled'][2] and true or false
	neon3 = vehModsOld['neonEnabled'][3] and true or false
	neon4 = vehModsOld['neonEnabled'][4] and true or false
	neonIndex[1]['index'] = vehModsOld['neonColor'][1]
	neonIndex[2]['index'] = vehModsOld['neonColor'][2]
	neonIndex[3]['index'] = vehModsOld['neonColor'][3]
end

function RefreshUpgradeIndex()
	for k, v in pairs(vehModsOld) do 
		for i = 1, #tempUpgrades, 1 do
			if k == tempUpgrades[i]['mod'] and tempUpgrades[i]['modType'] ~= 18 then
				upgradeIndex[i][k] = v + 2
				break
			elseif k == tempUpgrades[i]['mod'] and tempUpgrades[i]['modType'] == 18 then
				upgradeIndex[i][k] = v and true or false
				break
			end
		end
	end
end

--RESET ITEM LISTS
function ResetBodyPartItems()
	if tempBodyParts then
		for i = 1, #tempBodyParts, 1 do
			if i ~= 12 then
				for x = 1, #tempBodyParts[i]['items']['label'] do
				    tempBodyParts[i]['items']['label'][x] = nil
				end
			end
		end
	end
end

function ResetWheelItems()
	if tempBodyParts then
		for x = 1, #tempBodyParts[13]['items']['label'] do
		    tempBodyParts[13]['items']['label'][x] = nil
		end
	end
end

function ResetExtraItems()
	if tempExtras then
		for i = 1, #tempExtras, 1 do
			for x = 1, #tempExtras[i]['items']['label'] do
			    tempExtras[i]['items']['label'][x] = nil
			end
		end
	end
end

function ResetPaintItems()
	windowTintIndex = 1
	colorPartIndex = 1 
	colorTypeIndex[1] = 1
	colorTypeIndex[2] = 1
	colorTypeIndex[3] = 1
	primaryColorIndex = 1
	secondaryColorIndex = 1
	interiorColorIndex = 1
	primaryCustomColorIndex[1]['index'] = 0
	primaryCustomColorIndex[2]['index'] = 0
	primaryCustomColorIndex[3]['index'] = 0
	secondaryCustomColorIndex[1]['index'] = 0
	secondaryCustomColorIndex[2]['index'] = 0
	secondaryCustomColorIndex[3]['index'] = 0
	interiorCustomColorIndex[1]['index'] = 0
	interiorCustomColorIndex[2]['index'] = 0
	interiorCustomColorIndex[3]['index'] = 0
	primaryPaintFinishIndex = 1
	secondaryPaintFinishIndex = 1
	interiorPaintFinishIndex = 1
	pearlColorIndex = 1
	wheelColorIndex = 1
	tyreSmokeActive = false
	smokeColorIndex[1]['index'] = 0
	smokeColorIndex[2]['index'] = 0
	smokeColorIndex[3]['index'] = 0
	xenonActive = false
	xenonColorIndex = 1
end

function ResetNeonItems()
	neon1 = false
	neon2 = false
	neon3 = false
	neon4 = false
	neonIndex[1]['index'] = 0
	neonIndex[2]['index'] = 0
	neonIndex[3]['index'] = 0
end

function ResetUpgradeItems()
	if tempUpgrades then
		for i = 1, #tempUpgrades, 1 do
			for x = 1, #tempUpgrades[i]['items']['label'] do
			    tempUpgrades[i]['items']['label'][x] = nil
			end
		end
	end
end

--BUILD ITEM LISTS
function BuildBodyPartsLabel()
	local modCount = 0
	local modName = ""
	local label = ""
	for i = 1, #tempBodyParts, 1 do
		modCount = GetNumVehicleMods(vehPedIsIn, tempBodyParts[i]['modType'])
		if modCount > 0 and i < 12 then
			for x = 1, modCount, 1 do
				--[[modName = GetModTextLabel(vehPedIsIn, tempBodyParts[i]['modType'], x)
				label = GetLabelText(modName)
				if label == "NULL" then
					label = "Custom " .. tempBodyParts[i]['label']
				end
				if #label > 10 then
					label = label:sub(1, 10)
					print("label cut: " .. label)
				end--]]
				if x == 1 then
					--table.insert(tempBodyParts[i]['items']['label'], "Stock " .. label .. " [" .. x .. "/" .. modCount + 1 .. "]")
					table.insert(tempBodyParts[i]['items']['label'], "[" .. x .. "/" .. modCount + 1 .. "]")
				end
				--label = label .. " [" .. x + 1 .. "/" .. modCount + 1 .. "]"
				label = "[" .. x + 1 .. "/" .. modCount + 1 .. "]"
				table.insert(tempBodyParts[i]['items']['label'], label)
			end
		end
	end
end

function BuildWheelsLabel()
	local modCount = GetNumVehicleMods(vehPedIsIn, tempBodyParts[13]['modType'])
	if modCount > 0 then
		for x = 1, modCount, 1 do
			if x == 1 then
				table.insert(tempBodyParts[13]['items']['label'], "[" .. x .. "/" .. modCount + 1 .. "]")
			end
			label = "[" .. x + 1 .. "/" .. modCount + 1 .. "]"
			table.insert(tempBodyParts[13]['items']['label'], label)
		end
	end
end

function BuildExtrasLabel()
	local modCount = 0
	local modName = ""
	local label = ""
	for i = 1, #tempExtras, 1 do
		modCount = GetNumVehicleMods(vehPedIsIn, tempExtras[i]['modType'])
		if modCount > 0 then
			for x = 1, modCount, 1 do
				--[[modName = GetModTextLabel(vehPedIsIn, tempExtras[i]['modType'], x)
				label = GetLabelText(modName)
				if label == "NULL" then
					label = "Custom " .. tempExtras[i]['label']
				end--]]
				if x == 1 then
					--table.insert(tempExtras[i]['items']['label'], "Stock " .. label .. " [" .. x .. "/" .. modCount + 1 .. "]")
					table.insert(tempExtras[i]['items']['label'], "[" .. x .. "/" .. modCount + 1 .. "]")
				end
				--label = label .. " [" .. x + 1 .. "/" .. modCount + 1 .. "]"
				label = "[" .. x + 1 .. "/" .. modCount + 1 .. "]"
				table.insert(tempExtras[i]['items']['label'], label)
			end
		end
	end
end

function BuildUpgradesLabel()
	local modCount = 0
	local modName = ""
	local label = ""
	for i = 1, #tempUpgrades, 1 do
		modCount = GetNumVehicleMods(vehPedIsIn, tempUpgrades[i]['modType'])
		if modCount > 0 then
			for x = 1, modCount, 1 do
				--[[modName = GetModTextLabel(vehPedIsIn, tempUpgrades[i]['modType'], x)
				label = GetLabelText(modName)--]]
				--[[if label == "NULL" then
					label = "Custom " .. tempUpgrades[i]['label']
				end--]]
				if x == 1 then
					--local label1 = tempUpgrades[i]['label']
					--table.insert(tempUpgrades[i]['items']['label'], "Stock " .. label1 .. " [" .. x .. "/" .. modCount + 1 .. "]")
					table.insert(tempUpgrades[i]['items']['label'], "[" .. x .. "/" .. modCount + 1 .. "]")
				end
				--label = label .. " [" .. x + 1 .. "/" .. modCount + 1 .. "]"
				label = "[" .. x + 1 .. "/" .. modCount + 1 .. "]"
				table.insert(tempUpgrades[i]['items']['label'], label)
			end
		end
	end
end

function addToCart(label, mod, modType, index, price)
	local item = findKey(shopCart, mod)
	if item then
		shopCart[mod]['label'] = label
		shopCart[mod]['modType'] = modType
		shopCart[mod]['index'] = index
		shopCart[mod]['price'] = price
	else
		item = { label = label, modType = modType, index = index, price = price }
		shopCart[mod] = item
	end
	calcCartValue()
end

function removeFromCart(mod)
	local item = findKey(shopCart, mod)
	if item then
		shopCart[mod] = nil
		calcCartValue()
	end
end

function calcCartValue()
	shopProfitValue = 0
	totalCartValue = 0
	for k, v in pairs(shopCart) do
		--print("k: " .. k)
		--print("v['price']: " .. v['price'])
		totalCartValue = math.round(totalCartValue + v['price'])
	end
	shopCosts = 100 - shopProfit
	shopReductionValue = math.round(totalCartValue * (shopReduction / 100))
	totalWithReduction = math.round(totalCartValue - shopReductionValue)
	shopProfitValue = math.round(totalWithReduction * (shopProfit / 100))
	shopCostValue = math.round(totalWithReduction * (shopCosts / 100))
end

local dev = false
function finishPurchase()
	local vehModsNew = ESX.Game.GetVehicleProperties(vehPedIsIn)
	local primaryColorNew = GetVehicleCustomPrimaryColour(vehPedIsIn)
	if not dev then
		--passar fatura
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		local playerId =  GetPlayerServerId(closestPlayer)
		if (closestPlayer ~= -1 and closestDistance <= 3.0) or autoInvoice then
			TriggerServerEvent('fpwn_customs:finishPurchase', society, vehModsNew, shopCart, playerId, shopProfit, shopReduction, autoInvoice)
		else
			-- Pas de joueur proche
		end
	else
		terminatePurchase()
	end
end

function terminatePurchase()
	for k, v in pairs(shopCart) do
		shopCart[k] = nil
	end
	if lsMenuIsShowed then
		RageUI.CloseAll()
	end
	lsMenuIsShowed = false
	stop = false
	vehModsOld = nil
end

function compareMods(label, mod, modType, index, price)
	local vehModsNew = ESX.Game.GetVehicleProperties(vehPedIsIn)
	local interiorColorNew = GetVehicleInteriorColour(vehPedIsIn)
	if (mod ~= 'neonColor' and mod ~= 'tyreSmokeColor' and mod ~= 'customColorPrimary' and mod ~= 'customColorSecondary' and vehModsOld[mod] ~= vehModsNew[mod]) or 
		--apenas ligar neons
		(mod == 'leftNeon' and not vehModsOld['neonEnabled'][1] and vehModsNew['neonEnabled'][1]) or 
		(mod == 'rightNeon' and not vehModsOld['neonEnabled'][2] and vehModsNew['neonEnabled'][2]) or 
		(mod == 'frontNeon' and not vehModsOld['neonEnabled'][3] and vehModsNew['neonEnabled'][3]) or 
		(mod == 'backNeon' and not vehModsOld['neonEnabled'][4] and vehModsNew['neonEnabled'][4]) or
		--mudar cor da neon
		(mod == 'neonColor' and (vehModsOld['neonColor'][1] ~= vehModsNew['neonColor'][1] or vehModsOld['neonColor'][2] ~= vehModsNew['neonColor'][2] or vehModsOld['neonColor'][3] ~= vehModsNew['neonColor'][3])) or
		(mod == 'tyreSmokeColor' and (vehModsOld['tyreSmokeColor'][1] ~= vehModsNew['tyreSmokeColor'][1] or vehModsOld['tyreSmokeColor'][2] ~= vehModsNew['tyreSmokeColor'][2] or vehModsOld['tyreSmokeColor'][3] ~= vehModsNew['tyreSmokeColor'][3])) or
		--(mod == 'xenonColor' and vehModsOld['xenonColor'] ~= vehModsNew['xenonColor']) or
		(mod == 'interior' and interiorColorOld ~= interiorColorNew)or
		(mod == 'plateIndex' and plateIndex ~= newPlateIndex)
		-- (mod == 'customColorPrimary' and (vehModsOld['customColorPrimary'][1] ~= vehModsNew['customColorPrimary'][1] or 
		-- vehModsOld['customColorPrimary'][2] ~= vehModsNew['customColorPrimary'][2] or 
		-- vehModsOld['customColorPrimary'][3] ~= vehModsNew['customColorPrimary'][3])) 
		-- or 
		-- (mod == 'customColorSecondary' and (vehModsOld['customColorSecondary'][1] ~= vehModsNew['customColorSecondary'][1] or vehModsOld['customColorSecondary'][2] ~= vehModsNew['customColorSecondary'][2] or vehModsOld['customColorSecondary'][3] ~= vehModsNew['customColorSecondary'][3]))
		 then

		addToCart(label, mod, modType, index, price)
		if mod == 'customColorPrimary' then
			removeFromCart('color1')
		elseif mod == 'customColorSecondary' then
			removeFromCart('color2')
		elseif mod == 'color1' then 
			removeFromCart('customColorPrimary')
		elseif mod == 'interior' then
			removeFromCart('interior')
		elseif mod == 'color2' then
			removeFromCart('customColorSecondary')
		end
	else
		print('removed: ' .. mod)
		if (mod == 'leftNeon' and not vehModsNew['neonEnabled'][1]) and 
			(mod == 'rightNeon' and not vehModsNew['neonEnabled'][2]) and 
			(mod == 'frontNeon' and not vehModsNew['neonEnabled'][3]) and 
			(mod == 'backNeon' and not vehModsNew['neonEnabled'][4]) then

			removeFromCart('neonColor')
		elseif mod == 'modSmokeEnabled' then
			removeFromCart('tyreSmokeColor')
		elseif mod == 'modXenon' then
			removeFromCart('xenonColor')
		end
		removeFromCart(mod)
	end
end

function calcModPrice(parcel)
	local val = 0
	local basePrice = 30000
	if 50000 > vehiclePrice then
		basePrice = 10000
	elseif 50000 <= vehiclePrice and vehiclePrice <= 100000 then
		basePrice = 20000
	elseif 100000 < vehiclePrice then
		basePrice = 30000
	end
	val = math.round((basePrice * (parcel / 100)) * 2)
	return val
end

function DeleteFromCart(k, modType)
	print('delete')
	local vehModsNew = ESX.Game.GetVehicleProperties(vehPedIsIn)
	local interiorColorNew = GetVehicleInteriorColour(vehPedIsIn)
	if modType == -1 then
		if k == 'customColorPrimary' then
			if vehModsOld['hasCustomColorPrimary'] == 1 then
				SetVehicleCustomPrimaryColour(vehicle, vehModsOld['customColorPrimary'][1], vehModsOld['customColorPrimary'][2], vehModsOld['customColorPrimary'][3])
			else
				ClearVehicleCustomPrimaryColour(vehPedIsIn)
			end
		elseif k == 'customColorSecondary' then
			if vehModsOld['hasCustomColorSecondary'] == 1 then
				SetVehicleCustomSecondaryColour(vehicle, vehModsOld['customColorSecondary'][1], vehModsOld['customColorSecondary'][2], vehModsOld['customColorSecondary'][3])
			else
				ClearVehicleCustomSecondaryColour(vehPedIsIn)
			end
		elseif k == 'primaryPaintFinish' then
			SetVehicleColours(vehPedIsIn, vehModsOld['color1'], vehModsNew['color2'])
		elseif k == 'secondaryPaintFinish' then 
			SetVehicleColours(vehPedIsIn, vehModsNew['color1'], vehModsOld['color2'])
		elseif k == 'interiorPaintFinish' then 
			SetVehicleInteriorColour(vehPedIsIn, interiorColorNew);
		elseif k == 'color1' then
			SetVehicleColours(vehPedIsIn, vehModsOld['color1'], vehModsNew['color2'])
		elseif k == 'color2' then 
			SetVehicleColours(vehPedIsIn, vehModsNew['color1'], vehModsOld['color2'])
		elseif k == 'interior' then 
			SetVehicleInteriorColour(vehPedIsIn, interiorColorNew);
		elseif k == 'pearlescentColor' then
			SetVehicleExtraColours(vehPedIsIn, vehModsOld['pearlescentColor'], vehModsNew['wheelColor'])
		elseif k == 'wheelColor' then
			SetVehicleExtraColours(vehPedIsIn, vehModsNew['pearlescentColor'], vehModsOld['wheelColor'])
		elseif k == 'windowTint' then
			SetVehicleWindowTint(vehPedIsIn, vehModsOld['windowTint'])
		elseif k == 'tyreSmokeColor' then
			SetVehicleTyreSmokeColor(vehPedIsIn, vehModsOld['tyreSmokeColor'][1], vehModsOld['tyreSmokeColor'][2], vehModsOld['tyreSmokeColor'][3])
		--elseif k == 'xenonColor' then
		--	SetVehicleXenonLightsColour(vehPedIsIn, vehModsOld['xenonColor'])
		elseif k == 'neonColor' then
			SetVehicleNeonLightsColour(vehPedIsIn, vehModsOld['neonColor'][1], vehModsOld['neonColor'][2], vehModsOld['neonColor'][3])
		elseif k == 'leftNeon' then
			SetVehicleNeonLightEnabled(vehPedIsIn, 0, vehModsOld['neonEnabled'][1])
		elseif k == 'rightNeon' then
			SetVehicleNeonLightEnabled(vehPedIsIn, 1, vehModsOld['neonEnabled'][2])
		elseif k == 'frontNeon' then
			SetVehicleNeonLightEnabled(vehPedIsIn, 2, vehModsOld['neonEnabled'][3])
		elseif k == 'backNeon' then
			SetVehicleNeonLightEnabled(vehPedIsIn, 3, vehModsOld['neonEnabled'][4])
		end
	else
		--[[if k == 'modTurbo' or k == 'modSmokeEnabled' or k == 'modXenon' then
			print("vehModsOld[k]: " .. tostring(vehModsOld[k]))
			print("modType: " .. modType)
			if vehModsOld[k] or vehModsOld[k] == 1 then
				ToggleVehicleMod(vehPedIsIn, modType, true)
			elseif not vehModsOld[k] or vehModsOld[k] == 0 then
				ToggleVehicleMod(vehPedIsIn, modType, false)
			end--]]
		if k == 'modTurbo' or k == 'modSmokeEnabled' or k == 'modXenon' then
			if vehModsOld[k] or vehModsOld[k] == 1 then
				ToggleVehicleMod(vehPedIsIn, modType, true)
			elseif not vehModsOld[k] or vehModsOld[k] == 0 then
				ToggleVehicleMod(vehPedIsIn, modType, false)
			end
			removeFromCart('modTurbo')
			removeFromCart('modSmokeEnabled')
			removeFromCart('modXenon')
		elseif k == 'modLivery' then
			SetVehicleMod(vehPedIsIn, modType, vehModsOld['modLivery'], false)
			SetVehicleLivery(vehPedIsIn, vehModsOld['modLivery'])
		elseif k == 'wheels' or k == 'modFrontWheels' then
			print("PASSEICI")
			SetVehicleWheelType(vehPedIsIn, vehModsOld['wheels'])
            SetVehicleMod(vehPedIsIn, 23, vehModsOld['modFrontWheels'], false)
            SetVehicleMod(vehPedIsIn, 24, vehModsOld['modFrontWheels'], false)
		else
			SetVehicleMod(vehPedIsIn, modType, vehModsOld[k], false)
		end
	end
	removeFromCart(k)
	--refresh indexes
	RefreshBodyPartIndex()
	RefreshExtrasIndex()
	RefreshPaintIndex()
	RefreshNeonIndex()
	RefreshUpgradeIndex()
	deleting = false
end

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		
		if IsPedInAnyVehicle(playerPed, false) then
			if not vehPedIsIn and isInLSMarker then
				vehPedIsIn = GetVehiclePedIsIn(playerPed, false)
				vehModsOld = ESX.Game.GetVehicleProperties(vehPedIsIn)
				TriggerServerEvent('fpwn_customs:checkVehicle', vehModsOld['plate'])
			end
			local currentZone, zone, lastZone
			local coords = GetEntityCoords(PlayerPedId())
			local playerPedId = PlayerPedId()

			if (PlayerData.job and PlayerData.job.name == 'mecano' or PlayerData.job and PlayerData.job.name == 'lscustom') or not cfg_custom.IsMecanoJobOnly and not lsMenuIsShowed then
				isInLSMarker = false
				for k,v in pairs(cfg_custom.Zones) do
					local dst = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z)
					if dst <= 5.0 then
						isInLSMarker  = true
						ESX.ShowHelpNotification(cfg_custom.Hint)
						
					end
				end

			end

			if lsMenuIsShowed and not isInLSMarker then
				--FreezeEntityPosition(vehPedIsIn, false)
				RageUI.CloseAll()
				lsMenuIsShowed = false
				SetVehicleDoorsShut(vehPedIsIn, false)
				if not canClose then
					TriggerEvent('fpwn_customs:resetVehicle', vehModsOld)
				end
			end
			if IsControlJustReleased(0, 38) and not lsMenuIsShowed and isInLSMarker then
				if (PlayerData.job.name == 'mecano' or PlayerData.job.name == 'lscustom') or not cfg_custom.IsMecanoJobOnly then
					--vehPedIsIn = GetVehiclePedIsIn(playerPed, false)
					terminatePurchase()
					getCarPrice()
					vehicleClass = GetVehicleClass(vehPedIsIn)
					--print("vehicleClass: " .. vehicleClass)
					if ((vehicleClass ~= 8 or not cfg_custom.IsMotorCycleBikerOnly) and PlayerData.job.name == 'mecano') or 
						((vehicleClass ~= 8 or not cfg_custom.IsMotorCycleBikerOnly) and PlayerData.job.name == 'lscustom') 
					then

						--RageUI.CloseAll()
						vehModsOld = ESX.Game.GetVehicleProperties(vehPedIsIn)
						for kCat,vCat in pairs(cfg_custom.DetailsColor) do
							for kColor,vColor in pairs(cfg_custom.DetailsColor[kCat].id) do
								if vehModsOld['color1'] == cfg_custom.DetailsColor[kCat].id[kColor] then
									newPrimaryColorIndex = kCat
									newPrimaryColorDetailsIndex = kColor
								end
								if vehModsOld['color2'] == cfg_custom.DetailsColor[kCat].id[kColor] then
									newSecondaryColorIndex = kCat
									newSecondaryColorDetailsIndex = kColor
								end
								if vehModsOld['pearlescentColor'] == cfg_custom.DetailsColor[kCat].id[kColor] then
									newPearlescentColorIndex = kCat
									newPearlescentColorDetailsIndex = kColor
								end
								if vehModsOld['wheelColor'] == cfg_custom.DetailsColor[kCat].id[kColor] then
									newWheelColorIndex = kCat
									newWheelColorDetailsIndex = kColor
								end
							end
						end


						print('nacrage : '..vehModsOld['pearlescentColor'])
						primaryColorIndex = vehModsOld['color1']
						secondaryColorIndex = vehModsOld['color2']
						interiorColorIndex = GetVehicleInteriorColour(vehPedIsIn)
						pearlColorIndex = vehModsOld['pearlescentColor']
						wheelColorIndex = vehModsOld['wheelColor']
						interiorColorOld = GetVehicleInteriorColour(vehPedIsIn)
						plateIndex = GetVehicleNumberPlateTextIndex(vehPedIsIn)
						SetVehicleModKit(vehPedIsIn, 0)
						TriggerServerEvent('fpwn_customs:saveVehicle', vehModsOld)

						--resetItems
						ResetBodyPartItems()
						ResetWheelItems()
						ResetExtraItems()
						ResetPaintItems()
						ResetNeonItems()
						ResetUpgradeItems()
						
						if not tempBodyParts then tempBodyParts = cfg_custom.bodyParts end
						if not tempExtras then tempExtras = cfg_custom.extras end
						if not tempColorParts then tempColorParts = cfg_custom.colorParts end
						if not tempNeons then tempNeons = cfg_custom.neons end
						if not tempUpgrades then tempUpgrades = cfg_custom.upgrades end
						
						if vehicleClass == 8 and #tempBodyParts[12]['wheelType'] < 8 then
							table.insert(tempBodyParts[12]['items'], _U('motorcycle'))
							table.insert(tempBodyParts[12]['wheelType'], 6)
						elseif vehicleClass ~= 8 and #tempBodyParts[12]['wheelType'] == 8 then
							table.remove(tempBodyParts[12]['items'])
							table.remove(tempBodyParts[12]['wheelType'])
						end

						--refresh indexes
						RefreshBodyPartIndex()
						RefreshExtrasIndex()
						RefreshPaintIndex()
						RefreshNeonIndex()
						RefreshUpgradeIndex()
						--refresh item names
						BuildBodyPartsLabel()
						BuildWheelsLabel()
						BuildExtrasLabel()
						BuildUpgradesLabel()

						lsMenuIsShowed = true
						--SetVehicleDoorsLocked(vehPedIsIn, 4)
						--FreezeEntityPosition(vehPedIsIn, true)
						CreateLSMenu()
						myCar = vehModsOld

						shopProfit = cfg_custom.shopProfit[PlayerData.job and PlayerData.job.name]

						RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
					end
				end
			end

			RageUI.IsVisible(mainMenu, function()
					RageUI.Button(_U('bodyparts') , nil, {
						LeftBadge = nil,
						RightBadge = nil,
						RightLabel = ">"
					}, true, 
					{}, bodyMenu)  
					RageUI.Button("Extras" , nil, {
						LeftBadge = nil,
						RightBadge = nil,
						RightLabel = ">"
					}, true, {
						onSelected = function()
							--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							SetVehicleDoorOpen(vehPedIsIn, 0, false)
							SetVehicleDoorOpen(vehPedIsIn, 1, false)
							SetVehicleDoorOpen(vehPedIsIn, 2, false)
							SetVehicleDoorOpen(vehPedIsIn, 3, false)
							SetVehicleDoorOpen(vehPedIsIn, 4, false)
							SetVehicleDoorOpen(vehPedIsIn, 5, false)
                        end,
                    }, extrasMenu)
					RageUI.Button(_U('respray') , nil, {
						LeftBadge = nil,
						RightBadge = nil,
						RightLabel = ">"
					}, true,  {
						onSelected = function()
							--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
                        end,
                    }, colorMenu)
					RageUI.Button(_U('neons') , nil, {
						LeftBadge = nil,
						RightBadge = nil,
						RightLabel = ">"
					}, true,{
						onSelected = function()
							--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
                        end,
                    }, neonMenu)  
					RageUI.Button(_U('upgrades') , nil, {
						LeftBadge = nil,
						RightBadge = nil,
						RightLabel = ">"
					}, true, {
						onSelected = function()
							--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
                        end,
                    }, upgradeMenu) 
				RageUI.Button(_U('cart') , nil, {
						LeftBadge = nil,
						RightBadge = nil,
						RightLabel = ">"
					}, true, {
						onSelected = function()
							--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
                        end,
                    }, cartMenu) 
				end, function()
				---Panels
				end
			)
	        
            RageUI.IsVisible(bodyMenu, function()
            	local menuItemCount = 0
	            	for i = 1, #tempBodyParts, 1 do
	            		local modCount = GetNumVehicleMods(vehPedIsIn, tempBodyParts[i]['modType'])
						--print(tempBodyParts[i]['mod'] .. ' modCount: ' .. modCount)
						local bodyIndex = 1
						bodyIndex = bodyPartIndex[i][tempBodyParts[i]['mod']]
						if modCount > 0 then
							if vehicleClass ~= 8 or (tempBodyParts[i]['mod'] ~= 'wheels' and vehicleClass == 8) then
								local itemLabel = tempBodyParts[i]['label']
								if tempBodyParts[i]['mod'] ~= 'wheels' then
									itemLabel = itemLabel .. " (" .. (calcModPrice(tempBodyParts[i]['items']['price']) .. "$" or "---") .. ")" 
								end
								RageUI.List(itemLabel,
									(tempBodyParts[i]['mod'] ~= 'wheels') and tempBodyParts[i]['items']['label'] or tempBodyParts[i]['items'], 
									bodyIndex,
									nil, 
									{}, 
									true, 
									{
										onListChange= function(Index, CurrentItems)
											print(Index, CurrentItems)
											if bodyPartIndex[i][tempBodyParts[i]['mod']] ~= Index and Index <= modCount + 1 then -- +1 para contar com o index da peça STOCK
												bodyPartIndex[i][tempBodyParts[i]['mod']] = Index
											end
											local itemIndex = Index - (tempBodyParts[i]['mod'] ~= 'wheels' and 2 or 1)
											if tempBodyParts[i]['mod'] ~= 'wheels' then
												SetVehicleMod(vehPedIsIn, tempBodyParts[i]['modType'], itemIndex, false)
												SetVehicleMod(vehPedIsIn, 24, itemIndex, false)
												compareMods(tempBodyParts[i]['label'], tempBodyParts[i]['mod'], tempBodyParts[i]['modType'], itemIndex, calcModPrice(tempBodyParts[i]['items']['price']))
											elseif tempBodyParts[i]['mod'] == 'wheels' then
												bodyPartIndex[13][tempBodyParts[13]['mod']] = 1
												SetVehicleWheelType(vehPedIsIn, tempBodyParts[i]['wheelType'][Index])
												SetVehicleMod(vehPedIsIn, 23, -1, false)
												SetVehicleMod(vehPedIsIn, 24, -1, false)
												compareMods(tempBodyParts[13]['label'], tempBodyParts[13]['mod'], tempBodyParts[13]['modType'], 1, 0)
												ResetWheelItems()
												BuildWheelsLabel()
											elseif tempBodyParts[i]['mod'] == 'modFrontWheels' then
												SetVehicleMod(vehPedIsIn, 23, Index - 2, false)
												SetVehicleMod(vehPedIsIn, 24, Index - 2, false)
												if vehicleClass == 8 then
													SetVehicleMod(vehPedIsIn, 24, Index - 2, false)
												end
												compareMods(tempBodyParts[i]['label'], tempBodyParts[i]['mod'], tempBodyParts[i]['modType'], itemIndex, calcModPrice(tempBodyParts[i]['items']['price']))
											end
										end,
									}
								)
								menuItemCount = menuItemCount + 1
							end
						end
	            	end
	            	if menuItemCount == 0 then
	            		RageUI.Button(_U('noStock') , nil, {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "Vide"
						}, true, {
							onSelected = function()
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end,
						}, mainMenu)
	            	end
				end, function()
				---Panels
				end
			)
			RageUI.IsVisible(extrasMenu, function()
					local menuItemCount = 0
	            	for i = 1, #tempExtras, 1 do
	            		local modCount = GetNumVehicleMods(vehPedIsIn, tempExtras[i]['modType'])
						print(tempExtras[i]['mod'] .. ' modCount: ' .. modCount)
						local extraIndex = 1
						extraIndex = extrasIndex[i][tempExtras[i]['mod']]
						if modCount > 0 then
							local itemLabel = tempExtras[i]['label'] .. " (" .. (calcModPrice(tempExtras[i]['items']['price']) .. "$" or "---") .. ")"
							RageUI.List(itemLabel,
								tempExtras[i]['items']['label'], 
								extraIndex,
								nil, 
								{}, 
								true, {
									onListChange = function(Index, CurrentItems)
										print(Index, CurrentItems)
										if extrasIndex[i][tempExtras[i]['mod']] ~= Index and Index <= modCount + 1 then -- +1 para contar com o index da peça STOCK
											extrasIndex[i][tempExtras[i]['mod']] = Index
										end
										local itemIndex = Index - 2
										SetVehicleMod(vehPedIsIn, tempExtras[i]['modType'], itemIndex, false)
										if tempExtras[i]['mod'] == 'modLivery' then
											SetVehicleLivery(vehPedIsIn, itemIndex)
										end
										compareMods(tempExtras[i]['label'], tempExtras[i]['mod'], tempExtras[i]['modType'], itemIndex, calcModPrice(tempExtras[i]['items']['price']))
									end,
								}
							)
							menuItemCount = menuItemCount + 1
						end
	            	end
	            	if menuItemCount == 0 then
	            		RageUI.Button(_U('noStock') , nil, {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "Vide"
						}, true, {
							onSelected = function()
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end,
						}, mainMenu)
					end
					RageUI.Slider("Couleur plaque", newPlateIndex, 6, "", false, {}, true, 
						{
							onSliderChange = function(Index)
								newPlateIndex = Index
								SetVehicleNumberPlateTextIndex(vehPedIsIn, cfg_custom.PlateText[newPlateIndex]["id"])
								compareMods("Couleur plaque", "plateIndex", 0, 0, 1000)
							end,
						}
					)
				end, function()
				---Panels
				end
			)
			RageUI.IsVisible(colorMenu, function()
					if bodyPartIndex[13]['modFrontWheels'] ~= 1 then
						local item = findItem(tempColorParts['label'], _U('wheels'))
						local itemPos = item and item or 0
						if itemPos == 0 then
							table.insert(tempColorParts['label'], _U('wheels'))
							table.insert(tempColorParts['mod'], 'wheels')
						end
					else
						local item = findItem(tempColorParts['label'], _U('wheels'))
						local itemPos = item and item or 0
						if itemPos > 1 then
							tempColorParts['label'][itemPos] = nil
							tempColorParts['mod'][itemPos] = nil
							colorPartIndex = 1
						end
					end
					RageUI.Checkbox(cfg_custom.tireSmoke['label'] .. " (" .. (calcModPrice(cfg_custom.tireSmoke['price']) .. "$" or "---") .. ")", 
						nil, 
						tyreSmokeActive, 
						{ Style = RageUI.CheckboxStyle.Tick }, 
						{
							onSelected = function(Checked)
								tyreSmokeActive = Checked and true or false
								if tyreSmokeActive then
									local item = findItem(tempColorParts['label'], _U('tireSmoke'))
									local itemPos = item and item or 0
									if itemPos == 0 then
										table.insert(tempColorParts['label'], _U('tireSmoke'))
										table.insert(tempColorParts['mod'], 'tireSmoke')
									end
								else
									local item = findItem(tempColorParts['label'], _U('tireSmoke'))
									local itemPos = item and item or 0
									if itemPos > 1 then
										tempColorParts['label'][itemPos] = nil
										tempColorParts['mod'][itemPos] = nil
										colorPartIndex = 1
									end
								end
								ToggleVehicleMod(vehPedIsIn, 20, tyreSmokeActive)
								compareMods(cfg_custom.tireSmoke['label'], cfg_custom.tireSmoke['mod'], 20, tyreSmokeActive, ((tyreSmokeActive and vehModsOld['modSmokeEnabled']) or (not tyreSmokeActive and vehModsOld['modSmokeEnabled'])) and 0 or calcModPrice(cfg_custom.tireSmoke['price']))

							end,
						}
					)
					RageUI.Checkbox(cfg_custom.xenon['label'] .. " (" .. (calcModPrice(cfg_custom.xenon['price']) .. "$" or "---") .. ")", 
						nil, 
						xenonActive, 
						{ Style = RageUI.CheckboxStyle.Tick }, 
						{
							onSelected = function(Checked)
								xenonActive = Checked and true or false
								if xenonActive then
									local item = findItem(tempColorParts['label'], _U('headlights'))
									local itemPos = item and item or 0
									if itemPos == 0 then
										table.insert(tempColorParts['label'], _U('headlights'))
										table.insert(tempColorParts['mod'], 'headlights')
									end
								else
									local item = findItem(tempColorParts['label'], _U('headlights'))
									local itemPos = item and item or 0
									if itemPos > 1 then
										tempColorParts['label'][itemPos] = nil
										tempColorParts['mod'][itemPos] = nil
										colorPartIndex = 1
									end
								end
								ToggleVehicleMod(vehPedIsIn, 22, xenonActive)
								compareMods(cfg_custom.xenon['label'], cfg_custom.xenon['mod'], 22, xenonActive, ((xenonActive and vehModsOld['modXenon']) or (not xenonActive and vehModsOld['modXenon'])) and 0 or calcModPrice(cfg_custom.xenon['price']))
							end,
						}
					)
					RageUI.List(_U('paintPart'),
						tempColorParts['label'], 
						colorPartIndex,
						nil, 
						{}, 
						true, 
						{
							onListChange = function(Index, CurrentItems)
								print(Index, CurrentItems)
								colorPartIndex = Index
							end,
						}
					)
					if colorPartIndex <= 3 or colorPartIndex == 5 then
						if tempColorParts['mod'][colorPartIndex] == 'primary' then
							RageUI.List('Couleur',
								cfg_custom.Colors['label'], 
								newPrimaryColorIndex,
								nil, 
								{}, 
								true, 
								{
									onListChange = function(Index, CurrentItems)
										print(Index, CurrentItems)
										newPrimaryColorIndex = Index
									end,
								}
							)
							RageUI.List('Détails couleur',
								cfg_custom.DetailsColor[newPrimaryColorIndex]['label'], 
								newPrimaryColorDetailsIndex,
								nil, 
								{}, 
								true, 
								{
									onListChange = function(Index, CurrentItems)
										if primaryColorIndex ~= Index then
											newPrimaryColorDetailsIndex = Index
											primaryColorIndex = cfg_custom.DetailsColor[newPrimaryColorIndex]['id'][Index]	
											SetVehicleColours(vehPedIsIn, cfg_custom.DetailsColor[newPrimaryColorIndex]['id'][Index] , cfg_custom.DetailsColor[newSecondaryColorIndex]['id'][newSecondaryColorDetailsIndex])
											compareMods(_U('primary'), 'color1', -1, Index, calcModPrice(cfg_custom.colorParts['primaryColorPrice']))
										end
									end,
								}
							)
						elseif tempColorParts['mod'][colorPartIndex] == 'secondary' then
							RageUI.List('Couleur',
								cfg_custom.Colors['label'], 
								newSecondaryColorIndex,
								nil, 
								{}, 
								true, 
								{
									onListChange = function(Index, CurrentItems)
										print(Index, CurrentItems)
										newSecondaryColorIndex = Index
									end,
								}
							)
							RageUI.List('Détails couleur',
								cfg_custom.DetailsColor[newSecondaryColorIndex]['label'], 
								newSecondaryColorDetailsIndex,
								nil, 
								{}, 
								true, 
								{
									onListChange = function(Index, CurrentItems)
										if secondaryColorIndex ~= Index then
											newSecondaryColorDetailsIndex = Index
											secondaryColorIndex = cfg_custom.DetailsColor[newSecondaryColorIndex]['id'][Index]
											SetVehicleColours(vehPedIsIn, cfg_custom.DetailsColor[newPrimaryColorIndex]['id'][newPrimaryColorDetailsIndex] ,  cfg_custom.DetailsColor[newSecondaryColorIndex]['id'][Index])
											compareMods(_U('secondary'), 'color2', -1, Index, calcModPrice(cfg_custom.colorParts['secondaryColorPrice']))
										end
									end,
								}
							)
						elseif tempColorParts['mod'][colorPartIndex] == 'interior' then
							RageUI.List('Couleur',
								cfg_custom.Colors['label'], 
								newInteriorColorIndex,
								nil, 
								{}, 
								true, 
								{
									onListChange = function(Index, CurrentItems)
										print(Index, CurrentItems)
										newInteriorColorIndex = Index
									end,
								}
							)
							RageUI.List('Détails couleur',
								cfg_custom.DetailsColor[newInteriorColorIndex]['label'], 
								newInteriorColorDetailsIndex,
								nil, 
								{}, 
								true, 
								{
									onListChange = function(Index, CurrentItems)
										if InteriorColorIndex ~= Index then
											newInteriorColorDetailsIndex = Index
											InteriorColorIndex = cfg_custom.DetailsColor[newInteriorColorIndex]['id'][Index]
											SetVehicleInteriorColour(vehPedIsIn, cfg_custom.DetailsColor[newInteriorColorIndex]['id'][Index])
											compareMods(_U('interior'), 'interior', -1, Index, calcModPrice(cfg_custom.colorParts['interiorColorPrice']))	
										end
									end,
								}
							)
						elseif tempColorParts['mod'][colorPartIndex] == 'pearlescent' then
							RageUI.List('Couleur',
								cfg_custom.Colors['label'], 
								newPearlescentColorIndex,
								nil, 
								{}, 
								true, 
								{
									onListChange = function(Index, CurrentItems)
										print(Index, CurrentItems)
										newPearlescentColorIndex = Index
									end,
								}
							)
							RageUI.List('Détails couleur',
								cfg_custom.DetailsColor[newPearlescentColorIndex]['label'], 
								newPearlescentColorDetailsIndex,
								nil, 
								{}, 
								true, 
								{
									onListChange = function(Index, CurrentItems)
										if pearlColorIndex ~= Index then
											newPearlescentColorDetailsIndex = Index
											pearlColorIndex = cfg_custom.DetailsColor[newPearlescentColorIndex]['id'][Index]
											SetVehicleExtraColours(vehPedIsIn,  cfg_custom.DetailsColor[newPearlescentColorIndex]['id'][Index], cfg_custom.DetailsColor[newWheelColorIndex]['id'][newWheelColorDetailsIndex])
											compareMods(_U('pearlescent'), 'pearlescentColor', -1, Index, calcModPrice(cfg_custom.colorParts['pearlescentColorPrice']))
										end
									end,
								}
							)
						end
					elseif colorPartIndex == 4 then
						RageUI.List(_U('windows'),
							cfg_custom.resprayTypes[colorPartIndex]['label'], 
							windowTintIndex,
							nil, 
							{}, 
							true, 
							{
								onListChange = function(Index, CurrentItems)
									print(Index, CurrentItems)
									local itemIndex = windowTintIndex - 2
									windowTintIndex = Index
									compareMods(cfg_custom.windowTints['label'], cfg_custom.windowTints['mod'], -1, itemIndex, calcModPrice(cfg_custom.windowTints['price']))
									SetVehicleWindowTint(vehPedIsIn, windowTintIndex - 2)
								end,
							}
						)
					elseif tempColorParts['mod'][colorPartIndex] == 'wheels' then
						RageUI.List('Couleur',
							cfg_custom.Colors['label'], 
							newWheelColorIndex,
							nil, 
							{}, 
							true, 
							{
								onListChange = function(Index, CurrentItems)
									print(Index, CurrentItems)
									newWheelColorIndex = Index
								end,
							}
						)
						RageUI.List('Détails couleur',
							cfg_custom.DetailsColor[newWheelColorIndex]['label'], 
							newWheelColorDetailsIndex,
							nil, 
							{}, 
							true, 
							{
								onListChange = function(Index, CurrentItems)
									if pearlColorIndex ~= Index then
										newWheelColorDetailsIndex = Index
										wheelColorIndex = cfg_custom.DetailsColor[newWheelColorIndex]['id'][Index]
										SetVehicleExtraColours(vehPedIsIn,  cfg_custom.DetailsColor[newPearlescentColorIndex]['id'][newPearlescentColorDetailsIndex], cfg_custom.DetailsColor[newWheelColorIndex]['id'][Index])
										compareMods(_U('wheel_color'), 'wheelColor', -1, Index, calcModPrice(cfg_custom.colorParts['wheelColorPrice']))
									end
								end,
							}
						)
					elseif tempColorParts['mod'][colorPartIndex] == 'tireSmoke' then 
						RageUI.Button(smokeColorIndex[1]['label'] .. " [" .. smokeColorIndex[1]['index'] .. "]", nil, {}, true, {
							onSelected = function(Index)
								local smokeRedValue = Visual.KeyboardAmount("Taux de rouge")
								if smokeRedValue ~= nil and smokeRedValue >= 0 then
									smokeColorIndex[1]['index'] = smokeRedValue
									if vehModsOld['modSmokeEnabled'] then
										SetVehicleTyreSmokeColor(vehPedIsIn, smokeColorIndex[1]['index'], smokeColorIndex[2]['index'], smokeColorIndex[3]['index'])
										compareMods(cfg_custom.tireSmoke['label1'], cfg_custom.tireSmoke['mod1'], -1, Index, calcModPrice(cfg_custom.tireSmoke['price']))
									end								end
								
							end
						})
						RageUI.Button(smokeColorIndex[2]['label'] .. " [" .. smokeColorIndex[2]['index'] .. "]", nil, {}, true, {
							onSelected = function(Index)
								local smokeGreenValue = Visual.KeyboardAmount("Taux de vert")
								if smokeGreenValue ~= nil and smokeGreenValue >= 0 then
									smokeColorIndex[2]['index'] = smokeGreenValue
									if vehModsOld['modSmokeEnabled'] then
										SetVehicleTyreSmokeColor(vehPedIsIn, smokeColorIndex[1]['index'], smokeColorIndex[2]['index'], smokeColorIndex[3]['index'])
										compareMods(cfg_custom.tireSmoke['label1'], cfg_custom.tireSmoke['mod1'], -1, Index, calcModPrice(cfg_custom.tireSmoke['price']))
									end
								end
								
							end
						})
						RageUI.Button(smokeColorIndex[3]['label'] .. " [" .. smokeColorIndex[3]['index'] .. "]", nil, {}, true, {
							onSelected = function(Index)
								local smokeBlueValue = Visual.KeyboardAmount("Taux de bleu")
								if smokeBlueValue ~= nil and smokeBlueValue >= 0 then
									smokeColorIndex[3]['index'] = smokeBlueValue
									if vehModsOld['modSmokeEnabled'] then
										SetVehicleTyreSmokeColor(vehPedIsIn, smokeColorIndex[1]['index'], smokeColorIndex[2]['index'], smokeColorIndex[3]['index'])
										compareMods(cfg_custom.tireSmoke['label1'], cfg_custom.tireSmoke['mod1'], -1, Index, calcModPrice(cfg_custom.tireSmoke['price']))
									end
								end
							end
						})
					end
				end, function()
					---Panels
				end
			)
			RageUI.IsVisible(neonMenu, function()
					RageUI.Checkbox(tempNeons[1]['label'] .. " (" .. (calcModPrice(tempNeons[1]['price']) .. "$" or "---") .. ")", 
					nil, 
						neon1, 
						{ Style = RageUI.CheckboxStyle.Tick },
						{
							onSelected = function(Checked)
								neon1 = Checked and true or false
								SetVehicleNeonLightEnabled(vehPedIsIn, 0, neon1)
								compareMods(cfg_custom.neons[1]['label'], cfg_custom.neons[1]['mod'], -1, neon1, ((neon1 and vehModsOld['neonEnabled'][1]) or (not neon1 and vehModsOld['neonEnabled'][1])) and 0 or calcModPrice(tempNeons[1]['price']))
							end,
						}
					)
					RageUI.Checkbox(tempNeons[2]['label'] .. " (" .. (calcModPrice(tempNeons[2]['price']) .. "$" or "---") .. ")", 
					nil, 
						neon2, 
						{ Style = RageUI.CheckboxStyle.Tick }, 
						{
							onSelected = function(Checked)
								neon2 = Checked and true or false
								SetVehicleNeonLightEnabled(vehPedIsIn, 1, neon2)
								compareMods(cfg_custom.neons[2]['label'], cfg_custom.neons[2]['mod'], -1, neon2, ((neon2 and vehModsOld['neonEnabled'][3]) or (not neon2 and vehModsOld['neonEnabled'][3])) and 0 or calcModPrice(tempNeons[2]['price']))
							end,
						}
					)
					RageUI.Checkbox(tempNeons[3]['label'] .. " (" .. (calcModPrice(tempNeons[3]['price']) .. "$" or "---") .. ")", 
					nil, 
						neon3, 
						{ Style = RageUI.CheckboxStyle.Tick }, 
						{
							onSelected = function(Checked)
								neon3 = Checked and true or false
								SetVehicleNeonLightEnabled(vehPedIsIn, 2, neon3)
								compareMods(cfg_custom.neons[3]['label'], cfg_custom.neons[3]['mod'], -1, neon3, ((neon3 and vehModsOld['neonEnabled'][2]) or (not neon3 and vehModsOld['neonEnabled'][2])) and 0 or calcModPrice(tempNeons[3]['price']))
							end,
						}
					)
					RageUI.Checkbox(tempNeons[4]['label'] .. " (" .. (calcModPrice(tempNeons[4]['price']) .. "$" or "---") .. ")", 
					nil, 
						neon4, 
						{ Style = RageUI.CheckboxStyle.Tick }, 
						{
							onSelected = function(Checked)
								neon4 = Checked and true or false
								SetVehicleNeonLightEnabled(vehPedIsIn, 3, neon4)
								compareMods(cfg_custom.neons[4]['label'], cfg_custom.neons[4]['mod'], -1, neon4, ((neon4 and vehModsOld['neonEnabled'][4]) or (not neon4 and vehModsOld['neonEnabled'][4])) and 0 or calcModPrice(tempNeons[4]['price']))
							end,
						}
					)
					if neon1 or neon2 or neon3 or neon4 then
						RageUI.Button(neonIndex[1]['label'] .. " [" .. neonIndex[1]['index'] .. "]", nil, {}, true, {
							onSelected = function(Index)
								local neonRedValue = Visual.KeyboardAmount("Taux de rouge")
								if neonRedValue ~= nil and neonRedValue >= 0 then
									neonIndex[1]['index'] = neonRedValue
									SetVehicleNeonLightsColour(vehPedIsIn, neonIndex[1]['index'], neonIndex[2]['index'], neonIndex[3]['index'])
									if vehModsOld['neonEnabled'][1] or vehModsOld['neonEnabled'][2] or vehModsOld['neonEnabled'][3] or vehModsOld['neonEnabled'][4] then
										compareMods(cfg_custom.neons[5]['label'], cfg_custom.neons[5]['mod'], -1, Index, calcModPrice(cfg_custom.neons[5]['price']))
									end							
								end
							end
						})
						RageUI.Button(neonIndex[2]['label'] .. " [" .. neonIndex[2]['index'] .. "]", nil, {}, true, {
							onSelected = function(Index)
								local neonGreenValue = Visual.KeyboardAmount("Taux de vert")
								if neonGreenValue ~= nil and neonGreenValue >= 0 then
									neonIndex[2]['index'] = neonGreenValue
									SetVehicleNeonLightsColour(vehPedIsIn, neonIndex[1]['index'], neonIndex[2]['index'], neonIndex[3]['index'])
									if vehModsOld['neonEnabled'][1] or vehModsOld['neonEnabled'][2] or vehModsOld['neonEnabled'][3] or vehModsOld['neonEnabled'][4] then
										compareMods(cfg_custom.neons[5]['label'], cfg_custom.neons[5]['mod'], -1, Index, calcModPrice(cfg_custom.neons[5]['price']))
									end							
								end
							end
						})
						RageUI.Button(neonIndex[3]['label'] .. " [" .. neonIndex[3]['index'] .. "]", nil, {}, true, {
							onSelected = function(Index)
								local neonBlueValue = Visual.KeyboardAmount("Taux de bleu")
								if neonBlueValue ~= nil and neonBlueValue >= 0 then
									neonIndex[3]['index'] = neonBlueValue
									SetVehicleNeonLightsColour(vehPedIsIn, neonIndex[1]['index'], neonIndex[2]['index'], neonIndex[3]['index'])
									if vehModsOld['neonEnabled'][1] or vehModsOld['neonEnabled'][2] or vehModsOld['neonEnabled'][3] or vehModsOld['neonEnabled'][4] then
										compareMods(cfg_custom.neons[5]['label'], cfg_custom.neons[5]['mod'], -1, Index, calcModPrice(cfg_custom.neons[5]['price']))
									end							
								end
							end
						})
					end
				end, function()
				---Panels
				end
			)
			RageUI.IsVisible(upgradeMenu, function()
					local menuItemCount = 0
					for i = 1, #tempUpgrades, 1 do
						local modCount = GetNumVehicleMods(vehPedIsIn, tempUpgrades[i]['modType'])
						--print(tempUpgrades[i]['mod'] .. ' modCount: ' .. modCount)
						local upgIndex = 1
						if tempUpgrades[i]['mod'] == 'modTurbo' then
							upgIndex = upgradeIndex[i][tempUpgrades[i]['mod']] and true or false
							local itemLabel = tempUpgrades[i]['label'] .. " (" .. (not upgIndex and (calcModPrice(tempUpgrades[i]['items']['price'][2]) or 0) .. "$" or "0$") .. ")"
							RageUI.Checkbox(itemLabel, 
							nil, 
								upgIndex, 
								{ Style = RageUI.CheckboxStyle.Tick }, 
								{
									onSelected = function(Checked)
										upgradeIndex[i][tempUpgrades[i]['mod']] = Checked and true or false
										ToggleVehicleMod(vehPedIsIn, tempUpgrades[i]['modType'], upgradeIndex[i][tempUpgrades[i]['mod']])
										compareMods(tempUpgrades[i]['label'], tempUpgrades[i]['mod'], tempUpgrades[i]['modType'], upgradeIndex[i][tempUpgrades[i]['mod']], Checked and calcModPrice(tempUpgrades[i]['items']['price'][2]) or 0)
									end,
								}
								
							)
							menuItemCount = menuItemCount + 1
						elseif modCount > 0 then
							upgIndex = upgradeIndex[i][tempUpgrades[i]['mod']]
							local itemLabel = tempUpgrades[i]['label'] .. " (" .. (calcModPrice(tempUpgrades[i]['items']['price'][upgIndex]) .. "$" or "---") .. ")"
							RageUI.List(itemLabel,
								tempUpgrades[i]['items']['label'], 
								upgIndex,
								nil, 
								{}, 
								true, 
								{
									onListChange= function(Index, CurrentItems)
										if upgradeIndex[i][tempUpgrades[i]['mod']] ~= Index and Index <= modCount + 1 then -- +1 para contar com o index da peça STOCK
											upgradeIndex[i][tempUpgrades[i]['mod']] = Index
											if Selected then
										
											end
										end
										print(Index, CurrentItems)
										local itemIndex = Index - 2
										SetVehicleMod(vehPedIsIn, tempUpgrades[i]['modType'], Index - 2, false)
										compareMods(tempUpgrades[i]['label'], tempUpgrades[i]['mod'], tempUpgrades[i]['modType'], itemIndex, calcModPrice(tempUpgrades[i]['items']['price'][Index]))	
									end,
								}
							)
							menuItemCount = menuItemCount + 1
						end
					end
					if menuItemCount == 0 then
	            		RageUI.Button(_U('noStock') , nil, {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "Vide"
						}, true,{
							onSelected = function()
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end,
						}, mainMenu)
	            	end
				end, function()
					---Panels
				end
			)
			RageUI.IsVisible(cartMenu, function()
				local menuItemCount = 0
				for k, v in pairs(shopCart) do 
					RageUI.Button(shopCart[k]['label'], nil, {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = shopCart[k]['price'] .. " $"
						}, not deleting, {
							onActive = function()
								if IsControlJustReleased(0, 22) then
									if deleting then
										return
									end
									deleting = true
									DeleteFromCart(k, shopCart[k]['modType'])
								end
							end,
						}
					)
					menuItemCount = menuItemCount + 1
				end
				if menuItemCount == 0 then
					RageUI.Button(_U('cartEmpty') , nil, {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "Vide"
						}, true, {
							onSelected = function()
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end,
						}, mainMenu)
				else
					if PlayerData.job.grade_name == 'boss' then
						RageUI.Slider(_U('shopProfit') .. " (" .. shopProfit .. "%)", shopProfit, 100, nil, false, {}, true, 
						{
							onSliderChange = function(Index)
								if (shopProfit == 100 and Index == 1) or 
									(shopProfit == 1 and Index == 100) then
									Index = 0
								end
								if Index ~= shopProfit then
									shopProfit = Index
									calcCartValue()
								end
							end,
						}
						)
						RageUI.Slider(_U('shopReduction') .. " (" .. shopReduction .. "%)", shopReduction, 100, nil, false, {}, true, 
							{
								onSliderChange = function(Index)
									if (shopReduction == 100 and Index == 1) or 
										(shopReduction == 1 and Index == 100) then
										Index = 0
									end
									if Index ~= shopReduction then
										shopReduction = Index
										calcCartValue()
									end
								end,
							}
						)
						RageUI.Checkbox(_U('autoInvoice'), 
							_U('autoInvoiceTxt'), 
							autoInvoice, 
							{ Style = RageUI.CheckboxStyle.Tick }, 
							{
								onSelected = function(Checked)
									autoInvoice = Checked and true or false
								end,
							}
						)
						RageUI.Button(_U('shopProfitTotal') , nil, {
								LeftBadge = nil,
								RightBadge = nil,
								RightLabel = shopProfitValue .. " $"
							}, true, {
								onSelected = function()
									--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
								end,
							})
						RageUI.Button(_U('shopCosts') , nil, {
								LeftBadge = nil,
								RightBadge = nil,
								RightLabel = shopCostValue .. " $"
							}, true, {
								onSelected = function()
									--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
								end,
							})
						RageUI.Button(_U('reductionCosts') , nil, {
								LeftBadge = nil,
								RightBadge = nil,
								RightLabel = math.round(shopReductionValue) .. " $"
							}, true, {
							onSelected = function()
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end,
						})
						RageUI.Button(_U('valueTotalWithReduction') , nil, {
								LeftBadge = nil,
								RightBadge = nil,
								RightLabel = totalWithReduction .. " $"
							}, true, {
							onSelected = function()
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end,
						})
					end
					RageUI.Button(_U('valueTotal') , nil, {
						LeftBadge = nil,
						RightBadge = nil,
						RightLabel = totalCartValue .. " $"
					}, true, {
						onSelected = function()
							--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
						end,
					})
					RageUI.Button(_U('finishPurchase') , nil, {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = nil
						}, not stop, {
							onSelected = function()
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
								if stop then
									return
								end
								stop = true
								finishPurchase()
							end,
						}
					)
				end
				end, function()
					---Panels
				end
			)
		else
			vehPedIsIn = nil
			terminatePurchase()
		end
	end
end)

-- Prevent Free Tunning Bug
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if lsMenuIsShowed then
			DisableControlAction(2, 288, true)
			DisableControlAction(2, 289, true)
			DisableControlAction(2, 170, true)
			DisableControlAction(2, 167, true)
			DisableControlAction(2, 168, true)
			DisableControlAction(2, 23, true)
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('fpwn_customs:cantBill')
AddEventHandler('fpwn_customs:cantBill', function(amount, targetId)
	print("cancelled")
	terminatePurchase()
end)

RegisterNetEvent('fpwn_customs:canBill')
AddEventHandler('fpwn_customs:canBill', function(amount, targetId)
	print("success")
	--TriggerServerEvent('esx_billing:sendBill', targetId, society, _U('mecano'), amount)
	terminatePurchase()
end)

RegisterNetEvent('fpwn_customs:resetVehicle')
AddEventHandler('fpwn_customs:resetVehicle', function(vehProps)
	ClearVehicleCustomPrimaryColour(vehPedIsIn)
	ClearVehicleCustomSecondaryColour(vehPedIsIn)
	SetVehicleInteriorColour(vehPedIsIn, interiorColorOld);
	ESX.Game.SetVehicleProperties(vehPedIsIn, vehProps)
	terminatePurchase()
end)

RegisterNetEvent('fpwn_customs:getVehicle')
AddEventHandler('fpwn_customs:getVehicle', function()
	TriggerServerEvent('fpwn_customs:refreshOwnedVehicle', ESX.Game.GetVehicleProperties(vehPedIsIn))
end)