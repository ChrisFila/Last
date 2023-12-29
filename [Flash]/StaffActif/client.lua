RegisterNetEvent("ui:update")
AddEventHandler("ui:update", function(playerCount)
    SendNUIMessage({
        type = "topRight",

        serverId = GetPlayerServerId(PlayerId()),
        onlineCount = playerCount
    })
end)

-- Dès que le joueur active ou désactive sa radio ce trigger est appelé
-- ↓↓↓
RegisterNetEvent("ui:radioStatus")
AddEventHandler("ui:radioStatus", function(enabled)
    if enabled then
        SendNUIMessage({
            type = "radioButtonEnabled"
        })
    else
        SendNUIMessage({
            type = "radioButtonDisabled"
        })
    end
end)

RegisterNetEvent("ui:radioEnabled")
AddEventHandler("ui:radioEnabled", function()
    SendNUIMessage({
        type = "radioEnabled"
    })
end)

RegisterNetEvent("ui:radioDisabled")
AddEventHandler("ui:radioDisabled", function()
    SendNUIMessage({
        type = "radioDisabled"
    })
end)

RegisterNetEvent("ui:safeZoneEntered")
AddEventHandler("ui:safeZoneEntered", function()
    SendNUIMessage({
        type = "safeZoneEntered"
    })
end)

RegisterNetEvent("ui:safeZoneExit")
AddEventHandler("ui:safeZoneExit", function()
    SendNUIMessage({
        type = "safeZoneExit"
    })
end)

-- Variables
local directions = {
    N = 360,
    0,
    NE = 315,
    E = 270,
    SE = 225,
    S = 180,
    SO = 135,
    O = 90,
    NO = 45
    --  N = 0, <= will result in the HUD breaking above 315deg
}

local veh = 0;
local hash1, hash2, heading;

Citizen.CreateThread(function()

    Citizen.Wait(3500);

    SendNUIMessage({
        type = 'streetLabel:DATA',
        color = '#741e1e',
        offsetX = 18,
        offsetY = 2.5,
        scale = 1.0,
        dynamic = false
    })

    while true do
        local ped = PlayerPedId();
        local veh = GetVehiclePedIsIn(ped, false);

        local coords = GetEntityCoords(PlayerPedId());
        local zone = GetNameOfZone(coords.x, coords.y, coords.z);
        local zoneLabel = GetLabelText(zone);

        if (config.vehicleCheck == false or veh ~= 0) then
            local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(),
                Citizen.ResultAsInteger())
            hash1 = GetStreetNameFromHashKey(var1);
            hash2 = GetStreetNameFromHashKey(var2);
            heading = GetEntityHeading(PlayerPedId());

            for k, v in pairs(directions) do
                if (math.abs(heading - v) < 22.5) then
                    heading = k;

                    if (heading == 1) then
                        heading = 'N';
                        break
                    end

                    break
                end
            end

            local street2;
            if (hash2 == '') then
                street2 = zoneLabel;
            else
                street2 = hash2 .. ', ' .. zoneLabel;
            end

            SendNUIMessage({
                type = 'streetLabel:MSG',
                active = true,
                direction = heading,
                street = hash1,
                zone = street2
            });
        else
            SendNUIMessage({
                type = 'streetLabel:MSG',
                active = false
            });
        end

        SendNUIMessage({
            type = 'streetLabel:DATA',
            color = '#3659CD',
            offsetX = 18,
            offsetY = 2.5,
            scale = 1.0,
            dynamic = false
        })

        Citizen.Wait(1500)

    end
end)

Citizen.CreateThread(function()
    while true do
        local interval = 0

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            interval = 0

            HideHudComponentThisFrame(6)
            HideHudComponentThisFrame(7)
            HideHudComponentThisFrame(8)
            HideHudComponentThisFrame(9)
        end

        Citizen.Wait(interval)
    end
end)

-- ↓↓↓
-- ↓↓↓
-- ↓↓↓
-- ↓↓↓
-- ↓↓↓


-- ###
-- ###
-- ###
-- ###

