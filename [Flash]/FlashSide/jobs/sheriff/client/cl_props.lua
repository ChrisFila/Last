function GetVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

function GetVehiclesInArea (coords, area)
	local vehicles       = GetVehicles()
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

function GetClosestVehicle(coords)
	local vehicles        = GetVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end


function GetAllPlayerAround()
	local players = GetActivePlayers()
	local ids = {}
	for k,v in pairs(players) do
		table.insert(ids, GetPlayerServerId(v))
	end
	return ids
end

function IsSpawnPointClear(coords, radius)
	local vehicles = GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

function GetClosestPlayer()
	local pPed = GetPlayerPed(-1)
	local players = GetActivePlayers()
	local coords = GetEntityCoords(pPed)
	local pCloset = nil
	local pClosetPos = nil
	local pClosetDst = nil
	for k,v in pairs(players) do
		if GetPlayerPed(v) ~= pPed then
			local oPed = GetPlayerPed(v)
			local oCoords = GetEntityCoords(oPed)
			local dst = GetDistanceBetweenCoords(oCoords, coords, true)
			if pCloset == nil then
				pCloset = v
				pClosetPos = oCoords
				pClosetDst = dst
			else
				if dst < pClosetDst then
					pCloset = v
					pClosetPos = oCoords
					pClosetDst = dst
				end
			end
		end
	end

	return pCloset, pClosetDst
end

function GetClosestPed(coords)
	local pPed = GetPlayerPed(-1)
	local pCloset = nil
	local pClosetDst = nil
	for v in EnumeratePeds() do
		if v ~= pPed then
			local oCoords = GetEntityCoords(v)
			local dst = GetDistanceBetweenCoords(oCoords, coords, true)
			if pCloset == nil then
				pCloset = v
				pClosetDst = dst
			else
				if dst < pClosetDst then
					pCloset = v
					pClosetDst = dst
				end
			end
		end
	end

	return pCloset
end

function FoundClearSpawnPoint(zones)
	local found = false
	local count = 0
	for k,v in pairs(zones) do
		local clear = IsSpawnPointClear(v.pos, 2.0)
		if clear then
			found = v
			break
		end
	end
	return found
end

function DisplayClosetPlayer()
	local pPed = GetPlayerPed(-1)
	local pCoords = GetEntityCoords(pPed)
	local pCloset = GetClosestPlayer(pCoords)
	if pCloset ~= -1 then
		local cCoords = GetEntityCoords(GetPlayerPed(pCloset))
		DrawMarker(20, cCoords.x, cCoords.y, cCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)
	end
end

function DisplayClosetVehicle()
	local pPed = GetPlayerPed(-1)
	local pCoords = GetEntityCoords(pPed)
	local pCloset = GetClosestVehicle()
	if pCloset ~= -1 then
		local cCoords = GetEntityCoords(pCloset)
		DrawMarker(20, cCoords.x, cCoords.y, cCoords.z+1., 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)
	end
end

