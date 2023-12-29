TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local PlayerInventory, GangInventoryItem, GangInventoryWeapon, PlayerWeapon = {}, {}, {}, {}

local mainMenu = RageUI.CreateMenu("", "Quel actions voulez vous faire")
local PutMenu = RageUI.CreateSubMenu(mainMenu,"", "Choisissez l'objet à déposer")
local GetMenu = RageUI.CreateSubMenu(mainMenu,"", "Choisissez l'objet à prendre")


local open = false

mainMenu:DisplayGlare(false)
mainMenu.Closed = function()
    open = false
end

all_items = {}

    
function Chestsheriff() 
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
                getStocksheriff()
            end},GetMenu);

            RageUI.Button("Déposer un objet", " ", {RightLabel = "→"}, true, {onSelected = function()
                getInventorysheriff()
            end},PutMenu);

            

        end)

        RageUI.IsVisible(GetMenu, function()
            
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, " ", {RightLabel = "~r~x"..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput('', '','', 100)
                    count = tonumber(count)
                    if count <= v.nb then
                        TriggerServerEvent("sheriff:takeStockItems",v.item, count)
                    else
                        ESX.ShowNotification("~r~Vous n'en avez pas assez sur vous")
                    end
                    getStocksheriff()
                end});
            end

        end)

        RageUI.IsVisible(PutMenu, function()
            
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, " ", {RightLabel = "~r~x"..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput('', '','', 100)
                    count = tonumber(count)
                    TriggerServerEvent("sheriff:putStockItems",v.item, count)
                    getInventorysheriff()
                end});
            end
        end)



        Wait(0)
    end
 end)
 end
 end



function getInventorysheriff()
    ESX.TriggerServerCallback('sheriff:playerinventory', function(inventory)               
                
        all_items = inventory
        
    end)
end

function getStocksheriff()
    ESX.TriggerServerCallback('sheriff:getStockItems', function(inventory)               
                
        all_items = inventory

    end)
end


Citizen.CreateThread(function()
    while true do
		local wait = 750
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'sheriff' then
				for k in pairs(cfg_sheriff.Position.Coffre) do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				local pos = cfg_sheriff.Position.Coffre
				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

				if dist <= cfg_sheriff.MarkerDistance then
					wait = 0
					DrawMarker(cfg_sheriff.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, cfg_sheriff.MarkerSizeLargeur, cfg_sheriff.MarkerSizeEpaisseur, cfg_sheriff.MarkerSizeHauteur, cfg_sheriff.MarkerColorR, cfg_sheriff.MarkerColorG, cfg_sheriff.MarkerColorB, cfg_sheriff.MarkerOpacite, cfg_sheriff.MarkerSaute, true, p19, cfg_sheriff.MarkerTourne)  
				end

				if dist <= 2.0 then
					wait = 0
					Visual.Subtitle(cfg_sheriff.TextCoffre, 1)
					if IsControlJustPressed(1,51) then
						Chestsheriff()
					end
				end
			end
		end
    Citizen.Wait(wait)
    end
end)