ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
end)

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
	end)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(ped))) then
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId(ped))
            local lock = GetVehicleDoorLockStatus(veh)
            if lock == 7 then
                SetVehicleDoorsLocked(veh, 2)
            end
            local pedd = GetPedInVehicleSeat(veh, -1)
            if pedd then
                SetPedCanBeDraggedOut(pedd, false)
            end
        end
    end
 end)

local locked = false
RegisterNetEvent('KCarjack:startlockpicking')
AddEventHandler('KCarjack:startlockpicking', function()
    local ped = PlayerPedId()
    local pedc = GetEntityCoords(ped)
    local closeveh = GetClosestVehicle(pedc.x, pedc.y, pedc.z, 5.0, 0 ,71)
    local lockstatus = GetVehicleDoorLockStatus(closeveh)
    local distance = #(GetEntityCoords(closeveh) - pedc)
    if distance < 3 then
        if lockstatus == 2 then
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"),true)
            startAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer')
            lockpick()
        else
            ESX.ShowNotification(Config.VehiculePasfermer)
        end
    else
        ESX.ShowNotification(Config.AucunVehicule)
end
end)

function lockpick()
    ped = PlayerPedId()
    pedc = GetEntityCoords(ped)
    local veh = GetClosestVehicle(pedc.x, pedc.y, pedc.z, 3.0, 0, 71)
    local skillbar = exports["skillbar"]:CreateSkillbar(1, "medium")
    local playerCoords = GetEntityCoords(playerPed)
    if skillbar then
        Citizen.Wait(1000)
        ClearPedTasks(PlayerPedId())
        ESX.ShowNotification(Config.ReussiALockpick)
        SetVehicleDoorsLocked(veh, 0)
        SetVehicleDoorsLockedForAllPlayers(veh, false)
        TriggerServerEvent('logs_crochetage')        
        local raison = 'importante'
        local elements  = {}
        local playerPed = PlayerPedId()
        local coords  = GetEntityCoords(playerPed)
        local name = GetPlayerName(PlayerId())
        TriggerServerEvent('lockpick_kaitooo', coords, raison)
    else
        ClearPedTasks(PlayerPedId())
        ESX.ShowNotification(Config.RaterLeLockpick)
        TriggerServerEvent('fail_kaitolock')
        SetVehicleAlarm(veh, true)
        SetVehicleAlarmTimeLeft(veh, Config.TempsAlarme)
        SetVehicleDoorsLocked(veh, 2)
        Citizen.Wait(Config.TempsEnvoieAlerteLSPD)
        local raison = 'importante'
        local elements  = {}
        local playerPed = PlayerPedId()
        local coords  = GetEntityCoords(playerPed)
        local name = GetPlayerName(PlayerId())
        TriggerServerEvent('lockpick_kaitooo', coords, raison)
    end
end

RegisterNetEvent('lockpick_kaitooo:setBlip')

AddEventHandler('lockpick_kaitooo:setBlip', function(coords, raison)

if raison == 'importante' then

		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)

		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)

		ESX.ShowAdvancedNotification('INFORMATIONS', '~r~LSPD', 'Une tentative de vole a été aperçu dans cette zone', 'CHAR_CALL911', 8)

		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)

	end

	local blipId = AddBlipForCoord(coords)

	SetBlipSprite(blipId, Config.ImageBlipsAlerte)

	SetBlipScale(blipId, Config.TailleBlipAlerte)

	SetBlipColour(blipId, Config.CouleurAlerte)

	BeginTextCommandSetBlipName("STRING")

	AddTextComponentString(Config.TextBlipAlerte)

	EndTextCommandSetBlipName(blipId)

	Wait(Config.TempsAlerteLSPD)

	RemoveBlip(blipId)

end)