function LoadModel(model)
	local oldName = model
	local model = GetHashKey(model)
	if IsModelInCdimage(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(1) end
	else
		ESX.ShowNotification("~r~ERREUR: ~s~Modèle inconnu.\nMerci de report le problème au dev. (Modèle: "..oldName.." #"..model..")")
	end
end

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end


local actionZone = {}
function RegisterActionZone(zone, text, actions, npc, heading, haveNpc)
    actionZone[#actionZone + 1] = {name = zone.name, pos = zone.pos, txt = text, action = actions, npc = npc, heading = heading, spawned = false, entity = nil, haveNpc = haveNpc}
end

function UnregisterActionZone(name)
    for k,v in pairs(actionZone) do 
		if v.name == name then
			if v.spawned == true then            
				DeleteEntity(v.entity)
			end
			actionZone[k] = nil
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        local NearZone = false
        for k,v in pairs(actionZone) do
            if #(pCoords - v.pos) < 15 then
				NearZone = true
				if v.haveNpc then
					if not v.spawned then
						if not HasModelLoaded(GetHashKey(v.npc)) then
							LoadModel(v.npc)
						end
						actionZone[k].entity = CreatePed(1, GetHashKey(v.npc), v.pos, v.heading, false, false) -- Could use v.entity i think ?
						TaskSetBlockingOfNonTemporaryEvents(actionZone[k].entity, true)
						SetBlockingOfNonTemporaryEvents(actionZone[k].entity, true)
						FreezeEntityPosition(actionZone[k].entity, true)
						actionZone[k].spawned = true
					end
					DrawMarker(32, v.pos.x, v.pos.y, v.pos.z + 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 252, 198, 3, 180, 0, 0, 2, 1, nil, nil, 0)
				else
					DrawMarker(32, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 252, 198, 3, 180, 0, 0, 2, 1, nil, nil, 0)
				end
				if #(pCoords - v.pos) <= 3.0 then
                    ESX.ShowHelpNotification(v.txt)
                    if IsControlJustPressed(1, 38) then
                        v.action()
                    end
                end
			else
				if v.haveNpc then
					if v.spawned then 
						DeleteEntity(actionZone[k].entity )
						actionZone[k].spawned = false
					end
				end
            end
        end

        if NearZone then
            Wait(1)
        else
            Wait(500)
        end
    end
end)

local function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function RayCastGamePlayCamera(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 1, -1, 1))
	return b, c, e
end

local heading = 100.0
function AddPropsToGround(prop)
	local model = prop
	LoadModel(model)


	local pPed = GetPlayerPed(-1)
	local SpawnPoint = GetOffsetFromEntityInWorldCoords(pPed, 0.0, 1.5, 0.0)
	local prop = CreateObject(GetHashKey(model), SpawnPoint, 1, false, false)
	SetEntityCanBeDamaged(prop, false)
	--DecorSetBool(prop, "sheriff_PROP", true)

	local locked = false
	Citizen.CreateThread(function()
		while not locked do
			SetEntityAlpha(prop, 150, 150)

			local hit, SpawnPoint, entity = RayCastGamePlayCamera(1000.0)
			SetEntityCoordsNoOffset(prop, SpawnPoint, 0.0, 0.0, 0.0)
			SetEntityHeading(prop, heading)
			PlaceObjectOnGroundProperly(prop)

			if IsControlPressed(1, 174) then
				heading = heading + 1.0
			elseif IsControlPressed(1, 175) then
				heading = heading - 1.0
			end

			ShowFloatingHelpNotification("Utiliser   ~INPUT_CELLPHONE_LEFT~ ou    ~INPUT_CELLPHONE_RIGHT~ pour tourner l'objets \n\nUtiliser ~INPUT_PHONE~ pour valider le placement.", vector3(SpawnPoint.x, SpawnPoint.y, SpawnPoint.z+1.5))

			if IsControlJustReleased(1, 27) then
				locked = true
			end
			Wait(1)
		end

		FreezeEntityPosition(prop, true)
		ResetEntityAlpha(prop)
		SetObjectAsNoLongerNeeded(prop)
	end)
end

local propsEditor = false
function StartPropsEditor()
	if propsEditor then
		propsEditor = false
		return
	else
		local toCheck = {}
		local propsToCheck = {}
		for k,v in pairs(cfg_sheriff.props) do
			toCheck[GetHashKey(v.prop)] = true
		end

		Citizen.CreateThread(function()
			while propsEditor do
				for k in EnumerateObjects() do
					if toCheck[GetEntityModel(k)] ~= nil then
						propsToCheck[k] = true
					end
				end
				Wait(500)
			end
		end)

		propsEditor = true
	
		Citizen.CreateThread(function()
			while propsEditor do
				local pPed = GetPlayerPed(-1)
				local position = GetEntityCoords(pPed)
				local hit, pCoords, entity = RayCastGamePlayCamera(1000.0)
				local near = false

				DrawLine(position.x, position.y, position.z, pCoords.x, pCoords.y, pCoords.z, 255, 255, 255, 255)
				DrawMarker(28, pCoords.x, pCoords.y, pCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)

				for k,v in pairs(propsToCheck) do
					if not near then
						if GetDistanceBetweenCoords(GetEntityCoords(k), pCoords, true) < 2.0 then
							near = true

							local oCoords = GetEntityCoords(k)
							DrawMarker(25, oCoords.x, oCoords.y, oCoords.z+0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)

							--ESX.ShowHelpNotification(".")
							ESX.ShowHelpNotification("Appuyer sur E pour supprimer l'objets")
							
							SetEntityAlpha(k, 150, 150)

							if IsControlJustReleased(1, 38) then
								if NetworkRegisterEntityAsNetworked(k) then
									TriggerServerEvent("DeleteEntity", {ObjToNet(k)})
									DeleteEntity(k)
									DeleteObject(k)
								else
									DeleteEntity(k)
									DeleteObject(k)
								end
							end
						else
							ResetEntityAlpha(k)
						end
					end
				end

				Wait(1)
			end
		end)
	end
