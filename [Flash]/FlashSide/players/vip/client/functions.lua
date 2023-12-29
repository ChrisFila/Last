            ESX = nil

            Citizen.CreateThread(function()
                while ESX == nil do
                    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
                    Citizen.Wait(100)
                end
            end)

            function SpawnPed(pedname)
                local j1 = PlayerId()
                local p1 = GetHashKey(pedname)
                RequestModel(p1)
                while not HasModelLoaded(p1) do
                    Wait(100)
                    end
                    SetPlayerModel(j1, p1)
                    SetModelAsNoLongerNeeded(p1)
                    TriggerEvent('esx:restoreLoadout')
                    Citizen.Wait(500)
            end

            function InputPed()
                local j1 = PlayerId()
                local newped = KeyboardInput('Nom du ped (Cherchez sur wiki.rage.mp)', '', 45)
                local p1 = GetHashKey(newped)
                RequestModel(p1)
                Citizen.Wait(200)
                while not HasModelLoaded(p1) do
                    Wait(100)
                    end
                    SetPlayerModel(j1, p1)
                    Citizen.Wait(200)
                    SetModelAsNoLongerNeeded(p1)
                    Wait(100)
                    ESX.ShowNotification("~r~Ped changé avec succès !") 
                    TriggerEvent('esx:restoreLoadout')
                    Wait(100)
                    RageUI.CloseAll()
            end

            function SetCus(ped, componentId, drawableId, textureId, paletteId)
                SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
            end

            function SetProp(ped,componentId,drawableId,TextureId,attach)
                SetPedPropIndex(ped,componentId,drawableId,TextureId,attach)
            end

            
            function Clear(ped,propId)
                ClearPedProp(ped,propId)
            end

            function ResetPed()
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    local isMale = skin.sex == 0

                    TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            TriggerEvent('skinchanger:loadSkin', skin)
                            TriggerEvent('esx:restoreLoadout')
                            Citizen.Wait(200)
                            ESX.ShowNotification("~r~Votre personnage a été rénitialisé ...") 
                        end)
                    end)
                end)
            end



            ------------ FUNCTION MENU PROPS



            function SpawnObj(obj)
                local playerPed = PlayerPedId()
                local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
                local objectCoords = (coords + forward * 1.0)
                local Ent = nil

                SpawnObject(obj, objectCoords, function(obj)
                    SetEntityCoords(obj, objectCoords, 0.0, 0.0, 0.0, 0)
                    SetEntityHeading(obj, GetEntityHeading(playerPed))
                    PlaceObjectOnGroundProperly(obj)
                    Ent = obj
                    Wait(1)
                end)
                Wait(1)
                while Ent == nil do Wait(1) end
                SetEntityHeading(Ent, GetEntityHeading(playerPed))
                PlaceObjectOnGroundProperly(Ent)
                local placed = false
                while not placed do
                    Citizen.Wait(1)
                    local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
                    local objectCoords = (coords + forward * 2.0)
                    SetEntityCoords(Ent, objectCoords, 0.0, 0.0, 0.0, 0)
                    SetEntityHeading(Ent, GetEntityHeading(playerPed))
                    PlaceObjectOnGroundProperly(Ent)
                    SetEntityAlpha(Ent, 170, 170)

                    if IsControlJustReleased(1, 38) then
                        placed = true
                    end
                end

                FreezeEntityPosition(Ent, true)
                SetEntityInvincible(Ent, true)
                ResetEntityAlpha(Ent)
                local NetId = NetworkGetNetworkIdFromEntity(Ent)
                table.insert(object, NetId)

            end


            function RemoveObj(id, k)
                Citizen.CreateThread(function()
                    SetNetworkIdCanMigrate(id, true)
                    local entity = NetworkGetEntityFromNetworkId(id)
                    NetworkRequestControlOfEntity(entity)
                    local test = 0
                    while test > 100 and not NetworkHasControlOfEntity(entity) do
                        NetworkRequestControlOfEntity(entity)
                        Wait(1)
                        test = test + 1
                    end
                    SetEntityAsNoLongerNeeded(entity)

                    local test = 0
                    while test < 100 and DoesEntityExist(entity) do 
                        SetEntityAsNoLongerNeeded(entity)
                        TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(entity))
                        DeleteEntity(entity)
                        DeleteObject(entity)
                        if not DoesEntityExist(entity) then 
                            table.remove(object, k)
                        end
                        SetEntityCoords(entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0)
                        Wait(1)
                        test = test + 1
                    end
                end)
            end




            function GoodName(hash)
                if hash == GetHashKey("prop_roadcone02a") then
                    return "Cone"
                elseif hash == GetHashKey("prop_barrier_work05") then
                    return "Barrière"
                else
                    return hash
                end

            end



            function SpawnObject(model, coords, cb)
                local model = GetHashKey(model)

                Citizen.CreateThread(function()
                    RequestModels(model)
                    Wait(1)
                    local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

                    if cb then
                        cb(obj)
                    end
                end)
            end


            function RequestModels(modelHash)
                if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
                    RequestModel(modelHash)

                    while not HasModelLoaded(modelHash) do
                        Citizen.Wait(1)
                    end
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

            function VehicleCustom(vehNetId)
                local vehicle = NetworkGetEntityFromNetworkId(vehNetId)
                if GetVehicleModKit(vehicle) ~= 0 then
                    SetVehicleModKit(vehicle, 0)
                end
                SetVehicleNumberPlateTextIndex(vehicle, 1)
                SetVehicleWindowTint(vehicle, 1)
                ToggleVehicleMod(vehicle, 18, true)
                ToggleVehicleMod(vehicle, 20, true)
                ToggleVehicleMod(vehicle, 22, true)
                local max11 = GetNumVehicleMods(vehicle, 11)
                SetVehicleMod(vehicle, 11, (max11 > 0 and max11 - 1 or 0), false)
                local max12 = GetNumVehicleMods(vehicle, 12)
                SetVehicleMod(vehicle, 12, (max12 > 0 and max12 - 1 or 0), false)
                local max13 = GetNumVehicleMods(vehicle, 13)
                SetVehicleMod(vehicle, 13, (max13 > 0 and max13 - 1 or 0), false)
                local max15 = GetNumVehicleMods(vehicle, 15)
                SetVehicleMod(vehicle, 15, (max15 > 0 and max15 - 1 or 0), false)
                local max16 = GetNumVehicleMods(vehicle, 16)
                SetVehicleMod(vehicle, 16, (max16 > 0 and max16 - 1 or 0), false)
                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                TriggerServerEvent('esx_lscustom:refreshOwnedVehicle', vehicleProps)
                ESX.ShowNotification("~r~Nous avons appliqué une personnalisation complète des performances de votre véhicule.")
            end


