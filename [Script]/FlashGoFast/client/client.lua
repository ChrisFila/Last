ESX = nil 

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

local isMenuOpen = false 

local gofast_menu = RageUI.CreateMenu(nil, "GoFast")
gofast_menu.Closed = function()
    isMenuOpen = false
end

local GoFastEnCours = false

local function GoFast()
    if not isMenuOpen then
        isMenuOpen = true 
        RageUI.Visible(gofast_menu, true)
        CreateThread(function()
            local cooldown = false
            while isMenuOpen do
            RageUI.IsVisible(gofast_menu, function()
                RageUI.Separator("~r~↓~s~     GoFast     ~r~↓")
                RageUI.Separator("__________________")
                RageUI.Button("Commencer un ~r~GoFast", nil, {}, not GoFastEnCours, {
                    onSelected = function ()
                        Random = math.random(1, #Config.Vehicle)
                        local model = Config.Vehicle[Random].model
                        SpawnVehicle(model)
                    
                        GoFastEnCours = true

                        ESX.ShowAdvancedNotification("GoFast", "", "Livre moi cette ~y~"..Config.Vehicle[Random].label.."~s~ au point ~y~GPS", "CHAR_MP_MEX_BOSS", 8)
                        RandomPos = math.random(1, #Config.GoFastPosVente)

                        GoFastBlips = AddBlipForCoord(Config.GoFastPosVente[RandomPos].x, Config.GoFastPosVente[RandomPos].y, Config.GoFastPosVente[RandomPos].z)
                        SetBlipSprite(GoFastBlips, 501)
                        SetBlipScale(GoFastBlips, 0.9)
                        SetBlipColour(GoFastBlips, 5)
                        SetBlipAlpha(GoFastBlips, 200)
                        PulseBlip(GoFastBlips)
                        SetBlipRoute(GoFastBlips, true)

                        TriggerServerEvent("kprigfd:CallPolice")

                        RageUI.CloseAll()
                        isMenuOpen = false
                    end
                })
            end)   
            Wait(0)
            end
        end)
    end
end

CreateThread(function()
    while true do 
        local interval = 250 
        local playerPos = GetEntityCoords(PlayerPedId())


        for k,v in pairs(Config.GoFastPos) do 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local pos = Config.GoFastPos
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

            if dist <= 3 then
                interval = 0
                Visual.Subtitle("Appuyer sur [~r~E~s~] pour commencer un ~r~Gofast", 1)
                DrawMarker(22, pos[k].x + 1, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.5, 0.5, 0.5, 255, 0, 0, 255, false, true, p19, true)
            end

            if dist <= 2.0 then 
                interval = 0 
                if IsControlJustPressed(1, 51) then 
                    GoFast()
                end
            end
        end

        for k,v in pairs(Config.GoFastPosVente) do 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local pos = Config.GoFastPosVente
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

            if dist <= 20 and GoFastEnCours then
                interval = 0
                DrawMarker(23, pos[k].x + 1, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 4.0, 4.0, 4.0, 255, 0, 0, 255, false, true, p19, true)
            end

            if dist <= 2.0 and GoFastEnCours then 
                interval = 0 
                RemoveBlip(GoFastBlips)
                TriggerEvent("ui:showInteraction", "E", "GO FAST")
                if IsControlJustPressed(1, 51) then 
                    GoFastFini()
                    GoFastEnCours = false
                end
            end
        end
        Wait(interval)
    end

    local modelHash = GetHashKey("ig_beverly")
    while not HasModelLoaded(modelHash) do 
        RequestModel(modelHash)
        Wait(0)
    end
    local ped = CreatePed("PED_TYPE_CIVMALE", modelHash, 1712.22, -1555.49, 113.94, 250.30, true, false)
    SetBlockingOfNonTemporaryEvents(ped, true) 
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
end)

function SpawnVehicle(model)
    local hash = GetHashKey(model)
    print(hash)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(10) end 

    local veh = CreateVehicle(hash,  1718.94, -1561.58, 112.15, 290.01, true, false)
    SetVehicleNumberPlateText(veh, "GOFAST")
end

function GoFastFini()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local plate = GetVehicleNumberPlateText(veh)

    if plate == " GOFAST " then 
        TriggerServerEvent("kprigfd:GoFastFini")
        local veh, dist = ESX.Game.GetClosestVehicle(PlayerCoords)
        if dist < 4 then 
            DeleteEntity(veh)
        end  
        GoFastEnCours = false
        local playerPos = GetEntityCoords(PlayerPedId())

        local hash = GetHashKey(Config.VehicleFin)
        RequestModel(hash)
        while not HasModelLoaded(hash) do Wait(10) end 

        local veh = CreateVehicle(hash,  playerPos.x, playerPos.y, playerPos.z, 90.00, true, false)
    else 
        ESX.ShowAdvancedNotification("GoFast", "~b~Livraison GoFast", "Hein ? C'est quoi ça ? C'est pas la voiture du GoFast !", "CHAR_MP_MEX_BOSS", 8)
        GoFastEnCours = false
    end
end

CreateThread(function()
    local Hash = GetHashKey("a_m_m_stlat_02")
    while not HasModelLoaded(Hash) do
		RequestModel(Hash)
		Wait(20)
	end

    local ped = CreatePed("PED_TYPE_CIVFEMALE", Hash, 1712.15, -1555.56, 112.94, 249.84, true, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
end)