Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5000)
	end
end)

--- Récolte de boulont ---

local mainMenu = RageUI.CreateMenu('', '~r~Vigne')

function OpenMenuRecolte()
	if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
			RageUI.IsVisible(mainMenu,function() 

			RageUI.Button("Commencer la Récolte", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					FreezeEntityPosition(PlayerPedId(), true)
					StartRecolte()
				end
			})

			RageUI.Button("Stopper la Récolte", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					FreezeEntityPosition(PlayerPedId(), false)
					StopRecolte()
				end
			})

			end)
		Wait(0)
		end
	end)
  	end
end

--- FUNCTION RECOLTE ---
function StopRecolte()
    if recoltepossible then
    	recoltepossible = false
    end
end

function StartRecolte()
    if not recoltepossible then
        recoltepossible = true
    while recoltepossible do
        Citizen.Wait(2000)
        TriggerServerEvent('recolteraisin')
    end
    else
        recoltepossible = false
    end
end

----OUVRIR LE MENU------------

VignePosFarmRecolt = {
	{x = -1803.69, y = 2214.42, z = 91.43} 
}

Citizen.CreateThread(function()
    while true do

      local wait = 750

        for k in pairs(VignePosFarmRecolt) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, VignePosFarmRecolt[k].x, VignePosFarmRecolt[k].y, VignePosFarmRecolt[k].z)

            if dist <= 4.0 then
            wait = 0
            DrawMarker(22, -1803.69, 2214.42, 91.43, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 136, 14, 79, 255, true, true, p19, true)  

        
            if dist <= 10.0 then
               wait = 0
                Visual.Subtitle("Appuyer sur ~r~[E]~s~ pour ~r~récolter", 1) 
                if IsControlJustPressed(1,51) then
					OpenMenuRecolte()
            end
        end
    end
    end
    Citizen.Wait(wait)
    end
end
end)

--- Traitement des boulont ---

local mainMenu = RageUI.CreateMenu('', '~r~Vigne')

function OpenMenuTraitement()
	if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
			RageUI.IsVisible(mainMenu,function() 

			RageUI.Button("Commencer le Traitement", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					FreezeEntityPosition(PlayerPedId(), true)
					StartTraitement()
				end
			})

			RageUI.Button("Stopper le Traitement", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					FreezeEntityPosition(PlayerPedId(), false)
					StopTraitement()
				end
			})

			end)
		Wait(0)
		end
	end)
  	end
end

--- FUNCTION RECOLTE ---

function StopTraitement()
    if traitementpossible then
    	traitementpossible = false
    end
end

function StartTraitement()
    if not traitementpossible then
        traitementpossible = true
    while traitementpossible do
            Citizen.Wait(2000)
            TriggerServerEvent('traitementjusraisin')
    end
    else
        traitementpossible = false
    end
end

----OUVRIR LE MENU------------

VigenPosFarmTraitement = {
	{x = -51.86, y = 1911.27, z = 195.36}  
}

Citizen.CreateThread(function()
    while true do

      local wait = 750

        for k in pairs(VigenPosFarmTraitement) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, VigenPosFarmTraitement[k].x, VigenPosFarmTraitement[k].y, VigenPosFarmTraitement[k].z)

            if dist <= 4.0 then
            wait = 0
            DrawMarker(22, -51.86, 1911.27, 195.36, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 136, 14, 79, 255, true, true, p19, true)  

        
            if dist <= 10.0 then
               wait = 0
                Visual.Subtitle("Appuyer sur ~r~[E]~s~ pour ~r~traiter", 1) 
                if IsControlJustPressed(1,51) then
					OpenMenuTraitement()
            end
        end
    end
    end
    Citizen.Wait(wait)
    end
end
end)