RegisterNetEvent("ui:deathscreenHide")
AddEventHandler("ui:deathscreenHide", function()
    SendNUIMessage({
        type = "hideComa"
    })

    SendNUIMessage({
        type = "editFirstComa",
        text = "10:00"
    })
    SendNUIMessage({
        type = "editTwoComa",
        text = "EN ATTENTE D'AIDE"
    })
    SendNUIMessage({
        type = "editTreeComa",
        text = "AVANT DE MOURIR"
    })

    SetNuiFocus(false, false)
end)

RegisterNetEvent("ui:deathscreen")
AddEventHandler("ui:deathscreen", function()
    SendNUIMessage({
        type = "displayComa"
    })

    SetNuiFocus(true, true)
end)

RegisterNetEvent("ui:deathscreenTime")
AddEventHandler("ui:deathscreenTime", function(time)
    SendNUIMessage({
        type = "comaTime",
        time = time
    })
end)

RegisterNUICallback('ui:clickedAmbulance', function(data, cb)
    -- SetNuiFocus(false, false)

    TriggerEvent("deathHandler:callAmbulance")

    local count = 0
    Citizen.CreateThread(function()
        while count < 100 do

            count = count + 0.1
            SendNUIMessage({
                type = "cooldownCall",
                count = count
            })

            Citizen.Wait(50)
        end
        SendNUIMessage({
            type = "cooldownCall",
            count = 0
        })
        SendNUIMessage({
            type = "enableCallButton"
        })
    end)
end)

RegisterNetEvent("ui:deathscreenHospital")
AddEventHandler("ui:deathscreenHospital", function()
    SendNUIMessage({
        type = "showHospital"
    })

    SendNUIMessage({
        type = "editFirstComa",
        text = "TEMPS ÉCOULÉ"
    })
    SendNUIMessage({
        type = "editTwoComa",
        text = "VOUS POUVEZ RETOURNER"
    })
    SendNUIMessage({
        type = "editTreeComa",
        text = "À L'HÔPITAL"
    })
end)

RegisterNetEvent("ui:deathscreen:firstComa")
AddEventHandler("ui:deathscreen:firstComa", function(text)
    SendNUIMessage({
        type = "editFirstComa",
        text = text
    })
end)

RegisterNetEvent("ui:deathscreen:twoComa")
AddEventHandler("ui:deathscreen:twoComa", function(text)
    SendNUIMessage({
        type = "editTwoComa",
        text = text
    })
end)

RegisterNetEvent("ui:deathscreen:treeComa")
AddEventHandler("ui:deathscreen:treeComa", function(text)
    SendNUIMessage({
        type = "editTreeComa",
        text = text
    })
end)

RegisterNUICallback('ui:clickedHospital', function(data, cb)
    SetNuiFocus(false, false)

    TriggerEvent("deathHandler:RemoveItemsAfterRPDeath")

    TriggerEvent("ui:deathscreenHide")
end)

-- RegisterCommand('-test', function()
-- 	SetNuiFocus(false, false)
-- end)
-- RegisterKeyMapping('+test', 'Mode curseur', 'keyboard', '')

RegisterNetEvent("ui:food&thirst")
AddEventHandler("ui:food&thirst", function(hungerNumber, thirstNumber)
    SendNUIMessage({
        type = "hunger",
        count = hungerNumber
    })

    SendNUIMessage({
        type = "thirst",
        count = thirstNumber
    })
end)

------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------

local showMenu = false
local toggleCoffre = 0
local toggleCapot = 0
local toggleLocked = 0
local playing_emote = false

------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------

-- Show crosshair (circle) when player targets entities (vehicle, pedestrian…)
function Crosshair(enable)
    SendNUIMessage({
        crosshair = enable
    })
end

