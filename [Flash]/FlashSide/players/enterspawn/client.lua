local FirstSpawn = true
local IsInPersoMenu = true

local CONNECTION_CAMERA = 0;

local CAMERA_POSITION = {
    [1] = { coords = vector3(1278.2547607422, -2931.0268554688, 16.131813049316), rot = vector3(1.4105453491211, -6.6721293023875e-07, 70.965774536133) },
    [2] = { coords = vector3(662.11212158203, 1141.6303710938, 356.58215332031), rot = vector3(-15.990926742554, -1.776279987098e-06, -41.002635955811) },
    [3] = { coords = vector3(-1909.4598388672, 4594.5810546875, 22.447195053101), rot = vector3(-7.7229099273682, -8.6158871681619e-07, -135.48849487305) },
    [4] = { coords = vector3(3326.9645996094, 5138.302734375, 31.319602966309), rot = vector3(-19.769958496094, 2.2681206246489e-07, -9.0288410186768) },
    [5] = { coords = vector3(3375.3205566406, 5135.7651367188, 17.090915679932), rot = vector3(-5.8328413963318, 1.5018796375443e-06, -45.957286834717) },
    [6] = { coords = vector3(1324.0700683594, 4221.107421875, 44.377075195312), rot = vector3(-21.344434738159, 9.1664708179451e-07, 32.150550842285) },
    [7] = { coords = vector3(2770.8671875, 1411.0035400391, 76.942848205566), rot = vector3(-12.794981956482, 8.7551370597794e-07, 31.8342628479) },
    [8] = { coords = vector3(-1578.2526855469, 5219.431640625, 14.621535301208), rot = vector3(-17.046340942383, -0.0, 157.57688903809) },
    [9] = { coords = vector3(-582.57019042969, 4407.373046875, 44.216949462891), rot = vector3(-24.814863204956, 2.821868065439e-06, -37.403118133545) },
    [10] = { coords = vector3(-1560.7396240234, 2118.7177734375, 71.918342590332), rot = vector3(4.7130393981934, 1.1779214901253e-06, 113.68918609619) }
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerLoaded = true
end)

AddEventHandler('playerSpawned', function()
	Citizen.CreateThread(function()
		while not PlayerLoaded do
			Citizen.Wait(10)
		end
		if FirstSpawn then
            ClearTimecycleModifier()
            ClearExtraTimecycleModifier()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin ~= nil then
                    OpenPersoMenu(true)
                else
                    OpenPersoMenu(false)
				end
			end)
			FirstSpawn = false
		end
	end)
end)

function OpenPersoMenu(value)
    IsInPersoMenu = true
    local CAMERA = CAMERA_POSITION[math.random(1, #CAMERA_POSITION)];
    if (CAMERA) then
        if (CONNECTION_CAMERA == 0) then
            CONNECTION_CAMERA = CreateCameraPERSO("DEFAULT_SCRIPTED_CAMERA")
        end
        SetEntityVisible(PlayerPedId(), false)
        SetCamCoord(CONNECTION_CAMERA, CAMERA.coords)
        ShakeCam(CONNECTION_CAMERA, "HAND_SHAKE", 0.3)
        SetCamRot(CONNECTION_CAMERA, CAMERA.rot.x, CAMERA.rot.y, CAMERA.rot.z, 2)
        SetCamActive(CONNECTION_CAMERA, true)
        SetFocusPosAndVel(CAMERA.coords, 0, 0, 0)
        RenderScriptCams(1, 0, 500, false, false)
    end
    DoScreenFadeIn(2000)
    DisplayRadar(false)
    TriggerEvent('tempui:toggleUi', true)
    AnimpostfxStopAll()
    local menu = RageUI.CreateMenu("", "Bienvenue sur FlashSide")
    RageUI.Visible(menu, not RageUI.Visible(menu))
    menu.Closable = false
    while menu do
        Citizen.Wait(0)
        RageUI.IsVisible(menu, function()
            if value then 
                RageUI.Button('Entré en ville', nil, {}, true, {
                    onSelected = function()
                        RageUI.Visible(menu, false)
                        DoScreenFadeOut(5000)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(0)
                        end
                        getBaseSkin()
                        if (CONNECTION_CAMERA ~= 0) then
                            DestroyCam(CONNECTION_CAMERA);
                            ClearFocus()
                            RenderScriptCams(false, false, false, 0, 0)
                            CONNECTION_CAMERA = 0
                        end
                        SetEntityVisible(PlayerPedId(), true)
                        DoScreenFadeIn(2000)
                        while not IsScreenFadedIn() do
                            Citizen.Wait(0)
                        end
                        Citizen.Wait(2000)
                        TriggerEvent("pma-voice:mutePlayer")
                        DisplayRadar(true)
                        IsInPersoMenu = false
                        Citizen.Wait(1000)
                        TriggerEvent('tempui:toggleUi', false)
                    end
                })
            end
            if not value then
                RageUI.Button('Crée son Personnage', nil, {}, true, {
                    onSelected = function()
                        RageUI.Visible(menu, false)
                        DoScreenFadeOut(5000)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(0)
                        end
                        if (CONNECTION_CAMERA ~= 0) then
                            DestroyCam(CONNECTION_CAMERA);
                            ClearFocus()
                            RenderScriptCams(false, false, false, 0, 0)
                            CONNECTION_CAMERA = 0
                        end
                        SetEntityVisible(PlayerPedId(), true)
                        DoScreenFadeIn(2000)
                        while not IsScreenFadedIn() do
                            Citizen.Wait(0)
                        end
                        TriggerEvent("pma-voice:mutePlayer")
                        TriggerEvent('ronflex:creator')
                        IsInPersoMenu = false
                        Citizen.Wait(2000)
                    end
                })
            end
        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

function CreateCameraPERSO(name)
    local camera = CreateCam(name or "DEFAULT_SCRIPTED_CAMERA")
    while (camera == -1) do
        camera = CreateCam(name or "DEFAULT_SCRIPTED_CAMERA");
        Citizen.Wait(1.0)
    end
    return camera
end