end


function InitHerse()
	local herse = {}

	Citizen.CreateThread(function()
		while true do
			for v in EnumerateObjects() do
				if GetEntityModel(v) == GetHashKey("p_ld_stinger_s") then
					if herse[v] == nil then
						herse[v] = GetEntityCoords(v)
					end
				end
			end

			for k,v in pairs(herse) do
				if not DoesEntityExist(k) then
					herse[k] = nil
				end
			end
			Wait(1000)
		end
	end)


	Citizen.CreateThread(function()
		while true do
			local pPed = GetPlayerPed(-1)
			local pCoords = GetEntityCoords(pPed)
			local near = false

			if IsPedInAnyVehicle(pPed, false) then
				for k,v in pairs(herse) do
					local dst = GetDistanceBetweenCoords(pCoords, v, true)
					if dst < 50 then
						near = true

						if dst < 3.0 then
							local pVeh = GetVehiclePedIsIn(pPed, false)
							for i = 1,2 do
								SetVehicleTyreBurst(pVeh, math.random(0,5), true, 1000.0)
							end
							Wait(1000)
						end
					end
				end
			else
				Wait(300)
			end


			if near then
				Wait(5)
			else
				Wait(250)
			end
		end
	end)
end

local placing = false
local heading = 100.0
function SpawnObjectWithPos(model)
	placing = true
	LoadModel(model)
	local model = GetHashKey(model)

	local valide = false
	local hit, coords, entity = RayCastGamePlayCamera(1000.0)
	local object = CreateObject(model, coords, 0, 1, 1)
	PlaceObjectOnGroundProperly(object)


	while not valide do
		local hit, coords, entity = RayCastGamePlayCamera(1000.0, object)

		-- local position = GetEntityCoords(GetPlayerPed(-1))
		-- DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, 255, 0, 0, 255)
		-- DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)

		if hit then  
			SetEntityCoordsNoOffset(object, coords.xyz, 0.0, 0.0, 0.0)
			PlaceObjectOnGroundProperly(object)
			FreezeEntityPosition(object, 1)
			SetEntityHeading(object, heading)


			if IsControlPressed(1, 174) then
				heading = heading + 1.0
			elseif IsControlPressed(1, 175) then
				heading = heading - 1.0
			end
		end

		ESX.ShowHelpNotification("Appuyer sur [~r~E~s~] pour placer l'objets", 10)

		if IsControlJustReleased(0, 38) then
			local coords = GetEntityCoords(object)
			local heading = GetEntityHeading(object)
			DeleteObject(object)
			local objectFinal = CreateObject(model, coords, 1, 0, 0)

			SetEntityCoordsNoOffset(objectFinal, coords.xyz, 0.0, 0.0, 0.0)
			PlaceObjectOnGroundProperly(objectFinal)
			FreezeEntityPosition(objectFinal, 1)
			SetEntityHeading(objectFinal, heading)

			valide = true
			placing = false
		end
		Wait(1)
	end
end

AddEventHandler("core:PlaceObject", function(model)
	if not placing then
		SpawnObjectWithPos(model)
	end
end)