local calledTime = 0
-- Toggle focus (Example of Vehcile's menu)

RegisterNUICallback('disablenuifocus', function(data)
    showMenu = data.nuifocus
    SetNuiFocus(data.nuifocus, data.nuifocus)

    if GetGameTimer() > calledTime then
        TriggerEvent("ui:disableLogin")
        calledTime = GetGameTimer() + 5 * 1000
    end
end)

function GetEntInFrontOfPlayer(Distance, Ped)
    local Ent = nil
    local CoA = GetEntityCoords(Ped, 1)
    local CoB = GetOffsetFromEntityInWorldCoords(Ped, 0.0, Distance, 0.0)
    local RayHandle = StartShapeTestRay(CoA.x, CoA.y, CoA.z, CoB.x, CoB.y, CoB.z, -1, Ped, 0)
    local A, B, C, D, Ent = GetRaycastResult(RayHandle)
    return Ent
end

function GetCoordsFromCam(distance)
    local rot = GetGameplayCamRot(2)
    local coord = GetGameplayCamCoord()

    local tZ = rot.z * 0.0174532924
    local tX = rot.x * 0.0174532924
    local num = math.abs(math.cos(tX))

    newCoordX = coord.x + (-math.sin(tZ)) * (num + distance)
    newCoordY = coord.y + (math.cos(tZ)) * (num + distance)
    newCoordZ = coord.z + (math.sin(tX) * 8.0)
    return newCoordX, newCoordY, newCoordZ
end

function Target(Distance, Ped)
    local Entity = nil
    local camCoords = GetGameplayCamCoord()
    local farCoordsX, farCoordsY, farCoordsZ = GetCoordsFromCam(Distance)
    local RayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, farCoordsX, farCoordsY, farCoordsZ, 2,
        Ped, 4)
    local A, B, C, D, Entity = GetRaycastResult(RayHandle)
    return Entity, farCoordsX, farCoordsY, farCoordsZ
end



-- Citizen.CreateThread(function()
--     while true do
--         local Ped = PlayerPedId()

--         local Entity, farCoordsX, farCoordsY, farCoordsZ = Target(6.0, Ped)
--         local EntityType = GetEntityType(Entity)

--         if (EntityType == 2) then
--             if showMenu == false then
--                 SetNuiFocus(false, false)
--             end
--             Crosshair(true)

--             if not showMenu then
--                 SendNUIMessage({
--                     type = "showInteraction",
--                     key = "E",
--                     message = nil
--                 })
--             end

--             if IsControlJustReleased(1, 38) then -- E is pressed
--                 TriggerEvent("zCore:openContextUI", "vehicle", Entity)

--                 -- showMenu = true
--                 -- SetNuiFocus(true, true)

--                 -- SendNUIMessage({
--                 --     menu = 'vehicle',
--                 --     idEntity = Entity,
--                 --     buttons = exports.zCore:GetVehicleButtons(Entity)
--                 -- })
--             end
--         elseif (EntityType == 1) then
--             if showMenu == false then
--                 SetNuiFocus(false, false)
--             end
--             Crosshair(true)

--             if not showMenu then
--                 SendNUIMessage({
--                     type = "showInteraction",
--                     key = "E",
--                     message = nil
--                 })
--             end

--             if IsControlJustReleased(1, 38) then -- E is pressed
--                 showMenu = true
--                 SetNuiFocus(true, true)
--                 SendNUIMessage({
--                     menu = 'user',
--                     idEntity = Entity,
--                     buttons = json.encode({
--                         {name = "test", imgName = "ambulance.png", value = "test", event = "clicked:event"}
--                     })
--                 })
--             end
--         else
--             Citizen.Wait(500)

--             if showMenu then
--                 SendNUIMessage({
--                     menu = false
--                 })
--                 SetNuiFocus(false, false)
--                 Crosshair(false)
--             end
--         end

--         Citizen.Wait(1)
--     end
-- end)

RegisterNetEvent("ui:login")
AddEventHandler("ui:login", function(patchnote)
    --SetNuiFocus(true, true)

    SendNUIMessage({
        type = "login",
        patchnote = {
            {
                title = "Nouveaux produits dans la boutique (https://shop.alyniarp.fr)",
                description = "Pack de danses spéciales Drill, Jeton fullcustom à utiliser sur vos véhicules, Abonnement place illimitées",
            },
            {
                title = "Nouveau pack de vêtements pour les hommes et femmes",
                description = "Plusieurs nouvelles coupes de cheveux sont ajoutées, Plusieurs nouveaux masques pour les hommes ont été ajoutés, ⚠ Toutes vos tenues sont certainement plus à jour",
            },
            {
                title = "Nouvel HUD global",
                description = "Nouveau compteur de voiture",
            },
            {
                title = "Ajout d'un nouveau thème pour les notifications",
                description = "Nouveau module de chat",
            },
        }
    })
end)

