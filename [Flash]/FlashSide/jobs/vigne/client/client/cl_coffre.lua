Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local mainMenu = RageUI.CreateMenu("", "Quel actions voulez vous faire")
local PutMenu = RageUI.CreateSubMenu(mainMenu,"", "Choisissez l'objet à déposer")
local GetMenu = RageUI.CreateSubMenu(mainMenu,"", "Choisissez l'objet à prendre")

local open = false

mainMenu:DisplayGlare(false)
mainMenu.Closed = function()
    open = false
end

all_items = {}



    
function Coffrevigne() 
    if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
        RageUI.IsVisible(mainMenu, function()
            RageUI.Button("Prendre un objet", " ", {RightLabel = "→"}, true, {onSelected = function()
                getStockVigne()
            end},GetMenu);

            RageUI.Button("Déposer un objet", " ", {RightLabel = "→"}, true, {onSelected = function()
                getInventoryVigne()
            end},PutMenu);
            

        end)

        RageUI.IsVisible(GetMenu, function()
            
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, " ", {RightLabel = "~r~x"..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput('', '','', 1000)
                    count = tonumber(count)
                    if count <= v.nb then
                        TriggerServerEvent("vigne:takeStockItems",v.item, count)
                    else
                        ESX.ShowNotification("~r~Vous n'en avez pas assez sur vous")
                    end
                    getStockVigne()
                end});
            end

        end)

        RageUI.IsVisible(PutMenu, function()
            
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, " ", {RightLabel = "~r~x"..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput('', '','', 1000)
                    count = tonumber(count)
                    TriggerServerEvent("vigne:putStockItems",v.item, count)
                    getInventoryVigne()
                end});
            end
            

       end)


        Wait(0)
    end
 end)
 end
 end



function getInventoryVigne()
    ESX.TriggerServerCallback('vigne:playerinventory', function(inventory)               
                
        all_items = inventory
        
    end)
end

function getStockVigne()
    ESX.TriggerServerCallback('vigne:getStockItems', function(inventory)               
                
        all_items = inventory
        
    end)
end

----OUVRIR LE MENU------------
local VigenPosCoffre = {
	{x = -1868.58, y = 2066.22, z = 140.98}
}

Citizen.CreateThread(function()
    while true do

      local wait = 750

        for k in pairs(VigenPosCoffre) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' then 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, VigenPosCoffre[k].x, VigenPosCoffre[k].y, VigenPosCoffre[k].z)

            if dist <= 5.0 then
            wait = 0
            DrawMarker(22, -1868.58, 2066.22, 140.98, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 136, 14, 79, 255, true, true, p19, true)  

        
            if dist <= 4.0 then
               wait = 0
                Visual.Subtitle("Appuyez sur [~r~E~w~] pour accéder au coffre", 1) 
                if IsControlJustPressed(1,51) then
					Coffrevigne()
            end
        end
    end
    end
    Citizen.Wait(wait)
    end
end
end)