RegisterCommand("login", function()
    TriggerEvent("ui:login")
end)

RegisterNetEvent("ui:reward")
AddEventHandler("ui:reward", function(patchnote)
    SetNuiFocus(true, true)

    SendNUIMessage({
        type = "reward",
        rewardlist = {
            {
                title = "Jour 1",
                amount = 5000,
                amountVip = 50000,
                retired = true
            },
            {
                title = "Jour 13",
                amount = 5000,
                amountVip = 50000,
                retired = false
            },
            {
                title = "Jour 90",
                amount = 5000,
                amountVip = 50000,
                retired = true
            },
            {
                title = "Jour 103",
                amount = 5000,
                amountVip = 50000,
                retired = true
            },
        }
    })
end)

RegisterNetEvent("ui:staffinfo")
AddEventHandler("ui:staffinfo", function(info)
    -- SetNuiFocus(info.toggle, info.toggle)

    SendNUIMessage({
        type = "staffinfo",
        toggle = info.toggle,
        players = info.players,
        staffs = info.staffs,
        staffsService = info.staffsService,
        reports = info.reports,
        reportsWait = info.reportsWait
    })
end)

RegisterNetEvent("ui:showKey")
AddEventHandler("ui:showKey", function(message, key)
                SendNUIMessage({
                    type = "showInteraction",
                    key = key,
                    message = message
                })
end)

RegisterCommand("staffOff", function()
    TriggerEvent("ui:staffinfo", {
        toggle = false
    })
end)

RegisterNetEvent("ui:hideAll")
AddEventHandler("ui:hideAll", function()
    SendNUIMessage({
        type = "hideAll"
    })
end)

RegisterNetEvent("ui:showAll")
AddEventHandler("ui:showAll", function()
    SendNUIMessage({
        type = "showAll"
    })
end)

local inCreator = false
Citizen.CreateThread(function()
	while true do

        if not inCreator then
            if IsPauseMenuActive() then
                SendNUIMessage({
                    type = "hideAll"
                })
            else
                SendNUIMessage({
                    type = "showAll"
                })
            end
        end

		Citizen.Wait(500)
	end
end)

RegisterNetEvent("ui:toggleinCreator")
AddEventHandler("ui:toggleinCreator", function()
    inCreator = not inCreator
end)

RegisterNetEvent("hud:toggle")
AddEventHandler("hud:toggle", function(type)
    if type == "hunger" then
        SendNUIMessage({
            type = "toggleHunger",
        })
    end

    if type == "mic" then
        SendNUIMessage({
            type = "toggleMic",
        })
    end

    if type == "coords" then
        SendNUIMessage({
            type = "toggleCoords",
        })
    end

    if type == "discord" then
        SendNUIMessage({
            type = "toggleDiscord",
        })
    end
end)

-- RegisterCommand("showPurge", function()
--  SendNUIMessage({
--         type = "reward",
--         rewardlist = {
--             {
--                 title = "Jour 1",
--                 amount = 5000,
--                 amountVip = 50000,
--                 retired = true
--             },
--             {
--                 title = "Jour 13",
--                 amount = 5000,
--                 amountVip = 50000,
--                 retired = false
--             },
--             {
--                 title = "Jour 90",
--                 amount = 5000,
--                 amountVip = 50000,
--                 retired = true
--             },
--             {
--                 title = "Jour 103",
--                 amount = 5000,
--                 amountVip = 50000,
--                 retired = true
--             },
--         }
--     })
-- end)

Round = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

Citizen.CreateThread(function()
    while true do

        SendNUIMessage({
            type = "updatePurgeDistance",
            dist = Round(#(GetEntityCoords(PlayerPedId()) - vector3(0, 0, 0))),
            rect1 = Round(#(GetEntityCoords(PlayerPedId()) - vector3(0, 0, 0))) < 2500,
            rect2 = Round(#(GetEntityCoords(PlayerPedId()) - vector3(0, 0, 0))) < 1500,
            rect3 = Round(#(GetEntityCoords(PlayerPedId()) - vector3(0, 0, 0))) < 500,
        })

        Citizen.Wait(1000)
    end
end)




















































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































